import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/providers/house_provider.dart';
import 'package:dochat_app/providers/chat_provider.dart';
import 'package:dochat_app/pages/chat/chat_page.dart';

class HouseDetailPage extends StatefulWidget {
  final String houseId;

  const HouseDetailPage({super.key, required this.houseId});

  @override
  State<HouseDetailPage> createState() => _HouseDetailPageState();
}

class _HouseDetailPageState extends State<HouseDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final provider = context.read<HouseProvider>();
      provider.loadHouseDetail(widget.houseId);
      provider.loadCommunityInfo(widget.houseId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Consumer<HouseProvider>(
          builder: (context, provider, _) {
            return Text(provider.currentHouse?.title ?? l10n.houseTab);
          },
        ),
      ),
      child: Consumer<HouseProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.currentHouse == null) {
            return const Center(child: CupertinoActivityIndicator());
          }

          final house = provider.currentHouse;
          if (house == null) {
            return Center(
              child: Text(
                l10n.noHouseHint,
                style: const TextStyle(color: CupertinoColors.systemGrey),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: SafeArea(
                  top: false,
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: _buildImageCarousel(),
                      ),
                      SliverToBoxAdapter(
                        child: _buildPriceSection(l10n, house),
                      ),
                      SliverToBoxAdapter(
                        child: _buildInfoGrid(l10n, house),
                      ),
                      if (house.description != null &&
                          house.description!.isNotEmpty)
                        SliverToBoxAdapter(
                          child: _buildDescriptionSection(house),
                        ),
                      if (provider.communityInfo != null)
                        SliverToBoxAdapter(
                          child: _buildCommunitySection(
                              l10n, provider.communityInfo!),
                        ),
                      const SliverToBoxAdapter(
                          child: SizedBox(height: 16)),
                    ],
                  ),
                ),
              ),
              _buildBottomBar(l10n, provider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBottomBar(AppLocalizations l10n, HouseProvider provider) {
    return Container(
      decoration: const BoxDecoration(
        color: CupertinoColors.systemBackground,
        border: Border(
          top: BorderSide(color: CupertinoColors.systemGrey5, width: 0.5),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _onChatTap(provider.currentHouse),
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFF007AFF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      l10n.microChat,
                      style: const TextStyle(
                        color: CupertinoColors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                if (provider.currentHouse != null) {
                  provider.toggleFavorite(provider.currentHouse!.houseId);
                  showCupertinoDialog(
                    context: context,
                    builder: (_) => CupertinoAlertDialog(
                      title: Text(l10n.addFavorite),
                      content: const Text('✅'),
                      actions: [
                        CupertinoDialogAction(
                          child: Text(l10n.confirm),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: Container(
                height: 44,
                width: 60,
                decoration: BoxDecoration(
                  color: CupertinoColors.systemBackground,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: CupertinoColors.systemGrey5,
                    width: 0.5,
                  ),
                ),
                child: const Icon(CupertinoIcons.star, size: 22,
                    color: Color(0xFFFF9500)),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                _showAppointmentSheet(l10n, provider);
              },
              child: Container(
                height: 44,
                width: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFF34C759),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    l10n.appointmentViewing,
                    style: const TextStyle(
                      color: CupertinoColors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageCarousel() {
    return SizedBox(
      height: 240,
      child: PageView(
        children: List.generate(
          4,
          (_) => Container(
            margin: const EdgeInsets.only(right: 2),
            color: const Color(0xFFE5E5EA),
            child: const Center(
              child: Icon(CupertinoIcons.photo, size: 64,
                  color: CupertinoColors.systemGrey3),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPriceSection(AppLocalizations l10n, dynamic house) {
    final price = house.price?.toString() ?? '--';
    final unitPrice = house.price != null &&
            house.area != null &&
            house.area! > 0
        ? (house.price! / house.area!).toStringAsFixed(0)
        : '--';

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$price',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFFF3B30),
                ),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  house.priceUnit ?? '',
                  style:
                      const TextStyle(fontSize: 14, color: Color(0xFF8E8E93)),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  '${l10n.unitPriceLabel} $unitPrice 元/m²',
                  style:
                      const TextStyle(fontSize: 13, color: Color(0xFF8E8E93)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            house.communityName ?? '',
            style: const TextStyle(fontSize: 14, color: Color(0xFF3C3C43)),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoGrid(AppLocalizations l10n, dynamic house) {
    final items = [
      _InfoItem(l10n.houseLayout, house.layout ?? '--'),
      _InfoItem(
          l10n.houseArea, '${house.area?.toStringAsFixed(0) ?? '--'}m²'),
      _InfoItem(l10n.houseDirection, house.direction ?? '--'),
      _InfoItem(l10n.houseFloor, house.floorInfo ?? '--'),
      _InfoItem(l10n.houseDecoration, house.decoration ?? '--'),
      _InfoItem(l10n.houseType, house.type ?? '--'),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CupertinoColors.systemGrey5, width: 0.5),
      ),
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            if (i > 0)
              Container(
                  height: 1, color: CupertinoColors.systemGrey5),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    items[i].label,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF8E8E93),
                    ),
                  ),
                  Text(
                    items[i].value,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1C1C1E),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(dynamic house) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '房源描述',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1C1C1E),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            house.description ?? '',
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF3C3C43),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommunitySection(
      AppLocalizations l10n, Map<String, dynamic> info) {
    return Container(
      margin: const EdgeInsets.all(16),
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
              const Icon(CupertinoIcons.building_2_fill,
                  size: 20, color: Color(0xFF007AFF)),
              const SizedBox(width: 8),
              Text(
                l10n.communityInfo,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1C1C1E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildCommunityRow('小区名称', info['communityName']?.toString() ?? '--'),
          _buildCommunityRow('建造年份', info['builtYear']?.toString() ?? '--'),
          _buildCommunityRow('物业费', info['propertyFee']?.toString() ?? '--'),
          _buildCommunityRow('停车位', info['parkingRate']?.toString() ?? '--'),
          _buildCommunityRow('绿化率', info['greenRate']?.toString() ?? '--'),
        ],
      ),
    );
  }

  Widget _buildCommunityRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style:
                  const TextStyle(fontSize: 13, color: Color(0xFF8E8E93))),
          Text(value,
              style:
                  const TextStyle(fontSize: 13, color: Color(0xFF1C1C1E))),
        ],
      ),
    );
  }

  void _onChatTap(dynamic house) {
    if (house == null) return;
    final chatProvider = context.read<ChatProvider>();
    chatProvider.createSession(house.publisherId).then((session) {
      if (!mounted) return;
      Navigator.of(context).push(
        CupertinoPageRoute(
          builder: (_) => ChatPage(session: session),
        ),
      );
    }).catchError((_) {});
  }

  void _showAppointmentSheet(AppLocalizations l10n, HouseProvider provider) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();

    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 400,
        decoration: const BoxDecoration(
          color: CupertinoColors.systemBackground,
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemGrey3,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.appointmentViewing,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                CupertinoTextField(
                  controller: nameController,
                  placeholder: l10n.contactLandlord,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F2F7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 12),
                CupertinoTextField(
                  controller: phoneController,
                  placeholder: l10n.phoneNumber,
                  keyboardType: TextInputType.phone,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F2F7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const Spacer(),
                CupertinoButton.filled(
                  child: const Text('提交'),
                  onPressed: () {
                    final house = provider.currentHouse;
                    if (house != null) {
                      provider.createAppointment({
                        'houseId': house.houseId,
                        'contactName': nameController.text,
                        'contactPhone': phoneController.text,
                      });
                    }
                    Navigator.pop(context);
                    showCupertinoDialog(
                      context: context,
                      builder: (_) => CupertinoAlertDialog(
                        title: Text(l10n.appointmentViewing),
                        content: const Text('✅'),
                        actions: [
                          CupertinoDialogAction(
                            child: Text(l10n.confirm),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoItem {
  final String label;
  final String value;
  const _InfoItem(this.label, this.value);
}
