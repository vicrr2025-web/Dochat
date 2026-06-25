import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/providers/dating_provider.dart';

class DatingFeedPage extends StatefulWidget {
  const DatingFeedPage({super.key});

  @override
  State<DatingFeedPage> createState() => _DatingFeedPageState();
}

class _DatingFeedPageState extends State<DatingFeedPage> {
  final _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DatingProvider>().loadFeeds();
    });
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  void _showPublishDialog() {
    final l10n = AppLocalizations.of(context);
    _contentController.clear();
    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: Text(l10n.publishFeed),
        content: Column(
          children: [
            const SizedBox(height: 8),
            CupertinoTextField(
              controller: _contentController,
              maxLines: 4,
              placeholder: '分享你的心情...',
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 8),
            CupertinoButton(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              color: CupertinoColors.systemGrey5,
              borderRadius: BorderRadius.circular(16),
              child: Text(l10n.aiGenerate, style: const TextStyle(fontSize: 14)),
              onPressed: () {
                _contentController.text = '今天又是元气满满的一天！加油，遇见更好的自己 ✨';
              },
            ),
          ],
        ),
        actions: [
          CupertinoDialogAction(child: const Text('取消'), onPressed: () => Navigator.pop(context)),
          CupertinoDialogAction(
            child: const Text('发布'),
            onPressed: () {
              final text = _contentController.text.trim();
              if (text.isNotEmpty) {
                context.read<DatingProvider>().createFeed(text);
              }
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final provider = context.watch<DatingProvider>();

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.datingFeed),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.add_circled_solid, size: 28, color: Color(0xFFFF6B8A)),
          onPressed: _showPublishDialog,
        ),
      ),
      child: SafeArea(
        child: provider.isLoading
            ? const Center(child: CupertinoActivityIndicator())
            : provider.feeds.isEmpty
                ? Center(child: Text('暂无动态', style: const TextStyle(color: CupertinoColors.systemGrey)))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: provider.feeds.length,
                    itemBuilder: (context, index) {
                      final feed = provider.feeds[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: CupertinoColors.white,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                ClipOval(
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    color: CupertinoColors.systemGrey5,
                                    child: const Icon(CupertinoIcons.person_alt, size: 24, color: CupertinoColors.systemGrey3),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(feed.userName ?? '用户', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                                      Text(feed.createdAt, style: const TextStyle(fontSize: 11, color: CupertinoColors.systemGrey)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(feed.content, style: const TextStyle(fontSize: 15, color: Color(0xFF1C1C1E))),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => provider.toggleFeedLike(feed.feedId),
                                  child: Row(
                                    children: [
                                      Icon(
                                        feed.isLiked ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                                        size: 20,
                                        color: feed.isLiked ? const Color(0xFFFF6B8A) : CupertinoColors.systemGrey,
                                      ),
                                      const SizedBox(width: 4),
                                      Text('${feed.likeCount}', style: const TextStyle(fontSize: 13, color: CupertinoColors.systemGrey)),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 24),
                                Row(
                                  children: [
                                    const Icon(CupertinoIcons.chat_bubble, size: 20, color: CupertinoColors.systemGrey),
                                    const SizedBox(width: 4),
                                    Text('${feed.commentCount}', style: const TextStyle(fontSize: 13, color: CupertinoColors.systemGrey)),
                                  ],
                                ),
                              ],
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
