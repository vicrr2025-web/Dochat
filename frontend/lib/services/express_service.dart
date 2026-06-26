import 'package:dio/dio.dart';
import 'package:dochat_app/models/express_models.dart';
import 'package:dochat_app/services/api_service.dart';

class ExpressService {
  Dio get _client => ApiService().client;

  Future<ExpressOrder> createOrder(Map<String, dynamic> data) async {
    final res = await _client.post('/express/order', data: data);
    return ExpressOrder.fromJson(res.data['data']);
  }

  Future<List<ExpressOrder>> getOrders(String role, {int page = 0, int size = 20}) async {
    final res = await _client.get('/express/orders', queryParameters: {
      'role': role,
      'page': page,
      'size': size,
    });
    final list = res.data['data'] as List? ?? [];
    return list.map((e) => ExpressOrder.fromJson(e)).toList();
  }

  Future<ExpressOrder> getOrderDetail(String orderId) async {
    final res = await _client.get('/express/detail', queryParameters: {'orderId': orderId});
    return ExpressOrder.fromJson(res.data['data']);
  }

  Future<ExpressOrder> acceptOrder(String orderId) async {
    final res = await _client.put('/express/accept', data: {'orderId': orderId});
    return ExpressOrder.fromJson(res.data['data']);
  }

  Future<void> updateLocation(String orderId, double lat, double lng) async {
    await _client.post('/express/location', data: {
      'orderId': orderId,
      'lat': lat,
      'lng': lng,
    });
  }

  Future<ExpressOrder> completeOrder(String orderId, double price) async {
    final res = await _client.put('/express/complete', data: {
      'orderId': orderId,
      'price': price,
    });
    return ExpressOrder.fromJson(res.data['data']);
  }

  Future<Map<String, dynamic>> estimatePrice(Map<String, dynamic> data) async {
    final res = await _client.post('/express/estimate', data: data);
    return res.data['data'] as Map<String, dynamic>;
  }

  Future<ExpressDriver> registerDriver(Map<String, dynamic> data) async {
    final res = await _client.post('/express/driver/register', data: data);
    return ExpressDriver.fromJson(res.data['data']);
  }

  Future<Map<String, dynamic>> getDriverIncome() async {
    final res = await _client.get('/express/driver/income');
    return res.data['data'] as Map<String, dynamic>;
  }

  Future<void> withdraw(double amount, String bankAccount) async {
    await _client.post('/express/driver/withdraw', data: {
      'amount': amount,
      'bankAccount': bankAccount,
    });
  }

  Future<void> updateDriverStatus(String status) async {
    await _client.put('/express/driver/status', data: {'status': status});
  }

  Future<ExpressDispute> createDispute(Map<String, dynamic> data) async {
    final res = await _client.post('/express/dispute', data: data);
    return ExpressDispute.fromJson(res.data['data']);
  }

  Future<void> submitEvidence(String disputeId, String evidence) async {
    await _client.post('/express/dispute/evidence', data: {
      'disputeId': disputeId,
      'evidence': evidence,
    });
  }

  Future<Map<String, dynamic>> getJuryStatus(String disputeId) async {
    final res = await _client.get('/express/dispute/jury', queryParameters: {'disputeId': disputeId});
    return res.data['data'] as Map<String, dynamic>;
  }
}
