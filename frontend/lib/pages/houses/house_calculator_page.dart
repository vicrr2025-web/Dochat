import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/providers/house_provider.dart';

class HouseCalculatorPage extends StatefulWidget {
  const HouseCalculatorPage({super.key});

  @override
  State<HouseCalculatorPage> createState() => _HouseCalculatorPageState();
}

class _HouseCalculatorPageState extends State<HouseCalculatorPage> {
  final _totalPriceController = TextEditingController();
  final _downPaymentController = TextEditingController();
  final _rateController = TextEditingController();
  final _yearsController = TextEditingController();
  int _calcType = 0;

  @override
  void dispose() {
    _totalPriceController.dispose();
    _downPaymentController.dispose();
    _rateController.dispose();
    _yearsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.mortgageCalc),
      ),
      child: SafeArea(
        child: Consumer<HouseProvider>(
          builder: (context, provider, _) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                    child: CupertinoSlidingSegmentedControl<int>(
                      groupValue: _calcType,
                      children: {
                        0: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Text(l10n.mortgageCalc,
                              style: const TextStyle(fontSize: 14)),
                        ),
                        1: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Text(l10n.taxCalc,
                              style: const TextStyle(fontSize: 14)),
                        ),
                      },
                      onValueChanged: (v) {
                        if (v == null) return;
                        setState(() => _calcType = v);
                        provider.clearCalculationResults();
                      },
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildInputRow(l10n.housePrice,
                            _totalPriceController, '万元'),
                        const SizedBox(height: 12),
                        _buildInputRow(l10n.downPayment,
                            _downPaymentController, '万元'),
                        const SizedBox(height: 12),
                        if (_calcType == 0) ...[
                          _buildInputRow(
                              l10n.loanRate, _rateController, '%'),
                          const SizedBox(height: 12),
                          _buildInputRow(
                              l10n.loanYears, _yearsController, '年'),
                        ],
                        const SizedBox(height: 20),
                        CupertinoButton.filled(
                          child: const Text('计算'),
                          onPressed: () {
                            final totalPrice = double.tryParse(
                                _totalPriceController.text);
                            final downPayment = double.tryParse(
                                _downPaymentController.text);
                            if (totalPrice == null || downPayment == null) {
                              return;
                            }
                            if (_calcType == 0) {
                              final rate = double.tryParse(
                                  _rateController.text);
                              final years = int.tryParse(
                                  _yearsController.text);
                              if (rate == null || years == null) return;
                              provider.calculateMortgage({
                                'totalPrice': totalPrice,
                                'downPayment': downPayment,
                                'loanRate': rate,
                                'loanYears': years,
                              });
                            } else {
                              provider.calculateTax({
                                'totalPrice': totalPrice,
                                'downPayment': downPayment,
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        if (_calcType == 0 && provider.mortgageResult != null)
                          _buildResultCard(l10n, provider.mortgageResult!)
                        else if (_calcType == 1 &&
                            provider.taxResult != null)
                          _buildTaxResultCard(l10n, provider.taxResult!),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildInputRow(
      String label, TextEditingController controller, String unit) {
    return Row(
      children: [
        SizedBox(
          width: 60,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1C1C1E),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: CupertinoTextField(
            controller: controller,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F7),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          unit,
          style: const TextStyle(fontSize: 14, color: Color(0xFF8E8E93)),
        ),
      ],
    );
  }

  Widget _buildResultCard(
      AppLocalizations l10n, Map<String, dynamic> result) {
    final monthlyPayment = result['monthlyPayment']?.toString() ?? '--';
    final totalPayment = result['totalPayment']?.toString() ?? '--';
    final totalInterest = result['totalInterest']?.toString() ?? '--';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CupertinoColors.systemGrey5, width: 0.5),
      ),
      child: Column(
        children: [
          _buildResultRow(l10n.monthlyPayment,
              '$monthlyPayment 元', const Color(0xFFFF3B30)),
          const SizedBox(height: 12),
          _buildResultRow(
              l10n.totalPriceLabel, '$totalPayment 元', const Color(0xFF1C1C1E)),
          const SizedBox(height: 12),
          _buildResultRow(l10n.totalInterest, '$totalInterest 元',
              const Color(0xFFFF9500)),
        ],
      ),
    );
  }

  Widget _buildTaxResultCard(
      AppLocalizations l10n, Map<String, dynamic> result) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CupertinoColors.systemGrey5, width: 0.5),
      ),
      child: Column(
        children: [
          _buildResultRow('契税', '${result['deedTax'] ?? '--'} 元',
              const Color(0xFF1C1C1E)),
          const SizedBox(height: 12),
          _buildResultRow('个税', '${result['incomeTax'] ?? '--'} 元',
              const Color(0xFF1C1C1E)),
          const SizedBox(height: 12),
          _buildResultRow('增值税', '${result['vat'] ?? '--'} 元',
              const Color(0xFF1C1C1E)),
          Container(height: 1, color: CupertinoColors.systemGrey5),
          _buildResultRow('税费合计', '${result['totalTax'] ?? '--'} 元',
              const Color(0xFFFF3B30)),
        ],
      ),
    );
  }

  Widget _buildResultRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Color(0xFF8E8E93)),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
