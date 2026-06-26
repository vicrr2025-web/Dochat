import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dochat_app/models/auth_models.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  late final Dio dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const String baseUrl = 'http://127.0.0.1:8080/api';

  // 防止并发刷新
  bool _isRefreshing = false;
  

  ApiService._internal() {
    dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: 'token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401 &&
            error.requestOptions.path != '/auth/refresh') {
          if (!_isRefreshing) {
            _isRefreshing = true;
            try {
              final refreshToken = await _storage.read(key: 'refreshToken');
              if (refreshToken != null) {
                final refreshDio = Dio(BaseOptions(
                  baseUrl: baseUrl,
                  connectTimeout: const Duration(seconds: 10),
                ));
                final refreshResponse = await refreshDio.post(
                  '/auth/refresh',
                  options: Options(
                    headers: {'Authorization': 'Bearer $refreshToken'},
                  ),
                );

                if (refreshResponse.statusCode == 200) {
                  final authResp =
                      AuthResponse.fromJson(refreshResponse.data['data']);
                  await _storage.write(key: 'token', value: authResp.token);
                  await _storage.write(
                      key: 'refreshToken', value: authResp.refreshToken);
                  await _storage.write(key: 'userId', value: authResp.userId);

                  // 重试原始请求
                  final retryOptions = error.requestOptions;
                  retryOptions.headers['Authorization'] =
                      'Bearer ${authResp.token}';
                  final retryResponse = await dio.fetch(retryOptions);

                  _isRefreshing = false;
                  return handler.resolve(retryResponse);
                }
              }
            } catch (_) {
              await _storage.deleteAll();
            }
            _isRefreshing = false;
          } else {
            // 等待刷新完成后重试
            await Future.delayed(const Duration(milliseconds: 100));
            final newToken = await _storage.read(key: 'token');
            if (newToken != null) {
              final retryOptions = error.requestOptions;
              retryOptions.headers['Authorization'] = 'Bearer $newToken';
              final retryResponse = await dio.fetch(retryOptions);
              return handler.resolve(retryResponse);
            }
          }
        }
        return handler.next(error);
      },
    ));
  }

  Dio get client => dio;
  FlutterSecureStorage get storage => _storage;
}
