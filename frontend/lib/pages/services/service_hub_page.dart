import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/models/service_models.dart';
import 'package:dochat_app/providers/service_hub_provider.dart';
import 'package:dochat_app/pages/services/ecosystem_placeholder_page.dart';
import 'package:dochat_app/pages/services/guarantee_list_page.dart';
import 'package:dochat_app/pages/services/mall_list_page.dart';
import 'package:dochat_app/pages/dating/dating_profile_page.dart';
import 'package:dochat_app/pages/houses/house_home_page.dart';

String _ecosystemName(String key, AppLocalizations l10n) {
  switch (key) {
    case 'guarantee': return l10n.guarantee;
    case 'mall': return l10n.mall;
    case 'dating': return l10n.dating;
    case 'housing': return l10n.housing;
    case 'recruit': return l10n.recruit;
    case 'emailService': return l10n.emailService;
    case 'shipping': return l10n.shipping;
    case 'homeService': return l10n.homeService;
    default: return key;
  }
}

IconData _iconForKey(String key) {
  switch (key) {
    case 'guarantee':
      return CupertinoIcons.shield_lefthalf_fill;
    case 'mall':
      return CupertinoIcons.cart_fill;
    case 'dating':
      return CupertinoIcons.heart_fill;
    case 'housing':
      return CupertinoIcons.house_fill;
    case 'recruit':
      return CupertinoIcons.briefcase_fill;
    case 'emailService':
      return CupertinoIcons.mail_solid;
    case 'shipping':
      return CupertinoIcons.cube_box_fill;
    case 'homeService':
      return CupertinoIcons.wrench_fill;
    default:
      return CupertinoIcons.question_circle_fill;
  }
}

class ServiceHubPage extends StatefulWidget {
  const ServiceHubPage({super.key});

  @override
  State<ServiceHubPage> createState() => _ServiceHubPageState();
}

class _ServiceHubPageState extends State<ServiceHubPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ServiceHubProvider>();
      provider.loadBadges();
      provider.loadRecent();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.serviceHub),
      ),
      child: SafeArea(
        child: Consumer<ServiceHubProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading && provider.badges.isEmpty) {
              return const Center(child: CupertinoActivityIndicator());
            }

            final recent = provider.localRecent;
            final badges = provider.badges;

            return CustomScrollView(
              slivers: [
                CupertinoSliverRefreshControl(
                  onRefresh: () async {
                    await Future.wait([
                      provider.loadBadges(),
                      provider.loadRecent(),
                    ]);
                  },
                ),
                if (recent.isNotEmpty)
                  SliverToBoxAdapter(
                    child: _buildRecentSection(l10n, recent, badges),
                  ),
                if (recent.isNotEmpty)
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 8),
                  ),
                SliverToBoxAdapter(
                  child: _buildEcosystemGrid(l10n, provider),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildRecentSection(
    AppLocalizations l10n,
    List<RecentService> recent,
    List<EcosystemBadge> badges,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Text(
            l10n.recentlyUsed,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1C1C1E),
            ),
          ),
        ),
        SizedBox(
          height: 72,
          child: recent.isEmpty
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  l10n.noRecent,
                  style: const TextStyle(fontSize: 13, color: CupertinoColors.systemGrey),
                ),
              )
            : ListView.separated(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: recent.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final r = recent[index];
              return GestureDetector(
                onTap: () {
                  final badge = _badgeForKey(r.ecosystemKey, badges);
                  context.read<ServiceHubProvider>().addToRecent(badge);
                  if (r.ecosystemKey == 'guarantee' || r.ecosystemKey == 'mall' || r.ecosystemKey == 'dating') {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => r.ecosystemKey == 'guarantee' ? const GuaranteeListPage() : r.ecosystemKey == 'mall' ? const MallListPage() : const DatingProfilePage(),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => EcosystemPlaceholderPage(
                          ecosystemName: r.ecosystemName,
                          ecosystemKey: r.ecosystemKey,
                        ),
                      ),
                    );
                  }
                },
                child: SizedBox(
                  width: 60,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _iconForKey(r.ecosystemKey),
                        size: 28,
                        color: CupertinoColors.systemBlue,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        r.ecosystemName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF3C3C43),
                        ),
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

  Widget _buildEcosystemGrid(AppLocalizations l10n, ServiceHubProvider provider) {
    final badges = provider.badges;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.1,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(badges.length, (index) {
          final badge = badges[index];
          return GestureDetector(
            onTap: () {
              provider.addToRecent(badge);
              if (badge.ecosystemKey == 'guarantee' || badge.ecosystemKey == 'mall' || badge.ecosystemKey == 'dating' || badge.ecosystemKey == 'housing') {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (_) {
                    if (badge.ecosystemKey == 'guarantee') return const GuaranteeListPage();
                    if (badge.ecosystemKey == 'mall') return const MallListPage();
                    if (badge.ecosystemKey == 'dating') return const DatingProfilePage();
                    return const HouseHomePage();
                  },
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (_) => EcosystemPlaceholderPage(
                      ecosystemName: _ecosystemName(badge.ecosystemKey, l10n),
                      ecosystemKey: badge.ecosystemKey,
                    ),
                  ),
                );
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: CupertinoColors.systemBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: CupertinoColors.systemGrey5,
                  width: 0.5,
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _iconForKey(badge.ecosystemKey),
                          size: 64,
                          color: CupertinoColors.systemBlue,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _ecosystemName(badge.ecosystemKey, l10n),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1C1C1E),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (badge.badgeCount > 0)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: const BoxDecoration(
                          color: CupertinoColors.destructiveRed,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${badge.badgeCount}',
                          style: const TextStyle(
                            color: CupertinoColors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  EcosystemBadge _badgeForKey(String key, List<EcosystemBadge> badges) {
    final found = badges.where((b) => b.ecosystemKey == key).toList();
    if (found.isNotEmpty) return found.first;
    return EcosystemBadge(
      ecosystemKey: key,
      ecosystemName: key,
      iconName: key,
    );
  }
}
