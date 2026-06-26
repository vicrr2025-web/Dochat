import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/providers/home_provider.dart';

class HomeWorkerPage extends StatefulWidget {
  const HomeWorkerPage({super.key});

  @override
  State<HomeWorkerPage> createState() => _HomeWorkerPageState();
}

class _HomeWorkerPageState extends State<HomeWorkerPage> {
  bool _isOnline = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<HomeProvider>();
      provider.loadOrders(role: 'worker');
      provider.loadWorkerCredit();
      provider.loadWorkerIncome();
      provider.loadTrainings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Consumer<HomeProvider>(
      builder: (context, provider, _) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              decoration: BoxDecoration(
                color: CupertinoColors.systemBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: CupertinoColors.systemGrey5, width: 0.5),
              ),
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() => _isOnline = !_isOnline);
                      provider.updateWorkerStatus(_isOnline ? 'online' : 'offline');
                    },
                    child: Container(
                      width: 52,
                      height: 32,
                      decoration: BoxDecoration(
                        color: _isOnline ? const Color(0xFF34C759) : CupertinoColors.systemGrey4,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Stack(
                        children: [
                          AnimatedAlign(
                            alignment: _isOnline ? Alignment.centerRight : Alignment.centerLeft,
                            duration: const Duration(milliseconds: 200),
                            child: Container(
                              width: 28,
                              height: 28,
                              margin: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: CupertinoColors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _isOnline ? '' : '',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: _isOnline ? const Color(0xFF34C759) : CupertinoColors.systemGrey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (provider.credit != null)
              Container(
                decoration: BoxDecoration(
                  color: CupertinoColors.systemBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: CupertinoColors.systemGrey5, width: 0.5),
                ),
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Text(l10n.creditScore, style: const TextStyle(fontSize: 15, color: Color(0xFF1C1C1E))),
                    const Spacer(),
                    Text(
                      '${provider.credit!['score'] ?? 0}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF5AC8FA)),
                    ),
                  ],
                ),
              ),
            if (provider.income != null) ...[
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: CupertinoColors.systemBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: CupertinoColors.systemGrey5, width: 0.5),
                ),
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(l10n.driverIncome, style: const TextStyle(fontSize: 13, color: CupertinoColors.systemGrey)),
                        Text(
                          '¥${(provider.income!['totalIncome'] ?? 0).toString()}',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF1C1C1E)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    CupertinoButton(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      color: const Color(0xFF5AC8FA),
                      borderRadius: BorderRadius.circular(20),
                      onPressed: () async {
                        await provider.withdraw(100);
                      },
                      child: Text(
                        l10n.withdrawCash,
                        style: const TextStyle(fontSize: 14, color: CupertinoColors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            Text(
              l10n.homeService,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1C1C1E)),
            ),
            const SizedBox(height: 10),
            if (provider.orders.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Text(l10n.noServiceHint, style: const TextStyle(color: CupertinoColors.systemGrey)),
                ),
              ),
            ...provider.orders.where((o) => o.status == 'waiting').map((order) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: CupertinoColors.systemGrey5, width: 0.5),
                    ),
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(order.orderId, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                              const SizedBox(height: 2),
                              Text(order.appointmentTime, style: const TextStyle(fontSize: 12, color: CupertinoColors.systemGrey)),
                              const SizedBox(height: 2),
                              Text('¥${order.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 13, color: Color(0xFFFF3B30))),
                            ],
                          ),
                        ),
                        CupertinoButton(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          color: const Color(0xFF5AC8FA),
                          borderRadius: BorderRadius.circular(16),
                          onPressed: () async {
                            await provider.acceptOrder(order.orderId);
                          },
                          child: Text(l10n.acceptOrder, style: const TextStyle(fontSize: 13, color: CupertinoColors.white)),
                        ),
                      ],
                    ),
                  ),
                )),
            const SizedBox(height: 16),
            Text(
              l10n.homeTraining,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1C1C1E)),
            ),
            const SizedBox(height: 10),
            if (provider.trainings.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Text(l10n.noServiceHint, style: const TextStyle(color: CupertinoColors.systemGrey)),
                ),
              ),
            ...provider.trainings.map((t) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: CupertinoColors.systemGrey5, width: 0.5),
                    ),
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Icon(
                          t.isCompleted ? CupertinoIcons.check_mark_circled_solid : CupertinoIcons.play_circle,
                          size: 28,
                          color: t.isCompleted ? const Color(0xFF34C759) : const Color(0xFF5AC8FA),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(t.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                              const SizedBox(height: 2),
                              Text('${t.durationMinutes} min', style: const TextStyle(fontSize: 12, color: CupertinoColors.systemGrey)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {},
              child: Container(
                decoration: BoxDecoration(
                  color: CupertinoColors.systemBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: CupertinoColors.systemGrey5, width: 0.5),
                ),
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    const Icon(CupertinoIcons.cart_fill, size: 24, color: Color(0xFF5AC8FA)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(l10n.workerMall, style: const TextStyle(fontSize: 15, color: Color(0xFF1C1C1E))),
                    ),
                    const Icon(CupertinoIcons.chevron_right, size: 16, color: CupertinoColors.systemGrey3),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
