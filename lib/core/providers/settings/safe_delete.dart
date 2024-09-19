import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_app/core/services/services.dart';

class SafeDeleteNotifier extends StateNotifier<bool> {
  SafeDeleteNotifier() : super(true) {
    _loadSafeDelete();
  }

  Future<void> _loadSafeDelete() async {
    state = await LocalStorage.isSafeDeleteOn();
  }

  void updateSafeDelete(bool value) {
    state = value;
    LocalStorage.updateIsSafeDeleteOn(value);
  }
}

final safeDeleteProvider = StateNotifierProvider<SafeDeleteNotifier, bool>((ref) {
  return SafeDeleteNotifier();
});
