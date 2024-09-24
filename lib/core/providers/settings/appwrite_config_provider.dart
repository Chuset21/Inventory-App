import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_app/data/models/models.dart';

class AppwriteConfigNotifier extends StateNotifier<AppwriteConfig> {
  AppwriteConfigNotifier(super.initialState);

  void updateConfig(AppwriteConfig value) {
    state = value;
    // TODO: local storage
  }
}

final appwriteConfigProvider =
    StateNotifierProvider<AppwriteConfigNotifier, AppwriteConfig>(
  (ref) => AppwriteConfigNotifier(
    const AppwriteConfig(
        endpoint: '', projectId: '', databaseId: '', collectionId: ''),
  ),
);
