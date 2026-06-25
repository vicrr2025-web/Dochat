import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/providers/location_provider.dart';

class GeofencePage extends StatefulWidget {
  final String? targetUserId;

  const GeofencePage({super.key, this.targetUserId});

  @override
  State<GeofencePage> createState() => _GeofencePageState();
}

class _GeofencePageState extends State<GeofencePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _lngController = TextEditingController();
  final TextEditingController _radiusController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LocationProvider>().loadGeoFences();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _latController.dispose();
    _lngController.dispose();
    _radiusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final provider = context.watch<LocationProvider>();

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.geofence),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: provider.isLoading && provider.geoFences.isEmpty
                  ? const Center(child: CupertinoActivityIndicator())
                  : provider.geoFences.isEmpty
                      ? Center(
                          child: Text(
                            l10n.noGeoFences,
                            style: const TextStyle(
                              color: CupertinoColors.systemGrey,
                              fontSize: 15,
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          itemCount: provider.geoFences.length,
                          itemBuilder: (context, index) {
                            final fence = provider.geoFences[index];
                            return Dismissible(
                              key: Key(fence.fenceId),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                color: CupertinoColors.destructiveRed,
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20),
                                child: Text(
                                  l10n.delete,
                                  style: const TextStyle(color: CupertinoColors.white),
                                ),
                              ),
                              confirmDismiss: (_) async {
                                provider.deleteGeoFence(fence.fenceId);
                                return false;
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: CupertinoColors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  children: [
                                    const Icon(
                                      CupertinoIcons.location_solid,
                                      color: CupertinoColors.activeBlue,
                                      size: 24,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            fence.name,
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            '${fence.radius}m | ${fence.targetUserId ?? ""}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: CupertinoColors.systemGrey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    CupertinoSwitch(
                                      value: fence.isActive,
                                      onChanged: (value) {},
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: CupertinoButton.filled(
                  onPressed: () => _showAddFenceDialog(context),
                  child: Text(
                    l10n.addGeoFence,
                    style: const TextStyle(color: CupertinoColors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddFenceDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    _nameController.clear();
    _latController.clear();
    _lngController.clear();
    _radiusController.text = '500';

    showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text(l10n.addGeoFence),
        content: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CupertinoTextField(
                controller: _nameController,
                placeholder: l10n.fenceName,
              ),
              const SizedBox(height: 8),
              CupertinoTextField(
                controller: _latController,
                placeholder: l10n.latitude,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 8),
              CupertinoTextField(
                controller: _lngController,
                placeholder: l10n.longitude,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 8),
              CupertinoTextField(
                controller: _radiusController,
                placeholder: '${l10n.radius} (${l10n.radiusUnit})',
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.cancel),
          ),
          CupertinoDialogAction(
            onPressed: () async {
              final name = _nameController.text.trim();
              final latStr = _latController.text.trim();
              final lngStr = _lngController.text.trim();
              final radiusStr = _radiusController.text.trim();
              if (name.isEmpty || latStr.isEmpty || lngStr.isEmpty || radiusStr.isEmpty) {
                return;
              }
              final lat = double.tryParse(latStr);
              final lng = double.tryParse(lngStr);
              final radius = int.tryParse(radiusStr);
              if (lat == null || lng == null || radius == null) return;

              final targetId = widget.targetUserId ?? '';
              final success = await context.read<LocationProvider>().createGeoFence(
                    name: name,
                    lat: lat,
                    lng: lng,
                    radius: radius,
                    targetUserId: targetId,
                  );
              if (ctx.mounted) Navigator.of(ctx).pop();
              if (success) {
                context.read<LocationProvider>().loadGeoFences();
              }
            },
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
  }
}
