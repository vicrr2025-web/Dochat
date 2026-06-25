import 'package:dochat_app/models/guarantee_models.dart';
import 'package:dochat_app/services/api_service.dart';

class GuaranteeService {
  final _api = ApiService();

  Future<TradeInfo> createTrade(CreateTradeRequest request) async {
    final res = await _api.client.post('/guarantee/create', data: request.toJson());
    return TradeInfo.fromJson(res.data['data']);
  }

  Future<TradeInfo> getTradeDetail(String tradeId) async {
    final res = await _api.client.get('/guarantee/$tradeId');
    return TradeInfo.fromJson(res.data['data']);
  }

  Future<void> confirmTrade(String tradeId) async {
    await _api.client.put('/guarantee/$tradeId/confirm');
  }

  Future<void> freezeFunds(String tradeId) async {
    await _api.client.put('/guarantee/$tradeId/freeze');
  }

  Future<void> initiateVerify(String tradeId) async {
    await _api.client.post('/guarantee/$tradeId/verify');
  }

  Future<void> releaseFunds(String tradeId) async {
    await _api.client.put('/guarantee/$tradeId/release');
  }

  Future<List<TradeInfo>> getTradeList({String? status, int page = 0}) async {
    final params = <String, dynamic>{'page': page};
    if (status != null && status.isNotEmpty) params['status'] = status;
    final res = await _api.client.get('/guarantee/list', queryParameters: params);
    final data = res.data;
    if (data is Map && data['data'] is List) {
      return (data['data'] as List)
          .map((e) => TradeInfo.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    if (data is Map && data['content'] is List) {
      return (data['content'] as List)
          .map((e) => TradeInfo.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<DisputeInfo> createDispute(String tradeId, DisputeRequest request) async {
    final res = await _api.client.post(
      '/guarantee/$tradeId/dispute',
      data: request.toJson(),
    );
    return DisputeInfo.fromJson(res.data['data']);
  }

  Future<DisputeInfo> getDispute(String tradeId) async {
    final res = await _api.client.get('/guarantee/$tradeId/dispute');
    return DisputeInfo.fromJson(res.data['data']);
  }

  Future<ChatSessionResponse> getChatSession(String tradeId) async {
    final res = await _api.client.get('/guarantee/$tradeId/chat');
    return ChatSessionResponse.fromJson(res.data['data']);
  }
}
