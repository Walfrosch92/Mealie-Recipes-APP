// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Mealie Recipes';

  @override
  String get endCookingMode => 'Kochmodus beenden';

  @override
  String get endCookingModeConfirm =>
      'Möchtest du den Kochmodus wirklich beenden?';

  @override
  String endCookingModeConfirmAll(int count) {
    return 'Dadurch werden alle $count Rezepte im Kochmodus beendet. Wirklich fortfahren?';
  }

  @override
  String get addTimer => 'Timer hinzufügen';

  @override
  String get recipeFinished => 'Dein Gericht ist fertig.';

  @override
  String get bonAppetit => 'Guten Appetit!';

  @override
  String get prepareIngredients => 'Bitte folgende Zutaten vorbereiten';

  @override
  String prepareIngredientsFor(String servings) {
    return 'Bitte folgende Zutaten für $servings Portionen vorbereiten';
  }

  @override
  String get next => 'Weiter';

  @override
  String get navHome => 'Start';

  @override
  String get homeCookToday => 'Heute kochen';

  @override
  String get homeSuggestion => 'Vorschlag';

  @override
  String get homeQuickAccess => 'Schnellzugriff';

  @override
  String get homePlanned => 'Geplant';

  @override
  String get favorite => 'Favorit';

  @override
  String get navSettings => 'Einstellungen';

  @override
  String homeWelcomeName(Object name) {
    return 'Willkommen $name,';
  }

  @override
  String get homeWelcomeApp => 'bei Mealie Recipes 👋';

  @override
  String get theme => 'Erscheinungsbild';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Hell';

  @override
  String get themeDark => 'Dunkel';

  @override
  String get recipes => 'Rezepte';

  @override
  String get shoppingList => '🛒 Einkaufsliste';

  @override
  String get mealplan => 'Mahlzeitenplan';

  @override
  String get settings => '⚙️ Einstellungen';

  @override
  String get searchRecipe => 'Rezept suchen...';

  @override
  String get loadingRecipes => 'Rezepte werden geladen...';

  @override
  String get loadingRecipe => 'Rezept wird geladen...';

  @override
  String errorLoadingRecipes(String error) {
    return 'Fehler beim Laden: $error';
  }

  @override
  String get errorLoadingRecipe => 'Rezept konnte nicht geladen werden.';

  @override
  String get noRecipesForCategory => 'Keine Rezepte für diesen Filter.';

  @override
  String get resetFilter => 'Filter zurücksetzen';

  @override
  String get allCategories => 'Alle Kategorien';

  @override
  String get all => 'Alle';

  @override
  String get sortRecipes => 'Rezepte sortieren';

  @override
  String get refreshRecipes => 'Aktualisieren';

  @override
  String get sortNameAZ => 'Name A–Z';

  @override
  String get sortNameZA => 'Name Z–A';

  @override
  String get sortDateNewest => 'Neueste zuerst';

  @override
  String get sortDateOldest => 'Älteste zuerst';

  @override
  String get sortPrepTimeShort => 'Kürzeste Zubereitungszeit';

  @override
  String get sortPrepTimeLong => 'Längste Zubereitungszeit';

  @override
  String get sortRatingHighest => 'Höchste Bewertung';

  @override
  String get sortRatingLowest => 'Niedrigste Bewertung';

  @override
  String get details => 'Details';

  @override
  String get ingredients => 'Zutaten';

  @override
  String get instructions => 'Anleitung';

  @override
  String get tags => 'Schlagworte';

  @override
  String get notes => 'Notizen';

  @override
  String get addNote => 'Notiz hinzufügen';

  @override
  String get editNote => 'Notiz bearbeiten';

  @override
  String get noteTitleHint => 'Titel (optional)';

  @override
  String get noteTextHint => 'Notiztext';

  @override
  String get deleteNoteTitle => 'Notiz löschen?';

  @override
  String get deleteNoteMessage => 'Diese Notiz wird unwiderruflich gelöscht.';

  @override
  String get servings => 'Portionen';

  @override
  String get adjustQuantity => 'Menge anpassen';

  @override
  String get startTimer => 'Timer starten';

  @override
  String runningTimer(int minutes, String seconds) {
    return 'Timer: $minutes:$seconds';
  }

  @override
  String get planMeal => 'Mahlzeit planen';

  @override
  String get displayAlwaysOn => 'Bildschirm immer eingeschaltet';

  @override
  String get addAllIngredients => 'Alle Zutaten hinzufügen';

  @override
  String get addSelectedIngredients => 'Ausgewählte Zutaten hinzufügen';

  @override
  String get addIngredientsTitle => 'Zutaten hinzugefügt';

  @override
  String get addIngredientsMessage =>
      'Die Zutaten wurden zur Einkaufsliste hinzugefügt.';

  @override
  String addIngredientsFailedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Zutaten konnten nicht hinzugefügt werden.',
      one: '1 Zutat konnte nicht hinzugefügt werden.',
    );
    return '$_temp0';
  }

  @override
  String get cookbooks => 'Kochbücher';

  @override
  String get cookbooksEmpty =>
      'Noch keine Kochbücher vorhanden. Tippe oben rechts auf „+“, um eines zu erstellen.';

  @override
  String get cookbookNoMatches => 'Keine Rezepte entsprechen diesem Filter.';

  @override
  String get cookbookCreateTitle => 'Kochbuch erstellen';

  @override
  String get cookbookEditTitle => 'Kochbuch bearbeiten';

  @override
  String get cookbookNameLabel => 'Kochbuch Name';

  @override
  String get cookbookFilterSectionTitle => 'Rezepte automatisch hinzufügen';

  @override
  String get cookbookFieldTools => 'Utensilien';

  @override
  String get cookbookFieldUsers => 'Benutzer';

  @override
  String get cookbookOpIsOneOf => 'ist eines von';

  @override
  String get cookbookOpIsNotOneOf => 'ist nicht einer von';

  @override
  String get cookbookOpContainsAll => 'enthält alle';

  @override
  String get cookbookSelectValues => 'Werte auswählen';

  @override
  String get cookbookFilterOptionsUnavailable => 'Keine Optionen verfügbar';

  @override
  String get cookbookAddFilterField => 'Feld hinzufügen';

  @override
  String get cookbookPublicLabel => 'Öffentliches Kochbuch';

  @override
  String get cookbookPublicSubtitle =>
      'Für andere Haushalte des Servers sichtbar';

  @override
  String get cookbookRawModeEnter => 'Als Text bearbeiten';

  @override
  String get cookbookRawModeExit => 'Zurück zum Baukasten';

  @override
  String get cookbookRawModeHint =>
      'Experten-Modus dieser App: bearbeitet den Filter direkt als Text. Nützlich, wenn ein bestehender Filter nicht in einfache Zeilen zerlegt werden konnte.';

  @override
  String get cookbookRawModeUnparseable =>
      'Dieser Text passt nicht ins einfache Zeilen-Format — bleibt als Text erhalten.';

  @override
  String get saveFailed => 'Speichern fehlgeschlagen';

  @override
  String get search => 'Suchen';

  @override
  String get apply => 'Übernehmen';

  @override
  String get setupCachingTitle => 'Rezepte werden geladen';

  @override
  String get setupCachingSubtitle =>
      'Deine Rezepte werden für die Offline-Nutzung vorbereitet. Das kann je nach Anzahl einen Moment dauern.';

  @override
  String get setupCachingDone => 'Alles bereit!';

  @override
  String get setupTipsHeader => 'Schon gewusst?';

  @override
  String get setupFinish => 'Los geht\'s';

  @override
  String get setupSkipCaching => 'Im Hintergrund fortsetzen';

  @override
  String get setupTip1 =>
      'Du kannst Rezepte per Link, Foto oder PDF importieren — über die Import-Kachel auf dem Homescreen.';

  @override
  String get setupTip2 =>
      'Der Kochmodus hält das Display an, führt dich Schritt für Schritt und erkennt Timer im Text automatisch.';

  @override
  String get setupTip3 =>
      'Die Einkaufsliste funktioniert auch offline — Änderungen werden automatisch synchronisiert, sobald der Server erreichbar ist.';

  @override
  String get setupTip4 =>
      'Halte eine Kachel auf dem Homescreen gedrückt, um den Schnellzugriff neu anzuordnen.';

  @override
  String get setupTip5 =>
      'Deine Mealie-Kochbücher findest du über die Kochbücher-Kachel — inklusive Offline-Unterstützung.';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get delete => 'Löschen';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get save => 'Speichern';

  @override
  String get done => 'Fertig';

  @override
  String get close => 'Schließen';

  @override
  String get add => 'Hinzufügen';

  @override
  String get send => 'Senden';

  @override
  String get retry => 'Erneut versuchen';

  @override
  String get confirmDeleteTitle => 'Rezept löschen?';

  @override
  String get confirmDeleteMessage =>
      'Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get sendToDevice => 'An Gerät senden';

  @override
  String get sendToDevicePickerTitle => 'An Gerät senden';

  @override
  String get sendToAllDevices => 'An alle Geräte senden';

  @override
  String get timerFinished => 'Timer abgelaufen!';

  @override
  String get timerFinishedBody => 'Dein Rezept-Timer ist fertig.';

  @override
  String get timer => 'Timer';

  @override
  String get newTimer => 'Neuer Timer';

  @override
  String get timerDetails => 'Timer-Details';

  @override
  String get timerNamePlaceholder => 'Timer-Name';

  @override
  String get timerNameHint => 'Gib deinem Timer einen aussagekräftigen Namen.';

  @override
  String get durationLabel => 'Dauer';

  @override
  String minutesCount(int count) {
    return '$count Minuten';
  }

  @override
  String get start => 'Starten';

  @override
  String get stop => 'Stoppen';

  @override
  String get pause => 'Pausieren';

  @override
  String get resume => 'Fortsetzen';

  @override
  String get finished => 'Fertig!';

  @override
  String stepNumber(int number) {
    return 'Schritt $number';
  }

  @override
  String get minAbbreviation => 'min';

  @override
  String get cookingMode => 'Kochmodus';

  @override
  String activeRecipesCount(int count) {
    return '$count aktive Rezepte';
  }

  @override
  String get endAll => 'Alle beenden';

  @override
  String get end => 'Beenden';

  @override
  String get endAllRecipesTitle => 'Alle Rezepte beenden?';

  @override
  String endAllRecipesMessage(int count) {
    return 'Möchtest du alle $count aktiven Kochsessions beenden?';
  }

  @override
  String get endRecipeTitle => 'Rezept beenden?';

  @override
  String endRecipeMessage(String name) {
    return 'Möchtest du die Kochsession für \"$name\" beenden?';
  }

  @override
  String get noActiveTimers => 'Keine aktiven Timer';

  @override
  String get noActiveRecipes => 'Keine aktiven Rezepte';

  @override
  String get startRecipeToCook =>
      'Öffne ein Rezept und tippe auf den Kochmodus-Button.';

  @override
  String get browseRecipes => 'Rezepte durchsuchen';

  @override
  String timersPausedCount(int count) {
    return '$count Timer pausiert';
  }

  @override
  String get cookFriends => 'Kochen mit Freunden';

  @override
  String get cookingModeAddRecipe => 'Rezept hinzufügen';

  @override
  String get cookingModeAddRecipeSearchHint => 'Nach Rezept suchen';

  @override
  String get cookFriendsCode => 'Session-Code';

  @override
  String get cookFriendsJoin => 'Session beitreten';

  @override
  String get cookFriendsHost => 'Session hosten';

  @override
  String get cookFriendsHostNotFound =>
      'Host nicht gefunden. Stelle sicher, dass beide Geräte im selben WLAN sind und der lokale Netzwerkzugriff erlaubt ist.';

  @override
  String get cookFriendsConnectionFailed =>
      'Verbindung fehlgeschlagen. Bitte erneut versuchen.';

  @override
  String get cookFriendsEnterCode => 'Code eingeben';

  @override
  String cookFriendsConnected(int count) {
    return 'Verbunden: $count Gäste';
  }

  @override
  String get joinSession => 'Session beitreten';

  @override
  String get hostEndedSessionTitle => 'Session beendet';

  @override
  String get hostEndedSessionMessage => 'Der Host hat die Kochsession beendet.';

  @override
  String get shoppingListEmpty => 'Deine Einkaufsliste ist leer.';

  @override
  String get addItem => 'Artikel hinzufügen';

  @override
  String get itemNote => 'Artikelname';

  @override
  String get unlabeledCategory => 'Ohne Kategorie';

  @override
  String get reorderCategories => 'Kategorien sortieren';

  @override
  String get archiveChecked => 'Abgehakte archivieren';

  @override
  String get archivedLists => '📦 Archivierte Einkäufe';

  @override
  String get syncChanges => 'Änderungen synchronisieren';

  @override
  String get noSyncChanges => 'Keine Sync-Änderungen';

  @override
  String get postimportAction => 'Nach dem Import';

  @override
  String get postimportHint =>
      'Lege fest, was in der Quell-App (Erinnerungen / Google Tasks) mit den importierten Einträgen geschehen soll.';

  @override
  String get postimportLeave => 'Nur hinzufügen';

  @override
  String get postimportComplete => 'Abhaken';

  @override
  String get postimportCompleteDelete => 'Abhaken & löschen';

  @override
  String get postimportFailed =>
      'Nachverarbeitung in der Quell-App ist fehlgeschlagen. Die Artikel wurden trotzdem in Mealie hinzugefügt.';

  @override
  String get syncChangesTitle => 'Änderungen synchronisieren';

  @override
  String get syncSectionChecked => 'Abgehakt';

  @override
  String get syncSectionQuantity => 'Menge';

  @override
  String get syncSectionCategory => 'Kategorie';

  @override
  String get syncSectionAdditions => 'Neu hinzugefügt';

  @override
  String get syncLocalLabel => 'Lokal';

  @override
  String get syncServerLabel => 'Server';

  @override
  String get syncNow => 'Jetzt synchronisieren';

  @override
  String get offlineBadge => 'Offline';

  @override
  String get mealplanTitle => '📅 Essensplan';

  @override
  String get mealplanSelectMode => 'Mehrere Rezepte auswählen';

  @override
  String mealplanSelectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ausgewählt',
      one: '1 ausgewählt',
      zero: 'Auswahl',
    );
    return '$_temp0';
  }

  @override
  String get breakfast => 'Frühstück';

  @override
  String get lunch => 'Mittagessen';

  @override
  String get dinner => 'Abendessen';

  @override
  String get addMealEntry => 'Mahlzeit hinzufügen';

  @override
  String get selectRecipe => 'Rezept wählen';

  @override
  String get orFreeText => 'oder Freitext';

  @override
  String get entryNote => 'Notiz';

  @override
  String get noMealEntries => 'Keine Einträge für diese Woche.';

  @override
  String get importRecipe => 'Rezept importieren';

  @override
  String get importFromUrl => 'Aus URL importieren';

  @override
  String get importFromImage => 'Aus Foto importieren';

  @override
  String get importFromJson => 'Aus JSON importieren';

  @override
  String get url => 'URL';

  @override
  String get urlPlaceholder => 'https://...';

  @override
  String get importLanguage => 'Sprache für OCR';

  @override
  String get importing => 'Importiere...';

  @override
  String get importSuccess => 'Rezept erfolgreich importiert!';

  @override
  String importError(String error) {
    return 'Import fehlgeschlagen: $error';
  }

  @override
  String get pasteJson => 'JSON hier einfügen';

  @override
  String get setupTitle => 'Willkommen bei Mealie Recipes';

  @override
  String get setupSubtitle => 'Bitte konfiguriere deinen Mealie-Server.';

  @override
  String get serverUrl => 'Server-URL';

  @override
  String get serverUrlPlaceholder => 'https://mealie.beispiel.de';

  @override
  String get apiToken => 'API-Token';

  @override
  String get apiTokenPlaceholder => 'Dein API-Token';

  @override
  String get householdId => 'Haushalt';

  @override
  String get householdIdPlaceholder => 'Family';

  @override
  String get shoppingListId => 'Einkaufslisten-ID';

  @override
  String get shoppingListIdPlaceholder => 'Einkaufsliste wählen';

  @override
  String get setupHouseholdListTitle => 'Haushalt & Einkaufsliste';

  @override
  String get shoppingListLabel => 'Einkaufsliste';

  @override
  String get setupHouseholdManualHint =>
      'Haushalte konnten nicht geladen werden — gib den Haushaltsnamen manuell ein.';

  @override
  String get setupExactTitle => 'Mengen auf der Einkaufsliste';

  @override
  String get setupExactBody =>
      'In den meisten Ländern kauft man nicht aufs Gramm genau ein — im Laden landet 1 Packung Butter im Korb, nicht 200 g. Im einfachen Modus wandelt die App Rezeptmengen deshalb in „1×“ um. Im exakten Modus bleiben Menge und Einheit 1:1 wie in der Mealie-Webapp erhalten — auch beim Eintippen neuer Artikel (z. B. „200 g Butter“). Du kannst das jederzeit in den Einstellungen ändern.';

  @override
  String get setupExactSimpleTitle => 'Einfacher Modus (1×)';

  @override
  String get setupExactSimpleBody =>
      'Zutaten landen als „1× Artikel“ auf der Liste — ideal zum schnellen Abhaken im Laden.';

  @override
  String get setupExactExactTitle => 'Exakte Mengen';

  @override
  String get setupExactExactBody =>
      'Artikel erscheinen mit Menge und Einheit, z. B. „200 g Butter“ — 1:1 wie in der Webapp.';

  @override
  String get connect => 'Verbinden';

  @override
  String get connecting => 'Verbinde...';

  @override
  String get connectionSuccess => 'Verbindung erfolgreich!';

  @override
  String connectionError(String error) {
    return 'Verbindung fehlgeschlagen: $error';
  }

  @override
  String get optionalHeaders => 'Optionale HTTP-Header (für Reverse-Proxy)';

  @override
  String get settingsTitle => '⚙️ Einstellungen';

  @override
  String get settingsSaved => 'Einstellungen gespeichert';

  @override
  String get serverSettings => 'Server';

  @override
  String get displaySettings => 'Anzeige';

  @override
  String get notificationSettings => 'Benachrichtigungen';

  @override
  String get securitySettings => 'Sicherheit';

  @override
  String get aboutSettings => 'Über die App';

  @override
  String get showRecipeImages => 'Rezeptbilder anzeigen';

  @override
  String get apiVersion => 'API-Version';

  @override
  String get language => 'Sprache';

  @override
  String get biometricLock => 'Biometrische Sperre';

  @override
  String get biometricLockDescription => 'App mit Biometrie entsperren';

  @override
  String get criticalAlerts => 'Kritische Benachrichtigungen';

  @override
  String get criticalAlertsDescription => 'Timer-Alarm auch im Lautlosmodus';

  @override
  String get enableLogging => 'Logging aktivieren';

  @override
  String get selectLanguage => 'Sprache wählen';

  @override
  String get setupContinue => 'Weiter';

  @override
  String get back => 'Zurück';

  @override
  String get setupConnectStep => 'Mit deinem Server verbinden';

  @override
  String get resetSettings => 'Alle Einstellungen zurücksetzen';

  @override
  String get resetSettingsConfirm =>
      'Alle Einstellungen werden zurückgesetzt. Fortfahren?';

  @override
  String get guestMode => 'Gastmodus';

  @override
  String get appVersion => 'Version';

  @override
  String get leftoverFinder => 'Rezept-Suche';

  @override
  String get leftoverFinderSubtitle => 'Rezepte mit vorhandenen Zutaten finden';

  @override
  String get addIngredient => 'Zutat hinzufügen';

  @override
  String get ingredientPlaceholder => 'z.B. Eier';

  @override
  String get findRecipes => 'Rezepte finden';

  @override
  String get matchingRecipes => 'Passende Rezepte';

  @override
  String get noMatchingRecipes => 'Keine Rezepte für diese Zutaten gefunden.';

  @override
  String matchPercent(int percent) {
    return '$percent% Übereinstimmung';
  }

  @override
  String get biometricPrompt => 'Authentifizierung für Mealie Recipes';

  @override
  String get biometricFailed => 'Authentifizierung fehlgeschlagen';

  @override
  String get whatsNew => 'Was ist neu';

  @override
  String get pendingRecipesTitle => 'Empfangene Rezepte';

  @override
  String pendingRecipesMessage(String sender, String name) {
    return 'Du hast ein Rezept von $sender erhalten: \"$name\"';
  }

  @override
  String pendingRecipesFrom(Object names) {
    return 'Von $names';
  }

  @override
  String get pendingRecipesOpenCooking => 'Kochmodus öffnen';

  @override
  String get pendingRecipesLater => 'Später';

  @override
  String get openRecipe => 'Rezept öffnen';

  @override
  String get dismiss => 'Schließen';

  @override
  String get editRecipe => 'Rezept bearbeiten';

  @override
  String get recipeName => 'Rezeptname';

  @override
  String get recipeDescription => 'Beschreibung';

  @override
  String get prepTime => 'Vorbereitungszeit (min)';

  @override
  String get cookTime => 'Kochzeit (min)';

  @override
  String get totalTime => 'Gesamtzeit (min)';

  @override
  String get recipeServings => 'Portionen';

  @override
  String get rating => 'Bewertung';

  @override
  String get addIngredientLine => 'Zutat hinzufügen';

  @override
  String get addInstruction => 'Schritt hinzufügen';

  @override
  String get removeIngredient => 'Zutat entfernen';

  @override
  String get removeInstruction => 'Schritt entfernen';

  @override
  String get ingredientName => 'Zutat';

  @override
  String get ingredientQuantity => 'Menge';

  @override
  String get ingredientUnit => 'Einheit';

  @override
  String get ingredientNote => 'Notiz';

  @override
  String get instructionText => 'Schritttext';

  @override
  String get categories => 'Kategorien';

  @override
  String get selectCategories => 'Kategorien wählen';

  @override
  String get selectTags => 'Tags wählen';

  @override
  String get uploadImage => 'Bild hochladen';

  @override
  String get removeImage => 'Bild entfernen';

  @override
  String get saveChanges => 'Änderungen speichern';

  @override
  String get saving => 'Speichern...';

  @override
  String get saveSuccess => 'Rezept gespeichert.';

  @override
  String saveError(String error) {
    return 'Konnte nicht speichern: $error';
  }

  @override
  String get newCategory => 'Neue Kategorie';

  @override
  String get newTag => 'Neues Tag';

  @override
  String get setRating => 'Bewertung setzen';

  @override
  String get removeRating => 'Bewertung entfernen';

  @override
  String get ratingRemoved => 'Bewertung entfernt';

  @override
  String get googleTasksImport => 'Aus Google Tasks importieren';

  @override
  String get googleTasksImportDescription =>
      'Elemente aus Google Tasks in die Einkaufsliste importieren.';

  @override
  String get homeWelcome => 'Willkommen bei Mealie Recipes! 👋';

  @override
  String homeWelcomeNamed(String name) {
    return 'Willkommen $name, bei Mealie Recipes! 👋';
  }

  @override
  String get shopping => 'Einkaufen';

  @override
  String get planning => 'Planung';

  @override
  String get other => 'Anderes';

  @override
  String get viewRecipes => '📖 Rezepte anzeigen';

  @override
  String get addRecipe => '➕ Rezept hinzufügen';

  @override
  String get completeShopping => 'Einkauf abschließen';

  @override
  String get shoppingCompleted => 'Einkauf abgeschlossen';

  @override
  String get shoppingCompletedSubtitle => 'Alles im Wagen! 🎉';

  @override
  String get essensplan => '📅 Essensplan';

  @override
  String get resteverwertung => '🥗 Rezept-Suche';

  @override
  String get newRecipeUpload => 'Neues Rezept hochladen';

  @override
  String get copyCode => 'Code kopieren';

  @override
  String get shareLink => 'Link teilen';

  @override
  String get connectedFriends => 'Verbundene Freunde';

  @override
  String get waitingForFriends => 'Warte auf Freunde...';

  @override
  String get endSharing => 'Teilen beenden';

  @override
  String get cookFriendsDescription =>
      'Lade einen Freund ein, gemeinsam dieses Rezept zu kochen';

  @override
  String get sessionCode => 'SESSION-CODE';

  @override
  String get adjustQuantityLabel => 'Mengenfaktor für dieses Rezept anpassen:';

  @override
  String get timerStartForStep => 'Timer für Schritt';

  @override
  String get enterRecipeUrl => 'Rezept-URL eingeben';

  @override
  String get loading => 'Wird geladen...';

  @override
  String get urlInvalidScheme => 'URL muss mit http:// oder https:// beginnen';

  @override
  String get urlAddScheme => 'https:// hinzufügen';

  @override
  String get addItemPlaceholder => 'Artikel hinzufügen...';

  @override
  String get addSuccessToast => 'Hinzugefügt!';

  @override
  String get completedItems => 'Erledigt';

  @override
  String get completeShoppingTitle => 'Einkauf abschließen?';

  @override
  String get completeShoppingMessage => 'Erledigte Artikel löschen?';

  @override
  String get recipeListTitle => '📖 Rezepte';

  @override
  String get importRecipeTitle => 'Neues Rezept hochladen';

  @override
  String get uploadRecipeUrl => 'Import per Rezept-URL';

  @override
  String get uploadRecipeUrlHint =>
      'Gib die Rezept-URL ein, um sie auf deinem Server zu speichern';

  @override
  String get uploadOpenAI => 'Import per OpenAI von Datei';

  @override
  String get uploadOpenAIHint =>
      'Alternativ kannst du Fotos oder ein PDF eines Rezepts hochladen. Geht das Rezept über mehrere Seiten, füge einfach mehrere Seiten hinzu — sie werden zusammen per KI analysiert.';

  @override
  String get takePhoto => 'Kamera';

  @override
  String get cameraPermissionDenied =>
      'Kein Zugriff auf die Kamera. Erlaube ihn in den Systemeinstellungen, um Rezepte abzufotografieren.';

  @override
  String get cameraUnavailable =>
      'Auf diesem Gerät ist keine Kamera verfügbar.';

  @override
  String get selectPhoto => 'Fotos';

  @override
  String get selectPdf => 'PDF';

  @override
  String get openAIHintTitle => 'Dateianalyse-Info';

  @override
  String get openAIHintBody =>
      'Die Rezeptanalyse erfolgt über die OpenAI API. Stelle sicher, dass dein API-Key in den Mealie-Server-Einstellungen konfiguriert ist.';

  @override
  String get allDeleteConfirm => 'Alle löschen';

  @override
  String get portionen => 'Portionen';

  @override
  String get timerForStep => 'Timer für diesen Schritt starten';

  @override
  String get weekNavPrev => 'Vorherige Woche';

  @override
  String get weekNavNext => 'Nächste Woche';

  @override
  String get noMealsThisWeek => 'Keine Mahlzeiten geplant';

  @override
  String get entriesInOtherWeeks => 'Es gibt Einträge in anderen Wochen';

  @override
  String get availableWeeks => 'Verfügbare Wochen:';

  @override
  String weekRange(Object end, Object start, Object week) {
    return 'KW $week ($start – $end)';
  }

  @override
  String get currentWeek => 'Aktuelle Woche';

  @override
  String get rezepteAktualisieren => 'Rezepte aktualisieren';

  @override
  String get leftoverWhatTitle => 'Was macht diese Funktion?';

  @override
  String get leftoverWhatBody =>
      'Diese Funktion lädt alle Rezepte vom Server neu und aktualisiert den lokalen Cache.';

  @override
  String get leftoverDescription =>
      'Gib verfügbare Zutaten ein, um passende Rezepte zu finden und Reste optimal zu verwerten.';

  @override
  String get leftoverIngredientsHeader => 'Zutaten zu Hause';

  @override
  String get leftoverSuggestions => 'Rezeptvorschläge';

  @override
  String get leftoverNoMatches => 'Keine passenden Rezepte gefunden.';

  @override
  String get leftoverEnterIngredient => 'Zutat eingeben';

  @override
  String matchingPercentText(int percent, int count, int total) {
    return '$percent% passend ($count/$total)';
  }

  @override
  String get weekAbbreviation => 'KW';

  @override
  String get today => 'Heute';

  @override
  String get selectDate => 'Datum auswählen';

  @override
  String get selectSlot => 'Mahlzeit auswählen';

  @override
  String get selectedRecipe => 'Ausgewähltes Rezept';

  @override
  String get confirmMeal => 'Mahlzeit einplanen';

  @override
  String get searchRecipes => 'Rezepte suchen';

  @override
  String get addCustomMeal => 'Eigene Mahlzeit hinzufügen';

  @override
  String get diceModeButton => 'Zufällige Rezepte würfeln';

  @override
  String get diceModeTitle => '3 zufällige Vorschläge';

  @override
  String get diceBackToSearch => 'Zurück zur Suche';

  @override
  String get diceNotEnoughRecipes =>
      'Nicht genügend Rezepte für den Würfel-Modus (mind. 3 nötig)';

  @override
  String get entrySingular => 'Eintrag';

  @override
  String get entriesPlural => 'Einträge';

  @override
  String listTitle(int n) {
    return 'Liste $n';
  }

  @override
  String get deleteAllConfirmTitle => 'Wirklich löschen?';

  @override
  String get deleteAllConfirmMessage =>
      'Möchtest du alle archivierten Einkäufe löschen?';

  @override
  String get uploadFromUrlButton => 'Rezept von URL importieren';

  @override
  String get uploadingImage => 'Wird hochgeladen...';

  @override
  String get uploadErrorTitle => 'Upload fehlgeschlagen';

  @override
  String get uploadSuccessTitle => 'Upload erfolgreich';

  @override
  String get editImportedRecipeQuestion =>
      'Möchtest du das neue Rezept jetzt bearbeiten?';

  @override
  String get notNow => 'Jetzt nicht';

  @override
  String get pdfTooLarge => 'Die PDF-Datei ist zu groß (max. 10 MB).';

  @override
  String get invalidUrl =>
      'Ungültige URL. Bitte gib eine gültige HTTP(S)-URL ein.';

  @override
  String get cookWithFriends => 'Mit Freunden kochen';

  @override
  String get cookFriendsSubtitle =>
      'Lade einen Freund ein, gemeinsam dieses Rezept zu kochen';

  @override
  String get copied => 'Kopiert';

  @override
  String get linkCopied => 'Link kopiert';

  @override
  String get startCooking => 'Kochen starten';

  @override
  String get hostNoRecipe => 'Öffne ein Rezept, um eine Session zu starten';

  @override
  String get uploadToOwnServer => 'Auf meinem Server speichern';

  @override
  String get uploadingRecipe => 'Rezept wird hochgeladen…';

  @override
  String get recipeUploadedToOwnServer =>
      'Rezept auf deinem Server gespeichert';

  @override
  String get recipeUploadFailed => 'Hochladen fehlgeschlagen';

  @override
  String get allowGuestSaveRecipes =>
      'Gäste dürfen Rezepte auf ihrem eigenen Server speichern';

  @override
  String get appIcon => 'App-Icon';

  @override
  String get appIconClassic => 'Klassisch';

  @override
  String get appIconModern => 'Modern';

  @override
  String get name => 'Name';

  @override
  String get color => 'Farbe';

  @override
  String get randomColor => 'Zufallsfarbe';

  @override
  String get createFailed => 'Konnte nicht angelegt werden';

  @override
  String get deleteFailed => 'Konnte nicht gelöscht werden';

  @override
  String deleteOrganizerConfirm(String name) {
    return '„$name“ löschen? Wird auch auf dem Server entfernt.';
  }

  @override
  String get connectionSection => 'Verbindung';

  @override
  String get token => 'Token';

  @override
  String get advancedOptions => 'Erweiterte Optionen';

  @override
  String get mealieApiVersion => 'Mealie API-Version';

  @override
  String get sendOptionalHeaders => 'Optionale Header senden';

  @override
  String get offlineRecipeImages => 'Rezeptbilder offline speichern';

  @override
  String get offlineRecipeImagesHint =>
      'Lädt alle Rezeptbilder aufs Gerät, damit sie auch ohne Verbindung angezeigt werden. Bei großen Sammlungen kann das mehrere hundert MB belegen. Ausschalten löscht die gespeicherten Bilder.';

  @override
  String offlineRecipeImagesStatus(int count, int total, String size) {
    return 'Gespeichert: $count/$total · $size';
  }

  @override
  String get offlineRecipeImagesDisableConfirm =>
      'Alle gespeicherten Rezeptbilder löschen?';

  @override
  String headerNameLabel(int n) {
    return 'Header $n Name';
  }

  @override
  String headerValueLabel(int n) {
    return 'Header $n Wert';
  }

  @override
  String get value => 'Wert';

  @override
  String get personalization => 'Personalisierung';

  @override
  String get showRecipeImagesSubtitle => 'Zeigt Bilder in der Rezeptliste an';

  @override
  String get exactQuantities => 'Exakte Mengen übernehmen';

  @override
  String get exactQuantitiesSubtitle =>
      'Zutaten & eingetippte Artikel behalten Menge und Einheit (z. B. 200 g Butter) statt 1x pro Artikel — fehlende Zutaten legt die App am Server an';

  @override
  String get remindToShop => 'Erinnere mich zum Einkaufen';

  @override
  String get remindToShopSubtitle =>
      'Benachrichtigt dich, wenn du in der Nähe eines gespeicherten Standorts bist und die Einkaufsliste offene Artikel hat — auch bei geschlossener App';

  @override
  String get shoppingReminderAddLocation => 'Standort hinzufügen';

  @override
  String get shoppingReminderMaxLocations => 'Maximal 3 Standorte erreicht';

  @override
  String get shoppingReminderLocationServiceDisabled =>
      'Der Standortdienst ist auf diesem Gerät deaktiviert';

  @override
  String get shoppingReminderPermissionTitle => 'Standortzugriff nötig';

  @override
  String get shoppingReminderPermissionMessage =>
      'Damit du in der Nähe eines Geschäfts erinnert wirst, wird der Standortzugriff „Immer erlauben“ benötigt — auch bei geschlossener App. Bitte in den Einstellungen aktivieren.';

  @override
  String get openSettings => 'Einstellungen öffnen';

  @override
  String get shoppingReminderLocationName => 'Name';

  @override
  String get shoppingReminderUseCurrentLocation =>
      'Aktuellen Standort verwenden';

  @override
  String get shoppingReminderOrAddress => 'oder Adresse eingeben';

  @override
  String get shoppingReminderAddress => 'Adresse';

  @override
  String get shoppingReminderAddressPlaceholder => 'Straße, Ort';

  @override
  String get shoppingReminderSearchAddress => 'Suchen';

  @override
  String get shoppingReminderLocationFailed =>
      'Standort konnte nicht ermittelt werden';

  @override
  String get shoppingReminderAddressNotFound => 'Adresse nicht gefunden';

  @override
  String get ratingFailed =>
      'Bewertung konnte nicht gespeichert werden — bitte erneut versuchen.';

  @override
  String get lastCooked => 'Zuletzt gemacht';

  @override
  String get syncLastCooked => '„Zuletzt gemacht“ aktualisieren';

  @override
  String get syncLastCookedSubtitle =>
      'Speichert das heutige Datum und einen Eintrag im Zeitstrahl — wie in der Mealie-Webapp.';

  @override
  String get developer => 'Entwickler';

  @override
  String get enableLoggingSubtitle =>
      'Erfasst print/Fehler-Logs (letzte 500 Zeilen)';

  @override
  String get entriesLabel => 'Einträge';

  @override
  String get fileSize => 'Dateigröße';

  @override
  String get showAction => 'Anzeigen';

  @override
  String get copy => 'Kopieren';

  @override
  String logsWithCount(int count) {
    return 'Logs ($count)';
  }

  @override
  String get noLogs => 'Keine Logs vorhanden';

  @override
  String get logsTitle => 'Logs';

  @override
  String get required => 'Erforderlich';

  @override
  String get connectionFailedCheck =>
      'Verbindung fehlgeschlagen. URL und Token prüfen.';

  @override
  String get username => 'Benutzername';

  @override
  String get password => 'Passwort';

  @override
  String get setupPasswordHint =>
      'Dein Passwort wird nicht gespeichert — die App meldet dich einmalig an und erzeugt daraus ein API-Token (wie unter Profil → API-Tokens in der Webapp).';

  @override
  String get loginAndConnect => 'Anmelden & verbinden';

  @override
  String get loginInvalidCredentials => 'Benutzername oder Passwort falsch.';

  @override
  String get loginAndGenerateToken => 'Anmelden & Token erzeugen';

  @override
  String get loggingIn => 'Anmeldung läuft…';

  @override
  String get apiTokenSaveHint =>
      'Token übernommen — bitte unten „Änderungen speichern“ tippen.';

  @override
  String get renewApiToken => 'API-Token erneuern';

  @override
  String get setupAuthChoiceTitle => 'Wie möchtest du dich anmelden?';

  @override
  String get authModePasswordTitle => 'Einen API-Key für mich erstellen lassen';

  @override
  String get authModePasswordSubtitle =>
      'Mit Benutzername & Passwort anmelden — die App erzeugt automatisch ein Token.';

  @override
  String get authModeTokenTitle => 'Ich habe bereits einen API-Key';

  @override
  String get authModeTokenSubtitle =>
      'Aus dem Mealie-Profil kopiert (Profil → API-Tokens).';

  @override
  String keyN(int n) {
    return 'Schlüssel $n';
  }

  @override
  String valueN(int n) {
    return 'Wert $n';
  }

  @override
  String get openCookingMode => 'Kochmodus öffnen';

  @override
  String activeRecipes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count aktive Rezepte',
      one: '1 aktives Rezept',
    );
    return '$_temp0';
  }

  @override
  String get reparseIngredients => 'Zutaten neu parsen';

  @override
  String get reparseIngredientsSubtitle =>
      'Menge/Einheit/Zutat trennen (z. B. „200 g Mehl“)';

  @override
  String get reparseDone =>
      'Zutaten zerlegt – „Änderungen speichern“ zum Übernehmen';

  @override
  String get reparseNone => 'Keine zerlegbaren Zutaten gefunden';

  @override
  String get tagsAndCategories => 'Schlagworte, Kategorien & Utensilien';

  @override
  String get tapToAddPhoto => 'Tippe um Foto hinzuzufügen';

  @override
  String get descriptionLabel => 'Beschreibung';

  @override
  String get searchingDevices => 'Suche Geräte im selben WLAN…';

  @override
  String get selectAll => 'Alle auswählen';

  @override
  String get importReminders => 'Erinnerungen importieren';

  @override
  String get importGoogleTasks => 'Google Tasks importieren';

  @override
  String get noTaskLists => 'Keine Aufgabenlisten gefunden';

  @override
  String get noReminderLists => 'Keine Erinnerungslisten gefunden';

  @override
  String importCount(int count) {
    return '$count importieren';
  }

  @override
  String get activeRecipeTimer => 'Aktiver Rezept-Timer';

  @override
  String get linkIngredients => 'Zutaten verknüpfen';

  @override
  String get noIngredientsToLink => 'Keine Zutaten zum Verknüpfen vorhanden';

  @override
  String get importLanguageSubtitle =>
      'Sprache für Rezepte, die aus Foto oder PDF importiert werden';

  @override
  String get importLanguageSearch => 'Sprache suchen';

  @override
  String get importLanguageFollowApp => 'Wie App-Sprache';

  @override
  String get importLanguageNoMatch => 'Keine Sprache gefunden';

  @override
  String get setupImportLanguageTitle => 'KI-Rezeptimport';

  @override
  String get setupImportLanguageBody =>
      'Fotos und PDFs lassen sich per KI in Rezepte umwandeln. Wähl die Sprache, in der sie ankommen sollen — praktisch, wenn deine Muttersprache nicht als App-Sprache verfügbar ist. Du kannst das später in den Einstellungen ändern.';

  @override
  String get setupImportLanguageSearchHint =>
      'Über die Suche in der Auswahl findest du auch Sprachen, die die App-Oberfläche nicht anbietet.';

  @override
  String get setupCachingKeepOpenTitle => 'Bitte App geöffnet lassen';

  @override
  String get setupCachingKeepOpenBody =>
      'Das Laden läuft im Vordergrund. Lass die App offen, bis es fertig ist — schließt du sie oder wechselst zu lange weg, bricht der Vorgang ab und startet später neu.';

  @override
  String get supportContact => 'Support kontaktieren';

  @override
  String get supportDialogMessage =>
      'Beschreib dein Problem, wir melden uns. Das Protokoll hilft enorm bei der Fehlersuche — du kannst es als Textdatei anhängen.';

  @override
  String get supportWithoutLogs => 'Ohne Protokoll';

  @override
  String get supportWithLogs => 'Protokoll anhängen';

  @override
  String get supportMailSubject => 'Mealie Recipes — Support';

  @override
  String get supportMailHint => 'Beschreib dein Problem bitte hier:';

  @override
  String get supportLogsEmpty =>
      'Das Protokoll ist leer. Schalte die Protokollierung ein, ruf das Problem erneut hervor und schick es dann.';

  @override
  String supportAddressCopied(String email) {
    return 'Adresse kopiert: $email';
  }

  @override
  String supportNoMailApp(String email) {
    return 'Keine Mail-App gefunden. Adresse kopiert: $email';
  }

  @override
  String get createRecipeFromImages => 'Rezept erstellen';

  @override
  String imagePagesSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Seiten ausgewählt',
      one: '1 Seite ausgewählt',
    );
    return '$_temp0';
  }

  @override
  String get imagePagesHint =>
      'Das erste Bild wird zum Hauptbild des Rezepts. Zum Umsortieren eine Seite gedrückt halten.';

  @override
  String get mainImageBadge => 'Hauptbild';

  @override
  String maxImagesReached(int max) {
    return 'Maximal $max Bilder pro Rezept.';
  }

  @override
  String get removePage => 'Seite entfernen';

  @override
  String get preparingPdf => 'PDF wird verarbeitet...';

  @override
  String get shareRecipeTitle => 'Rezept teilen';

  @override
  String get recipeOptionsTitle => 'Optionen';

  @override
  String get exportAsPdf => 'Als PDF exportieren';

  @override
  String get generatingPdf => 'PDF wird erstellt…';

  @override
  String get pdfExportFailed => 'PDF-Export fehlgeschlagen';

  @override
  String get recipeTime => 'Zeit';

  @override
  String get ingredientSectionTitle => 'Abschnitt';

  @override
  String get addIngredientSection => 'Abschnitt hinzufügen';

  @override
  String get aiImportToggle => 'Mit KI analysieren';

  @override
  String get aiImportToggleHint =>
      'Auch für Rezeptvideos (YouTube, Instagram, TikTok …) und Seiten, die der normale Import nicht lesen kann. Dafür muss auf deinem Mealie-Server ein KI-Anbieter eingerichtet sein – für Videos zusätzlich ein Audio-Anbieter.';

  @override
  String get aiImportButton => 'Mit KI importieren';

  @override
  String get aiImportRunning =>
      'Die KI analysiert den Link … bei Videos kann das einige Minuten dauern.';

  @override
  String get aiImportFailed =>
      'Der KI-Import ist fehlgeschlagen. Prüfe die KI-Einstellungen deines Mealie-Servers.';

  @override
  String get stepHeadingLabel => 'Schritt-Überschrift (optional)';

  @override
  String get linkedRecipeLabel => 'Verlinktes Rezept';

  @override
  String get toolsTitle => 'Utensilien';

  @override
  String get prepareTools => 'Bitte folgende Utensilien bereitlegen';

  @override
  String get newTool => 'Neues Utensil';

  @override
  String get renameAction => 'Umbenennen';

  @override
  String get organizerEmpty =>
      'Noch keine Einträge. Tippe oben rechts auf „+“, um einen anzulegen.';

  @override
  String organizerRecipeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Rezepte',
      one: '1 Rezept',
      zero: 'Keine Rezepte',
    );
    return '$_temp0';
  }

  @override
  String get toolOnHand => 'Vorhanden';

  @override
  String get mealDiceSettingsTitle => 'Würfel-Filter';

  @override
  String get mealDiceSettingsHint =>
      'Wähle pro Mahlzeit Kategorien und Schlagworte. Der Würfel schlägt dann nur Rezepte vor, die mindestens einen davon haben. Dieselbe Auswahl kann bei mehreren Mahlzeiten gesetzt sein.';

  @override
  String get mealDiceSettingsNoneHint =>
      'Für diese Mahlzeit ist nichts ausgewählt: Der Würfel sucht automatisch nach Kategorien wie „Frühstück“, „Mittagessen“ oder „Abendessen“.';

  @override
  String get mealDiceAutoHintTitle => 'Automatische Auswahl';

  @override
  String get mealDiceAutoHintBody =>
      'Für diese Mahlzeit sind noch keine Kategorien oder Schlagworte festgelegt. Der Würfel sucht deshalb nach Kategorien wie „Frühstück“, „Mittagessen“ oder „Abendessen“ und füllt mit anderen Rezepten auf.\n\nEigene Auswahl: im Mahlzeitenplan auf das Zahnrad neben dem „+“ tippen.';

  @override
  String get dontShowAgain => 'Meldung nicht mehr anzeigen';

  @override
  String get mealDiceNoMatches =>
      'Kein Rezept passt zu den für diese Mahlzeit gewählten Kategorien und Schlagworten.';

  @override
  String mealDiceFewMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Nur $count passende Rezepte',
      one: 'Nur 1 passendes Rezept',
    );
    return '$_temp0';
  }

  @override
  String get commentsTitle => 'Kommentare';

  @override
  String get commentHint => 'Kommentar schreiben…';

  @override
  String get commentSaveFailed =>
      'Der Kommentar konnte nicht gespeichert werden.';

  @override
  String get commentDeleteConfirm => 'Diesen Kommentar löschen?';

  @override
  String get cookingDoneCommentLabel => 'Kommentar (optional)';

  @override
  String get cookingDoneCommentHint =>
      'Wie ist es geworden? Tipps fürs nächste Mal…';

  @override
  String get nutritionTitle => 'Nährwerte';

  @override
  String get nutritionPerServing => 'pro Portion';

  @override
  String get nutritionCalories => 'Kalorien';

  @override
  String get nutritionFat => 'Fett';

  @override
  String get nutritionSaturatedFat => 'Gesättigte Fettsäuren';

  @override
  String get nutritionTransFat => 'Transfette';

  @override
  String get nutritionUnsaturatedFat => 'Ungesättigte Fettsäuren';

  @override
  String get nutritionCholesterol => 'Cholesterin';

  @override
  String get nutritionSodium => 'Natrium';

  @override
  String get nutritionCarbohydrates => 'Kohlenhydrate';

  @override
  String get nutritionFiber => 'Ballaststoffe';

  @override
  String get nutritionSugar => 'Zucker';

  @override
  String get nutritionProtein => 'Eiweiß';

  @override
  String get timelineTitle => 'Zeitstrahl';

  @override
  String get timelineMadeThis => 'Ich hab\'s gemacht';

  @override
  String timelineUserMadeThis(String name) {
    return '$name hat\'s gemacht';
  }

  @override
  String get timelineEmpty => 'Noch keine Einträge im Zeitstrahl.';

  @override
  String get timelineDate => 'Datum';

  @override
  String get timelineNoteHint => 'Notiz (optional)';

  @override
  String get timelineAddPhoto => 'Foto hinzufügen';

  @override
  String get timelineRemovePhoto => 'Foto entfernen';

  @override
  String get timelineSaved => 'Zum Zeitstrahl hinzugefügt';

  @override
  String get timelineSaveFailed =>
      'Konnte nicht zum Zeitstrahl hinzugefügt werden';

  @override
  String get timelineImageFailed =>
      'Eintrag gespeichert, aber das Foto konnte nicht hochgeladen werden';

  @override
  String get timelineDeleteConfirm =>
      'Diesen Eintrag aus dem Zeitstrahl löschen?';

  @override
  String get timelineEditNote => 'Notiz bearbeiten';

  @override
  String get timelineUnknownRecipe => 'Rezept nicht gefunden';

  @override
  String get cookingDonePhotoHint =>
      'Foto für den Mealie-Zeitstrahl (optional)';

  @override
  String get assetsTitle => 'Anhänge';

  @override
  String get assetsAdd => 'Anhang hinzufügen';

  @override
  String get assetsChooseFile => 'Datei';

  @override
  String get assetsUploading => 'Wird hochgeladen …';

  @override
  String get assetsUploadFailed => 'Anhang konnte nicht hochgeladen werden';

  @override
  String assetsDeleteConfirm(String name) {
    return '„$name“ aus den Anhängen entfernen?';
  }

  @override
  String get assetsOpenFailed => 'Anhang konnte nicht geöffnet werden';

  @override
  String get assetsUnsupported =>
      'Mealie unterstützt nur PDF, Bilder, TXT, MD, CSV und JSON.';

  @override
  String get assetsShare => 'Teilen';

  @override
  String get mealRulesTitle => 'Mealie-Regeln';

  @override
  String get mealRulesHint =>
      'Gelten auch in der Mealie-Webapp. Passen mehrere Regeln auf Tag und Mahlzeit, müssen alle erfüllt sein. Greift keine Regel, wählt der Würfel aus allen Rezepten.';

  @override
  String get mealRuleAdd => 'Regel hinzufügen';

  @override
  String get mealRuleNewTitle => 'Neue Regel';

  @override
  String get mealRuleEditTitle => 'Regel bearbeiten';

  @override
  String get mealRuleDay => 'Wochentag';

  @override
  String get mealRuleAnyDay => 'Jeder Tag';

  @override
  String get mealRuleMealType => 'Mahlzeit';

  @override
  String get mealRuleAnyMeal => 'Jede Mahlzeit';

  @override
  String get mealRuleConditionsTitle => 'Bedingungen';

  @override
  String get mealRuleAllRecipes => 'Alle Rezepte';

  @override
  String get mealRuleDeleteConfirm => 'Diese Regel löschen?';

  @override
  String get mealRulesOffline =>
      'Mealie-Regeln sind gerade nicht erreichbar – der Würfel nutzt die App-Auswahl.';

  @override
  String get mealRulesNoMatches =>
      'Keine Rezepte erfüllen die Mealie-Regeln für diese Mahlzeit.';

  @override
  String get mealTypeSide => 'Beilage';

  @override
  String get mealTypeSnack => 'Zwischenmahlzeit';

  @override
  String get mealTypeDrink => 'Getränk';

  @override
  String get mealTypeDessert => 'Nachspeise';

  @override
  String get foodsTitle => 'Lebensmittel';

  @override
  String get unitsTitle => 'Einheiten';

  @override
  String get newFood => 'Neues Lebensmittel';

  @override
  String get newUnit => 'Neue Einheit';

  @override
  String get editFood => 'Lebensmittel bearbeiten';

  @override
  String get editUnit => 'Einheit bearbeiten';

  @override
  String get pluralNameLabel => 'Pluralname';

  @override
  String get abbreviationLabel => 'Abkürzung';

  @override
  String get pluralAbbreviationLabel => 'Abkürzung (Plural)';

  @override
  String get mergeAction => 'Zusammenführen';

  @override
  String mergeIntoTitle(String name) {
    return '„$name“ zusammenführen mit …';
  }

  @override
  String mergeConfirm(String from, String to) {
    return '„$from“ wird mit „$to“ zusammengeführt: Alle Rezepte und Einkaufslisten verwenden danach „$to“, „$from“ wird gelöscht.';
  }

  @override
  String get mergeFailed => 'Zusammenführen fehlgeschlagen';

  @override
  String foodUnitDeleteConfirm(String name) {
    return '„$name“ löschen? Zutaten, die es verwenden, verlieren den Eintrag.';
  }

  @override
  String get foodsUnitsEmpty => 'Noch keine Einträge.';

  @override
  String mealRuleConditionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Bedingungen',
      one: '1 Bedingung',
    );
    return '$_temp0';
  }

  @override
  String get showAll => 'Alle anzeigen';

  @override
  String get mealDiceModeTitle => 'Würfel verwendet';

  @override
  String get mealDiceModeApp => 'App-Auswahl';

  @override
  String get switchListTitle => 'Liste wechseln';

  @override
  String get newShoppingList => 'Neue Einkaufsliste';

  @override
  String shoppingListDeleteConfirm(String name) {
    return '„$name“ löschen? Alle Artikel darin werden ebenfalls gelöscht.';
  }

  @override
  String get labelOrderTitle => 'Bezeichnungen sortieren';

  @override
  String get labelOrderHint =>
      'Ziehen zum Sortieren. Gilt für diese Liste – auch in der Mealie-Webapp.';

  @override
  String get labelOrderEmpty => 'Diese Liste hat noch keine Bezeichnungen.';

  @override
  String get useAsActiveList => 'Als aktive Liste verwenden';

  @override
  String get activeListBadge => 'Aktiv';

  @override
  String get foodLabelLabel => 'Bezeichnung';

  @override
  String get foodNoLabel => 'Keine Bezeichnung';

  @override
  String get aliasesLabel => 'Aliasse';

  @override
  String get aliasAddHint => 'Alias hinzufügen';

  @override
  String get foodOnHand => 'Im Haushalt vorrätig';

  @override
  String get timelineChildRecipesTitle =>
      'Auch für verlinkte Rezepte eintragen';

  @override
  String timelineMadeForRecipe(String recipe) {
    return 'Gemacht für $recipe';
  }

  @override
  String get timelineFilter => 'Einträge filtern';

  @override
  String get timelineTypeComment => 'Gemacht & Notizen';

  @override
  String get timelineTypeInfo => 'Hinweise';

  @override
  String get timelineTypeSystem => 'System';

  @override
  String get listManagementTitle => 'Einkaufslisten';

  @override
  String get managementTitle => 'Weiteres';

  @override
  String get pinToHome => 'Auf den Startbildschirm';

  @override
  String get unpinFromHome => 'Vom Startbildschirm entfernen';

  @override
  String homeScreenFull(int count) {
    return 'Der Startbildschirm ist voll – maximal $count Kacheln. Entferne zuerst eine andere Kachel unter „Weiteres“.';
  }

  @override
  String get selectAction => 'Auswählen';

  @override
  String selectedCount(int count) {
    return '$count ausgewählt';
  }

  @override
  String get assignLabelAction => 'Bezeichnung zuweisen';

  @override
  String get assignLabelOverwriteHint =>
      'Überschreibt die Bezeichnung aller ausgewählten Lebensmittel.';

  @override
  String deleteSelectedConfirm(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Einträge löschen?',
      one: '1 Eintrag löschen?',
    );
    return '$_temp0';
  }

  @override
  String get seedDataAction => 'Musterdaten laden';

  @override
  String get seedFoodsHint =>
      'Legt Mealies Standard-Lebensmittel in der gewählten Sprache an.';

  @override
  String get seedUnitsHint =>
      'Legt Mealies Standard-Einheiten in der gewählten Sprache an.';

  @override
  String get seedLanguageLabel => 'Sprache';

  @override
  String get seedDuplicateWarning =>
      'Es gibt schon Einträge. Mealie gleicht Doppelte nicht ab – die musst du danach selbst zusammenführen.';

  @override
  String get seedDone => 'Musterdaten angelegt';

  @override
  String get seedFailed => 'Musterdaten konnten nicht geladen werden';

  @override
  String get exportAction => 'Exportieren';

  @override
  String get substitutionsLabel => 'Alternativen';

  @override
  String get substitutionAddHint => 'Alternative hinzufügen';

  @override
  String get substitutionFoodLabel => 'Lebensmittel (optional)';

  @override
  String get substitutionNoteLabel => 'Notiz (optional)';

  @override
  String get substitutionNeedOne => 'Lebensmittel oder Notiz angeben';

  @override
  String get useAbbreviationLabel => 'Abkürzung verwenden';

  @override
  String get useAbbreviationHint => 'In Rezepten „g“ statt „Gramm“ anzeigen';

  @override
  String get fractionLabel => 'Als Bruch anzeigen';

  @override
  String get fractionHint => '½ statt 0,5';

  @override
  String get standardizationTitle => 'Standardisierung';

  @override
  String get standardizationHint =>
      'Für Umrechnungen: 1 dieser Einheit entspricht … (z. B. 1 EL = 15 Milliliter).';

  @override
  String get standardQuantityLabel => 'Standardmenge';

  @override
  String get standardUnitLabel => 'Standardeinheit';

  @override
  String get standardUnitNone => 'Keine';

  @override
  String get stdFluidOunce => 'Flüssigunze (fl oz)';

  @override
  String get stdCup => 'Tasse (US)';

  @override
  String get stdOunce => 'Unze (oz)';

  @override
  String get stdPound => 'Pfund (lb)';

  @override
  String get stdMilliliter => 'Milliliter';

  @override
  String get stdLiter => 'Liter';

  @override
  String get stdGram => 'Gramm';

  @override
  String get stdKilogram => 'Kilogramm';

  @override
  String get labelsTitle => 'Bezeichnungen';

  @override
  String get newLabel => 'Neue Bezeichnung';

  @override
  String get editLabel => 'Bezeichnung bearbeiten';

  @override
  String get colorLabel => 'Farbe';

  @override
  String labelDeleteConfirm(String name) {
    return '„$name“ löschen? Artikel und Lebensmittel verlieren diese Bezeichnung.';
  }

  @override
  String get importMenuAction => 'Importieren';

  @override
  String get archivedEmpty =>
      'Noch keine archivierten Einkäufe. Tippe nach dem Einkaufen auf „Einkauf abschließen“ – die erledigten Artikel landen dann hier.';

  @override
  String get sectionTitleLabel => 'Titel des Abschnitts';

  @override
  String get clearSection => 'Abschnitt löschen';

  @override
  String get noPermissionGeneric =>
      'Dafür fehlen dir in Mealie die Rechte. Frag einen Admin oder Haushalts-Verwalter.';

  @override
  String get noPermissionEditRecipe =>
      'Du darfst dieses Rezept nicht bearbeiten – es ist gesperrt oder gehört einem anderen Haushalt. Das kann nur der Ersteller oder ein Admin.';

  @override
  String get noPermissionDeleteRecipe =>
      'Nur der Ersteller des Rezepts oder ein Admin darf es löschen.';

  @override
  String get noPermissionDemoteSelf =>
      'Du kannst dir die Admin-Rechte nicht selbst entziehen.';

  @override
  String get recipeLockedHint =>
      'Gesperrt – nur der Ersteller kann es bearbeiten';

  @override
  String get recipeDeleteOwnerOnlyHint =>
      'Nur der Ersteller oder ein Admin kann löschen';

  @override
  String get organizeReadOnlyHint =>
      'Nur ansehen: Zum Anlegen, Ändern und Löschen braucht es das Recht „Benutzer kann Lebensmittel, Tags und Kategorien verwalten“.';

  @override
  String get notesNotSavedNoPermission =>
      'Notiz nicht gespeichert – dir fehlt das Recht, dieses Rezept zu bearbeiten.';

  @override
  String get userManagementTitle => 'Benutzerverwaltung';

  @override
  String get usersTitle => 'Benutzer';

  @override
  String get editUserTitle => 'Benutzer bearbeiten';

  @override
  String get fullNameLabel => 'Vollständiger Name';

  @override
  String get usernameLabel => 'Benutzername';

  @override
  String get emailLabel => 'E-Mail';

  @override
  String get passwordLabel => 'Passwort';

  @override
  String get householdLabel => 'Haushalt';

  @override
  String get permissionsTitle => 'Berechtigungen';

  @override
  String get administratorLabel => 'Administrator';

  @override
  String get permCanInvite => 'Benutzer kann andere in Gruppe einladen';

  @override
  String get permCanManage => 'Benutzer kann Gruppeneinstellungen verwalten';

  @override
  String get permCanManageHousehold => 'Benutzer kann Haushalt verwalten';

  @override
  String get permCanOrganize =>
      'Benutzer kann Lebensmittel, Tags und Kategorien verwalten';

  @override
  String get advancedFeaturesLabel => 'Erweiterte Funktionen aktivieren';

  @override
  String get passwordResetLinkAction =>
      'Link zum Zurücksetzen des Passworts erstellen';

  @override
  String get resetLockedUsersAction => 'Gesperrte Benutzer zurücksetzen';

  @override
  String get membersTitle => 'Mitglieder';

  @override
  String get inviteLinkTitle => 'Einladungslink';

  @override
  String get inviteAction => 'Einladen';

  @override
  String get userUpdated => 'Benutzer aktualisiert';

  @override
  String get createUserTitle => 'Benutzer erstellen';

  @override
  String get userCreated => 'Benutzer erstellt';

  @override
  String userDeleteConfirm(String name) {
    return '„$name“ löschen? Das Konto wird in Mealie entfernt.';
  }

  @override
  String get passwordResetLinkCopied =>
      'Link kopiert – gib ihn an den Benutzer weiter. Er ist nur begrenzt gültig.';

  @override
  String lockedUsersReset(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Benutzer entsperrt',
      one: '1 Benutzer entsperrt',
      zero: 'Keine gesperrten Benutzer',
    );
    return '$_temp0';
  }

  @override
  String get inviteUsesLabel => 'Anzahl Verwendungen';

  @override
  String get inviteCreated => 'Einladungslink erstellt';

  @override
  String get inviteEmailHint =>
      'E-Mail-Adresse (optional – Mealie schickt dann die Einladung)';

  @override
  String get inviteEmailSent => 'Einladung per E-Mail verschickt';

  @override
  String get inviteEmailFailed =>
      'E-Mail konnte nicht verschickt werden (ist SMTP in Mealie eingerichtet?). Der Link funktioniert trotzdem.';

  @override
  String get copyLinkAction => 'Link kopieren';

  @override
  String get youLabel => 'Du';

  @override
  String get membersPermissionsHint =>
      'Du kannst die Rechte der Mitglieder deines Haushalts ändern – deine eigenen nicht.';

  @override
  String get householdManagementTitle => 'Haushaltsverwaltung';

  @override
  String get householdsTitle => 'Haushalte';

  @override
  String get createHouseholdTitle => 'Haushalt erstellen';

  @override
  String get householdNameLabel => 'Haushalt Name';

  @override
  String get householdPreferencesTitle => 'Haushaltskonfiguration';

  @override
  String get privateHouseholdLabel => 'Privater Haushalt';

  @override
  String get privateHouseholdHint =>
      'Wenn du deinen Haushalt auf privat stellst, werden alle Einstellungen für den öffentlichen Zugriff zurückgesetzt. Individuelle Einstellungen werden überschrieben';

  @override
  String get lockRecipeEditsLabel =>
      'Änderungen an Rezepten durch andere Haushalte sperren';

  @override
  String get lockRecipeEditsHint =>
      'Wenn aktiviert, können nur Benutzer deines Haushalts Rezepte bearbeiten, die in deinem Haushalt erstellt wurden';

  @override
  String get householdRecipePreferencesTitle => 'Haushalt Rezept-Einstellungen';

  @override
  String get groupsTitle => 'Gruppen';

  @override
  String get groupLabel => 'Gruppe';

  @override
  String get createGroupTitle => 'Gruppe anlegen';

  @override
  String get groupNameLabel => 'Name der Gruppe';

  @override
  String get groupPreferencesTitle => 'Gruppeneinstellungen';

  @override
  String get privateGroupLabel => 'Private Gruppe';

  @override
  String get privateGroupHint =>
      'Wenn du deine Gruppe auf privat stellst, werden alle Einstellungen für den öffentlichen Zugriff zurückgesetzt. Individuelle Einstellungen werden überschrieben';

  @override
  String get firstDayOfWeekLabel => 'Woche beginnt am';

  @override
  String get showAnnouncementsLabel => 'Ankündigung von Mealie anzeigen';

  @override
  String get recipePublicDefaultLabel =>
      'Erlaube Benutzern außerhalb deiner Gruppe deine Rezepte zu sehen';

  @override
  String get recipeShowNutritionDefaultLabel => 'Nährwerttabelle anzeigen';

  @override
  String get recipeShowAssetsDefaultLabel => 'Rezept-Anhänge anzeigen';

  @override
  String get recipeLandscapeDefaultLabel => 'Querformat voreingestellt';

  @override
  String get recipeDisableCommentsDefaultLabel =>
      'Kommentieren von Rezepten deaktivieren';

  @override
  String get myHouseholdSection => 'Mein Haushalt';

  @override
  String get myGroupSection => 'Meine Gruppe';

  @override
  String get preferencesSaved => 'Einstellungen gespeichert';

  @override
  String get cannotDeleteWithUsers =>
      'Enthält noch Benutzer – verschiebe oder lösche sie zuerst in der Benutzerverwaltung.';

  @override
  String deleteHouseholdConfirm(String name) {
    return 'Haushalt „$name“ löschen?';
  }

  @override
  String deleteGroupConfirm(String name) {
    return 'Gruppe „$name“ löschen?';
  }

  @override
  String usersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Benutzer',
      one: '1 Benutzer',
      zero: 'Keine Benutzer',
    );
    return '$_temp0';
  }

  @override
  String get originalUrlLabel => 'Ursprüngliche URL';

  @override
  String get copyTextAction => 'Text kopieren';

  @override
  String get copiedToClipboard => 'In die Zwischenablage kopiert';

  @override
  String get changelogEnglishHint =>
      'Die Neuerungen gibt es nur auf Englisch – mit „Text kopieren“ kannst du sie z. B. in einen Übersetzer einfügen.';

  @override
  String get favoritesTitle => 'Favoriten';

  @override
  String get favoritesEmpty =>
      'Noch keine Favoriten. Tippe im Rezept auf das Herz, um es hier zu sammeln.';

  @override
  String get changelogTitle => 'Changelog';

  @override
  String get changeProfileImage => 'Profilbild ändern';

  @override
  String get profileImageUpdated => 'Profilbild aktualisiert';

  @override
  String get profileImageFailed => 'Profilbild konnte nicht hochgeladen werden';

  @override
  String get myAccountTitle => 'Mein Konto';

  @override
  String get ownAccountHint =>
      'Hier kannst du dein eigenes Konto bearbeiten. Andere Benutzer verwalten Administratoren und Mitglieder mit dem Recht „Verwalten\".';

  @override
  String get changePasswordAction => 'Passwort ändern';

  @override
  String get currentPasswordLabel => 'Aktuelles Passwort';

  @override
  String get newPasswordLabel => 'Neues Passwort';

  @override
  String get confirmPasswordLabel => 'Passwort bestätigen';

  @override
  String get passwordTooShort => 'Mindestens 8 Zeichen';

  @override
  String get passwordsDoNotMatch => 'Die Passwörter stimmen nicht überein';

  @override
  String get passwordUpdated => 'Passwort aktualisiert';

  @override
  String get passwordChangeFailed => 'Passwort konnte nicht geändert werden';

  @override
  String passwordManagedExternally(String method) {
    return 'Du meldest dich über $method an — dein Passwort änderst du dort.';
  }

  @override
  String get bulkAddHint => 'Eine Zeile pro Eintrag.';

  @override
  String bulkAddCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Einträge hinzufügen',
      one: '1 Eintrag hinzufügen',
    );
    return '$_temp0';
  }

  @override
  String get linkRecipeAction => 'Rezept verknüpfen';

  @override
  String get useFoodAction => 'Lebensmittel statt Rezept';

  @override
  String get addSubstitutionsAction => 'Alternativen hinzufügen';

  @override
  String get clearSubstitutionsAction => 'Alternativen entfernen';

  @override
  String get recipeSubstitutionsTitle => 'Alternativen';

  @override
  String get substitutionUnknownFood =>
      'Nur vorhandene Lebensmittel – sonst die Notiz nutzen';

  @override
  String get insertAboveAction => 'Darüber einfügen';

  @override
  String get insertBelowAction => 'Darunter einfügen';

  @override
  String get moveToTopAction => 'Ganz nach oben';

  @override
  String get moveToBottomAction => 'Ganz nach unten';

  @override
  String get linkReferencesAction => 'Verknüpfen';

  @override
  String get editMarkdownAction => 'Markdown bearbeiten';

  @override
  String get previewMarkdownAction => 'Markdown Vorschau';

  @override
  String get insertStepImageAction => 'Bild hochladen';

  @override
  String get mergeAboveAction => 'Mit Eintrag darüber zusammenführen';

  @override
  String get linkedToOtherStep => 'In anderem Schritt verlinkt';

  @override
  String get noNotesToLink => 'Keine Notizen zum Verknüpfen';

  @override
  String get ownerLabel => 'Besitzer';

  @override
  String get ingredientParserTitle => 'Zutaten-Parser';

  @override
  String ingredientParserHint(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count Zutaten sind noch nicht strukturiert. Parser wählen, Ergebnis prüfen, übernehmen.',
      one:
          '1 Zutat ist noch nicht strukturiert. Parser wählen, Ergebnis prüfen, übernehmen.',
    );
    return '$_temp0';
  }

  @override
  String get parserNlp => 'Natürliche Sprachverarbeitung';

  @override
  String get parserBrute => 'Brute-Parser';

  @override
  String get parserOpenai => 'OpenAI-Parser';

  @override
  String get parserApp => 'Offline (App)';

  @override
  String get parseFailed => 'Parsen fehlgeschlagen';

  @override
  String get parseAction => 'Parsen';

  @override
  String applyParsedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Zutaten übernehmen',
      one: '1 Zutat übernehmen',
      zero: 'Nichts ausgewählt',
    );
    return '$_temp0';
  }

  @override
  String get parsedNewBadge => 'neu';

  @override
  String get hoursShort => 'Std.';

  @override
  String get minutesShort => 'Min.';

  @override
  String get timeExtraHint => 'Zusatz, z. B. „plus über Nacht\"';

  @override
  String get yieldLabel => 'Portionsangabe';

  @override
  String get yieldTextLabel => 'Ergibt Text';

  @override
  String get prepTimeLabel => 'Vorbereitung';

  @override
  String get performTimeLabel => 'Kochzeit';

  @override
  String get totalTimeLabel => 'Gesamtzeit';

  @override
  String get settingPublicRecipe => 'Öffentliches Rezept';

  @override
  String get settingShowNutrition => 'Nährwerte anzeigen';

  @override
  String get settingShowAssets => 'Anhänge anzeigen';

  @override
  String get settingLandscapeView => 'Querformat';

  @override
  String get settingDisableComments => 'Kommentare deaktivieren';

  @override
  String get settingDisableAmount => 'Zutatenmengen deaktivieren';

  @override
  String get settingLocked => 'Gesperrt';

  @override
  String get settingLockedOwnerOnly =>
      'Nur der Ersteller kann das Rezept sperren oder entsperren.';

  @override
  String get apiExtrasTitle => 'API-Extras';

  @override
  String get apiExtrasHint =>
      'Eigene Schlüssel/Wert-Paare für Drittanbieter-Anwendungen, z. B. um Automatisierungen auszulösen.';

  @override
  String get extraKeyLabel => 'Schlüssel';

  @override
  String get extraValueLabel => 'Wert';

  @override
  String get addExtraAction => 'Extra hinzufügen';

  @override
  String durationHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Stunden',
      one: '1 Stunde',
    );
    return '$_temp0';
  }

  @override
  String durationMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Minuten',
      one: '1 Minute',
    );
    return '$_temp0';
  }

  @override
  String get discardChangesConfirm => 'Ungespeicherte Änderungen verwerfen?';

  @override
  String get discardChanges => 'Änderungen verwerfen';

  @override
  String get imageFromUrl => 'Bild aus URL';

  @override
  String get deleteRecipeImage => 'Rezeptbild löschen';

  @override
  String get deleteRecipeImageConfirm =>
      'Bist du dir sicher, dass du dieses Rezeptbild löschen möchtest?';

  @override
  String get bulkAddIngredients => 'Mehrere Zutaten hinzufügen';

  @override
  String get bulkAddSteps => 'Mehrere Schritte hinzufügen';

  @override
  String get stepImageFailed => 'Bild konnte nicht hochgeladen werden';

  @override
  String get servingsAndTimes => 'Portionen & Zeiten';

  @override
  String get recipeSettingsTitle => 'Rezepteinstellungen';

  @override
  String get jsonEditorTitle => 'JSON-Editor';

  @override
  String get jsonInvalid => 'Ungültiges JSON – bitte prüfen.';

  @override
  String get editorOfflineHint =>
      'Offline geöffnet: Speichern klappt erst mit Verbindung. Neue Mealie-Felder (z. B. Alternativen) bleiben dabei unverändert erhalten.';

  @override
  String get parseLineFailed => 'Nicht erkannt – bleibt unverändert';

  @override
  String get createManualTitle => 'Rezept manuell anlegen';

  @override
  String get createManualHint =>
      'Gib einen Namen ein – Zutaten, Schritte, Bild und alles Weitere ergänzt du danach im Rezept-Editor.';

  @override
  String get createManualButton => 'Anlegen & bearbeiten';

  @override
  String get changelogEmpty => 'Für diese Version gibt es noch keine Einträge.';

  @override
  String get finderDescription =>
      'Suche nach Rezepten basierend auf den Zutaten, die du zur Hand hast. Du kannst auch nach verfügbaren Werkzeugen filtern und eine maximale Anzahl an fehlenden Zutaten oder Werkzeugen festlegen.';

  @override
  String get finderSelectedIngredients => 'Ausgewählte Zutaten';

  @override
  String get finderNoIngredientsSelected => 'Keine Zutaten ausgewählt';

  @override
  String get finderMissing => 'Fehlend';

  @override
  String get finderNoRecipesFound => 'Keine Rezepte gefunden';

  @override
  String get finderNoRecipesFoundDescription =>
      'Versuche mehr Zutaten zu deiner Suche hinzuzufügen oder deine Filter anzupassen';

  @override
  String get finderIncludeFoodsOnHand => 'Zutaten zu Hand einbeziehen';

  @override
  String get finderIncludeToolsOnHand => 'Utensilien zur Hand einbeziehen';

  @override
  String get finderIncludeSubstitutions => 'Alternativen einbeziehen';

  @override
  String get finderSubstituting => 'Ersetzt';

  @override
  String finderSubstituteForFood(String substitute, String food) {
    return '$substitute statt $food';
  }

  @override
  String get finderMaxMissingIngredients => 'Maximal fehlende Zutaten';

  @override
  String get finderMaxMissingTools => 'Maximal fehlende Utensilien';

  @override
  String get finderSelectedTools => 'Ausgewählte Utensilien';

  @override
  String get finderReadyToMake => 'Bereit zu Machen';

  @override
  String get finderAlmostReadyToMake => 'Fast bereit zu Machen';

  @override
  String get finderSettings => 'Einstellungen';

  @override
  String get finderLoadingRecipes => 'Lade Rezepte';

  @override
  String get finderClearSelection => 'Auswahl aufheben';

  @override
  String get finderOfflineHint =>
      'Keine Verbindung zum Server – die Ergebnisse stammen aus den auf diesem Gerät gespeicherten Rezepten.';

  @override
  String addIngredientsSkippedOnHand(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Zur Einkaufsliste hinzugefügt – $count vorrätige Zutaten wurden übersprungen.',
      one:
          'Zur Einkaufsliste hinzugefügt – 1 vorrätige Zutat wurde übersprungen.',
    );
    return '$_temp0';
  }

  @override
  String get sendPeerOfflineHint =>
      'Gerade nicht erreichbar – kommt an, sobald dort die App geöffnet wird';

  @override
  String sendDeliveredLater(String device) {
    return '„$device“ ist gerade nicht erreichbar. Das Rezept kommt an, sobald dort die App geöffnet wird.';
  }

  @override
  String get sendQueuedOffline =>
      'Gerade keine Verbindung. Das Rezept wird automatisch gesendet, sobald du wieder online bist.';

  @override
  String get searchHasAll => 'Alle enthalten';

  @override
  String get searchHasAny => 'Irgendeines enthalten';

  @override
  String get recipeFilterTitle => 'Filter';

  @override
  String get finderOtherFilters => 'Andere Filter';

  @override
  String get qfOpEquals => 'ist gleich';

  @override
  String get qfOpNotEquals => 'ist ungleich';

  @override
  String get qfOpGreater => 'ist größer als';

  @override
  String get qfOpGreaterEq => 'ist größer gleich';

  @override
  String get qfOpLess => 'ist weniger als';

  @override
  String get qfOpLessEq => 'ist kleiner gleich';

  @override
  String get qfOpNewerThan => 'Ist neuer als';

  @override
  String get qfOpOlderThan => 'Ist älter als';

  @override
  String qfDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'vor $count Tagen',
      one: 'vor 1 Tag',
    );
    return '$_temp0';
  }

  @override
  String get filterResetAll => 'Alle Filter zurücksetzen';

  @override
  String get filterAny => 'Alle';

  @override
  String get filterOfflineIgnored =>
      'Offline lassen sich die „Anderen Filter“ nur in ihrer einfachen Form anwenden.';

  @override
  String linkedRecipesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count verknüpfte Rezepte',
      one: 'Ein verknüpftes Rezept',
      zero: 'Kein verknüpftes Rezept',
    );
    return '$_temp0';
  }

  @override
  String get shoppingReminderNotificationsOff =>
      'Mitteilungen sind für Mealie Recipes ausgeschaltet — ohne sie kann die Einkaufserinnerung nicht erscheinen. Bitte in den Einstellungen erlauben.';

  @override
  String get shoppingReminderInactiveHint =>
      'Die Einkaufserinnerung kann gerade nicht funktionieren: Bitte Standortzugriff auf „Immer“ stellen und Mitteilungen erlauben.';

  @override
  String get bulkImportTitle => 'URL Massenimport';

  @override
  String get bulkImportDescription =>
      'Mit dem Massenimport kannst du mehrere Rezepte auf einmal importieren, indem die Webseiten nacheinander im Hintergrund bearbeitet werden. Das kann sinnvoll sein, wenn du Mealie erstmalig einrichtest oder wenn du eine große Zahl von Rezepten importieren möchtest.';

  @override
  String get bulkAddTitle => 'Mehrere hinzufügen';

  @override
  String get bulkImportSetOrganizers => 'Kategorien und Schlagwörter festlegen';

  @override
  String get bulkImportStarted => 'Massenimport wurde gestartet';

  @override
  String get bulkImportFailed => 'Massenimport fehlgeschlagen';

  @override
  String get bulkImportReports => 'Massenimporte';

  @override
  String get bulkImportUrlHint => 'Rezept URL';

  @override
  String get migrationsTitle => 'Datenmigration';

  @override
  String get migrationsDescription =>
      'Rezepte können aus anderen unterstützten Anwendungen zu Mealie migriert werden. So gelingt der Einstieg in Mealie ganz leicht. Das Übertragen von Daten zwischen Mealie-Instanzen ist über Sicherungen möglich, nicht über Migrationen.';

  @override
  String get migrationNew => 'Neue Migration';

  @override
  String get migrationChooseType => 'Migrationsart wählen';

  @override
  String get noFileSelected => 'Keine Datei ausgewählt';

  @override
  String migrationTagAll(String tag) {
    return 'Alle Rezepte mit Schlagwort $tag versehen';
  }

  @override
  String get migrationPrevious => 'Vorherige Migrationen';

  @override
  String get migrationMealieDescription =>
      'Mealie kann Rezepte aus einer Mealie-Version vor v1.0 importieren. Exportiere deine Rezepte aus der alten Instanz und lade die ZIP-Datei unten hoch. Hinweis: Nur Rezepte werden übernommen.';

  @override
  String get migrationChowdownDescription =>
      'Mealie unterstützt nativ das Chowdown Repository-Format. Lade das Code Repository als .zip Datei herunter und lade es unten hoch.';

  @override
  String get migrationCopyMeThatDescription =>
      'Mealie kann Rezepte aus Copy Me That importieren. Exportiere deine Rezepte im HTML-Format und lade dann unten die .zip Datei hoch.';

  @override
  String get migrationMyRecipeBoxDescription =>
      'Mealie kann Rezepte von My Recipe Box importieren. Exportiere deine Rezepte im CSV-Format und lade dann unten die .csv Datei hoch.';

  @override
  String get migrationNextcloudDescription =>
      'Nextcloud Rezepte können aus einer Zip-Datei importiert werden, die die in Nextcloud gespeicherten Daten enthält. Vergleiche die Beispiel-Ordnerstruktur unten um sicherzustellen, dass deine Rezepte importiert werden können.';

  @override
  String get migrationPaprikaDescription =>
      'Mealie kann Rezepte aus der Paprika-App importieren. Exportiere deine Rezepte in Paprika, ändere die Endung der Export-Datei in .zip und lade sie unten hoch.';

  @override
  String get migrationPlanToEatDescription =>
      'Mealie kann Rezepte von Plan to Eat importieren.';

  @override
  String get migrationRecipeKeeperDescription =>
      'Mealie kann Rezepte von Recipe Keeper importieren. Exportiere deine Rezepte im ZIP-Format und lade dann unten die .zip Datei hoch.';

  @override
  String get migrationTandoorDescription =>
      'Mealie kann Rezepte von Tandoor importieren. Exportiere deine Daten im \'Default\' Format und lade dann unten die .zip Datei hoch.';

  @override
  String get migrationCooknDescription =>
      'Mealie kann Rezepte von DVO Cook\'n X3 importieren. Exportiere ein Kochbuch oder ein Menü im \"Cook\'n\"-Format, benenne die Export-Erweiterung in .zip um, dann lade die .zip unten hoch.';

  @override
  String get reportTitle => 'Bericht';

  @override
  String get recipeDataTitle => 'Rezeptdaten';

  @override
  String get recipeDataDescription =>
      'Verwende diesen Bereich, um die mit deinen Rezepten verbundenen Daten zu verwalten. Du kannst mehrere Massenaktionen für deine Rezepte ausführen, zum Beispiel Exportieren, Löschen und Zuweisen von Kategorien.';

  @override
  String get recipeDataTagTitle => 'Rezepte verschlagworten';

  @override
  String get recipeDataCategorizeTitle => 'Rezepte kategorisieren';

  @override
  String get recipeDataSettingsTitle => 'Einstellungen aktualisieren';

  @override
  String get recipeDataExportTitle => 'Rezept exportieren';

  @override
  String get recipeDataDeleteTitle => 'Rezepte löschen';

  @override
  String recipeDataExportConfirm(int count) {
    return 'Die folgenden Rezepte ($count) werden exportiert.';
  }

  @override
  String get recipeDataExportsTitle => 'Daten Exporte';

  @override
  String get recipeDataExportsDescription =>
      'In diesem Bereich findest du die Links zu verfügbaren Exporten, die zum Herunterladen bereit sind. Diese Exporte verfallen nach einiger Zeit, deshalb lade sie herunter, solange sie noch verfügbar sind.';

  @override
  String get recipeDataPurgeExports => 'Exporte bereinigen';

  @override
  String get recipeDataPurgeConfirm =>
      'Bist du dir sicher, dass du alle exportierten Daten löschen möchtest?';

  @override
  String get recipeActionsTitle => 'Rezept-Aktionen';

  @override
  String get recipeActionNew => 'Neue Rezept-Aktion';

  @override
  String get recipeActionEdit => 'Rezept-Aktion bearbeiten';

  @override
  String get recipeActionTypeLink => 'Link';

  @override
  String get recipeActionTypePost => 'Posten';

  @override
  String get webhooksTitle => 'Webhooks';

  @override
  String get webhooksDescription =>
      'Die unten definierten Webhooks werden ausgeführt, wenn eine Mahlzeit für den Tag eingetragen ist. Zum geplanten Zeitpunkt werden die Webhooks mit den Daten aus dem für diesen Tag geplanten Rezept gesendet. Beachte, dass die Auslösung der Webhooks nicht genau ist. Die Webhooks werden in einem 5-Minuten-Intervall ausgeführt, so dass sie innerhalb von +/- 5 Minuten der geplanten Uhrzeit gesendet werden.';

  @override
  String get webhookName => 'Webhook-Name';

  @override
  String get webhookUrl => 'Webhook-URL';

  @override
  String get notifiersTitle => 'Benachrichtigungen';

  @override
  String get notifiersDescription =>
      'Richte E-Mail und Push-Benachrichtigungen ein, die bei bestimmten Ereignissen ausgelöst werden.';

  @override
  String get notifierNew => 'Neue Benachrichtigung';

  @override
  String get notifierDescription =>
      'Mealie verwendet die Apprise-Bibliothek, um Benachrichtigungen zu erzeugen. Sie bietet viele Dienste, die für Benachrichtigungen genutzt werden können. Wirf einen Blick in deren Wiki für eine ausführliche Anleitung zum Erstellen einer URL für deinen Dienst. Einige Benachrichtigungstypen können zusätzliche Funktionen enthalten.';

  @override
  String get notifierAppriseUrl => 'Apprise-URL';

  @override
  String get notifierAppriseUrlSkipped =>
      'Apprise-URL (wird übersprungen, wenn leer)';

  @override
  String get notifierAppriseUrlBlankHint =>
      'Da Apprise-URLs normalerweise sensible Informationen enthalten, wird dieses Feld während der Bearbeitung absichtlich leer gelassen. Wenn du die URL aktualisieren möchtest, gib hier die neue ein. Andernfalls lasse diese leer, um die aktuelle URL zu behalten.';

  @override
  String get notifierEnable => 'Benachrichtigen aktivieren';

  @override
  String get notifierWhatEvents =>
      'Welche Ereignisse soll diese Benachrichtigung abonnieren?';

  @override
  String get notifierRecipeEvents => 'Rezept-Ereignisse';

  @override
  String get notifierUserEvents => 'Benutzer-Ereignisse';

  @override
  String get notifierMealplanEvents => 'Essensplan-Ereignisse';

  @override
  String get notifierShoppingListEvents => 'Einkaufslisten-Ereignisse';

  @override
  String get notifierCookbookEvents => 'Kochbuch-Ereignisse';

  @override
  String get notifierTagEvents => 'Schlagwort-Ereignisse';

  @override
  String get notifierCategoryEvents => 'Kategorie-Ereignisse';

  @override
  String get notifierLabelEvents => 'Bezeichnungs-Ereignisse';

  @override
  String get notifierUserSignup =>
      'Wenn ein neuer Benutzer deiner Gruppe beitritt';

  @override
  String get notifierCreate => 'Erstellen';

  @override
  String get notifierUpdate => 'Aktualisieren';

  @override
  String get notifierDelete => 'Löschen';

  @override
  String get notifierTestSent => 'Testnachricht gesendet';

  @override
  String get adminTitle => 'Admin Einstellungen';

  @override
  String get backupsTitle => 'Sicherungen';

  @override
  String get backupsDescription =>
      'Backups sind vollständige Schnappschüsse der Datenbank und des Datenverzeichnisses der Website. Darin sind sämtliche Daten enthalten, es können keine Teile von Daten ausgeschlossen werden. Es ist wie ein Schnappschuss von Mealie zu einem bestimmten Zeitpunkt. Es handelt sich um eine von der Datenbank unabhängige Möglichkeit, Daten zu exportieren und zu importieren oder die Webseite an einem externen Ort zu sichern.';

  @override
  String get backupCreateHeading => 'Sicherung erstellen';

  @override
  String get backupCreated => 'Sicherung erfolgreich erstellt';

  @override
  String get backupCreateFailed =>
      'Fehler beim Erstellen der Sicherung. Siehe Protokolldatei';

  @override
  String get backupDelete => 'Sicherung löschen';

  @override
  String get backupDeleted => 'Sicherung gelöscht';

  @override
  String get backupRestore => 'Sicherung wiederherstellen';

  @override
  String get backupRestoreDescription =>
      'Das Wiederherstellen dieser Sicherung wird alle vorhandenen Daten in deiner Datenbank und im Datenverzeichnis überschreiben und durch den Inhalt dieser Sicherung ersetzen. Wenn die Wiederherstellung erfolgreich war, wirst du abgemeldet.';

  @override
  String get backupCannotBeUndone =>
      'Diese Aktion kann nicht rückgängig gemacht werden - verwende sie mit Vorsicht.';

  @override
  String get backupAcknowledge =>
      'Ich verstehe, dass diese Maßnahme unumkehrbar und destruktiv ist und Datenverlust verursachen kann';

  @override
  String get backupRestoreSuccess => 'Wiederherstellung erfolgreich';

  @override
  String get backupRestoreFailed =>
      'Wiederherstellung fehlgeschlagen. Überprüfe deine Serverprotokolle für weitere Informationen';

  @override
  String get maintenanceTitle => 'Wartung';

  @override
  String get maintenanceSummary => 'Zusammenfassung';

  @override
  String get maintenanceStorage => 'Speicherdetails';

  @override
  String get maintenanceDataDirSize => 'Datenverzeichnisgröße';

  @override
  String get maintenanceCleanableDirs => 'Löschbare Verzeichnisse';

  @override
  String get maintenanceCleanableImages => 'Löschbare Bilder';

  @override
  String get maintenanceTempDir => 'Temporäres Verzeichnis (.temp)';

  @override
  String get maintenanceBackupsDir => 'Sicherungen-Verzeichnis (backups)';

  @override
  String get maintenanceGroupsDir => 'Gruppen-Verzeichnis (groups)';

  @override
  String get maintenanceRecipesDir => 'Rezept-Verzeichnis (recipes)';

  @override
  String get maintenanceUserDir => 'Benutzer-Verzeichnis (user)';

  @override
  String get maintenanceCleanDirs => 'Verzeichnisse bereinigen';

  @override
  String get maintenanceCleanDirsDescription =>
      'Entfernt alle Rezeptordner mit ungültigen UUIDs';

  @override
  String get maintenanceCleanTemp => 'Temporäre Daten bereinigen';

  @override
  String get maintenanceCleanTempDescription =>
      'Entfernt alle Dateien und Ordner im .temp-Verzeichnis';

  @override
  String get maintenanceCleanImages => 'Bilder bereinigen';

  @override
  String get maintenanceCleanImagesDescription =>
      'Entfernt alle Bilder, die nicht mit .webp enden';

  @override
  String get maintenanceActions => 'Aktionen';

  @override
  String get adminConfiguration => 'Konfiguration';

  @override
  String get adminAppVersion => 'Programmversion';

  @override
  String get adminUpToDate => 'Mealie ist auf dem neuesten Stand';

  @override
  String adminVersionOutdated(String current, String latest) {
    return 'Deine derzeitige Version ($current) stimmt nicht mit der neuesten Version überein. Prüfe, ob du auf die neueste Version ($latest) aktualisieren solltest.';
  }

  @override
  String get adminBaseUrl => 'Serverseitige Basis-URL';

  @override
  String get adminBaseUrlOk =>
      'Serverseitige URL entspricht nicht der Standardeinstellung';

  @override
  String get adminBaseUrlError =>
      '`BASE_URL` ist immer noch der Standardwert auf dem API-Server. Das verursacht Probleme mit Benachrichtigungslinks auf dem Server für E-Mails, etc.';

  @override
  String adminAuthReady(String provider) {
    return '$provider bereit';
  }

  @override
  String adminAuthNotReady(String provider) {
    return '$provider ist nicht bereit';
  }

  @override
  String adminAuthDisabled(String provider) {
    return '$provider deaktiviert';
  }

  @override
  String adminAuthSuccessText(String provider) {
    return 'Alle erforderlichen $provider-Variablen sind hinterlegt.';
  }

  @override
  String adminAuthErrorText(String provider) {
    return 'Es sind nicht alle $provider-Werte konfiguriert. Wenn du keine $provider-Authentifizierung benutzt, kannst du das ignorieren.';
  }

  @override
  String adminAuthDisabledText(String envVar) {
    return 'Zum aktivieren, setze $envVar auf true.';
  }

  @override
  String get adminEmailStatus => 'E-Mail Konfigurationsstatus';

  @override
  String get adminEmailConfigured => 'E-Mail konfiguriert';

  @override
  String get adminNotReady => 'Nicht bereit - bitte Konfiguration überprüfen';

  @override
  String get adminSucceeded => 'Erfolgreich';

  @override
  String get adminFailed => 'Fehlgeschlagen';

  @override
  String get adminSiteStatistics => 'Seitenstatistiken';

  @override
  String get adminUncategorized => 'Unkategorisierte Rezepte';

  @override
  String get adminUntagged => 'Rezepte ohne Tag';

  @override
  String get adminGeneralAbout => 'Allgemeine Informationen';

  @override
  String get adminVersion => 'Version';

  @override
  String get adminBuild => 'Build';

  @override
  String get adminApplicationMode => 'Anwendungsmodus';

  @override
  String get adminProduction => 'Produktivumgebung';

  @override
  String get adminDevelopment => 'Entwicklung';

  @override
  String get adminDemoStatus => 'Demostatus';

  @override
  String get adminDemo => 'Demo';

  @override
  String get adminNotDemo => 'Keine Demo';

  @override
  String get adminApiPort => 'API-Port';

  @override
  String get adminApiDocs => 'API Dokumentation';

  @override
  String get adminDatabaseType => 'Datenbanktyp';

  @override
  String get adminDatabaseUrl => 'Datenbank-URL';

  @override
  String get adminDefaultGroup => 'Standardgruppe';

  @override
  String get adminDefaultHousehold => 'Standardhaushalt';

  @override
  String get adminScraperVersion => 'Rezept Scraper Version';

  @override
  String get adminStatUsers => 'Benutzer';

  @override
  String get adminStatHouseholds => 'Haushalte';

  @override
  String get adminStatGroups => 'Gruppen';

  @override
  String get recipeDuplicate => 'Rezept duplizieren';

  @override
  String get recipeDuplicateAction => 'Duplizieren';

  @override
  String get recipeShareLink => 'Rezept teilen';

  @override
  String get recipeShareExpiration => 'Ablaufdatum';

  @override
  String get recipeShareCopied => 'Rezept-Link in Zwischenablage kopiert';

  @override
  String get enabledLabel => 'Aktiviert';

  @override
  String get disabledLabel => 'Deaktiviert';

  @override
  String get testAction => 'Testen';

  @override
  String get yesLabel => 'Ja';

  @override
  String get noLabel => 'Nein';

  @override
  String get downloadAction => 'Herunterladen';

  @override
  String get backupUpload => 'Hochladen';

  @override
  String get zipImportButton => 'Von Zip importieren';

  @override
  String get zipImportDescription =>
      'Importiere ein einzelnes Rezept, das von einer anderen Mealie-Instanz exportiert wurde.';

  @override
  String get reportStatus => 'Status';

  @override
  String get reportDate => 'Datum';

  @override
  String get recipeActionTitleLabel => 'Titel';

  @override
  String get clearAll => 'Zurücksetzen';

  @override
  String get recipeDataSettingsExplanation =>
      'Die hier gewählten Einstellungen, außer der gesperrten Option, werden auf alle ausgewählten Rezepte angewendet.';

  @override
  String get adminAllowSignup => 'Registrierung erlaubt';

  @override
  String get adminAllowPasswordLogin => 'Anmeldung mit Passwort erlaubt';

  @override
  String get adminEmailInvalid => 'Bitte eine gültige E-Mail-Adresse eingeben.';

  @override
  String adminEmailTestResult(String result) {
    return 'E-Mail-Test: $result';
  }

  @override
  String get adminSendTestEmail => 'Test-E-Mail senden';

  @override
  String get adminTestEmailAddress => 'Empfänger';

  @override
  String get backupCreate => 'Sicherung erstellen';

  @override
  String backupDeleteConfirm(String name) {
    return 'Sicherung „$name\" löschen?';
  }

  @override
  String get backupPostgresNote =>
      'Wenn du PostgreSQL verwendest, lies bitte vor dem Wiederherstellen den Sicherungs-/Wiederherstellungsprozess in der Mealie-Dokumentation.';

  @override
  String get backupUploaded => 'Sicherung hochgeladen';

  @override
  String get backupsEmpty => 'Noch keine Sicherungen.';

  @override
  String get bulkImportAddRow => 'URL hinzufügen';

  @override
  String get bulkImportStart => 'Import starten';

  @override
  String get chooseFileButton => 'Datei wählen';

  @override
  String get deselectAllAction => 'Auswahl aufheben';

  @override
  String get downloadFailed => 'Herunterladen fehlgeschlagen';

  @override
  String get fileSaved => 'Datei gespeichert';

  @override
  String get loadFailed => 'Laden fehlgeschlagen';

  @override
  String get maintenanceActionsWarning =>
      'Wartungsaktionen sind destruktiv und sollten mit Vorsicht verwendet werden. Jede dieser Aktionen ist unumkehrbar.';

  @override
  String get maintenanceConfirm =>
      'Diese Aktion ist destruktiv und kann nicht rückgängig gemacht werden. Fortfahren?';

  @override
  String get maintenanceDone => 'Erledigt';

  @override
  String get maintenanceFailed => 'Wartungsaktion fehlgeschlagen';

  @override
  String get maintenanceRun => 'Ausführen';

  @override
  String get migrationFailed => 'Migration fehlgeschlagen';

  @override
  String get migrationStart => 'Migration starten';

  @override
  String get migrationStarted =>
      'Migration abgeschlossen – siehe Bericht unten.';

  @override
  String get moreImportOptions => 'Weitere Importwege';

  @override
  String notifierDeleteConfirm(String name) {
    return 'Benachrichtigung „$name\" löschen?';
  }

  @override
  String get notifierEdit => 'Benachrichtigung bearbeiten';

  @override
  String notifierEventCount(int count) {
    return 'Ereignisse: $count';
  }

  @override
  String get notifierTestFailed => 'Testnachricht konnte nicht gesendet werden';

  @override
  String get notifiersEmpty => 'Noch keine Benachrichtigungen.';

  @override
  String recipeActionDeleteConfirm(String name) {
    return 'Rezept-Aktion „$name\" löschen?';
  }

  @override
  String get recipeActionFailed => 'Rezept-Aktion fehlgeschlagen';

  @override
  String get recipeActionSent => 'Rezept gesendet';

  @override
  String get recipeActionUrlHint => 'Platzhalter';

  @override
  String get recipeActionsDescription =>
      'Rezept-Aktionen erscheinen im Menü jedes Rezepts. „Link\" öffnet die URL, „Posten\" lässt den Mealie-Server das Rezept an die URL senden.';

  @override
  String get recipeActionsEmpty => 'Noch keine Rezept-Aktionen.';

  @override
  String recipeDataDeleteConfirm(int count) {
    return 'Ausgewählte Rezepte ($count) löschen? Das kann nicht rückgängig gemacht werden.';
  }

  @override
  String recipeDataDeleteForbidden(int count) {
    return 'Du darfst $count der ausgewählten Rezepte nicht löschen (nur Ersteller oder Admins).';
  }

  @override
  String recipeDataDeleted(int count) {
    return 'Rezepte gelöscht: $count';
  }

  @override
  String get recipeDataExportAction => 'Exportieren';

  @override
  String get recipeDataExportDone =>
      'Export erstellt – unter „Daten Exporte\" herunterladen.';

  @override
  String recipeDataExportExpires(String date) {
    return 'läuft ab $date';
  }

  @override
  String get recipeDataExportFailed => 'Export fehlgeschlagen';

  @override
  String get recipeDataExportsEmpty => 'Keine Exporte vorhanden.';

  @override
  String recipeDataUpdated(int count) {
    return 'Rezepte aktualisiert: $count';
  }

  @override
  String get recipeDuplicated => 'Rezept dupliziert';

  @override
  String get recipeExportJson => 'Als JSON exportieren';

  @override
  String get recipeExportZip => 'Als ZIP exportieren (mit Bild)';

  @override
  String get recipeShareCreate => 'Link erstellen';

  @override
  String get recipeShareDescription =>
      'Jeder mit dem Link kann dieses Rezept im Browser ansehen – ohne Konto – bis er abläuft.';

  @override
  String get recipeShareEmpty => 'Noch keine Freigabe-Links.';

  @override
  String recipeShareExpiresAt(String date) {
    return 'Läuft ab $date';
  }

  @override
  String get recipeWebToolsMenu => 'Duplizieren, Freigabe-Link & mehr';

  @override
  String get reload => 'Neu laden';

  @override
  String get reportDeleteConfirm => 'Diesen Bericht löschen?';

  @override
  String get reportEntries => 'Einträge';

  @override
  String get reportFailedEntries => 'Fehlgeschlagen';

  @override
  String get reportOnlyFailed => 'Nur fehlgeschlagene Einträge zeigen';

  @override
  String get reportStatusFailure => 'Fehlgeschlagen';

  @override
  String get reportStatusInProgress => 'Läuft';

  @override
  String get reportStatusPartial => 'Teilweise';

  @override
  String get reportStatusSuccess => 'Erfolgreich';

  @override
  String get reportsEmpty => 'Noch keine Berichte.';

  @override
  String get uploadFailed => 'Hochladen fehlgeschlagen';

  @override
  String webhookDeleteConfirm(String name) {
    return 'Webhook „$name\" löschen?';
  }

  @override
  String get webhookEdit => 'Webhook bearbeiten';

  @override
  String get webhookNew => 'Neuer Webhook';

  @override
  String get webhookTestFailed => 'Test konnte nicht gestartet werden';

  @override
  String get webhookTestSent => 'Test-Webhook ausgelöst';

  @override
  String get webhookTime => 'Uhrzeit (Ortszeit)';

  @override
  String get webhooksEmpty => 'Noch keine Webhooks.';

  @override
  String get zipImportFailed => 'ZIP-Import fehlgeschlagen';

  @override
  String get aiProvidersTitle => 'KI-Anbieter';

  @override
  String get aiProvidersDescription =>
      'Konfiguriere KI-Anbieter, um KI-basierte Funktionen wie das verbesserte Parsen von Zutaten, das Erstellen von Rezepten aus Videos und vieles mehr zu aktivieren!';

  @override
  String get aiProviderSettingsTitle => 'KI-Anbieter-Einstellungen';

  @override
  String get aiProvidersList => 'Anbieter';

  @override
  String get aiProviderCreate => 'Anbieter erstellen';

  @override
  String get aiProviderEdit => 'Anbieter bearbeiten';

  @override
  String get aiDefaultProvider => 'Standard-Anbieter';

  @override
  String get aiDefaultProviderDescription =>
      'Zum Aktivieren der KI-Funktionen erforderlich';

  @override
  String get aiAudioProvider => 'Audio-Anbieter';

  @override
  String get aiAudioProviderDescription =>
      'Aktiviert Spracherkennungsfunktionen, um Rezepte aus Videos zu erstellen';

  @override
  String get aiImageProvider => 'Bildanbieter';

  @override
  String get aiImageProviderDescription =>
      'Aktiviert Bilderkennungsfunktionen, wie das Erstellen von Rezepten aus Bildern';

  @override
  String get aiProviderName => 'Anbietername';

  @override
  String get aiApiKey => 'API-Key';

  @override
  String get aiApiKeyCreateDescription =>
      'Der API-Schlüssel deines Anbieters zur Authentifizierung. Wenn der Dienst (z.B. Ollama) keinen API-Schlüssel verwendet, musst du hier trotzdem etwas eintragen.';

  @override
  String get aiApiKeyEditDescription =>
      'Lass dieses Feld leer, wenn du ihn nicht ändern möchtest.';

  @override
  String get aiBaseUrl => 'Basis-URL';

  @override
  String get aiBaseUrlDescription =>
      'Wenn du OpenAI verwendest, lasse dies leer. Muss ein OpenAI-kompatibler Endpunkt sein (z.B. \"http://localhost:11434/v1\").';

  @override
  String get aiModel => 'Modell';

  @override
  String get aiModelDescription =>
      'Welches Modell dein KI-Anbieter verwenden soll (z.B. \"gpt-5\").';

  @override
  String get aiTimeout => 'Anfrage-Timeout (Sekunden)';

  @override
  String get aiProviderCreated => 'Anbieter erstellt';

  @override
  String get aiProviderUpdated => 'Anbieter aktualisiert';

  @override
  String get aiProviderDeleted => 'Anbieter gelöscht';

  @override
  String get aiProviderCreateFailed => 'Anbieter konnte nicht erstellt werden';

  @override
  String get aiProviderUpdateFailed =>
      'Anbieter konnte nicht aktualisiert werden';

  @override
  String get aiProviderDeleteFailed => 'Anbieter konnte nicht gelöscht werden';

  @override
  String get aiRequestHeaders => 'Anfrage-Header';

  @override
  String get aiRequestParams => 'Anfrageparameter';

  @override
  String get aiNoDefaultWarning =>
      'Du hast keinen Standard-Anbieter festgelegt, daher sind die KI-Funktionen deaktiviert.';

  @override
  String get aiTestConnection => 'Verbindung testen';

  @override
  String get aiTestSucceeded => 'Verbindung erfolgreich';

  @override
  String get aiTestFailed => 'Verbindung fehlgeschlagen';

  @override
  String get aiSupportsImages => 'Unterstützt Bilder';

  @override
  String get aiTextOnly => 'Nur Text – kann nicht dein Bildanbieter sein';

  @override
  String get debugAiTitle => 'KI-Anbieter debuggen';

  @override
  String get debugAiDescription =>
      'Benutze diese Seite, um KI-Anbieter zu debuggen. Du kannst deine KI-Verbindung testen und die Ergebnisse hier sehen. Wenn du Bilddienste aktiviert hast, kannst du auch ein Bild angeben.';

  @override
  String get debugParserTitle => 'Zutaten-Parser';

  @override
  String get debugParserDescription =>
      'Mealie verwendet Conditional Random Fields (CRFs), um Zutaten zu analysieren und zu verarbeiten. Das für Zutaten verwendete Modell basiert auf über 100.000 Zutaten aus einem von der New York Times zusammengestellten Datensatz. Beachte, dass das Modell nur in Englisch trainiert wurde, deshalb können die Ergebnisse bei der Verwendung anderer Sprachen abweichen. Diese Seite ist eine Spielwiese zum Testen des Modells.';

  @override
  String get debugIngredientText => 'Zutaten-Angabe';

  @override
  String get debugTryExample => 'Probier ein Beispiel aus';

  @override
  String debugAverageConfidence(String value) {
    return '$value zuverlässig';
  }

  @override
  String get debugRunTest => 'Test durchführen';

  @override
  String get debugQuantity => 'Menge';

  @override
  String get debugUnit => 'Maßeinheit';

  @override
  String get debugFood => 'Lebensmittel';

  @override
  String get debugNote => 'Kommentar';

  @override
  String get debugGroup => 'Gruppe';

  @override
  String get aiProviderNone => 'Keiner';

  @override
  String aiProviderDeleteConfirm(String name) {
    return 'Anbieter „$name\" löschen?';
  }

  @override
  String get aiProvidersEmpty => 'Noch keine KI-Anbieter.';

  @override
  String get aiAdvanced => 'Erweitert';

  @override
  String get aiKeyLabel => 'Name';

  @override
  String get aiValueLabel => 'Wert';

  @override
  String get debugTitle => 'Debug';

  @override
  String get debugParse => 'Analysieren';

  @override
  String get debugParseFailed => 'Zutat konnte nicht analysiert werden';

  @override
  String get debugChooseImage => 'Bild wählen';

  @override
  String get debugNoImage => 'Kein Bild (optional)';

  @override
  String get updateTitle => 'Nach Updates suchen';

  @override
  String get updateInstalledVersion => 'Installierte Version';

  @override
  String get updateLastCheck => 'Zuletzt geprüft';

  @override
  String get updateCheckNow => 'Jetzt prüfen';

  @override
  String get updateChecking => 'Suche nach Updates …';

  @override
  String get updateUpToDate => 'Mealie Recipes ist auf dem neuesten Stand.';

  @override
  String updateAvailable(String version) {
    return 'Version $version ist verfügbar';
  }

  @override
  String get updateAvailableDescription =>
      'Eine neue Version von Mealie Recipes ist verfügbar. Installiert wird erst, wenn du das Update selbst startest.';

  @override
  String get updateShow => 'Update ansehen';

  @override
  String get updateLater => 'Später';

  @override
  String updateDownloading(int percent) {
    return 'Wird heruntergeladen … $percent %';
  }

  @override
  String updateReady(String version) {
    return 'Version $version ist bereit zur Installation';
  }

  @override
  String get updateInstalling =>
      'Wird installiert – die App startet gleich neu …';

  @override
  String get updateManual =>
      'Das Update konnte nicht automatisch installiert werden. Das Disk-Image wurde geöffnet: Ziehe Mealie Recipes in „Programme\".';

  @override
  String get updateFailed => 'Update fehlgeschlagen';

  @override
  String get updateInstallNow => 'Herunterladen & installieren';

  @override
  String get updateRestartNow => 'Installieren & neu starten';

  @override
  String get updateAutoTitle => 'Beim Start nach Updates suchen';

  @override
  String get updateAutoDescription =>
      'Prüft nur und gibt Bescheid – die Installation startest immer du.';

  @override
  String get updateNoNotes => 'Keine Versionshinweise.';

  @override
  String get updateSourceHint =>
      'Updates kommen aus den GitHub-Releases von Mealie Recipes und werden nur installiert, wenn sie vom Entwickler signiert sind (macOS).';
}
