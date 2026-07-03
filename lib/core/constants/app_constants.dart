/// Static, app-wide constants (route names, storage keys, enum-like strings).
class AppConstants {
  AppConstants._();

  // Hive / local storage boxes
  static const String hiveUserBox = 'user_box';
  static const String hiveFarmsBox = 'farms_box';
  static const String hiveCacheBox = 'cache_box';
  static const String prefLanguage = 'pref_language';
  static const String prefDarkMode = 'pref_dark_mode';
  static const String prefOnboarded = 'pref_onboarded';

  // User roles (mirrors Supabase `user_role` enum)
  static const String roleFarmer = 'farmer';
  static const String roleSaccoAdmin = 'sacco_admin';
  static const String roleVendor = 'vendor';
  static const String roleBuyer = 'buyer';
  static const String roleExtensionOfficer = 'extension_officer';

  static const List<String> allRoles = [
    roleFarmer,
    roleSaccoAdmin,
    roleVendor,
    roleBuyer,
    roleExtensionOfficer,
  ];

  // Cache durations
  static const Duration weatherCacheDuration = Duration(hours: 3);
  static const Duration productsCacheDuration = Duration(minutes: 15);
}
