import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/models/mall_models.dart';
import 'package:dochat_app/providers/mall_provider.dart';

class MallReviewPage extends StatefulWidget {
  final String orderId;

  const MallReviewPage({super.key, required this.orderId});

  @override
  State<MallReviewPage> createState() => _MallReviewPageState();
}

class _MallReviewPageState extends State<MallReviewPage> {
  final _contentController = TextEditingController();
  int _rating = 5;

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.writeReview),
        trailing: GestureDetector(
          onTap: () => _submit(context),
          child: Text(l10n.submitVerify,
              style: const TextStyle(
                  color: CupertinoColors.systemBlue,
                  fontSize: 16,
                  fontWeight: FontWeight.w600)),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Text(l10n.rating,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) {
                  return GestureDetector(
                    onTap: () => setState(() => _rating = i + 1),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Icon(
                        i < _rating
                            ? CupertinoIcons.star_fill
                            : CupertinoIcons.star,
                        size: 36,
                        color: const Color(0xFFFFD60A),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),
              CupertinoTextField(
                controller: _contentController,
                placeholder: l10n.saySomething,
                maxLines: 5,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit(BuildContext context) async {
    final request = SubmitReviewRequest(
      orderId: widget.orderId,
      rating: _rating,
      content: _contentController.text.trim(),
    );

    final ok = await context.read<MallProvider>().submitReview(request);
    if (ok && context.mounted) {
      Navigator.pop(context);
    }
  }
}
