import 'package:flutter/material.dart';
import 'package:inventory_app/core/constants/constants.dart';

class SafeDeleteSelector extends StatefulWidget {
  const SafeDeleteSelector({
    super.key,
    required this.isSafeDeleteOn,
    required this.onSafeDeleteToggle,
  });

  final bool Function() isSafeDeleteOn;
  final Function(bool) onSafeDeleteToggle;

  @override
  State<SafeDeleteSelector> createState() => _SafeDeleteSelectorState();
}

class _SafeDeleteSelectorState extends State<SafeDeleteSelector> {
  void _updateSafeDelete(bool newValue) {
    setState(() {
      widget.onSafeDeleteToggle(newValue);
    });
  }

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
            value: widget.isSafeDeleteOn(),
            onChanged: _updateSafeDelete,
          ),
        ),
      ],
    );
  }
}
