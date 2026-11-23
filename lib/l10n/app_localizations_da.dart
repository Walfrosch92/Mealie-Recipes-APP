// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Danish (`da`).
class AppLocalizationsDa extends AppLocalizations {
  AppLocalizationsDa([String locale = 'da']) : super(locale);

  @override
  String get endCookingMode => 'Afslut madlavningstilstand';

  @override
  String get endCookingModeConfirm =>
      'Vil du virkelig afslutte madlavningstilstanden?';

  @override
  String endCookingModeConfirmAll(int count) {
    return 'Alle $count opskrifter i madlavningstilstand afsluttes. Fortsæt?';
  }

  @override
  String get addTimer => 'Tilføj timer';

  @override
  String get recipeFinished => 'Din ret er klar.';

  @override
  String get bonAppetit => 'Velbekomme!';

  @override
  String get prepareIngredients => 'Gør følgende ingredienser klar';

  @override
  String prepareIngredientsFor(String servings) {
    return 'Gør følgende ingredienser klar til $servings portioner';
  }

  @override
  String get next => 'Næste';

  @override
  String get navHome => 'Hjem';

  @override
  String get homeCookToday => 'Laves i dag';

  @override
  String get homeSuggestion => 'Forslag';

  @override
  String get homeQuickAccess => 'Hurtig adgang';

  @override
  String get homePlanned => 'Planlagt';

  @override
  String get favorite => 'Favorit';

  @override
  String get navSettings => 'Indstillinger';

  @override
  String homeWelcomeName(Object name) {
    return 'Velkommen $name,';
  }

  @override
  String get homeWelcomeApp => 'til Mealie Recipes 👋';

  @override
  String get theme => 'Udseende';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Lyst';

  @override
  String get themeDark => 'Mørkt';

  @override
  String get recipes => 'Opskrifter';

  @override
  String get shoppingList => '🛒 Indkøbsliste';

  @override
  String get mealplan => 'Madplan';

  @override
  String get settings => '⚙️ Indstillinger';

  @override
  String get searchRecipe => 'Søg opskrift...';

  @override
  String get loadingRecipe => 'Indlæser opskrift...';

  @override
  String get errorLoadingRecipe => 'Opskriften kunne ikke indlæses.';

  @override
  String get noRecipesForCategory => 'Ingen opskrifter til dette filter.';

  @override
  String get resetFilter => 'Nulstil filter';

  @override
  String get allCategories => 'Alle kategorier';

  @override
  String get all => 'Alle';

  @override
  String get sortRecipes => 'Sortér opskrifter';

  @override
  String get refreshRecipes => 'Opdater';

  @override
  String get sortNameAZ => 'Navn A–Å';

  @override
  String get sortNameZA => 'Navn Å–A';

  @override
  String get sortDateNewest => 'Nyeste først';

  @override
  String get sortDateOldest => 'Ældste først';

  @override
  String get sortPrepTimeShort => 'Kortest forberedelsestid';

  @override
  String get sortPrepTimeLong => 'Længst forberedelsestid';

  @override
  String get sortRatingHighest => 'Højeste bedømmelse';

  @override
  String get sortRatingLowest => 'Laveste bedømmelse';

  @override
  String get details => 'Detaljer';

  @override
  String get ingredients => 'Ingredienser';

  @override
  String get instructions => 'Instruktioner';

  @override
  String get tags => 'Mærkater';

  @override
  String get notes => 'Kommentarer';

  @override
  String get addNote => 'Tilføj note';

  @override
  String get editNote => 'Rediger note';

  @override
  String get noteTitleHint => 'Titel (valgfri)';

  @override
  String get noteTextHint => 'Notetekst';

  @override
  String get deleteNoteTitle => 'Slet note?';

  @override
  String get deleteNoteMessage => 'Denne note slettes permanent.';

  @override
  String get servings => 'Portioner';

  @override
  String get planMeal => 'Planlæg måltid';

  @override
  String get addAllIngredients => 'Tilføj alle ingredienser';

  @override
  String get addSelectedIngredients => 'Tilføj valgte ingredienser';

  @override
  String get addIngredientsMessage =>
      'Ingredienserne er tilføjet til din indkøbsliste.';

