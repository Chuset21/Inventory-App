import 'package:flutter/material.dart';
import 'package:inventory_app/core/utils/app_theme.dart';
import 'package:inventory_app/presentation/widgets/app_theme_selector.dart';

import '../../core/constants/strings.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage(
      {super.key, required this.appTheme, required this.onThemeUpdate});

  final AppTheme appTheme;
  final Function(AppTheme) onThemeUpdate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).canvasColor,
        title: const Text(settingsTitle),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align to the left
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 5.0, right: 20.0),
            child: Row(
              children: [
                Center(
                  child: AppThemeSelector(
                    appTheme: appTheme,
                    onThemeUpdate: onThemeUpdate,
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            indent: 10,
            endIndent: 10,
            thickness: 1,
          ),
        ],
      ),
    );
  }
}
