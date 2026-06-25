import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/providers/dating_provider.dart';

class DatingLivePage extends StatefulWidget {
  const DatingLivePage({super.key});

  @override
  State<DatingLivePage> createState() => _DatingLivePageState();
}

class _DatingLivePageState extends State<DatingLivePage> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final provider = context.watch<DatingProvider>();
    final live = provider.currentLive;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.liveStream),
        trailing: live != null
            ? CupertinoButton(
                padding: EdgeInsets.zero,
                child: Text(l10n.endLive, style: const TextStyle(color: CupertinoColors.destructiveRed, fontSize: 15)),
                onPressed: () => provider.endLive(),
              )
            : null,
      ),
      child: SafeArea(
        child: live != null
            ? Column(
                children: [
                  Expanded(
                    child: Container(
                      color: CupertinoColors.black,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(CupertinoIcons.videocam_fill, size: 64, color: CupertinoColors.systemGrey),
                            const SizedBox(height: 16),
                            Text('直播中', style: const TextStyle(color: CupertinoColors.white, fontSize: 24)),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(CupertinoIcons.eye_fill, size: 18, color: CupertinoColors.white),
                                const SizedBox(width: 6),
                                Text('${live.viewerCount} 观看', style: const TextStyle(color: CupertinoColors.white, fontSize: 16)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text('礼物价值: ${live.giftValue} 珍爱币', style: const TextStyle(color: CupertinoColors.systemYellow, fontSize: 14)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    color: CupertinoColors.systemBackground,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _giftButton('🌹', '1 Coin', () => provider.sendGift('', 'rose')),
                        _giftButton('🚗', '10 Coins', () => provider.sendGift('', 'car')),
                        _giftButton('🏰', '50 Coins', () => provider.sendGift('', 'castle')),
                      ],
                    ),
                  ),
                ],
              )
            : Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(CupertinoIcons.videocam, size: 64, color: CupertinoColors.systemGrey),
                    const SizedBox(height: 16),
                    CupertinoButton.filled(
                      child: Text(l10n.startLive),
                      onPressed: () => provider.startLive(),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _giftButton(String emoji, String label, VoidCallback onTap) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: CupertinoColors.systemGrey5,
      borderRadius: BorderRadius.circular(12),
      onPressed: onTap,
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF3C3C43))),
        ],
      ),
    );
  }
}
