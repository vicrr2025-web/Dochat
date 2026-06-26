import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/providers/mail_provider.dart';

class MailAddAccountPage extends StatefulWidget {
  const MailAddAccountPage({super.key});

  @override
  State<MailAddAccountPage> createState() => _MailAddAccountPageState();
}

class _MailAddAccountPageState extends State<MailAddAccountPage> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _displayNameCtrl = TextEditingController();
  final _imapHostCtrl = TextEditingController();
  final _imapPortCtrl = TextEditingController();
  final _smtpHostCtrl = TextEditingController();
  final _smtpPortCtrl = TextEditingController();

  String _selectedProvider = 'QQ邮箱';

  static const _providers = [
    'QQ邮箱',
    '163邮箱',
    'Gmail',
    'Outlook',
    '其他',
  ];

  static const _providerConfigs = {
    'QQ邮箱': {'imapHost': 'imap.qq.com', 'imapPort': '993', 'smtpHost': 'smtp.qq.com', 'smtpPort': '465'},
    '163邮箱': {'imapHost': 'imap.163.com', 'imapPort': '993', 'smtpHost': 'smtp.163.com', 'smtpPort': '465'},
    'Gmail': {'imapHost': 'imap.gmail.com', 'imapPort': '993', 'smtpHost': 'smtp.gmail.com', 'smtpPort': '587'},
    'Outlook': {'imapHost': 'outlook.office365.com', 'imapPort': '993', 'smtpHost': 'smtp.office365.com', 'smtpPort': '587'},
    '其他': {'imapHost': '', 'imapPort': '993', 'smtpHost': '', 'smtpPort': '465'},
  };

  @override
  void initState() {
    super.initState();
    _applyProviderConfig(_selectedProvider);
  }

  void _applyProviderConfig(String provider) {
    final config = _providerConfigs[provider]!;
    _imapHostCtrl.text = config['imapHost']!;
    _imapPortCtrl.text = config['imapPort']!;
    _smtpHostCtrl.text = config['smtpHost']!;
    _smtpPortCtrl.text = config['smtpPort']!;
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _displayNameCtrl.dispose();
    _imapHostCtrl.dispose();
    _imapPortCtrl.dispose();
    _smtpHostCtrl.dispose();
    _smtpPortCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final email = _emailCtrl.text.trim();
    if (email.isEmpty) return;

    final data = {
      'email': email,
      'password': _passwordCtrl.text,
      'provider': _selectedProvider,
      'displayName': _displayNameCtrl.text.trim(),
      'imapHost': _imapHostCtrl.text.trim(),
      'imapPort': int.tryParse(_imapPortCtrl.text.trim()),
      'smtpHost': _smtpHostCtrl.text.trim(),
      'smtpPort': int.tryParse(_smtpPortCtrl.text.trim()),
    };

    final provider = context.read<MailProvider>();
    final success = await provider.addAccount(data);
    if (success && mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.addAccount),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _save,
          child: Text(
            l10n.confirm,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: CupertinoColors.activeBlue,
            ),
          ),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionLabel(l10n.mailProvider),
              const SizedBox(height: 8),
              SizedBox(
                height: 40,
                child: CupertinoSlidingSegmentedControl<String>(
                  groupValue: _selectedProvider,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  children: {
                    for (final p in _providers)
                      p: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(p, style: const TextStyle(fontSize: 12)),
                      ),
                  },
                  onValueChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedProvider = value;
                        _applyProviderConfig(value);
                      });
                    }
                  },
                ),
              ),
              const SizedBox(height: 16),
              _buildField(l10n.mailTo, _emailCtrl, CupertinoIcons.mail_solid),
              const SizedBox(height: 12),
              _buildField(l10n.password, _passwordCtrl, CupertinoIcons.lock_fill, obscure: true),
              const SizedBox(height: 12),
              _buildField(l10n.mailTo, _displayNameCtrl, CupertinoIcons.person_fill),
              const SizedBox(height: 20),
              _buildSectionLabel(l10n.mailImapHost),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildField('', _imapHostCtrl, CupertinoIcons.arrow_up_arrow_down),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 1,
                    child: _buildField(l10n.mailPort, _imapPortCtrl, CupertinoIcons.number, number: true),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildSectionLabel(l10n.mailSmtpHost),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildField('', _smtpHostCtrl, CupertinoIcons.arrow_up_arrow_down),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 1,
                    child: _buildField(l10n.mailPort, _smtpPortCtrl, CupertinoIcons.number, number: true),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: CupertinoButton.filled(
                  onPressed: _save,
                  child: Text(l10n.confirm),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: CupertinoColors.systemGrey,
      ),
    );
  }

  Widget _buildField(
    String placeholder,
    TextEditingController controller,
    IconData icon, {
    bool obscure = false,
    bool number = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: CupertinoColors.systemGrey5, width: 0.5),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: CupertinoColors.systemGrey),
          const SizedBox(width: 8),
          Expanded(
            child: CupertinoTextField(
              controller: controller,
              placeholder: placeholder,
              obscureText: obscure,
              keyboardType: number ? TextInputType.number : TextInputType.emailAddress,
              decoration: const BoxDecoration(),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
