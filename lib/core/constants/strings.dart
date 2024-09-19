final class AppTitles {
  AppTitles._();

  static const settings = 'Settings';
  static const home = 'Home';
  static const menu = 'Menu';
}

final class ThemeText {
  ThemeText._();

  static const light = 'Light';
  static const dark = 'Dark';
  static const systemDefault = 'System Default';
}

final class SafeDelete {
  SafeDelete._();

  static const settingDescription = 'Show Item Deletion Warning';
  static const turnOffWarningMessage = 'Turn this warning off in settings';
  static const cancel = 'Cancel';
  static const confirm = 'Confirm';

  static buildAreYouSureMessage({required String itemName}) =>
      'Are you sure you want to remove "$itemName"?';
}

final class Tooltips {
  Tooltips._();

  static const addButton = 'Add Item';
  static const confirmEditItem = 'Confirm item changes';
  static const changeOneField =
      'Change at least one field to edit item. Fields cannot be empty';
  static const confirmMoveItem = 'Move chosen quantity to specified location';
  static const changeLocation =
      'Choose a different or valid location to move the item/s to';
  static const itemInfo = 'Item Information';
  static const incrementQuantity = 'Increment Quantity';
  static const decrementQuantity = 'Decrement Quantity';
  static const deleteItem = 'Delete Item';
  static const editItem = 'Edit Item';
  static const moveItem = 'Move Item';
  static const openAdvancedFilter = 'Open advanced filters';
  static const hideAdvancedFilter = 'Hide advanced filters';
  static const openSearch = 'Press to filter items';
  static const closeSearch = 'Stop filtering';

  static buildInvalidQuantityMessage({required int maxQuantity}) =>
      maxQuantity == 1
          ? 'Quantity must be 1'
          : 'Quantity must be between 1 and $maxQuantity inclusive';
}

final class FilterMessages {
  FilterMessages._();

  static const searchHint = 'Filter by name';
  static const noCategoryFound = 'No categories match your search';
  static const categoryFilterHint = 'Filter by category';
  static const noLocationFound = 'No locations match your search';
  static const locationFilterHint = 'Filter by location';
}

final class Messages {
  Messages._();

  static const refineSearchSuggestion =
      'Try simplifying or refining your search for better results';
  static const addItemsSuggestion =
      'Start adding items to keep track of your inventory';
  static const emptySearch = 'Looks like no items match your search!';
  static const emptyInventory = 'Your inventory is empty!';
}

final class EditItemMessages {
  EditItemMessages._();

  static const addItem = 'Add Item';
  static const editItem = 'Edit Item';
  static const moveItem = 'Move some or all items to a different location';
  static const itemInfo = 'Item Information';
  static const itemName = 'Item Name';
  static const quantity = 'Quantity';
  static const category = 'Category';
  static const categoryHint = 'Select an existing category or enter a new one';
  static const location = 'Location';
  static const locationHint = 'Select an existing location or enter a new one';
}
