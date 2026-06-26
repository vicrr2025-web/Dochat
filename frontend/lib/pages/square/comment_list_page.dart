import 'package:flutter/cupertino.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/models/post_models.dart';
import 'package:dochat_app/services/post_service.dart';

class CommentListPage extends StatefulWidget {
  final String postId;
  final PostInfo post;

  const CommentListPage({super.key, required this.postId, required this.post});

  @override
  State<CommentListPage> createState() => _CommentListPageState();
}

class _CommentListPageState extends State<CommentListPage> {
  final PostService _postService = PostService();
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<CommentInfo> _comments = [];
  bool _isLoading = true;
  String? _replyToUserId;
  String? _replyToNickname;
  String? _replyToCommentId;
  int _page = 0;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _loadComments();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        _loadMoreComments();
      }
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadComments() async {
    try {
      final result = await _postService.getComments(widget.postId, _page);
      setState(() {
        if (_page == 0) {
          _comments = result.content;
        } else {
          _comments.addAll(result.content);
        }
        _hasMore = result.page < result.totalPages - 1;
        _isLoading = false;
      });
    } catch (_) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadMoreComments() async {
    if (!_hasMore || _isLoading) return;
    _page++;
    await _loadComments();
  }

  Future<void> _sendComment() async {
    final content = _inputController.text.trim();
    if (content.isEmpty) return;

    try {
      await _postService.addComment(
        widget.postId,
        content,
        replyToUserId: _replyToUserId,
        parentId: _replyToCommentId,
      );
      _inputController.clear();
      setState(() {
        _replyToUserId = null;
        _replyToNickname = null;
        _replyToCommentId = null;
      });
      _page = 0;
      await _loadComments();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.comments),
      ),
      child: SafeArea(
        child: Column(
          children: [
            _buildPostSummary(context),
            Expanded(
              child: _isLoading
                  ? const Center(child: CupertinoActivityIndicator())
                  : _comments.isEmpty
                      ? Center(
                          child: Text(
                            l10n.noComments,
                            style: const TextStyle(
                              color: CupertinoColors.systemGrey,
                              fontSize: 14,
                            ),
                          ),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          itemCount: _comments.length,
                          itemBuilder: (context, index) {
                            return _buildCommentItem(context, _comments[index], l10n);
                          },
                        ),
            ),
            _buildInputBar(l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildPostSummary(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: CupertinoColors.systemGrey5, width: 0.5),
        ),
      ),
      child: Text(
        widget.post.content ?? '',
        style: const TextStyle(fontSize: 14, color: CupertinoColors.systemGrey),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildCommentItem(BuildContext context, CommentInfo comment, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: CupertinoColors.systemGrey6, width: 0.3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipOval(
            child: comment.userAvatar != null && comment.userAvatar!.isNotEmpty
                ? Image.network(comment.userAvatar!, width: 30, height: 30, fit: BoxFit.cover)
                : Container(
                    width: 30,
                    height: 30,
                    color: CupertinoColors.systemGrey4,
                    child: const Icon(CupertinoIcons.person, size: 18, color: CupertinoColors.white),
                  ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 13, color: CupertinoColors.black),
                    children: [
                      TextSpan(
                        text: comment.userNickname,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      if (comment.replyToUserId != null)
                        const TextSpan(text: '  '),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  comment.content,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      _formatTime(comment.createdAt, l10n),
                      style: const TextStyle(fontSize: 11, color: CupertinoColors.systemGrey),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _replyToUserId = comment.userId;
                          _replyToNickname = comment.userNickname;
                          _replyToCommentId = comment.commentId;
                        });
                      },
                      child: Text(
                        l10n.reply,
                        style: const TextStyle(fontSize: 12, color: CupertinoColors.systemGrey),
                      ),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () {},
                      child: Row(
                        children: [
                          const Icon(CupertinoIcons.heart, size: 14, color: CupertinoColors.systemGrey),
                          const SizedBox(width: 2),
                          Text(
                            '${comment.likeCount}',
                            style: const TextStyle(fontSize: 12, color: CupertinoColors.systemGrey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: CupertinoColors.systemGrey5, width: 0.5),
        ),
        color: CupertinoColors.white,
      ),
      child: Row(
        children: [
          Expanded(
            child: CupertinoTextField(
              controller: _inputController,
              placeholder: _replyToNickname != null
                  ? '@$_replyToNickname...'
                  : l10n.saySomething,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          const SizedBox(width: 8),
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: Text(l10n.publish),
            onPressed: _sendComment,
          ),
        ],
      ),
    );
  }

  String _formatTime(String isoTimestamp, AppLocalizations l10n) {
    try {
      final dt = DateTime.parse(isoTimestamp);
      final now = DateTime.now();
      final diff = now.difference(dt);
      if (diff.inMinutes < 1) return l10n.justNow;
      if (diff.inMinutes < 60) return '${diff.inMinutes}${l10n.minAgo}';
      if (diff.inHours < 24) return '${diff.inHours}${l10n.hourAgo}';
      return '${dt.month}/${dt.day}';
    } catch (_) {
      return isoTimestamp;
    }
  }
}
