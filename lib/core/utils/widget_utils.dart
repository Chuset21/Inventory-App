import 'package:flutter/material.dart';
import 'package:inventory_app/data/models/models.dart';
import 'package:inventory_app/presentation/widgets/widgets.dart';

void selectAllText(TextEditingController controller) {
  controller.selection = TextSelection(
    baseOffset: 0,
    extentOffset: controller.text.length,
  );
}

void showErrorSnackBar(BuildContext context, ErrorInfo errorInfo,
    {int secondsToShow = 5}) {
  showMessageSnackBar(context, errorInfo.message, secondsToShow: secondsToShow);
}

void showMessageSnackBar(BuildContext context, String message,
    {int secondsToShow = 5, Color? backgroundColor, Color? foregroundColor}) {
  final duration = Duration(seconds: secondsToShow);

  final snackBar = SnackBar(
    behavior: SnackBarBehavior.floating,
    backgroundColor: backgroundColor,
    showCloseIcon: true,
    duration: duration,
    content: Column(
      children: [
        Center(child: Text(message)),
        MyProgressIndicator(
          // Add a bit to the duration, as it's more satisfying if the snackbar leaves before the indicator than the opposite
          duration: duration + const Duration(milliseconds: 400),
          foregroundColor: foregroundColor,
          backgroundColor: foregroundColor?.withOpacity(0.5),
        )
      ],
    ),
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}
