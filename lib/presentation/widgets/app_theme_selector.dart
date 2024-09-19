import 'package:flutter/material.dart';
import 'package:inventory_app/core/constants/constants.dart';
import 'package:inventory_app/core/utils/utils.dart';

class AppThemeSelector extends StatelessWidget {
  const AppThemeSelector(
      {super.key, required this.getAppTheme, required this.onThemeUpdate});

  final AppTheme Function() getAppTheme;
  final Function(AppTheme) onThemeUpdate;

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
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: AppTheme.values
          .map((value) => _buildThemeRadioButton(value))
          .toList(),
    );
  }

  Row _buildThemeRadioButton(AppTheme currentTheme) {
    final buttonInfo = AppThemeSelector.themeInfoMap[currentTheme]!;

    return Row(
      children: [
        buttonInfo.icon,
        Radio<AppTheme>(
          value: currentTheme,
          groupValue: getAppTheme(),
          onChanged: (AppTheme? mode) {
            if (mode != null) {
              onThemeUpdate(mode);
            }
          },
        ),
        buttonInfo.themeText,
      ],
    );
  }
}
