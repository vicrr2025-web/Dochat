import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/providers/mail_provider.dart';

class MailFoldersPage extends StatefulWidget {
  const MailFoldersPage({super.key});

  @override
  State<MailFoldersPage> createState() => _MailFoldersPageState();
}

class _MailFoldersPageState extends State<MailFoldersPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MailProvider>().loadFolders();
    });
  }

  void _showAddDialog() {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController();
    showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text(l10n.mailNewFolder),
        content: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: CupertinoTextField(
            controller: controller,
            placeholder: l10n.mailNewFolder,
            autofocus: true,
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
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                context.read<MailProvider>().createFolder(name);
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
        middle: Text(l10n.mailFolders),
        trailing: GestureDetector(
          onTap: _showAddDialog,
          child: const Padding(
            padding: EdgeInsets.only(right: 8),
            child: Icon(CupertinoIcons.add, size: 22),
          ),
        ),
      ),
      child: SafeArea(
        child: Consumer<MailProvider>(
          builder: (context, provider, _) {
            if (provider.loading) {
              return const Center(child: CupertinoActivityIndicator());
            }

            if (provider.folders.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      CupertinoIcons.folder_open,
                      size: 64,
                      color: CupertinoColors.systemGrey3,
                    ),
                    const SizedBox(height: 16),
                    CupertinoButton(
                      onPressed: _showAddDialog,
                      child: Text(
                        l10n.mailNewFolder,
                        style: const TextStyle(
                          color: CupertinoColors.activeBlue,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: provider.folders.length,
              itemBuilder: (context, index) {
                final folder = provider.folders[index];
                return Dismissible(
                  key: Key(folder.folderId),
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
                  onDismissed: (_) {
                    provider.deleteFolder(folder.folderId);
                  },
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
                        const Icon(
                          CupertinoIcons.folder_fill,
                          size: 22,
                          color: Color(0xFF5AC8FA),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            folder.name ?? '',
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xFF1C1C1E),
                            ),
                          ),
                        ),
                        const Icon(
                          CupertinoIcons.forward,
                          size: 16,
                          color: CupertinoColors.systemGrey3,
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
