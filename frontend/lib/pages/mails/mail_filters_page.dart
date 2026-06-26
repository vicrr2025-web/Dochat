import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/providers/mail_provider.dart';

class MailFiltersPage extends StatefulWidget {
  const MailFiltersPage({super.key});

  @override
  State<MailFiltersPage> createState() => _MailFiltersPageState();
}

class _MailFiltersPageState extends State<MailFiltersPage> {
  String _currentType = 'block';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MailProvider>().loadFilters();
    });
  }

  void _showAddDialog() {
    final l10n = AppLocalizations.of(context);
    final addressCtrl = TextEditingController();
    showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text(
          _currentType == 'block' ? l10n.mailBlacklist : l10n.mailWhitelist,
        ),
        content: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: CupertinoTextField(
            controller: addressCtrl,
            placeholder: 'email@example.com',
            autofocus: true,
            keyboardType: TextInputType.emailAddress,
          ),
        ),
        actions: [
          CupertinoDialogAction(
            child: Text(l10n.cancel),
            onPressed: () => Navigator.pop(ctx),
          ),
          CupertinoDialogAction(
            child: Text(l10n.confirm),
            onPressed: () {
              final address = addressCtrl.text.trim();
              if (address.isNotEmpty) {
                context.read<MailProvider>().addFilter({
                  'type': _currentType,
                  'addressPattern': address,
                });
              }
              Navigator.pop(ctx);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.mailFilters),
        trailing: GestureDetector(
          onTap: _showAddDialog,
          child: const Padding(
            padding: EdgeInsets.only(right: 8),
            child: Icon(CupertinoIcons.add, size: 22),
          ),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: CupertinoColors.systemBackground,
              child: SizedBox(
                height: 32,
                child: CupertinoSlidingSegmentedControl<String>(
                  groupValue: _currentType,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  children: {
                    'block': Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        l10n.mailBlacklist,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    'allow': Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        l10n.mailWhitelist,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  },
                  onValueChanged: (value) {
                    if (value != null) {
                      setState(() => _currentType = value);
                    }
                  },
                ),
              ),
            ),
            Expanded(
              child: Consumer<MailProvider>(
                builder: (context, provider, _) {
                  if (provider.loading) {
                    return const Center(child: CupertinoActivityIndicator());
                  }

                  final filtered = provider.filters
                      .where((f) => f.type == _currentType)
                      .toList();

                  if (filtered.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            CupertinoIcons.shield_lefthalf_fill,
                            size: 64,
                            color: CupertinoColors.systemGrey3,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _currentType == 'block'
                                ? l10n.mailBlacklist
                                : l10n.mailWhitelist,
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
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final filter = filtered[index];
                      return Dismissible(
                        key: Key(filter.filterId),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          color: CupertinoColors.destructiveRed,
                          child: const Icon(
                            CupertinoIcons.trash,
                            color: CupertinoColors.white,
                          ),
                        ),
                        onDismissed: (_) {},
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: CupertinoColors.systemGrey5,
                                width: 0.5,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _currentType == 'block'
                                    ? CupertinoIcons.xmark_shield_fill
                                    : CupertinoIcons.checkmark_shield_fill,
                                size: 22,
                                color: _currentType == 'block'
                                    ? CupertinoColors.destructiveRed
                                    : CupertinoColors.activeGreen,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  filter.addressPattern ?? '',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Color(0xFF1C1C1E),
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
          ],
        ),
      ),
    );
  }
}
