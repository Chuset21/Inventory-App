import 'package:flutter/material.dart';
import 'package:inventory_app/core/constants/strings.dart';
import 'package:inventory_app/core/utils/app_theme.dart';
import 'package:inventory_app/data/models/item.dart';
import 'package:inventory_app/presentation/screens/settings_page.dart';
import 'package:inventory_app/presentation/widgets/add_items_suggestion.dart';
import 'package:inventory_app/presentation/widgets/burger_menu.dart';
import 'package:inventory_app/presentation/widgets/item_display.dart';

class HomePage extends StatefulWidget {
  const HomePage(
      {super.key,
      required this.title,
      required this.appTheme,
      required this.onThemeUpdate});

  final String title;
  final AppTheme appTheme;
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
      type: 'Vegetable',
      location: 'Upstairs Freezer',
    ): 5,
    Item(
      name: 'Cauliflower',
      type: 'Vegetable',
      location: 'Upstairs Freezer',
    ): 2,
  };

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _searchFocusNode.unfocus();
      } else {
        _searchFocusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final itemListAndFocusNodes = _buildItemListViewWithFocusNodes(items);

    return GestureDetector(
      onTap: () {
        _searchFocusNode.unfocus();
        // Unfocus each item focus node
        for (var node in itemListAndFocusNodes.focusNodes) {
          node.unfocus();
        }
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
          children: <Widget>[
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
                      child: itemListAndFocusNodes.listView,
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
  ({ListView listView, List<FocusNode> focusNodes})
      _buildItemListViewWithFocusNodes(Map<Item, int> items) {
    // Create a list of FocusNodes
    final focusNodes =
        List.generate(items.length, (index) => FocusNode(), growable: false);

    // Convert the map entries to a list
    final entries = items.entries.toList();

    return (
      listView: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) => ItemDisplay(
          item: entries[index].key,
          number: entries[index].value,
          numberFocusNode: focusNodes[index],
        ),
      ),
      focusNodes: focusNodes,
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
        builder: (context) => SettingsPage(
          appTheme: widget.appTheme,
          onThemeUpdate: widget.onThemeUpdate,
        ),
      ),
    );
  }
}
