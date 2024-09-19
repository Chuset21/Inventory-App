import 'package:flutter/material.dart';
import 'package:inventory_app/core/services/services.dart';
import 'package:inventory_app/core/utils/utils.dart';
import 'package:provider/provider.dart';

import 'presentation/screens/screens.dart';

void main() async {
  runApp(MyApp(
    appTheme: await LocalStorage.getAppTheme(),
    isSafeDeleteOn: await LocalStorage.isSafeDeleteOn(),
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

/// This widget essentially keeps track of local settings
class _MyApp extends State<MyApp> {
  // Load the app in the system theme, since we need a theme for loading
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Freezer Inventory',
      theme: getThemeData(_appTheme),
      debugShowCheckedModeBanner: false,
      home: ChangeNotifierProvider(
        create: (_) => SettingsModel(_isSafeDeleteOn),
        child: HomePage(
          title: 'Freezer Inventory',
          getAppTheme: () => _appTheme,
          onThemeUpdate: _updateTheme,
        ),
      ),
    );
  }
}
