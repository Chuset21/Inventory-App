import 'package:flutter/material.dart';
import 'package:inventory_app/core/constants/strings.dart';
import 'package:inventory_app/presentation/screens/edit_item_page.dart';
import 'package:inventory_app/presentation/screens/move_item_page.dart';

import '../../core/utils/app_theme.dart';
import '../../core/utils/widget_utils.dart';
import '../../data/models/item.dart';
import '../screens/settings_page.dart';

class ItemDisplay extends StatefulWidget {
  final Iterable<String> existingNames;
  final Iterable<String> existingCategories;
  final Iterable<String> existingLocations;
  final Item item;
  final int quantity;
  final Function(int) setItemNumber;
  final Function() removeItem;
  final void Function({required Item updatedItem, required int updatedQuantity})
      editItem;
  final void Function(
      {required String newLocation, required int quantityToMove}) moveItem;
  final AppTheme Function() getAppTheme;
  final Function(AppTheme) onThemeUpdate;
  final bool Function() isSafeDeleteOn;
  final Function(bool) onSafeDeleteUpdate;

  /// The focus node for the number
  final FocusNode? numberFocusNode;

  late final TextEditingController _controller;

  ItemDisplay(
      {super.key,
      required this.existingNames,
      required this.existingCategories,
      required this.existingLocations,
      required this.item,
      required this.quantity,
      required this.setItemNumber,
      required this.removeItem,
      required this.editItem,
      required this.moveItem,
      required this.getAppTheme,
      required this.onThemeUpdate,
      required this.isSafeDeleteOn,
      required this.onSafeDeleteUpdate,
      this.numberFocusNode}) {
    _controller = TextEditingController(text: quantity.toString());
  }

  @override
  State<ItemDisplay> createState() => ItemDisplayState();
}

class ItemDisplayState extends State<ItemDisplay> {
  late int _lastValidNumber;

  @override
  void initState() {
    super.initState();
    _lastValidNumber = widget.quantity;
  }

  void submitText() {
    _onSubmitted(widget._controller.text);
  }

  void _setTextToLastValidNumber() {
    setState(() {
      // Revert to the last valid number if the input is invalid
      widget._controller.text = _lastValidNumber.toString();
      // Move the cursor to the end of the text
      widget._controller.selection = TextSelection.fromPosition(
        TextPosition(offset: widget._controller.text.length),
      );
    });
  }

  int? _getControllerNumber() {
    final text = widget._controller.text;
    return int.tryParse(text);
  }

  void _increment() {
    int controllerNumber = _getControllerNumber() ?? 0;
    widget.setItemNumber(controllerNumber + 1);
  }

  void _decrement() {
    int controllerNumber = _getControllerNumber() ?? 0;
    if (controllerNumber > 1) {
      widget.setItemNumber(controllerNumber - 1);
    } else if (widget.isSafeDeleteOn()) {
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

  void _onSubmitted(String value) {
    final int? number = int.tryParse(value);
    if (number != null && number > 0) {
      widget.setItemNumber(number);
    } else if (number == 0) {
      if (widget.isSafeDeleteOn()) {
        _showDeleteConfirmationDialog();
      } else {
        widget.removeItem();
      }
    } else {
      _setTextToLastValidNumber();
    }
  }

  void _onTextChanged(String value) {
    final int? number = int.tryParse(value);
    if (number == null || number < 0) {
      _setTextToLastValidNumber();
    } else {
      setState(() {
        widget._controller.text = number.toString();
        _lastValidNumber = number;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 50,
          // For now it will have a fixed width, TODO: make it flexible
          child: TextField(
            controller: widget._controller,
            focusNode: widget.numberFocusNode,
            keyboardType: const TextInputType.numberWithOptions(
                signed: false, decimal: false),
            textAlign: TextAlign.center,
            textAlignVertical: TextAlignVertical.center,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.secondary,
            ),
            onChanged: _onTextChanged,
            onSubmitted: _onSubmitted,
            decoration: InputDecoration(
              isDense: true,
              focusedBorder: _buildOutlineInputBorder(width: 2.0),
              enabledBorder: _buildOutlineInputBorder(opacity: 0.5, width: 1.0),
            ),
            onTap: () => selectAllText(widget._controller),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              widget.item.name,
              style: TextStyle(
                fontSize: 18.0,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              overflow: TextOverflow.ellipsis,
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
                    onTapCallback: _decrement,
                    child: (_getControllerNumber() ?? 0) <= 1
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
          required void Function() onTapCallback}) =>
      GestureDetector(
        onTap: onTapCallback,
        child: _buildCircleAvatar(
          radius: radius,
          child: child,
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
        // Hint about turning off the warning message
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
      // If the value is null, then that means that Navigator.of(context).pop() was called with no value
      // This means that the dialog was dismissed
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
        builder: (context) => SettingsPage(
          getAppTheme: widget.getAppTheme,
          onThemeUpdate: widget.onThemeUpdate,
          isSafeDeleteOn: widget.isSafeDeleteOn,
          onSafeDeleteUpdate: widget.onSafeDeleteUpdate,
        ),
      ),
    );
  }

  void _setTextToLastSubmittedNumber() {
    setState(() {
      widget._controller.text = widget.quantity.toString();
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
