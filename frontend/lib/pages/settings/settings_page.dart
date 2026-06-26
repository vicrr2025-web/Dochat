import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/providers/settings_provider.dart';
import 'package:dochat_app/providers/auth_provider.dart';
import 'package:dochat_app/pages/settings/profile_edit_page.dart';
import 'package:dochat_app/pages/settings/realname_verify_page.dart';
import 'package:dochat_app/pages/settings/device_manage_page.dart';
import 'package:dochat_app/pages/settings/privacy_settings_page.dart';
import 'package:dochat_app/pages/auth/login_page.dart';

String _creditLevelText(String level, AppLocalizations l10n) {
  switch (level) {
    case 'gold':
      return l10n.goldCredit;
    case 'silver':
      return l10n.silverCredit;
    case 'copper':
      return l10n.copperCredit;
    default:
      return level;
  }
}


class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<SettingsProvider>();
      provider.loadProfile();
    });
  }

  void _showChangePasswordDialog(BuildContext context, AppLocalizations l10n) {
    final currentCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();

    showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text(l10n.changePassword),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            CupertinoTextField(
              controller: currentCtrl,
              placeholder: l10n.currentPassword,
              obscureText: true,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            const SizedBox(height: 10),
            CupertinoTextField(
              controller: newCtrl,
              placeholder: l10n.newPassword,
              obscureText: true,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            const SizedBox(height: 10),
            CupertinoTextField(
              controller: confirmCtrl,
              placeholder: l10n.confirmPassword,
              obscureText: true,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            child: Text(l10n.cancel),
            onPressed: () => Navigator.pop(ctx),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text(l10n.confirm),
            onPressed: () async {
              final current = currentCtrl.text;
              final newPwd = newCtrl.text;
              final confirm = confirmCtrl.text;
              if (newPwd != confirm) {
                Navigator.pop(ctx);
                showCupertinoDialog(
                  context: context,
                  builder: (ctx) => CupertinoAlertDialog(
                    title: Text(l10n.passwordMismatch),
                    actions: [
                      CupertinoDialogAction(
                        child: Text(l10n.confirm),
                        onPressed: () => Navigator.of(ctx).pop(),
                      ),
                    ],
                  ),
                );
                return;
              }
              Navigator.pop(ctx);
              final provider = context.read<SettingsProvider>();
              final ok = await provider.changePassword(current, newPwd);
              if (ok) {
                showCupertinoDialog(
                  context: context,
                  builder: (ctx) => CupertinoAlertDialog(
                    title: Text(l10n.passwordChanged),
                    actions: [
                      CupertinoDialogAction(
                        child: Text(l10n.confirm),
                        onPressed: () => Navigator.of(ctx).pop(),
                      ),
                    ],
                  ),
                );
              } else {
                showCupertinoDialog(
                  context: context,
                  builder: (ctx) => CupertinoAlertDialog(
                    title: Text(l10n.wrongPassword),
                    actions: [
                      CupertinoDialogAction(
                        child: Text(l10n.confirm),
                        onPressed: () => Navigator.of(ctx).pop(),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  void _showLanguageSheet(BuildContext context, AppLocalizations l10n) {
    showCupertinoModalPopup(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        title: Text(l10n.language),
        actions: [
          CupertinoActionSheetAction(
            child: const Text('中文'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          CupertinoActionSheetAction(
            child: const Text('English'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text(l10n.cancel),
          onPressed: () => Navigator.of(ctx).pop(),
        ),
      ),
    );
  }

  void _showPaymentDialog(BuildContext context, AppLocalizations l10n) {
    showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text(l10n.paymentSettings),
        content: Text(l10n.notBound),
        actions: [
          CupertinoDialogAction(
            child: Text(l10n.confirm),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ],
      ),
    );
  }

  void _showStorageDialog(BuildContext context, AppLocalizations l10n) {
    final provider = context.read<SettingsProvider>();
    provider.loadStorage();
    showCupertinoDialog(
      context: context,
      builder: (ctx) {
        return Consumer<SettingsProvider>(
          builder: (context, p, _) {
            final storage = p.storage;
            if (storage == null) {
              return const CupertinoAlertDialog(
                content: Center(child: CupertinoActivityIndicator()),
              );
            }
            final totalMB = (storage.total / (1024 * 1024)).toStringAsFixed(1);
            final chatMB = (storage.chat / (1024 * 1024)).toStringAsFixed(1);
            final imagesMB = (storage.images / (1024 * 1024)).toStringAsFixed(1);
            final videosMB = (storage.videos / (1024 * 1024)).toStringAsFixed(1);
            final otherMB = (storage.other / (1024 * 1024)).toStringAsFixed(1);
            return CupertinoAlertDialog(
              title: Text(l10n.storageManagement),
              content: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${l10n.storage_label}: $totalMB MB'),
                    const SizedBox(height: 4),
                    Text('${l10n.chat}: $chatMB MB'),
                    Text('${l10n.image}: $imagesMB MB'),
                    Text('${l10n.videoMode}: $videosMB MB'),
                    Text('${l10n.other}: $otherMB MB'),
                  ],
                ),
              ),
              actions: [
                CupertinoDialogAction(
                  isDestructiveAction: true,
                  child: Text(l10n.clearCache),
                  onPressed: () {
                    Navigator.pop(ctx);
                  },
                ),
                CupertinoDialogAction(
                  child: Text(l10n.cancel),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAboutDialog(BuildContext context, AppLocalizations l10n) {
    showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text(l10n.aboutUs),
        content: Text(
          '${l10n.appName}\n\n${l10n.version}: 1.0.0\n${l10n.copyright}\n\ndochat@example.com',
        ),
        actions: [
          CupertinoDialogAction(
            child: Text(l10n.confirm),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ],
      ),
    );
  }

  void _showSignOutDialog(BuildContext context, AppLocalizations l10n) {
    showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text(l10n.signOut),
        content: Text(l10n.signOutMessage),
        actions: [
          CupertinoDialogAction(
            child: Text(l10n.cancel),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: Text(l10n.signOutConfirm),
            onPressed: () {
              Navigator.of(ctx).pop();
              final authProvider = context.read<AuthProvider>();
              authProvider.logout();
              Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                CupertinoPageRoute(builder: (_) => const LoginPage()),
                (_) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  void _showPlaceholder(BuildContext context, String title) {
    final l10n = AppLocalizations.of(context);
    showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(l10n.comingSoon),
        actions: [
          CupertinoDialogAction(
            child: Text(l10n.confirm),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.settings),
      ),
      child: SafeArea(
        child: Consumer<SettingsProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading && provider.profile == null) {
              return const Center(child: CupertinoActivityIndicator());
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  _buildProfileCard(context, l10n, provider),
                  const SizedBox(height: 16),
                  _buildAccountSection(context, l10n),
                  _buildGeneralSection(context, l10n),
                  _buildStorageSection(context, l10n),
                  _buildPrivacySection(context, l10n),
                  _buildAboutSection(context, l10n),
                  _buildOtherSection(context, l10n),
                  const SizedBox(height: 32),
                  _buildSignOutButton(context, l10n),
                  const SizedBox(height: 32),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, AppLocalizations l10n, SettingsProvider provider) {
    final profile = provider.profile;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(builder: (_) => const ProfileEditPage()),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            ClipOval(
              child: profile?.avatar != null && profile!.avatar.isNotEmpty
                  ? Image.network(
                      profile.avatar,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 80,
                        height: 80,
                        color: CupertinoColors.systemGrey4,
                        child: const Icon(CupertinoIcons.person, size: 40, color: CupertinoColors.systemGrey),
                      ),
                    )
                  : Container(
                      width: 80,
                      height: 80,
                      color: CupertinoColors.systemGrey4,
                      child: const Icon(CupertinoIcons.person, size: 40, color: CupertinoColors.systemGrey),
                    ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          profile?.nickname ?? '--',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1C1C1E),
                          ),
                        ),
                      ),
                      if (profile?.isVerified == true) ...[
                        const SizedBox(width: 6),
                        const Icon(
                          CupertinoIcons.checkmark_seal_fill,
                          size: 18,
                          color: CupertinoColors.systemBlue,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_creditLevelText(profile?.creditLevel ?? 'copper', l10n)} · ${l10n.creditScoreLabel}: ${profile?.creditScore ?? 0}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              CupertinoIcons.chevron_right,
              color: CupertinoColors.systemGrey3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountSection(BuildContext context, AppLocalizations l10n) {
    return CupertinoListSection.insetGrouped(
      header: Text(l10n.account),
      children: [
        CupertinoListTile(
          title: Text(l10n.realNameVerify),
          trailing: const Icon(CupertinoIcons.chevron_right, color: CupertinoColors.systemGrey3),
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (_) => const RealnameVerifyPage()),
            );
          },
        ),
        CupertinoListTile(
          title: Text(l10n.changePassword),
          trailing: const Icon(CupertinoIcons.chevron_right, color: CupertinoColors.systemGrey3),
          onTap: () => _showChangePasswordDialog(context, l10n),
        ),
        CupertinoListTile(
          title: Text(l10n.deviceManagement),
          trailing: const Icon(CupertinoIcons.chevron_right, color: CupertinoColors.systemGrey3),
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (_) => const DeviceManagePage()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildGeneralSection(BuildContext context, AppLocalizations l10n) {
    return CupertinoListSection.insetGrouped(
      header: Text(l10n.general),
      children: [
        CupertinoListTile(
          title: Text(l10n.language),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '中文',
                style: TextStyle(color: CupertinoColors.systemGrey, fontSize: 16),
              ),
              const Icon(CupertinoIcons.chevron_right, color: CupertinoColors.systemGrey3),
            ],
          ),
          onTap: () => _showLanguageSheet(context, l10n),
        ),
      ],
    );
  }

  Widget _buildStorageSection(BuildContext context, AppLocalizations l10n) {
    return CupertinoListSection.insetGrouped(
      header: Text(l10n.storage_label),
      children: [
        CupertinoListTile(
          title: Text(l10n.storageManagement),
          trailing: const Icon(CupertinoIcons.chevron_right, color: CupertinoColors.systemGrey3),
          onTap: () => _showStorageDialog(context, l10n),
        ),
      ],
    );
  }

  Widget _buildPrivacySection(BuildContext context, AppLocalizations l10n) {
    return CupertinoListSection.insetGrouped(
      header: Text(l10n.privacyPolicy),
      children: [
        CupertinoListTile(
          title: Text(l10n.privacyPolicy),
          trailing: const Icon(CupertinoIcons.chevron_right, color: CupertinoColors.systemGrey3),
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (_) => const PrivacySettingsPage()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildAboutSection(BuildContext context, AppLocalizations l10n) {
    return CupertinoListSection.insetGrouped(
      header: Text(l10n.about),
      children: [
        CupertinoListTile(
          title: Text(l10n.aboutUs),
          trailing: const Icon(CupertinoIcons.chevron_right, color: CupertinoColors.systemGrey3),
          onTap: () => _showAboutDialog(context, l10n),
        ),
      ],
    );
  }

  Widget _buildOtherSection(BuildContext context, AppLocalizations l10n) {
    return CupertinoListSection.insetGrouped(
      header: Text(l10n.other),
      children: [
      ],
    );
  }

  Widget _buildSignOutButton(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: CupertinoButton(
        color: CupertinoColors.destructiveRed,
        borderRadius: BorderRadius.circular(12),
        child: Text(
          l10n.signOut,
          style: const TextStyle(color: CupertinoColors.white),
        ),
        onPressed: () => _showSignOutDialog(context, l10n),
      ),
    );
  }
}
