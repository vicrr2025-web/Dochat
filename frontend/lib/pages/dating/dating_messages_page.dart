import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/providers/dating_provider.dart';
import 'package:dochat_app/pages/dating/dating_notes_page.dart';

class DatingMessagesPage extends StatefulWidget {
  const DatingMessagesPage({super.key});

  @override
  State<DatingMessagesPage> createState() => _DatingMessagesPageState();
}

class _DatingMessagesPageState extends State<DatingMessagesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DatingProvider>().loadNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final provider = context.watch<DatingProvider>();

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text(l10n.messagesLabel)),
      child: SafeArea(
        child: provider.isLoading
            ? const Center(child: CupertinoActivityIndicator())
            : provider.notes.isEmpty
                ? Center(child: Text(l10n.noRecommend, style: const TextStyle(color: CupertinoColors.systemGrey)))
                : ListView.builder(
                    itemCount: provider.notes.length,
                    itemBuilder: (context, index) {
                      final note = provider.notes[index];
                      return CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          Navigator.push(context, CupertinoPageRoute(
                            builder: (_) => DatingNotesPage(toUserId: note.fromUserId),
                          ));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: CupertinoColors.white,
                            border: Border(bottom: BorderSide(color: CupertinoColors.systemGrey5, width: 0.5)),
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
                                    Text(note.fromUserName ?? '用户', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF1C1C1E))),
                                    const SizedBox(height: 4),
                                    Text(note.content, maxLines: 1, overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 13, color: CupertinoColors.systemGrey)),
                                  ],
                                ),
                              ),
                              if (!note.isRead)
                                Container(
                                  width: 8, height: 8,
                                  decoration: const BoxDecoration(color: Color(0xFFFF6B8A), shape: BoxShape.circle),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
