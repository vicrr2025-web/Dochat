import 'package:dochat_app/models/service_models.dart';
import 'package:dochat_app/services/api_service.dart';

class ServiceHubService {
  final ApiService _api = ApiService();

  Future<List<EcosystemBadge>> getBadges() async {
    final response = await _api.client.get('/v1/services/badges');
    final data = response.data['data'] as List;
    return data
        .map((e) => EcosystemBadge.fromJson(e as Map<String, dynamic>))
        .toList();
  }

}
