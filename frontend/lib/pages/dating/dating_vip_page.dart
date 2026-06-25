import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/providers/dating_provider.dart';

class DatingVipPage extends StatefulWidget {
  const DatingVipPage({super.key});

  @override
  State<DatingVipPage> createState() => _DatingVipPageState();
}

class _DatingVipPageState extends State<DatingVipPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DatingProvider>().loadProfile();
    });
  }

  void _recharge(int amount) async {
    final provider = context.read<DatingProvider>();
    final ok = await provider.recharge(amount);
    if (mounted) {
      showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
          title: Text(ok ? '充值成功' : '充值失败'),
          content: Text(ok ? '已成功充值 $amount 珍爱币' : '请稍后重试'),
          actions: [CupertinoDialogAction(child: const Text('OK'), onPressed: () => Navigator.pop(context))],
        ),
      );
    }
  }

  void _upgradeVip(int months) async {
    final provider = context.read<DatingProvider>();
    final ok = await provider.upgradeVip(months);
    if (mounted) {
      showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
          title: Text(ok ? '升级成功' : '升级失败'),
          content: Text(ok ? '已成功升级VIP $months 个月' : '请稍后重试'),
          actions: [CupertinoDialogAction(child: const Text('OK'), onPressed: () => Navigator.pop(context))],
        ),
      );
    }
  }

  void _withdraw() async {
    final provider = context.read<DatingProvider>();
    final charm = provider.profile?.charmValue ?? 0;
    if (charm <= 0) return;
    final ok = await provider.charmWithdraw(charm);
    if (mounted) {
      showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
          title: Text(ok ? '提现成功' : '提现失败'),
          actions: [CupertinoDialogAction(child: const Text('OK'), onPressed: () => Navigator.pop(context))],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final profile = context.watch<DatingProvider>().profile;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text(l10n.vipMember)),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFFFFD700), Color(0xFFFFA500)]),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.loveCoin, style: const TextStyle(fontSize: 16, color: CupertinoColors.white)),
                          Text('${profile?.loveCoin ?? 0}', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: CupertinoColors.white)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(l10n.charmValue, style: const TextStyle(fontSize: 16, color: CupertinoColors.white)),
                          Text('${profile?.charmValue ?? 0}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: CupertinoColors.white)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(CupertinoIcons.star_fill, size: 16, color: CupertinoColors.white),
                      const SizedBox(width: 4),
                      Text('VIP Lv.${profile?.vipLevel ?? 0}', style: const TextStyle(fontSize: 14, color: CupertinoColors.white)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(l10n.rechargeLabel, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _rechargeButton('100 珍爱币', '¥100', () => _recharge(100)),
                _rechargeButton('500 珍爱币', '¥500', () => _recharge(500)),
                _rechargeButton('1000 珍爱币', '¥1000', () => _recharge(1000)),
                _rechargeButton('5000 珍爱币', '¥5000', () => _recharge(5000)),
              ],
            ),
            const SizedBox(height: 24),
            Text(l10n.vipMember, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _vipButton('1个月', '¥30', () => _upgradeVip(1))),
                const SizedBox(width: 12),
                Expanded(child: _vipButton('3个月', '¥80', () => _upgradeVip(3))),
                const SizedBox(width: 12),
                Expanded(child: _vipButton('12个月', '¥288', () => _upgradeVip(12))),
              ],
            ),
            const SizedBox(height: 24),
            CupertinoButton(
              padding: const EdgeInsets.symmetric(vertical: 14),
              color: const Color(0xFFFF6B8A),
              borderRadius: BorderRadius.circular(14),
              child: Text(l10n.superBoost, style: const TextStyle(color: CupertinoColors.white, fontSize: 16)),
              onPressed: () {
                context.read<DatingProvider>().superBoost();
                showCupertinoDialog(
                  context: context,
                  builder: (_) => CupertinoAlertDialog(
                    title: Text(l10n.superBoost),
                    content: const Text('已开启超级推荐，将获得更多曝光！'),
                    actions: [CupertinoDialogAction(child: const Text('OK'), onPressed: () => Navigator.pop(context))],
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            CupertinoButton(
              padding: const EdgeInsets.symmetric(vertical: 14),
              color: CupertinoColors.systemGrey5,
              borderRadius: BorderRadius.circular(14),
              child: Text(l10n.withdrawLabel, style: const TextStyle(color: Color(0xFF1C1C1E), fontSize: 16)),
              onPressed: _withdraw,
            ),
          ],
        ),
      ),
    );
  }

  Widget _rechargeButton(String label, String price, VoidCallback onTap) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      color: CupertinoColors.white,
      borderRadius: BorderRadius.circular(12),
      onPressed: onTap,
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF1C1C1E))),
          const SizedBox(height: 4),
          Text(price, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFFFF6B8A))),
        ],
      ),
    );
  }

  Widget _vipButton(String label, String price, VoidCallback onTap) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(vertical: 16),
      color: CupertinoColors.white,
      borderRadius: BorderRadius.circular(12),
      onPressed: onTap,
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF1C1C1E))),
          const SizedBox(height: 4),
          Text(price, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFFFFD700))),
        ],
      ),
    );
  }
}
