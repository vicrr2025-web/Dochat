import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/providers/house_provider.dart';
import 'package:dochat_app/pages/houses/house_detail_page.dart';

class HouseSecondListPage extends StatefulWidget {
  const HouseSecondListPage({super.key});

  @override
  State<HouseSecondListPage> createState() => _HouseSecondListPageState();
}

class _HouseSecondListPageState extends State<HouseSecondListPage> {
  final TextEditingController _searchController = TextEditingController();
  String? _regionFilter;
  String? _priceFilter;
  String? _layoutFilter;
  String? _areaFilter;

  final _regions = ['区域', '朝阳', '海淀', '丰台', '通州'];
  final _prices = ['价格', '100万以下', '100-200万', '200-300万', '300-500万', '500万以上'];
  final _layouts = ['户型', '一室', '两室', '三室', '四室+'];
  final _areas = ['面积', '50m²以下', '50-90m²', '90-120m²', '120m²以上'];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<HouseProvider>().loadSecondHouses();
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
        middle: Text(l10n.secondHouse),
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
                              placeholder: l10n.secondHouse,
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
                  child: Container(
                    height: 150,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E5EA),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(CupertinoIcons.map, size: 40,
                              color: Color(0xFF8E8E93)),
                          SizedBox(height: 8),
                          Text(
                            '地图模式 (Mock)',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF8E8E93),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip(_regionFilter, _regions, (v) {
                            setState(() => _regionFilter = v == '区域' ? null : v);
                          }),
                          const SizedBox(width: 8),
                          _buildFilterChip(_priceFilter, _prices, (v) {
                            setState(() => _priceFilter = v == '价格' ? null : v);
                          }),
                          const SizedBox(width: 8),
                          _buildFilterChip(_layoutFilter, _layouts, (v) {
                            setState(() => _layoutFilter = v == '户型' ? null : v);
                          }),
                          const SizedBox(width: 8),
                          _buildFilterChip(_areaFilter, _areas, (v) {
                            setState(() => _areaFilter = v == '面积' ? null : v);
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 8)),
                if (provider.isLoading)
                  const SliverToBoxAdapter(
                    child: Center(child: CupertinoActivityIndicator()),
                  )
                else if (provider.secondHouses.isEmpty)
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
                        final house = provider.secondHouses[index];
                        return _buildHouseRow(l10n, house);
                      },
                      childCount: provider.secondHouses.length,
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildFilterChip(String? current, List<String> options,
      void Function(String) onSelect) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      minSize: 0,
      color: current != null ? const Color(0xFF007AFF) : CupertinoColors.systemBackground,
      borderRadius: BorderRadius.circular(16),
      onPressed: () {
        showCupertinoModalPopup(
          context: context,
          builder: (_) => Container(
            height: 260,
            decoration: const BoxDecoration(
              color: CupertinoColors.systemBackground,
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
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
                    onSelectedItemChanged: (i) => onSelect(options[i]),
                    children: options.map((o) => Center(child: Text(o))).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      child: Text(
        current ?? options.first,
        style: TextStyle(
          fontSize: 13,
          color: current != null ? CupertinoColors.white : const Color(0xFF3C3C43),
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
                borderRadius: BorderRadius.horizontal(left: Radius.circular(12)),
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
