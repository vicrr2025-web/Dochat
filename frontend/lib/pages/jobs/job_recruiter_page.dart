import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/providers/job_provider.dart';

class JobRecruiterPage extends StatefulWidget {
  const JobRecruiterPage({super.key});

  @override
  State<JobRecruiterPage> createState() => _JobRecruiterPageState();
}

class _JobRecruiterPageState extends State<JobRecruiterPage> {
  final _mockPositions = [
    {'title': '高级前端工程师', 'views': 328, 'applies': 12, 'boosted': false},
    {'title': 'Flutter 开发工程师', 'views': 156, 'applies': 8, 'boosted': true},
    {'title': '后端开发（Java）', 'views': 89, 'applies': 3, 'boosted': false},
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.jobRecruiter),
      ),
      child: SafeArea(
        child: Consumer<JobProvider>(
          builder: (context, provider, _) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                CupertinoButton(
                  color: const Color(0xFF007AFF),
                  borderRadius: BorderRadius.circular(10),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(CupertinoIcons.plus_circle, color: CupertinoColors.white, size: 20),
                      const SizedBox(width: 8),
                      Text(l10n.publishPosition, style: const TextStyle(color: CupertinoColors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  onPressed: () => _showPublishDialog(l10n, provider),
                ),
                const SizedBox(height: 16),
                Text(l10n.positionStats, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Color(0xFF1C1C1E))),
                const SizedBox(height: 10),
                ..._mockPositions.map((pos) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Container(
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
                              Expanded(
                                child: Text(pos['title'] as String, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1C1C1E))),
                              ),
                              if (pos['boosted'] as bool)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(color: const Color(0xFFFF9500).withOpacity(0.15), borderRadius: BorderRadius.circular(4)),
                                  child: const Text('加油中', style: TextStyle(fontSize: 11, color: Color(0xFFFF9500), fontWeight: FontWeight.w500)),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              _statItem(CupertinoIcons.eye_fill, '${pos['views']} 浏览'),
                              const SizedBox(width: 16),
                              _statItem(CupertinoIcons.doc_text_fill, '${pos['applies']} 投递'),
                              const Spacer(),
                              CupertinoButton(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                color: CupertinoColors.systemGrey6,
                                borderRadius: BorderRadius.circular(14),
                                minSize: 0,
                                child: Text(l10n.boostPosition, style: const TextStyle(fontSize: 13, color: Color(0xFF007AFF))),
                                onPressed: () {
                                  showCupertinoDialog(
                                    context: context,
                                    builder: (_) => CupertinoAlertDialog(
                                      title: Text(l10n.boostPosition),
                                      content: const Text('确认购买曝光加油？'),
                                      actions: [
                                        CupertinoDialogAction(child: Text(l10n.cancel), onPressed: () => Navigator.pop(context)),
                                        CupertinoDialogAction(
                                          isDefaultAction: true,
                                          child: const Text('确认'),
                                          onPressed: () => Navigator.pop(context),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _statItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 13, color: CupertinoColors.systemGrey),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12, color: CupertinoColors.systemGrey)),
      ],
    );
  }

  void _showPublishDialog(AppLocalizations l10n, JobProvider provider) {
    final titleCtl = TextEditingController();
    final descCtl = TextEditingController();
    final cityCtl = TextEditingController();
    final salaryMinCtl = TextEditingController();
    final salaryMaxCtl = TextEditingController();

    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: Text(l10n.publishPosition),
        content: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CupertinoTextField(controller: titleCtl, placeholder: l10n.positionTitle),
              const SizedBox(height: 8),
              CupertinoTextField(controller: cityCtl, placeholder: '城市'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: CupertinoTextField(controller: salaryMinCtl, placeholder: '最低薪资(k)', keyboardType: TextInputType.number)),
                  const SizedBox(width: 8),
                  Expanded(child: CupertinoTextField(controller: salaryMaxCtl, placeholder: '最高薪资(k)', keyboardType: TextInputType.number)),
                ],
              ),
              const SizedBox(height: 8),
              CupertinoTextField(controller: descCtl, placeholder: '职位描述', maxLines: 3),
            ],
          ),
        ),
        actions: [
          CupertinoDialogAction(child: Text(l10n.cancel), onPressed: () => Navigator.pop(context)),
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text(l10n.confirm),
            onPressed: () {
              provider.publishPosition({
                'title': titleCtl.text,
                'city': cityCtl.text,
                'salaryMin': int.tryParse(salaryMinCtl.text) ?? 0,
                'salaryMax': int.tryParse(salaryMaxCtl.text) ?? 0,
                'description': descCtl.text,
              });
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
