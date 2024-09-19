import 'package:flutter/material.dart';
import 'package:inventory_app/core/constants/constants.dart';
import 'package:inventory_app/core/services/services.dart';
import 'package:inventory_app/core/utils/utils.dart';
import 'package:inventory_app/data/models/models.dart';
import 'package:inventory_app/presentation/widgets/widgets.dart';
import 'package:provider/provider.dart';

import 'add_item_page.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage(
      {super.key,
      required this.title,
      required this.getAppTheme,
      required this.onThemeUpdate});

  final String title;
  final AppTheme Function() getAppTheme;
  final Function(AppTheme) onThemeUpdate;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isSearching = false;
  bool _isFilterVisible = false;
  final TextEditingController _searchController = TextEditingController();
  String _previousSearchText = '';
  final FocusNode _searchFocusNode = FocusNode();
  Map<Item, int> items = {
    const Item(
      name: 'Broccoli',
      category: 'Vegetables',
      location: 'Upstairs Freezer',
    ): 5,
    const Item(
      name: 'Cauliflower',
      category: 'Vegetables',
      location: 'Upstairs Freezer',
    ): 2,
    const Item(
      name: 'Chicken Breast (500g)',
      category: 'Meat',
      location: 'Upstairs Freezer',
    ): 1,
    const Item(
      name: 'Ground Beef',
      category: 'Meat',
      location: 'Upstairs Freezer',
    ): 4,
    const Item(
      name: 'Bagels',
      category: 'Bread',
      location: 'Downstairs Freezer',
    ): 15,
    const Item(
      name: 'Soda Bread',
      category: 'Bread',
      location: 'Downstairs Freezer',
    ): 1,
    const Item(
      name: 'Mango',
      category: 'Fruit',
      location: 'Upstairs Freezer',
    ): 2,
    const Item(
      name: 'Strawberries',
      category: 'Fruit',
      location: 'Upstairs Freezer',
    ): 1,
    const Item(
      name: 'Raspberries',
      category: 'Fruit',
      location: 'Upstairs Freezer',
    ): 2,
    const Item(
      name: 'Mixed Berries',
      category: 'Fruit',
      location: 'Upstairs Freezer',
    ): 1,
  };

  List<String> _selectedCategories = [];
  List<String> _selectedLocations = [];

  late List<({FocusNode node, GlobalKey<ItemDisplayState> key})>
      _itemFocusNodesAndKeys;
  late SettingsModel settingsModel;

  Iterable<T> _getUniqueValuesFromItems<T>(T Function(Item) fieldExtractor) =>
      items.keys.map(fieldExtractor).toSet();

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

  @override
  void didChangeDependencies() {
    settingsModel = Provider.of<SettingsModel>(context);
    super.didChangeDependencies();
  }

  void _addItemWithState({required Item item, required int quantity}) {
    setState(() {
      _addItem(item: item, quantity: quantity);
    });
  }

  void _addItem({required Item item, required int quantity}) =>
      items.update(item, (prevValue) => prevValue + quantity,
          ifAbsent: () => quantity);

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
    for (var nodeAndKey in _itemFocusNodesAndKeys) {
      nodeAndKey.node.dispose();
    }
    super.dispose();
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
    _itemFocusNodesAndKeys = focusNodesAndKeys;

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

  Map<Item, int> _filterItems() {
    final nameSearch = _searchController.text.trim().toLowerCase();

    return Map.fromEntries(
      items.entries.where((entry) {
        final item = entry.key;

        final matchesName = item.name.toLowerCase().contains(nameSearch);
        final matchesCategory = _selectedCategories.isEmpty ||
            _selectedCategories.contains(item.category);
        final matchesLocation = _selectedLocations.isEmpty ||
            _selectedLocations.contains(item.location);

        return matchesName && matchesCategory && matchesLocation;
      }),
    );
  }

  /// Build the list view with focus nodes.
  /// Returns the list view with a reference to the focus node list too.
  /// This returns the focus nodes for the numbers as they are needed to be able to unfocus them when the user presses elsewhere on the screen.
  /// We also need to create a global key to submit the text if and when we lose focus on the node
  ({
    ListView listView,
    List<({FocusNode node, GlobalKey<ItemDisplayState> key})> focusNodesAndKeys
  }) _buildItemListViewWithFocusNodesAndKeys(Map<Item, int> items) {
    // Group items by their category
    final Map<String, List<MapEntry<Item, int>>> groupedItems =
        items.entries.fold(
      {},
      (map, entry) => map..putIfAbsent(entry.key.category, () => []).add(entry),
    );

    final sortedCategories = groupedItems.keys.toList()..sort();

    // Create a list of FocusNodes and GlobalKeys
    final focusNodesAndKeys = List.generate(
      items.length,
      (index) => (node: FocusNode(), key: GlobalKey<ItemDisplayState>()),
      growable: false,
    );

    // Build the list of widgets
    final List<Widget> itemWidgets = [];

    int focusNodeAndKeyIndex = 0;

    // Add widgets for each category in sorted order
    for (String category in sortedCategories) {
      // Sort by name
      final entries = groupedItems[category]!
        ..sort((a, b) => a.key.name.compareTo(b.key.name));

      // Add the section header
      itemWidgets.add(_buildHeader(category));

      // Add the items under the section
      for (MapEntry<Item, int> entry in entries) {
        final item = entry.key;
        final quantity = entry.value;

        itemWidgets.add(
          Column(
            children: [
              ItemDisplay(
                key: focusNodesAndKeys[focusNodeAndKeyIndex].key,
                isSafeDeleteOn: () => settingsModel.isSafeDeleteOn,
                onSafeDeleteUpdate: settingsModel.updateSafeDelete,
                getAppTheme: widget.getAppTheme,
                onThemeUpdate: widget.onThemeUpdate,
                existingNames: _existingNames,
                existingCategories: _existingCategories,
                existingLocations: _existingLocations,
                item: item,
                quantity: quantity,
                numberFocusNode: focusNodesAndKeys[focusNodeAndKeyIndex].node,
                setItemNumber: (itemNumber) {
                  setState(() {
                    items.update(item, (oldValue) => itemNumber);
                  });
                },
                removeItem: () {
                  setState(() {
                    items.remove(item);
                  });
                },
                editItem: (
                    {required Item updatedItem, required int updatedQuantity}) {
                  setState(() {
                    items.remove(item);
                    _addItem(item: updatedItem, quantity: updatedQuantity);
                  });
                },
                moveItem: ({
                  required String newLocation,
                  required int quantityToMove,
                }) {
                  setState(() {
                    // First update the existing item
                    if (quantityToMove == quantity) {
                      items.remove(item);
                    } else {
                      items.update(
                          item, (oldValue) => oldValue - quantityToMove);
                    }
                    // Next update the item with the new location
                    items.update(item.copyWith(location: newLocation),
                        (oldValue) => oldValue + quantityToMove,
                        ifAbsent: () => quantityToMove);
                  });
                },
              ),
              Divider(
                height: 10.0,
                thickness: 1,
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
              ),
            ],
          ),
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

  Widget _buildHeader(String category) {
    return Padding(
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
  }

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
        builder: (buildContext) => SettingsPage(
          getAppTheme: widget.getAppTheme,
          onThemeUpdate: widget.onThemeUpdate,
          isSafeDeleteOn: () => settingsModel.isSafeDeleteOn,
          onSafeDeleteUpdate: settingsModel.updateSafeDelete,
        ),
      ),
    );
  }
}
