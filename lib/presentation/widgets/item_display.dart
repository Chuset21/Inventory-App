import 'package:flutter/material.dart';

import '../../data/models/item.dart';

class ItemDisplay extends StatefulWidget {
  final Item item;
  final int number;

  /// The focus node for the number
  final FocusNode? numberFocusNode;

  const ItemDisplay(
      {super.key,
      required this.item,
      required this.number,
      this.numberFocusNode});

  @override
  State<ItemDisplay> createState() => _ItemDisplayState();
}

class _ItemDisplayState extends State<ItemDisplay> {
  // TODO: make it so that the number that was passed in is actually edited
  late int _currentNumber;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _currentNumber = widget.number;
    _controller = TextEditingController(text: '$_currentNumber');
  }

  void _increment() {
    setState(() {
      _currentNumber++;
      _controller.text = '$_currentNumber';
    });
  }

  // TODO: make it so that the item can be deleted, when the bin is pressed
  void _decrement() {
    setState(() {
      if (_currentNumber > 0) {
        _currentNumber--;
        _controller.text = '$_currentNumber';
      }
    });
  }

  // TODO: make it so that the item can be deleted if 0 is inputted
  void _onTextChanged(String value) {
    final int? number = int.tryParse(value);
    if (number != null && number >= 0) {
      setState(() {
        _currentNumber = number;
      });
    } else {
      setState(() {
        _controller.text = '$_currentNumber';
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    widget.numberFocusNode?.dispose();
    super.dispose();
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
            controller: _controller,
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
              _controller.selection = TextSelection(
                baseOffset: 0,
                extentOffset: _controller.text.length,
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
                    child: _currentNumber <=
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
