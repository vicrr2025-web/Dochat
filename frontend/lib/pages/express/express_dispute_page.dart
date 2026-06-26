import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/providers/express_provider.dart';

class ExpressDisputePage extends StatefulWidget {
  const ExpressDisputePage({super.key});

  @override
  State<ExpressDisputePage> createState() => _ExpressDisputePageState();
}

class _ExpressDisputePageState extends State<ExpressDisputePage> {
  final _orderIdController = TextEditingController();
  final _reasonController = TextEditingController();
  final _evidenceController = TextEditingController();
  final _disputeIdController = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _orderIdController.dispose();
    _reasonController.dispose();
    _evidenceController.dispose();
    _disputeIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.expressDispute),
      ),
      child: SafeArea(
        child: Consumer<ExpressProvider>(
          builder: (context, provider, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '\u53D1\u8D77\u7EA0\u7EB7',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1C1C1E)),
                  ),
                  const SizedBox(height: 12),
                  _field(l10n.orderId, _orderIdController),
                  const SizedBox(height: 10),
                  _field('\u7EA0\u7EB7\u539F\u56E0', _reasonController),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: CupertinoColors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: CupertinoColors.systemGrey5, width: 0.5),
                    ),
                    child: CupertinoTextField(
                      controller: _evidenceController,
                      placeholder: l10n.submitEvidence,
                      maxLines: 4,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: const BoxDecoration(),
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                  const SizedBox(height: 16),
                  CupertinoButton.filled(
                    onPressed: _submitting
                        ? null
                        : () async {
                            setState(() => _submitting = true);
                            await provider.createDispute({
                              'orderId': _orderIdController.text,
                              'reason': _reasonController.text,
                              'evidence': _evidenceController.text,
                            });
                            setState(() => _submitting = false);
                          },
                    child: Text(_submitting ? l10n.loading : '\u63D0\u4EA4\u7EA0\u7EB7'),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    l10n.juryVoting,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1C1C1E)),
                  ),
                  const SizedBox(height: 12),
                  _field('\u7EA0\u7EB7ID', _disputeIdController),
                  const SizedBox(height: 10),
                  CupertinoButton(
                    color: const Color(0xFFFF9500),
                    onPressed: () {
                      provider.loadJuryStatus(_disputeIdController.text);
                    },
                    child: const Text('\u67E5\u8BE2\u966A\u5BA1\u56E2'),
                  ),
                  if (provider.juryStatus != null) ...[
                    const SizedBox(height: 14),
                    _juryCard(provider.juryStatus!),
                  ],
                ],
              ),
            );
          },
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

  Widget _juryCard(Map<String, dynamic> jury) {
    final votesFor = jury['votesFor'] ?? 0;
    final votesAgainst = jury['votesAgainst'] ?? 0;
    final verdict = jury['verdict'];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CupertinoColors.systemGrey5, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('\u966A\u5BA1\u56E2\u6295\u7968', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1C1C1E))),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text('$votesFor', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Color(0xFF34C759))),
                  const Text('\u652F\u6301', style: TextStyle(fontSize: 12, color: CupertinoColors.systemGrey)),
                ],
              ),
              Column(
                children: [
                  Text('$votesAgainst', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Color(0xFFFF3B30))),
                  const Text('\u53CD\u5BF9', style: TextStyle(fontSize: 12, color: CupertinoColors.systemGrey)),
                ],
              ),
            ],
          ),
          if (verdict != null) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF34C759).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '\u88C1\u51B3: $verdict',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF34C759)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
