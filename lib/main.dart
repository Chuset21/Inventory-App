import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_app/core/providers/providers.dart';
import 'package:inventory_app/core/services/services.dart';
import 'package:inventory_app/core/themes/themes.dart';
import 'package:inventory_app/core/utils/logger_utils.dart';
import 'package:inventory_app/presentation/screens/screens.dart';

import 'data/models/models.dart';

void main() async {
  // Load environment variables
  await dotenv.load(fileName: ".env");
  // Load settings before starting the app to avoid unnecessary reloads
  final initialTheme = await LocalStorage.getAppTheme();
  final isSafeDeleteOn = await LocalStorage.isSafeDeleteOn();

  setupLogger();

  runApp(
    ProviderScope(
      overrides: [
        themeProvider.overrideWith((ref) => ThemeNotifier(initialTheme)),
        safeDeleteProvider
            .overrideWith((ref) => SafeDeleteNotifier(isSafeDeleteOn)),
      ],
      child: MyApp(initialTheme: initialTheme),
    ),
  );
}

final _itemsProvider = FutureProvider<Iterable<Item>>((ref) {
  return ref.read(Repository.databases).getItems();
});

class MyApp extends ConsumerWidget {
  const MyApp({super.key, required this.initialTheme});

  final AppTheme initialTheme;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncItems = ref.watch(_itemsProvider);

    return ThemeProvider(
      initTheme: getThemeData(initialTheme),
      builder: (context, myTheme) => MaterialApp(
        title: 'Freezer Inventory',
        theme: myTheme,
        debugShowCheckedModeBanner: false,
        home: asyncItems.when(
          data: (items) => HomePage(
            title: 'Freezer Inventory',
            initialItems: items.toList(),
          ),
          loading: () => const LoadingPage(),
          error: (e, st) => SettingsPage(
            errorInfo:
                ErrorInfo(message: 'Error fetching data from the database'),
          ),
        ),
      ),
    );
  }
}
