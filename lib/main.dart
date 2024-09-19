import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_app/core/providers/providers.dart';
import 'package:inventory_app/core/themes/themes.dart';
import 'package:inventory_app/presentation/screens/screens.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appTheme = ref.watch(themeProvider);

    return MaterialApp(
      title: 'Freezer Inventory',
      theme: getThemeData(appTheme),
      debugShowCheckedModeBanner: false,
      home: const HomePage(
        title: 'Freezer Inventory',
      ),
    );
  }
}
