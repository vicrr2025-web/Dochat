import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/providers/mall_provider.dart';
import 'package:dochat_app/pages/services/mall_cart_page.dart';
import 'package:dochat_app/pages/services/mall_shop_page.dart';

class MallDetailPage extends StatefulWidget {
  final String productId;

  const MallDetailPage({super.key, required this.productId});

  @override
  State<MallDetailPage> createState() => _MallDetailPageState();
}

class _MallDetailPageState extends State<MallDetailPage> {
  int _imageIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<MallProvider>().loadProductDetail(widget.productId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.tradeDetail),
      ),
      child: SafeArea(
        child: Consumer<MallProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading || provider.currentProduct == null) {
              return const Center(child: CupertinoActivityIndicator());
            }
            final p = provider.currentProduct!;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 280,
                    child: Container(
                      color: const Color(0xFFF2F2F7),
                      child: p.images.isNotEmpty
                          ? Image.network(
                              p.images[_imageIndex % p.images.length],
                              fit: BoxFit.contain,
                              width: double.infinity,
                              errorBuilder: (_, __, ___) => const Center(
                                child: Icon(CupertinoIcons.photo,
                                    size: 64,
                                    color: CupertinoColors.systemGrey3),
                              ),
                            )
                          : const Center(
                              child: Icon(CupertinoIcons.photo,
                                  size: 64,
                                  color: CupertinoColors.systemGrey3),
                            ),
                    ),
                  ),
                  if (p.images.length > 1)
                    SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        itemCount: p.images.length,
                        itemBuilder: (_, i) => GestureDetector(
                          onTap: () => setState(() => _imageIndex = i),
                          child: Container(
                            width: 48,
                            height: 48,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: i == _imageIndex
                                    ? CupertinoColors.systemBlue
                                    : CupertinoColors.systemGrey4,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Image.network(
                              p.images[i],
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const SizedBox(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.title,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '¥${p.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: 24,
                              color: Color(0xFFFF3B30),
                              fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          p.desc,
                          style: const TextStyle(
                              fontSize: 14, color: CupertinoColors.systemGrey),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Icon(CupertinoIcons.person_circle,
                                size: 20, color: CupertinoColors.systemGrey),
                            const SizedBox(width: 6),
                            Text(
                              '${l10n.seller}: ${p.sellerId}',
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: CupertinoColors.systemGrey),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                if (p.shopId.isNotEmpty) {
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (_) =>
                                          MallShopPage(shopId: p.shopId),
                                    ),
                                  );
                                }
                              },
                              child: Text(
                                l10n.shopInfo,
                                style: const TextStyle(
                                    fontSize: 13,
                                    color: CupertinoColors.systemBlue),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: CupertinoButton(
                                color: CupertinoColors.systemBlue,
                                child: Text(l10n.addToCart),
                                onPressed: () async {
                                  final ok = await provider
                                      .addToCart(widget.productId);
                                  if (ok && context.mounted) {
                                    _showToast(context, l10n.addToCart);
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: CupertinoButton(
                                color: const Color(0xFFFF3B30),
                                child: Text(l10n.checkout),
                                onPressed: () async {
                                  await provider.addToCart(widget.productId);
                                  if (context.mounted) {
                                    Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (_) =>
                                            const MallCartPage(),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CupertinoButton(
                              padding: EdgeInsets.zero,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(CupertinoIcons.heart,
                                      size: 18,
                                      color: CupertinoColors.systemBlue),
                                  const SizedBox(width: 4),
                                  Text(l10n.addFavorite,
                                      style: const TextStyle(fontSize: 13)),
                                ],
                              ),
                              onPressed: () {
                                provider.toggleFavorite(widget.productId);
                              },
                            ),
                            CupertinoButton(
                              padding: EdgeInsets.zero,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(CupertinoIcons.chat_bubble_text,
                                      size: 18,
                                      color: CupertinoColors.systemBlue),
                                  const SizedBox(width: 4),
                                  Text(l10n.contactSellerLabel,
                                      style: const TextStyle(fontSize: 13)),
                                ],
                              ),
                              onPressed: () {
                                // contact seller
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showToast(BuildContext context, String msg) {
    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(content: Text(msg), actions: [
        CupertinoDialogAction(
          child: const Text('OK'),
          onPressed: () => Navigator.pop(context),
        ),
      ]),
    );
  }
}
