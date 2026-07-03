import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connectivity_service.g.dart';

/// Streams the device's online/offline status so the UI can show
/// an offline indicator and gate network-dependent actions.
@riverpod
Stream<bool> isOnline(IsOnlineRef ref) {
  final connectivity = Connectivity();
  return connectivity.onConnectivityChanged.map(
    (results) => !results.contains(ConnectivityResult.none),
  );
}
