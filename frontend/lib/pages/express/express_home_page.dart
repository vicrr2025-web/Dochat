import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/providers/express_provider.dart';
import 'package:dochat_app/pages/express/express_order_taxi_page.dart';
import 'package:dochat_app/pages/express/express_order_errand_page.dart';
import 'package:dochat_app/pages/express/express_order_freight_page.dart';
import 'package:dochat_app/pages/express/express_orders_page.dart';
import 'package:dochat_app/pages/express/express_estimate_page.dart';
import 'package:dochat_app/pages/express/express_driver_page.dart';

class ExpressHomePage extends StatefulWidget {
  const ExpressHomePage({super.key});

  @override
  State<ExpressHomePage> createState() => _ExpressHomePageState();
}

class _ExpressHomePageState extends State<ExpressHomePage> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.expressTab),
        trailing: Consumer<ExpressProvider>(
          builder: (context, provider, _) {
            return GestureDetector(
              onTap: () {
                provider.toggleRole();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF9500).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  provider.role == 'user' ? l10n.driverRegister : '\u7528\u6237',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFFF9500),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      child: SafeArea(
        child: Consumer<ExpressProvider>(
          builder: (context, provider, _) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  if (provider.role == 'user') ...[
                    _serviceCard(
                      icon: CupertinoIcons.car_detailed,
                      title: '\uD83D\uDE97' + l10n.expressTaxi,
                      subtitle: '\u5FEB\u8F66 / \u4E13\u8F66 / \u62FC\u8F66',
                      color: const Color(0xFF007AFF),
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (_) => const ExpressOrderTaxiPage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    _serviceCard(
                      icon: CupertinoIcons.person_fill,
                      title: '\uD83C\uDFC3' + l10n.expressErrand,
                      subtitle: '\u6587\u4EF6 / \u9910\u996E / \u65E5\u7528\u54C1',
                      color: const Color(0xFF34C759),
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (_) => const ExpressOrderErrandPage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    _serviceCard(
                      icon: CupertinoIcons.cube_box_fill,
                      title: '\uD83D\uDE9A' + l10n.expressFreight,
                      subtitle: '\u5C0F\u9762 / \u4E2D\u9762 / 4.2\u7C73 / 6.8\u7C73',
                      color: const Color(0xFFFF9500),
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (_) => const ExpressOrderFreightPage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: _quickAction(
                            icon: CupertinoIcons.money_dollar_circle,
                            label: l10n.estimatePrice,
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (_) => const ExpressEstimatePage(),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _quickAction(
                            icon: CupertinoIcons.list_bullet,
                            label: '\u6211\u7684\u8BA2\u5355',
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (_) => const ExpressOrdersPage(),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    _serviceCard(
                      icon: CupertinoIcons.list_bullet,
                      title: '\u6211\u7684\u8BA2\u5355',
                      subtitle: '\u67E5\u770B\u5F85\u63A5\u5355 / \u8FDB\u884C\u4E2D\u8BA2\u5355',
                      color: const Color(0xFF007AFF),
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (_) => const ExpressOrdersPage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    _serviceCard(
                      icon: CupertinoIcons.person_crop_circle,
                      title: l10n.driverRegister,
                      subtitle: '\u7BA1\u7406\u53F8\u673A\u4FE1\u606F\u4E0E\u6536\u5165',
                      color: const Color(0xFFFF9500),
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (_) => const ExpressDriverPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _serviceCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: CupertinoColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: CupertinoColors.systemGrey5, width: 0.5),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1C1C1E),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              CupertinoIcons.chevron_right,
              size: 18,
              color: CupertinoColors.systemGrey3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _quickAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: CupertinoColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: CupertinoColors.systemGrey5, width: 0.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: const Color(0xFF007AFF)),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1C1C1E),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
