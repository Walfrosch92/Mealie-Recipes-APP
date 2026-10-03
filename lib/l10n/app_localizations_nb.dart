// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Norwegian Bokmål (`nb`).
class AppLocalizationsNb extends AppLocalizations {
  AppLocalizationsNb([String locale = 'nb']) : super(locale);

  @override
  String get appTitle => 'Mealie Recipes';

  @override
  String get endCookingMode => 'Avslutt kokemodus';

  @override
  String get endCookingModeConfirm => 'Vil du virkelig avslutte kokemodus?';

  @override
  String endCookingModeConfirmAll(int count) {
    return 'Dette avslutter alle $count oppskrifter i kokemodus. Fortsette?';
  }

  @override
  String get addTimer => 'Legg til timer';

  @override
  String get recipeFinished => 'Retten din er klar.';

  @override
  String get bonAppetit => 'Velbekomme!';

  @override
  String get prepareIngredients => 'Gjør klar følgende ingredienser';

  @override
  String prepareIngredientsFor(String servings) {
    return 'Gjør klar følgende ingredienser til $servings porsjoner';
  }

  @override
  String get next => 'Neste';

  @override
  String get navHome => 'Hjem';

  @override
  String get homeCookToday => 'Lag i dag';

  @override
  String get homeSuggestion => 'Forslag';

  @override
  String get homeQuickAccess => 'Hurtigtilgang';

  @override
  String get homePlanned => 'Planlagt';

  @override
  String get favorite => 'Favoritt';

  @override
  String get navSettings => 'Innstillinger';

  @override
  String homeWelcomeName(Object name) {
    return 'Velkommen $name,';
  }

  @override
  String get homeWelcomeApp => 'til Mealie Recipes 👋';

  @override
  String get theme => 'Utseende';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Lys';

  @override
  String get themeDark => 'Mørk';

  @override
  String get recipes => 'Oppskrifter';

  @override
  String get shoppingList => '🛒 Handleliste';

  @override
  String get mealplan => 'Måltidsplan';

  @override
  String get settings => '⚙️ Innstillinger';

  @override
  String get searchRecipe => 'Søk etter oppskrift...';

  @override
  String get loadingRecipes => 'Laster oppskrifter...';

  @override
  String get loadingRecipe => 'Laster oppskrift...';

  @override
  String errorLoadingRecipes(String error) {
    return 'Feil ved lasting av oppskrifter: $error';
  }

  @override
  String get errorLoadingRecipe => 'Kunne ikke laste oppskriften.';

  @override
  String get noRecipesForCategory => 'Ingen oppskrifter for dette filteret.';

  @override
  String get resetFilter => 'Nullstill filter';

  @override
  String get allCategories => 'Alle kategorier';

  @override
  String get all => 'Alle';

  @override
  String get sortRecipes => 'Sorter oppskrifter';

  @override
  String get refreshRecipes => 'Oppdater';

  @override
  String get sortNameAZ => 'Navn A–Å';

  @override
  String get sortNameZA => 'Navn Å–A';

  @override
  String get sortDateNewest => 'Nyeste først';

  @override
  String get sortDateOldest => 'Eldste først';

  @override
  String get sortPrepTimeShort => 'Kortest forberedelsestid';

  @override
  String get sortPrepTimeLong => 'Lengst forberedelsestid';

  @override
  String get sortRatingHighest => 'Høyest vurdering';

  @override
  String get sortRatingLowest => 'Lavest vurdering';

  @override
  String get details => 'Detaljer';

  @override
  String get ingredients => 'Ingredienser';

  @override
  String get instructions => 'Fremgangsmåte';

  @override
  String get tags => 'Emneord';

  @override
  String get notes => 'Notater';

  @override
  String get addNote => 'Legg til notat';

  @override
  String get editNote => 'Rediger notat';

  @override
  String get noteTitleHint => 'Tittel (valgfritt)';

  @override
  String get noteTextHint => 'Notattekst';

  @override
  String get deleteNoteTitle => 'Slette notatet?';

  @override
  String get deleteNoteMessage => 'Notatet slettes permanent.';

  @override
  String get servings => 'Porsjoner';

  @override
  String get adjustQuantity => 'Juster mengde';

  @override
  String get startTimer => 'Start timer';

  @override
  String runningTimer(int minutes, String seconds) {
    return 'Timer: $minutes:$seconds';
  }

  @override
  String get planMeal => 'Planlegg måltid';

  @override
  String get displayAlwaysOn => 'Hold skjermen på';

  @override
  String get addAllIngredients => 'Legg til alle ingredienser';

  @override
  String get addSelectedIngredients => 'Legg til valgte ingredienser';

  @override
  String get addIngredientsTitle => 'Ingredienser lagt til';

  @override
  String get addIngredientsMessage =>
      'Ingrediensene er lagt til i handlelisten din.';

