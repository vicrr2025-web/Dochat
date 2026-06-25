import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/providers/mall_provider.dart';
import 'package:dochat_app/pages/services/mall_order_detail_page.dart';

class MallOrderListPage extends StatefulWidget {
  const MallOrderListPage({super.key});

  @override
  State<MallOrderListPage> createState() => _MallOrderListPageState();
}

class _MallOrderListPageState extends State<MallOrderListPage> {
  int _selectedTab = 0;

  String? _statusFromTab(int tab) {
    switch (tab) {
      case 1: return 'toPay';
      case 2: return 'toShip';
      case 3: return 'toReceive';
      case 4: return 'toReview';
      default: return null;
    }
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<MallProvider>().loadOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.myOrders),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: CupertinoSlidingSegmentedControl<int>(
                groupValue: _selectedTab,
                onValueChanged: (v) {
                  if (v != null) {
                    setState(() => _selectedTab = v);
                    context
                        .read<MallProvider>()
                        .loadOrders(status: _statusFromTab(v));
                  }
                },
                children: {
                  0: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Text(l10n.all, style: const TextStyle(fontSize: 12)),
                  ),
                  1: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Text(l10n.toPayStatus, style: const TextStyle(fontSize: 12)),
                  ),
                  2: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Text(l10n.toShipStatus, style: const TextStyle(fontSize: 12)),
                  ),
                  3: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Text(l10n.toReceiveStatus, style: const TextStyle(fontSize: 12)),
                  ),
                  4: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Text(l10n.toReviewStatus, style: const TextStyle(fontSize: 12)),
                  ),
                },
              ),
            ),
            Expanded(
              child: Consumer<MallProvider>(
                builder: (context, provider, _) {
                  if (provider.isLoading) {
                    return const Center(child: CupertinoActivityIndicator());
                  }
                  if (provider.orders.isEmpty) {
                    return Center(child: Text(l10n.noOrdersHint));
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: provider.orders.length,
                    itemBuilder: (context, index) {
                      final order = provider.orders[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (_) => MallOrderDetailPage(orderId: order.id),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: CupertinoColors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(order.title,
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 4),
                                    Text(
                                      '¥${order.price.toStringAsFixed(2)}  ×${order.qty}',
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFFFF3B30),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _statusColor(order.status)
                                      .withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  _statusLabel(order.status, l10n),
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: _statusColor(order.status),
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
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

  Color _statusColor(String status) {
    switch (status) {
      case 'toPay': return CupertinoColors.systemOrange;
      case 'toShip': return CupertinoColors.activeBlue;
      case 'toReceive': return CupertinoColors.systemGreen;
      case 'toReview': return const Color(0xFF5856D6);
      case 'completed': return const Color(0xFF34C759);
      default: return CupertinoColors.systemGrey;
    }
  }

  String _statusLabel(String status, AppLocalizations l10n) {
    switch (status) {
      case 'toPay': return l10n.toPayStatus;
      case 'toShip': return l10n.toShipStatus;
      case 'toReceive': return l10n.toReceiveStatus;
      case 'toReview': return l10n.toReviewStatus;
      case 'completed': return l10n.completed;
      default: return status;
    }
  }
}
