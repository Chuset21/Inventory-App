abstract class AppTitles {
  static const settings = 'Settings';
  static const home = 'Home';
  static const menu = 'Menu';
  static const appTitle = 'Inventory';
}

abstract class ThemeText {
  static const light = 'Light';
  static const dark = 'Dark';
  static const systemDefault = 'System Default';
}

abstract class SafeDelete {
  static const settingDescription = 'Show Item Deletion Warning';
  static const turnOffWarningMessage = 'Turn this warning off in settings';
  static const cancel = 'Cancel';
  static const confirm = 'Confirm';

  static buildAreYouSureMessage({required String itemName}) =>
      'Are you sure you want to remove "$itemName"?';
}

abstract class Tooltips {
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

abstract class FilterMessages {
  static const searchHint = 'Filter by name';
  static const noCategoryFound = 'No categories match your search';
  static const categoryFilterHint = 'Filter by category';
  static const noLocationFound = 'No locations match your search';
  static const locationFilterHint = 'Filter by location';
}

abstract class Messages {
  static const refineSearchSuggestion =
      'Try simplifying or refining your search for better results';
  static const addItemsSuggestion =
      'Start adding items to keep track of your inventory';
  static const emptySearch = 'Looks like no items match your search!';
  static const emptyInventory = 'Your inventory is empty!';
  static const appRestartTitle = 'Restarting the app with the new config';
  static const appRestartPrompt = 'Please tap here to open the app again.';
}

abstract class EditItemMessages {
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

abstract class DatabaseConfigurationSettings {
  static const title = 'Database Configuration Settings (Advanced)';
  static const endpointLabel = 'Endpoint';
  static const projectIdLabel = 'Project ID';
  static const databaseIdLabel = 'Database ID';
  static const collectionIdLabel = 'Collection ID';
  static const submit = 'Submit';
}

abstract class SnackBarMessages {
  static const appwriteConfigFormSubmitError =
      'Invalid configuration - could not connect to database. Changes have not been applied.';
  static const errorFetchingInitialData =
      'Error fetching data from the database';
  static const errorFetchingRealTimeData =
      'Error fetching real-time data from the database';
  static const errorUpdatingDatabase = 'Error updating database';
  static const successfulDatabaseReconnection =
      'Successfully connected to database';

  static buildLostConnectionMessage({required int secondsToRetry}) =>
      'Lost connection to the database, attempting to connect in $secondsToRetry seconds';
}
