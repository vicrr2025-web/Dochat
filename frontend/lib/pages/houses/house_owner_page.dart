import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/providers/house_provider.dart';

class HouseOwnerPage extends StatefulWidget {
  const HouseOwnerPage({super.key});

  @override
  State<HouseOwnerPage> createState() => _HouseOwnerPageState();
}

class _HouseOwnerPageState extends State<HouseOwnerPage> {
  final _valuationAreaController = TextEditingController();
  final _valuationPriceController = TextEditingController();

  @override
  void dispose() {
    _valuationAreaController.dispose();
    _valuationPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.ownerService),
      ),
      child: SafeArea(
        child: Consumer<HouseProvider>(
          builder: (context, provider, _) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionCard(
                          icon: CupertinoIcons.money_dollar,
                          iconColor: const Color(0xFF007AFF),
                          title: l10n.houseValuation,
                          child: Column(
                            children: [
                              const SizedBox(height: 12),
                              CupertinoTextField(
                                controller: _valuationAreaController,
                                placeholder: l10n.houseArea,
                                keyboardType: TextInputType.number,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF2F2F7),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              const SizedBox(height: 8),
                              CupertinoTextField(
                                controller: _valuationPriceController,
                                placeholder: l10n.housePrice,
                                keyboardType: TextInputType.number,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF2F2F7),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              const SizedBox(height: 12),
                              CupertinoButton(
                                color: const Color(0xFF007AFF),
                                borderRadius: BorderRadius.circular(8),
                                child: Text(l10n.recycleEstimate),
                                onPressed: () {
                                  final area = double.tryParse(
                                      _valuationAreaController.text);
                                  final price = double.tryParse(
                                      _valuationPriceController.text);
                                  if (area != null && price != null) {
                                    provider.evaluateHouse({
                                      'area': area,
                                      'price': price,
                                    });
                                  }
                                },
                              ),
                              if (provider.valuationResult != null) ...[
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF2F2F7),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '估价结果: ${provider.valuationResult!['estimatedPrice'] ?? '--'} 万元',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFFFF3B30),
                                        ),
                                      ),
                                      if (provider.valuationResult!['priceRange'] != null)
                                        Padding(
                                          padding: const EdgeInsets.only(top: 4),
                                          child: Text(
                                            '参考区间: ${provider.valuationResult!['priceRange']}',
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Color(0xFF8E8E93),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildSectionCard(
                          icon: CupertinoIcons.bolt_fill,
                          iconColor: const Color(0xFFFF9500),
                          title: l10n.quickSell,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              const Text(
                                '快速卖房服务，专业经纪人一对一服务，助您快速成交。',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF3C3C43),
                                ),
                              ),
                              const SizedBox(height: 12),
                              CupertinoButton(
                                color: const Color(0xFFFF9500),
                                borderRadius: BorderRadius.circular(8),
                                child: Text(l10n.quickSell),
                                onPressed: () {
                                  showCupertinoDialog(
                                    context: context,
                                    builder: (_) => CupertinoAlertDialog(
                                      title: Text(l10n.quickSell),
                                      content: const Text('✅ 已提交快速卖房申请'),
                                      actions: [
                                        CupertinoDialogAction(
                                          child: Text(l10n.confirm),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildSectionCard(
                          icon: CupertinoIcons.star_fill,
                          iconColor: const Color(0xFFAF52DE),
                          title: l10n.sellVip,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0x33AF52DE),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      provider.vipInfo != null
                                          ? 'VIP ${provider.vipInfo!['level'] ?? 1}'
                                          : '未开通',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFFAF52DE),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  if (provider.vipInfo != null)
                                    Text(
                                      '到期: ${provider.vipInfo!['expiresAt'] ?? '--'}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF8E8E93),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'VIP会员享优先展示、专属推广、数据分析等特权',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF3C3C43),
                                ),
                              ),
                              const SizedBox(height: 12),
                              CupertinoButton(
                                color: const Color(0xFFAF52DE),
                                borderRadius: BorderRadius.circular(8),
                                child: Text(
                                  provider.vipInfo != null ? '续费VIP' : '开通VIP',
                                ),
                                onPressed: () {
                                  provider.upgradeVip().then((_) {
                                    if (!mounted) return;
                                    showCupertinoDialog(
                                      context: context,
                                      builder: (_) => CupertinoAlertDialog(
                                        title: Text(l10n.sellVip),
                                        content: const Text('✅'),
                                        actions: [
                                          CupertinoDialogAction(
                                            child: Text(l10n.confirm),
                                            onPressed: () =>
                                                Navigator.pop(context),
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
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

  Widget _buildSectionCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CupertinoColors.systemGrey5, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: iconColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1C1C1E),
                ),
              ),
            ],
          ),
          child,
        ],
      ),
    );
  }
}
