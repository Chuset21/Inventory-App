import 'package:flutter/material.dart';

import '../../data/models/item.dart';

class ItemDisplay extends StatefulWidget {
  final Item item;
  final int number;
  final Function(int) setItemNumber;
  final Function() removeItem;

  /// The focus node for the number
  final FocusNode? numberFocusNode;

  late final TextEditingController _controller;

  ItemDisplay(
      {super.key,
      required this.item,
      required this.number,
      required this.setItemNumber,
      required this.removeItem,
      this.numberFocusNode}) {
    _controller = TextEditingController(text: number.toString());
  }

  @override
  State<ItemDisplay> createState() => ItemDisplayState();
}

class ItemDisplayState extends State<ItemDisplay> {
  late int _lastValidNumber;

  @override
  void initState() {
    super.initState();
    _lastValidNumber = widget.number;
  }

  @override
  void dispose() {
    widget.numberFocusNode?.dispose();
    widget._controller.dispose();
    super.dispose();
  }

  void submitText() {
    _onSubmitted(widget._controller.text);
  }

  void setTextToLastValidNumber() {
    // Revert to the last valid number if the input is invalid
    widget._controller.text = _lastValidNumber.toString();
    // Move the cursor to the end of the text
    widget._controller.selection = TextSelection.fromPosition(
      TextPosition(offset: widget._controller.text.length),
    );
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
    } else {
      // TODO: Maybe show message about being sure to delete?
      widget.removeItem();
    }
  }

  void _onSubmitted(String value) {
    final int? number = int.tryParse(value);
    if (number != null && number > 0) {
      widget.setItemNumber(number);
    } else if (number == 0) {
      // TODO: Maybe show message about being sure to delete?
      widget.removeItem();
    } else {
      setTextToLastValidNumber();
    }
  }

  void _onTextChanged(String value) {
    final int? number = int.tryParse(value);
    if (number == null || number < 0) {
      setTextToLastValidNumber();
    } else {
      widget._controller.text = number.toString();
      _lastValidNumber = number;
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
            // Add data validation here, only allow numbers >= 0
            controller: widget._controller,
            focusNode: widget.numberFocusNode,
            keyboardType: TextInputType.number,
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
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                // Adjust radius for rounded corners
                borderSide: BorderSide(
                  color: Theme.of(context)
                      .colorScheme
                      .secondary, // Border color when focused
                  width: 2.0, // Border width when focused
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                // Adjust radius for rounded corners
                borderSide: BorderSide(
                  color: Theme.of(context)
                      .colorScheme
                      .secondary
                      .withOpacity(0.5), // Border color
                  width: 1.0, // Border width
                ),
              ),
            ),
            onTap: () {
              widget._controller.selection = TextSelection(
                baseOffset: 0,
                extentOffset: widget._controller.text.length,
              ); // Select all text when tapped
            },
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
          child: Column(
            children: [
              GestureDetector(
                onTap: _increment,
                child: CircleAvatar(
                  radius: 15, // Adjust the size of the circle
                  backgroundColor:
                      Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                  child: Icon(
                    Icons.add,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: _decrement,
                child: CircleAvatar(
                    radius: 15, // Adjust the size of the circle
                    backgroundColor: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.5),
                    child: widget.number <=
                            1 // Show a bin if there is only one item remaining
                        ? const Icon(
                            Icons.delete,
                            color: Colors.red,
                          )
                        : Icon(
                            Icons.remove,
                            color: Theme.of(context).colorScheme.primary,
                          )),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
