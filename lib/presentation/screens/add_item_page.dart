import 'package:flutter/material.dart';
import 'package:inventory_app/core/constants/strings.dart';
import 'package:inventory_app/data/models/item.dart';

class AddItemPage extends StatefulWidget {
  final Iterable<String> existingCategories;
  final Iterable<String> existingLocations;
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
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _quantityFocusNode = FocusNode();
  final FocusNode _categoryFocusNode = FocusNode();
  final FocusNode _locationFocusNode = FocusNode();

  // This invisible entry is needed so that when a filter matches all possible values but none exactly, we don't get an index out of bounds from the menu
  static const _invisibleEntry = '';

  String _lastValidQuantityText = '';

  // When the menu text is changed, be sure to call setState so that the menu rebuilds and the menu height is updated accordingly
  void _menuControllerCallback() {
    setState(() {});
  }

  @override
  void initState() {
    _nameFocusNode.requestFocus();
    _categoryController.addListener(_menuControllerCallback);
    _locationController.addListener(_menuControllerCallback);
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocusNode.dispose();
    _quantityController.dispose();
    _quantityFocusNode.dispose();
    _categoryController.removeListener(_menuControllerCallback);
    _categoryController.dispose();
    _categoryFocusNode.dispose();
    _locationController.removeListener(_menuControllerCallback);
    _locationController.dispose();
    _locationFocusNode.dispose();
    super.dispose();
  }

  void _setQuantityTextToLastValidText() {
    setState(() {
      // Revert to the last valid text if the input is invalid
      _quantityController.text = _lastValidQuantityText;
      // Move the cursor to the end of the text
      _quantityController.selection = TextSelection.fromPosition(
        TextPosition(offset: _quantityController.text.length),
      );
    });
  }

  void _onQuantityTextChanged(String value) {
    final int? number = int.tryParse(value);
    if ((number == null || number <= 0) && value.isNotEmpty) {
      _setQuantityTextToLastValidText();
    } else {
      setState(() {
        _lastValidQuantityText = value;
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

  List<DropdownMenuEntry<String>> _filterCallback(
      List<DropdownMenuEntry<String>> entries, String filter) {
    final realEntries =
        entries.where((entry) => entry.label != _invisibleEntry);
    final trimmedFilter = filter.trim();

    if (trimmedFilter.isEmpty) {
      return realEntries.toList();
    }
    final trimmedLowercaseFilter = trimmedFilter.toLowerCase();

    final filteredEntries = realEntries
        .where(
          (entry) => entry.label.toLowerCase().contains(trimmedLowercaseFilter),
        )
        .toSet();

    if (!filteredEntries
        .any((entry) => entry.label.toLowerCase() == trimmedLowercaseFilter)) {
      filteredEntries.add(DropdownMenuEntry(
        value: trimmedFilter,
        label: trimmedFilter,
      ));
    }

    return filteredEntries.toList();
  }

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
              focusNode: _nameFocusNode,
              onChanged: (value) {
                setState(() {});
              },
              onSubmitted: (value) {
                _quantityFocusNode.requestFocus();
              },
              decoration:
                  const InputDecoration(labelText: EditItemMessages.itemName),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _quantityController,
              focusNode: _quantityFocusNode,
              onChanged: _onQuantityTextChanged,
              onSubmitted: (value) {
                _categoryFocusNode.requestFocus();
              },
              decoration:
                  const InputDecoration(labelText: EditItemMessages.quantity),
              keyboardType: const TextInputType.numberWithOptions(
                  signed: false, decimal: false),
            ),
            const SizedBox(height: 10),
            _buildDropdownMenu(
              controller: _categoryController,
              focusNode: _categoryFocusNode,
              nextFocusNode: _locationFocusNode,
              helperText: EditItemMessages.categoryHint,
              label: EditItemMessages.category,
              menuEntries: widget.existingCategories,
            ),
            const SizedBox(height: 10),
            _buildDropdownMenu(
              controller: _locationController,
              focusNode: _locationFocusNode,
              helperText: EditItemMessages.locationHint,
              label: EditItemMessages.location,
              menuEntries: widget.existingLocations,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              // Enable the button if all options are valid
              onPressed: _areAllOptionsValid()
                  ? () {
                      widget.addItemCallback(
                        item: Item(
                          name: _nameController.text.trim(),
                          category: _categoryController.text.trim(),
                          location: _locationController.text.trim(),
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

  DropdownMenu<String> _buildDropdownMenu({
    required TextEditingController controller,
    required FocusNode focusNode,
    FocusNode? nextFocusNode,
    required String helperText,
    required String label,
    required Iterable<String> menuEntries,
  }) =>
      DropdownMenu<String>(
        expandedInsets: EdgeInsets.zero,
        helperText: helperText,
        requestFocusOnTap: true,
        enableFilter: true,
        filterCallback: _filterCallback,
        menuHeight: menuEntries.isEmpty && controller.text.isEmpty ? 0 : null,
        menuStyle: const MenuStyle(
          minimumSize: WidgetStatePropertyAll(Size.zero),
        ),
        focusNode: focusNode,
        controller: controller,
        onSelected: (value) {
          setState(() {});
          nextFocusNode?.requestFocus();
        },
        dropdownMenuEntries: menuEntries
            .map((value) => DropdownMenuEntry(
                  value: value,
                  label: value,
                ))
            .toList()
          // Add the invisible entry
          ..add(const DropdownMenuEntry(
            labelWidget: SizedBox(
              width: 0,
              height: 0,
            ),
            value: _invisibleEntry,
            label: _invisibleEntry,
          )),
        label: Text(label),
      );
}
