import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/models/mall_models.dart';
import 'package:dochat_app/providers/mall_provider.dart';

class MallDisputePage extends StatefulWidget {
  final String orderId;

  const MallDisputePage({super.key, required this.orderId});

  @override
  State<MallDisputePage> createState() => _MallDisputePageState();
}

class _MallDisputePageState extends State<MallDisputePage> {
  final _reasonController = TextEditingController();
  Map<String, dynamic>? _dispute;
  bool _disputeLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDispute();
  }

  Future<void> _loadDispute() async {
    final d =
        await context.read<MallProvider>().getDispute(widget.orderId);
    if (mounted) {
      setState(() {
        _dispute = d;
        _disputeLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.viewDispute),
      ),
      child: SafeArea(
        child: _disputeLoading
            ? const Center(child: CupertinoActivityIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_dispute != null) ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: CupertinoColors.white,
                          borderRadius:
                              BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(l10n.disputeDetail,
                                style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight:
                                        FontWeight.w700)),
                            const SizedBox(height: 12),
                            _infoRow(l10n.columnReason,
                                _dispute!['reason']
                                        ?.toString() ??
                                    ''),
                            _infoRow(l10n.initiator,
                                _dispute!['initiatorId']
                                        ?.toString() ??
                                    ''),
                            _infoRow(
                                l10n.verifyStatus,
                                _dispute!['status']
                                        ?.toString() ??
                                    ''),
                            const SizedBox(height: 12),
                            Text(l10n.juryVoting,
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight:
                                        FontWeight.w600)),
                            const SizedBox(height: 8),
                            _juryProgress(),
                          ],
                        ),
                      ),
                    ] else ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: CupertinoColors.white,
                          borderRadius:
                              BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(l10n.refundReason,
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight:
                                        FontWeight.w600)),
                            const SizedBox(height: 8),
                            CupertinoTextField(
                              controller:
                                  _reasonController,
                              placeholder:
                                  l10n.refundReason,
                              maxLines: 3,
                              padding:
                                  const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color:
                                    const Color(0xFFF2F2F7),
                                borderRadius:
                                    BorderRadius.circular(
                                        10),
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: CupertinoButton(
                                color:
                                    CupertinoColors
                                        .destructiveRed,
                                child: Text(
                                    l10n.initiateDispute),
                                onPressed: () async {
                                  final ok = await context
                                      .read<
                                          MallProvider>()
                                      .createDispute(
                                          DisputeRequest(
                                    orderId:
                                        widget.orderId,
                                    reason: _reasonController
                                        .text
                                        .trim(),
                                  ));
                                  if (ok &&
                                      context.mounted) {
                                    Navigator.pop(
                                        context);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text('$label: ',
              style: const TextStyle(
                  fontSize: 13,
                  color: CupertinoColors.systemGrey)),
          Expanded(
            child: Text(value,
                style: const TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }

  Widget _juryProgress() {
    final total = (_dispute?['juryCount'] as int?) ?? 17;
    final forBuyer =
        (_dispute?['votesForBuyer'] as int?) ?? 0;
    final forSeller =
        (_dispute?['votesForSeller'] as int?) ?? 0;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Text('买方',
                      style: const TextStyle(
                          fontSize: 12,
                          color: CupertinoColors
                              .systemGrey)),
                  const SizedBox(height: 2),
                  Text('$forBuyer',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color:
                              CupertinoColors.systemBlue)),
                ],
              ),
            ),
            const Text('VS',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600)),
            Expanded(
              child: Column(
                children: [
                  Text('卖方',
                      style: const TextStyle(
                          fontSize: 12,
                          color: CupertinoColors
                              .systemGrey)),
                  const SizedBox(height: 2),
                  Text('$forSeller',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color:
                              CupertinoColors.destructiveRed)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            height: 24,
            child: Row(
              children: [
                if (total > 0)
                  Expanded(
                    flex: forBuyer,
                    child: Container(
                      color:
                          CupertinoColors.systemBlue,
                    ),
                  ),
                if (total > 0)
                  Expanded(
                    flex: forSeller,
                    child: Container(
                      color: CupertinoColors
                          .destructiveRed,
                    ),
                  ),
                if (total > 0 &&
                    (total -
                            forBuyer -
                            forSeller) >
                        0)
                  Expanded(
                    flex: total -
                        forBuyer -
                        forSeller,
                    child: Container(
                      color: CupertinoColors
                          .systemGrey4,
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text('$total 人参与投票',
            style: const TextStyle(
                fontSize: 12,
                color: CupertinoColors.systemGrey)),
      ],
    );
  }
}
