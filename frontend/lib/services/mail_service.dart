import 'package:dochat_app/services/api_service.dart';

class MailService {
  final ApiService _api = ApiService();

  Future<Map<String, dynamic>> addAccount(Map<String, dynamic> data) async {
    final response = await _api.client.post('/mail/account', data: data);
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<List<dynamic>> getAccounts() async {
    final response = await _api.client.get('/mail/accounts');
    return response.data['data'] as List<dynamic>;
  }

  Future<void> deleteAccount(String accountId) async {
    await _api.client.delete('/mail/account', queryParameters: {'accountId': accountId});
  }

  Future<List<dynamic>> getMailList(
    String accountId,
    String folder, {
    int page = 0,
    int size = 20,
  }) async {
    final response = await _api.client.get(
      '/mail/list',
      queryParameters: {
        'accountId': accountId,
        'folder': folder,
        'page': page,
        'size': size,
      },
    );
    return response.data['data'] as List<dynamic> ?? [];
  }

  Future<Map<String, dynamic>> getMailDetail(String messageId) async {
    final response = await _api.client.get(
      '/mail/detail',
      queryParameters: {'messageId': messageId},
    );
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> sendMail(Map<String, dynamic> data) async {
    final response = await _api.client.post('/mail/send', data: data);
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> replyMail(Map<String, dynamic> data) async {
    final response = await _api.client.post('/mail/reply', data: data);
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<void> deleteMail(String messageId) async {
    await _api.client.delete('/mail/delete', queryParameters: {'messageId': messageId});
  }

  Future<void> markMail(Map<String, dynamic> data) async {
    await _api.client.put('/mail/mark', data: data);
  }

  Future<void> moveMail(Map<String, dynamic> data) async {
    await _api.client.put('/mail/move', data: data);
  }

  Future<Map<String, dynamic>> createFolder(String name) async {
    final response = await _api.client.post('/mail/folder', data: {'name': name});
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<void> deleteFolder(String folderId) async {
    await _api.client.delete('/mail/folder', queryParameters: {'folderId': folderId});
  }

  Future<List<dynamic>> getFolders() async {
    final res = await _api.client.get('/mail/folders');
    return res.data['data'] as List<dynamic> ?? [];
  }

  Future<List<dynamic>> getFilters() async {
    final res = await _api.client.get('/mail/filters');
    return res.data['data'] as List<dynamic> ?? [];
  }

  Future<Map<String, dynamic>> addFilter(Map<String, dynamic> data) async {
    final response = await _api.client.post('/mail/filter', data: data);
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getDailyReads({int page = 0, int size = 10}) async {
    final response = await _api.client.get(
      '/mail/reads',
      queryParameters: {'page': page, 'size': size},
    );
    return response.data['data'] as Map<String, dynamic>;
  }
}
