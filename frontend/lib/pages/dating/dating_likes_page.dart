import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/providers/dating_provider.dart';
import 'package:dochat_app/pages/dating/dating_notes_page.dart';

class DatingLikesPage extends StatefulWidget {
  const DatingLikesPage({super.key});

  @override
  State<DatingLikesPage> createState() => _DatingLikesPageState();
}

class _DatingLikesPageState extends State<DatingLikesPage> {
  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DatingProvider>().loadRecommendations();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final provider = context.watch<DatingProvider>();

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.likeDating),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            CupertinoSlidingSegmentedControl<int>(
              groupValue: _tabIndex,
              children: const {
                0: Text('我喜欢'),
                1: Text('喜欢我'),
              },
              onValueChanged: (v) => setState(() => _tabIndex = v ?? 0),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: provider.isLoading
                  ? const Center(child: CupertinoActivityIndicator())
                  : provider.recommendations.isEmpty
                      ? Center(child: Text(l10n.noRecommend, style: const TextStyle(color: CupertinoColors.systemGrey)))
                      : ListView.builder(
                          itemCount: provider.recommendations.length,
                          itemBuilder: (context, index) {
                            final rec = provider.recommendations[index];
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: CupertinoColors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  ClipOval(
                                    child: Container(
                                      width: 48,
                                      height: 48,
                                      color: CupertinoColors.systemGrey5,
                                      child: const Icon(CupertinoIcons.person_alt, size: 28, color: CupertinoColors.systemGrey3),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(rec.nickname ?? '用户', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                        if (rec.tags != null && rec.tags!.isNotEmpty)
                                          Text(rec.tags!, style: const TextStyle(fontSize: 12, color: CupertinoColors.systemGrey)),
                                      ],
                                    ),
                                  ),
                                  CupertinoButton(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    color: const Color(0xFFFF6B8A),
                                    borderRadius: BorderRadius.circular(16),
                                    child: const Text('发消息', style: TextStyle(fontSize: 13, color: CupertinoColors.white)),
                                    onPressed: () {
                                      Navigator.push(context, CupertinoPageRoute(
                                        builder: (_) => DatingNotesPage(toUserId: rec.userId),
                                      ));
                                    },
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
