import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/providers/mail_provider.dart';
import 'package:dochat_app/pages/mails/mail_add_account_page.dart';
import 'package:dochat_app/pages/mails/mail_list_page.dart';
import 'package:dochat_app/pages/mails/mail_reads_page.dart';

class MailHomePage extends StatefulWidget {
  const MailHomePage({super.key});

  @override
  State<MailHomePage> createState() => _MailHomePageState();
}

class _MailHomePageState extends State<MailHomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MailProvider>().loadAccounts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.mailTab),
        trailing: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (_) => const MailReadsPage(),
              ),
            );
          },
          child: const Padding(
            padding: EdgeInsets.only(right: 8),
            child: Icon(CupertinoIcons.book_fill, size: 22),
          ),
        ),
      ),
      child: SafeArea(
        child: Consumer<MailProvider>(
          builder: (context, provider, _) {
            if (provider.loading && provider.accounts.isEmpty) {
              return const Center(child: CupertinoActivityIndicator());
            }

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.mailTab,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1C1C1E),
                        ),
                      ),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (_) => const MailAddAccountPage(),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            const Icon(CupertinoIcons.add, size: 20, color: CupertinoColors.activeBlue),
                            const SizedBox(width: 4),
                            Text(
                              l10n.addAccount,
                              style: const TextStyle(
                                fontSize: 14,
                                color: CupertinoColors.activeBlue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: provider.accounts.isEmpty
                      ? Center(
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
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: provider.accounts.length,
                          itemBuilder: (context, index) {
                            final account = provider.accounts[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: GestureDetector(
                                onTap: () {
                                  provider.setCurrentAccount(account);
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (_) => MailListPage(accountId: account.accountId),
                                    ),
                                  );
                                },
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
                                    children: [
                                      ClipOval(
                                        child: Container(
                                          width: 44,
                                          height: 44,
                                          color: const Color(0xFF5AC8FA).withOpacity(0.15),
                                          child: const Icon(
                                            CupertinoIcons.envelope_fill,
                                            color: Color(0xFF5AC8FA),
                                            size: 24,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              account.email ?? '',
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xFF1C1C1E),
                                              ),
                                            ),
                                            if (account.provider != null)
                                              Text(
                                                account.provider!,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: CupertinoColors.systemGrey,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      if (account.isDefault == true)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF5AC8FA).withOpacity(0.15),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            l10n.mailDefault,
                                            style: const TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF5AC8FA),
                                            ),
                                          ),
                                        ),
                                      const SizedBox(width: 8),
                                      const Icon(
                                        CupertinoIcons.forward,
                                        size: 18,
                                        color: CupertinoColors.systemGrey3,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
