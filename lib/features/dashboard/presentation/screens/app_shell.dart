import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

/// Shared scaffold + bottom navigation for the 5 main tabs:
/// Home, Marketplace, SACCO, Weather, Profile.
class AppShell extends StatelessWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  static const _tabs = ['/home', '/marketplace', '/sacco', '/weather', '/profile'];

  int _indexForLocation(String location) {
    final index = _tabs.indexWhere((t) => location.startsWith(t));
    return index == -1 ? 0 : index;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final currentIndex = _indexForLocation(location);

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (i) => context.go(_tabs[i]),
        selectedItemColor: AppColors.primaryGreen,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.storefront_rounded), label: 'Marketplace'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_rounded), label: 'SACCO'),
          BottomNavigationBarItem(icon: Icon(Icons.wb_sunny_rounded), label: 'Weather'),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
        ],
      ),
    );
  }
}
