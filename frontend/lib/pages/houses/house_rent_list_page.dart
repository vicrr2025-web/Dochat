import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/providers/house_provider.dart';
import 'package:dochat_app/pages/houses/house_detail_page.dart';

class HouseRentListPage extends StatefulWidget {
  const HouseRentListPage({super.key});

  @override
  State<HouseRentListPage> createState() => _HouseRentListPageState();
}

class _HouseRentListPageState extends State<HouseRentListPage> {
  int _segmentIndex = 0;
  String? _priceFilter;
  String? _layoutFilter;
  String? _regionFilter;

  final _subTypes = ['整租', '合租', '公寓'];
  final _prices = ['价格', '2000以下', '2000-5000', '5000-10000', '10000以上'];
  final _layouts = ['户型', '一室', '两室', '三室', '四室+'];
  final _regions = ['区域', '朝阳', '海淀', '丰台', '通州'];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<HouseProvider>().loadRentHouses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.rentHouse),
      ),
      child: SafeArea(
        child: Consumer<HouseProvider>(
          builder: (context, provider, _) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                    child: CupertinoSlidingSegmentedControl<int>(
                      groupValue: _segmentIndex,
                      children: {
                        0: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          child: Text(_subTypes[0], style: const TextStyle(fontSize: 14)),
                        ),
                        1: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          child: Text(_subTypes[1], style: const TextStyle(fontSize: 14)),
                        ),
                        2: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          child: Text(_subTypes[2], style: const TextStyle(fontSize: 14)),
                        ),
                      },
                      onValueChanged: (v) {
                        if (v == null) return;
                        setState(() => _segmentIndex = v);
                        context.read<HouseProvider>().loadRentHouses(
                          subType: _subTypes[v],
                        );
                      },
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildChip(_priceFilter, _prices, (v) {
                            setState(() => _priceFilter = v == '价格' ? null : v);
                          }),
                          const SizedBox(width: 8),
                          _buildChip(_layoutFilter, _layouts, (v) {
                            setState(() => _layoutFilter = v == '户型' ? null : v);
                          }),
                          const SizedBox(width: 8),
                          _buildChip(_regionFilter, _regions, (v) {
                            setState(() => _regionFilter = v == '区域' ? null : v);
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 4)),
                if (provider.isLoading)
                  const SliverToBoxAdapter(
                    child: Center(child: CupertinoActivityIndicator()),
                  )
                else if (provider.rentHouses.isEmpty)
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
                        final house = provider.rentHouses[index];
                        return _buildRentRow(l10n, house);
                      },
                      childCount: provider.rentHouses.length,
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildChip(String? current, List<String> options,
      void Function(String) onSelect) {
    return GestureDetector(
      onTap: () {
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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: current != null
              ? const Color(0xFF007AFF)
              : CupertinoColors.systemBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: current != null
                ? const Color(0xFF007AFF)
                : CupertinoColors.systemGrey5,
            width: 0.5,
          ),
        ),
        child: Text(
          current ?? options.first,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: current != null
                ? CupertinoColors.white
                : const Color(0xFF3C3C43),
          ),
        ),
      ),
    );
  }

  Widget _buildRentRow(AppLocalizations l10n, dynamic house) {
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
                            color: Color(0xFFFF9500),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          l10n.monthlyRent,
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
