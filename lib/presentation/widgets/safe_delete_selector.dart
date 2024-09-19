import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_app/core/constants/constants.dart';
import 'package:inventory_app/core/providers/providers.dart';

class SafeDeleteSelector extends ConsumerWidget {
  const SafeDeleteSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSafeDeleteOn = ref.watch(safeDeleteProvider);

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
            onChanged: (bool newValue) {
              ref.read(safeDeleteProvider.notifier).updateSafeDelete(newValue);
            },
          ),
        ),
      ],
    );
  }
}
