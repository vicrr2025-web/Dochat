import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/models/chat_models.dart';
import 'package:dochat_app/providers/chat_provider.dart';
import 'package:dochat_app/pages/chat/chat_page.dart';
import 'package:dochat_app/pages/chat/select_friend_page.dart';

class SessionListPage extends StatefulWidget {
  const SessionListPage({super.key});

  @override
  State<SessionListPage> createState() => _SessionListPageState();
}

class _SessionListPageState extends State<SessionListPage> {
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<ChatProvider>().loadSessions();
      }
    });
  }

  String _formatTime(DateTime? dt, AppLocalizations l10n) {
    if (dt == null) return '';
    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inMinutes < 1) return l10n.justNow;
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';

    final today = DateTime(now.year, now.month, now.day);
    final msgDay = DateTime(dt.year, dt.month, dt.day);
    if (msgDay == today) {
      return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    }

    final yesterday = today.subtract(const Duration(days: 1));
    if (msgDay == yesterday) return l10n.yesterday;

    if (dt.year == now.year) {
      return '${dt.month}-${dt.day}';
    }
    return '${dt.year}-${dt.month}-${dt.day}';
  }

  String _lastMsgPreview(SessionInfo session) {
    if (session.lastMessage == null || session.lastMessage!.isEmpty) return '';
    if (session.lastMessage!.length > 20) {
      return '${session.lastMessage!.substring(0, 20)}...';
    }
    return session.lastMessage!;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: Text(l10n.chat),
            trailing: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (_) => const SelectFriendPage(),
                  ),
                );
              },
              child: const Icon(CupertinoIcons.add_circled_solid),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: CupertinoSearchTextField(
                placeholder: l10n.search,
                onChanged: (_) {
                  _debounce?.cancel();
                  _debounce = Timer(const Duration(milliseconds: 500), () {});
                },
              ),
            ),
          ),
          Consumer<ChatProvider>(
            builder: (context, chat, _) {
              if (chat.isLoadingSessions && chat.sessions.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(child: CupertinoActivityIndicator()),
                );
              }

              if (chat.sessions.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Text(
                      l10n.noMessages,
                      style: const TextStyle(
                        color: Color(0xFF8E8E93),
                        fontSize: 15,
                      ),
                    ),
                  ),
                );
              }

              final sorted = List<SessionInfo>.from(chat.sessions)
                ..sort((a, b) {
                  if (a.isPinned != b.isPinned) {
                    return a.isPinned ? -1 : 1;
                  }
                  final aTime = a.lastTime?.millisecondsSinceEpoch ?? 0;
                  final bTime = b.lastTime?.millisecondsSinceEpoch ?? 0;
                  return bTime.compareTo(aTime);
                });

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final session = sorted[index];
                    return _SessionRow(
                      session: session,
                      l10n: l10n,
                      formatTime: _formatTime,
                      lastMsgPreview: _lastMsgPreview,
                      onTap: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (_) => ChatPage(session: session),
                          ),
                        );
                      },
                      onSwipeAction: (action) {
                        switch (action) {
                          case SwipeAction.pin:
                            chat.pinSession(session.sessionId, !session.isPinned);
                          case SwipeAction.mute:
                            chat.muteSession(session.sessionId, !session.isMuted);
                          case SwipeAction.delete:
                            chat.deleteSession(session.sessionId);
                        }
                      },
                    );
                  },
                  childCount: sorted.length,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

enum SwipeAction { pin, mute, delete }

class _SessionRow extends StatefulWidget {
  final SessionInfo session;
  final AppLocalizations l10n;
  final String Function(DateTime?, AppLocalizations) formatTime;
  final String Function(SessionInfo) lastMsgPreview;
  final VoidCallback onTap;
  final void Function(SwipeAction) onSwipeAction;

  const _SessionRow({
    required this.session,
    required this.l10n,
    required this.formatTime,
    required this.lastMsgPreview,
    required this.onTap,
    required this.onSwipeAction,
  });

  @override
  State<_SessionRow> createState() => _SessionRowState();
}

class _SessionRowState extends State<_SessionRow> {
  double _dragOffset = 0;
  static const double _actionWidth = 72;

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset =
          (_dragOffset + details.delta.dx).clamp(-_actionWidth * 3, 0.0);
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (_dragOffset < -_actionWidth * 2.5) {
      widget.onSwipeAction(SwipeAction.delete);
      setState(() => _dragOffset = 0);
    } else if (_dragOffset < -_actionWidth * 1.5) {
      widget.onSwipeAction(SwipeAction.mute);
      setState(() => _dragOffset = 0);
    } else if (_dragOffset < -_actionWidth * 0.5) {
      widget.onSwipeAction(SwipeAction.pin);
      setState(() => _dragOffset = 0);
    } else {
      setState(() => _dragOffset = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = widget.session;
    final l10n = widget.l10n;

    return GestureDetector(
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      onTap: widget.onTap,
      child: Stack(
        children: [
          Positioned.fill(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _ActionButton(
                  label: session.isPinned ? l10n.unpin : l10n.pin,
                  color: const Color(0xFF007AFF),
                  width: _actionWidth,
                  onTap: () => widget.onSwipeAction(SwipeAction.pin),
                ),
                _ActionButton(
                  label: session.isMuted ? l10n.unmute : l10n.mute,
                  color: const Color(0xFFFF9500),
                  width: _actionWidth,
                  onTap: () => widget.onSwipeAction(SwipeAction.mute),
                ),
                _ActionButton(
                  label: l10n.delete,
                  color: const Color(0xFFFF3B30),
                  width: _actionWidth,
                  onTap: () => widget.onSwipeAction(SwipeAction.delete),
                ),
              ],
            ),
          ),
          Transform.translate(
            offset: Offset(_dragOffset, 0),
            child: Container(
              color: CupertinoColors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    ClipOval(
                      child: session.avatar != null
                          ? Image.network(
                              session.avatar!,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (_, e, s) => Container(
                                width: 50,
                                height: 50,
                                color: const Color(0xFFE9E9EB),
                                child: const Icon(
                                  CupertinoIcons.person_fill,
                                  color: Color(0xFF8E8E93),
                                  size: 28,
                                ),
                              ),
                            )
                          : Container(
                              width: 50,
                              height: 50,
                              color: const Color(0xFFE9E9EB),
                              child: const Icon(
                                CupertinoIcons.person_fill,
                                color: Color(0xFF8E8E93),
                                size: 28,
                              ),
                            ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  session.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              if (session.isPinned)
                                const Padding(
                                  padding: EdgeInsets.only(left: 4),
                                  child: Text('📌', style: TextStyle(fontSize: 13)),
                                ),
                              if (session.isMuted)
                                const Padding(
                                  padding: EdgeInsets.only(left: 2),
                                  child: Text('🔕', style: TextStyle(fontSize: 13)),
                                ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.lastMsgPreview(session),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF8E8E93),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          widget.formatTime(session.lastTime, l10n),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF8E8E93),
                          ),
                        ),
                        if (session.unreadCount > 0)
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: const BoxDecoration(
                              color: Color(0xFFFF3B30),
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              session.unreadCount > 99
                                  ? '99+'
                                  : '${session.unreadCount}',
                              style: const TextStyle(
                                color: CupertinoColors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final Color color;
  final double width;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.color,
    required this.width,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        color: color,
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
            color: CupertinoColors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
