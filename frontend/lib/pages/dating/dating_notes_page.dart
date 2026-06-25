import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/providers/dating_provider.dart';

class DatingNotesPage extends StatefulWidget {
  final String? toUserId;
  const DatingNotesPage({super.key, this.toUserId});

  @override
  State<DatingNotesPage> createState() => _DatingNotesPageState();
}

class _DatingNotesPageState extends State<DatingNotesPage> {
  final _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DatingProvider>().loadNotes();
    });
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _sendNote() {
    final text = _noteController.text.trim();
    if (text.isEmpty) return;
    final toUserId = widget.toUserId ?? '';
    if (toUserId.isEmpty) return;
    context.read<DatingProvider>().sendNote(toUserId, text);
    _noteController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final provider = context.watch<DatingProvider>();
    final notes = provider.notes;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text(l10n.noteLabel)),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: provider.isLoading
                  ? const Center(child: CupertinoActivityIndicator())
                  : notes.isEmpty
                      ? Center(child: Text('暂无小纸条', style: const TextStyle(color: CupertinoColors.systemGrey)))
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: notes.length,
                          itemBuilder: (context, index) {
                            final note = notes[index];
                            final isMine = note.toUserId == widget.toUserId || note.fromUserId != widget.toUserId;
                            return Align(
                              alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                                decoration: BoxDecoration(
                                  color: isMine ? const Color(0xFFFF6B8A) : CupertinoColors.systemGrey5,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (note.fromUserName != null)
                                      Text(note.fromUserName!, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                                          color: isMine ? CupertinoColors.white.withOpacity(0.8) : CupertinoColors.systemGrey)),
                                    const SizedBox(height: 4),
                                    Text(note.content, style: TextStyle(fontSize: 15,
                                        color: isMine ? CupertinoColors.white : const Color(0xFF1C1C1E))),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
            Container(
              decoration: BoxDecoration(
                color: CupertinoColors.systemBackground,
                border: Border(top: BorderSide(color: CupertinoColors.systemGrey5, width: 0.5)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  CupertinoButton(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    color: CupertinoColors.systemGrey5,
                    borderRadius: BorderRadius.circular(16),
                    child: const Text('AI帮写', style: TextStyle(fontSize: 14)),
                    onPressed: () {
                      _noteController.text = '你好，很高兴认识你！想和你聊聊天～';
                    },
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CupertinoTextField(
                      controller: _noteController,
                      placeholder: l10n.sendNote,
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CupertinoButton(
                    padding: const EdgeInsets.all(8),
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xFFFF6B8A),
                    child: const Text('发送', style: TextStyle(fontSize: 14, color: CupertinoColors.white)),
                    onPressed: _sendNote,
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
