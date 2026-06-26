import 'package:dio/dio.dart';
import 'package:dochat_app/models/home_models.dart';
import 'package:dochat_app/services/api_service.dart';

class HomeService {
  Dio get _client => ApiService().client;

  Future<List<HomeServiceItem>> getServices({
    String? category,
    String? subCategory,
    int page = 0,
    int size = 20,
  }) async {
    final res = await _client.get('/home/service', queryParameters: {
      if (category != null) 'category': category,
      if (subCategory != null) 'subCategory': subCategory,
      'page': page,
      'size': size,
    });
    final list = res.data['data'] as List? ?? [];
    return list.map((e) => HomeServiceItem.fromJson(e)).toList();
  }

  Future<HomeServiceItem> getServiceDetail(String serviceId) async {
    final res = await _client.get('/home/service/detail', queryParameters: {'serviceId': serviceId});
    return HomeServiceItem.fromJson(res.data['data']);
  }

  Future<HomeOrder> createOrder(Map<String, dynamic> data) async {
    final res = await _client.post('/home/order', data: data);
    return HomeOrder.fromJson(res.data['data']);
  }

  Future<List<HomeOrder>> getOrders({String? role, int page = 0, int size = 20}) async {
    final res = await _client.get('/home/orders', queryParameters: {
      if (role != null) 'role': role,
      'page': page,
      'size': size,
    });
    final list = res.data['data'] as List? ?? [];
    return list.map((e) => HomeOrder.fromJson(e)).toList();
  }

  Future<HomeOrder> getOrderDetail(String orderId) async {
    final res = await _client.get('/home/order/detail', queryParameters: {'orderId': orderId});
    return HomeOrder.fromJson(res.data['data']);
  }

  Future<HomeOrder> acceptOrder(String orderId) async {
    final res = await _client.put('/home/order/accept', data: {'orderId': orderId});
    return HomeOrder.fromJson(res.data['data']);
  }

  Future<HomeOrder> startService(String orderId) async {
    final res = await _client.put('/home/order/start', data: {'orderId': orderId});
    return HomeOrder.fromJson(res.data['data']);
  }

  Future<HomeOrder> completeService(String orderId) async {
    final res = await _client.put('/home/order/complete', data: {'orderId': orderId});
    return HomeOrder.fromJson(res.data['data']);
  }

  Future<HomeOrder> verifyOrder(String orderId, bool accept, {double? rating}) async {
    final res = await _client.put('/home/order/verify', data: {
      'orderId': orderId,
      'accept': accept,
      if (rating != null) 'rating': rating,
    });
    return HomeOrder.fromJson(res.data['data']);
  }

  Future<HomeWorker> registerWorker(Map<String, dynamic> data) async {
    final res = await _client.post('/home/worker/register', data: data);
    return HomeWorker.fromJson(res.data['data']);
  }

  Future<List<HomeWorker>> getWorkers({String? serviceId, int page = 0, int size = 20}) async {
    final res = await _client.get('/home/workers', queryParameters: {
      if (serviceId != null) 'serviceId': serviceId,
      'page': page,
      'size': size,
    });
    final list = res.data['data'] as List? ?? [];
    return list.map((e) => HomeWorker.fromJson(e)).toList();
  }

  Future<HomeWorker> getWorkerDetail(String workerId) async {
    final res = await _client.get('/home/worker/detail', queryParameters: {'workerId': workerId});
    return HomeWorker.fromJson(res.data['data']);
  }

  Future<Map<String, dynamic>> getWorkerCredit() async {
    final res = await _client.get('/home/worker/credit');
    return res.data['data'] as Map<String, dynamic>;
  }

  Future<HomeDispute> createDispute(Map<String, dynamic> data) async {
    final res = await _client.post('/home/dispute', data: data);
    return HomeDispute.fromJson(res.data['data']);
  }

  Future<void> submitEvidence(String disputeId, String evidence) async {
    await _client.post('/home/dispute/evidence', data: {
      'disputeId': disputeId,
      'evidence': evidence,
    });
  }

  Future<Map<String, dynamic>> getJuryStatus(String disputeId) async {
    final res = await _client.get('/home/dispute/jury', queryParameters: {'disputeId': disputeId});
    return res.data['data'] as Map<String, dynamic>;
  }

  Future<List<HomeTraining>> getTrainings({String? category, int page = 0, int size = 20}) async {
    final res = await _client.get('/home/trainings', queryParameters: {
      if (category != null) 'category': category,
      'page': page,
      'size': size,
    });
    final list = res.data['data'] as List? ?? [];
    return list.map((e) => HomeTraining.fromJson(e)).toList();
  }

  Future<void> updateWorkerStatus(String status) async {
    await _client.put('/home/worker/status', data: {'status': status});
  }

  Future<Map<String, dynamic>> getWorkerIncome() async {
    final res = await _client.get('/home/worker/income');
    return res.data['data'] as Map<String, dynamic>;
  }

  Future<void> withdraw(double amount) async {
    await _client.post('/home/worker/withdraw', data: {'amount': amount});
  }

  Future<List<HomeCategory>> getCategories() async {
    final res = await _client.get('/home/categories');
    final list = res.data['data'] as List? ?? [];
    return list.map((e) => HomeCategory.fromJson(e)).toList();
  }

  Future<List<HomeFavorite>> getFavorites() async {
    final res = await _client.get('/home/favorites');
    final list = res.data['data'] as List? ?? [];
    return list.map((e) => HomeFavorite.fromJson(e)).toList();
  }

  Future<void> addFavorite(String workerId) async {
    await _client.post('/home/favorite', data: {'workerId': workerId});
  }

  Future<void> removeFavorite(String workerId) async {
    await _client.delete('/home/favorite', data: {'workerId': workerId});
  }
}
