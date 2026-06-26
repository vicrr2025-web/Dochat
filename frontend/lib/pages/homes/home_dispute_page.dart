import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/providers/home_provider.dart';

class HomeDisputePage extends StatefulWidget {
  const HomeDisputePage({super.key});

  @override
  State<HomeDisputePage> createState() => _HomeDisputePageState();
}

class _HomeDisputePageState extends State<HomeDisputePage> {
  final TextEditingController _reasonController = TextEditingController();
  String? _selectedOrderId;
  String _evidenceText = '';

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _submitDispute() async {
    if (_selectedOrderId == null || _reasonController.text.trim().isEmpty) return;

    final provider = context.read<HomeProvider>();
    final success = await provider.createDispute({
      'orderId': _selectedOrderId,
      'reason': _reasonController.text.trim(),
      if (_evidenceText.isNotEmpty) 'evidence': _evidenceText,
    });

    if (success && provider.dispute != null && mounted) {
      provider.loadJuryStatus(provider.dispute!.disputeId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.expressDispute),
      ),
      child: SafeArea(
        child: Consumer<HomeProvider>(
          builder: (context, provider, _) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  l10n.homeService,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1C1C1E)),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: CupertinoColors.systemGrey5, width: 0.5),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: CupertinoTextField(
                    placeholder: l10n.orderId,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const BoxDecoration(color: CupertinoColors.systemBackground),
                    onChanged: (v) => _selectedOrderId = v.trim(),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: CupertinoColors.systemGrey5, width: 0.5),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: CupertinoTextField(
                    controller: _reasonController,
                    placeholder: '',
                    maxLines: 4,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const BoxDecoration(color: CupertinoColors.systemBackground),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.submitEvidence,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1C1C1E)),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: CupertinoColors.systemGrey5, width: 0.5),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: CupertinoTextField(
                    placeholder: '',
                    maxLines: 3,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const BoxDecoration(color: CupertinoColors.systemBackground),
                    onChanged: (v) => _evidenceText = v,
                  ),
                ),
                const SizedBox(height: 24),
                CupertinoButton.filled(
                  onPressed: _submitDispute,
                  child: Text(l10n.confirm),
                ),
                if (provider.juryStatus != null) ...[
                  const SizedBox(height: 20),
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
                        Text('', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1C1C1E))),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _juryStat('', provider.juryStatus!['for']),
                            _juryStat('', provider.juryStatus!['against']),
                            _juryStat('', provider.juryStatus!['total']),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _juryStat(String label, dynamic value) {
    return Column(
      children: [
        Text(
          '${value ?? 0}',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF1C1C1E)),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: CupertinoColors.systemGrey)),
      ],
    );
  }
}
