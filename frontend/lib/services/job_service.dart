import 'package:dochat_app/models/job_models.dart';
import 'package:dochat_app/services/api_service.dart';

class JobService {
  final _api = ApiService();

  Future<JobResume> createOrUpdateResume(Map<String, dynamic> body) async {
    final res = await _api.client.post('/job/resume', data: body);
    return JobResume.fromJson(res.data['data'] as Map<String, dynamic>);
  }

  Future<JobResume?> getResume() async {
    try {
      final res = await _api.client.get('/job/resume');
      final data = res.data['data'];
      if (data == null) return null;
      return JobResume.fromJson(data as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<List<JobPosition>> searchPositions({
    int page = 0,
    int size = 10,
    String? keyword,
    String? city,
    String? industry,
  }) async {
    final params = <String, dynamic>{'page': page, 'size': size};
    if (keyword != null) params['keyword'] = keyword;
    if (city != null) params['city'] = city;
    if (industry != null) params['industry'] = industry;
    final res = await _api.client.get('/job/positions', queryParameters: params);
    final data = res.data;
    if (data is Map && data['data'] is List) {
      return (data['data'] as List)
          .map((e) => JobPosition.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<Map<String, dynamic>> applyPosition(String positionId, String greeting) async {
    final res = await _api.client.post('/job/apply', data: {
      'positionId': positionId,
      'greeting': greeting,
    });
    return res.data['data'] as Map<String, dynamic>;
  }

  Future<List<dynamic>> getApplications() async {
    final res = await _api.client.get('/job/applications');
    return res.data['data'] ?? [];
  }

  Future<Map<String, dynamic>> publishPosition(Map<String, dynamic> body) async {
    final res = await _api.client.post('/job/publish', data: body);
    return res.data['data'] as Map<String, dynamic>;
  }

  Future<List<JobApplication>> getCandidates(String positionId, {int page = 0, int size = 10}) async {
    final res = await _api.client.get('/job/candidates', queryParameters: {
      'positionId': positionId,
      'page': page,
      'size': size,
    });
    final data = res.data;
    if (data is Map && data['data'] is List) {
      return (data['data'] as List)
          .map((e) => JobApplication.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<Map<String, dynamic>> toggleFavoriteResume(String resumeId) async {
    final res = await _api.client.post('/job/favorite', data: {'resumeId': resumeId});
    return res.data['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> sendGreeting(String toUserId, String content) async {
    final res = await _api.client.post('/job/greeting', data: {
      'toUserId': toUserId,
      'content': content,
    });
    return res.data['data'] as Map<String, dynamic>;
  }

  Future<List<dynamic>> getMessages() async {
    final res = await _api.client.get('/job/messages');
    final data = res.data;
    if (data is Map && data['data'] is List) {
      return data['data'] as List<dynamic>;
    }
    return [];
  }

  Future<Map<String, dynamic>> companyAuth(Map<String, dynamic> body) async {
    final res = await _api.client.post('/job/company/auth', data: body);
    return res.data['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> scheduleInterview(Map<String, dynamic> body) async {
    final res = await _api.client.post('/job/interview', data: body);
    return res.data['data'] as Map<String, dynamic>;
  }

  Future<List<JobInterview>> getInterviews() async {
    final res = await _api.client.get('/job/interviews');
    final data = res.data;
    if (data is Map && data['data'] is List) {
      return (data['data'] as List)
          .map((e) => JobInterview.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<Map<String, dynamic>> upgradeVip(String role) async {
    final res = await _api.client.post('/job/vip', data: {'role': role});
    return res.data['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> buyBoost(String positionId) async {
    final res = await _api.client.post('/job/boost', data: {'positionId': positionId});
    return res.data['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> aiBatchInvite(String positionId, List<String> resumeIds) async {
    final res = await _api.client.post('/job/ai/invite', data: {
      'positionId': positionId,
      'resumeIds': resumeIds,
    });
    return res.data['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> buyExpertService(String serviceType) async {
    final res = await _api.client.post('/job/expert', data: {'serviceType': serviceType});
    return res.data['data'] as Map<String, dynamic>;
  }
}
