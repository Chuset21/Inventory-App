import 'package:flutter/material.dart';

class CustomDropdownMenu extends StatelessWidget {
  const CustomDropdownMenu({
    super.key,
    required this.controller,
    this.initialSelection,
    required this.focusNode,
    this.nextFocusNode,
    required this.helperText,
    required this.label,
    required this.menuEntries,
  });

  final TextEditingController controller;
  final String? initialSelection;
  final FocusNode focusNode;
  final FocusNode? nextFocusNode;
  final String helperText;
  final String label;
  final Iterable<String> menuEntries;

  // Can't seem to bring up the keyboard capitalised in menus
  @override
  Widget build(BuildContext context) {
    final dropdownMenuEntries = _buildDropdownMenuEntries(
      menuEntries: menuEntries,
      currentText: controller.text,
    );

    return DropdownMenu<String>(
      initialSelection: initialSelection,
      expandedInsets: EdgeInsets.zero,
      helperText: helperText,
      requestFocusOnTap: true,
      menuHeight: dropdownMenuEntries.isEmpty ? 0 : null,
      focusNode: focusNode,
      controller: controller,
      onSelected: (value) {
        focusNode.unfocus();
        nextFocusNode?.requestFocus();
      },
      dropdownMenuEntries: dropdownMenuEntries,
      label: Text(label),
    );
  }
}

/// Builds and filters dropdown menu entries based on the user's input.
///
/// This function takes the current input text and the list of existing menu
/// entries, and returns a filtered list of `DropdownMenuEntry<String>` objects.
/// It performs the following steps:
///
/// 1. Maps the `menuEntries` iterable to `DropdownMenuEntry<String>` items.
/// 2. If the user input (filter) is empty, it returns all menu entries without filtering.
/// 3. If the filter is non-empty, it converts the input to lowercase and returns a list
///    of entries whose labels contain the input as a substring.
/// 4. If the exact filter text is not found in the entries, it adds the filter text
///    as a new option.
///
/// This approach allows users to select an existing option or add a new one if needed.
///
/// - Parameters:
///   - `menuEntries`: A collection of existing options.
///   - `currentText`: The current text entered by the user for filtering the dropdown.
///
/// - Returns: A list of `DropdownMenuEntry<String>` that includes filtered existing
///   entries and potentially the user's input as a new option if no exact match is found.
List<DropdownMenuEntry<String>> _buildDropdownMenuEntries({
  required Iterable<String> menuEntries,
  required String currentText,
}) {
  final mappedMenuEntries = menuEntries.map((value) => DropdownMenuEntry(
        value: value,
        label: value,
      ));

  final trimmedFilter = currentText.trim();

  // If the filter text is empty, return all mapped menu entries
  if (trimmedFilter.isEmpty) {
    return mappedMenuEntries.toList();
  }

  final lowercaseText = trimmedFilter.toLowerCase();

  // Filter the mapped entries where the label contains the filter text
  final result = mappedMenuEntries
      .where(
        (entry) => entry.label.toLowerCase().contains(lowercaseText),
      )
      .toList();

  // If none of the existing entries exactly match the filter text, add it as a new entry
  if (result
      .every((entry) => entry.label.trim().toLowerCase() != lowercaseText)) {
    result.add(DropdownMenuEntry(
      value: trimmedFilter,
      label: trimmedFilter,
    ));
  }

  return result;
}
