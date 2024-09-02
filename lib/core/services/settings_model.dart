import 'package:flutter/material.dart';

import 'local_storage.dart';

class SettingsModel extends ChangeNotifier {
  bool _isSafeDeleteOn;

  SettingsModel(this._isSafeDeleteOn);

  bool get isSafeDeleteOn => _isSafeDeleteOn;

  void updateSafeDelete(bool value) {
    _isSafeDeleteOn = value;
    LocalStorage.updateIsSafeDeleteOn(_isSafeDeleteOn);
    notifyListeners(); // Notify all listeners about the change
  }
}
