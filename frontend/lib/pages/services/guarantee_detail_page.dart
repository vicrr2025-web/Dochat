import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/models/guarantee_models.dart';
import 'package:dochat_app/providers/guarantee_provider.dart';
import 'package:dochat_app/services/chat_service.dart';
import 'package:dochat_app/services/guarantee_service.dart';
import 'package:dochat_app/pages/chat/chat_page.dart';
import 'package:dochat_app/pages/services/guarantee_dispute_page.dart';

Color _statusColor(String status) {
  switch (status) {
    case 'pending':
      return const Color(0xFFFF9500);
    case 'confirmed':
      return const Color(0xFF007AFF);
    case 'frozen':
      return const Color(0xFF5856D6);
    case 'verifying':
      return const Color(0xFFFF9500);
    case 'verified':
      return const Color(0xFF34C759);
    case 'completed':
      return const Color(0xFF34C759);
    case 'cancelled':
      return const Color(0xFFFF3B30);
    case 'disputed':
      return const Color(0xFFFF3B30);
    default:
      return CupertinoColors.systemGrey;
  }
}

String _statusLabel(String status, AppLocalizations l10n) {
  switch (status) {
    case 'pending':
      return l10n.pending;
    case 'confirmed':
      return l10n.confirmed;
    case 'frozen':
      return l10n.frozen;
    case 'verifying':
      return l10n.verifying;
    case 'verified':
      return l10n.verifyPassed;
    case 'completed':
      return l10n.completed;
    case 'cancelled':
      return l10n.cancelled;
    case 'disputed':
      return l10n.disputed;
    default:
      return status;
  }
}

int _statusIndex(String status) {
  const order = [
    'pending',
    'confirmed',
    'frozen',
    'verifying',
    'verified',
    'completed',
  ];
  final idx = order.indexOf(status);
  return idx >= 0 ? idx : 0;
}

class GuaranteeDetailPage extends StatefulWidget {
  final String tradeId;

  const GuaranteeDetailPage({super.key, required this.tradeId});

  @override
  State<GuaranteeDetailPage> createState() => _GuaranteeDetailPageState();
}

