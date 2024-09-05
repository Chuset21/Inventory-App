final class AppTitles {
  static const settings = 'Settings';
  static const home = 'Home';
  static const menu = 'Menu';
}

final class ThemeText {
  static const light = 'Light';
  static const dark = 'Dark';
  static const systemDefault = 'System Default';
}

final class SafeDelete {
  static const settingDescription = 'Show Item Deletion Warning';
  static const turnOffWarningMessage = 'Turn this warning off in settings';
  static const cancel = 'Cancel';
  static const confirm = 'Confirm';

  static buildAreYouSureMessage({required String itemName}) =>
      'Are you sure you want to remove "$itemName"?';
}

final class Tooltips {
  static const addButton = 'Add Item';
}

final class Placeholders {
  static const searchHint = 'Search...';
}

final class Messages {
  static const addItemsSuggestion =
      'Start adding items to keep track of your inventory';
  static const emptyInventory = 'Your inventory is empty!';
}

final class EditItemMessages {
  static const addItem = 'Add Item';
  static const itemName = 'Item Name';
  static const quantity = 'Quantity';
  static const category = 'Category';
  static const location = 'Location';
}
