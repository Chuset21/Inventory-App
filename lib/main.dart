import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_app/core/providers/providers.dart';
import 'package:inventory_app/core/services/services.dart';
import 'package:inventory_app/core/themes/themes.dart';
import 'package:inventory_app/core/utils/logger_utils.dart';
import 'package:inventory_app/presentation/screens/screens.dart';

import 'data/models/models.dart';

void main() async {
  // Load settings before starting the app to avoid unnecessary reloads
  final initialTheme = await LocalStorage.getAppTheme();
  final isSafeDeleteOn = await LocalStorage.isSafeDeleteOn();

  // TODO: remove this once it is working inside the app
  // This works!!!
  // final client = Client()
  //     .setProject(appwriteProjectId)
  //     .setSelfSigned(status: true)
  //     .setEndpoint(appwriteEndpoint);
  // final databases = Databases(client);
  // final documents = (await databases.listDocuments(
  //         databaseId: databaseId, collectionId: collectionId))
  //     .documents;
  // print(DatabaseUtils.mapDocumentsToItems(documents));

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

// TODO: remove - used for testing
List<Item> testItems = [
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
          data: (items) {
            return HomePage(
              title: 'Freezer Inventory',
              initialItems: items.toList(),
            );
          },
          loading: () {
            return const LoadingPage();
          },
          error: (e, st) {
            logger.severe('Error');
            logger.severe(st);
            return const Center(
              child: Text('Error loading data'),
            );
          },
        ),
      ),
    );
  }
}
