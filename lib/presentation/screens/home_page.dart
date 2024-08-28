import 'package:flutter/material.dart';
import 'package:inventory_app/core/constants/strings.dart';
import 'package:inventory_app/core/utils/app_theme.dart';
import 'package:inventory_app/presentation/screens/settings_page.dart';
import 'package:inventory_app/presentation/widgets/add_items_suggestion.dart';
import 'package:inventory_app/presentation/widgets/burger_menu.dart';

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

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          const Expanded(
            child: Center(
              child: AddItemsSuggestion(),
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
