import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/services/auth_service.dart';
import 'package:dochat_app/pages/auth/widgets/sms_button.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _phoneController = TextEditingController();
  final _smsCodeController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool _passwordMismatch = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _smsCodeController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _canSubmit() {
    return _phoneController.text.length == 11 &&
        _smsCodeController.text.isNotEmpty &&
        _newPasswordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        !_passwordMismatch;
  }

  void _checkPasswordMatch(String value) {
    setState(() {
      _passwordMismatch = _confirmPasswordController.text.isNotEmpty &&
          _newPasswordController.text != value;
    });
  }

  Future<void> _handleSubmit() async {
    if (!_canSubmit()) return;

    setState(() => _isLoading = true);

    try {
      await _authService.resetPassword(
        _phoneController.text,
        _smsCodeController.text,
        _newPasswordController.text,
      );

      if (!mounted) return;

      final loc = AppLocalizations.of(context);
      showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
          title: Text(loc.passwordReset),
          content: Text(loc.passwordReset),
          actions: [
            CupertinoDialogAction(
              child: Text(loc.confirm),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      final loc = AppLocalizations.of(context);
      showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
          title: Text(loc.appName),
          content: Text(loc.networkError),
          actions: [
            CupertinoDialogAction(
              child: Text(loc.confirm),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(loc.resetPassword),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Icon(
                CupertinoIcons.person_2_square_stack,
                size: 60,
                color: Color(0xFF007AFF),
              ),
              const SizedBox(height: 12),
              Text(
                loc.appSlogan,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF8E8E93),
                ),
              ),
              const SizedBox(height: 40),
              CupertinoTextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(11),
                ],
                placeholder: loc.phoneNumber,
                prefix: const Padding(
                  padding: EdgeInsets.only(left: 12),
                  child: Icon(
                    CupertinoIcons.phone,
                    size: 20,
                    color: Color(0xFFC7C7CC),
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CupertinoTextField(
                      controller: _smsCodeController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(6),
                      ],
                      placeholder: loc.smsCode,
                      prefix: const Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Icon(
                          CupertinoIcons.lock,
                          size: 20,
                          color: Color(0xFFC7C7CC),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                      decoration: BoxDecoration(
                        color: CupertinoColors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SmsButton(
                    phone: _phoneController.text,
                    type: 'reset',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CupertinoTextField(
                controller: _newPasswordController,
                obscureText: true,
                placeholder: loc.newPassword,
                prefix: const Padding(
                  padding: EdgeInsets.only(left: 12),
                  child: Icon(
                    CupertinoIcons.lock,
                    size: 20,
                    color: Color(0xFFC7C7CC),
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),
              CupertinoTextField(
                controller: _confirmPasswordController,
                obscureText: true,
                placeholder: loc.confirmPassword,
                prefix: const Padding(
                  padding: EdgeInsets.only(left: 12),
                  child: Icon(
                    CupertinoIcons.lock,
                    size: 20,
                    color: Color(0xFFC7C7CC),
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: _passwordMismatch
                      ? Border.all(color: const Color(0xFFFF3B30), width: 1)
                      : null,
                ),
                onChanged: _checkPasswordMatch,
              ),
              if (_passwordMismatch) ...[
                const SizedBox(height: 8),
                Text(
                  loc.passwordMismatch,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFFFF3B30),
                  ),
                ),
              ],
              const SizedBox(height: 24),
              if (_isLoading)
                const CupertinoActivityIndicator()
              else
                CupertinoButton.filled(
                  onPressed: _canSubmit() ? _handleSubmit : null,
                  child: Text(loc.confirm),
                ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
