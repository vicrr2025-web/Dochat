import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:dochat_app/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoggedIn = false;
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> checkAuth() async {
    _isLoggedIn = await _authService.isLoggedIn();
    notifyListeners();
    return _isLoggedIn;
  }

  Future<void> login(String phone, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.login(phone, password);
      _isLoggedIn = true;
    } on DioException catch (e) {
      _errorMessage = _extractError(e);
    } catch (e) {
      _errorMessage = 'networkError';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loginBySms(String phone, String smsCode) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.loginBySms(phone, smsCode);
      _isLoggedIn = true;
    } on DioException catch (e) {
      _errorMessage = _extractError(e);
    } catch (e) {
      _errorMessage = 'networkError';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> register(String phone, String smsCode, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.register(phone, smsCode, password);
      _isLoggedIn = true;
    } on DioException catch (e) {
      _errorMessage = _extractError(e);
    } catch (e) {
      _errorMessage = 'networkError';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    await _authService.logout();
    _isLoggedIn = false;
    _isLoading = false;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  String _extractError(DioException e) {
    if (e.response?.data is Map) {
      final message = (e.response?.data as Map)['message'] as String?;
      if (message != null && message.isNotEmpty) return message;
    }
    return 'networkError';
  }
}
