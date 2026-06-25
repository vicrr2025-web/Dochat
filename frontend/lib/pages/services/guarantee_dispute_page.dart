import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/providers/guarantee_provider.dart';

class GuaranteeDisputePage extends StatefulWidget {
  final String tradeId;

  const GuaranteeDisputePage({super.key, required this.tradeId});

  @override
  State<GuaranteeDisputePage> createState() => _GuaranteeDisputePageState();
}

class _GuaranteeDisputePageState extends State<GuaranteeDisputePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GuaranteeProvider>().loadDispute(widget.tradeId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.disputeDetail),
      ),
      child: SafeArea(
        child: Consumer<GuaranteeProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return const Center(child: CupertinoActivityIndicator());
            }

            final dispute = provider.currentDispute;
            if (dispute == null) {
              return Center(
                child: Text(
                  l10n.noTrades,
                  style: const TextStyle(
                    fontSize: 14,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildInfoCard(l10n, dispute),
                  const SizedBox(height: 16),
                  _buildJuryProgress(l10n, dispute),
                  if (dispute.verdict != null) ...[
                    const SizedBox(height: 16),
                    _buildVerdictCard(l10n, dispute),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoCard(AppLocalizations l10n, dispute) {
    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CupertinoColors.systemGrey5, width: 0.5),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.disputeDetail,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1C1C1E),
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: dispute.status == 'executed'
                      ? const Color(0xFF34C759).withOpacity(0.12)
                      : const Color(0xFFFF9500).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _disputeStatusLabel(dispute.status, l10n),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: dispute.status == 'executed'
                        ? const Color(0xFF34C759)
                        : const Color(0xFFFF9500),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _infoRow(l10n.columnReason, dispute.reason),
          const SizedBox(height: 6),
          _infoRow(l10n.productDesc, dispute.description),
          const SizedBox(height: 6),
          _infoRow(l10n.initiator, dispute.initiatorId),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 13,
            color: CupertinoColors.systemGrey,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF1C1C1E),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildJuryProgress(AppLocalizations l10n, dispute) {
    final totalVotes = dispute.votesForBuyer + dispute.votesForSeller;
    final juryTotal = dispute.juryCount > 0 ? dispute.juryCount : 19;
    final buyerPercent = juryTotal > 0
        ? (dispute.votesForBuyer / juryTotal).clamp(0.0, 1.0)
        : 0.0;
    final sellerPercent = juryTotal > 0
        ? (dispute.votesForSeller / juryTotal).clamp(0.0, 1.0)
        : 0.0;

    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CupertinoColors.systemGrey5, width: 0.5),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.juryVoting,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1C1C1E),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$totalVotes / $juryTotal ${l10n.votes}',
            style: const TextStyle(
              fontSize: 13,
              color: CupertinoColors.systemGrey,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                l10n.buyer,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF007AFF),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: SizedBox(
                    height: 20,
                    child: Stack(
                      children: [
                        Container(color: CupertinoColors.systemGrey5),
                        FractionallySizedBox(
                          widthFactor: buyerPercent,
                          child: Container(
                            color: const Color(0xFF007AFF),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '${dispute.votesForBuyer}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF007AFF),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                l10n.seller,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF34C759),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: SizedBox(
                    height: 20,
                    child: Stack(
                      children: [
                        Container(color: CupertinoColors.systemGrey5),
                        FractionallySizedBox(
                          widthFactor: sellerPercent,
                          child: Container(
                            color: const Color(0xFF34C759),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '${dispute.votesForSeller}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF34C759),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVerdictCard(AppLocalizations l10n, dispute) {
    final winnerLabel = dispute.verdict == 'buyer' ? l10n.buyer : l10n.seller;
    final color = dispute.verdict == 'buyer'
        ? const Color(0xFF007AFF)
        : const Color(0xFF34C759);

    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 0.5),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          Text(
            l10n.juryVerdict,
            style: const TextStyle(
              fontSize: 14,
              color: CupertinoColors.systemGrey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            winnerLabel,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  String _disputeStatusLabel(String status, AppLocalizations l10n) {
    switch (status) {
      case 'pending':
        return l10n.pending;
      case 'voting':
        return l10n.verifyStatus;
      case 'executed':
        return l10n.completed;
      default:
        return status;
    }
  }
}
