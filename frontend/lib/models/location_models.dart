class LocationInfo {
  final double latitude;
  final double longitude;
  final double? accuracy;
  final int? battery;
  final bool? isCharging;
  final DateTime? updatedAt;

  const LocationInfo({
    required this.latitude,
    required this.longitude,
    this.accuracy,
    this.battery,
    this.isCharging,
    this.updatedAt,
  });

  factory LocationInfo.fromJson(Map<String, dynamic> json) {
    return LocationInfo(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      accuracy: (json['accuracy'] as num?)?.toDouble(),
      battery: json['battery'] as int?,
      isCharging: json['isCharging'] as bool?,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'accuracy': accuracy,
      'battery': battery,
      'isCharging': isCharging,
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

class GeoFenceInfo {
  final String fenceId;
  final String name;
  final double latitude;
  final double longitude;
  final int radius;
  final bool isActive;
  final String? targetUserId;
  final DateTime? createdAt;

  const GeoFenceInfo({
    required this.fenceId,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.radius,
    this.isActive = true,
    this.targetUserId,
    this.createdAt,
  });

  factory GeoFenceInfo.fromJson(Map<String, dynamic> json) {
    return GeoFenceInfo(
      fenceId: json['fenceId'] as String,
      name: json['name'] as String? ?? '',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      radius: json['radius'] as int,
      isActive: json['isActive'] as bool? ?? true,
      targetUserId: json['targetUserId'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fenceId': fenceId,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'radius': radius,
      'isActive': isActive,
      'targetUserId': targetUserId,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}

class TrajectoryPoint {
  final double latitude;
  final double longitude;
  final DateTime recordedAt;

  const TrajectoryPoint({
    required this.latitude,
    required this.longitude,
    required this.recordedAt,
  });

  factory TrajectoryPoint.fromJson(Map<String, dynamic> json) {
    return TrajectoryPoint(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      recordedAt: DateTime.parse(json['recordedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'recordedAt': recordedAt.toIso8601String(),
    };
  }
}
