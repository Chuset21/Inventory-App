import 'package:flutter/material.dart';
import 'package:inventory_app/core/constants/strings.dart';
import 'package:inventory_app/core/utils/app_theme.dart';
import 'package:inventory_app/presentation/screens/settings_page.dart';

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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).canvasColor,
        title: Text(
          widget.title,
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              color: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.only(
                  left: 16.0, top: 50.0, right: 16.0, bottom: 16.0),
              alignment: Alignment.centerLeft,
              child: Text(
                menuTitle,
                style: TextStyle(
                  color: Theme.of(context).canvasColor,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text(homeTitle),
              onTap: _navigateToHomePage,
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text(settingsTitle),
              onTap: _navigateToSettingsPage,
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
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
