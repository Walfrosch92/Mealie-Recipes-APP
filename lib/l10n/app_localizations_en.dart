// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Mealie Recipes';

  @override
  String get endCookingMode => 'End cooking mode';

  @override
  String get endCookingModeConfirm => 'Do you really want to end cooking mode?';

  @override
  String endCookingModeConfirmAll(int count) {
    return 'This will end all $count recipes in cooking mode. Continue?';
  }

  @override
  String get addTimer => 'Add timer';

  @override
  String get recipeFinished => 'Your dish is ready.';

  @override
  String get bonAppetit => 'Enjoy your meal!';

  @override
  String get prepareIngredients => 'Please prepare the following ingredients';

  @override
  String prepareIngredientsFor(String servings) {
    return 'Please prepare the following ingredients for $servings servings';
  }

  @override
  String get next => 'Next';

  @override
  String get navHome => 'Home';

  @override
  String get homeCookToday => 'Cook today';

  @override
  String get homeSuggestion => 'Suggestion';

  @override
  String get homeQuickAccess => 'Quick access';

  @override
  String get homePlanned => 'Planned';

  @override
  String get favorite => 'Favorite';

  @override
  String get navSettings => 'Settings';

  @override
  String homeWelcomeName(Object name) {
    return 'Welcome $name,';
  }

  @override
  String get homeWelcomeApp => 'to Mealie Recipes 👋';

  @override
  String get theme => 'Appearance';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get recipes => 'Recipes';

  @override
  String get shoppingList => '🛒 Shopping List';

  @override
  String get mealplan => 'Meal Plan';

  @override
  String get settings => '⚙️ Settings';

  @override
  String get searchRecipe => 'Search recipe...';

  @override
  String get loadingRecipes => 'Loading recipes...';

  @override
  String get loadingRecipe => 'Loading recipe...';

  @override
  String errorLoadingRecipes(String error) {
    return 'Error loading recipes: $error';
  }

  @override
  String get errorLoadingRecipe => 'Could not load recipe.';

  @override
  String get noRecipesForCategory => 'No recipes for this filter.';

  @override
  String get resetFilter => 'Reset filter';

  @override
  String get allCategories => 'All categories';

  @override
  String get all => 'All';

  @override
  String get sortRecipes => 'Sort recipes';

  @override
  String get refreshRecipes => 'Refresh';

  @override
  String get sortNameAZ => 'Name A–Z';

  @override
  String get sortNameZA => 'Name Z–A';

  @override
  String get sortDateNewest => 'Newest first';

  @override
  String get sortDateOldest => 'Oldest first';

  @override
  String get sortPrepTimeShort => 'Shortest prep time';

  @override
  String get sortPrepTimeLong => 'Longest prep time';

  @override
  String get sortRatingHighest => 'Highest rating';

  @override
  String get sortRatingLowest => 'Lowest rating';

  @override
  String get details => 'Details';

  @override
  String get ingredients => 'Ingredients';

  @override
  String get instructions => 'Instructions';

  @override
  String get tags => 'Tags';

  @override
  String get notes => 'Notes';

  @override
  String get addNote => 'Add note';

  @override
  String get editNote => 'Edit note';

  @override
  String get noteTitleHint => 'Title (optional)';

  @override
  String get noteTextHint => 'Note text';

  @override
  String get deleteNoteTitle => 'Delete note?';

  @override
  String get deleteNoteMessage => 'This note will be permanently deleted.';

  @override
  String get servings => 'Servings';

  @override
  String get adjustQuantity => 'Adjust quantity';

  @override
  String get startTimer => 'Start Timer';

  @override
  String runningTimer(int minutes, String seconds) {
    return 'Timer: $minutes:$seconds';
  }

  @override
  String get planMeal => 'Plan Meal';

  @override
  String get displayAlwaysOn => 'Keep screen on';

  @override
  String get addAllIngredients => 'Add all ingredients';

  @override
  String get addSelectedIngredients => 'Add selected ingredients';

  @override
  String get addIngredientsTitle => 'Ingredients added';

  @override
  String get addIngredientsMessage =>
      'The ingredients have been added to your shopping list.';

  @override
  String addIngredientsFailedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ingredients could not be added.',
      one: '1 ingredient could not be added.',
    );
    return '$_temp0';
  }

  @override
  String get cookbooks => 'Cookbooks';

  @override
  String get cookbooksEmpty =>
      'No cookbooks yet. Tap “+” in the top right to create one.';

  @override
  String get cookbookNoMatches => 'No recipes match this filter.';

  @override
  String get cookbookCreateTitle => 'Create cookbook';

  @override
  String get cookbookEditTitle => 'Edit cookbook';

  @override
  String get cookbookNameLabel => 'Cookbook name';

  @override
  String get cookbookFilterSectionTitle => 'Automatically add recipes';

  @override
  String get cookbookFieldTools => 'Tools';

  @override
  String get cookbookFieldUsers => 'Users';

  @override
  String get cookbookOpIsOneOf => 'is one of';

  @override
  String get cookbookOpIsNotOneOf => 'is not one of';

  @override
  String get cookbookOpContainsAll => 'contains all';

  @override
  String get cookbookSelectValues => 'Select values';

  @override
  String get cookbookFilterOptionsUnavailable => 'No options available';

  @override
  String get cookbookAddFilterField => 'Add field';

  @override
  String get cookbookPublicLabel => 'Public cookbook';

  @override
  String get cookbookPublicSubtitle =>
      'Visible to other households on the server';

  @override
  String get cookbookRawModeEnter => 'Edit as text';

  @override
  String get cookbookRawModeExit => 'Back to builder';

  @override
  String get cookbookRawModeHint =>
      'This app\'s expert mode: edits the filter directly as text. Useful when an existing filter couldn\'t be broken down into simple rows.';

  @override
  String get cookbookRawModeUnparseable =>
      'This text doesn\'t match the simple row format — it stays as text.';

  @override
  String get saveFailed => 'Save failed';

  @override
  String get search => 'Search';

  @override
  String get apply => 'Apply';

  @override
  String get setupCachingTitle => 'Loading your recipes';

  @override
  String get setupCachingSubtitle =>
      'Your recipes are being prepared for offline use. Depending on how many you have, this can take a moment.';

  @override
  String get setupCachingDone => 'All set!';

  @override
  String get setupTipsHeader => 'Did you know?';

  @override
  String get setupFinish => 'Let\'s go';

  @override
  String get setupSkipCaching => 'Continue in the background';

  @override
  String get setupTip1 =>
      'You can import recipes from a link, photo or PDF — via the Import tile on the home screen.';

  @override
  String get setupTip2 =>
      'Cooking mode keeps the screen awake, guides you step by step and automatically detects timers in the text.';

  @override
  String get setupTip3 =>
      'The shopping list works offline too — changes sync automatically once the server is reachable.';

  @override
  String get setupTip4 =>
      'Long-press a tile on the home screen to rearrange your quick access.';

  @override
  String get setupTip5 =>
      'Find your Mealie cookbooks via the Cookbooks tile — including offline support.';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get save => 'Save';

  @override
  String get done => 'Done';

  @override
  String get close => 'Close';

  @override
  String get add => 'Add';

  @override
  String get send => 'Send';

  @override
  String get retry => 'Retry';

  @override
  String get confirmDeleteTitle => 'Delete recipe?';

  @override
  String get confirmDeleteMessage => 'This action cannot be undone.';

  @override
  String get sendToDevice => 'Send to device';

  @override
  String get sendToDevicePickerTitle => 'Send to device';

  @override
  String get sendToAllDevices => 'Send to all devices';

  @override
  String get timerFinished => 'Timer finished!';

  @override
  String get timerFinishedBody => 'Your recipe timer has finished.';

  @override
  String get timer => 'Timer';

  @override
  String get newTimer => 'New Timer';

  @override
  String get timerDetails => 'Timer Details';

  @override
  String get timerNamePlaceholder => 'Timer name';

  @override
  String get timerNameHint => 'Give your timer a descriptive name.';

  @override
  String get durationLabel => 'Duration';

  @override
  String minutesCount(int count) {
    return '$count minutes';
  }

  @override
  String get start => 'Start';

  @override
  String get stop => 'Stop';

  @override
  String get pause => 'Pause';

  @override
  String get resume => 'Resume';

  @override
  String get finished => 'Finished!';

  @override
  String stepNumber(int number) {
    return 'Step $number';
  }

  @override
  String get minAbbreviation => 'min';

  @override
  String get cookingMode => 'Cooking Mode';

  @override
  String activeRecipesCount(int count) {
    return '$count active recipes';
  }

  @override
  String get endAll => 'End all';

  @override
  String get end => 'End';

  @override
  String get endAllRecipesTitle => 'End all recipes?';

  @override
  String endAllRecipesMessage(int count) {
    return 'Do you want to end all $count active cooking sessions?';
  }

  @override
  String get endRecipeTitle => 'End recipe?';

  @override
  String endRecipeMessage(String name) {
    return 'Do you want to end the cooking session for \"$name\"?';
  }

  @override
  String get noActiveTimers => 'No active timers';

  @override
  String get noActiveRecipes => 'No active recipes';

  @override
  String get startRecipeToCook =>
      'Open a recipe and tap the cooking mode button to start.';

  @override
  String get browseRecipes => 'Browse recipes';

  @override
  String timersPausedCount(int count) {
    return '$count timer(s) paused';
  }

  @override
  String get cookFriends => 'Cook with Friends';

  @override
  String get cookingModeAddRecipe => 'Add recipe';

  @override
  String get cookingModeAddRecipeSearchHint => 'Search recipes';

  @override
  String get cookFriendsCode => 'Session code';

  @override
  String get cookFriendsJoin => 'Join session';

  @override
  String get cookFriendsHost => 'Host session';

  @override
  String get cookFriendsHostNotFound =>
      'Host not found. Make sure both devices are on the same Wi-Fi and local network access is allowed.';

  @override
  String get cookFriendsConnectionFailed =>
      'Connection failed. Please try again.';

  @override
  String get cookFriendsEnterCode => 'Enter code';

  @override
  String cookFriendsConnected(int count) {
    return 'Connected: $count guests';
  }

  @override
  String get joinSession => 'Join session';

  @override
  String get hostEndedSessionTitle => 'Session ended';

  @override
  String get hostEndedSessionMessage =>
      'The host has ended the cooking session.';

  @override
  String get shoppingListEmpty => 'Your shopping list is empty.';

  @override
  String get addItem => 'Add item';

  @override
  String get itemNote => 'Item name';

  @override
  String get unlabeledCategory => 'Unlabeled';

  @override
  String get reorderCategories => 'Reorder categories';

  @override
  String get archiveChecked => 'Archive checked items';

  @override
  String get archivedLists => '📦 Archived purchases';

  @override
  String get syncChanges => 'Sync changes';

  @override
  String get noSyncChanges => 'No sync changes';

  @override
  String get postimportAction => 'After import';

  @override
  String get postimportHint =>
      'Choose what should happen in the source app (Reminders / Google Tasks) with the imported entries.';

  @override
  String get postimportLeave => 'Just add';

  @override
  String get postimportComplete => 'Check off';

  @override
  String get postimportCompleteDelete => 'Check off & delete';

  @override
  String get postimportFailed =>
      'Post-processing in the source app failed. The items were still added to Mealie.';

  @override
  String get syncChangesTitle => 'Sync changes';

  @override
  String get syncSectionChecked => 'Checked';

  @override
  String get syncSectionQuantity => 'Quantity';

  @override
  String get syncSectionCategory => 'Category';

  @override
  String get syncSectionAdditions => 'Newly added';

  @override
  String get syncLocalLabel => 'Local';

  @override
  String get syncServerLabel => 'Server';

  @override
  String get syncNow => 'Sync now';

  @override
  String get offlineBadge => 'Offline';

  @override
  String get mealplanTitle => '📅 Meal Plan';

  @override
  String get mealplanSelectMode => 'Select multiple recipes';

  @override
  String mealplanSelectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count selected',
      one: '1 selected',
      zero: 'Select',
    );
    return '$_temp0';
  }

  @override
  String get breakfast => 'Breakfast';

  @override
  String get lunch => 'Lunch';

  @override
  String get dinner => 'Dinner';

  @override
  String get addMealEntry => 'Add meal';

  @override
  String get selectRecipe => 'Select recipe';

  @override
  String get orFreeText => 'or free text';

  @override
  String get entryNote => 'Note';

  @override
  String get noMealEntries => 'No entries for this week.';

  @override
  String get importRecipe => 'Import Recipe';

  @override
  String get importFromUrl => 'Import from URL';

  @override
  String get importFromImage => 'Import from photo';

  @override
  String get importFromJson => 'Import from JSON';

  @override
  String get url => 'URL';

  @override
  String get urlPlaceholder => 'https://...';

  @override
  String get importLanguage => 'Language for OCR';

  @override
  String get importing => 'Importing...';

  @override
  String get importSuccess => 'Recipe imported successfully!';

  @override
  String importError(String error) {
    return 'Import failed: $error';
  }

  @override
  String get pasteJson => 'Paste JSON here';

  @override
  String get setupTitle => 'Welcome to Mealie Recipes';

  @override
  String get setupSubtitle => 'Please configure your Mealie server.';

  @override
  String get serverUrl => 'Server URL';

  @override
  String get serverUrlPlaceholder => 'https://mealie.example.com';

  @override
  String get apiToken => 'API Token';

  @override
  String get apiTokenPlaceholder => 'Your API token';

  @override
  String get householdId => 'Household';

  @override
  String get householdIdPlaceholder => 'Family';

  @override
  String get shoppingListId => 'Shopping list ID';

  @override
  String get shoppingListIdPlaceholder => 'Select a shopping list';

  @override
  String get setupHouseholdListTitle => 'Household & shopping list';

  @override
  String get shoppingListLabel => 'Shopping list';

  @override
  String get setupHouseholdManualHint =>
      'Households could not be loaded — enter the household name manually.';

  @override
  String get setupExactTitle => 'Quantities on the shopping list';

  @override
  String get setupExactBody =>
      'In most countries you don\'t shop gram-precise — you put 1 pack of butter in the cart, not 200 g. In simple mode the app therefore converts recipe amounts to “1×”. In exact mode quantity and unit are kept 1:1 like the Mealie web app — including when typing new items (e.g. “200 g butter”). You can change this anytime in the settings.';

  @override
  String get setupExactSimpleTitle => 'Simple mode (1×)';

  @override
  String get setupExactSimpleBody =>
      'Ingredients land on the list as “1× item” — ideal for quick ticking off in the store.';

  @override
  String get setupExactExactTitle => 'Exact quantities';

  @override
  String get setupExactExactBody =>
      'Items appear with quantity and unit, e.g. “200 g butter” — exactly like the web app.';

  @override
  String get connect => 'Connect';

  @override
  String get connecting => 'Connecting...';

  @override
  String get connectionSuccess => 'Connection successful!';

  @override
  String connectionError(String error) {
    return 'Connection failed: $error';
  }

  @override
  String get optionalHeaders => 'Optional HTTP headers (for reverse proxy)';

  @override
  String get settingsTitle => '⚙️ Settings';

  @override
  String get settingsSaved => 'Settings saved';

  @override
  String get serverSettings => 'Server';

  @override
  String get displaySettings => 'Display';

  @override
  String get notificationSettings => 'Notifications';

  @override
  String get securitySettings => 'Security';

  @override
  String get aboutSettings => 'About';

  @override
  String get showRecipeImages => 'Show recipe images';

  @override
  String get apiVersion => 'API version';

  @override
  String get language => 'Language';

  @override
  String get biometricLock => 'Biometric lock';

  @override
  String get biometricLockDescription => 'Unlock app with biometrics';

  @override
  String get criticalAlerts => 'Critical alerts';

  @override
  String get criticalAlertsDescription => 'Timer alarm even in silent mode';

  @override
  String get enableLogging => 'Enable logging';

  @override
  String get selectLanguage => 'Select language';

  @override
  String get setupContinue => 'Continue';

  @override
  String get back => 'Back';

  @override
  String get setupConnectStep => 'Connect to your server';

  @override
  String get resetSettings => 'Reset all settings';

  @override
  String get resetSettingsConfirm => 'This will reset all settings. Continue?';

  @override
  String get guestMode => 'Guest mode';

  @override
  String get appVersion => 'Version';

  @override
  String get leftoverFinder => 'Recipe Finder';

  @override
  String get leftoverFinderSubtitle => 'Find recipes with ingredients you have';

  @override
  String get addIngredient => 'Add ingredient';

  @override
  String get ingredientPlaceholder => 'e.g. eggs';

  @override
  String get findRecipes => 'Find recipes';

  @override
  String get matchingRecipes => 'Matching recipes';

  @override
  String get noMatchingRecipes => 'No recipes found for these ingredients.';

  @override
  String matchPercent(int percent) {
    return '$percent% match';
  }

  @override
  String get biometricPrompt => 'Authenticate to open Mealie Recipes';

  @override
  String get biometricFailed => 'Authentication failed';

  @override
  String get whatsNew => 'What\'s New';

  @override
  String get pendingRecipesTitle => 'Received recipes';

  @override
  String pendingRecipesMessage(String sender, String name) {
    return 'You received a recipe from $sender: \"$name\"';
  }

  @override
  String pendingRecipesFrom(Object names) {
    return 'From $names';
  }

  @override
  String get pendingRecipesOpenCooking => 'Open cooking mode';

  @override
  String get pendingRecipesLater => 'Later';

  @override
  String get openRecipe => 'Open recipe';

  @override
  String get dismiss => 'Dismiss';

  @override
  String get editRecipe => 'Edit Recipe';

  @override
  String get recipeName => 'Recipe name';

  @override
  String get recipeDescription => 'Description';

  @override
  String get prepTime => 'Prep time (min)';

  @override
  String get cookTime => 'Cook time (min)';

  @override
  String get totalTime => 'Total time (min)';

  @override
  String get recipeServings => 'Servings';

  @override
  String get rating => 'Rating';

  @override
  String get addIngredientLine => 'Add ingredient';

  @override
  String get addInstruction => 'Add step';

  @override
  String get removeIngredient => 'Remove ingredient';

  @override
  String get removeInstruction => 'Remove step';

  @override
  String get ingredientName => 'Ingredient';

  @override
  String get ingredientQuantity => 'Qty';

  @override
  String get ingredientUnit => 'Unit';

  @override
  String get ingredientNote => 'Note';

  @override
  String get instructionText => 'Step text';

  @override
  String get categories => 'Categories';

  @override
  String get selectCategories => 'Select categories';

  @override
  String get selectTags => 'Select tags';

  @override
  String get uploadImage => 'Upload image';

  @override
  String get removeImage => 'Remove image';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get saving => 'Saving...';

  @override
  String get saveSuccess => 'Recipe saved.';

  @override
  String saveError(String error) {
    return 'Could not save: $error';
  }

  @override
  String get newCategory => 'New category';

  @override
  String get newTag => 'New tag';

  @override
  String get setRating => 'Set rating';

  @override
  String get removeRating => 'Remove rating';

  @override
  String get ratingRemoved => 'Rating removed';

  @override
  String get googleTasksImport => 'Import from Google Tasks';

  @override
  String get googleTasksImportDescription =>
      'Import items from Google Tasks to your shopping list.';

  @override
  String get homeWelcome => 'Welcome to Mealie Recipes! 👋';

  @override
  String homeWelcomeNamed(String name) {
    return 'Welcome $name, to Mealie Recipes! 👋';
  }

  @override
  String get shopping => 'Shopping';

  @override
  String get planning => 'Planning';

  @override
  String get other => 'Other';

  @override
  String get viewRecipes => '📖 View Recipes';

  @override
  String get addRecipe => '➕ Add Recipe';

  @override
  String get completeShopping => 'Complete Shopping';

  @override
  String get shoppingCompleted => 'Shopping Completed';

  @override
  String get shoppingCompletedSubtitle => 'All in the cart! 🎉';

  @override
  String get essensplan => '📅 Meal Plan';

  @override
  String get resteverwertung => '🥗 Recipe Finder';

  @override
  String get newRecipeUpload => 'Upload New Recipe';

  @override
  String get copyCode => 'Copy Code';

  @override
  String get shareLink => 'Share Link';

  @override
  String get connectedFriends => 'Connected Friends';

  @override
  String get waitingForFriends => 'Waiting for friends...';

  @override
  String get endSharing => 'End Sharing';

  @override
  String get cookFriendsDescription =>
      'Invite a friend to cook this recipe together';

  @override
  String get sessionCode => 'SESSION CODE';

  @override
  String get adjustQuantityLabel => 'Adjust quantity for this recipe:';

  @override
  String get timerStartForStep => 'Timer for step';

  @override
  String get enterRecipeUrl => 'Enter recipe URL';

  @override
  String get loading => 'Loading...';

  @override
  String get urlInvalidScheme => 'URL must start with http:// or https://';

  @override
  String get urlAddScheme => 'Add https://';

  @override
  String get addItemPlaceholder => 'Add item...';

  @override
  String get addSuccessToast => 'Added!';

  @override
  String get completedItems => 'Completed';

  @override
  String get completeShoppingTitle => 'Complete shopping?';

  @override
  String get completeShoppingMessage => 'Delete completed items?';

  @override
  String get recipeListTitle => '📖 Recipes';

  @override
  String get importRecipeTitle => 'Upload new recipe';

  @override
  String get uploadRecipeUrl => 'Import via Recipe URL';

  @override
  String get uploadRecipeUrlHint =>
      'Enter the recipe URL to save it on your server';

  @override
  String get uploadOpenAI => 'Import from file via OpenAI';

  @override
  String get uploadOpenAIHint =>
      'Alternatively upload photos or a PDF of a recipe. If the recipe spans several pages, just add several — they are analyzed together by AI.';

  @override
  String get takePhoto => 'Camera';

  @override
  String get cameraPermissionDenied =>
      'No access to the camera. Allow it in your system settings to photograph recipes.';

  @override
  String get cameraUnavailable => 'No camera available on this device.';

  @override
  String get selectPhoto => 'Photos';

  @override
  String get selectPdf => 'PDF';

  @override
  String get openAIHintTitle => 'File Analysis Info';

  @override
  String get openAIHintBody =>
      'Recipe analysis uses the OpenAI API. Make sure your API key is configured in the Mealie server settings.';

  @override
  String get allDeleteConfirm => 'Delete all';

  @override
  String get portionen => 'Servings';

  @override
  String get timerForStep => 'Start timer for this step';

  @override
  String get weekNavPrev => 'Previous week';

  @override
  String get weekNavNext => 'Next week';

  @override
  String get noMealsThisWeek => 'No meals planned';

  @override
  String get entriesInOtherWeeks => 'There are entries in other weeks';

  @override
  String get availableWeeks => 'Available weeks:';

  @override
  String weekRange(Object end, Object start, Object week) {
    return 'Week $week ($start – $end)';
  }

  @override
  String get currentWeek => 'Current Week';

  @override
  String get rezepteAktualisieren => 'Update recipes';

  @override
  String get leftoverWhatTitle => 'What does this do?';

  @override
  String get leftoverWhatBody =>
      'This function reloads all recipes from the server and updates the local cache.';

  @override
  String get leftoverDescription =>
      'Enter available ingredients to find matching recipes and use up leftovers.';

  @override
  String get leftoverIngredientsHeader => 'Ingredients at home';

  @override
  String get leftoverSuggestions => 'Recipe suggestions';

  @override
  String get leftoverNoMatches => 'No matching recipes found.';

  @override
  String get leftoverEnterIngredient => 'Enter ingredient';

  @override
  String matchingPercentText(int percent, int count, int total) {
    return '$percent% match ($count/$total)';
  }

  @override
  String get weekAbbreviation => 'Week';

  @override
  String get today => 'Today';

  @override
  String get selectDate => 'Select date';

  @override
  String get selectSlot => 'Select meal';

  @override
  String get selectedRecipe => 'Selected recipe';

  @override
  String get confirmMeal => 'Schedule meal';

  @override
  String get searchRecipes => 'Search recipes';

  @override
  String get addCustomMeal => 'Add custom meal';

  @override
  String get diceModeButton => 'Roll random recipes';

  @override
  String get diceModeTitle => '3 random suggestions';

  @override
  String get diceBackToSearch => 'Back to search';

  @override
  String get diceNotEnoughRecipes =>
      'Not enough recipes for dice mode (need at least 3)';

  @override
  String get entrySingular => 'entry';

  @override
  String get entriesPlural => 'entries';

  @override
  String listTitle(int n) {
    return 'List $n';
  }

  @override
  String get deleteAllConfirmTitle => 'Delete all?';

  @override
  String get deleteAllConfirmMessage =>
      'Do you want to delete all archived purchases?';

  @override
  String get uploadFromUrlButton => 'Import recipe from URL';

  @override
  String get uploadingImage => 'Uploading...';

  @override
  String get uploadErrorTitle => 'Upload failed';

  @override
  String get uploadSuccessTitle => 'Upload successful';

  @override
  String get editImportedRecipeQuestion =>
      'Do you want to edit the new recipe now?';

  @override
  String get notNow => 'Not now';

  @override
  String get pdfTooLarge => 'The PDF file is too large (max 10 MB).';

  @override
  String get invalidUrl => 'Invalid URL. Please enter a valid HTTP(S) URL.';

  @override
  String get cookWithFriends => 'Cook with friends';

  @override
  String get cookFriendsSubtitle =>
      'Invite a friend to cook this recipe together';

  @override
  String get copied => 'Copied';

  @override
  String get linkCopied => 'Link copied';

  @override
  String get startCooking => 'Start cooking';

  @override
  String get hostNoRecipe => 'Open from a recipe to host a session';

  @override
  String get uploadToOwnServer => 'Save to my server';

  @override
  String get uploadingRecipe => 'Uploading recipe…';

  @override
  String get recipeUploadedToOwnServer => 'Recipe saved to your server';

  @override
  String get recipeUploadFailed => 'Upload failed';

  @override
  String get allowGuestSaveRecipes =>
      'Let guests save recipes to their own server';

  @override
  String get appIcon => 'App icon';

  @override
  String get appIconClassic => 'Classic';

  @override
  String get appIconModern => 'Modern';

  @override
  String get name => 'Name';

  @override
  String get color => 'Color';

  @override
  String get randomColor => 'Random color';

  @override
  String get createFailed => 'Could not create';

  @override
  String get deleteFailed => 'Could not delete';

  @override
  String deleteOrganizerConfirm(String name) {
    return 'Delete \"$name\"? This also removes it on the server.';
  }

  @override
  String get connectionSection => 'Connection';

  @override
  String get token => 'Token';

  @override
  String get advancedOptions => 'Advanced options';

  @override
  String get mealieApiVersion => 'Mealie API version';

  @override
  String get sendOptionalHeaders => 'Send optional headers';

  @override
  String get offlineRecipeImages => 'Save recipe images offline';

  @override
  String get offlineRecipeImagesHint =>
      'Downloads all recipe images to this device so they also show without a connection. With large collections this can take up several hundred MB. Turning it off deletes the saved images.';

  @override
  String offlineRecipeImagesStatus(int count, int total, String size) {
    return 'Saved: $count/$total · $size';
  }

  @override
  String get offlineRecipeImagesDisableConfirm =>
      'Delete all saved recipe images?';

  @override
  String headerNameLabel(int n) {
    return 'Header $n name';
  }

  @override
  String headerValueLabel(int n) {
    return 'Header $n value';
  }

  @override
  String get value => 'Value';

  @override
  String get personalization => 'Personalization';

  @override
  String get showRecipeImagesSubtitle => 'Shows images in the recipe list';

  @override
  String get exactQuantities => 'Add exact quantities';

  @override
  String get exactQuantitiesSubtitle =>
      'Ingredients & typed items keep quantity and unit (e.g. 200 g butter) instead of 1x per item — missing foods are created on the server';

  @override
  String get remindToShop => 'Remind me to shop';

  @override
  String get remindToShopSubtitle =>
      'Notifies you when you\'re near a saved location and your shopping list has open items — even if the app is closed';

  @override
  String get shoppingReminderAddLocation => 'Add location';

  @override
  String get shoppingReminderMaxLocations => 'Maximum of 3 locations reached';

  @override
  String get shoppingReminderLocationServiceDisabled =>
      'Location services are turned off on this device';

  @override
  String get shoppingReminderPermissionTitle => 'Location access needed';

  @override
  String get shoppingReminderPermissionMessage =>
      'To remind you when you\'re near a shop, this needs \"Always\" location access — even while the app is closed. Please enable it in Settings.';

  @override
  String get openSettings => 'Open Settings';

  @override
  String get shoppingReminderLocationName => 'Name';

  @override
  String get shoppingReminderUseCurrentLocation => 'Use current location';

  @override
  String get shoppingReminderOrAddress => 'or enter an address';

  @override
  String get shoppingReminderAddress => 'Address';

  @override
  String get shoppingReminderAddressPlaceholder => 'Street, city';

  @override
  String get shoppingReminderSearchAddress => 'Search';

  @override
  String get shoppingReminderLocationFailed =>
      'Couldn\'t determine your location';

  @override
  String get shoppingReminderAddressNotFound => 'Address not found';

  @override
  String get ratingFailed =>
      'The rating could not be saved — please try again.';

  @override
  String get lastCooked => 'Last made';

  @override
  String get syncLastCooked => 'Update “last made”';

  @override
  String get syncLastCookedSubtitle =>
      'Saves today\'s date and a timeline entry on the server — like the Mealie web app.';

  @override
  String get developer => 'Developer';

  @override
  String get enableLoggingSubtitle =>
      'Records print/error logs (last 500 lines)';

  @override
  String get entriesLabel => 'Entries';

  @override
  String get fileSize => 'File size';

  @override
  String get showAction => 'Show';

  @override
  String get copy => 'Copy';

  @override
  String logsWithCount(int count) {
    return 'Logs ($count)';
  }

  @override
  String get noLogs => 'No logs available';

  @override
  String get logsTitle => 'Logs';

  @override
  String get required => 'Required';

  @override
  String get connectionFailedCheck => 'Connection failed. Check URL and token.';

  @override
  String get username => 'Username';

  @override
  String get password => 'Password';

  @override
  String get setupPasswordHint =>
      'Your password is not stored — the app logs you in once and generates an API token from it (same as Profile → API Tokens in the web app).';

  @override
  String get loginAndConnect => 'Log in & connect';

  @override
  String get loginInvalidCredentials => 'Username or password is incorrect.';

  @override
  String get loginAndGenerateToken => 'Log in & generate token';

  @override
  String get loggingIn => 'Signing in…';

  @override
  String get apiTokenSaveHint =>
      'Token applied — please tap “Save changes” below.';

  @override
  String get renewApiToken => 'Renew API token';

  @override
  String get setupAuthChoiceTitle => 'How would you like to sign in?';

  @override
  String get authModePasswordTitle => 'Let the app create an API key for me';

  @override
  String get authModePasswordSubtitle =>
      'Sign in with username & password — the app generates a token automatically.';

  @override
  String get authModeTokenTitle => 'I already have an API key';

  @override
  String get authModeTokenSubtitle =>
      'Copied from the Mealie profile (Profile → API Tokens).';

  @override
  String keyN(int n) {
    return 'Key $n';
  }

  @override
  String valueN(int n) {
    return 'Value $n';
  }

  @override
  String get openCookingMode => 'Open cooking mode';

  @override
  String activeRecipes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count active recipes',
      one: '1 active recipe',
    );
    return '$_temp0';
  }

  @override
  String get reparseIngredients => 'Re-parse ingredients';

  @override
  String get reparseIngredientsSubtitle =>
      'Split quantity/unit/ingredient (e.g. “200 g flour”)';

  @override
  String get reparseDone => 'Ingredients split – tap “Save changes” to apply';

  @override
  String get reparseNone => 'No splittable ingredients found';

  @override
  String get tagsAndCategories => 'Tags, categories & tools';

  @override
  String get tapToAddPhoto => 'Tap to add photo';

  @override
  String get descriptionLabel => 'Description';

  @override
  String get searchingDevices => 'Searching for devices on the same Wi-Fi…';

  @override
  String get selectAll => 'Select all';

  @override
  String get importReminders => 'Import reminders';

  @override
  String get importGoogleTasks => 'Import Google Tasks';

  @override
  String get noTaskLists => 'No task lists found';

  @override
  String get noReminderLists => 'No reminder lists found';

  @override
  String importCount(int count) {
    return 'Import $count';
  }

  @override
  String get activeRecipeTimer => 'Active recipe timer';

  @override
  String get linkIngredients => 'Link ingredients';

  @override
  String get noIngredientsToLink => 'No ingredients to link yet';

  @override
  String get importLanguageSubtitle =>
      'Language for recipes imported from a photo or PDF';

  @override
  String get importLanguageSearch => 'Search language';

  @override
  String get importLanguageFollowApp => 'Same as app language';

  @override
  String get importLanguageNoMatch => 'No language found';

  @override
  String get setupImportLanguageTitle => 'AI recipe import';

  @override
  String get setupImportLanguageBody =>
      'Photos and PDFs can be turned into recipes by AI. Pick the language they should end up in — handy if your mother tongue is not available as an app language. You can change this later in the settings.';

  @override
  String get setupImportLanguageSearchHint =>
      'Use the search in the picker to find languages the app interface does not offer.';

  @override
  String get setupCachingKeepOpenTitle => 'Please keep the app open';

  @override
  String get setupCachingKeepOpenBody =>
      'Loading runs in the foreground. Leave the app open until it finishes — if you close it or switch away for too long, the process stops and starts over later.';

  @override
  String get supportContact => 'Contact support';

  @override
  String get supportDialogMessage =>
      'Describe your problem and we will get back to you. The log helps a lot with troubleshooting — you can attach it as a text file.';

  @override
  String get supportWithoutLogs => 'Without log';

  @override
  String get supportWithLogs => 'Attach log';

  @override
  String get supportMailSubject => 'Mealie Recipes — Support';

  @override
  String get supportMailHint => 'Please describe your problem here:';

  @override
  String get supportLogsEmpty =>
      'The log is empty. Turn on logging, reproduce the problem and then send it.';

  @override
  String supportAddressCopied(String email) {
    return 'Address copied: $email';
  }

  @override
  String supportNoMailApp(String email) {
    return 'No mail app found. Address copied: $email';
  }

  @override
  String get createRecipeFromImages => 'Create recipe';

  @override
  String imagePagesSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pages selected',
      one: '1 page selected',
    );
    return '$_temp0';
  }

  @override
  String get imagePagesHint =>
      'The first image becomes the recipe\'s main image. Press and hold a page to reorder it.';

  @override
  String get mainImageBadge => 'Main';

  @override
  String maxImagesReached(int max) {
    return 'You can add up to $max images per recipe.';
  }

  @override
  String get removePage => 'Remove page';

  @override
  String get preparingPdf => 'Processing PDF...';

  @override
  String get shareRecipeTitle => 'Share recipe';

  @override
  String get recipeOptionsTitle => 'Options';

  @override
  String get exportAsPdf => 'Export as PDF';

  @override
  String get generatingPdf => 'Generating PDF…';

  @override
  String get pdfExportFailed => 'PDF export failed';

  @override
  String get recipeTime => 'Time';

  @override
  String get ingredientSectionTitle => 'Section';

  @override
  String get addIngredientSection => 'Add section';

  @override
  String get aiImportToggle => 'Analyze with AI';

  @override
  String get aiImportToggleHint =>
      'Also for recipe videos (YouTube, Instagram, TikTok …) and pages the regular import can\'t read. Requires an AI provider on your Mealie server — for videos also an audio provider.';

  @override
  String get aiImportButton => 'Import with AI';

  @override
  String get aiImportRunning =>
      'The AI is analyzing the link … videos can take a few minutes.';

  @override
  String get aiImportFailed =>
      'The AI import failed. Check the AI settings on your Mealie server.';

  @override
  String get stepHeadingLabel => 'Step heading (optional)';

  @override
  String get linkedRecipeLabel => 'Linked recipe';

  @override
  String get toolsTitle => 'Tools';

  @override
  String get prepareTools => 'Please get the following tools ready';

  @override
  String get newTool => 'New tool';

  @override
  String get renameAction => 'Rename';

  @override
  String get organizerEmpty =>
      'Nothing here yet. Tap “+” in the top right to create one.';

  @override
  String organizerRecipeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count recipes',
      one: '1 recipe',
      zero: 'No recipes',
    );
    return '$_temp0';
  }

  @override
  String get toolOnHand => 'On hand';

  @override
  String get mealDiceSettingsTitle => 'Dice filter';

  @override
  String get mealDiceSettingsHint =>
      'Choose categories and tags for each meal. When you roll the dice, only recipes with at least one of them are suggested. The same entry can be used for several meals.';

  @override
  String get mealDiceSettingsNoneHint =>
      'Nothing selected for this meal: the dice picks automatically by category names like “Breakfast”, “Lunch” or “Dinner”.';

  @override
  String get mealDiceAutoHintTitle => 'Automatic selection';

  @override
  String get mealDiceAutoHintBody =>
      'No categories or tags are set for this meal yet. The dice therefore looks for categories like “Breakfast”, “Lunch” or “Dinner” and fills up with other recipes.\n\nTo choose your own: in the meal plan, tap the gear icon next to “+”.';

  @override
  String get dontShowAgain => 'Don\'t show again';

  @override
  String get mealDiceNoMatches =>
      'No recipe matches the categories and tags selected for this meal.';

  @override
  String mealDiceFewMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Only $count matching recipes',
      one: 'Only 1 matching recipe',
    );
    return '$_temp0';
  }

  @override
  String get commentsTitle => 'Comments';

  @override
  String get commentHint => 'Write a comment…';

  @override
  String get commentSaveFailed => 'The comment could not be saved.';

  @override
  String get commentDeleteConfirm => 'Delete this comment?';

  @override
  String get cookingDoneCommentLabel => 'Comment (optional)';

  @override
  String get cookingDoneCommentHint =>
      'How did it turn out? Tips for next time…';

  @override
  String get nutritionTitle => 'Nutrition';

  @override
  String get nutritionPerServing => 'per serving';

  @override
  String get nutritionCalories => 'Calories';

  @override
  String get nutritionFat => 'Fat';

  @override
  String get nutritionSaturatedFat => 'Saturated fat';

  @override
  String get nutritionTransFat => 'Trans fat';

  @override
  String get nutritionUnsaturatedFat => 'Unsaturated fat';

  @override
  String get nutritionCholesterol => 'Cholesterol';

  @override
  String get nutritionSodium => 'Sodium';

  @override
  String get nutritionCarbohydrates => 'Carbohydrates';

  @override
  String get nutritionFiber => 'Fiber';

  @override
  String get nutritionSugar => 'Sugar';

  @override
  String get nutritionProtein => 'Protein';

  @override
  String get timelineTitle => 'Timeline';

  @override
  String get timelineMadeThis => 'I made this';

  @override
  String timelineUserMadeThis(String name) {
    return '$name made this';
  }

  @override
  String get timelineEmpty => 'No timeline entries yet.';

  @override
  String get timelineDate => 'Date';

  @override
  String get timelineNoteHint => 'Note (optional)';

  @override
  String get timelineAddPhoto => 'Add photo';

  @override
  String get timelineRemovePhoto => 'Remove photo';

  @override
  String get timelineSaved => 'Added to the timeline';

  @override
  String get timelineSaveFailed => 'Could not add to the timeline';

  @override
  String get timelineImageFailed =>
      'Entry saved, but the photo could not be uploaded';

  @override
  String get timelineDeleteConfirm => 'Delete this entry from the timeline?';

  @override
  String get timelineEditNote => 'Edit note';

  @override
  String get timelineUnknownRecipe => 'Recipe not found';

  @override
  String get cookingDonePhotoHint => 'Photo for the Mealie timeline (optional)';

  @override
  String get assetsTitle => 'Attachments';

  @override
  String get assetsAdd => 'Add attachment';

  @override
  String get assetsChooseFile => 'File';

  @override
  String get assetsUploading => 'Uploading…';

  @override
  String get assetsUploadFailed => 'Attachment could not be uploaded';

  @override
  String assetsDeleteConfirm(String name) {
    return 'Remove “$name” from the attachments?';
  }

  @override
  String get assetsOpenFailed => 'Attachment could not be opened';

  @override
  String get assetsUnsupported =>
      'Mealie only supports PDF, images, TXT, MD, CSV and JSON.';

  @override
  String get assetsShare => 'Share';

  @override
  String get mealRulesTitle => 'Mealie rules';

  @override
  String get mealRulesHint =>
      'Also used by the Mealie web app. If several rules apply to the day and meal, all of them must match. If no rule applies, the dice picks from all recipes.';

  @override
  String get mealRuleAdd => 'Add rule';

  @override
  String get mealRuleNewTitle => 'New rule';

  @override
  String get mealRuleEditTitle => 'Edit rule';

  @override
  String get mealRuleDay => 'Day';

  @override
  String get mealRuleAnyDay => 'Any day';

  @override
  String get mealRuleMealType => 'Meal';

  @override
  String get mealRuleAnyMeal => 'Any meal';

  @override
  String get mealRuleConditionsTitle => 'Conditions';

  @override
  String get mealRuleAllRecipes => 'All recipes';

  @override
  String get mealRuleDeleteConfirm => 'Delete this rule?';

  @override
  String get mealRulesOffline =>
      'Mealie rules are unavailable right now – the dice uses the app selection.';

  @override
  String get mealRulesNoMatches =>
      'No recipes match the Mealie rules for this meal.';

  @override
  String get mealTypeSide => 'Side';

  @override
  String get mealTypeSnack => 'Snack';

  @override
  String get mealTypeDrink => 'Drink';

  @override
  String get mealTypeDessert => 'Dessert';

  @override
  String get foodsTitle => 'Foods';

  @override
  String get unitsTitle => 'Units';

  @override
  String get newFood => 'New food';

  @override
  String get newUnit => 'New unit';

  @override
  String get editFood => 'Edit food';

  @override
  String get editUnit => 'Edit unit';

  @override
  String get pluralNameLabel => 'Plural name';

  @override
  String get abbreviationLabel => 'Abbreviation';

  @override
  String get pluralAbbreviationLabel => 'Plural abbreviation';

  @override
  String get mergeAction => 'Merge';

  @override
  String mergeIntoTitle(String name) {
    return 'Merge “$name” into…';
  }

  @override
  String mergeConfirm(String from, String to) {
    return '“$from” will be merged into “$to”: all recipes and shopping lists will use “$to” afterwards, and “$from” will be deleted.';
  }

  @override
  String get mergeFailed => 'Merge failed';

  @override
  String foodUnitDeleteConfirm(String name) {
    return 'Delete “$name”? Ingredients that use it will lose the reference.';
  }

  @override
  String get foodsUnitsEmpty => 'No entries yet.';

  @override
  String mealRuleConditionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count conditions',
      one: '1 condition',
    );
    return '$_temp0';
  }

  @override
  String get showAll => 'Show all';

  @override
  String get mealDiceModeTitle => 'Dice uses';

  @override
  String get mealDiceModeApp => 'App selection';

  @override
  String get switchListTitle => 'Switch list';

  @override
  String get newShoppingList => 'New shopping list';

  @override
  String shoppingListDeleteConfirm(String name) {
    return 'Delete “$name”? All items in it will be deleted too.';
  }

  @override
  String get labelOrderTitle => 'Sort labels';

  @override
  String get labelOrderHint =>
      'Drag to sort. Applies to this list – in the Mealie web app too.';

  @override
  String get labelOrderEmpty => 'This list has no labels yet.';

  @override
  String get useAsActiveList => 'Use as active list';

  @override
  String get activeListBadge => 'Active';

  @override
  String get foodLabelLabel => 'Label';

  @override
  String get foodNoLabel => 'No label';

  @override
  String get aliasesLabel => 'Aliases';

  @override
  String get aliasAddHint => 'Add alias';

  @override
  String get foodOnHand => 'On hand in the household';

  @override
  String get timelineChildRecipesTitle => 'Also add for linked recipes';

  @override
  String timelineMadeForRecipe(String recipe) {
    return 'Made for $recipe';
  }

  @override
  String get timelineFilter => 'Filter entries';

  @override
  String get timelineTypeComment => 'Made & notes';

  @override
  String get timelineTypeInfo => 'Info';

  @override
  String get timelineTypeSystem => 'System';

  @override
  String get listManagementTitle => 'Shopping lists';

  @override
  String get managementTitle => 'More';

  @override
  String get pinToHome => 'Add to home screen';

  @override
  String get unpinFromHome => 'Remove from home screen';

  @override
  String homeScreenFull(int count) {
    return 'The home screen is full – at most $count tiles. Remove another tile under “More” first.';
  }

  @override
  String get selectAction => 'Select';

  @override
  String selectedCount(int count) {
    return '$count selected';
  }

  @override
  String get assignLabelAction => 'Assign label';

  @override
  String get assignLabelOverwriteHint =>
      'Overwrites the label of all selected foods.';

  @override
  String deleteSelectedConfirm(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Delete $count entries?',
      one: 'Delete 1 entry?',
    );
    return '$_temp0';
  }

  @override
  String get seedDataAction => 'Load default data';

  @override
  String get seedFoodsHint =>
      'Creates Mealie\'s default foods in the selected language.';

  @override
  String get seedUnitsHint =>
      'Creates Mealie\'s default units in the selected language.';

  @override
  String get seedLanguageLabel => 'Language';

  @override
  String get seedDuplicateWarning =>
      'You already have entries. Mealie does not reconcile duplicates – you\'ll have to merge them yourself afterwards.';

  @override
  String get seedDone => 'Default data created';

  @override
  String get seedFailed => 'Default data could not be loaded';

  @override
  String get exportAction => 'Export';

  @override
  String get substitutionsLabel => 'Substitutes';

  @override
  String get substitutionAddHint => 'Add substitute';

  @override
  String get substitutionFoodLabel => 'Food (optional)';

  @override
  String get substitutionNoteLabel => 'Note (optional)';

  @override
  String get substitutionNeedOne => 'Enter a food or a note';

  @override
  String get useAbbreviationLabel => 'Use abbreviation';

  @override
  String get useAbbreviationHint => 'Show “g” instead of “gram” in recipes';

  @override
  String get fractionLabel => 'Display as fraction';

  @override
  String get fractionHint => '½ instead of 0.5';

  @override
  String get standardizationTitle => 'Standardization';

  @override
  String get standardizationHint =>
      'For conversions: 1 of this unit equals … (e.g. 1 tbsp = 15 milliliters).';

  @override
  String get standardQuantityLabel => 'Standard quantity';

  @override
  String get standardUnitLabel => 'Standard unit';

  @override
  String get standardUnitNone => 'None';

  @override
  String get stdFluidOunce => 'Fluid ounce (fl oz)';

  @override
  String get stdCup => 'Cup (US)';

  @override
  String get stdOunce => 'Ounce (oz)';

  @override
  String get stdPound => 'Pound (lb)';

  @override
  String get stdMilliliter => 'Milliliter';

  @override
  String get stdLiter => 'Liter';

  @override
  String get stdGram => 'Gram';

  @override
  String get stdKilogram => 'Kilogram';

  @override
  String get labelsTitle => 'Labels';

  @override
  String get newLabel => 'New label';

  @override
  String get editLabel => 'Edit label';

  @override
  String get colorLabel => 'Color';

  @override
  String labelDeleteConfirm(String name) {
    return 'Delete “$name”? Items and foods will lose this label.';
  }

  @override
  String get importMenuAction => 'Import';

  @override
  String get archivedEmpty =>
      'No archived purchases yet. Tap “Complete Shopping” after shopping – the checked items will be stored here.';

  @override
  String get sectionTitleLabel => 'Section title';

  @override
  String get clearSection => 'Clear section';

  @override
  String get noPermissionGeneric =>
      'You don\'t have permission for this in Mealie. Ask an admin or household manager.';

  @override
  String get noPermissionEditRecipe =>
      'You can\'t edit this recipe – it\'s locked or belongs to another household. Only its creator or an admin can.';

  @override
  String get noPermissionDeleteRecipe =>
      'Only the recipe\'s creator or an admin can delete it.';

  @override
  String get noPermissionDemoteSelf =>
      'You can\'t remove your own admin rights.';

  @override
  String get recipeLockedHint => 'Locked – only its creator can edit it';

  @override
  String get recipeDeleteOwnerOnlyHint =>
      'Only its creator or an admin can delete';

  @override
  String get organizeReadOnlyHint =>
      'View only: creating, changing and deleting requires the permission “User can manage foods, tags, and categories”.';

  @override
  String get notesNotSavedNoPermission =>
      'Note not saved – you don\'t have permission to edit this recipe.';

  @override
  String get userManagementTitle => 'User Management';

  @override
  String get usersTitle => 'Users';

  @override
  String get editUserTitle => 'Edit User';

  @override
  String get fullNameLabel => 'Full Name';

  @override
  String get usernameLabel => 'Username';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get householdLabel => 'Household';

  @override
  String get permissionsTitle => 'Permissions';

  @override
  String get administratorLabel => 'Administrator';

  @override
  String get permCanInvite => 'User can invite others to group';

  @override
  String get permCanManage => 'User can manage group settings';

  @override
  String get permCanManageHousehold => 'User can manage household';

  @override
  String get permCanOrganize => 'User can manage foods, tags, and categories';

  @override
  String get advancedFeaturesLabel => 'Enable advanced features';

  @override
  String get passwordResetLinkAction => 'Generate Password Reset Link';

  @override
  String get resetLockedUsersAction => 'Reset Locked Users';

  @override
  String get membersTitle => 'Members';

  @override
  String get inviteLinkTitle => 'Invite Link';

  @override
  String get inviteAction => 'Invite';

  @override
  String get userUpdated => 'User updated';

  @override
  String get createUserTitle => 'Create user';

  @override
  String get userCreated => 'User created';

  @override
  String userDeleteConfirm(String name) {
    return 'Delete “$name”? The account will be removed from Mealie.';
  }

  @override
  String get passwordResetLinkCopied =>
      'Link copied – pass it on to the user. It is only valid for a limited time.';

  @override
  String lockedUsersReset(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count users unlocked',
      one: '1 user unlocked',
      zero: 'No locked users',
    );
    return '$_temp0';
  }

  @override
  String get inviteUsesLabel => 'Number of uses';

  @override
  String get inviteCreated => 'Invite link created';

  @override
  String get inviteEmailHint =>
      'Email address (optional – Mealie will send the invitation)';

  @override
  String get inviteEmailSent => 'Invitation sent by email';

  @override
  String get inviteEmailFailed =>
      'The email couldn\'t be sent (is SMTP set up in Mealie?). The link still works.';

  @override
  String get copyLinkAction => 'Copy link';

  @override
  String get youLabel => 'You';

  @override
  String get membersPermissionsHint =>
      'You can change the permissions of your household members – but not your own.';

  @override
  String get householdManagementTitle => 'Household Management';

  @override
  String get householdsTitle => 'Households';

  @override
  String get createHouseholdTitle => 'Create Household';

  @override
  String get householdNameLabel => 'Household Name';

  @override
  String get householdPreferencesTitle => 'Household Preferences';

  @override
  String get privateHouseholdLabel => 'Private Household';

  @override
  String get privateHouseholdHint =>
      'Setting your household to private will disable all public view options. This overrides any individual public view settings';

  @override
  String get lockRecipeEditsLabel => 'Lock recipe edits from other households';

  @override
  String get lockRecipeEditsHint =>
      'When enabled only users in your household can edit recipes created by your household';

  @override
  String get householdRecipePreferencesTitle => 'Household Recipe Preferences';

  @override
  String get groupsTitle => 'Groups';

  @override
  String get groupLabel => 'Group';

  @override
  String get createGroupTitle => 'Create Group';

  @override
  String get groupNameLabel => 'Group Name';

  @override
  String get groupPreferencesTitle => 'Group Preferences';

  @override
  String get privateGroupLabel => 'Private Group';

  @override
  String get privateGroupHint =>
      'Setting your group to private will disable all public view options. This overrides any individual public view settings';

  @override
  String get firstDayOfWeekLabel => 'First day of the week';

  @override
  String get showAnnouncementsLabel => 'Show announcements from Mealie';

  @override
  String get recipePublicDefaultLabel =>
      'Allow users outside of your group to see your recipes';

  @override
  String get recipeShowNutritionDefaultLabel => 'Show nutrition information';

  @override
  String get recipeShowAssetsDefaultLabel => 'Show recipe assets';

  @override
  String get recipeLandscapeDefaultLabel => 'Default to landscape view';

  @override
  String get recipeDisableCommentsDefaultLabel =>
      'Disable users from commenting on recipes';

  @override
  String get myHouseholdSection => 'My household';

  @override
  String get myGroupSection => 'My group';

  @override
  String get preferencesSaved => 'Settings saved';

  @override
  String get cannotDeleteWithUsers =>
      'Still has users – move or delete them in User Management first.';

  @override
  String deleteHouseholdConfirm(String name) {
    return 'Delete household “$name”?';
  }

  @override
  String deleteGroupConfirm(String name) {
    return 'Delete group “$name”?';
  }

  @override
  String usersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count users',
      one: '1 user',
      zero: 'No users',
    );
    return '$_temp0';
  }

  @override
  String get originalUrlLabel => 'Original URL';

  @override
  String get copyTextAction => 'Copy text';

  @override
  String get copiedToClipboard => 'Copied to clipboard';

  @override
  String get changelogEnglishHint =>
      'The release notes are available in English only.';

  @override
  String get favoritesTitle => 'Favorites';

  @override
  String get favoritesEmpty =>
      'No favorites yet. Tap the heart on a recipe to collect it here.';

  @override
  String get changelogTitle => 'Changelog';

  @override
  String get changeProfileImage => 'Change profile picture';

  @override
  String get profileImageUpdated => 'Profile picture updated';

  @override
  String get profileImageFailed => 'Profile picture could not be uploaded';

  @override
  String get myAccountTitle => 'My account';

  @override
  String get ownAccountHint =>
      'Here you can edit your own account. Other users are managed by administrators and members with the \"manage\" permission.';

  @override
  String get changePasswordAction => 'Change password';

  @override
  String get currentPasswordLabel => 'Current password';

  @override
  String get newPasswordLabel => 'New password';

  @override
  String get confirmPasswordLabel => 'Confirm password';

  @override
  String get passwordTooShort => 'At least 8 characters';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get passwordUpdated => 'Password updated';

  @override
  String get passwordChangeFailed => 'Password could not be changed';

  @override
  String passwordManagedExternally(String method) {
    return 'You sign in via $method — change your password there.';
  }

  @override
  String get bulkAddHint => 'One line per entry.';

  @override
  String bulkAddCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Add $count entries',
      one: 'Add 1 entry',
    );
    return '$_temp0';
  }

  @override
  String get linkRecipeAction => 'Link recipe';

  @override
  String get useFoodAction => 'Use food instead of recipe';

  @override
  String get addSubstitutionsAction => 'Add substitutions';

  @override
  String get clearSubstitutionsAction => 'Clear substitutions';

  @override
  String get recipeSubstitutionsTitle => 'Substitutions';

  @override
  String get substitutionUnknownFood =>
      'Existing foods only – use the note otherwise';

  @override
  String get insertAboveAction => 'Insert above';

  @override
  String get insertBelowAction => 'Insert below';

  @override
  String get moveToTopAction => 'Move to top';

  @override
  String get moveToBottomAction => 'Move to bottom';

  @override
  String get linkReferencesAction => 'Link references';

  @override
  String get editMarkdownAction => 'Edit Markdown';

  @override
  String get previewMarkdownAction => 'Preview Markdown';

  @override
  String get insertStepImageAction => 'Upload image';

  @override
  String get mergeAboveAction => 'Merge above';

  @override
  String get linkedToOtherStep => 'Linked to other step';

  @override
  String get noNotesToLink => 'No notes to link';

  @override
  String get ownerLabel => 'Owner';

  @override
  String get ingredientParserTitle => 'Ingredient Parser';

  @override
  String ingredientParserHint(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count ingredients aren\'t structured yet. Pick a parser, check the result, apply.',
      one:
          '1 ingredient isn\'t structured yet. Pick a parser, check the result, apply.',
    );
    return '$_temp0';
  }

  @override
  String get parserNlp => 'Natural Language Processor';

  @override
  String get parserBrute => 'Brute Parser';

  @override
  String get parserOpenai => 'OpenAI Parser';

  @override
  String get parserApp => 'Offline (app)';

  @override
  String get parseFailed => 'Parsing failed';

  @override
  String get parseAction => 'Parse';

  @override
  String applyParsedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Apply $count ingredients',
      one: 'Apply 1 ingredient',
      zero: 'Nothing selected',
    );
    return '$_temp0';
  }

  @override
  String get parsedNewBadge => 'new';

  @override
  String get hoursShort => 'h';

  @override
  String get minutesShort => 'min';

  @override
  String get timeExtraHint => 'Extra, e.g. “plus overnight”';

  @override
  String get yieldLabel => 'Yield';

  @override
  String get yieldTextLabel => 'Yield Text';

  @override
  String get prepTimeLabel => 'Prep Time';

  @override
  String get performTimeLabel => 'Cook Time';

  @override
  String get totalTimeLabel => 'Total Time';

  @override
  String get settingPublicRecipe => 'Public Recipe';

  @override
  String get settingShowNutrition => 'Show Nutrition Values';

  @override
  String get settingShowAssets => 'Show Assets';

  @override
  String get settingLandscapeView => 'Landscape View';

  @override
  String get settingDisableComments => 'Disable Comments';

  @override
  String get settingDisableAmount => 'Disable Ingredient Amounts';

  @override
  String get settingLocked => 'Locked';

  @override
  String get settingLockedOwnerOnly =>
      'Only the creator can lock or unlock the recipe.';

  @override
  String get apiExtrasTitle => 'API Extras';

  @override
  String get apiExtrasHint =>
      'Custom key/value pairs for 3rd party applications, e.g. to trigger automations.';

  @override
  String get extraKeyLabel => 'Key';

  @override
  String get extraValueLabel => 'Value';

  @override
  String get addExtraAction => 'Add extra';

  @override
  String durationHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hours',
      one: '1 hour',
    );
    return '$_temp0';
  }

  @override
  String durationMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutes',
      one: '1 minute',
    );
    return '$_temp0';
  }

  @override
  String get discardChangesConfirm => 'Discard unsaved changes?';

  @override
  String get discardChanges => 'Discard Changes';

  @override
  String get imageFromUrl => 'Image from URL';

  @override
  String get deleteRecipeImage => 'Delete Recipe Image';

  @override
  String get deleteRecipeImageConfirm =>
      'Are you sure you want to delete this recipe image?';

  @override
  String get bulkAddIngredients => 'Bulk add ingredients';

  @override
  String get bulkAddSteps => 'Bulk add steps';

  @override
  String get stepImageFailed => 'Image could not be uploaded';

  @override
  String get servingsAndTimes => 'Servings & times';

  @override
  String get recipeSettingsTitle => 'Recipe Settings';

  @override
  String get jsonEditorTitle => 'JSON Editor';

  @override
  String get jsonInvalid => 'Invalid JSON – please check.';

  @override
  String get editorOfflineHint =>
      'Opened offline: saving needs a connection. Newer Mealie fields (e.g. substitutions) are kept unchanged.';

  @override
  String get parseLineFailed => 'Not recognized – stays unchanged';

  @override
  String get createManualTitle => 'Create recipe manually';

  @override
  String get createManualHint =>
      'Enter a name – add ingredients, steps, image and everything else afterwards in the recipe editor.';

  @override
  String get createManualButton => 'Create & edit';

  @override
  String get changelogEmpty => 'No entries for this version yet.';

  @override
  String get finderDescription =>
      'Search for recipes based on ingredients you have on hand. You can also filter by tools you have available, and set a maximum number of missing ingredients or tools.';

  @override
  String get finderSelectedIngredients => 'Selected Ingredients';

  @override
  String get finderNoIngredientsSelected => 'No ingredients selected';

  @override
  String get finderMissing => 'Missing';

  @override
  String get finderNoRecipesFound => 'No recipes found';

  @override
  String get finderNoRecipesFoundDescription =>
      'Try adding more ingredients to your search or adjusting your filters';

  @override
  String get finderIncludeFoodsOnHand => 'Include Ingredients On Hand';

  @override
  String get finderIncludeToolsOnHand => 'Include Tools On Hand';

  @override
  String get finderIncludeSubstitutions => 'Include Substitutions';

  @override
  String get finderSubstituting => 'Substituting';

  @override
  String finderSubstituteForFood(String substitute, String food) {
    return '$substitute for $food';
  }

  @override
  String get finderMaxMissingIngredients => 'Max Missing Ingredients';

  @override
  String get finderMaxMissingTools => 'Max Missing Tools';

  @override
  String get finderSelectedTools => 'Selected Tools';

  @override
  String get finderReadyToMake => 'Ready to Make';

  @override
  String get finderAlmostReadyToMake => 'Almost Ready to Make';

  @override
  String get finderSettings => 'Settings';

  @override
  String get finderLoadingRecipes => 'Loading Recipes';

  @override
  String get finderClearSelection => 'Clear Selection';

  @override
  String get finderOfflineHint =>
      'No connection to the server – results come from the recipes stored on this device.';

  @override
  String addIngredientsSkippedOnHand(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Added to your shopping list – $count ingredients on hand were skipped.',
      one: 'Added to your shopping list – 1 ingredient on hand was skipped.',
    );
    return '$_temp0';
  }

  @override
  String get sendPeerOfflineHint =>
      'Not reachable right now – arrives when the app is opened there';

  @override
  String sendDeliveredLater(String device) {
    return '“$device” is not reachable right now. The recipe will arrive as soon as the app is opened there.';
  }

  @override
  String get sendQueuedOffline =>
      'No connection right now. The recipe will be sent automatically as soon as you\'re back online.';

  @override
  String get searchHasAll => 'Has All';

  @override
  String get searchHasAny => 'Has Any';

  @override
  String get recipeFilterTitle => 'Filter';

  @override
  String get finderOtherFilters => 'Other Filters';

  @override
  String get qfOpEquals => 'equals';

  @override
  String get qfOpNotEquals => 'does not equal';

  @override
  String get qfOpGreater => 'is greater than';

  @override
  String get qfOpGreaterEq => 'is greater than or equal to';

  @override
  String get qfOpLess => 'is less than';

  @override
  String get qfOpLessEq => 'is less than or equal to';

  @override
  String get qfOpNewerThan => 'is newer than';

  @override
  String get qfOpOlderThan => 'is older than';

  @override
  String qfDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days ago',
      one: '1 day ago',
    );
    return '$_temp0';
  }

  @override
  String get filterResetAll => 'Reset all filters';

  @override
  String get filterAny => 'Any';

  @override
  String get filterOfflineIgnored =>
      'Offline, the “Other Filters” can only be applied in their simple form.';

  @override
  String linkedRecipesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Linked Recipes',
      one: 'One Linked Recipe',
      zero: 'No Linked Recipes',
    );
    return '$_temp0';
  }

  @override
  String get shoppingReminderNotificationsOff =>
      'Notifications are turned off for Mealie Recipes — without them the shopping reminder can\'t appear. Please allow notifications in the settings.';

  @override
  String get shoppingReminderInactiveHint =>
      'The shopping reminder can\'t work right now: please set location access to “Always” and allow notifications.';

  @override
  String get bulkImportTitle => 'Bulk URL Import';

  @override
  String get bulkImportDescription =>
      'The Bulk recipe importer allows you to import multiple recipes at once by queueing the sites on the backend and running the task in the background. This can be useful when initially migrating to Mealie, or when you want to import a large number of recipes.';

  @override
  String get bulkAddTitle => 'Bulk Add';

  @override
  String get bulkImportSetOrganizers => 'Set Categories and Tags';

  @override
  String get bulkImportStarted => 'Bulk Import process has started';

  @override
  String get bulkImportFailed => 'Bulk import process has failed';

  @override
  String get bulkImportReports => 'Bulk Imports';

  @override
  String get bulkImportUrlHint => 'Recipe URL';

  @override
  String get migrationsTitle => 'Data Migrations';

  @override
  String get migrationsDescription =>
      'Recipes can be migrated from another supported application to Mealie. This is a great way to get started with Mealie. Moving data between Mealie instances, or restoring an earlier Mealie backup, is done with the backup and restore tools instead.';

  @override
  String get migrationNew => 'New Migration';

  @override
  String get migrationChooseType => 'Choose Migration Type';

  @override
  String get noFileSelected => 'No File Selected';

  @override
  String migrationTagAll(String tag) {
    return 'Tag all recipes with $tag tag';
  }

  @override
  String get migrationPrevious => 'Previous Migrations';

  @override
  String get migrationMealieDescription =>
      'Mealie can import recipes from the Mealie application from a pre v1.0 release. Export your recipes from your old instance, and upload the zip file below. Note that only recipes can be imported from the export. This applies only to instances older than v1.0. A backup taken from v1.0 or later should be restored with the backup and restore tools.';

  @override
  String get migrationChowdownDescription =>
      'Mealie natively supports the chowdown repository format. Download the code repository as a .zip file and upload it below.';

  @override
  String get migrationCopyMeThatDescription =>
      'Mealie can import recipes from Copy Me That. Export your recipes in HTML format, then upload the .zip below.';

  @override
  String get migrationMyRecipeBoxDescription =>
      'Mealie can import recipes from My Recipe Box. Export your recipes in CSV format, then upload the .csv file below.';

  @override
  String get migrationNextcloudDescription =>
      'Nextcloud recipes can be imported from a zip file that contains the data stored in Nextcloud. See the example folder structure below to ensure your recipes are able to be imported.';

  @override
  String get migrationPaprikaDescription =>
      'Mealie can import recipes from the Paprika application. Export your recipes from paprika, rename the export extension to .zip and upload it below.';

  @override
  String get migrationPlanToEatDescription =>
      'Mealie can import recipes from Plan to Eat. Upload a ZIP archive, CSV, or TXT file exported from Plan to Eat.';

  @override
  String get migrationRecipeKeeperDescription =>
      'Mealie can import recipes from Recipe Keeper. Export your recipes in zip format, then upload the .zip file below.';

  @override
  String get migrationTandoorDescription =>
      'Mealie can import recipes from Tandoor. Export your data in the \"Default\" format, then upload the .zip below.';

  @override
  String get migrationCooknDescription =>
      'Mealie can import recipes from DVO Cook\'n X3. Export a cookbook or menu in the \"Cook\'n\" format, rename the export extension to .zip, then upload the .zip below.';

  @override
  String get reportTitle => 'Report';

  @override
  String get recipeDataTitle => 'Recipe Data';

  @override
  String get recipeDataDescription =>
      'Use this section to manage the data associated with your recipes. You can perform several bulk actions on your recipes including exporting, deleting, tagging, and assigning categories.';

  @override
  String get recipeDataTagTitle => 'Tag Recipes';

  @override
  String get recipeDataCategorizeTitle => 'Categorize Recipes';

  @override
  String get recipeDataSettingsTitle => 'Update Settings';

  @override
  String get recipeDataExportTitle => 'Export Recipes';

  @override
  String get recipeDataDeleteTitle => 'Delete Recipes';

  @override
  String recipeDataExportConfirm(int count) {
    return 'The following recipes ($count) will be exported.';
  }

  @override
  String get recipeDataExportsTitle => 'Data Exports';

  @override
  String get recipeDataExportsDescription =>
      'This section provides links to available exports that are ready to download. These exports do expire, so be sure to grab them while they\'re still available.';

  @override
  String get recipeDataPurgeExports => 'Purge Exports';

  @override
  String get recipeDataPurgeConfirm =>
      'Are you sure you want to delete all export data?';

  @override
  String get recipeActionsTitle => 'Recipe Actions';

  @override
  String get recipeActionNew => 'New Recipe Action';

  @override
  String get recipeActionEdit => 'Edit Recipe Action';

  @override
  String get recipeActionTypeLink => 'Link';

  @override
  String get recipeActionTypePost => 'Post';

  @override
  String get webhooksTitle => 'Webhooks';

  @override
  String get webhooksDescription =>
      'The webhooks defined below will be executed when a meal is defined for the day. At the scheduled time the webhooks will be sent with the data from the recipe that is scheduled for the day. Note that webhook execution is not exact. The webhooks are executed on a 5 minutes interval so the webhooks will be executed within 5 +/- minutes of the scheduled.';

  @override
  String get webhookName => 'Webhook Name';

  @override
  String get webhookUrl => 'Webhook URL';

  @override
  String get notifiersTitle => 'Notifiers';

  @override
  String get notifiersDescription =>
      'Set up email and push notifications that trigger on specific events.';

  @override
  String get notifierNew => 'New Notification';

  @override
  String get notifierDescription =>
      'Mealie uses the Apprise library to generate notifications. They offer many options for services to use for notifications. Refer to their wiki for a comprehensive guide on how to create the URL for your service. If available, selecting the type of your notification may include extra features.';

  @override
  String get notifierAppriseUrl => 'Apprise URL';

  @override
  String get notifierAppriseUrlSkipped => 'Apprise URL (skipped if blank)';

  @override
  String get notifierAppriseUrlBlankHint =>
      'Since Apprise URLs typically contain sensitive information, this field is left intentionally blank while editing. If you wish to update the URL, please enter the new one here, otherwise leave it blank to keep the current URL.';

  @override
  String get notifierEnable => 'Enable Notifier';

  @override
  String get notifierWhatEvents =>
      'What events should this notifier subscribe to?';

  @override
  String get notifierRecipeEvents => 'Recipe Events';

  @override
  String get notifierUserEvents => 'User Events';

  @override
  String get notifierMealplanEvents => 'Meal Plan Events';

  @override
  String get notifierShoppingListEvents => 'Shopping List Events';

  @override
  String get notifierCookbookEvents => 'Cookbook Events';

  @override
  String get notifierTagEvents => 'Tag Events';

  @override
  String get notifierCategoryEvents => 'Category Events';

  @override
  String get notifierLabelEvents => 'Label Events';

  @override
  String get notifierUserSignup => 'When a new user joins your group';

  @override
  String get notifierCreate => 'Create';

  @override
  String get notifierUpdate => 'Update';

  @override
  String get notifierDelete => 'Delete';

  @override
  String get notifierTestSent => 'Test Message Sent';

  @override
  String get adminTitle => 'Admin Settings';

  @override
  String get backupsTitle => 'Backups';

  @override
  String get backupsDescription =>
      'Backups are total snapshots of the database and data directory of the site. This includes all data and cannot be set to exclude subsets of data. You can think of this as a snapshot of Mealie at a specific time. These serve as a database agnostic way to export and import data, or back up the site to an external location.';

  @override
  String get backupCreateHeading => 'Create A Backup';

  @override
  String get backupCreated => 'Backup created successfully';

  @override
  String get backupCreateFailed => 'Error Creating Backup. See Log File';

  @override
  String get backupDelete => 'Delete Backup';

  @override
  String get backupDeleted => 'Backup deleted';

  @override
  String get backupRestore => 'Restore Backup';

  @override
  String get backupRestoreDescription =>
      'Restoring this backup will overwrite all the current data in your database and in the data directory and replace them with the contents of this backup. If the restoration is successful, you will be logged out.';

  @override
  String get backupCannotBeUndone =>
      'This action cannot be undone - use with caution.';

  @override
  String get backupAcknowledge =>
      'I understand that this action is irreversible, destructive and may cause data loss';

  @override
  String get backupRestoreSuccess => 'Restore successful';

  @override
  String get backupRestoreFailed =>
      'Restore failed. Check your server logs for more details';

  @override
  String get maintenanceTitle => 'Maintenance';

  @override
  String get maintenanceSummary => 'Summary';

  @override
  String get maintenanceStorage => 'Storage Details';

  @override
  String get maintenanceDataDirSize => 'Data Directory Size';

  @override
  String get maintenanceCleanableDirs => 'Cleanable Directories';

  @override
  String get maintenanceCleanableImages => 'Cleanable Images';

  @override
  String get maintenanceTempDir => 'Temporary Directory (.temp)';

  @override
  String get maintenanceBackupsDir => 'Backups Directory (backups)';

  @override
  String get maintenanceGroupsDir => 'Groups Directory (groups)';

  @override
  String get maintenanceRecipesDir => 'Recipes Directory (recipes)';

  @override
  String get maintenanceUserDir => 'User Directory (user)';

  @override
  String get maintenanceCleanDirs => 'Clean Directories';

  @override
  String get maintenanceCleanDirsDescription =>
      'Removes all the recipe folders that are not valid UUIDs';

  @override
  String get maintenanceCleanTemp => 'Clean Temporary Files';

  @override
  String get maintenanceCleanTempDescription =>
      'Removes all files and folders in the .temp directory';

  @override
  String get maintenanceCleanImages => 'Clean Images';

  @override
  String get maintenanceCleanImagesDescription =>
      'Removes all the images that don\'t end with .webp';

  @override
  String get maintenanceActions => 'Actions';

  @override
  String get adminConfiguration => 'Configuration';

  @override
  String get adminAppVersion => 'Application Version';

  @override
  String get adminUpToDate => 'Mealie is up to date';

  @override
  String adminVersionOutdated(String current, String latest) {
    return 'Your current version ($current) does not match the latest release. Considering updating to the latest version ($latest).';
  }

  @override
  String get adminBaseUrl => 'Server Side Base URL';

  @override
  String get adminBaseUrlOk => 'Server Side URL does not match the default';

  @override
  String get adminBaseUrlError =>
      '`BASE_URL` is still the default value on API Server. This will cause issues with notifications links generated on the server for emails, etc.';

  @override
  String adminAuthReady(String provider) {
    return '$provider Ready';
  }

  @override
  String adminAuthNotReady(String provider) {
    return '$provider Not Ready';
  }

  @override
  String adminAuthDisabled(String provider) {
    return '$provider Disabled';
  }

  @override
  String adminAuthSuccessText(String provider) {
    return 'Required $provider variables are all set.';
  }

  @override
  String adminAuthErrorText(String provider) {
    return 'Not all $provider values are configured. This can be ignored if you are not using $provider Authentication.';
  }

  @override
  String adminAuthDisabledText(String envVar) {
    return 'To enable set $envVar to true.';
  }

  @override
  String get adminEmailStatus => 'Email Configuration Status';

  @override
  String get adminEmailConfigured => 'Email Configured';

  @override
  String get adminNotReady => 'Not Ready - Check Environmental Variables';

  @override
  String get adminSucceeded => 'Succeeded';

  @override
  String get adminFailed => 'Failed';

  @override
  String get adminSiteStatistics => 'Site Statistics';

  @override
  String get adminUncategorized => 'Uncategorized Recipes';

  @override
  String get adminUntagged => 'Untagged Recipes';

  @override
  String get adminGeneralAbout => 'General About';

  @override
  String get adminVersion => 'Version';

  @override
  String get adminBuild => 'Build';

  @override
  String get adminApplicationMode => 'Application Mode';

  @override
  String get adminProduction => 'Production';

  @override
  String get adminDevelopment => 'Development';

  @override
  String get adminDemoStatus => 'Demo Status';

  @override
  String get adminDemo => 'Demo';

  @override
  String get adminNotDemo => 'Not Demo';

  @override
  String get adminApiPort => 'API Port';

  @override
  String get adminApiDocs => 'API Docs';

  @override
  String get adminDatabaseType => 'Database Type';

  @override
  String get adminDatabaseUrl => 'Database URL';

  @override
  String get adminDefaultGroup => 'Default Group';

  @override
  String get adminDefaultHousehold => 'Default Household';

  @override
  String get adminScraperVersion => 'Recipe Scraper Version';

  @override
  String get adminStatUsers => 'Users';

  @override
  String get adminStatHouseholds => 'Households';

  @override
  String get adminStatGroups => 'Groups';

  @override
  String get recipeDuplicate => 'Duplicate recipe';

  @override
  String get recipeDuplicateAction => 'Duplicate';

  @override
  String get recipeShareLink => 'Share Recipe';

  @override
  String get recipeShareExpiration => 'Expiration Date';

  @override
  String get recipeShareCopied => 'Recipe link copied to clipboard';

  @override
  String get enabledLabel => 'Enabled';

  @override
  String get disabledLabel => 'Disabled';

  @override
  String get testAction => 'Test';

  @override
  String get yesLabel => 'Yes';

  @override
  String get noLabel => 'No';

  @override
  String get downloadAction => 'Download';

  @override
  String get backupUpload => 'Upload';

  @override
  String get zipImportButton => 'Import from Zip';

  @override
  String get zipImportDescription =>
      'Import a single recipe that was exported from another Mealie instance.';

  @override
  String get reportStatus => 'Status';

  @override
  String get reportDate => 'Date';

  @override
  String get recipeActionTitleLabel => 'Title';

  @override
  String get clearAll => 'Clear';

  @override
  String get recipeDataSettingsExplanation =>
      'Settings chosen here, excluding the locked option, will be applied to all selected recipes.';

  @override
  String get adminAllowSignup => 'Allow sign-up';

  @override
  String get adminAllowPasswordLogin => 'Allow password login';

  @override
  String get adminEmailInvalid => 'Please enter a valid email address.';

  @override
  String adminEmailTestResult(String result) {
    return 'Email test: $result';
  }

  @override
  String get adminSendTestEmail => 'Send test email';

  @override
  String get adminTestEmailAddress => 'Recipient';

  @override
  String get backupCreate => 'Create backup';

  @override
  String backupDeleteConfirm(String name) {
    return 'Delete the backup \"$name\"?';
  }

  @override
  String get backupPostgresNote =>
      'If you use PostgreSQL, please read the backup/restore process in the Mealie documentation before restoring.';

  @override
  String get backupUploaded => 'Backup uploaded';

  @override
  String get backupsEmpty => 'No backups yet.';

  @override
  String get bulkImportAddRow => 'Add URL';

  @override
  String get bulkImportStart => 'Start import';

  @override
  String get chooseFileButton => 'Choose file';

  @override
  String get deselectAllAction => 'Deselect all';

  @override
  String get downloadFailed => 'Download failed';

  @override
  String get fileSaved => 'File saved';

  @override
  String get loadFailed => 'Could not load';

  @override
  String get maintenanceActionsWarning =>
      'Maintenance actions are destructive and should be used with caution. Performing any of these actions is irreversible.';

  @override
  String get maintenanceConfirm =>
      'This action is destructive and cannot be undone. Continue?';

  @override
  String get maintenanceDone => 'Done';

  @override
  String get maintenanceFailed => 'Maintenance action failed';

  @override
  String get maintenanceRun => 'Run';

  @override
  String get migrationFailed => 'Migration failed';

  @override
  String get migrationStart => 'Start migration';

  @override
  String get migrationStarted => 'Migration finished — see the report below.';

  @override
  String get moreImportOptions => 'More import options';

  @override
  String notifierDeleteConfirm(String name) {
    return 'Delete the notifier \"$name\"?';
  }

  @override
  String get notifierEdit => 'Edit notifier';

  @override
  String notifierEventCount(int count) {
    return 'Events: $count';
  }

  @override
  String get notifierTestFailed => 'Test message could not be sent';

  @override
  String get notifiersEmpty => 'No notifiers yet.';

  @override
  String recipeActionDeleteConfirm(String name) {
    return 'Delete the recipe action \"$name\"?';
  }

  @override
  String get recipeActionFailed => 'Recipe action failed';

  @override
  String get recipeActionSent => 'Recipe sent';

  @override
  String get recipeActionUrlHint => 'Placeholders';

  @override
  String get recipeActionsDescription =>
      'Recipe actions appear in the menu of every recipe. \"Link\" opens the URL, \"Post\" lets the Mealie server send the recipe to the URL.';

  @override
  String get recipeActionsEmpty => 'No recipe actions yet.';

  @override
  String recipeDataDeleteConfirm(int count) {
    return 'Delete the selected recipes ($count)? This action cannot be undone.';
  }

  @override
  String recipeDataDeleteForbidden(int count) {
    return 'You may not delete $count of the selected recipes (only their creator or an admin can).';
  }

  @override
  String recipeDataDeleted(int count) {
    return 'Recipes deleted: $count';
  }

  @override
  String get recipeDataExportAction => 'Export';

  @override
  String get recipeDataExportDone =>
      'Export created — download it under Data Exports.';

  @override
  String recipeDataExportExpires(String date) {
    return 'expires $date';
  }

  @override
  String get recipeDataExportFailed => 'Export failed';

  @override
  String get recipeDataExportsEmpty => 'No exports available.';

  @override
  String recipeDataUpdated(int count) {
    return 'Recipes updated: $count';
  }

  @override
  String get recipeDuplicated => 'Recipe duplicated';

  @override
  String get recipeExportJson => 'Export as JSON';

  @override
  String get recipeExportZip => 'Export as ZIP (with image)';

  @override
  String get recipeShareCreate => 'Create link';

  @override
  String get recipeShareDescription =>
      'Anyone with the link can view this recipe in the browser — without an account — until it expires.';

  @override
  String get recipeShareEmpty => 'No share links yet.';

  @override
  String recipeShareExpiresAt(String date) {
    return 'Expires $date';
  }

  @override
  String get recipeWebToolsMenu => 'Duplicate, share link & more';

  @override
  String get reload => 'Reload';

  @override
  String get reportDeleteConfirm => 'Delete this report?';

  @override
  String get reportEntries => 'Entries';

  @override
  String get reportFailedEntries => 'Failed';

  @override
  String get reportOnlyFailed => 'Show only failed entries';

  @override
  String get reportStatusFailure => 'Failure';

  @override
  String get reportStatusInProgress => 'In progress';

  @override
  String get reportStatusPartial => 'Partial';

  @override
  String get reportStatusSuccess => 'Success';

  @override
  String get reportsEmpty => 'No reports yet.';

  @override
  String get uploadFailed => 'Upload failed';

  @override
  String webhookDeleteConfirm(String name) {
    return 'Delete the webhook \"$name\"?';
  }

  @override
  String get webhookEdit => 'Edit webhook';

  @override
  String get webhookNew => 'New webhook';

  @override
  String get webhookTestFailed => 'Test could not be started';

  @override
  String get webhookTestSent => 'Test webhook triggered';

  @override
  String get webhookTime => 'Time (local)';

  @override
  String get webhooksEmpty => 'No webhooks yet.';

  @override
  String get zipImportFailed => 'ZIP import failed';

  @override
  String get aiProvidersTitle => 'AI Providers';

  @override
  String get aiProvidersDescription =>
      'Configure AI providers to enable AI-powered features, such as enhanced ingredient parsing, creating recipes from videos, and more!';

  @override
  String get aiProviderSettingsTitle => 'AI Provider Settings';

  @override
  String get aiProvidersList => 'Providers';

  @override
  String get aiProviderCreate => 'Create Provider';

  @override
  String get aiProviderEdit => 'Edit Provider';

  @override
  String get aiDefaultProvider => 'Default Provider';

  @override
  String get aiDefaultProviderDescription => 'Required to enable AI features';

  @override
  String get aiAudioProvider => 'Audio Provider';

  @override
  String get aiAudioProviderDescription =>
      'Enables audio transcription features, such as creating recipes from videos';

  @override
  String get aiImageProvider => 'Image Provider';

  @override
  String get aiImageProviderDescription =>
      'Enables image recognition features, such as creating recipes from images';

  @override
  String get aiProviderName => 'Provider Name';

  @override
  String get aiApiKey => 'API Key';

  @override
  String get aiApiKeyCreateDescription =>
      'Your provider\'s API key for authentication. If your service (e.g. Ollama) doesn\'t use an API key, you still have to put something here.';

  @override
  String get aiApiKeyEditDescription =>
      'Leave this blank unless you want to change it.';

  @override
  String get aiBaseUrl => 'Base URL';

  @override
  String get aiBaseUrlDescription =>
      'If you\'re using OpenAI leave this blank. Must be an OpenAI-compatible endpoint (e.g. \"http://localhost:11434/v1\").';

  @override
  String get aiModel => 'Model';

  @override
  String get aiModelDescription =>
      'Which model your AI provider should use (e.g. \"gpt-5\").';

  @override
  String get aiTimeout => 'Request Timeout (seconds)';

  @override
  String get aiProviderCreated => 'Provider created';

  @override
  String get aiProviderUpdated => 'Provider updated';

  @override
  String get aiProviderDeleted => 'Provider deleted';

  @override
  String get aiProviderCreateFailed => 'Failed to create provider';

  @override
  String get aiProviderUpdateFailed => 'Failed to update provider';

  @override
  String get aiProviderDeleteFailed => 'Failed to delete provider';

  @override
  String get aiRequestHeaders => 'Request Headers';

  @override
  String get aiRequestParams => 'Request Parameters';

  @override
  String get aiNoDefaultWarning =>
      'You have not set a default provider, so AI features are disabled';

  @override
  String get aiTestConnection => 'Test Connection';

  @override
  String get aiTestSucceeded => 'Connection successful';

  @override
  String get aiTestFailed => 'Connection failed';

  @override
  String get aiSupportsImages => 'Supports images';

  @override
  String get aiTextOnly => 'Text-only, can\'t be your image provider';

  @override
  String get debugAiTitle => 'Debug AI Providers';

  @override
  String get debugAiDescription =>
      'Use this page to debug AI providers. You can test your AI connection and see the results here. If you have image services enabled, you can also provide an image.';

  @override
  String get debugParserTitle => 'Parser';

  @override
  String get debugParserDescription =>
      'Mealie uses Conditional Random Fields (CRFs) for parsing and processing ingredients. The model used for ingredients is based off a data set of over 100,000 ingredients from a dataset compiled by the New York Times. Note that as the model is trained in English only, you may have varied results when using the model in other languages. This page is a playground for testing the model.';

  @override
  String get debugIngredientText => 'Ingredient Text';

  @override
  String get debugTryExample => 'Try an example';

  @override
  String debugAverageConfidence(String value) {
    return '$value Confident';
  }

  @override
  String get debugRunTest => 'Run Test';

  @override
  String get debugQuantity => 'Quantity';

  @override
  String get debugUnit => 'Unit';

  @override
  String get debugFood => 'Food';

  @override
  String get debugNote => 'Comment';

  @override
  String get debugGroup => 'Group';

  @override
  String get aiProviderNone => 'None';

  @override
  String aiProviderDeleteConfirm(String name) {
    return 'Delete the provider \"$name\"?';
  }

  @override
  String get aiProvidersEmpty => 'No AI providers yet.';

  @override
  String get aiAdvanced => 'Advanced';

  @override
  String get aiKeyLabel => 'Name';

  @override
  String get aiValueLabel => 'Value';

  @override
  String get debugTitle => 'Debug';

  @override
  String get debugParse => 'Parse';

  @override
  String get debugParseFailed => 'Ingredient could not be parsed';

  @override
  String get debugChooseImage => 'Choose image';

  @override
  String get debugNoImage => 'No image (optional)';

  @override
  String get updateTitle => 'Check for updates';

  @override
  String get updateInstalledVersion => 'Installed version';

  @override
  String get updateLastCheck => 'Last checked';

  @override
  String get updateCheckNow => 'Check now';

  @override
  String get updateChecking => 'Checking for updates…';

  @override
  String get updateUpToDate => 'Mealie Recipes is up to date.';

  @override
  String updateAvailable(String version) {
    return 'Version $version is available';
  }

  @override
  String get updateAvailableDescription =>
      'A new version of Mealie Recipes is available. Nothing is installed until you start the update yourself.';

  @override
  String get updateShow => 'Show update';

  @override
  String get updateLater => 'Later';

  @override
  String updateDownloading(int percent) {
    return 'Downloading … $percent %';
  }

  @override
  String updateReady(String version) {
    return 'Version $version is ready to install';
  }

  @override
  String get updateInstalling =>
      'Installing — the app restarts automatically …';

  @override
  String get updateManual =>
      'The update could not be installed automatically. The disk image has been opened: drag Mealie Recipes into Applications.';

  @override
  String get updateFailed => 'Update failed';

  @override
  String get updateInstallNow => 'Download & install';

  @override
  String get updateRestartNow => 'Install & restart';

  @override
  String get updateAutoTitle => 'Check for updates on start';

  @override
  String get updateAutoDescription =>
      'Only checks and notifies you — you always start the installation yourself.';

  @override
  String get updateNoNotes => 'No release notes.';

  @override
  String get updateSourceHint =>
      'Updates come from the GitHub releases of Mealie Recipes and are only installed if they are signed by the developer (macOS).';
}
