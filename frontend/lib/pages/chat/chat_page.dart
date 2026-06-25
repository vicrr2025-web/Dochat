import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/models/chat_models.dart';
import 'package:dochat_app/providers/chat_provider.dart';
import 'package:dochat_app/pages/chat/voice_record_widget.dart';
import 'package:dochat_app/pages/chat/image_picker_sheet.dart';

class ChatPage extends StatefulWidget {
  final SessionInfo session;

  const ChatPage({super.key, required this.session});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  bool _showVoiceRecord = false;
  bool _isLoadingMore = false;
  final bool _hasMore = true;
  Timer? _readTimer;

  SessionInfo get _session => widget.session;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      final chat = context.read<ChatProvider>();
      chat.loadMessages(_session.sessionId);
      chat.subscribeToSession(_session.sessionId);
      if (_session.unreadCount > 0) {
        chat.markAsRead(_session.sessionId, '');
      }
    });
    _scrollController.addListener(_onScroll);
    _textController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _readTimer?.cancel();
    _textController.removeListener(_onTextChanged);
    _textController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    context.read<ChatProvider>().unsubscribeFromSession(_session.sessionId);
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
  }

  void _onScroll() {
    if (_scrollController.position.pixels <= 50 && !_isLoadingMore && _hasMore) {
      final messages =
          context.read<ChatProvider>().messagesForSession(_session.sessionId);
      if (messages.isNotEmpty) {
        _isLoadingMore = true;
        context.read<ChatProvider>().loadMessages(
          _session.sessionId,
          before: messages.first.messageId,
        ).then((_) {
          _isLoadingMore = false;
        });
      }
    }
  }

  void _sendTextMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    final request = SendMessageRequest(
      sessionId: _session.sessionId,
      type: 'text',
      content: text,
    );
    context.read<ChatProvider>().sendMessage(request);
    _textController.clear();
  }

  void _handleImagePick() {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => const ImagePickerSheet(),
    ).then((result) {
      if (!mounted) return;
      if (result == 'camera' || result == 'album') {
        final request = SendMessageRequest(
          sessionId: _session.sessionId,
          type: 'image',
          mediaUrl: 'https://picsum.photos/400/400?random=${Random().nextInt(1000)}',
        );
        context.read<ChatProvider>().sendMessage(request);
      }
    });
  }

  void _handleFilePick() {
    final request = SendMessageRequest(
      sessionId: _session.sessionId,
      type: 'file',
      fileName: 'document.pdf',
      fileSize: 2048000,
      mediaUrl: 'https://example.com/file.pdf',
    );
    context.read<ChatProvider>().sendMessage(request);
  }

  void _showMessageActions(MessageInfo message, AppLocalizations l10n) {
    final isWithin24h =
        DateTime.now().difference(message.sentAt).inHours < 24;

    showCupertinoModalPopup(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        title: Text(
          message.type == 'text' ? (message.content ?? '') : '',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 13, color: Color(0xFF8E8E93)),
        ),
        actions: [
          if (message.type == 'text' && !message.isRecalled)
            CupertinoActionSheetAction(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: message.content ?? ''));
                Navigator.pop(ctx);
                if (mounted) {
                  showCupertinoDialog(
                    context: context,
                    builder: (_) => CupertinoAlertDialog(
                      content: Text(l10n.copied),
                      actions: [
                        CupertinoDialogAction(
                          child: Text(l10n.confirm),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: Text(l10n.copy),
            ),
          if (isWithin24h && !message.isRecalled && message.isMine)
            CupertinoActionSheetAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.pop(ctx);
                if (mounted) {
                  context.read<ChatProvider>().revokeMessage(message.messageId);
                }
              },
              child: Text(l10n.revoke),
            ),
          if (message.isMine)
            CupertinoActionSheetAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: Text(l10n.delete),
            ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text(l10n.cancel),
          onPressed: () => Navigator.pop(ctx),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(MessageInfo message, AppLocalizations l10n) {
    final isMine = message.isMine;

    if (message.isRecalled) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Center(
          child: Text(
            isMine ? l10n.youRecalled : l10n.otherRecalled,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF8E8E93),
            ),
          ),
        ),
      );
    }

    switch (message.type) {
      case 'image':
        return _buildImageBubble(message, isMine);
      case 'voice':
        return _buildVoiceBubble(message, isMine);
      case 'file':
        return _buildFileBubble(message, isMine);
      default:
        return _buildTextBubble(message, isMine);
    }
  }

  Widget _buildTextBubble(MessageInfo message, bool isMine) {
    return GestureDetector(
      onLongPress: () {
        _showMessageActions(message, AppLocalizations.of(context));
      },
      child: Container(
        margin: EdgeInsets.only(
          left: isMine ? 60 : 0,
          right: isMine ? 0 : 60,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isMine
              ? const Color(0xFF007AFF)
              : const Color(0xFFE9E9EB),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment:
              isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              message.content ?? '',
              style: TextStyle(
                fontSize: 16,
                color: isMine ? CupertinoColors.white : CupertinoColors.black,
              ),
            ),
            if (isMine)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (message.status == 'read')
                      const Icon(
                        CupertinoIcons.checkmark_alt,
                        size: 14,
                        color: Color(0xFF8E8E93),
                      )
                    else
                      const Icon(
                        CupertinoIcons.checkmark,
                        size: 14,
                        color: Color(0xFF8E8E93),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageBubble(MessageInfo message, bool isMine) {
    return GestureDetector(
      onLongPress: () {
        _showMessageActions(message, AppLocalizations.of(context));
      },
      onTap: () {
        if (message.mediaUrl != null) {
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (_) => _ImageViewer(imageUrl: message.mediaUrl!),
            ),
          );
        }
      },
      child: Container(
        margin: EdgeInsets.only(
          left: isMine ? 60 : 0,
          right: isMine ? 0 : 60,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(
            message.mediaUrl ?? '',
            width: 200,
            height: 200,
            fit: BoxFit.cover,
            errorBuilder: (_, e, s) => Container(
              width: 200,
              height: 200,
              color: const Color(0xFFE9E9EB),
              child: const Icon(
                CupertinoIcons.photo,
                color: Color(0xFF8E8E93),
              ),
            ),
            loadingBuilder: (_, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                width: 200,
                height: 200,
                color: const Color(0xFFE9E9EB),
                child: const Center(child: CupertinoActivityIndicator()),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildVoiceBubble(MessageInfo message, bool isMine) {
    final duration = message.mediaDuration ?? 1;
    final width = 60.0 + (duration.clamp(1, 60) * 1.5);
    final clampedWidth = width.clamp(60.0, 150.0);

    return GestureDetector(
      onLongPress: () {
        _showMessageActions(message, AppLocalizations.of(context));
      },
      child: Container(
        margin: EdgeInsets.only(
          left: isMine ? 60 : 0,
          right: isMine ? 0 : 60,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        width: clampedWidth,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF007AFF), Color(0xFF0055CC)],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Icon(
              CupertinoIcons.waveform,
              color: CupertinoColors.white,
              size: 20,
            ),
            const Spacer(),
            Text(
              "$duration''",
              style: const TextStyle(
                color: CupertinoColors.white,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileBubble(MessageInfo message, bool isMine) {
    return GestureDetector(
      onLongPress: () {
        _showMessageActions(message, AppLocalizations.of(context));
      },
      child: Container(
        margin: EdgeInsets.only(
          left: isMine ? 60 : 0,
          right: isMine ? 0 : 60,
        ),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFE9E9EB),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(CupertinoIcons.doc_fill, size: 36, color: Color(0xFF007AFF)),
            const SizedBox(width: 8),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.fileName ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    _formatFileSize(message.fileSize),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF8E8E93),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              CupertinoIcons.arrow_down_to_line,
              size: 20,
              color: Color(0xFF007AFF),
            ),
          ],
        ),
      ),
    );
  }

  String _formatFileSize(int? bytes) {
    if (bytes == null) return '';
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }


  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _session.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(width: 4),
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Color(0xFF34C759),
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                showCupertinoDialog(
                  context: context,
                  builder: (_) => CupertinoAlertDialog(
                    content: Text(l10n.comingSoon),
                    actions: [
                      CupertinoDialogAction(
                        child: Text(l10n.confirm),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                );
              },
              child: const Icon(CupertinoIcons.phone_fill, size: 22),
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                showCupertinoDialog(
                  context: context,
                  builder: (_) => CupertinoAlertDialog(
                    content: Text(l10n.comingSoon),
                    actions: [
                      CupertinoDialogAction(
                        child: Text(l10n.confirm),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                );
              },
              child: const Icon(CupertinoIcons.videocam_fill, size: 22),
            ),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Consumer<ChatProvider>(
                builder: (context, chat, _) {
                  final messages = List<MessageInfo>.from(
                    chat.messagesForSession(_session.sessionId),
                  ).reversed.toList();

                  if (chat.isLoadingMessages && messages.isEmpty) {
                    return const Center(child: CupertinoActivityIndicator());
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    itemCount: messages.length + (_isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= messages.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: CupertinoActivityIndicator()),
                        );
                      }
                      final message = messages[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildMessageBubble(message, l10n),
                      );
                    },
                  );
                },
              ),
            ),
            _buildInputBar(l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildInputBar(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: const BoxDecoration(
        color: Color(0xFFF2F2F7),
        border: Border(
          top: BorderSide(color: Color(0xFFDCDCE0), width: 0.5),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CupertinoButton(
            padding: const EdgeInsets.all(6),
            onPressed: () {
              setState(() {
                _showVoiceRecord = !_showVoiceRecord;
                if (!_showVoiceRecord) {
                  _focusNode.requestFocus();
                }
              });
            },
            child: Icon(
              _showVoiceRecord
                  ? CupertinoIcons.keyboard
                  : CupertinoIcons.mic_fill,
              size: 26,
              color: const Color(0xFF007AFF),
            ),
          ),
          if (_showVoiceRecord)
            Expanded(
              child: VoiceRecordWidget(
                onSend: (duration) {
                  final request = SendMessageRequest(
                    sessionId: _session.sessionId,
                    type: 'voice',
                    mediaDuration: duration,
                  );
                  context.read<ChatProvider>().sendMessage(request);
                },
              ),
            )
          else
            Expanded(
              child: CupertinoTextField(
                controller: _textController,
                focusNode: _focusNode,
                maxLines: 3,
                minLines: 1,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                placeholder: '',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          CupertinoButton(
            padding: const EdgeInsets.all(6),
            onPressed: () {
              showCupertinoModalPopup(
                context: context,
                builder: (_) => CupertinoActionSheet(
                  actions: [
                    CupertinoActionSheetAction(
                      onPressed: () {
                        Navigator.pop(context);
                        _handleImagePick();
                      },
                      child: Text(l10n.picture),
                    ),
                    CupertinoActionSheetAction(
                      onPressed: () {
                        Navigator.pop(context);
                        _handleImagePick();
                      },
                      child: Text(l10n.camera),
                    ),
                    CupertinoActionSheetAction(
                      onPressed: () {
                        Navigator.pop(context);
                        _handleFilePick();
                      },
                      child: Text(l10n.file),
                    ),
                  ],
                  cancelButton: CupertinoActionSheetAction(
                    child: Text(l10n.cancel),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              );
            },
            child: const Icon(
              CupertinoIcons.add_circled,
              size: 26,
              color: Color(0xFF007AFF),
            ),
          ),
          CupertinoButton(
            padding: const EdgeInsets.all(6),
            onPressed: _textController.text.trim().isNotEmpty
                ? _sendTextMessage
                : null,
            child: Icon(
              CupertinoIcons.arrow_up_circle_fill,
              size: 28,
              color: _textController.text.trim().isNotEmpty
                  ? const Color(0xFF007AFF)
                  : const Color(0xFFC7C7CC),
            ),
          ),
        ],
      ),
    );
  }
}

class _ImageViewer extends StatelessWidget {
  final String imageUrl;

  const _ImageViewer({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.black,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: const Color.fromRGBO(0, 0, 0, 0.8),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.pop(context),
          child: const Icon(
            CupertinoIcons.xmark,
            color: CupertinoColors.white,
          ),
        ),
      ),
      child: SafeArea(
        child: Center(
          child: InteractiveViewer(
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
              errorBuilder: (_, e, s) => const Icon(
                CupertinoIcons.exclamationmark_triangle,
                color: CupertinoColors.white,
                size: 48,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
