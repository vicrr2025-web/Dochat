

import 'package:dochat_app/models/friend_models.dart';
import 'package:dochat_app/services/api_service.dart';

class FriendService {
  final ApiService _api = ApiService();

  Future<FriendInfo> searchUser(String phone) async {
    final response = await _api.client.get('/api/v1/friends/search', queryParameters: {
      'phone': phone,
    });
    return FriendInfo.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<void> sendFriendRequest(String targetUserId, String message) async {
    await _api.client.post('/api/v1/friends/requests', data: {
      'targetUserId': targetUserId,
      'message': message,
    });
  }

  Future<List<FriendRequestInfo>> getPendingRequests() async {
    final response = await _api.client.get('/api/v1/friends/requests');
    final data = response.data;
    if (data is Map && data['data'] is List) {
      return (data['data'] as List)
          .map((e) => FriendRequestInfo.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<void> acceptRequest(String requestId) async {
    await _api.client.put('/api/v1/friends/requests/$requestId/accept');
  }

  Future<void> rejectRequest(String requestId) async {
    await _api.client.put('/api/v1/friends/requests/$requestId/reject');
  }

  Future<List<FriendInfo>> getFriends() async {
    final response = await _api.client.get('/api/v1/friends');
    final data = response.data;
    if (data is Map && data['data'] is List) {
      return (data['data'] as List)
          .map((e) => FriendInfo.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<void> removeFriend(String friendId) async {
    await _api.client.delete('/api/v1/friends/$friendId');
  }
}
