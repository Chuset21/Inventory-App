import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Returns whether or not the platform's default theme is dark mode.
/// Should only be used inside a Flutter Widget.
bool isPlatformDarkMode() {
  Brightness brightness =
      SchedulerBinding.instance.platformDispatcher.platformBrightness;
  return brightness == Brightness.dark;
}
