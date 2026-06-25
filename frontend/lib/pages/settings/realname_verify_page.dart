import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/providers/settings_provider.dart';

class RealnameVerifyPage extends StatefulWidget {
  const RealnameVerifyPage({super.key});

  @override
  State<RealnameVerifyPage> createState() => _RealnameVerifyPageState();
}

class _RealnameVerifyPageState extends State<RealnameVerifyPage> {
  final _realNameCtrl = TextEditingController();
  final _idNumberCtrl = TextEditingController();
  final _faceIdCtrl = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _realNameCtrl.dispose();
    _idNumberCtrl.dispose();
    _faceIdCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.realNameVerify),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              CupertinoTextField(
                controller: _realNameCtrl,
                placeholder: l10n.realName,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
              const SizedBox(height: 12),
              CupertinoTextField(
                controller: _idNumberCtrl,
                placeholder: l10n.idNumber,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
              const SizedBox(height: 12),
              CupertinoTextField(
                controller: _faceIdCtrl,
                placeholder: l10n.faceVerifyHint,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
              const SizedBox(height: 24),
              CupertinoButton.filled(
                onPressed: _isSubmitting
                    ? null
                    : () async {
                        setState(() => _isSubmitting = true);
                        final provider = context.read<SettingsProvider>();
                        final ok = await provider.submitVerify(
                          _realNameCtrl.text.trim(),
                          _idNumberCtrl.text.trim(),
                          _faceIdCtrl.text.trim(),
                        );
                        setState(() => _isSubmitting = false);
                        if (!mounted) return;
                        showCupertinoDialog(
                          context: context,
                          builder: (ctx) => CupertinoAlertDialog(
                            title: Text(ok ? l10n.verifyPending : l10n.networkError),
                            actions: [
                              CupertinoDialogAction(
                                child: Text(l10n.confirm),
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                  if (ok) Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                child: _isSubmitting
                    ? const CupertinoActivityIndicator()
                    : Text(l10n.submitVerify),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
