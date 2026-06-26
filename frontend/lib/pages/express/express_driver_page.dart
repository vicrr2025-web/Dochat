import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/providers/express_provider.dart';

class ExpressDriverPage extends StatefulWidget {
  const ExpressDriverPage({super.key});

  @override
  State<ExpressDriverPage> createState() => _ExpressDriverPageState();
}

class _ExpressDriverPageState extends State<ExpressDriverPage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _idController = TextEditingController();
  final _licenseController = TextEditingController();
  final _vehicleController = TextEditingController();
  final _plateController = TextEditingController();
  final _withdrawAmountController = TextEditingController();
  final _bankAccountController = TextEditingController();
  bool _registering = false;
  bool _withdrawing = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _idController.dispose();
    _licenseController.dispose();
    _vehicleController.dispose();
    _plateController.dispose();
    _withdrawAmountController.dispose();
    _bankAccountController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ExpressProvider>().loadDriverIncome();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.driverRegister),
      ),
      child: SafeArea(
        child: Consumer<ExpressProvider>(
          builder: (context, provider, _) {
            if (provider.loading) {
              return const Center(child: CupertinoActivityIndicator());
            }

            final driver = provider.driver;

            if (driver == null) {
              return _registrationForm(l10n, provider);
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _driverProfileCard(l10n, driver, provider),
                  const SizedBox(height: 14),
                  if (provider.income != null) _incomeCard(l10n, provider.income!),
                  const SizedBox(height: 14),
                  _pendingOrdersSection(l10n, provider),
                  const SizedBox(height: 14),
                  _withdrawSection(l10n, provider),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _registrationForm(AppLocalizations l10n, ExpressProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.driverAuth,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1C1C1E),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            '\u63D0\u4EA4\u4EE5\u4E0B\u4FE1\u606F\u5B8C\u6210\u53F8\u673A\u8BA4\u8BC1',
            style: TextStyle(fontSize: 13, color: CupertinoColors.systemGrey),
          ),
          const SizedBox(height: 16),
          _inputField('\u59D3\u540D', _nameController),
          const SizedBox(height: 10),
          _inputField('\u624B\u673A\u53F7', _phoneController),
          const SizedBox(height: 10),
          _inputField('\u8EAB\u4EFD\u8BC1\u53F7', _idController),
          const SizedBox(height: 10),
          _inputField('\u9A7E\u7167\u53F7', _licenseController),
          const SizedBox(height: 10),
          _inputField('\u8F66\u8F86\u7C7B\u578B', _vehicleController),
          const SizedBox(height: 10),
          _inputField('\u8F66\u724C\u53F7', _plateController),
          const SizedBox(height: 24),
          CupertinoButton.filled(
            onPressed: _registering
                ? null
                : () async {
                    setState(() => _registering = true);
                    final ok = await provider.registerDriver({
                      'name': _nameController.text,
                      'phone': _phoneController.text,
                      'idNumber': _idController.text,
                      'licenseNumber': _licenseController.text,
                      'vehicleType': _vehicleController.text,
                      'vehiclePlate': _plateController.text,
                    });
                    setState(() => _registering = false);
                    if (ok && mounted) {
                      showCupertinoDialog(
                        context: context,
                        builder: (_) => CupertinoAlertDialog(
                          title: Text(l10n.driverRegister),
                          content: const Text('\u63D0\u4EA4\u6210\u529F\uFF0C\u7B49\u5F85\u5BA1\u6838'),
                          actions: [
                            CupertinoDialogAction(
                              onPressed: () => Navigator.pop(context),
                              child: Text(l10n.confirm),
                            ),
                          ],
                        ),
                      );
                    }
                  },
            child: Text(_registering ? l10n.loading : l10n.driverRegister),
          ),
        ],
      ),
    );
  }

  Widget _driverProfileCard(AppLocalizations l10n, dynamic driver, ExpressProvider provider) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CupertinoColors.systemGrey5, width: 0.5),
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipOval(
                child: Container(
                  width: 52,
                  height: 52,
                  color: CupertinoColors.systemGrey5,
                  child: const Icon(CupertinoIcons.person_fill, size: 28, color: CupertinoColors.systemGrey),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      driver.name,
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Color(0xFF1C1C1E)),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${driver.vehicleType} | ${driver.vehiclePlate}',
                      style: const TextStyle(fontSize: 13, color: CupertinoColors.systemGrey),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${l10n.expressCreditScore}: ${driver.creditScore.toStringAsFixed(0)}',
                      style: const TextStyle(fontSize: 12, color: Color(0xFFFF9500), fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              CupertinoSwitch(
                value: driver.status == 'online',
                activeColor: const Color(0xFF34C759),
                onChanged: (v) {
                  provider.updateDriverStatus(v ? 'online' : 'offline');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _incomeCard(AppLocalizations l10n, Map<String, dynamic> income) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CupertinoColors.systemGrey5, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.driverIncome,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1C1C1E)),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _incomeMetric('\u7D2F\u8BA1\u6536\u5165', '\u00A5${(income['totalIncome'] ?? 0).toStringAsFixed(2)}'),
              _incomeMetric('\u53EF\u63D0\u73B0', '\u00A5${(income['balance'] ?? 0).toStringAsFixed(2)}'),
              _incomeMetric('\u4ECA\u65E5\u6536\u5165', '\u00A5${(income['todayIncome'] ?? 0).toStringAsFixed(2)}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _incomeMetric(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF1C1C1E))),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 11, color: CupertinoColors.systemGrey)),
      ],
    );
  }

  Widget _pendingOrdersSection(AppLocalizations l10n, ExpressProvider provider) {
    final pending = provider.orders.where((o) => o.status == 'pending').toList();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CupertinoColors.systemGrey5, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '\u5F85\u63A5\u5355 (${pending.length})',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1C1C1E)),
          ),
          const SizedBox(height: 8),
          if (pending.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('\u6682\u65E0\u5F85\u63A5\u8BA2\u5355', style: TextStyle(fontSize: 13, color: CupertinoColors.systemGrey)),
            )
          else
            ...pending.map((order) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey6,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${order.originAddress} \u2192 ${order.destAddress}',
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                            const SizedBox(height: 2),
                            Text(
                              '\u00A5${order.estimatedPrice.toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 14, color: Color(0xFFFF3B30), fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          CupertinoButton(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            color: const Color(0xFF34C759),
                            onPressed: () => provider.acceptOrder(order.orderId),
                            child: Text(l10n.acceptOrder, style: const TextStyle(fontSize: 12)),
                          ),
                          const SizedBox(width: 6),
                          CupertinoButton(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            color: CupertinoColors.destructiveRed,
                            onPressed: () {},
                            child: Text(l10n.rejectOrder, style: const TextStyle(fontSize: 12)),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
        ],
      ),
    );
  }

  Widget _withdrawSection(AppLocalizations l10n, ExpressProvider provider) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CupertinoColors.systemGrey5, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.withdrawCash,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1C1C1E)),
          ),
          const SizedBox(height: 8),
          _inputField('\u91D1\u989D', _withdrawAmountController),
          const SizedBox(height: 8),
          _inputField('\u94F6\u884C\u5361\u53F7', _bankAccountController),
          const SizedBox(height: 10),
          CupertinoButton.filled(
            onPressed: _withdrawing
                ? null
                : () async {
                    final amount = double.tryParse(_withdrawAmountController.text);
                    if (amount == null || amount <= 0) return;
                    setState(() => _withdrawing = true);
                    await provider.withdraw(amount, _bankAccountController.text);
                    setState(() => _withdrawing = false);
                  },
            child: Text(_withdrawing ? l10n.loading : l10n.withdrawCash),
          ),
        ],
      ),
    );
  }

  Widget _inputField(String hint, TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey6,
        borderRadius: BorderRadius.circular(8),
      ),
      child: CupertinoTextField(
        controller: controller,
        placeholder: hint,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const BoxDecoration(),
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
}
