import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/services/supabase_service.dart';
import '../features/authentication/presentation/screens/welcome_screen.dart';
import '../features/authentication/presentation/screens/role_select_screen.dart';
import '../features/authentication/presentation/screens/register_screen.dart';
import '../features/authentication/presentation/screens/otp_verify_screen.dart';
import '../features/authentication/presentation/screens/profile_setup_screen.dart';
import '../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../features/dashboard/presentation/screens/app_shell.dart';
import '../features/gps/presentation/screens/measure_land_screen.dart';
import '../features/weather/presentation/screens/weather_screen.dart';
import '../features/marketplace/presentation/screens/marketplace_screen.dart';
import '../features/sacco/presentation/screens/sacco_dashboard_screen.dart';
import '../features/profile/presentation/screens/profile_screen.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(AppRouterRef ref) {
  return GoRouter(
    initialLocation: '/welcome',
    redirect: (context, state) {
      final loggedIn = SupabaseService.isAuthenticated;
      final isAuthRoute = state.matchedLocation.startsWith('/welcome') ||
          state.matchedLocation.startsWith('/select-role') ||
          state.matchedLocation.startsWith('/register') ||
          state.matchedLocation.startsWith('/verify-otp') ||
          state.matchedLocation.startsWith('/profile-setup');

      if (!loggedIn && !isAuthRoute) return '/welcome';
      if (loggedIn && isAuthRoute) return '/home';
      return null;
    },
    routes: [
      GoRoute(path: '/welcome', builder: (_, __) => const WelcomeScreen()),
      GoRoute(path: '/select-role', builder: (_, __) => const RoleSelectScreen()),
      GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),
      GoRoute(path: '/verify-otp', builder: (_, __) => const OtpVerifyScreen()),
      GoRoute(path: '/profile-setup', builder: (_, __) => const ProfileSetupScreen()),

      // Shell route with bottom navigation: Home / Marketplace / SACCO / Weather / Profile
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(path: '/home', builder: (_, __) => const DashboardScreen()),
          GoRoute(path: '/marketplace', builder: (_, __) => const MarketplaceScreen()),
          GoRoute(path: '/sacco', builder: (_, __) => const SaccoDashboardScreen()),
          GoRoute(path: '/weather', builder: (_, __) => const WeatherScreen()),
          GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
        ],
      ),

      GoRoute(path: '/measure-land', builder: (_, __) => const MeasureLandScreen()),
    ],
  );
}
