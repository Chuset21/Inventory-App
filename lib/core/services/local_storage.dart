import 'package:flutter/material.dart';
import 'package:inventory_app/core/utils/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/keys.dart';

class LocalStorage {
  static late final SharedPreferencesWithCache _preferences;
  static bool _isInitialised = false;

  LocalStorage._(); // Private constructor

  static Future<void> _initialise() async {
    WidgetsFlutterBinding.ensureInitialized();
    LocalStorage._preferences = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(
        allowList: <String>{appThemeKey},
      ),
    );

    if (_preferences.get(appThemeKey) == null) {
      _preferences.setString(appThemeKey, AppTheme.system.name);
    }
    _isInitialised = true;
  }

  static Future<AppTheme> getAppTheme() async {
    if (!_isInitialised) {
      await _initialise();
    }
    final String? appTheme = _preferences.getString(appThemeKey);
    return appThemeNameMap[appTheme] ?? AppTheme.system;
  }

  static Future<void> updateAppTheme(AppTheme value) async {
    if (!_isInitialised) {
      await _initialise();
    }
    _preferences.setString(appThemeKey, value.name);
  }
}
