import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_app/core/services/services.dart';

class SafeDeleteNotifier extends StateNotifier<bool> {
  SafeDeleteNotifier(super.initialState);

  void updateSafeDelete(bool value) {
    state = value;
    LocalStorage.updateIsSafeDeleteOn(value);
  }
}

final safeDeleteProvider = StateNotifierProvider<SafeDeleteNotifier, bool>(
  // Default, fake implementation
  (ref) => SafeDeleteNotifier(true),
);
