import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:inventory_app/core/constants/constants.dart';
import 'package:inventory_app/core/themes/themes.dart';
import 'package:inventory_app/core/utils/utils.dart';
import 'package:inventory_app/data/models/models.dart';
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
        allowList: <String>{
          appThemeKey,
          isSafeDeleteOnKey,
          appwriteEndpointKey,
          appwriteProjectIdKey,
          appwriteDatabaseIdKey,
          appwriteCollectionIdKey,
        },
      ),
    );

    if (_preferences.get(appThemeKey) == null) {
      _preferences.setString(appThemeKey, _appThemeDefault.name);
    }
    if (_preferences.get(isSafeDeleteOnKey) == null) {
      _preferences.setBool(isSafeDeleteOnKey, _isSafeDeleteOnDefault);
    }

    // Initialize Appwrite Config
    await dotenv.load(fileName: ".env");
    final defaultAppwriteConfig = getDefaultAppwriteConfig();

    if (_preferences.get(appwriteEndpointKey) == null) {
      _preferences.setString(
          appwriteEndpointKey, defaultAppwriteConfig.endpoint);
    }
    if (_preferences.get(appwriteProjectIdKey) == null) {
      _preferences.setString(
          appwriteProjectIdKey, defaultAppwriteConfig.projectId);
    }
    if (_preferences.get(appwriteDatabaseIdKey) == null) {
      _preferences.setString(
          appwriteDatabaseIdKey, defaultAppwriteConfig.databaseId);
    }
    if (_preferences.get(appwriteCollectionIdKey) == null) {
      _preferences.setString(
          appwriteCollectionIdKey, defaultAppwriteConfig.collectionId);
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

  // Appwrite Config Methods
  static Future<AppwriteConfig> getAppwriteConfig() async {
    if (!_isInitialised) {
      await _initialise();
    }

    return AppwriteConfig(
      endpoint: _preferences.getString(appwriteEndpointKey)!,
      projectId: _preferences.getString(appwriteProjectIdKey)!,
      databaseId: _preferences.getString(appwriteDatabaseIdKey)!,
      collectionId: _preferences.getString(appwriteCollectionIdKey)!,
    );
  }

  static Future<void> updateAppwriteConfigFields({
    String? endpoint,
    String? projectId,
    String? databaseId,
    String? collectionId,
  }) async {
    if (!_isInitialised) {
      await _initialise();
    }
    if (endpoint != null) {
      _preferences.setString(appwriteEndpointKey, endpoint);
    }
    if (projectId != null) {
      _preferences.setString(appwriteProjectIdKey, projectId);
    }
    if (databaseId != null) {
      _preferences.setString(appwriteDatabaseIdKey, databaseId);
    }
    if (collectionId != null) {
      _preferences.setString(appwriteCollectionIdKey, collectionId);
    }
  }

  static Future<void> updateAppwriteConfig(
          AppwriteConfig appwriteConfig) async =>
      await updateAppwriteConfigFields(
          endpoint: appwriteConfig.endpoint,
          projectId: appwriteConfig.projectId,
          databaseId: appwriteConfig.databaseId,
          collectionId: appwriteConfig.collectionId);
}
