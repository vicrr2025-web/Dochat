class EcosystemBadge {
  final String ecosystemKey;
  final String ecosystemName;
  final String iconName;
  final int badgeCount;
  final String route;

  EcosystemBadge({
    required this.ecosystemKey,
    required this.ecosystemName,
    required this.iconName,
    this.badgeCount = 0,
    this.route = '',
  });

  factory EcosystemBadge.fromJson(Map<String, dynamic> json) {
    return EcosystemBadge(
      ecosystemKey: json['ecosystemKey'] as String? ?? '',
      ecosystemName: json['ecosystemName'] as String? ?? '',
      iconName: json['iconName'] as String? ?? '',
      badgeCount: json['badgeCount'] as int? ?? 0,
      route: json['route'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ecosystemKey': ecosystemKey,
      'ecosystemName': ecosystemName,
      'iconName': iconName,
      'badgeCount': badgeCount,
      'route': route,
    };
  }
}

class RecentService {
  final String ecosystemKey;
  final String ecosystemName;
  final String iconName;
  final String accessedAt;

  RecentService({
    required this.ecosystemKey,
    required this.ecosystemName,
    required this.iconName,
    required this.accessedAt,
  });

  factory RecentService.fromJson(Map<String, dynamic> json) {
    return RecentService(
      ecosystemKey: json['ecosystemKey'] as String? ?? '',
      ecosystemName: json['ecosystemName'] as String? ?? '',
      iconName: json['iconName'] as String? ?? '',
      accessedAt: json['accessedAt'] as String? ?? '',
    );
  }
}
