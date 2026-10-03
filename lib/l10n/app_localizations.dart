import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hu.dart';
import 'app_localizations_nb.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_sl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hu'),
    Locale('nl'),
    Locale('nb'),
    Locale('pl'),
    Locale('pt'),
    Locale('sl')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Mealie Recipes'**
  String get appTitle;

  /// No description provided for @endCookingMode.
  ///
  /// In en, this message translates to:
  /// **'End cooking mode'**
  String get endCookingMode;

  /// No description provided for @endCookingModeConfirm.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to end cooking mode?'**
  String get endCookingModeConfirm;

  /// No description provided for @endCookingModeConfirmAll.
  ///
  /// In en, this message translates to:
  /// **'This will end all {count} recipes in cooking mode. Continue?'**
  String endCookingModeConfirmAll(int count);

  /// No description provided for @addTimer.
  ///
  /// In en, this message translates to:
  /// **'Add timer'**
  String get addTimer;

  /// No description provided for @recipeFinished.
  ///
  /// In en, this message translates to:
  /// **'Your dish is ready.'**
  String get recipeFinished;

  /// No description provided for @bonAppetit.
  ///
  /// In en, this message translates to:
  /// **'Enjoy your meal!'**
  String get bonAppetit;

  /// No description provided for @prepareIngredients.
  ///
  /// In en, this message translates to:
  /// **'Please prepare the following ingredients'**
  String get prepareIngredients;

  /// No description provided for @prepareIngredientsFor.
  ///
  /// In en, this message translates to:
  /// **'Please prepare the following ingredients for {servings} servings'**
  String prepareIngredientsFor(String servings);

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @homeCookToday.
  ///
  /// In en, this message translates to:
  /// **'Cook today'**
  String get homeCookToday;

  /// No description provided for @homeSuggestion.
  ///
  /// In en, this message translates to:
  /// **'Suggestion'**
  String get homeSuggestion;

  /// No description provided for @homeQuickAccess.
  ///
  /// In en, this message translates to:
  /// **'Quick access'**
  String get homeQuickAccess;

  /// No description provided for @homePlanned.
  ///
  /// In en, this message translates to:
  /// **'Planned'**
  String get homePlanned;

  /// No description provided for @favorite.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get favorite;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @homeWelcomeName.
  ///
  /// In en, this message translates to:
  /// **'Welcome {name},'**
  String homeWelcomeName(Object name);

  /// No description provided for @homeWelcomeApp.
  ///
  /// In en, this message translates to:
  /// **'to Mealie Recipes 👋'**
  String get homeWelcomeApp;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get theme;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @recipes.
  ///
  /// In en, this message translates to:
  /// **'Recipes'**
  String get recipes;

  /// No description provided for @shoppingList.
  ///
  /// In en, this message translates to:
  /// **'🛒 Shopping List'**
  String get shoppingList;

  /// No description provided for @mealplan.
  ///
  /// In en, this message translates to:
  /// **'Meal Plan'**
  String get mealplan;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'⚙️ Settings'**
  String get settings;

  /// No description provided for @searchRecipe.
  ///
  /// In en, this message translates to:
  /// **'Search recipe...'**
  String get searchRecipe;

  /// No description provided for @loadingRecipes.
  ///
  /// In en, this message translates to:
  /// **'Loading recipes...'**
  String get loadingRecipes;

  /// No description provided for @loadingRecipe.
  ///
  /// In en, this message translates to:
  /// **'Loading recipe...'**
  String get loadingRecipe;

  /// No description provided for @errorLoadingRecipes.
  ///
  /// In en, this message translates to:
  /// **'Error loading recipes: {error}'**
  String errorLoadingRecipes(String error);

  /// No description provided for @errorLoadingRecipe.
  ///
  /// In en, this message translates to:
  /// **'Could not load recipe.'**
  String get errorLoadingRecipe;

  /// No description provided for @noRecipesForCategory.
  ///
  /// In en, this message translates to:
  /// **'No recipes for this filter.'**
  String get noRecipesForCategory;

  /// No description provided for @resetFilter.
  ///
  /// In en, this message translates to:
  /// **'Reset filter'**
  String get resetFilter;

  /// No description provided for @allCategories.
  ///
  /// In en, this message translates to:
  /// **'All categories'**
  String get allCategories;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @sortRecipes.
  ///
  /// In en, this message translates to:
  /// **'Sort recipes'**
  String get sortRecipes;

  /// No description provided for @refreshRecipes.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refreshRecipes;

  /// No description provided for @sortNameAZ.
  ///
  /// In en, this message translates to:
  /// **'Name A–Z'**
  String get sortNameAZ;

  /// No description provided for @sortNameZA.
  ///
  /// In en, this message translates to:
  /// **'Name Z–A'**
  String get sortNameZA;

  /// No description provided for @sortDateNewest.
  ///
  /// In en, this message translates to:
  /// **'Newest first'**
  String get sortDateNewest;

  /// No description provided for @sortDateOldest.
  ///
  /// In en, this message translates to:
  /// **'Oldest first'**
  String get sortDateOldest;

  /// No description provided for @sortPrepTimeShort.
  ///
  /// In en, this message translates to:
  /// **'Shortest prep time'**
  String get sortPrepTimeShort;

  /// No description provided for @sortPrepTimeLong.
  ///
  /// In en, this message translates to:
  /// **'Longest prep time'**
  String get sortPrepTimeLong;

  /// No description provided for @sortRatingHighest.
  ///
  /// In en, this message translates to:
  /// **'Highest rating'**
  String get sortRatingHighest;

  /// No description provided for @sortRatingLowest.
  ///
  /// In en, this message translates to:
  /// **'Lowest rating'**
  String get sortRatingLowest;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @ingredients.
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get ingredients;

  /// No description provided for @instructions.
  ///
  /// In en, this message translates to:
  /// **'Instructions'**
  String get instructions;

  /// No description provided for @tags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get tags;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @addNote.
  ///
  /// In en, this message translates to:
  /// **'Add note'**
  String get addNote;

  /// No description provided for @editNote.
  ///
  /// In en, this message translates to:
  /// **'Edit note'**
  String get editNote;

  /// No description provided for @noteTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Title (optional)'**
  String get noteTitleHint;

  /// No description provided for @noteTextHint.
  ///
  /// In en, this message translates to:
  /// **'Note text'**
  String get noteTextHint;

  /// No description provided for @deleteNoteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete note?'**
  String get deleteNoteTitle;

  /// No description provided for @deleteNoteMessage.
  ///
  /// In en, this message translates to:
  /// **'This note will be permanently deleted.'**
  String get deleteNoteMessage;

  /// No description provided for @servings.
  ///
  /// In en, this message translates to:
  /// **'Servings'**
  String get servings;

  /// No description provided for @adjustQuantity.
  ///
  /// In en, this message translates to:
  /// **'Adjust quantity'**
  String get adjustQuantity;

  /// No description provided for @startTimer.
  ///
  /// In en, this message translates to:
  /// **'Start Timer'**
  String get startTimer;

  /// No description provided for @runningTimer.
  ///
  /// In en, this message translates to:
  /// **'Timer: {minutes}:{seconds}'**
  String runningTimer(int minutes, String seconds);

  /// No description provided for @planMeal.
  ///
  /// In en, this message translates to:
  /// **'Plan Meal'**
  String get planMeal;

  /// No description provided for @displayAlwaysOn.
  ///
  /// In en, this message translates to:
  /// **'Keep screen on'**
  String get displayAlwaysOn;

  /// No description provided for @addAllIngredients.
  ///
  /// In en, this message translates to:
  /// **'Add all ingredients'**
  String get addAllIngredients;

  /// No description provided for @addSelectedIngredients.
  ///
  /// In en, this message translates to:
  /// **'Add selected ingredients'**
  String get addSelectedIngredients;

  /// No description provided for @addIngredientsTitle.
  ///
  /// In en, this message translates to:
  /// **'Ingredients added'**
  String get addIngredientsTitle;

  /// No description provided for @addIngredientsMessage.
  ///
  /// In en, this message translates to:
  /// **'The ingredients have been added to your shopping list.'**
  String get addIngredientsMessage;

  /// No description provided for @addIngredientsFailedCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 ingredient could not be added.} other{{count} ingredients could not be added.}}'**
  String addIngredientsFailedCount(int count);

  /// No description provided for @cookbooks.
  ///
  /// In en, this message translates to:
  /// **'Cookbooks'**
  String get cookbooks;

  /// No description provided for @cookbooksEmpty.
  ///
  /// In en, this message translates to:
  /// **'No cookbooks yet. Tap “+” in the top right to create one.'**
  String get cookbooksEmpty;

  /// No description provided for @cookbookNoMatches.
  ///
  /// In en, this message translates to:
  /// **'No recipes match this filter.'**
  String get cookbookNoMatches;

  /// No description provided for @cookbookCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Create cookbook'**
  String get cookbookCreateTitle;

  /// No description provided for @cookbookEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit cookbook'**
  String get cookbookEditTitle;

  /// No description provided for @cookbookNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Cookbook name'**
  String get cookbookNameLabel;

  /// No description provided for @cookbookFilterSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Automatically add recipes'**
  String get cookbookFilterSectionTitle;

  /// No description provided for @cookbookFieldTools.
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get cookbookFieldTools;

  /// No description provided for @cookbookFieldUsers.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get cookbookFieldUsers;

  /// No description provided for @cookbookOpIsOneOf.
  ///
  /// In en, this message translates to:
  /// **'is one of'**
  String get cookbookOpIsOneOf;

  /// No description provided for @cookbookOpIsNotOneOf.
  ///
  /// In en, this message translates to:
  /// **'is not one of'**
  String get cookbookOpIsNotOneOf;

  /// No description provided for @cookbookOpContainsAll.
  ///
  /// In en, this message translates to:
  /// **'contains all'**
  String get cookbookOpContainsAll;

  /// No description provided for @cookbookSelectValues.
  ///
  /// In en, this message translates to:
  /// **'Select values'**
  String get cookbookSelectValues;

  /// No description provided for @cookbookFilterOptionsUnavailable.
  ///
  /// In en, this message translates to:
  /// **'No options available'**
  String get cookbookFilterOptionsUnavailable;

  /// No description provided for @cookbookAddFilterField.
  ///
  /// In en, this message translates to:
  /// **'Add field'**
  String get cookbookAddFilterField;

  /// No description provided for @cookbookPublicLabel.
  ///
  /// In en, this message translates to:
  /// **'Public cookbook'**
  String get cookbookPublicLabel;

  /// No description provided for @cookbookPublicSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Visible to other households on the server'**
  String get cookbookPublicSubtitle;

  /// No description provided for @cookbookRawModeEnter.
  ///
  /// In en, this message translates to:
  /// **'Edit as text'**
  String get cookbookRawModeEnter;

  /// No description provided for @cookbookRawModeExit.
  ///
  /// In en, this message translates to:
  /// **'Back to builder'**
  String get cookbookRawModeExit;

  /// No description provided for @cookbookRawModeHint.
  ///
  /// In en, this message translates to:
  /// **'This app\'s expert mode: edits the filter directly as text. Useful when an existing filter couldn\'t be broken down into simple rows.'**
  String get cookbookRawModeHint;

  /// No description provided for @cookbookRawModeUnparseable.
  ///
  /// In en, this message translates to:
  /// **'This text doesn\'t match the simple row format — it stays as text.'**
  String get cookbookRawModeUnparseable;

  /// No description provided for @saveFailed.
  ///
  /// In en, this message translates to:
  /// **'Save failed'**
  String get saveFailed;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @setupCachingTitle.
  ///
  /// In en, this message translates to:
  /// **'Loading your recipes'**
  String get setupCachingTitle;

  /// No description provided for @setupCachingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your recipes are being prepared for offline use. Depending on how many you have, this can take a moment.'**
  String get setupCachingSubtitle;

  /// No description provided for @setupCachingDone.
  ///
  /// In en, this message translates to:
  /// **'All set!'**
  String get setupCachingDone;

  /// No description provided for @setupTipsHeader.
  ///
  /// In en, this message translates to:
  /// **'Did you know?'**
  String get setupTipsHeader;

  /// No description provided for @setupFinish.
  ///
  /// In en, this message translates to:
  /// **'Let\'s go'**
  String get setupFinish;

  /// No description provided for @setupSkipCaching.
  ///
  /// In en, this message translates to:
  /// **'Continue in the background'**
  String get setupSkipCaching;

  /// No description provided for @setupTip1.
  ///
  /// In en, this message translates to:
  /// **'You can import recipes from a link, photo or PDF — via the Import tile on the home screen.'**
  String get setupTip1;

  /// No description provided for @setupTip2.
  ///
  /// In en, this message translates to:
  /// **'Cooking mode keeps the screen awake, guides you step by step and automatically detects timers in the text.'**
  String get setupTip2;

  /// No description provided for @setupTip3.
  ///
  /// In en, this message translates to:
  /// **'The shopping list works offline too — changes sync automatically once the server is reachable.'**
  String get setupTip3;

  /// No description provided for @setupTip4.
  ///
  /// In en, this message translates to:
  /// **'Long-press a tile on the home screen to rearrange your quick access.'**
  String get setupTip4;

  /// No description provided for @setupTip5.
  ///
  /// In en, this message translates to:
  /// **'Find your Mealie cookbooks via the Cookbooks tile — including offline support.'**
  String get setupTip5;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @confirmDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete recipe?'**
  String get confirmDeleteTitle;

  /// No description provided for @confirmDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get confirmDeleteMessage;

  /// No description provided for @sendToDevice.
  ///
  /// In en, this message translates to:
  /// **'Send to device'**
  String get sendToDevice;

  /// No description provided for @sendToDevicePickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Send to device'**
  String get sendToDevicePickerTitle;

  /// No description provided for @sendToAllDevices.
  ///
  /// In en, this message translates to:
  /// **'Send to all devices'**
  String get sendToAllDevices;

  /// No description provided for @timerFinished.
  ///
  /// In en, this message translates to:
  /// **'Timer finished!'**
  String get timerFinished;

  /// No description provided for @timerFinishedBody.
  ///
  /// In en, this message translates to:
  /// **'Your recipe timer has finished.'**
  String get timerFinishedBody;

  /// No description provided for @timer.
  ///
  /// In en, this message translates to:
  /// **'Timer'**
  String get timer;

  /// No description provided for @newTimer.
  ///
  /// In en, this message translates to:
  /// **'New Timer'**
  String get newTimer;

  /// No description provided for @timerDetails.
  ///
  /// In en, this message translates to:
  /// **'Timer Details'**
  String get timerDetails;

  /// No description provided for @timerNamePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Timer name'**
  String get timerNamePlaceholder;

  /// No description provided for @timerNameHint.
  ///
  /// In en, this message translates to:
  /// **'Give your timer a descriptive name.'**
  String get timerNameHint;

  /// No description provided for @durationLabel.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get durationLabel;

  /// No description provided for @minutesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} minutes'**
  String minutesCount(int count);

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stop;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @resume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resume;

  /// No description provided for @finished.
  ///
  /// In en, this message translates to:
  /// **'Finished!'**
  String get finished;

  /// No description provided for @stepNumber.
  ///
  /// In en, this message translates to:
  /// **'Step {number}'**
  String stepNumber(int number);

  /// No description provided for @minAbbreviation.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get minAbbreviation;

  /// No description provided for @cookingMode.
  ///
  /// In en, this message translates to:
  /// **'Cooking Mode'**
  String get cookingMode;

  /// No description provided for @activeRecipesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} active recipes'**
  String activeRecipesCount(int count);

  /// No description provided for @endAll.
  ///
  /// In en, this message translates to:
  /// **'End all'**
  String get endAll;

  /// No description provided for @end.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get end;

  /// No description provided for @endAllRecipesTitle.
  ///
  /// In en, this message translates to:
  /// **'End all recipes?'**
  String get endAllRecipesTitle;

  /// No description provided for @endAllRecipesMessage.
  ///
  /// In en, this message translates to:
  /// **'Do you want to end all {count} active cooking sessions?'**
  String endAllRecipesMessage(int count);

  /// No description provided for @endRecipeTitle.
  ///
  /// In en, this message translates to:
  /// **'End recipe?'**
  String get endRecipeTitle;

  /// No description provided for @endRecipeMessage.
  ///
  /// In en, this message translates to:
  /// **'Do you want to end the cooking session for \"{name}\"?'**
  String endRecipeMessage(String name);

  /// No description provided for @noActiveTimers.
  ///
  /// In en, this message translates to:
  /// **'No active timers'**
  String get noActiveTimers;

  /// No description provided for @noActiveRecipes.
  ///
  /// In en, this message translates to:
  /// **'No active recipes'**
  String get noActiveRecipes;

  /// No description provided for @startRecipeToCook.
  ///
  /// In en, this message translates to:
  /// **'Open a recipe and tap the cooking mode button to start.'**
  String get startRecipeToCook;

  /// No description provided for @browseRecipes.
  ///
  /// In en, this message translates to:
  /// **'Browse recipes'**
  String get browseRecipes;

  /// No description provided for @timersPausedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} timer(s) paused'**
  String timersPausedCount(int count);

  /// No description provided for @cookFriends.
  ///
  /// In en, this message translates to:
  /// **'Cook with Friends'**
  String get cookFriends;

  /// No description provided for @cookingModeAddRecipe.
  ///
  /// In en, this message translates to:
  /// **'Add recipe'**
  String get cookingModeAddRecipe;

  /// No description provided for @cookingModeAddRecipeSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search recipes'**
  String get cookingModeAddRecipeSearchHint;

  /// No description provided for @cookFriendsCode.
  ///
  /// In en, this message translates to:
  /// **'Session code'**
  String get cookFriendsCode;

  /// No description provided for @cookFriendsJoin.
  ///
  /// In en, this message translates to:
  /// **'Join session'**
  String get cookFriendsJoin;

  /// No description provided for @cookFriendsHost.
  ///
  /// In en, this message translates to:
  /// **'Host session'**
  String get cookFriendsHost;

  /// No description provided for @cookFriendsHostNotFound.
  ///
  /// In en, this message translates to:
  /// **'Host not found. Make sure both devices are on the same Wi-Fi and local network access is allowed.'**
  String get cookFriendsHostNotFound;

  /// No description provided for @cookFriendsConnectionFailed.
  ///
  /// In en, this message translates to:
  /// **'Connection failed. Please try again.'**
  String get cookFriendsConnectionFailed;

  /// No description provided for @cookFriendsEnterCode.
  ///
  /// In en, this message translates to:
  /// **'Enter code'**
  String get cookFriendsEnterCode;

  /// No description provided for @cookFriendsConnected.
  ///
  /// In en, this message translates to:
  /// **'Connected: {count} guests'**
  String cookFriendsConnected(int count);

  /// No description provided for @joinSession.
  ///
  /// In en, this message translates to:
  /// **'Join session'**
  String get joinSession;

  /// No description provided for @hostEndedSessionTitle.
  ///
  /// In en, this message translates to:
  /// **'Session ended'**
  String get hostEndedSessionTitle;

  /// No description provided for @hostEndedSessionMessage.
  ///
  /// In en, this message translates to:
  /// **'The host has ended the cooking session.'**
  String get hostEndedSessionMessage;

  /// No description provided for @shoppingListEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your shopping list is empty.'**
  String get shoppingListEmpty;

  /// No description provided for @addItem.
  ///
  /// In en, this message translates to:
  /// **'Add item'**
  String get addItem;

  /// No description provided for @itemNote.
  ///
  /// In en, this message translates to:
  /// **'Item name'**
  String get itemNote;

  /// No description provided for @unlabeledCategory.
  ///
  /// In en, this message translates to:
  /// **'Unlabeled'**
  String get unlabeledCategory;

  /// No description provided for @reorderCategories.
  ///
  /// In en, this message translates to:
  /// **'Reorder categories'**
  String get reorderCategories;

  /// No description provided for @archiveChecked.
  ///
  /// In en, this message translates to:
  /// **'Archive checked items'**
  String get archiveChecked;

  /// No description provided for @archivedLists.
  ///
  /// In en, this message translates to:
  /// **'📦 Archived purchases'**
  String get archivedLists;

  /// No description provided for @syncChanges.
  ///
  /// In en, this message translates to:
  /// **'Sync changes'**
  String get syncChanges;

  /// No description provided for @noSyncChanges.
  ///
  /// In en, this message translates to:
  /// **'No sync changes'**
  String get noSyncChanges;

  /// No description provided for @postimportAction.
  ///
  /// In en, this message translates to:
  /// **'After import'**
  String get postimportAction;

  /// No description provided for @postimportHint.
  ///
  /// In en, this message translates to:
  /// **'Choose what should happen in the source app (Reminders / Google Tasks) with the imported entries.'**
  String get postimportHint;

  /// No description provided for @postimportLeave.
  ///
  /// In en, this message translates to:
  /// **'Just add'**
  String get postimportLeave;

  /// No description provided for @postimportComplete.
  ///
  /// In en, this message translates to:
  /// **'Check off'**
  String get postimportComplete;

  /// No description provided for @postimportCompleteDelete.
  ///
  /// In en, this message translates to:
  /// **'Check off & delete'**
  String get postimportCompleteDelete;

  /// No description provided for @postimportFailed.
  ///
  /// In en, this message translates to:
  /// **'Post-processing in the source app failed. The items were still added to Mealie.'**
  String get postimportFailed;

  /// No description provided for @syncChangesTitle.
  ///
  /// In en, this message translates to:
  /// **'Sync changes'**
  String get syncChangesTitle;

  /// No description provided for @syncSectionChecked.
  ///
  /// In en, this message translates to:
  /// **'Checked'**
  String get syncSectionChecked;

  /// No description provided for @syncSectionQuantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get syncSectionQuantity;

  /// No description provided for @syncSectionCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get syncSectionCategory;

  /// No description provided for @syncSectionAdditions.
  ///
  /// In en, this message translates to:
  /// **'Newly added'**
  String get syncSectionAdditions;

  /// No description provided for @syncLocalLabel.
  ///
  /// In en, this message translates to:
  /// **'Local'**
  String get syncLocalLabel;

  /// No description provided for @syncServerLabel.
  ///
  /// In en, this message translates to:
  /// **'Server'**
  String get syncServerLabel;

  /// No description provided for @syncNow.
  ///
  /// In en, this message translates to:
  /// **'Sync now'**
  String get syncNow;

  /// No description provided for @offlineBadge.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offlineBadge;

  /// No description provided for @mealplanTitle.
  ///
  /// In en, this message translates to:
  /// **'📅 Meal Plan'**
  String get mealplanTitle;

  /// No description provided for @mealplanSelectMode.
  ///
  /// In en, this message translates to:
  /// **'Select multiple recipes'**
  String get mealplanSelectMode;

  /// No description provided for @mealplanSelectedCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Select} =1{1 selected} other{{count} selected}}'**
  String mealplanSelectedCount(int count);

  /// No description provided for @breakfast.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get breakfast;

  /// No description provided for @lunch.
  ///
  /// In en, this message translates to:
  /// **'Lunch'**
  String get lunch;

  /// No description provided for @dinner.
  ///
  /// In en, this message translates to:
  /// **'Dinner'**
  String get dinner;

  /// No description provided for @addMealEntry.
  ///
  /// In en, this message translates to:
  /// **'Add meal'**
  String get addMealEntry;

  /// No description provided for @selectRecipe.
  ///
  /// In en, this message translates to:
  /// **'Select recipe'**
  String get selectRecipe;

  /// No description provided for @orFreeText.
  ///
  /// In en, this message translates to:
  /// **'or free text'**
  String get orFreeText;

  /// No description provided for @entryNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get entryNote;

  /// No description provided for @noMealEntries.
  ///
  /// In en, this message translates to:
  /// **'No entries for this week.'**
  String get noMealEntries;

  /// No description provided for @importRecipe.
  ///
  /// In en, this message translates to:
  /// **'Import Recipe'**
  String get importRecipe;

  /// No description provided for @importFromUrl.
  ///
  /// In en, this message translates to:
  /// **'Import from URL'**
  String get importFromUrl;

  /// No description provided for @importFromImage.
  ///
  /// In en, this message translates to:
  /// **'Import from photo'**
  String get importFromImage;

  /// No description provided for @importFromJson.
  ///
  /// In en, this message translates to:
  /// **'Import from JSON'**
  String get importFromJson;

  /// No description provided for @url.
  ///
  /// In en, this message translates to:
  /// **'URL'**
  String get url;

  /// No description provided for @urlPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'https://...'**
  String get urlPlaceholder;

  /// No description provided for @importLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language for OCR'**
  String get importLanguage;

  /// No description provided for @importing.
  ///
  /// In en, this message translates to:
  /// **'Importing...'**
  String get importing;

  /// No description provided for @importSuccess.
  ///
  /// In en, this message translates to:
  /// **'Recipe imported successfully!'**
  String get importSuccess;

  /// No description provided for @importError.
  ///
  /// In en, this message translates to:
  /// **'Import failed: {error}'**
  String importError(String error);

  /// No description provided for @pasteJson.
  ///
  /// In en, this message translates to:
  /// **'Paste JSON here'**
  String get pasteJson;

  /// No description provided for @setupTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Mealie Recipes'**
  String get setupTitle;

  /// No description provided for @setupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please configure your Mealie server.'**
  String get setupSubtitle;

  /// No description provided for @serverUrl.
  ///
  /// In en, this message translates to:
  /// **'Server URL'**
  String get serverUrl;

  /// No description provided for @serverUrlPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'https://mealie.example.com'**
  String get serverUrlPlaceholder;

  /// No description provided for @apiToken.
  ///
  /// In en, this message translates to:
  /// **'API Token'**
  String get apiToken;

  /// No description provided for @apiTokenPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Your API token'**
  String get apiTokenPlaceholder;

  /// No description provided for @householdId.
  ///
  /// In en, this message translates to:
  /// **'Household'**
  String get householdId;

  /// No description provided for @householdIdPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get householdIdPlaceholder;

  /// No description provided for @shoppingListId.
  ///
  /// In en, this message translates to:
  /// **'Shopping list ID'**
  String get shoppingListId;

  /// No description provided for @shoppingListIdPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Select a shopping list'**
  String get shoppingListIdPlaceholder;

  /// No description provided for @setupHouseholdListTitle.
  ///
  /// In en, this message translates to:
  /// **'Household & shopping list'**
  String get setupHouseholdListTitle;

  /// No description provided for @shoppingListLabel.
  ///
  /// In en, this message translates to:
  /// **'Shopping list'**
  String get shoppingListLabel;

  /// No description provided for @setupHouseholdManualHint.
  ///
  /// In en, this message translates to:
  /// **'Households could not be loaded — enter the household name manually.'**
  String get setupHouseholdManualHint;

  /// No description provided for @setupExactTitle.
  ///
  /// In en, this message translates to:
  /// **'Quantities on the shopping list'**
  String get setupExactTitle;

  /// No description provided for @setupExactBody.
  ///
  /// In en, this message translates to:
  /// **'In most countries you don\'t shop gram-precise — you put 1 pack of butter in the cart, not 200 g. In simple mode the app therefore converts recipe amounts to “1×”. In exact mode quantity and unit are kept 1:1 like the Mealie web app — including when typing new items (e.g. “200 g butter”). You can change this anytime in the settings.'**
  String get setupExactBody;

  /// No description provided for @setupExactSimpleTitle.
  ///
  /// In en, this message translates to:
  /// **'Simple mode (1×)'**
  String get setupExactSimpleTitle;

  /// No description provided for @setupExactSimpleBody.
  ///
  /// In en, this message translates to:
  /// **'Ingredients land on the list as “1× item” — ideal for quick ticking off in the store.'**
  String get setupExactSimpleBody;

  /// No description provided for @setupExactExactTitle.
  ///
  /// In en, this message translates to:
  /// **'Exact quantities'**
  String get setupExactExactTitle;

  /// No description provided for @setupExactExactBody.
  ///
  /// In en, this message translates to:
  /// **'Items appear with quantity and unit, e.g. “200 g butter” — exactly like the web app.'**
  String get setupExactExactBody;

  /// No description provided for @connect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get connect;

  /// No description provided for @connecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting...'**
  String get connecting;

  /// No description provided for @connectionSuccess.
  ///
  /// In en, this message translates to:
  /// **'Connection successful!'**
  String get connectionSuccess;

  /// No description provided for @connectionError.
  ///
  /// In en, this message translates to:
  /// **'Connection failed: {error}'**
  String connectionError(String error);

  /// No description provided for @optionalHeaders.
  ///
  /// In en, this message translates to:
  /// **'Optional HTTP headers (for reverse proxy)'**
  String get optionalHeaders;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'⚙️ Settings'**
  String get settingsTitle;

  /// No description provided for @settingsSaved.
  ///
  /// In en, this message translates to:
  /// **'Settings saved'**
  String get settingsSaved;

  /// No description provided for @serverSettings.
  ///
  /// In en, this message translates to:
  /// **'Server'**
  String get serverSettings;

  /// No description provided for @displaySettings.
  ///
  /// In en, this message translates to:
  /// **'Display'**
  String get displaySettings;

  /// No description provided for @notificationSettings.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationSettings;

  /// No description provided for @securitySettings.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get securitySettings;

  /// No description provided for @aboutSettings.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutSettings;

  /// No description provided for @showRecipeImages.
  ///
  /// In en, this message translates to:
  /// **'Show recipe images'**
  String get showRecipeImages;

  /// No description provided for @apiVersion.
  ///
  /// In en, this message translates to:
  /// **'API version'**
  String get apiVersion;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @biometricLock.
  ///
  /// In en, this message translates to:
  /// **'Biometric lock'**
  String get biometricLock;

  /// No description provided for @biometricLockDescription.
  ///
  /// In en, this message translates to:
  /// **'Unlock app with biometrics'**
  String get biometricLockDescription;

  /// No description provided for @criticalAlerts.
  ///
  /// In en, this message translates to:
  /// **'Critical alerts'**
  String get criticalAlerts;

  /// No description provided for @criticalAlertsDescription.
  ///
  /// In en, this message translates to:
  /// **'Timer alarm even in silent mode'**
  String get criticalAlertsDescription;

  /// No description provided for @enableLogging.
  ///
  /// In en, this message translates to:
  /// **'Enable logging'**
  String get enableLogging;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select language'**
  String get selectLanguage;

  /// No description provided for @setupContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get setupContinue;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @setupConnectStep.
  ///
  /// In en, this message translates to:
  /// **'Connect to your server'**
  String get setupConnectStep;

  /// No description provided for @resetSettings.
  ///
  /// In en, this message translates to:
  /// **'Reset all settings'**
  String get resetSettings;

  /// No description provided for @resetSettingsConfirm.
  ///
  /// In en, this message translates to:
  /// **'This will reset all settings. Continue?'**
  String get resetSettingsConfirm;

  /// No description provided for @guestMode.
  ///
  /// In en, this message translates to:
  /// **'Guest mode'**
  String get guestMode;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get appVersion;

  /// No description provided for @leftoverFinder.
  ///
  /// In en, this message translates to:
  /// **'Recipe Finder'**
  String get leftoverFinder;

  /// No description provided for @leftoverFinderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Find recipes with ingredients you have'**
  String get leftoverFinderSubtitle;

  /// No description provided for @addIngredient.
  ///
  /// In en, this message translates to:
  /// **'Add ingredient'**
  String get addIngredient;

  /// No description provided for @ingredientPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'e.g. eggs'**
  String get ingredientPlaceholder;

  /// No description provided for @findRecipes.
  ///
  /// In en, this message translates to:
  /// **'Find recipes'**
  String get findRecipes;

  /// No description provided for @matchingRecipes.
  ///
  /// In en, this message translates to:
  /// **'Matching recipes'**
  String get matchingRecipes;

  /// No description provided for @noMatchingRecipes.
  ///
  /// In en, this message translates to:
  /// **'No recipes found for these ingredients.'**
  String get noMatchingRecipes;

  /// No description provided for @matchPercent.
  ///
  /// In en, this message translates to:
  /// **'{percent}% match'**
  String matchPercent(int percent);

  /// No description provided for @biometricPrompt.
  ///
  /// In en, this message translates to:
  /// **'Authenticate to open Mealie Recipes'**
  String get biometricPrompt;

  /// No description provided for @biometricFailed.
  ///
  /// In en, this message translates to:
  /// **'Authentication failed'**
  String get biometricFailed;

  /// No description provided for @whatsNew.
  ///
  /// In en, this message translates to:
  /// **'What\'s New'**
  String get whatsNew;

  /// No description provided for @pendingRecipesTitle.
  ///
  /// In en, this message translates to:
  /// **'Received recipes'**
  String get pendingRecipesTitle;

  /// No description provided for @pendingRecipesMessage.
  ///
  /// In en, this message translates to:
  /// **'You received a recipe from {sender}: \"{name}\"'**
  String pendingRecipesMessage(String sender, String name);

  /// No description provided for @pendingRecipesFrom.
  ///
  /// In en, this message translates to:
  /// **'From {names}'**
  String pendingRecipesFrom(Object names);

  /// No description provided for @pendingRecipesOpenCooking.
  ///
  /// In en, this message translates to:
  /// **'Open cooking mode'**
  String get pendingRecipesOpenCooking;

  /// No description provided for @pendingRecipesLater.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get pendingRecipesLater;

  /// No description provided for @openRecipe.
  ///
  /// In en, this message translates to:
  /// **'Open recipe'**
  String get openRecipe;

  /// No description provided for @dismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get dismiss;

  /// No description provided for @editRecipe.
  ///
  /// In en, this message translates to:
  /// **'Edit Recipe'**
  String get editRecipe;

  /// No description provided for @recipeName.
  ///
  /// In en, this message translates to:
  /// **'Recipe name'**
  String get recipeName;

  /// No description provided for @recipeDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get recipeDescription;

  /// No description provided for @prepTime.
  ///
  /// In en, this message translates to:
  /// **'Prep time (min)'**
  String get prepTime;

  /// No description provided for @cookTime.
  ///
  /// In en, this message translates to:
  /// **'Cook time (min)'**
  String get cookTime;

  /// No description provided for @totalTime.
  ///
  /// In en, this message translates to:
  /// **'Total time (min)'**
  String get totalTime;

  /// No description provided for @recipeServings.
  ///
  /// In en, this message translates to:
  /// **'Servings'**
  String get recipeServings;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// No description provided for @addIngredientLine.
  ///
  /// In en, this message translates to:
  /// **'Add ingredient'**
  String get addIngredientLine;

  /// No description provided for @addInstruction.
  ///
  /// In en, this message translates to:
  /// **'Add step'**
  String get addInstruction;

  /// No description provided for @removeIngredient.
  ///
  /// In en, this message translates to:
  /// **'Remove ingredient'**
  String get removeIngredient;

  /// No description provided for @removeInstruction.
  ///
  /// In en, this message translates to:
  /// **'Remove step'**
  String get removeInstruction;

  /// No description provided for @ingredientName.
  ///
  /// In en, this message translates to:
  /// **'Ingredient'**
  String get ingredientName;

  /// No description provided for @ingredientQuantity.
  ///
  /// In en, this message translates to:
  /// **'Qty'**
  String get ingredientQuantity;

  /// No description provided for @ingredientUnit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get ingredientUnit;

  /// No description provided for @ingredientNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get ingredientNote;

  /// No description provided for @instructionText.
  ///
  /// In en, this message translates to:
  /// **'Step text'**
  String get instructionText;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @selectCategories.
  ///
  /// In en, this message translates to:
  /// **'Select categories'**
  String get selectCategories;

  /// No description provided for @selectTags.
  ///
  /// In en, this message translates to:
  /// **'Select tags'**
  String get selectTags;

  /// No description provided for @uploadImage.
  ///
  /// In en, this message translates to:
  /// **'Upload image'**
  String get uploadImage;

  /// No description provided for @removeImage.
  ///
  /// In en, this message translates to:
  /// **'Remove image'**
  String get removeImage;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChanges;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving;

  /// No description provided for @saveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Recipe saved.'**
  String get saveSuccess;

  /// No description provided for @saveError.
  ///
  /// In en, this message translates to:
  /// **'Could not save: {error}'**
  String saveError(String error);

  /// No description provided for @newCategory.
  ///
  /// In en, this message translates to:
  /// **'New category'**
  String get newCategory;

  /// No description provided for @newTag.
  ///
  /// In en, this message translates to:
  /// **'New tag'**
  String get newTag;

  /// No description provided for @setRating.
  ///
  /// In en, this message translates to:
  /// **'Set rating'**
  String get setRating;

  /// No description provided for @removeRating.
  ///
  /// In en, this message translates to:
  /// **'Remove rating'**
  String get removeRating;

  /// No description provided for @ratingRemoved.
  ///
  /// In en, this message translates to:
  /// **'Rating removed'**
  String get ratingRemoved;

  /// No description provided for @googleTasksImport.
  ///
  /// In en, this message translates to:
  /// **'Import from Google Tasks'**
  String get googleTasksImport;

  /// No description provided for @googleTasksImportDescription.
  ///
  /// In en, this message translates to:
  /// **'Import items from Google Tasks to your shopping list.'**
  String get googleTasksImportDescription;

  /// No description provided for @homeWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Mealie Recipes! 👋'**
  String get homeWelcome;

  /// No description provided for @homeWelcomeNamed.
  ///
  /// In en, this message translates to:
  /// **'Welcome {name}, to Mealie Recipes! 👋'**
  String homeWelcomeNamed(String name);

  /// No description provided for @shopping.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get shopping;

  /// No description provided for @planning.
  ///
  /// In en, this message translates to:
  /// **'Planning'**
  String get planning;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @viewRecipes.
  ///
  /// In en, this message translates to:
  /// **'📖 View Recipes'**
  String get viewRecipes;

  /// No description provided for @addRecipe.
  ///
  /// In en, this message translates to:
  /// **'➕ Add Recipe'**
  String get addRecipe;

  /// No description provided for @completeShopping.
  ///
  /// In en, this message translates to:
  /// **'Complete Shopping'**
  String get completeShopping;

  /// No description provided for @shoppingCompleted.
  ///
  /// In en, this message translates to:
  /// **'Shopping Completed'**
  String get shoppingCompleted;

  /// No description provided for @shoppingCompletedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'All in the cart! 🎉'**
  String get shoppingCompletedSubtitle;

  /// No description provided for @essensplan.
  ///
  /// In en, this message translates to:
  /// **'📅 Meal Plan'**
  String get essensplan;

  /// No description provided for @resteverwertung.
  ///
  /// In en, this message translates to:
  /// **'🥗 Recipe Finder'**
  String get resteverwertung;

  /// No description provided for @newRecipeUpload.
  ///
  /// In en, this message translates to:
  /// **'Upload New Recipe'**
  String get newRecipeUpload;

  /// No description provided for @copyCode.
  ///
  /// In en, this message translates to:
  /// **'Copy Code'**
  String get copyCode;

  /// No description provided for @shareLink.
  ///
  /// In en, this message translates to:
  /// **'Share Link'**
  String get shareLink;

  /// No description provided for @connectedFriends.
  ///
  /// In en, this message translates to:
  /// **'Connected Friends'**
  String get connectedFriends;

  /// No description provided for @waitingForFriends.
  ///
  /// In en, this message translates to:
  /// **'Waiting for friends...'**
  String get waitingForFriends;

  /// No description provided for @endSharing.
  ///
  /// In en, this message translates to:
  /// **'End Sharing'**
  String get endSharing;

  /// No description provided for @cookFriendsDescription.
  ///
  /// In en, this message translates to:
  /// **'Invite a friend to cook this recipe together'**
  String get cookFriendsDescription;

  /// No description provided for @sessionCode.
  ///
  /// In en, this message translates to:
  /// **'SESSION CODE'**
  String get sessionCode;

  /// No description provided for @adjustQuantityLabel.
  ///
  /// In en, this message translates to:
  /// **'Adjust quantity for this recipe:'**
  String get adjustQuantityLabel;

  /// No description provided for @timerStartForStep.
  ///
  /// In en, this message translates to:
  /// **'Timer for step'**
  String get timerStartForStep;

  /// No description provided for @enterRecipeUrl.
  ///
  /// In en, this message translates to:
  /// **'Enter recipe URL'**
  String get enterRecipeUrl;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @urlInvalidScheme.
  ///
  /// In en, this message translates to:
  /// **'URL must start with http:// or https://'**
  String get urlInvalidScheme;

  /// No description provided for @urlAddScheme.
  ///
  /// In en, this message translates to:
  /// **'Add https://'**
  String get urlAddScheme;

  /// No description provided for @addItemPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Add item...'**
  String get addItemPlaceholder;

  /// No description provided for @addSuccessToast.
  ///
  /// In en, this message translates to:
  /// **'Added!'**
  String get addSuccessToast;

  /// No description provided for @completedItems.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completedItems;

  /// No description provided for @completeShoppingTitle.
  ///
  /// In en, this message translates to:
  /// **'Complete shopping?'**
  String get completeShoppingTitle;

  /// No description provided for @completeShoppingMessage.
  ///
  /// In en, this message translates to:
  /// **'Delete completed items?'**
  String get completeShoppingMessage;

  /// No description provided for @recipeListTitle.
  ///
  /// In en, this message translates to:
  /// **'📖 Recipes'**
  String get recipeListTitle;

  /// No description provided for @importRecipeTitle.
  ///
  /// In en, this message translates to:
  /// **'Upload new recipe'**
  String get importRecipeTitle;

  /// No description provided for @uploadRecipeUrl.
  ///
  /// In en, this message translates to:
  /// **'Import via Recipe URL'**
  String get uploadRecipeUrl;

  /// No description provided for @uploadRecipeUrlHint.
  ///
  /// In en, this message translates to:
  /// **'Enter the recipe URL to save it on your server'**
  String get uploadRecipeUrlHint;

  /// No description provided for @uploadOpenAI.
  ///
  /// In en, this message translates to:
  /// **'Import from file via OpenAI'**
  String get uploadOpenAI;

  /// No description provided for @uploadOpenAIHint.
  ///
  /// In en, this message translates to:
  /// **'Alternatively upload photos or a PDF of a recipe. If the recipe spans several pages, just add several — they are analyzed together by AI.'**
  String get uploadOpenAIHint;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get takePhoto;

  /// No description provided for @cameraPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'No access to the camera. Allow it in your system settings to photograph recipes.'**
  String get cameraPermissionDenied;

  /// No description provided for @cameraUnavailable.
  ///
  /// In en, this message translates to:
  /// **'No camera available on this device.'**
  String get cameraUnavailable;

  /// No description provided for @selectPhoto.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get selectPhoto;

  /// No description provided for @selectPdf.
  ///
  /// In en, this message translates to:
  /// **'PDF'**
  String get selectPdf;

  /// No description provided for @openAIHintTitle.
  ///
  /// In en, this message translates to:
  /// **'File Analysis Info'**
  String get openAIHintTitle;

  /// No description provided for @openAIHintBody.
  ///
  /// In en, this message translates to:
  /// **'Recipe analysis uses the OpenAI API. Make sure your API key is configured in the Mealie server settings.'**
  String get openAIHintBody;

  /// No description provided for @allDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete all'**
  String get allDeleteConfirm;

  /// No description provided for @portionen.
  ///
  /// In en, this message translates to:
  /// **'Servings'**
  String get portionen;

  /// No description provided for @timerForStep.
  ///
  /// In en, this message translates to:
  /// **'Start timer for this step'**
  String get timerForStep;

  /// No description provided for @weekNavPrev.
  ///
  /// In en, this message translates to:
  /// **'Previous week'**
  String get weekNavPrev;

  /// No description provided for @weekNavNext.
  ///
  /// In en, this message translates to:
  /// **'Next week'**
  String get weekNavNext;

  /// No description provided for @noMealsThisWeek.
  ///
  /// In en, this message translates to:
  /// **'No meals planned'**
  String get noMealsThisWeek;

  /// No description provided for @entriesInOtherWeeks.
  ///
  /// In en, this message translates to:
  /// **'There are entries in other weeks'**
  String get entriesInOtherWeeks;

  /// No description provided for @availableWeeks.
  ///
  /// In en, this message translates to:
  /// **'Available weeks:'**
  String get availableWeeks;

  /// No description provided for @weekRange.
  ///
  /// In en, this message translates to:
  /// **'Week {week} ({start} – {end})'**
  String weekRange(Object end, Object start, Object week);

  /// No description provided for @currentWeek.
  ///
  /// In en, this message translates to:
  /// **'Current Week'**
  String get currentWeek;

  /// No description provided for @rezepteAktualisieren.
  ///
  /// In en, this message translates to:
  /// **'Update recipes'**
  String get rezepteAktualisieren;

  /// No description provided for @leftoverWhatTitle.
  ///
  /// In en, this message translates to:
  /// **'What does this do?'**
  String get leftoverWhatTitle;

  /// No description provided for @leftoverWhatBody.
  ///
  /// In en, this message translates to:
  /// **'This function reloads all recipes from the server and updates the local cache.'**
  String get leftoverWhatBody;

  /// No description provided for @leftoverDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter available ingredients to find matching recipes and use up leftovers.'**
  String get leftoverDescription;

  /// No description provided for @leftoverIngredientsHeader.
  ///
  /// In en, this message translates to:
  /// **'Ingredients at home'**
  String get leftoverIngredientsHeader;

  /// No description provided for @leftoverSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Recipe suggestions'**
  String get leftoverSuggestions;

  /// No description provided for @leftoverNoMatches.
  ///
  /// In en, this message translates to:
  /// **'No matching recipes found.'**
  String get leftoverNoMatches;

  /// No description provided for @leftoverEnterIngredient.
  ///
  /// In en, this message translates to:
  /// **'Enter ingredient'**
  String get leftoverEnterIngredient;

  /// No description provided for @matchingPercentText.
  ///
  /// In en, this message translates to:
  /// **'{percent}% match ({count}/{total})'**
  String matchingPercentText(int percent, int count, int total);

  /// No description provided for @weekAbbreviation.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get weekAbbreviation;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get selectDate;

  /// No description provided for @selectSlot.
  ///
  /// In en, this message translates to:
  /// **'Select meal'**
  String get selectSlot;

  /// No description provided for @selectedRecipe.
  ///
  /// In en, this message translates to:
  /// **'Selected recipe'**
  String get selectedRecipe;

  /// No description provided for @confirmMeal.
  ///
  /// In en, this message translates to:
  /// **'Schedule meal'**
  String get confirmMeal;

  /// No description provided for @searchRecipes.
  ///
  /// In en, this message translates to:
  /// **'Search recipes'**
  String get searchRecipes;

  /// No description provided for @addCustomMeal.
  ///
  /// In en, this message translates to:
  /// **'Add custom meal'**
  String get addCustomMeal;

  /// No description provided for @diceModeButton.
  ///
  /// In en, this message translates to:
  /// **'Roll random recipes'**
  String get diceModeButton;

  /// No description provided for @diceModeTitle.
  ///
  /// In en, this message translates to:
  /// **'3 random suggestions'**
  String get diceModeTitle;

  /// No description provided for @diceBackToSearch.
  ///
  /// In en, this message translates to:
  /// **'Back to search'**
  String get diceBackToSearch;

  /// No description provided for @diceNotEnoughRecipes.
  ///
  /// In en, this message translates to:
  /// **'Not enough recipes for dice mode (need at least 3)'**
  String get diceNotEnoughRecipes;

  /// No description provided for @entrySingular.
  ///
  /// In en, this message translates to:
  /// **'entry'**
  String get entrySingular;

  /// No description provided for @entriesPlural.
  ///
  /// In en, this message translates to:
  /// **'entries'**
  String get entriesPlural;

  /// No description provided for @listTitle.
  ///
  /// In en, this message translates to:
  /// **'List {n}'**
  String listTitle(int n);

  /// No description provided for @deleteAllConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete all?'**
  String get deleteAllConfirmTitle;

  /// No description provided for @deleteAllConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Do you want to delete all archived purchases?'**
  String get deleteAllConfirmMessage;

  /// No description provided for @uploadFromUrlButton.
  ///
  /// In en, this message translates to:
  /// **'Import recipe from URL'**
  String get uploadFromUrlButton;

  /// No description provided for @uploadingImage.
  ///
  /// In en, this message translates to:
  /// **'Uploading...'**
  String get uploadingImage;

  /// No description provided for @uploadErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Upload failed'**
  String get uploadErrorTitle;

  /// No description provided for @uploadSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Upload successful'**
  String get uploadSuccessTitle;

  /// No description provided for @editImportedRecipeQuestion.
  ///
  /// In en, this message translates to:
  /// **'Do you want to edit the new recipe now?'**
  String get editImportedRecipeQuestion;

  /// No description provided for @notNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get notNow;

  /// No description provided for @pdfTooLarge.
  ///
  /// In en, this message translates to:
  /// **'The PDF file is too large (max 10 MB).'**
  String get pdfTooLarge;

  /// No description provided for @invalidUrl.
  ///
  /// In en, this message translates to:
  /// **'Invalid URL. Please enter a valid HTTP(S) URL.'**
  String get invalidUrl;

  /// No description provided for @cookWithFriends.
  ///
  /// In en, this message translates to:
  /// **'Cook with friends'**
  String get cookWithFriends;

  /// No description provided for @cookFriendsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Invite a friend to cook this recipe together'**
  String get cookFriendsSubtitle;

  /// No description provided for @copied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get copied;

  /// No description provided for @linkCopied.
  ///
  /// In en, this message translates to:
  /// **'Link copied'**
  String get linkCopied;

  /// No description provided for @startCooking.
  ///
  /// In en, this message translates to:
  /// **'Start cooking'**
  String get startCooking;

  /// No description provided for @hostNoRecipe.
  ///
  /// In en, this message translates to:
  /// **'Open from a recipe to host a session'**
  String get hostNoRecipe;

  /// No description provided for @uploadToOwnServer.
  ///
  /// In en, this message translates to:
  /// **'Save to my server'**
  String get uploadToOwnServer;

  /// No description provided for @uploadingRecipe.
  ///
  /// In en, this message translates to:
  /// **'Uploading recipe…'**
  String get uploadingRecipe;

  /// No description provided for @recipeUploadedToOwnServer.
  ///
  /// In en, this message translates to:
  /// **'Recipe saved to your server'**
  String get recipeUploadedToOwnServer;

  /// No description provided for @recipeUploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Upload failed'**
  String get recipeUploadFailed;

  /// No description provided for @allowGuestSaveRecipes.
  ///
  /// In en, this message translates to:
  /// **'Let guests save recipes to their own server'**
  String get allowGuestSaveRecipes;

  /// No description provided for @appIcon.
  ///
  /// In en, this message translates to:
  /// **'App icon'**
  String get appIcon;

  /// No description provided for @appIconClassic.
  ///
  /// In en, this message translates to:
  /// **'Classic'**
  String get appIconClassic;

  /// No description provided for @appIconModern.
  ///
  /// In en, this message translates to:
  /// **'Modern'**
  String get appIconModern;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// No description provided for @randomColor.
  ///
  /// In en, this message translates to:
  /// **'Random color'**
  String get randomColor;

  /// No description provided for @createFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not create'**
  String get createFailed;

  /// No description provided for @deleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not delete'**
  String get deleteFailed;

  /// No description provided for @deleteOrganizerConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"? This also removes it on the server.'**
  String deleteOrganizerConfirm(String name);

  /// No description provided for @connectionSection.
  ///
  /// In en, this message translates to:
  /// **'Connection'**
  String get connectionSection;

  /// No description provided for @token.
  ///
  /// In en, this message translates to:
  /// **'Token'**
  String get token;

  /// No description provided for @advancedOptions.
  ///
  /// In en, this message translates to:
  /// **'Advanced options'**
  String get advancedOptions;

  /// No description provided for @mealieApiVersion.
  ///
  /// In en, this message translates to:
  /// **'Mealie API version'**
  String get mealieApiVersion;

  /// No description provided for @sendOptionalHeaders.
  ///
  /// In en, this message translates to:
  /// **'Send optional headers'**
  String get sendOptionalHeaders;

  /// No description provided for @offlineRecipeImages.
  ///
  /// In en, this message translates to:
  /// **'Save recipe images offline'**
  String get offlineRecipeImages;

  /// No description provided for @offlineRecipeImagesHint.
  ///
  /// In en, this message translates to:
  /// **'Downloads all recipe images to this device so they also show without a connection. With large collections this can take up several hundred MB. Turning it off deletes the saved images.'**
  String get offlineRecipeImagesHint;

  /// No description provided for @offlineRecipeImagesStatus.
  ///
  /// In en, this message translates to:
  /// **'Saved: {count}/{total} · {size}'**
  String offlineRecipeImagesStatus(int count, int total, String size);

  /// No description provided for @offlineRecipeImagesDisableConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete all saved recipe images?'**
  String get offlineRecipeImagesDisableConfirm;

  /// No description provided for @headerNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Header {n} name'**
  String headerNameLabel(int n);

  /// No description provided for @headerValueLabel.
  ///
  /// In en, this message translates to:
  /// **'Header {n} value'**
  String headerValueLabel(int n);

  /// No description provided for @value.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get value;

  /// No description provided for @personalization.
  ///
  /// In en, this message translates to:
  /// **'Personalization'**
  String get personalization;

  /// No description provided for @showRecipeImagesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Shows images in the recipe list'**
  String get showRecipeImagesSubtitle;

  /// No description provided for @exactQuantities.
  ///
  /// In en, this message translates to:
  /// **'Add exact quantities'**
  String get exactQuantities;

  /// No description provided for @exactQuantitiesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ingredients & typed items keep quantity and unit (e.g. 200 g butter) instead of 1x per item — missing foods are created on the server'**
  String get exactQuantitiesSubtitle;

  /// No description provided for @remindToShop.
  ///
  /// In en, this message translates to:
  /// **'Remind me to shop'**
  String get remindToShop;

  /// No description provided for @remindToShopSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Notifies you when you\'re near a saved location and your shopping list has open items — even if the app is closed'**
  String get remindToShopSubtitle;

  /// No description provided for @shoppingReminderAddLocation.
  ///
  /// In en, this message translates to:
  /// **'Add location'**
  String get shoppingReminderAddLocation;

  /// No description provided for @shoppingReminderMaxLocations.
  ///
  /// In en, this message translates to:
  /// **'Maximum of 3 locations reached'**
  String get shoppingReminderMaxLocations;

  /// No description provided for @shoppingReminderLocationServiceDisabled.
  ///
  /// In en, this message translates to:
  /// **'Location services are turned off on this device'**
  String get shoppingReminderLocationServiceDisabled;

  /// No description provided for @shoppingReminderPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Location access needed'**
  String get shoppingReminderPermissionTitle;

  /// No description provided for @shoppingReminderPermissionMessage.
  ///
  /// In en, this message translates to:
  /// **'To remind you when you\'re near a shop, this needs \"Always\" location access — even while the app is closed. Please enable it in Settings.'**
  String get shoppingReminderPermissionMessage;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// No description provided for @shoppingReminderLocationName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get shoppingReminderLocationName;

  /// No description provided for @shoppingReminderUseCurrentLocation.
  ///
  /// In en, this message translates to:
  /// **'Use current location'**
  String get shoppingReminderUseCurrentLocation;

  /// No description provided for @shoppingReminderOrAddress.
  ///
  /// In en, this message translates to:
  /// **'or enter an address'**
  String get shoppingReminderOrAddress;

  /// No description provided for @shoppingReminderAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get shoppingReminderAddress;

  /// No description provided for @shoppingReminderAddressPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Street, city'**
  String get shoppingReminderAddressPlaceholder;

  /// No description provided for @shoppingReminderSearchAddress.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get shoppingReminderSearchAddress;

  /// No description provided for @shoppingReminderLocationFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t determine your location'**
  String get shoppingReminderLocationFailed;

  /// No description provided for @shoppingReminderAddressNotFound.
  ///
  /// In en, this message translates to:
  /// **'Address not found'**
  String get shoppingReminderAddressNotFound;

  /// No description provided for @ratingFailed.
  ///
  /// In en, this message translates to:
  /// **'The rating could not be saved — please try again.'**
  String get ratingFailed;

  /// No description provided for @lastCooked.
  ///
  /// In en, this message translates to:
  /// **'Last made'**
  String get lastCooked;

  /// No description provided for @syncLastCooked.
  ///
  /// In en, this message translates to:
  /// **'Update “last made”'**
  String get syncLastCooked;

  /// No description provided for @syncLastCookedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Saves today\'s date and a timeline entry on the server — like the Mealie web app.'**
  String get syncLastCookedSubtitle;

  /// No description provided for @developer.
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get developer;

  /// No description provided for @enableLoggingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Records print/error logs (last 500 lines)'**
  String get enableLoggingSubtitle;

  /// No description provided for @entriesLabel.
  ///
  /// In en, this message translates to:
  /// **'Entries'**
  String get entriesLabel;

  /// No description provided for @fileSize.
  ///
  /// In en, this message translates to:
  /// **'File size'**
  String get fileSize;

  /// No description provided for @showAction.
  ///
  /// In en, this message translates to:
  /// **'Show'**
  String get showAction;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @logsWithCount.
  ///
  /// In en, this message translates to:
  /// **'Logs ({count})'**
  String logsWithCount(int count);

  /// No description provided for @noLogs.
  ///
  /// In en, this message translates to:
  /// **'No logs available'**
  String get noLogs;

  /// No description provided for @logsTitle.
  ///
  /// In en, this message translates to:
  /// **'Logs'**
  String get logsTitle;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @connectionFailedCheck.
  ///
  /// In en, this message translates to:
  /// **'Connection failed. Check URL and token.'**
  String get connectionFailedCheck;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @setupPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Your password is not stored — the app logs you in once and generates an API token from it (same as Profile → API Tokens in the web app).'**
  String get setupPasswordHint;

  /// No description provided for @loginAndConnect.
  ///
  /// In en, this message translates to:
  /// **'Log in & connect'**
  String get loginAndConnect;

  /// No description provided for @loginInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Username or password is incorrect.'**
  String get loginInvalidCredentials;

  /// No description provided for @loginAndGenerateToken.
  ///
  /// In en, this message translates to:
  /// **'Log in & generate token'**
  String get loginAndGenerateToken;

  /// No description provided for @loggingIn.
  ///
  /// In en, this message translates to:
  /// **'Signing in…'**
  String get loggingIn;

  /// No description provided for @apiTokenSaveHint.
  ///
  /// In en, this message translates to:
  /// **'Token applied — please tap “Save changes” below.'**
  String get apiTokenSaveHint;

  /// No description provided for @renewApiToken.
  ///
  /// In en, this message translates to:
  /// **'Renew API token'**
  String get renewApiToken;

  /// No description provided for @setupAuthChoiceTitle.
  ///
  /// In en, this message translates to:
  /// **'How would you like to sign in?'**
  String get setupAuthChoiceTitle;

  /// No description provided for @authModePasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Let the app create an API key for me'**
  String get authModePasswordTitle;

  /// No description provided for @authModePasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with username & password — the app generates a token automatically.'**
  String get authModePasswordSubtitle;

  /// No description provided for @authModeTokenTitle.
  ///
  /// In en, this message translates to:
  /// **'I already have an API key'**
  String get authModeTokenTitle;

  /// No description provided for @authModeTokenSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Copied from the Mealie profile (Profile → API Tokens).'**
  String get authModeTokenSubtitle;

  /// No description provided for @keyN.
  ///
  /// In en, this message translates to:
  /// **'Key {n}'**
  String keyN(int n);

  /// No description provided for @valueN.
  ///
  /// In en, this message translates to:
  /// **'Value {n}'**
  String valueN(int n);

  /// No description provided for @openCookingMode.
  ///
  /// In en, this message translates to:
  /// **'Open cooking mode'**
  String get openCookingMode;

  /// No description provided for @activeRecipes.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 active recipe} other{{count} active recipes}}'**
  String activeRecipes(int count);

  /// No description provided for @reparseIngredients.
  ///
  /// In en, this message translates to:
  /// **'Re-parse ingredients'**
  String get reparseIngredients;

  /// No description provided for @reparseIngredientsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Split quantity/unit/ingredient (e.g. “200 g flour”)'**
  String get reparseIngredientsSubtitle;

  /// No description provided for @reparseDone.
  ///
  /// In en, this message translates to:
  /// **'Ingredients split – tap “Save changes” to apply'**
  String get reparseDone;

  /// No description provided for @reparseNone.
  ///
  /// In en, this message translates to:
  /// **'No splittable ingredients found'**
  String get reparseNone;

  /// No description provided for @tagsAndCategories.
  ///
  /// In en, this message translates to:
  /// **'Tags, categories & tools'**
  String get tagsAndCategories;

  /// No description provided for @tapToAddPhoto.
  ///
  /// In en, this message translates to:
  /// **'Tap to add photo'**
  String get tapToAddPhoto;

  /// No description provided for @descriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get descriptionLabel;

  /// No description provided for @searchingDevices.
  ///
  /// In en, this message translates to:
  /// **'Searching for devices on the same Wi-Fi…'**
  String get searchingDevices;

  /// No description provided for @selectAll.
  ///
  /// In en, this message translates to:
  /// **'Select all'**
  String get selectAll;

  /// No description provided for @importReminders.
  ///
  /// In en, this message translates to:
  /// **'Import reminders'**
  String get importReminders;

  /// No description provided for @importGoogleTasks.
  ///
  /// In en, this message translates to:
  /// **'Import Google Tasks'**
  String get importGoogleTasks;

  /// No description provided for @noTaskLists.
  ///
  /// In en, this message translates to:
  /// **'No task lists found'**
  String get noTaskLists;

  /// No description provided for @noReminderLists.
  ///
  /// In en, this message translates to:
  /// **'No reminder lists found'**
  String get noReminderLists;

  /// No description provided for @importCount.
  ///
  /// In en, this message translates to:
  /// **'Import {count}'**
  String importCount(int count);

  /// No description provided for @activeRecipeTimer.
  ///
  /// In en, this message translates to:
  /// **'Active recipe timer'**
  String get activeRecipeTimer;

  /// No description provided for @linkIngredients.
  ///
  /// In en, this message translates to:
  /// **'Link ingredients'**
  String get linkIngredients;

  /// No description provided for @noIngredientsToLink.
  ///
  /// In en, this message translates to:
  /// **'No ingredients to link yet'**
  String get noIngredientsToLink;

  /// No description provided for @importLanguageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Language for recipes imported from a photo or PDF'**
  String get importLanguageSubtitle;

  /// No description provided for @importLanguageSearch.
  ///
  /// In en, this message translates to:
  /// **'Search language'**
  String get importLanguageSearch;

  /// No description provided for @importLanguageFollowApp.
  ///
  /// In en, this message translates to:
  /// **'Same as app language'**
  String get importLanguageFollowApp;

  /// No description provided for @importLanguageNoMatch.
  ///
  /// In en, this message translates to:
  /// **'No language found'**
  String get importLanguageNoMatch;

  /// No description provided for @setupImportLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'AI recipe import'**
  String get setupImportLanguageTitle;

  /// No description provided for @setupImportLanguageBody.
  ///
  /// In en, this message translates to:
  /// **'Photos and PDFs can be turned into recipes by AI. Pick the language they should end up in — handy if your mother tongue is not available as an app language. You can change this later in the settings.'**
  String get setupImportLanguageBody;

  /// No description provided for @setupImportLanguageSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Use the search in the picker to find languages the app interface does not offer.'**
  String get setupImportLanguageSearchHint;

  /// No description provided for @setupCachingKeepOpenTitle.
  ///
  /// In en, this message translates to:
  /// **'Please keep the app open'**
  String get setupCachingKeepOpenTitle;

  /// No description provided for @setupCachingKeepOpenBody.
  ///
  /// In en, this message translates to:
  /// **'Loading runs in the foreground. Leave the app open until it finishes — if you close it or switch away for too long, the process stops and starts over later.'**
  String get setupCachingKeepOpenBody;

  /// No description provided for @supportContact.
  ///
  /// In en, this message translates to:
  /// **'Contact support'**
  String get supportContact;

  /// No description provided for @supportDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'Describe your problem and we will get back to you. The log helps a lot with troubleshooting — you can attach it as a text file.'**
  String get supportDialogMessage;

  /// No description provided for @supportWithoutLogs.
  ///
  /// In en, this message translates to:
  /// **'Without log'**
  String get supportWithoutLogs;

  /// No description provided for @supportWithLogs.
  ///
  /// In en, this message translates to:
  /// **'Attach log'**
  String get supportWithLogs;

  /// No description provided for @supportMailSubject.
  ///
  /// In en, this message translates to:
  /// **'Mealie Recipes — Support'**
  String get supportMailSubject;

  /// No description provided for @supportMailHint.
  ///
  /// In en, this message translates to:
  /// **'Please describe your problem here:'**
  String get supportMailHint;

  /// No description provided for @supportLogsEmpty.
  ///
  /// In en, this message translates to:
  /// **'The log is empty. Turn on logging, reproduce the problem and then send it.'**
  String get supportLogsEmpty;

  /// No description provided for @supportAddressCopied.
  ///
  /// In en, this message translates to:
  /// **'Address copied: {email}'**
  String supportAddressCopied(String email);

  /// No description provided for @supportNoMailApp.
  ///
  /// In en, this message translates to:
  /// **'No mail app found. Address copied: {email}'**
  String supportNoMailApp(String email);

  /// No description provided for @createRecipeFromImages.
  ///
  /// In en, this message translates to:
  /// **'Create recipe'**
  String get createRecipeFromImages;

  /// No description provided for @imagePagesSelected.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 page selected} other{{count} pages selected}}'**
  String imagePagesSelected(int count);

  /// No description provided for @imagePagesHint.
  ///
  /// In en, this message translates to:
  /// **'The first image becomes the recipe\'s main image. Press and hold a page to reorder it.'**
  String get imagePagesHint;

  /// No description provided for @mainImageBadge.
  ///
  /// In en, this message translates to:
  /// **'Main'**
  String get mainImageBadge;

  /// No description provided for @maxImagesReached.
  ///
  /// In en, this message translates to:
  /// **'You can add up to {max} images per recipe.'**
  String maxImagesReached(int max);

  /// No description provided for @removePage.
  ///
  /// In en, this message translates to:
  /// **'Remove page'**
  String get removePage;

  /// No description provided for @preparingPdf.
  ///
  /// In en, this message translates to:
  /// **'Processing PDF...'**
  String get preparingPdf;

  /// No description provided for @shareRecipeTitle.
  ///
  /// In en, this message translates to:
  /// **'Share recipe'**
  String get shareRecipeTitle;

  /// No description provided for @recipeOptionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Options'**
  String get recipeOptionsTitle;

  /// No description provided for @exportAsPdf.
  ///
  /// In en, this message translates to:
  /// **'Export as PDF'**
  String get exportAsPdf;

  /// No description provided for @generatingPdf.
  ///
  /// In en, this message translates to:
  /// **'Generating PDF…'**
  String get generatingPdf;

  /// No description provided for @pdfExportFailed.
  ///
  /// In en, this message translates to:
  /// **'PDF export failed'**
  String get pdfExportFailed;

  /// No description provided for @recipeTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get recipeTime;

  /// No description provided for @ingredientSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Section'**
  String get ingredientSectionTitle;

  /// No description provided for @addIngredientSection.
  ///
  /// In en, this message translates to:
  /// **'Add section'**
  String get addIngredientSection;

  /// No description provided for @aiImportToggle.
  ///
  /// In en, this message translates to:
  /// **'Analyze with AI'**
  String get aiImportToggle;

  /// No description provided for @aiImportToggleHint.
  ///
  /// In en, this message translates to:
  /// **'Also for recipe videos (YouTube, Instagram, TikTok …) and pages the regular import can\'t read. Requires an AI provider on your Mealie server — for videos also an audio provider.'**
  String get aiImportToggleHint;

  /// No description provided for @aiImportButton.
  ///
  /// In en, this message translates to:
  /// **'Import with AI'**
  String get aiImportButton;

  /// No description provided for @aiImportRunning.
  ///
  /// In en, this message translates to:
  /// **'The AI is analyzing the link … videos can take a few minutes.'**
  String get aiImportRunning;

  /// No description provided for @aiImportFailed.
  ///
  /// In en, this message translates to:
  /// **'The AI import failed. Check the AI settings on your Mealie server.'**
  String get aiImportFailed;

  /// No description provided for @stepHeadingLabel.
  ///
  /// In en, this message translates to:
  /// **'Step heading (optional)'**
  String get stepHeadingLabel;

  /// No description provided for @linkedRecipeLabel.
  ///
  /// In en, this message translates to:
  /// **'Linked recipe'**
  String get linkedRecipeLabel;

  /// No description provided for @toolsTitle.
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get toolsTitle;

  /// No description provided for @prepareTools.
  ///
  /// In en, this message translates to:
  /// **'Please get the following tools ready'**
  String get prepareTools;

  /// No description provided for @newTool.
  ///
  /// In en, this message translates to:
  /// **'New tool'**
  String get newTool;

  /// No description provided for @renameAction.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get renameAction;

  /// No description provided for @organizerEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet. Tap “+” in the top right to create one.'**
  String get organizerEmpty;

  /// No description provided for @organizerRecipeCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No recipes} =1{1 recipe} other{{count} recipes}}'**
  String organizerRecipeCount(int count);

  /// No description provided for @toolOnHand.
  ///
  /// In en, this message translates to:
  /// **'On hand'**
  String get toolOnHand;

  /// No description provided for @mealDiceSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Dice filter'**
  String get mealDiceSettingsTitle;

  /// No description provided for @mealDiceSettingsHint.
  ///
  /// In en, this message translates to:
  /// **'Choose categories and tags for each meal. When you roll the dice, only recipes with at least one of them are suggested. The same entry can be used for several meals.'**
  String get mealDiceSettingsHint;

  /// No description provided for @mealDiceSettingsNoneHint.
  ///
  /// In en, this message translates to:
  /// **'Nothing selected for this meal: the dice picks automatically by category names like “Breakfast”, “Lunch” or “Dinner”.'**
  String get mealDiceSettingsNoneHint;

  /// No description provided for @mealDiceAutoHintTitle.
  ///
  /// In en, this message translates to:
  /// **'Automatic selection'**
  String get mealDiceAutoHintTitle;

  /// No description provided for @mealDiceAutoHintBody.
  ///
  /// In en, this message translates to:
  /// **'No categories or tags are set for this meal yet. The dice therefore looks for categories like “Breakfast”, “Lunch” or “Dinner” and fills up with other recipes.\n\nTo choose your own: in the meal plan, tap the gear icon next to “+”.'**
  String get mealDiceAutoHintBody;

  /// No description provided for @dontShowAgain.
  ///
  /// In en, this message translates to:
  /// **'Don\'t show again'**
  String get dontShowAgain;

  /// No description provided for @mealDiceNoMatches.
  ///
  /// In en, this message translates to:
  /// **'No recipe matches the categories and tags selected for this meal.'**
  String get mealDiceNoMatches;

  /// No description provided for @mealDiceFewMatches.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Only 1 matching recipe} other{Only {count} matching recipes}}'**
  String mealDiceFewMatches(int count);

  /// No description provided for @commentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get commentsTitle;

  /// No description provided for @commentHint.
  ///
  /// In en, this message translates to:
  /// **'Write a comment…'**
  String get commentHint;

  /// No description provided for @commentSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'The comment could not be saved.'**
  String get commentSaveFailed;

  /// No description provided for @commentDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this comment?'**
  String get commentDeleteConfirm;

  /// No description provided for @cookingDoneCommentLabel.
  ///
  /// In en, this message translates to:
  /// **'Comment (optional)'**
  String get cookingDoneCommentLabel;

  /// No description provided for @cookingDoneCommentHint.
  ///
  /// In en, this message translates to:
  /// **'How did it turn out? Tips for next time…'**
  String get cookingDoneCommentHint;

  /// No description provided for @nutritionTitle.
  ///
  /// In en, this message translates to:
  /// **'Nutrition'**
  String get nutritionTitle;

  /// No description provided for @nutritionPerServing.
  ///
  /// In en, this message translates to:
  /// **'per serving'**
  String get nutritionPerServing;

  /// No description provided for @nutritionCalories.
  ///
  /// In en, this message translates to:
  /// **'Calories'**
  String get nutritionCalories;

  /// No description provided for @nutritionFat.
  ///
  /// In en, this message translates to:
  /// **'Fat'**
  String get nutritionFat;

  /// No description provided for @nutritionSaturatedFat.
  ///
  /// In en, this message translates to:
  /// **'Saturated fat'**
  String get nutritionSaturatedFat;

  /// No description provided for @nutritionTransFat.
  ///
  /// In en, this message translates to:
  /// **'Trans fat'**
  String get nutritionTransFat;

  /// No description provided for @nutritionUnsaturatedFat.
  ///
  /// In en, this message translates to:
  /// **'Unsaturated fat'**
  String get nutritionUnsaturatedFat;

  /// No description provided for @nutritionCholesterol.
  ///
  /// In en, this message translates to:
  /// **'Cholesterol'**
  String get nutritionCholesterol;

  /// No description provided for @nutritionSodium.
  ///
  /// In en, this message translates to:
  /// **'Sodium'**
  String get nutritionSodium;

  /// No description provided for @nutritionCarbohydrates.
  ///
  /// In en, this message translates to:
  /// **'Carbohydrates'**
  String get nutritionCarbohydrates;

  /// No description provided for @nutritionFiber.
  ///
  /// In en, this message translates to:
  /// **'Fiber'**
  String get nutritionFiber;

  /// No description provided for @nutritionSugar.
  ///
  /// In en, this message translates to:
  /// **'Sugar'**
  String get nutritionSugar;

  /// No description provided for @nutritionProtein.
  ///
  /// In en, this message translates to:
  /// **'Protein'**
  String get nutritionProtein;

  /// No description provided for @timelineTitle.
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get timelineTitle;

  /// No description provided for @timelineMadeThis.
  ///
  /// In en, this message translates to:
  /// **'I made this'**
  String get timelineMadeThis;

  /// No description provided for @timelineUserMadeThis.
  ///
  /// In en, this message translates to:
  /// **'{name} made this'**
  String timelineUserMadeThis(String name);

  /// No description provided for @timelineEmpty.
  ///
  /// In en, this message translates to:
  /// **'No timeline entries yet.'**
  String get timelineEmpty;

  /// No description provided for @timelineDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get timelineDate;

  /// No description provided for @timelineNoteHint.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get timelineNoteHint;

  /// No description provided for @timelineAddPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add photo'**
  String get timelineAddPhoto;

  /// No description provided for @timelineRemovePhoto.
  ///
  /// In en, this message translates to:
  /// **'Remove photo'**
  String get timelineRemovePhoto;

  /// No description provided for @timelineSaved.
  ///
  /// In en, this message translates to:
  /// **'Added to the timeline'**
  String get timelineSaved;

  /// No description provided for @timelineSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not add to the timeline'**
  String get timelineSaveFailed;

  /// No description provided for @timelineImageFailed.
  ///
  /// In en, this message translates to:
  /// **'Entry saved, but the photo could not be uploaded'**
  String get timelineImageFailed;

  /// No description provided for @timelineDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this entry from the timeline?'**
  String get timelineDeleteConfirm;

  /// No description provided for @timelineEditNote.
  ///
  /// In en, this message translates to:
  /// **'Edit note'**
  String get timelineEditNote;

  /// No description provided for @timelineUnknownRecipe.
  ///
  /// In en, this message translates to:
  /// **'Recipe not found'**
  String get timelineUnknownRecipe;

  /// No description provided for @cookingDonePhotoHint.
  ///
  /// In en, this message translates to:
  /// **'Photo for the Mealie timeline (optional)'**
  String get cookingDonePhotoHint;

  /// No description provided for @assetsTitle.
  ///
  /// In en, this message translates to:
  /// **'Attachments'**
  String get assetsTitle;

  /// No description provided for @assetsAdd.
  ///
  /// In en, this message translates to:
  /// **'Add attachment'**
  String get assetsAdd;

  /// No description provided for @assetsChooseFile.
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get assetsChooseFile;

  /// No description provided for @assetsUploading.
  ///
  /// In en, this message translates to:
  /// **'Uploading…'**
  String get assetsUploading;

  /// No description provided for @assetsUploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Attachment could not be uploaded'**
  String get assetsUploadFailed;

  /// No description provided for @assetsDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove “{name}” from the attachments?'**
  String assetsDeleteConfirm(String name);

  /// No description provided for @assetsOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'Attachment could not be opened'**
  String get assetsOpenFailed;

  /// No description provided for @assetsUnsupported.
  ///
  /// In en, this message translates to:
  /// **'Mealie only supports PDF, images, TXT, MD, CSV and JSON.'**
  String get assetsUnsupported;

  /// No description provided for @assetsShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get assetsShare;

  /// No description provided for @mealRulesTitle.
  ///
  /// In en, this message translates to:
  /// **'Mealie rules'**
  String get mealRulesTitle;

  /// No description provided for @mealRulesHint.
  ///
  /// In en, this message translates to:
  /// **'Also used by the Mealie web app. If several rules apply to the day and meal, all of them must match. If no rule applies, the dice picks from all recipes.'**
  String get mealRulesHint;

  /// No description provided for @mealRuleAdd.
  ///
  /// In en, this message translates to:
  /// **'Add rule'**
  String get mealRuleAdd;

  /// No description provided for @mealRuleNewTitle.
  ///
  /// In en, this message translates to:
  /// **'New rule'**
  String get mealRuleNewTitle;

  /// No description provided for @mealRuleEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit rule'**
  String get mealRuleEditTitle;

  /// No description provided for @mealRuleDay.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get mealRuleDay;

  /// No description provided for @mealRuleAnyDay.
  ///
  /// In en, this message translates to:
  /// **'Any day'**
  String get mealRuleAnyDay;

  /// No description provided for @mealRuleMealType.
  ///
  /// In en, this message translates to:
  /// **'Meal'**
  String get mealRuleMealType;

  /// No description provided for @mealRuleAnyMeal.
  ///
  /// In en, this message translates to:
  /// **'Any meal'**
  String get mealRuleAnyMeal;

  /// No description provided for @mealRuleConditionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Conditions'**
  String get mealRuleConditionsTitle;

  /// No description provided for @mealRuleAllRecipes.
  ///
  /// In en, this message translates to:
  /// **'All recipes'**
  String get mealRuleAllRecipes;

  /// No description provided for @mealRuleDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this rule?'**
  String get mealRuleDeleteConfirm;

  /// No description provided for @mealRulesOffline.
  ///
  /// In en, this message translates to:
  /// **'Mealie rules are unavailable right now – the dice uses the app selection.'**
  String get mealRulesOffline;

  /// No description provided for @mealRulesNoMatches.
  ///
  /// In en, this message translates to:
  /// **'No recipes match the Mealie rules for this meal.'**
  String get mealRulesNoMatches;

  /// No description provided for @mealTypeSide.
  ///
  /// In en, this message translates to:
  /// **'Side'**
  String get mealTypeSide;

  /// No description provided for @mealTypeSnack.
  ///
  /// In en, this message translates to:
  /// **'Snack'**
  String get mealTypeSnack;

  /// No description provided for @mealTypeDrink.
  ///
  /// In en, this message translates to:
  /// **'Drink'**
  String get mealTypeDrink;

  /// No description provided for @mealTypeDessert.
  ///
  /// In en, this message translates to:
  /// **'Dessert'**
  String get mealTypeDessert;

  /// No description provided for @foodsTitle.
  ///
  /// In en, this message translates to:
  /// **'Foods'**
  String get foodsTitle;

  /// No description provided for @unitsTitle.
  ///
  /// In en, this message translates to:
  /// **'Units'**
  String get unitsTitle;

  /// No description provided for @newFood.
  ///
  /// In en, this message translates to:
  /// **'New food'**
  String get newFood;

  /// No description provided for @newUnit.
  ///
  /// In en, this message translates to:
  /// **'New unit'**
  String get newUnit;

  /// No description provided for @editFood.
  ///
  /// In en, this message translates to:
  /// **'Edit food'**
  String get editFood;

  /// No description provided for @editUnit.
  ///
  /// In en, this message translates to:
  /// **'Edit unit'**
  String get editUnit;

  /// No description provided for @pluralNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Plural name'**
  String get pluralNameLabel;

  /// No description provided for @abbreviationLabel.
  ///
  /// In en, this message translates to:
  /// **'Abbreviation'**
  String get abbreviationLabel;

  /// No description provided for @pluralAbbreviationLabel.
  ///
  /// In en, this message translates to:
  /// **'Plural abbreviation'**
  String get pluralAbbreviationLabel;

  /// No description provided for @mergeAction.
  ///
  /// In en, this message translates to:
  /// **'Merge'**
  String get mergeAction;

  /// No description provided for @mergeIntoTitle.
  ///
  /// In en, this message translates to:
  /// **'Merge “{name}” into…'**
  String mergeIntoTitle(String name);

  /// No description provided for @mergeConfirm.
  ///
  /// In en, this message translates to:
  /// **'“{from}” will be merged into “{to}”: all recipes and shopping lists will use “{to}” afterwards, and “{from}” will be deleted.'**
  String mergeConfirm(String from, String to);

  /// No description provided for @mergeFailed.
  ///
  /// In en, this message translates to:
  /// **'Merge failed'**
  String get mergeFailed;

  /// No description provided for @foodUnitDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete “{name}”? Ingredients that use it will lose the reference.'**
  String foodUnitDeleteConfirm(String name);

  /// No description provided for @foodsUnitsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No entries yet.'**
  String get foodsUnitsEmpty;

  /// No description provided for @mealRuleConditionCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 condition} other{{count} conditions}}'**
  String mealRuleConditionCount(int count);

  /// No description provided for @showAll.
  ///
  /// In en, this message translates to:
  /// **'Show all'**
  String get showAll;

  /// No description provided for @mealDiceModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Dice uses'**
  String get mealDiceModeTitle;

  /// No description provided for @mealDiceModeApp.
  ///
  /// In en, this message translates to:
  /// **'App selection'**
  String get mealDiceModeApp;

  /// No description provided for @switchListTitle.
  ///
  /// In en, this message translates to:
  /// **'Switch list'**
  String get switchListTitle;

  /// No description provided for @newShoppingList.
  ///
  /// In en, this message translates to:
  /// **'New shopping list'**
  String get newShoppingList;

  /// No description provided for @shoppingListDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete “{name}”? All items in it will be deleted too.'**
  String shoppingListDeleteConfirm(String name);

  /// No description provided for @labelOrderTitle.
  ///
  /// In en, this message translates to:
  /// **'Sort labels'**
  String get labelOrderTitle;

  /// No description provided for @labelOrderHint.
  ///
  /// In en, this message translates to:
  /// **'Drag to sort. Applies to this list – in the Mealie web app too.'**
  String get labelOrderHint;

  /// No description provided for @labelOrderEmpty.
  ///
  /// In en, this message translates to:
  /// **'This list has no labels yet.'**
  String get labelOrderEmpty;

  /// No description provided for @useAsActiveList.
  ///
  /// In en, this message translates to:
  /// **'Use as active list'**
  String get useAsActiveList;

  /// No description provided for @activeListBadge.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get activeListBadge;

  /// No description provided for @foodLabelLabel.
  ///
  /// In en, this message translates to:
  /// **'Label'**
  String get foodLabelLabel;

  /// No description provided for @foodNoLabel.
  ///
  /// In en, this message translates to:
  /// **'No label'**
  String get foodNoLabel;

  /// No description provided for @aliasesLabel.
  ///
  /// In en, this message translates to:
  /// **'Aliases'**
  String get aliasesLabel;

  /// No description provided for @aliasAddHint.
  ///
  /// In en, this message translates to:
  /// **'Add alias'**
  String get aliasAddHint;

  /// No description provided for @foodOnHand.
  ///
  /// In en, this message translates to:
  /// **'On hand in the household'**
  String get foodOnHand;

  /// No description provided for @timelineChildRecipesTitle.
  ///
  /// In en, this message translates to:
  /// **'Also add for linked recipes'**
  String get timelineChildRecipesTitle;

  /// No description provided for @timelineMadeForRecipe.
  ///
  /// In en, this message translates to:
  /// **'Made for {recipe}'**
  String timelineMadeForRecipe(String recipe);

  /// No description provided for @timelineFilter.
  ///
  /// In en, this message translates to:
  /// **'Filter entries'**
  String get timelineFilter;

  /// No description provided for @timelineTypeComment.
  ///
  /// In en, this message translates to:
  /// **'Made & notes'**
  String get timelineTypeComment;

  /// No description provided for @timelineTypeInfo.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get timelineTypeInfo;

  /// No description provided for @timelineTypeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get timelineTypeSystem;

  /// No description provided for @listManagementTitle.
  ///
  /// In en, this message translates to:
  /// **'Shopping lists'**
  String get listManagementTitle;

  /// No description provided for @managementTitle.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get managementTitle;

  /// No description provided for @pinToHome.
  ///
  /// In en, this message translates to:
  /// **'Add to home screen'**
  String get pinToHome;

  /// No description provided for @unpinFromHome.
  ///
  /// In en, this message translates to:
  /// **'Remove from home screen'**
  String get unpinFromHome;

  /// No description provided for @homeScreenFull.
  ///
  /// In en, this message translates to:
  /// **'The home screen is full – at most {count} tiles. Remove another tile under “More” first.'**
  String homeScreenFull(int count);

  /// No description provided for @selectAction.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get selectAction;

  /// No description provided for @selectedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String selectedCount(int count);

  /// No description provided for @assignLabelAction.
  ///
  /// In en, this message translates to:
  /// **'Assign label'**
  String get assignLabelAction;

  /// No description provided for @assignLabelOverwriteHint.
  ///
  /// In en, this message translates to:
  /// **'Overwrites the label of all selected foods.'**
  String get assignLabelOverwriteHint;

  /// No description provided for @deleteSelectedConfirm.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Delete 1 entry?} other{Delete {count} entries?}}'**
  String deleteSelectedConfirm(int count);

  /// No description provided for @seedDataAction.
  ///
  /// In en, this message translates to:
  /// **'Load default data'**
  String get seedDataAction;

  /// No description provided for @seedFoodsHint.
  ///
  /// In en, this message translates to:
  /// **'Creates Mealie\'s default foods in the selected language.'**
  String get seedFoodsHint;

  /// No description provided for @seedUnitsHint.
  ///
  /// In en, this message translates to:
  /// **'Creates Mealie\'s default units in the selected language.'**
  String get seedUnitsHint;

  /// No description provided for @seedLanguageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get seedLanguageLabel;

  /// No description provided for @seedDuplicateWarning.
  ///
  /// In en, this message translates to:
  /// **'You already have entries. Mealie does not reconcile duplicates – you\'ll have to merge them yourself afterwards.'**
  String get seedDuplicateWarning;

  /// No description provided for @seedDone.
  ///
  /// In en, this message translates to:
  /// **'Default data created'**
  String get seedDone;

  /// No description provided for @seedFailed.
  ///
  /// In en, this message translates to:
  /// **'Default data could not be loaded'**
  String get seedFailed;

  /// No description provided for @exportAction.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get exportAction;

  /// No description provided for @substitutionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Substitutes'**
  String get substitutionsLabel;

  /// No description provided for @substitutionAddHint.
  ///
  /// In en, this message translates to:
  /// **'Add substitute'**
  String get substitutionAddHint;

  /// No description provided for @substitutionFoodLabel.
  ///
  /// In en, this message translates to:
  /// **'Food (optional)'**
  String get substitutionFoodLabel;

  /// No description provided for @substitutionNoteLabel.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get substitutionNoteLabel;

  /// No description provided for @substitutionNeedOne.
  ///
  /// In en, this message translates to:
  /// **'Enter a food or a note'**
  String get substitutionNeedOne;

  /// No description provided for @useAbbreviationLabel.
  ///
  /// In en, this message translates to:
  /// **'Use abbreviation'**
  String get useAbbreviationLabel;

  /// No description provided for @useAbbreviationHint.
  ///
  /// In en, this message translates to:
  /// **'Show “g” instead of “gram” in recipes'**
  String get useAbbreviationHint;

  /// No description provided for @fractionLabel.
  ///
  /// In en, this message translates to:
  /// **'Display as fraction'**
  String get fractionLabel;

  /// No description provided for @fractionHint.
  ///
  /// In en, this message translates to:
  /// **'½ instead of 0.5'**
  String get fractionHint;

  /// No description provided for @standardizationTitle.
  ///
  /// In en, this message translates to:
  /// **'Standardization'**
  String get standardizationTitle;

  /// No description provided for @standardizationHint.
  ///
  /// In en, this message translates to:
  /// **'For conversions: 1 of this unit equals … (e.g. 1 tbsp = 15 milliliters).'**
  String get standardizationHint;

  /// No description provided for @standardQuantityLabel.
  ///
  /// In en, this message translates to:
  /// **'Standard quantity'**
  String get standardQuantityLabel;

  /// No description provided for @standardUnitLabel.
  ///
  /// In en, this message translates to:
  /// **'Standard unit'**
  String get standardUnitLabel;

  /// No description provided for @standardUnitNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get standardUnitNone;

  /// No description provided for @stdFluidOunce.
  ///
  /// In en, this message translates to:
  /// **'Fluid ounce (fl oz)'**
  String get stdFluidOunce;

  /// No description provided for @stdCup.
  ///
  /// In en, this message translates to:
  /// **'Cup (US)'**
  String get stdCup;

  /// No description provided for @stdOunce.
  ///
  /// In en, this message translates to:
  /// **'Ounce (oz)'**
  String get stdOunce;

  /// No description provided for @stdPound.
  ///
  /// In en, this message translates to:
  /// **'Pound (lb)'**
  String get stdPound;

  /// No description provided for @stdMilliliter.
  ///
  /// In en, this message translates to:
  /// **'Milliliter'**
  String get stdMilliliter;

  /// No description provided for @stdLiter.
  ///
  /// In en, this message translates to:
  /// **'Liter'**
  String get stdLiter;

  /// No description provided for @stdGram.
  ///
  /// In en, this message translates to:
  /// **'Gram'**
  String get stdGram;

  /// No description provided for @stdKilogram.
  ///
  /// In en, this message translates to:
  /// **'Kilogram'**
  String get stdKilogram;

  /// No description provided for @labelsTitle.
  ///
  /// In en, this message translates to:
  /// **'Labels'**
  String get labelsTitle;

  /// No description provided for @newLabel.
  ///
  /// In en, this message translates to:
  /// **'New label'**
  String get newLabel;

  /// No description provided for @editLabel.
  ///
  /// In en, this message translates to:
  /// **'Edit label'**
  String get editLabel;

  /// No description provided for @colorLabel.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get colorLabel;

  /// No description provided for @labelDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete “{name}”? Items and foods will lose this label.'**
  String labelDeleteConfirm(String name);

  /// No description provided for @importMenuAction.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get importMenuAction;

  /// No description provided for @archivedEmpty.
  ///
  /// In en, this message translates to:
  /// **'No archived purchases yet. Tap “Complete Shopping” after shopping – the checked items will be stored here.'**
  String get archivedEmpty;

  /// No description provided for @sectionTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Section title'**
  String get sectionTitleLabel;

  /// No description provided for @clearSection.
  ///
  /// In en, this message translates to:
  /// **'Clear section'**
  String get clearSection;

  /// No description provided for @noPermissionGeneric.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have permission for this in Mealie. Ask an admin or household manager.'**
  String get noPermissionGeneric;

  /// No description provided for @noPermissionEditRecipe.
  ///
  /// In en, this message translates to:
  /// **'You can\'t edit this recipe – it\'s locked or belongs to another household. Only its creator or an admin can.'**
  String get noPermissionEditRecipe;

  /// No description provided for @noPermissionDeleteRecipe.
  ///
  /// In en, this message translates to:
  /// **'Only the recipe\'s creator or an admin can delete it.'**
  String get noPermissionDeleteRecipe;

  /// No description provided for @noPermissionDemoteSelf.
  ///
  /// In en, this message translates to:
  /// **'You can\'t remove your own admin rights.'**
  String get noPermissionDemoteSelf;

  /// No description provided for @recipeLockedHint.
  ///
  /// In en, this message translates to:
  /// **'Locked – only its creator can edit it'**
  String get recipeLockedHint;

  /// No description provided for @recipeDeleteOwnerOnlyHint.
  ///
  /// In en, this message translates to:
  /// **'Only its creator or an admin can delete'**
  String get recipeDeleteOwnerOnlyHint;

  /// No description provided for @organizeReadOnlyHint.
  ///
  /// In en, this message translates to:
  /// **'View only: creating, changing and deleting requires the permission “User can manage foods, tags, and categories”.'**
  String get organizeReadOnlyHint;

  /// No description provided for @notesNotSavedNoPermission.
  ///
  /// In en, this message translates to:
  /// **'Note not saved – you don\'t have permission to edit this recipe.'**
  String get notesNotSavedNoPermission;

  /// No description provided for @userManagementTitle.
  ///
  /// In en, this message translates to:
  /// **'User Management'**
  String get userManagementTitle;

  /// No description provided for @usersTitle.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get usersTitle;

  /// No description provided for @editUserTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit User'**
  String get editUserTitle;

  /// No description provided for @fullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullNameLabel;

  /// No description provided for @usernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get usernameLabel;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @householdLabel.
  ///
  /// In en, this message translates to:
  /// **'Household'**
  String get householdLabel;

  /// No description provided for @permissionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Permissions'**
  String get permissionsTitle;

  /// No description provided for @administratorLabel.
  ///
  /// In en, this message translates to:
  /// **'Administrator'**
  String get administratorLabel;

  /// No description provided for @permCanInvite.
  ///
  /// In en, this message translates to:
  /// **'User can invite others to group'**
  String get permCanInvite;

  /// No description provided for @permCanManage.
  ///
  /// In en, this message translates to:
  /// **'User can manage group settings'**
  String get permCanManage;

  /// No description provided for @permCanManageHousehold.
  ///
  /// In en, this message translates to:
  /// **'User can manage household'**
  String get permCanManageHousehold;

  /// No description provided for @permCanOrganize.
  ///
  /// In en, this message translates to:
  /// **'User can manage foods, tags, and categories'**
  String get permCanOrganize;

  /// No description provided for @advancedFeaturesLabel.
  ///
  /// In en, this message translates to:
  /// **'Enable advanced features'**
  String get advancedFeaturesLabel;

  /// No description provided for @passwordResetLinkAction.
  ///
  /// In en, this message translates to:
  /// **'Generate Password Reset Link'**
  String get passwordResetLinkAction;

  /// No description provided for @resetLockedUsersAction.
  ///
  /// In en, this message translates to:
  /// **'Reset Locked Users'**
  String get resetLockedUsersAction;

  /// No description provided for @membersTitle.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get membersTitle;

  /// No description provided for @inviteLinkTitle.
  ///
  /// In en, this message translates to:
  /// **'Invite Link'**
  String get inviteLinkTitle;

  /// No description provided for @inviteAction.
  ///
  /// In en, this message translates to:
  /// **'Invite'**
  String get inviteAction;

  /// No description provided for @userUpdated.
  ///
  /// In en, this message translates to:
  /// **'User updated'**
  String get userUpdated;

  /// No description provided for @createUserTitle.
  ///
  /// In en, this message translates to:
  /// **'Create user'**
  String get createUserTitle;

  /// No description provided for @userCreated.
  ///
  /// In en, this message translates to:
  /// **'User created'**
  String get userCreated;

  /// No description provided for @userDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete “{name}”? The account will be removed from Mealie.'**
  String userDeleteConfirm(String name);

  /// No description provided for @passwordResetLinkCopied.
  ///
  /// In en, this message translates to:
  /// **'Link copied – pass it on to the user. It is only valid for a limited time.'**
  String get passwordResetLinkCopied;

  /// No description provided for @lockedUsersReset.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No locked users} =1{1 user unlocked} other{{count} users unlocked}}'**
  String lockedUsersReset(int count);

  /// No description provided for @inviteUsesLabel.
  ///
  /// In en, this message translates to:
  /// **'Number of uses'**
  String get inviteUsesLabel;

  /// No description provided for @inviteCreated.
  ///
  /// In en, this message translates to:
  /// **'Invite link created'**
  String get inviteCreated;

  /// No description provided for @inviteEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Email address (optional – Mealie will send the invitation)'**
  String get inviteEmailHint;

  /// No description provided for @inviteEmailSent.
  ///
  /// In en, this message translates to:
  /// **'Invitation sent by email'**
  String get inviteEmailSent;

  /// No description provided for @inviteEmailFailed.
  ///
  /// In en, this message translates to:
  /// **'The email couldn\'t be sent (is SMTP set up in Mealie?). The link still works.'**
  String get inviteEmailFailed;

  /// No description provided for @copyLinkAction.
  ///
  /// In en, this message translates to:
  /// **'Copy link'**
  String get copyLinkAction;

  /// No description provided for @youLabel.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get youLabel;

  /// No description provided for @membersPermissionsHint.
  ///
  /// In en, this message translates to:
  /// **'You can change the permissions of your household members – but not your own.'**
  String get membersPermissionsHint;

  /// No description provided for @householdManagementTitle.
  ///
  /// In en, this message translates to:
  /// **'Household Management'**
  String get householdManagementTitle;

  /// No description provided for @householdsTitle.
  ///
  /// In en, this message translates to:
  /// **'Households'**
  String get householdsTitle;

  /// No description provided for @createHouseholdTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Household'**
  String get createHouseholdTitle;

  /// No description provided for @householdNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Household Name'**
  String get householdNameLabel;

  /// No description provided for @householdPreferencesTitle.
  ///
  /// In en, this message translates to:
  /// **'Household Preferences'**
  String get householdPreferencesTitle;

  /// No description provided for @privateHouseholdLabel.
  ///
  /// In en, this message translates to:
  /// **'Private Household'**
  String get privateHouseholdLabel;

  /// No description provided for @privateHouseholdHint.
  ///
  /// In en, this message translates to:
  /// **'Setting your household to private will disable all public view options. This overrides any individual public view settings'**
  String get privateHouseholdHint;

  /// No description provided for @lockRecipeEditsLabel.
  ///
  /// In en, this message translates to:
  /// **'Lock recipe edits from other households'**
  String get lockRecipeEditsLabel;

  /// No description provided for @lockRecipeEditsHint.
  ///
  /// In en, this message translates to:
  /// **'When enabled only users in your household can edit recipes created by your household'**
  String get lockRecipeEditsHint;

  /// No description provided for @householdRecipePreferencesTitle.
  ///
  /// In en, this message translates to:
  /// **'Household Recipe Preferences'**
  String get householdRecipePreferencesTitle;

  /// No description provided for @groupsTitle.
  ///
  /// In en, this message translates to:
  /// **'Groups'**
  String get groupsTitle;

  /// No description provided for @groupLabel.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get groupLabel;

  /// No description provided for @createGroupTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Group'**
  String get createGroupTitle;

  /// No description provided for @groupNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Group Name'**
  String get groupNameLabel;

  /// No description provided for @groupPreferencesTitle.
  ///
  /// In en, this message translates to:
  /// **'Group Preferences'**
  String get groupPreferencesTitle;

  /// No description provided for @privateGroupLabel.
  ///
  /// In en, this message translates to:
  /// **'Private Group'**
  String get privateGroupLabel;

  /// No description provided for @privateGroupHint.
  ///
  /// In en, this message translates to:
  /// **'Setting your group to private will disable all public view options. This overrides any individual public view settings'**
  String get privateGroupHint;

  /// No description provided for @firstDayOfWeekLabel.
  ///
  /// In en, this message translates to:
  /// **'First day of the week'**
  String get firstDayOfWeekLabel;

  /// No description provided for @showAnnouncementsLabel.
  ///
  /// In en, this message translates to:
  /// **'Show announcements from Mealie'**
  String get showAnnouncementsLabel;

  /// No description provided for @recipePublicDefaultLabel.
  ///
  /// In en, this message translates to:
  /// **'Allow users outside of your group to see your recipes'**
  String get recipePublicDefaultLabel;

  /// No description provided for @recipeShowNutritionDefaultLabel.
  ///
  /// In en, this message translates to:
  /// **'Show nutrition information'**
  String get recipeShowNutritionDefaultLabel;

  /// No description provided for @recipeShowAssetsDefaultLabel.
  ///
  /// In en, this message translates to:
  /// **'Show recipe assets'**
  String get recipeShowAssetsDefaultLabel;

  /// No description provided for @recipeLandscapeDefaultLabel.
  ///
  /// In en, this message translates to:
  /// **'Default to landscape view'**
  String get recipeLandscapeDefaultLabel;

  /// No description provided for @recipeDisableCommentsDefaultLabel.
  ///
  /// In en, this message translates to:
  /// **'Disable users from commenting on recipes'**
  String get recipeDisableCommentsDefaultLabel;

  /// No description provided for @myHouseholdSection.
  ///
  /// In en, this message translates to:
  /// **'My household'**
  String get myHouseholdSection;

  /// No description provided for @myGroupSection.
  ///
  /// In en, this message translates to:
  /// **'My group'**
  String get myGroupSection;

  /// No description provided for @preferencesSaved.
  ///
  /// In en, this message translates to:
  /// **'Settings saved'**
  String get preferencesSaved;

  /// No description provided for @cannotDeleteWithUsers.
  ///
  /// In en, this message translates to:
  /// **'Still has users – move or delete them in User Management first.'**
  String get cannotDeleteWithUsers;

  /// No description provided for @deleteHouseholdConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete household “{name}”?'**
  String deleteHouseholdConfirm(String name);

  /// No description provided for @deleteGroupConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete group “{name}”?'**
  String deleteGroupConfirm(String name);

  /// No description provided for @usersCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No users} =1{1 user} other{{count} users}}'**
  String usersCount(int count);

  /// No description provided for @originalUrlLabel.
  ///
  /// In en, this message translates to:
  /// **'Original URL'**
  String get originalUrlLabel;

  /// No description provided for @copyTextAction.
  ///
  /// In en, this message translates to:
  /// **'Copy text'**
  String get copyTextAction;

  /// No description provided for @copiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copiedToClipboard;

  /// No description provided for @changelogEnglishHint.
  ///
  /// In en, this message translates to:
  /// **'The release notes are available in English only.'**
  String get changelogEnglishHint;

  /// No description provided for @favoritesTitle.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favoritesTitle;

  /// No description provided for @favoritesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No favorites yet. Tap the heart on a recipe to collect it here.'**
  String get favoritesEmpty;

  /// No description provided for @changelogTitle.
  ///
  /// In en, this message translates to:
  /// **'Changelog'**
  String get changelogTitle;

  /// No description provided for @changeProfileImage.
  ///
  /// In en, this message translates to:
  /// **'Change profile picture'**
  String get changeProfileImage;

  /// No description provided for @profileImageUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile picture updated'**
  String get profileImageUpdated;

  /// No description provided for @profileImageFailed.
  ///
  /// In en, this message translates to:
  /// **'Profile picture could not be uploaded'**
  String get profileImageFailed;

  /// No description provided for @myAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'My account'**
  String get myAccountTitle;

  /// No description provided for @ownAccountHint.
  ///
  /// In en, this message translates to:
  /// **'Here you can edit your own account. Other users are managed by administrators and members with the \"manage\" permission.'**
  String get ownAccountHint;

  /// No description provided for @changePasswordAction.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get changePasswordAction;

  /// No description provided for @currentPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get currentPasswordLabel;

  /// No description provided for @newPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPasswordLabel;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPasswordLabel;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters'**
  String get passwordTooShort;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @passwordUpdated.
  ///
  /// In en, this message translates to:
  /// **'Password updated'**
  String get passwordUpdated;

  /// No description provided for @passwordChangeFailed.
  ///
  /// In en, this message translates to:
  /// **'Password could not be changed'**
  String get passwordChangeFailed;

  /// No description provided for @passwordManagedExternally.
  ///
  /// In en, this message translates to:
  /// **'You sign in via {method} — change your password there.'**
  String passwordManagedExternally(String method);

  /// No description provided for @bulkAddHint.
  ///
  /// In en, this message translates to:
  /// **'One line per entry.'**
  String get bulkAddHint;

  /// No description provided for @bulkAddCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Add 1 entry} other{Add {count} entries}}'**
  String bulkAddCount(int count);

  /// No description provided for @linkRecipeAction.
  ///
  /// In en, this message translates to:
  /// **'Link recipe'**
  String get linkRecipeAction;

  /// No description provided for @useFoodAction.
  ///
  /// In en, this message translates to:
  /// **'Use food instead of recipe'**
  String get useFoodAction;

  /// No description provided for @addSubstitutionsAction.
  ///
  /// In en, this message translates to:
  /// **'Add substitutions'**
  String get addSubstitutionsAction;

  /// No description provided for @clearSubstitutionsAction.
  ///
  /// In en, this message translates to:
  /// **'Clear substitutions'**
  String get clearSubstitutionsAction;

  /// No description provided for @recipeSubstitutionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Substitutions'**
  String get recipeSubstitutionsTitle;

  /// No description provided for @substitutionUnknownFood.
  ///
  /// In en, this message translates to:
  /// **'Existing foods only – use the note otherwise'**
  String get substitutionUnknownFood;

  /// No description provided for @insertAboveAction.
  ///
  /// In en, this message translates to:
  /// **'Insert above'**
  String get insertAboveAction;

  /// No description provided for @insertBelowAction.
  ///
  /// In en, this message translates to:
  /// **'Insert below'**
  String get insertBelowAction;

  /// No description provided for @moveToTopAction.
  ///
  /// In en, this message translates to:
  /// **'Move to top'**
  String get moveToTopAction;

  /// No description provided for @moveToBottomAction.
  ///
  /// In en, this message translates to:
  /// **'Move to bottom'**
  String get moveToBottomAction;

  /// No description provided for @linkReferencesAction.
  ///
  /// In en, this message translates to:
  /// **'Link references'**
  String get linkReferencesAction;

  /// No description provided for @editMarkdownAction.
  ///
  /// In en, this message translates to:
  /// **'Edit Markdown'**
  String get editMarkdownAction;

  /// No description provided for @previewMarkdownAction.
  ///
  /// In en, this message translates to:
  /// **'Preview Markdown'**
  String get previewMarkdownAction;

  /// No description provided for @insertStepImageAction.
  ///
  /// In en, this message translates to:
  /// **'Upload image'**
  String get insertStepImageAction;

  /// No description provided for @mergeAboveAction.
  ///
  /// In en, this message translates to:
  /// **'Merge above'**
  String get mergeAboveAction;

  /// No description provided for @linkedToOtherStep.
  ///
  /// In en, this message translates to:
  /// **'Linked to other step'**
  String get linkedToOtherStep;

  /// No description provided for @noNotesToLink.
  ///
  /// In en, this message translates to:
  /// **'No notes to link'**
  String get noNotesToLink;

  /// No description provided for @ownerLabel.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get ownerLabel;

  /// No description provided for @ingredientParserTitle.
  ///
  /// In en, this message translates to:
  /// **'Ingredient Parser'**
  String get ingredientParserTitle;

  /// No description provided for @ingredientParserHint.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 ingredient isn\'t structured yet. Pick a parser, check the result, apply.} other{{count} ingredients aren\'t structured yet. Pick a parser, check the result, apply.}}'**
  String ingredientParserHint(int count);

  /// No description provided for @parserNlp.
  ///
  /// In en, this message translates to:
  /// **'Natural Language Processor'**
  String get parserNlp;

  /// No description provided for @parserBrute.
  ///
  /// In en, this message translates to:
  /// **'Brute Parser'**
  String get parserBrute;

  /// No description provided for @parserOpenai.
  ///
  /// In en, this message translates to:
  /// **'OpenAI Parser'**
  String get parserOpenai;

  /// No description provided for @parserApp.
  ///
  /// In en, this message translates to:
  /// **'Offline (app)'**
  String get parserApp;

  /// No description provided for @parseFailed.
  ///
  /// In en, this message translates to:
  /// **'Parsing failed'**
  String get parseFailed;

  /// No description provided for @parseAction.
  ///
  /// In en, this message translates to:
  /// **'Parse'**
  String get parseAction;

  /// No description provided for @applyParsedCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Nothing selected} =1{Apply 1 ingredient} other{Apply {count} ingredients}}'**
  String applyParsedCount(int count);

  /// No description provided for @parsedNewBadge.
  ///
  /// In en, this message translates to:
  /// **'new'**
  String get parsedNewBadge;

  /// No description provided for @hoursShort.
  ///
  /// In en, this message translates to:
  /// **'h'**
  String get hoursShort;

  /// No description provided for @minutesShort.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get minutesShort;

  /// No description provided for @timeExtraHint.
  ///
  /// In en, this message translates to:
  /// **'Extra, e.g. “plus overnight”'**
  String get timeExtraHint;

  /// No description provided for @yieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Yield'**
  String get yieldLabel;

  /// No description provided for @yieldTextLabel.
  ///
  /// In en, this message translates to:
  /// **'Yield Text'**
  String get yieldTextLabel;

  /// No description provided for @prepTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Prep Time'**
  String get prepTimeLabel;

  /// No description provided for @performTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Cook Time'**
  String get performTimeLabel;

  /// No description provided for @totalTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Time'**
  String get totalTimeLabel;

  /// No description provided for @settingPublicRecipe.
  ///
  /// In en, this message translates to:
  /// **'Public Recipe'**
  String get settingPublicRecipe;

  /// No description provided for @settingShowNutrition.
  ///
  /// In en, this message translates to:
  /// **'Show Nutrition Values'**
  String get settingShowNutrition;

  /// No description provided for @settingShowAssets.
  ///
  /// In en, this message translates to:
  /// **'Show Assets'**
  String get settingShowAssets;

  /// No description provided for @settingLandscapeView.
  ///
  /// In en, this message translates to:
  /// **'Landscape View'**
  String get settingLandscapeView;

  /// No description provided for @settingDisableComments.
  ///
  /// In en, this message translates to:
  /// **'Disable Comments'**
  String get settingDisableComments;

  /// No description provided for @settingDisableAmount.
  ///
  /// In en, this message translates to:
  /// **'Disable Ingredient Amounts'**
  String get settingDisableAmount;

  /// No description provided for @settingLocked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get settingLocked;

  /// No description provided for @settingLockedOwnerOnly.
  ///
  /// In en, this message translates to:
  /// **'Only the creator can lock or unlock the recipe.'**
  String get settingLockedOwnerOnly;

  /// No description provided for @apiExtrasTitle.
  ///
  /// In en, this message translates to:
  /// **'API Extras'**
  String get apiExtrasTitle;

  /// No description provided for @apiExtrasHint.
  ///
  /// In en, this message translates to:
  /// **'Custom key/value pairs for 3rd party applications, e.g. to trigger automations.'**
  String get apiExtrasHint;

  /// No description provided for @extraKeyLabel.
  ///
  /// In en, this message translates to:
  /// **'Key'**
  String get extraKeyLabel;

  /// No description provided for @extraValueLabel.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get extraValueLabel;

  /// No description provided for @addExtraAction.
  ///
  /// In en, this message translates to:
  /// **'Add extra'**
  String get addExtraAction;

  /// No description provided for @durationHours.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 hour} other{{count} hours}}'**
  String durationHours(int count);

  /// No description provided for @durationMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 minute} other{{count} minutes}}'**
  String durationMinutes(int count);

  /// No description provided for @discardChangesConfirm.
  ///
  /// In en, this message translates to:
  /// **'Discard unsaved changes?'**
  String get discardChangesConfirm;

  /// No description provided for @discardChanges.
  ///
  /// In en, this message translates to:
  /// **'Discard Changes'**
  String get discardChanges;

  /// No description provided for @imageFromUrl.
  ///
  /// In en, this message translates to:
  /// **'Image from URL'**
  String get imageFromUrl;

  /// No description provided for @deleteRecipeImage.
  ///
  /// In en, this message translates to:
  /// **'Delete Recipe Image'**
  String get deleteRecipeImage;

  /// No description provided for @deleteRecipeImageConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this recipe image?'**
  String get deleteRecipeImageConfirm;

  /// No description provided for @bulkAddIngredients.
  ///
  /// In en, this message translates to:
  /// **'Bulk add ingredients'**
  String get bulkAddIngredients;

  /// No description provided for @bulkAddSteps.
  ///
  /// In en, this message translates to:
  /// **'Bulk add steps'**
  String get bulkAddSteps;

  /// No description provided for @stepImageFailed.
  ///
  /// In en, this message translates to:
  /// **'Image could not be uploaded'**
  String get stepImageFailed;

  /// No description provided for @servingsAndTimes.
  ///
  /// In en, this message translates to:
  /// **'Servings & times'**
  String get servingsAndTimes;

  /// No description provided for @recipeSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Recipe Settings'**
  String get recipeSettingsTitle;

  /// No description provided for @jsonEditorTitle.
  ///
  /// In en, this message translates to:
  /// **'JSON Editor'**
  String get jsonEditorTitle;

  /// No description provided for @jsonInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid JSON – please check.'**
  String get jsonInvalid;

  /// No description provided for @editorOfflineHint.
  ///
  /// In en, this message translates to:
  /// **'Opened offline: saving needs a connection. Newer Mealie fields (e.g. substitutions) are kept unchanged.'**
  String get editorOfflineHint;

  /// No description provided for @parseLineFailed.
  ///
  /// In en, this message translates to:
  /// **'Not recognized – stays unchanged'**
  String get parseLineFailed;

  /// No description provided for @createManualTitle.
  ///
  /// In en, this message translates to:
  /// **'Create recipe manually'**
  String get createManualTitle;

  /// No description provided for @createManualHint.
  ///
  /// In en, this message translates to:
  /// **'Enter a name – add ingredients, steps, image and everything else afterwards in the recipe editor.'**
  String get createManualHint;

  /// No description provided for @createManualButton.
  ///
  /// In en, this message translates to:
  /// **'Create & edit'**
  String get createManualButton;

  /// No description provided for @changelogEmpty.
  ///
  /// In en, this message translates to:
  /// **'No entries for this version yet.'**
  String get changelogEmpty;

  /// No description provided for @finderDescription.
  ///
  /// In en, this message translates to:
  /// **'Search for recipes based on ingredients you have on hand. You can also filter by tools you have available, and set a maximum number of missing ingredients or tools.'**
  String get finderDescription;

  /// No description provided for @finderSelectedIngredients.
  ///
  /// In en, this message translates to:
  /// **'Selected Ingredients'**
  String get finderSelectedIngredients;

  /// No description provided for @finderNoIngredientsSelected.
  ///
  /// In en, this message translates to:
  /// **'No ingredients selected'**
  String get finderNoIngredientsSelected;

  /// No description provided for @finderMissing.
  ///
  /// In en, this message translates to:
  /// **'Missing'**
  String get finderMissing;

  /// No description provided for @finderNoRecipesFound.
  ///
  /// In en, this message translates to:
  /// **'No recipes found'**
  String get finderNoRecipesFound;

  /// No description provided for @finderNoRecipesFoundDescription.
  ///
  /// In en, this message translates to:
  /// **'Try adding more ingredients to your search or adjusting your filters'**
  String get finderNoRecipesFoundDescription;

  /// No description provided for @finderIncludeFoodsOnHand.
  ///
  /// In en, this message translates to:
  /// **'Include Ingredients On Hand'**
  String get finderIncludeFoodsOnHand;

  /// No description provided for @finderIncludeToolsOnHand.
  ///
  /// In en, this message translates to:
  /// **'Include Tools On Hand'**
  String get finderIncludeToolsOnHand;

  /// No description provided for @finderIncludeSubstitutions.
  ///
  /// In en, this message translates to:
  /// **'Include Substitutions'**
  String get finderIncludeSubstitutions;

  /// No description provided for @finderSubstituting.
  ///
  /// In en, this message translates to:
  /// **'Substituting'**
  String get finderSubstituting;

  /// No description provided for @finderSubstituteForFood.
  ///
  /// In en, this message translates to:
  /// **'{substitute} for {food}'**
  String finderSubstituteForFood(String substitute, String food);

  /// No description provided for @finderMaxMissingIngredients.
  ///
  /// In en, this message translates to:
  /// **'Max Missing Ingredients'**
  String get finderMaxMissingIngredients;

  /// No description provided for @finderMaxMissingTools.
  ///
  /// In en, this message translates to:
  /// **'Max Missing Tools'**
  String get finderMaxMissingTools;

  /// No description provided for @finderSelectedTools.
  ///
  /// In en, this message translates to:
  /// **'Selected Tools'**
  String get finderSelectedTools;

  /// No description provided for @finderReadyToMake.
  ///
  /// In en, this message translates to:
  /// **'Ready to Make'**
  String get finderReadyToMake;

  /// No description provided for @finderAlmostReadyToMake.
  ///
  /// In en, this message translates to:
  /// **'Almost Ready to Make'**
  String get finderAlmostReadyToMake;

  /// No description provided for @finderSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get finderSettings;

  /// No description provided for @finderLoadingRecipes.
  ///
  /// In en, this message translates to:
  /// **'Loading Recipes'**
  String get finderLoadingRecipes;

  /// No description provided for @finderClearSelection.
  ///
  /// In en, this message translates to:
  /// **'Clear Selection'**
  String get finderClearSelection;

  /// No description provided for @finderOfflineHint.
  ///
  /// In en, this message translates to:
  /// **'No connection to the server – results come from the recipes stored on this device.'**
  String get finderOfflineHint;

  /// No description provided for @addIngredientsSkippedOnHand.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Added to your shopping list – 1 ingredient on hand was skipped.} other{Added to your shopping list – {count} ingredients on hand were skipped.}}'**
  String addIngredientsSkippedOnHand(int count);

  /// No description provided for @sendPeerOfflineHint.
  ///
  /// In en, this message translates to:
  /// **'Not reachable right now – arrives when the app is opened there'**
  String get sendPeerOfflineHint;

  /// No description provided for @sendDeliveredLater.
  ///
  /// In en, this message translates to:
  /// **'“{device}” is not reachable right now. The recipe will arrive as soon as the app is opened there.'**
  String sendDeliveredLater(String device);

  /// No description provided for @sendQueuedOffline.
  ///
  /// In en, this message translates to:
  /// **'No connection right now. The recipe will be sent automatically as soon as you\'re back online.'**
  String get sendQueuedOffline;

  /// No description provided for @searchHasAll.
  ///
  /// In en, this message translates to:
  /// **'Has All'**
  String get searchHasAll;

  /// No description provided for @searchHasAny.
  ///
  /// In en, this message translates to:
  /// **'Has Any'**
  String get searchHasAny;

  /// No description provided for @recipeFilterTitle.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get recipeFilterTitle;

  /// No description provided for @finderOtherFilters.
  ///
  /// In en, this message translates to:
  /// **'Other Filters'**
  String get finderOtherFilters;

  /// No description provided for @qfOpEquals.
  ///
  /// In en, this message translates to:
  /// **'equals'**
  String get qfOpEquals;

  /// No description provided for @qfOpNotEquals.
  ///
  /// In en, this message translates to:
  /// **'does not equal'**
  String get qfOpNotEquals;

  /// No description provided for @qfOpGreater.
  ///
  /// In en, this message translates to:
  /// **'is greater than'**
  String get qfOpGreater;

  /// No description provided for @qfOpGreaterEq.
  ///
  /// In en, this message translates to:
  /// **'is greater than or equal to'**
  String get qfOpGreaterEq;

  /// No description provided for @qfOpLess.
  ///
  /// In en, this message translates to:
  /// **'is less than'**
  String get qfOpLess;

  /// No description provided for @qfOpLessEq.
  ///
  /// In en, this message translates to:
  /// **'is less than or equal to'**
  String get qfOpLessEq;

  /// No description provided for @qfOpNewerThan.
  ///
  /// In en, this message translates to:
  /// **'is newer than'**
  String get qfOpNewerThan;

  /// No description provided for @qfOpOlderThan.
  ///
  /// In en, this message translates to:
  /// **'is older than'**
  String get qfOpOlderThan;

  /// No description provided for @qfDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day ago} other{{count} days ago}}'**
  String qfDaysAgo(int count);

  /// No description provided for @filterResetAll.
  ///
  /// In en, this message translates to:
  /// **'Reset all filters'**
  String get filterResetAll;

  /// No description provided for @filterAny.
  ///
  /// In en, this message translates to:
  /// **'Any'**
  String get filterAny;

  /// No description provided for @filterOfflineIgnored.
  ///
  /// In en, this message translates to:
  /// **'Offline, the “Other Filters” can only be applied in their simple form.'**
  String get filterOfflineIgnored;

  /// No description provided for @linkedRecipesCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No Linked Recipes} =1{One Linked Recipe} other{{count} Linked Recipes}}'**
  String linkedRecipesCount(int count);

  /// No description provided for @shoppingReminderNotificationsOff.
  ///
  /// In en, this message translates to:
  /// **'Notifications are turned off for Mealie Recipes — without them the shopping reminder can\'t appear. Please allow notifications in the settings.'**
  String get shoppingReminderNotificationsOff;

  /// No description provided for @shoppingReminderInactiveHint.
  ///
  /// In en, this message translates to:
  /// **'The shopping reminder can\'t work right now: please set location access to “Always” and allow notifications.'**
  String get shoppingReminderInactiveHint;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Bulk URL Import'**
  String get bulkImportTitle;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'The Bulk recipe importer allows you to import multiple recipes at once by queueing the sites on the backend and running the task in the background. This can be useful when initially migrating to Mealie, or when you want to import a large number of recipes.'**
  String get bulkImportDescription;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Bulk Add'**
  String get bulkAddTitle;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Set Categories and Tags'**
  String get bulkImportSetOrganizers;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Bulk Import process has started'**
  String get bulkImportStarted;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Bulk import process has failed'**
  String get bulkImportFailed;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Bulk Imports'**
  String get bulkImportReports;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Recipe URL'**
  String get bulkImportUrlHint;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Data Migrations'**
  String get migrationsTitle;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Recipes can be migrated from another supported application to Mealie. This is a great way to get started with Mealie. Moving data between Mealie instances, or restoring an earlier Mealie backup, is done with the backup and restore tools instead.'**
  String get migrationsDescription;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'New Migration'**
  String get migrationNew;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Choose Migration Type'**
  String get migrationChooseType;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'No File Selected'**
  String get noFileSelected;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Tag all recipes with {tag} tag'**
  String migrationTagAll(String tag);

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Previous Migrations'**
  String get migrationPrevious;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Mealie can import recipes from the Mealie application from a pre v1.0 release. Export your recipes from your old instance, and upload the zip file below. Note that only recipes can be imported from the export. This applies only to instances older than v1.0. A backup taken from v1.0 or later should be restored with the backup and restore tools.'**
  String get migrationMealieDescription;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Mealie natively supports the chowdown repository format. Download the code repository as a .zip file and upload it below.'**
  String get migrationChowdownDescription;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Mealie can import recipes from Copy Me That. Export your recipes in HTML format, then upload the .zip below.'**
  String get migrationCopyMeThatDescription;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Mealie can import recipes from My Recipe Box. Export your recipes in CSV format, then upload the .csv file below.'**
  String get migrationMyRecipeBoxDescription;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Nextcloud recipes can be imported from a zip file that contains the data stored in Nextcloud. See the example folder structure below to ensure your recipes are able to be imported.'**
  String get migrationNextcloudDescription;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Mealie can import recipes from the Paprika application. Export your recipes from paprika, rename the export extension to .zip and upload it below.'**
  String get migrationPaprikaDescription;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Mealie can import recipes from Plan to Eat. Upload a ZIP archive, CSV, or TXT file exported from Plan to Eat.'**
  String get migrationPlanToEatDescription;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Mealie can import recipes from Recipe Keeper. Export your recipes in zip format, then upload the .zip file below.'**
  String get migrationRecipeKeeperDescription;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Mealie can import recipes from Tandoor. Export your data in the \"Default\" format, then upload the .zip below.'**
  String get migrationTandoorDescription;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Mealie can import recipes from DVO Cook\'n X3. Export a cookbook or menu in the \"Cook\'n\" format, rename the export extension to .zip, then upload the .zip below.'**
  String get migrationCooknDescription;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get reportTitle;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Recipe Data'**
  String get recipeDataTitle;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Use this section to manage the data associated with your recipes. You can perform several bulk actions on your recipes including exporting, deleting, tagging, and assigning categories.'**
  String get recipeDataDescription;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Tag Recipes'**
  String get recipeDataTagTitle;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Categorize Recipes'**
  String get recipeDataCategorizeTitle;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Update Settings'**
  String get recipeDataSettingsTitle;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Export Recipes'**
  String get recipeDataExportTitle;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Delete Recipes'**
  String get recipeDataDeleteTitle;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'The following recipes ({count}) will be exported.'**
  String recipeDataExportConfirm(int count);

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Data Exports'**
  String get recipeDataExportsTitle;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'This section provides links to available exports that are ready to download. These exports do expire, so be sure to grab them while they\'re still available.'**
  String get recipeDataExportsDescription;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Purge Exports'**
  String get recipeDataPurgeExports;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete all export data?'**
  String get recipeDataPurgeConfirm;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Recipe Actions'**
  String get recipeActionsTitle;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'New Recipe Action'**
  String get recipeActionNew;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Edit Recipe Action'**
  String get recipeActionEdit;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get recipeActionTypeLink;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get recipeActionTypePost;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Webhooks'**
  String get webhooksTitle;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'The webhooks defined below will be executed when a meal is defined for the day. At the scheduled time the webhooks will be sent with the data from the recipe that is scheduled for the day. Note that webhook execution is not exact. The webhooks are executed on a 5 minutes interval so the webhooks will be executed within 5 +/- minutes of the scheduled.'**
  String get webhooksDescription;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Webhook Name'**
  String get webhookName;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Webhook URL'**
  String get webhookUrl;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Notifiers'**
  String get notifiersTitle;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Set up email and push notifications that trigger on specific events.'**
  String get notifiersDescription;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'New Notification'**
  String get notifierNew;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Mealie uses the Apprise library to generate notifications. They offer many options for services to use for notifications. Refer to their wiki for a comprehensive guide on how to create the URL for your service. If available, selecting the type of your notification may include extra features.'**
  String get notifierDescription;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Apprise URL'**
  String get notifierAppriseUrl;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Apprise URL (skipped if blank)'**
  String get notifierAppriseUrlSkipped;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Since Apprise URLs typically contain sensitive information, this field is left intentionally blank while editing. If you wish to update the URL, please enter the new one here, otherwise leave it blank to keep the current URL.'**
  String get notifierAppriseUrlBlankHint;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Enable Notifier'**
  String get notifierEnable;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'What events should this notifier subscribe to?'**
  String get notifierWhatEvents;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Recipe Events'**
  String get notifierRecipeEvents;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'User Events'**
  String get notifierUserEvents;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Meal Plan Events'**
  String get notifierMealplanEvents;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Shopping List Events'**
  String get notifierShoppingListEvents;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Cookbook Events'**
  String get notifierCookbookEvents;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Tag Events'**
  String get notifierTagEvents;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Category Events'**
  String get notifierCategoryEvents;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Label Events'**
  String get notifierLabelEvents;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'When a new user joins your group'**
  String get notifierUserSignup;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get notifierCreate;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get notifierUpdate;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get notifierDelete;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Test Message Sent'**
  String get notifierTestSent;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Admin Settings'**
  String get adminTitle;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Backups'**
  String get backupsTitle;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Backups are total snapshots of the database and data directory of the site. This includes all data and cannot be set to exclude subsets of data. You can think of this as a snapshot of Mealie at a specific time. These serve as a database agnostic way to export and import data, or back up the site to an external location.'**
  String get backupsDescription;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Create A Backup'**
  String get backupCreateHeading;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Backup created successfully'**
  String get backupCreated;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Error Creating Backup. See Log File'**
  String get backupCreateFailed;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Delete Backup'**
  String get backupDelete;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Backup deleted'**
  String get backupDeleted;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Restore Backup'**
  String get backupRestore;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Restoring this backup will overwrite all the current data in your database and in the data directory and replace them with the contents of this backup. If the restoration is successful, you will be logged out.'**
  String get backupRestoreDescription;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone - use with caution.'**
  String get backupCannotBeUndone;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'I understand that this action is irreversible, destructive and may cause data loss'**
  String get backupAcknowledge;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Restore successful'**
  String get backupRestoreSuccess;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Restore failed. Check your server logs for more details'**
  String get backupRestoreFailed;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get maintenanceTitle;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get maintenanceSummary;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Storage Details'**
  String get maintenanceStorage;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Data Directory Size'**
  String get maintenanceDataDirSize;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Cleanable Directories'**
  String get maintenanceCleanableDirs;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Cleanable Images'**
  String get maintenanceCleanableImages;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Temporary Directory (.temp)'**
  String get maintenanceTempDir;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Backups Directory (backups)'**
  String get maintenanceBackupsDir;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Groups Directory (groups)'**
  String get maintenanceGroupsDir;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Recipes Directory (recipes)'**
  String get maintenanceRecipesDir;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'User Directory (user)'**
  String get maintenanceUserDir;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Clean Directories'**
  String get maintenanceCleanDirs;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Removes all the recipe folders that are not valid UUIDs'**
  String get maintenanceCleanDirsDescription;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Clean Temporary Files'**
  String get maintenanceCleanTemp;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Removes all files and folders in the .temp directory'**
  String get maintenanceCleanTempDescription;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Clean Images'**
  String get maintenanceCleanImages;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Removes all the images that don\'t end with .webp'**
  String get maintenanceCleanImagesDescription;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get maintenanceActions;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Configuration'**
  String get adminConfiguration;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Application Version'**
  String get adminAppVersion;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Mealie is up to date'**
  String get adminUpToDate;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Your current version ({current}) does not match the latest release. Considering updating to the latest version ({latest}).'**
  String adminVersionOutdated(String current, String latest);

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Server Side Base URL'**
  String get adminBaseUrl;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Server Side URL does not match the default'**
  String get adminBaseUrlOk;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'`BASE_URL` is still the default value on API Server. This will cause issues with notifications links generated on the server for emails, etc.'**
  String get adminBaseUrlError;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'{provider} Ready'**
  String adminAuthReady(String provider);

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'{provider} Not Ready'**
  String adminAuthNotReady(String provider);

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'{provider} Disabled'**
  String adminAuthDisabled(String provider);

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Required {provider} variables are all set.'**
  String adminAuthSuccessText(String provider);

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Not all {provider} values are configured. This can be ignored if you are not using {provider} Authentication.'**
  String adminAuthErrorText(String provider);

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'To enable set {envVar} to true.'**
  String adminAuthDisabledText(String envVar);

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Email Configuration Status'**
  String get adminEmailStatus;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Email Configured'**
  String get adminEmailConfigured;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Not Ready - Check Environmental Variables'**
  String get adminNotReady;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Succeeded'**
  String get adminSucceeded;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get adminFailed;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Site Statistics'**
  String get adminSiteStatistics;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Uncategorized Recipes'**
  String get adminUncategorized;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Untagged Recipes'**
  String get adminUntagged;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'General About'**
  String get adminGeneralAbout;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get adminVersion;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Build'**
  String get adminBuild;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Application Mode'**
  String get adminApplicationMode;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Production'**
  String get adminProduction;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Development'**
  String get adminDevelopment;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Demo Status'**
  String get adminDemoStatus;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Demo'**
  String get adminDemo;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Not Demo'**
  String get adminNotDemo;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'API Port'**
  String get adminApiPort;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'API Docs'**
  String get adminApiDocs;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Database Type'**
  String get adminDatabaseType;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Database URL'**
  String get adminDatabaseUrl;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Default Group'**
  String get adminDefaultGroup;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Default Household'**
  String get adminDefaultHousehold;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Recipe Scraper Version'**
  String get adminScraperVersion;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get adminStatUsers;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Households'**
  String get adminStatHouseholds;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Groups'**
  String get adminStatGroups;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Duplicate recipe'**
  String get recipeDuplicate;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Duplicate'**
  String get recipeDuplicateAction;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Share Recipe'**
  String get recipeShareLink;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Expiration Date'**
  String get recipeShareExpiration;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Recipe link copied to clipboard'**
  String get recipeShareCopied;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get enabledLabel;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get disabledLabel;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Test'**
  String get testAction;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yesLabel;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get noLabel;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get downloadAction;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get backupUpload;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Import from Zip'**
  String get zipImportButton;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Import a single recipe that was exported from another Mealie instance.'**
  String get zipImportDescription;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get reportStatus;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get reportDate;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get recipeActionTitleLabel;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clearAll;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Settings chosen here, excluding the locked option, will be applied to all selected recipes.'**
  String get recipeDataSettingsExplanation;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Allow sign-up'**
  String get adminAllowSignup;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Allow password login'**
  String get adminAllowPasswordLogin;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address.'**
  String get adminEmailInvalid;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Email test: {result}'**
  String adminEmailTestResult(String result);

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Send test email'**
  String get adminSendTestEmail;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Recipient'**
  String get adminTestEmailAddress;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Create backup'**
  String get backupCreate;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Delete the backup \"{name}\"?'**
  String backupDeleteConfirm(String name);

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'If you use PostgreSQL, please read the backup/restore process in the Mealie documentation before restoring.'**
  String get backupPostgresNote;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Backup uploaded'**
  String get backupUploaded;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'No backups yet.'**
  String get backupsEmpty;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Add URL'**
  String get bulkImportAddRow;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Start import'**
  String get bulkImportStart;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Choose file'**
  String get chooseFileButton;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Deselect all'**
  String get deselectAllAction;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Download failed'**
  String get downloadFailed;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'File saved'**
  String get fileSaved;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Could not load'**
  String get loadFailed;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Maintenance actions are destructive and should be used with caution. Performing any of these actions is irreversible.'**
  String get maintenanceActionsWarning;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'This action is destructive and cannot be undone. Continue?'**
  String get maintenanceConfirm;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get maintenanceDone;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Maintenance action failed'**
  String get maintenanceFailed;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Run'**
  String get maintenanceRun;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Migration failed'**
  String get migrationFailed;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Start migration'**
  String get migrationStart;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Migration finished — see the report below.'**
  String get migrationStarted;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'More import options'**
  String get moreImportOptions;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Delete the notifier \"{name}\"?'**
  String notifierDeleteConfirm(String name);

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Edit notifier'**
  String get notifierEdit;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Events: {count}'**
  String notifierEventCount(int count);

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Test message could not be sent'**
  String get notifierTestFailed;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'No notifiers yet.'**
  String get notifiersEmpty;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Delete the recipe action \"{name}\"?'**
  String recipeActionDeleteConfirm(String name);

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Recipe action failed'**
  String get recipeActionFailed;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Recipe sent'**
  String get recipeActionSent;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Placeholders'**
  String get recipeActionUrlHint;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Recipe actions appear in the menu of every recipe. \"Link\" opens the URL, \"Post\" lets the Mealie server send the recipe to the URL.'**
  String get recipeActionsDescription;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'No recipe actions yet.'**
  String get recipeActionsEmpty;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Delete the selected recipes ({count})? This action cannot be undone.'**
  String recipeDataDeleteConfirm(int count);

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'You may not delete {count} of the selected recipes (only their creator or an admin can).'**
  String recipeDataDeleteForbidden(int count);

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Recipes deleted: {count}'**
  String recipeDataDeleted(int count);

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get recipeDataExportAction;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Export created — download it under Data Exports.'**
  String get recipeDataExportDone;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'expires {date}'**
  String recipeDataExportExpires(String date);

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Export failed'**
  String get recipeDataExportFailed;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'No exports available.'**
  String get recipeDataExportsEmpty;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Recipes updated: {count}'**
  String recipeDataUpdated(int count);

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Recipe duplicated'**
  String get recipeDuplicated;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Export as JSON'**
  String get recipeExportJson;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Export as ZIP (with image)'**
  String get recipeExportZip;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Create link'**
  String get recipeShareCreate;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Anyone with the link can view this recipe in the browser — without an account — until it expires.'**
  String get recipeShareDescription;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'No share links yet.'**
  String get recipeShareEmpty;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Expires {date}'**
  String recipeShareExpiresAt(String date);

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Duplicate, share link & more'**
  String get recipeWebToolsMenu;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Reload'**
  String get reload;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Delete this report?'**
  String get reportDeleteConfirm;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Entries'**
  String get reportEntries;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get reportFailedEntries;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Show only failed entries'**
  String get reportOnlyFailed;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Failure'**
  String get reportStatusFailure;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get reportStatusInProgress;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Partial'**
  String get reportStatusPartial;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get reportStatusSuccess;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'No reports yet.'**
  String get reportsEmpty;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Upload failed'**
  String get uploadFailed;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Delete the webhook \"{name}\"?'**
  String webhookDeleteConfirm(String name);

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Edit webhook'**
  String get webhookEdit;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'New webhook'**
  String get webhookNew;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Test could not be started'**
  String get webhookTestFailed;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Test webhook triggered'**
  String get webhookTestSent;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Time (local)'**
  String get webhookTime;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'No webhooks yet.'**
  String get webhooksEmpty;

  /// Webapp-Werkzeuge (Desktop)
  ///
  /// In en, this message translates to:
  /// **'ZIP import failed'**
  String get zipImportFailed;

  /// Webapp-Werkzeuge (Desktop): KI-Anbieter / Debug
  ///
  /// In en, this message translates to:
  /// **'AI Providers'**
  String get aiProvidersTitle;

  /// Webapp-Werkzeuge (Desktop): KI-Anbieter / Debug
  ///
  /// In en, this message translates to:
  /// **'Configure AI providers to enable AI-powered features, such as enhanced ingredient parsing, creating recipes from videos, and more!'**
  String get aiProvidersDescription;

  /// Webapp-Werkzeuge (Desktop): KI-Anbieter / Debug
  ///
  /// In en, this message translates to:
  /// **'AI Provider Settings'**
  String get aiProviderSettingsTitle;

  /// Webapp-Werkzeuge (Desktop): KI-Anbieter / Debug
  ///
  /// In en, this message translates to:
  /// **'Providers'**
  String get aiProvidersList;

  /// Webapp-Werkzeuge (Desktop): KI-Anbieter / Debug
  ///
  /// In en, this message translates to:
  /// **'Create Provider'**
  String get aiProviderCreate;

  /// Webapp-Werkzeuge (Desktop): KI-Anbieter / Debug
  ///
  /// In en, this message translates to:
  /// **'Edit Provider'**
  String get aiProviderEdit;

  /// Webapp-Werkzeuge (Desktop): KI-Anbieter / Debug
  ///
  /// In en, this message translates to:
  /// **'Default Provider'**
  String get aiDefaultProvider;

  /// Webapp-Werkzeuge (Desktop): KI-Anbieter / Debug
  ///
  /// In en, this message translates to:
  /// **'Required to enable AI features'**
  String get aiDefaultProviderDescription;

  /// Webapp-Werkzeuge (Desktop): KI-Anbieter / Debug
  ///
  /// In en, this message translates to:
  /// **'Audio Provider'**
  String get aiAudioProvider;

  /// Webapp-Werkzeuge (Desktop): KI-Anbieter / Debug
  ///
  /// In en, this message translates to:
  /// **'Enables audio transcription features, such as creating recipes from videos'**
  String get aiAudioProviderDescription;

  /// Webapp-Werkzeuge (Desktop): KI-Anbieter / Debug
  ///
  /// In en, this message translates to:
  /// **'Image Provider'**
  String get aiImageProvider;

  /// Webapp-Werkzeuge (Desktop): KI-Anbieter / Debug
  ///
  /// In en, this message translates to:
  /// **'Enables image recognition features, such as creating recipes from images'**
  String get aiImageProviderDescription;

  /// Webapp-Werkzeuge (Desktop): KI-Anbieter / Debug
  ///
  /// In en, this message translates to:
  /// **'Provider Name'**
  String get aiProviderName;

  /// Webapp-Werkzeuge (Desktop): KI-Anbieter / Debug
  ///
  /// In en, this message translates to:
  /// **'API Key'**
  String get aiApiKey;

  /// Webapp-Werkzeuge (Desktop): KI-Anbieter / Debug
  ///
  /// In en, this message translates to:
  /// **'Your provider\'s API key for authentication. If your service (e.g. Ollama) doesn\'t use an API key, you still have to put something here.'**
  String get aiApiKeyCreateDescription;

  /// Webapp-Werkzeuge (Desktop): KI-Anbieter / Debug
  ///
  /// In en, this message translates to:
  /// **'Leave this blank unless you want to change it.'**
  String get aiApiKeyEditDescription;

  /// Webapp-Werkzeuge (Desktop): KI-Anbieter / Debug
  ///
  /// In en, this message translates to:
  /// **'Base URL'**
  String get aiBaseUrl;

  /// Webapp-Werkzeuge (Desktop): KI-Anbieter / Debug
  ///
  /// In en, this message translates to:
  /// **'If you\'re using OpenAI leave this blank. Must be an OpenAI-compatible endpoint (e.g. \"http://localhost:11434/v1\").'**
  String get aiBaseUrlDescription;

  /// Webapp-Werkzeuge (Desktop): KI-Anbieter / Debug
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get aiModel;

  /// Webapp-Werkzeuge (Desktop): KI-Anbieter / Debug
  ///
  /// In en, this message translates to:
  /// **'Which model your AI provider should use (e.g. \"gpt-5\").'**
  String get aiModelDescription;

  /// Webapp-Werkzeuge (Desktop): KI-Anbieter / Debug
  ///
  /// In en, this message translates to:
  /// **'Request Timeout (seconds)'**
  String get aiTimeout;

  /// Webapp-Werkzeuge (Desktop): KI-Anbieter / Debug
  ///
  /// In en, this message translates to:
  /// **'Provider created'**
  String get aiProviderCreated;

  /// Webapp-Werkzeuge (Desktop): KI-Anbieter / Debug
  ///
  /// In en, this message translates to:
  /// **'Provider updated'**
  String get aiProviderUpdated;

  /// Webapp-Werkzeuge (Desktop): KI-Anbieter / Debug
  ///
  /// In en, this message translates to:
  /// **'Provider deleted'**
  String get aiProviderDeleted;

  /// Webapp-Werkzeuge (Desktop): KI-Anbieter / Debug
  ///
  /// In en, this message translates to:
  /// **'Failed to create provider'**
  String get aiProviderCreateFailed;

  /// Webapp-Werkzeuge (Desktop): KI-Anbieter / Debug
  ///
  /// In en, this message translates to:
  /// **'Failed to update provider'**
  String get aiProviderUpdateFailed;

  /// Webapp-Werkzeuge (Desktop): KI-Anbieter / Debug
  ///
  /// In en, this message translates to:
  /// **'Failed to delete provider'**
  String get aiProviderDeleteFailed;

  /// Webapp-Werkzeuge (Desktop): KI-Anbieter / Debug
  ///
  /// In en, this message translates to:
  /// **'Request Headers'**
  String get aiRequestHeaders;

  /// Webapp-Werkzeuge (Desktop): KI-Anbieter / Debug
  ///
  /// In en, this message translates to:
  /// **'Request Parameters'**
  String get aiRequestParams;

  /// Webapp-Werkzeuge (Desktop): KI-Anbieter / Debug
  ///
  /// In en, this message translates to:
  /// **'You have not set a default provider, so AI features are disabled'**
  String get aiNoDefaultWarning;

  /// Webapp-Werkzeuge (Desktop): KI-Anbieter / Debug
  ///
  /// In en, this message translates to:
  /// **'Test Connection'**
  String get aiTestConnection;

  /// Webapp-Werkzeuge (Desktop): KI-Anbieter / Debug
  ///
  /// In en, this message translates to:
  /// **'Connection successful'**
  String get aiTestSucceeded;

  /// Webapp-Werkzeuge (Desktop): KI-Anbieter / Debug
  ///
  /// In en, this message translates to:
  /// **'Connection failed'**
  String get aiTestFailed;

  /// Webapp-Werkzeuge (Desktop): KI-Anbieter / Debug
  ///
  /// In en, this message translates to:
  /// **'Supports images'**
  String get aiSupportsImages;

  /// Webapp-Werkzeuge (Desktop): KI-Anbieter / Debug
  ///
  /// In en, this message translates to:
  /// **'Text-only, can\'t be your image provider'**
  String get aiTextOnly;

  /// Webapp-Werkzeuge (Desktop): KI-Anbieter / Debug
  ///
  /// In en, this message translates to:
  /// **'Debug AI Providers'**
  String get debugAiTitle;

  /// Webapp-Werkzeuge (Desktop): KI-Anbieter / Debug
  ///
  /// In en, this message translates to:
  /// **'Use this page to debug AI providers. You can test your AI connection and see the results here. If you have image services enabled, you can also provide an image.'**
  String get debugAiDescription;

  /// Webapp-Werkzeuge (Desktop): KI-Anbieter / Debug
  ///
  /// In en, this message translates to:
  /// **'Parser'**
  String get debugParserTitle;

  /// Webapp-Werkzeuge (Desktop): KI-Anbieter / Debug
  ///
  /// In en, this message translates to:
  /// **'Mealie uses Conditional Random Fields (CRFs) for parsing and processing ingredients. The model used for ingredients is based off a data set of over 100,000 ingredients from a dataset compiled by the New York Times. Note that as the model is trained in English only, you may have varied results when using the model in other languages. This page is a playground for testing the model.'**
  String get debugParserDescription;

  /// Webapp-Werkzeuge (Desktop): KI-Anbieter / Debug
  ///
  /// In en, this message translates to:
  /// **'Ingredient Text'**
  String get debugIngredientText;

  /// Webapp-Werkzeuge (Desktop): KI-Anbieter / Debug
  ///
  /// In en, this message translates to:
  /// **'Try an example'**
  String get debugTryExample;

  /// Webapp-Werkzeuge (Desktop): KI-Anbieter / Debug
  ///
  /// In en, this message translates to:
  /// **'{value} Confident'**
  String debugAverageConfidence(String value);

  /// Webapp-Werkzeuge (Desktop): KI-Anbieter / Debug
  ///
  /// In en, this message translates to:
  /// **'Run Test'**
  String get debugRunTest;

  /// Webapp-Werkzeuge (Desktop): KI-Anbieter / Debug
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get debugQuantity;

  /// Webapp-Werkzeuge (Desktop): KI-Anbieter / Debug
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get debugUnit;

  /// Webapp-Werkzeuge (Desktop): KI-Anbieter / Debug
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get debugFood;

  /// Webapp-Werkzeuge (Desktop): KI-Anbieter / Debug
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get debugNote;

  /// Webapp-Werkzeuge (Desktop): KI-Anbieter / Debug
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get debugGroup;

  /// Webapp-Werkzeuge (Desktop): KI-Anbieter / Debug
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get aiProviderNone;

  /// Webapp-Werkzeuge (Desktop): KI-Anbieter / Debug
  ///
  /// In en, this message translates to:
  /// **'Delete the provider \"{name}\"?'**
  String aiProviderDeleteConfirm(String name);

  /// Webapp-Werkzeuge (Desktop): KI-Anbieter / Debug
  ///
  /// In en, this message translates to:
  /// **'No AI providers yet.'**
  String get aiProvidersEmpty;

  /// Webapp-Werkzeuge (Desktop): KI-Anbieter / Debug
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get aiAdvanced;

  /// Webapp-Werkzeuge (Desktop): KI-Anbieter / Debug
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get aiKeyLabel;

  /// Webapp-Werkzeuge (Desktop): KI-Anbieter / Debug
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get aiValueLabel;

  /// Webapp-Werkzeuge (Desktop): KI-Anbieter / Debug
  ///
  /// In en, this message translates to:
  /// **'Debug'**
  String get debugTitle;

  /// Webapp-Werkzeuge (Desktop): KI-Anbieter / Debug
  ///
  /// In en, this message translates to:
  /// **'Parse'**
  String get debugParse;

  /// Webapp-Werkzeuge (Desktop): KI-Anbieter / Debug
  ///
  /// In en, this message translates to:
  /// **'Ingredient could not be parsed'**
  String get debugParseFailed;

  /// Webapp-Werkzeuge (Desktop): KI-Anbieter / Debug
  ///
  /// In en, this message translates to:
  /// **'Choose image'**
  String get debugChooseImage;

  /// Webapp-Werkzeuge (Desktop): KI-Anbieter / Debug
  ///
  /// In en, this message translates to:
  /// **'No image (optional)'**
  String get debugNoImage;

  /// Update-Prüfer (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Check for updates'**
  String get updateTitle;

  /// Update-Prüfer (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Installed version'**
  String get updateInstalledVersion;

  /// Update-Prüfer (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Last checked'**
  String get updateLastCheck;

  /// Update-Prüfer (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Check now'**
  String get updateCheckNow;

  /// Update-Prüfer (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Checking for updates…'**
  String get updateChecking;

  /// Update-Prüfer (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Mealie Recipes is up to date.'**
  String get updateUpToDate;

  /// Update-Prüfer (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Version {version} is available'**
  String updateAvailable(String version);

  /// Update-Prüfer (Desktop)
  ///
  /// In en, this message translates to:
  /// **'A new version of Mealie Recipes is available. Nothing is installed until you start the update yourself.'**
  String get updateAvailableDescription;

  /// Update-Prüfer (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Show update'**
  String get updateShow;

  /// Update-Prüfer (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get updateLater;

  /// Update-Prüfer (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Downloading … {percent} %'**
  String updateDownloading(int percent);

  /// Update-Prüfer (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Version {version} is ready to install'**
  String updateReady(String version);

  /// Update-Prüfer (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Installing — the app restarts automatically …'**
  String get updateInstalling;

  /// Update-Prüfer (Desktop)
  ///
  /// In en, this message translates to:
  /// **'The update could not be installed automatically. The disk image has been opened: drag Mealie Recipes into Applications.'**
  String get updateManual;

  /// Update-Prüfer (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Update failed'**
  String get updateFailed;

  /// Update-Prüfer (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Download & install'**
  String get updateInstallNow;

  /// Update-Prüfer (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Install & restart'**
  String get updateRestartNow;

  /// Update-Prüfer (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Check for updates on start'**
  String get updateAutoTitle;

  /// Update-Prüfer (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Only checks and notifies you — you always start the installation yourself.'**
  String get updateAutoDescription;

  /// Update-Prüfer (Desktop)
  ///
  /// In en, this message translates to:
  /// **'No release notes.'**
  String get updateNoNotes;

  /// Update-Prüfer (Desktop)
  ///
  /// In en, this message translates to:
  /// **'Updates come from the GitHub releases of Mealie Recipes and are only installed if they are signed by the developer (macOS).'**
  String get updateSourceHint;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'de',
        'en',
        'es',
        'fr',
        'hu',
        'nb',
        'nl',
        'pl',
        'pt',
        'sl'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hu':
      return AppLocalizationsHu();
    case 'nb':
      return AppLocalizationsNb();
    case 'nl':
      return AppLocalizationsNl();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'sl':
      return AppLocalizationsSl();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
