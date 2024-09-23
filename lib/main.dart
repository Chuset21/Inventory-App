import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_app/core/providers/providers.dart';
import 'package:inventory_app/core/services/services.dart';
import 'package:inventory_app/core/themes/themes.dart';
import 'package:inventory_app/core/utils/logger_utils.dart';
import 'package:inventory_app/presentation/screens/screens.dart';

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

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.initialTheme});

  final AppTheme initialTheme;

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      initTheme: getThemeData(initialTheme),
      builder: (context, myTheme) => MaterialApp(
        title: 'Freezer Inventory',
        theme: myTheme,
        debugShowCheckedModeBanner: false,
        home: const HomePage(
          title: 'Freezer Inventory',
        ),
      ),
    );
  }
}
