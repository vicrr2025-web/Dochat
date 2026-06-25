import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/providers/mall_provider.dart';
import 'package:dochat_app/pages/services/mall_detail_page.dart';
import 'package:dochat_app/pages/services/mall_publish_page.dart';

class MallListPage extends StatefulWidget {
  const MallListPage({super.key});

  @override
  State<MallListPage> createState() => _MallListPageState();
}

class _MallListPageState extends State<MallListPage> {
  int _selectedTab = 0;
  final _searchController = TextEditingController();

  String? _categoryFromTab(int tab) {
    switch (tab) {
      case 0: return 'farm';
      case 1: return 'factory';
      case 2: return 'idle';
      default: return null;
    }
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<MallProvider>().loadProducts(category: _categoryFromTab(0));
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.mallTab),
        trailing: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (_) => const MallPublishPage(),
              ),
            );
          },
          child: const Icon(CupertinoIcons.add_circled),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              child: CupertinoSlidingSegmentedControl<int>(
                groupValue: _selectedTab,
                onValueChanged: (v) {
                  if (v != null) {
                    setState(() => _selectedTab = v);
                    context
                        .read<MallProvider>()
                        .loadProducts(category: _categoryFromTab(v));
                  }
                },
                children: {
                  0: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text(l10n.farmProducts),
                  ),
                  1: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text(l10n.factoryDirect),
                  ),
                  2: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text(l10n.idleItems),
                  ),
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: CupertinoSearchTextField(
                controller: _searchController,
                placeholder: l10n.search,
              ),
            ),
            Expanded(
              child: Consumer<MallProvider>(
                builder: (context, provider, _) {
                  if (provider.isLoading) {
                    return const Center(child: CupertinoActivityIndicator());
                  }
                  if (provider.products.isEmpty) {
                    return Center(child: Text(l10n.noProductsHint));
                  }
                  return GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.68,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: provider.products.length,
                    itemBuilder: (context, index) {
                      final product = provider.products[index];
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
                                              const Icon(
                                                  CupertinoIcons.photo,
                                                  size: 40,
                                                  color: CupertinoColors
                                                      .systemGrey3),
                                        )
                                      : const Icon(CupertinoIcons.photo,
                                          size: 40,
                                          color: CupertinoColors.systemGrey3),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
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
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
