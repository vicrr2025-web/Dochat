import 'package:dochat_app/models/dating_models.dart';
import 'package:dochat_app/services/api_service.dart';

class DatingService {
  final _api = ApiService();

  Future<DatingProfile> getProfile() async {
    final res = await _api.client.get('/love/profile');
    return DatingProfile.fromJson(res.data['data'] as Map<String, dynamic>);
  }

  Future<DatingProfile> updateProfile(Map<String, dynamic> body) async {
    final res = await _api.client.post('/love/profile', data: body);
    return DatingProfile.fromJson(res.data['data'] as Map<String, dynamic>);
  }

  Future<List<DatingProfile>> getRecommendations({int page = 0, int size = 10}) async {
    final res = await _api.client.get('/love/recommend', queryParameters: {'page': page, 'size': size});
    final data = res.data;
    if (data is Map && data['data'] is List) {
      return (data['data'] as List)
          .map((e) => DatingProfile.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<Map<String, dynamic>> like(String toUserId) async {
    final res = await _api.client.post('/love/like', data: {'toUserId': toUserId});
    return res.data['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> superLike(String toUserId) async {
    final res = await _api.client.post('/love/superlike', data: {'toUserId': toUserId});
    return res.data['data'] as Map<String, dynamic>;
  }

  Future<List<dynamic>> getMatchStatus() async {
    final res = await _api.client.get('/love/match');
    final data = res.data;
    if (data is Map && data['data'] is List) {
      return data['data'] as List<dynamic>;
    }
    return [];
  }

  Future<DatingNote> sendNote(String toUserId, String content) async {
    final res = await _api.client.post('/love/note', data: {'toUserId': toUserId, 'content': content});
    return DatingNote.fromJson(res.data['data'] as Map<String, dynamic>);
  }

  Future<List<DatingNote>> getNotes() async {
    final res = await _api.client.get('/love/notes');
    final data = res.data;
    if (data is Map && data['data'] is List) {
      return (data['data'] as List)
          .map((e) => DatingNote.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<Map<String, dynamic>> authReal() async {
    final res = await _api.client.post('/love/auth/real');
    return res.data['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> authWork() async {
    final res = await _api.client.post('/love/auth/work');
    return res.data['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> authEdu() async {
    final res = await _api.client.post('/love/auth/edu');
    return res.data['data'] as Map<String, dynamic>;
  }

  Future<DatingFeed> createFeed(String content, [String? images]) async {
    final body = <String, dynamic>{'content': content};
    if (images != null) body['images'] = images;
    final res = await _api.client.post('/love/feed', data: body);
    return DatingFeed.fromJson(res.data['data'] as Map<String, dynamic>);
  }

  Future<List<DatingFeed>> getFeeds({int page = 0, int size = 10}) async {
    final res = await _api.client.get('/love/feed', queryParameters: {'page': page, 'size': size});
    final data = res.data;
    if (data is Map && data['data'] is List) {
      return (data['data'] as List)
          .map((e) => DatingFeed.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<Map<String, dynamic>> toggleFeedLike(String feedId) async {
    final res = await _api.client.post('/love/feed/$feedId/like');
    return res.data['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> addFeedComment(String feedId, String content) async {
    final res = await _api.client.post('/love/feed/$feedId/comment', data: {'content': content});
    return res.data['data'] as Map<String, dynamic>;
  }

  Future<DatingLive> startLive() async {
    final res = await _api.client.post('/love/live/start');
    return DatingLive.fromJson(res.data['data'] as Map<String, dynamic>);
  }

  Future<Map<String, dynamic>> endLive() async {
    final res = await _api.client.post('/love/live/end');
    return res.data['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> sendGift(String toUserId, String giftType) async {
    final res = await _api.client.post('/love/gift', data: {'toUserId': toUserId, 'giftType': giftType});
    return res.data['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> recharge(int amount) async {
    final res = await _api.client.post('/love/recharge', data: {'amount': amount});
    return res.data['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> upgradeVip(int months) async {
    final res = await _api.client.post('/love/vip', data: {'months': months});
    return res.data['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> superBoost() async {
    final res = await _api.client.post('/love/superboost');
    return res.data['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> charmWithdraw(int amount) async {
    final res = await _api.client.post('/love/charm/withdraw', data: {'amount': amount});
    return res.data['data'] as Map<String, dynamic>;
  }
}
