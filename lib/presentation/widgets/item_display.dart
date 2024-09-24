import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_app/core/constants/constants.dart';
import 'package:inventory_app/core/providers/providers.dart';
import 'package:inventory_app/core/utils/utils.dart';
import 'package:inventory_app/data/models/models.dart';
import 'package:inventory_app/presentation/screens/screens.dart';

class ItemDisplay extends ConsumerStatefulWidget {
  final Iterable<String> existingNames;
  final Iterable<String> existingCategories;
  final Iterable<String> existingLocations;
  final Item item;
  final Function(int) setItemNumber;
  final Function() removeItem;
  final void Function({required Item updatedItem}) editItem;
  final void Function(
      {required String newLocation, required int quantityToMove}) moveItem;
  final bool disableButtons;

  /// The focus node for the number
  final FocusNode? numberFocusNode;

  const ItemDisplay({
    super.key,
    required this.existingNames,
    required this.existingCategories,
    required this.existingLocations,
    required this.item,
    required this.setItemNumber,
    required this.removeItem,
    required this.editItem,
    required this.moveItem,
    this.numberFocusNode,
    this.disableButtons = false,
  });

  int get quantity => item.quantity;

  @override
  ConsumerState<ItemDisplay> createState() => ItemDisplayState();
}

class ItemDisplayState extends ConsumerState<ItemDisplay> {
  bool get isSafeDeleteOn => ref.read(safeDeleteProvider);

