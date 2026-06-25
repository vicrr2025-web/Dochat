import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/models/job_models.dart';
import 'package:dochat_app/providers/job_provider.dart';
import 'package:dochat_app/pages/jobs/job_detail_page.dart';

class JobSearchPage extends StatefulWidget {
  const JobSearchPage({super.key});

  @override
  State<JobSearchPage> createState() => _JobSearchPageState();
}

class _JobSearchPageState extends State<JobSearchPage> {
  final _searchCtl = TextEditingController();
  String? _city;
  String? _industry;

  static const _cities = ['北京', '上海', '广州', '深圳', '杭州', '成都', '武汉', '南京'];
  static const _industries = ['互联网', '金融', '教育', '医疗', '电商', '制造业', '房地产'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<JobProvider>().loadPositions();
    });
  }

  @override
  void dispose() {
    _searchCtl.dispose();
    super.dispose();
  }

  void _doSearch() {
    context.read<JobProvider>().loadPositions(
      keyword: _searchCtl.text.isNotEmpty ? _searchCtl.text : null,
      city: _city,
      industry: _industry,
    );
  }

  void _pickOption(String title, List<String> options, String? current, Function(String?) onSelect) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) {
        return Container(
          height: 300,
          color: CupertinoColors.systemBackground,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: CupertinoColors.systemGrey6,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: const Text('取消', style: TextStyle(color: CupertinoColors.systemGrey)),
                      onPressed: () => Navigator.pop(context),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: const Text('不限'),
                      onPressed: () {
                        onSelect(null);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  children: options.map((o) {
                    final selected = current == o;
                    return CupertinoButton(
                      onPressed: () {
                        onSelect(o);
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(o, style: TextStyle(fontSize: 16, color: selected ? CupertinoColors.activeBlue : const Color(0xFF1C1C1E))),
                          ),
                          if (selected) const Icon(CupertinoIcons.checkmark_alt, color: CupertinoColors.activeBlue),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.jobSearch),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: CupertinoSearchTextField(
                controller: _searchCtl,
                placeholder: l10n.subscribeKeyword,
                onSubmitted: (_) => _doSearch(),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  _filterChip('城市', _city, () {
                    _pickOption('城市', _cities, _city, (v) {
                      setState(() => _city = v);
                      _doSearch();
                    });
                  }),
                  const SizedBox(width: 8),
                  _filterChip('行业', _industry, () {
                    _pickOption('行业', _industries, _industry, (v) {
                      setState(() => _industry = v);
                      _doSearch();
                    });
                  }),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Consumer<JobProvider>(
                builder: (context, provider, _) {
                  if (provider.isLoading && provider.positions.isEmpty) {
                    return const Center(child: CupertinoActivityIndicator());
                  }
                  if (provider.positions.isEmpty) {
                    return Center(child: Text(l10n.noPositionHint, style: const TextStyle(color: CupertinoColors.systemGrey)));
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: provider.positions.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final pos = provider.positions[index];
                      return _buildCard(l10n, pos);
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

  Widget _filterChip(String label, String? value, VoidCallback onTap) {
    final active = value != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF007AFF) : CupertinoColors.systemGrey6,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value ?? label,
              style: TextStyle(fontSize: 13, color: active ? CupertinoColors.white : const Color(0xFF3C3C43)),
            ),
            if (active) const SizedBox(width: 4),
            if (active)
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (label == '城市') _city = null;
                    if (label == '行业') _industry = null;
                  });
                  _doSearch();
                },
                child: const Icon(CupertinoIcons.xmark_circle_fill, size: 14, color: CupertinoColors.white),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(AppLocalizations l10n, JobPosition pos) {
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
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: CupertinoColors.systemGrey6,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(CupertinoIcons.building_2_fill, size: 26, color: CupertinoColors.systemGrey),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(pos.title ?? '', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1C1C1E))),
                  const SizedBox(height: 2),
                  Text('${pos.companyName ?? ''}  ${pos.city ?? ''}  ${pos.industry ?? ''}', style: const TextStyle(fontSize: 12, color: CupertinoColors.systemGrey)),
                  if (pos.salaryMin != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        '${pos.salaryMin}k-${pos.salaryMax}k',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Color(0xFFFF3B30)),
                      ),
                    ),
                  if (tags.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Wrap(
                        spacing: 4,
                        children: tags.take(4).map((t) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: CupertinoColors.systemGrey6, borderRadius: BorderRadius.circular(4)),
                          child: Text(t.trim(), style: const TextStyle(fontSize: 11, color: CupertinoColors.systemGrey)),
                        )).toList(),
                      ),
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
