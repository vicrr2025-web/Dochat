import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/models/home_models.dart';
import 'package:dochat_app/providers/home_provider.dart';
import 'package:dochat_app/pages/homes/home_order_tracking_page.dart';

class HomeOrderCreatePage extends StatefulWidget {
  final HomeServiceItem service;
  final HomeWorker? worker;
  const HomeOrderCreatePage({super.key, required this.service, this.worker});

  @override
  State<HomeOrderCreatePage> createState() => _HomeOrderCreatePageState();
}

class _HomeOrderCreatePageState extends State<HomeOrderCreatePage> {
  final TextEditingController _addressController = TextEditingController();
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  late FixedExtentScrollController _hourController;

  @override
  void initState() {
    super.initState();
    _hourController = FixedExtentScrollController(initialItem: 9);
  }

  @override
  void dispose() {
    _addressController.dispose();
    _hourController.dispose();
    super.dispose();
  }

  void _showDatePicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 260,
        color: CupertinoColors.systemBackground,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              alignment: Alignment.centerRight,
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  setState(() {
                    _selectedDate = _selectedDate;
                  });
                  Navigator.pop(context);
                },
                child: const Text('', style: TextStyle(fontSize: 16)),
              ),
            ),
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: _selectedDate,
                minimumDate: DateTime.now(),
                onDateTimeChanged: (date) {
                  _selectedDate = date;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitOrder() async {
    if (_addressController.text.trim().isEmpty) return;

    final dateStr = '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}';
    final hour = _hourController.selectedItem + 8;
    final timeStr = '$dateStr ${hour.toString().padLeft(2, '0')}:00';

    final provider = context.read<HomeProvider>();
    final success = await provider.createOrder({
      'serviceId': widget.service.serviceId,
      'address': _addressController.text.trim(),
      'appointmentTime': timeStr,
      'price': widget.service.fixedPrice ?? widget.service.basePrice ?? 0,
      if (widget.worker != null) 'workerId': widget.worker!.workerId,
    });

    if (success && mounted) {
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (_) => const HomeOrderTrackingPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.homeService),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              decoration: BoxDecoration(
                color: CupertinoColors.systemBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: CupertinoColors.systemGrey5, width: 0.5),
              ),
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.workerInfo,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1C1C1E)),
                  ),
                  const SizedBox(height: 10),
                  if (widget.worker != null)
                    Row(
                      children: [
                        ClipOval(
                          child: Container(
                            width: 40,
                            height: 40,
                            color: const Color(0xFF5AC8FA).withOpacity(0.2),
                            child: const Center(
                              child: Icon(CupertinoIcons.person_fill, size: 20, color: Color(0xFF5AC8FA)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.worker!.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                              Text(
                                '${l10n.creditScore}: ${widget.worker!.creditScore.toStringAsFixed(0)}',
                                style: const TextStyle(fontSize: 12, color: CupertinoColors.systemGrey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  else
                    Text(l10n.noWorkerHint, style: const TextStyle(fontSize: 13, color: CupertinoColors.systemGrey)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: CupertinoColors.systemBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: CupertinoColors.systemGrey5, width: 0.5),
              ),
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.homeService,
                    style: const TextStyle(fontSize: 13, color: CupertinoColors.systemGrey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.service.name,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF1C1C1E)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: CupertinoColors.systemBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: CupertinoColors.systemGrey5, width: 0.5),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: CupertinoTextField(
                controller: _addressController,
                placeholder: '',
                maxLines: 2,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: const BoxDecoration(color: CupertinoColors.systemBackground),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: CupertinoColors.systemBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: CupertinoColors.systemGrey5, width: 0.5),
              ),
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.appointmentTime,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1C1C1E)),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: _showDatePicker,
                    child: Row(
                      children: [
                        const Icon(CupertinoIcons.calendar, size: 20, color: CupertinoColors.systemGrey),
                        const SizedBox(width: 8),
                        Text(
                          '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}',
                          style: const TextStyle(fontSize: 15, color: Color(0xFF1C1C1E)),
                        ),
                        const Spacer(),
                        const Icon(CupertinoIcons.chevron_right, size: 16, color: CupertinoColors.systemGrey3),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 100,
                    child: CupertinoPicker(
                      scrollController: _hourController,
                      itemExtent: 32,
                      onSelectedItemChanged: (index) {},
                      children: List.generate(14, (i) {
                        final h = i + 8;
                        return Center(
                          child: Text(
                            '${h.toString().padLeft(2, '0')}:00',
                            style: const TextStyle(fontSize: 18),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (widget.service.priceType == 'fixed' && widget.service.fixedPrice != null)
              Container(
                decoration: BoxDecoration(
                  color: CupertinoColors.systemBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: CupertinoColors.systemGrey5, width: 0.5),
                ),
                padding: const EdgeInsets.all(14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(l10n.estimatePrice, style: const TextStyle(fontSize: 15, color: Color(0xFF1C1C1E))),
                    Text(
                      '¥${widget.service.fixedPrice!.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFFFF3B30)),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 24),
            CupertinoButton.filled(
              onPressed: _submitOrder,
              child: Text(l10n.confirm),
            ),
          ],
        ),
      ),
    );
  }
}