  late int _lastValidNumber;
  late double _quantityFontSize;
  static const _quantityBoxSize = 50.0;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _lastValidNumber = widget.quantity;
    _controller = TextEditingController(text: widget.quantity.toString());
    _updateQuantityFontSize();
  }

  void _updateQuantityFontSize() {
    _quantityFontSize = getAdjustedFontSizeByCharacters(
      text: _controller.text,
      maxFontSize: 18.0,
      fontAdjustOffset: 2,
      minFontSize: 8.0,
      scaleFactor: 3,
    );
  }

  void submitText() {
    _onSubmitted(_controller.text);
  }

  void _setTextToLastValidNumber() {
    // Revert to the last valid number if the input is invalid
    _controller.text = _lastValidNumber.toString();
    // Move the cursor to the end of the text
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: _controller.text.length),
    );
  }

  int? _tryGetControllerNumber() => int.tryParse(_controller.text);

  void _increment() {
    final controllerNumber = _tryGetControllerNumber() ?? 0;
    widget.setItemNumber(controllerNumber + 1);
  }

  void _decrement() {
    final controllerNumber = _tryGetControllerNumber() ?? 0;
    if (controllerNumber > 1) {
      widget.setItemNumber(controllerNumber - 1);
    } else if (isSafeDeleteOn) {
      _showDeleteConfirmationDialog();
    } else {
      widget.removeItem();
    }
  }

  void _editItem() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditItemPage(
          editItemCallback: widget.editItem,
          itemToEdit: widget.item,
          existingNames: widget.existingNames,
          existingQuantity: widget.quantity,
          existingCategories: widget.existingCategories,
          existingLocations: widget.existingLocations,
        ),
      ),
    );
  }

  void _moveItem() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MoveItemPage(
          moveItemCallback: widget.moveItem,
          itemToMove: widget.item,
          existingQuantity: widget.quantity,
          existingLocations: widget.existingLocations,
        ),
      ),
    );
  }

  void _showItemInfo() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemInfoPage(
          item: widget.item,
          quantity: widget.quantity,
        ),
      ),
    );
  }

  void _onSubmitted(String value) {
    final int? number = int.tryParse(value);
    if (number != null && number > 0) {
      widget.setItemNumber(number);
    } else if (number == 0) {
      if (isSafeDeleteOn) {
        _showDeleteConfirmationDialog();
      } else {
        widget.removeItem();
      }
    } else {
      setState(() {
        _setTextToLastValidNumber();
      });
    }
  }

  void _onTextChanged(String value) {
    final int? number = int.tryParse(value);
    setState(() {
      if (number == null || number < 0) {
        _setTextToLastValidNumber();
      } else {
        _controller.text = number.toString();
        _lastValidNumber = number;
      }
      _updateQuantityFontSize();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(safeDeleteProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: _quantityBoxSize,
          height: _quantityBoxSize,
          child: TextField(
            readOnly: widget.disableButtons,
            controller: _controller,
            focusNode: widget.numberFocusNode,
            keyboardType: const TextInputType.numberWithOptions(
                signed: false, decimal: false),
            textAlign: TextAlign.center,
            textAlignVertical: TextAlignVertical.center,
            style: TextStyle(
              fontSize: _quantityFontSize,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.secondary,
            ),
            onChanged: _onTextChanged,
            onSubmitted: _onSubmitted,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              focusedBorder: _buildOutlineInputBorder(width: 2.0),
              enabledBorder: _buildOutlineInputBorder(opacity: 0.5, width: 1.0),
            ),
            onTap: () => selectAllText(_controller),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Row(
              children: [
                IconButton(
                  tooltip: Tooltips.itemInfo,
                  icon: Icon(
                    Icons.info,
                    size: 30,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: _showItemInfo,
                ),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      textAlign: TextAlign.start,
                      widget.item.name,
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Column(
                children: [
                  _buildItemButton(
                    tooltipMessage: Tooltips.incrementQuantity,
                    onTapCallback: _increment,
                    child: Icon(
                      Icons.add,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  _buildItemButton(
                    tooltipMessage: (_tryGetControllerNumber() ?? 0) <= 1
                        ? Tooltips.deleteItem
                        : Tooltips.decrementQuantity,
                    onTapCallback: _decrement,
                    child: (_tryGetControllerNumber() ?? 0) <= 1
                        ? const Icon(
                            Icons.delete,
                            color: Colors.red,
                          )
                        : Icon(
                            Icons.remove,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                  ),
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                children: [
                  _buildItemButton(
                    tooltipMessage: Tooltips.editItem,
                    onTapCallback: _editItem,
                    child: Icon(
                      Icons.edit,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  _buildItemButton(
                    tooltipMessage: Tooltips.moveItem,
                    onTapCallback: _moveItem,
                    child: Icon(
                      Icons.swap_horiz,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildItemButton(
          {double radius = 15,
          required Widget child,
          required String tooltipMessage,
          required void Function() onTapCallback}) =>
      Tooltip(
        message: tooltipMessage,
        child: GestureDetector(
          onTap: widget.disableButtons ? null : onTapCallback,
          child: _buildCircleAvatar(
            radius: radius,
            child: child,
          ),
        ),
      );

  Widget _buildCircleAvatar({required double radius, required Widget child}) =>
      CircleAvatar(
        radius: radius,
        backgroundColor:
            Theme.of(context).colorScheme.secondary.withOpacity(0.5),
        child: child,
      );

  OutlineInputBorder _buildOutlineInputBorder(
          {double opacity = 1.0, required double width}) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(
          color: Theme.of(context)
              .colorScheme
              .secondary
              .withOpacity(opacity), // Border color
          width: width, // Border width
        ),
      );

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: Transform.scale(
          scale: 1.7,
          child: Icon(
            Icons.warning_amber,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        title: Text(
          SafeDelete.buildAreYouSureMessage(itemName: widget.item.name),
          textAlign: TextAlign.center,
          softWrap: true,
          overflow: TextOverflow.fade,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
        content: TextButton(
          onPressed: _navigateToSettings,
          child: Text(
            SafeDelete.turnOffWarningMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              decoration: TextDecoration.underline,
              decorationColor: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        actionsPadding:
            const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 12.0),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          _buildDialogButton(actionType: _ActionType.cancel),
          _buildDialogButton(actionType: _ActionType.confirm),
        ],
      ),
    ).then((value) {
      if (value == null) {
        _setTextToLastSubmittedNumber();
      }
    });
  }

  void _navigateToSettings() {
    Navigator.of(context).pop(); // Close the dialog
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SettingsPage(),
      ),
    );
  }

  void _setTextToLastSubmittedNumber() {
    setState(() {
      _controller.text = widget.quantity.toString();
    });
  }

  Widget _buildDialogButton({required _ActionType actionType}) => TextButton(
        onPressed: () {
          _performActionBasedOnActionType(actionType);
          Navigator.of(context).pop(actionType); // Close the dialog
        },
        child: Text(actionType == _ActionType.cancel
            ? SafeDelete.cancel
            : SafeDelete.confirm),
      );

  void _performActionBasedOnActionType(_ActionType actionType) {
    if (actionType == _ActionType.cancel) {
      _setTextToLastSubmittedNumber();
    } else if (actionType == _ActionType.confirm) {
      widget.removeItem();
    }
  }
}

enum _ActionType { cancel, confirm }
