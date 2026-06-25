

import 'package:dochat_app/models/location_models.dart';
import 'package:dochat_app/services/api_service.dart';

class LocationService {
  final ApiService _api = ApiService();

  Future<void> uploadLocation({
    required double lat,
    required double lng,
    required double accuracy,
    required int battery,
    required bool isCharging,
  }) async {
    await _api.client.post('/api/v1/location/upload', data: {
      'lat': lat,
      'lng': lng,
      'accuracy': accuracy,
      'battery': battery,
      'isCharging': isCharging,
    });
  }

  Future<LocationInfo> getCurrentLocation() async {
    final response = await _api.client.get('/api/v1/location/current');
    return LocationInfo.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<Map<String, LocationInfo>> getFriendLocations() async {
    final response = await _api.client.get('/api/v1/location/friends');
    final data = response.data['data'] as Map<String, dynamic>? ?? {};
    final result = <String, LocationInfo>{};
    for (final entry in data.entries) {
      result[entry.key] =
          LocationInfo.fromJson(entry.value as Map<String, dynamic>);
    }
    return result;
  }

  Future<List<TrajectoryPoint>> getTrajectory(
    String friendId,
    DateTime startTime,
    DateTime endTime,
  ) async {
    final response = await _api.client.get(
      '/api/v1/location/$friendId/trajectory',
      queryParameters: {
        'start': startTime.toIso8601String(),
        'end': endTime.toIso8601String(),
      },
    );
    final data = response.data;
    if (data is Map && data['data'] is List) {
      return (data['data'] as List)
          .map((e) => TrajectoryPoint.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<void> toggleSharing(bool enabled) async {
    await _api.client.put('/api/v1/location/sharing', data: {
      'enabled': enabled,
    });
  }

  Future<List<GeoFenceInfo>> getGeoFences() async {
    final response = await _api.client.get('/api/v1/geofences');
    final data = response.data;
    if (data is Map && data['data'] is List) {
      return (data['data'] as List)
          .map((e) => GeoFenceInfo.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<GeoFenceInfo> createGeoFence({
    required String name,
    required double lat,
    required double lng,
    required int radius,
    required String targetUserId,
  }) async {
    final response = await _api.client.post('/api/v1/geofences', data: {
      'name': name,
      'lat': lat,
      'lng': lng,
      'radius': radius,
      'targetUserId': targetUserId,
    });
    return GeoFenceInfo.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<void> deleteGeoFence(String fenceId) async {
    await _api.client.delete('/api/v1/geofences/$fenceId');
  }
}
