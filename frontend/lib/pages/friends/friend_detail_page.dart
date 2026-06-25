import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/models/chat_models.dart';

import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/models/friend_models.dart';
import 'package:dochat_app/providers/friend_provider.dart';
import 'package:dochat_app/pages/chat/chat_page.dart';
import 'package:dochat_app/pages/friends/location_page.dart';
import 'package:dochat_app/pages/friends/trajectory_page.dart';
import 'package:dochat_app/pages/friends/geofence_page.dart';

class FriendDetailPage extends StatelessWidget {
  final String friendId;

  const FriendDetailPage({super.key, required this.friendId});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final provider = context.watch<FriendProvider>();
    final friend = provider.friends.where((f) => f.userId == friendId).firstOrNull;

    if (friend == null) {
      return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(middle: Text(l10n.loading)),
        child: const Center(child: CupertinoActivityIndicator()),
      );
    }

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(friend.nickname),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Center(
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Container(
                      width: 80,
                      height: 80,
                      color: CupertinoColors.systemGrey4,
                      child: friend.avatar != null
                          ? Image.network(friend.avatar!, fit: BoxFit.cover)
                          : const Icon(
                              CupertinoIcons.person_fill,
                              color: CupertinoColors.systemGrey,
                              size: 40,
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    friend.nickname,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${l10n.creditScore} 100',
                    style: const TextStyle(
                      fontSize: 13,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            CupertinoListSection.insetGrouped(
              children: [
                CupertinoListTile(
                  title: Text(l10n.sendMessage),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (_) => ChatPage(
                          session: SessionInfo(
                            sessionId: friend.userId,
                            type: 'single',
                            name: friend.nickname,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                CupertinoListTile(
                  title: Text(l10n.liveLocation),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (_) => LocationPage(
                          friendId: friend.userId,
                          friendName: friend.nickname,
                        ),
                      ),
                    );
                  },
                ),
                CupertinoListTile(
                  title: Text(l10n.trajectory),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (_) => TrajectoryPage(
                          friendId: friend.userId,
                          friendName: friend.nickname,
                        ),
                      ),
                    );
                  },
                ),
                CupertinoListTile(
                  title: Text(l10n.geofence),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (_) => GeofencePage(
                          targetUserId: friend.userId,
                        ),
                      ),
                    );
                  },
                ),
                CupertinoListTile(
                  title: Text(l10n.envMonitor),
                  subtitle: Text(l10n.comingSoon),
                  trailing: const Icon(
                    CupertinoIcons.lock,
                    color: CupertinoColors.systemGrey3,
                    size: 18,
                  ),
                ),
                CupertinoListTile(
                  title: Text(l10n.cameraView),
                  subtitle: Text(l10n.comingSoon),
                  trailing: const Icon(
                    CupertinoIcons.lock,
                    color: CupertinoColors.systemGrey3,
                    size: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            CupertinoButton(
              color: CupertinoColors.destructiveRed,
              borderRadius: BorderRadius.circular(12),
              onPressed: () => _showDeleteConfirmation(context, friend),
              child: Text(
                l10n.removeFriend,
                style: const TextStyle(color: CupertinoColors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, FriendInfo friend) {
    final l10n = AppLocalizations.of(context);
    showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text(l10n.removeFriend),
        content: Text(l10n.removeFriendConfirm),
        actions: [
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              context.read<FriendProvider>().removeFriend(friend.userId);
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
            child: Text(l10n.confirm),
          ),
          CupertinoDialogAction(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }
}
