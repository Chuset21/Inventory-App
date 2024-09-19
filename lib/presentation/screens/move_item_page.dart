import 'package:flutter/material.dart';
import 'package:inventory_app/core/constants/constants.dart';
import 'package:inventory_app/core/utils/utils.dart';
import 'package:inventory_app/data/models/models.dart';
import 'package:inventory_app/presentation/widgets/widgets.dart';

// TODO: Refactor so that we're not copying so many things from edit item page
class MoveItemPage extends StatefulWidget {
  final Iterable<String> existingLocations;
  final Item itemToMove;
  final int existingQuantity;
  final void Function(
      {required String newLocation,
      required int quantityToMove}) moveItemCallback;

  const MoveItemPage({
    super.key,
    required this.existingLocations,
    required this.moveItemCallback,
    required this.itemToMove,
    required this.existingQuantity,
  });

  @override
  State<MoveItemPage> createState() => _MoveItemPageState();
}

class _MoveItemPageState extends State<MoveItemPage> {
  late TextEditingController _nameController;
  late TextEditingController _quantityController;
  late TextEditingController _categoryController;
  late TextEditingController _locationController;
  final FocusNode _locationFocusNode = FocusNode();

  late String _lastValidQuantityText;
  late String _previousLocationText;
  bool _isInitialized = false;

  // When the menu text is changed, be sure to call setState so that the menu rebuilds and the menu height is updated accordingly
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
    _nameController = TextEditingController(text: widget.itemToMove.name);
    _lastValidQuantityText = widget.existingQuantity.toString();
    _quantityController = TextEditingController(text: _lastValidQuantityText);
    _categoryController =
        TextEditingController(text: widget.itemToMove.category);
    _locationController = TextEditingController();
    _previousLocationText = widget.itemToMove.location;
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
    _categoryController.dispose();
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
    if ((number == null || number <= 0 || number > widget.existingQuantity) &&
        value.isNotEmpty) {
      _setQuantityTextToLastValidText();
    } else {
      setState(() {
        _lastValidQuantityText = value;
      });
    }
  }

  /// Assume that this function will only be called when the controller has text
  int _getQuantity() => _tryGetQuantity()!;

  int? _tryGetQuantity() => int.tryParse(_quantityController.text);

  bool get _areAllOptionsValid => _isLocationValid && _isQuantityValid;

  bool get _isLocationValid =>
      _locationController.text.isNotEmpty &&
      widget.itemToMove.location !=
          normaliseOption(
              chosenOption: _locationController.text,
              existingValues: widget.existingLocations);

  bool get _isQuantityValid {
    final int? quantity = _tryGetQuantity();
    return quantity != null &&
        1 <= quantity &&
        quantity <= widget.existingQuantity;
  }

  @override
  Widget build(BuildContext context) {
    final areAllOptionsValid = _areAllOptionsValid;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const DefaultAppBar(
        title: Text(
          EditItemMessages.moveItem,
          textAlign: TextAlign.center,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration:
                  const InputDecoration(labelText: EditItemMessages.itemName),
              readOnly: true,
            ),
            const Spacer(
              flex: 2,
            ),
            TextField(
              controller: _quantityController,
              onChanged: _onQuantityTextChanged,
              onSubmitted: (value) => _locationFocusNode.requestFocus(),
              decoration:
                  const InputDecoration(labelText: EditItemMessages.quantity),
              keyboardType: const TextInputType.numberWithOptions(
                  signed: false, decimal: false),
              onTap: () => selectAllText(_quantityController),
            ),
            const Spacer(
              flex: 2,
            ),
            TextField(
              controller: _categoryController,
              decoration:
                  const InputDecoration(labelText: EditItemMessages.category),
              readOnly: true,
            ),
            const Spacer(
              flex: 2,
            ),
            CustomDropdownMenu(
              initialSelection: widget.itemToMove.location,
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
      floatingActionButton: _buildFloatingActionButton(
        areAllOptionsValid: areAllOptionsValid,
        isLocationValid: _isLocationValid,
        isQuantityValid: _isQuantityValid,
      ),
    );
  }

  Widget _buildFloatingActionButton(
          {required bool areAllOptionsValid,
          required bool isLocationValid,
          required bool isQuantityValid}) =>
      FloatingActionButton(
        onPressed: areAllOptionsValid
            ? () {
                widget.moveItemCallback(
                  newLocation: normaliseOption(
                      chosenOption: _locationController.text,
                      existingValues: widget.existingLocations),
                  quantityToMove: _getQuantity(),
                );
                Navigator.pop(context);
              }
            : null,
        tooltip: isLocationValid
            ? isQuantityValid
                ? Tooltips.confirmMoveItem
                : Tooltips.buildInvalidQuantityMessage(
                    maxQuantity: widget.existingQuantity)
            : Tooltips.changeLocation,
        backgroundColor: getButtonBackgroundColor(context, areAllOptionsValid),
        foregroundColor: getButtonForegroundColor(context, areAllOptionsValid),
        child: const Icon(Icons.check),
      );
}
