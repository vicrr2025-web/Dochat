import 'package:dochat_app/models/house_models.dart';
import 'package:dochat_app/services/api_service.dart';

class HouseService {
  final _api = ApiService();

  Future<List<House>> getNewHouses({int page = 0, int size = 10, String? region}) async {
    final params = <String, dynamic>{'page': page, 'size': size};
    if (region != null && region.isNotEmpty) params['region'] = region;
    final res = await _api.client.get('/house/new', queryParameters: params);
    final data = res.data['data'];
    if (data is List) return List<House>.from(data.map((e) => House.fromJson(e as Map<String, dynamic>)));
    return [];
  }

  Future<List<House>> getSecondHouses({int page = 0, int size = 10}) async {
    final res = await _api.client.get('/house/second', queryParameters: {'page': page, 'size': size});
    final data = res.data['data'];
    if (data is List) return List<House>.from(data.map((e) => House.fromJson(e as Map<String, dynamic>)));
    return [];
  }

  Future<List<House>> getRentHouses({int page = 0, int size = 10, String? subType}) async {
    final params = <String, dynamic>{'page': page, 'size': size};
    if (subType != null && subType.isNotEmpty) params['subType'] = subType;
    final res = await _api.client.get('/house/rent', queryParameters: params);
    final data = res.data['data'];
    if (data is List) return List<House>.from(data.map((e) => House.fromJson(e as Map<String, dynamic>)));
    return [];
  }

  Future<List<House>> getCommercialHouses({int page = 0, int size = 10, String? subType}) async {
    final params = <String, dynamic>{'page': page, 'size': size};
    if (subType != null && subType.isNotEmpty) params['subType'] = subType;
    final res = await _api.client.get('/house/commercial', queryParameters: params);
    final data = res.data['data'];
    if (data is List) return List<House>.from(data.map((e) => House.fromJson(e as Map<String, dynamic>)));
    return [];
  }

  Future<House> getHouseDetail(String houseId) async {
    final res = await _api.client.get('/house/detail', queryParameters: {'houseId': houseId});
    return House.fromJson(res.data['data'] as Map<String, dynamic>);
  }

  Future<House> publishHouse(Map<String, dynamic> body) async {
    final res = await _api.client.post('/house/publish', data: body);
    return House.fromJson(res.data['data'] as Map<String, dynamic>);
  }

  Future<void> addFavorite(String houseId) async {
    await _api.client.post('/house/favorite', data: {'houseId': houseId});
  }

  Future<void> removeFavorite(String houseId) async {
    await _api.client.delete('/house/favorite', queryParameters: {'houseId': houseId});
  }

  Future<HouseAppointment> createAppointment(Map<String, dynamic> body) async {
    final res = await _api.client.post('/house/appointment', data: body);
    return HouseAppointment.fromJson(res.data['data'] as Map<String, dynamic>);
  }

  Future<List<HouseAppointment>> getAppointments({int page = 0, int size = 10, String? type}) async {
    final Map<String, dynamic> queryParams = {'page': page, 'size': size};
    if (type != null) queryParams['type'] = type;
    final res = await _api.client.get('/house/appointments', queryParameters: queryParams);
    final data = res.data['data'];
    if (data is List) return List<HouseAppointment>.from(data.map((e) => HouseAppointment.fromJson(e as Map<String, dynamic>)));
    return [];
  }

  Future<Map<String, dynamic>> calculateMortgage(Map<String, dynamic> body) async {
    final res = await _api.client.post('/house/calculator/mortgage', data: body);
    return res.data['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> calculateTax(Map<String, dynamic> body) async {
    final res = await _api.client.post('/house/calculator/tax', data: body);
    return res.data['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> evaluateHouse(Map<String, dynamic> body) async {
    final res = await _api.client.post('/house/valuation', data: body);
    return res.data['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> upgradeVip() async {
    final res = await _api.client.post('/house/vip');
    return res.data['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> renovationEstimate(Map<String, dynamic> body) async {
    final res = await _api.client.post('/house/renovation/estimate', data: body);
    return res.data['data'] as Map<String, dynamic>;
  }

  Future<List<Map<String, dynamic>>> getRenovationCompanies({int page = 0, int size = 10}) async {
    final res = await _api.client.get('/house/renovation/companies', queryParameters: {'page': page, 'size': size});
    final data = res.data['data'];
    if (data is List) return List<Map<String, dynamic>>.from(data.map((e) => e as Map<String, dynamic>));
    return [];
  }

  Future<Map<String, dynamic>> getCommunityInfo(String houseId) async {
    final res = await _api.client.get('/house/community', queryParameters: {'houseId': houseId});
    return res.data['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> sendChatMessage(String houseId, String content) async {
    final res = await _api.client.post('/house/chat', data: {'houseId': houseId, 'content': content});
    return res.data['data'] as Map<String, dynamic>;
  }
}
