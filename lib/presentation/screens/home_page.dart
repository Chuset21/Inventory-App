import 'package:flutter/material.dart';
import 'package:inventory_app/core/constants/constants.dart';
import 'package:inventory_app/data/models/models.dart';
import 'package:inventory_app/presentation/widgets/widgets.dart';

import 'add_item_page.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isSearching = false;
  bool _isFilterVisible = false;
  final TextEditingController _searchController = TextEditingController();
  String _previousSearchText = '';
  final FocusNode _searchFocusNode = FocusNode();
  List<Item> items = [
    const Item(
      name: 'Broccoli',
      category: 'Vegetables',
      location: 'Upstairs Freezer',
      quantity: 5,
    ),
    const Item(
      name: 'Cauliflower',
      category: 'Vegetables',
      location: 'Upstairs Freezer',
      quantity: 2,
    ),
    const Item(
      name: 'Chicken Breast (500g)',
      category: 'Meat',
      location: 'Upstairs Freezer',
      quantity: 1,
    ),
    const Item(
      name: 'Ground Beef',
      category: 'Meat',
      location: 'Upstairs Freezer',
      quantity: 4,
    ),
    const Item(
      name: 'Bagels',
      category: 'Bread',
      location: 'Downstairs Freezer',
      quantity: 15,
    ),
    const Item(
      name: 'Soda Bread',
      category: 'Bread',
      location: 'Downstairs Freezer',
      quantity: 1,
    ),
    const Item(
      name: 'Mango',
      category: 'Fruit',
      location: 'Upstairs Freezer',
      quantity: 2,
    ),
    const Item(
      name: 'Strawberries',
      category: 'Fruit',
      location: 'Upstairs Freezer',
      quantity: 1,
    ),
    const Item(
      name: 'Raspberries',
      category: 'Fruit',
      location: 'Upstairs Freezer',
      quantity: 2,
    ),
    const Item(
      name: 'Mixed Berries',
      category: 'Fruit',
      location: 'Upstairs Freezer',
      quantity: 1,
    ),
  ];

  List<String> _selectedCategories = [];
  List<String> _selectedLocations = [];

  List<({FocusNode node, GlobalKey<ItemDisplayState> key})>
      _itemFocusNodesAndKeys = [];

  Iterable<T> _getUniqueValuesFromItems<T>(T Function(Item) fieldExtractor) =>
      items.map(fieldExtractor).toSet();

  Iterable<String> get _existingCategories =>
      _getUniqueValuesFromItems((item) => item.category);

  Iterable<String> get _existingLocations =>
      _getUniqueValuesFromItems((item) => item.location);

  Iterable<String> get _existingNames =>
      _getUniqueValuesFromItems((item) => item.name);

  void _searchControllerListener() {
    final currentText = _searchController.text.trim().toLowerCase();
    if (_previousSearchText != currentText) {
      setState(() {});
    }
    _previousSearchText = currentText;
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_searchControllerListener);
  }

  void _addItemWithState({required Item item}) {
    setState(() {
      _addItem(newItem: item);
    });
  }

  void _addItem({required Item newItem}) {
    final existingItemIndex = _getItemIndex(newItem);

    if (existingItemIndex >= 0) {
      // Item exists
      final existingItem = items[existingItemIndex];
      final updatedItem = existingItem.copyWith(
          quantity: existingItem.quantity + newItem.quantity);
      _updateItemAtIndex(existingItemIndex, updatedItem);
    } else {
      items.add(newItem);
    }
  }

  void _updateItemAtIndex(int existingItemIndex, Item newItem) {
    items[existingItemIndex] = newItem;
  }

  void _setItemQuantity(
      {required Item itemToUpdate, required int newQuantity}) {
    final existingItemIndex = _getItemIndex(itemToUpdate);

    if (existingItemIndex != -1) {
      // Update the item's quantity
      final existingItem = items[existingItemIndex];
      final updatedItem = existingItem.copyWith(quantity: newQuantity);
      _updateItemAtIndex(existingItemIndex, updatedItem);
    }
  }

  // Returns the item index of a matching item, if the item is not present, returns -1
  int _getItemIndex(Item newItem) => items.indexWhere((item) =>
      item.name == newItem.name &&
      item.category == newItem.category &&
      item.location == newItem.location);

  void _unfocusAndSubmitItemNodes() {
    // Unfocus each item focus node
    for (var nodeAndKey in _itemFocusNodesAndKeys) {
      // If we are losing focus then submit the current text
      if (nodeAndKey.node.hasFocus) {
        nodeAndKey.key.currentState?.submitText();
      }
      nodeAndKey.node.unfocus();
    }
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _clearAllFilters();
        _isFilterVisible = false;
        _searchFocusNode.unfocus();
      } else {
        _unfocusAndSubmitItemNodes();
        _searchFocusNode.requestFocus();
      }
    });
  }

  void _toggleFilterVisibility() {
    setState(() {
      _isFilterVisible = !_isFilterVisible;
    });
  }

  void _clearAllFilters() {
    _searchController.clear();
    _selectedCategories.clear();
    _selectedLocations.clear();
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _searchController.removeListener(_searchControllerListener);
    _searchController.dispose();
    _disposeItemFocusNodes();
    super.dispose();
  }

  void _disposeItemFocusNodes() {
    for (var nodeAndKey in _itemFocusNodesAndKeys) {
      nodeAndKey.node.dispose();
    }
  }

  // This function should be used whenever setting the _itemFocusNodesAndKeys
  // To avoid memory leaks _itemFocusNodesAndKeys should never be set outside this function
  void _setItemFocusNodesAndKeys(
      List<({GlobalKey<ItemDisplayState> key, FocusNode node})>
          focusNodesAndKeys) {
    // First dispose of the previous item focus nodes and keys
    _disposeItemFocusNodes();
    _itemFocusNodesAndKeys = focusNodesAndKeys;
  }

  void _updateSelectedCategories(List<String> newSelectedCategories) {
    setState(() {
      _selectedCategories = newSelectedCategories;
    });
  }

  void _updateSelectedLocations(List<String> newSelectedLocations) {
    setState(() {
      _selectedLocations = newSelectedLocations;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredItems = _isFilterEmpty ? items : _filterItems();
    final numberOfItems = filteredItems.length;

    final (:listView, :focusNodesAndKeys) =
        _buildItemListViewWithFocusNodesAndKeys(filteredItems);
    final itemListView = listView;
    _setItemFocusNodesAndKeys(focusNodesAndKeys);

    return GestureDetector(
      onTap: () {
        _searchFocusNode.unfocus();
        _unfocusAndSubmitItemNodes();
      },
      child: Scaffold(
        appBar: DefaultAppBar(
          title: Text(widget.title),
          actions: [
            IconButton(
              tooltip:
                  _isSearching ? Tooltips.closeSearch : Tooltips.openSearch,
              icon: Icon(_isSearching ? Icons.close : Icons.search),
              onPressed: _toggleSearch,
            ),
          ],
        ),
        drawer: BurgerMenu(
          navigateToHome: _navigateToHomePage,
          navigateToSettings: _navigateToSettingsPage,
        ),
        body: Column(
          children: [
            // Conditionally render the search bar
            if (_isSearching)
              Container(
                color: Theme.of(context).colorScheme.primary,
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            textCapitalization: TextCapitalization.sentences,
                            controller: _searchController,
                            focusNode: _searchFocusNode,
                            autofocus: true,
                            decoration: InputDecoration(
                              hintText: FilterMessages.searchHint,
                              hintStyle: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondary
                                    .withOpacity(0.8),
                                fontSize: 18.0,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                            ),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                        _buildFilterButton(),
                      ],
                    ),
                    if (_isFilterVisible)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Column(
                          children: [
                            FilterDropdown(
                              initialSelectedItems: _selectedCategories,
                              dropdownOptions: _existingCategories.toList(),
                              onSelectedItemsUpdated: _updateSelectedCategories,
                              noResultsFoundText:
                                  FilterMessages.noCategoryFound,
                              hintText: FilterMessages.categoryFilterHint,
                            ),
                            const SizedBox(
                              height: 12.0,
                            ),
                            FilterDropdown(
                              initialSelectedItems: _selectedLocations,
                              dropdownOptions: _existingLocations.toList(),
                              onSelectedItemsUpdated: _updateSelectedLocations,
                              noResultsFoundText:
                                  FilterMessages.noLocationFound,
                              hintText: FilterMessages.locationFilterHint,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            // The rest of the body content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: items.isEmpty
                    ? const Center(
                        child: EmptyInventory(
                          mainMessage: Messages.emptyInventory,
                          suggestionMessage: Messages.addItemsSuggestion,
                        ),
                      )
                    : (_isSearching && numberOfItems == 0
                        ? const Center(
                            child: EmptyInventory(
                              mainMessage: Messages.emptySearch,
                              suggestionMessage:
                                  Messages.refineSearchSuggestion,
                            ),
                          )
                        : itemListView),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddItemPage(
                  addItemCallback: _addItemWithState,
                  existingNames: _existingNames,
                  existingCategories: _existingCategories,
                  existingLocations: _existingLocations,
                ),
              ),
            );
          },
          tooltip: Tooltips.addButton,
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).canvasColor,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  static const _filterRotationDuration = Duration(milliseconds: 400);
  static const _badgeOpacityAnimationDuration = Duration(milliseconds: 400);

  Widget _buildFilterButton() => Stack(
        // Ensure badge can go outside the button's bounds
        clipBehavior: Clip.none,
        children: [
          AnimatedRotation(
            turns: _isFilterVisible ? 0.5 : 0.0,
            // Rotate 180 degrees when filter is visible
            duration: _filterRotationDuration,
            child: IconButton(
              tooltip: _isFilterVisible
                  ? Tooltips.hideAdvancedFilter
                  : Tooltips.openAdvancedFilter,
              icon: const Icon(
                Icons.filter_list,
              ),
              color: Theme.of(context).colorScheme.primaryContainer,
              onPressed: _toggleFilterVisibility,
            ),
          ),

          // Only show badge if there are active filters and the filter is not visible
          Positioned(
            right: 2,
            top: 1,
            child: AnimatedOpacity(
              opacity:
                  (_activeFiltersCount > 0 && !_isFilterVisible) ? 1.0 : 0.0,
              duration: _badgeOpacityAnimationDuration,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(
                  minWidth: 20,
                  minHeight: 20,
                ),
                child: Center(
                  child: Text(
                    _activeFiltersCount.toString(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ],
      );

  bool get isSearchControllerEmpty => _searchController.text.trim().isEmpty;

  bool get _isFilterEmpty =>
      isSearchControllerEmpty &&
      _selectedCategories.isEmpty &&
      _selectedLocations.isEmpty;

  int get _activeFiltersCount =>
      _selectedCategories.length + _selectedLocations.length;

  Iterable<Item> _filterItems() {
    final nameSearch = _searchController.text.trim().toLowerCase();

    return items.where((item) {
      final matchesName = item.name.toLowerCase().contains(nameSearch);
      final matchesCategory = _selectedCategories.isEmpty ||
          _selectedCategories.contains(item.category);
      final matchesLocation = _selectedLocations.isEmpty ||
          _selectedLocations.contains(item.location);

      return matchesName && matchesCategory && matchesLocation;
    });
  }

  // TODO: lazily build this list, as this is causing a lot of lag, especially apparent when switching themes
  /// Build the list view with focus nodes.
  /// Returns the list view with a reference to the focus node list too.
  /// This returns the focus nodes for the numbers as they are needed to be able to unfocus them when the user presses elsewhere on the screen.
  /// We also need to create a global key to submit the text if and when we lose focus on the node
  ({
    ListView listView,
    List<({FocusNode node, GlobalKey<ItemDisplayState> key})> focusNodesAndKeys
  }) _buildItemListViewWithFocusNodesAndKeys(Iterable<Item> itemsToShow) {
    // Group items by their category
    final Map<String, List<Item>> groupedItems = itemsToShow.fold(
      {},
      (map, item) => map..putIfAbsent(item.category, () => []).add(item),
    );

    final sortedCategories = groupedItems.keys.toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

    // Create a list of FocusNodes and GlobalKeys
    final focusNodesAndKeys = List.generate(
      itemsToShow.length,
      (index) => (node: FocusNode(), key: GlobalKey<ItemDisplayState>()),
      growable: false,
    );

    // Build the list of widgets
    final List<Widget> itemWidgets = [];

    int focusNodeAndKeyIndex = 0;

    // Add widgets for each category in sorted order
    for (String category in sortedCategories) {
      // Sort by name
      final items = groupedItems[category]!
        ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

      // Add the section header
      itemWidgets.add(_buildHeader(category));

      // Add the items under the section
      for (Item item in items) {
        itemWidgets.add(
          _buildListItem(focusNodesAndKeys[focusNodeAndKeyIndex].key,
              focusNodesAndKeys[focusNodeAndKeyIndex].node, item),
        );
        focusNodeAndKeyIndex++;
      }
      // Add some spacing before the next heading
      itemWidgets.add(const SizedBox(
        height: 5,
      ));
    }
    // Add some padding at the bottom of the list to ensure that the
    // 'add item' button doesn't obscure the last item's controls
    itemWidgets.add(const SizedBox(
      height: 90,
    ));

    return (
      listView: ListView(
        children: itemWidgets,
      ),
      focusNodesAndKeys: focusNodesAndKeys,
    );
  }

  Widget _buildListItem(
          GlobalKey<ItemDisplayState> key, FocusNode node, Item item) =>
      Column(
        children: [
          ItemDisplay(
            key: key,
            existingNames: _existingNames,
            existingCategories: _existingCategories,
            existingLocations: _existingLocations,
            item: item,
            numberFocusNode: node,
            setItemNumber: (itemNumber) {
              setState(() {
                _setItemQuantity(itemToUpdate: item, newQuantity: itemNumber);
              });
            },
            removeItem: () {
              setState(() {
                _removeItem(item);
              });
            },
            editItem: ({required Item updatedItem}) {
              setState(() {
                _editItem(item, updatedItem);
              });
            },
            moveItem: ({
              required String newLocation,
              required int quantityToMove,
            }) {
              setState(() {
                _moveItem(quantityToMove, item, newLocation);
              });
            },
          ),
          Divider(
            height: 10.0,
            thickness: 1,
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
          ),
        ],
      );

  void _moveItem(int quantityToMove, Item item, String newLocation) {
    // First update the existing item
    if (quantityToMove == item.quantity) {
      _removeItem(item);
    } else {
      _setItemQuantity(
          itemToUpdate: item, newQuantity: item.quantity - quantityToMove);
    }
    // Next update the item with the new location
    _addItem(
      newItem: item.copyWith(
          location: newLocation,
          quantity: quantityToMove,
          // Make sure that ID is null to avoid possible ID collision
          // If we didn't do this and the item wasn't completely removed before this
          // we could have two different items with the same ID
          id: null),
    );
  }

  void _editItem(Item item, Item updatedItem) {
    _removeItem(item);
    _addItem(newItem: updatedItem.copyWith(id: item.id));
  }

  void _removeItem(Item item) {
    items.remove(item);
  }

  Widget _buildHeader(String category) => Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              category,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            Divider(
              height: 8.0,
              thickness: 3.5,
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
          ],
        ),
      );

  void _navigateToHomePage() {
    // Simply close the burger menu
    Navigator.pop(context);
  }

  void _navigateToSettingsPage() {
    // Close the burger menu
    Navigator.pop(context);
    // Navigate to the settings page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (buildContext) => const SettingsPage(),
      ),
    );
  }
}
