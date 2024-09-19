import 'package:flutter/material.dart';
import 'package:inventory_app/core/constants/constants.dart';
import 'package:inventory_app/core/utils/utils.dart';
import 'package:inventory_app/presentation/widgets/widgets.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({
    super.key,
    required this.getAppTheme,
    required this.onThemeUpdate,
    required this.onSafeDeleteUpdate,
    required this.isSafeDeleteOn,
  });

  final AppTheme Function() getAppTheme;
  final Function(AppTheme) onThemeUpdate;
  final bool Function() isSafeDeleteOn;
  final Function(bool) onSafeDeleteUpdate;

  @override
  Widget build(BuildContext context) {
    final settings = [
      AppThemeSelector(
        getAppTheme: getAppTheme,
        onThemeUpdate: onThemeUpdate,
      ),
      SafeDeleteSelector(
        isSafeDeleteOn: isSafeDeleteOn,
        onSafeDeleteToggle: onSafeDeleteUpdate,
      ),
    ];

    return Scaffold(
      appBar: const DefaultAppBar(
        title: Text(AppTitles.settings),
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
