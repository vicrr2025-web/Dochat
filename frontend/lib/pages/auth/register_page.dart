import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/providers/auth_provider.dart';
import 'package:dochat_app/pages/auth/main_shell_page.dart';
import 'package:dochat_app/pages/auth/home_page.dart';
import 'package:dochat_app/pages/auth/widgets/sms_button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _phoneController = TextEditingController();
  final _smsCodeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _passwordMismatch = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _smsCodeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _canSubmit() {
    return _phoneController.text.length == 11 &&
        _smsCodeController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        !_passwordMismatch;
  }

  void _checkPasswordMatch(String value) {
    setState(() {
      _passwordMismatch = _confirmPasswordController.text.isNotEmpty &&
          _passwordController.text != value;
    });
  }

  Future<void> _handleRegister() async {
    if (!_canSubmit()) return;

    final authProvider = context.read<AuthProvider>();
    await authProvider.register(
      _phoneController.text,
      _smsCodeController.text,
      _passwordController.text,
    );

    if (!mounted) return;

    if (authProvider.isLoggedIn) {
      Navigator.of(context).pushAndRemoveUntil(
        CupertinoPageRoute(builder: (_) => const MainShellPage()),
        (_) => false,
      );
    } else if (authProvider.errorMessage != null) {
      _showError(authProvider.errorMessage!);
      authProvider.clearError();
    }
  }

  void _showError(String errorKey) {
    final loc = AppLocalizations.of(context);
    final message = _errorText(loc, errorKey);

    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: Text(loc.appName),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: Text(loc.confirm),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  String _errorText(AppLocalizations loc, String key) {
    switch (key) {
      case 'networkError':
        return loc.networkError;
      case 'phoneRegistered':
        return loc.phoneRegistered;
      case 'passwordInvalid':
        return loc.passwordInvalid;
      default:
        return key;
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final authProvider = context.watch<AuthProvider>();

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(loc.register),
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
                    type: 'register',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CupertinoTextField(
                controller: _passwordController,
                obscureText: true,
                placeholder: loc.setPassword,
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
              if (authProvider.isLoading)
                const CupertinoActivityIndicator()
              else
                CupertinoButton.filled(
                  onPressed: _canSubmit() ? _handleRegister : null,
                  child: Text(loc.register),
                ),
              const SizedBox(height: 32),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Text(
                  loc.hasAccount,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF007AFF),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
