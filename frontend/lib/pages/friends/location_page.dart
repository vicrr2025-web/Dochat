import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/providers/location_provider.dart';
import 'package:dochat_app/pages/friends/friend_detail_page.dart';

class LocationPage extends StatefulWidget {
  final String? friendId;
  final String? friendName;

  const LocationPage({super.key, this.friendId, this.friendName});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<LocationProvider>();
      provider.refreshFriendLocations();
      provider.startPollingFriendLocations();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  String _formatDistance(double lat1, double lng1, double lat2, double lng2) {
    const double r = 6371;
    final dLat = _toRad(lat2 - lat1);
    final dLng = _toRad(lng2 - lng1);
    final a = _sin(dLat / 2) * _sin(dLat / 2) +
        _cos(_toRad(lat1)) * _cos(_toRad(lat2)) * _sin(dLng / 2) * _sin(dLng / 2);
    final c = 2 * _atan2(_sqrt(a), _sqrt(1 - a));
    final km = r * c;
    if (km < 1) return '${(km * 1000).round()}m';
    return '${km.toStringAsFixed(1)}km';
  }

  double _toRad(double deg) => deg * 0.017453292519943295;
  double _sin(double x) => x - x * x * x / 6 + x * x * x * x * x / 120;
  double _cos(double x) => 1 - x * x / 2 + x * x * x * x / 24;
  double _sqrt(double x) {
    if (x <= 0) return 0;
    double z = x;
    for (int i = 0; i < 10; i++) {
      z = (z + x / z) / 2;
    }
    return z;
  }
  double _atan2(double y, double x) {
    if (x > 0) return _atan(y / x);
    if (x < 0) return _atan(y / x) + (y >= 0 ? 3.141592653589793 : -3.141592653589793);
    return y > 0 ? 1.5707963267948966 : y < 0 ? -1.5707963267948966 : 0;
  }
  double _atan(double x) {
    double result = 0;
    double term = x;
    double x2 = x * x;
    for (int i = 1; i < 20; i += 2) {
      if (i > 1) term *= -x2;
      result += term / i;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final provider = context.watch<LocationProvider>();

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.friendName ?? l10n.liveLocation),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Container(
              height: 200,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE5E5EA),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(CupertinoIcons.map, size: 48, color: CupertinoColors.systemGrey),
                    SizedBox(height: 8),
                    Text(
                      'Map Loading…',
                      style: TextStyle(color: CupertinoColors.systemGrey, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: provider.friendLocations.isEmpty
                  ? Center(
                      child: Text(
                        l10n.noMessages,
                        style: const TextStyle(
                          color: CupertinoColors.systemGrey,
                          fontSize: 15,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: provider.friendLocations.length,
                      itemBuilder: (context, index) {
                        final entry = provider.friendLocations.entries.elementAt(index);
                        final loc = entry.value;
                        final distStr = provider.myLocation != null
                            ? _formatDistance(
                                provider.myLocation!.latitude,
                                provider.myLocation!.longitude,
                                loc.latitude,
                                loc.longitude,
                              )
                            : '-';

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              Navigator.of(context).push(
                                CupertinoPageRoute(
                                  builder: (_) => FriendDetailPage(friendId: entry.key),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: CupertinoColors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      color: CupertinoColors.systemGrey4,
                                      child: const Icon(
                                        CupertinoIcons.person_fill,
                                        color: CupertinoColors.systemGrey,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          entry.key,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: CupertinoColors.black,
                                          ),
                                        ),
                                        Text(
                                          distStr,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: CupertinoColors.systemGrey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (loc.battery != null)
                                    Text(
                                      '🔋${loc.battery}%',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
