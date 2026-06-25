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
    } catch (_) {
      _errorMessage = 'networkError';
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> updateProfile({String? nickname, String? avatar}) async {
    try {
      await _service.updateProfile(nickname: nickname, avatar: avatar);
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
      return true;
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
      return false;
    }
  }

  Future<bool> changePassword(String current, String newPwd) async {
    try {
      await _service.changePassword(current, newPwd);
      return true;
    } catch (_) {
      _errorMessage = 'wrongPassword';
      notifyListeners();
      return false;
    }
  }

  Future<bool> submitVerify(String realName, String idNumber, String faceId) async {
    try {
      await _service.submitVerify(realName, idNumber, faceId);
      return true;
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
      return false;
    }
  }

  Future<void> loadDevices() async {
    _isLoading = true;
    notifyListeners();
    try {
      _devices = await _service.getDevices();
    } catch (_) {
      _errorMessage = 'networkError';
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> removeDevice(String deviceId) async {
    try {
      await _service.removeDevice(deviceId);
      _devices.removeWhere((d) => d.deviceId == deviceId);
      notifyListeners();
      return true;
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
      return false;
    }
  }

  Future<bool> removeOtherDevices() async {
    try {
      await _service.removeOtherDevices();
      _devices.removeWhere((d) => !d.isCurrent);
      notifyListeners();
      return true;
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
      return false;
    }
  }

  Future<void> loadStorage() async {
    _isLoading = true;
    notifyListeners();
    try {
      _storage = await _service.getStorage();
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
    } catch (_) {
      _errorMessage = 'networkError';
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> updatePrivacy(PrivacySettings settings) async {
    try {
      await _service.updatePrivacy(settings);
      _privacy = settings;
      notifyListeners();
      return true;
    } catch (_) {
      _errorMessage = 'networkError';
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
