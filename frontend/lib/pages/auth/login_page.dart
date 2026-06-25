import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/providers/auth_provider.dart';
import 'package:dochat_app/pages/auth/register_page.dart';
import 'package:dochat_app/pages/auth/forgot_password_page.dart';
import 'package:dochat_app/pages/auth/home_page.dart';
import 'package:dochat_app/pages/auth/widgets/sms_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _smsCodeController = TextEditingController();
  final _phoneFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _smsCodeFocusNode = FocusNode();

  bool _isSmsMode = false;
  bool _obscurePassword = true;
  DateTime? _lastTapTime;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _smsCodeController.dispose();
    _phoneFocusNode.dispose();
    _passwordFocusNode.dispose();
    _smsCodeFocusNode.dispose();
    super.dispose();
  }

  bool _canSubmit() {
    final phoneValid = _phoneController.text.length == 11;
    if (_isSmsMode) {
      return phoneValid && _smsCodeController.text.isNotEmpty;
    }
    return phoneValid && _passwordController.text.isNotEmpty;
  }

  bool _debounce() {
    final now = DateTime.now();
    if (_lastTapTime != null &&
        now.difference(_lastTapTime!) < const Duration(milliseconds: 500)) {
      return false;
    }
    _lastTapTime = now;
    return true;
  }

  Future<void> _handleLogin() async {
    if (!_debounce() || !_canSubmit()) return;

    final authProvider = context.read<AuthProvider>();
    final phone = _phoneController.text;

    if (_isSmsMode) {
      await authProvider.loginBySms(phone, _smsCodeController.text);
    } else {
      await authProvider.login(phone, _passwordController.text);
    }

    if (!mounted) return;

    if (authProvider.isLoggedIn) {
      Navigator.of(context).pushReplacement(
        CupertinoPageRoute(builder: (_) => const HomePage()),
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
      case 'serverError':
        return loc.serverError;
      case 'phoneNotRegistered':
        return loc.phoneNotRegistered;
      case 'passwordWrong':
        return loc.passwordWrong;
      case 'accountLocked':
        return loc.accountLocked;
      case 'accountBanned':
        return loc.accountBanned;
      default:
        return key;
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final authProvider = context.watch<AuthProvider>();
    final canSubmit = _canSubmit();

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(loc.login),
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
                focusNode: _phoneFocusNode,
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
              if (_isSmsMode) ...[
                Row(
                  children: [
                    Expanded(
                      child: CupertinoTextField(
                        controller: _smsCodeController,
                        focusNode: _smsCodeFocusNode,
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
                      type: 'login',
                    ),
                  ],
                ),
              ] else ...[
                CupertinoTextField(
                  controller: _passwordController,
                  focusNode: _passwordFocusNode,
                  obscureText: _obscurePassword,
                  placeholder: loc.password,
                  prefix: const Padding(
                    padding: EdgeInsets.only(left: 12),
                    child: Icon(
                      CupertinoIcons.lock,
                      size: 20,
                      color: Color(0xFFC7C7CC),
                    ),
                  ),
                  suffix: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap: () => setState(() => _obscurePassword = !_obscurePassword),
                      child: Icon(
                        _obscurePassword
                            ? CupertinoIcons.eye
                            : CupertinoIcons.eye_slash,
                        size: 20,
                        color: const Color(0xFFC7C7CC),
                      ),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                  decoration: BoxDecoration(
                    color: CupertinoColors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (_) => const ForgotPasswordPage(),
                        ),
                      );
                    },
                    child: Text(
                      loc.forgotPassword,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF007AFF),
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 24),
              if (authProvider.isLoading)
                const CupertinoActivityIndicator()
              else
                CupertinoButton.filled(
                  onPressed: canSubmit ? _handleLogin : null,
                  child: Text(loc.login),
                ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (_) => const RegisterPage(),
                        ),
                      );
                    },
                    child: Text(
                      loc.noAccount,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF007AFF),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isSmsMode = !_isSmsMode;
                    _smsCodeController.clear();
                    _passwordController.clear();
                  });
                },
                child: Text(
                  _isSmsMode ? loc.loginViaPassword : loc.loginViaSms,
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
