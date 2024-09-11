import 'package:flutter/material.dart';
import 'package:inventory_app/core/constants/strings.dart';
import 'package:inventory_app/core/utils/color_utils.dart';
import 'package:inventory_app/data/models/item.dart';
import 'package:inventory_app/presentation/widgets/default_app_bar.dart';

import '../../core/utils/item_utils.dart';
import '../../core/utils/widget_utils.dart';

class AddItemPage extends StatefulWidget {
  final Iterable<String> existingNames;
  final Iterable<String> existingCategories;
  final Iterable<String> existingLocations;
  final void Function({required Item item, required int quantity})
      addItemCallback;

  const AddItemPage({
    super.key,
    required this.existingNames,
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
  final FocusNode _addItemFocusNode = FocusNode();

  // This invisible entry is needed so that when a filter matches all possible values but none exactly, we don't get an index out of bounds from the menu
  static const _invisibleEntry = '';

  String _lastValidQuantityText = '';
  String _previousCategoryText = '';
  String _previousLocationText = '';

  // When the menu text is changed, be sure to call setState so that the menu rebuilds and the menu height is updated accordingly
  void _onCategoryTextChange() {
    final currentText = _categoryController.text.trim().toLowerCase();
    if (_previousCategoryText != currentText) {
      setState(() {});
    }
    _previousCategoryText = currentText;
  }

  // Same as above but with the location text
  void _onLocationTextChange() {
    final currentText = _locationController.text.trim().toLowerCase();
    if (_previousLocationText != currentText) {
      setState(() {});
    }
    _previousLocationText = currentText;
  }

  @override
  void initState() {
    _nameFocusNode.requestFocus();
    _categoryController.addListener(_onCategoryTextChange);
    _locationController.addListener(_onLocationTextChange);
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocusNode.dispose();
    _quantityController.dispose();
    _quantityFocusNode.dispose();
    _categoryController.removeListener(_onCategoryTextChange);
    _categoryController.dispose();
    _categoryFocusNode.dispose();
    _locationController.removeListener(_onLocationTextChange);
    _locationController.dispose();
    _locationFocusNode.dispose();
    _addItemFocusNode.dispose();
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

  bool get _areAllOptionsValid => [
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
    final areAllOptionsValid = _areAllOptionsValid;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const DefaultAppBar(
        title: Text(EditItemMessages.addItem),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              textCapitalization: TextCapitalization.sentences,
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
            const Spacer(
              flex: 2,
            ),
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
              onTap: () => selectAllText(_quantityController),
            ),
            const Spacer(
              flex: 2,
            ),
            _buildDropdownMenu(
              controller: _categoryController,
              focusNode: _categoryFocusNode,
              nextFocusNode: _locationFocusNode,
              helperText: EditItemMessages.categoryHint,
              label: EditItemMessages.category,
              menuEntries: widget.existingCategories,
            ),
            const Spacer(
              flex: 2,
            ),
            _buildDropdownMenu(
              controller: _locationController,
              focusNode: _locationFocusNode,
              nextFocusNode: _addItemFocusNode,
              helperText: EditItemMessages.locationHint,
              label: EditItemMessages.location,
              menuEntries: widget.existingLocations,
            ),
            const Spacer(
              flex: 3,
            ),
            Center(
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    getButtonBackgroundColor(context, areAllOptionsValid),
                  ),
                  foregroundColor: WidgetStatePropertyAll(
                    getButtonForegroundColor(context, areAllOptionsValid),
                  ),
                ),
                focusNode: _addItemFocusNode,
                // Enable the button if all options are valid
                onPressed: areAllOptionsValid
                    ? () {
                        widget.addItemCallback(
                          item: Item(
                            name: normaliseOption(
                                chosenOption: _nameController.text,
                                existingValues: widget.existingNames),
                            category: normaliseOption(
                                chosenOption: _categoryController.text,
                                existingValues: widget.existingCategories),
                            location: normaliseOption(
                                chosenOption: _locationController.text,
                                existingValues: widget.existingLocations),
                          ),
                          quantity: _getQuantity(),
                        );
                        Navigator.pop(context);
                      }
                    : null,
                child: const Text(EditItemMessages.addItem),
              ),
            ),
            const Spacer(
              flex: 40,
            ),
          ],
        ),
      ),
    );
  }

  // Can't seem to bring up the keyboard capitalised in menus
  Widget _buildDropdownMenu({
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
          focusNode.unfocus();
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
