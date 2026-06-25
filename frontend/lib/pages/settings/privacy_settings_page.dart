import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/models/settings_models.dart';
import 'package:dochat_app/providers/settings_provider.dart';

String _privacyLabel(String key, AppLocalizations l10n) {
  switch (key) {
    case 'all':
      return l10n.everyone;
    case 'friends':
      return l10n.friendsOnly;
    case 'none':
      return l10n.nobody;
    default:
      return key;
  }
}

class PrivacySettingsPage extends StatefulWidget {
  const PrivacySettingsPage({super.key});

  @override
  State<PrivacySettingsPage> createState() => _PrivacySettingsPageState();
}

class _PrivacySettingsPageState extends State<PrivacySettingsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SettingsProvider>().loadPrivacy();
    });
  }

  void _showPrivacySheet(
    BuildContext context,
    AppLocalizations l10n,
    SettingsProvider provider,
    String currentValue,
    String field,
    String Function(PrivacySettings) getValue,
    PrivacySettings Function(PrivacySettings, String) updateValue,
  ) {
    showCupertinoModalPopup(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(ctx).pop();
              final updated = updateValue(provider.privacy ?? PrivacySettings(), 'all');
              provider.updatePrivacy(updated);
            },
            child: Row(
              children: [
                if (currentValue == 'all')
                  const Icon(CupertinoIcons.checkmark, size: 18, color: CupertinoColors.systemBlue),
                const SizedBox(width: 8),
                Text(
                  l10n.everyone,
                  style: TextStyle(
                    color: currentValue == 'all'
                        ? CupertinoColors.systemBlue
                        : CupertinoColors.label,
                  ),
                ),
              ],
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(ctx).pop();
              final updated = updateValue(provider.privacy ?? PrivacySettings(), 'friends');
              provider.updatePrivacy(updated);
            },
            child: Row(
              children: [
                if (currentValue == 'friends')
                  const Icon(CupertinoIcons.checkmark, size: 18, color: CupertinoColors.systemBlue),
                const SizedBox(width: 8),
                Text(
                  l10n.friendsOnly,
                  style: TextStyle(
                    color: currentValue == 'friends'
                        ? CupertinoColors.systemBlue
                        : CupertinoColors.label,
                  ),
                ),
              ],
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(ctx).pop();
              final updated = updateValue(provider.privacy ?? PrivacySettings(), 'none');
              provider.updatePrivacy(updated);
            },
            child: Row(
              children: [
                if (currentValue == 'none')
                  const Icon(CupertinoIcons.checkmark, size: 18, color: CupertinoColors.systemBlue),
                const SizedBox(width: 8),
                Text(
                  l10n.nobody,
                  style: TextStyle(
                    color: currentValue == 'none'
                        ? CupertinoColors.systemBlue
                        : CupertinoColors.label,
                  ),
                ),
              ],
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text(l10n.cancel),
          onPressed: () => Navigator.of(ctx).pop(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.privacyPolicy),
      ),
      child: SafeArea(
        child: Consumer<SettingsProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading && provider.privacy == null) {
              return const Center(child: CupertinoActivityIndicator());
            }

            final privacy = provider.privacy ?? PrivacySettings();

            return ListView(
              children: [
                const SizedBox(height: 8),
                CupertinoListSection.insetGrouped(
                  header: const Text(''),
                  children: [
                    CupertinoListTile(
                      title: Text(l10n.onlineVisibility),
                      trailing: Text(
                        _privacyLabel(privacy.onlineVisibility, l10n),
                        style: const TextStyle(
                          color: CupertinoColors.systemGrey,
                          fontSize: 16,
                        ),
                      ),
                      onTap: () => _showPrivacySheet(
                        context,
                        l10n,
                        provider,
                        privacy.onlineVisibility,
                        'onlineVisibility',
                        (s) => s.onlineVisibility,
                        (s, v) => s.copyWith(onlineVisibility: v),
                      ),
                    ),
                    CupertinoListTile(
                      title: Text(l10n.avatarVisibility),
                      trailing: Text(
                        _privacyLabel(privacy.avatarVisibility, l10n),
                        style: const TextStyle(
                          color: CupertinoColors.systemGrey,
                          fontSize: 16,
                        ),
                      ),
                      onTap: () => _showPrivacySheet(
                        context,
                        l10n,
                        provider,
                        privacy.avatarVisibility,
                        'avatarVisibility',
                        (s) => s.avatarVisibility,
                        (s, v) => s.copyWith(avatarVisibility: v),
                      ),
                    ),
                    CupertinoListTile(
                      title: Text(l10n.bioVisibility),
                      trailing: Text(
                        _privacyLabel(privacy.bioVisibility, l10n),
                        style: const TextStyle(
                          color: CupertinoColors.systemGrey,
                          fontSize: 16,
                        ),
                      ),
                      onTap: () => _showPrivacySheet(
                        context,
                        l10n,
                        provider,
                        privacy.bioVisibility,
                        'bioVisibility',
                        (s) => s.bioVisibility,
                        (s, v) => s.copyWith(bioVisibility: v),
                      ),
                    ),
                    CupertinoListTile(
                      title: Text(l10n.messagePermission),
                      trailing: Text(
                        _privacyLabel(privacy.messagePermission, l10n),
                        style: const TextStyle(
                          color: CupertinoColors.systemGrey,
                          fontSize: 16,
                        ),
                      ),
                      onTap: () => _showPrivacySheet(
                        context,
                        l10n,
                        provider,
                        privacy.messagePermission,
                        'messagePermission',
                        (s) => s.messagePermission,
                        (s, v) => s.copyWith(messagePermission: v),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                CupertinoListSection.insetGrouped(
                  header: Text(l10n.blacklist),
                  children: [
                    CupertinoListTile(
                      title: Text(
                        l10n.noBlacklist,
                        style: const TextStyle(
                          color: CupertinoColors.systemGrey,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
