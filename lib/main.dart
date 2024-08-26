import 'package:flutter/material.dart';

import 'core/themes/app_themes.dart';
import 'core/services/local_storage.dart';
import 'core/utils/platform_utils.dart';

void main() async {
  runApp(MyApp(
    startInDarkMode: await LocalStorage.isDarkMode(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.startInDarkMode});

  final bool? startInDarkMode;

  @override
  State<MyApp> createState() => _MyApp();
}

/// This widget essentially keeps track of the theme
class _MyApp extends State<MyApp> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      // Prioritise app settings if present, otherwise use platform settings
      _isDarkMode = widget.startInDarkMode ?? isPlatformDarkMode();
    });
  }

  void _updateIsDarkMode(bool value) {
    setState(() {
      // Flip the mode
      _isDarkMode = value;
      // Update in local storage
      LocalStorage.updateDarkMode(_isDarkMode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Freezer Inventory Demo',
      theme: _isDarkMode ? darkTheme : lightTheme,
      debugShowCheckedModeBanner: false,
      home: MyHomePage(
          title: 'Freezer Inventory Demo',
          isDarkMode: _isDarkMode,
          onDarkModeUpdate: _updateIsDarkMode),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage(
      {super.key,
      required this.title,
      required this.isDarkMode,
      required this.onDarkModeUpdate});

  final String title;
  final bool isDarkMode;
  final Function(bool) onDarkModeUpdate; // Callback to update dark mode

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Toggle to change theme:',
                ),
                Switch(
                  value: widget.isDarkMode,
                  onChanged: (value) {
                    widget.onDarkModeUpdate(value); // Call the callback
                  },
                ),
              ],
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
