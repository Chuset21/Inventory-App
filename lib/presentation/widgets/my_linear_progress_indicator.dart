import 'package:flutter/material.dart';
import 'package:inventory_app/core/constants/constants.dart';

class MyProgressIndicator extends StatefulWidget {
  const MyProgressIndicator({
    super.key,
    required this.duration,
    this.backgroundColor,
    this.foregroundColor,
  });

  final Duration duration;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  State<MyProgressIndicator> createState() => _MyProgressIndicatorState();
}

class _MyProgressIndicatorState extends State<MyProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      value: 1.0,
      vsync: this,
      duration: widget.duration,
    )..addListener(() {
        setState(() {});
      });
    controller.reverse();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      color: widget.foregroundColor,
      backgroundColor: widget.backgroundColor,
      value: controller.value,
      semanticsLabel: SemanticLabels.linearProgressIndicator,
    );
  }
}
