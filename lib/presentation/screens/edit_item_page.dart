import 'package:flutter/material.dart';
import 'package:inventory_app/core/constants/strings.dart';
import 'package:inventory_app/core/utils/widget_utils.dart';
import 'package:inventory_app/data/models/item.dart';
import 'package:inventory_app/presentation/widgets/default_app_bar.dart';

import '../../core/utils/item_utils.dart';

// TODO: Refactor so that we're not copying so many things from add item page
class EditItemPage extends StatefulWidget {
  final Iterable<String> existingNames;
  final Iterable<String> existingCategories;
  final Iterable<String> existingLocations;
  final Item itemToEdit;
  final int existingQuantity;
  final void Function({required Item updatedItem, required int updatedQuantity})
      editItemCallback;

  const EditItemPage({
    super.key,
    required this.existingNames,
    required this.existingCategories,
    required this.existingLocations,
    required this.editItemCallback,
    required this.itemToEdit,
    required this.existingQuantity,
  });

  @override
  State<EditItemPage> createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  late TextEditingController _nameController;
  late TextEditingController _quantityController;
  late TextEditingController _categoryController;
  late TextEditingController _locationController;
  final FocusNode _categoryFocusNode = FocusNode();
  final FocusNode _locationFocusNode = FocusNode();

  // This invisible entry is needed so that when a filter matches all possible values but none exactly, we don't get an index out of bounds from the menu
  static const _invisibleEntry = '';

  String _lastValidQuantityText = '';
  late String _previousCategoryText;
  late String _previousLocationText;

  // When the menu text is changed, be sure to call setState so that the menu rebuilds and the menu height is updated accordingly
  void _onCategoryTextChange() {
    final currentText = _categoryController.text.trim().toLowerCase();
    // Only call setState if the menu hasn't just loaded and if the text has changed
    if (_categoryController.text != widget.itemToEdit.category &&
        _previousCategoryText != currentText) {
      setState(() {});
    }
    _previousCategoryText = currentText;
  }

  // Same as above but with the location text
  void _onLocationTextChange() {
    final currentText = _locationController.text.trim().toLowerCase();
    // Only call setState if the menu hasn't just loaded and if the text has changed
    if (_locationController.text != widget.itemToEdit.location &&
        _previousLocationText != currentText) {
      setState(() {});
    }
    _previousLocationText = currentText;
  }

  @override
  void initState() {
    _nameController = TextEditingController(text: widget.itemToEdit.name);
    _quantityController =
        TextEditingController(text: widget.existingQuantity.toString());
    _categoryController = TextEditingController();
    _locationController = TextEditingController();
    _previousCategoryText = widget.itemToEdit.category;
    _previousLocationText = widget.itemToEdit.location;
    _categoryController.addListener(_onCategoryTextChange);
    _locationController.addListener(_onLocationTextChange);
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _categoryController.removeListener(_onCategoryTextChange);
    _categoryController.dispose();
    _categoryFocusNode.dispose();
    _locationController.removeListener(_onLocationTextChange);
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

  bool _areAllOptionsValid() =>
      [
        _nameController,
        _quantityController,
        _categoryController,
        _locationController,
      ].every((controller) => controller.text.isNotEmpty) &&
      // Not all values are the same as their initial values
      !(widget.itemToEdit.name ==
              normaliseOption(
                  chosenOption: _nameController.text,
                  existingValues: widget.existingNames) &&
          widget.existingQuantity.toString() == _quantityController.text &&
          widget.itemToEdit.category ==
              normaliseOption(
                  chosenOption: _categoryController.text,
                  existingValues: widget.existingCategories) &&
          widget.itemToEdit.location ==
              normaliseOption(
                  chosenOption: _locationController.text,
                  existingValues: widget.existingLocations));

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
    final areAllOptionsValid = _areAllOptionsValid();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const DefaultAppBar(
        title: Text(EditItemMessages.editItem),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              textCapitalization: TextCapitalization.sentences,
              controller: _nameController,
              onChanged: (value) {
                setState(() {});
              },
              decoration:
                  const InputDecoration(labelText: EditItemMessages.itemName),
            ),
            const Spacer(
              flex: 2,
            ),
            TextField(
              controller: _quantityController,
              onChanged: _onQuantityTextChanged,
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
              initialSelection: widget.itemToEdit.category,
              controller: _categoryController,
              focusNode: _categoryFocusNode,
              helperText: EditItemMessages.categoryHint,
              label: EditItemMessages.category,
              menuEntries: widget.existingCategories,
            ),
            const Spacer(
              flex: 2,
            ),
            _buildDropdownMenu(
              initialSelection: widget.itemToEdit.location,
              controller: _locationController,
              focusNode: _locationFocusNode,
              helperText: EditItemMessages.locationHint,
              label: EditItemMessages.location,
              menuEntries: widget.existingLocations,
            ),
            const Spacer(
              flex: 40,
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(areAllOptionsValid),
    );
  }

  Widget _buildFloatingActionButton(bool areAllOptionsValid) =>
      FloatingActionButton(
        onPressed: areAllOptionsValid
            ? () {
                widget.editItemCallback(
                  updatedItem: Item(
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
                  updatedQuantity: _getQuantity(),
                );
                Navigator.pop(context);
              }
            : null,
        tooltip: areAllOptionsValid
            ? Tooltips.confirmEditItem
            : Tooltips.changeOneField,
        backgroundColor: areAllOptionsValid
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
        // Disabled state
        foregroundColor: areAllOptionsValid
            ? Theme.of(context).canvasColor
            : Theme.of(context).colorScheme.onSurface.withOpacity(0.38),
        child: const Icon(Icons.check),
      );

  // Can't seem to bring up the keyboard capitalised in menus
  Widget _buildDropdownMenu({
    required String initialSelection,
    required TextEditingController controller,
    required FocusNode focusNode,
    required String helperText,
    required String label,
    required Iterable<String> menuEntries,
  }) =>
      DropdownMenu<String>(
        initialSelection: initialSelection,
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
