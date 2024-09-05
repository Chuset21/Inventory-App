import 'package:flutter/material.dart';
import 'package:inventory_app/core/constants/strings.dart';
import 'package:inventory_app/data/models/item.dart';

class AddItemPage extends StatefulWidget {
  final List<String> existingCategories;
  final List<String> existingLocations;
  final void Function({required Item item, required int quantity})
      addItemCallback;

  const AddItemPage({
    super.key,
    required this.existingCategories,
    required this.existingLocations,
    required this.addItemCallback,
  });

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  String _lastValidText = '';

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _categoryController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _setQuantityTextToLastValidText() {
    setState(() {
      // Revert to the last valid text if the input is invalid
      _quantityController.text = _lastValidText;
      // Move the cursor to the end of the text
      _quantityController.selection = TextSelection.fromPosition(
        TextPosition(offset: _quantityController.text.length),
      );
    });
  }

  void _onQuantityTextChanged(String value) {
    final int? number = int.tryParse(value);
    if ((number == null || number < 0) && value.isNotEmpty) {
      _setQuantityTextToLastValidText();
    } else {
      setState(() {
        _lastValidText = value;
      });
    }
  }

  /// Assume that this function will only be called when the controller has text
  int _getQuantity() => int.tryParse(_quantityController.text)!;

  bool _areAllOptionsValid() => [
        _nameController,
        _quantityController,
        _categoryController,
        _locationController,
      ].every((controller) => controller.text.isNotEmpty);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).canvasColor,
        title: const Text(EditItemMessages.addItem),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              onChanged: (value) {
                setState(() {});
              },
              decoration:
                  const InputDecoration(labelText: EditItemMessages.itemName),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _quantityController,
              onChanged: _onQuantityTextChanged,
              decoration:
                  const InputDecoration(labelText: EditItemMessages.quantity),
              keyboardType: const TextInputType.numberWithOptions(
                  signed: false, decimal: false),
            ),
            const SizedBox(height: 10),
            // TODO: fix error where user cannot try to type a new option or make a mistake, otherwise it crashes
            DropdownMenu<String>(
              requestFocusOnTap: true,
              enableFilter: true,
              controller: _categoryController,
              onSelected: (value) {
                setState(() {});
              },
              dropdownMenuEntries: widget.existingCategories
                  .map((category) => DropdownMenuEntry(
                        value: category,
                        label: category,
                      ))
                  .toList(),
              label: const Text(EditItemMessages.category),
            ),
            const SizedBox(height: 10),
            // TODO: fix error where user cannot try to type a new option or make a mistake, otherwise it crashes
            DropdownMenu<String>(
              requestFocusOnTap: true,
              enableFilter: true,
              controller: _locationController,
              onSelected: (value) {
                setState(() {});
              },
              dropdownMenuEntries: widget.existingLocations
                  .map((location) => DropdownMenuEntry(
                        value: location,
                        label: location,
                      ))
                  .toList(),
              label: const Text(EditItemMessages.location),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              // Disable the button if not all options are valid
              onPressed: _areAllOptionsValid()
                  ? () {
                      widget.addItemCallback(
                        item: Item(
                          name: _nameController.text,
                          category: _categoryController.text,
                          location: _locationController.text,
                        ),
                        quantity: _getQuantity(),
                      );
                      Navigator.pop(context);
                    }
                  : null,
              child: const Text(EditItemMessages.addItem),
            ),
          ],
        ),
      ),
    );
  }
}
