import 'package:flutter/material.dart';
import 'package:inventory_app/core/constants/strings.dart';
import 'package:inventory_app/data/models/item.dart';
import 'package:inventory_app/presentation/widgets/default_app_bar.dart';

class ItemInfoPage extends StatelessWidget {
  final Item item;
  final int quantity;

  const ItemInfoPage({
    super.key,
    required this.item,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: const DefaultAppBar(
          title: Text(EditItemMessages.itemInfo),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: TextEditingController(text: item.name),
                decoration:
                    const InputDecoration(labelText: EditItemMessages.itemName),
                readOnly: true,
              ),
              const Spacer(
                flex: 2,
              ),
              TextField(
                controller: TextEditingController(text: quantity.toString()),
                decoration:
                    const InputDecoration(labelText: EditItemMessages.quantity),
                readOnly: true,
              ),
              const Spacer(
                flex: 2,
              ),
              TextField(
                controller: TextEditingController(text: item.category),
                decoration:
                    const InputDecoration(labelText: EditItemMessages.category),
                readOnly: true,
              ),
              const Spacer(
                flex: 2,
              ),
              TextField(
                controller: TextEditingController(text: item.location),
                decoration:
                    const InputDecoration(labelText: EditItemMessages.location),
                readOnly: true,
              ),
              const Spacer(
                flex: 40,
              ),
            ],
          ),
        ),
      );
}
