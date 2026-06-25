import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/models/chat_models.dart';

import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/models/friend_models.dart';
import 'package:dochat_app/providers/friend_provider.dart';
import 'package:dochat_app/pages/friends/request_list_page.dart';
import 'package:dochat_app/pages/friends/search_friend_page.dart';
import 'package:dochat_app/pages/chat/chat_page.dart';

class FriendListPage extends StatefulWidget {
  const FriendListPage({super.key});

  @override
  State<FriendListPage> createState() => _FriendListPageState();
}

class _FriendListPageState extends State<FriendListPage> {
  int _segmentedIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<FriendProvider>();
      provider.loadFriends();
      provider.loadPendingRequests();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<FriendInfo> _filteredFriends() {
    final provider = context.watch<FriendProvider>();
    if (_searchQuery.isEmpty) return provider.friends;
    return provider.friends
        .where((f) => f.nickname.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final provider = context.watch<FriendProvider>();
    final filteredFriends = _filteredFriends();

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.friends),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              minSize: 44,
              onPressed: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(builder: (_) => const RequestListPage()),
                );
              },
              child: Stack(
                children: [
                  const Icon(CupertinoIcons.bell, size: 24),
                  if (provider.pendingRequestCount > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: CupertinoColors.destructiveRed,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${provider.pendingRequestCount}',
                          style: const TextStyle(
                            color: CupertinoColors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              minSize: 44,
              onPressed: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(builder: (_) => const SearchFriendPage()),
                );
              },
              child: const Icon(CupertinoIcons.add, size: 24),
            ),
          ],
        ),
      ),
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            CupertinoSliverRefreshControl(
              onRefresh: () async {
                await provider.loadFriends();
                await provider.loadPendingRequests();
              },
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: CupertinoSegmentedControl<int>(
                  selectedColor: CupertinoColors.activeBlue,
                  unselectedColor: CupertinoColors.systemGrey5,
                  borderColor: CupertinoColors.systemGrey4,
                  groupValue: _segmentedIndex,
                  onValueChanged: (value) {
                    setState(() => _segmentedIndex = value);
                  },
                  children: {
                    0: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      child: Text(l10n.friends, style: const TextStyle(fontSize: 14)),
                    ),
                    1: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      child: Text(l10n.groups, style: const TextStyle(fontSize: 14)),
                    ),
                  },
                ),
              ),
            ),
            if (_segmentedIndex == 0) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: CupertinoSearchTextField(
                    controller: _searchController,
                    placeholder: l10n.search,
                    onChanged: (value) {
                      setState(() => _searchQuery = value);
                    },
                  ),
                ),
              ),
              if (provider.isLoading && filteredFriends.isEmpty)
                const SliverFillRemaining(
                  child: Center(child: CupertinoActivityIndicator()),
                )
              else if (filteredFriends.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Text(
                      l10n.noMessages,
                      style: const TextStyle(
                        color: CupertinoColors.systemGrey,
                        fontSize: 15,
                      ),
                    ),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final friend = filteredFriends[index];
                      return Dismissible(
                        key: Key(friend.userId),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: CupertinoColors.destructiveRed,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: Text(
                            l10n.delete,
                            style: const TextStyle(color: CupertinoColors.white),
                          ),
                        ),
                        confirmDismiss: (_) async {
                          _showDeleteConfirmation(context, friend);
                          return false;
                        },
                        child: CupertinoListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: Container(
                              width: 50,
                              height: 50,
                              color: CupertinoColors.systemGrey4,
                              child: friend.avatar != null
                                  ? Image.network(friend.avatar!, fit: BoxFit.cover)
                                  : const Icon(
                                      CupertinoIcons.person_fill,
                                      color: CupertinoColors.systemGrey,
                                    ),
                            ),
                          ),
                          title: Text(
                            friend.nickname,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          subtitle: friend.status != null
                              ? Text(friend.status!, style: const TextStyle(fontSize: 12))
                              : null,
                          trailing: CupertinoButton(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            minSize: 0,
                            onPressed: () {
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
                            child: const Text(
                              '发消息',
                              style: TextStyle(fontSize: 13, color: CupertinoColors.activeBlue),
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: filteredFriends.length,
                  ),
                ),
            ] else
              SliverFillRemaining(
                child: Center(
                  child: Text(
                    l10n.comingSoon,
                    style: const TextStyle(
                      color: CupertinoColors.systemGrey,
                      fontSize: 15,
                    ),
                  ),
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
