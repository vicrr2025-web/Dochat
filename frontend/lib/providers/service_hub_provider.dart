import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dochat_app/models/service_models.dart';
import 'package:dochat_app/services/service_hub_service.dart';

class ServiceHubProvider extends ChangeNotifier {
  final ServiceHubService _service = ServiceHubService();

  List<EcosystemBadge> _badges = [];
  List<RecentService> _localRecent = [];
  bool _isLoading = false;

  List<EcosystemBadge> get badges => _badges;
  List<RecentService> get localRecent => _localRecent;
  bool get isLoading => _isLoading;

  int get totalBadgeCount {
    int sum = 0;
    for (final b in _badges) {
      sum += b.badgeCount;
    }
    return sum;
  }

  Future<void> loadBadges() async {
    _isLoading = true;
    notifyListeners();
    try {
      _badges = await _service.getBadges();
    } catch (_) {}
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadRecent() async {
    _localRecent = await _loadLocalRecent();
    notifyListeners();
  }

  Future<void> addToRecent(EcosystemBadge badge) async {
    final entry = RecentService(
      ecosystemKey: badge.ecosystemKey,
      ecosystemName: badge.ecosystemName,
      iconName: badge.iconName,
      accessedAt: DateTime.now().toIso8601String(),
    );

    _localRecent.removeWhere((r) => r.ecosystemKey == badge.ecosystemKey);
    _localRecent.insert(0, entry);
    if (_localRecent.length > 4) {
      _localRecent = _localRecent.sublist(0, 4);
    }
    notifyListeners();
    await _saveLocalRecent();
  }

  static const _recentKey = 'service_hub_recent';

  Future<List<RecentService>> _loadLocalRecent() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_recentKey);
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List;
      return list.map((e) => RecentService(
        ecosystemKey: e['ecosystemKey'] as String? ?? '',
        ecosystemName: e['ecosystemName'] as String? ?? '',
        iconName: e['iconName'] as String? ?? '',
        accessedAt: e['accessedAt'] as String? ?? '',
      )).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> _saveLocalRecent() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _localRecent.map((r) => {
      'ecosystemKey': r.ecosystemKey,
      'ecosystemName': r.ecosystemName,
      'iconName': r.iconName,
      'accessedAt': r.accessedAt,
    }).toList();
    await prefs.setString(_recentKey, jsonEncode(data));
  }

}
