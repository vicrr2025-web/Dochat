import 'package:flutter/foundation.dart';
import 'package:dochat_app/models/settings_models.dart';
import 'package:dochat_app/services/settings_service.dart';

class SettingsProvider extends ChangeNotifier {
  final SettingsService _service = SettingsService();

  ProfileInfo? _profile;
  List<DeviceInfo> _devices = [];
  StorageInfo? _storage;
  PrivacySettings? _privacy;
  bool _isLoading = false;
  String? _errorMessage;

  ProfileInfo? get profile => _profile;
  List<DeviceInfo> get devices => _devices;
  StorageInfo? get storage => _storage;
  PrivacySettings? get privacy => _privacy;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadProfile() async {
    _isLoading = true;
    notifyListeners();
    try {
      _profile = await _service.getProfile();
      _errorMessage = null;
    } catch (_) {
      _errorMessage = 'networkError';
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> updateProfile({String? nickname, String? avatar}) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _service.updateProfile(nickname: nickname, avatar: avatar);
      _errorMessage = null;
      if (nickname != null && _profile != null) {
        _profile = ProfileInfo(
          userId: _profile!.userId,
          nickname: nickname,
          avatar: avatar ?? _profile!.avatar,
          email: _profile!.email,
          creditLevel: _profile!.creditLevel,
          isVerified: _profile!.isVerified,
          creditScore: _profile!.creditScore,
        );
        notifyListeners();
      }
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (_) {
      _errorMessage = 'networkError';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> changePassword(String current, String newPwd) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _service.changePassword(current, newPwd);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (_) {
      _errorMessage = 'wrongPassword';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> submitVerify(String realName, String idNumber, String faceId) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _service.submitVerify(realName, idNumber, faceId);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (_) {
      _errorMessage = 'networkError';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> loadDevices() async {
    _isLoading = true;
    notifyListeners();
    try {
      _devices = await _service.getDevices();
      _errorMessage = null;
    } catch (_) {
      _errorMessage = 'networkError';
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> removeDevice(String deviceId) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _service.removeDevice(deviceId);
      _devices.removeWhere((d) => d.deviceId == deviceId);
      notifyListeners();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (_) {
      _errorMessage = 'networkError';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> removeOtherDevices() async {
    _isLoading = true;
    notifyListeners();
    try {
      await _service.removeOtherDevices();
      _devices.removeWhere((d) => !d.isCurrent);
      notifyListeners();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (_) {
      _errorMessage = 'networkError';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> loadStorage() async {
    _isLoading = true;
    notifyListeners();
    try {
      _storage = await _service.getStorage();
      _errorMessage = null;
    } catch (_) {
      _errorMessage = 'networkError';
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadPrivacy() async {
    _isLoading = true;
    notifyListeners();
    try {
      _privacy = await _service.getPrivacy();
      _errorMessage = null;
    } catch (_) {
      _errorMessage = 'networkError';
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> updatePrivacy(PrivacySettings settings) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _service.updatePrivacy(settings);
      _privacy = settings;
      notifyListeners();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (_) {
      _errorMessage = 'networkError';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
