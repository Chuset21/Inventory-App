import 'package:flutter/material.dart';
import 'package:inventory_app/presentation/screens/home_page.dart';

import 'core/themes/app_themes.dart';
import 'core/services/local_storage.dart';
import 'core/utils/platform_utils.dart';

void main() async {
  runApp(MyApp(
    startInDarkMode: await LocalStorage.isDarkMode(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.startInDarkMode});

  final bool? startInDarkMode;

  @override
  State<MyApp> createState() => _MyApp();
}

/// This widget essentially keeps track of the theme
class _MyApp extends State<MyApp> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      // Prioritise app settings if present, otherwise use platform settings
      _isDarkMode = widget.startInDarkMode ?? isPlatformDarkMode();
    });
  }

  void _updateIsDarkMode(bool value) {
    setState(() {
      _isDarkMode = value;
      // Update in local storage
      LocalStorage.updateDarkMode(_isDarkMode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Freezer Inventory Demo',
      theme: _isDarkMode ? darkTheme : lightTheme,
      debugShowCheckedModeBanner: false,
      home: HomePage(
          title: 'Freezer Inventory Demo',
          isDarkMode: _isDarkMode,
          onDarkModeUpdate: _updateIsDarkMode),
    );
  }
}
