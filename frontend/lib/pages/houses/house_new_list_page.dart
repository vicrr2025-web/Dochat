import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/providers/house_provider.dart';
import 'package:dochat_app/pages/houses/house_detail_page.dart';

class HouseNewListPage extends StatefulWidget {
  const HouseNewListPage({super.key});

  @override
  State<HouseNewListPage> createState() => _HouseNewListPageState();
}

class _HouseNewListPageState extends State<HouseNewListPage> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedRegion;

  final _regions = ['全城', '朝阳', '海淀', '丰台', '通州', '大兴', '昌平', '顺义'];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<HouseProvider>().loadNewHouses();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.newHouse),
      ),
      child: SafeArea(
        child: Consumer<HouseProvider>(
          builder: (context, provider, _) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5E5EA),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Icon(CupertinoIcons.search, size: 18,
                                color: Color(0xFF8E8E93)),
                          ),
                          Expanded(
                            child: CupertinoTextField(
                              controller: _searchController,
                              placeholder: l10n.newHouse,
                              decoration: const BoxDecoration(
                                color: Color(0x00000000),
                              ),
                              style: const TextStyle(fontSize: 14),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 40,
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _regions.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final region = _regions[index];
                        final selected = _selectedRegion == region ||
                            (_selectedRegion == null && region == '全城');
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedRegion =
                                  region == '全城' ? null : region;
                            });
                            context.read<HouseProvider>().loadNewHouses(
                              region: _selectedRegion,
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: selected
                                  ? const Color(0xFF007AFF)
                                  : CupertinoColors.systemBackground,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: selected
                                    ? const Color(0xFF007AFF)
                                    : CupertinoColors.systemGrey5,
                                width: 0.5,
                              ),
                            ),
                            child: Text(
                              region,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: selected
                                    ? CupertinoColors.white
                                    : const Color(0xFF3C3C43),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 12)),
                if (provider.isLoading)
                  const SliverToBoxAdapter(
                    child: Center(child: CupertinoActivityIndicator()),
                  )
                else if (provider.newHouses.isEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(48),
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
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final house = provider.newHouses[index];
                        return _buildHouseRow(l10n, house);
                      },
                      childCount: provider.newHouses.length,
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHouseRow(AppLocalizations l10n, dynamic house) {
    final title = house.title ?? l10n.noHouseHint;
    final price = house.price?.toString() ?? '--';
    final layout = house.layout ?? '';
    final area = house.area?.toStringAsFixed(0) ?? '--';

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (_) => HouseDetailPage(houseId: house.houseId),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: CupertinoColors.systemGrey5,
            width: 0.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: Color(0xFFE5E5EA),
                borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(12)),
              ),
              child: const Center(
                child: Icon(CupertinoIcons.photo, size: 36,
                    color: CupertinoColors.systemGrey3),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1C1C1E),
                      ),
                    ),
                    const SizedBox(height: 8),
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
