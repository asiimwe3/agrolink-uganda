import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/app_config.dart';

/// Thin wrapper around the Supabase client lifecycle.
/// Call [SupabaseService.initialize] once in main() before runApp.
class SupabaseService {
  SupabaseService._();

  static SupabaseClient get client => Supabase.instance.client;

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: AppConfig.supabaseUrl,
      anonKey: AppConfig.supabaseAnonKey,
      debug: !AppConfig.isProduction,
    );
  }

  static User? get currentUser => client.auth.currentUser;
  static bool get isAuthenticated => currentUser != null;
  static Stream<AuthState> get authStateChanges => client.auth.onAuthStateChange;
}