class _GuaranteeDetailPageState extends State<GuaranteeDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GuaranteeProvider>().loadTradeDetail(widget.tradeId);
    });
  }

  Future<void> _navigateToChat(TradeInfo trade, AppLocalizations l10n) async {
    if (trade.sessionId == null) {
      try {
        final guaranteeService = GuaranteeService();
        final chatResp = await guaranteeService.getChatSession(trade.tradeId);
        final chatService = ChatService();
        final sessions = await chatService.getSessions();
        final sessionInfo = sessions.where(
          (s) => s.sessionId == chatResp.sessionId,
        ).toList();
        if (sessionInfo.isNotEmpty && mounted) {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (_) => ChatPage(session: sessionInfo.first),
            ),
          );
        } else if (mounted) {
          showCupertinoDialog(
            context: context,
            builder: (ctx) => CupertinoAlertDialog(
              title: Text(l10n.networkError),
              actions: [
                CupertinoDialogAction(
                  child: Text(l10n.confirm),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
          );
        }
      } catch (_) {
        if (mounted) {
          showCupertinoDialog(
            context: context,
            builder: (ctx) => CupertinoAlertDialog(
              title: Text(l10n.networkError),
              actions: [
                CupertinoDialogAction(
                  child: Text(l10n.confirm),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
          );
        }
      }
      return;
    }
    try {
      final chatService = ChatService();
      final sessions = await chatService.getSessions();
      final sessionInfo = sessions.where(
        (s) => s.sessionId == trade.sessionId,
      ).toList();
      if (sessionInfo.isNotEmpty && mounted) {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (_) => ChatPage(session: sessionInfo.first),
          ),
        );
      } else if (mounted) {
        showCupertinoDialog(
          context: context,
          builder: (ctx) => CupertinoAlertDialog(
            title: Text(l10n.networkError),
            actions: [
              CupertinoDialogAction(
                child: Text(l10n.confirm),
                onPressed: () => Navigator.pop(ctx),
              ),
            ],
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        showCupertinoDialog(
          context: context,
          builder: (ctx) => CupertinoAlertDialog(
            title: Text(l10n.networkError),
            actions: [
              CupertinoDialogAction(
                child: Text(l10n.confirm),
                onPressed: () => Navigator.pop(ctx),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.tradeDetail),
      ),
      child: SafeArea(
        child: Consumer<GuaranteeProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return const Center(child: CupertinoActivityIndicator());
            }

            final trade = provider.currentTrade;
            if (trade == null) {
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

            final statusIdx = trade.status == 'cancelled' ||
                    trade.status == 'disputed'
                ? null
                : _statusIndex(trade.status);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (statusIdx != null) _buildStatusFlow(trade, l10n),
                  const SizedBox(height: 12),
                  _buildTradeInfoCard(trade, l10n),
                  const SizedBox(height: 12),
                  _buildActionButtons(trade, l10n),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatusFlow(TradeInfo trade, AppLocalizations l10n) {
    final steps = [
      l10n.pending,
      l10n.confirmed,
      l10n.frozen,
      l10n.verifying,
      l10n.verifyPassed,
      l10n.completed,
    ];
    final currentIdx = _statusIndex(trade.status);

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
            children: List.generate(steps.length, (i) {
              final isPast = i <= currentIdx;
              return Expanded(
                child: Row(
                  children: [
                    if (i > 0)
                      Expanded(
                        child: Container(
                          height: 2,
                          color: isPast
                              ? const Color(0xFF007AFF)
                              : CupertinoColors.systemGrey4,
                        ),
                      ),
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isPast
                            ? const Color(0xFF007AFF)
                            : CupertinoColors.systemGrey4,
                      ),
                      child: isPast
                          ? const Icon(
                              CupertinoIcons.checkmark_alt,
                              size: 12,
                              color: CupertinoColors.white,
                            )
                          : null,
                    ),
                    if (i < steps.length - 1)
                      Expanded(
                        child: Container(
                          height: 2,
                          color: i < currentIdx
                              ? const Color(0xFF007AFF)
                              : CupertinoColors.systemGrey4,
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(steps.length, (i) {
              final isActive = i <= currentIdx;
              return Expanded(
                child: Text(
                  steps[i],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    color: isActive
                        ? const Color(0xFF1C1C1E)
                        : CupertinoColors.systemGrey,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTradeInfoCard(TradeInfo trade, AppLocalizations l10n) {
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
                  trade.productName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1C1C1E),
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor(trade.status).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _statusLabel(trade.status, l10n),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _statusColor(trade.status),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (trade.productDesc.isNotEmpty) ...[
            Text(
              trade.productDesc,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF3C3C43),
              ),
            ),
            const SizedBox(height: 10),
          ],
          _infoRow(l10n.tradeAmount, '¥${trade.amount.toStringAsFixed(2)}'),
          const SizedBox(height: 6),
          _infoRow(l10n.buyer, trade.buyerNickname),
          const SizedBox(height: 6),
          _infoRow(l10n.seller, trade.sellerNickname),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 13,
            color: CupertinoColors.systemGrey,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF1C1C1E),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(TradeInfo trade, AppLocalizations l10n) {
    final buttons = <Widget>[];

    if (trade.status == 'pending' && _isSeller(trade)) {
      buttons.add(_actionButton(
        l10n.confirmTrade,
        const Color(0xFF007AFF),
        () async {
          final ok = await context
              .read<GuaranteeProvider>()
              .confirmTrade(trade.tradeId);
          if (ok && mounted) {
            _showToast(context, l10n.confirm);
          }
        },
      ));
    }

    if (trade.status == 'confirmed' && _isBuyer(trade)) {
      buttons.add(_actionButton(
        l10n.freezeFunds,
        const Color(0xFF5856D6),
        () async {
          final ok = await context
              .read<GuaranteeProvider>()
              .freezeFunds(trade.tradeId);
          if (ok && mounted) {
            _showToast(context, l10n.confirm);
          }
        },
      ));
    }

    if (trade.status == 'frozen' && _isBuyer(trade)) {
      buttons.add(_actionButton(
        l10n.initiateVerify,
        const Color(0xFFFF9500),
        () async {
          final ok = await context
              .read<GuaranteeProvider>()
              .initiateVerify(trade.tradeId);
          if (ok && mounted) {
            _showToast(context, l10n.confirm);
          }
        },
      ));
    }

    if (trade.status == 'verified' && _isBuyer(trade)) {
      buttons.add(_actionButton(
        l10n.releaseFunds,
        const Color(0xFF34C759),
        () async {
          final ok = await context
              .read<GuaranteeProvider>()
              .releaseFunds(trade.tradeId);
          if (ok && mounted) {
            _showToast(context, l10n.confirm);
          }
        },
      ));
    }

    if (trade.status == 'frozen' ||
        trade.status == 'verifying' ||
        trade.status == 'verified') {
      buttons.add(_actionButton(
        l10n.initiateDispute,
        const Color(0xFFFF3B30),
        () => _showDisputeDialog(context, trade, l10n),
      ));
    }

    if (trade.sessionId != null ||
        trade.status == 'frozen' ||
        trade.status == 'verifying' ||
        trade.status == 'verified') {
      buttons.add(_actionButton(
        l10n.chatWithCounterparty,
        const Color(0xFF007AFF),
        () => _navigateToChat(trade, l10n),
      ));
    }

    if (trade.disputeId != null) {
      buttons.add(_actionButton(
        l10n.viewDispute,
        const Color(0xFFFF3B30),
        () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (_) =>
                  GuaranteeDisputePage(tradeId: trade.tradeId),
            ),
          );
        },
      ));
    }

    return Column(
      children: buttons.map((b) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: b,
      )).toList(),
    );
  }

  Widget _actionButton(String label, Color color, VoidCallback onTap) {
    return CupertinoButton(
      color: color,
      borderRadius: BorderRadius.circular(12),
      onPressed: onTap,
      child: Text(
        label,
        style: const TextStyle(
          color: CupertinoColors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  bool _isSeller(TradeInfo trade) {
    return true;
  }

  bool _isBuyer(TradeInfo trade) {
    return true;
  }

  void _showToast(BuildContext context, String message) {
    showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: Text(AppLocalizations.of(context).confirm),
            onPressed: () => Navigator.pop(ctx),
          ),
        ],
      ),
    );
  }

  void _showDisputeDialog(
    BuildContext context,
    TradeInfo trade,
    AppLocalizations l10n,
  ) {
    final reasonCtrl = TextEditingController();
    final descCtrl = TextEditingController();

    showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text(l10n.initiateDispute),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            CupertinoTextField(
              controller: reasonCtrl,
              placeholder: l10n.columnReason,
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            const SizedBox(height: 10),
            CupertinoTextField(
              controller: descCtrl,
              placeholder: l10n.productDesc,
              maxLines: 3,
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            child: Text(l10n.cancel),
            onPressed: () => Navigator.pop(ctx),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text(l10n.confirm),
            onPressed: () async {
              Navigator.pop(ctx);
              final request = DisputeRequest(
                reason: reasonCtrl.text,
                description: descCtrl.text,
              );
              await context
                  .read<GuaranteeProvider>()
                  .createDispute(trade.tradeId, request);
            },
          ),
        ],
      ),
    );
  }
}
