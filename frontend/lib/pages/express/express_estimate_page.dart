import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/providers/express_provider.dart';

class ExpressEstimatePage extends StatefulWidget {
  const ExpressEstimatePage({super.key});

  @override
  State<ExpressEstimatePage> createState() => _ExpressEstimatePageState();
}

class _ExpressEstimatePageState extends State<ExpressEstimatePage> {
  final _originController = TextEditingController();
  final _destController = TextEditingController();
  String _vehicleType = '\u5FEB\u8F66';

  @override
  void dispose() {
    _originController.dispose();
    _destController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.estimatePrice),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Consumer<ExpressProvider>(
            builder: (context, provider, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _field(l10n.originAddress, _originController),
                  const SizedBox(height: 10),
                  _field(l10n.destAddress, _destController),
                  const SizedBox(height: 14),
                  Text(
                    l10n.vehicleType,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1C1C1E)),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      _chip(l10n.expressCar),
                      _chip(l10n.specialCar),
                      _chip(l10n.carpool),
                    ],
                  ),
                  const SizedBox(height: 20),
                  CupertinoButton.filled(
                    onPressed: () {
                      provider.estimatePrice({
                        'originAddress': _originController.text,
                        'destAddress': _destController.text,
                        'vehicleType': _vehicleType,
                      });
                    },
                    child: Text(l10n.estimatePrice),
                  ),
                  const SizedBox(height: 16),
                  if (provider.estimateResult != null) _resultCard(provider.estimateResult!),
                ],
              );
            },
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

  Widget _chip(String label) {
    final selected = _vehicleType == label;
    return GestureDetector(
      onTap: () => setState(() => _vehicleType = label),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF007AFF) : CupertinoColors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? const Color(0xFF007AFF) : CupertinoColors.systemGrey5,
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

  Widget _resultCard(Map<String, dynamic> result) {
    final distance = result['distance'] ?? 0;
    final duration = result['duration'] ?? 0;
    final price = result['price'] ?? 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: CupertinoColors.systemGrey5, width: 0.5),
      ),
      child: Column(
        children: [
          const Text('\u9884\u4F30\u7ED3\u679C', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1C1C1E))),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _metric('\u8DDD\u79BB', '${distance.toStringAsFixed(1)} km'),
              _metric('\u65F6\u95F4', '$duration \u5206\u949F'),
              _metric('\u8D39\u7528', '\u00A5${price.toStringAsFixed(2)}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _metric(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFFFF9500))),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 11, color: CupertinoColors.systemGrey)),
      ],
    );
  }
}
