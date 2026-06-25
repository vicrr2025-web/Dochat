import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/providers/friend_provider.dart';

class SearchFriendPage extends StatefulWidget {
  const SearchFriendPage({super.key});

  @override
  State<SearchFriendPage> createState() => _SearchFriendPageState();
}

class _SearchFriendPageState extends State<SearchFriendPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final provider = context.watch<FriendProvider>();

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.addFriend),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CupertinoSearchTextField(
                controller: _phoneController,
                placeholder: l10n.enterPhone,
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    provider.searchUser(value.trim());
                  }
                },
              ),
              const SizedBox(height: 12),
              CupertinoButton.filled(
                onPressed: provider.isSearching
                    ? null
                    : () {
                        final phone = _phoneController.text.trim();
                        if (phone.isNotEmpty) {
                          provider.searchUser(phone);
                        }
                      },
                child: Text(
                  provider.isSearching ? l10n.loading : l10n.searchFriend,
                  style: const TextStyle(color: CupertinoColors.white),
                ),
              ),
              const SizedBox(height: 16),
              if (provider.isSearching)
                const Center(child: CupertinoActivityIndicator())
              else if (provider.errorMessage != null)
                Center(
                  child: Text(
                    l10n.userNotFound,
                    style: const TextStyle(
                      color: CupertinoColors.systemGrey,
                      fontSize: 15,
                    ),
                  ),
                )
              else if (provider.searchResult != null)
                Container(
                  decoration: BoxDecoration(
                    color: CupertinoColors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Container(
                          width: 50,
                          height: 50,
                          color: CupertinoColors.systemGrey4,
                          child: provider.searchResult!.avatar != null
                              ? Image.network(
                                  provider.searchResult!.avatar!,
                                  fit: BoxFit.cover,
                                )
                              : const Icon(
                                  CupertinoIcons.person_fill,
                                  color: CupertinoColors.systemGrey,
                                ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              provider.searchResult!.nickname,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'ID: ${provider.searchResult!.userId}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: CupertinoColors.systemGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        minSize: 0,
                        onPressed: provider.isLoading
                            ? null
                            : () => _showSendRequestDialog(context, provider),
                        child: const Text(
                          '发送申请',
                          style: TextStyle(
                            fontSize: 13,
                            color: CupertinoColors.activeBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSendRequestDialog(BuildContext context, FriendProvider provider) {
    final l10n = AppLocalizations.of(context);
    _messageController.clear();

    showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text(l10n.sendRequest),
        content: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: CupertinoTextField(
            controller: _messageController,
            placeholder: l10n.requestMessageHint,
            maxLength: 50,
          ),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.cancel),
          ),
          CupertinoDialogAction(
            onPressed: () async {
              final message = _messageController.text.trim();
              if (provider.searchResult == null) return;
              final success = await provider.sendRequest(
                provider.searchResult!.userId,
                message.isEmpty ? '你好，我想加你为好友' : message,
              );
              if (ctx.mounted) Navigator.of(ctx).pop();
              if (success && mounted) {
                Navigator.of(context).pop();
                showCupertinoDialog(
                  context: context,
                  builder: (c) => CupertinoAlertDialog(
                    title: Text(l10n.friendRequestSent),
                    actions: [
                      CupertinoDialogAction(
                        onPressed: () => Navigator.of(c).pop(),
                        child: Text(l10n.confirm),
                      ),
                    ],
                  ),
                );
              }
            },
            child: Text(l10n.send),
          ),
        ],
      ),
    );
  }
}
