import 'package:flutter/material.dart';
import 'package:inventory_app/data/models/models.dart';

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
    {int secondsToShow = 5, Color? backgroundColor}) {
  final snackBar = SnackBar(
    behavior: SnackBarBehavior.floating,
    backgroundColor: backgroundColor,
    showCloseIcon: true,
    duration: Duration(seconds: secondsToShow),
    content: Center(child: Text(message)),
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}
