import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:dochat_app/models/location_models.dart';
import 'package:dochat_app/services/location_service.dart';

class LocationProvider extends ChangeNotifier {
  final LocationService _locationService = LocationService();

  LocationInfo? _myLocation;
  Map<String, LocationInfo> _friendLocations = {};
  bool _isSharingEnabled = false;
  List<GeoFenceInfo> _geoFences = [];
  List<TrajectoryPoint> _trajectory = [];
  bool _isLoading = false;
  String? _errorMessage;

  Timer? _pollTimer;
  Timer? _uploadTimer;

  LocationInfo? get myLocation => _myLocation;
  Map<String, LocationInfo> get friendLocations => _friendLocations;
  bool get isSharingEnabled => _isSharingEnabled;
  List<GeoFenceInfo> get geoFences => _geoFences;
  List<TrajectoryPoint> get trajectory => _trajectory;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> toggleSharing(bool enabled) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _locationService.toggleSharing(enabled);
      _isSharingEnabled = enabled;
      if (enabled) {
        startLocationUpdates();
      } else {
        stopLocationUpdates();
      }
    } catch (e) {
      _errorMessage = 'networkError';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refreshFriendLocations() async {
    try {
      _friendLocations = await _locationService.getFriendLocations();
      notifyListeners();
    } catch (_) {}
  }

  void startPollingFriendLocations() {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      refreshFriendLocations();
    });
  }

  void stopPollingFriendLocations() {
    _pollTimer?.cancel();
    _pollTimer = null;
  }

  Future<void> loadGeoFences() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _geoFences = await _locationService.getGeoFences();
    } catch (e) {
      _errorMessage = 'networkError';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> createGeoFence({
    required String name,
    required double lat,
    required double lng,
    required int radius,
    required String targetUserId,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final fence = await _locationService.createGeoFence(
        name: name,
        lat: lat,
        lng: lng,
        radius: radius,
        targetUserId: targetUserId,
      );
      _geoFences.add(fence);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'networkError';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> deleteGeoFence(String fenceId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _locationService.deleteGeoFence(fenceId);
      _geoFences.removeWhere((f) => f.fenceId == fenceId);
    } catch (e) {
      _errorMessage = 'networkError';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadTrajectory(
    String friendId,
    DateTime start,
    DateTime end,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _trajectory = await _locationService.getTrajectory(friendId, start, end);
    } catch (e) {
      _errorMessage = 'networkError';
    }

    _isLoading = false;
    notifyListeners();
  }

  void startLocationUpdates() {
    _uploadTimer?.cancel();
    _uploadTimer = Timer.periodic(const Duration(seconds: 10), (_) async {
      try {
        if (_myLocation != null) {
          await _locationService.uploadLocation(
            lat: _myLocation!.latitude,
            lng: _myLocation!.longitude,
            accuracy: _myLocation!.accuracy ?? 0,
            battery: _myLocation!.battery ?? 0,
            isCharging: _myLocation!.isCharging ?? false,
          );
        }
      } catch (_) {}
    });
  }

  void stopLocationUpdates() {
    _uploadTimer?.cancel();
    _uploadTimer = null;
  }

  void updateMyLocation(double lat, double lng) {
    _myLocation = LocationInfo(
      latitude: lat,
      longitude: lng,
      accuracy: 10.0,
      battery: 85,
      isCharging: false,
      updatedAt: DateTime.now(),
    );
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _uploadTimer?.cancel();
    super.dispose();
  }
}
