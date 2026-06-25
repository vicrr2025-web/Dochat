import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/providers/settings_provider.dart';

class DeviceManagePage extends StatefulWidget {
  const DeviceManagePage({super.key});

  @override
  State<DeviceManagePage> createState() => _DeviceManagePageState();
}

class _DeviceManagePageState extends State<DeviceManagePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SettingsProvider>().loadDevices();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.deviceManagement),
      ),
      child: SafeArea(
        child: Consumer<SettingsProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading && provider.devices.isEmpty) {
              return const Center(child: CupertinoActivityIndicator());
            }

            final devices = provider.devices;
            final currentDevice = devices.where((d) => d.isCurrent).toList();
            final otherDevices = devices.where((d) => !d.isCurrent).toList();

            return ListView(
              children: [
                const SizedBox(height: 8),
                if (currentDevice.isNotEmpty) ...[
                  CupertinoListSection.insetGrouped(
                    header: Text(l10n.currentDevice),
                    children: currentDevice.map((d) {
                      return CupertinoListTile(
                        title: Text(d.deviceName),
                        subtitle: Text('${d.deviceModel} · ${d.osVersion}'),
                        trailing: const Icon(
                          CupertinoIcons.checkmark_circle_fill,
                          color: CupertinoColors.systemGreen,
                        ),
                      );
                    }).toList(),
                  ),
                ],
                if (otherDevices.isNotEmpty) ...[
                  CupertinoListSection.insetGrouped(
                    header: const Text(''),
                    children: otherDevices.map((d) {
                      return CupertinoListTile(
                        title: Text(d.deviceName),
                        subtitle: Text('${d.deviceModel} · ${d.lastActiveAt}'),
                        trailing: CupertinoButton(
                          padding: EdgeInsets.zero,
                          minSize: 0,
                          child: Text(
                            l10n.signOut,
                            style: const TextStyle(
                              color: CupertinoColors.destructiveRed,
                              fontSize: 14,
                            ),
                          ),
                          onPressed: () {
                            showCupertinoDialog(
                              context: context,
                              builder: (ctx) => CupertinoAlertDialog(
                                title: Text(l10n.signOut),
                                content: Text(l10n.removeFriendConfirm),
                                actions: [
                                  CupertinoDialogAction(
                                    child: Text(l10n.cancel),
                                    onPressed: () => Navigator.of(ctx).pop(),
                                  ),
                                  CupertinoDialogAction(
                                    isDestructiveAction: true,
                                    child: Text(l10n.signOut),
                                    onPressed: () {
                                      Navigator.of(ctx).pop();
                                      provider.removeDevice(d.deviceId);
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ],
                if (otherDevices.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: CupertinoButton(
                      color: CupertinoColors.destructiveRed,
                      borderRadius: BorderRadius.circular(12),
                      child: Text(
                        l10n.signOut,
                        style: const TextStyle(color: CupertinoColors.white),
                      ),
                      onPressed: () {
                        showCupertinoDialog(
                          context: context,
                          builder: (ctx) => CupertinoAlertDialog(
                            title: Text(l10n.signOut),
                            content: Text(l10n.signOutMessage),
                            actions: [
                              CupertinoDialogAction(
                                child: Text(l10n.cancel),
                                onPressed: () => Navigator.of(ctx).pop(),
                              ),
                              CupertinoDialogAction(
                                isDestructiveAction: true,
                                child: Text(l10n.confirm),
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                  provider.removeOtherDevices();
                                },
                              ),
                            ],
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
