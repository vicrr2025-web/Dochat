import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/providers/mail_provider.dart';
import 'package:dochat_app/pages/mails/mail_compose_page.dart';

class MailDetailPage extends StatefulWidget {
  final String messageId;
  final String accountId;

  const MailDetailPage({
    super.key,
    required this.messageId,
    required this.accountId,
  });

  @override
  State<MailDetailPage> createState() => _MailDetailPageState();
}

class _MailDetailPageState extends State<MailDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MailProvider>().loadMailDetail(widget.messageId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.mailInbox),
        trailing: GestureDetector(
          onTap: () {
            final provider = context.read<MailProvider>();
            final msg = provider.currentMessage;
            if (msg != null) {
              provider.markMail({
                'messageId': msg.messageId,
                'isStarred': !(msg.isStarred == true),
              });
            }
          },
          child: Consumer<MailProvider>(
            builder: (context, provider, _) {
              final isStarred = provider.currentMessage?.isStarred == true;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(
                  isStarred ? CupertinoIcons.star_fill : CupertinoIcons.star,
                  size: 22,
                  color: isStarred ? const Color(0xFFFFCC00) : CupertinoColors.systemGrey,
                ),
              );
            },
          ),
        ),
      ),
      child: SafeArea(
        child: Consumer<MailProvider>(
          builder: (context, provider, _) {
            if (provider.loading) {
              return const Center(child: CupertinoActivityIndicator());
            }

            final msg = provider.currentMessage;
            if (msg == null) {
              return Center(
                child: Text(
                  l10n.mailNoMessages,
                  style: const TextStyle(color: CupertinoColors.systemGrey),
                ),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ClipOval(
                              child: Container(
                                width: 40,
                                height: 40,
                                color: const Color(0xFF5AC8FA).withOpacity(0.15),
                                child: const Icon(
                                  CupertinoIcons.person_fill,
                                  color: Color(0xFF5AC8FA),
                                  size: 22,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    msg.sender ?? '',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF1C1C1E),
                                    ),
                                  ),
                                  if (msg.recipients != null)
                                    Text(
                                      '${l10n.mailTo}: ${msg.recipients}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: CupertinoColors.systemGrey,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                ],
                              ),
                            ),
                            Text(
                              msg.receivedAt ?? '',
                              style: const TextStyle(
                                fontSize: 12,
                                color: CupertinoColors.systemGrey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          msg.subject ?? '',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1C1C1E),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(height: 0.5, color: CupertinoColors.systemGrey5),
                        const SizedBox(height: 12),
                        Text(
                          msg.body ?? '',
                          style: const TextStyle(
                            fontSize: 15,
                            color: Color(0xFF3C3C43),
                            height: 1.6,
                          ),
                        ),
                        if (msg.hasAttachments == true) ...[
                          const SizedBox(height: 20),
                          Container(height: 0.5, color: CupertinoColors.systemGrey5),
                          const SizedBox(height: 8),
                          Text(
                            l10n.mailAttachments,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1C1C1E),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: CupertinoColors.systemGrey6,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  CupertinoIcons.paperclip,
                                  size: 20,
                                  color: CupertinoColors.systemGrey,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    msg.attachments ?? l10n.mailAttachments,
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemBackground,
                    border: Border(
                      top: BorderSide(
                        color: CupertinoColors.systemGrey5,
                        width: 0.5,
                      ),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: SafeArea(
                    top: false,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildAction(
                          CupertinoIcons.arrowshape_turn_up_left_fill,
                          l10n.mailReply,
                          () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (_) => MailComposePage(
                                  accountId: widget.accountId,
                                  replyTo: msg,
                                  replyAll: false,
                                ),
                              ),
                            );
                          },
                        ),
                        _buildAction(
                          CupertinoIcons.arrowshape_turn_up_left_2_fill,
                          l10n.mailReplyAll,
                          () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (_) => MailComposePage(
                                  accountId: widget.accountId,
                                  replyTo: msg,
                                  replyAll: true,
                                ),
                              ),
                            );
                          },
                        ),
                        _buildAction(
                          CupertinoIcons.arrowshape_turn_up_right_fill,
                          l10n.mailForward,
                          () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (_) => MailComposePage(
                                  accountId: widget.accountId,
                                  forwardFrom: msg,
                                ),
                              ),
                            );
                          },
                        ),
                        _buildAction(
                          CupertinoIcons.trash_fill,
                          l10n.mailDelete,
                          () async {
                            final confirm = await showCupertinoDialog<bool>(
                              context: context,
                              builder: (ctx) => CupertinoAlertDialog(
                                title: Text(l10n.mailDelete),
                                content: Text(l10n.confirm),
                                actions: [
                                  CupertinoDialogAction(
                                    child: Text(l10n.cancel),
                                    onPressed: () =>
                                        Navigator.pop(ctx, false),
                                  ),
                                  CupertinoDialogAction(
                                    isDestructiveAction: true,
                                    child: Text(l10n.mailDelete),
                                    onPressed: () =>
                                        Navigator.pop(ctx, true),
                                  ),
                                ],
                              ),
                            );
                            if (confirm == true && mounted) {
                              final success = await provider
                                  .deleteMail(widget.messageId);
                              if (success && mounted) {
                                Navigator.pop(context);
                              }
                            }
                          },
                        ),
                        _buildAction(
                          CupertinoIcons.star,
                          l10n.mailStar,
                          () {
                            provider.markMail({
                              'messageId': msg.messageId,
                              'isStarred': !(msg.isStarred == true),
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildAction(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 22, color: CupertinoColors.activeBlue),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: CupertinoColors.systemGrey,
            ),
          ),
        ],
      ),
    );
  }
}
