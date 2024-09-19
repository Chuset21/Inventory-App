import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_app/core/constants/constants.dart';
import 'package:inventory_app/core/providers/providers.dart';
import 'package:inventory_app/core/themes/themes.dart';
import 'package:inventory_app/core/utils/utils.dart';

class AppThemeSelector extends ConsumerWidget {
  const AppThemeSelector({super.key});

  static final themeInfoMap = {
    AppTheme.light: (
      icon: const Icon(Icons.brightness_5),
      themeText: const Text(ThemeText.light),
    ),
    AppTheme.dark: (
      icon: const Icon(Icons.brightness_2),
      themeText: const Text(ThemeText.dark),
    ),
    AppTheme.system: (
      icon: const Icon(Icons.devices),
      themeText: Text(
          '${ThemeText.systemDefault} (${isPlatformDarkMode() ? ThemeText.dark : ThemeText.light})'),
    ),
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appTheme = ref.watch(themeProvider);
    final updateTheme = ref.read(themeProvider.notifier).updateTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: AppTheme.values
          .map((value) => _buildThemeRadioButton(value, appTheme, updateTheme))
          .toList(),
    );
  }

  Row _buildThemeRadioButton(
    AppTheme currentTheme,
    AppTheme selectedTheme,
    Function(AppTheme) updateTheme,
  ) {
    final buttonInfo = AppThemeSelector.themeInfoMap[currentTheme]!;

    return Row(
      children: [
        buttonInfo.icon,
        ThemeSwitcher.withTheme(
          builder: (context, switcher, theme) => Radio<AppTheme>(
            value: currentTheme,
            groupValue: selectedTheme,
            onChanged: (AppTheme? theme) {
              if (theme != null) {
                ThemeSwitcher.of(context).changeTheme(
                  theme: getThemeData(theme),
                );
                updateTheme(theme);
              }
            },
          ),
        ),
        buttonInfo.themeText,
      ],
    );
  }
}
