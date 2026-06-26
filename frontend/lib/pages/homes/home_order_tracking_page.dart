import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/providers/home_provider.dart';
import 'package:dochat_app/pages/homes/home_dispute_page.dart';

class HomeOrderTrackingPage extends StatefulWidget {
  const HomeOrderTrackingPage({super.key});

  @override
  State<HomeOrderTrackingPage> createState() => _HomeOrderTrackingPageState();
}

class _HomeOrderTrackingPageState extends State<HomeOrderTrackingPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<HomeProvider>();
      if (provider.currentOrder != null) {
        provider.loadOrderDetail(provider.currentOrder!.orderId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.homeTab),
      ),
      child: SafeArea(
        child: Consumer<HomeProvider>(
          builder: (context, provider, _) {
            final order = provider.currentOrder;

            if (order == null) {
              return const Center(child: CupertinoActivityIndicator());
            }

            final statuses = ['waiting', 'accepted', 'dispatched', 'serving', 'waiting_verify', 'completed'];
            final currentIdx = statuses.indexOf(order.status);
            

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: CupertinoColors.systemGrey5, width: 0.5),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.homeService,
                            style: const TextStyle(fontSize: 13, color: CupertinoColors.systemGrey),
                          ),
                          Text(
                            order.orderId,
                            style: const TextStyle(fontSize: 13, color: CupertinoColors.systemGrey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      for (int i = 0; i < statuses.length; i++)
                        _buildStep(
                          index: i,
                          currentIndex: currentIdx,
                        ),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: CupertinoColors.systemGrey6,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${l10n.appointmentTime}: ${order.appointmentTime}', style: const TextStyle(fontSize: 13)),
                            const SizedBox(height: 4),
                            Text('¥${order.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 13, color: Color(0xFFFF3B30))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                if (provider.worker != null)
                  Container(
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: CupertinoColors.systemGrey5, width: 0.5),
                    ),
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        ClipOval(
                          child: Container(
                            width: 44,
                            height: 44,
                            color: const Color(0xFF5AC8FA).withOpacity(0.2),
                            child: const Center(
                              child: Icon(CupertinoIcons.person_fill, size: 22, color: Color(0xFF5AC8FA)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(provider.worker!.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                              Text(
                                '${l10n.creditScore}: ${provider.worker!.creditScore.toStringAsFixed(0)}',
                                style: const TextStyle(fontSize: 12, color: CupertinoColors.systemGrey),
                              ),
                            ],
                          ),
                        ),
                        CupertinoButton(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          color: const Color(0xFF34C759),
                          borderRadius: BorderRadius.circular(16),
                          onPressed: () {},
                          child: const Text('', style: TextStyle(fontSize: 13)),
                        ),
                      ],
                    ),
                  ),
                if (provider.role == 'user' && order.status == 'waiting_verify') ...[
                  const SizedBox(height: 16),
                  CupertinoButton.filled(
                    onPressed: () async {
                      await provider.verifyOrder(order.orderId, true, rating: 5);
                    },
                    child: Text(l10n.serviceVerify),
                  ),
                ],
                if (provider.role == 'worker') ...[
                  const SizedBox(height: 16),
                  if (order.status == 'waiting')
                    CupertinoButton.filled(
                      onPressed: () async {
                        await provider.acceptOrder(order.orderId);
                      },
                      child: Text(l10n.acceptOrder),
                    ),
                  if (order.status == 'accepted')
                    CupertinoButton.filled(
                      onPressed: () async {
                        await provider.startService(order.orderId);
                      },
                      child: Text(l10n.startTrip),
                    ),
                  if (order.status == 'serving')
                    CupertinoButton.filled(
                      onPressed: () async {
                        await provider.completeService(order.orderId);
                      },
                      child: Text(l10n.completeTrip),
                    ),
                ],
                const SizedBox(height: 12),
                Center(
                  child: CupertinoButton(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    onPressed: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (_) => const HomeDisputePage(),
                        ),
                      );
                    },
                    child: Text(
                      l10n.expressDispute,
                      style: const TextStyle(color: CupertinoColors.systemGrey, fontSize: 14),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildStep({required int index, required int currentIndex}) {
    final labels = ['', '', '', '', '', ''];

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: index <= currentIndex
                ? Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF5AC8FA),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(CupertinoIcons.check_mark, size: 14, color: CupertinoColors.white),
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: CupertinoColors.systemGrey4, width: 1.5),
                    ),
                  ),
          ),
          const SizedBox(width: 12),
          Text(
            labels[index],
            style: TextStyle(
              fontSize: 14,
              color: index <= currentIndex ? const Color(0xFF1C1C1E) : CupertinoColors.systemGrey,
              fontWeight: index == currentIndex ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
