import 'package:flutter/cupertino.dart';
import 'package:dochat_app/l10n/app_localizations.dart';

class JobCommunityPage extends StatefulWidget {
  const JobCommunityPage({super.key});

  @override
  State<JobCommunityPage> createState() => _JobCommunityPageState();
}

class _JobCommunityPageState extends State<JobCommunityPage> {
  int _selectedTab = 0;

  final _mockFeeds = [
    {'user': '陈工', 'avatar': null, 'content': '刚从大厂裸辞，有没有一起找工作的朋友？互相鼓励一下！', 'likes': 128, 'comments': 34},
    {'user': '产品小王', 'avatar': null, 'content': '分享一个面试技巧：STAR 法则真的很管用，准备了一周拿了 3 个 offer', 'likes': 256, 'comments': 89},
    {'user': 'HR学姐', 'avatar': null, 'content': '简历上这 5 个坑千万别踩：1. 假大空 2. 没有数据支撑 3. 格式混乱...', 'likes': 512, 'comments': 167},
    {'user': '程序员老李', 'avatar': null, 'content': '远程办公 3 年了，分享一下我是怎么保持效率和沟通的', 'likes': 89, 'comments': 23},
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.jobCommunity),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: CupertinoSlidingSegmentedControl<int>(
                    groupValue: _selectedTab,
                    children: const {
                      0: Text('推荐'),
                      1: Text('求职'),
                      2: Text('专家服务'),
                    },
                    onValueChanged: (v) {
                      if (v != null) setState(() => _selectedTab = v);
                    },
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: _mockFeeds.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final feed = _mockFeeds[index];
                      return Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: CupertinoColors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: CupertinoColors.systemGrey5, width: 0.5),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: const BoxDecoration(
                                    color: CupertinoColors.systemGrey6,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(CupertinoIcons.person_fill, size: 18, color: CupertinoColors.systemGrey),
                                ),
                                const SizedBox(width: 10),
                                Text(feed['user'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1C1C1E))),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(feed['content'] as String, style: const TextStyle(fontSize: 14, color: Color(0xFF3C3C43), height: 1.4)),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Icon(CupertinoIcons.heart, size: 16, color: CupertinoColors.systemGrey),
                                const SizedBox(width: 4),
                                Text('${feed['likes']}', style: const TextStyle(fontSize: 13, color: CupertinoColors.systemGrey)),
                                const SizedBox(width: 20),
                                const Icon(CupertinoIcons.chat_bubble, size: 16, color: CupertinoColors.systemGrey),
                                const SizedBox(width: 4),
                                Text('${feed['comments']}', style: const TextStyle(fontSize: 13, color: CupertinoColors.systemGrey)),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 16,
              right: 16,
              child: CupertinoButton(
                color: const Color(0xFF007AFF),
                borderRadius: BorderRadius.circular(24),
                padding: const EdgeInsets.all(14),
                minSize: 48,
                child: const Icon(CupertinoIcons.add, color: CupertinoColors.white, size: 24),
                onPressed: () {
                  showCupertinoDialog(
                    context: context,
                    builder: (_) {
                      final ctl = TextEditingController();
                      return CupertinoAlertDialog(
                        title: const Text('发布动态'),
                        content: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: CupertinoTextField(
                            controller: ctl,
                            placeholder: '分享你的职场心得...',
                            maxLines: 4,
                          ),
                        ),
                        actions: [
                          CupertinoDialogAction(child: Text(l10n.cancel), onPressed: () => Navigator.pop(context)),
                          CupertinoDialogAction(
                            isDefaultAction: true,
                            child: const Text('发布'),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
