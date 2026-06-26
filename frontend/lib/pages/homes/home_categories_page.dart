import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/models/home_models.dart';
import 'package:dochat_app/providers/home_provider.dart';
import 'package:dochat_app/pages/homes/home_service_detail_page.dart';

class HomeCategoriesPage extends StatefulWidget {
  const HomeCategoriesPage({super.key});

  @override
  State<HomeCategoriesPage> createState() => _HomeCategoriesPageState();
}

class _HomeCategoriesPageState extends State<HomeCategoriesPage> {
  HomeCategory? _selectedL1;
  HomeCategory? _selectedL2;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.serviceCategory),
        leading: GestureDetector(
          onTap: () {
            if (_selectedL2 != null) {
              setState(() => _selectedL2 = null);
            } else if (_selectedL1 != null) {
              setState(() => _selectedL1 = null);
            } else {
              Navigator.pop(context);
            }
          },
          child: const Icon(CupertinoIcons.back),
        ),
      ),
      child: SafeArea(
        child: Consumer<HomeProvider>(
          builder: (context, provider, _) {
            if (provider.categories.isEmpty) {
              return const Center(child: CupertinoActivityIndicator());
            }

            final l1Cats = provider.categories;
            final l2Cats = _selectedL1?.children ?? [];

            if (_selectedL1 == null) {
              return _buildLevelList(
                items: l1Cats,
                onTap: (cat) {
                  setState(() => _selectedL1 = cat);
                  provider.loadServices(category: cat.key);
                },
              );
            }

            if (_selectedL2 == null && l2Cats.isNotEmpty) {
              return _buildLevelList(
                title: _selectedL1!.name,
                items: l2Cats,
                onTap: (cat) {
                  setState(() => _selectedL2 = cat);
                  provider.loadServices(category: _selectedL1!.key, subCategory: cat.key);
                },
              );
            }

            return _buildServiceList(l10n, provider);
          },
        ),
      ),
    );
  }

  Widget _buildLevelList({
    String? title,
    required List<HomeCategory> items,
    required void Function(HomeCategory) onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF1C1C1E))),
          ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final cat = items[index];
              return GestureDetector(
                onTap: () => onTap(cat),
                child: Container(
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: CupertinoColors.systemGrey5, width: 0.5),
                  ),
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(cat.name, style: const TextStyle(fontSize: 15, color: Color(0xFF1C1C1E))),
                      ),
                      if (cat.children.isNotEmpty)
                        const Icon(CupertinoIcons.chevron_right, size: 16, color: CupertinoColors.systemGrey3),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _selectedL2?.name ?? _selectedL1?.name ?? '',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF1C1C1E)),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: provider.services.isEmpty
              ? Center(
                  child: Text(l10n.noServiceHint, style: const TextStyle(color: CupertinoColors.systemGrey)),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: provider.services.length,
                  itemBuilder: (context, index) {
                    final service = provider.services[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
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
                                  width: 44,
                                  height: 44,
                                  color: const Color(0xFF5AC8FA).withOpacity(0.15),
                                  child: const Center(
                                    child: Icon(CupertinoIcons.wrench_fill, size: 22, color: Color(0xFF5AC8FA)),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  service.name,
                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Color(0xFF1C1C1E)),
                                ),
                              ),
                              if (service.fixedPrice != null)
                                Text(
                                  '¥${service.fixedPrice!.toStringAsFixed(0)}',
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFFFF3B30)),
                                ),
                              const SizedBox(width: 4),
                              const Icon(CupertinoIcons.chevron_right, size: 16, color: CupertinoColors.systemGrey3),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
