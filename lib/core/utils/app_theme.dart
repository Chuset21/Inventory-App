import 'package:flutter/material.dart';
import 'package:inventory_app/core/themes/app_themes.dart';

import 'platform_utils.dart';

enum AppTheme {
  light,
  dark,
  system,
}

final appThemeNameMap = AppTheme.values.asNameMap();

ThemeData getThemeData(AppTheme theme) {
  switch (theme) {
    case AppTheme.light:
      return lightTheme;
    case AppTheme.dark:
      return darkTheme;
    default:
      return isPlatformDarkMode() ? darkTheme : lightTheme;
  }
}
