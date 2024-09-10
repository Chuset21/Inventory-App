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
  static const confirmEditItem = 'Confirm item changes';
  static const changeOneField = 'Change at least one field to edit item';
}

final class Placeholders {
  static const searchHint = 'Filter by name';
}

final class FilterMessages {
  static const noCategoryFound = 'No categories match your search';
  static const categoryFilterHint = 'Filter by category';
  static const noLocationFound = 'No locations match your search';
  static const locationFilterHint = 'Filter by location';
}

final class Messages {
  static const refineSearchSuggestion =
      'Try simplifying or refining your search for better results';
  static const addItemsSuggestion =
      'Start adding items to keep track of your inventory';
  static const emptySearch = 'Looks like no items match your search!';
  static const emptyInventory = 'Your inventory is empty!';
}

final class EditItemMessages {
  static const addItem = 'Add Item';
  static const editItem = 'Edit Item';
  static const itemName = 'Item Name';
  static const quantity = 'Quantity';
  static const category = 'Category';
  static const categoryHint = 'Select an existing category or enter a new one';
  static const location = 'Location';
  static const locationHint = 'Select an existing location or enter a new one';
}
