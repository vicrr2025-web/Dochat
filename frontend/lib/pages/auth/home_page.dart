import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/providers/auth_provider.dart';
import 'package:dochat_app/pages/auth/login_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(loc.appName),
      ),
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                CupertinoIcons.person_2_square_stack,
                size: 80,
                color: Color(0xFF007AFF),
              ),
              const SizedBox(height: 16),
              Text(
                loc.loginSuccess,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1C1C1E),
                ),
              ),
              const SizedBox(height: 32),
              CupertinoButton(
                color: const Color(0xFFFF3B30),
                borderRadius: BorderRadius.circular(10),
                onPressed: () => _showSignOutDialog(context, loc),
                child: Text(
                  loc.signOut,
                  style: const TextStyle(color: CupertinoColors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSignOutDialog(BuildContext context, AppLocalizations loc) {
    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: Text(loc.appName),
        content: Text(loc.signOutConfirm),
        actions: [
          CupertinoDialogAction(
            child: Text(loc.cancel),
            onPressed: () => Navigator.of(context).pop(),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () async {
              Navigator.of(context).pop();
              final authProvider = context.read<AuthProvider>();
              await authProvider.logout();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  CupertinoPageRoute(builder: (_) => const LoginPage()),
                  (_) => false,
                );
              }
            },
            child: Text(loc.signOut),
          ),
        ],
      ),
    );
  }
}
