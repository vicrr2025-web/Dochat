import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/providers/mall_provider.dart';
import 'package:dochat_app/pages/services/mall_detail_page.dart';

class MallShopPage extends StatefulWidget {
  final String shopId;

  const MallShopPage({super.key, required this.shopId});

  @override
  State<MallShopPage> createState() => _MallShopPageState();
}

class _MallShopPageState extends State<MallShopPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<MallProvider>().loadShop(widget.shopId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.shopInfo),
      ),
      child: SafeArea(
        child: Consumer<MallProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return const Center(child: CupertinoActivityIndicator());
            }
            final shop = provider.shop;
            return CustomScrollView(
              slivers: [
                if (shop != null)
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      color: CupertinoColors.white,
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF2F2F7),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: shop.logo.isNotEmpty
                                ? ClipOval(
                                    child: Image.network(shop.logo,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            const Icon(CupertinoIcons.bag,
                                                size: 28)),
                                  )
                                : const Icon(CupertinoIcons.bag, size: 28),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(shop.name,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700)),
                                const SizedBox(height: 4),
                                Text(
                                  '${l10n.productName}: ${provider.products.length}',
                                  style: const TextStyle(
                                      fontSize: 13,
                                      color: CupertinoColors.systemGrey),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                SliverPadding(
                  padding: const EdgeInsets.all(12),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.68,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final product = provider.products[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (_) => MallDetailPage(
                                    productId: product.id),
                              ),
                            );
                          },
                          child: Container(
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
                                                    color: CupertinoColors
                                                        .systemGrey3),
                                          )
                                        : const Icon(CupertinoIcons.photo,
                                            size: 40,
                                            color:
                                                CupertinoColors.systemGrey3),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(product.title,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500)),
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
                        );
                      },
                      childCount: provider.products.length,
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
}
