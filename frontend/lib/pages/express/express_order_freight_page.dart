import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/providers/express_provider.dart';
import 'package:dochat_app/pages/express/express_tracking_page.dart';

class ExpressOrderFreightPage extends StatefulWidget {
  const ExpressOrderFreightPage({super.key});

  @override
  State<ExpressOrderFreightPage> createState() => _ExpressOrderFreightPageState();
}

class _ExpressOrderFreightPageState extends State<ExpressOrderFreightPage> {
  final _originController = TextEditingController();
  final _destController = TextEditingController();
  final _weightController = TextEditingController();
  final _quantityController = TextEditingController();
  String _vehicleType = '\u5C0F\u9762';
  String _cargoType = '\u666E\u901A\u8D27\u7269';
  bool _insured = false;
  bool _submitting = false;

  @override
  void dispose() {
    _originController.dispose();
    _destController.dispose();
    _weightController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.expressFreight),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.selectVehicle,
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
                  _vehicleChip('\u5C0F\u9762'),
                  _vehicleChip('\u4E2D\u9762'),
                  _vehicleChip('4.2\u7C73'),
                  _vehicleChip('6.8\u7C73'),
                ],
              ),
              const SizedBox(height: 14),
              _field(l10n.originAddress, _originController),
              const SizedBox(height: 10),
              _field(l10n.destAddress, _destController),
              const SizedBox(height: 14),
              Text(
                l10n.cargoInfo,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1C1C1E),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _field(l10n.cargoWeight + ' (kg)', _weightController),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _field('\u6570\u91CF', _quantityController),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: CupertinoColors.systemGrey5, width: 0.5),
                ),
                child: CupertinoTextField(
                  controller: TextEditingController(text: _cargoType),
                  placeholder: '\u8D27\u7269\u7C7B\u578B',
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: const BoxDecoration(),
                  style: const TextStyle(fontSize: 15),
                  onChanged: (v) => _cargoType = v,
                ),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: CupertinoColors.systemGrey5, width: 0.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.expressInsurance,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF1C1C1E),
                      ),
                    ),
                    CupertinoSwitch(
                      value: _insured,
                      activeColor: const Color(0xFFFF9500),
                      onChanged: (v) => setState(() => _insured = v),
                    ),
                  ],
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
                          'type': 'freight',
                          'vehicleType': _vehicleType,
                          'originAddress': _originController.text,
                          'originLat': 0.0,
                          'originLng': 0.0,
                          'destAddress': _destController.text,
                          'destLat': 0.0,
                          'destLng': 0.0,
                          'cargoInfo': '\u8D27\u7269: ${_cargoType} ${_weightController.text}kg x${_quantityController.text}',
                          'insured': _insured,
                          'insuranceFee': _insured ? 5.0 : 0.0,
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

  Widget _vehicleChip(String label) {
    final selected = _vehicleType == label;
    return GestureDetector(
      onTap: () => setState(() => _vehicleType = label),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFF9500) : CupertinoColors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? const Color(0xFFFF9500) : CupertinoColors.systemGrey5,
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
