import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/models/mail_models.dart';
import 'package:dochat_app/providers/mail_provider.dart';

class MailComposePage extends StatefulWidget {
  final String accountId;
  final MailMessage? replyTo;
  final bool replyAll;
  final MailMessage? forwardFrom;

  const MailComposePage({
    super.key,
    required this.accountId,
    this.replyTo,
    this.replyAll = false,
    this.forwardFrom,
  });

  @override
  State<MailComposePage> createState() => _MailComposePageState();
}

class _MailComposePageState extends State<MailComposePage> {
  final _toCtrl = TextEditingController();
  final _ccCtrl = TextEditingController();
  final _bccCtrl = TextEditingController();
  final _subjectCtrl = TextEditingController();
  final _bodyCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.replyTo != null) {
      _toCtrl.text = widget.replyTo!.sender ?? '';
      _subjectCtrl.text =
          'Re: ${widget.replyTo!.subject ?? ''}';
      _bodyCtrl.text = '\n\n--- Original Message ---\n${widget.replyTo!.body ?? ''}';
    } else if (widget.forwardFrom != null) {
      _subjectCtrl.text =
          'Fwd: ${widget.forwardFrom!.subject ?? ''}';
      _bodyCtrl.text =
          '\n\n--- Forwarded Message ---\n${widget.forwardFrom!.body ?? ''}';
    }
  }

  @override
  void dispose() {
    _toCtrl.dispose();
    _ccCtrl.dispose();
    _bccCtrl.dispose();
    _subjectCtrl.dispose();
    _bodyCtrl.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final to = _toCtrl.text.trim();
    if (to.isEmpty) return;

    final data = {
      'accountId': widget.accountId,
      'to': to,
      'cc': _ccCtrl.text.trim(),
      'bcc': _bccCtrl.text.trim(),
      'subject': _subjectCtrl.text.trim(),
      'body': _bodyCtrl.text,
    };

    final provider = context.read<MailProvider>();
    final success = widget.replyTo != null
        ? await provider.replyMail({
            ...data,
            'messageId': widget.replyTo!.messageId,
          })
        : await provider.sendMail(data);

    if (success && mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.mailCompose),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _send,
          child: const Icon(
            CupertinoIcons.paperplane_fill,
            size: 22,
            color: CupertinoColors.activeBlue,
          ),
        ),
      ),
      child: SafeArea(
        child: Consumer<MailProvider>(
          builder: (context, provider, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemBackground,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: CupertinoColors.systemGrey5,
                        width: 0.5,
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildField(
                          l10n.mailTo,
                          _toCtrl,
                        ),
                        _divider(),
                        _buildField(
                          l10n.mailCc,
                          _ccCtrl,
                        ),
                        _divider(),
                        _buildField(
                          l10n.mailBcc,
                          _bccCtrl,
                        ),
                        _divider(),
                        _buildField(
                          l10n.mailSubject,
                          _subjectCtrl,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 300,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemBackground,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: CupertinoColors.systemGrey5,
                        width: 0.5,
                      ),
                    ),
                    child: CupertinoTextField(
                      controller: _bodyCtrl,
                      placeholder: l10n.mailBody,
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: const BoxDecoration(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemBackground,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: CupertinoColors.systemGrey5,
                          width: 0.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            CupertinoIcons.paperclip,
                            size: 20,
                            color: CupertinoColors.systemGrey,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            l10n.mailAddAttachment,
                            style: const TextStyle(
                              fontSize: 14,
                              color: CupertinoColors.systemGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: CupertinoButton.filled(
                      onPressed: _send,
                      child: Text(l10n.mailCompose),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildField(String placeholder, TextEditingController controller) {
    return SizedBox(
      height: 44,
      child: CupertinoTextField(
        controller: controller,
        placeholder: placeholder,
        decoration: const BoxDecoration(),
        padding: const EdgeInsets.symmetric(vertical: 10),
      ),
    );
  }

  Widget _divider() {
    return Container(
      height: 0.5,
      color: CupertinoColors.systemGrey5,
    );
  }
}
