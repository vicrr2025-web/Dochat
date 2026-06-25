import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/providers/job_provider.dart';

class JobApplicationsPage extends StatefulWidget {
  const JobApplicationsPage({super.key});

  @override
  State<JobApplicationsPage> createState() => _JobApplicationsPageState();
}

class _JobApplicationsPageState extends State<JobApplicationsPage> {
  int _selectedSegment = 0;

  final _mockData = {
    0: [{'title': '前端开发工程师', 'company': '字节跳动', 'status': 'applied', 'time': '2026-06-20'}],
    1: [{'title': 'Flutter 开发', 'company': '腾讯', 'status': 'viewed', 'time': '2026-06-18'}],
    2: [{'title': 'iOS 开发', 'company': '阿里巴巴', 'status': 'communicating', 'time': '2026-06-15'}],
    3: [{'title': 'Android 开发', 'company': '美团', 'status': 'interview', 'time': '2026-06-25 14:00'}],
  };

  String _statusText(AppLocalizations l10n, String status) {
    switch (status) {
      case 'applied': return l10n.applied;
      case 'viewed': return l10n.viewed;
      case 'communicating': return l10n.communicating;
      case 'interview': return l10n.interviewInvite;
      default: return status;
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'applied': return const Color(0xFFFF9500);
      case 'viewed': return const Color(0xFF007AFF);
      case 'communicating': return const Color(0xFF34C759);
      case 'interview': return const Color(0xFFAF52DE);
      default: return CupertinoColors.systemGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final items = _mockData[_selectedSegment] ?? [];

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.jobApplications),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: CupertinoSlidingSegmentedControl<int>(
                groupValue: _selectedSegment,
                children: const {
                  0: Text('已投递'),
                  1: Text('已查看'),
                  2: Text('沟通中'),
                  3: Text('面试'),
                },
                onValueChanged: (v) {
                  if (v != null) setState(() => _selectedSegment = v);
                },
              ),
            ),
            Expanded(
              child: items.isEmpty
                  ? Center(child: Text(l10n.noPositionHint, style: const TextStyle(color: CupertinoColors.systemGrey)))
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        final status = item['status'] as String;
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
                                decoration: BoxDecoration(
                                  color: CupertinoColors.systemGrey6,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(CupertinoIcons.building_2_fill, size: 24, color: CupertinoColors.systemGrey),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item['title'] as String, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1C1C1E))),
                                    const SizedBox(height: 2),
                                    Text(item['company'] as String, style: const TextStyle(fontSize: 13, color: CupertinoColors.systemGrey)),
                                    const SizedBox(height: 2),
                                    Text(item['time'] as String, style: const TextStyle(fontSize: 12, color: CupertinoColors.systemGrey)),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _statusColor(status).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(_statusText(l10n, status), style: TextStyle(fontSize: 12, color: _statusColor(status), fontWeight: FontWeight.w500)),
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
