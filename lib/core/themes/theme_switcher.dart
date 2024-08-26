import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:inventory_app/core/constants/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_themes.dart';

/// Theme switcher to learn about theme switching,
/// something similar will later be moved to a settings page*/
class ThemeSwitcher extends StatefulWidget {
  const ThemeSwitcher({super.key});

  @override
  State<ThemeSwitcher> createState() => _ThemeSwitcherState();
}

class _ThemeSwitcherState extends State<ThemeSwitcher> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _initializeTheme();
  }

  void _initializeTheme() async {
    bool? isDarkModePreferred = await _isDarkModePreferred();
    setState(() {
      // Prioritise app settings if present, otherwise use platform settings
      _isDarkMode = isDarkModePreferred ?? _isPlatformDarkMode();
    });
  }

  bool _isPlatformDarkMode() {
    Brightness brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
    return brightness == Brightness.dark;
  }

  Future<bool?> _isDarkModePreferred() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isDarkModeKey);
  }

  void _updateIsDarkMode(bool value) {
    setState(() {
      _isDarkMode = value;
      // Load and set the shared preferences for this app.
      SharedPreferences.getInstance()
          .then((pref) => pref.setBool(isDarkModeKey, _isDarkMode));
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkMode ? darkTheme : lightTheme,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Theme Switcher'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Toggle the switch to change the theme:',
              ),
              Switch(
                value: _isDarkMode,
                onChanged: (value) {
                  _updateIsDarkMode(value);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