  @override
  String addIngredientsFailedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ingredienser kunne ikke tilføjes.',
      one: '1 ingrediens kunne ikke tilføjes.',
    );
    return '$_temp0';
  }

  @override
  String get cookbooks => 'Kogebøger';

  @override
  String get cookbooksEmpty =>
      'Ingen kogebøger endnu. Tryk på “+” øverst til højre for at oprette en.';

  @override
  String get cookbookNoMatches => 'Ingen opskrifter matcher dette filter.';

  @override
  String get cookbookCreateTitle => 'Opret kogebog';

  @override
  String get cookbookEditTitle => 'Rediger kogebog';

  @override
  String get cookbookNameLabel => 'Kogebogens navn';

  @override
  String get cookbookFilterSectionTitle => 'Tilføj opskrifter automatisk';

  @override
  String get cookbookFieldTools => 'Redskaber';

  @override
  String get cookbookFieldUsers => 'Brugere';

  @override
  String get cookbookOpIsOneOf => 'er en af';

  @override
  String get cookbookOpIsNotOneOf => 'er ikke en af';

  @override
  String get cookbookOpContainsAll => 'indeholder alle';

  @override
  String get cookbookSelectValues => 'Vælg værdier';

  @override
  String get cookbookFilterOptionsUnavailable =>
      'Ingen muligheder tilgængelige';

  @override
  String get cookbookAddFilterField => 'Tilføj felt';

  @override
  String get cookbookPublicLabel => 'Offentlig kogebog';

  @override
  String get cookbookPublicSubtitle => 'Synlig for andre husstande på serveren';

  @override
  String get cookbookRawModeEnter => 'Rediger som tekst';

  @override
  String get cookbookRawModeExit => 'Tilbage til byggeren';

  @override
  String get cookbookRawModeHint =>
      'Appens eksperttilstand: redigerer filteret direkte som tekst. Nyttigt, når et eksisterende filter ikke kunne opdeles i enkle rækker.';

  @override
  String get cookbookRawModeUnparseable =>
      'Denne tekst passer ikke til det enkle rækkeformat — den forbliver tekst.';

  @override
  String get saveFailed => 'Kunne ikke gemme';

  @override
  String get search => 'Søg';

  @override
  String get apply => 'Anvend';

  @override
  String get setupCachingTitle => 'Indlæser dine opskrifter';

  @override
  String get setupCachingSubtitle =>
      'Dine opskrifter klargøres til brug offline. Afhængigt af hvor mange du har, kan det tage et øjeblik.';

  @override
  String get setupCachingDone => 'Alt klar!';

  @override
  String get setupTipsHeader => 'Vidste du?';

  @override
  String get setupFinish => 'Kom i gang';

  @override
  String get setupSkipCaching => 'Fortsæt i baggrunden';

  @override
  String get setupTip1 =>
      'Du kan importere opskrifter fra et link, et foto eller en PDF — via feltet Importér på startskærmen.';

  @override
  String get setupTip2 =>
      'Madlavningstilstand holder skærmen tændt, guider dig trin for trin og finder automatisk timere i teksten.';

  @override
  String get setupTip3 =>
      'Indkøbslisten virker også offline — ændringer synkroniseres automatisk, når serveren kan nås.';

  @override
  String get setupTip4 =>
      'Hold et felt nede på startskærmen for at ændre rækkefølgen i hurtig adgang.';

  @override
  String get setupTip5 =>
      'Dine Mealie-kogebøger finder du i feltet Kogebøger — også offline.';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Annuller';

  @override
  String get delete => 'Slet';

  @override
  String get edit => 'Rediger';

  @override
  String get save => 'Gem';

  @override
  String get done => 'Udført';

  @override
  String get close => 'Luk';

  @override
  String get add => 'Tilføj';

  @override
  String get send => 'Send';

  @override
  String get retry => 'Prøv igen';

  @override
  String get confirmDeleteTitle => 'Slet opskrift?';

  @override
  String get confirmDeleteMessage => 'Denne handling kan ikke fortrydes.';

  @override
  String get sendToDevice => 'Send til enhed';

  @override
  String get timerFinished => 'Timeren er færdig!';

  @override
  String get timer => 'Timer';

  @override
  String get newTimer => 'Ny timer';

  @override
  String get timerNamePlaceholder => 'Timerens navn';

  @override
  String get durationLabel => 'Varighed';

  @override
  String get start => 'Start';

  @override
  String get stop => 'Stop';

  @override
  String get pause => 'Pause';

  @override
  String get resume => 'Fortsæt';

  @override
  String get finished => 'Færdig!';

  @override
  String stepNumber(int number) {
    return 'Trin $number';
  }

  @override
  String get minAbbreviation => 'min';

  @override
  String get cookingMode => 'Madlavningstilstand';

  @override
  String get endAll => 'Afslut alle';

  @override
  String get end => 'Afslut';

  @override
  String get noActiveTimers => 'Ingen aktive timere';

  @override
  String get noActiveRecipes => 'Ingen aktive opskrifter';

  @override
  String get startRecipeToCook =>
      'Åbn en opskrift, og tryk på knappen for madlavningstilstand for at starte.';

  @override
  String get browseRecipes => 'Gennemse opskrifter';

  @override
  String get cookFriends => 'Lav mad med venner';

  @override
  String get cookingModeAddRecipe => 'Tilføj opskrift';

  @override
  String get cookingModeAddRecipeSearchHint => 'Søg opskrifter';

  @override
  String get cookFriendsCode => 'Sessionskode';

  @override
  String get cookFriendsJoin => 'Deltag i session';

  @override
  String get cookFriendsHost => 'Start session';

  @override
  String get cookFriendsHostNotFound =>
      'Værten blev ikke fundet. Sørg for, at begge enheder er på samme Wi-Fi, og at adgang til lokalt netværk er tilladt.';

  @override
  String get cookFriendsConnectionFailed =>
      'Forbindelsen mislykkedes. Prøv igen.';

  @override
  String get cookFriendsEnterCode => 'Indtast kode';

  @override
  String cookFriendsConnected(int count) {
    return 'Forbundet: $count gæster';
  }

  @override
  String get joinSession => 'Deltag i session';

  @override
  String get hostEndedSessionMessage =>
      'Værten har afsluttet madlavningssessionen.';

  @override
  String get addItem => 'Tilføj vare';

  @override
  String get itemNote => 'Varens navn';

  @override
  String get unlabeledCategory => 'Uden etiket';

  @override
  String get archivedLists => '📦 Arkiverede indkøb';

  @override
  String get postimportAction => 'Efter import';

  @override
  String get postimportHint =>
      'Vælg, hvad der skal ske med de importerede poster i kildeappen (Påmindelser / Google Tasks).';

  @override
  String get postimportLeave => 'Bare tilføj';

  @override
  String get postimportComplete => 'Afkryds';

  @override
  String get postimportCompleteDelete => 'Afkryds og slet';

  @override
  String get postimportFailed =>
      'Efterbehandlingen i kildeappen mislykkedes. Varerne blev alligevel tilføjet til Mealie.';

  @override
  String get syncChangesTitle => 'Synkroniser ændringer';

  @override
  String get syncSectionChecked => 'Afkrydset';

  @override
  String get syncSectionQuantity => 'Antal';

  @override
  String get syncSectionCategory => 'Kategori';

  @override
  String get syncSectionAdditions => 'Nyligt tilføjet';

  @override
  String get syncLocalLabel => 'Lokalt';

  @override
  String get syncServerLabel => 'Server';

  @override
  String get syncNow => 'Synkroniser nu';

  @override
  String get offlineBadge => 'Offline';

  @override
  String get mealplanTitle => '📅 Madplan';

  @override
  String get breakfast => 'Morgenmad';

  @override
  String get lunch => 'Frokost';

  @override
  String get dinner => 'Aftensmad';

  @override
  String get addMealEntry => 'Tilføj måltid';

  @override
  String get selectRecipe => 'Vælg opskrift';

  @override
  String get importRecipe => 'Importér opskrift';

  @override
  String get url => 'URL';

  @override
  String get importLanguage => 'Sprog til OCR';

  @override
  String get setupTitle => 'Velkommen til Mealie Recipes';

  @override
  String get setupSubtitle => 'Konfigurer din Mealie-server.';

  @override
  String get serverUrl => 'Serverens URL';

  @override
  String get serverUrlPlaceholder => 'https://mealie.example.com';

  @override
  String get apiToken => 'API-token';

  @override
  String get apiTokenPlaceholder => 'Dit API-token';

  @override
  String get householdId => 'Husstand';

  @override
  String get householdIdPlaceholder => 'Familie';

  @override
  String get shoppingListId => 'Indkøbslistens ID';

  @override
  String get setupHouseholdListTitle => 'Husstand og indkøbsliste';

  @override
  String get shoppingListLabel => 'Indkøbsliste';

  @override
  String get setupHouseholdManualHint =>
      'Husstande kunne ikke indlæses — indtast husstandens navn manuelt.';

  @override
  String get setupExactTitle => 'Mængder på indkøbslisten';

  @override
  String get setupExactBody =>
      'I de fleste lande handler man ikke på grammet — man lægger 1 pakke smør i kurven, ikke 200 g. I enkel tilstand omregner appen derfor opskriftens mængder til “1×”. I præcis tilstand bevares mængde og enhed 1:1 som i Mealies webapp — også når du skriver nye varer (f.eks. “200 g smør”). Du kan ændre det når som helst i indstillingerne.';

  @override
  String get setupExactSimpleTitle => 'Enkel tilstand (1×)';

  @override
  String get setupExactSimpleBody =>
      'Ingredienser kommer på listen som “1× vare” — ideelt til hurtig afkrydsning i butikken.';

  @override
  String get setupExactExactTitle => 'Præcise mængder';

  @override
  String get setupExactExactBody =>
      'Varer vises med mængde og enhed, f.eks. “200 g smør” — præcis som i webappen.';

  @override
  String get connect => 'Forbind';

  @override
  String connectionError(String error) {
    return 'Forbindelsen mislykkedes: $error';
  }

  @override
  String get optionalHeaders => 'Valgfrie HTTP-headers (til reverse proxy)';

  @override
  String get settingsTitle => '⚙️ Indstillinger';

  @override
  String get settingsSaved => 'Indstillinger gemt';

  @override
  String get securitySettings => 'Sikkerhed';

  @override
  String get showRecipeImages => 'Vis opskriftsbilleder';

  @override
  String get apiVersion => 'API-version';

  @override
  String get language => 'Sprog';

  @override
  String get biometricLock => 'Biometrisk lås';

  @override
  String get biometricLockDescription => 'Lås appen op med biometri';

  @override
  String get enableLogging => 'Aktivér logning';

  @override
  String get selectLanguage => 'Vælg sprog';

  @override
  String get setupContinue => 'Fortsæt';

  @override
  String get back => 'Tilbage';

  @override
  String get setupConnectStep => 'Forbind til din server';

  @override
  String get resetSettings => 'Nulstil alle indstillinger';

  @override
  String get resetSettingsConfirm => 'Alle indstillinger nulstilles. Fortsæt?';

  @override
  String get guestMode => 'Gæstetilstand';

  @override
  String get appVersion => 'Version';

  @override
  String get leftoverFinder => 'Opskriftssøger';

  @override
  String get addIngredient => 'Tilføj ingrediens';

  @override
  String get biometricPrompt => 'Godkend for at åbne Mealie Recipes';

  @override
  String get biometricFailed => 'Godkendelsen mislykkedes';

  @override
  String get pendingRecipesTitle => 'Modtagne opskrifter';

  @override
  String pendingRecipesFrom(Object names) {
    return 'Fra $names';
  }

  @override
  String get pendingRecipesOpenCooking => 'Åbn madlavningstilstand';

  @override
  String get dismiss => 'Luk';

  @override
  String get editRecipe => 'Rediger opskrift';

  @override
  String get recipeName => 'Opskriftens navn';

  @override
  String get prepTime => 'Forberedelsestid (min)';

  @override
  String get cookTime => 'Tilberedningstid (min)';

  @override
  String get totalTime => 'Samlet tid (min)';

  @override
  String get recipeServings => 'Portioner';

  @override
  String get rating => 'Bedømmelse';

  @override
  String get addIngredientLine => 'Tilføj ingrediens';

  @override
  String get addInstruction => 'Tilføj trin';

  @override
  String get removeIngredient => 'Fjern ingrediens';

  @override
  String get removeInstruction => 'Fjern trin';

  @override
  String get ingredientName => 'Ingrediens';

  @override
  String get ingredientQuantity => 'Antal';

  @override
  String get ingredientUnit => 'Enhed';

  @override
  String get ingredientNote => 'Note';

  @override
  String get instructionText => 'Trinnets tekst';

  @override
  String get categories => 'Kategorier';

  @override
  String get saveChanges => 'Gem ændringer';

  @override
  String get saveSuccess => 'Opskriften er gemt.';

  @override
  String get newCategory => 'Ny kategori';

  @override
  String get newTag => 'Nyt mærkat';

  @override
  String get setRating => 'Angiv bedømmelse';

  @override
  String get homeWelcome => 'Velkommen til Mealie Recipes! 👋';

  @override
  String homeWelcomeNamed(String name) {
    return 'Velkommen $name, til Mealie Recipes! 👋';
  }

  @override
  String get shopping => 'Indkøb';

  @override
  String get planning => 'Planlægning';

  @override
  String get other => 'Andet';

  @override
  String get addRecipe => '➕ Tilføj opskrift';

  @override
  String get completeShopping => 'Afslut indkøb';

  @override
  String get shoppingCompleted => 'Indkøb afsluttet';

  @override
  String get shoppingCompletedSubtitle => 'Alt i kurven! 🎉';

  @override
  String get shoppingOfflineNoCache => 'Offline – listen er ikke gemt';

  @override
  String get shoppingOfflineNoCacheSubtitle =>
      'Ingen varer fra denne liste er gemt på enheden endnu. Den indlæses, så snart du er online igen.';

  @override
  String get essensplan => '📅 Madplan';

  @override
  String get resteverwertung => '🥗 Opskriftssøgning';

  @override
  String get copyCode => 'Kopiér kode';

  @override
  String get shareLink => 'Del link';

  @override
  String get connectedFriends => 'Forbundne venner';

  @override
  String get waitingForFriends => 'Venter på venner...';

  @override
  String get sessionCode => 'SESSIONSKODE';

  @override
  String get loading => 'Indlæser...';

  @override
  String get urlInvalidScheme =>
      'URL\'en skal starte med http:// eller https://';

  @override
  String get urlAddScheme => 'Tilføj https://';

  @override
  String get addItemPlaceholder => 'Tilføj vare...';

  @override
  String get completedItems => 'Fuldført';

  @override
  String get completeShoppingTitle => 'Afslut indkøb?';

  @override
  String get completeShoppingMessage => 'Slet afkrydsede varer?';

  @override
  String get recipeListTitle => '📖 Opskrifter';

  @override
  String get importRecipeTitle => 'Upload ny opskrift';

  @override
  String get uploadRecipeUrl => 'Importér via opskriftens URL';

  @override
  String get uploadRecipeUrlHint =>
      'Indtast opskriftens URL for at gemme den på din server';

  @override
  String get uploadOpenAI => 'Importér fra fil via OpenAI';

  @override
  String get uploadOpenAIHint =>
      'Upload alternativt fotos eller en PDF af en opskrift. Hvis opskriften fylder flere sider, tilføjer du bare flere — de analyseres samlet af AI.';

  @override
  String get takePhoto => 'Kamera';

  @override
  String get cameraPermissionDenied =>
      'Ingen adgang til kameraet. Tillad det i systemindstillingerne for at fotografere opskrifter.';

  @override
  String get cameraUnavailable => 'Intet kamera tilgængeligt på denne enhed.';

  @override
  String get selectPhoto => 'Fotos';

  @override
  String get selectPdf => 'PDF';

  @override
  String get openAIHintTitle => 'Info om filanalyse';

  @override
  String get openAIHintBody =>
      'Opskriftsanalysen bruger OpenAI\'s API. Sørg for, at din API-nøgle er konfigureret i Mealie-serverens indstillinger.';

  @override
  String get allDeleteConfirm => 'Slet alle';

  @override
  String get entriesInOtherWeeks => 'Der er poster i andre uger';

  @override
  String get availableWeeks => 'Tilgængelige uger:';

  @override
  String get currentWeek => 'Aktuel uge';

  @override
  String get weekAbbreviation => 'Uge';

  @override
  String get today => 'I dag';

  @override
  String get selectDate => 'Vælg dato';

  @override
  String get selectedRecipe => 'Valgt opskrift';

  @override
  String get confirmMeal => 'Planlæg måltid';

  @override
  String get searchRecipes => 'Søg opskrifter';

  @override
  String get addCustomMeal => 'Tilføj eget måltid';

  @override
  String get diceModeButton => 'Slå tilfældige opskrifter';

  @override
  String get diceModeTitle => '3 tilfældige forslag';

  @override
  String get diceBackToSearch => 'Tilbage til søgningen';

  @override
  String get diceNotEnoughRecipes =>
      'For få opskrifter til terningtilstand (mindst 3 kræves)';

  @override
  String get entrySingular => 'post';

  @override
  String get entriesPlural => 'poster';

  @override
  String get deleteAllConfirmTitle => 'Slet alle?';

  @override
  String get deleteAllConfirmMessage => 'Vil du slette alle arkiverede indkøb?';

  @override
  String get uploadFromUrlButton => 'Importér opskrift fra URL';

  @override
  String get uploadingImage => 'Uploader...';

  @override
  String get uploadErrorTitle => 'Upload mislykkedes';

  @override
  String get uploadSuccessTitle => 'Upload gennemført';

  @override
  String get editImportedRecipeQuestion =>
      'Vil du redigere den nye opskrift nu?';

  @override
  String get notNow => 'Ikke nu';

  @override
  String get pdfTooLarge => 'PDF-filen er for stor (maks. 10 MB).';

  @override
  String get invalidUrl => 'Ugyldig URL. Indtast en gyldig HTTP(S)-URL.';

  @override
  String get cookWithFriends => 'Lav mad med venner';

  @override
  String get cookFriendsSubtitle =>
      'Inviter en ven til at lave denne opskrift sammen';

  @override
  String get copied => 'Kopieret';

  @override
  String get linkCopied => 'Link kopieret';

  @override
  String get startCooking => 'Begynd at lave mad';

  @override
  String get uploadToOwnServer => 'Gem på min server';

  @override
  String get uploadingRecipe => 'Uploader opskrift…';

  @override
  String get recipeUploadedToOwnServer => 'Opskriften er gemt på din server';

  @override
  String get recipeUploadFailed => 'Upload mislykkedes';

  @override
  String get allowGuestSaveRecipes =>
      'Lad gæster gemme opskrifter på deres egen server';

  @override
  String get appIcon => 'App-ikon';

  @override
  String get name => 'Navn';

  @override
  String get color => 'Farve';

  @override
  String get randomColor => 'Tilfældig farve';

  @override
  String get createFailed => 'Kunne ikke oprette';

  @override
  String get deleteFailed => 'Kunne ikke slette';

  @override
  String deleteOrganizerConfirm(String name) {
    return 'Slet “$name”? Den fjernes også på serveren.';
  }

  @override
  String get connectionSection => 'Forbindelse';

  @override
  String get token => 'Token';

  @override
  String get advancedOptions => 'Avancerede indstillinger';

  @override
  String get mealieApiVersion => 'Mealie API-version';

  @override
  String get sendOptionalHeaders => 'Send valgfrie headers';

  @override
  String get offlineRecipeImages => 'Gem opskriftsbilleder offline';

  @override
  String get offlineRecipeImagesHint =>
      'Henter alle opskriftsbilleder til enheden – også billederne i trin og noter – så de vises uden forbindelse. Store samlinger kan fylde flere hundrede MB. Slås det fra, slettes de gemte billeder.';

  @override
  String offlineRecipeImagesStatus(int count, int total, String size) {
    return 'Gemt: $count/$total · $size';
  }

  @override
  String get offlineRecipeImagesDisableConfirm =>
      'Slet alle gemte opskriftsbilleder?';

  @override
  String headerNameLabel(int n) {
    return 'Navn på header $n';
  }

  @override
  String headerValueLabel(int n) {
    return 'Værdi for header $n';
  }

  @override
  String get value => 'Værdi';

  @override
  String get personalization => 'Personalisering';

  @override
  String get showRecipeImagesSubtitle => 'Viser billeder i opskriftslisten';

  @override
  String get exactQuantities => 'Tilføj præcise mængder';

  @override
  String get exactQuantitiesSubtitle =>
      'Ingredienser og indtastede varer beholder mængde og enhed (f.eks. 200 g smør) i stedet for 1× pr. vare';

  @override
  String get remindToShop => 'Mind mig om at handle';

  @override
  String get remindToShopSubtitle =>
      'Giver besked, når du er nær et gemt sted, og indkøbslisten har åbne varer — også når appen er lukket';

  @override
  String get shoppingReminderAddLocation => 'Tilføj sted';

  @override
  String get shoppingReminderMaxLocations => 'Maksimum på 3 steder er nået';

  @override
  String get shoppingReminderLocationServiceDisabled =>
      'Lokalitetstjenester er slået fra på denne enhed';

  @override
  String get shoppingReminderPermissionTitle => 'Adgang til lokalitet kræves';

  @override
  String get shoppingReminderPermissionMessage =>
      'For at minde dig om det nær en butik kræves lokalitetsadgang “Altid” — også når appen er lukket. Slå det til i Indstillinger.';

  @override
  String get openSettings => 'Åbn Indstillinger';

  @override
  String get shoppingReminderLocationName => 'Navn';

  @override
  String get shoppingReminderUseCurrentLocation => 'Brug nuværende placering';

  @override
  String get shoppingReminderOrAddress => 'eller indtast en adresse';

  @override
  String get shoppingReminderAddress => 'Adresse';

  @override
  String get shoppingReminderAddressPlaceholder => 'Gade, by';

  @override
  String get shoppingReminderSearchAddress => 'Søg';

  @override
  String get shoppingReminderLocationFailed =>
      'Din placering kunne ikke bestemmes';

  @override
  String get shoppingReminderAddressNotFound => 'Adressen blev ikke fundet';

  @override
  String get ratingFailed => 'Bedømmelsen kunne ikke gemmes — prøv igen.';

  @override
  String get lastCooked => 'Senest lavet';

  @override
  String get syncLastCooked => 'Opdater “senest lavet”';

  @override
  String get syncLastCookedSubtitle =>
      'Gemmer dagens dato og en tidslinjepost på serveren — som Mealies webapp.';

  @override
  String get developer => 'Udvikler';

  @override
  String get enableLoggingSubtitle =>
      'Gemmer print-/fejllogs (seneste 500 linjer)';

  @override
  String get entriesLabel => 'Poster';

  @override
  String get fileSize => 'Filstørrelse';

  @override
  String get showAction => 'Vis';

  @override
  String get copy => 'Kopier';

  @override
  String logsWithCount(int count) {
    return 'Logs ($count)';
  }

  @override
  String get noLogs => 'Ingen logs tilgængelige';

  @override
  String get logsTitle => 'Logs';

  @override
  String get required => 'Påkrævet';

  @override
  String get connectionFailedCheck =>
      'Forbindelsen mislykkedes. Tjek URL og token.';

  @override
  String get username => 'Brugernavn';

  @override
  String get password => 'Adgangskode';

  @override
  String get setupPasswordHint =>
      'Din adgangskode gemmes ikke — appen logger ind én gang og opretter et API-token ud fra den (som Profil → API-tokens i webappen).';

  @override
  String get loginAndConnect => 'Log ind og forbind';

  @override
  String get loginInvalidCredentials =>
      'Brugernavn eller adgangskode er forkert.';

  @override
  String get apiTokenSaveHint =>
      'Token anvendt — tryk på “Gem ændringer” nedenfor.';

  @override
  String get renewApiToken => 'Forny API-token';

  @override
  String get setupAuthChoiceTitle => 'Hvordan vil du logge ind?';

  @override
  String get authModePasswordTitle => 'Lad appen oprette en API-nøgle til mig';

  @override
  String get authModePasswordSubtitle =>
      'Log ind med brugernavn og adgangskode — appen opretter et token automatisk.';

  @override
  String get authModeTokenTitle => 'Jeg har allerede en API-nøgle';

  @override
  String get authModeTokenSubtitle =>
      'Kopieret fra Mealie-profilen (Profil → API-tokens).';

  @override
  String keyN(int n) {
    return 'Nøgle $n';
  }

  @override
  String valueN(int n) {
    return 'Værdi $n';
  }

  @override
  String get openCookingMode => 'Åbn madlavningstilstand';

  @override
  String activeRecipes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count aktive opskrifter',
      one: '1 aktiv opskrift',
    );
    return '$_temp0';
  }

  @override
  String get reparseIngredients => 'Fortolk ingredienser igen';

  @override
  String get reparseIngredientsSubtitle =>
      'Opdel mængde/enhed/ingrediens (f.eks. “200 g mel”)';

  @override
  String get reparseDone =>
      'Ingredienser opdelt – tryk på “Gem ændringer” for at anvende';

  @override
  String get tagsAndCategories => 'Mærkater, kategorier og redskaber';

  @override
  String get tapToAddPhoto => 'Tryk for at tilføje foto';

  @override
  String get descriptionLabel => 'Beskrivelse';

  @override
  String get searchingDevices => 'Søger efter enheder på samme Wi-Fi…';

  @override
  String get selectAll => 'Vælg alle';

  @override
  String get importReminders => 'Importér påmindelser';

  @override
  String get importGoogleTasks => 'Importér Google Tasks';

  @override
  String get noTaskLists => 'Ingen opgavelister fundet';

  @override
  String get noReminderLists => 'Ingen påmindelseslister fundet';

  @override
  String importCount(int count) {
    return 'Importér $count';
  }

  @override
  String get noIngredientsToLink => 'Ingen ingredienser at linke endnu';

  @override
  String get importLanguageSubtitle =>
      'Sprog for opskrifter importeret fra foto eller PDF';

  @override
  String get importLanguageSearch => 'Søg sprog';

  @override
  String get importLanguageFollowApp => 'Samme som appens sprog';

  @override
  String get importLanguageNoMatch => 'Intet sprog fundet';

  @override
  String get setupImportLanguageTitle => 'AI-import af opskrifter';

  @override
  String get setupImportLanguageBody =>
      'Fotos og PDF\'er kan laves om til opskrifter af AI. Vælg, hvilket sprog de skal ende på — praktisk, hvis dit modersmål ikke findes som appsprog. Du kan ændre det senere i indstillingerne.';

  @override
  String get setupImportLanguageSearchHint =>
      'Brug søgningen i vælgeren til at finde sprog, som appens brugerflade ikke tilbyder.';

  @override
  String get setupCachingKeepOpenTitle => 'Hold appen åben';

  @override
  String get setupCachingKeepOpenBody =>
      'Indlæsningen kører i forgrunden. Lad appen være åben, til den er færdig — lukker du den eller skifter væk for længe, stopper processen og starter forfra senere.';

  @override
  String get supportContact => 'Kontakt support';

  @override
  String get supportDialogMessage =>
      'Beskriv dit problem, så vender vi tilbage. Loggen hjælper meget ved fejlsøgning — du kan vedhæfte den som tekstfil.';

  @override
  String get supportWithoutLogs => 'Uden log';

  @override
  String get supportWithLogs => 'Vedhæft log';

  @override
  String get supportMailSubject => 'Mealie Recipes — Support';

  @override
  String get supportMailHint => 'Beskriv dit problem her:';

  @override
  String get supportLogsEmpty =>
      'Loggen er tom. Slå logning til, genskab problemet, og send den så.';

  @override
  String supportAddressCopied(String email) {
    return 'Adresse kopieret: $email';
  }

  @override
  String supportNoMailApp(String email) {
    return 'Ingen mailapp er sat op – adresse kopieret: $email. Vælg en anden app for at skrive til os.';
  }

  @override
  String get createRecipeFromImages => 'Opret opskrift';

  @override
  String imagePagesSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sider valgt',
      one: '1 side valgt',
    );
    return '$_temp0';
  }

  @override
  String get imagePagesHint =>
      'Det første billede bliver opskriftens hovedbillede. Hold en side nede for at ændre rækkefølgen.';

  @override
  String get mainImageBadge => 'Hoved';

  @override
  String maxImagesReached(int max) {
    return 'Du kan tilføje op til $max billeder pr. opskrift.';
  }

  @override
  String get removePage => 'Fjern side';

  @override
  String get preparingPdf => 'Behandler PDF...';

  @override
  String get recipeOptionsTitle => 'Indstillinger';

  @override
  String get exportAsPdf => 'Eksportér som PDF';

  @override
  String get generatingPdf => 'Opretter PDF…';

  @override
  String get pdfExportFailed => 'PDF-eksport mislykkedes';

  @override
  String get recipeTime => 'Tid';

  @override
  String get addIngredientSection => 'Tilføj afsnit';

  @override
  String get aiImportToggle => 'Analysér med AI';

  @override
  String get aiImportToggleHint =>
      'Også til opskriftsvideoer (YouTube, Instagram, TikTok …) og sider, som den almindelige import ikke kan læse. Kræver en AI-udbyder på din Mealie-server — til videoer også en lydudbyder.';

  @override
  String get aiImportButton => 'Importér med AI';

  @override
  String get aiImportRunning =>
      'AI\'en analyserer linket … videoer kan tage et par minutter.';

  @override
  String get aiImportFailed =>
      'AI-importen mislykkedes. Tjek AI-indstillingerne på din Mealie-server.';

  @override
  String get stepHeadingLabel => 'Overskrift for trin (valgfri)';

  @override
  String get linkedRecipeLabel => 'Linket opskrift';

  @override
  String get toolsTitle => 'Redskaber';

  @override
  String get prepareTools => 'Find følgende redskaber frem';

  @override
  String get newTool => 'Nyt redskab';

  @override
  String get renameAction => 'Omdøb';

  @override
  String get organizerEmpty =>
      'Intet her endnu. Tryk på “+” øverst til højre for at oprette.';

  @override
  String organizerRecipeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count opskrifter',
      one: '1 opskrift',
      zero: 'Ingen opskrifter',
    );
    return '$_temp0';
  }

  @override
  String get toolOnHand => 'Haves';

  @override
  String get mealDiceSettingsHint =>
      'Vælg kategorier og mærkater for hvert måltid. Når du slår med terningen, foreslås kun opskrifter med mindst én af dem. Samme post kan bruges til flere måltider.';

  @override
  String get mealDiceSettingsNoneHint =>
      'Intet valgt for dette måltid: terningen vælger automatisk ud fra kategorinavne som “Morgenmad”, “Frokost” eller “Aftensmad”.';

  @override
  String get mealDiceAutoHintTitle => 'Automatisk valg';

  @override
  String get mealDiceAutoHintBody =>
      'Der er endnu ikke valgt kategorier eller mærkater for dette måltid. Terningen leder derfor efter kategorier som “Morgenmad”, “Frokost” eller “Aftensmad” og fylder op med andre opskrifter.\n\nFor selv at vælge: tryk på tandhjulet ved siden af “+” i madplanen.';

  @override
  String get dontShowAgain => 'Vis ikke igen';

  @override
  String get mealDiceNoMatches =>
      'Ingen opskrift matcher de kategorier og mærkater, der er valgt for dette måltid.';

  @override
  String mealDiceFewMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Kun $count matchende opskrifter',
      one: 'Kun 1 matchende opskrift',
    );
    return '$_temp0';
  }

  @override
  String get commentsTitle => 'Kommentarer';

  @override
  String get commentHint => 'Skriv en kommentar…';

  @override
  String get commentSaveFailed => 'Kommentaren kunne ikke gemmes.';

  @override
  String get commentDeleteConfirm => 'Slet denne kommentar?';

  @override
  String get cookingDoneCommentLabel => 'Kommentar (valgfri)';

  @override
  String get cookingDoneCommentHint => 'Hvordan blev det? Tips til næste gang…';

  @override
  String get nutritionTitle => 'Ernæring';

  @override
  String get nutritionPerServing => 'pr. portion';

  @override
  String get nutritionCalories => 'Kalorier';

  @override
  String get nutritionFat => 'Fedt';

  @override
  String get nutritionSaturatedFat => 'Mættet fedt';

  @override
  String get nutritionTransFat => 'Transfedt';

  @override
  String get nutritionUnsaturatedFat => 'Umættet fedt';

  @override
  String get nutritionCholesterol => 'Kolesterol';

  @override
  String get nutritionSodium => 'Salt';

  @override
  String get nutritionCarbohydrates => 'Kulhydrater';

  @override
  String get nutritionFiber => 'Kostfibre';

  @override
  String get nutritionSugar => 'Sukker';

  @override
  String get nutritionProtein => 'Protein';

  @override
  String get timelineTitle => 'Tidslinje';

  @override
  String get timelineMadeThis => 'Jeg har lavet det';

  @override
  String timelineUserMadeThis(String name) {
    return '$name har lavet det';
  }

  @override
  String get timelineEmpty => 'Ingen poster på tidslinjen endnu.';

  @override
  String get timelineDate => 'Dato';

  @override
  String get timelineNoteHint => 'Note (valgfri)';

  @override
  String get timelineAddPhoto => 'Tilføj foto';

  @override
  String get timelineRemovePhoto => 'Fjern foto';

  @override
  String get timelineSaved => 'Tilføjet til tidslinjen';

  @override
  String get timelineSaveFailed => 'Kunne ikke tilføjes til tidslinjen';

  @override
  String get timelineImageFailed =>
      'Posten er gemt, men fotoet kunne ikke uploades';

  @override
  String get timelineDeleteConfirm => 'Slet denne post fra tidslinjen?';

  @override
  String get timelineEditNote => 'Rediger note';

  @override
  String get timelineUnknownRecipe => 'Opskriften blev ikke fundet';

  @override
  String get cookingDonePhotoHint => 'Foto til Mealies tidslinje (valgfri)';

  @override
  String get assetsTitle => 'Vedhæftninger';

  @override
  String get assetsAdd => 'Tilføj vedhæftning';

  @override
  String get assetsChooseFile => 'Fil';

  @override
  String get assetsUploading => 'Uploader…';

  @override
  String get assetsUploadFailed => 'Vedhæftningen kunne ikke uploades';

  @override
  String assetsDeleteConfirm(String name) {
    return 'Fjern “$name” fra vedhæftningerne?';
  }

  @override
  String get assetsOpenFailed => 'Vedhæftningen kunne ikke åbnes';

  @override
  String get assetsUnsupported =>
      'Mealie understøtter kun PDF, billeder, TXT, MD, CSV og JSON.';

  @override
  String get assetsShare => 'Del';

  @override
  String get mealRulesTitle => 'Mealie-regler';

  @override
  String get mealRulesHint =>
      'Bruges også af Mealies webapp. Hvis flere regler gælder for dagen og måltidet, skal alle passe. Gælder ingen regel, vælger terningen blandt alle opskrifter.';

  @override
  String get mealRuleAdd => 'Tilføj regel';

  @override
  String get mealRuleNewTitle => 'Ny regel';

  @override
  String get mealRuleEditTitle => 'Rediger regel';

  @override
  String get mealRuleDay => 'Dag';

  @override
  String get mealRuleAnyDay => 'Enhver dag';

  @override
  String get mealRuleMealType => 'Måltid';

  @override
  String get mealRuleAnyMeal => 'Ethvert måltid';

  @override
  String get mealRuleConditionsTitle => 'Betingelser';

  @override
  String get mealRuleAllRecipes => 'Alle opskrifter';

  @override
  String get mealRuleDeleteConfirm => 'Slet denne regel?';

  @override
  String get mealRulesOffline =>
      'Mealie-reglerne er ikke tilgængelige lige nu – terningen bruger appens udvalg.';

  @override
  String get mealRulesNoMatches =>
      'Ingen opskrifter matcher Mealie-reglerne for dette måltid.';

  @override
  String get mealTypeSide => 'Tilbehør';

  @override
  String get mealTypeSnack => 'Snack';

  @override
  String get mealTypeDrink => 'Drik';

  @override
  String get mealTypeDessert => 'Dessert';

  @override
  String get foodsTitle => 'Ingredienser';

  @override
  String get unitsTitle => 'Enheder';

  @override
  String get newFood => 'Ny ingrediens';

  @override
  String get newUnit => 'Ny enhed';

  @override
  String get editFood => 'Rediger ingrediens';

  @override
  String get editUnit => 'Rediger enhed';

  @override
  String get pluralNameLabel => 'Navn i flertal';

  @override
  String get abbreviationLabel => 'Forkortelse';

  @override
  String get pluralAbbreviationLabel => 'Forkortelse i flertal';

  @override
  String get mergeAction => 'Flet';

  @override
  String mergeIntoTitle(String name) {
    return 'Flet “$name” ind i…';
  }

  @override
  String mergeConfirm(String from, String to) {
    return '“$from” flettes ind i “$to”: alle opskrifter og indkøbslister bruger derefter “$to”, og “$from” slettes.';
  }

  @override
  String get mergeFailed => 'Fletning mislykkedes';

  @override
  String foodUnitDeleteConfirm(String name) {
    return 'Slet “$name”? Ingredienser, der bruger den, mister henvisningen.';
  }

  @override
  String get foodsUnitsEmpty => 'Ingen poster endnu.';

  @override
  String mealRuleConditionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count betingelser',
      one: '1 betingelse',
    );
    return '$_temp0';
  }

  @override
  String get showAll => 'Vis alle';

  @override
  String get mealDiceModeTitle => 'Terningen bruger';

  @override
  String get mealDiceModeApp => 'Appens udvalg';

  @override
  String get switchListTitle => 'Skift liste';

  @override
  String get newShoppingList => 'Ny indkøbsliste';

  @override
  String shoppingListDeleteConfirm(String name) {
    return 'Slet “$name”? Alle varer i den slettes også.';
  }

  @override
  String get labelOrderTitle => 'Sortér etiketter';

  @override
  String get labelOrderHint =>
      'Træk for at sortere. Gælder for denne liste – også i Mealies webapp.';

  @override
  String get labelOrderEmpty => 'Denne liste har ingen etiketter endnu.';

  @override
  String get useAsActiveList => 'Brug som aktiv liste';

  @override
  String get activeListBadge => 'Aktiv';

  @override
  String get foodLabelLabel => 'Etiket';

  @override
  String get foodNoLabel => 'Ingen etiket';

  @override
  String get aliasesLabel => 'Aliasser';

  @override
  String get aliasAddHint => 'Tilføj alias';

  @override
  String get foodOnHand => 'Haves i husstanden';

  @override
  String get timelineChildRecipesTitle => 'Tilføj også for linkede opskrifter';

  @override
  String timelineMadeForRecipe(String recipe) {
    return 'Lavet til $recipe';
  }

  @override
  String get timelineFilter => 'Filtrér poster';

  @override
  String get timelineTypeComment => 'Lavet og noter';

  @override
  String get timelineTypeInfo => 'Information';

  @override
  String get timelineTypeSystem => 'System';

  @override
  String get listManagementTitle => 'Indkøbslister';

  @override
  String get managementTitle => 'Mere';

  @override
  String get pinToHome => 'Føj til startskærmen';

  @override
  String get unpinFromHome => 'Fjern fra startskærmen';

  @override
  String homeScreenFull(int count) {
    return 'Startskærmen er fuld – højst $count felter. Fjern først et andet felt under “Mere”.';
  }

  @override
  String get selectAction => 'Vælg';

  @override
  String selectedCount(int count) {
    return '$count valgt';
  }

  @override
  String get assignLabelAction => 'Tildel etiket';

  @override
  String get assignLabelOverwriteHint =>
      'Overskriver etiketten for alle valgte ingredienser.';

  @override
  String deleteSelectedConfirm(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Slet $count poster?',
      one: 'Slet 1 post?',
    );
    return '$_temp0';
  }

  @override
  String get seedDataAction => 'Indlæs standarddata';

  @override
  String get seedFoodsHint =>
      'Opretter Mealies standardingredienser på det valgte sprog.';

  @override
  String get seedUnitsHint =>
      'Opretter Mealies standardenheder på det valgte sprog.';

  @override
  String get seedLanguageLabel => 'Sprog';

  @override
  String get seedDuplicateWarning =>
      'Du har allerede poster. Mealie håndterer ikke dubletter – du skal selv flette dem bagefter.';

  @override
  String get seedDone => 'Standarddata oprettet';

  @override
  String get seedFailed => 'Standarddata kunne ikke indlæses';

  @override
  String get exportAction => 'Eksportér';

  @override
  String get substitutionsLabel => 'Erstatninger';

  @override
  String get substitutionAddHint => 'Tilføj erstatning';

  @override
  String get substitutionFoodLabel => 'Ingrediens (valgfri)';

  @override
  String get substitutionNoteLabel => 'Note (valgfri)';

  @override
  String get substitutionNeedOne => 'Indtast en ingrediens eller en note';

  @override
  String get useAbbreviationLabel => 'Brug forkortelse';

  @override
  String get useAbbreviationHint => 'Vis “g” i stedet for “gram” i opskrifter';

  @override
  String get fractionLabel => 'Vis som brøk';

  @override
  String get fractionHint => '½ i stedet for 0,5';

  @override
  String get standardizationTitle => 'Standardisering';

  @override
  String get standardizationHint =>
      'Til omregning: 1 af denne enhed svarer til … (f.eks. 1 spsk = 15 milliliter).';

  @override
  String get standardQuantityLabel => 'Standardmængde';

  @override
  String get standardUnitLabel => 'Standardenhed';

  @override
  String get standardUnitNone => 'Ingen';

  @override
  String get stdFluidOunce => 'Flydende ounce (fl oz)';

  @override
  String get stdCup => 'Kop (US)';

  @override
  String get stdOunce => 'Ounce (oz)';

  @override
  String get stdPound => 'Pund (lb)';

  @override
  String get stdMilliliter => 'Milliliter';

  @override
  String get stdLiter => 'Liter';

  @override
  String get stdGram => 'Gram';

  @override
  String get stdKilogram => 'Kilogram';

  @override
  String get labelsTitle => 'Etiketter';

  @override
  String get newLabel => 'Ny etiket';

  @override
  String get editLabel => 'Rediger etiket';

  @override
  String get colorLabel => 'Farve';

  @override
  String labelDeleteConfirm(String name) {
    return 'Slet “$name”? Varer og ingredienser mister denne etiket.';
  }

  @override
  String get importMenuAction => 'Importér';

  @override
  String get archivedEmpty =>
      'Ingen arkiverede indkøb endnu. Tryk på “Afslut indkøb” efter indkøbet – de afkrydsede varer gemmes her.';

  @override
  String get sectionTitleLabel => 'Afsnittets titel';

  @override
  String get clearSection => 'Fjern afsnit';

  @override
  String get noPermissionGeneric =>
      'Du har ikke tilladelse til dette i Mealie. Spørg en administrator eller husstandsansvarlig.';

  @override
  String get noPermissionEditRecipe =>
      'Du kan ikke redigere denne opskrift – den er låst eller tilhører en anden husstand. Kun dens opretter eller en administrator kan.';

  @override
  String get noPermissionDeleteRecipe =>
      'Kun opskriftens opretter eller en administrator kan slette den.';

  @override
  String get noPermissionDemoteSelf =>
      'Du kan ikke fjerne dine egne administratorrettigheder.';

  @override
  String get recipeLockedHint => 'Låst – kun opretteren kan redigere';

  @override
  String get recipeDeleteOwnerOnlyHint =>
      'Kun opretteren eller en administrator kan slette';

  @override
  String get organizeReadOnlyHint =>
      'Kun visning: at oprette, ændre og slette kræver tilladelsen “Brugeren kan administrere ingredienser, mærkater og kategorier”.';

  @override
  String get notesNotSavedNoPermission =>
      'Noten blev ikke gemt – du har ikke tilladelse til at redigere denne opskrift.';

  @override
  String get userManagementTitle => 'Brugeradministration';

  @override
  String get editUserTitle => 'Rediger bruger';

  @override
  String get fullNameLabel => 'Fulde navn';

  @override
  String get usernameLabel => 'Brugernavn';

  @override
  String get emailLabel => 'E-mail';

  @override
  String get passwordLabel => 'Adgangskode';

  @override
  String get householdLabel => 'Husstand';

  @override
  String get permissionsTitle => 'Rettigheder';

  @override
  String get administratorLabel => 'Administrator';

  @override
  String get permCanInvite => 'Bruger kan invitere andre til gruppen';

  @override
  String get permCanManage => 'Brugeren kan administrere gruppeindstillinger';

  @override
  String get permCanManageHousehold => 'Brugeren kan administrere husstande';

  @override
  String get permCanOrganize =>
      'Brugeren kan administrere ingredienser, mærkater og kategorier';

  @override
  String get advancedFeaturesLabel => 'Aktiver avancerede funktioner';

  @override
  String get passwordResetLinkAction =>
      'Generér link til nulstilling af adgangskode';

  @override
  String get resetLockedUsersAction => 'Nulstil låste brugere';

  @override
  String get inviteLinkTitle => 'Invitationslink';

  @override
  String get inviteAction => 'Invitér';

  @override
  String get userUpdated => 'Bruger opdateret';

  @override
  String get createUserTitle => 'Opret bruger';

  @override
  String get userCreated => 'Bruger oprettet';

  @override
  String userDeleteConfirm(String name) {
    return 'Slet “$name”? Kontoen fjernes fra Mealie.';
  }

  @override
  String get passwordResetLinkCopied =>
      'Link kopieret – giv det videre til brugeren. Det er kun gyldigt i begrænset tid.';

  @override
  String lockedUsersReset(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count brugere låst op',
      one: '1 bruger låst op',
      zero: 'Ingen låste brugere',
    );
    return '$_temp0';
  }

  @override
  String get inviteUsesLabel => 'Antal anvendelser';

  @override
  String get inviteCreated => 'Invitationslink oprettet';

  @override
  String get inviteEmailHint =>
      'E-mailadresse (valgfri – Mealie sender invitationen)';

  @override
  String get inviteEmailSent => 'Invitation sendt via e-mail';

  @override
  String get inviteEmailFailed =>
      'E-mailen kunne ikke sendes (er SMTP sat op i Mealie?). Linket virker stadig.';

  @override
  String get copyLinkAction => 'Kopiér link';

  @override
  String get youLabel => 'Dig';

  @override
  String get membersPermissionsHint =>
      'Du kan ændre tilladelserne for medlemmerne af din husstand – men ikke dine egne.';

  @override
  String get householdManagementTitle => 'Husstands Administration';

  @override
  String get householdsTitle => 'Husstande';

  @override
  String get createHouseholdTitle => 'Opret Husstand';

  @override
  String get householdNameLabel => 'Husstandens Navn';

  @override
  String get householdPreferencesTitle => 'Husstands præferencer';

  @override
  String get privateHouseholdLabel => 'Privat Husstand';

  @override
  String get privateHouseholdHint =>
      'Sættes din Husstand til privat, vil det deaktivere alle indstillinger for offentlig visning. Dette overskriver individuelle indstillinger for offentlig visning';

  @override
  String get lockRecipeEditsLabel =>
      'Lås opskriftredigeringer fra andre husstande';

  @override
  String get lockRecipeEditsHint =>
      'Når denne funktion er aktiveret, kan kun brugere i din husstand redigere opskrifter, der er oprettet af din husstand.';

  @override
  String get householdRecipePreferencesTitle =>
      'Husstandens opskriftspræferencer';

  @override
  String get groupsTitle => 'Grupper';

  @override
  String get groupLabel => 'Gruppe';

  @override
  String get createGroupTitle => 'Opret gruppe';

  @override
  String get groupNameLabel => 'Gruppenavn';

  @override
  String get groupPreferencesTitle => 'Gruppeindstillinger';

  @override
  String get privateGroupLabel => 'Privat gruppe';

  @override
  String get privateGroupHint =>
      'Sættes din husholdning til privat vil det deaktivere alle indstillinger for offentlig visning. Dette tilsidesætter individuelle indstillinger for offentlig visning';

  @override
  String get firstDayOfWeekLabel => 'Første dag i ugen';

  @override
  String get showAnnouncementsLabel => 'Vis meddelelser fra Mealie';

  @override
  String get recipePublicDefaultLabel =>
      'Tillad brugere udenfor din gruppe at se dine opskrifter';

  @override
  String get recipeShowNutritionDefaultLabel => 'Vis ernæringsoplysninger';

  @override
  String get recipeShowAssetsDefaultLabel => 'Vis opskriftsaktiver';

  @override
  String get recipeLandscapeDefaultLabel =>
      'Vælg landskabsvisning som standard';

  @override
  String get recipeDisableCommentsDefaultLabel =>
      'Brugere kan ikke kommentere på opskrifter';

  @override
  String get myHouseholdSection => 'Min husstand';

  @override
  String get myGroupSection => 'Min gruppe';

  @override
  String get preferencesSaved => 'Indstillinger gemt';

  @override
  String get cannotDeleteWithUsers =>
      'Har stadig brugere – flyt eller slet dem først under Brugeradministration.';

  @override
  String deleteHouseholdConfirm(String name) {
    return 'Slet husstanden “$name”?';
  }

  @override
  String deleteGroupConfirm(String name) {
    return 'Slet gruppen “$name”?';
  }

  @override
  String usersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count brugere',
      one: '1 bruger',
      zero: 'Ingen brugere',
    );
    return '$_temp0';
  }

  @override
  String get originalUrlLabel => 'Oprindelig opskrift';

  @override
  String get copyTextAction => 'Kopiér tekst';

  @override
  String get copiedToClipboard => 'Kopieret til udklipsholderen';

  @override
  String get changelogEnglishHint => 'Udgivelsesnoterne findes kun på engelsk.';

  @override
  String get favoritesTitle => 'Favoritter';

  @override
  String get favoritesEmpty =>
      'Ingen favoritter endnu. Tryk på hjertet på en opskrift for at samle den her.';

  @override
  String get changelogTitle => 'Nyheder';

  @override
  String get changeProfileImage => 'Skift profilbillede';

  @override
  String get profileImageUpdated => 'Profilbillede opdateret';

  @override
  String get profileImageFailed => 'Profilbilledet kunne ikke uploades';

  @override
  String get myAccountTitle => 'Min konto';

  @override
  String get ownAccountHint =>
      'Her kan du redigere din egen konto. Andre brugere administreres af administratorer og medlemmer med tilladelsen “administrere”.';

  @override
  String get changePasswordAction => 'Skift adgangskode';

  @override
  String get currentPasswordLabel => 'Nuværende adgangskode';

  @override
  String get newPasswordLabel => 'Ny adgangskode';

  @override
  String get confirmPasswordLabel => 'Bekræft adgangskode';

  @override
  String get passwordTooShort => 'Mindst 8 tegn';

  @override
  String get passwordsDoNotMatch => 'Adgangskoderne er ikke ens';

  @override
  String get passwordUpdated => 'Adgangskoden blev opdateret';

  @override
  String get passwordChangeFailed => 'Adgangskoden kunne ikke ændres';

  @override
  String passwordManagedExternally(String method) {
    return 'Du logger ind via $method — skift adgangskoden der.';
  }

  @override
  String get bulkAddHint => 'Én linje pr. post.';

  @override
  String bulkAddCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tilføj $count poster',
      one: 'Tilføj 1 post',
    );
    return '$_temp0';
  }

  @override
  String get linkRecipeAction => 'Link opskrift';

  @override
  String get useFoodAction => 'Brug ingrediens i stedet for opskrift';

  @override
  String get addSubstitutionsAction => 'Tilføj erstatninger';

  @override
  String get clearSubstitutionsAction => 'Ryd erstatninger';

  @override
  String get recipeSubstitutionsTitle => 'Erstatninger';

  @override
  String get substitutionUnknownFood =>
      'Kun eksisterende ingredienser – brug ellers noten';

  @override
  String get insertAboveAction => 'Indsæt over';

  @override
  String get insertBelowAction => 'Indsæt under';

  @override
  String get moveToTopAction => 'Flyt øverst';

  @override
  String get moveToBottomAction => 'Flyt nederst';

  @override
  String get linkReferencesAction => 'Link-referencer';

  @override
  String get editMarkdownAction => 'Rediger markdown';

  @override
  String get previewMarkdownAction => 'Forhåndsvisning';

  @override
  String get insertStepImageAction => 'Upload billede';

  @override
  String get mergeAboveAction => 'Flet med ovenstående';

  @override
  String get linkedToOtherStep => 'Linket til andet trin';

  @override
  String get noNotesToLink => 'Ingen noter at linke til';

  @override
  String get ownerLabel => 'Ejer';

  @override
  String get ingredientParserTitle => 'Ingrediensfortolker';

  @override
  String ingredientParserHint(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count ingredienser er endnu ikke struktureret. Vælg en fortolker, tjek resultatet, anvend.',
      one:
          '1 ingrediens er endnu ikke struktureret. Vælg en fortolker, tjek resultatet, anvend.',
    );
    return '$_temp0';
  }

  @override
  String get parserNlp => 'Naturlig sprogbehandler';

  @override
  String get parserBrute => 'Rå parser';

  @override
  String get parserOpenai => 'OpenAI-fortolker';

  @override
  String get parserApp => 'Offline (app)';

  @override
  String get parseFailed => 'Fortolkning mislykkedes';

  @override
  String get parseAction => 'Behandl data';

  @override
  String applyParsedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Anvend $count ingredienser',
      one: 'Anvend 1 ingrediens',
      zero: 'Intet valgt',
    );
    return '$_temp0';
  }

  @override
  String get parsedNewBadge => 'ny';

  @override
  String get hoursShort => 't';

  @override
  String get minutesShort => 'min';

  @override
  String get timeExtraHint => 'Ekstra, f.eks. “plus natten over”';

  @override
  String get yieldLabel => 'Mængde';

  @override
  String get yieldTextLabel =>
      'Mængdeenhed (styk, liter, gram, portioner etc.)';

  @override
  String get prepTimeLabel => 'Forberedelsestid';

  @override
  String get performTimeLabel => 'Tilberedningstid';

  @override
  String get totalTimeLabel => 'Total tid';

  @override
  String get settingPublicRecipe => 'Offentlig opskrift';

  @override
  String get settingShowNutrition => 'Vis ernæringstabel';

  @override
  String get settingShowAssets => 'Vis aktiver';

  @override
  String get settingLandscapeView => 'Liggende visning (Kommer snart)';

  @override
  String get settingDisableComments => 'Slå kommentarer fra';

  @override
  String get settingDisableAmount => 'Deaktiver ingrediensmængder';

  @override
  String get settingLocked => 'Låst';

  @override
  String get settingLockedOwnerOnly =>
      'Kun opretteren kan låse eller låse opskriften op.';

  @override
  String get apiExtrasTitle => 'API-ekstramateriale';

  @override
  String get apiExtrasHint =>
      'Egne nøgle/værdi-par til tredjepartsapps, f.eks. til at udløse automatiseringer.';

  @override
  String get extraKeyLabel => 'Nøgle';

  @override
  String get extraValueLabel => 'Værdi';

  @override
  String get addExtraAction => 'Tilføj ekstra';

  @override
  String durationHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count timer',
      one: '1 time',
    );
    return '$_temp0';
  }

  @override
  String durationMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutter',
      one: '1 minut',
    );
    return '$_temp0';
  }

  @override
  String get discardChangesConfirm => 'Kassér ikke-gemte ændringer?';

  @override
  String get discardChanges => 'Kassér ændringer';

  @override
  String get imageFromUrl => 'Billede fra URL';

  @override
  String get deleteRecipeImage => 'Slet Opskrift Billede';

  @override
  String get deleteRecipeImageConfirm =>
      'Er du sikker på, du vil slette dette opskrift billede?';

  @override
  String get bulkAddIngredients => 'Tilføj flere ingredienser';

  @override
  String get bulkAddSteps => 'Tilføj flere trin';

  @override
  String get stepImageFailed => 'Billedet kunne ikke uploades';

  @override
  String get servingsAndTimes => 'Portioner og tider';

  @override
  String get recipeSettingsTitle => 'Opskriftsindstillinger';

  @override
  String get jsonEditorTitle => 'JSON-redigeringsprogram';

  @override
  String get jsonInvalid => 'Ugyldig JSON – tjek venligst.';

  @override
  String get editorOfflineHint =>
      'Åbnet offline: det kræver forbindelse at gemme. Nyere Mealie-felter (f.eks. erstatninger) bevares uændret.';

  @override
  String get parseLineFailed => 'Ikke genkendt – forbliver uændret';

  @override
  String get createManualTitle => 'Opret opskrift manuelt';

  @override
  String get createManualHint =>
      'Indtast et navn – ingredienser, trin, billede og alt andet tilføjer du bagefter i opskriftseditoren.';

  @override
  String get createManualButton => 'Opret og rediger';

  @override
  String get changelogEmpty => 'Ingen poster for denne version endnu.';

  @override
  String get finderDescription =>
      'Søg efter opskrifter pba. ingredienser du har ved hånden. Du kan også søge ud fra tilgængelige redskaber og sætte et maksimum antal manglende ingredienser og/eller redskaber.';

  @override
  String get finderSelectedIngredients => 'Valgte Ingredienser';

  @override
  String get finderNoIngredientsSelected => 'Ingen ingredienser valgt';

  @override
  String get finderMissing => 'Mangler';

  @override
  String get finderNoRecipesFound => 'Ingen opskrifter fundet';

  @override
  String get finderNoRecipesFoundDescription =>
      'Prøv at tilføje flere ingredienser til din søgning eller justere dine filtre';

  @override
  String get finderIncludeFoodsOnHand =>
      'Inkluder ingredienser du allerede har';

  @override
  String get finderIncludeToolsOnHand => 'Inkluder værktøjer du allerede har';

  @override
  String get finderIncludeSubstitutions => 'Inkludér erstatninger';

  @override
  String get finderSubstituting => 'Erstatter';

  @override
  String finderSubstituteForFood(String substitute, String food) {
    return '$substitute i stedet for $food';
  }

  @override
  String get finderMaxMissingIngredients => 'Maksimum Manglende Ingredienser';

  @override
  String get finderMaxMissingTools => 'Maks. manglende redskaber';

  @override
  String get finderSelectedTools => 'Valgte redskaber';

  @override
  String get finderReadyToMake => 'Klar til at lave';

  @override
  String get finderAlmostReadyToMake => 'Næsten klar til at lave';

  @override
  String get finderSettings => 'Indstillinger';

  @override
  String get finderLoadingRecipes => 'Indlæser opskrifter';

  @override
  String get finderClearSelection => 'Ryd valg';

  @override
  String get finderOfflineHint =>
      'Ingen forbindelse til serveren – resultaterne kommer fra opskrifterne gemt på denne enhed.';

  @override
  String get sendPeerOfflineHint =>
      'Ikke tilgængelig lige nu – ankommer, når appen åbnes der';

  @override
  String sendDeliveredLater(String device) {
    return '“$device” er ikke tilgængelig lige nu. Opskriften ankommer, så snart appen åbnes der.';
  }

  @override
  String get sendQueuedOffline =>
      'Ingen forbindelse lige nu. Opskriften sendes automatisk, så snart du er online igen.';

  @override
  String get searchHasAll => 'Har alle';

  @override
  String get searchHasAny => 'Har nogen';

  @override
  String get recipeFilterTitle => 'Filtrer';

  @override
  String get finderOtherFilters => 'Andre filtre';

  @override
  String get qfOpEquals => 'lig med';

  @override
  String get qfOpNotEquals => 'ikke lig med';

  @override
  String get qfOpGreater => 'er større end';

  @override
  String get qfOpGreaterEq =>
      'er større end eller lig med (Automatic Translation)';

  @override
  String get qfOpLess => 'er mindre end (Automatic Translation)';

  @override
  String get qfOpLessEq =>
      'er mindre end eller lig med (Automatic Translation)';

  @override
  String get qfOpNewerThan => 'er nyere end';

  @override
  String get qfOpOlderThan => 'er ældre end';

  @override
  String qfDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'for $count dage siden',
      one: 'for 1 dag siden',
    );
    return '$_temp0';
  }

  @override
  String get filterResetAll => 'Nulstil alle filtre';

  @override
  String get filterAny => 'Alle';

  @override
  String get filterOfflineIgnored =>
      'Offline kan “Andre filtre” kun anvendes i deres enkle form.';

  @override
  String linkedRecipesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count linkede opskrifter',
      one: 'Én linket opskrift',
      zero: 'Ingen linkede opskrifter',
    );
    return '$_temp0';
  }

  @override
  String get shoppingReminderNotificationsOff =>
      'Notifikationer er slået fra for Mealie Recipes — uden dem kan indkøbspåmindelsen ikke vises. Tillad notifikationer i indstillingerne.';

  @override
  String get shoppingReminderInactiveHint =>
      'Indkøbspåmindelsen kan ikke virke lige nu: sæt lokalitetsadgang til “Altid”, og tillad notifikationer.';

  @override
  String get bulkImportTitle => 'Import fra flere URL-adresser';

  @override
  String get bulkImportDescription =>
      'Du kan importere flere opskrifter på én gang ved at danne en kø med hjemmesider og foretage importen i baggrunden. Dette kan være nyttigt, når du i første omgang migrerer til Mealie, eller når du ønsker at importere et stort antal opskrifter.';

  @override
  String get bulkAddTitle => 'Tilføj flere';

  @override
  String get bulkImportSetOrganizers => 'Angiv kategorier og mærkater';

  @override
  String get bulkImportStarted => 'Importen at de valgte opskrifter er startet';

  @override
  String get bulkImportFailed => 'Der opstod en fejl ved import af opskrifter';

  @override
  String get bulkImportReports => 'Importér flere opskrifter';

  @override
  String get bulkImportUrlHint => 'URL på opskrift';

  @override
  String get migrationsTitle => 'Migrering af data';

  @override
  String get migrationsDescription =>
      'Opskrifter kan migreres fra andre understøttede applikationer til Mealie. Det er en god måde at komme i gang med Mealie på. Flytning af data mellem Mealie-instanser, eller gendannelse fra en tidligere Mealie-backup, gøres i stedet med backup- og gendannelsesværktøjerne.';

  @override
  String get migrationNew => 'Ny migrering';

  @override
  String get migrationChooseType => 'Vælg migreringstype';

  @override
  String get noFileSelected => 'Ingen fil valgt';

  @override
  String migrationTagAll(String tag) {
    return 'Tilføj mærkatet $tag til alle opskrifter';
  }

  @override
  String get migrationPrevious => 'Tidligere migreringer';

  @override
  String get migrationMealieDescription =>
      'Mealie kan importere opskrifter fra en tidligere Mealie-version end v1.0. Eksportér dine opskrifter fra den gamle instans, og upload ZIP-filen nedenfor. Bemærk, at det kun er opskrifter, der kan importeres fra en sådan eksport. Dette gælder kun eksport fra instanser med en version tidligere end v1.0. Backups, der er taget fra Mealie-version v1.0 eller senere, bør gendannes med backup- og gendannelsesværktøjerne i stedet.';

  @override
  String get migrationChowdownDescription =>
      'Mealie understøtter indbygget chowdown repository format. Download repositoriet som en .zip-fil og upload den nedenfor.';

  @override
  String get migrationCopyMeThatDescription =>
      'Mealie kan importere opskrifter fra Copy Me That. Eksportere dine opskrifter i HTML-format, og derefter uploade .zip-filen nedenfor.';

  @override
  String get migrationMyRecipeBoxDescription =>
      'Mealie kan importere opskrifter fra My Recipe Box. Eksporter dine opskrifter i CSV-format, og upload derefter .csv-filen nedenfor.';

  @override
  String get migrationNextcloudDescription =>
      'Nextcloud opskrifter kan importeres fra en zip-fil, der indeholder data lagret i Nextcloud. Se eksempelmappestrukturen nedenfor for at sikre, at dine opskrifter kan importeres.';

  @override
  String get migrationPaprikaDescription =>
      'Mealie kan importere opskrifter fra Paprika. Eksporter dine opskrifter fra paprika, omdøbe eksportudvidelsen til .zip og uploade den nedenfor.';

  @override
  String get migrationPlanToEatDescription =>
      'Mealie kan importere opskrifter fra Plan to Eat.';

  @override
  String get migrationRecipeKeeperDescription =>
      'Mealie kan importere opskrifter fra Recipe Keeper. Eksportér dine opskrifter i zip-format, og upload derefter .zip-filen nedenfor.';

  @override
  String get migrationTandoorDescription =>
      'Mealie kan importere opskrifter fra Tandoor. Eksporter dine data i \"Standard\" format, og upload derefter Zip filen nedenfor.';

  @override
  String get migrationCooknDescription =>
      'Mealie kan importere opskrifter fra DVO Cook\'n X3. Eksportér en kogebog eller menu i \"Cook\'n\" formatet, omdøb filtypen .dvo til .zip, og upload derefter .zip nedenfor.';

  @override
  String get reportTitle => 'Rapport';

  @override
  String get recipeDataTitle => 'Opskriftoplysninger';

  @override
  String get recipeDataDescription =>
      'Her kan du administrere data for dine opskrifter. Du kan udføre flere samtidige handlinger for dine opskrifter, herunder eksportere, slette, mærke og tildele kategorier.';

  @override
  String get recipeDataTagTitle => 'Tilføj mærkater til opskrifter';

  @override
  String get recipeDataCategorizeTitle => 'Kategorisér opskrifter';

  @override
  String get recipeDataSettingsTitle => 'Opdatér indstillinger';

  @override
  String get recipeDataExportTitle => 'Eksportér opskrifter';

  @override
  String get recipeDataDeleteTitle => 'Slet opskrifter';

  @override
  String recipeDataExportConfirm(int count) {
    return 'Følgende opskrifter ($count) eksporteres.';
  }

  @override
  String get recipeDataExportsTitle => 'Eksport af data';

  @override
  String get recipeDataExportsDescription =>
      'Her finder du links til tilgængelige eksporter, der er klar til download. Eksporterede data udløber, så sørg for at hente dem, mens de stadig er tilgængelige.';

  @override
  String get recipeDataPurgeExports => 'Slet eksporter';

  @override
  String get recipeDataPurgeConfirm =>
      'Er du sikker på, at du vil slette alle eksportdata?';

  @override
  String get recipeActionsTitle => 'Opskriftshandlinger';

  @override
  String get recipeActionNew => 'Ny opskriftshandling';

  @override
  String get recipeActionEdit => 'Rediger opskriftshandling';

  @override
  String get recipeActionTypeLink => 'Link';

  @override
  String get recipeActionTypePost => 'Opslag';

  @override
  String get webhooksTitle => 'Webhooks';

  @override
  String get webhooksDescription =>
      'Nedenstående webhooks vil blive afvikler, når et måltid er angivet for dagen. På det planlagte tidspunkt, afvikles webhooks med data fra den opskrift, der er planlagt til dagen. Bemærk, at webhook ikke afvikles nøjagtig på det planlagte tidspunkt. Webhooks afvikles med 5 minutters intervaler, så webhooks vil blive udført inden for 5 +/- minutter fra den planlagte tid.';

  @override
  String get webhookName => 'Webhooknavn';

  @override
  String get webhookUrl => 'Webhook-URL';

  @override
  String get notifiersTitle => 'Notifikatorer';

  @override
  String get notifiersDescription =>
      'Opsæt e-mail og push-notifikationer, der udløses af specifikke begivenheder.';

  @override
  String get notifierNew => 'Ny notifikation';

  @override
  String get notifierDescription =>
      'Mealie bruger Apprise-biblioteket til at generere notifikationer. De giver mange muligheder for notifikationstjenester. Se deres wiki for en udførlig guide til, hvordan en URL oprettes i din tjeneste. Hvis muligt, kan valget af din type af notifikation omfatte flere ekstrafunktioner.';

  @override
  String get notifierAppriseUrl => 'Apprise-URL';

  @override
  String get notifierAppriseUrlSkipped =>
      'Apprise-URL (ignoreres, hvis ikke udfyldt)';

  @override
  String get notifierAppriseUrlBlankHint =>
      'Eftersom Apprise URL\'er typisk indeholder følsomme oplysninger, er feltet bevidst tom imens du skriver. Hvis du ønsker at opdatere URL\'en, kan du skrive en ny, ellers efterlad feltet tomt for at bevare den nuværende URL.';

  @override
  String get notifierEnable => 'Aktiver notifikatorer';

  @override
  String get notifierWhatEvents =>
      'Hvilke begivenheder skal denne notifikator abonnere på?';

  @override
  String get notifierRecipeEvents => 'Begivenheder for opskrifter';

  @override
  String get notifierUserEvents => 'Brugerbegivenheder';

  @override
  String get notifierMealplanEvents => 'Madplansbegivenheder';

  @override
  String get notifierShoppingListEvents => 'Indkøbslistebegivenheder';

  @override
  String get notifierCookbookEvents => 'Kogebogsbegivenheder';

  @override
  String get notifierTagEvents => 'Mærkningsbegivenheder';

  @override
  String get notifierCategoryEvents => 'Kategoribegivenheder';

  @override
  String get notifierLabelEvents => 'Etiketbegivenheder';

  @override
  String get notifierUserSignup =>
      'Når en ny bruger slutter sig til din gruppe';

  @override
  String get notifierCreate => 'Opret';

  @override
  String get notifierUpdate => 'Gem';

  @override
  String get notifierDelete => 'Slet';

  @override
  String get notifierTestSent => 'Testbesked sendt';

  @override
  String get adminTitle => 'Administratorindstillinger';

  @override
  String get backupsTitle => 'Backup og eksport';

  @override
  String get backupsDescription =>
      'Backups er samlede snapshots af databasen og datamappe på installationen. Dette omfatter alle data og kan ikke indstilles til at udelukke undergrupper af data. Du kan tænke på dette som et øjebliksbillede af Mealie på et bestemt tidspunkt. Disse fungerer som en database agnostisk måde at eksportere og importere data, eller sikkerhedskopiere installationen til en ekstern placering.';

  @override
  String get backupCreateHeading => 'Opret en backup';

  @override
  String get backupCreated => 'Backup oprettet med succes';

  @override
  String get backupCreateFailed =>
      'Der opstod en fejl under oprettelse af backuppen. Se log-filen';

  @override
  String get backupDelete => 'Slet backup';

  @override
  String get backupDeleted => 'Backup slettet';

  @override
  String get backupRestore => 'Gendan sikkerhedskopi';

  @override
  String get backupRestoreDescription =>
      'Gendannelse af denne backup overskriver alle nuværende data i din database og i datamappen med indholdet af backuppen. Lykkes gendannelsen, bliver du logget ud.';

  @override
  String get backupCannotBeUndone =>
      'Denne handling kan ikke fortrydes - brug med forsigtighed.';

  @override
  String get backupAcknowledge =>
      'Jeg forstår, at denne handling er irreversibel, destruktiv og kan forårsage tab af data';

  @override
  String get backupRestoreSuccess => 'Gendannelse lykkedes';

  @override
  String get backupRestoreFailed =>
      'Gendannelse mislykkedes. Tjek dine serverlogs for flere detaljer';

  @override
  String get maintenanceTitle => 'Vedligeholdelse';

  @override
  String get maintenanceSummary => 'Oversigt';

  @override
  String get maintenanceStorage => 'Lageroplysninger';

  @override
  String get maintenanceDataDirSize => 'Størrelse på datamappe';

  @override
  String get maintenanceCleanableDirs => 'Mapper, hvor indhold kan slettes';

  @override
  String get maintenanceCleanableImages => 'Sletbare billeder';

  @override
  String get maintenanceTempDir => 'Midlertidig mappe (.Temp)';

  @override
  String get maintenanceBackupsDir => 'Mappe med sikkerhedskopier (backups)';

  @override
  String get maintenanceGroupsDir => 'Mappe med grupper (groups)';

  @override
  String get maintenanceRecipesDir => 'Mappe med opskrifter (recipes)';

  @override
  String get maintenanceUserDir => 'Mappe med brugerdata (user)';

  @override
  String get maintenanceCleanDirs => 'Rens mapper';

  @override
  String get maintenanceCleanDirsDescription =>
      'Fjerner alle opskriftsmapper, der ikke er gyldige UUID\'er';

  @override
  String get maintenanceCleanTemp => 'Slet midlertidige filer';

  @override
  String get maintenanceCleanTempDescription =>
      'Fjerner alle filer og mapper i .temp mappen';

  @override
  String get maintenanceCleanImages => 'Rens billeder';

  @override
  String get maintenanceCleanImagesDescription =>
      'Fjerner alle de billeder, der ikke slutter med .webp';

  @override
  String get maintenanceActions => 'Handlinger';

  @override
  String get adminConfiguration => 'Konfiguration';

  @override
  String get adminAppVersion => 'Programversion';

  @override
  String get adminUpToDate => 'Mealie er ajour';

  @override
  String adminVersionOutdated(String current, String latest) {
    return 'Din nuværende version ($current) svarer ikke til den seneste udgivelse. Overvej at opdatere til den seneste version ($latest).';
  }

  @override
  String get adminBaseUrl => 'Serverens URL';

  @override
  String get adminBaseUrlOk => 'Serverens URL matcher ikke standarden';

  @override
  String get adminBaseUrlError =>
      '`BASE_URL` er anvendt som standardværdien på API Server. Dette kan medføre problemer med meddelelser, der indeholder links til serveren, f. eks. i e-mails, osv.';

  @override
  String adminAuthReady(String provider) {
    return '$provider klar';
  }

  @override
  String adminAuthNotReady(String provider) {
    return '$provider ikke klar';
  }

  @override
  String adminAuthDisabled(String provider) {
    return '$provider deaktiveret';
  }

  @override
  String adminAuthSuccessText(String provider) {
    return 'Alle påkrævede $provider-variable er sat.';
  }

  @override
  String adminAuthErrorText(String provider) {
    return 'Ikke alle $provider-variable er konfigurerede. Det kan ignoreres, hvis du ikke benytter $provider til login.';
  }

  @override
  String adminAuthDisabledText(String envVar) {
    return 'Aktivér ved at sætte $envVar til true.';
  }

  @override
  String get adminEmailStatus => 'Status for konfiguration af e-mail';

  @override
  String get adminEmailConfigured => 'Email Konfigureret';

  @override
  String get adminNotReady => 'Ikke Klar - Kontroller konfigurationen';

  @override
  String get adminSucceeded => 'Gennemført';

  @override
  String get adminFailed => 'Mislykket';

  @override
  String get adminSiteStatistics => 'Webstedsstatistik';

  @override
  String get adminUncategorized => 'Opskrifter uden kategori';

  @override
  String get adminUntagged => 'Opskrifter uden anmærkning';

  @override
  String get adminGeneralAbout => 'Om Mealie';

  @override
  String get adminVersion => 'Version';

  @override
  String get adminBuild => 'Build';

  @override
  String get adminApplicationMode => 'Applikationstilstand';

  @override
  String get adminProduction => 'Produktion';

  @override
  String get adminDevelopment => 'Udvikling';

  @override
  String get adminDemoStatus => 'Demo-status';

  @override
  String get adminDemo => 'Demo';

  @override
  String get adminNotDemo => 'Ikke demo';

  @override
  String get adminApiPort => 'API-port';

  @override
  String get adminApiDocs => 'API-dokumentation';

  @override
  String get adminDatabaseType => 'Database-type';

  @override
  String get adminDatabaseUrl => 'Database-URL';

  @override
  String get adminDefaultGroup => 'Standardgruppe';

  @override
  String get adminDefaultHousehold => 'Standardhusstand';

  @override
  String get adminScraperVersion => 'Version på opskriftsfortolker';

  @override
  String get adminStatUsers => 'Brugere';

  @override
  String get adminStatHouseholds => 'Husstande';

  @override
  String get adminStatGroups => 'Grupper';

  @override
  String get recipeDuplicate => 'Kopier opskrift';

  @override
  String get recipeDuplicateAction => 'Kopier';

  @override
  String get recipeShareLink => 'Del opskrift';

  @override
  String get recipeShareExpiration => 'Udløbsdato';

  @override
  String get recipeShareCopied =>
      'Link til opskrift er kopieret til udklipsholder';

  @override
  String get enabledLabel => 'Aktiveret';

  @override
  String get disabledLabel => 'Deaktiveret';

  @override
  String get testAction => 'Afprøv';

  @override
  String get yesLabel => 'Ja';

  @override
  String get noLabel => 'Nej';

  @override
  String get downloadAction => 'Hent';

  @override
  String get backupUpload => 'Upload';

  @override
  String get zipImportButton => 'Importer fra zip-fil';

  @override
  String get zipImportDescription =>
      'Importer en enkelt opskrift, der blev eksporteret fra en anden Mealie instans.';

  @override
  String get reportStatus => 'Status';

  @override
  String get reportDate => 'Dato';

  @override
  String get recipeActionTitleLabel => 'Titel';

  @override
  String get clearAll => 'Ryd';

  @override
  String get recipeDataSettingsExplanation =>
      'Indstillinger valgt her, eksklusiv den låste indstilling, vil blive anvendt på alle valgte opskrifter.';

  @override
  String get adminAllowSignup => 'Tillad tilmelding';

  @override
  String get adminAllowPasswordLogin => 'Tillad login med adgangskode';

  @override
  String get adminEmailInvalid => 'Indtast en gyldig e-mailadresse.';

  @override
  String adminEmailTestResult(String result) {
    return 'E-mailtest: $result';
  }

  @override
  String get adminSendTestEmail => 'Send test-e-mail';

  @override
  String get adminTestEmailAddress => 'Modtager';

  @override
  String get backupCreate => 'Opret backup';

  @override
  String backupDeleteConfirm(String name) {
    return 'Slet backuppen “$name”?';
  }

  @override
  String get backupPostgresNote =>
      'Bruger du PostgreSQL, så læs om backup/gendannelse i Mealies dokumentation før gendannelse.';

  @override
  String get backupUploaded => 'Backup uploadet';

  @override
  String get backupsEmpty => 'Ingen backups endnu.';

  @override
  String get bulkImportAddRow => 'Tilføj URL';

  @override
  String get bulkImportStart => 'Start import';

  @override
  String get chooseFileButton => 'Vælg fil';

  @override
  String get deselectAllAction => 'Fravælg alle';

  @override
  String get downloadFailed => 'Download mislykkedes';

  @override
  String get fileSaved => 'Fil gemt';

  @override
  String get loadFailed => 'Kunne ikke indlæses';

  @override
  String get maintenanceActionsWarning =>
      'Vedligeholdelseshandlinger er destruktive og bør bruges med forsigtighed. Enhver af disse handlinger kan ikke fortrydes.';

  @override
  String get maintenanceConfirm =>
      'Denne handling er destruktiv og kan ikke fortrydes. Fortsæt?';

  @override
  String get maintenanceDone => 'Udført';

  @override
  String get maintenanceFailed => 'Vedligeholdelseshandlingen mislykkedes';

  @override
  String get maintenanceRun => 'Start';

  @override
  String get migrationFailed => 'Migreringen mislykkedes';

  @override
  String get migrationStart => 'Start migrering';

  @override
  String get migrationStarted =>
      'Migreringen er færdig — se rapporten nedenfor.';

  @override
  String get moreImportOptions => 'Flere importmuligheder';

  @override
  String notifierDeleteConfirm(String name) {
    return 'Slet notifikationen “$name”?';
  }

  @override
  String get notifierEdit => 'Rediger notifikation';

  @override
  String notifierEventCount(int count) {
    return 'Hændelser: $count';
  }

  @override
  String get notifierTestFailed => 'Testbeskeden kunne ikke sendes';

  @override
  String get notifiersEmpty => 'Ingen notifikationer endnu.';

  @override
  String recipeActionDeleteConfirm(String name) {
    return 'Slet opskriftshandlingen “$name”?';
  }

  @override
  String get recipeActionFailed => 'Opskriftshandlingen mislykkedes';

  @override
  String get recipeActionSent => 'Opskrift sendt';

  @override
  String get recipeActionUrlHint => 'Pladsholdere';

  @override
  String get recipeActionsDescription =>
      'Opskriftshandlinger vises i menuen på hver opskrift. “Link” åbner URL\'en, “Post” lader Mealie-serveren sende opskriften til URL\'en.';

  @override
  String get recipeActionsEmpty => 'Ingen opskriftshandlinger endnu.';

  @override
  String recipeDataDeleteConfirm(int count) {
    return 'Slet de valgte opskrifter ($count)? Handlingen kan ikke fortrydes.';
  }

  @override
  String recipeDataDeleteForbidden(int count) {
    return 'Du må ikke slette $count af de valgte opskrifter (kun opretteren eller en administrator kan).';
  }

  @override
  String recipeDataDeleted(int count) {
    return 'Slettede opskrifter: $count';
  }

  @override
  String get recipeDataExportAction => 'Eksportér';

  @override
  String get recipeDataExportDone =>
      'Eksport oprettet — download den under Dataeksporter.';

  @override
  String recipeDataExportExpires(String date) {
    return 'udløber $date';
  }

  @override
  String get recipeDataExportFailed => 'Eksport mislykkedes';

  @override
  String get recipeDataExportsEmpty => 'Ingen eksporter tilgængelige.';

  @override
  String recipeDataUpdated(int count) {
    return 'Opdaterede opskrifter: $count';
  }

  @override
  String get recipeDuplicated => 'Opskrift duplikeret';

  @override
  String get recipeExportJson => 'Eksportér som JSON';

  @override
  String get recipeExportZip => 'Eksportér som ZIP (med billede)';

  @override
  String get recipeShareCreate => 'Opret link';

  @override
  String get recipeShareDescription =>
      'Alle med linket kan se denne opskrift i browseren — uden konto — indtil det udløber.';

  @override
  String get recipeShareEmpty => 'Ingen delingslinks endnu.';

  @override
  String recipeShareExpiresAt(String date) {
    return 'Udløber $date';
  }

  @override
  String get recipeWebToolsMenu => 'Duplikér, delingslink og mere';

  @override
  String get reload => 'Genindlæs';

  @override
  String get reportDeleteConfirm => 'Slet denne rapport?';

  @override
  String get reportEntries => 'Poster';

  @override
  String get reportFailedEntries => 'Mislykket';

  @override
  String get reportOnlyFailed => 'Vis kun mislykkede poster';

  @override
  String get reportStatusFailure => 'Fejl';

  @override
  String get reportStatusInProgress => 'I gang';

  @override
  String get reportStatusPartial => 'Delvis';

  @override
  String get reportStatusSuccess => 'Gennemført';

  @override
  String get reportsEmpty => 'Ingen rapporter endnu.';

  @override
  String get uploadFailed => 'Upload mislykkedes';

  @override
  String webhookDeleteConfirm(String name) {
    return 'Slet webhooken “$name”?';
  }

  @override
  String get webhookEdit => 'Rediger webhook';

  @override
  String get webhookNew => 'Ny webhook';

  @override
  String get webhookTestFailed => 'Testen kunne ikke startes';

  @override
  String get webhookTestSent => 'Testwebhook udløst';

  @override
  String get webhookTime => 'Tid (lokal)';

  @override
  String get webhooksEmpty => 'Ingen webhooks endnu.';

  @override
  String get zipImportFailed => 'ZIP-import mislykkedes';

  @override
  String get aiProvidersTitle => 'AI-udbydere';

  @override
  String get aiProvidersDescription =>
      'Konfigurér AI-udbydere for at slå AI-funktioner til, såsom forbedret ingredienshåndtering, at oprette opskrifter fra videoer med mere!';

  @override
  String get aiProviderSettingsTitle => 'AI-udbyderindstillinger';

  @override
  String get aiProvidersList => 'Udbydere';

  @override
  String get aiProviderCreate => 'Opret udbyder';

  @override
  String get aiProviderEdit => 'Redigér udbyder';

  @override
  String get aiDefaultProvider => 'Standardudbyder';

  @override
  String get aiDefaultProviderDescription =>
      'Påkrævet for at slå AI-funktioner til';

  @override
  String get aiAudioProvider => 'Lydudbyder';

  @override
  String get aiAudioProviderDescription =>
      'Slå lydtranskriberingsfunktioner til, såsom at oprette opskrifter fra videoer';

  @override
  String get aiImageProvider => 'Billedudbyder';

  @override
  String get aiImageProviderDescription =>
      'Slår billedgenkendelsesfunktioner til, såsom at oprette opskrifter fra billeder';

  @override
  String get aiProviderName => 'Udbydernavn';

  @override
  String get aiApiKey => 'API-nøgle';

  @override
  String get aiApiKeyCreateDescription =>
      'Din udbyders API-nøgle til godkendelse. Hvis din udbyder ikke benytter en API-nøgle (eks. Ollama), skal du stadig skrive ét eller andet.';

  @override
  String get aiApiKeyEditDescription =>
      'Undlad at udfylde dette, medmindre du vil ændre det.';

  @override
  String get aiBaseUrl => 'Basis-URL';

  @override
  String get aiBaseUrlDescription =>
      'Undlad at udfylde, hvis du benytter OpenAI. Skal være et OpenAI-kompatibelt endpoint (eks. \"http://localhost:11434/v1\").';

  @override
  String get aiModel => 'Model';

  @override
  String get aiModelDescription =>
      'Hvilken model din udbyder skal benytte (eks. \"gpt-5\").';

  @override
  String get aiTimeout => 'Forespørgsels-time-out (sekunder)';

  @override
  String get aiProviderCreated => 'Udbyder oprettet';

  @override
  String get aiProviderUpdated => 'Udbyder opdateret';

  @override
  String get aiProviderDeleted => 'Udbyder slettet';

  @override
  String get aiProviderCreateFailed => 'Kunne ikke oprette udbyder';

  @override
  String get aiProviderUpdateFailed => 'Kunne ikke opdatere udbyder';

  @override
  String get aiProviderDeleteFailed => 'Kunne ikke slette udbyder';

  @override
  String get aiRequestHeaders => 'Forespørgsels-headers';

  @override
  String get aiRequestParams => 'Forespørgselsparametre';

  @override
  String get aiNoDefaultWarning =>
      'Du har ikke sat en standardudbyder, så AI-funktioner er slået fra';

  @override
  String get aiTestConnection => 'Afprøv forbindelse';

  @override
  String get aiTestSucceeded => 'Forbindelsesforsøg lykkedes';

  @override
  String get aiTestFailed => 'Forbindelsesforsøg mislykkedes';

  @override
  String get aiSupportsImages => 'Understøt billeder';

  @override
  String get aiTextOnly => 'Kun tekst, kan ikke benyttes som billedudbyder';

  @override
  String get debugAiTitle => 'Fejlsøg AI-udbydere';

  @override
  String get debugAiDescription =>
      'Brug denne side til at fejlsøge AI-udbydere. Du kan teste din AI-forbindelse og se resultaterne her. Hvis du har billedetjenester aktiveret, kan du også prøve med et billede.';

  @override
  String get debugParserTitle => 'Fortolker';

  @override
  String get debugParserDescription =>
      'Mealie bruger Conditional Random Fields felter (CRF\'er) til berarbejdning af ingredienser. Den model, der anvendes til ingredienser er baseret ud fra et datasæt på over 100.000 ingredienser fra et datasæt udarbejdet af New York Times. Bemærk, at da modellen kun er trænet på engelsk, kan du have forskellige resultater, når du bruger modellen på andre sprog. På denne side kan du teste modellen.';

  @override
  String get debugIngredientText => 'Ingredienstekst';

  @override
  String get debugTryExample => 'Prøv et eksempel';

  @override
  String debugAverageConfidence(String value) {
    return '$value sikkerhed';
  }

  @override
  String get debugRunTest => 'Kør test';

  @override
  String get debugQuantity => 'Antal';

  @override
  String get debugUnit => 'Enhed';

  @override
  String get debugFood => 'Ingredienser';

  @override
  String get debugNote => 'Kommentar';

  @override
  String get debugGroup => 'Gruppe';

  @override
  String get aiProviderNone => 'Ingen';

  @override
  String aiProviderDeleteConfirm(String name) {
    return 'Slet udbyderen “$name”?';
  }

  @override
  String get aiProvidersEmpty => 'Ingen AI-udbydere endnu.';

  @override
  String get aiAdvanced => 'Avanceret';

  @override
  String get aiKeyLabel => 'Navn';

  @override
  String get aiValueLabel => 'Værdi';

  @override
  String get debugTitle => 'Fejlsøgning';

  @override
  String get debugParse => 'Behandl data';

  @override
  String get debugParseFailed => 'Ingrediensen kunne ikke fortolkes';

  @override
  String get debugChooseImage => 'Vælg billede';

  @override
  String get debugNoImage => 'Intet billede (valgfrit)';

  @override
  String get updateTitle => 'Søg efter opdateringer';

  @override
  String get updateInstalledVersion => 'Installeret version';

  @override
  String get updateLastCheck => 'Senest tjekket';

  @override
  String get updateCheckNow => 'Tjek nu';

  @override
  String get updateChecking => 'Søger efter opdateringer…';

  @override
  String get updateUpToDate => 'Mealie Recipes er opdateret.';

  @override
  String updateAvailable(String version) {
    return 'Version $version er tilgængelig';
  }

  @override
  String get updateAvailableDescription =>
      'En ny version af Mealie Recipes er tilgængelig. Intet installeres, før du selv starter opdateringen.';

  @override
  String get updateShow => 'Vis opdatering';

  @override
  String get updateLater => 'Senere';

  @override
  String updateDownloading(int percent) {
    return 'Henter … $percent %';
  }

  @override
  String updateReady(String version) {
    return 'Version $version er klar til installation';
  }

  @override
  String get updateInstalling => 'Installerer — appen genstarter automatisk …';

  @override
  String get updateManual =>
      'Opdateringen kunne ikke installeres automatisk. Diskbilledet er åbnet: træk Mealie Recipes til Programmer.';

  @override
  String get updateFailed => 'Opdateringen mislykkedes';

  @override
  String get updateInstallNow => 'Hent og installér';

  @override
  String get updateRestartNow => 'Installér og genstart';

  @override
  String get updateAutoTitle => 'Søg efter opdateringer ved start';

  @override
  String get updateAutoDescription =>
      'Tjekker kun og giver besked — installationen starter du altid selv.';

  @override
  String get updateBetaTitle => 'Modtag betaversioner';

  @override
  String get updateBetaDescription =>
      'Tilbyder også forhåndsversioner til test. De kan stadig indeholde fejl.';

  @override
  String get updateNoNotes => 'Ingen udgivelsesnoter.';

  @override
  String get updateSourceHint =>
      'Opdateringer kommer fra GitHub-udgivelserne af Mealie Recipes og installeres kun, hvis de er signeret af udvikleren (macOS).';

  @override
  String get errorNoConnection =>
      'Kan ikke nå din Mealie-server. Tjek internetforbindelsen og serveradressen.';

  @override
  String get errorTimeout => 'Serveren var for længe om at svare. Prøv igen.';

  @override
  String get errorUnauthorized =>
      'Dit login er udløbet, eller API-tokenet er ikke længere gyldigt. Log ind igen i indstillingerne.';

  @override
  String get errorServer =>
      'Mealie-serveren rapporterede en fejl. Prøv igen senere.';

  @override
  String get errorNotFound => 'Ikke fundet på serveren — det kan være slettet.';

  @override
  String get errorCertificate =>
      'Serverens sikkerhedscertifikat er ikke tillidsværdigt.';

  @override
  String get errorGeneric => 'Noget gik galt. Prøv igen.';

  @override
  String get offlineLabel => 'Offline';

  @override
  String offlineSince(String time) {
    return 'Offline · senest synkroniseret $time';
  }

  @override
  String get mealplanEntryActions => 'Måltidsindstillinger';

  @override
  String get mealplanMoveAction => 'Flyt';

  @override
  String get mealplanMoveTitle => 'Flyt måltid';

  @override
  String get mealplanMoveDate => 'Dato';

  @override
  String mealplanMovedTo(String date) {
    return 'Flyttet til $date';
  }

  @override
  String get mealplanShowWeek => 'Vis';

  @override
  String get mealplanMoveFailed => 'Måltidet kunne ikke flyttes';

  @override
  String get recentlyViewedTitle => 'Senest vist';

  @override
  String get recentlyViewedEmpty => 'Opskrifter, du åbner, vises her.';

  @override
  String get recentlyViewedClear => 'Ryd historik';

  @override
  String get recentlyViewedClearMessage =>
      'Listen over senest viste opskrifter på denne enhed ryddes. Selve opskrifterne bliver.';

  @override
  String get recentlyViewedClearConfirm => 'Ryd';

  @override
  String get duplicatesTitle => 'Dubletsøger';

  @override
  String get duplicatesScanning => 'Søger efter dubletopskrifter…';

  @override
  String get duplicatesNone => 'Ingen dubletopskrifter fundet.';

  @override
  String duplicatesFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mulige dubletter fundet.',
      one: '1 mulig dublet fundet.',
    );
    return '$_temp0';
  }

  @override
  String get duplicatesIntro =>
      'Tryk på den opskrift, der skal blive, og flet derefter.';

  @override
  String get duplicatesReasonSource => 'Samme kilde';

  @override
  String get duplicatesReasonName => 'Samme navn';

  @override
  String duplicatesReasonSimilar(int percent) {
    return 'Lignende · $percent % samme ingredienser';
  }

  @override
  String get duplicatesKeeps => 'Bliver';

  @override
  String get duplicatesWillBeDeleted => 'Slettes';

  @override
  String get duplicatesMerge => 'Flet';

  @override
  String get duplicatesNotDuplicate => 'Ikke en dublet';

  @override
  String get duplicatesMergeTitle => 'Flet opskrifter?';

  @override
  String duplicatesMergeMessage(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count andre opskrifter slettes',
      one: '1 anden opskrift slettes',
    );
    return '“$name” bliver. $_temp0.\n\nKategorier, mærkater, redskaber, noter, planlagte måltider i din husstand og din favorit flyttes over. Kommentarer, tidslinje og vedhæftninger for de slettede opskrifter går tabt.';
  }

  @override
  String get duplicatesMerged => 'Opskrifter flettet';

  @override
  String duplicatesIngredientCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ingredienser',
      one: '1 ingrediens',
    );
    return '$_temp0';
  }

  @override
  String duplicatesResetIgnored(int count) {
    return 'Vis skjulte par igen ($count)';
  }

  @override
  String get duplicatesRescan => 'Søg igen';

  @override
  String get duplicatesOpenRecipe => 'Åbn opskrift';

  @override
  String get duplicatesMergeNoEditHint =>
      'Du må ikke redigere den opskrift, der bliver (en andens låste opskrift eller fra en anden husstand). Dens kategorier, mærkater, redskaber og noter forbliver derfor uændrede; kun planlagte måltider og din favorit flyttes over.';

  @override
  String get recipeOtherHouseholdHint =>
      'Fra en anden husstand – redigering er låst der';

  @override
  String foodsSavedAsNote(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nye ingredienser blev',
      one: '1 ny ingrediens blev',
    );
    return 'Gemt. $_temp0 beholdt som ingrediensnote – oprettelse af ingredienser kræver tilladelsen “Brugeren kan administrere ingredienser, mærkater og kategorier” i Mealie.';
  }

  @override
  String get a11yRemove => 'Fjern';

  @override
  String get a11yDecrease => 'Mindre';

  @override
  String get a11yIncrease => 'Mere';

  @override
  String get a11yShowPassword => 'Vis adgangskode';

  @override
  String get a11yHidePassword => 'Skjul adgangskode';

  @override
  String get a11yClearSearch => 'Ryd søgning';

  @override
  String get notesQueuedOffline =>
      'Offline – noten sendes, så snart serveren kan nås igen.';

  @override
  String get timelineQueuedOffline =>
      'Offline – det føjes til tidslinjen, så snart serveren kan nås igen.';

  @override
  String get syncSectionName => 'Omdøbt';

  @override
  String get pendingRecipesDiscard => 'Kassér';

  @override
  String get undo => 'Fortryd';

  @override
  String timerStoppedSnack(String name) {
    return 'Timeren “$name” er stoppet';
  }

  @override
  String get cookFriendsEndConfirm =>
      'Afslut sessionen for alle? Alle gæster afbrydes.';

  @override
  String get weekStartSyncHint =>
      'Gemt i Mealie – gælder hele din husstand, også i webappen.';

  @override
  String get weekStartNoPermission =>
      'Sat i Mealie af din husstand. Kun medlemmer, der må administrere husstanden, kan ændre det.';

  @override
  String get assetsUnsupported329 =>
      'Mealie understøtter PDF, billeder, videoer (MP4, MOV, WebM), lyd (MP3, M4A), Word/ODT/RTF, TXT, MD, CSV og JSON.';

  @override
  String get assetsRecordVideo => 'Optag video';

  @override
  String get assetsChooseVideo => 'Vælg video';

  @override
  String get shoppingSearchHint => 'Søg i denne liste';

  @override
  String get shoppingSearchNoMatches => 'Ingen varer matcher din søgning.';

  @override
  String get mealplanServingsTitle => 'Planlagte portioner';

  @override
  String get mealplanServingsHint =>
      'Kun for denne post i madplanen — selve opskriften forbliver uændret. Når opskriften åbnes og føjes til indkøbslisten, bruges disse portioner.';

  @override
  String get calendarFeedTitle => 'Abonnér på kalender';

  @override
  String get calendarFeedSubtitle =>
      'Vis madplanen i Google, Apple eller enhver anden kalender';

  @override
  String get calendarFeedDescription =>
      'Abonnér på din husholdnings madplan fra Google Kalender, Apple Kalender, Home Assistant eller enhver anden app, der understøtter iCal-links. Enhver, der kender linket, kan se din madplan.';

  @override
  String get calendarFeedOff =>
      'Kalenderlinket er slået fra for din husholdning.';

  @override
  String get calendarFeedAskManager =>
      'Bed én, der kan administrere din husholdning, om at slå det til.';

  @override
  String get calendarFeedTurnOn => 'Slå til';

  @override
  String get calendarFeedTurnOff => 'Slå fra';

  @override
  String get calendarFeedReset => 'Nulstil link';

  @override
  String get calendarFeedResetHint =>
      'At nulstille eller slå linket fra, vil forhindre eksisterende abonnementer i at blive opdateret.';

  @override
  String get calendarFeedIncludeNotes => 'Inkludér noter';

  @override
  String get calendarFeedTimesHint =>
      'Tryk på et måltid for at angive tidspunktet. Måltider uden tidspunkt vises som heldagsbegivenheder.';

  @override
  String get calendarFeedMealTypes => 'Måltidstype';

  @override
  String get calendarFeedSubscribe => 'Abonnér i kalender';

  @override
  String get calendarFeedNoApp =>
      'Ingen kalenderapp kunne åbnes. Kopiér linket, og tilføj det som abonnement i din kalender.';

  @override
  String get calendarFeedPublicHint =>
      'Linket virker uden login — del det kun med personer, der må se din madplan.';

  @override
  String get recipeShareLinkMenu => 'Delingslink og QR-kode';

  @override
  String get recipeShareShowQr => 'Vis QR-kode';

  @override
  String get recipeShareScanQr =>
      'Scan med en telefonkamera for at åbne denne opskrift';

  @override
  String get recipeShareQrShare => 'Del billede';

  @override
  String get recipeShareQrFailed => 'QR-kodebilledet kunne ikke oprettes';

  @override
  String get mealplanSettingsTitle => 'Indstillinger for madplanlægning';

  @override
  String get mealDiceRulesTitle => 'Terningregler';

  @override
  String saveAsNewFood(String name) {
    return 'Gem “$name” som ny ingrediens';
  }

  @override
  String get shoppingMoreOptions => 'Flere valgmuligheder';

  @override
  String get shoppingFewerOptions => 'Færre valgmuligheder';

  @override
  String nameAlreadyExists(String name) {
    return 'Findes allerede: $name';
  }

  @override
  String aliasBelongsTo(String alias, String name) {
    return '“$alias” hører allerede til “$name” — flet hellere de to.';
  }

  @override
  String get recipeMatchTitle => 'Recipe Match';

  @override
  String get recipeMatchShuffle => 'Bland';

  @override
  String recipeMatchCardsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count opskrifter i bunken',
      one: '1 opskrift i bunken',
    );
    return '$_temp0';
  }

  @override
  String get recipeMatchNext => 'Næste';

  @override
  String get recipeMatchKeep => 'På bakken';

  @override
  String get recipeMatchKept => 'Lagt på bakken';

  @override
  String get recipeMatchAnyTime => 'Enhver varighed';

  @override
  String recipeMatchMaxTime(int minutes) {
    return '≤ $minutes min';
  }

  @override
  String get recipeMatchEmpty => 'Ingen matchende opskrifter';

  @override
  String get recipeMatchEmptyHint => 'Skift filtrene, eller tøm bakken.';

  @override
  String get recipeMatchResetFilters => 'Nulstil filtre';

  @override
  String get recipeMatchFlipHint => 'Tryk: ingredienser · instruktioner';

  @override
  String get recipeMatchFlipBack => 'Vend tilbage';

  @override
  String get recipeMatchOpenRecipe => 'Hele opskriften';

  @override
  String get recipeMatchOnHand => 'haves';

  @override
  String get recipeMatchTray => 'Bakke';

  @override
  String get recipeMatchTrayEmpty => 'Stadig tom – træk et kort ned';

  @override
  String recipeMatchTrayCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count opskrifter',
      one: '1 opskrift',
    );
    return '$_temp0';
  }

  @override
  String get recipeMatchClear => 'Ryd';

  @override
  String get recipeMatchTrayHint =>
      'Bliver, indtil du tømmer den – også når du lukker bunken.';

  @override
  String get recipeMatchRemove => 'Fjern fra bakken';

  @override
  String get recipeMatchToMealplan => 'Føj til madplan';

  @override
  String get recipeMatchToShopping => 'Ingredienser til indkøbsliste';

  @override
  String get recipeMatchSelectIngredients => 'Vælg ingredienser';

  @override
  String get recipeMatchNoList => 'Vælg først en indkøbsliste.';

  @override
  String get recipeMatchList => 'Liste';

  @override
  String get recipeMatchOnHandHint =>
      'Ingredienser, du har, er allerede fravalgt.';

  @override
  String recipeMatchAddCount(int selected, int total) {
    return 'Tilføj $selected af $total ingredienser';
  }

  @override
  String get recipeMatchNoDay => 'Ingen dag endnu – bliver på bakken';

  @override
  String recipeMatchAddMeals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tilføj $count måltider',
      one: 'Tilføj 1 måltid',
    );
    return '$_temp0';
  }

  @override
  String recipeMatchMealsAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count måltider tilføjet',
      one: '1 måltid tilføjet',
    );
    return '$_temp0';
  }

  @override
  String get recipeMatchSwipeUp => 'Stryg op for at åbne bakken';

  @override
  String get weekPlannerTitle => 'Planlæg ugen';

  @override
  String get weekPlannerStepDays => 'Dage';

  @override
  String get weekPlannerStepPrefs => 'Indstillinger';

  @override
  String get weekPlannerStepPreview => 'Forhåndsvisning';

  @override
  String get weekPlannerDaysTitle => 'Hvilke måltider skal appen udfylde?';

  @override
  String get weekPlannerDaysHint =>
      'Tryk på felterne. Det, der allerede er planlagt, forbliver som det er.';

  @override
  String get weekPlannerPresetWeekdays => 'Hverdage';

  @override
  String get weekPlannerPlanned => 'planlagt';

  @override
  String get weekPlannerMoreMeals => 'Vis flere måltider';

  @override
  String get weekPlannerFewerMeals => 'Færre måltider';

  @override
  String weekPlannerMealCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count måltider',
      one: '1 måltid',
    );
    return '$_temp0';
  }

  @override
  String get weekPlannerPrefsTitle => 'Hvad skal appen tage hensyn til?';

  @override
  String get weekPlannerPrefsHint =>
      'Alt er valgfrit – uden valg vælger den en farverig blanding af dine opskrifter.';

  @override
  String get weekPlannerQuick => 'Hurtigt på hverdage';

  @override
  String weekPlannerQuickSub(int minutes) {
    return 'Man–fre højst $minutes min';
  }

  @override
  String get weekPlannerStale => 'Længe ulavede først';

  @override
  String get weekPlannerStaleSub => 'ud fra “Senest lavet” og madplanen';

  @override
  String get weekPlannerFavorites => 'Planlæg favoritter oftere';

  @override
  String get weekPlannerFavoritesSub =>
      'hjertemarkerede og højt bedømte opskrifter';

  @override
  String get weekPlannerVariety => 'Variation';

  @override
  String get weekPlannerVarietySub => 'ingen kategori to gange i træk';

  @override
  String get weekPlannerOnlyFrom => 'Kun fra';

  @override
  String get weekPlannerDiceRules => 'Brug terningregler';

  @override
  String get weekPlannerDiceRulesSub =>
      'dit valg pr. måltid fra madplanens indstillinger';

  @override
  String weekPlannerMatching(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count matchende opskrifter',
      one: '1 matchende opskrift',
    );
    return '$_temp0';
  }

  @override
  String weekPlannerForMeals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'til $count måltider',
      one: 'til 1 måltid',
    );
    return '$_temp0';
  }

  @override
  String get weekPlannerSuggest => 'Foreslå';

  @override
  String get weekPlannerPreviewHint =>
      'Terningen bytter, låsen beholder. Hold en ret nede, og træk den til en anden dag for at bytte dem.';

  @override
  String get weekPlannerRerollAll => 'Slå alle om';

  @override
  String get weekPlannerReroll => 'Slå om';

  @override
  String get weekPlannerLock => 'Lås';

  @override
  String get weekPlannerUnlock => 'Lås op';

  @override
  String get weekPlannerReasonNever => 'aldrig lavet';

  @override
  String get weekPlannerReasonStale => 'ikke lavet i et stykke tid';

  @override
  String get weekPlannerReasonFavorite => 'Favorit';

  @override
  String get weekPlannerNoMatch => 'Ingen matchende opskrift';

  @override
  String get weekPlannerThenShopping =>
      'Vælg derefter ingredienser til indkøbslisten';

  @override
  String get weekPlannerMostlyEmpty => 'Ugen er næsten tom';

  @override
  String weekPlannerMostlyEmptySub(int free, int total) {
    return '$free af $total dage er stadig ledige – udfyld dem i tre trin.';
  }

  @override
  String get previousWeek => 'Forrige uge';

  @override
  String get nextWeek => 'Næste uge';

  @override
  String get weekPlannerAllDays => 'Alle dage';

  @override
  String get weekPlannerWeekend => 'Weekend';

  @override
  String get weekPlannerDinners => 'Aftensmåltider';

  @override
  String get weekPlannerLunches => 'Frokoster';

  @override
  String get weekPlannerAllMeals => 'Alle måltider';

  @override
  String get mealplanDayEmpty => 'Intet planlagt';

  @override
  String get mealplanDropHere => 'Slip her';

  @override
  String mealplanDayKcal(String kcal) {
    return '$kcal kcal pr. portion';
  }

  @override
  String mealplanDayKcalPartial(String kcal) {
    return 'mindst $kcal kcal pr. portion';
  }

  @override
  String get globalSearchHint => 'Søg opskrifter, varer, funktioner …';

  @override
  String get globalSearchIntro =>
      'Søg efter opskrifter, varer på indkøbslisten, ingredienser og kogebøger – og efter appens funktioner og indstillinger, f.eks. “liste”.';

  @override
  String get globalSearchFunctions => 'Funktioner';

  @override
  String globalSearchNoResults(String query) {
    return 'Ingen resultater for “$query”';
  }

  @override
  String get searchClear => 'Ryd søgning';

  @override
  String get recipeMatchPlanWeek => 'Planlæg ugen med disse opskrifter';

  @override
  String get weekPlannerReasonTray => 'fra bakken';

  @override
  String get emptyBrowseRecipes => 'Gennemse opskrifter';

  @override
  String get mealplanWeekShopping => 'Ingredienser til denne uge';

  @override
  String get globalSearchActions => 'Handlinger';

  @override
  String globalSearchAddToList(String text) {
    return 'Føj “$text” til indkøbslisten';
  }

  @override
  String globalSearchAdded(String text) {
    return '“$text” tilføjet';
  }

  @override
  String get globalSearchImportUrl => 'Importér opskrift fra denne adresse';

  @override
  String get homeContinueCooking => 'Fortsæt madlavningen';

  @override
  String homeCookingStep(int step, int total) {
    return 'Trin $step af $total';
  }

  @override
  String get homeCookingPrep => 'Forberedelse';

  @override
  String get homeCookingAlmostDone => 'Næsten færdig';

  @override
  String get homeCookingContinue => 'fortsæt';

  @override
  String get paneSelectRecipe => 'Vælg en opskrift til venstre.';

  @override
  String get mealplanDragRecipeHint =>
      'Træk en opskrift til en dag for at planlægge den.';

  @override
  String get desktopDropUnsupported =>
      'Disse filer kan ikke tilføjes som vedhæftninger.';

  @override
  String desktopDropUploaded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vedhæftninger tilføjet',
      one: '1 vedhæftning tilføjet',
    );
    return '$_temp0';
  }

  @override
  String get desktopDropAsAttachment => 'Slip for at tilføje som vedhæftning';

  @override
  String get printAction => 'Udskriv';

  @override
  String get mealplanPrintWeek => 'Udskriv ugen';

  @override
  String get mealplanEntryCooked => 'Lavet';

  @override
  String get recipeSearchClear => 'Ryd søgning';

  @override
  String get organizerShowRecipes => 'Vis opskrifter';

  @override
  String globalSearchShowAllRecipes(int count) {
    return 'Vis alle $count opskrifter';
  }

  @override
  String get unnamedEntry => '(intet navn)';

  @override
  String get mealplanWholeWeek => 'For hele ugen';

  @override
  String get mealplanWholeWeekDropHint =>
      'Slip et måltid her for at planlægge det for hele ugen.';

  @override
  String get mealplanMovedToWholeWeek => 'Planlagt for hele ugen';

  @override
  String get mealplanCookToday => 'Laver det i dag';

  @override
  String get mealplanPlanWholeWeek => 'Plan for hele ugen';

  @override
  String mealplanPlanWholeWeekRange(String from, String to) {
    return '$from – $to';
  }

  @override
  String get calendarFeedDuration => 'Varighed (minutter)';

  @override
  String get calendarFeedEventDetails => 'Begivenhedsdetaljer';

  @override
  String calendarFeedEventDetailsHint(String fields) {
    return 'Tilpas, hvordan måltider vises i din kalender. Flettefelter: $fields';
  }

  @override
  String get calendarFeedEventTitle => 'Begivenhedens navn';

  @override
  String get calendarFeedEventDescription => 'Beskrivelse af begivenhed';

  @override
  String get calendarFeedEventDetailsWarning =>
      'Ændrer du disse, ændres kalenderlinket — har du allerede abonneret, så abonnér igen med det nye link.';

  @override
  String get stepDurationMinutes => 'Varighed (minutter)';

  @override
  String stepDurationSaved(String duration) {
    return 'Gemt varighed: $duration. Redigering erstatter den med hele minutter.';
  }

  @override
  String get sortTotalTimeShort => 'Korteste samlede tid';

  @override
  String get sortTotalTimeLong => 'Længste samlede tid';

  @override
  String recipeCreatedBy(String name) {
    return 'Oprettet af $name';
  }

  @override
  String get timelineReplacePhoto => 'Erstat foto';

  @override
  String get pasteRecipeTitle => 'Indsæt opskrift';

  @override
  String get pasteRecipeDescription =>
      'Indsæt en opskrift som JSON (schema.org) eller en websides HTML-kildekode.';

  @override
  String get pasteRecipeDescription330 =>
      'Indsæt en opskrift eksporteret fra Mealie (JSON) — den importeres med hele sin struktur: ingredienser, enheder og trinlinks. JSON (schema.org) og en websides HTML-kildekode virker også.';

  @override
  String get pasteRecipeHint => 'Indsæt JSON eller HTML her';

  @override
  String get pasteRecipeButton => 'Indsæt opskrift';

  @override
  String get pasteRecipeImport => 'Importér';

  @override
  String get aiPromptsTitle => 'AI-forespørgsler';

  @override
  String get aiPromptsTeaser =>
      'Tilpas de instruktioner, Mealie giver din AI-udbyder — for alle opgaver eller hver enkelt.';

  @override
  String get aiPromptsDescription =>
      'Tilpas de instruktioner, som Mealie giver din AI-udbyder for hver opgave. Mealies forespørgsler skrives på engelsk, men det ændrer ikke på dine opskrifters sprog: de vil være på samme sprog som deres kildemateriale, medmindre du vælger at få dem oversat. Du kan skrive dine egne instruktioner i et hvilket som helst sprog.';

  @override
  String get aiPromptsGlobal => 'Instruktioner for alle forespørgsler';

  @override
  String get aiPromptsGlobalDescription =>
      'Tilføjes til hver forespørgsel, der producerer opskriftsdata, såsom sammensætning af opskrifter, håndtering af ingredienser, samt oversættelse. Systemforespørgsler påvirkes ikke deraf.';

  @override
  String get aiPromptsGlobalPlaceholder =>
      'f.eks. Benyt altid metriske enheder';

  @override
  String get aiPromptsList => 'Forespørgsler';

  @override
  String get aiPromptSystem => 'System';

  @override
  String get aiPromptSystemDescription =>
      'Dette er en systemforespørgsel. Den transskriberer dit kildemateriale så tæt, som det er muligt, før det omdannes til en opskrift, så instruktioner for alle forespørgsler tilføjes ikke til den. Det er normalt ikke nødvendigt at ændre den, og hvis man gør det, kan det gøre import mindre pålideligt.';

  @override
  String get aiPromptAppended => 'Tilføjet';

  @override
  String get aiPromptOverridden => 'Tilsidesat';

  @override
  String get aiPromptModeDefault => 'Standard';

  @override
  String get aiPromptModeAppend => 'Tilføj';

  @override
  String get aiPromptModeOverride => 'Tilsidesæt';

  @override
  String get aiPromptAppendDescription =>
      'Disse instruktioner tilføjes efter Mealies forespørgsel, og prioriteres først, hvis der er uoverensstemmelser mellem de to.';

  @override
  String get aiPromptOverrideDescription =>
      'Din forespørgsel erstatter fuldstændigt Mealies forespørgsel, så fremtidige ændringer til Mealies forespørgsel gør vil ikke gøre sig gældende for den. Anden data, som opgaven kræver, såsom din liste over enheder, vil stadig blive tilføjet efter din forespørgsel.';

  @override
  String get aiPromptDefaultChanged =>
      'Mealies forespørgsel har ændret sig siden du tilsidesatte den. Sammenlign den med din egen, eller skift tilbage til standardforespørgsel, for at benytte den nye version.';

  @override
  String get aiPromptViewDefault => 'Vis standardforespørgsel';

  @override
  String get aiPromptHideDefault => 'Skjul standardforespørgsel';

  @override
  String get aiPromptSaved => 'Forespørgsel gemt';

  @override
  String get aiPromptSaveFailed => 'Kunne ikke gemme forespørgsel';

  @override
  String get aiPromptTitleBuildRecipe => 'Sammensæt opskrift';

  @override
  String get aiPromptTitleParseIngredients => 'Håndtér ingredienser';

  @override
  String get aiPromptTitleRecipeVideo => 'Opskrift fra video';

  @override
  String get aiPromptTitleOrganizers => 'Tildel til organisatorer';

  @override
  String get aiPromptTitleTranslate => 'Oversæt opskrift';

  @override
  String get aiPromptTitleCompileSource => 'Læs kildemateriale';

  @override
  String get aiPromptTitleTranscribe => 'Transskribér lyd';

  @override
  String get aiPromptDescBuildRecipe =>
      'Omdanner kildemateriale, der læses fra en weside, foto eller tekst til en struktureret opskrift.';

  @override
  String get aiPromptDescParseIngredients =>
      'Bruges af AIs håndtering af ingredienser til at dele hver ingrediens op i mængde, enhed, ingrediens og note.';

  @override
  String get aiPromptDescRecipeVideo =>
      'Omdanner en videos transskription og undertekst til en opskrift.';

  @override
  String get aiPromptDescOrganizers =>
      'Vælger mærkater, kategorier og redskaber for en importeret opskrift.';

  @override
  String get aiPromptDescTranslate =>
      'Oversætter en importeret opskrift til det sprog, du vælger.';

  @override
  String get aiPromptDescCompileSource =>
      'Omdanner websider, fotos og tekst til en ren tekstgennemgang af opskriften.';

  @override
  String get aiPromptDescTranscribe =>
      'Transskriberer lyd, når din lydudbyder ikke kan transskribere det direkte';

  @override
  String get mealplanNoteHint => 'Note (valgfri)';

  @override
  String get mealplanEditTitle => 'Rediger post';

  @override
  String get mealplanEntryTitleLabel => 'Titel';

  @override
  String get mealplanEntryNoteLabel => 'Note';

  @override
  String mealplanCreateRecipe(String name) {
    return 'Ny opskrift “$name”';
  }

  @override
  String get mealplanCreateRecipeSubtitle =>
      'Opretter en tom opskrift, planlægger den og åbner editoren';

  @override
  String get importOptionsTitle => 'Importindstillinger';

  @override
  String get importOptionsHint =>
      'Hvor meget Mealies AI gør på din server ved import. Hvert ekstra trin er sin egen AI-forespørgsel – jo færre, jo hurtigere.';

  @override
  String get importTranslateTitle => 'Oversæt opskrift';

  @override
  String get importOrganizersTitle => 'Kategorier og mærkater';

  @override
  String get importOrganizersCreate => 'Tilføj nye';

  @override
  String get importOrganizersExisting => 'Kun eksisterende';

  @override
  String get importOrganizersNone => 'Ingen';

  @override
  String get importOrganizersCreateHint =>
      'AI tildeler mærkater, kategorier og redskaber og opretter manglende.';

  @override
  String get importOrganizersExistingHint =>
      'AI bruger kun mærkater, kategorier og redskaber, der allerede findes.';

  @override
  String get importOrganizersNoneHint =>
      'Opskriften importeres uden mærkater, kategorier og redskaber. Mealie kører stadig dette trin, så importen bliver ikke hurtigere.';

  @override
  String get importStarting => 'Sender til serveren…';

  @override
  String get importRunning => 'Importerer opskrift…';

  @override
  String get aiImagesRunning => 'AI\'en læser siderne…';

  @override
  String get importStreamPhotosTitle => 'Fotoimport med live-fremskridt';

  @override
  String get importStreamPhotosHint =>
      'Viser hvert trin og holder forbindelsen åben under lange importer. Slå fra for at uploade i én forespørgsel som før – f.eks. hvis din proxy blokerer streaming.';

  @override
  String get weekPlannerDiceRulesMealieSub =>
      'din husstands Mealie-regler (madplanens indstillinger)';

  @override
  String get syncStarted =>
      'Genindlæser opskrifter, billeder og lister fra serveren…';

  @override
  String get syncDone => 'Alt er opdateret';

  @override
  String get recipeReloaded => 'Opskrift genindlæst';

  @override
  String get logoutTitle => 'Log ud / skift bruger';

  @override
  String get logoutConfirm =>
      'Opskrifter, lister og ændringer, der endnu ikke er synkroniseret, fjernes fra denne enhed. Appindstillingerne og serveradressen bliver, så du skal kun logge ind igen.';

  @override
  String get reloadRecipe => 'Genindlæs fra serveren';

  @override
  String get wifiServerTitle => 'Anden adresse på Wi-Fi';

  @override
  String get wifiServerHint =>
      'Til samme server under en anden adresse, f.eks. den lokale IP derhjemme og ZeroTier, Tailscale eller et domæne på farten. På Wi-Fi\'et nedenfor bruger appen automatisk denne adresse, alle andre steder serverens URL ovenfor.';

  @override
  String get wifiSsidLabel => 'Wi-Fi-navn';

  @override
  String get wifiServerUrl => 'Adresse på dette Wi-Fi';

  @override
  String get wifiUseCurrent => 'Brug nuværende Wi-Fi';

  @override
  String get wifiNameUnavailable =>
      'Wi-Fi-navnet kunne ikke læses. Opret forbindelse til Wi-Fi\'et, og tillad lokalitetsadgang – Android og iOS viser kun Wi-Fi-navnet med den.';

  @override
  String wifiServerActive(String ssid) {
    return 'Aktiv: adresse på Wi-Fi “$ssid”';
  }

  @override
  String wifiServerStandardActive(String ssid) {
    return 'Aktiv: serverens URL (ikke på “$ssid”)';
  }

  @override
  String get wifiServerRemove => 'Fjern';

  @override
  String get switchUserTitle => 'Skift bruger';

  @override
  String switchUserBody(String name) {
    return '$name forbliver gemt på denne enhed – med alle opskrifter, lister og ændringer, der endnu ikke er synkroniseret. Du kan skifte tilbage via dit profilbillede eller login-siden.';
  }

  @override
  String get allowBiometricTitle => 'Skift tilbage med enhedsoplåsning';

  @override
  String get allowBiometricHint =>
      'Face ID, fingeraftryk eller enhedens PIN i stedet for adgangskoden. Alle, der kan låse denne enhed op, kan så åbne denne konto.';

  @override
  String get allow => 'Tillad';

  @override
  String unlockAccountReason(String name) {
    return 'Skift til $name';
  }

  @override
  String signInAs(String name) {
    return 'Log ind som $name';
  }

  @override
  String wrongAccountError(String name) {
    return 'Det er kontoen “$name”. Log ind med den gemte konto.';
  }

  @override
  String get accountSaveOffline =>
      'Kontoen kan ikke gemmes lige nu – serveren kan ikke nås.';

  @override
  String get signOutRemoveTitle => 'Log ud og fjern';

  @override
  String get signOutRemoveConfirm =>
      'Denne konto og alle dens data på denne enhed (opskrifter, lister, ikke-synkroniserede ændringer) fjernes. Dine appindstillinger bliver.';

  @override
  String get removeSavedAccount => 'Fjern fra denne enhed';

  @override
  String removeSavedAccountConfirm(String name) {
    return 'Fjern “$name” og alle gemte data fra denne enhed? Ændringer, der ikke er synkroniseret, går tabt.';
  }

  @override
  String get savedAccountsTitle => 'Gemte konti';

  @override
  String get addAccount => 'Tilføj en anden konto';

  @override
  String get biometricOff => 'Stop med at bruge enhedsoplåsning';

  @override
  String get orNewAccount => 'Eller log ind med en anden konto:';

  @override
  String get importVideoTitle => 'Videolinks';

  @override
  String get importVideoFast => 'Hurtig';

  @override
  String get importVideoThorough => 'Grundig (AI)';

  @override
  String get importVideoFastHint =>
      'Mealie transskriberer videoen og opbygger opskriften med én AI-forespørgsel – som regel meget hurtigere. Ingen oversættelse og ingen kategorier/mærkater. Du kan stadig slå AI til pr. import.';

  @override
  String get importVideoThoroughHint =>
      'AI-kontakten slås automatisk til for videolinks: flere AI-trin, med oversættelse og kategorier/mærkater som indstillet ovenfor. Tager længere tid.';

  @override
  String get importPresetFast => 'Hurtig';

  @override
  String get importPresetThorough => 'Grundig';

  @override
  String get importPresetCustom => 'Tilpasset';

  @override
  String get importPresetFastTitle =>
      'Så få AI-trin som muligt – den korteste ventetid';

  @override
  String get importPresetFastVideo =>
      'Videolinks: Mealie transskriberer videoen og opbygger opskriften med én AI-forespørgsel (AI-kontakten forbliver slået fra).';

  @override
  String get importPresetFastTranslate =>
      'Ingen oversættelse – opskriften bliver på originalsproget.';

  @override
  String get importPresetFastOrganizers =>
      'Kun eksisterende kategorier og mærkater tildeles, der oprettes ingen nye.';

  @override
  String get importPresetThoroughTitle =>
      'Mealies fulde AI-import – tager længere tid, får mest ud af det';

  @override
  String get importPresetThoroughVideo =>
      'Videolinks importeres automatisk med AI – i flere trin (saml kilden, opbyg opskriften, …).';

  @override
  String get importPresetThoroughTranslate =>
      'Opskriften oversættes til importsproget nedenfor, hvis den er skrevet på et andet sprog.';

  @override
  String get importPresetThoroughOrganizers =>
      'Passende kategorier og mærkater tildeles; manglende oprettes.';

  @override
  String get importPresetCustomTitle => 'Indstil hver mulighed selv';

  @override
  String get importPresetCustomBody =>
      'Tag udgangspunkt i det, dit tidligere valg gjorde, og ændr kun det nødvendige – f.eks. hurtige videoimporter men med oversættelse.';

  @override
  String get sidebarPinHint =>
      'Tip: hold et felt nede, og træk det til sidebjælken for at fastgøre det der.';

  @override
  String get sidebarDropHere => 'Slip her';

  @override
  String sidebarShortcutTitle(String name) {
    return 'Genvej til “$name”';
  }

  @override
  String sidebarShortcutPrompt(String modifier) {
    return 'Tryk nu på den ønskede tastkombination, inklusive $modifier.';
  }

  @override
  String get sidebarShortcutTaken => 'Denne kombination er allerede i brug.';

  @override
  String get sidebarShortcutNone => 'Ingen genvej';

  @override
  String get sidebarShortcutChange => 'Skift genvej';

  @override
  String get sidebarUnpin => 'Fjern fra sidebjælken';

  @override
  String sidebarFull(int count) {
    return 'Sidebjælken er fuld – højst $count egne poster.';
  }

  @override
  String get tabletSidebar => 'Sidebjælke i liggende format';

  @override
  String get tabletSidebarSubtitle =>
      'Viser navigationen til venstre i stedet for nederst, når tabletten holdes på tværs';

  @override
  String get filterDateCreated => 'Oprettet';

  @override
  String get filterDateUpdated => 'Opdateret';

  @override
  String get errorUploadTooLarge =>
      'Filen er for stor til denne Mealie-server. Serverens uploadgrænse kan hæves med MAX_UPLOAD_SIZE_MB.';

  @override
  String get recipeDownloadPdfMealie => 'Download PDF (Mealies layout)';

  @override
  String get mealplanNoteMore => 'Vis mere…';

  @override
  String get mealplanNoteLess => 'Vis mindre';

  @override
  String get ingredientCommonlySubstitutedWith => 'Ofte erstattet af';

  @override
  String requiresMealieVersion(String version) {
    return 'Kræver Mealie $version eller nyere.';
  }

  @override
  String get apiTokensTitle => 'API-tokener';

  @override
  String get apiTokensDescription =>
      'Administrer dine API Tokens for adgang fra eksterne applikationer.';

  @override
  String get apiTokenNameLabel => 'Tokennavn';

  @override
  String get apiTokenGenerate => 'Generer';

  @override
  String get apiTokensActive => 'Aktive tokens';

  @override
  String get apiTokenCopyWarning =>
      'Kopier denne token ved brug i en anden applikation. Denne token kan ikke ses igen.';

  @override
  String get apiTokenThisApp => 'Bruges af denne app';

  @override
  String get apiTokenThisAppHint =>
      'Dette token holder appen logget ind og kan ikke slettes her.';

  @override
  String apiTokenDeleteConfirm(String name) {
    return 'Slet tokenet “$name”? Apps, der bruger det, mister straks adgangen.';
  }

  @override
  String get apiTokensEmpty => 'Ingen tokens endnu.';

  @override
  String apiTokenCreatedOn(String date) {
    return 'Oprettet $date';
  }

  @override
  String get apiTokenCopied => 'Token kopieret';

  @override
  String get qfOpHasNoValue => 'har ingen værdi';

  @override
  String get qfOpHasValue => 'har værdien';

  @override
  String get ratingHouseholdAverage => 'husstandens gns.';

  @override
  String get stepLinkedNotes => 'Linkede noter';

  @override
  String get noteFallbackTitle => 'Note';

  @override
  String get aiPromptTitleEnrichInstructions => 'Tilføj detaljer til skridt';

  @override
  String get aiPromptDescEnrichInstructions =>
      'Opretter links fra hvert skridt i en importeret opskrift, til de ingredienser og noter, som den benytter, samt angiver varighed og overskift.';

  @override
  String get loginAccountLocked => 'Konto låst. Prøv igen senere';

  @override
  String get loginPasswordDisabled =>
      'Login med adgangskode er deaktiveret på denne server. Brug et API-token i stedet.';

  @override
  String get unitSystemTitle => 'Enheder';

  @override
  String get unitSystemAsWritten => 'Som skrevet';

  @override
  String get unitSystemMetric => 'Metrisk';

  @override
  String get unitSystemMetricHint => 'Metrisk (g, mL, etc.)';

  @override
  String get unitSystemImperial => 'Amerikansk';

  @override
  String get unitSystemImperialHint => 'Amerikansk (kopper, ounces, etc.)';

  @override
  String get unitSystemHint =>
      'Kun visningen – selve opskriften ændres ikke. Som i Mealies webapp gælder valget alle opskrifter på denne enhed.';

  @override
  String get unitSystemUnavailable =>
      'Ingen enheder i denne opskrift kan omregnes. Det kræver en standardisering af enheden i Mealie (Ingredienser og enheder → enhed → Standardisering).';

  @override
  String get shoppingCheckAll => 'Markér alle elementer';

  @override
  String get shoppingUncheckAll => 'Fjern markering af alle elementer';

  @override
  String get shoppingDeleteChecked => 'Slet valgte';

  @override
  String get shoppingCheckAllConfirm =>
      'Er du sikker på, at du vil markere alle elementer?';

  @override
  String get shoppingUncheckAllConfirm =>
      'Er du sikker på, at du vil fjerne markeringen af alle elementer?';

  @override
  String shoppingItemCheckedOff(String item) {
    return 'Krydsede $item af';
  }

  @override
  String get updateGithubUnavailable =>
      'GitHub svarer ikke lige nu. Prøv igen om et par minutter.';
}
