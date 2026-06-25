import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/providers/job_provider.dart';

class JobExpertPage extends StatelessWidget {
  const JobExpertPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final provider = context.read<JobProvider>();

    final services = [
      (l10n.expertResumeSubmit, '专业HR帮你代投简历到目标企业，提高面试邀约率', '¥99/次', CupertinoIcons.paperplane_fill, 'resume_submit'),
      (l10n.expertResumeCustom, '资深简历顾问一对一为你定制优化简历', '¥199/次', CupertinoIcons.doc_richtext, 'resume_custom'),
      (l10n.expertCareerConsult, '职业规划师提供1小时深度职业咨询', '¥299/次', CupertinoIcons.person_2_fill, 'career_consult'),
      (l10n.expertJobButler, '专属求职管家全程陪跑，直到拿到offer', '¥999/月', CupertinoIcons.star_fill, 'job_butler'),
    ];

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.jobExpert),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: services.map((s) {
            final title = s.$1;
            final desc = s.$2;
            final price = s.$3;
            final icon = s.$4;
            final serviceType = s.$5;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: CupertinoColors.systemGrey5, width: 0.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [Color(0xFF007AFF), Color(0xFF5856D6)]),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(icon, color: CupertinoColors.white, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1C1C1E))),
                              const SizedBox(height: 2),
                              Text(desc, style: const TextStyle(fontSize: 13, color: CupertinoColors.systemGrey)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(price, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFFFF3B30))),
                        CupertinoButton(
                          color: const Color(0xFF007AFF),
                          borderRadius: BorderRadius.circular(16),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          minSize: 0,
                          child: const Text('购买', style: TextStyle(color: CupertinoColors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                          onPressed: () {
                            showCupertinoDialog(
                              context: context,
                              builder: (_) => CupertinoAlertDialog(
                                title: Text(title),
                                content: Text('确认购买 $price 的服务？'),
                                actions: [
                                  CupertinoDialogAction(child: Text(l10n.cancel), onPressed: () => Navigator.pop(context)),
                                  CupertinoDialogAction(
                                    isDefaultAction: true,
                                    child: Text(l10n.confirm),
                                    onPressed: () {
                                      provider.buyExpertService(serviceType);
                                      Navigator.pop(context);
                                      showCupertinoDialog(
                                        context: context,
                                        builder: (_) => CupertinoAlertDialog(
                                          content: const Text('购买成功！'),
                                          actions: [CupertinoDialogAction(child: const Text('OK'), onPressed: () => Navigator.pop(context))],
                                        ),
                                      );
                                    },
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
          }).toList(),
        ),
      ),
    );
  }
}
