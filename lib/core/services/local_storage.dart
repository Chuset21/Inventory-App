import 'package:flutter/material.dart';
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
        allowList: <String>{isDarkModeKey},
      ),
    );
    _isInitialised = true;
  }

  static Future<bool?> isDarkMode() async {
    if (!_isInitialised) {
      await _initialise();
    }
    return _preferences.getBool(isDarkModeKey);
  }

  static Future<void> updateDarkMode(bool value) async {
    if (!_isInitialised) {
      await _initialise();
    }
    _preferences.setBool(isDarkModeKey, value);
  }
}