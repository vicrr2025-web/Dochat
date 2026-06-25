import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/providers/mall_provider.dart';
import 'package:dochat_app/pages/services/mall_review_page.dart';
import 'package:dochat_app/pages/services/mall_dispute_page.dart';

class MallOrderDetailPage extends StatefulWidget {
  final String orderId;

  const MallOrderDetailPage({super.key, required this.orderId});

  @override
  State<MallOrderDetailPage> createState() => _MallOrderDetailPageState();
}

class _MallOrderDetailPageState extends State<MallOrderDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<MallProvider>().loadOrderDetail(widget.orderId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.tradeDetail),
      ),
      child: SafeArea(
        child: Consumer<MallProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading || provider.currentOrder == null) {
              return const Center(child: CupertinoActivityIndicator());
            }
            final order = provider.currentOrder!;

            final timeline = _buildTimeline(order.status, l10n);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: CupertinoColors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(order.title,
                            style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700)),
                        const SizedBox(height: 8),
                        Text(
                          '¥${order.price.toStringAsFixed(2)}  ×${order.qty}',
                          style: const TextStyle(
                              fontSize: 18,
                              color: Color(0xFFFF3B30),
                              fontWeight: FontWeight.w700),
                        ),
                        if (order.trackingNo != null &&
                            order.trackingNo!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            '${l10n.trackingNo}: ${order.trackingNo}',
                            style: const TextStyle(
                                fontSize: 13,
                                color:
                                    CupertinoColors.systemGrey),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: CupertinoColors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text('状态',
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600)),
                        const SizedBox(height: 12),
                        ...timeline,
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildActions(
                      context, provider, order, l10n),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildTimeline(
      String status, AppLocalizations l10n) {
    final steps = ['toPay', 'toShip', 'toReceive', 'toReview', 'completed'];
    final labels = [
      l10n.toPayStatus,
      l10n.toShipStatus,
      l10n.toReceiveStatus,
      l10n.toReviewStatus,
      l10n.completed,
    ];

    int currentIdx = steps.indexOf(status);
    if (currentIdx < 0) currentIdx = 0;

    return List.generate(steps.length, (i) {
      final isActive = i <= currentIdx;
      final isLast = i == steps.length - 1;
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive
                      ? CupertinoColors.systemBlue
                      : CupertinoColors.systemGrey4,
                ),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 24,
                  color: isActive
                      ? CupertinoColors.systemBlue
                      : CupertinoColors.systemGrey4,
                ),
            ],
          ),
          const SizedBox(width: 12),
          Text(
            labels[i],
            style: TextStyle(
              fontSize: 14,
              fontWeight:
                  isActive ? FontWeight.w600 : FontWeight.w400,
              color: isActive
                  ? const Color(0xFF1C1C1E)
                  : CupertinoColors.systemGrey,
            ),
          ),
        ],
      );
    });
  }

  Widget _buildActions(BuildContext context,
      MallProvider provider, dynamic order, AppLocalizations l10n) {
    switch (order.status) {
      case 'toPay':
        return CupertinoButton(
          color: const Color(0xFFFF3B30),
          child: Text(l10n.payNow),
          onPressed: () {
            provider.payOrder(order.id);
          },
        );
      case 'toShip':
        return CupertinoButton(
          color: CupertinoColors.systemBlue,
          child: Text(l10n.shipOrder),
          onPressed: () {
            provider.shipOrder(order.id, 'SF1234567890');
          },
        );
      case 'toReceive':
        return Row(
          children: [
            Expanded(
              child: CupertinoButton(
                color: CupertinoColors.systemGreen,
                child: Text(l10n.confirmReceipt),
                onPressed: () {
                  provider.confirmReceipt(order.id);
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: CupertinoButton(
                color: CupertinoColors.systemGrey,
                child: Text(l10n.applyRefund),
                onPressed: () {
                  provider.refundOrder(order.id, '质量问题');
                },
              ),
            ),
          ],
        );
      case 'toReview':
        return Row(
          children: [
            Expanded(
              child: CupertinoButton(
                color: CupertinoColors.systemBlue,
                child: Text(l10n.writeReview),
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (_) =>
                          MallReviewPage(orderId: order.id),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      default:
        return Row(
          children: [
            Expanded(
              child: CupertinoButton(
                color: CupertinoColors.systemGrey,
                child: Text(l10n.contactSellerLabel),
                onPressed: () {
                  provider.getChatSession(order.id);
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: CupertinoButton(
                color: CupertinoColors.systemGrey,
                child: Text(l10n.initiateDispute),
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (_) =>
                          MallDisputePage(orderId: order.id),
                    ),
                  );
                },
              ),
            ),
          ],
        );
    }
  }
}
