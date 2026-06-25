import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/providers/dating_provider.dart';

class DatingAuthPage extends StatefulWidget {
  const DatingAuthPage({super.key});

  @override
  State<DatingAuthPage> createState() => _DatingAuthPageState();
}

class _DatingAuthPageState extends State<DatingAuthPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DatingProvider>().loadProfile();
    });
  }

  void _authWithAnimation(String type, Future<bool> Function() authFn) async {
    showCupertinoDialog(
      context: context,
      builder: (_) => const Center(child: CupertinoActivityIndicator(radius: 24)),
    );
    final ok = await authFn();
    if (mounted) {
      Navigator.pop(context);
      showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
          title: Text(ok ? '认证成功 ✅' : '认证失败'),
          content: Text(ok ? '恭喜，验证通过！' : '请稍后重试'),
          actions: [CupertinoDialogAction(child: const Text('OK'), onPressed: () => Navigator.pop(context))],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final profile = context.watch<DatingProvider>().profile;

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('认证中心')),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildAuthCard(
              icon: CupertinoIcons.person_badge_plus_fill,
              title: l10n.realAuth,
              verified: profile?.realVerified ?? false,
              onTap: () => _authWithAnimation('real', () => context.read<DatingProvider>().authReal()),
            ),
            const SizedBox(height: 12),
            _buildAuthCard(
              icon: CupertinoIcons.briefcase_fill,
              title: l10n.workAuth,
              verified: profile?.workVerified ?? false,
              onTap: () => _authWithAnimation('work', () => context.read<DatingProvider>().authWork()),
            ),
            const SizedBox(height: 12),
            _buildAuthCard(
              icon: CupertinoIcons.book_fill,
              title: l10n.eduAuth,
              verified: profile?.eduVerified ?? false,
              onTap: () => _authWithAnimation('edu', () => context.read<DatingProvider>().authEdu()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthCard({required IconData icon, required String title, required bool verified, required VoidCallback onTap}) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: verified ? null : onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: CupertinoColors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, size: 32, color: verified ? CupertinoColors.systemGreen : CupertinoColors.systemGrey),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1C1C1E))),
                  Text(verified ? '已认证' : '未认证', style: TextStyle(fontSize: 13, color: verified ? CupertinoColors.systemGreen : CupertinoColors.systemGrey)),
                ],
              ),
            ),
            Icon(
              verified ? CupertinoIcons.checkmark_seal_fill : CupertinoIcons.chevron_right,
              size: 24,
              color: verified ? CupertinoColors.systemGreen : CupertinoColors.systemGrey,
            ),
          ],
        ),
      ),
    );
  }
}
