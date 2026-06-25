import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/providers/house_provider.dart';

class HouseRenovationPage extends StatefulWidget {
  const HouseRenovationPage({super.key});

  @override
  State<HouseRenovationPage> createState() => _HouseRenovationPageState();
}

class _HouseRenovationPageState extends State<HouseRenovationPage> {
  final _areaController = TextEditingController();
  String _renovationType = '全屋';

  final _renovationTypes = ['全屋', '厨房', '卫生间', '客厅', '卧室'];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<HouseProvider>().loadRenovationCompanies();
    });
  }

  @override
  void dispose() {
    _areaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.renovationService),
      ),
      child: SafeArea(
        child: Consumer<HouseProvider>(
          builder: (context, provider, _) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: CupertinoColors.systemGrey5, width: 0.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(CupertinoIcons.wrench_fill,
                                size: 20, color: Color(0xFF34C759)),
                            const SizedBox(width: 8),
                            Text(
                              l10n.renovationEstimate,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1C1C1E),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        CupertinoTextField(
                          controller: _areaController,
                          placeholder: l10n.houseArea,
                          keyboardType: TextInputType.number,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2F2F7),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: () {
                            showCupertinoModalPopup(
                              context: context,
                              builder: (_) => Container(
                                height: 260,
                                decoration: const BoxDecoration(
                                  color: CupertinoColors.systemBackground,
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(12)),
                                ),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 8),
                                    Container(
                                      width: 36,
                                      height: 4,
                                      decoration: BoxDecoration(
                                        color: CupertinoColors.systemGrey3,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                    Expanded(
                                      child: CupertinoPicker(
                                        itemExtent: 44,
                                        onSelectedItemChanged: (i) {
                                          setState(() =>
                                              _renovationType =
                                                  _renovationTypes[i]);
                                        },
                                        children: _renovationTypes
                                            .map((t) => Center(child: Text(t)))
                                            .toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF2F2F7),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _renovationType,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF1C1C1E)),
                                ),
                                const Icon(CupertinoIcons.chevron_down,
                                    size: 18, color: Color(0xFF8E8E93)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        CupertinoButton(
                          color: const Color(0xFF34C759),
                          borderRadius: BorderRadius.circular(8),
                          child: Text(l10n.recycleEstimate),
                          onPressed: () {
                            final area =
                                double.tryParse(_areaController.text);
                            if (area != null) {
                              provider.renovationEstimate({
                                'area': area,
                                'type': _renovationType,
                              });
                            }
                          },
                        ),
                        if (provider.renovationResult != null) ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF2F2F7),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '预估费用: ${provider.renovationResult!['estimatedCost'] ?? '--'} 元',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF34C759),
                                  ),
                                ),
                                if (provider.renovationResult!['duration'] !=
                                    null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      '预计工期: ${provider.renovationResult!['duration']}',
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
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Text(
                      '装修公司',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1C1C1E),
                      ),
                    ),
                  ),
                ),
                if (provider.isLoading)
                  const SliverToBoxAdapter(
                    child: Center(child: CupertinoActivityIndicator()),
                  )
                else if (provider.renovationCompanies.isEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Center(
                        child: Text(
                          '暂无装修公司',
                          style: const TextStyle(
                            fontSize: 14,
                            color: CupertinoColors.systemGrey,
                          ),
                        ),
                      ),
                    ),
                  )
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final company =
                            provider.renovationCompanies[index];
                        return _buildCompanyCard(company);
                      },
                      childCount: provider.renovationCompanies.length,
                    ),
                  ),
                const SliverToBoxAdapter(child: SizedBox(height: 32)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCompanyCard(Map<String, dynamic> company) {
    final name = company['name'] as String? ?? '--';
    final rating = (company['rating'] as num?)?.toDouble() ?? 0.0;
    final services = company['services'] as String? ?? '';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: Color(0xFFE5E5EA),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(CupertinoIcons.building_2_fill,
                      size: 24, color: CupertinoColors.systemGrey3),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1C1C1E),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: List.generate(5, (i) {
                        return Icon(
                          i < rating.floor()
                              ? CupertinoIcons.star_fill
                              : CupertinoIcons.star,
                          size: 14,
                          color: const Color(0xFFFF9500),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              const Icon(CupertinoIcons.forward, size: 18,
                  color: Color(0xFFC7C7CC)),
            ],
          ),
          if (services.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              services,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF8E8E93),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
