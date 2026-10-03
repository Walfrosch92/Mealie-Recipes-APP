// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appTitle => 'Mealie Recipes';

  @override
  String get endCookingMode => 'Kookmodus beëindigen';

  @override
  String get endCookingModeConfirm => 'Wil je de kookmodus echt beëindigen?';

  @override
  String endCookingModeConfirmAll(int count) {
    return 'Hiermee worden alle $count recepten in de kookmodus beëindigd. Doorgaan?';
  }

  @override
  String get addTimer => 'Timer toevoegen';

  @override
  String get recipeFinished => 'Je gerecht is klaar.';

  @override
  String get bonAppetit => 'Eet smakelijk!';

  @override
  String get prepareIngredients => 'Bereid de volgende ingrediënten voor';

  @override
  String prepareIngredientsFor(String servings) {
    return 'Bereid de volgende ingrediënten voor $servings porties voor';
  }

  @override
  String get next => 'Volgende';

  @override
  String get navHome => 'Start';

  @override
  String get homeCookToday => 'Vandaag koken';

  @override
  String get homeSuggestion => 'Suggestie';

  @override
  String get homeQuickAccess => 'Snel toegang';

  @override
  String get homePlanned => 'Gepland';

  @override
  String get favorite => 'Favoriet';

  @override
  String get navSettings => 'Instellingen';

  @override
  String homeWelcomeName(Object name) {
    return 'Welkom $name,';
  }

  @override
  String get homeWelcomeApp => 'bij Mealie Recipes 👋';

  @override
  String get theme => 'Weergave';

  @override
  String get themeSystem => 'Systeem';

  @override
  String get themeLight => 'Licht';

  @override
  String get themeDark => 'Donker';

  @override
  String get recipes => 'Recepten';

  @override
  String get shoppingList => '🛒 Boodschappenlijst';

  @override
  String get mealplan => 'Maaltijdplan';

  @override
  String get settings => '⚙️ Instellingen';

  @override
  String get searchRecipe => 'Recept zoeken...';

  @override
  String get loadingRecipes => 'Recepten laden...';

  @override
  String get loadingRecipe => 'Recept laden...';

  @override
  String errorLoadingRecipes(String error) {
    return 'Fout bij laden: $error';
  }

  @override
  String get errorLoadingRecipe => 'Recept kon niet geladen worden.';

  @override
  String get noRecipesForCategory => 'Geen recepten voor dit filter.';

  @override
  String get resetFilter => 'Filter resetten';

  @override
  String get allCategories => 'Alle categorieën';

  @override
  String get all => 'Alle';

  @override
  String get sortRecipes => 'Recepten sorteren';

  @override
  String get refreshRecipes => 'Vernieuwen';

  @override
  String get sortNameAZ => 'Naam A–Z';

  @override
  String get sortNameZA => 'Naam Z–A';

  @override
  String get sortDateNewest => 'Nieuwste eerst';

  @override
  String get sortDateOldest => 'Oudste eerst';

  @override
  String get sortPrepTimeShort => 'Kortste bereidingstijd';

  @override
  String get sortPrepTimeLong => 'Langste bereidingstijd';

  @override
  String get sortRatingHighest => 'Hoogste beoordeling';

  @override
  String get sortRatingLowest => 'Laagste beoordeling';

  @override
  String get details => 'Details';

  @override
  String get ingredients => 'Ingrediënten';

  @override
  String get instructions => 'Instructies';

  @override
  String get tags => 'Tags';

  @override
  String get notes => 'Notities';

  @override
  String get addNote => 'Notitie toevoegen';

  @override
  String get editNote => 'Notitie bewerken';

  @override
  String get noteTitleHint => 'Titel (optioneel)';

  @override
  String get noteTextHint => 'Notitietekst';

  @override
  String get deleteNoteTitle => 'Notitie verwijderen?';

  @override
  String get deleteNoteMessage => 'Deze notitie wordt permanent verwijderd.';

  @override
  String get servings => 'Porties';

  @override
  String get adjustQuantity => 'Hoeveelheid aanpassen';

  @override
  String get startTimer => 'Timer starten';

  @override
  String runningTimer(int minutes, String seconds) {
    return 'Timer: $minutes:$seconds';
  }

  @override
  String get planMeal => 'Maaltijd plannen';

  @override
  String get displayAlwaysOn => 'Scherm altijd aan';

  @override
  String get addAllIngredients => 'Alle ingrediënten toevoegen';

  @override
  String get addSelectedIngredients => 'Geselecteerde ingrediënten toevoegen';

  @override
  String get addIngredientsTitle => 'Ingrediënten toegevoegd';

  @override
  String get addIngredientsMessage =>
      'De ingrediënten zijn aan uw boodschappenlijst toegevoegd.';

  @override
  String addIngredientsFailedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ingrediënten konden niet worden toegevoegd.',
      one: '1 ingrediënt kon niet worden toegevoegd.',
    );
    return '$_temp0';
  }

  @override
  String get cookbooks => 'Kookboeken';

  @override
  String get cookbooksEmpty =>
      'Nog geen kookboeken. Tik rechtsboven op “+” om er een te maken.';

  @override
  String get cookbookNoMatches => 'Geen recepten voldoen aan dit filter.';

  @override
  String get cookbookCreateTitle => 'Kookboek aanmaken';

  @override
  String get cookbookEditTitle => 'Kookboek bewerken';

  @override
  String get cookbookNameLabel => 'Kookboeknaam';

  @override
  String get cookbookFilterSectionTitle => 'Recepten automatisch toevoegen';

  @override
  String get cookbookFieldTools => 'Gereedschap';

  @override
  String get cookbookFieldUsers => 'Gebruikers';

  @override
  String get cookbookOpIsOneOf => 'is een van';

  @override
  String get cookbookOpIsNotOneOf => 'is geen van';

  @override
  String get cookbookOpContainsAll => 'bevat alle';

  @override
  String get cookbookSelectValues => 'Waarden selecteren';

  @override
  String get cookbookFilterOptionsUnavailable => 'Geen opties beschikbaar';

  @override
  String get cookbookAddFilterField => 'Veld toevoegen';

  @override
  String get cookbookPublicLabel => 'Openbaar kookboek';

  @override
  String get cookbookPublicSubtitle =>
      'Zichtbaar voor andere huishoudens op de server';

  @override
  String get cookbookRawModeEnter => 'Bewerken als tekst';

  @override
  String get cookbookRawModeExit => 'Terug naar bouwer';

  @override
  String get cookbookRawModeHint =>
      'Expertmodus van deze app: bewerkt het filter direct als tekst. Handig als een bestaand filter niet in eenvoudige regels kon worden opgesplitst.';

  @override
  String get cookbookRawModeUnparseable =>
      'Deze tekst past niet in het eenvoudige regelformaat — blijft als tekst behouden.';

  @override
  String get saveFailed => 'Opslaan mislukt';

  @override
  String get search => 'Zoeken';

  @override
  String get apply => 'Toepassen';

  @override
  String get setupCachingTitle => 'Recepten worden geladen';

  @override
  String get setupCachingSubtitle =>
      'Je recepten worden voorbereid voor offline gebruik. Afhankelijk van het aantal kan dit even duren.';

  @override
  String get setupCachingDone => 'Alles klaar!';

  @override
  String get setupTipsHeader => 'Wist je dat?';

  @override
  String get setupFinish => 'Aan de slag';

  @override
  String get setupSkipCaching => 'Op de achtergrond voortzetten';

  @override
  String get setupTip1 =>
      'Je kunt recepten importeren via een link, foto of PDF — met de importtegel op het startscherm.';

  @override
  String get setupTip2 =>
      'De kookmodus houdt het scherm aan, leidt je stap voor stap en herkent timers in de tekst automatisch.';

  @override
  String get setupTip3 =>
      'De boodschappenlijst werkt ook offline — wijzigingen worden automatisch gesynchroniseerd zodra de server bereikbaar is.';

  @override
  String get setupTip4 =>
      'Houd een tegel op het startscherm ingedrukt om de snelle toegang te herschikken.';

  @override
  String get setupTip5 =>
      'Je Mealie-kookboeken vind je via de kookboekentegel — ook offline beschikbaar.';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Annuleren';

  @override
  String get delete => 'Verwijderen';

  @override
  String get edit => 'Bewerken';

  @override
  String get save => 'Opslaan';

  @override
  String get done => 'Klaar';

  @override
  String get close => 'Sluiten';

  @override
  String get add => 'Toevoegen';

  @override
  String get send => 'Verzenden';

  @override
  String get retry => 'Opnieuw proberen';

  @override
  String get confirmDeleteTitle => 'Recept verwijderen?';

  @override
  String get confirmDeleteMessage =>
      'Deze actie kan niet ongedaan worden gemaakt.';

  @override
  String get sendToDevice => 'Naar apparaat sturen';

  @override
  String get sendToDevicePickerTitle => 'Naar apparaat sturen';

  @override
  String get sendToAllDevices => 'Naar alle apparaten sturen';

  @override
  String get timerFinished => 'Timer afgelopen!';

  @override
  String get timerFinishedBody => 'Uw recepttimer is klaar.';

  @override
  String get timer => 'Timer';

  @override
  String get newTimer => 'Nieuwe timer';

  @override
  String get timerDetails => 'Timerdetails';

  @override
  String get timerNamePlaceholder => 'Timernaam';

  @override
  String get timerNameHint => 'Geef de timer een beschrijvende naam.';

  @override
  String get durationLabel => 'Duur';

  @override
  String minutesCount(int count) {
    return '$count minuten';
  }

  @override
  String get start => 'Starten';

  @override
  String get stop => 'Stoppen';

  @override
  String get pause => 'Pauzeren';

  @override
  String get resume => 'Hervatten';

  @override
  String get finished => 'Klaar!';

  @override
  String stepNumber(int number) {
    return 'Stap $number';
  }

  @override
  String get minAbbreviation => 'min';

  @override
  String get cookingMode => 'Kookmodus';

  @override
  String activeRecipesCount(int count) {
    return '$count actieve recepten';
  }

  @override
  String get endAll => 'Alles beëindigen';

  @override
  String get end => 'Beëindigen';

  @override
  String get endAllRecipesTitle => 'Alle recepten beëindigen?';

  @override
  String endAllRecipesMessage(int count) {
    return 'Wil je alle $count actieve kooksessies beëindigen?';
  }

  @override
  String get endRecipeTitle => 'Recept beëindigen?';

  @override
  String endRecipeMessage(String name) {
    return 'Wil je de kooksessie voor \"$name\" beëindigen?';
  }

  @override
  String get noActiveTimers => 'Geen actieve timers';

  @override
  String get noActiveRecipes => 'Geen actieve recepten';

  @override
  String get startRecipeToCook =>
      'Open een recept en tik op de kookmodus-knop.';

  @override
  String get browseRecipes => 'Recepten bladeren';

  @override
  String timersPausedCount(int count) {
    return '$count timer(s) gepauzeerd';
  }

  @override
  String get cookFriends => 'Koken met vrienden';

  @override
  String get cookingModeAddRecipe => 'Recept toevoegen';

  @override
  String get cookingModeAddRecipeSearchHint => 'Recepten zoeken';

  @override
  String get cookFriendsCode => 'Sessiecode';

  @override
  String get cookFriendsJoin => 'Sessie deelnemen';

  @override
  String get cookFriendsHost => 'Sessie hosten';

  @override
  String get cookFriendsHostNotFound =>
      'Host niet gevonden. Zorg dat beide apparaten op dezelfde wifi zitten en dat lokale netwerktoegang is toegestaan.';

  @override
  String get cookFriendsConnectionFailed =>
      'Verbinding mislukt. Probeer het opnieuw.';

  @override
  String get cookFriendsEnterCode => 'Code invoeren';

  @override
  String cookFriendsConnected(int count) {
    return 'Verbonden: $count gasten';
  }

  @override
  String get joinSession => 'Sessie deelnemen';

  @override
  String get hostEndedSessionTitle => 'Sessie beëindigd';

  @override
  String get hostEndedSessionMessage =>
      'De host heeft de kooksessie beëindigd.';

  @override
  String get shoppingListEmpty => 'Uw boodschappenlijst is leeg.';

  @override
  String get addItem => 'Artikel toevoegen';

  @override
  String get itemNote => 'Artikelnaam';

  @override
  String get unlabeledCategory => 'Zonder categorie';

  @override
  String get reorderCategories => 'Categorieën herordenen';

  @override
  String get archiveChecked => 'Aangevinkte archiveren';

  @override
  String get archivedLists => '📦 Gearchiveerde boodschappen';

  @override
  String get syncChanges => 'Wijzigingen synchroniseren';

  @override
  String get noSyncChanges => 'Geen wijzigingen om te synchroniseren';

  @override
  String get postimportAction => 'Na het importeren';

  @override
  String get postimportHint =>
      'Kies wat er in de bron-app (Herinneringen / Google Tasks) met de geïmporteerde items moet gebeuren.';

  @override
  String get postimportLeave => 'Alleen toevoegen';

  @override
  String get postimportComplete => 'Afvinken';

  @override
  String get postimportCompleteDelete => 'Afvinken & verwijderen';

  @override
  String get postimportFailed =>
      'Nabewerking in de bron-app is mislukt. De artikelen zijn toch aan Mealie toegevoegd.';

  @override
  String get syncChangesTitle => 'Wijzigingen synchroniseren';

  @override
  String get syncSectionChecked => 'Aangevinkt';

  @override
  String get syncSectionQuantity => 'Hoeveelheid';

  @override
  String get syncSectionCategory => 'Categorie';

  @override
  String get syncSectionAdditions => 'Nieuw toegevoegd';

  @override
  String get syncLocalLabel => 'Lokaal';

  @override
  String get syncServerLabel => 'Server';

  @override
  String get syncNow => 'Nu synchroniseren';

  @override
  String get offlineBadge => 'Offline';

  @override
  String get mealplanTitle => '📅 Maaltijdplan';

  @override
  String get mealplanSelectMode => 'Meerdere recepten selecteren';

  @override
  String mealplanSelectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count geselecteerd',
      one: '1 geselecteerd',
      zero: 'Selectie',
    );
    return '$_temp0';
  }

  @override
  String get breakfast => 'Ontbijt';

  @override
  String get lunch => 'Lunch';

  @override
  String get dinner => 'Diner';

  @override
  String get addMealEntry => 'Maaltijd toevoegen';

  @override
  String get selectRecipe => 'Recept selecteren';

  @override
  String get orFreeText => 'of vrije tekst';

  @override
  String get entryNote => 'Notitie';

  @override
  String get noMealEntries => 'Geen invoer voor deze week.';

  @override
  String get importRecipe => 'Recept importeren';

  @override
  String get importFromUrl => 'Importeren van URL';

  @override
  String get importFromImage => 'Importeren van foto';

  @override
  String get importFromJson => 'Importeren van JSON';

  @override
  String get url => 'URL';

  @override
  String get urlPlaceholder => 'https://...';

  @override
  String get importLanguage => 'Taal voor OCR';

  @override
  String get importing => 'Importeren...';

  @override
  String get importSuccess => 'Recept succesvol geïmporteerd!';

  @override
  String importError(String error) {
    return 'Importeren mislukt: $error';
  }

  @override
  String get pasteJson => 'Plak JSON hier';

  @override
  String get setupTitle => 'Welkom bij Mealie Recipes';

  @override
  String get setupSubtitle => 'Configureer uw Mealie-server.';

  @override
  String get serverUrl => 'Server-URL';

  @override
  String get serverUrlPlaceholder => 'https://mealie.voorbeeld.nl';

  @override
  String get apiToken => 'API-token';

  @override
  String get apiTokenPlaceholder => 'Uw API-token';

  @override
  String get householdId => 'Huishouden';

  @override
  String get householdIdPlaceholder => 'Family';

  @override
  String get shoppingListId => 'Boodschappenlijst-ID';

  @override
  String get shoppingListIdPlaceholder => 'Selecteer een lijst';

  @override
  String get setupHouseholdListTitle => 'Huishouden & boodschappenlijst';

  @override
  String get shoppingListLabel => 'Boodschappenlijst';

  @override
  String get setupHouseholdManualHint =>
      'Huishoudens konden niet worden geladen — voer de naam handmatig in.';

  @override
  String get setupExactTitle => 'Hoeveelheden op de boodschappenlijst';

  @override
  String get setupExactBody =>
      'In de meeste landen koop je niet op de gram nauwkeurig — er belandt 1 pak boter in je mandje, geen 200 g. In de eenvoudige modus zet de app recepthoeveelheden daarom om naar “1×”. In de exacte modus blijven hoeveelheid en eenheid 1:1 behouden zoals in de Mealie-webapp — ook bij het intypen van nieuwe artikelen (bijv. “200 g boter”). Je kunt dit altijd wijzigen in de instellingen.';

  @override
  String get setupExactSimpleTitle => 'Eenvoudige modus (1×)';

  @override
  String get setupExactSimpleBody =>
      'Ingrediënten komen als “1× artikel” op de lijst — ideaal om snel af te vinken in de winkel.';

  @override
  String get setupExactExactTitle => 'Exacte hoeveelheden';

  @override
  String get setupExactExactBody =>
      'Artikelen verschijnen met hoeveelheid en eenheid, bijv. “200 g boter” — precies zoals in de webapp.';

  @override
  String get connect => 'Verbinden';

  @override
  String get connecting => 'Verbinden...';

  @override
  String get connectionSuccess => 'Verbinding geslaagd!';

  @override
  String connectionError(String error) {
    return 'Verbinding mislukt: $error';
  }

  @override
  String get optionalHeaders => 'Optionele HTTP-headers (voor reverse proxy)';

  @override
  String get settingsTitle => '⚙️ Instellingen';

  @override
  String get settingsSaved => 'Instellingen opgeslagen';

  @override
  String get serverSettings => 'Server';

  @override
  String get displaySettings => 'Weergave';

  @override
  String get notificationSettings => 'Meldingen';

  @override
  String get securitySettings => 'Beveiliging';

  @override
  String get aboutSettings => 'Over';

  @override
  String get showRecipeImages => 'Receptafbeeldingen tonen';

  @override
  String get apiVersion => 'API-versie';

  @override
  String get language => 'Taal';

  @override
  String get biometricLock => 'Biometrisch slot';

  @override
  String get biometricLockDescription => 'App ontgrendelen met biometrie';

  @override
  String get criticalAlerts => 'Kritieke meldingen';

  @override
  String get criticalAlertsDescription => 'Timeralarm ook in stille modus';

  @override
  String get enableLogging => 'Logboek inschakelen';

  @override
  String get selectLanguage => 'Taal selecteren';

  @override
  String get setupContinue => 'Doorgaan';

  @override
  String get back => 'Terug';

  @override
  String get setupConnectStep => 'Verbind met je server';

  @override
  String get resetSettings => 'Alle instellingen resetten';

  @override
  String get resetSettingsConfirm => 'Alle instellingen resetten?';

  @override
  String get guestMode => 'Gastmodus';

  @override
  String get appVersion => 'Versie';

  @override
  String get leftoverFinder => 'Recept zoeker';

  @override
  String get leftoverFinderSubtitle =>
      'Vind recepten met de ingrediënten die je hebt';

  @override
  String get addIngredient => 'Ingrediënt toevoegen';

  @override
  String get ingredientPlaceholder => 'bijv. eieren';

  @override
  String get findRecipes => 'Recepten zoeken';

  @override
  String get matchingRecipes => 'Overeenkomende recepten';

  @override
  String get noMatchingRecipes => 'Geen recepten gevonden.';

  @override
  String matchPercent(int percent) {
    return '$percent% overeenkomst';
  }

  @override
  String get biometricPrompt => 'Authenticatie voor Mealie Recipes';

  @override
  String get biometricFailed => 'Authenticatie mislukt';

  @override
  String get whatsNew => 'Nieuw';

  @override
  String get pendingRecipesTitle => 'Ontvangen recepten';

  @override
  String pendingRecipesMessage(String sender, String name) {
    return 'Je hebt een recept ontvangen van $sender: \"$name\"';
  }

  @override
  String pendingRecipesFrom(Object names) {
    return 'Van $names';
  }

  @override
  String get pendingRecipesOpenCooking => 'Kookmodus openen';

  @override
  String get pendingRecipesLater => 'Later';

  @override
  String get openRecipe => 'Recept openen';

  @override
  String get dismiss => 'Sluiten';

  @override
  String get editRecipe => 'Recept bewerken';

  @override
  String get recipeName => 'Receptnaam';

  @override
  String get recipeDescription => 'Beschrijving';

  @override
  String get prepTime => 'Bereidingstijd (min)';

  @override
  String get cookTime => 'Kooktijd (min)';

  @override
  String get totalTime => 'Totale tijd (min)';

  @override
  String get recipeServings => 'Porties';

  @override
  String get rating => 'Beoordeling';

  @override
  String get addIngredientLine => 'Ingrediënt toevoegen';

  @override
  String get addInstruction => 'Stap toevoegen';

  @override
  String get removeIngredient => 'Ingrediënt verwijderen';

  @override
  String get removeInstruction => 'Stap verwijderen';

  @override
  String get ingredientName => 'Ingrediënt';

  @override
  String get ingredientQuantity => 'Hoeveelheid';

  @override
  String get ingredientUnit => 'Eenheid';

  @override
  String get ingredientNote => 'Notitie';

  @override
  String get instructionText => 'Staptekst';

  @override
  String get categories => 'Categorieën';

  @override
  String get selectCategories => 'Categorieën selecteren';

  @override
  String get selectTags => 'Tags selecteren';

  @override
  String get uploadImage => 'Afbeelding uploaden';

  @override
  String get removeImage => 'Afbeelding verwijderen';

  @override
  String get saveChanges => 'Wijzigingen opslaan';

  @override
  String get saving => 'Opslaan...';

  @override
  String get saveSuccess => 'Recept opgeslagen.';

  @override
  String saveError(String error) {
    return 'Kon niet opslaan: $error';
  }

  @override
  String get newCategory => 'Nieuwe categorie';

  @override
  String get newTag => 'Nieuw label';

  @override
  String get setRating => 'Beoordeling instellen';

  @override
  String get removeRating => 'Beoordeling verwijderen';

  @override
  String get ratingRemoved => 'Beoordeling verwijderd';

  @override
  String get googleTasksImport => 'Importeren uit Google Tasks';

  @override
  String get googleTasksImportDescription =>
      'Importeer items van Google Tasks naar de boodschappenlijst.';

  @override
  String get homeWelcome => 'Welkom bij Mealie Recipes! 👋';

  @override
  String homeWelcomeNamed(String name) {
    return 'Welkom $name, bij Mealie Recipes! 👋';
  }

  @override
  String get shopping => 'Boodschappen';

  @override
  String get planning => 'Planning';

  @override
  String get other => 'Overig';

  @override
  String get viewRecipes => '📖 Recepten bekijken';

  @override
  String get addRecipe => '➕ Recept toevoegen';

  @override
  String get completeShopping => 'Winkelen afronden';

  @override
  String get shoppingCompleted => 'Winkelen voltooid';

  @override
  String get shoppingCompletedSubtitle => 'Alles in het winkelwagentje! 🎉';

  @override
  String get essensplan => '📅 Maaltijdplan';

  @override
  String get resteverwertung => '🥗 Recept zoeker';

  @override
  String get newRecipeUpload => 'Nieuw recept uploaden';

  @override
  String get copyCode => 'Code kopiëren';

  @override
  String get shareLink => 'Link delen';

  @override
  String get connectedFriends => 'Verbonden vrienden';

  @override
  String get waitingForFriends => 'Wachten op vrienden...';

  @override
  String get endSharing => 'Delen beëindigen';

  @override
  String get cookFriendsDescription =>
      'Nodig een vriend uit om dit recept samen te koken';

  @override
  String get sessionCode => 'SESSIECODE';

  @override
  String get adjustQuantityLabel => 'Hoeveelheid aanpassen voor dit recept:';

  @override
  String get timerStartForStep => 'Timer voor stap';

  @override
  String get enterRecipeUrl => 'Voer recept-URL in';

  @override
  String get loading => 'Laden...';

  @override
  String get urlInvalidScheme => 'URL moet beginnen met http:// of https://';

  @override
  String get urlAddScheme => 'https:// toevoegen';

  @override
  String get addItemPlaceholder => 'Artikel toevoegen...';

  @override
  String get addSuccessToast => 'Toegevoegd!';

  @override
  String get completedItems => 'Voltooid';

  @override
  String get completeShoppingTitle => 'Boodschappen afronden?';

  @override
  String get completeShoppingMessage => 'Voltooide artikelen verwijderen?';

  @override
  String get recipeListTitle => '📖 Recepten';

  @override
  String get importRecipeTitle => 'Nieuw recept uploaden';

  @override
  String get uploadRecipeUrl => 'Import via URL';

  @override
  String get uploadRecipeUrlHint =>
      'Voer de recept-URL in om op te slaan op je server';

  @override
  String get uploadOpenAI => 'Importeer via OpenAI';

  @override
  String get uploadOpenAIHint =>
      'Je kunt ook foto\'s of een PDF van een recept uploaden. Beslaat het recept meerdere pagina\'s, voeg er dan meerdere toe — ze worden samen door AI geanalyseerd.';

  @override
  String get takePhoto => 'Camera';

  @override
  String get cameraPermissionDenied =>
      'Geen toegang tot de camera. Sta dit toe in de systeeminstellingen om recepten te fotograferen.';

  @override
  String get cameraUnavailable => 'Op dit apparaat is geen camera beschikbaar.';

  @override
  String get selectPhoto => 'Foto\'s';

  @override
  String get selectPdf => 'PDF';

  @override
  String get openAIHintTitle => 'Bestandsanalyse-info';

  @override
  String get openAIHintBody =>
      'De analyse gebruikt de OpenAI API. Zorg dat je API-sleutel geconfigureerd is in Mealie.';

  @override
  String get allDeleteConfirm => 'Alles verwijderen';

  @override
  String get portionen => 'Porties';

  @override
  String get timerForStep => 'Timer starten';

  @override
  String get weekNavPrev => 'Vorige week';

  @override
  String get weekNavNext => 'Volgende week';

  @override
  String get noMealsThisWeek => 'Geen maaltijden gepland';

  @override
  String get entriesInOtherWeeks => 'Er zijn vermeldingen in andere weken';

  @override
  String get availableWeeks => 'Beschikbare weken:';

  @override
  String weekRange(Object end, Object start, Object week) {
    return 'Week $week ($start – $end)';
  }

  @override
  String get currentWeek => 'Huidige week';

  @override
  String get rezepteAktualisieren => 'Recepten bijwerken';

  @override
  String get leftoverWhatTitle => 'Wat doet dit?';

  @override
  String get leftoverWhatBody =>
      'Deze functie herlaadt alle recepten van de server.';

  @override
  String get leftoverDescription =>
      'Voer beschikbare ingrediënten in om passende recepten te vinden.';

  @override
  String get leftoverIngredientsHeader => 'Ingrediënten thuis';

  @override
  String get leftoverSuggestions => 'Receptsuggesties';

  @override
  String get leftoverNoMatches => 'Geen passende recepten gevonden.';

  @override
  String get leftoverEnterIngredient => 'Ingrediënt invoeren';

  @override
  String matchingPercentText(int percent, int count, int total) {
    return '$percent% match ($count/$total)';
  }

  @override
  String get weekAbbreviation => 'Wk';

  @override
  String get today => 'Vandaag';

  @override
  String get selectDate => 'Datum kiezen';

  @override
  String get selectSlot => 'Maaltijd kiezen';

  @override
  String get selectedRecipe => 'Geselecteerd recept';

  @override
  String get confirmMeal => 'Maaltijd plannen';

  @override
  String get searchRecipes => 'Recepten zoeken';

  @override
  String get addCustomMeal => 'Eigen maaltijd toevoegen';

  @override
  String get diceModeButton => 'Willekeurige recepten dobbelen';

  @override
  String get diceModeTitle => '3 willekeurige suggesties';

  @override
  String get diceBackToSearch => 'Terug naar zoeken';

  @override
  String get diceNotEnoughRecipes =>
      'Niet genoeg recepten voor de dobbelmodus (minimaal 3 nodig)';

  @override
  String get entrySingular => 'vermelding';

  @override
  String get entriesPlural => 'vermeldingen';

  @override
  String listTitle(int n) {
    return 'Lijst $n';
  }

  @override
  String get deleteAllConfirmTitle => 'Alles verwijderen?';

  @override
  String get deleteAllConfirmMessage =>
      'Wil je alle gearchiveerde boodschappen verwijderen?';

  @override
  String get uploadFromUrlButton => 'Recept importeren van URL';

  @override
  String get uploadingImage => 'Uploaden...';

  @override
  String get uploadErrorTitle => 'Uploaden mislukt';

  @override
  String get uploadSuccessTitle => 'Upload geslaagd';

  @override
  String get editImportedRecipeQuestion =>
      'Wil je het nieuwe recept nu bewerken?';

  @override
  String get notNow => 'Niet nu';

  @override
  String get pdfTooLarge => 'Het PDF-bestand is te groot (max. 10 MB).';

  @override
  String get invalidUrl => 'Ongeldige URL. Voer een geldige HTTP(S)-URL in.';

  @override
  String get cookWithFriends => 'Met vrienden koken';

  @override
  String get cookFriendsSubtitle =>
      'Nodig een vriend uit om samen dit recept te koken';

  @override
  String get copied => 'Gekopieerd';

  @override
  String get linkCopied => 'Link gekopieerd';

  @override
  String get startCooking => 'Begin met koken';

  @override
  String get hostNoRecipe => 'Open een recept om een sessie te starten';

  @override
  String get uploadToOwnServer => 'Op mijn server opslaan';

  @override
  String get uploadingRecipe => 'Recept wordt geüpload…';

  @override
  String get recipeUploadedToOwnServer => 'Recept opgeslagen op je server';

  @override
  String get recipeUploadFailed => 'Uploaden mislukt';

  @override
  String get allowGuestSaveRecipes =>
      'Gasten mogen recepten op hun eigen server opslaan';

  @override
  String get appIcon => 'App-pictogram';

  @override
  String get appIconClassic => 'Klassiek';

  @override
  String get appIconModern => 'Modern';

  @override
  String get name => 'Naam';

  @override
  String get color => 'Kleur';

  @override
  String get randomColor => 'Willekeurige kleur';

  @override
  String get createFailed => 'Kon niet worden aangemaakt';

  @override
  String get deleteFailed => 'Kon niet worden verwijderd';

  @override
  String deleteOrganizerConfirm(String name) {
    return '„$name“ verwijderen? Wordt ook van de server verwijderd.';
  }

  @override
  String get connectionSection => 'Verbinding';

  @override
  String get token => 'Token';

  @override
  String get advancedOptions => 'Geavanceerde opties';

  @override
  String get mealieApiVersion => 'Mealie API-versie';

  @override
  String get sendOptionalHeaders => 'Optionele headers verzenden';

  @override
  String get offlineRecipeImages => 'Receptafbeeldingen offline opslaan';

  @override
  String get offlineRecipeImagesHint =>
      'Downloadt alle receptafbeeldingen naar dit apparaat, zodat ze ook zonder verbinding worden weergegeven. Bij grote verzamelingen kan dit enkele honderden MB innemen. Uitschakelen verwijdert de opgeslagen afbeeldingen.';

  @override
  String offlineRecipeImagesStatus(int count, int total, String size) {
    return 'Opgeslagen: $count/$total · $size';
  }

  @override
  String get offlineRecipeImagesDisableConfirm =>
      'Alle opgeslagen receptafbeeldingen verwijderen?';

  @override
  String headerNameLabel(int n) {
    return 'Header $n naam';
  }

  @override
  String headerValueLabel(int n) {
    return 'Header $n waarde';
  }

  @override
  String get value => 'Waarde';

  @override
  String get personalization => 'Personalisatie';

  @override
  String get showRecipeImagesSubtitle =>
      'Toont afbeeldingen in de receptenlijst';

  @override
  String get exactQuantities => 'Exacte hoeveelheden toevoegen';

  @override
  String get exactQuantitiesSubtitle =>
      'Ingrediënten en ingetypte artikelen behouden hoeveelheid en eenheid (bijv. 200 g boter) in plaats van 1x per artikel — ontbrekende ingrediënten maakt de app aan op de server';

  @override
  String get remindToShop => 'Herinner me om te winkelen';

  @override
  String get remindToShopSubtitle =>
      'Stuurt een melding als je in de buurt bent van een opgeslagen locatie en je boodschappenlijst nog openstaande items heeft — ook als de app gesloten is';

  @override
  String get shoppingReminderAddLocation => 'Locatie toevoegen';

  @override
  String get shoppingReminderMaxLocations => 'Maximaal 3 locaties bereikt';

  @override
  String get shoppingReminderLocationServiceDisabled =>
      'Locatievoorzieningen staan uit op dit apparaat';

  @override
  String get shoppingReminderPermissionTitle => 'Locatietoegang vereist';

  @override
  String get shoppingReminderPermissionMessage =>
      'Om je in de buurt van een winkel te herinneren, is locatietoegang \"Altijd\" nodig — ook als de app gesloten is. Schakel dit in bij Instellingen.';

  @override
  String get openSettings => 'Instellingen openen';

  @override
  String get shoppingReminderLocationName => 'Naam';

  @override
  String get shoppingReminderUseCurrentLocation => 'Huidige locatie gebruiken';

  @override
  String get shoppingReminderOrAddress => 'of voer een adres in';

  @override
  String get shoppingReminderAddress => 'Adres';

  @override
  String get shoppingReminderAddressPlaceholder => 'Straat, plaats';

  @override
  String get shoppingReminderSearchAddress => 'Zoeken';

  @override
  String get shoppingReminderLocationFailed =>
      'Locatie kon niet worden bepaald';

  @override
  String get shoppingReminderAddressNotFound => 'Adres niet gevonden';

  @override
  String get ratingFailed =>
      'De beoordeling kon niet worden opgeslagen — probeer het opnieuw.';

  @override
  String get lastCooked => 'Laatst gemaakt';

  @override
  String get syncLastCooked => '“Laatst gemaakt” bijwerken';

  @override
  String get syncLastCookedSubtitle =>
      'Slaat de datum van vandaag en een tijdlijnitem op de server op — zoals in de Mealie-webapp.';

  @override
  String get developer => 'Ontwikkelaar';

  @override
  String get enableLoggingSubtitle =>
      'Registreert print-/foutlogs (laatste 500 regels)';

  @override
  String get entriesLabel => 'Items';

  @override
  String get fileSize => 'Bestandsgrootte';

  @override
  String get showAction => 'Tonen';

  @override
  String get copy => 'Kopiëren';

  @override
  String logsWithCount(int count) {
    return 'Logs ($count)';
  }

  @override
  String get noLogs => 'Geen logs beschikbaar';

  @override
  String get logsTitle => 'Logs';

  @override
  String get required => 'Vereist';

  @override
  String get connectionFailedCheck =>
      'Verbinding mislukt. Controleer URL en token.';

  @override
  String get username => 'Gebruikersnaam';

  @override
  String get password => 'Wachtwoord';

  @override
  String get setupPasswordHint =>
      'Je wachtwoord wordt niet opgeslagen — de app logt je eenmalig in en genereert daaruit een API-token (net als bij Profiel → API-tokens in de webapp).';

  @override
  String get loginAndConnect => 'Inloggen & verbinden';

  @override
  String get loginInvalidCredentials => 'Gebruikersnaam of wachtwoord onjuist.';

  @override
  String get loginAndGenerateToken => 'Inloggen & token genereren';

  @override
  String get loggingIn => 'Bezig met inloggen…';

  @override
  String get apiTokenSaveHint =>
      'Token toegepast — tik hieronder op “Wijzigingen opslaan”.';

  @override
  String get renewApiToken => 'API-token vernieuwen';

  @override
  String get setupAuthChoiceTitle => 'Hoe wil je inloggen?';

  @override
  String get authModePasswordTitle =>
      'Laat de app een API-sleutel voor me maken';

  @override
  String get authModePasswordSubtitle =>
      'Log in met gebruikersnaam & wachtwoord — de app genereert automatisch een token.';

  @override
  String get authModeTokenTitle => 'Ik heb al een API-sleutel';

  @override
  String get authModeTokenSubtitle =>
      'Gekopieerd uit het Mealie-profiel (Profiel → API-tokens).';

  @override
  String keyN(int n) {
    return 'Sleutel $n';
  }

  @override
  String valueN(int n) {
    return 'Waarde $n';
  }

  @override
  String get openCookingMode => 'Kookmodus openen';

  @override
  String activeRecipes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count actieve recepten',
      one: '1 actief recept',
    );
    return '$_temp0';
  }

  @override
  String get reparseIngredients => 'Ingrediënten opnieuw verwerken';

  @override
  String get reparseIngredientsSubtitle =>
      'Hoeveelheid/eenheid/ingrediënt splitsen (bijv. ‘200 g bloem’)';

  @override
  String get reparseDone =>
      'Ingrediënten gesplitst – tik op ‘Wijzigingen opslaan’';

  @override
  String get reparseNone => 'Geen splitsbare ingrediënten gevonden';

  @override
  String get tagsAndCategories => 'Tags, categorieën & keukengerei';

  @override
  String get tapToAddPhoto => 'Tik om foto toe te voegen';

  @override
  String get descriptionLabel => 'Beschrijving';

  @override
  String get searchingDevices => 'Zoeken naar apparaten op hetzelfde wifi…';

  @override
  String get selectAll => 'Alles selecteren';

  @override
  String get importReminders => 'Herinneringen importeren';

  @override
  String get importGoogleTasks => 'Google Taken importeren';

  @override
  String get noTaskLists => 'Geen takenlijsten gevonden';

  @override
  String get noReminderLists => 'Geen herinneringslijsten gevonden';

  @override
  String importCount(int count) {
    return '$count importeren';
  }

  @override
  String get activeRecipeTimer => 'Actieve recepttimer';

  @override
  String get linkIngredients => 'Ingrediënten koppelen';

  @override
  String get noIngredientsToLink => 'Nog geen ingrediënten om te koppelen';

  @override
  String get importLanguageSubtitle =>
      'Taal voor recepten die uit een foto of pdf worden geïmporteerd';

  @override
  String get importLanguageSearch => 'Taal zoeken';

  @override
  String get importLanguageFollowApp => 'Zelfde als app-taal';

  @override
  String get importLanguageNoMatch => 'Geen taal gevonden';

  @override
  String get setupImportLanguageTitle => 'AI-receptimport';

  @override
  String get setupImportLanguageBody =>
      'Foto’s en pdf’s kunnen door AI in recepten worden omgezet. Kies de taal waarin ze moeten binnenkomen — handig als je moedertaal niet als app-taal beschikbaar is. Je kunt dit later in de instellingen wijzigen.';

  @override
  String get setupImportLanguageSearchHint =>
      'Gebruik het zoekveld in de lijst om talen te vinden die de app-interface niet aanbiedt.';

  @override
  String get setupCachingKeepOpenTitle => 'Houd de app open';

  @override
  String get setupCachingKeepOpenBody =>
      'Het laden gebeurt op de voorgrond. Laat de app open tot het klaar is — als je hem sluit of te lang wegschakelt, stopt het proces en begint het later opnieuw.';

  @override
  String get supportContact => 'Contact met support';

  @override
  String get supportDialogMessage =>
      'Beschrijf je probleem, dan nemen we contact op. Het logboek helpt enorm bij het opsporen van fouten — je kunt het als tekstbestand meesturen.';

  @override
  String get supportWithoutLogs => 'Zonder logboek';

  @override
  String get supportWithLogs => 'Logboek bijvoegen';

  @override
  String get supportMailSubject => 'Mealie Recipes — Support';

  @override
  String get supportMailHint => 'Beschrijf je probleem hier:';

  @override
  String get supportLogsEmpty =>
      'Het logboek is leeg. Zet logboekregistratie aan, roep het probleem opnieuw op en stuur het daarna.';

  @override
  String supportAddressCopied(String email) {
    return 'Adres gekopieerd: $email';
  }

  @override
  String supportNoMailApp(String email) {
    return 'Geen mail-app gevonden. Adres gekopieerd: $email';
  }

  @override
  String get createRecipeFromImages => 'Recept aanmaken';

  @override
  String imagePagesSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pagina\'s geselecteerd',
      one: '1 pagina geselecteerd',
    );
    return '$_temp0';
  }

  @override
  String get imagePagesHint =>
      'De eerste afbeelding wordt de hoofdafbeelding van het recept. Houd een pagina ingedrukt om te herschikken.';

  @override
  String get mainImageBadge => 'Hoofd';

  @override
  String maxImagesReached(int max) {
    return 'Maximaal $max afbeeldingen per recept.';
  }

  @override
  String get removePage => 'Pagina verwijderen';

  @override
  String get preparingPdf => 'PDF wordt verwerkt...';

  @override
  String get shareRecipeTitle => 'Recept delen';

  @override
  String get recipeOptionsTitle => 'Opties';

  @override
  String get exportAsPdf => 'Exporteren als PDF';

  @override
  String get generatingPdf => 'PDF wordt gemaakt…';

  @override
  String get pdfExportFailed => 'PDF-export mislukt';

  @override
  String get recipeTime => 'Tijd';

  @override
  String get ingredientSectionTitle => 'Sectie';

  @override
  String get addIngredientSection => 'Sectie toevoegen';

  @override
  String get aiImportToggle => 'Analyseren met AI';

  @override
  String get aiImportToggleHint =>
      'Ook voor receptvideo\'s (YouTube, Instagram, TikTok …) en pagina\'s die de normale import niet kan lezen. Vereist een AI-provider op je Mealie-server – voor video\'s ook een audioprovider.';

  @override
  String get aiImportButton => 'Importeren met AI';

  @override
  String get aiImportRunning =>
      'De AI analyseert de link … bij video\'s kan dit een paar minuten duren.';

  @override
  String get aiImportFailed =>
      'De AI-import is mislukt. Controleer de AI-instellingen van je Mealie-server.';

  @override
  String get stepHeadingLabel => 'Kop van de stap (optioneel)';

  @override
  String get linkedRecipeLabel => 'Gekoppeld recept';

  @override
  String get toolsTitle => 'Keukengerei';

  @override
  String get prepareTools => 'Leg het volgende keukengerei klaar';

  @override
  String get newTool => 'Nieuw keukengerei';

  @override
  String get renameAction => 'Hernoemen';

  @override
  String get organizerEmpty =>
      'Nog geen items. Tik rechtsboven op ‘+’ om er een aan te maken.';

  @override
  String organizerRecipeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count recepten',
      one: '1 recept',
      zero: 'Geen recepten',
    );
    return '$_temp0';
  }

  @override
  String get toolOnHand => 'Aanwezig';

  @override
  String get mealDiceSettingsTitle => 'Dobbelsteenfilter';

  @override
  String get mealDiceSettingsHint =>
      'Kies per maaltijd categorieën en tags. De dobbelsteen stelt dan alleen recepten voor die er minstens één van hebben. Dezelfde keuze kan bij meerdere maaltijden staan.';

  @override
  String get mealDiceSettingsNoneHint =>
      'Voor deze maaltijd is niets gekozen: de dobbelsteen kiest automatisch op categorieën zoals ‘Ontbijt’, ‘Lunch’ of ‘Avondeten’.';

  @override
  String get mealDiceAutoHintTitle => 'Automatische keuze';

  @override
  String get mealDiceAutoHintBody =>
      'Voor deze maaltijd zijn nog geen categorieën of tags ingesteld. De dobbelsteen zoekt daarom naar categorieën zoals ‘Ontbijt’, ‘Lunch’ of ‘Avondeten’ en vult aan met andere recepten.\n\nZelf kiezen: tik in het maaltijdplan op het tandwiel naast ‘+’.';

  @override
  String get dontShowAgain => 'Niet meer tonen';

  @override
  String get mealDiceNoMatches =>
      'Geen recept past bij de categorieën en tags die voor deze maaltijd zijn gekozen.';

  @override
  String mealDiceFewMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Slechts $count passende recepten',
      one: 'Slechts 1 passend recept',
    );
    return '$_temp0';
  }

  @override
  String get commentsTitle => 'Opmerkingen';

  @override
  String get commentHint => 'Schrijf een opmerking…';

  @override
  String get commentSaveFailed => 'De opmerking kon niet worden opgeslagen.';

  @override
  String get commentDeleteConfirm => 'Deze opmerking verwijderen?';

  @override
  String get cookingDoneCommentLabel => 'Opmerking (optioneel)';

  @override
  String get cookingDoneCommentHint =>
      'Hoe is het gelukt? Tips voor de volgende keer…';

  @override
  String get nutritionTitle => 'Voedingswaarden';

  @override
  String get nutritionPerServing => 'per portie';

  @override
  String get nutritionCalories => 'Calorieën';

  @override
  String get nutritionFat => 'Vet';

  @override
  String get nutritionSaturatedFat => 'Verzadigd vet';

  @override
  String get nutritionTransFat => 'Transvet';

  @override
  String get nutritionUnsaturatedFat => 'Onverzadigd vet';

  @override
  String get nutritionCholesterol => 'Cholesterol';

  @override
  String get nutritionSodium => 'Natrium';

  @override
  String get nutritionCarbohydrates => 'Koolhydraten';

  @override
  String get nutritionFiber => 'Vezels';

  @override
  String get nutritionSugar => 'Suiker';

  @override
  String get nutritionProtein => 'Eiwit';

  @override
  String get timelineTitle => 'Tijdlijn';

  @override
  String get timelineMadeThis => 'Ik heb dit gemaakt';

  @override
  String timelineUserMadeThis(String name) {
    return '$name heeft dit gemaakt';
  }

  @override
  String get timelineEmpty => 'Nog geen items in de tijdlijn.';

  @override
  String get timelineDate => 'Datum';

  @override
  String get timelineNoteHint => 'Notitie (optioneel)';

  @override
  String get timelineAddPhoto => 'Foto toevoegen';

  @override
  String get timelineRemovePhoto => 'Foto verwijderen';

  @override
  String get timelineSaved => 'Toegevoegd aan de tijdlijn';

  @override
  String get timelineSaveFailed => 'Kon niet aan de tijdlijn worden toegevoegd';

  @override
  String get timelineImageFailed =>
      'Item opgeslagen, maar de foto kon niet worden geüpload';

  @override
  String get timelineDeleteConfirm => 'Dit item uit de tijdlijn verwijderen?';

  @override
  String get timelineEditNote => 'Notitie bewerken';

  @override
  String get timelineUnknownRecipe => 'Recept niet gevonden';

  @override
  String get cookingDonePhotoHint => 'Foto voor de Mealie-tijdlijn (optioneel)';

  @override
  String get assetsTitle => 'Bijlagen';

  @override
  String get assetsAdd => 'Bijlage toevoegen';

  @override
  String get assetsChooseFile => 'Bestand';

  @override
  String get assetsUploading => 'Bezig met uploaden…';

  @override
  String get assetsUploadFailed => 'Bijlage kon niet worden geüpload';

  @override
  String assetsDeleteConfirm(String name) {
    return '“$name” uit de bijlagen verwijderen?';
  }

  @override
  String get assetsOpenFailed => 'Bijlage kon niet worden geopend';

  @override
  String get assetsUnsupported =>
      'Mealie ondersteunt alleen PDF, afbeeldingen, TXT, MD, CSV en JSON.';

  @override
  String get assetsShare => 'Delen';

  @override
  String get mealRulesTitle => 'Mealie-regels';

  @override
  String get mealRulesHint =>
      'Worden ook in de Mealie-webapp gebruikt. Gelden er meerdere regels voor de dag en maaltijd, dan moeten ze allemaal kloppen. Geldt er geen regel, dan kiest de dobbelsteen uit alle recepten.';

  @override
  String get mealRuleAdd => 'Regel toevoegen';

  @override
  String get mealRuleNewTitle => 'Nieuwe regel';

  @override
  String get mealRuleEditTitle => 'Regel bewerken';

  @override
  String get mealRuleDay => 'Dag';

  @override
  String get mealRuleAnyDay => 'Elke dag';

  @override
  String get mealRuleMealType => 'Maaltijd';

  @override
  String get mealRuleAnyMeal => 'Elke maaltijd';

  @override
  String get mealRuleConditionsTitle => 'Voorwaarden';

  @override
  String get mealRuleAllRecipes => 'Alle recepten';

  @override
  String get mealRuleDeleteConfirm => 'Deze regel verwijderen?';

  @override
  String get mealRulesOffline =>
      'Mealie-regels zijn nu niet bereikbaar – de dobbelsteen gebruikt de app-selectie.';

  @override
  String get mealRulesNoMatches =>
      'Geen recepten voldoen aan de Mealie-regels voor deze maaltijd.';

  @override
  String get mealTypeSide => 'Bijgerecht';

  @override
  String get mealTypeSnack => 'Tussendoortje';

  @override
  String get mealTypeDrink => 'Drankje';

  @override
  String get mealTypeDessert => 'Toetje';

  @override
  String get foodsTitle => 'Levensmiddelen';

  @override
  String get unitsTitle => 'Eenheden';

  @override
  String get newFood => 'Nieuw levensmiddel';

  @override
  String get newUnit => 'Nieuwe eenheid';

  @override
  String get editFood => 'Levensmiddel bewerken';

  @override
  String get editUnit => 'Eenheid bewerken';

  @override
  String get pluralNameLabel => 'Meervoudsnaam';

  @override
  String get abbreviationLabel => 'Afkorting';

  @override
  String get pluralAbbreviationLabel => 'Afkorting (meervoud)';

  @override
  String get mergeAction => 'Samenvoegen';

  @override
  String mergeIntoTitle(String name) {
    return '“$name” samenvoegen met…';
  }

  @override
  String mergeConfirm(String from, String to) {
    return '“$from” wordt samengevoegd met “$to”: alle recepten en boodschappenlijsten gebruiken daarna “$to”, en “$from” wordt verwijderd.';
  }

  @override
  String get mergeFailed => 'Samenvoegen mislukt';

  @override
  String foodUnitDeleteConfirm(String name) {
    return '“$name” verwijderen? Ingrediënten die het gebruiken verliezen de koppeling.';
  }

  @override
  String get foodsUnitsEmpty => 'Nog geen items.';

  @override
  String mealRuleConditionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count voorwaarden',
      one: '1 voorwaarde',
    );
    return '$_temp0';
  }

  @override
  String get showAll => 'Alles tonen';

  @override
  String get mealDiceModeTitle => 'Dobbelsteen gebruikt';

  @override
  String get mealDiceModeApp => 'App-selectie';

  @override
  String get switchListTitle => 'Lijst wisselen';

  @override
  String get newShoppingList => 'Nieuwe boodschappenlijst';

  @override
  String shoppingListDeleteConfirm(String name) {
    return '“$name” verwijderen? Alle items erin worden ook verwijderd.';
  }

  @override
  String get labelOrderTitle => 'Labels sorteren';

  @override
  String get labelOrderHint =>
      'Sleep om te sorteren. Geldt voor deze lijst – ook in de Mealie-webapp.';

  @override
  String get labelOrderEmpty => 'Deze lijst heeft nog geen labels.';

  @override
  String get useAsActiveList => 'Als actieve lijst gebruiken';

  @override
  String get activeListBadge => 'Actief';

  @override
  String get foodLabelLabel => 'Label';

  @override
  String get foodNoLabel => 'Geen label';

  @override
  String get aliasesLabel => 'Aliassen';

  @override
  String get aliasAddHint => 'Alias toevoegen';

  @override
  String get foodOnHand => 'Op voorraad in het huishouden';

  @override
  String get timelineChildRecipesTitle =>
      'Ook voor gekoppelde recepten toevoegen';

  @override
  String timelineMadeForRecipe(String recipe) {
    return 'Gemaakt voor $recipe';
  }

  @override
  String get timelineFilter => 'Items filteren';

  @override
  String get timelineTypeComment => 'Gemaakt & notities';

  @override
  String get timelineTypeInfo => 'Info';

  @override
  String get timelineTypeSystem => 'Systeem';

  @override
  String get listManagementTitle => 'Boodschappenlijsten';

  @override
  String get managementTitle => 'Meer';

  @override
  String get pinToHome => 'Aan startscherm toevoegen';

  @override
  String get unpinFromHome => 'Van startscherm verwijderen';

  @override
  String homeScreenFull(int count) {
    return 'Het startscherm is vol – maximaal $count tegels. Haal eerst een andere tegel onder “Meer” weg.';
  }

  @override
  String get selectAction => 'Selecteren';

  @override
  String selectedCount(int count) {
    return '$count geselecteerd';
  }

  @override
  String get assignLabelAction => 'Label toewijzen';

  @override
  String get assignLabelOverwriteHint =>
      'Overschrijft het label van alle geselecteerde levensmiddelen.';

  @override
  String deleteSelectedConfirm(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items verwijderen?',
      one: '1 item verwijderen?',
    );
    return '$_temp0';
  }

  @override
  String get seedDataAction => 'Standaardgegevens laden';

  @override
  String get seedFoodsHint =>
      'Maakt de standaardlevensmiddelen van Mealie aan in de gekozen taal.';

  @override
  String get seedUnitsHint =>
      'Maakt de standaardeenheden van Mealie aan in de gekozen taal.';

  @override
  String get seedLanguageLabel => 'Taal';

  @override
  String get seedDuplicateWarning =>
      'Je hebt al items. Mealie controleert niet op dubbelen – die moet je daarna zelf samenvoegen.';

  @override
  String get seedDone => 'Standaardgegevens aangemaakt';

  @override
  String get seedFailed => 'Standaardgegevens konden niet worden geladen';

  @override
  String get exportAction => 'Exporteren';

  @override
  String get substitutionsLabel => 'Vervangers';

  @override
  String get substitutionAddHint => 'Vervanger toevoegen';

  @override
  String get substitutionFoodLabel => 'Levensmiddel (optioneel)';

  @override
  String get substitutionNoteLabel => 'Notitie (optioneel)';

  @override
  String get substitutionNeedOne => 'Geef een levensmiddel of notitie op';

  @override
  String get useAbbreviationLabel => 'Afkorting gebruiken';

  @override
  String get useAbbreviationHint => 'Toon “g” in plaats van “gram” in recepten';

  @override
  String get fractionLabel => 'Als breuk tonen';

  @override
  String get fractionHint => '½ in plaats van 0,5';

  @override
  String get standardizationTitle => 'Standaardisatie';

  @override
  String get standardizationHint =>
      'Voor omrekeningen: 1 van deze eenheid is … (bijv. 1 el = 15 milliliter).';

  @override
  String get standardQuantityLabel => 'Standaard hoeveelheid';

  @override
  String get standardUnitLabel => 'Standaardeenheid';

  @override
  String get standardUnitNone => 'Geen';

  @override
  String get stdFluidOunce => 'Vloeibare ons (fl oz)';

  @override
  String get stdCup => 'Kop (VS)';

  @override
  String get stdOunce => 'Ons (oz)';

  @override
  String get stdPound => 'Pond (lb)';

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
  String get newLabel => 'Nieuw label';

  @override
  String get editLabel => 'Label bewerken';

  @override
  String get colorLabel => 'Kleur';

  @override
  String labelDeleteConfirm(String name) {
    return '“$name” verwijderen? Items en levensmiddelen verliezen dit label.';
  }

  @override
  String get importMenuAction => 'Importeren';

  @override
  String get archivedEmpty =>
      'Nog geen gearchiveerde boodschappen. Tik na het boodschappen doen op “Winkelen afronden” – de afgevinkte items komen dan hier.';

  @override
  String get sectionTitleLabel => 'Sectietitel';

  @override
  String get clearSection => 'Sectie verwijderen';

  @override
  String get noPermissionGeneric =>
      'Je hebt hiervoor geen rechten in Mealie. Vraag het een beheerder of huishoudbeheerder.';

  @override
  String get noPermissionEditRecipe =>
      'Je kunt dit recept niet bewerken – het is vergrendeld of hoort bij een ander huishouden. Alleen de maker of een beheerder kan dat.';

  @override
  String get noPermissionDeleteRecipe =>
      'Alleen de maker van het recept of een beheerder kan het verwijderen.';

  @override
  String get noPermissionDemoteSelf =>
      'Je kunt je eigen beheerrechten niet intrekken.';

  @override
  String get recipeLockedHint => 'Vergrendeld – alleen de maker kan bewerken';

  @override
  String get recipeDeleteOwnerOnlyHint =>
      'Alleen de maker of een beheerder kan verwijderen';

  @override
  String get organizeReadOnlyHint =>
      'Alleen bekijken: aanmaken, wijzigen en verwijderen vereist het recht “Gebruiker kan ingrediënten, tags en categorieën beheren”.';

  @override
  String get notesNotSavedNoPermission =>
      'Notitie niet opgeslagen – je hebt geen recht om dit recept te bewerken.';

  @override
  String get userManagementTitle => 'Gebruikersbeheer';

  @override
  String get usersTitle => 'Gebruikers';

  @override
  String get editUserTitle => 'Bewerk gebruiker';

  @override
  String get fullNameLabel => 'Volledige naam';

  @override
  String get usernameLabel => 'Gebruikersnaam';

  @override
  String get emailLabel => 'E-mailadres';

  @override
  String get passwordLabel => 'Wachtwoord';

  @override
  String get householdLabel => 'Huishouden';

  @override
  String get permissionsTitle => 'Gebruikersrechten';

  @override
  String get administratorLabel => 'Beheerder';

  @override
  String get permCanInvite =>
      'Gebruiker kan anderen uitnodigen voor zijn groep';

  @override
  String get permCanManage => 'Gebruiker kan de groepsinstellingen beheren';

  @override
  String get permCanManageHousehold => 'Gebruiker kan huishouden beheren';

  @override
  String get permCanOrganize =>
      'Gebruiker kan ingrediënten, tags en categorieën beheren';

  @override
  String get advancedFeaturesLabel => 'Geavanceerde functies inschakelen';

  @override
  String get passwordResetLinkAction =>
      'Stuur een link om het wachtwoord opnieuw in te stellen';

  @override
  String get resetLockedUsersAction => 'Vergrendelde gebruikers herstellen';

  @override
  String get membersTitle => 'Leden';

  @override
  String get inviteLinkTitle => 'Uitnodigingslink';

  @override
  String get inviteAction => 'Uitnodigen';

  @override
  String get userUpdated => 'Gebruiker bijgewerkt';

  @override
  String get createUserTitle => 'Gebruiker aanmaken';

  @override
  String get userCreated => 'Gebruiker aangemaakt';

  @override
  String userDeleteConfirm(String name) {
    return '“$name” verwijderen? Het account wordt uit Mealie verwijderd.';
  }

  @override
  String get passwordResetLinkCopied =>
      'Link gekopieerd – geef hem door aan de gebruiker. Hij is maar beperkt geldig.';

  @override
  String lockedUsersReset(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gebruikers ontgrendeld',
      one: '1 gebruiker ontgrendeld',
      zero: 'Geen vergrendelde gebruikers',
    );
    return '$_temp0';
  }

  @override
  String get inviteUsesLabel => 'Aantal keer bruikbaar';

  @override
  String get inviteCreated => 'Uitnodigingslink aangemaakt';

  @override
  String get inviteEmailHint =>
      'E-mailadres (optioneel – Mealie verstuurt de uitnodiging)';

  @override
  String get inviteEmailSent => 'Uitnodiging per e-mail verstuurd';

  @override
  String get inviteEmailFailed =>
      'De e-mail kon niet worden verstuurd (is SMTP ingesteld in Mealie?). De link werkt wel.';

  @override
  String get copyLinkAction => 'Link kopiëren';

  @override
  String get youLabel => 'Jij';

  @override
  String get membersPermissionsHint =>
      'Je kunt de rechten van de leden van je huishouden wijzigen – maar niet die van jezelf.';

  @override
  String get householdManagementTitle => 'Beheer van huishoudens';

  @override
  String get householdsTitle => 'Huishoudens';

  @override
  String get createHouseholdTitle => 'Maak Huishouden';

  @override
  String get householdNameLabel => 'Huishouden Naam';

  @override
  String get householdPreferencesTitle => 'Voorkeuren huishouden';

  @override
  String get privateHouseholdLabel => 'Privé huishouden';

  @override
  String get privateHouseholdHint =>
      'Instellen van je groep op privé, zet alle publieke weergaveopties naar standaard. Dit overschrijft de instellingen per recept';

  @override
  String get lockRecipeEditsLabel =>
      'Vergrendel recept bewerkingen van andere huishoudens';

  @override
  String get lockRecipeEditsHint =>
      'Wanneer ingeschakeld kunnen alleen gebruikers in uw huishouden recepten bewerken die zijn gemaakt door uw huishouden';

  @override
  String get householdRecipePreferencesTitle => 'Receptvoorkeuren voor groep';

  @override
  String get groupsTitle => 'Groepen';

  @override
  String get groupLabel => 'Groep';

  @override
  String get createGroupTitle => 'Groep aanmaken';

  @override
  String get groupNameLabel => 'Groepsnaam';

  @override
  String get groupPreferencesTitle => 'Groepsvoorkeuren';

  @override
  String get privateGroupLabel => 'Privé-groep';

  @override
  String get privateGroupHint =>
      'Instellen van je groep op privé, zet alle publieke weergaveopties naar standaard. Dit overschrijft de instellingen per recept';

  @override
  String get firstDayOfWeekLabel => 'Eerste dag van de week';

  @override
  String get showAnnouncementsLabel => 'Aankondigingen van Mealie weergeven';

  @override
  String get recipePublicDefaultLabel =>
      'Sta gebruikers buiten je groep toe om je recepten te zien';

  @override
  String get recipeShowNutritionDefaultLabel => 'Toon voedingswaarden';

  @override
  String get recipeShowAssetsDefaultLabel => 'Toon receptbijlagen';

  @override
  String get recipeLandscapeDefaultLabel => 'Standaard liggende weergave';

  @override
  String get recipeDisableCommentsDefaultLabel =>
      'Gebruikersreacties op recepten uitschakelen';

  @override
  String get myHouseholdSection => 'Mijn huishouden';

  @override
  String get myGroupSection => 'Mijn groep';

  @override
  String get preferencesSaved => 'Instellingen opgeslagen';

  @override
  String get cannotDeleteWithUsers =>
      'Heeft nog gebruikers – verplaats of verwijder ze eerst in Gebruikersbeheer.';

  @override
  String deleteHouseholdConfirm(String name) {
    return 'Huishouden “$name” verwijderen?';
  }

  @override
  String deleteGroupConfirm(String name) {
    return 'Groep “$name” verwijderen?';
  }

  @override
  String usersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gebruikers',
      one: '1 gebruiker',
      zero: 'Geen gebruikers',
    );
    return '$_temp0';
  }

  @override
  String get originalUrlLabel => 'Oorspronkelijke URL';

  @override
  String get copyTextAction => 'Tekst kopiëren';

  @override
  String get copiedToClipboard => 'Gekopieerd naar klembord';

  @override
  String get changelogEnglishHint =>
      'De nieuwigheden zijn alleen in het Engels – met “Tekst kopiëren” kun je ze bijvoorbeeld in een vertaler plakken.';

  @override
  String get favoritesTitle => 'Favorieten';

  @override
  String get favoritesEmpty =>
      'Nog geen favorieten. Tik op het hartje bij een recept om het hier te verzamelen.';

  @override
  String get changelogTitle => 'Changelog';

  @override
  String get changeProfileImage => 'Profielfoto wijzigen';

  @override
  String get profileImageUpdated => 'Profielfoto bijgewerkt';

  @override
  String get profileImageFailed => 'Profielfoto kon niet worden geüpload';

  @override
  String get myAccountTitle => 'Mijn account';

  @override
  String get ownAccountHint =>
      'Hier kun je je eigen account bewerken. Andere gebruikers worden beheerd door beheerders en leden met de machtiging \"beheren\".';

  @override
  String get changePasswordAction => 'Wachtwoord wijzigen';

  @override
  String get currentPasswordLabel => 'Huidig wachtwoord';

  @override
  String get newPasswordLabel => 'Nieuw wachtwoord';

  @override
  String get confirmPasswordLabel => 'Wachtwoord bevestigen';

  @override
  String get passwordTooShort => 'Minimaal 8 tekens';

  @override
  String get passwordsDoNotMatch => 'Wachtwoorden komen niet overeen';

  @override
  String get passwordUpdated => 'Wachtwoord bijgewerkt';

  @override
  String get passwordChangeFailed => 'Wachtwoord kon niet worden gewijzigd';

  @override
  String passwordManagedExternally(String method) {
    return 'Je meldt je aan via $method — wijzig je wachtwoord daar.';
  }

  @override
  String get bulkAddHint => 'Eén regel per item.';

  @override
  String bulkAddCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items toevoegen',
      one: '1 item toevoegen',
    );
    return '$_temp0';
  }

  @override
  String get linkRecipeAction => 'Recept koppelen';

  @override
  String get useFoodAction => 'Levensmiddel i.p.v. recept';

  @override
  String get addSubstitutionsAction => 'Vervangingen toevoegen';

  @override
  String get clearSubstitutionsAction => 'Vervangingen wissen';

  @override
  String get recipeSubstitutionsTitle => 'Vervangingen';

  @override
  String get substitutionUnknownFood =>
      'Alleen bestaande levensmiddelen – gebruik anders de notitie';

  @override
  String get insertAboveAction => 'Voeg hierboven in';

  @override
  String get insertBelowAction => 'Voeg hieronder in';

  @override
  String get moveToTopAction => 'Verplaats naar begin';

  @override
  String get moveToBottomAction => 'Verplaats naar onderen';

  @override
  String get linkReferencesAction => 'Verwijzingen koppelen';

  @override
  String get editMarkdownAction => 'Markdown bewerken';

  @override
  String get previewMarkdownAction => 'Bekijk opmaak';

  @override
  String get insertStepImageAction => 'Afbeelding uploaden';

  @override
  String get mergeAboveAction => 'Samenvoegen met bovenstaande';

  @override
  String get linkedToOtherStep => 'Gekoppeld aan andere stap';

  @override
  String get noNotesToLink => 'Geen notities om te koppelen';

  @override
  String get ownerLabel => 'Eigenaar';

  @override
  String get ingredientParserTitle => 'Ingrediëntenontleder';

  @override
  String ingredientParserHint(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count ingrediënten zijn nog niet gestructureerd. Kies een ontleder, controleer het resultaat en pas toe.',
      one:
          '1 ingrediënt is nog niet gestructureerd. Kies een ontleder, controleer het resultaat en pas toe.',
    );
    return '$_temp0';
  }

  @override
  String get parserNlp => 'Natuurlijke taalverwerker';

  @override
  String get parserBrute => 'Ruwe ontleder';

  @override
  String get parserOpenai => 'OpenAI ontleder';

  @override
  String get parserApp => 'Offline (app)';

  @override
  String get parseFailed => 'Ontleden mislukt';

  @override
  String get parseAction => 'Ontleed';

  @override
  String applyParsedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ingrediënten toepassen',
      one: '1 ingrediënt toepassen',
      zero: 'Niets geselecteerd',
    );
    return '$_temp0';
  }

  @override
  String get parsedNewBadge => 'nieuw';

  @override
  String get hoursShort => 'u';

  @override
  String get minutesShort => 'min';

  @override
  String get timeExtraHint => 'Extra, bijv. \"plus een nacht\"';

  @override
  String get yieldLabel => 'Opbrengst';

  @override
  String get yieldTextLabel => 'Opmerking over opbrengst';

  @override
  String get prepTimeLabel => 'Voorbereidingstijd';

  @override
  String get performTimeLabel => 'Kooktijd';

  @override
  String get totalTimeLabel => 'Totale tijd';

  @override
  String get settingPublicRecipe => 'Openbaar recept';

  @override
  String get settingShowNutrition => 'Toon voedingswaarden';

  @override
  String get settingShowAssets => 'Toon bijlagen';

  @override
  String get settingLandscapeView => 'Liggende weergave';

  @override
  String get settingDisableComments => 'Reacties uitschakelen';

  @override
  String get settingDisableAmount => 'Ingrediënthoeveelheden uitschakelen';

  @override
  String get settingLocked => 'Vergrendeld';

  @override
  String get settingLockedOwnerOnly =>
      'Alleen de maker kan het recept vergrendelen of ontgrendelen.';

  @override
  String get apiExtrasTitle => 'API-extra\'s';

  @override
  String get apiExtrasHint =>
      'Eigen sleutel/waarde-paren voor apps van derden, bijv. om automatiseringen te starten.';

  @override
  String get extraKeyLabel => 'Sleutel';

  @override
  String get extraValueLabel => 'Waarde';

  @override
  String get addExtraAction => 'Extra toevoegen';

  @override
  String durationHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count uur',
      one: '1 uur',
    );
    return '$_temp0';
  }

  @override
  String durationMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minuten',
      one: '1 minuut',
    );
    return '$_temp0';
  }

  @override
  String get discardChangesConfirm => 'Niet-opgeslagen wijzigingen verwerpen?';

  @override
  String get discardChanges => 'Wijzigingen verwerpen';

  @override
  String get imageFromUrl => 'Afbeelding van URL';

  @override
  String get deleteRecipeImage => 'Receptafbeelding verwijderen';

  @override
  String get deleteRecipeImageConfirm =>
      'Weet je zeker dat je deze afbeelding wil verwijderen?';

  @override
  String get bulkAddIngredients => 'Ingrediënten in bulk toevoegen';

  @override
  String get bulkAddSteps => 'Stappen in bulk toevoegen';

  @override
  String get stepImageFailed => 'Afbeelding kon niet worden geüpload';

  @override
  String get servingsAndTimes => 'Porties & tijden';

  @override
  String get recipeSettingsTitle => 'Receptinstellingen';

  @override
  String get jsonEditorTitle => 'JSON-bewerker';

  @override
  String get jsonInvalid => 'Ongeldige JSON – controleer het.';

  @override
  String get editorOfflineHint =>
      'Offline geopend: opslaan kan pas met verbinding. Nieuwere Mealie-velden (bijv. vervangingen) blijven ongewijzigd.';

  @override
  String get parseLineFailed => 'Niet herkend – blijft ongewijzigd';

  @override
  String get createManualTitle => 'Recept handmatig aanmaken';

  @override
  String get createManualHint =>
      'Voer een naam in – voeg daarna ingrediënten, stappen, afbeelding en de rest toe in de recepteditor.';

  @override
  String get createManualButton => 'Aanmaken & bewerken';

  @override
  String get changelogEmpty => 'Nog geen items voor deze versie.';

  @override
  String get finderDescription =>
      'Zoek naar recepten op basis van ingrediënten die je bij de hand hebt. Je kunt ook filteren op gereedschap dat je beschikbaar hebt en een maximum aantal ontbrekende ingrediënten of gereedschappen instellen.';

  @override
  String get finderSelectedIngredients => 'Gekozen ingrediënten';

  @override
  String get finderNoIngredientsSelected => 'Geen ingrediënten geselecteerd';

  @override
  String get finderMissing => 'Ontbrekend';

  @override
  String get finderNoRecipesFound => 'Geen recepten gevonden';

  @override
  String get finderNoRecipesFoundDescription =>
      'Probeer meer ingrediënten toe te voegen aan uw zoekopdracht of pas uw filters aan';

  @override
  String get finderIncludeFoodsOnHand => 'Inclusief ingrediënten in huis';

  @override
  String get finderIncludeToolsOnHand => 'Inclusief keukengerei in huis';

  @override
  String get finderIncludeSubstitutions => 'Vervangers meenemen';

  @override
  String get finderSubstituting => 'Vervangen';

  @override
  String finderSubstituteForFood(String substitute, String food) {
    return '$substitute in plaats van $food';
  }

  @override
  String get finderMaxMissingIngredients => 'Maximum ontbrekende ingrediënten';

  @override
  String get finderMaxMissingTools => 'Maximum ontbrekend keukengerei';

  @override
  String get finderSelectedTools => 'Geselecteerd keukengerei';

  @override
  String get finderReadyToMake => 'Klaar om te maken';

  @override
  String get finderAlmostReadyToMake => 'Bijna klaar om te maken';

  @override
  String get finderSettings => 'Instellingen';

  @override
  String get finderLoadingRecipes => 'Recepten ophalen';

  @override
  String get finderClearSelection => 'Selectie wissen';

  @override
  String get finderOfflineHint =>
      'Geen verbinding met de server – de resultaten komen uit de recepten die op dit apparaat zijn opgeslagen.';

  @override
  String addIngredientsSkippedOnHand(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Toegevoegd aan je boodschappenlijst – $count ingrediënten op voorraad zijn overgeslagen.',
      one:
          'Toegevoegd aan je boodschappenlijst – 1 ingrediënt op voorraad is overgeslagen.',
    );
    return '$_temp0';
  }

  @override
  String get sendPeerOfflineHint =>
      'Nu niet bereikbaar – komt aan zodra de app daar wordt geopend';

  @override
  String sendDeliveredLater(String device) {
    return '„$device” is nu niet bereikbaar. Het recept komt aan zodra de app daar wordt geopend.';
  }

  @override
  String get sendQueuedOffline =>
      'Nu geen verbinding. Het recept wordt automatisch verstuurd zodra je weer online bent.';

  @override
  String get searchHasAll => 'Bevat alles';

  @override
  String get searchHasAny => 'Heeft een van';

  @override
  String get recipeFilterTitle => 'Filter';

  @override
  String get finderOtherFilters => 'Overige filters';

  @override
  String get qfOpEquals => 'is gelijk aan';

  @override
  String get qfOpNotEquals => 'is niet gelijk aan';

  @override
  String get qfOpGreater => 'is groter dan';

  @override
  String get qfOpGreaterEq => 'is groter dan of gelijk aan';

  @override
  String get qfOpLess => 'is kleiner dan';

  @override
  String get qfOpLessEq => 'is kleiner dan of gelijk aan';

  @override
  String get qfOpNewerThan => 'is nieuwer dan';

  @override
  String get qfOpOlderThan => 'is ouder dan';

  @override
  String qfDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dagen geleden',
      one: '1 dag geleden',
    );
    return '$_temp0';
  }

  @override
  String get filterResetAll => 'Alle filters wissen';

  @override
  String get filterAny => 'Alle';

  @override
  String get filterOfflineIgnored =>
      'Offline kunnen de „Overige filters” alleen in eenvoudige vorm worden toegepast.';

  @override
  String linkedRecipesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gekoppelde recepten',
      one: 'Eén gekoppeld recept',
      zero: 'Geen gekoppelde recepten',
    );
    return '$_temp0';
  }

  @override
  String get shoppingReminderNotificationsOff =>
      'Meldingen staan uit voor Mealie Recipes — zonder meldingen kan de boodschappenherinnering niet verschijnen. Sta ze toe in de instellingen.';

  @override
  String get shoppingReminderInactiveHint =>
      'De boodschappenherinnering kan nu niet werken: zet locatietoegang op „Altijd” en sta meldingen toe.';

  @override
  String get bulkImportTitle => 'URL-import in bulk';

  @override
  String get bulkImportDescription =>
      'Met recepten in bulk importeren kunt u meerdere recepten tegelijk importeren door de sites op de backend in een wachtrij te plaatsen en de taak op de achtergrond uit te voeren. Dit kan handig zijn bij een eerste migratie naar Mealie, of wanneer u een groot aantal recepten wilt importeren.';

  @override
  String get bulkAddTitle => 'Toevoegen in bulk';

  @override
  String get bulkImportSetOrganizers => 'Categorieën en tags instellen';

  @override
  String get bulkImportStarted => 'Bulk importproces is gestart';

  @override
  String get bulkImportFailed => 'Bulk-importproces is mislukt';

  @override
  String get bulkImportReports => 'Importeren in bulk';

  @override
  String get bulkImportUrlHint => 'Recept-URL';

  @override
  String get migrationsTitle => 'Gegevensmigraties';

  @override
  String get migrationsDescription =>
      'Recepten kunnen vanuit een andere ondersteunde applicatie naar Mealie worden gemigreerd. Zo begin je eenvoudig met Mealie. Gegevens tussen Mealie-instanties verplaats je met back-ups, niet met migraties.';

  @override
  String get migrationNew => 'Nieuwe migratie';

  @override
  String get migrationChooseType => 'Kies het migratietype';

  @override
  String get noFileSelected => 'Geen bestand gekozen';

  @override
  String migrationTagAll(String tag) {
    return 'Label alle recepten met het label $tag';
  }

  @override
  String get migrationPrevious => 'Vorige migraties';

  @override
  String get migrationMealieDescription =>
      'Mealie kan recepten importeren uit een Mealie-versie van vóór v1.0. Exporteer je recepten uit je oude instantie en upload het zipbestand hieronder. Let op: alleen recepten worden geïmporteerd.';

  @override
  String get migrationChowdownDescription =>
      'Mealie ondersteunt het formaat van de chowdown repository. Download de repository als een .zip-bestand en upload deze hieronder.';

  @override
  String get migrationCopyMeThatDescription =>
      'Mealie kan recepten importeren uit Copy Me That. Exporteer je recepten in HTML-formaat, upload daarna de .zip hieronder.';

  @override
  String get migrationMyRecipeBoxDescription =>
      'Mealie kan recepten importeren uit My Recipe Box. Exporteer je recepten in CSV-formaat, upload daarna het .csv bestand hieronder.';

  @override
  String get migrationNextcloudDescription =>
      'Nextcloud recepten kunnen worden geïmporteerd uit een zip-bestand dat de gegevens bevat die zijn opgeslagen in Nextcloud. Zie de voorbeeldmapstructuur hieronder om ervoor te zorgen dat uw recepten kunnen worden geïmporteerd.';

  @override
  String get migrationPaprikaDescription =>
      'Mealie kan recepten uit het programma Paprika importeren. Exporteer je recepten uit Paprika, hernoem de extentie van het geëxporteerde bestand naar .zip en upload dat bestand hieronder.';

  @override
  String get migrationPlanToEatDescription =>
      'Mealie kan recepten importeren van Plan to Eat.';

  @override
  String get migrationRecipeKeeperDescription =>
      'Mealie kan recepten importeren van Recipe Keeper. Exporteer de recepten als .zip. Dat bestand kan je hier dan uploaden.';

  @override
  String get migrationTandoorDescription =>
      'Mealie kan recepten importeren van Tandoor. Exporteer je gegevens in het \"Standaardformaat\" (\"Default\") en upload het .zip bestand hieronder.';

  @override
  String get migrationCooknDescription =>
      'Mealie kan recepten importeren van DVO Cook\'n X3. Exporteer een cookboek of menu in het \"Cook\'n\" formaat. Verander de naam van de export extensie naar .zip. En upload daarna de .zip.';

  @override
  String get reportTitle => 'Rapport';

  @override
  String get recipeDataTitle => 'Receptgegevens';

  @override
  String get recipeDataDescription =>
      'Gebruik deze sectie om de gegevens te beheren die zijn gekoppeld aan je recepten. Je kunt verschillende groepsgewijze acties uitvoeren op je recepten, zoals het exporteren, verwijderen, labelen en toewijzen van categorieën.';

  @override
  String get recipeDataTagTitle => 'Label recepten';

  @override
  String get recipeDataCategorizeTitle => 'Categoriseer recepten';

  @override
  String get recipeDataSettingsTitle => 'Instellingen bijwerken';

  @override
  String get recipeDataExportTitle => 'Exporteer recepten';

  @override
  String get recipeDataDeleteTitle => 'Verwijder recepten';

  @override
  String recipeDataExportConfirm(int count) {
    return 'De volgende recepten ($count) zullen worden geëxporteerd.';
  }

  @override
  String get recipeDataExportsTitle => 'Gegevensexports';

  @override
  String get recipeDataExportsDescription =>
      'Deze sectie bevat links naar beschikbare exportbestanden die gedownload kunnen worden. Deze exportbestanden zullen verlopen, dus zorg ervoor dat je ze grijpt terwijl ze nog beschikbaar zijn.';

  @override
  String get recipeDataPurgeExports => 'Verwijder exports';

  @override
  String get recipeDataPurgeConfirm =>
      'Weet je zeker dat je alle exportgegevens wil verwijderen?';

  @override
  String get recipeActionsTitle => 'Acties met recepten ';

  @override
  String get recipeActionNew => 'Nieuwe actie met recept';

  @override
  String get recipeActionEdit => 'Pas actie met recept aan';

  @override
  String get recipeActionTypeLink => 'Link';

  @override
  String get recipeActionTypePost => 'Post';

  @override
  String get webhooksTitle => 'Webhooks';

  @override
  String get webhooksDescription =>
      'De onderstaande webhooks worden uitgevoerd wanneer een maaltijd is gedefinieerd voor de dag. Op het geplande tijdstip worden de webhooks verzonden met de data van het recept dat voor de dag is ingepland. Merk op dat er onnauwkeurigheid is in het tijdstip waarop de webhook wordt uitgevoerd. De webhooks worden uitgevoerd met een interval van 5 minuten, dus de webhooks worden uitgevoerd binnen ± 5 minuten van de geplande tijd.';

  @override
  String get webhookName => 'Webhooknaam';

  @override
  String get webhookUrl => 'Webhook URL';

  @override
  String get notifiersTitle => 'Melders';

  @override
  String get notifiersDescription =>
      'Stel e-mail en push-meldingen in die worden getriggerd bij specifieke gebeurtenissen.';

  @override
  String get notifierNew => 'Nieuwe melding';

  @override
  String get notifierDescription =>
      'Mealie gebruikt de notificatieservices van Apprise om meldingen te genereren. Apprise biedt diverse services aan om meldingen te versturen. Raadpleeg hun wiki voor een uitgebreide handleiding over het creëren van een link voor je service. Afhankelijk van de gekozen service zijn er mogelijk extra functionaliteiten beschikbaar.';

  @override
  String get notifierAppriseUrl => 'Kennisgevings-url';

  @override
  String get notifierAppriseUrlSkipped =>
      'URL van Apprise (overgeslagen als veld leeg is)';

  @override
  String get notifierAppriseUrlBlankHint =>
      'Aangezien Apprise URL\'s doorgaans gevoelige informatie bevatten, wordt dit veld opzettelijk leeg gelaten tijdens het bewerken. Als je de URL wilt bijwerken, vul dan de nieuwe hier in, anders laat het leeg om de huidige URL te behouden.';

  @override
  String get notifierEnable => 'Activeer melding';

  @override
  String get notifierWhatEvents =>
      'Op welke gebeurtenissen moet deze melding zich abonneren?';

  @override
  String get notifierRecipeEvents => 'Recept gebeurtenissen';

  @override
  String get notifierUserEvents => 'Gebeurtenissen van gebruiker';

  @override
  String get notifierMealplanEvents => 'Maaltijdplan-gebeurtenissen';

  @override
  String get notifierShoppingListEvents => 'Boodschappenlijst-gebeurtenissen';

  @override
  String get notifierCookbookEvents => 'Kookboek-gebeurtenissen';

  @override
  String get notifierTagEvents => 'Label-gebeurtenissen';

  @override
  String get notifierCategoryEvents => 'Categorie-gebeurtenissen';

  @override
  String get notifierLabelEvents => 'Label gebeurtenissen';

  @override
  String get notifierUserSignup =>
      'Als een nieuwe gebruiker zich bij je groep aansluit';

  @override
  String get notifierCreate => 'Aanmaken';

  @override
  String get notifierUpdate => 'Bijwerken';

  @override
  String get notifierDelete => 'Verwijderen';

  @override
  String get notifierTestSent => 'Testbericht verzonden';

  @override
  String get adminTitle => 'Beheerdersinstellingen';

  @override
  String get backupsTitle => 'Back-ups';

  @override
  String get backupsDescription =>
      'Back-ups zijn een complete kopie van de database en de data map. Je kunt niet kiezen wat wel of niet in de reservekopie zit. Het is een kopie van Mealie van dat moment. Je kunt de back-up gebruiken om data te importeren of exporteren. Of om de hele site op een andere plek te bewaren.';

  @override
  String get backupCreateHeading => 'Back-up maken';

  @override
  String get backupCreated => 'Back-up successvol gemaakt';

  @override
  String get backupCreateFailed =>
      'Fout bij aanmaken van back-up. Zie logbestand';

  @override
  String get backupDelete => 'Back-up verwijderen';

  @override
  String get backupDeleted => 'Back-up verwijderd';

  @override
  String get backupRestore => 'Back-up terugzetten';

  @override
  String get backupRestoreDescription =>
      'Het terugzetten van deze back-up overschrijft alle huidige gegevens in je database en in de gegevensmap. Als het terugzetten is gelukt wordt je afgemeld.';

  @override
  String get backupCannotBeUndone =>
      'Deze actie kan niet ongedaan worden gemaakt – gebruik met voorzichtigheid.';

  @override
  String get backupAcknowledge =>
      'Ik begrijp dat deze actie onomkeerbaar en destructief is en gegevensverlies kan veroorzaken';

  @override
  String get backupRestoreSuccess => 'Herstellen gelukt';

  @override
  String get backupRestoreFailed =>
      'Herstel mislukt. Controleer de logbestanden van je server voor meer informatie';

  @override
  String get maintenanceTitle => 'Onderhoud';

  @override
  String get maintenanceSummary => 'Samenvatting';

  @override
  String get maintenanceStorage => 'Opslaggegevens';

  @override
  String get maintenanceDataDirSize => 'Grootte van de gegevensmap';

  @override
  String get maintenanceCleanableDirs => 'Opschoonbare mappen';

  @override
  String get maintenanceCleanableImages => 'Opschoonbare afbeeldingen';

  @override
  String get maintenanceTempDir => 'Tijdelijke map (.temp)';

  @override
  String get maintenanceBackupsDir => 'Back-upmap (backups)';

  @override
  String get maintenanceGroupsDir => 'Groepenmap (groups)';

  @override
  String get maintenanceRecipesDir => 'Receptenmap (recipes)';

  @override
  String get maintenanceUserDir => 'Gebruikersmap (user)';

  @override
  String get maintenanceCleanDirs => 'Mappen opschonen';

  @override
  String get maintenanceCleanDirsDescription =>
      'Verwijdert alle receptmappen die geen geldige UUIDs zijn';

  @override
  String get maintenanceCleanTemp => 'Tijdelijke bestanden opschonen';

  @override
  String get maintenanceCleanTempDescription =>
      'Verwijdert alle bestanden en mappen in de .temp-map';

  @override
  String get maintenanceCleanImages => 'Afbeeldingen opschonen';

  @override
  String get maintenanceCleanImagesDescription =>
      'Verwijdert alle afbeeldingen die niet eindigen met .webp';

  @override
  String get maintenanceActions => 'Acties';

  @override
  String get adminConfiguration => 'Configuratie';

  @override
  String get adminAppVersion => 'Applicatieversie';

  @override
  String get adminUpToDate => 'Laatste versie van Mealie';

  @override
  String adminVersionOutdated(String current, String latest) {
    return 'De huidige versie ($current) komt niet overeen met de nieuwste versie. Overweeg bijwerken naar de laatste versie ($latest).';
  }

  @override
  String get adminBaseUrl => 'Server-side basis-URL';

  @override
  String get adminBaseUrlOk =>
      'Server-side URL komt niet overeen met de standaard';

  @override
  String get adminBaseUrlError =>
      '`BASE_URL` is nog steeds de standaard waarde op de API Server. Dit geeft problemen met notificatielinks in e-mails etc.';

  @override
  String adminAuthReady(String provider) {
    return '$provider gereed';
  }

  @override
  String adminAuthNotReady(String provider) {
    return '$provider niet gereed';
  }

  @override
  String adminAuthDisabled(String provider) {
    return '$provider uitgeschakeld';
  }

  @override
  String adminAuthSuccessText(String provider) {
    return 'Alle vereiste $provider-variabelen zijn ingesteld.';
  }

  @override
  String adminAuthErrorText(String provider) {
    return 'Niet alle $provider-waarden zijn ingesteld. Dit kun je negeren als je geen $provider-authenticatie gebruikt.';
  }

  @override
  String adminAuthDisabledText(String envVar) {
    return 'Zet $envVar op true om in te schakelen.';
  }

  @override
  String get adminEmailStatus => 'Emailconfiguratie';

  @override
  String get adminEmailConfigured => 'E-mail geconfigureerd';

  @override
  String get adminNotReady => 'Niet klaar – Controleer omgevingsvariabelen';

  @override
  String get adminSucceeded => 'Geslaagd';

  @override
  String get adminFailed => 'Mislukt';

  @override
  String get adminSiteStatistics => 'Websitestatistieken';

  @override
  String get adminUncategorized => 'Ongecategoriseerde recepten';

  @override
  String get adminUntagged => 'Ongetagde recepten';

  @override
  String get adminGeneralAbout => 'Algemene informatie';

  @override
  String get adminVersion => 'Versie';

  @override
  String get adminBuild => 'Build';

  @override
  String get adminApplicationMode => 'Applicatiemodus';

  @override
  String get adminProduction => 'Productie';

  @override
  String get adminDevelopment => 'Ontwikkeling';

  @override
  String get adminDemoStatus => 'Demostatus';

  @override
  String get adminDemo => 'Demo';

  @override
  String get adminNotDemo => 'Geen demo';

  @override
  String get adminApiPort => 'API-poort';

  @override
  String get adminApiDocs => 'API-documentatie';

  @override
  String get adminDatabaseType => 'Databasetype';

  @override
  String get adminDatabaseUrl => 'Database URL';

  @override
  String get adminDefaultGroup => 'Standaardgroep';

  @override
  String get adminDefaultHousehold => 'Standaard huishouden';

  @override
  String get adminScraperVersion => 'Versie van de receptenscraper';

  @override
  String get adminStatUsers => 'Gebruikers';

  @override
  String get adminStatHouseholds => 'Huishoudens';

  @override
  String get adminStatGroups => 'Groepen';

  @override
  String get recipeDuplicate => 'Dupliceer recept';

  @override
  String get recipeDuplicateAction => 'Dupliceren';

  @override
  String get recipeShareLink => 'Deel recept';

  @override
  String get recipeShareExpiration => 'Vervaldatum';

  @override
  String get recipeShareCopied => 'Link gekopieerd naar klembord';

  @override
  String get enabledLabel => 'Ingeschakeld';

  @override
  String get disabledLabel => 'Uitgeschakeld';

  @override
  String get testAction => 'Test';

  @override
  String get yesLabel => 'Ja';

  @override
  String get noLabel => 'Nee';

  @override
  String get downloadAction => 'Downloaden';

  @override
  String get backupUpload => 'Uploaden';

  @override
  String get zipImportButton => 'Importeren uit zip';

  @override
  String get zipImportDescription =>
      'Importeer een recept dat geëxporteerd was uit een andere Mealie instantie.';

  @override
  String get reportStatus => 'Status';

  @override
  String get reportDate => 'Datum';

  @override
  String get recipeActionTitleLabel => 'Titel';

  @override
  String get clearAll => 'Wissen';

  @override
  String get recipeDataSettingsExplanation =>
      'Instellingen die hier gekozen zijn, exclusief de vergrendelde optie, zullen worden toegepast op alle geselecteerde recepten.';

  @override
  String get adminAllowSignup => 'Registratie toegestaan';

  @override
  String get adminAllowPasswordLogin => 'Inloggen met wachtwoord toegestaan';

  @override
  String get adminEmailInvalid => 'Voer een geldig e-mailadres in.';

  @override
  String adminEmailTestResult(String result) {
    return 'E-mailtest: $result';
  }

  @override
  String get adminSendTestEmail => 'Test-e-mail versturen';

  @override
  String get adminTestEmailAddress => 'Ontvanger';

  @override
  String get backupCreate => 'Back-up maken';

  @override
  String backupDeleteConfirm(String name) {
    return 'Back-up \"$name\" verwijderen?';
  }

  @override
  String get backupPostgresNote =>
      'Gebruik je PostgreSQL, lees dan eerst het back-up-/herstelproces in de Mealie-documentatie.';

  @override
  String get backupUploaded => 'Back-up geüpload';

  @override
  String get backupsEmpty => 'Nog geen back-ups.';

  @override
  String get bulkImportAddRow => 'URL toevoegen';

  @override
  String get bulkImportStart => 'Import starten';

  @override
  String get chooseFileButton => 'Bestand kiezen';

  @override
  String get deselectAllAction => 'Alles deselecteren';

  @override
  String get downloadFailed => 'Downloaden mislukt';

  @override
  String get fileSaved => 'Bestand opgeslagen';

  @override
  String get loadFailed => 'Laden mislukt';

  @override
  String get maintenanceActionsWarning =>
      'Onderhoudsacties zijn destructief en moeten voorzichtig worden gebruikt. Elke actie is onomkeerbaar.';

  @override
  String get maintenanceConfirm =>
      'Deze actie is destructief en kan niet ongedaan worden gemaakt. Doorgaan?';

  @override
  String get maintenanceDone => 'Klaar';

  @override
  String get maintenanceFailed => 'Onderhoudsactie mislukt';

  @override
  String get maintenanceRun => 'Uitvoeren';

  @override
  String get migrationFailed => 'Migratie mislukt';

  @override
  String get migrationStart => 'Migratie starten';

  @override
  String get migrationStarted =>
      'Migratie voltooid – zie het rapport hieronder.';

  @override
  String get moreImportOptions => 'Meer importopties';

  @override
  String notifierDeleteConfirm(String name) {
    return 'Melding \"$name\" verwijderen?';
  }

  @override
  String get notifierEdit => 'Melding bewerken';

  @override
  String notifierEventCount(int count) {
    return 'Gebeurtenissen: $count';
  }

  @override
  String get notifierTestFailed => 'Testbericht kon niet worden verzonden';

  @override
  String get notifiersEmpty => 'Nog geen meldingen.';

  @override
  String recipeActionDeleteConfirm(String name) {
    return 'Receptactie \"$name\" verwijderen?';
  }

  @override
  String get recipeActionFailed => 'Receptactie mislukt';

  @override
  String get recipeActionSent => 'Recept verzonden';

  @override
  String get recipeActionUrlHint => 'Plaatsaanduidingen';

  @override
  String get recipeActionsDescription =>
      'Receptacties verschijnen in het menu van elk recept. \"Link\" opent de URL, \"Post\" laat de Mealie-server het recept naar de URL sturen.';

  @override
  String get recipeActionsEmpty => 'Nog geen receptacties.';

  @override
  String recipeDataDeleteConfirm(int count) {
    return 'Geselecteerde recepten ($count) verwijderen? Dit kan niet ongedaan worden gemaakt.';
  }

  @override
  String recipeDataDeleteForbidden(int count) {
    return 'Je mag $count van de geselecteerde recepten niet verwijderen (alleen de maker of een beheerder).';
  }

  @override
  String recipeDataDeleted(int count) {
    return 'Recepten verwijderd: $count';
  }

  @override
  String get recipeDataExportAction => 'Exporteren';

  @override
  String get recipeDataExportDone =>
      'Export aangemaakt – download het onder Data-exports.';

  @override
  String recipeDataExportExpires(String date) {
    return 'verloopt $date';
  }

  @override
  String get recipeDataExportFailed => 'Exporteren mislukt';

  @override
  String get recipeDataExportsEmpty => 'Geen exports beschikbaar.';

  @override
  String recipeDataUpdated(int count) {
    return 'Recepten bijgewerkt: $count';
  }

  @override
  String get recipeDuplicated => 'Recept gedupliceerd';

  @override
  String get recipeExportJson => 'Exporteren als JSON';

  @override
  String get recipeExportZip => 'Exporteren als ZIP (met afbeelding)';

  @override
  String get recipeShareCreate => 'Link maken';

  @override
  String get recipeShareDescription =>
      'Iedereen met de link kan dit recept in de browser bekijken – zonder account – tot de link verloopt.';

  @override
  String get recipeShareEmpty => 'Nog geen deellinks.';

  @override
  String recipeShareExpiresAt(String date) {
    return 'Verloopt $date';
  }

  @override
  String get recipeWebToolsMenu => 'Dupliceren, deellink en meer';

  @override
  String get reload => 'Opnieuw laden';

  @override
  String get reportDeleteConfirm => 'Dit rapport verwijderen?';

  @override
  String get reportEntries => 'Items';

  @override
  String get reportFailedEntries => 'Mislukt';

  @override
  String get reportOnlyFailed => 'Alleen mislukte items tonen';

  @override
  String get reportStatusFailure => 'Mislukt';

  @override
  String get reportStatusInProgress => 'Bezig';

  @override
  String get reportStatusPartial => 'Gedeeltelijk';

  @override
  String get reportStatusSuccess => 'Geslaagd';

  @override
  String get reportsEmpty => 'Nog geen rapporten.';

  @override
  String get uploadFailed => 'Uploaden mislukt';

  @override
  String webhookDeleteConfirm(String name) {
    return 'Webhook \"$name\" verwijderen?';
  }

  @override
  String get webhookEdit => 'Webhook bewerken';

  @override
  String get webhookNew => 'Nieuwe webhook';

  @override
  String get webhookTestFailed => 'Test kon niet worden gestart';

  @override
  String get webhookTestSent => 'Testwebhook verzonden';

  @override
  String get webhookTime => 'Tijd (lokaal)';

  @override
  String get webhooksEmpty => 'Nog geen webhooks.';

  @override
  String get zipImportFailed => 'ZIP-import mislukt';

  @override
  String get aiProvidersTitle => 'AI-aanbieders';

  @override
  String get aiProvidersDescription =>
      'Configureer AI-aanbieders om krachtige AI-aangedreven functies te activeren, zoals verbeterde ingrediëntherkenning, het aanmaken van recepten op basis van video\'s en nog meer!';

  @override
  String get aiProviderSettingsTitle => 'AI-aanbieder-instellingen';

  @override
  String get aiProvidersList => 'Aanbieders';

  @override
  String get aiProviderCreate => 'Aanbieder aanmaken';

  @override
  String get aiProviderEdit => 'Aanbieder bewerken';

  @override
  String get aiDefaultProvider => 'Standaard aanbieder';

  @override
  String get aiDefaultProviderDescription =>
      'Vereist om AI-functies in te schakelen';

  @override
  String get aiAudioProvider => 'Audioaanbieder';

  @override
  String get aiAudioProviderDescription =>
      'Maakt audiotransscriptie functionaliteiten mogelijk, waarmee recepten op basis van video\'s gemaakt kunnen worden';

  @override
  String get aiImageProvider => 'Afbeeldingsaanbieder';

  @override
  String get aiImageProviderDescription =>
      'Maakt beeldherkenningsfunctionaliteiten mogelijk, waarmee recepten op basis van afbeeldingen gemaakt kunnen worden';

  @override
  String get aiProviderName => 'Naam van de aanbieder';

  @override
  String get aiApiKey => 'API-sleutel';

  @override
  String get aiApiKeyCreateDescription =>
      'Je aanbieder\'s API-sleutel voor authenticatie. Als je service (bijv. Ollama) geen API-sleutel gebruikt moet je hier alsnog iets invoeren.';

  @override
  String get aiApiKeyEditDescription =>
      'Laat dit leeg tenzij je het wilt wijzigen.';

  @override
  String get aiBaseUrl => 'Basis-URL';

  @override
  String get aiBaseUrlDescription =>
      'Laat dit leeg als je OpenAI gebruikt. Dit moet een OpenAI-compatibel eindpunt zijn (bijv. \"http://localhost:11434/v1\").';

  @override
  String get aiModel => 'Model';

  @override
  String get aiModelDescription =>
      'Welk model je AI-aanbieder moet gebruiken (bijv. \"gpt-5\").';

  @override
  String get aiTimeout => 'Verzoek time-out (seconden)';

  @override
  String get aiProviderCreated => 'Aanbieder aangemaakt';

  @override
  String get aiProviderUpdated => 'Aanbieder bijgewerkt';

  @override
  String get aiProviderDeleted => 'Aanbieder verwijderd';

  @override
  String get aiProviderCreateFailed => 'Aanmaken van aanbieder mislukt';

  @override
  String get aiProviderUpdateFailed => 'Bijwerken van aanbieder mislukt';

  @override
  String get aiProviderDeleteFailed => 'Verwijderen van aanbieder mislukt';

  @override
  String get aiRequestHeaders => 'Aanvraagheaders';

  @override
  String get aiRequestParams => 'Aanvraag parameters';

  @override
  String get aiNoDefaultWarning =>
      'Je hebt geen standaard aanbieder ingesteld, AI-functies zijn uitgeschakeld';

  @override
  String get aiTestConnection => 'Verbinding testen';

  @override
  String get aiTestSucceeded => 'Verbinding geslaagd';

  @override
  String get aiTestFailed => 'Verbinding mislukt';

  @override
  String get aiSupportsImages => 'Ondersteunt afbeeldingen';

  @override
  String get aiTextOnly =>
      'Alleen tekst – kan niet je afbeeldingsaanbieder zijn';

  @override
  String get debugAiTitle => 'AI-aanbieders debuggen';

  @override
  String get debugAiDescription =>
      'Gebruik deze pagina om AI-aanbieders te debuggen. Test hier je AI-verbinding en bekijk de resultaten. Als beelddiensten aan staan, kun je ook een afbeelding meegeven.';

  @override
  String get debugParserTitle => 'Ontleder';

  @override
  String get debugParserDescription =>
      'Mealie gebruikt willekeurige voorwaardelijke velden (Conditional Random Fields, CRFs) voor het ontleden en verwerken van ingrediënten. Het model is gebaseerd op een gegevensset van meer dan 100.000 ingrediënten. Die komen uit een dataset die is samengesteld door de New York Times. Aangezien het model alleen in het Engels wordt getraind, kan het resultaat van het model in andere talen wisselend zijn. Deze pagina is een speeltuin om het model te testen.';

  @override
  String get debugIngredientText => 'Ingrediënttekst';

  @override
  String get debugTryExample => 'Probeer een voorbeeld';

  @override
  String debugAverageConfidence(String value) {
    return '$value overtuigd';
  }

  @override
  String get debugRunTest => 'Test starten';

  @override
  String get debugQuantity => 'Hoeveelheid';

  @override
  String get debugUnit => 'Eenheid';

  @override
  String get debugFood => 'Levensmiddelen';

  @override
  String get debugNote => 'Opmerking';

  @override
  String get debugGroup => 'Groep';

  @override
  String get aiProviderNone => 'Geen';

  @override
  String aiProviderDeleteConfirm(String name) {
    return 'Aanbieder \"$name\" verwijderen?';
  }

  @override
  String get aiProvidersEmpty => 'Nog geen AI-aanbieders.';

  @override
  String get aiAdvanced => 'Geavanceerd';

  @override
  String get aiKeyLabel => 'Naam';

  @override
  String get aiValueLabel => 'Waarde';

  @override
  String get debugTitle => 'Debug';

  @override
  String get debugParse => 'Ontleden';

  @override
  String get debugParseFailed => 'Ingrediënt kon niet worden ontleed';

  @override
  String get debugChooseImage => 'Afbeelding kiezen';

  @override
  String get debugNoImage => 'Geen afbeelding (optioneel)';

  @override
  String get updateTitle => 'Controleren op updates';

  @override
  String get updateInstalledVersion => 'Geïnstalleerde versie';

  @override
  String get updateLastCheck => 'Laatst gecontroleerd';

  @override
  String get updateCheckNow => 'Nu controleren';

  @override
  String get updateChecking => 'Zoeken naar updates…';

  @override
  String get updateUpToDate => 'Mealie Recipes is up-to-date.';

  @override
  String updateAvailable(String version) {
    return 'Versie $version is beschikbaar';
  }

  @override
  String get updateAvailableDescription =>
      'Er is een nieuwe versie van Mealie Recipes. Er wordt pas iets geïnstalleerd als je de update zelf start.';

  @override
  String get updateShow => 'Update bekijken';

  @override
  String get updateLater => 'Later';

  @override
  String updateDownloading(int percent) {
    return 'Downloaden… $percent %';
  }

  @override
  String updateReady(String version) {
    return 'Versie $version is klaar om te installeren';
  }

  @override
  String get updateInstalling => 'Installeren – de app start zo opnieuw…';

  @override
  String get updateManual =>
      'De update kon niet automatisch worden geïnstalleerd. De schijfkopie is geopend: sleep Mealie Recipes naar Apps.';

  @override
  String get updateFailed => 'Update mislukt';

  @override
  String get updateInstallNow => 'Downloaden en installeren';

  @override
  String get updateRestartNow => 'Installeren en herstarten';

  @override
  String get updateAutoTitle => 'Bij het starten op updates controleren';

  @override
  String get updateAutoDescription =>
      'Controleert alleen en meldt het – de installatie start je altijd zelf.';

  @override
  String get updateNoNotes => 'Geen release-opmerkingen.';

  @override
  String get updateSourceHint =>
      'Updates komen uit de GitHub-releases van Mealie Recipes en worden alleen geïnstalleerd als ze door de ontwikkelaar zijn ondertekend (macOS).';
}
