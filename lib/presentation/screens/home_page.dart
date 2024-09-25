import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_app/core/constants/constants.dart';
import 'package:inventory_app/core/providers/providers.dart';
import 'package:inventory_app/core/utils/utils.dart';
import 'package:inventory_app/data/models/models.dart';
import 'package:inventory_app/presentation/widgets/widgets.dart';

import 'add_item_page.dart';
import 'settings_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key, required this.title, required this.initialItems});

  final String title;
  final List<Item> initialItems;
  static const initialSecondsUntilRetry = 10;

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  bool _isSearching = false;
  bool _isFilterVisible = false;
  final TextEditingController _searchController = TextEditingController();
  String _previousSearchText = '';
  final FocusNode _searchFocusNode = FocusNode();
  late List<Item> _items;
  int _secondsUntilRetry = HomePage.initialSecondsUntilRetry;
  bool _isDisconnected = false;

  int get _retryTimeout => _secondsUntilRetry;

  List<String> _selectedCategories = [];
  List<String> _selectedLocations = [];

  List<({FocusNode node, GlobalKey<ItemDisplayState> key})>
      _itemFocusNodesAndKeys = [];

  Iterable<T> _getUniqueValuesFromItems<T>(T Function(Item) fieldExtractor) =>
      _items.map(fieldExtractor).toSet();

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

  Function _onErrorCallBackBuilder(
          {required ErrorInfo errorInfo, int secondsToShow = 5}) =>
      () => showErrorSnackBar(context, errorInfo, secondsToShow: secondsToShow);

  @override
  void initState() {
    super.initState();
    _items = widget.initialItems;
    _searchController.addListener(_searchControllerListener);

    // Wait for the first build cycle to complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Get the repository from the provider
      _setupItemListener();
    });
  }

  void _setupItemListener() {
    final itemRepo = ref.watch(Repository.databases);

    // Listen to real-time updates
    itemRepo.listenToItems(
      onItemsUpdated: (updatedItems) {
        setState(() {
          _items = updatedItems.toList();
        });
      },
      onErrorCallback: _onErrorCallBackBuilder(
        errorInfo:
            ErrorInfo(message: SnackBarMessages.errorFetchingRealTimeData),
      ),
      // TODO: fix Concurrent modification during iteration: Instance of 'IdentityMap<int, RealtimeSubscription>' error
      onLostConnectionCallback: _retryFetchingItems,
    );
  }

  void _retryFetchingItems() {
    setState(() {
      _isDisconnected = true;
    });

    Future.delayed(Duration(seconds: _retryTimeout), () {
      // Double the retry timeout for the next attempt
      _secondsUntilRetry *= 2;

      // Fetch items asynchronously
      ref.read(Repository.databases).getItems().then(
        (result) {
          setState(() {
            _items = result.toList();
            _secondsUntilRetry =
                HomePage.initialSecondsUntilRetry; // Reset on success
            _isDisconnected = false;
          });
          if (context.mounted && mounted) {
            showMessageSnackBar(
                context, SnackBarMessages.successfulDatabaseReconnection,
                backgroundColor: Colors.green[200]);
          }
          _setupItemListener(); // Start listening for real-time updates
        },
        onError: (o, st) {
          // Recursively retry on error
          _retryFetchingItems();
        },
      );
    });

    // Show the error message
    _onErrorCallBackBuilder(
      errorInfo: ErrorInfo(
        message: SnackBarMessages.buildLostConnectionMessage(
            secondsToRetry: _retryTimeout),
      ),
      secondsToShow: _retryTimeout,
    )();
  }

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
    ref.read(Repository.databases).cancelSubscription();
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
    final filteredItems = _isFilterEmpty ? _items : _filterItems();
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
                child: _items.isEmpty
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
          onPressed: _isDisconnected
              ? null
              : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddItemPage(
                        addItemCallback: _addItem,
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

    return _items.where((item) {
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

  Widget _buildListItem(
          GlobalKey<ItemDisplayState> key, FocusNode node, Item item) =>
      Column(
        children: [
          ItemDisplay(
            disableButtons: _isDisconnected,
            key: key,
            existingNames: _existingNames,
            existingCategories: _existingCategories,
            existingLocations: _existingLocations,
            item: item,
            numberFocusNode: node,
            setItemNumber: (itemNumber) {
              _setItemQuantity(itemToUpdate: item, newQuantity: itemNumber);
            },
            removeItem: () {
              _removeItem(item);
            },
            editItem: ({required Item updatedItem}) {
              _editItem(item, updatedItem);
            },
            moveItem: ({
              required String newLocation,
              required int quantityToMove,
            }) {
              _moveItem(quantityToMove, item, newLocation);
            },
          ),
          Divider(
            height: 10.0,
            thickness: 1,
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
          ),
        ],
      );

  void _addItem({required Item newItem}) {
    final existingItem = _tryGetItem(newItem);

    if (existingItem != null) {
      final updatedItem = existingItem.copyWith(
          quantity: existingItem.quantity + newItem.quantity);
      _updateItem(existingItem: existingItem, newItem: updatedItem);
    } else {
      final itemToAdd = newItem.copyWith(id: uniqueId);
      // Add the item to the database
      ref.read(Repository.databases).addItem(
            item: itemToAdd,
            onErrorCallback: _databaseUpdateErrorCallback,
          );
    }
  }

  void _updateItem({required Item existingItem, required Item newItem}) {
    // Update the item in the database
    ref.read(Repository.databases).updateItem(
          oldItemId: existingItem.id,
          updatedItem: newItem,
          onErrorCallback: _databaseUpdateErrorCallback,
        );
  }

  void _setItemQuantity(
      {required Item itemToUpdate, required int newQuantity}) {
    final existingItem = _tryGetItem(itemToUpdate);

    if (existingItem != null) {
      // Update the item's quantity
      final updatedItem = existingItem.copyWith(quantity: newQuantity);
      _updateItem(existingItem: existingItem, newItem: updatedItem);
    }
  }

  Item? _tryGetItem(Item newItem) {
    for (final item in _items) {
      if (item.name == newItem.name &&
          item.category == newItem.category &&
          item.location == newItem.location) {
        return item; // Return the found item
      }
    }
    return null;
  }

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
      newItem: item.copyWith(location: newLocation, quantity: quantityToMove),
    );
  }

  void _editItem(Item prevItem, Item newItem) {
    final existingItem = _tryGetItem(newItem);

    // Check if the updated item collides with any items other than the existing one
    if (existingItem != null && existingItem != prevItem) {
      final updatedItem = existingItem.copyWith(
          quantity: existingItem.quantity + newItem.quantity);
      // Remove the item that was edited
      _removeItem(prevItem);
      // Update the item that already exists to have the increased quantity
      _updateItem(existingItem: existingItem, newItem: updatedItem);
    } else {
      // If a version of the new item doesn't exist, simply update the item with the new information, but with the old ID
      _updateItem(existingItem: prevItem, newItem: newItem);
    }
  }

  void _removeItem(Item item) {
    ref.read(Repository.databases).removeItem(
          itemId: item.id,
          onErrorCallback: _databaseUpdateErrorCallback,
        );
  }

  Function get _databaseUpdateErrorCallback => _onErrorCallBackBuilder(
        errorInfo: ErrorInfo(message: SnackBarMessages.errorUpdatingDatabase),
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
