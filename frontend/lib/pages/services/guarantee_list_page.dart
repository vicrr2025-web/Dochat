import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/providers/guarantee_provider.dart';
import 'package:dochat_app/pages/services/guarantee_detail_page.dart';
import 'package:dochat_app/pages/services/guarantee_create_page.dart';

class GuaranteeListPage extends StatefulWidget {
  const GuaranteeListPage({super.key});

  @override
  State<GuaranteeListPage> createState() => _GuaranteeListPageState();
}

class _GuaranteeListPageState extends State<GuaranteeListPage> {
  int _selectedTab = 0;

  String? _statusFromTab(int tab) {
    switch (tab) {
      case 1: return 'pending';
      case 2: return 'completed';
      case 3: return 'cancelled';
      default: return null;
    }
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<GuaranteeProvider>().loadTradeList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.guarantee),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (_) => const GuaranteeCreatePage()),
            );
          },
          child: const Icon(CupertinoIcons.add, color: CupertinoColors.activeBlue),
        ),
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
                    context.read<GuaranteeProvider>().loadTradeList(status: _statusFromTab(v));
                  }
                },
                children: {
                  0: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text(l10n.all),
                  ),
                  1: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text(l10n.active),
                  ),
                  2: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text(l10n.completed),
                  ),
                  3: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text(l10n.closed),
                  ),
                },
              ),
            ),
            Expanded(
              child: Consumer<GuaranteeProvider>(
                builder: (context, provider, _) {
                  if (provider.isLoading) {
                    return const Center(child: CupertinoActivityIndicator());
                  }
                  if (provider.trades.isEmpty) {
                    return Center(child: Text(l10n.noTrades));
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: provider.trades.length,
                    itemBuilder: (context, index) {
                      final trade = provider.trades[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (_) => GuaranteeDetailPage(tradeId: trade.tradeId),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(14),
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
                                      Text(
                                        trade.productName,
                                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '¥${trade.amount.toStringAsFixed(2)}',
                                        style: const TextStyle(fontSize: 16, color: Color(0xFFFF3B30), fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        trade.productDesc,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 12, color: CupertinoColors.systemGrey),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _statusColor(trade.status).withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    trade.status,
                                    style: TextStyle(fontSize: 11, color: _statusColor(trade.status), fontWeight: FontWeight.w600),
                                  ),
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

  Color _statusColor(String status) {
    switch (status) {
      case 'pending': return CupertinoColors.systemOrange;
      case 'confirmed':
      case 'frozen':
      case 'verifying': return CupertinoColors.activeBlue;
      case 'verified': return CupertinoColors.systemGreen;
      case 'completed': return const Color(0xFF34C759);
      case 'cancelled': return CupertinoColors.systemGrey;
      case 'disputed': return CupertinoColors.destructiveRed;
      default: return CupertinoColors.systemGrey;
    }
  }
}
