import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/providers/house_provider.dart';

class HousePublishPage extends StatefulWidget {
  const HousePublishPage({super.key});

  @override
  State<HousePublishPage> createState() => _HousePublishPageState();
}

class _HousePublishPageState extends State<HousePublishPage> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _areaController = TextEditingController();
  final _priceController = TextEditingController();
  final _layoutController = TextEditingController();
  final _floorController = TextEditingController();
  final _communityController = TextEditingController();
  final _addressController = TextEditingController();

  String _type = '新房';
  String _direction = '南';
  String _decoration = '毛坯';
  String _priceUnit = '元/m²';

  final _types = ['新房', '二手房', '租房', '商业地产'];
  final _directions = ['南', '北', '东', '西', '南北', '东西'];
  final _decorations = ['毛坯', '简装', '精装', '豪装'];
  final _priceUnits = ['元/m²', '万元/套', '元/月'];

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _areaController.dispose();
    _priceController.dispose();
    _layoutController.dispose();
    _floorController.dispose();
    _communityController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.publishHouse),
      ),
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel(l10n.houseType),
                    _buildPickerField(l10n.houseType, _type, _types, (v) {
                      setState(() => _type = v);
                    }),
                    const SizedBox(height: 16),
                    _buildLabel(l10n.publishHouseTitle),
                    CupertinoTextField(
                      controller: _titleController,
                      placeholder: l10n.publishHouseTitle,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F2F7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        if (_descController.text.isNotEmpty) {
                          showCupertinoDialog(
                            context: context,
                            builder: (_) => CupertinoAlertDialog(
                              title: Text(l10n.aiTitle),
                              content: Text(
                                '${l10n.aiTitle}: ${_descController.text.substring(0, _descController.text.length.clamp(0, 30))}...',
                              ),
                              actions: [
                                CupertinoDialogAction(
                                  child: Text(l10n.confirm),
                                  onPressed: () {
                                    _titleController.text =
                                        '精装好房 - ${_descController.text.length > 20 ? _descController.text.substring(0, 20) : _descController.text}';
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0x1A007AFF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(CupertinoIcons.wand_stars,
                                size: 16, color: Color(0xFF007AFF)),
                            const SizedBox(width: 6),
                            Text(
                              l10n.aiTitle,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF007AFF),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildLabel(l10n.productDesc),
                    CupertinoTextField(
                      controller: _descController,
                      placeholder: l10n.productDesc,
                      maxLines: 4,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F2F7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel(l10n.houseArea),
                              CupertinoTextField(
                                controller: _areaController,
                                placeholder: 'm²',
                                keyboardType: TextInputType.number,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF2F2F7),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel(l10n.housePrice),
                              CupertinoTextField(
                                controller: _priceController,
                                placeholder: '0',
                                keyboardType: TextInputType.number,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF2F2F7),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildPickerField(
                        l10n.unitPriceLabel, _priceUnit, _priceUnits, (v) {
                      setState(() => _priceUnit = v);
                    }),
                    const SizedBox(height: 16),
                    _buildLabel(l10n.houseLayout),
                    CupertinoTextField(
                      controller: _layoutController,
                      placeholder: '3室2厅',
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F2F7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildLabel(l10n.houseFloor),
                    CupertinoTextField(
                      controller: _floorController,
                      placeholder: '中层/28层',
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F2F7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildPickerField(l10n.houseDirection, _direction,
                        _directions, (v) {
                      setState(() => _direction = v);
                    }),
                    const SizedBox(height: 16),
                    _buildPickerField(l10n.houseDecoration, _decoration,
                        _decorations, (v) {
                      setState(() => _decoration = v);
                    }),
                    const SizedBox(height: 16),
                    _buildLabel('小区名称'),
                    CupertinoTextField(
                      controller: _communityController,
                      placeholder: '小区名称',
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F2F7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildLabel('地址'),
                    CupertinoTextField(
                      controller: _addressController,
                      placeholder: '地址',
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F2F7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildLabel(l10n.productImages),
                    SizedBox(
                      height: 80,
                      child: Row(
                        children: [
                          ...List.generate(3, (i) {
                            return Container(
                              width: 80,
                              height: 80,
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE5E5EA),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Center(
                                child: Icon(CupertinoIcons.photo, size: 28,
                                    color: CupertinoColors.systemGrey3),
                              ),
                            );
                          }),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: CupertinoColors.systemBackground,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: CupertinoColors.systemGrey5,
                                  width: 1,
                                  strokeAlign: BorderSide.strokeAlignInside,
                                ),
                              ),
                              child: const Center(
                                child: Icon(CupertinoIcons.add, size: 28,
                                    color: Color(0xFF8E8E93)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    CupertinoButton.filled(
                      child: Text(l10n.publishProduct),
                      onPressed: () async {
                        final body = {
                          'type': _type,
                          'title': _titleController.text,
                          'description': _descController.text,
                          'area': double.tryParse(_areaController.text),
                          'price': double.tryParse(_priceController.text),
                          'priceUnit': _priceUnit,
                          'layout': _layoutController.text,
                          'floorInfo': _floorController.text,
                          'direction': _direction,
                          'decoration': _decoration,
                          'communityName': _communityController.text,
                          'address': _addressController.text,
                        };
                        final ok = await context
                            .read<HouseProvider>()
                            .publishHouse(body);
                        if (!mounted) return;
                        if (ok) {
                          showCupertinoDialog(
                            context: context,
                            builder: (_) => CupertinoAlertDialog(
                              title: Text(l10n.publishProduct),
                              content: const Text('✅'),
                              actions: [
                                CupertinoDialogAction(
                                  child: Text(l10n.confirm),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1C1C1E),
        ),
      ),
    );
  }

  Widget _buildPickerField(String label, String current, List<String> options,
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
                    children: options
                        .map((o) => Center(child: Text(o)))
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              current,
              style: const TextStyle(fontSize: 16, color: Color(0xFF1C1C1E)),
            ),
            const Icon(CupertinoIcons.chevron_down, size: 18,
                color: Color(0xFF8E8E93)),
          ],
        ),
      ),
    );
  }
}
