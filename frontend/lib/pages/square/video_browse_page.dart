import 'package:flutter/cupertino.dart';
import 'package:dochat_app/models/post_models.dart';

class VideoBrowsePage extends StatefulWidget {
  final PostInfo post;

  const VideoBrowsePage({super.key, required this.post});

  @override
  State<VideoBrowsePage> createState() => _VideoBrowsePageState();
}

class _VideoBrowsePageState extends State<VideoBrowsePage> {
  late PageController _pageController;
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _isLiked = widget.post.isLiked;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      child: Stack(
        children: [
          GestureDetector(
            onDoubleTap: () {
              setState(() {
                _isLiked = !_isLiked;
              });
              _showLikeAnimation();
            },
            child: Center(
              child: Container(
                color: const Color(0xFF1C1C1E),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.6,
                      color: CupertinoColors.systemGrey2,
                      child: const Center(
                        child: Icon(
                          CupertinoIcons.play_fill,
                          color: CupertinoColors.white,
                          size: 64,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 48,
            left: 16,
            child: CupertinoButton(
              padding: const EdgeInsets.all(8),
              child: const Icon(CupertinoIcons.xmark, color: CupertinoColors.white, size: 28),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Positioned(
            bottom: 40,
            right: 16,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isLiked = !_isLiked;
                    });
                    if (_isLiked) _showLikeAnimation();
                  },
                  child: Column(
                    children: [
                      Icon(
                        _isLiked ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                        color: _isLiked ? CupertinoColors.destructiveRed : CupertinoColors.white,
                        size: 32,
                      ),
                      Text(
                        '${widget.post.likeCount}',
                        style: const TextStyle(color: CupertinoColors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: () {},
                  child: Column(
                    children: [
                      const Icon(CupertinoIcons.chat_bubble, color: CupertinoColors.white, size: 32),
                      Text(
                        '${widget.post.commentCount}',
                        style: const TextStyle(color: CupertinoColors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Icon(CupertinoIcons.arrow_2_squarepath, color: CupertinoColors.white, size: 32),
              ],
            ),
          ),
          Positioned(
            bottom: 120,
            left: 16,
            right: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ClipOval(
                      child: widget.post.userAvatar != null && widget.post.userAvatar!.isNotEmpty
                          ? Image.network(widget.post.userAvatar!, width: 40, height: 40, fit: BoxFit.cover)
                          : Container(
                              width: 40,
                              height: 40,
                              color: CupertinoColors.systemGrey4,
                              child: const Icon(CupertinoIcons.person, color: CupertinoColors.white),
                            ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.post.userNickname,
                      style: const TextStyle(
                        color: CupertinoColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                if (widget.post.content != null && widget.post.content!.isNotEmpty)
                  Text(
                    widget.post.content!,
                    style: const TextStyle(color: CupertinoColors.white, fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          if (_showHeart)
            Positioned.fill(
              child: IgnorePointer(
                child: Center(
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 1.0, end: 0.0),
                    duration: const Duration(milliseconds: 800),
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.scale(
                          scale: 2 - value,
                          child: const Icon(
                            CupertinoIcons.heart_fill,
                            color: CupertinoColors.destructiveRed,
                            size: 80,
                          ),
                        ),
                      );
                    },
                    onEnd: () {
                      setState(() => _showHeart = false);
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  bool _showHeart = false;

  void _showLikeAnimation() {
    setState(() => _showHeart = true);
  }
}
