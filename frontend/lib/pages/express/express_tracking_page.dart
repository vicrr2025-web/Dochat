import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/providers/express_provider.dart';

class ExpressTrackingPage extends StatefulWidget {
  final String orderId;

  const ExpressTrackingPage({super.key, required this.orderId});

  @override
  State<ExpressTrackingPage> createState() => _ExpressTrackingPageState();
}

class _ExpressTrackingPageState extends State<ExpressTrackingPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ExpressProvider>().loadOrderDetail(widget.orderId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.trackingMap),
      ),
      child: SafeArea(
        child: Consumer<ExpressProvider>(
          builder: (context, provider, _) {
            if (provider.loading) {
              return const Center(child: CupertinoActivityIndicator());
            }

            final order = provider.currentOrder;
            if (order == null) {
              return Center(child: Text(l10n.noOrdersHint));
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 220,
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemGrey6,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(CupertinoIcons.map_fill, size: 56, color: CupertinoColors.systemGrey3),
                          SizedBox(height: 8),
                          Text(
                            '\u5B9E\u65F6\u8FFD\u8E2A\u5730\u56FE',
                            style: TextStyle(fontSize: 14, color: CupertinoColors.systemGrey),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _driverInfoCard(l10n, order),
                  const SizedBox(height: 14),
                  _statusTimeline(order.status),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF007AFF).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(CupertinoIcons.clock, color: Color(0xFF007AFF), size: 20),
                        const SizedBox(width: 8),
                        Text(
                          l10n.etaMinutes + ': ~8 \u5206\u949F',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF007AFF),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: CupertinoButton(
                          color: const Color(0xFF34C759),
                          onPressed: () {},
                          child: Text(l10n.contactDriver),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: CupertinoButton(
                          color: CupertinoColors.systemGrey4,
                          onPressed: () {},
                          child: Text(
                            '\u53D6\u6D88\u8BA2\u5355',
                            style: TextStyle(color: CupertinoColors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  CupertinoButton.filled(
                    onPressed: () async {
                      final ok = await provider.completeOrder(order.orderId, order.estimatedPrice);
                      if (ok && mounted) {
                        showCupertinoDialog(
                          context: context,
                          builder: (_) => CupertinoAlertDialog(
                            title: Text(l10n.arrived),
                            content: Text('\u8BA2\u5355\u5DF2\u5B8C\u6210'),
                            actions: [
                              CupertinoDialogAction(
                                onPressed: () => Navigator.pop(context),
                                child: Text(l10n.confirm),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    child: Text(l10n.arrived),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _driverInfoCard(AppLocalizations l10n, dynamic order) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CupertinoColors.systemGrey5, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.driverInfo,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1C1C1E),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              ClipOval(
                child: Container(
                  width: 44,
                  height: 44,
                  color: CupertinoColors.systemGrey5,
                  child: const Icon(
                    CupertinoIcons.person_fill,
                    size: 24,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '\u5F20\u5E08\u5085',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1C1C1E),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${order.vehicleType ?? '\u672A\u77E5'} | \u4EACA\u00B712345',
                      style: const TextStyle(fontSize: 12, color: CupertinoColors.systemGrey),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF9500).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      '\u2605 4.8',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFFF9500),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Icon(CupertinoIcons.phone, size: 20, color: Color(0xFF34C759)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusTimeline(String status) {
    final steps = [
      '\u5DF2\u63A5\u5355',
      '\u5DF2\u53D6\u4EF6',
      '\u8FD0\u9001\u4E2D',
      '\u5DF2\u9001\u8FBE',
    ];

    int activeIndex;
    switch (status) {
      case 'accepted':
        activeIndex = 0;
        break;
      case 'picked_up':
        activeIndex = 1;
        break;
      case 'in_transit':
        activeIndex = 2;
        break;
      case 'delivered':
        activeIndex = 3;
        break;
      default:
        activeIndex = 0;
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CupertinoColors.systemGrey5, width: 0.5),
      ),
      child: Column(
        children: List.generate(steps.length, (i) {
          final done = i <= activeIndex;
          return Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: done ? const Color(0xFF34C759) : CupertinoColors.systemGrey4,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                steps[i],
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: done ? FontWeight.w600 : FontWeight.w400,
                  color: done ? const Color(0xFF1C1C1E) : CupertinoColors.systemGrey,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
