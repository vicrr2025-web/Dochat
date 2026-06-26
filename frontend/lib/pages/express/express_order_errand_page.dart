import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/providers/express_provider.dart';
import 'package:dochat_app/pages/express/express_tracking_page.dart';

class ExpressOrderErrandPage extends StatefulWidget {
  const ExpressOrderErrandPage({super.key});

  @override
  State<ExpressOrderErrandPage> createState() => _ExpressOrderErrandPageState();
}

class _ExpressOrderErrandPageState extends State<ExpressOrderErrandPage> {
  final _originController = TextEditingController();
  final _destController = TextEditingController();
  final _descController = TextEditingController();
  String _itemType = '\u6587\u4EF6';
  bool _submitting = false;

  @override
  void dispose() {
    _originController.dispose();
    _destController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.expressErrand),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _field(l10n.originAddress, _originController),
              const SizedBox(height: 10),
              _field(l10n.destAddress, _destController),
              const SizedBox(height: 14),
              Text(
                '\u7269\u54C1\u7C7B\u578B',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1C1C1E),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  _typeChip('\u6587\u4EF6'),
                  _typeChip('\u9910\u996E'),
                  _typeChip('\u65E5\u7528\u54C1'),
                  _typeChip('\u5176\u4ED6'),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: CupertinoColors.systemGrey5, width: 0.5),
                ),
                child: CupertinoTextField(
                  controller: _descController,
                  placeholder: '\u7269\u54C1\u63CF\u8FF0',
                  maxLines: 3,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const BoxDecoration(),
                  style: const TextStyle(fontSize: 15),
                ),
              ),
              const SizedBox(height: 24),
              CupertinoButton.filled(
                onPressed: _submitting
                    ? null
                    : () async {
                        setState(() => _submitting = true);
                        final provider = context.read<ExpressProvider>();
                        final ok = await provider.createOrder({
                          'type': 'errand',
                          'originAddress': _originController.text,
                          'originLat': 0.0,
                          'originLng': 0.0,
                          'destAddress': _destController.text,
                          'destLat': 0.0,
                          'destLng': 0.0,
                          'cargoInfo': '${_itemType}: ${_descController.text}',
                          'insured': false,
                          'insuranceFee': 0.0,
                        });
                        setState(() => _submitting = false);
                        if (ok && mounted) {
                          Navigator.pushReplacement(
                            context,
                            CupertinoPageRoute(
                              builder: (_) => ExpressTrackingPage(
                                orderId: provider.currentOrder!.orderId,
                              ),
                            ),
                          );
                        }
                      },
                child: Text(_submitting ? l10n.loading : '\u53D1\u5355'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(String hint, TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: CupertinoColors.systemGrey5, width: 0.5),
      ),
      child: CupertinoTextField(
        controller: controller,
        placeholder: hint,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: const BoxDecoration(),
        style: const TextStyle(fontSize: 15),
      ),
    );
  }

  Widget _typeChip(String label) {
    final selected = _itemType == label;
    return GestureDetector(
      onTap: () => setState(() => _itemType = label),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF34C759) : CupertinoColors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? const Color(0xFF34C759) : CupertinoColors.systemGrey5,
            width: 0.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: selected ? CupertinoColors.white : const Color(0xFF1C1C1E),
          ),
        ),
      ),
    );
  }
}
