import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/providers/chat_provider.dart';
import 'package:dochat_app/pages/chat/chat_page.dart';

class JobChatPage extends StatefulWidget {
  const JobChatPage({super.key});

  @override
  State<JobChatPage> createState() => _JobChatPageState();
}

class _JobChatPageState extends State<JobChatPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatProvider>().loadSessions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.messagesLabel),
      ),
      child: SafeArea(
        child: Consumer<ChatProvider>(
          builder: (context, provider, _) {
            if (provider.sessions.isEmpty) {
              return Center(
                child: Text(l10n.noPositionHint,
                    style: const TextStyle(color: CupertinoColors.systemGrey)),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: provider.sessions.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final session = provider.sessions[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => ChatPage(session: session),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: CupertinoColors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: CupertinoColors.systemGrey5, width: 0.5),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(
                            color: CupertinoColors.systemGrey6,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(CupertinoIcons.person_fill,
                              size: 24, color: CupertinoColors.systemGrey),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                session.name,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF1C1C1E)),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                session.lastMessage ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 13,
                                    color: CupertinoColors.systemGrey),
                              ),
                            ],
                          ),
                        ),
                        if (session.unreadCount > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: const BoxDecoration(
                              color: CupertinoColors.destructiveRed,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '${session.unreadCount}',
                              style: const TextStyle(
                                  color: CupertinoColors.white, fontSize: 11),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
