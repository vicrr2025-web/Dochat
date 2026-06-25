import 'package:dochat_app/models/settings_models.dart';
import 'package:dochat_app/services/api_service.dart';

class SettingsService {
  final _api = ApiService();

  Future<ProfileInfo> getProfile() async {
    final res = await _api.client.get('/user/profile');
    return ProfileInfo.fromJson(res.data['data']);
  }

  Future<void> updateProfile({String? nickname, String? avatar}) async {
    await _api.client.put('/user/profile', data: {
      if (nickname != null) 'nickname': nickname,
      if (avatar != null) 'avatar': avatar,
    });
  }

  Future<void> changePassword(String current, String newPwd) async {
    await _api.client.put('/user/password', data: {
      'currentPassword': current,
      'newPassword': newPwd,
    });
  }

  Future<void> submitVerify(String realName, String idNumber, String faceId) async {
    await _api.client.post('/user/verify', data: {
      'realName': realName,
      'idNumber': idNumber,
      'faceId': faceId,
    });
  }

  Future<Map<String, dynamic>> getVerifyStatus() async {
    final res = await _api.client.get('/user/verify/status');
    return res.data['data'] as Map<String, dynamic>;
  }

  Future<List<DeviceInfo>> getDevices() async {
    final res = await _api.client.get('/user/devices');
    final list = res.data['data'] as List? ?? [];
    return list.map((e) => DeviceInfo.fromJson(e)).toList();
  }

  Future<void> removeDevice(String deviceId) async {
    await _api.client.delete('/user/devices/$deviceId');
  }

  Future<void> removeOtherDevices() async {
    await _api.client.delete('/user/devices/others');
  }

  Future<StorageInfo> getStorage() async {
    final res = await _api.client.get('/user/storage');
    return StorageInfo.fromJson(res.data['data']);
  }

  Future<PrivacySettings> getPrivacy() async {
    final res = await _api.client.get('/user/privacy');
    return PrivacySettings.fromJson(res.data['data']);
  }

  Future<void> updatePrivacy(PrivacySettings settings) async {
    await _api.client.put('/user/privacy', data: settings.toJson());
  }

  Future<List<Map<String, dynamic>>> getBlacklist() async {
    final res = await _api.client.get('/user/blacklist');
    final list = res.data['data'] as List? ?? [];
    return list.map((e) => e as Map<String, dynamic>).toList();
  }
}
