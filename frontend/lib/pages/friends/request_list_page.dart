import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/providers/friend_provider.dart';

class RequestListPage extends StatelessWidget {
  const RequestListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final provider = context.watch<FriendProvider>();
    final requests = provider.pendingRequests;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.friendRequests),
      ),
      child: SafeArea(
        child: provider.isLoading && requests.isEmpty
            ? const Center(child: CupertinoActivityIndicator())
            : requests.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          CupertinoIcons.person_2,
                          size: 48,
                          color: CupertinoColors.systemGrey3,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          l10n.noPendingRequests,
                          style: const TextStyle(
                            color: CupertinoColors.systemGrey,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: requests.length,
                    itemBuilder: (context, index) {
                      final req = requests[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: Container(
                          decoration: BoxDecoration(
                            color: CupertinoColors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  color: CupertinoColors.systemGrey4,
                                  child: req.fromAvatar != null
                                      ? Image.network(req.fromAvatar!, fit: BoxFit.cover)
                                      : const Icon(
                                          CupertinoIcons.person_fill,
                                          color: CupertinoColors.systemGrey,
                                          size: 24,
                                        ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      req.fromNickname,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    if (req.message != null && req.message!.isNotEmpty)
                                      Text(
                                        req.message!,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: CupertinoColors.systemGrey,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                  ],
                                ),
                              ),
                              if (req.isPending) ...[
                                CupertinoButton(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  minSize: 0,
                                  onPressed: () {
                                    provider.rejectRequest(req.requestId);
                                  },
                                  child: Text(
                                    l10n.reject,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: CupertinoColors.systemGrey,
                                    ),
                                  ),
                                ),
                                CupertinoButton(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  minSize: 0,
                                  onPressed: () {
                                    provider.acceptRequest(req.requestId);
                                  },
                                  child: Text(
                                    l10n.accept,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: CupertinoColors.activeBlue,
                                    ),
                                  ),
                                ),
                              ] else
                                Text(
                                  req.isAccepted ? l10n.accepted : l10n.rejected,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: CupertinoColors.systemGrey,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
