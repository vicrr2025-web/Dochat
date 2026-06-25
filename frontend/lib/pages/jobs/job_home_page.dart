import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/models/job_models.dart';
import 'package:dochat_app/providers/job_provider.dart';
import 'package:dochat_app/pages/jobs/job_search_page.dart';
import 'package:dochat_app/pages/jobs/job_resume_page.dart';
import 'package:dochat_app/pages/jobs/job_applications_page.dart';
import 'package:dochat_app/pages/jobs/job_recruiter_page.dart';
import 'package:dochat_app/pages/jobs/job_candidates_page.dart';
import 'package:dochat_app/pages/jobs/job_interview_page.dart';
import 'package:dochat_app/pages/jobs/job_company_page.dart';
import 'package:dochat_app/pages/jobs/job_expert_page.dart';
import 'package:dochat_app/pages/jobs/job_community_page.dart';
import 'package:dochat_app/pages/jobs/job_chat_page.dart';
import 'package:dochat_app/pages/jobs/job_detail_page.dart';

class JobHomePage extends StatefulWidget {
  const JobHomePage({super.key});

  @override
  State<JobHomePage> createState() => _JobHomePageState();
}

class _JobHomePageState extends State<JobHomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<JobProvider>();
      provider.loadResume();
      provider.loadPositions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.jobTab),
      ),
      child: SafeArea(
        child: Consumer<JobProvider>(
          builder: (context, provider, _) {
            final role = provider.role.trim();
            final isCandidate = role == 'candidate';

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildRoleBadge(l10n, provider, isCandidate),
                const SizedBox(height: 16),
                if (isCandidate)
                  ..._buildCandidateHome(l10n, provider)
                else
                  ..._buildRecruiterHome(l10n, provider),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildRoleBadge(AppLocalizations l10n, JobProvider provider, bool isCandidate) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF007AFF), Color(0xFF5856D6)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isCandidate ? l10n.candidateRole : l10n.recruiterRole,
                style: const TextStyle(color: CupertinoColors.white, fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                isCandidate ? '寻找心仪职位' : '高效招人才',
                style: const TextStyle(color: Color(0xCCFFFFFF), fontSize: 13),
              ),
            ],
          ),
          CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: CupertinoColors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            child: Text(l10n.switchRole, style: const TextStyle(color: CupertinoColors.white, fontSize: 14)),
            onPressed: () => provider.toggleRole(),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCandidateHome(AppLocalizations l10n, JobProvider provider) {
    final widgets = <Widget>[
      CupertinoSearchTextField(
        placeholder: l10n.jobSearch,
        onSubmitted: (value) {
          Navigator.push(context, CupertinoPageRoute(builder: (_) => const JobSearchPage()));
        },
        onTap: () {
          Navigator.push(context, CupertinoPageRoute(builder: (_) => const JobSearchPage()));
        },
      ),
      const SizedBox(height: 16),
      _sectionHeader(l10n, l10n.matchRecommend),
      const SizedBox(height: 8),
    ];

    if (provider.positions.isEmpty) {
      widgets.add(_emptyHint(l10n.noPositionHint));
    } else {
      for (final pos in provider.positions.take(5)) {
        widgets.add(_positionCard(l10n, pos));
        widgets.add(const SizedBox(height: 8));
      }
    }

    widgets.add(const SizedBox(height: 8));
    widgets.add(_ecoRow(l10n));
    return widgets;
  }

  List<Widget> _buildRecruiterHome(AppLocalizations l10n, JobProvider provider) {
    return [
      _actionCard(l10n, CupertinoIcons.plus_circle_fill, l10n.publishPosition, const Color(0xFF007AFF), () {
        Navigator.push(context, CupertinoPageRoute(builder: (_) => const JobRecruiterPage()));
      }),
      const SizedBox(height: 10),
      _actionCard(l10n, CupertinoIcons.person_2_fill, l10n.jobCandidates, const Color(0xFF34C759), () {
        Navigator.push(context, CupertinoPageRoute(builder: (_) => const JobCandidatesPage()));
      }),
      const SizedBox(height: 10),
      _actionCard(l10n, CupertinoIcons.calendar, l10n.jobInterviews, const Color(0xFFFF9500), () {
        Navigator.push(context, CupertinoPageRoute(builder: (_) => const JobInterviewPage()));
      }),
      const SizedBox(height: 10),
      _actionCard(l10n, CupertinoIcons.chart_bar_fill, l10n.positionStats, const Color(0xFFAF52DE), () {
        Navigator.push(context, CupertinoPageRoute(builder: (_) => const JobRecruiterPage()));
      }),
      const SizedBox(height: 16),
      _ecoRow(l10n),
    ];
  }

  Widget _actionCard(AppLocalizations l10n, IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 16),
            Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: color)),
            const Spacer(),
            const Icon(CupertinoIcons.chevron_right, color: CupertinoColors.systemGrey, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(AppLocalizations l10n, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Color(0xFF1C1C1E))),
        GestureDetector(
          onTap: () {
            Navigator.push(context, CupertinoPageRoute(builder: (_) => const JobSearchPage()));
          },
          child: Row(
            children: [
              Text(l10n.jobSearch, style: const TextStyle(fontSize: 13, color: CupertinoColors.systemGrey)),
              const Icon(CupertinoIcons.chevron_right, size: 16, color: CupertinoColors.systemGrey),
            ],
          ),
        ),
      ],
    );
  }

  Widget _positionCard(AppLocalizations l10n, JobPosition pos) {
    final tags = pos.tags?.split(',') ?? [];
    return GestureDetector(
      onTap: () {
        Navigator.push(context, CupertinoPageRoute(builder: (_) => JobDetailPage(position: pos)));
      },
      child: Container(
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
              decoration: BoxDecoration(
                color: CupertinoColors.systemGrey6,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(CupertinoIcons.building_2_fill, color: CupertinoColors.systemGrey, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pos.title ?? '',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1C1C1E)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${pos.companyName ?? ''}  ${pos.city ?? ''}',
                    style: const TextStyle(fontSize: 13, color: CupertinoColors.systemGrey),
                  ),
                  if (pos.salaryMin != null && pos.salaryMax != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        '${pos.salaryMin}k-${pos.salaryMax}k',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Color(0xFFFF3B30)),
                      ),
                    ),
                  const SizedBox(height: 4),
                  if (tags.isNotEmpty)
                    Wrap(
                      spacing: 4,
                      children: tags
                          .take(3)
                          .map((t) => Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: CupertinoColors.systemGrey6,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(t.trim(), style: const TextStyle(fontSize: 11, color: CupertinoColors.systemGrey)),
                              ))
                          .toList(),
                    ),
                ],
              ),
            ),
            const Icon(CupertinoIcons.chevron_right, size: 18, color: CupertinoColors.systemGrey),
          ],
        ),
      ),
    );
  }

  Widget _ecoRow(AppLocalizations l10n) {
    final items = [
      (CupertinoIcons.doc_text_fill, l10n.jobResume, () => Navigator.push(context, CupertinoPageRoute(builder: (_) => const JobResumePage()))),
      (CupertinoIcons.tray_full_fill, l10n.jobApplications, () => Navigator.push(context, CupertinoPageRoute(builder: (_) => const JobApplicationsPage()))),
      (CupertinoIcons.person_2_fill, l10n.jobExpert, () => Navigator.push(context, CupertinoPageRoute(builder: (_) => const JobExpertPage()))),
      (CupertinoIcons.group_solid, l10n.jobCommunity, () => Navigator.push(context, CupertinoPageRoute(builder: (_) => const JobCommunityPage()))),
      (CupertinoIcons.chat_bubble_2_fill, l10n.messagesLabel, () => Navigator.push(context, CupertinoPageRoute(builder: (_) => const JobChatPage()))),
      (CupertinoIcons.building_2_fill, l10n.jobCompany, () => Navigator.push(context, CupertinoPageRoute(builder: (_) => const JobCompanyPage()))),
    ];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((item) {
        return GestureDetector(
          onTap: item.$3,
          child: Container(
            width: (MediaQuery.of(context).size.width - 56) / 3,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: CupertinoColors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: CupertinoColors.systemGrey5, width: 0.5),
            ),
            child: Column(
              children: [
                Icon(item.$1, size: 24, color: const Color(0xFF007AFF)),
                const SizedBox(height: 6),
                Text(item.$2, style: const TextStyle(fontSize: 12, color: Color(0xFF3C3C43))),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _emptyHint(String hint) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Center(
        child: Text(hint, style: const TextStyle(color: CupertinoColors.systemGrey, fontSize: 14)),
      ),
    );
  }
}
