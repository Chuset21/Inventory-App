import 'package:flutter/material.dart';
import 'package:inventory_app/core/constants/strings.dart';
import 'package:inventory_app/core/utils/color_utils.dart';
import 'package:inventory_app/core/utils/widget_utils.dart';
import 'package:inventory_app/data/models/item.dart';
import 'package:inventory_app/presentation/widgets/custom_dropdown_menu.dart';
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

  late String _lastValidQuantityText;
  late String _previousCategoryText;
  late String _previousLocationText;
  bool _isInitialized = false;

  // When the menu text is changed, be sure to call setState so that the menu rebuilds and the menu height is updated accordingly
  void _onCategoryTextChange() {
    final currentText = _categoryController.text.trim().toLowerCase();
    // Call setState if the widget has initialized and the category text has changed
    if (_isInitialized && _previousCategoryText != currentText) {
      setState(() {});
    }
    _previousCategoryText = currentText;
  }

  // Same as above but with the location text
  void _onLocationTextChange() {
    final currentText = _locationController.text.trim().toLowerCase();
    // Call setState if the widget has initialized and the location text has changed
    if (_isInitialized && _previousLocationText != currentText) {
      setState(() {});
    }
    _previousLocationText = currentText;
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.itemToEdit.name);
    _lastValidQuantityText = widget.existingQuantity.toString();
    _quantityController = TextEditingController(text: _lastValidQuantityText);
    _categoryController = TextEditingController();
    _locationController = TextEditingController();
    _previousCategoryText = widget.itemToEdit.category;
    _previousLocationText = widget.itemToEdit.location;
    _categoryController.addListener(_onCategoryTextChange);
    _locationController.addListener(_onLocationTextChange);

    // Wait for the first build cycle to complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _isInitialized = true;
      });
    });
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

  bool get _areAllOptionsValid =>
      _areAllControllersNonEmpty && _haveValuesChanged;

  bool get _areAllControllersNonEmpty => [
        _nameController,
        _quantityController,
        _categoryController,
        _locationController,
      ].every((controller) => controller.text.isNotEmpty);

  bool get _haveValuesChanged => !(widget.itemToEdit.name ==
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

  @override
  Widget build(BuildContext context) {
    final areAllOptionsValid = _areAllOptionsValid;

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
            CustomDropdownMenu(
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
            CustomDropdownMenu(
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
        backgroundColor: getButtonBackgroundColor(context, areAllOptionsValid),
        foregroundColor: getButtonForegroundColor(context, areAllOptionsValid),
        child: const Icon(Icons.check),
      );
}
