import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/providers/location_provider.dart';

class TrajectoryPage extends StatefulWidget {
  final String friendId;
  final String friendName;

  const TrajectoryPage({
    super.key,
    required this.friendId,
    required this.friendName,
  });

  @override
  State<TrajectoryPage> createState() => _TrajectoryPageState();
}

class _TrajectoryPageState extends State<TrajectoryPage> {
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 1));
  DateTime _endDate = DateTime.now();
  bool _isPlaying = false;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LocationProvider>().loadTrajectory(
            widget.friendId,
            _startDate,
            _endDate,
          );
    });
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  void _playTrajectory() {
    final provider = context.read<LocationProvider>();
    final points = provider.trajectory;
    if (points.isEmpty) return;

    setState(() {
      _isPlaying = true;
      _currentIndex = 0;
    });

    Future.doWhile(() async {
      if (!_isPlaying || !mounted) return false;
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return false;
      setState(() {
        if (_currentIndex < points.length - 1) {
          _currentIndex++;
        }
      });
      if (_currentIndex >= points.length - 1) {
        setState(() => _isPlaying = false);
        return false;
      }
      return _isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final provider = context.watch<LocationProvider>();
    final points = provider.trajectory;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.trajectory),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CupertinoButton(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    minSize: 0,
                    child: Text(
                      _formatDate(_startDate),
                      style: const TextStyle(fontSize: 14),
                    ),
                    onPressed: () async {
                      final picked = await showCupertinoModalPopup<DateTime>(
                        context: context,
                        builder: (ctx) => Container(
                          height: 260,
                          color: CupertinoColors.systemBackground,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CupertinoButton(
                                    child: Text(l10n.cancel),
                                    onPressed: () => Navigator.pop(ctx),
                                  ),
                                  CupertinoButton(
                                    child: Text(l10n.confirm),
                                    onPressed: () {
                                      Navigator.pop(ctx, _startDate);
                                    },
                                  ),
                                ],
                              ),
                              Expanded(
                                child: CupertinoDatePicker(
                                  mode: CupertinoDatePickerMode.date,
                                  initialDateTime: _startDate,
                                  minimumDate: DateTime.now().subtract(const Duration(days: 7)),
                                  maximumDate: _endDate,
                                  onDateTimeChanged: (date) {
                                    _startDate = date;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                      if (picked != null && mounted) {
                        provider.loadTrajectory(widget.friendId, picked, _endDate);
                      }
                    },
                  ),
                  const Text('~', style: TextStyle(fontSize: 16)),
                  CupertinoButton(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    minSize: 0,
                    child: Text(
                      _formatDate(_endDate),
                      style: const TextStyle(fontSize: 14),
                    ),
                    onPressed: () async {
                      final picked = await showCupertinoModalPopup<DateTime>(
                        context: context,
                        builder: (ctx) => Container(
                          height: 260,
                          color: CupertinoColors.systemBackground,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CupertinoButton(
                                    child: Text(l10n.cancel),
                                    onPressed: () => Navigator.pop(ctx),
                                  ),
                                  CupertinoButton(
                                    child: Text(l10n.confirm),
                                    onPressed: () {
                                      Navigator.pop(ctx, _endDate);
                                    },
                                  ),
                                ],
                              ),
                              Expanded(
                                child: CupertinoDatePicker(
                                  mode: CupertinoDatePickerMode.date,
                                  initialDateTime: _endDate,
                                  minimumDate: _startDate,
                                  maximumDate: DateTime.now(),
                                  onDateTimeChanged: (date) {
                                    _endDate = date;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                      if (picked != null && mounted) {
                        provider.loadTrajectory(widget.friendId, _startDate, picked);
                      }
                    },
                  ),
                ],
              ),
            ),
            Container(
              height: 180,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFE5E5EA),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(CupertinoIcons.map, size: 48, color: CupertinoColors.systemGrey),
                    SizedBox(height: 8),
                    Text(
                      'Trajectory Map',
                      style: TextStyle(color: CupertinoColors.systemGrey, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            CupertinoButton.filled(
              onPressed: points.isEmpty ? null : () => _playTrajectory(),
              child: Text(
                _isPlaying ? l10n.playing : l10n.play,
                style: const TextStyle(color: CupertinoColors.white),
              ),
            ),
            if (_isPlaying && _currentIndex < points.length)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  '点 ${_currentIndex + 1}/${points.length}',
                  style: const TextStyle(fontSize: 12, color: CupertinoColors.systemGrey),
                ),
              ),
            Expanded(
              child: provider.isLoading
                  ? const Center(child: CupertinoActivityIndicator())
                  : points.isEmpty
                      ? Center(
                          child: Text(
                            l10n.noTrajectoryData,
                            style: const TextStyle(
                              color: CupertinoColors.systemGrey,
                              fontSize: 15,
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: points.length,
                          itemBuilder: (context, index) {
                            final point = points[index];
                            final isActive = _isPlaying && index == _currentIndex;
                            return Container(
                              margin: const EdgeInsets.only(bottom: 4),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: isActive
                                    ? CupertinoColors.activeBlue.withOpacity(0.1)
                                    : CupertinoColors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    isActive
                                        ? CupertinoIcons.location_solid
                                        : CupertinoIcons.location,
                                    size: 16,
                                    color: isActive
                                        ? CupertinoColors.activeBlue
                                        : CupertinoColors.systemGrey,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      '${point.recordedAt.hour.toString().padLeft(2, '0')}:${point.recordedAt.minute.toString().padLeft(2, '0')}  '
                                      '(${point.latitude.toStringAsFixed(4)}, ${point.longitude.toStringAsFixed(4)})',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isActive
                                            ? CupertinoColors.activeBlue
                                            : CupertinoColors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
