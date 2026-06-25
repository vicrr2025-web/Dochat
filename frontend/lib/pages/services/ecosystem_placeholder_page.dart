import 'package:flutter/cupertino.dart';
import 'package:dochat_app/l10n/app_localizations.dart';

IconData _iconForKey(String key) {
  switch (key) {
    case 'guarantee':
      return CupertinoIcons.shield_lefthalf_fill;
    case 'mall':
      return CupertinoIcons.cart_fill;
    case 'dating':
      return CupertinoIcons.heart_fill;
    case 'housing':
      return CupertinoIcons.house_fill;
    case 'recruit':
      return CupertinoIcons.briefcase_fill;
    case 'email':
      return CupertinoIcons.mail_solid;
    case 'shipping':
      return CupertinoIcons.cube_box_fill;
    case 'homeService':
      return CupertinoIcons.wrench_fill;
    default:
      return CupertinoIcons.question_circle_fill;
  }
}

class EcosystemPlaceholderPage extends StatelessWidget {
  final String ecosystemName;
  final String ecosystemKey;

  const EcosystemPlaceholderPage({
    super.key,
    required this.ecosystemName,
    required this.ecosystemKey,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(ecosystemName),
      ),
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _iconForKey(ecosystemKey),
                size: 80,
                color: CupertinoColors.systemGrey,
              ),
              const SizedBox(height: 16),
              Text(
                ecosystemName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1C1C1E),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.comingSoon,
                style: const TextStyle(
                  fontSize: 14,
                  color: CupertinoColors.systemGrey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
