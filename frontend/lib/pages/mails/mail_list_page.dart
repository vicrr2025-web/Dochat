import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/models/mail_models.dart';
import 'package:dochat_app/providers/mail_provider.dart';
import 'package:dochat_app/pages/mails/mail_detail_page.dart';
import 'package:dochat_app/pages/mails/mail_compose_page.dart';
import 'package:dochat_app/pages/mails/mail_folders_page.dart';
import 'package:dochat_app/pages/mails/mail_filters_page.dart';

class MailListPage extends StatefulWidget {
  final String accountId;

  const MailListPage({super.key, required this.accountId});

  @override
  State<MailListPage> createState() => _MailListPageState();
}

class _MailListPageState extends State<MailListPage> {
  String _currentFolder = 'inbox';

  static const _folders = ['inbox', 'sent', 'drafts', 'trash', 'starred'];

  Map<String, String> _folderLabel(String key, AppLocalizations l10n) {
    switch (key) {
      case 'inbox':
        return {'label': l10n.mailInbox, 'icon': 'inbox'};
      case 'sent':
        return {'label': l10n.mailSent, 'icon': 'sent'};
      case 'drafts':
        return {'label': l10n.mailDrafts, 'icon': 'drafts'};
      case 'trash':
        return {'label': l10n.mailTrash, 'icon': 'trash'};
      case 'starred':
        return {'label': l10n.mailStarred, 'icon': 'starred'};
      default:
        return {'label': key, 'icon': key};
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMessages();
    });
  }

  void _loadMessages() {
    context
        .read<MailProvider>()
        .loadMailList(widget.accountId, _currentFolder);
  }

  String _formatTime(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final dt = DateTime.parse(dateStr);
      final now = DateTime.now();
      if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
        return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
      }
      return '${dt.month}/${dt.day}';
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(_folderLabel(_currentFolder, l10n)['label']!),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (_) => const MailFiltersPage(),
                  ),
                );
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Icon(CupertinoIcons.shield_fill, size: 22),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (_) => const MailFoldersPage(),
                  ),
                );
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Icon(CupertinoIcons.folder_fill, size: 22),
              ),
            ),
            GestureDetector(
              onTap: () async {
                await Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (_) => MailComposePage(
                      accountId: widget.accountId,
                    ),
                  ),
                );
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 8),
                child: Icon(CupertinoIcons.pencil, size: 22),
              ),
            ),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: CupertinoColors.systemBackground,
              child: SizedBox(
                height: 32,
                child: CupertinoSlidingSegmentedControl<String>(
                  groupValue: _currentFolder,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  children: {
                    for (final f in _folders)
                      f: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          _folderLabel(f, l10n)['label']!,
                          style: const TextStyle(fontSize: 11),
                        ),
                      ),
                  },
                  onValueChanged: (value) {
                    if (value != null) {
                      setState(() => _currentFolder = value);
                      _loadMessages();
                    }
                  },
                ),
              ),
            ),
            Expanded(
              child: Consumer<MailProvider>(
                builder: (context, provider, _) {
                  if (provider.loading && provider.messages.isEmpty) {
                    return const Center(child: CupertinoActivityIndicator());
                  }

                  if (provider.messages.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            CupertinoIcons.envelope_open,
                            size: 64,
                            color: CupertinoColors.systemGrey3,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.mailNoMessages,
                            style: const TextStyle(
                              fontSize: 16,
                              color: CupertinoColors.systemGrey,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    itemCount: provider.messages.length,
                    itemBuilder: (context, index) {
                      final msg = provider.messages[index];
                      return _buildMailItem(msg, l10n, provider);
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

  Widget _buildMailItem(
      MailMessage msg, AppLocalizations l10n, MailProvider provider) {
    return GestureDetector(
      onTap: () async {
        if (msg.isRead != true) {
          provider.markMail({
            'messageId': msg.messageId,
            'isRead': true,
          });
        }
        await Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (_) => MailDetailPage(
              messageId: msg.messageId,
              accountId: widget.accountId,
            ),
          ),
        );
        _loadMessages();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: CupertinoColors.systemGrey5,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 10,
              height: 10,
              margin: const EdgeInsets.only(top: 4, right: 10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: msg.isRead == true
                    ? const Color(0x00000000)
                    : const Color(0xFF5AC8FA),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          msg.sender ?? '',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight:
                                msg.isRead == true ? FontWeight.w400 : FontWeight.w600,
                            color: const Color(0xFF1C1C1E),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        _formatTime(msg.receivedAt),
                        style: const TextStyle(
                          fontSize: 12,
                          color: CupertinoColors.systemGrey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    msg.subject ?? '',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight:
                          msg.isRead == true ? FontWeight.w400 : FontWeight.w500,
                      color: const Color(0xFF3C3C43),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (msg.body != null && msg.body!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        msg.body!.replaceAll('\n', ' '),
                        style: const TextStyle(
                          fontSize: 12,
                          color: CupertinoColors.systemGrey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            ),
            if (msg.isStarred == true)
              const Padding(
                padding: EdgeInsets.only(left: 8, top: 2),
                child: Icon(
                  CupertinoIcons.star_fill,
                  size: 16,
                  color: Color(0xFFFFCC00),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
