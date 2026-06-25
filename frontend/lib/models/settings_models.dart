class ProfileInfo {
  final String userId;
  final String nickname;
  final String avatar;
  final String email;
  final String creditLevel;
  final bool isVerified;
  final int creditScore;

  ProfileInfo({
    required this.userId,
    required this.nickname,
    required this.avatar,
    required this.email,
    required this.creditLevel,
    required this.isVerified,
    required this.creditScore,
  });

  factory ProfileInfo.fromJson(Map<String, dynamic> json) {
    return ProfileInfo(
      userId: json['userId'] as String? ?? '',
      nickname: json['nickname'] as String? ?? '',
      avatar: json['avatar'] as String? ?? '',
      email: json['email'] as String? ?? '',
      creditLevel: json['creditLevel'] as String? ?? 'copper',
      isVerified: json['isVerified'] as bool? ?? false,
      creditScore: json['creditScore'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'nickname': nickname,
      'avatar': avatar,
      'email': email,
      'creditLevel': creditLevel,
      'isVerified': isVerified,
      'creditScore': creditScore,
    };
  }
}

class DeviceInfo {
  final String deviceId;
  final String deviceName;
  final String deviceModel;
  final String osVersion;
  final String lastActiveAt;
  final bool isCurrent;

  DeviceInfo({
    required this.deviceId,
    required this.deviceName,
    required this.deviceModel,
    required this.osVersion,
    required this.lastActiveAt,
    required this.isCurrent,
  });

  factory DeviceInfo.fromJson(Map<String, dynamic> json) {
    return DeviceInfo(
      deviceId: json['deviceId'] as String? ?? '',
      deviceName: json['deviceName'] as String? ?? '',
      deviceModel: json['deviceModel'] as String? ?? '',
      osVersion: json['osVersion'] as String? ?? '',
      lastActiveAt: json['lastActiveAt'] as String? ?? '',
      isCurrent: json['isCurrent'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deviceId': deviceId,
      'deviceName': deviceName,
      'deviceModel': deviceModel,
      'osVersion': osVersion,
      'lastActiveAt': lastActiveAt,
      'isCurrent': isCurrent,
    };
  }
}

class StorageInfo {
  final int total;
  final int chat;
  final int images;
  final int videos;
  final int other;

  StorageInfo({
    required this.total,
    required this.chat,
    required this.images,
    required this.videos,
    required this.other,
  });

  factory StorageInfo.fromJson(Map<String, dynamic> json) {
    return StorageInfo(
      total: json['total'] as int? ?? 0,
      chat: json['chat'] as int? ?? 0,
      images: json['images'] as int? ?? 0,
      videos: json['videos'] as int? ?? 0,
      other: json['other'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'chat': chat,
      'images': images,
      'videos': videos,
      'other': other,
    };
  }
}

class PrivacySettings {
  final String onlineVisibility;
  final String avatarVisibility;
  final String bioVisibility;
  final String messagePermission;

  PrivacySettings({
    this.onlineVisibility = 'everyone',
    this.avatarVisibility = 'everyone',
    this.bioVisibility = 'everyone',
    this.messagePermission = 'everyone',
  });

  factory PrivacySettings.fromJson(Map<String, dynamic> json) {
    return PrivacySettings(
      onlineVisibility: json['onlineVisibility'] as String? ?? 'everyone',
      avatarVisibility: json['avatarVisibility'] as String? ?? 'everyone',
      bioVisibility: json['bioVisibility'] as String? ?? 'everyone',
      messagePermission: json['messagePermission'] as String? ?? 'everyone',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'onlineVisibility': onlineVisibility,
      'avatarVisibility': avatarVisibility,
      'bioVisibility': bioVisibility,
      'messagePermission': messagePermission,
    };
  }

  PrivacySettings copyWith({
    String? onlineVisibility,
    String? avatarVisibility,
    String? bioVisibility,
    String? messagePermission,
  }) {
    return PrivacySettings(
      onlineVisibility: onlineVisibility ?? this.onlineVisibility,
      avatarVisibility: avatarVisibility ?? this.avatarVisibility,
      bioVisibility: bioVisibility ?? this.bioVisibility,
      messagePermission: messagePermission ?? this.messagePermission,
    );
  }
}
