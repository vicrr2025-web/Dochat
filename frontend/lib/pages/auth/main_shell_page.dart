import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:dochat_app/l10n/app_localizations.dart';
import 'package:dochat_app/providers/service_hub_provider.dart';
import 'package:dochat_app/pages/auth/home_page.dart';
import 'package:dochat_app/pages/square/square_page.dart';
import 'package:dochat_app/pages/services/service_hub_page.dart';
import 'package:dochat_app/pages/settings/settings_page.dart';

class MainShellPage extends StatefulWidget {
  const MainShellPage({super.key});

  @override
  State<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends State<MainShellPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ServiceHubProvider>().loadBadges();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        activeColor: CupertinoColors.systemBlue,
        inactiveColor: CupertinoColors.systemGrey,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.chat_bubble_text),
            activeIcon: const Icon(CupertinoIcons.chat_bubble_text_fill),
            label: l10n.chats,
          ),
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.person_2),
            activeIcon: const Icon(CupertinoIcons.person_2_fill),
            label: l10n.friends,
          ),
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.rectangle_grid_1x2),
            activeIcon: const Icon(CupertinoIcons.rectangle_grid_1x2_fill),
            label: l10n.square,
          ),
          BottomNavigationBarItem(
            icon: Consumer<ServiceHubProvider>(
              builder: (context, provider, _) {
                final count = provider.totalBadgeCount;
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(CupertinoIcons.cube_box),
                    if (count > 0)
                      Positioned(
                        right: -8,
                        top: -4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 1,
                          ),
                          decoration: const BoxDecoration(
                            color: CupertinoColors.destructiveRed,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            count > 99 ? '99+' : '$count',
                            style: const TextStyle(
                              color: CupertinoColors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            activeIcon: Consumer<ServiceHubProvider>(
              builder: (context, provider, _) {
                final count = provider.totalBadgeCount;
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(CupertinoIcons.cube_box_fill),
                    if (count > 0)
                      Positioned(
                        right: -8,
                        top: -4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 1,
                          ),
                          decoration: const BoxDecoration(
                            color: CupertinoColors.destructiveRed,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            count > 99 ? '99+' : '$count',
                            style: const TextStyle(
                              color: CupertinoColors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            label: l10n.services,
          ),
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.gear),
            activeIcon: const Icon(CupertinoIcons.gear_alt_fill),
            label: l10n.settings,
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return const HomePage();
          case 1:
            return const HomePage();
          case 2:
            return const SquarePage();
          case 3:
            return const ServiceHubPage();
          case 4:
            return const SettingsPage();
          default:
            return const HomePage();
        }
      },
    );
  }
}
