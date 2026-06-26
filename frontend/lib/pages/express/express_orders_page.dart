import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/models/express_models.dart';
import 'package:dochat_app/providers/express_provider.dart';
import 'package:dochat_app/pages/express/express_tracking_page.dart';

class ExpressOrdersPage extends StatefulWidget {
  const ExpressOrdersPage({super.key});

  @override
  State<ExpressOrdersPage> createState() => _ExpressOrdersPageState();
}

class _ExpressOrdersPageState extends State<ExpressOrdersPage> {
  int _selectedTab = 0;

  String? _statusFilter(int tab) {
    switch (tab) {
      case 0:
        return 'pending';
      case 1:
        return 'in_progress';
      case 2:
        return 'completed';
      default:
        return null;
    }
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ExpressProvider>().loadOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.expressTab),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              child: CupertinoSlidingSegmentedControl<int>(
                groupValue: _selectedTab,
                onValueChanged: (v) {
                  if (v != null) {
                    setState(() => _selectedTab = v);
                  }
                },
                children: {
                  0: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text('\u5F85\u63A5\u5355'),
                  ),
                  1: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text('\u8FDB\u884C\u4E2D'),
                  ),
                  2: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text('\u5DF2\u5B8C\u6210'),
                  ),
                },
              ),
            ),
            Expanded(
              child: Consumer<ExpressProvider>(
                builder: (context, provider, _) {
                  if (provider.loading) {
                    return const Center(child: CupertinoActivityIndicator());
                  }

                  final orders = provider.orders;

                  if (orders.isEmpty) {
                    return Center(child: Text(l10n.noOrdersHint));
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (_) => ExpressTrackingPage(orderId: order.orderId),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: CupertinoColors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: CupertinoColors.systemGrey5, width: 0.5),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: _typeColor(order.type).withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    _typeIcon(order.type),
                                    size: 20,
                                    color: _typeColor(order.type),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _typeLabel(order.type),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF1C1C1E),
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        '${order.originAddress} \u2192 ${order.destAddress}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: CupertinoColors.systemGrey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '\u00A5${order.estimatedPrice.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFFFF3B30),
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: _statusColor(order.status).withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        _statusLabel(order.status),
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: _statusColor(order.status),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _typeIcon(String type) {
    switch (type) {
      case 'taxi':
        return CupertinoIcons.car_detailed;
      case 'errand':
        return CupertinoIcons.person_fill;
      case 'freight':
        return CupertinoIcons.cube_box_fill;
      default:
        return CupertinoIcons.cube_box_fill;
    }
  }

  Color _typeColor(String type) {
    switch (type) {
      case 'taxi':
        return const Color(0xFF007AFF);
      case 'errand':
        return const Color(0xFF34C759);
      case 'freight':
        return const Color(0xFFFF9500);
      default:
        return const Color(0xFF007AFF);
    }
  }

  String _typeLabel(String type) {
    switch (type) {
      case 'taxi':
        return '\u6253\u8F66';
      case 'errand':
        return '\u8DD1\u817F';
      case 'freight':
        return '\u8D27\u8FD0';
      default:
        return type;
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'pending':
        return '\u5F85\u63A5\u5355';
      case 'accepted':
        return '\u5DF2\u63A5\u5355';
      case 'picked_up':
        return '\u5DF2\u53D6\u4EF6';
      case 'in_transit':
        return '\u8FD0\u9001\u4E2D';
      case 'delivered':
        return '\u5DF2\u9001\u8FBE';
      case 'completed':
        return '\u5DF2\u5B8C\u6210';
      default:
        return status;
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'pending':
        return CupertinoColors.systemOrange;
      case 'accepted':
      case 'picked_up':
      case 'in_transit':
        return const Color(0xFF007AFF);
      case 'delivered':
      case 'completed':
        return const Color(0xFF34C759);
      default:
        return CupertinoColors.systemGrey;
    }
  }
}
