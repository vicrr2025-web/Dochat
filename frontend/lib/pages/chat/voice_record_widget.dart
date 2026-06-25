import 'dart:async';
import 'package:flutter/cupertino.dart';

import 'package:dochat_app/l10n/app_localizations.dart';

class VoiceRecordWidget extends StatefulWidget {
  final void Function(int duration) onSend;

  const VoiceRecordWidget({super.key, required this.onSend});

  @override
  State<VoiceRecordWidget> createState() => _VoiceRecordWidgetState();
}

class _VoiceRecordWidgetState extends State<VoiceRecordWidget> {
  bool _isRecording = false;
  bool _willCancel = false;
  Timer? _recordTimer;
  int _recordSeconds = 0;

  void _startRecording() {
    setState(() {
      _isRecording = true;
      _willCancel = false;
      _recordSeconds = 0;
    });

    _recordTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _recordSeconds++;
      });
    });
  }

  void _stopRecording(bool cancel) {
    _recordTimer?.cancel();
    _recordTimer = null;

    final duration = _recordSeconds;

    setState(() {
      _isRecording = false;
      _willCancel = false;
    });

    if (!cancel) {
      if (duration < 1) {
        showCupertinoDialog(
          context: context,
          builder: (_) {
            final l10n = AppLocalizations.of(context);
            return CupertinoAlertDialog(
              content: Text(l10n.recordingTooShort),
              actions: [
                CupertinoDialogAction(
                  child: Text(l10n.confirm),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            );
          },
        );
        return;
      }
      widget.onSend(duration);
    }
  }

  @override
  void dispose() {
    _recordTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanDown: (_) {
        _startRecording();
      },
      onPanUpdate: (details) {
        setState(() {
          _willCancel = details.localPosition.dy < -50;
        });
      },
      onPanEnd: (details) {
        _stopRecording(_willCancel);
      },
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: _isRecording
              ? const Color(0xFFDCDCE0)
              : CupertinoColors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            _isRecording
                ? (_willCancel ? l10n.releaseToCancel : "${l10n.holdToTalk} ${_recordSeconds}s")
                : l10n.holdToTalk,
            style: TextStyle(
              fontSize: 15,
              color: _willCancel
                  ? const Color(0xFFFF3B30)
                  : const Color(0xFF007AFF),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
