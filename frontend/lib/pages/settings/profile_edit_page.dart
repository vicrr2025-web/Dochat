import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/providers/settings_provider.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  late TextEditingController _nicknameCtrl;

  @override
  void initState() {
    super.initState();
    _nicknameCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _nicknameCtrl.dispose();
    super.dispose();
  }

  void _showAvatarSheet(BuildContext context, AppLocalizations l10n) {
    showCupertinoModalPopup(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        title: Text(l10n.editProfile),
        actions: [
          CupertinoActionSheetAction(
            child: Text(l10n.takePhoto ?? '拍照'),
            onPressed: () {
              Navigator.of(ctx).pop();
              showCupertinoDialog(
                context: context,
                builder: (ctx2) => CupertinoAlertDialog(
                  content: Text(l10n.comingSoon),
                  actions: [
                    CupertinoDialogAction(
                      child: Text(l10n.confirm),
                      onPressed: () => Navigator.of(ctx2).pop(),
                    ),
                  ],
                ),
              );
            },
          ),
          CupertinoActionSheetAction(
            child: Text(l10n.chooseFromAlbum ?? '从相册选择'),
            onPressed: () {
              Navigator.of(ctx).pop();
              showCupertinoDialog(
                context: context,
                builder: (ctx2) => CupertinoAlertDialog(
                  content: Text(l10n.comingSoon),
                  actions: [
                    CupertinoDialogAction(
                      child: Text(l10n.confirm),
                      onPressed: () => Navigator.of(ctx2).pop(),
                    ),
                  ],
                ),
              );
            },
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
        middle: Text(l10n.editProfile),
      ),
      child: SafeArea(
        child: Consumer<SettingsProvider>(
          builder: (context, provider, _) {
            final profile = provider.profile;
            if (profile != null && _nicknameCtrl.text.isEmpty) {
              _nicknameCtrl.text = profile.nickname;
            }

            final hasAvatar = profile != null && (profile.avatar?.isNotEmpty == true);

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => _showAvatarSheet(context, l10n),
                    child: Center(
                      child: ClipOval(
                        child: hasAvatar
                            ? Image.network(
                                profile!.avatar!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stack) => Container(
                                  width: 100,
                                  height: 100,
                                  color: CupertinoColors.systemGrey4,
                                  child: const Icon(
                                    CupertinoIcons.person,
                                    size: 50,
                                    color: CupertinoColors.systemGrey,
                                  ),
                                ),
                              )
                            : Container(
                                width: 100,
                                height: 100,
                                color: CupertinoColors.systemGrey4,
                                child: const Icon(
                                  CupertinoIcons.person,
                                  size: 50,
                                  color: CupertinoColors.systemGrey,
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.editProfile,
                    style: const TextStyle(
                      fontSize: 13,
                      color: CupertinoColors.systemBlue,
                    ),
                  ),
                  const SizedBox(height: 24),
                  CupertinoTextField(
                    controller: _nicknameCtrl,
                    placeholder: l10n.editProfile,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    clearButtonMode: OverlayVisibilityMode.editing,
                  ),
                  const SizedBox(height: 24),
                  CupertinoButton.filled(
                    child: Text(l10n.confirm),
                    onPressed: () async {
                      final nickname = _nicknameCtrl.text.trim();
                      if (nickname.isEmpty) return;
                      final ok = await provider.updateProfile(nickname: nickname);
                      if (ok && mounted) {
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
