import 'package:flutter/cupertino.dart';
import 'package:dochat_app/l10n/app_localizations.dart';

class DatingSettingsPage extends StatefulWidget {
  const DatingSettingsPage({super.key});

  @override
  State<DatingSettingsPage> createState() => _DatingSettingsPageState();
}

class _DatingSettingsPageState extends State<DatingSettingsPage> {
  bool _profileVisible = true;
  bool _notifyMatch = true;
  bool _notifyNote = true;
  bool _notifyLike = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text(l10n.settings)),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              decoration: BoxDecoration(color: CupertinoColors.white, borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  _buildSwitchRow('资料可见性', _profileVisible, (v) => setState(() => _profileVisible = v)),
                  _buildDivider(),
                  _buildSwitchRow('匹配通知', _notifyMatch, (v) => setState(() => _notifyMatch = v)),
                  _buildDivider(),
                  _buildSwitchRow('小纸条通知', _notifyNote, (v) => setState(() => _notifyNote = v)),
                  _buildDivider(),
                  _buildSwitchRow('喜欢通知', _notifyLike, (v) => setState(() => _notifyLike = v)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            CupertinoButton(
              padding: const EdgeInsets.symmetric(vertical: 14),
              color: CupertinoColors.white,
              borderRadius: BorderRadius.circular(12),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('已屏蔽的用户', style: TextStyle(color: Color(0xFF1C1C1E), fontSize: 16)),
                  Icon(CupertinoIcons.chevron_right, size: 18, color: CupertinoColors.systemGrey),
                ],
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchRow(String label, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16, color: Color(0xFF1C1C1E))),
          CupertinoSwitch(value: value, onChanged: onChanged, activeColor: const Color(0xFFFF6B8A)),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(height: 0.5, color: CupertinoColors.systemGrey5);
  }
}
