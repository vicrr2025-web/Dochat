import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dochat_app/models/auth_models.dart';
import 'package:dochat_app/services/api_service.dart';

class AuthService {
  final ApiService _api = ApiService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const _tokenKey = 'token';
  static const _refreshTokenKey = 'refreshToken';
  static const _userIdKey = 'userId';

  Future<ApiResponse> sendSms(String phone, String type) async {
    try {
      final response = await _api.client.post('/api/auth/sms/send', data: {
        'phone': phone,
        'type': type,
      });
      return ApiResponse.fromJson(response.data);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<AuthResponse> register(String phone, String smsCode, String password) async {
    final response = await _api.client.post('/api/auth/register', data: {
      'phone': phone,
      'smsCode': smsCode,
      'password': password,
    });
    final authResp = AuthResponse.fromJson(response.data['data']);
    await saveTokens(authResp);
    return authResp;
  }

  Future<AuthResponse> login(String phone, String password) async {
    final response = await _api.client.post('/api/auth/login', data: {
      'phone': phone,
      'password': password,
    });
    final authResp = AuthResponse.fromJson(response.data['data']);
    await saveTokens(authResp);
    return authResp;
  }

  Future<AuthResponse> loginBySms(String phone, String smsCode) async {
    final response = await _api.client.post('/api/auth/login/sms', data: {
      'phone': phone,
      'smsCode': smsCode,
    });
    final authResp = AuthResponse.fromJson(response.data['data']);
    await saveTokens(authResp);
    return authResp;
  }

  Future<AuthResponse> refreshToken(String refreshToken) async {
    final response = await _api.client.post('/api/auth/refresh',
        options: Options(headers: {'Authorization': 'Bearer $refreshToken'}));
    return AuthResponse.fromJson(response.data['data']);
  }

  Future<void> logout() async {
    try {
      await _api.client.post('/api/auth/logout');
    } catch (_) {}
    await clearTokens();
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    await _api.client.put('/api/auth/password', data: {
      'oldPassword': oldPassword,
      'newPassword': newPassword,
    });
  }

  Future<void> resetPassword(String phone, String smsCode, String newPassword) async {
    await _api.client.post('/api/auth/password/reset', data: {
      'phone': phone,
      'smsCode': smsCode,
      'newPassword': newPassword,
    });
  }

  Future<void> saveTokens(AuthResponse response) async {
    await _storage.write(key: _tokenKey, value: response.token);
    await _storage.write(key: _refreshTokenKey, value: response.refreshToken);
    await _storage.write(key: _userIdKey, value: response.userId);
  }

  Future<void> clearTokens() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _userIdKey);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  Future<String?> getUserId() async {
    return await _storage.read(key: _userIdKey);
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  ApiResponse _handleError(dynamic error) {
    if (error is DioException) {
      if (error.response != null) {
        return ApiResponse.fromJson(error.response!.data);
      }
      return ApiResponse(code: -1, message: 'networkError');
    }
    return ApiResponse(code: -1, message: 'unknownError');
  }
}
