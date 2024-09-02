import 'package:flutter/material.dart';
import 'package:inventory_app/core/utils/app_theme.dart';
import 'package:inventory_app/presentation/screens/home_page.dart';

import 'core/services/local_storage.dart';

void main() async {
  runApp(MyApp(
    appTheme: await LocalStorage.getAppTheme(),
    isSafeDeleteOn: false, // TODO: make it come from a setting
  ));
}

class MyApp extends StatefulWidget {
  const MyApp(
      {super.key, required this.appTheme, required this.isSafeDeleteOn});

  final AppTheme appTheme;
  final bool isSafeDeleteOn;

  @override
  State<MyApp> createState() => _MyApp();
}

/// This widget essentially keeps track of the theme
class _MyApp extends State<MyApp> {
  AppTheme _appTheme = AppTheme.system;
  late bool _isSafeDeleteOn;

  @override
  void initState() {
    super.initState();
    _appTheme = widget.appTheme;
    _isSafeDeleteOn = widget.isSafeDeleteOn;
  }

  void _updateTheme(AppTheme theme) {
    setState(() {
      _appTheme = theme;
      // Update in local storage
      LocalStorage.updateAppTheme(_appTheme);
    });
  }

  void _setSafeDelete(bool isSafeDeleteOn) {
    setState(() {
      _isSafeDeleteOn = isSafeDeleteOn;
      // TODO: Update in local storage
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Freezer Inventory Demo',
      theme: getThemeData(_appTheme),
      debugShowCheckedModeBanner: false,
      home: HomePage(
          title: 'Freezer Inventory Demo',
          isSafeDeleteOn: _isSafeDeleteOn,
          appTheme: _appTheme,
          onThemeUpdate:
              _updateTheme), // TODO: give callback for isSafeDeleteOn setting
    );
  }
}
