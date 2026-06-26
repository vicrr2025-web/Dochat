import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/services/auth_service.dart';

class SmsButton extends StatefulWidget {
  final String phone;
  final String type;

  const SmsButton({
    super.key,
    required this.phone,
    required this.type,
  });

  @override
  State<SmsButton> createState() => _SmsButtonState();
}

class _SmsButtonState extends State<SmsButton> {
  final AuthService _authService = AuthService();
  int _countdown = 0;
  Timer? _timer;
  bool _isSending = false;

  bool get isCountingDown => _countdown > 0;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _sendSms() async {
    if (_countdown > 0 || _isSending || widget.phone.length != 11) return;

    setState(() => _isSending = true);

    final result = await _authService.sendSms(widget.phone, widget.type);

    setState(() => _isSending = false);

    if (result.code == 0) {
      setState(() => _countdown = 60);

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_countdown > 1) {
            _countdown--;
          } else {
            _countdown = 0;
            _timer?.cancel();
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final isDisabled = _countdown > 0 || _isSending || widget.phone.length != 11;

    return GestureDetector(
      onTap: _sendSms,
      child: _isSending
          ? const CupertinoActivityIndicator(radius: 8)
          : Text(
              _countdown > 0
                  ? '$_countdown${loc.retryAfter}'
                  : loc.getSmsCode,
              style: TextStyle(
                fontSize: 15,
                color: isDisabled
                    ? const Color(0xFFC7C7CC)
                    : const Color(0xFF007AFF),
                fontWeight: FontWeight.w500,
              ),
            ),
    );
  }
}
