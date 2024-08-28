import 'package:flutter/material.dart';
import 'package:inventory_app/core/constants/strings.dart';

import '../../core/utils/app_theme.dart';

class AppThemeSelector extends StatelessWidget {
  const AppThemeSelector(
      {super.key, required this.appTheme, required this.onThemeUpdate});

  final AppTheme appTheme;
  final Function(AppTheme) onThemeUpdate;

  static final themeInfoMap = {
    AppTheme.light: _RadioButtonInfo(
      const Icon(Icons.brightness_5),
      const Text(ThemeText.light),
    ),
    AppTheme.dark: _RadioButtonInfo(
      const Icon(Icons.brightness_2),
      const Text(ThemeText.dark),
    ),
    AppTheme.system: _RadioButtonInfo(
      const Icon(Icons.devices),
      const Text(ThemeText.systemDefault),
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
    final _RadioButtonInfo buttonInfo =
        AppThemeSelector.themeInfoMap[currentTheme]!;

    return Row(
      children: [
        buttonInfo.icon,
        Radio<AppTheme>(
          value: currentTheme,
          groupValue: appTheme,
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

class _RadioButtonInfo {
  final Icon icon;
  final Text themeText;

  _RadioButtonInfo(this.icon, this.themeText);
}
