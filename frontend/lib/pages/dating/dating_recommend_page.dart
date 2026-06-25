import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/providers/dating_provider.dart';

class DatingRecommendPage extends StatefulWidget {
  const DatingRecommendPage({super.key});

  @override
  State<DatingRecommendPage> createState() => _DatingRecommendPageState();
}

class _DatingRecommendPageState extends State<DatingRecommendPage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DatingProvider>().loadRecommendations();
    });
  }

  void _handleLike() async {
    final provider = context.read<DatingProvider>();
    if (_currentIndex >= provider.recommendations.length) return;
    final rec = provider.recommendations[_currentIndex];
    final result = await provider.likeUser(rec.userId);
    if (result != null && mounted) {
      final matched = result['matched'] as bool? ?? false;
      if (matched) {
        final l10n = AppLocalizations.of(context);
        showCupertinoDialog(
          context: context,
          builder: (_) => CupertinoAlertDialog(
            title: Text(l10n.matchedLabel),
            content: const Text('🎉 你们互相喜欢！开始聊天吧！'),
            actions: [CupertinoDialogAction(child: const Text('OK'), onPressed: () => Navigator.pop(context))],
          ),
        );
      }
    }
    setState(() {
      if (_currentIndex < provider.recommendations.length - 1) {
        _currentIndex++;
      } else {
        provider.loadRecommendations(page: (_currentIndex ~/ 10) + 1);
        _currentIndex = 0;
      }
    });
  }

  void _handlePass() {
    setState(() {
      if (_currentIndex < context.read<DatingProvider>().recommendations.length - 1) {
        _currentIndex++;
      }
    });
  }

  void _handleSuperLike() async {
    final provider = context.read<DatingProvider>();
    if (_currentIndex >= provider.recommendations.length) return;
    final rec = provider.recommendations[_currentIndex];
    await provider.superLikeUser(rec.userId);
    _handlePass();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final provider = context.watch<DatingProvider>();
    final recs = provider.recommendations;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text(l10n.matchRecommend)),
      child: SafeArea(
        child: provider.isLoading
            ? const Center(child: CupertinoActivityIndicator())
            : recs.isEmpty
                ? Center(child: Text(l10n.noRecommend, style: const TextStyle(fontSize: 16, color: CupertinoColors.systemGrey)))
                : Column(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onHorizontalDragEnd: (details) {
                            if (details.primaryVelocity != null && details.primaryVelocity! < -50) {
                              _handlePass();
                            } else if (details.primaryVelocity != null && details.primaryVelocity! > 50) {
                              _handleLike();
                            }
                          },
                          child: _currentIndex < recs.length
                              ? Container(
                                  margin: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    color: CupertinoColors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: const [
                                      BoxShadow(color: Color(0x1A000000), blurRadius: 12, offset: Offset(0, 4)),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                                          child: Container(
                                            color: CupertinoColors.systemGrey5,
                                            child: Center(
                                              child: Icon(
                                                recs[_currentIndex].gender == 'female' ? CupertinoIcons.person_alt : CupertinoIcons.person_alt,
                                                size: 80,
                                                color: CupertinoColors.systemGrey3,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    recs[_currentIndex].nickname ?? '用户',
                                                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                                                  ),
                                                  if (recs[_currentIndex].age != null) ...[
                                                    const SizedBox(width: 8),
                                                    Text('${recs[_currentIndex].age}岁',
                                                        style: const TextStyle(fontSize: 16, color: CupertinoColors.systemGrey)),
                                                  ],
                                                ],
                                              ),
                                              const SizedBox(height: 8),
                                              if (recs[_currentIndex].tags != null && recs[_currentIndex].tags!.isNotEmpty)
                                                Wrap(
                                                  spacing: 6,
                                                  children: recs[_currentIndex].tags!
                                                      .split(',')
                                                      .map((t) => Container(
                                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                            decoration: BoxDecoration(
                                                              color: const Color(0xFFFF6B8A).withOpacity(0.1),
                                                              borderRadius: BorderRadius.circular(12),
                                                            ),
                                                            child: Text(t, style: const TextStyle(fontSize: 12, color: Color(0xFFFF6B8A))),
                                                          ))
                                                      .toList(),
                                                ),
                                              if (recs[_currentIndex].aboutMe != null) ...[
                                                const SizedBox(height: 8),
                                                Expanded(
                                                  child: Text(
                                                    recs[_currentIndex].aboutMe!,
                                                    maxLines: 3,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: const TextStyle(fontSize: 14, color: CupertinoColors.systemGrey),
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Center(child: Text(l10n.noRecommend)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CupertinoButton(
                              padding: const EdgeInsets.all(12),
                              borderRadius: BorderRadius.circular(30),
                              color: CupertinoColors.white,
                              onPressed: _handlePass,
                              child: const Text('❌', style: TextStyle(fontSize: 30)),
                            ),
                            CupertinoButton(
                              padding: const EdgeInsets.all(12),
                              borderRadius: BorderRadius.circular(30),
                              color: const Color(0xFFFF6B8A),
                              onPressed: _handleLike,
                              child: const Text('💕', style: TextStyle(fontSize: 30)),
                            ),
                            CupertinoButton(
                              padding: const EdgeInsets.all(12),
                              borderRadius: BorderRadius.circular(30),
                              color: const Color(0xFFFFD700),
                              onPressed: _handleSuperLike,
                              child: const Text('⭐', style: TextStyle(fontSize: 30)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
