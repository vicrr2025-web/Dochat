import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/providers/home_provider.dart';
import 'package:dochat_app/pages/homes/home_service_detail_page.dart';
import 'package:dochat_app/pages/homes/home_categories_page.dart';
import 'package:dochat_app/pages/homes/home_worker_page.dart';

class HomeHomePage extends StatefulWidget {
  const HomeHomePage({super.key});

  @override
  State<HomeHomePage> createState() => _HomeHomePageState();
}

class _HomeHomePageState extends State<HomeHomePage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<HomeProvider>();
      provider.loadCategories();
      provider.loadServices();
      provider.loadWorkers();
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
        middle: Text(l10n.homeTab),
        trailing: Consumer<HomeProvider>(
          builder: (context, provider, _) {
            return GestureDetector(
              onTap: () {
                provider.toggleRole();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF5AC8FA).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  provider.role == 'user' ? l10n.workerRegister : l10n.homeTab,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF5AC8FA),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      child: SafeArea(
        child: Consumer<HomeProvider>(
          builder: (context, provider, _) {
            if (provider.role == 'worker') {
              return const HomeWorkerPage();
            }

            if (provider.loading && provider.services.isEmpty && provider.categories.isEmpty) {
              return const Center(child: CupertinoActivityIndicator());
            }

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemGrey6,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 12),
                            child: Icon(CupertinoIcons.search, size: 20, color: CupertinoColors.systemGrey),
                          ),
                          Expanded(
                            child: CupertinoTextField(
                              controller: _searchController,
                              placeholder: l10n.homeService,
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                              decoration: const BoxDecoration(
                                color: CupertinoColors.systemGrey6,
                              ),
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: _buildCategoryGrid(l10n, provider),
                ),
                if (provider.workers.isNotEmpty)
                  SliverToBoxAdapter(
                    child: _buildRecommendedWorkers(l10n, provider),
                  ),
                SliverToBoxAdapter(
                  child: _buildServiceList(l10n, provider),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategoryGrid(AppLocalizations l10n, HomeProvider provider) {
    final cats = provider.categories.take(8).toList();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.serviceCategory,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1C1C1E)),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (_) => const HomeCategoriesPage()),
                  );
                },
                child: Text(
                  l10n.allCategories,
                  style: const TextStyle(fontSize: 13, color: Color(0xFF5AC8FA)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 4,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 0.85,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: cats.map((cat) {
              return GestureDetector(
                onTap: () {
                  provider.setCategory(cat.key);
                  provider.loadServices(category: cat.key);
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (_) => const HomeCategoriesPage()),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: CupertinoColors.systemGrey5, width: 0.5),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _iconForCategory(cat.key),
                        size: 28,
                        color: const Color(0xFF5AC8FA),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        cat.name,
                        style: const TextStyle(fontSize: 11, color: Color(0xFF3C3C43)),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedWorkers(AppLocalizations l10n, HomeProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1C1C1E)),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: provider.workers.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final worker = provider.workers[index];
              return GestureDetector(
                onTap: () {},
                child: Container(
                  width: 80,
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: CupertinoColors.systemGrey5, width: 0.5),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipOval(
                        child: Container(
                          width: 44,
                          height: 44,
                          color: const Color(0xFF5AC8FA).withOpacity(0.2),
                          child: const Center(
                            child: Icon(CupertinoIcons.person_fill, size: 24, color: Color(0xFF5AC8FA)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        worker.name,
                        style: const TextStyle(fontSize: 11, color: Color(0xFF1C1C1E)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildServiceList(AppLocalizations l10n, HomeProvider provider) {
    if (provider.services.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Center(
            child: Text(l10n.noServiceHint, style: const TextStyle(color: CupertinoColors.systemGrey)),
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final service = provider.services[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (_) => HomeServiceDetailPage(service: service),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: CupertinoColors.systemBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: CupertinoColors.systemGrey5, width: 0.5),
                ),
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    ClipOval(
                      child: Container(
                        width: 48,
                        height: 48,
                        color: const Color(0xFF5AC8FA).withOpacity(0.15),
                        child: const Center(
                          child: Icon(CupertinoIcons.wrench_fill, size: 24, color: Color(0xFF5AC8FA)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            service.name,
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Color(0xFF1C1C1E)),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${service.category} · ${service.subCategory}',
                            style: const TextStyle(fontSize: 12, color: CupertinoColors.systemGrey),
                          ),
                        ],
                      ),
                    ),
                    if (service.priceType == 'fixed' && service.fixedPrice != null)
                      Text(
                        '¥${service.fixedPrice!.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFFFF3B30),
                        ),
                      ),
                    const SizedBox(width: 4),
                    const Icon(CupertinoIcons.chevron_right, size: 16, color: CupertinoColors.systemGrey3),
                  ],
                ),
              ),
            ),
          );
        },
        childCount: provider.services.length,
      ),
    );
  }

  IconData _iconForCategory(String key) {
    switch (key) {
      case 'cleaning':
        return CupertinoIcons.drop_fill;
      case 'repair':
        return CupertinoIcons.wrench_fill;
      case 'moving':
        return CupertinoIcons.cube_box_fill;
      case 'tutoring':
        return CupertinoIcons.book_fill;
      case 'care':
        return CupertinoIcons.heart_fill;
      case 'cooking':
        return CupertinoIcons.flame_fill;
      case 'beauty':
        return CupertinoIcons.star_fill;
      case 'pet':
        return CupertinoIcons.ant_fill;
      default:
        return CupertinoIcons.square_grid_2x2_fill;
    }
  }
}
