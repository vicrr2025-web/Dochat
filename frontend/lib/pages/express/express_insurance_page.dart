import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/providers/express_provider.dart';

class ExpressInsurancePage extends StatefulWidget {
  const ExpressInsurancePage({super.key});

  @override
  State<ExpressInsurancePage> createState() => _ExpressInsurancePageState();
}

class _ExpressInsurancePageState extends State<ExpressInsurancePage> {
  String _insuranceType = 'basic';
  final _orderIdController = TextEditingController();
  final _claimDescController = TextEditingController();

  @override
  void dispose() {
    _orderIdController.dispose();
    _claimDescController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.expressInsurance),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.buyInsurance,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1C1C1E)),
              ),
              const SizedBox(height: 12),
              _insuranceCard('\u57FA\u7840\u7248', 'basic', '\u00A52.00', '\u00A5500'),
              const SizedBox(height: 8),
              _insuranceCard('\u6807\u51C6\u7248', 'standard', '\u00A55.00', '\u00A52000'),
              const SizedBox(height: 8),
              _insuranceCard('\u8C6A\u534E\u7248', 'premium', '\u00A510.00', '\u00A55000'),
              const SizedBox(height: 16),
              CupertinoButton.filled(
                onPressed: () {
                  showCupertinoDialog(
                    context: context,
                    builder: (_) => CupertinoAlertDialog(
                      title: Text(l10n.buyInsurance),
                      content: Text('\u5DF2\u8D2D\u4E70 $_insuranceType \u4FDD\u9669'),
                      actions: [
                        CupertinoDialogAction(
                          onPressed: () => Navigator.pop(context),
                          child: Text(l10n.confirm),
                        ),
                      ],
                    ),
                  );
                },
                child: Text(l10n.buyInsurance),
              ),
              const SizedBox(height: 28),
              Text(
                l10n.claimInsurance,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1C1C1E)),
              ),
              const SizedBox(height: 12),
              _field(l10n.orderId, _orderIdController),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: CupertinoColors.systemGrey5, width: 0.5),
                ),
                child: CupertinoTextField(
                  controller: _claimDescController,
                  placeholder: '\u7406\u8D54\u63CF\u8FF0',
                  maxLines: 4,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const BoxDecoration(),
                  style: const TextStyle(fontSize: 15),
                ),
              ),
              const SizedBox(height: 16),
              CupertinoButton(
                color: const Color(0xFFFF9500),
                onPressed: () {
                  showCupertinoDialog(
                    context: context,
                    builder: (_) => CupertinoAlertDialog(
                      title: Text(l10n.claimInsurance),
                      content: const Text('\u7406\u8D54\u7533\u8BF7\u5DF2\u63D0\u4EA4\uFF0C\u5BA1\u6838\u4E2D'),
                      actions: [
                        CupertinoDialogAction(
                          onPressed: () => Navigator.pop(context),
                          child: Text(l10n.confirm),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text('\u63D0\u4EA4\u7406\u8D54', style: TextStyle(color: CupertinoColors.white)),
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

  Widget _insuranceCard(String name, String type, String fee, String coverage) {
    final selected = _insuranceType == type;
    return GestureDetector(
      onTap: () => setState(() => _insuranceType = type),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFF9500).withOpacity(0.08) : CupertinoColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? const Color(0xFFFF9500) : CupertinoColors.systemGrey5,
            width: selected ? 1.5 : 0.5,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1C1C1E))),
                  const SizedBox(height: 2),
                  Text('\u4FDD\u8D39 $fee  /  \u4FDD\u989D $coverage',
                      style: const TextStyle(fontSize: 12, color: CupertinoColors.systemGrey)),
                ],
              ),
            ),
            if (selected)
              const Icon(CupertinoIcons.checkmark_alt_circle_fill, color: Color(0xFFFF9500), size: 22),
          ],
        ),
      ),
    );
  }
}
