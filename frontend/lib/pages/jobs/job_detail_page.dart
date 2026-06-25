import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/models/job_models.dart';
import 'package:dochat_app/providers/job_provider.dart';

class JobDetailPage extends StatelessWidget {
  final JobPosition position;
  const JobDetailPage({super.key, required this.position});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tags = position.tags?.split(',') ?? [];

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(position.title ?? ''),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
              children: [
                _companyHeader(l10n),
                const SizedBox(height: 12),
                _infoRow(l10n, tags),
                const SizedBox(height: 16),
                _section('职位描述'),
                const SizedBox(height: 8),
                Text(
                  position.description ?? '暂无描述',
                  style: const TextStyle(fontSize: 14, color: Color(0xFF3C3C43), height: 1.5),
                ),
                const SizedBox(height: 16),
                if (position.industry != null) _field('行业', position.industry!),
                if (position.experienceRequired != null) _field('经验要求', position.experienceRequired!),
                if (position.educationRequired != null) _field('学历要求', position.educationRequired!),
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: CupertinoColors.white,
                  border: Border(top: BorderSide(color: CupertinoColors.systemGrey5, width: 0.5)),
                ),
                child: SafeArea(
                  top: false,
                  child: Row(
                    children: [
                      Expanded(
                        child: CupertinoButton(
                          color: const Color(0xFF007AFF),
                          borderRadius: BorderRadius.circular(10),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(l10n.applyNow, style: const TextStyle(color: CupertinoColors.white, fontWeight: FontWeight.w600)),
                          onPressed: () {
                            final provider = context.read<JobProvider>();
                            provider.applyPosition(position.positionId, '您好，我对这个职位很感兴趣');
                            showCupertinoDialog(
                              context: context,
                              builder: (_) => CupertinoAlertDialog(
                                content: const Text('投递成功'),
                                actions: [CupertinoDialogAction(child: const Text('OK'), onPressed: () => Navigator.pop(context))],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      CupertinoButton(
                        color: CupertinoColors.systemGrey6,
                        borderRadius: BorderRadius.circular(10),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        child: Text(l10n.sendGreeting, style: const TextStyle(color: Color(0xFF007AFF), fontWeight: FontWeight.w600)),
                        onPressed: () {
                          showCupertinoDialog(
                            context: context,
                            builder: (_) {
                              final ctl = TextEditingController();
                              return CupertinoAlertDialog(
                                title: Text(l10n.sendGreeting),
                                content: Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: CupertinoTextField(
                                    controller: ctl,
                                    placeholder: '说些什么...',
                                    maxLines: 3,
                                  ),
                                ),
                                actions: [
                                  CupertinoDialogAction(child: Text(l10n.cancel), onPressed: () => Navigator.pop(context)),
                                  CupertinoDialogAction(
                                    isDefaultAction: true,
                                    child: Text(l10n.sendMessage),
                                    onPressed: () {
                                      context.read<JobProvider>().sendGreeting(position.companyId, ctl.text);
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _companyHeader(AppLocalizations l10n) {
    return Row(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: CupertinoColors.systemGrey6,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(CupertinoIcons.building_2_fill, size: 28, color: CupertinoColors.systemGrey),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(position.companyName ?? '', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF1C1C1E))),
              const SizedBox(height: 2),
              Text(position.city ?? '', style: const TextStyle(fontSize: 13, color: CupertinoColors.systemGrey)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _infoRow(AppLocalizations l10n, List<String> tags) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (position.salaryMin != null)
            Text(
              '${position.salaryMin}k - ${position.salaryMax}k',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFFFF3B30)),
            ),
          if (tags.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: tags.map((t) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: CupertinoColors.systemGrey6, borderRadius: BorderRadius.circular(4)),
                child: Text(t.trim(), style: const TextStyle(fontSize: 12, color: CupertinoColors.systemGrey)),
              )).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _section(String label) {
    return Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1C1C1E)));
  }

  Widget _field(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(width: 72, child: Text(label, style: const TextStyle(fontSize: 13, color: CupertinoColors.systemGrey))),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 13, color: Color(0xFF1C1C1E)))),
        ],
      ),
    );
  }
}
