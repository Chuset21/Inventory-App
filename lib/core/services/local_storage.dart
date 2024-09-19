import 'package:flutter/material.dart';
import 'package:inventory_app/core/constants/constants.dart';
import 'package:inventory_app/core/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const _isSafeDeleteOnDefault = true;
  static const _appThemeDefault = AppTheme.system;
  static late final SharedPreferencesWithCache _preferences;
  static bool _isInitialised = false;

  LocalStorage._(); // Private constructor

  static Future<void> _initialise() async {
    WidgetsFlutterBinding.ensureInitialized();
    LocalStorage._preferences = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(
        allowList: <String>{appThemeKey, isSafeDeleteOnKey},
      ),
    );

    if (_preferences.get(appThemeKey) == null) {
      _preferences.setString(appThemeKey, _appThemeDefault.name);
    }
    if (_preferences.get(isSafeDeleteOnKey) == null) {
      _preferences.setBool(isSafeDeleteOnKey, _isSafeDeleteOnDefault);
    }
    _isInitialised = true;
  }

  static Future<AppTheme> getAppTheme() async {
    if (!_isInitialised) {
      await _initialise();
    }
    final String? appTheme = _preferences.getString(appThemeKey);
    return appThemeNameMap[appTheme] ?? _appThemeDefault;
  }

  static Future<void> updateAppTheme(AppTheme theme) async {
    if (!_isInitialised) {
      await _initialise();
    }
    _preferences.setString(appThemeKey, theme.name);
  }

  static Future<bool> isSafeDeleteOn() async {
    if (!_isInitialised) {
      await _initialise();
    }
    return _preferences.getBool(isSafeDeleteOnKey) ?? _isSafeDeleteOnDefault;
  }

  static Future<void> updateIsSafeDeleteOn(bool isSafeDeleteOn) async {
    if (!_isInitialised) {
      await _initialise();
    }
    _preferences.setBool(isSafeDeleteOnKey, isSafeDeleteOn);
  }
}
