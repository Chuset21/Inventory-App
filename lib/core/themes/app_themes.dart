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
        backgroundColor: _darkTheme.colorScheme.error,
        contentTextStyle: TextStyle(color: _darkTheme.colorScheme.surface),
        actionTextColor: _darkTheme.colorScheme.surface,
        closeIconColor: _darkTheme.colorScheme.surface,
      ),
    );

final ThemeData lightTheme = _createTheme(_lightTheme);
final ThemeData darkTheme = _createTheme(_darkTheme);
