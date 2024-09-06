import 'package:flutter/material.dart';

/// A widget to be used when there are no items
class EmptyInventory extends StatelessWidget {
  const EmptyInventory({
    super.key,
    required this.mainMessage,
    this.alignment = MainAxisAlignment.center,
    required this.suggestionMessage,
  });

  final String mainMessage;
  final String suggestionMessage;
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
          mainMessage,
          style: TextStyle(
            fontSize: 24.0,
            color: Theme.of(context).colorScheme.primary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10.0),
        Text(
          suggestionMessage,
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
