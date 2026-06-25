import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/models/mall_models.dart';
import 'package:dochat_app/providers/mall_provider.dart';

class MallRecyclePage extends StatefulWidget {
  const MallRecyclePage({super.key});

  @override
  State<MallRecyclePage> createState() => _MallRecyclePageState();
}

class _MallRecyclePageState extends State<MallRecyclePage> {
  final _descController = TextEditingController();
  String _category = 'phone';
  final List<String> _images = [];
  double? _estimatedPrice;

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.submitRecycle),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.productCategory,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              CupertinoSlidingSegmentedControl<String>(
                groupValue: _category,
                onValueChanged: (v) {
                  if (v != null) setState(() => _category = v);
                },
                children: {
                  'phone': Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    child: Text('手机', style: TextStyle(fontSize: 12)),
                  ),
                  'laptop': Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    child: Text('笔记本', style: TextStyle(fontSize: 12)),
                  ),
                  'tablet': Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    child: Text('平板', style: TextStyle(fontSize: 12)),
                  ),
                  'other': Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    child: Text(l10n.other, style: TextStyle(fontSize: 12)),
                  ),
                },
              ),
              const SizedBox(height: 16),
              Text(l10n.productDesc,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              CupertinoTextField(
                controller: _descController,
                placeholder: l10n.productDesc,
                maxLines: 3,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 16),
              Text(l10n.productImages,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Container(
                height: 100,
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(
                            () => _images.add('placeholder_image'));
                      },
                      child: Container(
                        width: 80,
                        height: 80,
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2F2F7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(CupertinoIcons.camera,
                            color: CupertinoColors.systemGrey),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _images.length,
                        itemBuilder: (_, i) => Container(
                          width: 80,
                          height: 80,
                          margin: const EdgeInsets.only(
                              right: 10, top: 10),
                          decoration: BoxDecoration(
                            color: CupertinoColors.systemGrey5,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(CupertinoIcons.photo,
                              color: CupertinoColors.systemGrey),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (_estimatedPrice != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF5E5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '估价: ',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '¥${_estimatedPrice!.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 22,
                            color: Color(0xFFFF3B30),
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CupertinoButton(
                      color: CupertinoColors.systemGrey4,
                      child: Text(l10n.recycleEstimate),
                      onPressed: () async {
                        final result = await context
                            .read<MallProvider>()
                            .estimateRecycle(RecycleRequest(
                              category: _category,
                              desc: _descController.text.trim(),
                              images: _images,
                            ));
                        if (result != null) {
                          setState(() {
                            _estimatedPrice =
                                (result['price'] as num?)
                                        ?.toDouble() ??
                                    0;
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CupertinoButton(
                      color: CupertinoColors.systemBlue,
                      child: Text(l10n.submitRecycle),
                      onPressed: () async {
                        final ok = await context
                            .read<MallProvider>()
                            .submitRecycle(RecycleRequest(
                              category: _category,
                              desc: _descController.text.trim(),
                              images: _images,
                            ));
                        if (ok && context.mounted) {
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
