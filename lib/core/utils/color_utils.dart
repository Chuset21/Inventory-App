import 'package:flutter/material.dart';

Color getButtonBackgroundColor(BuildContext context, bool isEnabled) =>
    isEnabled
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.onSurface.withOpacity(0.12);

Color getButtonForegroundColor(BuildContext context, bool isEnabled) =>
    isEnabled
        ? Theme.of(context).canvasColor
        : Theme.of(context).colorScheme.onSurface.withOpacity(0.38);
