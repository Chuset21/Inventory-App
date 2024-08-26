import 'package:flutter/material.dart';

import '../../core/constants/strings.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage(
      {super.key, required this.isDarkMode, required this.onDarkModeUpdate});

  final bool isDarkMode;
  final Function(bool) onDarkModeUpdate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).canvasColor,
        title: const Text(settingsTitle),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align to the left
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 5.0, right: 20.0),
            child: Row(
              children: [
                Text(
                  darkModeSwitchText,
                  style: Theme.of(context).textTheme.bodyLarge,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                const Icon(
                  Icons.brightness_5, // Sun icon for light mode
                ),
                Switch(
                  value: isDarkMode,
                  onChanged: (value) {
                    onDarkModeUpdate(value);
                  },
                ),
                const Icon(
                  Icons.brightness_2, // Moon icon for dark mode
                ),
              ],
            ),
          ),
          const Divider(
            indent: 10,
            endIndent: 10,
            thickness: 1,
          ),
        ],
      ),
    );
  }
}
