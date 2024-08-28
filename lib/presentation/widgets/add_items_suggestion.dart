import 'package:flutter/material.dart';
import 'package:inventory_app/core/constants/strings.dart';

/// A suggestion to be used when there are no items,
/// informing you that there are no items and suggesting you add items.
class AddItemsSuggestion extends StatelessWidget {
  const AddItemsSuggestion(
      {super.key, this.alignment = MainAxisAlignment.center});

  final MainAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: alignment,
      children: [
        Icon(
          Icons.inventory_2_outlined,
          size: 80.0,
          color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
        ),
        const SizedBox(height: 20.0),
        Text(
          Messages.emptyInventory,
          style: TextStyle(
            fontSize: 24.0,
            color: Theme.of(context).colorScheme.primary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10.0),
        Text(
          Messages.addItemsSuggestion,
          style: TextStyle(
            fontSize: 16.0,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
