import 'package:flutter/material.dart';
import 'package:inventory_app/presentation/screens/settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage(
      {super.key,
      required this.title,
      required this.isDarkMode,
      required this.onDarkModeUpdate});

  final String title;
  final bool isDarkMode;
  final Function(bool) onDarkModeUpdate; // Callback to update dark mode

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
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(
                    isDarkMode: widget.isDarkMode,
                    onDarkModeUpdate: widget.onDarkModeUpdate,
                  ),
                ),
              );
            },
          ),
        ],
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
}
