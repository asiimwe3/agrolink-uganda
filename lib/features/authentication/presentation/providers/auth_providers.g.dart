// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authRepositoryHash() => r'827d48289fca9ff7300a551270d89129c3b7693f';

/// See also [authRepository].
@ProviderFor(authRepository)
final authRepositoryProvider = AutoDisposeProvider<AuthRepository>.internal(
  authRepository,
  name: r'authRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AuthRepositoryRef = AutoDisposeProviderRef<AuthRepository>;
String _$pendingRegistrationHash() =>
    r'351a1a64388cc693e51bc88a958045cd23863c58';

/// Holds the in-progress registration state across the multi-step
/// Register -> OTP -> Profile Setup flow (before the account fully exists).
///
/// Copied from [PendingRegistration].
@ProviderFor(PendingRegistration)
final pendingRegistrationProvider = AutoDisposeNotifierProvider<
    PendingRegistration,
    ({String? phone, String? fullName, String? role})>.internal(
  PendingRegistration.new,
  name: r'pendingRegistrationProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$pendingRegistrationHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PendingRegistration
    = AutoDisposeNotifier<({String? phone, String? fullName, String? role})>;
String _$currentUserProfileHash() =>
    r'3e81da6464ee0526e2462409dee759d97d0b0f25';

/// Lazily-loaded profile for the currently authenticated user.
/// Call [loadFor] once the auth user id is known (e.g. right after login).
///
/// Copied from [CurrentUserProfile].
@ProviderFor(CurrentUserProfile)
final currentUserProfileProvider = AutoDisposeNotifierProvider<
    CurrentUserProfile, AsyncValue<AppUser?>>.internal(
  CurrentUserProfile.new,
  name: r'currentUserProfileProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentUserProfileHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrentUserProfile = AutoDisposeNotifier<AsyncValue<AppUser?>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
