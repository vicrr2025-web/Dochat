import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/models/home_models.dart';
import 'package:dochat_app/providers/home_provider.dart';
import 'package:dochat_app/pages/homes/home_order_create_page.dart';

class HomeServiceDetailPage extends StatelessWidget {
  final HomeServiceItem service;
  const HomeServiceDetailPage({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(service.name),
      ),
      child: SafeArea(
        child: Consumer<HomeProvider>(
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
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ClipOval(
                            child: Container(
                              width: 56,
                              height: 56,
                              color: const Color(0xFF5AC8FA).withOpacity(0.15),
                              child: const Center(
                                child: Icon(CupertinoIcons.wrench_fill, size: 28, color: Color(0xFF5AC8FA)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  service.name,
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF1C1C1E)),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${service.category} · ${service.subCategory}',
                                  style: const TextStyle(fontSize: 13, color: CupertinoColors.systemGrey),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        service.description,
                        style: const TextStyle(fontSize: 14, color: Color(0xFF3C3C43), height: 1.5),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Text(
                            l10n.priceType,
                            style: const TextStyle(fontSize: 13, color: CupertinoColors.systemGrey),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            service.priceType == 'fixed'
                                ? l10n.fixedPrice
                                : service.priceType == 'quote'
                                    ? l10n.quotePrice
                                    : l10n.calcPrice,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF007AFF)),
                          ),
                        ],
                      ),
                      if (service.priceType == 'fixed' && service.fixedPrice != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          '¥${service.fixedPrice!.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Color(0xFFFF3B30)),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  l10n.selectWorker,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1C1C1E)),
                ),
                const SizedBox(height: 12),
                if (provider.workers.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: Text(l10n.noWorkerHint, style: const TextStyle(color: CupertinoColors.systemGrey)),
                    ),
                  ),
                ...provider.workers.map((worker) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (_) => HomeOrderCreatePage(service: service, worker: worker),
                            ),
                          );
                        },
                        child: Container(
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
                                    Text(
                                      worker.name,
                                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Color(0xFF1C1C1E)),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${l10n.creditScore}: ${worker.creditScore.toStringAsFixed(0)} · ${l10n.homeService}: ${worker.completedOrders}',
                                      style: const TextStyle(fontSize: 12, color: CupertinoColors.systemGrey),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF5AC8FA).withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  l10n.homeService,
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF5AC8FA)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )),
                const SizedBox(height: 24),
                CupertinoButton.filled(
                  onPressed: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => HomeOrderCreatePage(service: service, worker: null),
                      ),
                    );
                  },
                  child: Text(l10n.homeService),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
