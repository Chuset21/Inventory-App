import 'package:flutter/material.dart';

import '../../core/constants/strings.dart';

class BurgerMenu extends StatelessWidget {
  const BurgerMenu(
      {super.key,
      required this.navigateToHome,
      required this.navigateToSettings});

  final Function() navigateToHome;
  final Function() navigateToSettings;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            color: Theme.of(context).colorScheme.primary,
            padding: const EdgeInsets.only(
                left: 16.0, top: 65.0, right: 16.0, bottom: 16.0),
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
            onTap: navigateToHome,
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text(settingsTitle),
            onTap: navigateToSettings,
          ),
        ],
      ),
    );
  }
}
