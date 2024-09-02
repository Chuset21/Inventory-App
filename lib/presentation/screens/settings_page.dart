import 'package:flutter/material.dart';
import 'package:inventory_app/core/utils/app_theme.dart';
import 'package:inventory_app/presentation/widgets/app_theme_selector.dart';
import 'package:inventory_app/presentation/widgets/safe_delete_selector.dart';

import '../../core/constants/strings.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage(
      {super.key,
      required this.appTheme,
      required this.onThemeUpdate,
      required this.onSafeDeleteUpdate,
      required this.isSafeDeleteOn});

  final AppTheme appTheme;
  final Function(AppTheme) onThemeUpdate;
  final bool isSafeDeleteOn;
  final Function(bool) onSafeDeleteUpdate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).canvasColor,
        title: const Text(AppTitles.settings),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align to the left
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Center(
                child: AppThemeSelector(
                  appTheme: appTheme,
                  onThemeUpdate: onThemeUpdate,
                ),
              ),
            ),
            const Divider(
              indent: 10,
              endIndent: 10,
              thickness: 1,
            ),
            Flexible(
              flex: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Center(
                  child: SafeDeleteSelector(
                    isSafeDeleteOn: isSafeDeleteOn,
                    onSafeDeleteToggle: onSafeDeleteUpdate,
                  ),
                ),
              ),
            ),
            const Divider(
              indent: 10,
              endIndent: 10,
              thickness: 1,
            ),
          ],
        ),
      ),
    );
  }
}
