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

  LocalStorage._();

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
      await _preferences.setString(appThemeKey, _appThemeDefault.name);
    }
    if (_preferences.get(isSafeDeleteOnKey) == null) {
      await _preferences.setBool(isSafeDeleteOnKey, _isSafeDeleteOnDefault);
    }

    // Check if any of the Appwrite config keys are missing
    final endpoint = _preferences.getString(appwriteEndpointKey);
    final projectId = _preferences.getString(appwriteProjectIdKey);
    final databaseId = _preferences.getString(appwriteDatabaseIdKey);
    final collectionId = _preferences.getString(appwriteCollectionIdKey);

    if (endpoint == null ||
        projectId == null ||
        databaseId == null ||
        collectionId == null) {
      // Try loading the environment file only if a key is missing
      try {
        await dotenv.load(fileName: ".env");
      } catch (e) {
        logger.severe('Error loading .env file');
      }

      // Get default config after loading environment variables
      final defaultAppwriteConfig = getDefaultAppwriteConfig();

      // Set preferences only if they are null
      if (endpoint == null) {
        await _preferences.setString(
            appwriteEndpointKey, defaultAppwriteConfig.endpoint);
      }
      if (projectId == null) {
        await _preferences.setString(
            appwriteProjectIdKey, defaultAppwriteConfig.projectId);
      }
      if (databaseId == null) {
        await _preferences.setString(
            appwriteDatabaseIdKey, defaultAppwriteConfig.databaseId);
      }
      if (collectionId == null) {
        await _preferences.setString(
            appwriteCollectionIdKey, defaultAppwriteConfig.collectionId);
      }
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
    await _preferences.setString(appThemeKey, theme.name);
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
    await _preferences.setBool(isSafeDeleteOnKey, isSafeDeleteOn);
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
      await _preferences.setString(appwriteEndpointKey, endpoint);
    }
    if (projectId != null) {
      await _preferences.setString(appwriteProjectIdKey, projectId);
    }
    if (databaseId != null) {
      await _preferences.setString(appwriteDatabaseIdKey, databaseId);
    }
    if (collectionId != null) {
      await _preferences.setString(appwriteCollectionIdKey, collectionId);
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
