import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/providers/job_provider.dart';

class JobCandidatesPage extends StatefulWidget {
  const JobCandidatesPage({super.key});

  @override
  State<JobCandidatesPage> createState() => _JobCandidatesPageState();
}

class _JobCandidatesPageState extends State<JobCandidatesPage> {
  final _searchCtl = TextEditingController();

  final _mockCandidates = [
    {'name': '张工', 'skills': 'Flutter,Dart,React', 'education': '本科', 'experience': '5年', 'favorited': false},
    {'name': '李工程师', 'skills': 'Java,Spring,K8s', 'education': '硕士', 'experience': '3年', 'favorited': true},
    {'name': '王设计', 'skills': 'UI/UX,Figma,Sketch', 'education': '本科', 'experience': '4年', 'favorited': false},
    {'name': '赵研发', 'skills': 'Go,Python,AI', 'education': '博士', 'experience': '2年', 'favorited': false},
  ];

  @override
  void dispose() {
    _searchCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.jobCandidates),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: CupertinoSearchTextField(
                controller: _searchCtl,
                placeholder: l10n.jobSearch,
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: _mockCandidates.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final c = _mockCandidates[index];
                  final favorited = c['favorited'] as bool;
                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: CupertinoColors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: CupertinoColors.systemGrey5, width: 0.5),
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
                          child: const Icon(CupertinoIcons.person_fill, size: 24, color: CupertinoColors.systemGrey),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(c['name'] as String, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1C1C1E))),
                              const SizedBox(height: 4),
                              Text('${c['education']} · ${c['experience']}', style: const TextStyle(fontSize: 13, color: CupertinoColors.systemGrey)),
                              const SizedBox(height: 4),
                              Wrap(
                                spacing: 4,
                                children: (c['skills'] as String).split(',').map((s) => Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(color: CupertinoColors.systemGrey6, borderRadius: BorderRadius.circular(4)),
                                  child: Text(s.trim(), style: const TextStyle(fontSize: 11, color: CupertinoColors.systemGrey)),
                                )).toList(),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _mockCandidates[index]['favorited'] = !favorited;
                                });
                              },
                              child: Icon(
                                favorited ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                                color: favorited ? const Color(0xFFFF3B30) : CupertinoColors.systemGrey,
                                size: 22,
                              ),
                            ),
                            const SizedBox(height: 8),
                            CupertinoButton(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              color: const Color(0xFF007AFF),
                              borderRadius: BorderRadius.circular(12),
                              minSize: 0,
                              child: Text(l10n.interviewInvite, style: const TextStyle(fontSize: 11, color: CupertinoColors.white)),
                              onPressed: () {
                                showCupertinoDialog(
                                  context: context,
                                  builder: (_) => CupertinoAlertDialog(
                                    content: const Text('已发送面试邀请'),
                                    actions: [CupertinoDialogAction(child: const Text('OK'), onPressed: () => Navigator.pop(context))],
                                  ),
                                );
                              },
                            ),
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
      ),
    );
  }
}
