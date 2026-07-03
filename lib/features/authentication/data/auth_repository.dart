import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/services/supabase_service.dart';
import '../domain/user_model.dart';

/// Repository Pattern: isolates all Supabase auth calls from the UI layer.
/// Screens depend on this abstraction (via Riverpod providers), never on
/// SupabaseClient directly — this is what "decoupled business logic" means.
class AuthRepository {
  final SupabaseClient _client = SupabaseService.client;

  Future<void> sendOtp(String phoneNumber) async {
    await _client.auth.signInWithOtp(phone: phoneNumber);
  }

  Future<AuthResponse> verifyOtp({
    required String phoneNumber,
    required String otp,
  }) {
    return _client.auth.verifyOTP(
      phone: phoneNumber,
      token: otp,
      type: OtpType.sms,
    );
  }

  Future<AppUser?> fetchProfile(String userId) async {
    final data = await _client
        .from('users')
        .select()
        .eq('id', userId)
        .maybeSingle();
    if (data == null) return null;
    return AppUser.fromJson(data);
  }

  Future<AppUser> createProfile({
    required String userId,
    required String phoneNumber,
    required String fullName,
    required String role,
  }) async {
    final data = await _client
        .from('users')
        .insert({
          'id': userId,
          'phone_number': phoneNumber,
          'full_name': fullName,
          'role': role,
        })
        .select()
        .single();
    return AppUser.fromJson(data);
  }

  Future<AppUser> updateProfile(AppUser user) async {
    final data = await _client
        .from('users')
        .update(user.toJson()..remove('id'))
        .eq('id', user.id)
        .select()
        .single();
    return AppUser.fromJson(data);
  }

  Future<void> signOut() => _client.auth.signOut();
}
