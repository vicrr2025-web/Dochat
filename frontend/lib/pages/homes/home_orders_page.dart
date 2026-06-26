import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/providers/home_provider.dart';
import 'package:dochat_app/pages/homes/home_order_tracking_page.dart';

class HomeOrdersPage extends StatefulWidget {
  const HomeOrdersPage({super.key});

  @override
  State<HomeOrdersPage> createState() => _HomeOrdersPageState();
}

class _HomeOrdersPageState extends State<HomeOrdersPage> {
  int _selectedSegment = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().loadOrders();
    });
  }

  List<dynamic> _filteredOrders(HomeProvider provider) {
    final statuses = [
      ['waiting', 'accepted', 'dispatched'],
      ['serving'],
      ['completed', 'verified'],
    ];
    return provider.orders
        .where((o) => statuses[_selectedSegment].contains(o.status))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.homeTab),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CupertinoSegmentedControl<int>(
                groupValue: _selectedSegment,
                onValueChanged: (v) => setState(() => _selectedSegment = v),
                children: const {
                  0: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(''),
                  ),
                  1: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(''),
                  ),
                  2: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(''),
                  ),
                },
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Consumer<HomeProvider>(
                builder: (context, provider, _) {
                  if (provider.loading && provider.orders.isEmpty) {
                    return const Center(child: CupertinoActivityIndicator());
                  }

                  final filtered = _filteredOrders(provider);

                  if (filtered.isEmpty) {
                    return Center(
                      child: Text(l10n.noServiceHint, style: const TextStyle(color: CupertinoColors.systemGrey)),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final order = filtered[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: GestureDetector(
                          onTap: () {
                            provider.loadOrderDetail(order.orderId);
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (_) => const HomeOrderTrackingPage(),
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
                                    color: const Color(0xFF5AC8FA).withOpacity(0.15),
                                    child: const Center(
                                      child: Icon(CupertinoIcons.wrench_fill, size: 22, color: Color(0xFF5AC8FA)),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        order.orderId,
                                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF1C1C1E)),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        order.appointmentTime,
                                        style: const TextStyle(fontSize: 12, color: CupertinoColors.systemGrey),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '¥${order.price.toStringAsFixed(2)}',
                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFFFF3B30)),
                                ),
                                const SizedBox(width: 4),
                                const Icon(CupertinoIcons.chevron_right, size: 16, color: CupertinoColors.systemGrey3),
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
}
