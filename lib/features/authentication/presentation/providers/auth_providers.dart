import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/auth_repository.dart';
import '../../domain/user_model.dart';

part 'auth_providers.g.dart';

@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) => AuthRepository();

/// Holds the in-progress registration state across the multi-step
/// Register -> OTP -> Profile Setup flow (before the account fully exists).
@riverpod
class PendingRegistration extends _$PendingRegistration {
  @override
  ({String? phone, String? fullName, String? role}) build() =>
      (phone: null, fullName: null, role: null);

  void setRole(String role) =>
      state = (phone: state.phone, fullName: state.fullName, role: role);
  void setDetails({required String phone, required String fullName}) =>
      state = (phone: phone, fullName: fullName, role: state.role);
}

/// Lazily-loaded profile for the currently authenticated user.
/// Call [loadFor] once the auth user id is known (e.g. right after login).
@riverpod
class CurrentUserProfile extends _$CurrentUserProfile {
  @override
  AsyncValue<AppUser?> build() => const AsyncData(null);

  Future<void> loadFor(String userId) async {
    state = const AsyncLoading();
    final repo = ref.read(authRepositoryProvider);
    state = await AsyncValue.guard(() => repo.fetchProfile(userId));
  }

  Future<void> save(AppUser user) async {
    final repo = ref.read(authRepositoryProvider);
    state = await AsyncValue.guard(() => repo.updateProfile(user));
  }
}
