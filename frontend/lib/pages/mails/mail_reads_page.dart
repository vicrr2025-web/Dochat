import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/providers/mail_provider.dart';

class MailReadsPage extends StatefulWidget {
  const MailReadsPage({super.key});

  @override
  State<MailReadsPage> createState() => _MailReadsPageState();
}

class _MailReadsPageState extends State<MailReadsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MailProvider>().loadReads();
    });
  }

  String _formatTime(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final dt = DateTime.parse(dateStr);
      return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.mailDailyRead),
      ),
      child: SafeArea(
        child: Consumer<MailProvider>(
          builder: (context, provider, _) {
            if (provider.loading && provider.reads.isEmpty) {
              return const Center(child: CupertinoActivityIndicator());
            }

            if (provider.reads.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      CupertinoIcons.book,
                      size: 64,
                      color: CupertinoColors.systemGrey3,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.mailDailyRead,
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
              padding: const EdgeInsets.all(16),
              itemCount: provider.reads.length,
              itemBuilder: (context, index) {
                final read = provider.reads[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: CupertinoColors.systemGrey5,
                        width: 0.5,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                read.title ?? '',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF1C1C1E),
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  if (read.source != null)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF5AC8FA)
                                            .withOpacity(0.1),
                                        borderRadius:
                                            BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        read.source!,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: Color(0xFF5AC8FA),
                                        ),
                                      ),
                                    ),
                                  if (read.source != null)
                                    const SizedBox(width: 8),
                                  Text(
                                    _formatTime(read.readAt),
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: CupertinoColors.systemGrey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {});
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8, top: 2),
                            child: Icon(
                              read.isFavorited == true
                                  ? CupertinoIcons.heart_fill
                                  : CupertinoIcons.heart,
                              size: 20,
                              color: read.isFavorited == true
                                  ? CupertinoColors.destructiveRed
                                  : CupertinoColors.systemGrey3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
