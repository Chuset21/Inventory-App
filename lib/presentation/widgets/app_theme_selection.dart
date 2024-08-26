import 'package:flutter/material.dart';
import 'package:inventory_app/core/constants/strings.dart';

import '../../core/utils/app_theme.dart';

class AppThemeSelection extends StatefulWidget {
  const AppThemeSelection(
      {super.key, required this.appTheme, required this.onThemeUpdate});

  final AppTheme appTheme;
  final Function(AppTheme) onThemeUpdate;

  @override
  State<AppThemeSelection> createState() => _AppThemeSelectionState();
}

class _AppThemeSelectionState extends State<AppThemeSelection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.brightness_5, // Sun icon for light mode
            ),
            Radio<AppTheme>(
              value: AppTheme.light,
              groupValue: widget.appTheme,
              onChanged: (AppTheme? mode) {
                if (mode != null) {
                  widget.onThemeUpdate(mode);
                }
              },
            ),
            const Text(lightThemeText),
          ],
        ),
        Row(
          children: [
            const Icon(
              Icons.brightness_2, // Moon icon for dark mode
            ),
            Radio<AppTheme>(
              value: AppTheme.dark,
              groupValue: widget.appTheme,
              onChanged: (AppTheme? mode) {
                if (mode != null) {
                  widget.onThemeUpdate(mode);
                }
              },
            ),
            const Text(darkThemeText),
          ],
        ),
        Row(
          children: [
            const Icon(
              Icons.devices, // System icon for system default
            ),
            Radio<AppTheme>(
              value: AppTheme.system,
              groupValue: widget.appTheme,
              onChanged: (AppTheme? mode) {
                if (mode != null) {
                  widget.onThemeUpdate(mode);
                }
              },
            ),
            const Text(systemThemeText),
          ],
        ),
      ],
    );
  }
}
