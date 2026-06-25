import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/providers/mall_provider.dart';
import 'package:dochat_app/pages/services/mall_detail_page.dart';

class MallFavoritesPage extends StatefulWidget {
  const MallFavoritesPage({super.key});

  @override
  State<MallFavoritesPage> createState() => _MallFavoritesPageState();
}

class _MallFavoritesPageState extends State<MallFavoritesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<MallProvider>().loadFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.myFavorites),
      ),
      child: SafeArea(
        child: Consumer<MallProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return const Center(child: CupertinoActivityIndicator());
            }
            if (provider.favorites.isEmpty) {
              return Center(child: Text(l10n.noProductsHint));
            }
            return GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.68,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: provider.favorites.length,
              itemBuilder: (context, index) {
                final product = provider.favorites[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) =>
                            MallDetailPage(productId: product.id),
                      ),
                    );
                  },
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: CupertinoColors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Color(0xFFF2F2F7),
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(12)),
                                ),
                                child: product.images.isNotEmpty
                                    ? Image.network(
                                        product.images.first,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        errorBuilder: (_, __, ___) =>
                                            const Icon(CupertinoIcons.photo,
                                                size: 40,
                                                color:
                                                    CupertinoColors.systemGrey3),
                                      )
                                    : const Icon(CupertinoIcons.photo,
                                        size: 40,
                                        color: CupertinoColors.systemGrey3),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '¥${product.price.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                        fontSize: 15,
                                        color: Color(0xFFFF3B30),
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 6,
                        right: 6,
                        child: GestureDetector(
                          onTap: () {
                            provider.toggleFavorite(product.id);
                          },
                          child: const Icon(
                            CupertinoIcons.heart_fill,
                            color: CupertinoColors.destructiveRed,
                            size: 22,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
