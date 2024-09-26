import 'package:flutter/material.dart';

final ThemeData _lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.lightBlue.shade600, brightness: Brightness.light),
);

final ThemeData _darkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blueGrey, brightness: Brightness.dark),
);

ThemeData _createTheme(ThemeData initialTheme) => initialTheme.copyWith(
      snackBarTheme: SnackBarThemeData(
        backgroundColor: initialTheme.colorScheme.error,
        contentTextStyle: TextStyle(color: initialTheme.colorScheme.surface),
        actionTextColor: initialTheme.colorScheme.surface,
        closeIconColor: initialTheme.colorScheme.surface,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
          linearTrackColor: initialTheme.colorScheme.onError.withOpacity(0.5),
          color: initialTheme.colorScheme.onError),
    );

final ThemeData lightTheme = _createTheme(_lightTheme);
final ThemeData darkTheme = _createTheme(_darkTheme);
