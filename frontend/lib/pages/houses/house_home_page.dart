import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/providers/house_provider.dart';
import 'package:dochat_app/pages/houses/house_new_list_page.dart';
import 'package:dochat_app/pages/houses/house_second_list_page.dart';
import 'package:dochat_app/pages/houses/house_rent_list_page.dart';
import 'package:dochat_app/pages/houses/house_commercial_list_page.dart';
import 'package:dochat_app/pages/houses/house_calculator_page.dart';
import 'package:dochat_app/pages/houses/house_renovation_page.dart';
import 'package:dochat_app/pages/houses/house_detail_page.dart';

class HouseHomePage extends StatefulWidget {
  const HouseHomePage({super.key});

  @override
  State<HouseHomePage> createState() => _HouseHomePageState();
}

class _HouseHomePageState extends State<HouseHomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<HouseProvider>().loadNewHouses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.houseTab),
      ),
      child: SafeArea(
        child: Consumer<HouseProvider>(
          builder: (context, provider, _) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: _buildCategoryGrid(l10n),
                ),
                SliverToBoxAdapter(
                  child: _buildQuickActions(l10n),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      l10n.matchRecommend,
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
                else if (provider.newHouses.isEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Center(
                        child: Text(
                          l10n.noHouseHint,
                          style: const TextStyle(
                            fontSize: 14,
                            color: CupertinoColors.systemGrey,
                          ),
                        ),
                      ),
                    ),
                  )
                else
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 240,
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: provider.newHouses.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final house = provider.newHouses[index];
                          return _buildHouseCard(l10n, house);
                        },
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

  Widget _buildCategoryGrid(AppLocalizations l10n) {
    final items = [
      _CategoryItem('🏠', l10n.newHouse, const Color(0xFF007AFF)),
      _CategoryItem('🏘️', l10n.secondHouse, const Color(0xFFFF9500)),
      _CategoryItem('🏢', l10n.rentHouse, const Color(0xFF34C759)),
      _CategoryItem('🏗️', l10n.commercialHouse, const Color(0xFFAF52DE)),
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items.map((item) {
          return GestureDetector(
            onTap: () {
              Widget page;
              switch (item.label) {
                case var l when l == l10n.newHouse:
                  page = const HouseNewListPage();
                  break;
                case var l when l == l10n.secondHouse:
                  page = const HouseSecondListPage();
                  break;
                case var l when l == l10n.rentHouse:
                  page = const HouseRentListPage();
                  break;
                case var l when l == l10n.commercialHouse:
                  page = const HouseCommercialListPage();
                  break;
                default:
                  page = const HouseNewListPage();
              }
              Navigator.of(context).push(
                CupertinoPageRoute(builder: (_) => page),
              );
            },
            child: Container(
              width: 72,
              height: 88,
              decoration: BoxDecoration(
                color: CupertinoColors.systemBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: CupertinoColors.systemGrey5,
                  width: 0.5,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(item.emoji, style: const TextStyle(fontSize: 28)),
                  const SizedBox(height: 6),
                  Text(
                    item.label,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1C1C1E),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildQuickActions(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (_) => const HouseCalculatorPage(),
                  ),
                );
              },
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: CupertinoColors.systemBackground,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: CupertinoColors.systemGrey5,
                    width: 0.5,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(CupertinoIcons.money_dollar,
                        size: 18, color: Color(0xFFFF9500)),
                    const SizedBox(width: 6),
                    Text(
                      l10n.mortgageCalc,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1C1C1E),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (_) => const HouseRenovationPage(),
                  ),
                );
              },
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: CupertinoColors.systemBackground,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: CupertinoColors.systemGrey5,
                    width: 0.5,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(CupertinoIcons.wrench_fill,
                        size: 18, color: Color(0xFF34C759)),
                    const SizedBox(width: 6),
                    Text(
                      l10n.renovationService,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1C1C1E),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHouseCard(AppLocalizations l10n, dynamic house) {
    final title = house.title ?? l10n.noHouseHint;
    final price = house.price?.toString() ?? '--';
    final layout = house.layout ?? '';
    final area = house.area?.toStringAsFixed(0) ?? '--';
    final tags = (house.tags as String?)?.split(',') ?? <String>[];

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (_) => HouseDetailPage(houseId: house.houseId),
          ),
        );
      },
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: CupertinoColors.systemGrey5,
            width: 0.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 130,
              decoration: const BoxDecoration(
                color: Color(0xFFE5E5EA),
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: const Center(
                child: Icon(CupertinoIcons.photo, size: 48,
                    color: CupertinoColors.systemGrey3),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1C1C1E),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        '$price',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFFF3B30),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        house.priceUnit ?? '',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF8E8E93),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$layout  ${area}m²',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF8E8E93),
                    ),
                  ),
                  if (tags.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 4,
                      runSpacing: 2,
                      children: tags.take(3).map((t) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0x33007AFF),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            t.trim(),
                            style: const TextStyle(
                              fontSize: 10,
                              color: Color(0xFF007AFF),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryItem {
  final String emoji;
  final String label;
  final Color color;
  const _CategoryItem(this.emoji, this.label, this.color);
}
