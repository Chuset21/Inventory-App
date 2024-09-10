import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';

class FilterDropdown<T> extends StatelessWidget {
  final List<T> initialSelectedItems;
  final List<T> dropdownOptions;
  final Function(List<T>) onSelectedItemsUpdated;
  final String? noResultsFoundText;
  final String? hintText;

  const FilterDropdown({
    super.key,
    required this.dropdownOptions,
    required this.onSelectedItemsUpdated,
    this.initialSelectedItems = const [],
    this.noResultsFoundText,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    final secondaryTextStyle = TextStyle(
      color: Theme.of(context).colorScheme.secondary,
    );
    final secondaryHintStyle = TextStyle(
      color: Theme.of(context).colorScheme.secondary.withOpacity(0.8),
    );
    final headerStyle = secondaryTextStyle.copyWith(fontSize: 18.0);
    final headerHintStyle = secondaryHintStyle.copyWith(fontSize: 18.0);

    return CustomDropdown<T>.multiSelectSearch(
      initialItems: initialSelectedItems,
      items: dropdownOptions.toList(),
      onListChanged: onSelectedItemsUpdated,
      noResultFoundText: noResultsFoundText,
      hintText: hintText,
      searchHintText: hintText,
      validateOnChange: false,
      hideSelectedFieldWhenExpanded: true,
      closeDropDownOnClearFilterSearch: true,
      decoration: CustomDropdownDecoration(
        closedFillColor: Theme.of(context).colorScheme.primaryContainer,
        expandedFillColor: Theme.of(context).colorScheme.primaryContainer,
        listItemDecoration: ListItemDecoration(
          selectedColor: Theme.of(context).colorScheme.primaryContainer,
          selectedIconColor: Theme.of(context).colorScheme.primary,
          highlightColor: Theme.of(context).colorScheme.secondaryContainer,
        ),
        searchFieldDecoration: SearchFieldDecoration(
          fillColor: Theme.of(context).colorScheme.primaryContainer,
          textStyle: secondaryTextStyle,
          hintStyle: secondaryHintStyle,
        ),
        errorStyle: secondaryTextStyle,
        listItemStyle: secondaryTextStyle,
        noResultFoundStyle: secondaryTextStyle,
        headerStyle: headerStyle,
        hintStyle: headerHintStyle,
      ),
    );
  }
}