  @override
  String addIngredientsFailedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ingredienser kunne ikke legges til.',
      one: '1 ingrediens kunne ikke legges til.',
    );
    return '$_temp0';
  }

  @override
  String get cookbooks => 'Kokebøker';

  @override
  String get cookbooksEmpty =>
      'Ingen kokebøker ennå. Trykk på «+» øverst til høyre for å opprette en.';

  @override
  String get cookbookNoMatches =>
      'Ingen oppskrifter passer til dette filteret.';

  @override
  String get cookbookCreateTitle => 'Opprett kokebok';

  @override
  String get cookbookEditTitle => 'Rediger kokebok';

  @override
  String get cookbookNameLabel => 'Navn på kokebok';

  @override
  String get cookbookFilterSectionTitle => 'Legg til oppskrifter automatisk';

  @override
  String get cookbookFieldTools => 'Kjøkkenredskap';

  @override
  String get cookbookFieldUsers => 'Brukere';

  @override
  String get cookbookOpIsOneOf => 'er en av';

  @override
  String get cookbookOpIsNotOneOf => 'er ikke en av';

  @override
  String get cookbookOpContainsAll => 'inneholder alle';

  @override
  String get cookbookSelectValues => 'Velg verdier';

  @override
  String get cookbookFilterOptionsUnavailable =>
      'Ingen alternativer tilgjengelig';

  @override
  String get cookbookAddFilterField => 'Legg til felt';

  @override
  String get cookbookPublicLabel => 'Offentlig kokebok';

  @override
  String get cookbookPublicSubtitle =>
      'Synlig for andre husholdninger på serveren';

  @override
  String get cookbookRawModeEnter => 'Rediger som tekst';

  @override
  String get cookbookRawModeExit => 'Tilbake til byggeren';

  @override
  String get cookbookRawModeHint =>
      'Appens ekspertmodus: redigerer filteret direkte som tekst. Nyttig når et eksisterende filter ikke kunne deles opp i enkle rader.';

  @override
  String get cookbookRawModeUnparseable =>
      'Denne teksten passer ikke til det enkle radformatet — den forblir tekst.';

  @override
  String get saveFailed => 'Lagring mislyktes';

  @override
  String get search => 'Søk';

  @override
  String get apply => 'Bruk';

  @override
  String get setupCachingTitle => 'Laster oppskriftene dine';

  @override
  String get setupCachingSubtitle =>
      'Oppskriftene dine gjøres klare for bruk uten nett. Avhengig av hvor mange du har, kan dette ta litt tid.';

  @override
  String get setupCachingDone => 'Alt klart!';

  @override
  String get setupTipsHeader => 'Visste du?';

  @override
  String get setupFinish => 'Sett i gang';

  @override
  String get setupSkipCaching => 'Fortsett i bakgrunnen';

  @override
  String get setupTip1 =>
      'Du kan importere oppskrifter fra en lenke, et bilde eller en PDF — via Import-flisen på startskjermen.';

  @override
  String get setupTip2 =>
      'Kokemodus holder skjermen våken, guider deg steg for steg og oppdager tidtakere i teksten automatisk.';

  @override
  String get setupTip3 =>
      'Handlelisten fungerer også uten nett — endringer synkroniseres automatisk når serveren er tilgjengelig.';

  @override
  String get setupTip4 =>
      'Trykk lenge på en flis på startskjermen for å omorganisere hurtigtilgangen.';

  @override
  String get setupTip5 =>
      'Finn Mealie-kokebøkene dine via Kokebøker-flisen — også uten nett.';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Avbryt';

  @override
  String get delete => 'Slett';

  @override
  String get edit => 'Rediger';

  @override
  String get save => 'Lagre';

  @override
  String get done => 'Ferdig';

  @override
  String get close => 'Lukk';

  @override
  String get add => 'Legg til';

  @override
  String get send => 'Send';

  @override
  String get retry => 'Prøv igjen';

  @override
  String get confirmDeleteTitle => 'Slette oppskriften?';

  @override
  String get confirmDeleteMessage => 'Denne handlingen kan ikke angres.';

  @override
  String get sendToDevice => 'Send til enhet';

  @override
  String get sendToDevicePickerTitle => 'Send til enhet';

  @override
  String get sendToAllDevices => 'Send til alle enheter';

  @override
  String get timerFinished => 'Timeren er ferdig!';

  @override
  String get timerFinishedBody => 'Oppskriftstimeren din er ferdig.';

  @override
  String get timer => 'Timer';

  @override
  String get newTimer => 'Ny timer';

  @override
  String get timerDetails => 'Timerdetaljer';

  @override
  String get timerNamePlaceholder => 'Navn på timer';

  @override
  String get timerNameHint => 'Gi timeren et beskrivende navn.';

  @override
  String get durationLabel => 'Varighet';

  @override
  String minutesCount(int count) {
    return '$count minutter';
  }

  @override
  String get start => 'Start';

  @override
  String get stop => 'Stopp';

  @override
  String get pause => 'Pause';

  @override
  String get resume => 'Fortsett';

  @override
  String get finished => 'Ferdig!';

  @override
  String stepNumber(int number) {
    return 'Steg $number';
  }

  @override
  String get minAbbreviation => 'min';

  @override
  String get cookingMode => 'Kokemodus';

  @override
  String activeRecipesCount(int count) {
    return '$count aktive oppskrifter';
  }

  @override
  String get endAll => 'Avslutt alle';

  @override
  String get end => 'Avslutt';

  @override
  String get endAllRecipesTitle => 'Avslutte alle oppskrifter?';

  @override
  String endAllRecipesMessage(int count) {
    return 'Vil du avslutte alle $count aktive kokeøkter?';
  }

  @override
  String get endRecipeTitle => 'Avslutte oppskriften?';

  @override
  String endRecipeMessage(String name) {
    return 'Vil du avslutte kokeøkten for «$name»?';
  }

  @override
  String get noActiveTimers => 'Ingen aktive timere';

  @override
  String get noActiveRecipes => 'Ingen aktive oppskrifter';

  @override
  String get startRecipeToCook =>
      'Åpne en oppskrift og trykk på kokemodus-knappen for å starte.';

  @override
  String get browseRecipes => 'Bla i oppskrifter';

  @override
  String timersPausedCount(int count) {
    return '$count timer(e) satt på pause';
  }

  @override
  String get cookFriends => 'Lag mat med venner';

  @override
  String get cookingModeAddRecipe => 'Legg til oppskrift';

  @override
  String get cookingModeAddRecipeSearchHint => 'Søk i oppskrifter';

  @override
  String get cookFriendsCode => 'Øktkode';

  @override
  String get cookFriendsJoin => 'Bli med i økt';

  @override
  String get cookFriendsHost => 'Start økt';

  @override
  String get cookFriendsHostNotFound =>
      'Fant ikke verten. Sørg for at begge enhetene er på samme Wi-Fi og at tilgang til lokalt nettverk er tillatt.';

  @override
  String get cookFriendsConnectionFailed =>
      'Tilkoblingen mislyktes. Prøv igjen.';

  @override
  String get cookFriendsEnterCode => 'Skriv inn kode';

  @override
  String cookFriendsConnected(int count) {
    return 'Tilkoblet: $count gjester';
  }

  @override
  String get joinSession => 'Bli med i økt';

  @override
  String get hostEndedSessionTitle => 'Økten er avsluttet';

  @override
  String get hostEndedSessionMessage => 'Verten har avsluttet kokeøkten.';

  @override
  String get shoppingListEmpty => 'Handlelisten din er tom.';

  @override
  String get addItem => 'Legg til vare';

  @override
  String get itemNote => 'Varenavn';

  @override
  String get unlabeledCategory => 'Uten etikett';

  @override
  String get reorderCategories => 'Endre rekkefølge på kategorier';

  @override
  String get archiveChecked => 'Arkiver avkryssede varer';

  @override
  String get archivedLists => '📦 Arkiverte innkjøp';

  @override
  String get syncChanges => 'Synkroniser endringer';

  @override
  String get noSyncChanges => 'Ingen endringer å synkronisere';

  @override
  String get postimportAction => 'Etter import';

  @override
  String get postimportHint =>
      'Velg hva som skal skje med de importerte oppføringene i kildeappen (Påminnelser / Google Tasks).';

  @override
  String get postimportLeave => 'Bare legg til';

  @override
  String get postimportComplete => 'Kryss av';

  @override
  String get postimportCompleteDelete => 'Kryss av og slett';

  @override
  String get postimportFailed =>
      'Etterbehandlingen i kildeappen mislyktes. Varene ble likevel lagt til i Mealie.';

  @override
  String get syncChangesTitle => 'Synkroniser endringer';

  @override
  String get syncSectionChecked => 'Avkrysset';

  @override
  String get syncSectionQuantity => 'Mengde';

  @override
  String get syncSectionCategory => 'Kategori';

  @override
  String get syncSectionAdditions => 'Nylig lagt til';

  @override
  String get syncLocalLabel => 'Lokalt';

  @override
  String get syncServerLabel => 'Server';

  @override
  String get syncNow => 'Synkroniser nå';

  @override
  String get offlineBadge => 'Frakoblet';

  @override
  String get mealplanTitle => '📅 Måltidsplan';

  @override
  String get mealplanSelectMode => 'Velg flere oppskrifter';

  @override
  String mealplanSelectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count valgt',
      one: '1 valgt',
      zero: 'Velg',
    );
    return '$_temp0';
  }

  @override
  String get breakfast => 'Frokost';

  @override
  String get lunch => 'Lunsj';

  @override
  String get dinner => 'Middag';

  @override
  String get addMealEntry => 'Legg til måltid';

  @override
  String get selectRecipe => 'Velg oppskrift';

  @override
  String get orFreeText => 'eller fritekst';

  @override
  String get entryNote => 'Notat';

  @override
  String get noMealEntries => 'Ingen oppføringer denne uken.';

  @override
  String get importRecipe => 'Importer oppskrift';

  @override
  String get importFromUrl => 'Importer fra URL';

  @override
  String get importFromImage => 'Importer fra bilde';

  @override
  String get importFromJson => 'Importer fra JSON';

  @override
  String get url => 'URL';

  @override
  String get urlPlaceholder => 'https://...';

  @override
  String get importLanguage => 'Språk for OCR';

  @override
  String get importing => 'Importerer...';

  @override
  String get importSuccess => 'Oppskriften ble importert!';

  @override
  String importError(String error) {
    return 'Importen mislyktes: $error';
  }

  @override
  String get pasteJson => 'Lim inn JSON her';

  @override
  String get setupTitle => 'Velkommen til Mealie Recipes';

  @override
  String get setupSubtitle => 'Konfigurer Mealie-serveren din.';

  @override
  String get serverUrl => 'Server-URL';

  @override
  String get serverUrlPlaceholder => 'https://mealie.example.com';

  @override
  String get apiToken => 'API-token';

  @override
  String get apiTokenPlaceholder => 'Ditt API-token';

  @override
  String get householdId => 'Husholdning';

  @override
  String get householdIdPlaceholder => 'Familie';

  @override
  String get shoppingListId => 'Handleliste-ID';

  @override
  String get shoppingListIdPlaceholder => 'Velg en handleliste';

  @override
  String get setupHouseholdListTitle => 'Husholdning og handleliste';

  @override
  String get shoppingListLabel => 'Handleliste';

  @override
  String get setupHouseholdManualHint =>
      'Kunne ikke laste husholdninger — skriv inn navnet på husholdningen manuelt.';

  @override
  String get setupExactTitle => 'Mengder på handlelisten';

  @override
  String get setupExactBody =>
      'I de fleste land handler man ikke på grammet — du legger 1 pakke smør i kurven, ikke 200 g. I enkel modus gjør appen derfor om mengdene i oppskriften til «1×». I nøyaktig modus beholdes mengde og enhet 1:1 som i Mealie-webappen — også når du skriver inn nye varer (f.eks. «200 g smør»). Du kan endre dette når som helst i innstillingene.';

  @override
  String get setupExactSimpleTitle => 'Enkel modus (1×)';

  @override
  String get setupExactSimpleBody =>
      'Ingrediensene havner på listen som «1× vare» — ideelt for rask avkrysning i butikken.';

  @override
  String get setupExactExactTitle => 'Nøyaktige mengder';

  @override
  String get setupExactExactBody =>
      'Varer vises med mengde og enhet, f.eks. «200 g smør» — akkurat som i webappen.';

  @override
  String get connect => 'Koble til';

  @override
  String get connecting => 'Kobler til...';

  @override
  String get connectionSuccess => 'Tilkoblingen var vellykket!';

  @override
  String connectionError(String error) {
    return 'Tilkoblingen mislyktes: $error';
  }

  @override
  String get optionalHeaders => 'Valgfrie HTTP-headere (for omvendt proxy)';

  @override
  String get settingsTitle => '⚙️ Innstillinger';

  @override
  String get settingsSaved => 'Innstillingene er lagret';

  @override
  String get serverSettings => 'Server';

  @override
  String get displaySettings => 'Visning';

  @override
  String get notificationSettings => 'Varsler';

  @override
  String get securitySettings => 'Sikkerhet';

  @override
  String get aboutSettings => 'Om';

  @override
  String get showRecipeImages => 'Vis oppskriftsbilder';

  @override
  String get apiVersion => 'API-versjon';

  @override
  String get language => 'Språk';

  @override
  String get biometricLock => 'Biometrisk lås';

  @override
  String get biometricLockDescription => 'Lås opp appen med biometri';

  @override
  String get criticalAlerts => 'Kritiske varsler';

  @override
  String get criticalAlertsDescription => 'Timeralarm også i lydløs modus';

  @override
  String get enableLogging => 'Aktiver logging';

  @override
  String get selectLanguage => 'Velg språk';

  @override
  String get setupContinue => 'Fortsett';

  @override
  String get back => 'Tilbake';

  @override
  String get setupConnectStep => 'Koble til serveren din';

  @override
  String get resetSettings => 'Tilbakestill alle innstillinger';

  @override
  String get resetSettingsConfirm =>
      'Dette tilbakestiller alle innstillinger. Fortsette?';

  @override
  String get guestMode => 'Gjestemodus';

  @override
  String get appVersion => 'Versjon';

  @override
  String get leftoverFinder => 'Oppskriftsfinner';

  @override
  String get leftoverFinderSubtitle =>
      'Finn oppskrifter med ingrediensene du har';

  @override
  String get addIngredient => 'Legg til ingrediens';

  @override
  String get ingredientPlaceholder => 'f.eks. egg';

  @override
  String get findRecipes => 'Finn oppskrifter';

  @override
  String get matchingRecipes => 'Passende oppskrifter';

  @override
  String get noMatchingRecipes =>
      'Fant ingen oppskrifter med disse ingrediensene.';

  @override
  String matchPercent(int percent) {
    return '$percent % treff';
  }

  @override
  String get biometricPrompt => 'Autentiser deg for å åpne Mealie Recipes';

  @override
  String get biometricFailed => 'Autentiseringen mislyktes';

  @override
  String get whatsNew => 'Hva er nytt';

  @override
  String get pendingRecipesTitle => 'Mottatte oppskrifter';

  @override
  String pendingRecipesMessage(String sender, String name) {
    return 'Du har mottatt en oppskrift fra $sender: «$name»';
  }

  @override
  String pendingRecipesFrom(Object names) {
    return 'Fra $names';
  }

  @override
  String get pendingRecipesOpenCooking => 'Åpne kokemodus';

  @override
  String get pendingRecipesLater => 'Senere';

  @override
  String get openRecipe => 'Åpne oppskrift';

  @override
  String get dismiss => 'Lukk';

  @override
  String get editRecipe => 'Rediger oppskrift';

  @override
  String get recipeName => 'Navn på oppskrift';

  @override
  String get recipeDescription => 'Beskrivelse';

  @override
  String get prepTime => 'Forberedelsestid (min)';

  @override
  String get cookTime => 'Koketid (min)';

  @override
  String get totalTime => 'Total tid (min)';

  @override
  String get recipeServings => 'Porsjoner';

  @override
  String get rating => 'Vurdering';

  @override
  String get addIngredientLine => 'Legg til ingrediens';

  @override
  String get addInstruction => 'Legg til steg';

  @override
  String get removeIngredient => 'Fjern ingrediens';

  @override
  String get removeInstruction => 'Fjern steg';

  @override
  String get ingredientName => 'Ingrediens';

  @override
  String get ingredientQuantity => 'Mengde';

  @override
  String get ingredientUnit => 'Enhet';

  @override
  String get ingredientNote => 'Notat';

  @override
  String get instructionText => 'Stegtekst';

  @override
  String get categories => 'Kategorier';

  @override
  String get selectCategories => 'Velg kategorier';

  @override
  String get selectTags => 'Velg emneord';

  @override
  String get uploadImage => 'Last opp bilde';

  @override
  String get removeImage => 'Fjern bilde';

  @override
  String get saveChanges => 'Lagre endringer';

  @override
  String get saving => 'Lagrer...';

  @override
  String get saveSuccess => 'Oppskriften er lagret.';

  @override
  String saveError(String error) {
    return 'Kunne ikke lagre: $error';
  }

  @override
  String get newCategory => 'Ny kategori';

  @override
  String get newTag => 'Nytt emneord';

  @override
  String get setRating => 'Gi vurdering';

  @override
  String get removeRating => 'Fjern vurdering';

  @override
  String get ratingRemoved => 'Vurderingen er fjernet';

  @override
  String get googleTasksImport => 'Importer fra Google Tasks';

  @override
  String get googleTasksImportDescription =>
      'Importer varer fra Google Tasks til handlelisten din.';

  @override
  String get homeWelcome => 'Velkommen til Mealie Recipes! 👋';

  @override
  String homeWelcomeNamed(String name) {
    return 'Velkommen $name, til Mealie Recipes! 👋';
  }

  @override
  String get shopping => 'Handling';

  @override
  String get planning => 'Planlegging';

  @override
  String get other => 'Annet';

  @override
  String get viewRecipes => '📖 Se oppskrifter';

  @override
  String get addRecipe => '➕ Legg til oppskrift';

  @override
  String get completeShopping => 'Fullfør handlingen';

  @override
  String get shoppingCompleted => 'Handlingen er fullført';

  @override
  String get shoppingCompletedSubtitle => 'Alt er i kurven! 🎉';

  @override
  String get essensplan => '📅 Måltidsplan';

  @override
  String get resteverwertung => '🥗 Oppskriftsfinner';

  @override
  String get newRecipeUpload => 'Last opp ny oppskrift';

  @override
  String get copyCode => 'Kopier kode';

  @override
  String get shareLink => 'Del lenke';

  @override
  String get connectedFriends => 'Tilkoblede venner';

  @override
  String get waitingForFriends => 'Venter på venner...';

  @override
  String get endSharing => 'Avslutt deling';

  @override
  String get cookFriendsDescription =>
      'Inviter en venn til å lage denne oppskriften sammen';

  @override
  String get sessionCode => 'ØKTKODE';

  @override
  String get adjustQuantityLabel => 'Juster mengden for denne oppskriften:';

  @override
  String get timerStartForStep => 'Timer for steg';

  @override
  String get enterRecipeUrl => 'Skriv inn oppskrifts-URL';

  @override
  String get loading => 'Laster...';

  @override
  String get urlInvalidScheme => 'URL-en må starte med http:// eller https://';

  @override
  String get urlAddScheme => 'Legg til https://';

  @override
  String get addItemPlaceholder => 'Legg til vare...';

  @override
  String get addSuccessToast => 'Lagt til!';

  @override
  String get completedItems => 'Fullført';

  @override
  String get completeShoppingTitle => 'Fullføre handlingen?';

  @override
  String get completeShoppingMessage => 'Slette fullførte varer?';

  @override
  String get recipeListTitle => '📖 Oppskrifter';

  @override
  String get importRecipeTitle => 'Last opp ny oppskrift';

  @override
  String get uploadRecipeUrl => 'Importer via oppskrifts-URL';

  @override
  String get uploadRecipeUrlHint =>
      'Skriv inn URL-en til oppskriften for å lagre den på serveren din';

  @override
  String get uploadOpenAI => 'Importer fra fil via OpenAI';

  @override
  String get uploadOpenAIHint =>
      'Du kan også laste opp bilder eller en PDF av en oppskrift. Går oppskriften over flere sider, legger du bare til flere — de analyseres samlet av KI.';

  @override
  String get takePhoto => 'Kamera';

  @override
  String get cameraPermissionDenied =>
      'Ingen tilgang til kameraet. Tillat det i systeminnstillingene for å fotografere oppskrifter.';

  @override
  String get cameraUnavailable => 'Ingen kamera tilgjengelig på denne enheten.';

  @override
  String get selectPhoto => 'Bilder';

  @override
  String get selectPdf => 'PDF';

  @override
  String get openAIHintTitle => 'Info om filanalyse';

  @override
  String get openAIHintBody =>
      'Oppskriftsanalysen bruker OpenAI-API-et. Sørg for at API-nøkkelen din er konfigurert i innstillingene på Mealie-serveren.';

  @override
  String get allDeleteConfirm => 'Slett alle';

  @override
  String get portionen => 'Porsjoner';

  @override
  String get timerForStep => 'Start timer for dette steget';

  @override
  String get weekNavPrev => 'Forrige uke';

  @override
  String get weekNavNext => 'Neste uke';

  @override
  String get noMealsThisWeek => 'Ingen måltider planlagt';

  @override
  String get entriesInOtherWeeks => 'Det finnes oppføringer i andre uker';

  @override
  String get availableWeeks => 'Tilgjengelige uker:';

  @override
  String weekRange(Object end, Object start, Object week) {
    return 'Uke $week ($start – $end)';
  }

  @override
  String get currentWeek => 'Denne uken';

  @override
  String get rezepteAktualisieren => 'Oppdater oppskrifter';

  @override
  String get leftoverWhatTitle => 'Hva gjør dette?';

  @override
  String get leftoverWhatBody =>
      'Denne funksjonen laster alle oppskrifter på nytt fra serveren og oppdaterer den lokale hurtigbufferen.';

  @override
  String get leftoverDescription =>
      'Skriv inn ingredienser du har, for å finne passende oppskrifter og bruke opp rester.';

  @override
  String get leftoverIngredientsHeader => 'Ingredienser hjemme';

  @override
  String get leftoverSuggestions => 'Oppskriftsforslag';

  @override
  String get leftoverNoMatches => 'Fant ingen passende oppskrifter.';

  @override
  String get leftoverEnterIngredient => 'Skriv inn ingrediens';

  @override
  String matchingPercentText(int percent, int count, int total) {
    return '$percent % treff ($count/$total)';
  }

  @override
  String get weekAbbreviation => 'Uke';

  @override
  String get today => 'I dag';

  @override
  String get selectDate => 'Velg dato';

  @override
  String get selectSlot => 'Velg måltid';

  @override
  String get selectedRecipe => 'Valgt oppskrift';

  @override
  String get confirmMeal => 'Planlegg måltid';

  @override
  String get searchRecipes => 'Søk i oppskrifter';

  @override
  String get addCustomMeal => 'Legg til eget måltid';

  @override
  String get diceModeButton => 'Trekk tilfeldige oppskrifter';

  @override
  String get diceModeTitle => '3 tilfeldige forslag';

  @override
  String get diceBackToSearch => 'Tilbake til søk';

  @override
  String get diceNotEnoughRecipes =>
      'Ikke nok oppskrifter for terningmodus (minst 3 trengs)';

  @override
  String get entrySingular => 'oppføring';

  @override
  String get entriesPlural => 'oppføringer';

  @override
  String listTitle(int n) {
    return 'Liste $n';
  }

  @override
  String get deleteAllConfirmTitle => 'Slette alle?';

  @override
  String get deleteAllConfirmMessage => 'Vil du slette alle arkiverte innkjøp?';

  @override
  String get uploadFromUrlButton => 'Importer oppskrift fra URL';

  @override
  String get uploadingImage => 'Laster opp...';

  @override
  String get uploadErrorTitle => 'Opplastingen mislyktes';

  @override
  String get uploadSuccessTitle => 'Opplastingen var vellykket';

  @override
  String get editImportedRecipeQuestion =>
      'Vil du redigere den nye oppskriften nå?';

  @override
  String get notNow => 'Ikke nå';

  @override
  String get pdfTooLarge => 'PDF-filen er for stor (maks 10 MB).';

  @override
  String get invalidUrl => 'Ugyldig URL. Skriv inn en gyldig HTTP(S)-URL.';

  @override
  String get cookWithFriends => 'Lag mat med venner';

  @override
  String get cookFriendsSubtitle =>
      'Inviter en venn til å lage denne oppskriften sammen';

  @override
  String get copied => 'Kopiert';

  @override
  String get linkCopied => 'Lenken er kopiert';

  @override
  String get startCooking => 'Begynn å lage mat';

  @override
  String get hostNoRecipe => 'Åpne fra en oppskrift for å starte en økt';

  @override
  String get uploadToOwnServer => 'Lagre på serveren min';

  @override
  String get uploadingRecipe => 'Laster opp oppskrift…';

  @override
  String get recipeUploadedToOwnServer =>
      'Oppskriften er lagret på serveren din';

  @override
  String get recipeUploadFailed => 'Opplastingen mislyktes';

  @override
  String get allowGuestSaveRecipes =>
      'La gjester lagre oppskrifter på sin egen server';

  @override
  String get appIcon => 'Appikon';

  @override
  String get appIconClassic => 'Classic';

  @override
  String get appIconModern => 'Modern';

  @override
  String get name => 'Navn';

  @override
  String get color => 'Farge';

  @override
  String get randomColor => 'Tilfeldig farge';

  @override
  String get createFailed => 'Kunne ikke opprette';

  @override
  String get deleteFailed => 'Kunne ikke slette';

  @override
  String deleteOrganizerConfirm(String name) {
    return 'Slette «$name»? Dette fjerner det også på serveren.';
  }

  @override
  String get connectionSection => 'Tilkobling';

  @override
  String get token => 'Token';

  @override
  String get advancedOptions => 'Avanserte alternativer';

  @override
  String get mealieApiVersion => 'Mealie API-versjon';

  @override
  String get sendOptionalHeaders => 'Send valgfrie headere';

  @override
  String get offlineRecipeImages => 'Lagre oppskriftsbilder uten nett';

  @override
  String get offlineRecipeImagesHint =>
      'Laster ned alle oppskriftsbilder til denne enheten, slik at de også vises uten tilkobling. Ved store samlinger kan dette ta opp flere hundre MB. Slår du det av, slettes de lagrede bildene.';

  @override
  String offlineRecipeImagesStatus(int count, int total, String size) {
    return 'Lagret: $count/$total · $size';
  }

  @override
  String get offlineRecipeImagesDisableConfirm =>
      'Slette alle lagrede oppskriftsbilder?';

  @override
  String headerNameLabel(int n) {
    return 'Header $n navn';
  }

  @override
  String headerValueLabel(int n) {
    return 'Header $n verdi';
  }

  @override
  String get value => 'Verdi';

  @override
  String get personalization => 'Tilpasning';

  @override
  String get showRecipeImagesSubtitle => 'Viser bilder i oppskriftslisten';

  @override
  String get exactQuantities => 'Legg til nøyaktige mengder';

  @override
  String get exactQuantitiesSubtitle =>
      'Ingredienser og innskrevne varer beholder mengde og enhet (f.eks. 200 g smør) i stedet for 1x per vare — manglende matvarer opprettes på serveren';

  @override
  String get remindToShop => 'Minn meg på å handle';

  @override
  String get remindToShopSubtitle =>
      'Varsler deg når du er i nærheten av et lagret sted og handlelisten har åpne varer — selv når appen er lukket';

  @override
  String get shoppingReminderAddLocation => 'Legg til sted';

  @override
  String get shoppingReminderMaxLocations => 'Maksimalt 3 steder er nådd';

  @override
  String get shoppingReminderLocationServiceDisabled =>
      'Posisjonstjenester er slått av på denne enheten';

  @override
  String get shoppingReminderPermissionTitle => 'Tilgang til posisjon trengs';

  @override
  String get shoppingReminderPermissionMessage =>
      'For å minne deg på det når du er i nærheten av en butikk, trengs posisjonstilgang «Alltid» — også når appen er lukket. Aktiver det i Innstillinger.';

  @override
  String get openSettings => 'Åpne Innstillinger';

  @override
  String get shoppingReminderLocationName => 'Navn';

  @override
  String get shoppingReminderUseCurrentLocation => 'Bruk nåværende posisjon';

  @override
  String get shoppingReminderOrAddress => 'eller skriv inn en adresse';

  @override
  String get shoppingReminderAddress => 'Adresse';

  @override
  String get shoppingReminderAddressPlaceholder => 'Gate, sted';

  @override
  String get shoppingReminderSearchAddress => 'Søk';

  @override
  String get shoppingReminderLocationFailed =>
      'Kunne ikke finne posisjonen din';

  @override
  String get shoppingReminderAddressNotFound => 'Fant ikke adressen';

  @override
  String get ratingFailed => 'Vurderingen kunne ikke lagres — prøv igjen.';

  @override
  String get lastCooked => 'Sist laget';

  @override
  String get syncLastCooked => 'Oppdater «sist laget»';

  @override
  String get syncLastCookedSubtitle =>
      'Lagrer dagens dato og en oppføring i tidslinjen — som i Mealie-webappen.';

  @override
  String get developer => 'Utvikler';

  @override
  String get enableLoggingSubtitle =>
      'Registrerer print-/feillogger (siste 500 linjer)';

  @override
  String get entriesLabel => 'Oppføringer';

  @override
  String get fileSize => 'Filstørrelse';

  @override
  String get showAction => 'Vis';

  @override
  String get copy => 'Kopier';

  @override
  String logsWithCount(int count) {
    return 'Logger ($count)';
  }

  @override
  String get noLogs => 'Ingen logger tilgjengelig';

  @override
  String get logsTitle => 'Logger';

  @override
  String get required => 'Påkrevd';

  @override
  String get connectionFailedCheck =>
      'Tilkoblingen mislyktes. Sjekk URL og token.';

  @override
  String get username => 'Brukernavn';

  @override
  String get password => 'Passord';

  @override
  String get setupPasswordHint =>
      'Passordet ditt lagres ikke — appen logger deg inn én gang og genererer et API-token ut fra det (samme som Profil → API-tokens i webappen).';

  @override
  String get loginAndConnect => 'Logg inn og koble til';

  @override
  String get loginInvalidCredentials => 'Brukernavnet eller passordet er feil.';

  @override
  String get loginAndGenerateToken => 'Logg inn og generer token';

  @override
  String get loggingIn => 'Logger inn…';

  @override
  String get apiTokenSaveHint =>
      'Token er brukt — trykk på «Lagre endringer» nedenfor.';

  @override
  String get renewApiToken => 'Forny API-token';

  @override
  String get setupAuthChoiceTitle => 'Hvordan vil du logge inn?';

  @override
  String get authModePasswordTitle => 'La appen lage en API-nøkkel for meg';

  @override
  String get authModePasswordSubtitle =>
      'Logg inn med brukernavn og passord — appen genererer et token automatisk.';

  @override
  String get authModeTokenTitle => 'Jeg har allerede en API-nøkkel';

  @override
  String get authModeTokenSubtitle =>
      'Kopiert fra Mealie-profilen (Profil → API-tokens).';

  @override
  String keyN(int n) {
    return 'Nøkkel $n';
  }

  @override
  String valueN(int n) {
    return 'Verdi $n';
  }

  @override
  String get openCookingMode => 'Åpne kokemodus';

  @override
  String activeRecipes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count aktive oppskrifter',
      one: '1 aktiv oppskrift',
    );
    return '$_temp0';
  }

  @override
  String get reparseIngredients => 'Tolk ingredienser på nytt';

  @override
  String get reparseIngredientsSubtitle =>
      'Del opp mengde/enhet/ingrediens (f.eks. «200 g mel»)';

  @override
  String get reparseDone =>
      'Ingrediensene er delt opp – trykk på «Lagre endringer» for å bruke dem';

  @override
  String get reparseNone => 'Fant ingen ingredienser som kan deles opp';

  @override
  String get tagsAndCategories => 'Emneord, kategorier og kjøkkenredskap';

  @override
  String get tapToAddPhoto => 'Trykk for å legge til bilde';

  @override
  String get descriptionLabel => 'Beskrivelse';

  @override
  String get searchingDevices => 'Søker etter enheter på samme Wi-Fi…';

  @override
  String get selectAll => 'Velg alle';

  @override
  String get importReminders => 'Importer påminnelser';

  @override
  String get importGoogleTasks => 'Importer Google Tasks';

  @override
  String get noTaskLists => 'Fant ingen oppgavelister';

  @override
  String get noReminderLists => 'Fant ingen påminnelseslister';

  @override
  String importCount(int count) {
    return 'Importer $count';
  }

  @override
  String get activeRecipeTimer => 'Aktiv oppskriftstimer';

  @override
  String get linkIngredients => 'Koble ingredienser';

  @override
  String get noIngredientsToLink => 'Ingen ingredienser å koble ennå';

  @override
  String get importLanguageSubtitle =>
      'Språk for oppskrifter importert fra bilde eller PDF';

  @override
  String get importLanguageSearch => 'Søk etter språk';

  @override
  String get importLanguageFollowApp => 'Samme som appspråket';

  @override
  String get importLanguageNoMatch => 'Fant ikke noe språk';

  @override
  String get setupImportLanguageTitle => 'KI-oppskriftsimport';

  @override
  String get setupImportLanguageBody =>
      'Bilder og PDF-er kan gjøres om til oppskrifter med KI. Velg språket de skal ende opp på — praktisk hvis morsmålet ditt ikke finnes som appspråk. Du kan endre dette senere i innstillingene.';

  @override
  String get setupImportLanguageSearchHint =>
      'Bruk søket i velgeren for å finne språk som appgrensesnittet ikke tilbyr.';

  @override
  String get setupCachingKeepOpenTitle => 'Hold appen åpen';

  @override
  String get setupCachingKeepOpenBody =>
      'Lastingen kjører i forgrunnen. La appen være åpen til den er ferdig — lukker du den eller bytter bort for lenge, stopper prosessen og starter på nytt senere.';

  @override
  String get supportContact => 'Kontakt brukerstøtte';

  @override
  String get supportDialogMessage =>
      'Beskriv problemet ditt, så tar vi kontakt. Loggen hjelper mye med feilsøkingen — du kan legge den ved som tekstfil.';

  @override
  String get supportWithoutLogs => 'Uten logg';

  @override
  String get supportWithLogs => 'Legg ved logg';

  @override
  String get supportMailSubject => 'Mealie Recipes — Brukerstøtte';

  @override
  String get supportMailHint => 'Beskriv problemet ditt her:';

  @override
  String get supportLogsEmpty =>
      'Loggen er tom. Slå på logging, gjenskap problemet og send den deretter.';

  @override
  String supportAddressCopied(String email) {
    return 'Adressen er kopiert: $email';
  }

  @override
  String supportNoMailApp(String email) {
    return 'Fant ingen e-postapp. Adressen er kopiert: $email';
  }

  @override
  String get createRecipeFromImages => 'Opprett oppskrift';

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
      'Det første bildet blir oppskriftens hovedbilde. Trykk og hold på en side for å endre rekkefølgen.';

  @override
  String get mainImageBadge => 'Hoved';

  @override
  String maxImagesReached(int max) {
    return 'Du kan legge til opptil $max bilder per oppskrift.';
  }

  @override
  String get removePage => 'Fjern side';

  @override
  String get preparingPdf => 'Behandler PDF...';

  @override
  String get shareRecipeTitle => 'Del oppskrift';

  @override
  String get recipeOptionsTitle => 'Alternativer';

  @override
  String get exportAsPdf => 'Eksporter som PDF';

  @override
  String get generatingPdf => 'Genererer PDF…';

  @override
  String get pdfExportFailed => 'PDF-eksporten mislyktes';

  @override
  String get recipeTime => 'Tid';

  @override
  String get ingredientSectionTitle => 'Seksjon';

  @override
  String get addIngredientSection => 'Legg til seksjon';

  @override
  String get aiImportToggle => 'Analyser med KI';

  @override
  String get aiImportToggleHint =>
      'Også for oppskriftsvideoer (YouTube, Instagram, TikTok …) og sider den vanlige importen ikke kan lese. Krever en KI-leverandør på Mealie-serveren din – for videoer også en lydleverandør.';

  @override
  String get aiImportButton => 'Importer med KI';

  @override
  String get aiImportRunning =>
      'KI-en analyserer lenken … for videoer kan det ta noen minutter.';

  @override
  String get aiImportFailed =>
      'KI-importen mislyktes. Sjekk KI-innstillingene på Mealie-serveren din.';

  @override
  String get stepHeadingLabel => 'Overskrift for steget (valgfritt)';

  @override
  String get linkedRecipeLabel => 'Lenket oppskrift';

  @override
  String get toolsTitle => 'Kjøkkenredskap';

  @override
  String get prepareTools => 'Gjør klar følgende kjøkkenredskap';

  @override
  String get newTool => 'Nytt kjøkkenredskap';

  @override
  String get renameAction => 'Gi nytt navn';

  @override
  String get organizerEmpty =>
      'Ingen oppføringer ennå. Trykk på «+» øverst til høyre for å opprette en.';

  @override
  String organizerRecipeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count oppskrifter',
      one: '1 oppskrift',
      zero: 'Ingen oppskrifter',
    );
    return '$_temp0';
  }

  @override
  String get toolOnHand => 'Tilgjengelig';

  @override
  String get mealDiceSettingsTitle => 'Terningfilter';

  @override
  String get mealDiceSettingsHint =>
      'Velg kategorier og emneord for hvert måltid. Terningen foreslår da bare oppskrifter som har minst ett av dem. Det samme valget kan brukes for flere måltider.';

  @override
  String get mealDiceSettingsNoneHint =>
      'Ingenting er valgt for dette måltidet: terningen velger automatisk etter kategorier som «Frokost», «Lunsj» eller «Middag».';

  @override
  String get mealDiceAutoHintTitle => 'Automatisk valg';

  @override
  String get mealDiceAutoHintBody =>
      'Det er ennå ikke satt kategorier eller emneord for dette måltidet. Terningen ser derfor etter kategorier som «Frokost», «Lunsj» eller «Middag» og fyller opp med andre oppskrifter.\n\nEget valg: trykk på tannhjulet ved siden av «+» i måltidsplanen.';

  @override
  String get dontShowAgain => 'Ikke vis igjen';

  @override
  String get mealDiceNoMatches =>
      'Ingen oppskrift passer til kategoriene og emneordene som er valgt for dette måltidet.';

  @override
  String mealDiceFewMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bare $count passende oppskrifter',
      one: 'Bare 1 passende oppskrift',
    );
    return '$_temp0';
  }

  @override
  String get commentsTitle => 'Kommentarer';

  @override
  String get commentHint => 'Skriv en kommentar…';

  @override
  String get commentSaveFailed => 'Kommentaren kunne ikke lagres.';

  @override
  String get commentDeleteConfirm => 'Slette denne kommentaren?';

  @override
  String get cookingDoneCommentLabel => 'Kommentar (valgfritt)';

  @override
  String get cookingDoneCommentHint => 'Hvordan ble det? Tips til neste gang…';

  @override
  String get nutritionTitle => 'Næringsinnhold';

  @override
  String get nutritionPerServing => 'per porsjon';

  @override
  String get nutritionCalories => 'Kalorier';

  @override
  String get nutritionFat => 'Fett';

  @override
  String get nutritionSaturatedFat => 'Mettet fett';

  @override
  String get nutritionTransFat => 'Transfett';

  @override
  String get nutritionUnsaturatedFat => 'Umettet fett';

  @override
  String get nutritionCholesterol => 'Kolesterol';

  @override
  String get nutritionSodium => 'Natrium';

  @override
  String get nutritionCarbohydrates => 'Karbohydrater';

  @override
  String get nutritionFiber => 'Kostfiber';

  @override
  String get nutritionSugar => 'Sukker';

  @override
  String get nutritionProtein => 'Protein';

  @override
  String get timelineTitle => 'Tidslinje';

  @override
  String get timelineMadeThis => 'Jeg har laget dette';

  @override
  String timelineUserMadeThis(String name) {
    return '$name har laget dette';
  }

  @override
  String get timelineEmpty => 'Ingen oppføringer i tidslinjen ennå.';

  @override
  String get timelineDate => 'Dato';

  @override
  String get timelineNoteHint => 'Notat (valgfritt)';

  @override
  String get timelineAddPhoto => 'Legg til bilde';

  @override
  String get timelineRemovePhoto => 'Fjern bilde';

  @override
  String get timelineSaved => 'Lagt til i tidslinjen';

  @override
  String get timelineSaveFailed => 'Kunne ikke legge til i tidslinjen';

  @override
  String get timelineImageFailed =>
      'Oppføringen er lagret, men bildet kunne ikke lastes opp';

  @override
  String get timelineDeleteConfirm =>
      'Slette denne oppføringen fra tidslinjen?';

  @override
  String get timelineEditNote => 'Rediger notat';

  @override
  String get timelineUnknownRecipe => 'Fant ikke oppskriften';

  @override
  String get cookingDonePhotoHint => 'Bilde til Mealie-tidslinjen (valgfritt)';

  @override
  String get assetsTitle => 'Vedlegg';

  @override
  String get assetsAdd => 'Legg til vedlegg';

  @override
  String get assetsChooseFile => 'Fil';

  @override
  String get assetsUploading => 'Laster opp …';

  @override
  String get assetsUploadFailed => 'Vedlegget kunne ikke lastes opp';

  @override
  String assetsDeleteConfirm(String name) {
    return 'Fjerne «$name» fra vedleggene?';
  }

  @override
  String get assetsOpenFailed => 'Vedlegget kunne ikke åpnes';

  @override
  String get assetsUnsupported =>
      'Mealie støtter bare PDF, bilder, TXT, MD, CSV og JSON.';

  @override
  String get assetsShare => 'Del';

  @override
  String get mealRulesTitle => 'Mealie-regler';

  @override
  String get mealRulesHint =>
      'Brukes også i Mealie-nettappen. Gjelder flere regler for dagen og måltidet, må alle være oppfylt. Gjelder ingen regel, velger terningen blant alle oppskrifter.';

  @override
  String get mealRuleAdd => 'Legg til regel';

  @override
  String get mealRuleNewTitle => 'Ny regel';

  @override
  String get mealRuleEditTitle => 'Rediger regel';

  @override
  String get mealRuleDay => 'Dag';

  @override
  String get mealRuleAnyDay => 'Alle dager';

  @override
  String get mealRuleMealType => 'Måltid';

  @override
  String get mealRuleAnyMeal => 'Alle måltider';

  @override
  String get mealRuleConditionsTitle => 'Betingelser';

  @override
  String get mealRuleAllRecipes => 'Alle oppskrifter';

  @override
  String get mealRuleDeleteConfirm => 'Slette denne regelen?';

  @override
  String get mealRulesOffline =>
      'Mealie-reglene er ikke tilgjengelige nå – terningen bruker appens utvalg.';

  @override
  String get mealRulesNoMatches =>
      'Ingen oppskrifter oppfyller Mealie-reglene for dette måltidet.';

  @override
  String get mealTypeSide => 'Tilbehør';

  @override
  String get mealTypeSnack => 'Snacks';

  @override
  String get mealTypeDrink => 'Drikke';

  @override
  String get mealTypeDessert => 'Dessert';

  @override
  String get foodsTitle => 'Matvarer';

  @override
  String get unitsTitle => 'Enheter';

  @override
  String get newFood => 'Ny matvare';

  @override
  String get newUnit => 'Ny enhet';

  @override
  String get editFood => 'Rediger matvare';

  @override
  String get editUnit => 'Rediger enhet';

  @override
  String get pluralNameLabel => 'Flertallsnavn';

  @override
  String get abbreviationLabel => 'Forkortelse';

  @override
  String get pluralAbbreviationLabel => 'Forkortelse (flertall)';

  @override
  String get mergeAction => 'Slå sammen';

  @override
  String mergeIntoTitle(String name) {
    return 'Slå sammen «$name» med …';
  }

  @override
  String mergeConfirm(String from, String to) {
    return '«$from» slås sammen med «$to»: Alle oppskrifter og handlelister bruker deretter «$to», og «$from» slettes.';
  }

  @override
  String get mergeFailed => 'Sammenslåingen mislyktes';

  @override
  String foodUnitDeleteConfirm(String name) {
    return 'Slette «$name»? Ingredienser som bruker den, mister koblingen.';
  }

  @override
  String get foodsUnitsEmpty => 'Ingen oppføringer ennå.';

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
  String get mealDiceModeTitle => 'Terningen bruker';

  @override
  String get mealDiceModeApp => 'Appens utvalg';

  @override
  String get switchListTitle => 'Bytt liste';

  @override
  String get newShoppingList => 'Ny handleliste';

  @override
  String shoppingListDeleteConfirm(String name) {
    return 'Slette «$name»? Alle varer i den slettes også.';
  }

  @override
  String get labelOrderTitle => 'Sorter etiketter';

  @override
  String get labelOrderHint =>
      'Dra for å sortere. Gjelder denne listen – også i Mealie-nettappen.';

  @override
  String get labelOrderEmpty => 'Denne listen har ingen etiketter ennå.';

  @override
  String get useAsActiveList => 'Bruk som aktiv liste';

  @override
  String get activeListBadge => 'Aktiv';

  @override
  String get foodLabelLabel => 'Etikett';

  @override
  String get foodNoLabel => 'Ingen etikett';

  @override
  String get aliasesLabel => 'Alias';

  @override
  String get aliasAddHint => 'Legg til alias';

  @override
  String get foodOnHand => 'På lager i husholdningen';

  @override
  String get timelineChildRecipesTitle =>
      'Legg også til for koblede oppskrifter';

  @override
  String timelineMadeForRecipe(String recipe) {
    return 'Laget til $recipe';
  }

  @override
  String get timelineFilter => 'Filtrer oppføringer';

  @override
  String get timelineTypeComment => 'Laget og notater';

  @override
  String get timelineTypeInfo => 'Info';

  @override
  String get timelineTypeSystem => 'System';

  @override
  String get listManagementTitle => 'Handlelister';

  @override
  String get managementTitle => 'Mer';

  @override
  String get pinToHome => 'Legg til på startskjermen';

  @override
  String get unpinFromHome => 'Fjern fra startskjermen';

  @override
  String homeScreenFull(int count) {
    return 'Startskjermen er full – maks $count fliser. Fjern først en annen flis under «Mer».';
  }

  @override
  String get selectAction => 'Velg';

  @override
  String selectedCount(int count) {
    return '$count valgt';
  }

  @override
  String get assignLabelAction => 'Tilordne etikett';

  @override
  String get assignLabelOverwriteHint =>
      'Overskriver etiketten for alle valgte matvarer.';

  @override
  String deleteSelectedConfirm(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Slette $count oppføringer?',
      one: 'Slette 1 oppføring?',
    );
    return '$_temp0';
  }

  @override
  String get seedDataAction => 'Last inn standarddata';

  @override
  String get seedFoodsHint =>
      'Oppretter Mealies standard matvarer på valgt språk.';

  @override
  String get seedUnitsHint =>
      'Oppretter Mealies standardenheter på valgt språk.';

  @override
  String get seedLanguageLabel => 'Språk';

  @override
  String get seedDuplicateWarning =>
      'Du har allerede oppføringer. Mealie avstemmer ikke duplikater – du må slå dem sammen selv etterpå.';

  @override
  String get seedDone => 'Standarddata opprettet';

  @override
  String get seedFailed => 'Standarddata kunne ikke lastes inn';

  @override
  String get exportAction => 'Eksporter';

  @override
  String get substitutionsLabel => 'Erstatninger';

  @override
  String get substitutionAddHint => 'Legg til erstatning';

  @override
  String get substitutionFoodLabel => 'Matvare (valgfritt)';

  @override
  String get substitutionNoteLabel => 'Notat (valgfritt)';

  @override
  String get substitutionNeedOne => 'Oppgi en matvare eller et notat';

  @override
  String get useAbbreviationLabel => 'Bruk forkortelse';

  @override
  String get useAbbreviationHint => 'Vis «g» i stedet for «gram» i oppskrifter';

  @override
  String get fractionLabel => 'Vis som brøk';

  @override
  String get fractionHint => '½ i stedet for 0,5';

  @override
  String get standardizationTitle => 'Standardisering';

  @override
  String get standardizationHint =>
      'For omregning: 1 av denne enheten tilsvarer … (f.eks. 1 ss = 15 milliliter).';

  @override
  String get standardQuantityLabel => 'Standard antall';

  @override
  String get standardUnitLabel => 'Standardenhet';

  @override
  String get standardUnitNone => 'Ingen';

  @override
  String get stdFluidOunce => 'Væskeunse (fl oz)';

  @override
  String get stdCup => 'Kopp (US)';

  @override
  String get stdOunce => 'Unse (oz)';

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
  String get newLabel => 'Ny etikett';

  @override
  String get editLabel => 'Rediger etikett';

  @override
  String get colorLabel => 'Farge';

  @override
  String labelDeleteConfirm(String name) {
    return 'Slette «$name»? Varer og matvarer mister denne etiketten.';
  }

  @override
  String get importMenuAction => 'Importer';

  @override
  String get archivedEmpty =>
      'Ingen arkiverte innkjøp ennå. Trykk «Fullfør handlingen» etter handlingen – de avkryssede varene havner her.';

  @override
  String get sectionTitleLabel => 'Seksjonstittel';

  @override
  String get clearSection => 'Fjern seksjon';

  @override
  String get noPermissionGeneric =>
      'Du har ikke rettigheter til dette i Mealie. Spør en administrator eller husholdningsansvarlig.';

  @override
  String get noPermissionEditRecipe =>
      'Du kan ikke redigere denne oppskriften – den er låst eller tilhører en annen husholdning. Bare den som opprettet den eller en administrator kan.';

  @override
  String get noPermissionDeleteRecipe =>
      'Bare den som opprettet oppskriften eller en administrator kan slette den.';

  @override
  String get noPermissionDemoteSelf =>
      'Du kan ikke fjerne dine egne administratorrettigheter.';

  @override
  String get recipeLockedHint =>
      'Låst – bare den som opprettet den kan redigere';

  @override
  String get recipeDeleteOwnerOnlyHint =>
      'Bare oppretteren eller en administrator kan slette';

  @override
  String get organizeReadOnlyHint =>
      'Bare visning: å opprette, endre og slette krever rettigheten «Bruker kan administrere matvarer, emneord og kategorier».';

  @override
  String get notesNotSavedNoPermission =>
      'Notatet ble ikke lagret – du har ikke rett til å redigere denne oppskriften.';

  @override
  String get userManagementTitle => 'Brukeradministrasjon';

  @override
  String get usersTitle => 'Brukere';

  @override
  String get editUserTitle => 'Rediger bruker';

  @override
  String get fullNameLabel => 'Fullt navn';

  @override
  String get usernameLabel => 'Brukernavn';

  @override
  String get emailLabel => 'E-post';

  @override
  String get passwordLabel => 'Passord';

  @override
  String get householdLabel => 'Husholdning';

  @override
  String get permissionsTitle => 'Rettigheter';

  @override
  String get administratorLabel => 'Administrator';

  @override
  String get permCanInvite => 'Bruker kan invitere andre til gruppe';

  @override
  String get permCanManage => 'Bruker kan administrere gruppeinnstillinger';

  @override
  String get permCanManageHousehold => 'Bruker kan administrere husholdningen';

  @override
  String get permCanOrganize =>
      'Bruker kan administrere matvarer, emneord og kategorier';

  @override
  String get advancedFeaturesLabel => 'Aktiver avanserte funksjoner';

  @override
  String get passwordResetLinkAction =>
      'Generer lenke for tilbakestilling av passord';

  @override
  String get resetLockedUsersAction => 'Tilbakestill låste brukere';

  @override
  String get membersTitle => 'Medlemmer';

  @override
  String get inviteLinkTitle => 'Invitasjonslenke';

  @override
  String get inviteAction => 'Inviter';

  @override
  String get userUpdated => 'Bruker oppdatert';

  @override
  String get createUserTitle => 'Opprett bruker';

  @override
  String get userCreated => 'Bruker opprettet';

  @override
  String userDeleteConfirm(String name) {
    return 'Slette «$name»? Kontoen fjernes fra Mealie.';
  }

  @override
  String get passwordResetLinkCopied =>
      'Lenke kopiert – gi den videre til brukeren. Den er bare gyldig en begrenset tid.';

  @override
  String lockedUsersReset(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count brukere låst opp',
      one: '1 bruker låst opp',
      zero: 'Ingen låste brukere',
    );
    return '$_temp0';
  }

  @override
  String get inviteUsesLabel => 'Antall bruk';

  @override
  String get inviteCreated => 'Invitasjonslenke opprettet';

  @override
  String get inviteEmailHint =>
      'E-postadresse (valgfritt – Mealie sender invitasjonen)';

  @override
  String get inviteEmailSent => 'Invitasjon sendt på e-post';

  @override
  String get inviteEmailFailed =>
      'E-posten kunne ikke sendes (er SMTP satt opp i Mealie?). Lenken fungerer likevel.';

  @override
  String get copyLinkAction => 'Kopier lenke';

  @override
  String get youLabel => 'Deg';

  @override
  String get membersPermissionsHint =>
      'Du kan endre rettighetene til medlemmene i husholdningen din – men ikke dine egne.';

  @override
  String get householdManagementTitle => 'Administrering av husholdninger';

  @override
  String get householdsTitle => 'Husholdninger';

  @override
  String get createHouseholdTitle => 'Opprett husholdning';

  @override
  String get householdNameLabel => 'Husholdningens navn';

  @override
  String get householdPreferencesTitle => 'Innstillinger for husholdning';

  @override
  String get privateHouseholdLabel => 'Privat husholdning';

  @override
  String get privateHouseholdHint =>
      'Når du setter husholdningen din til privat, vil alle offentlige visningsalternativer tilbakestilles til standardverdiene. Dette overskriver envher individuell offentlig visningsinnstilling';

  @override
  String get lockRecipeEditsLabel =>
      'Lås redigering av oppskrifter fra andre husholdninger';

  @override
  String get lockRecipeEditsHint =>
      'Når dette er aktivert kan bare brukere i husholdningen din redigere oppskrifter laget av husholdningen din';

  @override
  String get householdRecipePreferencesTitle =>
      'Husholdningenes oppskriftsinnstillinger';

  @override
  String get groupsTitle => 'Grupper';

  @override
  String get groupLabel => 'Gruppe';

  @override
  String get createGroupTitle => 'Opprett gruppe';

  @override
  String get groupNameLabel => 'Gruppenavn';

  @override
  String get groupPreferencesTitle => 'Gruppeinnstillinger';

  @override
  String get privateGroupLabel => 'Privat gruppe';

  @override
  String get privateGroupHint =>
      'Å sette husholdningen din til privat vil deaktivere alle alternativer for offentlig visning. Denne innstillingen overstyrer individuelle innstillinger for offentlig visning';

  @override
  String get firstDayOfWeekLabel => 'Første dag i uken';

  @override
  String get showAnnouncementsLabel => 'Vis kunngjøringer fra Mealie';

  @override
  String get recipePublicDefaultLabel =>
      'Tillat brukere utenfor gruppen å se oppskriftene dine';

  @override
  String get recipeShowNutritionDefaultLabel => 'Vis ernæringsinformasjon';

  @override
  String get recipeShowAssetsDefaultLabel => 'Vis oppskriftsressurser';

  @override
  String get recipeLandscapeDefaultLabel =>
      'Sett landskapsvisning som standard';

  @override
  String get recipeDisableCommentsDefaultLabel =>
      'Deaktiver muligheten for at brukere kan kommentere på oppskrifter';

  @override
  String get myHouseholdSection => 'Min husholdning';

  @override
  String get myGroupSection => 'Min gruppe';

  @override
  String get preferencesSaved => 'Innstillinger lagret';

  @override
  String get cannotDeleteWithUsers =>
      'Har fortsatt brukere – flytt eller slett dem først i brukeradministrasjonen.';

  @override
  String deleteHouseholdConfirm(String name) {
    return 'Slette husholdningen «$name»?';
  }

  @override
  String deleteGroupConfirm(String name) {
    return 'Slette gruppen «$name»?';
  }

  @override
  String usersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count brukere',
      one: '1 bruker',
      zero: 'Ingen brukere',
    );
    return '$_temp0';
  }

  @override
  String get originalUrlLabel => 'Nettadresse til oppskrift';

  @override
  String get copyTextAction => 'Kopier tekst';

  @override
  String get copiedToClipboard => 'Kopiert til utklippstavlen';

  @override
  String get changelogEnglishHint =>
      'Nyhetene finnes bare på engelsk – med «Kopier tekst» kan du lime dem inn i for eksempel en oversetter.';

  @override
  String get favoritesTitle => 'Favoritter';

  @override
  String get favoritesEmpty =>
      'Ingen favoritter ennå. Trykk på hjertet i en oppskrift for å samle den her.';

  @override
  String get changelogTitle => 'Changelog';

  @override
  String get changeProfileImage => 'Endre profilbilde';

  @override
  String get profileImageUpdated => 'Profilbilde oppdatert';

  @override
  String get profileImageFailed => 'Profilbildet kunne ikke lastes opp';

  @override
  String get myAccountTitle => 'Min konto';

  @override
  String get ownAccountHint =>
      'Her kan du redigere din egen konto. Andre brukere administreres av administratorer og medlemmer med «administrer»-tillatelsen.';

  @override
  String get changePasswordAction => 'Endre passord';

  @override
  String get currentPasswordLabel => 'Nåværende passord';

  @override
  String get newPasswordLabel => 'Nytt passord';

  @override
  String get confirmPasswordLabel => 'Bekreft passord';

  @override
  String get passwordTooShort => 'Minst 8 tegn';

  @override
  String get passwordsDoNotMatch => 'Passordene samsvarer ikke';

  @override
  String get passwordUpdated => 'Passord oppdatert';

  @override
  String get passwordChangeFailed => 'Passordet kunne ikke endres';

  @override
  String passwordManagedExternally(String method) {
    return 'Du logger inn via $method — endre passordet ditt der.';
  }

  @override
  String get bulkAddHint => 'Én linje per oppføring.';

  @override
  String bulkAddCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Legg til $count oppføringer',
      one: 'Legg til 1 oppføring',
    );
    return '$_temp0';
  }

  @override
  String get linkRecipeAction => 'Koble til oppskrift';

  @override
  String get useFoodAction => 'Bruk matvare i stedet for oppskrift';

  @override
  String get addSubstitutionsAction => 'Legg til erstatninger';

  @override
  String get clearSubstitutionsAction => 'Fjern erstatninger';

  @override
  String get recipeSubstitutionsTitle => 'Erstatninger';

  @override
  String get substitutionUnknownFood =>
      'Kun eksisterende matvarer – bruk ellers notatet';

  @override
  String get insertAboveAction => 'Sett inn over';

  @override
  String get insertBelowAction => 'Sett inn under';

  @override
  String get moveToTopAction => 'Flytt til toppen';

  @override
  String get moveToBottomAction => 'Flytt til bunnen';

  @override
  String get linkReferencesAction => 'Koble referanser';

  @override
  String get editMarkdownAction => 'Rediger Markdown';

  @override
  String get previewMarkdownAction => 'Forhåndsvis Markdown';

  @override
  String get insertStepImageAction => 'Last opp bilde';

  @override
  String get mergeAboveAction => 'Slå sammen med steget over';

  @override
  String get linkedToOtherStep => 'Tilknyttet et annet steg';

  @override
  String get noNotesToLink => 'Ingen notater å koble';

  @override
  String get ownerLabel => 'Eier';

  @override
  String get ingredientParserTitle => 'Ingrediens-analyserer';

  @override
  String ingredientParserHint(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count ingredienser er ikke strukturert ennå. Velg analyse, sjekk resultatet, bruk det.',
      one:
          '1 ingrediens er ikke strukturert ennå. Velg analyse, sjekk resultatet, bruk det.',
    );
    return '$_temp0';
  }

  @override
  String get parserNlp => 'Prosessor for naturlig språk';

  @override
  String get parserBrute => 'Enkel analyse';

  @override
  String get parserOpenai => 'OpenAI-analyse';

  @override
  String get parserApp => 'Frakoblet (app)';

  @override
  String get parseFailed => 'Analysen mislyktes';

  @override
  String get parseAction => 'Analyser';

  @override
  String applyParsedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bruk $count ingredienser',
      one: 'Bruk 1 ingrediens',
      zero: 'Ingenting valgt',
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
  String get timeExtraHint => 'Tillegg, f.eks. «pluss over natten»';

  @override
  String get yieldLabel => 'Gir';

  @override
  String get yieldTextLabel => 'Porsjonsenhet';

  @override
  String get prepTimeLabel => 'Forberedelsestid';

  @override
  String get performTimeLabel => 'Passiv tid';

  @override
  String get totalTimeLabel => 'Total tid';

  @override
  String get settingPublicRecipe => 'Offentlig oppskrift';

  @override
  String get settingShowNutrition => 'Vis ernæringsverdier';

  @override
  String get settingShowAssets => 'Vis ressurser';

  @override
  String get settingLandscapeView => 'Landskapsvisning';

  @override
  String get settingDisableComments => 'Deaktiver kommentarer';

  @override
  String get settingDisableAmount => 'Deaktiver ingrediensmengder';

  @override
  String get settingLocked => 'Låst';

  @override
  String get settingLockedOwnerOnly =>
      'Bare den som opprettet oppskriften kan låse eller låse den opp.';

  @override
  String get apiExtrasTitle => 'API-tillegg';

  @override
  String get apiExtrasHint =>
      'Egendefinerte nøkkel/verdi-par for tredjepartsapper, f.eks. for å utløse automatiseringer.';

  @override
  String get extraKeyLabel => 'Nøkkel';

  @override
  String get extraValueLabel => 'Verdi';

  @override
  String get addExtraAction => 'Legg til tillegg';

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
      one: '1 minutt',
    );
    return '$_temp0';
  }

  @override
  String get discardChangesConfirm => 'Forkaste endringer som ikke er lagret?';

  @override
  String get discardChanges => 'Forkast endringer';

  @override
  String get imageFromUrl => 'Bilde fra URL';

  @override
  String get deleteRecipeImage => 'Slett oppskriftsbilde';

  @override
  String get deleteRecipeImageConfirm =>
      'Er du sikker på at du vil slette dette oppskriftsbildet?';

  @override
  String get bulkAddIngredients => 'Legg til flere ingredienser';

  @override
  String get bulkAddSteps => 'Legg til flere steg';

  @override
  String get stepImageFailed => 'Bildet kunne ikke lastes opp';

  @override
  String get servingsAndTimes => 'Porsjoner og tider';

  @override
  String get recipeSettingsTitle => 'Oppskriftsinnstillinger';

  @override
  String get jsonEditorTitle => 'JSON-editor';

  @override
  String get jsonInvalid => 'Ugyldig JSON – sjekk det.';

  @override
  String get editorOfflineHint =>
      'Åpnet frakoblet: lagring krever tilkobling. Nyere Mealie-felt (f.eks. erstatninger) beholdes uendret.';

  @override
  String get parseLineFailed => 'Ikke gjenkjent – forblir uendret';

  @override
  String get createManualTitle => 'Opprett oppskrift manuelt';

  @override
  String get createManualHint =>
      'Skriv inn et navn – legg deretter til ingredienser, steg, bilde og alt annet i oppskriftsredigeringen.';

  @override
  String get createManualButton => 'Opprett og rediger';

  @override
  String get changelogEmpty => 'Ingen oppføringer for denne versjonen ennå.';

  @override
  String get finderDescription =>
      'Søk etter oppskrifter basert på ingredienser du har for hånden. Du kan også filtrere på verktøy du har tilgjengelig, og angi maksimalt antall manglende ingredienser eller verktøy.';

  @override
  String get finderSelectedIngredients => 'Valgte ingredienser';

  @override
  String get finderNoIngredientsSelected => 'Ingen ingredienser valgt';

  @override
  String get finderMissing => 'Mangler';

  @override
  String get finderNoRecipesFound => 'Ingen oppskrifter funnet';

  @override
  String get finderNoRecipesFoundDescription =>
      'Prøv å legge til flere ingredienser i søket eller juster filtrene dine';

  @override
  String get finderIncludeFoodsOnHand =>
      'Inkluder ingredienser du har for hånden';

  @override
  String get finderIncludeToolsOnHand => 'Inkluder tilgjengelige verktøy';

  @override
  String get finderIncludeSubstitutions => 'Inkluder erstatninger';

  @override
  String get finderSubstituting => 'Erstatter';

  @override
  String finderSubstituteForFood(String substitute, String food) {
    return '$substitute i stedet for $food';
  }

  @override
  String get finderMaxMissingIngredients =>
      'Maks antall manglende ingredienser';

  @override
  String get finderMaxMissingTools => 'Maks antall manglende redskaper';

  @override
  String get finderSelectedTools => 'Valgte redskaper';

  @override
  String get finderReadyToMake => 'Klar til å lages';

  @override
  String get finderAlmostReadyToMake => 'Nesten klar til å lages';

  @override
  String get finderSettings => 'Innstillinger';

  @override
  String get finderLoadingRecipes => 'Laster oppskrifter';

  @override
  String get finderClearSelection => 'Tøm valg';

  @override
  String get finderOfflineHint =>
      'Ingen forbindelse til serveren – resultatene kommer fra oppskriftene som er lagret på denne enheten.';

  @override
  String addIngredientsSkippedOnHand(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Lagt til i handlelisten – $count ingredienser du har på lager ble hoppet over.',
      one:
          'Lagt til i handlelisten – 1 ingrediens du har på lager ble hoppet over.',
    );
    return '$_temp0';
  }

  @override
  String get sendPeerOfflineHint =>
      'Ikke tilgjengelig nå – kommer frem når appen åpnes der';

  @override
  String sendDeliveredLater(String device) {
    return '«$device» er ikke tilgjengelig nå. Oppskriften kommer frem så snart appen åpnes der.';
  }

  @override
  String get sendQueuedOffline =>
      'Ingen forbindelse nå. Oppskriften sendes automatisk så snart du er på nett igjen.';

  @override
  String get searchHasAll => 'Har alle';

  @override
  String get searchHasAny => 'Har enhver';

  @override
  String get recipeFilterTitle => 'Filter';

  @override
  String get finderOtherFilters => 'Andre filtre';

  @override
  String get qfOpEquals => 'er lik';

  @override
  String get qfOpNotEquals => 'er ikke lik';

  @override
  String get qfOpGreater => 'er større enn';

  @override
  String get qfOpGreaterEq => 'er større enn eller lik';

  @override
  String get qfOpLess => 'er mindre enn';

  @override
  String get qfOpLessEq => 'er mindre enn eller lik';

  @override
  String get qfOpNewerThan => 'er nyere enn';

  @override
  String get qfOpOlderThan => 'er eldre enn';

  @override
  String qfDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dager siden',
      one: '1 dag siden',
    );
    return '$_temp0';
  }

  @override
  String get filterResetAll => 'Tilbakestill alle filtre';

  @override
  String get filterAny => 'Alle';

  @override
  String get filterOfflineIgnored =>
      'Uten nett kan «Andre filtre» bare brukes i enkel form.';

  @override
  String linkedRecipesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tilknyttede oppskrifter',
      one: 'En tilknyttet oppskrift',
      zero: 'Ingen tilknyttede oppskrifter',
    );
    return '$_temp0';
  }

  @override
  String get shoppingReminderNotificationsOff =>
      'Varsler er slått av for Mealie Recipes — uten dem kan handlepåminnelsen ikke vises. Tillat varsler i innstillingene.';

  @override
  String get shoppingReminderInactiveHint =>
      'Handlepåminnelsen kan ikke virke nå: sett posisjonstilgang til «Alltid» og tillat varsler.';

  @override
  String get bulkImportTitle => 'Importer flere nettadresser';

  @override
  String get bulkImportDescription =>
      'Masseimport av oppskrifter lar deg importere flere oppskrifter samtidig ved å sette opp nettstedene i kø på serveren og kjøre oppgaven i bakgrunnen. Dette kan være nyttig når du først migrerer til Mealie, eller når du ønsker å importere et stort antall oppskrifter.';

  @override
  String get bulkAddTitle => 'Legg til flere';

  @override
  String get bulkImportSetOrganizers => 'Angi kategorier og emneord';

  @override
  String get bulkImportStarted => 'Masseimport har startet';

  @override
  String get bulkImportFailed => 'Masseimport mislyktes';

  @override
  String get bulkImportReports => 'Masseimport';

  @override
  String get bulkImportUrlHint => 'Nettadresse til oppskrift';

  @override
  String get migrationsTitle => 'Dataoverføringer';

  @override
  String get migrationsDescription =>
      'Oppskrifter kan migreres fra et annet støttet program til Mealie. Dette er en flott måte å komme i gang med Mealie. Flytting av data mellom Mealie instanser, eller gjenoppretting av en tidligere Mealie sikkerhetskopiering, utføres med sikkerhetskopien og gjenopprettingsverktøy i stedet.';

  @override
  String get migrationNew => 'Ny overføring';

  @override
  String get migrationChooseType => 'Velg type overføring';

  @override
  String get noFileSelected => 'Ingen fil valgt';

  @override
  String migrationTagAll(String tag) {
    return 'Merk alle oppskrifter med emneordet $tag';
  }

  @override
  String get migrationPrevious => 'Tidligere overføringer';

  @override
  String get migrationMealieDescription =>
      'Mealie kan importere oppskrifter fra utgaver av Mealie før v1.0. Eksporter oppskriftene fra den gamle utgaven, og last opp zip-filen under. Merk at bare oppskrifter kan importeres fra eksporten. Dette gjelder bare utgaver som er eldre enn v1.0. En sikkerhetskopi av Mealie v1.0 eller senere bør gjenopprettes med sikkerhetskopien og gjenopprettingsverktøyene.';

  @override
  String get migrationChowdownDescription =>
      'Mealie støtter Chowdown-arkivformatet. Last ned kodearkivet som en .zip-fil og last den opp nedenfor.';

  @override
  String get migrationCopyMeThatDescription =>
      'Mealie kan importere oppskrifter fra Copy Me That. Eksporter oppskrifter i HTML-format, last deretter opp .zip-filen under.';

  @override
  String get migrationMyRecipeBoxDescription =>
      'Mealie kan importere oppskrifter fra My Recipe Box. Eksporter oppskrifter i CSV-format, og last deretter opp .csv-filen nedenfor.';

  @override
  String get migrationNextcloudDescription =>
      'Oppskrifter fra Nextcloud kan importeres fra en zip-fil som inneholder dataene lagret i Nextcloud. Se eksempelet på mappestrukture nedenfor for å sikre at oppskriftene kan importeres.';

  @override
  String get migrationPaprikaDescription =>
      'Mealie kan importere oppskrifter fra Paprika. Eksporter oppskriftene fra Paprika, endre filnavnutvidelsen til .zip og last den opp nedenfor.';

  @override
  String get migrationPlanToEatDescription =>
      'Mealie kan importere oppskrifter fra Plan to Eat.';

  @override
  String get migrationRecipeKeeperDescription =>
      'Meali kan importere oppskrifter fra Recipe Keeper. Eksporter oppskrifter i zip-format, og last deretter opp .zip-filen nedenfor.';

  @override
  String get migrationTandoorDescription =>
      'Mealie kan importere oppskrifter fra Tandoor. Eksporter dataene i \"Standard\"-formatet, last deretter opp zip-filen nedenfor.';

  @override
  String get migrationCooknDescription =>
      'Mealie kan importere oppskrifter fra DVO Cook\'n X3. Eksporter en cookbook eller meny i \"Cook\'n\" formatet, endre navnet på eksporten til .zip, og last så opp .zip-filen nedenfor.';

  @override
  String get reportTitle => 'Rapport';

  @override
  String get recipeDataTitle => 'Oppskriftsdata';

  @override
  String get recipeDataDescription =>
      'Bruk denne delen til å administrere dataene knyttet til oppskriftene dine. Du kan utføre flere massehandlinger på oppskriftene dine, inkludert eksportering, sletting, merking og tildeling av kategorier.';

  @override
  String get recipeDataTagTitle => 'Merk oppskrifter';

  @override
  String get recipeDataCategorizeTitle => 'Kategoriser oppskrifter';

  @override
  String get recipeDataSettingsTitle => 'Oppdater innstillinger';

  @override
  String get recipeDataExportTitle => 'Eksporter oppskrift';

  @override
  String get recipeDataDeleteTitle => 'Slett oppskrifter';

  @override
  String recipeDataExportConfirm(int count) {
    return 'Følgende oppskrifter ($count) vil bli eksportert.';
  }

  @override
  String get recipeDataExportsTitle => 'Dataeksport';

  @override
  String get recipeDataExportsDescription =>
      'Her finner du lenker til tilgjengelige eksportfiler som er klare til nedlasting. Disse eksportfilene utløper, så sørg for å laste dem ned mens de fortsatt er tilgjengelige.';

  @override
  String get recipeDataPurgeExports => 'Fjern eksporter';

  @override
  String get recipeDataPurgeConfirm =>
      'Er du sikker på at du vil slette alle eksporterte data?';

  @override
  String get recipeActionsTitle => 'Oppskriftshandlinger';

  @override
  String get recipeActionNew => 'Ny oppskriftshandling';

  @override
  String get recipeActionEdit => 'Rediger oppskriftshandling';

  @override
  String get recipeActionTypeLink => 'Lenke';

  @override
  String get recipeActionTypePost => 'Innlegg';

  @override
  String get webhooksTitle => 'Webhooks';

  @override
  String get webhooksDescription =>
      'Webhooks definert nedenfor vil utføres når et måltid defineres for dagen. På det planlagte tidspunktet blir webhook sendt med data fra oppskriften som er planlagt for dagen. Merk at tidspunktet ikke er nøyaktig og webhooks utføres med et intervall på 5 minutter. Dette betyr at webhooks utføres innenfor +/- 5 minutter etter planlagt tidspunkt.';

  @override
  String get webhookName => 'Navn på webhook';

  @override
  String get webhookUrl => 'Webhook-URL';

  @override
  String get notifiersTitle => 'Varslingsagenter';

  @override
  String get notifiersDescription =>
      'Sett opp e-post- og pushvarsler som utløses av spesifikke hendelser.';

  @override
  String get notifierNew => 'Nytt varsel';

  @override
  String get notifierDescription =>
      'Mealie bruker Apprise biblioteket til å generere varsler. De tilbyr mange alternativer for varsler. Se wikien for en omfattende guide om hvordan du oppretter URL-adressen for tjenesten din. Hvis tilgjengelig, kan valg av type varsel inkludere ekstra funksjoner.';

  @override
  String get notifierAppriseUrl => 'Apprise-URL';

  @override
  String get notifierAppriseUrlSkipped => 'Apprise-URL (hoppes over hvis tom)';

  @override
  String get notifierAppriseUrlBlankHint =>
      'Siden Apprise URL-er vanligvis inneholder sensitiv informasjon forblir dette feltet tomt mens du redigerer. Hvis du vil oppdatere URL, skriv inn den nye her, eller la den være tom for å beholde den gjeldende URL.';

  @override
  String get notifierEnable => 'Aktiver varslingsagenten';

  @override
  String get notifierWhatEvents =>
      'Hvilke hendelser skal denne varslingsagenten abonnere på?';

  @override
  String get notifierRecipeEvents => 'Oppskriftshendelser';

  @override
  String get notifierUserEvents => 'Brukerhendelser';

  @override
  String get notifierMealplanEvents => 'Måltidsplan-hendelser';

  @override
  String get notifierShoppingListEvents => 'Handlelistehendelser';

  @override
  String get notifierCookbookEvents => 'Kokebokhendelser';

  @override
  String get notifierTagEvents => 'Emneordhendelser';

  @override
  String get notifierCategoryEvents => 'Kategorihendelser';

  @override
  String get notifierLabelEvents => 'Merk hendelser';

  @override
  String get notifierUserSignup => 'Når en ny bruker blir med i gruppen din';

  @override
  String get notifierCreate => 'Opprett';

  @override
  String get notifierUpdate => 'Oppdater';

  @override
  String get notifierDelete => 'Slett';

  @override
  String get notifierTestSent => 'Testmelding sendt';

  @override
  String get adminTitle => 'Administratorinnstillinger';

  @override
  String get backupsTitle => 'Sikkerhetskopier';

  @override
  String get backupsDescription =>
      'Sikkerhetskopier er komplette øyeblikksbilder av databasen og datamappen til nettstedet. Dette inkluderer all data og kan ikke settes til å ekskludere delsett av data. Du kan tenke på dette som et øyeblikksbilde av Mealie på et bestemt tidspunkt. Disse fungerer som en databasesystemuavhengig måte å eksportere og importere data på, eller sikkerhetskopiere nettstedet til en ekstern plassering.';

  @override
  String get backupCreateHeading => 'Opprett en sikkerhetskopi';

  @override
  String get backupCreated => 'Sikkerhetskopiering fullført';

  @override
  String get backupCreateFailed =>
      'Feil ved oppretting av sikkerhetskopi. Se loggfil';

  @override
  String get backupDelete => 'Slett sikkerhetskopi';

  @override
  String get backupDeleted => 'Sikkerhetskopi slettet';

  @override
  String get backupRestore => 'Gjenopprett sikkerhetskopi';

  @override
  String get backupRestoreDescription =>
      'Gjenoppretting av denne sikkerhetskopien vil overskrive alle gjeldende data i databasen og i datamappen og erstatte dem med innholdet i denne sikkerhetskopien. Hvis gjenopprettingen er vellykket, vil du bli logget ut.';

  @override
  String get backupCannotBeUndone =>
      'Denne handlingen kan ikke angres – bruk med forsiktighet.';

  @override
  String get backupAcknowledge =>
      'Jeg forstår at denne handlingen er irreversibel, destruktiv og kan føre til tap av data';

  @override
  String get backupRestoreSuccess => 'Gjenopprettingen var vellykket';

  @override
  String get backupRestoreFailed =>
      'Gjenoppretting mislyktes. Sjekk serverloggene for flere detaljer';

  @override
  String get maintenanceTitle => 'Vedlikehold';

  @override
  String get maintenanceSummary => 'Sammendrag';

  @override
  String get maintenanceStorage => 'Lagringsdetaljer';

  @override
  String get maintenanceDataDirSize => 'Størrelse på datamappe';

  @override
  String get maintenanceCleanableDirs => 'Mapper som kan ryddes i';

  @override
  String get maintenanceCleanableImages => 'Ryddbare bilder';

  @override
  String get maintenanceTempDir => 'Midlertidig mappe (.temp)';

  @override
  String get maintenanceBackupsDir => 'Mappe for sikkerhetskopier (backups)';

  @override
  String get maintenanceGroupsDir => 'Mappe for grupper (groups)';

  @override
  String get maintenanceRecipesDir => 'Mappe for oppskrifter (recipes)';

  @override
  String get maintenanceUserDir => 'Mappe for brukere (user)';

  @override
  String get maintenanceCleanDirs => 'Fjern kataloger';

  @override
  String get maintenanceCleanDirsDescription =>
      'Fjerner alle oppskriftsmapper som ikke er gyldige UUID-er';

  @override
  String get maintenanceCleanTemp => 'Fjern midlertidige filer';

  @override
  String get maintenanceCleanTempDescription =>
      'Fjerner alle filer og mapper i .temp-mappen';

  @override
  String get maintenanceCleanImages => 'Fjern bilder';

  @override
  String get maintenanceCleanImagesDescription =>
      'Fjerner alle bildene som ikke slutter med .webp';

  @override
  String get maintenanceActions => 'Handlinger';

  @override
  String get adminConfiguration => 'Konfigurasjon';

  @override
  String get adminAppVersion => 'Programversjon';

  @override
  String get adminUpToDate => 'Mealie er oppdatert';

  @override
  String adminVersionOutdated(String current, String latest) {
    return 'Din nåværende versjon ($current) samsvarer ikke med den nyeste utgivelsen. Vurder å oppdatere til siste versjon ($latest).';
  }

  @override
  String get adminBaseUrl => 'Serverens URL';

  @override
  String get adminBaseUrlOk => 'Serverside-URL samsvarer ikke med standard';

  @override
  String get adminBaseUrlError =>
      '`BASE_URL` er fortsatt standardverdien på API-serveren. Dette vil forårsake problemer med varslingslenker som genereres på serveren for e-post osv.';

  @override
  String adminAuthReady(String provider) {
    return '$provider Klar';
  }

  @override
  String adminAuthNotReady(String provider) {
    return '$provider Ikke klar';
  }

  @override
  String adminAuthDisabled(String provider) {
    return '$provider Deaktivert';
  }

  @override
  String adminAuthSuccessText(String provider) {
    return 'Alle nødvendige $provider-variabler er satt.';
  }

  @override
  String adminAuthErrorText(String provider) {
    return 'Ikke alle $provider-verdier er konfigurert. Dette kan ignoreres hvis du ikke bruker $provider-autentisering.';
  }

  @override
  String adminAuthDisabledText(String envVar) {
    return 'For å aktivere, set $envVar til \"true\".';
  }

  @override
  String get adminEmailStatus => 'Status på konfigurasjon av e-post';

  @override
  String get adminEmailConfigured => 'E-post konfigurert';

  @override
  String get adminNotReady => 'Ikke klar - kontroller konfigurasjonen';

  @override
  String get adminSucceeded => 'Lyktes';

  @override
  String get adminFailed => 'Mislyktes';

  @override
  String get adminSiteStatistics => 'Nettstedsstatistikk';

  @override
  String get adminUncategorized => 'Ukategoriserte oppskrifter';

  @override
  String get adminUntagged => 'Oppskrifter uten tagger';

  @override
  String get adminGeneralAbout => 'Generelt om';

  @override
  String get adminVersion => 'Versjon';

  @override
  String get adminBuild => 'Build';

  @override
  String get adminApplicationMode => 'Programmodus';

  @override
  String get adminProduction => 'Produksjon';

  @override
  String get adminDevelopment => 'Utvikling';

  @override
  String get adminDemoStatus => 'Demostatus';

  @override
  String get adminDemo => 'Demo';

  @override
  String get adminNotDemo => 'Ikke demo';

  @override
  String get adminApiPort => 'API-port';

  @override
  String get adminApiDocs => 'API-dokumentasjon';

  @override
  String get adminDatabaseType => 'Databasetype';

  @override
  String get adminDatabaseUrl => 'URL til database';

  @override
  String get adminDefaultGroup => 'Standardgruppe';

  @override
  String get adminDefaultHousehold => 'Standard husholdning';

  @override
  String get adminScraperVersion => 'Versjon på oppskrift-scraper';

  @override
  String get adminStatUsers => 'Brukere';

  @override
  String get adminStatHouseholds => 'Husholdninger';

  @override
  String get adminStatGroups => 'Grupper';

  @override
  String get recipeDuplicate => 'Dupliser oppskrift';

  @override
  String get recipeDuplicateAction => 'Dupliser';

  @override
  String get recipeShareLink => 'Del oppskrift';

  @override
  String get recipeShareExpiration => 'Utløpsdato';

  @override
  String get recipeShareCopied => 'Oppskriftslenke kopiert til utklippstavle';

  @override
  String get enabledLabel => 'Aktivert';

  @override
  String get disabledLabel => 'Deaktivert';

  @override
  String get testAction => 'Test';

  @override
  String get yesLabel => 'Ja';

  @override
  String get noLabel => 'Nei';

  @override
  String get downloadAction => 'Last ned';

  @override
  String get backupUpload => 'Last opp';

  @override
  String get zipImportButton => 'Importer fra zip-fil';

  @override
  String get zipImportDescription =>
      'Importer en enkelt oppskrift som ble eksportert fra en annen Mealie-instans.';

  @override
  String get reportStatus => 'Status';

  @override
  String get reportDate => 'Dato';

  @override
  String get recipeActionTitleLabel => 'Tittel';

  @override
  String get clearAll => 'Tøm';

  @override
  String get recipeDataSettingsExplanation =>
      'Innstillinger som valgt her, bortsett fra det låste alternativet, vil bli brukt på alle valgte oppskrifter.';

  @override
  String get adminAllowSignup => 'Tillat registrering';

  @override
  String get adminAllowPasswordLogin => 'Tillat innlogging med passord';

  @override
  String get adminEmailInvalid => 'Skriv inn en gyldig e-postadresse.';

  @override
  String adminEmailTestResult(String result) {
    return 'E-posttest: $result';
  }

  @override
  String get adminSendTestEmail => 'Send test-e-post';

  @override
  String get adminTestEmailAddress => 'Mottaker';

  @override
  String get backupCreate => 'Opprett sikkerhetskopi';

  @override
  String backupDeleteConfirm(String name) {
    return 'Slette sikkerhetskopien «$name»?';
  }

  @override
  String get backupPostgresNote =>
      'Bruker du PostgreSQL, les sikkerhetskopierings-/gjenopprettingsprosessen i Mealie-dokumentasjonen før du gjenoppretter.';

  @override
  String get backupUploaded => 'Sikkerhetskopi lastet opp';

  @override
  String get backupsEmpty => 'Ingen sikkerhetskopier ennå.';

  @override
  String get bulkImportAddRow => 'Legg til URL';

  @override
  String get bulkImportStart => 'Start import';

  @override
  String get chooseFileButton => 'Velg fil';

  @override
  String get deselectAllAction => 'Fjern alle valg';

  @override
  String get downloadFailed => 'Nedlasting mislyktes';

  @override
  String get fileSaved => 'Fil lagret';

  @override
  String get loadFailed => 'Kunne ikke laste';

  @override
  String get maintenanceActionsWarning =>
      'Vedlikeholdshandlinger er destruktive og bør brukes med forsiktighet. Alle handlingene er irreversible.';

  @override
  String get maintenanceConfirm =>
      'Denne handlingen er destruktiv og kan ikke angres. Fortsette?';

  @override
  String get maintenanceDone => 'Ferdig';

  @override
  String get maintenanceFailed => 'Vedlikeholdshandlingen mislyktes';

  @override
  String get maintenanceRun => 'Kjør';

  @override
  String get migrationFailed => 'Migrering mislyktes';

  @override
  String get migrationStart => 'Start migrering';

  @override
  String get migrationStarted =>
      'Migreringen er ferdig – se rapporten nedenfor.';

  @override
  String get moreImportOptions => 'Flere importvalg';

  @override
  String notifierDeleteConfirm(String name) {
    return 'Slette varslingen «$name»?';
  }

  @override
  String get notifierEdit => 'Rediger varsling';

  @override
  String notifierEventCount(int count) {
    return 'Hendelser: $count';
  }

  @override
  String get notifierTestFailed => 'Testmeldingen kunne ikke sendes';

  @override
  String get notifiersEmpty => 'Ingen varslinger ennå.';

  @override
  String recipeActionDeleteConfirm(String name) {
    return 'Slette oppskriftshandlingen «$name»?';
  }

  @override
  String get recipeActionFailed => 'Oppskriftshandlingen mislyktes';

  @override
  String get recipeActionSent => 'Oppskrift sendt';

  @override
  String get recipeActionUrlHint => 'Plassholdere';

  @override
  String get recipeActionsDescription =>
      'Oppskriftshandlinger vises i menyen til hver oppskrift. «Lenke» åpner URL-en, «Post» lar Mealie-serveren sende oppskriften til URL-en.';

  @override
  String get recipeActionsEmpty => 'Ingen oppskriftshandlinger ennå.';

  @override
  String recipeDataDeleteConfirm(int count) {
    return 'Slette de valgte oppskriftene ($count)? Dette kan ikke angres.';
  }

  @override
  String recipeDataDeleteForbidden(int count) {
    return 'Du kan ikke slette $count av de valgte oppskriftene (bare oppretteren eller en admin kan).';
  }

  @override
  String recipeDataDeleted(int count) {
    return 'Oppskrifter slettet: $count';
  }

  @override
  String get recipeDataExportAction => 'Eksporter';

  @override
  String get recipeDataExportDone =>
      'Eksport opprettet – last den ned under Dataeksport.';

  @override
  String recipeDataExportExpires(String date) {
    return 'utløper $date';
  }

  @override
  String get recipeDataExportFailed => 'Eksport mislyktes';

  @override
  String get recipeDataExportsEmpty => 'Ingen eksporter tilgjengelig.';

  @override
  String recipeDataUpdated(int count) {
    return 'Oppskrifter oppdatert: $count';
  }

  @override
  String get recipeDuplicated => 'Oppskrift duplisert';

  @override
  String get recipeExportJson => 'Eksporter som JSON';

  @override
  String get recipeExportZip => 'Eksporter som ZIP (med bilde)';

  @override
  String get recipeShareCreate => 'Opprett lenke';

  @override
  String get recipeShareDescription =>
      'Alle med lenken kan se oppskriften i nettleseren – uten konto – til den utløper.';

  @override
  String get recipeShareEmpty => 'Ingen delingslenker ennå.';

  @override
  String recipeShareExpiresAt(String date) {
    return 'Utløper $date';
  }

  @override
  String get recipeWebToolsMenu => 'Dupliser, delingslenke og mer';

  @override
  String get reload => 'Last inn på nytt';

  @override
  String get reportDeleteConfirm => 'Slette denne rapporten?';

  @override
  String get reportEntries => 'Oppføringer';

  @override
  String get reportFailedEntries => 'Mislyktes';

  @override
  String get reportOnlyFailed => 'Vis bare mislykkede oppføringer';

  @override
  String get reportStatusFailure => 'Mislyktes';

  @override
  String get reportStatusInProgress => 'Pågår';

  @override
  String get reportStatusPartial => 'Delvis';

  @override
  String get reportStatusSuccess => 'Vellykket';

  @override
  String get reportsEmpty => 'Ingen rapporter ennå.';

  @override
  String get uploadFailed => 'Opplasting mislyktes';

  @override
  String webhookDeleteConfirm(String name) {
    return 'Slette webhooken «$name»?';
  }

  @override
  String get webhookEdit => 'Rediger webhook';

  @override
  String get webhookNew => 'Ny webhook';

  @override
  String get webhookTestFailed => 'Testen kunne ikke startes';

  @override
  String get webhookTestSent => 'Testwebhook utløst';

  @override
  String get webhookTime => 'Tidspunkt (lokal)';

  @override
  String get webhooksEmpty => 'Ingen webhooker ennå.';

  @override
  String get zipImportFailed => 'ZIP-import mislyktes';

  @override
  String get aiProvidersTitle => 'KI-leverandører';

  @override
  String get aiProvidersDescription =>
      'Konfigurer KI-levrandører for å aktivere KI-drevne funksjoner, som forbedret analyse av ingredienser, oppretting av oppskrifter fra videoer, og mer!';

  @override
  String get aiProviderSettingsTitle => 'Innstillinger for KI-leverandører';

  @override
  String get aiProvidersList => 'Tilbydere';

  @override
  String get aiProviderCreate => 'Opprett tilbyder';

  @override
  String get aiProviderEdit => 'Rediger tilbyder';

  @override
  String get aiDefaultProvider => 'Standard tilbyder';

  @override
  String get aiDefaultProviderDescription =>
      'Påkrevd for å aktivere KI-funksjoner';

  @override
  String get aiAudioProvider => 'Lydtilbyder';

  @override
  String get aiAudioProviderDescription =>
      'Aktiver funksjon for lyd transkripsjon, som å opprette oppskrifter fra videoer';

  @override
  String get aiImageProvider => 'Bildeleverandør';

  @override
  String get aiImageProviderDescription =>
      'Aktiver funksjoner for bildegjenkjenning som å opprette oppskrifter fra bilder';

  @override
  String get aiProviderName => 'Navn på tilbyder';

  @override
  String get aiApiKey => 'API-nøkkel';

  @override
  String get aiApiKeyCreateDescription =>
      'API nøkkelen til leverandøren din, brukt for autentisering. Hvis tjenesten din (f.eks. Ollama) ikke bruker en API nøkkel, må du likevel skrive inn noe her.';

  @override
  String get aiApiKeyEditDescription =>
      'La dette stå tomt med mindre du vil endre det.';

  @override
  String get aiBaseUrl => 'Grunn URL';

  @override
  String get aiBaseUrlDescription =>
      'Hvis du bruker OpenAI, la dette stå tomt. Må være et OpenAI-kompatibelt endepunkt (f.eks. «http://localhost:11434/v1»).';

  @override
  String get aiModel => 'Modell';

  @override
  String get aiModelDescription =>
      'Hva model din KI-levrandør bør bli brukt (f.eks. \"gpt-5\").';

  @override
  String get aiTimeout => 'Førespørsmål timeout (sekunder)';

  @override
  String get aiProviderCreated => 'Tilbyder opprettet';

  @override
  String get aiProviderUpdated => 'Tilbyder oppdatert';

  @override
  String get aiProviderDeleted => 'Tilbyder slettet';

  @override
  String get aiProviderCreateFailed => 'Kunne ikke opprette tilbyder';

  @override
  String get aiProviderUpdateFailed => 'Kunne ikke oppdatere tilbyder';

  @override
  String get aiProviderDeleteFailed => 'Kunne ikke slette tilbyder';

  @override
  String get aiRequestHeaders => 'Forespørselshoder';

  @override
  String get aiRequestParams => 'Forespørsel Parametere';

  @override
  String get aiNoDefaultWarning =>
      'Du har ikke angitt en standardtilbyder, så AI-funksjoner er deaktivert';

  @override
  String get aiTestConnection => 'Test tilkobling';

  @override
  String get aiTestSucceeded => 'Tilkobling vellykket';

  @override
  String get aiTestFailed => 'Tilkobling mislyktes';

  @override
  String get aiSupportsImages => 'Støtter bilder';

  @override
  String get aiTextOnly => 'Bare tekst – kan ikke være bildeleverandøren din';

  @override
  String get debugAiTitle => 'Feilsøk KI-leverandører';

  @override
  String get debugAiDescription =>
      'Bruk denne siden til å feilsøke KI-leverandører. Du kan teste tilkoblingen og se resultatet her. Er bildetjenester aktivert, kan du også legge ved et bilde.';

  @override
  String get debugParserTitle => 'Ingrediens-parser';

  @override
  String get debugParserDescription =>
      'Mealie bruker Conditional Random Fields (CRFs) for å analysere og behandle ingredienser. Modellen som brukes til ingredienser er basert på et datasett med over 100 000 ingredienser satt sammen av New York Times. Vær oppmerksom på at siden modellen kun er trent på engelsk, kan resultatene variere når du bruker modellen på andre språk. På denne siden kan du teste modellen.';

  @override
  String get debugIngredientText => 'Ingredienstekst';

  @override
  String get debugTryExample => 'Prøv et eksempel';

  @override
  String debugAverageConfidence(String value) {
    return '$value Troverdig';
  }

  @override
  String get debugRunTest => 'Kjør test';

  @override
  String get debugQuantity => 'Antall';

  @override
  String get debugUnit => 'Enhet';

  @override
  String get debugFood => 'Matvare';

  @override
  String get debugNote => 'Kommentar';

  @override
  String get debugGroup => 'Gruppe';

  @override
  String get aiProviderNone => 'Ingen';

  @override
  String aiProviderDeleteConfirm(String name) {
    return 'Slette leverandøren «$name»?';
  }

  @override
  String get aiProvidersEmpty => 'Ingen KI-leverandører ennå.';

  @override
  String get aiAdvanced => 'Avansert';

  @override
  String get aiKeyLabel => 'Navn';

  @override
  String get aiValueLabel => 'Verdi';

  @override
  String get debugTitle => 'Feilsøking';

  @override
  String get debugParse => 'Analyser';

  @override
  String get debugParseFailed => 'Ingrediensen kunne ikke analyseres';

  @override
  String get debugChooseImage => 'Velg bilde';

  @override
  String get debugNoImage => 'Intet bilde (valgfritt)';

  @override
  String get updateTitle => 'Se etter oppdateringer';

  @override
  String get updateInstalledVersion => 'Installert versjon';

  @override
  String get updateLastCheck => 'Sist sjekket';

  @override
  String get updateCheckNow => 'Sjekk nå';

  @override
  String get updateChecking => 'Ser etter oppdateringer …';

  @override
  String get updateUpToDate => 'Mealie Recipes er oppdatert.';

  @override
  String updateAvailable(String version) {
    return 'Versjon $version er tilgjengelig';
  }

  @override
  String get updateAvailableDescription =>
      'En ny versjon av Mealie Recipes er tilgjengelig. Ingenting installeres før du starter oppdateringen selv.';

  @override
  String get updateShow => 'Vis oppdatering';

  @override
  String get updateLater => 'Senere';

  @override
  String updateDownloading(int percent) {
    return 'Laster ned … $percent %';
  }

  @override
  String updateReady(String version) {
    return 'Versjon $version er klar til installering';
  }

  @override
  String get updateInstalling => 'Installerer – appen starter på nytt straks …';

  @override
  String get updateManual =>
      'Oppdateringen kunne ikke installeres automatisk. Diskbildet er åpnet: dra Mealie Recipes til Programmer.';

  @override
  String get updateFailed => 'Oppdateringen mislyktes';

  @override
  String get updateInstallNow => 'Last ned og installer';

  @override
  String get updateRestartNow => 'Installer og start på nytt';

  @override
  String get updateAutoTitle => 'Se etter oppdateringer ved oppstart';

  @override
  String get updateAutoDescription =>
      'Sjekker bare og gir beskjed – installeringen starter du alltid selv.';

  @override
  String get updateNoNotes => 'Ingen versjonsmerknader.';

  @override
  String get updateSourceHint =>
      'Oppdateringer kommer fra GitHub-utgivelsene til Mealie Recipes og installeres bare hvis de er signert av utvikleren (macOS).';
}
