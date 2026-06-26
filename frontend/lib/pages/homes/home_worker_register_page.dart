import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/providers/home_provider.dart';

class HomeWorkerRegisterPage extends StatefulWidget {
  const HomeWorkerRegisterPage({super.key});

  @override
  State<HomeWorkerRegisterPage> createState() => _HomeWorkerRegisterPageState();
}

class _HomeWorkerRegisterPageState extends State<HomeWorkerRegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _idCardController = TextEditingController();
  final TextEditingController _depositController = TextEditingController();
  final List<String> _selectedSkills = [];
  final List<String> _certificates = [];

  final List<String> _availableSkills = ['', '', '', '', '', '', '', ''];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _idCardController.dispose();
    _depositController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_nameController.text.trim().isEmpty || _phoneController.text.trim().isEmpty) return;

    final provider = context.read<HomeProvider>();
    final success = await provider.registerWorker({
      'name': _nameController.text.trim(),
      'phone': _phoneController.text.trim(),
      'idCard': _idCardController.text.trim(),
      'skills': _selectedSkills,
      'certificates': _certificates,
      'deposit': double.tryParse(_depositController.text.trim()) ?? 0,
    });

    if (success && mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.workerRegister),
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
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: CupertinoTextField(
                controller: _nameController,
                placeholder: '',
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: const BoxDecoration(color: CupertinoColors.systemBackground),
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
                controller: _phoneController,
                placeholder: l10n.phoneNumber,
                keyboardType: TextInputType.phone,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: const BoxDecoration(color: CupertinoColors.systemBackground),
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
                controller: _idCardController,
                placeholder: '',
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: const BoxDecoration(color: CupertinoColors.systemBackground),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.workerSkills,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1C1C1E)),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _availableSkills.map((skill) {
                final selected = _selectedSkills.contains(skill);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (selected) {
                        _selectedSkills.remove(skill);
                      } else {
                        _selectedSkills.add(skill);
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected ? const Color(0xFF5AC8FA) : CupertinoColors.systemGrey6,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      skill,
                      style: TextStyle(
                        fontSize: 13,
                        color: selected ? CupertinoColors.white : const Color(0xFF3C3C43),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.workerCert,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1C1C1E)),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                setState(() {
                  _certificates.add('');
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: CupertinoColors.systemBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: CupertinoColors.systemGrey5, width: 0.5),
                ),
                padding: const EdgeInsets.all(14),
                child: const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(CupertinoIcons.plus_circle, size: 20, color: Color(0xFF5AC8FA)),
                      SizedBox(width: 8),
                      Text('', style: TextStyle(fontSize: 14, color: Color(0xFF5AC8FA))),
                    ],
                  ),
                ),
              ),
            ),
            if (_certificates.isNotEmpty) ...[
              const SizedBox(height: 8),
              ..._certificates.asMap().entries.map((entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemGrey6,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Row(
                        children: [
                          const Icon(CupertinoIcons.doc_fill, size: 16, color: CupertinoColors.systemGrey),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(' #${entry.key + 1}', style: const TextStyle(fontSize: 13)),
                          ),
                        ],
                      ),
                    ),
                  )),
            ],
            const SizedBox(height: 20),
            Text(
              l10n.depositPay,
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
                controller: _depositController,
                placeholder: '¥',
                keyboardType: TextInputType.number,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: const BoxDecoration(color: CupertinoColors.systemBackground),
              ),
            ),
            const SizedBox(height: 24),
            CupertinoButton.filled(
              onPressed: _submit,
              child: Text(l10n.confirm),
            ),
          ],
        ),
      ),
    );
  }
}
