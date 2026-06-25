import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/providers/house_provider.dart';
import 'package:dochat_app/pages/houses/house_detail_page.dart';

class HouseCommercialListPage extends StatefulWidget {
  const HouseCommercialListPage({super.key});

  @override
  State<HouseCommercialListPage> createState() => _HouseCommercialListPageState();
}

class _HouseCommercialListPageState extends State<HouseCommercialListPage> {
  int _segmentIndex = 0;

  final _subTypes = ['商铺', '写字楼', '厂房', '仓库', '土地', '车位'];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<HouseProvider>().loadCommercialHouses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.commercialHouse),
      ),
      child: SafeArea(
        child: Consumer<HouseProvider>(
          builder: (context, provider, _) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                    child: SizedBox(
                      height: 36,
                      child: CupertinoSlidingSegmentedControl<int>(
                        groupValue: _segmentIndex,
                        children: Map.fromEntries(
                          List.generate(_subTypes.length, (i) {
                            return MapEntry(
                              i,
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8),
                                child: Text(
                                  _subTypes[i],
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            );
                          }),
                        ),
                        onValueChanged: (v) {
                          if (v == null) return;
                          setState(() => _segmentIndex = v);
                          context.read<HouseProvider>().loadCommercialHouses(
                            subType: _subTypes[v],
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 4)),
                if (provider.isLoading)
                  const SliverToBoxAdapter(
                    child: Center(child: CupertinoActivityIndicator()),
                  )
                else if (provider.commercialHouses.isEmpty)
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
                        final house = provider.commercialHouses[index];
                        return _buildHouseRow(l10n, house);
                      },
                      childCount: provider.commercialHouses.length,
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
