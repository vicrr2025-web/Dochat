import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/models/mall_models.dart';
import 'package:dochat_app/providers/mall_provider.dart';

class MallCartPage extends StatefulWidget {
  const MallCartPage({super.key});

  @override
  State<MallCartPage> createState() => _MallCartPageState();
}

class _MallCartPageState extends State<MallCartPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<MallProvider>().loadCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.myCart),
      ),
      child: SafeArea(
        child: Consumer<MallProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return const Center(child: CupertinoActivityIndicator());
            }
            if (provider.cart.isEmpty) {
              return Center(child: Text(l10n.cartEmpty));
            }
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: provider.cart.length,
                    itemBuilder: (context, index) {
                      final item = provider.cart[index];
                      return Dismissible(
                        key: Key(item.id),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) {
                          provider.removeCartItem(item.id);
                        },
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding:
                              const EdgeInsets.only(right: 20),
                          color: CupertinoColors.destructiveRed,
                          child: const Icon(CupertinoIcons.delete,
                              color: CupertinoColors.white),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: CupertinoColors.white,
                            borderRadius:
                                BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () => provider
                                    .toggleCartItemSelection(
                                        index),
                                child: Icon(
                                  item.selected
                                      ? CupertinoIcons
                                          .checkmark_circle_fill
                                      : CupertinoIcons.circle,
                                  color: item.selected
                                      ? CupertinoColors.systemBlue
                                      : CupertinoColors
                                          .systemGrey4,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFFF2F2F7),
                                  borderRadius:
                                      BorderRadius.circular(8),
                                ),
                                child: item.image.isNotEmpty
                                    ? Image.network(
                                        item.image,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (_, __, ___) =>
                                                const Icon(
                                                    CupertinoIcons.photo,
                                                    size: 24),
                                      )
                                    : const Icon(
                                        CupertinoIcons.photo,
                                        size: 24),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                  children: [
                                    Text(item.title,
                                        maxLines: 1,
                                        overflow:
                                            TextOverflow
                                                .ellipsis,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight:
                                                FontWeight
                                                    .w500)),
                                    const SizedBox(height: 4),
                                    Text(
                                      '¥${item.price.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                          fontSize: 15,
                                          color:
                                              Color(0xFFFF3B30),
                                          fontWeight:
                                              FontWeight
                                                  .w600),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: item.qty > 1
                                        ? () => provider
                                            .updateCartItemQty(
                                                item.id,
                                                item.qty - 1)
                                        : null,
                                    child: Container(
                                      width: 28,
                                      height: 28,
                                      decoration:
                                          const BoxDecoration(
                                        shape:
                                            BoxShape.circle,
                                        color: Color(
                                            0xFFF2F2F7),
                                      ),
                                      child:
                                          const Icon(
                                        CupertinoIcons.minus,
                                        size: 14,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets
                                            .symmetric(
                                            horizontal: 8),
                                    child: Text(
                                        '${item.qty}',
                                        style: const TextStyle(
                                            fontSize: 15)),
                                  ),
                                  GestureDetector(
                                    onTap: () => provider
                                        .updateCartItemQty(
                                            item.id,
                                            item.qty + 1),
                                    child: Container(
                                      width: 28,
                                      height: 28,
                                      decoration:
                                          const BoxDecoration(
                                        shape:
                                            BoxShape.circle,
                                        color: Color(
                                            0xFFF2F2F7),
                                      ),
                                      child:
                                          const Icon(
                                        CupertinoIcons.plus,
                                        size: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: CupertinoColors.white,
                    border: Border(
                      top: BorderSide(
                          color: CupertinoColors.systemGrey5,
                          width: 0.5),
                    ),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => provider.toggleSelectAll(),
                        child: Row(
                          children: [
                            Icon(
                              provider.cartAllSelected
                                  ? CupertinoIcons
                                      .checkmark_circle_fill
                                  : CupertinoIcons.circle,
                              color:
                                  provider.cartAllSelected
                                      ? CupertinoColors
                                          .systemBlue
                                      : CupertinoColors
                                          .systemGrey4,
                              size: 22,
                            ),
                            const SizedBox(width: 6),
                            Text(l10n.selectAll,
                                style: const TextStyle(
                                    fontSize: 14)),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${l10n.totalAmount}: ¥${provider.cartTotal.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontSize: 13,
                                color: CupertinoColors
                                    .systemGrey),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '¥${provider.cartTotal.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontSize: 18,
                                color: Color(0xFFFF3B30),
                                fontWeight:
                                    FontWeight.w700),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      CupertinoButton(
                        color: const Color(0xFFFF3B30),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Text(l10n.checkout,
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600)),
                        onPressed: () async {
                          final requests = provider.cart
                              .where((e) => e.selected)
                              .map((e) => CreateOrderRequest(
                                    productId: e.productId,
                                    qty: e.qty,
                                  ))
                              .toList();
                          if (requests.isEmpty) return;
                          final orders = await provider
                              .createOrders(requests);
                          if (orders.isNotEmpty &&
                              context.mounted) {
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ],
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
