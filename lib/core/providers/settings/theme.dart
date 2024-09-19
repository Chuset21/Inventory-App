import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_app/core/services/services.dart';
import 'package:inventory_app/core/themes/themes.dart';

class ThemeNotifier extends StateNotifier<AppTheme> {
  ThemeNotifier(super.initialTheme);

  void updateTheme(AppTheme newTheme) {
    state = newTheme;
    LocalStorage.updateAppTheme(newTheme);
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, AppTheme>(
  // Default, fake implementation
  (ref) => ThemeNotifier(AppTheme.system),
);
