import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/providers/job_provider.dart';

class JobInterviewPage extends StatefulWidget {
  const JobInterviewPage({super.key});

  @override
  State<JobInterviewPage> createState() => _JobInterviewPageState();
}

class _JobInterviewPageState extends State<JobInterviewPage> {
  int _selectedSegment = 0;

  final _mockInterviews = {
    0: [
      {'company': '字节跳动', 'position': '高级前端', 'time': '2026-06-28 14:00', 'type': '视频面试', 'location': '飞书会议'},
      {'company': '阿里巴巴', 'position': 'Flutter 开发', 'time': '2026-06-29 10:00', 'type': '现场面试', 'location': '杭州西溪园区'},
    ],
    1: [
      {'company': '腾讯', 'position': 'iOS 开发', 'time': '2026-06-30 15:00', 'type': '电话面试', 'location': ''},
    ],
    2: [
      {'company': '美团', 'position': 'Android 开发', 'time': '2026-06-20 10:00', 'type': '视频面试', 'location': '腾讯会议'},
    ],
  };

  Color _statusColor(int segment) {
    switch (segment) {
      case 0: return const Color(0xFFFF9500);
      case 1: return const Color(0xFF007AFF);
      case 2: return const Color(0xFF34C759);
      default: return CupertinoColors.systemGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final items = _mockInterviews[_selectedSegment] ?? [];

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.jobInterviews),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: CupertinoSlidingSegmentedControl<int>(
                groupValue: _selectedSegment,
                children: const {
                  0: Text('待确认'),
                  1: Text('待面试'),
                  2: Text('已完成'),
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
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: _statusColor(_selectedSegment).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(CupertinoIcons.calendar, color: _statusColor(_selectedSegment), size: 22),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(item['company'] as String, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1C1C1E))),
                                        Text(item['position'] as String, style: const TextStyle(fontSize: 13, color: CupertinoColors.systemGrey)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              _detailRow(l10n.interviewTime, item['time'] as String),
                              const SizedBox(height: 4),
                              _detailRow(l10n.interviewType, item['type'] as String),
                              if ((item['location'] as String).isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: _detailRow('地点', item['location'] as String),
                                ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  if (_selectedSegment == 0) ...[
                                    CupertinoButton(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                      color: CupertinoColors.destructiveRed.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(14),
                                      minSize: 0,
                                      child: Text(l10n.cancel, style: const TextStyle(fontSize: 13, color: CupertinoColors.destructiveRed)),
                                      onPressed: () {
                                        showCupertinoDialog(
                                          context: context,
                                          builder: (_) => CupertinoAlertDialog(
                                            content: const Text('已取消面试'),
                                            actions: [CupertinoDialogAction(child: const Text('OK'), onPressed: () => Navigator.pop(context))],
                                          ),
                                        );
                                      },
                                    ),
                                    const SizedBox(width: 8),
                                    CupertinoButton(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                      color: const Color(0xFF34C759),
                                      borderRadius: BorderRadius.circular(14),
                                      minSize: 0,
                                      child: Text(l10n.confirm, style: const TextStyle(fontSize: 13, color: CupertinoColors.white)),
                                      onPressed: () {
                                        setState(() => _selectedSegment = 1);
                                      },
                                    ),
                                  ],
                                  if (_selectedSegment == 2) ...[
                                    CupertinoButton(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                      color: const Color(0xFFFF9500).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(14),
                                      minSize: 0,
                                      child: const Text('评价', style: TextStyle(fontSize: 13, color: Color(0xFFFF9500))),
                                      onPressed: () {
                                        _showRatingDialog(l10n);
                                      },
                                    ),
                                  ],
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

  Widget _detailRow(String label, String value) {
    return Row(
      children: [
        SizedBox(width: 64, child: Text(label, style: const TextStyle(fontSize: 13, color: CupertinoColors.systemGrey))),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 13, color: Color(0xFF1C1C1E)))),
      ],
    );
  }

  void _showRatingDialog(AppLocalizations l10n) {
    int rating = 5;
    showCupertinoDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return CupertinoAlertDialog(
              title: const Text('面试评价'),
              content: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (i) {
                        return GestureDetector(
                          onTap: () => setDialogState(() => rating = i + 1),
                          child: Icon(
                            i < rating ? CupertinoIcons.star_fill : CupertinoIcons.star,
                            color: i < rating ? const Color(0xFFFF9500) : CupertinoColors.systemGrey,
                            size: 28,
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              actions: [
                CupertinoDialogAction(child: Text(l10n.cancel), onPressed: () => Navigator.pop(context)),
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text(l10n.confirm),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
