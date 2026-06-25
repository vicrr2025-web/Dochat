import 'package:flutter/cupertino.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/pages/square/drafts_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.profile),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 24),
            Center(
              child: Column(
                children: [
                  ClipOval(
                    child: Container(
                      width: 80,
                      height: 80,
                      color: CupertinoColors.systemGrey4,
                      child: const Icon(CupertinoIcons.person, size: 40, color: CupertinoColors.white),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'User',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'ID: 10001',
                    style: TextStyle(fontSize: 13, color: CupertinoColors.systemGrey),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: const [
                          Text('0', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          Text('Following', style: TextStyle(fontSize: 12, color: CupertinoColors.systemGrey)),
                        ],
                      ),
                      const SizedBox(width: 32),
                      Column(
                        children: const [
                          Text('0', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          Text('Followers', style: TextStyle(fontSize: 12, color: CupertinoColors.systemGrey)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            CupertinoListSection(
              children: [
                CupertinoListTile(
                  title: Text(l10n.myPosts),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () {
                    showCupertinoDialog(
                      context: context,
                      builder: (ctx) => CupertinoAlertDialog(
                        title: Text(l10n.myPosts),
                        content: Text(l10n.comingSoon),
                        actions: [
                          CupertinoDialogAction(
                            child: Text(l10n.confirm),
                            onPressed: () => Navigator.pop(ctx),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                CupertinoListTile(
                  title: Text(l10n.myFollowing),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () {
                    showCupertinoDialog(
                      context: context,
                      builder: (ctx) => CupertinoAlertDialog(
                        title: Text(l10n.myFollowing),
                        content: Text(l10n.comingSoon),
                        actions: [
                          CupertinoDialogAction(
                            child: Text(l10n.confirm),
                            onPressed: () => Navigator.pop(ctx),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                CupertinoListTile(
                  title: Text(l10n.myFollowers),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () {
                    showCupertinoDialog(
                      context: context,
                      builder: (ctx) => CupertinoAlertDialog(
                        title: Text(l10n.myFollowers),
                        content: Text(l10n.comingSoon),
                        actions: [
                          CupertinoDialogAction(
                            child: Text(l10n.confirm),
                            onPressed: () => Navigator.pop(ctx),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            CupertinoListSection(
              children: [
                CupertinoListTile(
                  title: Text(l10n.favorites),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () {
                    showCupertinoDialog(
                      context: context,
                      builder: (ctx) => CupertinoAlertDialog(
                        title: Text(l10n.favorites),
                        content: Text(l10n.comingSoon),
                        actions: [
                          CupertinoDialogAction(
                            child: Text(l10n.confirm),
                            onPressed: () => Navigator.pop(ctx),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                CupertinoListTile(
                  title: Text(l10n.drafts),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (_) => const DraftsPage()),
                    );
                  },
                ),
                CupertinoListTile(
                  title: Text(l10n.viewHistory),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () {
                    showCupertinoDialog(
                      context: context,
                      builder: (ctx) => CupertinoAlertDialog(
                        title: Text(l10n.viewHistory),
                        content: Text(l10n.comingSoon),
                        actions: [
                          CupertinoDialogAction(
                            child: Text(l10n.confirm),
                            onPressed: () => Navigator.pop(ctx),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: CupertinoButton(
                child: Text(l10n.editProfile),
                onPressed: () {},
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
