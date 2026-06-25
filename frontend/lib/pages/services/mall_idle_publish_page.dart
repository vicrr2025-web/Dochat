import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/models/mall_models.dart';
import 'package:dochat_app/providers/mall_provider.dart';

class MallIdlePublishPage extends StatefulWidget {
  const MallIdlePublishPage({super.key});

  @override
  State<MallIdlePublishPage> createState() => _MallIdlePublishPageState();
}

class _MallIdlePublishPageState extends State<MallIdlePublishPage> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  String _category = 'idle';
  String _delivery = 'express';
  final List<String> _images = [];
  bool _aiGenerating = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.idleItems),
        trailing: GestureDetector(
          onTap: () => _submit(context),
          child: Text(l10n.publish,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.productTitle,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              CupertinoTextField(
                controller: _titleController,
                placeholder: l10n.productName,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(l10n.productDesc,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600)),
                  ),
                  CupertinoButton(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 4),
                    color: CupertinoColors.systemGrey5,
                    child: _aiGenerating
                        ? const CupertinoActivityIndicator()
                        : const Text('AI',
                            style: TextStyle(fontSize: 13)),
                    onPressed: () {
                      setState(() => _aiGenerating = true);
                      Future.delayed(const Duration(seconds: 1), () {
                        setState(() {
                          _descController.text = '九成新，功能完好，包装齐全。';
                          _aiGenerating = false;
                        });
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              CupertinoTextField(
                controller: _descController,
                placeholder: l10n.productDesc,
                maxLines: 4,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 16),
              Text(l10n.productPrice,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              CupertinoTextField(
                controller: _priceController,
                placeholder: '¥ 0.00',
                keyboardType: const TextInputType.numberWithOptions(
                    decimal: true),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 16),
              Text('配送方式',
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              CupertinoSlidingSegmentedControl<String>(
                groupValue: _delivery,
                onValueChanged: (v) {
                  if (v != null) setState(() => _delivery = v);
                },
                children: const {
                  'express': Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text('快递'),
                  ),
                  'self': Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text('自提'),
                  ),
                  'local': Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text('同城'),
                  ),
                },
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
                          margin:
                              const EdgeInsets.only(right: 10, top: 10),
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
            ],
          ),
        ),
      ),
    );
  }

  void _submit(BuildContext context) async {
    final title = _titleController.text.trim();
    final price = double.tryParse(_priceController.text.trim()) ?? 0;
    if (title.isEmpty || price <= 0) return;

    final request = PublishProductRequest(
      title: title,
      desc: _descController.text.trim(),
      price: price,
      category: _category,
      images: _images,
    );

    final ok = await context.read<MallProvider>().publishProduct(request);
    if (ok && context.mounted) {
      Navigator.pop(context);
    }
  }
}
