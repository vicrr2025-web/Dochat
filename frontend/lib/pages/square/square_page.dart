import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/models/post_models.dart';
import 'package:dochat_app/providers/post_provider.dart';
import 'package:dochat_app/pages/square/comment_list_page.dart';
import 'package:dochat_app/pages/square/video_browse_page.dart';
import 'package:dochat_app/pages/square/profile_page.dart';

class SquarePage extends StatefulWidget {
  const SquarePage({super.key});

  @override
  State<SquarePage> createState() => _SquarePageState();
}

class _SquarePageState extends State<SquarePage> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final provider = context.read<PostProvider>();
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!provider.isLoading && provider.hasMore) {
        provider.loadMore();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: Text(l10n.square),
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (_) => const ProfilePage(),
                  ),
                );
              },
              child: const Icon(CupertinoIcons.person_circle),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _SegmentHeaderDelegate(context),
          ),
          SliverToBoxAdapter(
            child: Consumer<PostProvider>(
              builder: (context, provider, _) {
                if (provider.errorMessage != null &&
                    provider.currentPosts.isEmpty) {
                  return _buildErrorView(l10n);
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          Consumer<PostProvider>(
            builder: (context, provider, _) {
              if (provider.isRefreshing && provider.currentPosts.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(child: CupertinoActivityIndicator()),
                );
              }
              if (provider.currentPosts.isEmpty && !provider.isLoading) {
                return SliverFillRemaining(
                  child: _buildEmptyView(l10n),
                );
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index >= provider.currentPosts.length) {
                      return _buildLoadMoreIndicator(provider);
                    }
                    return _PostCard(post: provider.currentPosts[index]);
                  },
                  childCount: provider.currentPosts.length + 1,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(CupertinoIcons.wifi_slash, size: 48, color: CupertinoColors.systemGrey),
            const SizedBox(height: 16),
            Text(l10n.networkError),
            const SizedBox(height: 16),
            CupertinoButton.filled(
              child: Text(l10n.confirm),
              onPressed: () {
                context.read<PostProvider>().loadFeed('recommend', refresh: true);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyView(AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Text(
          l10n.noPosts,
          style: const TextStyle(
            color: CupertinoColors.systemGrey,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildLoadMoreIndicator(PostProvider provider) {
    if (provider.hasMore) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CupertinoActivityIndicator()),
      );
    }
    return const SizedBox.shrink();
  }
}

class _SegmentHeaderDelegate extends SliverPersistentHeaderDelegate {
  final BuildContext context;

  _SegmentHeaderDelegate(this.context);

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final l10n = AppLocalizations.of(context);
    final provider = context.watch<PostProvider>();

    return Container(
      color: CupertinoTheme.of(context).barBackgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: CupertinoSlidingSegmentedControl<String>(
        groupValue: provider.currentFeed,
        onValueChanged: (value) {
          if (value != null) {
            provider.switchFeed(value);
            provider.loadFeed(value, refresh: true);
          }
        },
        children: {
          'recommend': Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(l10n.recommend),
          ),
          'following': Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(l10n.following),
          ),
          'moments': Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(l10n.moments),
          ),
        },
      ),
    );
  }

  @override
  double get maxExtent => 52;

  @override
  double get minExtent => 52;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
}

class _PostCard extends StatefulWidget {
  final PostInfo post;

  _PostCard({required this.post});

  @override
  State<_PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<_PostCard> {
  bool _contentExpanded = false;
  bool _isFollowed = false;

  @override
  void initState() {
    super.initState();
    _isFollowed = post.isFollowing;
  }

  PostInfo get post => widget.post;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, l10n),
            if (post.content != null && post.content!.isNotEmpty) ...[
              const SizedBox(height: 8),
              _buildContent(),
            ],
            if (post.mediaUrls.isNotEmpty) ...[
              const SizedBox(height: 8),
              _buildMediaGrid(context),
            ],
            if (post.location != null && post.location!.isNotEmpty) ...[
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(CupertinoIcons.location, size: 12, color: CupertinoColors.systemGrey),
                  const SizedBox(width: 2),
                  Text(
                    post.location!,
                    style: const TextStyle(fontSize: 12, color: CupertinoColors.systemGrey),
                  ),
                  if (post.visibility == 'private') ...[
                    const SizedBox(width: 8),
                    const Icon(CupertinoIcons.lock, size: 12, color: CupertinoColors.systemGrey),
                  ],
                ],
              ),
            ],
            if (post.visibility == 'private' && (post.location == null || post.location!.isEmpty))
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    const Icon(CupertinoIcons.lock, size: 12, color: CupertinoColors.systemGrey),
                    const SizedBox(width: 4),
                    Text(
                      l10n.private,
                      style: const TextStyle(fontSize: 12, color: CupertinoColors.systemGrey),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 8),
            _buildBottomBar(context, l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n) {
    final distance = (Random().nextDouble() * 20).toStringAsFixed(1);

    return Row(
      children: [
        ClipOval(
          child: post.userAvatar != null && post.userAvatar!.isNotEmpty
              ? Image.network(post.userAvatar!, width: 40, height: 40, fit: BoxFit.cover)
              : Container(
                  width: 40,
                  height: 40,
                  color: CupertinoColors.systemGrey4,
                  child: const Icon(CupertinoIcons.person, color: CupertinoColors.white),
                ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.userNickname,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              Text(
                _formatTime(post.createdAt, l10n),
                style: const TextStyle(fontSize: 12, color: CupertinoColors.systemGrey),
              ),
            ],
          ),
        ),
        Text(
          '$distance km',
          style: const TextStyle(fontSize: 12, color: CupertinoColors.systemGrey),
        ),
        const SizedBox(width: 8),
        CupertinoButton(
          padding: EdgeInsets.zero,
          minSize: 28,
          child: Text(
            _isFollowed ? l10n.following : l10n.follow,
            style: TextStyle(
              fontSize: 12,
              color: _isFollowed ? CupertinoColors.systemGrey : CupertinoColors.activeBlue,
            ),
          ),
          onPressed: () {
            final provider = context.read<PostProvider>();
            provider.toggleFollow(widget.post.userId);
            setState(() {
              _isFollowed = !_isFollowed;
            });
          },
        ),
      ],
    );
  }

  Widget _buildContent() {
    return GestureDetector(
      onTap: () {
        setState(() => _contentExpanded = !_contentExpanded);
      },
      child: Text(
        post.content!,
        style: const TextStyle(fontSize: 15),
        maxLines: _contentExpanded ? null : 3,
        overflow: _contentExpanded ? null : TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildMediaGrid(BuildContext context) {
    final urls = post.mediaUrls;
    if (post.mediaType == 'video') {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (_) => VideoBrowsePage(post: post),
            ),
          );
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: urls.isNotEmpty
                  ? Image.network(urls.first, width: double.infinity, height: 200, fit: BoxFit.cover)
                  : Container(width: double.infinity, height: 200, color: CupertinoColors.systemGrey5),
            ),
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromRGBO(0, 0, 0, 0.5),
              ),
              child: const Icon(CupertinoIcons.play_fill, color: CupertinoColors.white, size: 24),
            ),
            if (post.mediaDuration != null)
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(0, 0, 0, 0.6),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _formatDuration(post.mediaDuration!),
                    style: const TextStyle(color: CupertinoColors.white, fontSize: 12),
                  ),
                ),
              ),
          ],
        ),
      );
    }

    if (urls.length == 1) {
      return GestureDetector(
        onTap: () => _previewImage(context, urls, 0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(urls.first, width: double.infinity, height: 200, fit: BoxFit.cover),
        ),
      );
    }

    final crossAxisCount = urls.length <= 4 ? 2 : 3;
    final itemCount = urls.length;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        childAspectRatio: 1,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _previewImage(context, urls, index),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.network(urls[index], fit: BoxFit.cover),
          ),
        );
      },
    );
  }

  void _previewImage(BuildContext context, List<String> urls, int initialIndex) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (_) => _ImagePreviewPage(urls: urls, initialIndex: initialIndex),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, AppLocalizations l10n) {
    final provider = context.read<PostProvider>();

    return Row(
      children: [
        GestureDetector(
          onTap: () => provider.toggleLike(post.postId),
          child: Row(
            children: [
              Icon(
                post.isLiked ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                size: 20,
                color: post.isLiked ? CupertinoColors.destructiveRed : CupertinoColors.systemGrey,
              ),
              const SizedBox(width: 4),
              Text(
                '${post.likeCount}',
                style: const TextStyle(fontSize: 13, color: CupertinoColors.systemGrey),
              ),
            ],
          ),
        ),
        const SizedBox(width: 24),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (_) => CommentListPage(postId: post.postId, post: post),
              ),
            );
          },
          child: Row(
            children: [
              const Icon(CupertinoIcons.chat_bubble, size: 20, color: CupertinoColors.systemGrey),
              const SizedBox(width: 4),
              Text(
                '${post.commentCount}',
                style: const TextStyle(fontSize: 13, color: CupertinoColors.systemGrey),
              ),
            ],
          ),
        ),
        const SizedBox(width: 24),
        const Icon(CupertinoIcons.arrow_2_squarepath, size: 20, color: CupertinoColors.systemGrey),
      ],
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
      if (diff.inDays < 7) return '${diff.inDays}${l10n.dayAgo}';
      return '${dt.month}/${dt.day}';
    } catch (_) {
      return isoTimestamp;
    }
  }

  String _formatDuration(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
}

class _ImagePreviewPage extends StatelessWidget {
  final List<String> urls;
  final int initialIndex;

  const _ImagePreviewPage({required this.urls, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.black,
      child: Stack(
        children: [
          PageView.builder(
            controller: PageController(initialPage: initialIndex),
            itemCount: urls.length,
            itemBuilder: (context, index) {
              return InteractiveViewer(
                maxScale: 3,
                child: Center(
                  child: Image.network(urls[index]),
                ),
              );
            },
          ),
          Positioned(
            top: 44,
            left: 8,
            child: CupertinoButton(
              padding: const EdgeInsets.all(8),
              child: const Icon(CupertinoIcons.xmark, color: CupertinoColors.white, size: 28),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
