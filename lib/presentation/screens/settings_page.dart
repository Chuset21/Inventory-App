import 'package:flutter/material.dart';
import 'package:inventory_app/core/utils/app_theme.dart';
import 'package:inventory_app/presentation/widgets/app_theme_selector.dart';
import 'package:inventory_app/presentation/widgets/safe_delete_selector.dart';

import '../../core/constants/strings.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({
    super.key,
    required this.appTheme,
    required this.onThemeUpdate,
    required this.onSafeDeleteUpdate,
    required this.isSafeDeleteOn,
  });

  final AppTheme appTheme;
  final Function(AppTheme) onThemeUpdate;
  final bool Function() isSafeDeleteOn;
  final Function(bool) onSafeDeleteUpdate;

  @override
  Widget build(BuildContext context) {
    final settings = [
      AppThemeSelector(
        appTheme: appTheme,
        onThemeUpdate: onThemeUpdate,
      ),
      SafeDeleteSelector(
        isSafeDeleteOn: isSafeDeleteOn,
        onSafeDeleteToggle: onSafeDeleteUpdate,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).canvasColor,
        title: const Text(AppTitles.settings),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: ListView(
          children: addDividersBetween(settings),
        ),
      ),
    );
  }

  Widget buildPaddedCenteredSetting(Widget child) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Center(
          child: child,
        ),
      );

  Widget buildDivider() => const Divider(
        indent: 10,
        endIndent: 10,
        thickness: 1,
      );

  List<Widget> addDividersBetween(List<Widget> widgets) => widgets
      .map((widget) => [
            buildPaddedCenteredSetting(widget),
            buildDivider(),
          ])
      .expand((e) => e)
      .toList();
}
