import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:inventory_app/core/constants/constants.dart';
import 'package:inventory_app/core/utils/utils.dart';
import 'package:inventory_app/data/models/models.dart';
import 'package:inventory_app/presentation/widgets/widgets.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, this.errorInfo});

  final ErrorInfo? errorInfo;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isConfigFormVisible = false; // State to track visibility

  @override
  void initState() {
    super.initState();
    // Show the error information the first time it builds
    if (widget.errorInfo != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showErrorSnackBar(context, widget.errorInfo!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const settings = [
      AppThemeSelector(),
      SafeDeleteSelector(),
    ];

    return ThemeSwitchingArea(
      child: Scaffold(
        appBar: const DefaultAppBar(
          title: Text(AppTitles.settings),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: ListView(
            children: [
              ...addDividersBetween(settings),
              // Add other settings
              Padding(
                padding: const EdgeInsets.only(top: 60.0),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.center,
                  child: buildPaddedCenteredSetting(
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isConfigFormVisible = !_isConfigFormVisible;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            DatabaseConfigurationSettings.title,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Icon(
                            _isConfigFormVisible
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              buildDivider(),
              Visibility(
                visible: _isConfigFormVisible,
                child: buildPaddedCenteredSetting(const AppwriteConfigForm()),
              ),
              if (_isConfigFormVisible) buildDivider(),
              // Add divider if form is visible
            ],
          ),
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
