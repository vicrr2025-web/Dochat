import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/models/guarantee_models.dart';
import 'package:dochat_app/providers/guarantee_provider.dart';

class GuaranteeCreatePage extends StatefulWidget {
  const GuaranteeCreatePage({super.key});

  @override
  State<GuaranteeCreatePage> createState() => _GuaranteeCreatePageState();
}

class _GuaranteeCreatePageState extends State<GuaranteeCreatePage> {
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  String? _selectedFriendId;
  String _selectedFriendName = '';

  static const _mockFriends = [
    {'id': 'friend_001', 'name': '张三'},
    {'id': 'friend_002', 'name': '李四'},
    {'id': 'friend_003', 'name': '王五'},
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  void _showFriendPicker(AppLocalizations l10n) {
    showCupertinoModalPopup(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        title: Text(l10n.selectCounterparty),
        actions: _mockFriends.map((f) {
          return CupertinoActionSheetAction(
            onPressed: () {
              setState(() {
                _selectedFriendId = f['id'];
                _selectedFriendName = f['name']!;
              });
              Navigator.pop(ctx);
            },
            child: Text(f['name']!),
          );
        }).toList(),
        cancelButton: CupertinoActionSheetAction(
          child: Text(l10n.cancel),
          onPressed: () => Navigator.pop(ctx),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final name = _nameCtrl.text.trim();
    final desc = _descCtrl.text.trim();
    final amountText = _amountCtrl.text.trim();

    if (name.isEmpty || amountText.isEmpty || _selectedFriendId == null) return;

    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) return;

    final request = CreateTradeRequest(
      productName: name,
      productDesc: desc,
      amount: amount,
      counterpartyId: _selectedFriendId!,
    );

    final ok = await context.read<GuaranteeProvider>().createTrade(request);
    if (ok && mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.createTrade),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CupertinoTextField(
                controller: _nameCtrl,
                placeholder: l10n.productName,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: CupertinoColors.systemGrey5,
                    width: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              CupertinoTextField(
                controller: _descCtrl,
                placeholder: l10n.productDesc,
                maxLines: 4,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: CupertinoColors.systemGrey5,
                    width: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              CupertinoTextField(
                controller: _amountCtrl,
                placeholder: l10n.tradeAmount,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: CupertinoColors.systemGrey5,
                    width: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              CupertinoButton(
                color: CupertinoColors.white,
                borderRadius: BorderRadius.circular(10),
                padding: const EdgeInsets.symmetric(vertical: 14),
                onPressed: () => _showFriendPicker(l10n),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedFriendName.isEmpty
                            ? l10n.selectCounterparty
                            : _selectedFriendName,
                        style: TextStyle(
                          fontSize: 16,
                          color: _selectedFriendName.isEmpty
                              ? CupertinoColors.systemGrey
                              : const Color(0xFF1C1C1E),
                        ),
                      ),
                    ),
                    const Icon(
                      CupertinoIcons.chevron_right,
                      color: CupertinoColors.systemGrey3,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              CupertinoButton(
                color: const Color(0xFF007AFF),
                borderRadius: BorderRadius.circular(12),
                onPressed: _submit,
                child: Text(
                  l10n.confirm,
                  style: const TextStyle(
                    color: CupertinoColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
