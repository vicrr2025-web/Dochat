import 'package:dio/dio.dart';

import 'package:dochat_app/models/chat_models.dart';
import 'package:dochat_app/services/api_service.dart';

class ChatService {
  final ApiService _api = ApiService();

  Future<List<SessionInfo>> getSessions({int page = 0, int size = 20}) async {
    final response = await _api.client.get('/api/v1/sessions', queryParameters: {
      'page': page,
      'size': size,
    });
    final data = response.data;
    if (data is Map && data['content'] is List) {
      final pageResp = PageResponse.fromJson(
        data as Map<String, dynamic>,
        fromJsonT: (json) => SessionInfo.fromJson(json),
      );
      return pageResp.content;
    }
    return [];
  }

  Future<SessionInfo> createSession(String targetUserId) async {
    final request = CreateSessionRequest(targetUserId: targetUserId);
    final response = await _api.client.post(
      '/api/v1/sessions',
      data: request.toJson(),
    );
    return SessionInfo.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<void> pinSession(String sessionId, bool pinned) async {
    await _api.client.put(
      '/api/v1/sessions/$sessionId/pin',
      data: {'pinned': pinned},
    );
  }

  Future<void> muteSession(String sessionId, bool muted, {int? duration}) async {
    final data = <String, dynamic>{'muted': muted};
    if (duration != null) data['duration'] = duration;
    await _api.client.put(
      '/api/v1/sessions/$sessionId/mute',
      data: data,
    );
  }

  Future<void> deleteSession(String sessionId) async {
    await _api.client.delete('/api/v1/sessions/$sessionId');
  }

  Future<List<MessageInfo>> getMessages(
    String sessionId, {
    String? beforeMessageId,
    int size = 20,
    String currentUserId = '',
  }) async {
    final params = <String, dynamic>{
      'sessionId': sessionId,
      'size': size,
    };
    if (beforeMessageId != null) params['before'] = beforeMessageId;

    final response = await _api.client.get(
      '/api/v1/messages',
      queryParameters: params,
    );
    final data = response.data;
    if (data is Map && data['content'] is List) {
      final pageResp = PageResponse.fromJson(
        data as Map<String, dynamic>,
        fromJsonT: (json) => MessageInfo.fromJson(json, currentUserId: currentUserId),
      );
      return pageResp.content;
    }
    return [];
  }

  Future<MessageInfo> sendMessage(SendMessageRequest request, {String currentUserId = ''}) async {
    final response = await _api.client.post(
      '/api/v1/messages',
      data: request.toJson(),
    );
    return MessageInfo.fromJson(
      response.data['data'] as Map<String, dynamic>,
      currentUserId: currentUserId,
    );
  }

  Future<void> revokeMessage(String messageId) async {
    await _api.client.put('/api/v1/messages/$messageId/revoke');
  }

  Future<void> markRead(String sessionId, String lastMessageId) async {
    await _api.client.put(
      '/api/v1/messages/read',
      data: {'sessionId': sessionId, 'lastMessageId': lastMessageId},
    );
  }

  Future<List<MessageInfo>> searchMessages({
    String? keyword,
    String? sessionId,
    int page = 0,
    int size = 20,
    String currentUserId = '',
  }) async {
    final params = <String, dynamic>{'page': page, 'size': size};
    if (keyword != null && keyword.isNotEmpty) params['keyword'] = keyword;
    if (sessionId != null) params['sessionId'] = sessionId;

    final response = await _api.client.get(
      '/api/v1/messages/search',
      queryParameters: params,
    );
    final data = response.data;
    if (data is Map && data['content'] is List) {
      final pageResp = PageResponse.fromJson(
        data as Map<String, dynamic>,
        fromJsonT: (json) => MessageInfo.fromJson(json, currentUserId: currentUserId),
      );
      return pageResp.content;
    }
    return [];
  }

  Future<String> uploadFile(String filePath) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
    });
    final response = await _api.client.post(
      '/api/v1/messages/upload',
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );
    return response.data['data']['url'] as String;
  }

  Future<List<Map<String, dynamic>>> getFriends() async {
    final response = await _api.client.get('/api/v1/friends');
    final data = response.data;
    if (data is Map && data['data'] is List) {
      return (data['data'] as List).cast<Map<String, dynamic>>();
    }
    if (data is Map && data['content'] is List) {
      return (data['content'] as List).cast<Map<String, dynamic>>();
    }
    return [];
  }
}
