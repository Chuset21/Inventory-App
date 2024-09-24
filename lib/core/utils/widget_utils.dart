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
  final snackBar = SnackBar(
    behavior: SnackBarBehavior.floating,
    showCloseIcon: true,
    duration: Duration(seconds: secondsToShow),
    content: Center(child: Text(errorInfo.message)),
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}
