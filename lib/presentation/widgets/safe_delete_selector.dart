import 'package:flutter/material.dart';
import 'package:inventory_app/core/constants/strings.dart';

class SafeDeleteSelector extends StatelessWidget {
  const SafeDeleteSelector({
    super.key,
    required this.isSafeDeleteOn,
    required this.onSafeDeleteToggle,
  });

  final bool isSafeDeleteOn;
  final Function(bool) onSafeDeleteToggle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.delete_forever),
        const Spacer(),
        const Text(SafeDelete.settingDescription),
        const Spacer(flex: 25),
        Transform.scale(
          scale: 0.85,
          child: Switch(
            value: isSafeDeleteOn,
            onChanged: onSafeDeleteToggle,
          ),
        ),
      ],
    );
  }
}
