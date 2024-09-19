import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_app/core/services/services.dart';
import 'package:inventory_app/core/themes/themes.dart';

class ThemeNotifier extends StateNotifier<AppTheme> {
  ThemeNotifier() : super(AppTheme.system) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    state = await LocalStorage.getAppTheme();
  }

  void updateTheme(AppTheme newTheme) {
    state = newTheme;
    LocalStorage.updateAppTheme(newTheme);
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, AppTheme>((ref) {
  return ThemeNotifier();
});
