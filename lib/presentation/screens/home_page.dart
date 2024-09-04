import 'package:flutter/material.dart';
import 'package:inventory_app/core/constants/strings.dart';
import 'package:inventory_app/core/services/settings_model.dart';
import 'package:inventory_app/core/utils/app_theme.dart';
import 'package:inventory_app/data/models/item.dart';
import 'package:inventory_app/presentation/screens/settings_page.dart';
import 'package:inventory_app/presentation/widgets/add_items_suggestion.dart';
import 'package:inventory_app/presentation/widgets/burger_menu.dart';
import 'package:inventory_app/presentation/widgets/item_display.dart';
import 'package:provider/provider.dart';

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
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  Map<Item, int> items = {
    Item(
      name: 'Broccoli',
      category: 'Vegetables',
      location: 'Upstairs Freezer',
    ): 5,
    Item(
      name: 'Cauliflower',
      category: 'Vegetables',
      location: 'Upstairs Freezer',
    ): 2,
    Item(
      name: 'Chicken Breast (500g)',
      category: 'Meat',
      location: 'Upstairs Freezer',
    ): 1,
    Item(
      name: 'Ground Beef',
      category: 'Meat',
      location: 'Upstairs Freezer',
    ): 4,
    Item(
      name: 'Bagels',
      category: 'Bread',
      location: 'Downstairs Freezer',
    ): 15,
    Item(
      name: 'Soda Bread',
      category: 'Bread',
      location: 'Downstairs Freezer',
    ): 1,
    Item(
      name: 'Mango',
      category: 'Fruit',
      location: 'Upstairs Freezer',
    ): 2,
    Item(
      name: 'Strawberries',
      category: 'Fruit',
      location: 'Upstairs Freezer',
    ): 1,
    Item(
      name: 'Raspberries',
      category: 'Fruit',
      location: 'Upstairs Freezer',
    ): 2,
    Item(
      name: 'Mixed Berries',
      category: 'Fruit',
      location: 'Upstairs Freezer',
    ): 1,
  };

  late ListView _itemListView;
  late List<({FocusNode node, GlobalKey<ItemDisplayState> key})>
      _itemFocusNodesAndKeys;
  late SettingsModel settingsModel;

  void _syncItemListViewAndDependencies() {
    setState(() {
      final (:listView, :focusNodesAndKeys) =
          _buildItemListViewWithFocusNodesAndKeys(items);
      _itemListView = listView;
      _itemFocusNodesAndKeys = focusNodesAndKeys;
    });
  }

  @override
  void didChangeDependencies() {
    settingsModel = Provider.of<SettingsModel>(context);
    _syncItemListViewAndDependencies();
    super.didChangeDependencies();
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
        _searchController.clear();
        _searchFocusNode.unfocus();
      } else {
        _unfocusAndSubmitItemNodes();
        _searchFocusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _searchController.dispose();
    for (var nodeAndKey in _itemFocusNodesAndKeys) {
      nodeAndKey.node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _searchFocusNode.unfocus();
        _unfocusAndSubmitItemNodes();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).canvasColor,
          title: Text(widget.title),
          actions: [
            IconButton(
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
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: Placeholders.searchHint,
                          hintStyle: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacity(0.8),
                            fontSize: 18.0,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            // borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.primaryFixed,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.filter_list),
                      color: Theme.of(context).colorScheme.primaryFixed,
                      onPressed: () {
                        // TODO: Handle filter action here
                      },
                    ),
                  ],
                ),
              ),
            // The rest of the body content
            Expanded(
              child: items.isEmpty
                  ? const Center(
                      child: AddItemsSuggestion(),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: _itemListView,
                    ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          // TODO: route to add item page
          tooltip: Tooltips.addButton,
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).canvasColor,
          child: const Icon(Icons.add),
        ),
      ),
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
      final entries = groupedItems[category]!;

      // Add the section header
      itemWidgets.add(_buildHeader(category));

      // Add the items under the section
      for (MapEntry<Item, int> entry in entries) {
        Item item = entry.key;

        itemWidgets.add(
          ItemDisplay(
            key: focusNodesAndKeys[focusNodeAndKeyIndex].key,
            isSafeDeleteOn: () => settingsModel.isSafeDeleteOn,
            onSafeDeleteUpdate: settingsModel.updateSafeDelete,
            getAppTheme: widget.getAppTheme,
            onThemeUpdate: widget.onThemeUpdate,
            item: item,
            number: entry.value,
            numberFocusNode: focusNodesAndKeys[focusNodeAndKeyIndex].node,
            setItemNumber: (itemNumber) {
              setState(() {
                items.update(item, (oldValue) => itemNumber);
                _syncItemListViewAndDependencies();
              });
            },
            removeItem: () {
              setState(() {
                items.remove(item);
                _syncItemListViewAndDependencies();
              });
            },
          ),
        );
        focusNodeAndKeyIndex++;
      }
    }

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
            thickness: 3.0, // Height of the separator line
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
