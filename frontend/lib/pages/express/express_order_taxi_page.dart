import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/providers/express_provider.dart';
import 'package:dochat_app/pages/express/express_tracking_page.dart';

class ExpressOrderTaxiPage extends StatefulWidget {
  const ExpressOrderTaxiPage({super.key});

  @override
  State<ExpressOrderTaxiPage> createState() => _ExpressOrderTaxiPageState();
}

class _ExpressOrderTaxiPageState extends State<ExpressOrderTaxiPage> {
  final _originController = TextEditingController();
  final _destController = TextEditingController();
  String _vehicleType = '\u5FEB\u8F66';
  bool _submitting = false;

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
        middle: Text(l10n.expressTaxi),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 180,
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey6,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(CupertinoIcons.map_fill, size: 48, color: CupertinoColors.systemGrey3),
                      SizedBox(height: 8),
                      Text(
                        '\u5730\u56FE\u533A\u57DF',
                        style: TextStyle(fontSize: 14, color: CupertinoColors.systemGrey),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _addressField(
                icon: CupertinoIcons.smallcircle_fill_circle,
                controller: _originController,
                hint: l10n.originAddress,
                color: const Color(0xFF34C759),
              ),
              const SizedBox(height: 8),
              _addressField(
                icon: CupertinoIcons.smallcircle_circle_fill,
                controller: _destController,
                hint: l10n.destAddress,
                color: const Color(0xFFFF3B30),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.selectVehicle,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1C1C1E),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _vehicleOption(l10n.expressCar, '\u5FEB\u8F66'),
                  const SizedBox(width: 8),
                  _vehicleOption(l10n.specialCar, '\u4E13\u8F66'),
                  const SizedBox(width: 8),
                  _vehicleOption(l10n.carpool, '\u62FC\u8F66'),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF9500).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(CupertinoIcons.money_dollar_circle, color: Color(0xFFFF9500), size: 22),
                    const SizedBox(width: 10),
                    Text(
                      '\u9884\u4F30\u8D39\u7528: \u00A512.00 - 25.00',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFFF9500),
                      ),
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
                          'type': 'taxi',
                          'vehicleType': _vehicleType,
                          'originAddress': _originController.text,
                          'originLat': 0.0,
                          'originLng': 0.0,
                          'destAddress': _destController.text,
                          'destLat': 0.0,
                          'destLng': 0.0,
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
                child: Text(_submitting ? l10n.loading : '\u786E\u8BA4\u53EB\u8F66'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _addressField({
    required IconData icon,
    required TextEditingController controller,
    required String hint,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: CupertinoColors.systemGrey5, width: 0.5),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: CupertinoTextField(
              controller: controller,
              placeholder: hint,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: const BoxDecoration(),
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }

  Widget _vehicleOption(String label, String value) {
    final selected = _vehicleType == value;
    return GestureDetector(
      onTap: () => setState(() => _vehicleType = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
}
