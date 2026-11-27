// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class AppLocalizationsSv extends AppLocalizations {
  AppLocalizationsSv([String locale = 'sv']) : super(locale);

  @override
  String get endCookingMode => 'Avsluta matlagningsläge';

  @override
  String get endCookingModeConfirm =>
      'Vill du verkligen avsluta matlagningsläget?';

  @override
  String endCookingModeConfirmAll(int count) {
    return 'Alla $count recept i matlagningsläget avslutas. Fortsätta?';
  }

  @override
  String get addTimer => 'Lägg till timer';

  @override
  String get recipeFinished => 'Din rätt är klar.';

  @override
  String get bonAppetit => 'Smaklig måltid!';

  @override
  String get prepareIngredients => 'Förbered följande ingredienser';

  @override
  String prepareIngredientsFor(String servings) {
    return 'Förbered följande ingredienser för $servings portioner';
  }

  @override
  String get next => 'Nästa';

  @override
  String get navHome => 'Startsida';

  @override
  String get homeCookToday => 'Laga idag';

  @override
  String get homeSuggestion => 'Förslag';

  @override
  String get homeQuickAccess => 'Snabbåtkomst';

  @override
  String get homePlanned => 'Planerat';

  @override
  String get favorite => 'Favorit';

  @override
  String get navSettings => 'Inställningar';

  @override
  String homeWelcomeName(Object name) {
    return 'Välkommen $name,';
  }

  @override
  String get homeWelcomeApp => 'till Mealie Recipes 👋';

  @override
  String get theme => 'Utseende';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Ljust';

  @override
  String get themeDark => 'Mörkt';

  @override
  String get recipes => 'Recept';

  @override
  String get shoppingList => '🛒 Inköpslista';

  @override
  String get mealplan => 'Måltidsplan';

  @override
  String get settings => '⚙️ Inställningar';

  @override
  String get searchRecipe => 'Sök recept...';

  @override
  String get loadingRecipe => 'Läser in recept...';

  @override
  String get errorLoadingRecipe => 'Kunde inte ladda receptet.';

  @override
  String get noRecipesForCategory => 'Inga recept för det här filtret.';

  @override
  String get resetFilter => 'Återställ filter';

  @override
  String get allCategories => 'Alla kategorier';

  @override
  String get all => 'Alla';

  @override
  String get sortRecipes => 'Sortera recept';

  @override
  String get refreshRecipes => 'Uppdatera';

  @override
  String get sortNameAZ => 'Namn A–Ö';

  @override
  String get sortNameZA => 'Namn Ö–A';

  @override
  String get sortDateNewest => 'Nyaste först';

  @override
  String get sortDateOldest => 'Äldsta först';

  @override
  String get sortPrepTimeShort => 'Kortast förberedelsetid';

  @override
  String get sortPrepTimeLong => 'Längst förberedelsetid';

  @override
  String get sortRatingHighest => 'Högst betyg';

  @override
  String get sortRatingLowest => 'Lägst betyg';

  @override
  String get details => 'Detaljer';

  @override
  String get ingredients => 'Ingredienser';

  @override
  String get instructions => 'Gör så här';

  @override
  String get tags => 'Taggar';

  @override
  String get notes => 'Anteckningar';

  @override
  String get addNote => 'Lägg till anteckning';

  @override
  String get editNote => 'Redigera anteckning';

  @override
  String get noteTitleHint => 'Titel (valfritt)';

  @override
  String get noteTextHint => 'Anteckningstext';

  @override
  String get deleteNoteTitle => 'Ta bort anteckningen?';

  @override
  String get deleteNoteMessage => 'Anteckningen tas bort permanent.';

  @override
  String get servings => 'Portioner';

  @override
  String get planMeal => 'Planera måltid';

  @override
  String get addAllIngredients => 'Lägg till alla ingredienser';

  @override
  String get addSelectedIngredients => 'Lägg till valda ingredienser';

  @override
  String get addIngredientsMessage =>
      'Ingredienserna har lagts till i din inköpslista.';

  @override
  String addIngredientsFailedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ingredienser kunde inte läggas till.',
      one: '1 ingrediens kunde inte läggas till.',
    );
    return '$_temp0';
  }

  @override
  String get cookbooks => 'Kokböcker';

  @override
  String get cookbooksEmpty =>
      'Inga kokböcker än. Tryck på “+” uppe till höger för att skapa en.';

  @override
  String get cookbookNoMatches => 'Inga recept matchar det här filtret.';

  @override
  String get cookbookCreateTitle => 'Skapa kokbok';

  @override
  String get cookbookEditTitle => 'Redigera kokbok';

  @override
  String get cookbookNameLabel => 'Kokbokens namn';

  @override
  String get cookbookFilterSectionTitle => 'Lägg till recept automatiskt';

  @override
  String get cookbookFieldTools => 'Redskap';

  @override
  String get cookbookFieldUsers => 'Användare';

  @override
  String get cookbookOpIsOneOf => 'är något av';

  @override
  String get cookbookOpIsNotOneOf => 'är inget av';

  @override
  String get cookbookOpContainsAll => 'innehåller alla';

  @override
  String get cookbookSelectValues => 'Välj värden';

  @override
  String get cookbookFilterOptionsUnavailable => 'Inga alternativ tillgängliga';

  @override
  String get cookbookAddFilterField => 'Lägg till fält';

  @override
  String get cookbookPublicLabel => 'Offentlig kokbok';

  @override
  String get cookbookPublicSubtitle => 'Synlig för andra hushåll på servern';

  @override
  String get cookbookRawModeEnter => 'Redigera som text';

  @override
  String get cookbookRawModeExit => 'Tillbaka till byggaren';

  @override
  String get cookbookRawModeHint =>
      'Appens expertläge: redigerar filtret direkt som text. Användbart när ett befintligt filter inte kunde delas upp i enkla rader.';

  @override
  String get cookbookRawModeUnparseable =>
      'Den här texten matchar inte det enkla radformatet — den förblir text.';

  @override
  String get saveFailed => 'Det gick inte att spara';

  @override
  String get search => 'Sök';

  @override
  String get apply => 'Använd';

  @override
  String get setupCachingTitle => 'Laddar dina recept';

  @override
  String get setupCachingSubtitle =>
      'Dina recept förbereds för användning offline. Beroende på hur många du har kan det ta en stund.';

  @override
  String get setupCachingDone => 'Allt klart!';

  @override
  String get setupTipsHeader => 'Visste du?';

  @override
  String get setupFinish => 'Kör igång';

  @override
  String get setupSkipCaching => 'Fortsätt i bakgrunden';

  @override
  String get setupTip1 =>
      'Du kan importera recept från en länk, ett foto eller en PDF — via rutan Importera på startskärmen.';

  @override
  String get setupTip2 =>
      'Matlagningsläget håller skärmen tänd, guidar dig steg för steg och hittar automatiskt timrar i texten.';

  @override
  String get setupTip3 =>
      'Inköpslistan fungerar även offline — ändringar synkas automatiskt när servern går att nå.';

  @override
  String get setupTip4 =>
      'Håll in en ruta på startskärmen för att ordna om snabbåtkomsten.';

  @override
  String get setupTip5 =>
      'Dina Mealie-kokböcker hittar du i rutan Kokböcker — även offline.';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Avbryt';

  @override
  String get delete => 'Ta bort';

  @override
  String get edit => 'Redigera';

  @override
  String get save => 'Spara';

  @override
  String get done => 'Färdig';

  @override
  String get close => 'Stäng';

  @override
  String get add => 'Lägg till';

  @override
  String get send => 'Skicka';

  @override
  String get retry => 'Försök igen';

  @override
  String get confirmDeleteTitle => 'Ta bort receptet?';

  @override
  String get confirmDeleteMessage => 'Den här åtgärden kan inte ångras.';

  @override
  String get sendToDevice => 'Skicka till enhet';

  @override
  String get timerFinished => 'Timern är klar!';

  @override
  String get timer => 'Timer';

  @override
  String get newTimer => 'Ny timer';

  @override
  String get timerNamePlaceholder => 'Timerns namn';

  @override
  String get durationLabel => 'Tid';

  @override
  String get start => 'Starta';

  @override
  String get stop => 'Stoppa';

  @override
  String get pause => 'Pausa';

  @override
  String get resume => 'Fortsätt';

  @override
  String get finished => 'Klart!';

  @override
  String stepNumber(int number) {
    return 'Steg $number';
  }

  @override
  String get minAbbreviation => 'min';

  @override
  String get cookingMode => 'Matlagningsläge';

  @override
  String get endAll => 'Avsluta alla';

  @override
  String get end => 'Avsluta';

  @override
  String get noActiveTimers => 'Inga aktiva timrar';

  @override
  String get noActiveRecipes => 'Inga aktiva recept';

  @override
  String get startRecipeToCook =>
      'Öppna ett recept och tryck på knappen för matlagningsläge för att börja.';

  @override
  String get browseRecipes => 'Bläddra bland recept';

  @override
  String get cookFriends => 'Laga mat med vänner';

  @override
  String get cookingModeAddRecipe => 'Lägg till recept';

  @override
  String get cookingModeAddRecipeSearchHint => 'Sök recept';

  @override
  String get cookFriendsCode => 'Sessionskod';

  @override
  String get cookFriendsJoin => 'Gå med i session';

  @override
  String get cookFriendsHost => 'Starta session';

  @override
  String get cookFriendsHostNotFound =>
      'Värden hittades inte. Se till att båda enheterna är på samma Wi-Fi och att åtkomst till lokalt nätverk är tillåten.';

  @override
  String get cookFriendsConnectionFailed =>
      'Anslutningen misslyckades. Försök igen.';

  @override
  String get cookFriendsEnterCode => 'Ange kod';

  @override
  String cookFriendsConnected(int count) {
    return 'Anslutna: $count gäster';
  }

  @override
  String get joinSession => 'Gå med i session';

  @override
  String get hostEndedSessionMessage =>
      'Värden har avslutat matlagningssessionen.';

  @override
  String get addItem => 'Lägg till vara';

  @override
  String get itemNote => 'Varans namn';

  @override
  String get unlabeledCategory => 'Utan etikett';

  @override
  String get archivedLists => '📦 Arkiverade inköp';

  @override
  String get postimportAction => 'Efter import';

  @override
  String get postimportHint =>
      'Välj vad som ska hända med de importerade posterna i källappen (Påminnelser / Google Tasks).';

  @override
  String get postimportLeave => 'Bara lägg till';

  @override
  String get postimportComplete => 'Bocka av';

  @override
  String get postimportCompleteDelete => 'Bocka av och ta bort';

  @override
  String get postimportFailed =>
      'Efterbehandlingen i källappen misslyckades. Varorna lades ändå till i Mealie.';

  @override
  String get syncChangesTitle => 'Synka ändringar';

  @override
  String get syncSectionChecked => 'Avbockade';

  @override
  String get syncSectionQuantity => 'Mängd';

  @override
  String get syncSectionCategory => 'Kategori';

  @override
  String get syncSectionAdditions => 'Nyligen tillagda';

  @override
  String get syncLocalLabel => 'Lokalt';

  @override
  String get syncServerLabel => 'Server';

  @override
  String get syncNow => 'Synka nu';

  @override
  String get offlineBadge => 'Offline';

  @override
  String get mealplanTitle => '📅 Måltidsplan';

  @override
  String get breakfast => 'Frukost';

  @override
  String get lunch => 'Lunch';

  @override
  String get dinner => 'Middag';

  @override
  String get addMealEntry => 'Lägg till måltid';

  @override
  String get selectRecipe => 'Välj recept';

  @override
  String get importRecipe => 'Importera recept';

  @override
  String get url => 'URL';

  @override
  String get importLanguage => 'Språk för OCR';

  @override
  String get setupTitle => 'Välkommen till Mealie Recipes';

  @override
  String get setupSubtitle => 'Konfigurera din Mealie-server.';

  @override
  String get serverUrl => 'Serverns URL';

  @override
  String get serverUrlPlaceholder => 'https://mealie.example.com';

  @override
  String get apiToken => 'API-nyckel';

  @override
  String get apiTokenPlaceholder => 'Din API-token';

  @override
  String get householdId => 'Hushåll';

  @override
  String get householdIdPlaceholder => 'Familj';

  @override
  String get shoppingListId => 'Inköpslistans ID';

  @override
  String get setupHouseholdListTitle => 'Hushåll och inköpslista';

  @override
  String get shoppingListLabel => 'Inköpslista';

  @override
  String get setupHouseholdManualHint =>
      'Hushållen kunde inte laddas — ange hushållets namn manuellt.';

  @override
  String get setupExactTitle => 'Mängder på inköpslistan';

  @override
  String get setupExactBody =>
      'I de flesta länder handlar man inte på grammet — man lägger 1 paket smör i vagnen, inte 200 g. I enkelt läge gör appen därför om receptets mängder till “1×”. I exakt läge behålls mängd och enhet 1:1 som i Mealies webbapp — även när du skriver nya varor (t.ex. “200 g smör”). Du kan ändra detta när som helst i inställningarna.';

  @override
  String get setupExactSimpleTitle => 'Enkelt läge (1×)';

  @override
  String get setupExactSimpleBody =>
      'Ingredienser hamnar på listan som “1× vara” — perfekt för att snabbt bocka av i butiken.';

  @override
  String get setupExactExactTitle => 'Exakta mängder';

  @override
  String get setupExactExactBody =>
      'Varor visas med mängd och enhet, t.ex. “200 g smör” — precis som i webbappen.';

  @override
  String get connect => 'Anslut';

  @override
  String connectionError(String error) {
    return 'Anslutningen misslyckades: $error';
  }

  @override
  String get optionalHeaders => 'Valfria HTTP-huvuden (för omvänd proxy)';

  @override
  String get settingsTitle => '⚙️ Inställningar';

  @override
  String get settingsSaved => 'Inställningarna har sparats';

  @override
  String get securitySettings => 'Säkerhet';

  @override
  String get showRecipeImages => 'Visa receptbilder';

  @override
  String get apiVersion => 'API-version';

  @override
  String get language => 'Språk';

  @override
  String get biometricLock => 'Biometriskt lås';

  @override
  String get biometricLockDescription => 'Lås upp appen med biometri';

  @override
  String get enableLogging => 'Aktivera loggning';

  @override
  String get selectLanguage => 'Välj språk';

  @override
  String get setupContinue => 'Fortsätt';

  @override
  String get back => 'Tillbaka';

  @override
  String get setupConnectStep => 'Anslut till din server';

  @override
  String get resetSettings => 'Återställ alla inställningar';

  @override
  String get resetSettingsConfirm =>
      'Alla inställningar återställs. Fortsätta?';

  @override
  String get guestMode => 'Gästläge';

  @override
  String get appVersion => 'Version';

  @override
  String get leftoverFinder => 'Sök recept';

  @override
  String get addIngredient => 'Lägg till ingrediens';

  @override
  String get biometricPrompt => 'Autentisera dig för att öppna Mealie Recipes';

  @override
  String get biometricFailed => 'Autentiseringen misslyckades';

  @override
  String get pendingRecipesTitle => 'Mottagna recept';

  @override
  String pendingRecipesFrom(Object names) {
    return 'Från $names';
  }

  @override
  String get pendingRecipesOpenCooking => 'Öppna matlagningsläge';

  @override
  String get dismiss => 'Stäng';

  @override
  String get editRecipe => 'Redigera recept';

  @override
  String get recipeName => 'Receptets namn';

  @override
  String get prepTime => 'Förberedelsetid (min)';

  @override
  String get cookTime => 'Tillagningstid (min)';

  @override
  String get totalTime => 'Total tid (min)';

  @override
  String get recipeServings => 'Portioner';

  @override
  String get rating => 'Betyg';

  @override
  String get addIngredientLine => 'Lägg till ingrediens';

  @override
  String get addInstruction => 'Lägg till steg';

  @override
  String get removeIngredient => 'Ta bort ingrediens';

  @override
  String get removeInstruction => 'Ta bort steg';

  @override
  String get ingredientName => 'Ingrediens';

  @override
  String get ingredientQuantity => 'Antal';

  @override
  String get ingredientUnit => 'Måttenhet';

  @override
  String get ingredientNote => 'Anteckning';

  @override
  String get instructionText => 'Stegets text';

  @override
  String get categories => 'Kategorier';

  @override
  String get saveChanges => 'Spara ändringar';

  @override
  String get saveSuccess => 'Receptet har sparats.';

  @override
  String get newCategory => 'Ny kategori';

  @override
  String get newTag => 'Ny tagg';

  @override
  String get setRating => 'Sätt betyg';

  @override
  String get homeWelcome => 'Välkommen till Mealie Recipes! 👋';

  @override
  String homeWelcomeNamed(String name) {
    return 'Välkommen $name, till Mealie Recipes! 👋';
  }

  @override
  String get shopping => 'Handla';

  @override
  String get planning => 'Planering';

  @override
  String get other => 'Övrigt';

  @override
  String get addRecipe => '➕ Lägg till recept';

  @override
  String get completeShopping => 'Avsluta handlingen';

  @override
  String get shoppingCompleted => 'Handlingen är klar';

  @override
  String get shoppingCompletedSubtitle => 'Allt i vagnen! 🎉';

  @override
  String get shoppingOfflineNoCache => 'Offline – listan är inte sparad';

  @override
  String get shoppingOfflineNoCacheSubtitle =>
      'Inga varor från den här listan finns sparade på enheten än. Den laddas så snart du är online igen.';

  @override
  String get essensplan => '📅 Måltidsplan';

  @override
  String get resteverwertung => '🥗 Receptsök';

  @override
  String get copyCode => 'Kopiera kod';

  @override
  String get shareLink => 'Dela länk';

  @override
  String get connectedFriends => 'Anslutna vänner';

  @override
  String get waitingForFriends => 'Väntar på vänner...';

  @override
  String get sessionCode => 'SESSIONSKOD';

  @override
  String get loading => 'Laddar...';

  @override
  String get urlInvalidScheme =>
      'URL:en måste börja med http:// eller https://';

  @override
  String get urlAddScheme => 'Lägg till https://';

  @override
  String get addItemPlaceholder => 'Lägg till vara...';

  @override
  String get completedItems => 'Klara';

  @override
  String get completeShoppingTitle => 'Avsluta handlingen?';

  @override
  String get completeShoppingMessage => 'Ta bort avbockade varor?';

  @override
  String get recipeListTitle => '📖 Recept';

  @override
  String get importRecipeTitle => 'Ladda upp nytt recept';

  @override
  String get uploadRecipeUrl => 'Importera via receptets URL';

  @override
  String get uploadRecipeUrlHint =>
      'Ange receptets URL för att spara det på din server';

  @override
  String get uploadOpenAI => 'Importera från fil via OpenAI';

  @override
  String get uploadOpenAIHint =>
      'Ladda alternativt upp foton eller en PDF av ett recept. Om receptet sträcker sig över flera sidor lägger du bara till flera — de analyseras tillsammans av AI.';

  @override
  String get takePhoto => 'Kamera';

  @override
  String get cameraPermissionDenied =>
      'Ingen åtkomst till kameran. Tillåt den i systeminställningarna för att fotografera recept.';

  @override
  String get cameraUnavailable => 'Ingen kamera finns på den här enheten.';

  @override
  String get selectPhoto => 'Bilder';

  @override
  String get selectPdf => 'PDF';

  @override
  String get openAIHintTitle => 'Info om filanalys';

  @override
  String get openAIHintBody =>
      'Receptanalysen använder OpenAI:s API. Se till att din API-nyckel är konfigurerad i Mealie-serverns inställningar.';

  @override
  String get allDeleteConfirm => 'Ta bort alla';

  @override
  String get entriesInOtherWeeks => 'Det finns poster i andra veckor';

  @override
  String get availableWeeks => 'Tillgängliga veckor:';

  @override
  String get currentWeek => 'Aktuell vecka';

  @override
  String get weekAbbreviation => 'V.';

  @override
  String get today => 'Idag';

  @override
  String get selectDate => 'Välj datum';

  @override
  String get selectedRecipe => 'Valt recept';

  @override
  String get confirmMeal => 'Planera måltid';

  @override
  String get searchRecipes => 'Sök recept';

  @override
  String get addCustomMeal => 'Lägg till egen måltid';

  @override
  String get diceModeButton => 'Slumpa recept';

  @override
  String get diceModeTitle => '3 slumpade förslag';

  @override
  String get diceBackToSearch => 'Tillbaka till sökningen';

  @override
  String get diceNotEnoughRecipes =>
      'För få recept för tärningsläget (minst 3 behövs)';

  @override
  String get entrySingular => 'post';

  @override
  String get entriesPlural => 'poster';

  @override
  String get deleteAllConfirmTitle => 'Ta bort alla?';

  @override
  String get deleteAllConfirmMessage =>
      'Vill du ta bort alla arkiverade inköp?';

  @override
  String get uploadFromUrlButton => 'Importera recept från URL';

  @override
  String get uploadingImage => 'Laddar upp...';

  @override
  String get uploadErrorTitle => 'Uppladdningen misslyckades';

  @override
  String get uploadSuccessTitle => 'Uppladdningen lyckades';

  @override
  String get editImportedRecipeQuestion =>
      'Vill du redigera det nya receptet nu?';

  @override
  String get notNow => 'Inte nu';

  @override
  String get pdfTooLarge => 'PDF-filen är för stor (max 10 MB).';

  @override
  String get invalidUrl => 'Ogiltig URL. Ange en giltig HTTP(S)-URL.';

  @override
  String get cookWithFriends => 'Laga mat med vänner';

  @override
  String get cookFriendsSubtitle =>
      'Bjud in en vän att laga det här receptet tillsammans';

  @override
  String get copied => 'Kopierat';

  @override
  String get linkCopied => 'Länken har kopierats';

  @override
  String get startCooking => 'Börja laga';

  @override
  String get uploadToOwnServer => 'Spara på min server';

  @override
  String get uploadingRecipe => 'Laddar upp recept…';

  @override
  String get recipeUploadedToOwnServer => 'Receptet har sparats på din server';

  @override
  String get recipeUploadFailed => 'Uppladdningen misslyckades';

  @override
  String get allowGuestSaveRecipes =>
      'Låt gäster spara recept på sin egen server';

  @override
  String get appIcon => 'Appikon';

  @override
  String get name => 'Namn';

  @override
  String get color => 'Färg';

  @override
  String get randomColor => 'Slumpad färg';

  @override
  String get createFailed => 'Kunde inte skapa';

  @override
  String get deleteFailed => 'Kunde inte ta bort';

  @override
  String deleteOrganizerConfirm(String name) {
    return 'Ta bort “$name”? Den tas även bort på servern.';
  }

  @override
  String get connectionSection => 'Anslutning';

  @override
  String get token => 'Token';

  @override
  String get advancedOptions => 'Avancerade alternativ';

  @override
  String get mealieApiVersion => 'Mealies API-version';

  @override
  String get sendOptionalHeaders => 'Skicka valfria huvuden';

  @override
  String get offlineRecipeImages => 'Spara receptbilder offline';

  @override
  String get offlineRecipeImagesHint =>
      'Laddar ner alla receptbilder till enheten – även bilderna i stegen och anteckningarna – så att de visas utan anslutning. Stora samlingar kan ta upp flera hundra MB. Stängs detta av tas de sparade bilderna bort.';

  @override
  String offlineRecipeImagesStatus(int count, int total, String size) {
    return 'Sparade: $count/$total · $size';
  }

  @override
  String get offlineRecipeImagesDisableConfirm =>
      'Ta bort alla sparade receptbilder?';

  @override
  String headerNameLabel(int n) {
    return 'Namn på huvud $n';
  }

  @override
  String headerValueLabel(int n) {
    return 'Värde för huvud $n';
  }

  @override
  String get value => 'Värde';

  @override
  String get personalization => 'Anpassning';

  @override
  String get showRecipeImagesSubtitle => 'Visar bilder i receptlistan';

  @override
  String get exactQuantities => 'Lägg till exakta mängder';

  @override
  String get exactQuantitiesSubtitle =>
      'Ingredienser och inskrivna varor behåller mängd och enhet (t.ex. 200 g smör) i stället för 1× per vara';

  @override
  String get remindToShop => 'Påminn mig att handla';

  @override
  String get remindToShopSubtitle =>
      'Meddelar dig när du är nära en sparad plats och inköpslistan har öppna varor — även när appen är stängd';

  @override
  String get shoppingReminderAddLocation => 'Lägg till plats';

  @override
  String get shoppingReminderMaxLocations => 'Max 3 platser har nåtts';

  @override
  String get shoppingReminderLocationServiceDisabled =>
      'Platstjänster är avstängda på den här enheten';

  @override
  String get shoppingReminderPermissionTitle => 'Platsåtkomst krävs';

  @override
  String get shoppingReminderPermissionMessage =>
      'För att påminna dig nära en butik krävs platsåtkomst “Alltid” — även när appen är stängd. Aktivera det i Inställningar.';

  @override
  String get openSettings => 'Öppna Inställningar';

  @override
  String get shoppingReminderLocationName => 'Namn';

  @override
  String get shoppingReminderUseCurrentLocation => 'Använd nuvarande plats';

  @override
  String get shoppingReminderOrAddress => 'eller ange en adress';

  @override
  String get shoppingReminderAddress => 'Adress';

  @override
  String get shoppingReminderAddressPlaceholder => 'Gata, ort';

  @override
  String get shoppingReminderSearchAddress => 'Sök';

  @override
  String get shoppingReminderLocationFailed => 'Kunde inte avgöra din plats';

  @override
  String get shoppingReminderAddressNotFound => 'Adressen hittades inte';

  @override
  String get ratingFailed => 'Betyget kunde inte sparas — försök igen.';

  @override
  String get lastCooked => 'Senast tillagat';

  @override
  String get syncLastCooked => 'Uppdatera “senast tillagat”';

  @override
  String get syncLastCookedSubtitle =>
      'Sparar dagens datum och en tidslinjepost på servern — som Mealies webbapp.';

  @override
  String get developer => 'Utvecklare';

  @override
  String get enableLoggingSubtitle =>
      'Sparar utskrifts-/felloggar (senaste 500 raderna)';

  @override
  String get entriesLabel => 'Poster';

  @override
  String get fileSize => 'Filstorlek';

  @override
  String get showAction => 'Visa';

  @override
  String get copy => 'Kopiera';

  @override
  String logsWithCount(int count) {
    return 'Loggar ($count)';
  }

  @override
  String get noLogs => 'Inga loggar tillgängliga';

  @override
  String get logsTitle => 'Loggar';

  @override
  String get required => 'Obligatoriskt';

  @override
  String get connectionFailedCheck =>
      'Anslutningen misslyckades. Kontrollera URL och token.';

  @override
  String get username => 'Användarnamn';

  @override
  String get password => 'Lösenord';

  @override
  String get setupPasswordHint =>
      'Ditt lösenord sparas inte — appen loggar in en gång och skapar en API-token från det (som Profil → API-tokens i webbappen).';

  @override
  String get loginAndConnect => 'Logga in och anslut';

  @override
  String get loginInvalidCredentials =>
      'Användarnamnet eller lösenordet är fel.';

  @override
  String get apiTokenSaveHint =>
      'Token tillämpad — tryck på “Spara ändringar” nedan.';

  @override
  String get renewApiToken => 'Förnya API-token';

  @override
  String get setupAuthChoiceTitle => 'Hur vill du logga in?';

  @override
  String get authModePasswordTitle => 'Låt appen skapa en API-nyckel åt mig';

  @override
  String get authModePasswordSubtitle =>
      'Logga in med användarnamn och lösenord — appen skapar en token automatiskt.';

  @override
  String get authModeTokenTitle => 'Jag har redan en API-nyckel';

  @override
  String get authModeTokenSubtitle =>
      'Kopierad från Mealie-profilen (Profil → API-tokens).';

  @override
  String keyN(int n) {
    return 'Nyckel $n';
  }

  @override
  String valueN(int n) {
    return 'Värde $n';
  }

  @override
  String get openCookingMode => 'Öppna matlagningsläge';

  @override
  String activeRecipes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count aktiva recept',
      one: '1 aktivt recept',
    );
    return '$_temp0';
  }

  @override
  String get reparseIngredients => 'Tolka ingredienser igen';

  @override
  String get reparseIngredientsSubtitle =>
      'Dela upp mängd/enhet/ingrediens (t.ex. “200 g mjöl”)';

  @override
  String get reparseDone =>
      'Ingredienser uppdelade – tryck på “Spara ändringar” för att tillämpa';

  @override
  String get tagsAndCategories => 'Taggar, kategorier och redskap';

  @override
  String get tapToAddPhoto => 'Tryck för att lägga till foto';

  @override
  String get descriptionLabel => 'Beskrivning';

  @override
  String get searchingDevices => 'Söker efter enheter på samma Wi-Fi…';

  @override
  String get selectAll => 'Markera alla';

  @override
  String get importReminders => 'Importera påminnelser';

  @override
  String get importGoogleTasks => 'Importera Google Tasks';

  @override
  String get noTaskLists => 'Inga uppgiftslistor hittades';

  @override
  String get noReminderLists => 'Inga påminnelselistor hittades';

  @override
  String importCount(int count) {
    return 'Importera $count';
  }

  @override
  String get noIngredientsToLink => 'Inga ingredienser att länka än';

  @override
  String get importLanguageSubtitle =>
      'Språk för recept som importeras från foto eller PDF';

  @override
  String get importLanguageSearch => 'Sök språk';

  @override
  String get importLanguageFollowApp => 'Samma som appens språk';

  @override
  String get importLanguageNoMatch => 'Inget språk hittades';

  @override
  String get setupImportLanguageTitle => 'AI-import av recept';

  @override
  String get setupImportLanguageBody =>
      'Foton och PDF:er kan göras om till recept av AI. Välj vilket språk de ska hamna på — praktiskt om ditt modersmål inte finns som appspråk. Du kan ändra detta senare i inställningarna.';

  @override
  String get setupImportLanguageSearchHint =>
      'Använd sökningen i väljaren för att hitta språk som appens gränssnitt inte erbjuder.';

  @override
  String get setupCachingKeepOpenTitle => 'Håll appen öppen';

  @override
  String get setupCachingKeepOpenBody =>
      'Laddningen sker i förgrunden. Låt appen vara öppen tills den är klar — om du stänger den eller byter app för länge avbryts processen och börjar om senare.';

  @override
  String get supportContact => 'Kontakta support';

  @override
  String get supportDialogMessage =>
      'Beskriv ditt problem så återkommer vi. Loggen hjälper mycket vid felsökning — du kan bifoga den som textfil.';

  @override
  String get supportWithoutLogs => 'Utan logg';

  @override
  String get supportWithLogs => 'Bifoga logg';

  @override
  String get supportMailSubject => 'Mealie Recipes — Support';

  @override
  String get supportMailHint => 'Beskriv ditt problem här:';

  @override
  String get supportLogsEmpty =>
      'Loggen är tom. Aktivera loggning, återskapa problemet och skicka sedan.';

  @override
  String supportAddressCopied(String email) {
    return 'Adressen har kopierats: $email';
  }

  @override
  String supportNoMailApp(String email) {
    return 'Ingen e-postapp är konfigurerad – adressen har kopierats: $email. Välj en annan app för att skriva till oss.';
  }

  @override
  String get createRecipeFromImages => 'Skapa recept';

  @override
  String imagePagesSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sidor valda',
      one: '1 sida vald',
    );
    return '$_temp0';
  }

  @override
  String get imagePagesHint =>
      'Den första bilden blir receptets huvudbild. Håll ned en sida för att ändra ordningen.';

  @override
  String get mainImageBadge => 'Huvud';

  @override
  String maxImagesReached(int max) {
    return 'Du kan lägga till upp till $max bilder per recept.';
  }

  @override
  String get removePage => 'Ta bort sida';

  @override
  String get preparingPdf => 'Bearbetar PDF...';

  @override
  String get recipeOptionsTitle => 'Alternativ';

  @override
  String get exportAsPdf => 'Exportera som PDF';

  @override
  String get generatingPdf => 'Skapar PDF…';

  @override
  String get pdfExportFailed => 'PDF-exporten misslyckades';

  @override
  String get recipeTime => 'Tid';

  @override
  String get addIngredientSection => 'Lägg till avsnitt';

  @override
  String get aiImportToggle => 'Analysera med AI';

  @override
  String get aiImportToggleHint =>
      'Även för receptvideor (YouTube, Instagram, TikTok …) och sidor som den vanliga importen inte kan läsa. Kräver en AI-leverantör på din Mealie-server — för videor även en ljudleverantör.';

  @override
  String get aiImportButton => 'Importera med AI';

  @override
  String get aiImportRunning =>
      'AI:n analyserar länken … videor kan ta några minuter.';

  @override
  String get aiImportFailed =>
      'AI-importen misslyckades. Kontrollera AI-inställningarna på din Mealie-server.';

  @override
  String get stepHeadingLabel => 'Rubrik för steget (valfritt)';

  @override
  String get linkedRecipeLabel => 'Länkat recept';

  @override
  String get toolsTitle => 'Redskap';

  @override
  String get prepareTools => 'Ta fram följande redskap';

  @override
  String get newTool => 'Nytt redskap';

  @override
  String get renameAction => 'Byt namn';

  @override
  String get organizerEmpty =>
      'Här finns inget än. Tryck på “+” uppe till höger för att skapa.';

  @override
  String organizerRecipeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count recept',
      one: '1 recept',
      zero: 'Inga recept',
    );
    return '$_temp0';
  }

  @override
  String get toolOnHand => 'Finns hemma';

  @override
  String get mealDiceSettingsHint =>
      'Välj kategorier och taggar för varje måltid. När du slår tärningen föreslås bara recept med minst en av dem. Samma post kan användas för flera måltider.';

  @override
  String get mealDiceSettingsNoneHint =>
      'Inget valt för den här måltiden: tärningen väljer automatiskt utifrån kategorinamn som “Frukost”, “Lunch” eller “Middag”.';

  @override
  String get mealDiceAutoHintTitle => 'Automatiskt val';

  @override
  String get mealDiceAutoHintBody =>
      'Inga kategorier eller taggar är inställda för den här måltiden än. Tärningen letar därför efter kategorier som “Frukost”, “Lunch” eller “Middag” och fyller på med andra recept.\n\nFör att välja själv: tryck på kugghjulet bredvid “+” i måltidsplanen.';

  @override
  String get dontShowAgain => 'Visa inte igen';

  @override
  String get mealDiceNoMatches =>
      'Inget recept matchar de kategorier och taggar som valts för den här måltiden.';

  @override
  String mealDiceFewMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bara $count matchande recept',
      one: 'Bara 1 matchande recept',
    );
    return '$_temp0';
  }

  @override
  String get commentsTitle => 'Kommentarer';

  @override
  String get commentHint => 'Skriv en kommentar…';

  @override
  String get commentSaveFailed => 'Kommentaren kunde inte sparas.';

  @override
  String get commentDeleteConfirm => 'Ta bort den här kommentaren?';

  @override
  String get cookingDoneCommentLabel => 'Kommentar (valfritt)';

  @override
  String get cookingDoneCommentHint => 'Hur blev det? Tips till nästa gång…';

  @override
  String get nutritionTitle => 'Näringsinnehåll';

  @override
  String get nutritionPerServing => 'per portion';

  @override
  String get nutritionCalories => 'Kalorier';

  @override
  String get nutritionFat => 'Fett';

  @override
  String get nutritionSaturatedFat => 'Mättat fett';

  @override
  String get nutritionTransFat => 'Transfett';

  @override
  String get nutritionUnsaturatedFat => 'Omättat fett';

  @override
  String get nutritionCholesterol => 'Kolesterol';

  @override
  String get nutritionSodium => 'Natrium';

  @override
  String get nutritionCarbohydrates => 'Kolhydrater';

  @override
  String get nutritionFiber => 'Fibrer';

  @override
  String get nutritionSugar => 'Socker';

  @override
  String get nutritionProtein => 'Protein';

  @override
  String get timelineTitle => 'Tidslinje';

  @override
  String get timelineMadeThis => 'Jag har lagat det';

  @override
  String timelineUserMadeThis(String name) {
    return '$name har lagat det';
  }

  @override
  String get timelineEmpty => 'Inga poster i tidslinjen än.';

  @override
  String get timelineDate => 'Datum';

  @override
  String get timelineNoteHint => 'Anteckning (valfritt)';

  @override
  String get timelineAddPhoto => 'Lägg till foto';

  @override
  String get timelineRemovePhoto => 'Ta bort foto';

  @override
  String get timelineSaved => 'Tillagt i tidslinjen';

  @override
  String get timelineSaveFailed => 'Kunde inte läggas till i tidslinjen';

  @override
  String get timelineImageFailed =>
      'Posten sparades, men fotot kunde inte laddas upp';

  @override
  String get timelineDeleteConfirm => 'Ta bort den här posten från tidslinjen?';

  @override
  String get timelineEditNote => 'Redigera anteckning';

  @override
  String get timelineUnknownRecipe => 'Receptet hittades inte';

  @override
  String get cookingDonePhotoHint => 'Foto till Mealies tidslinje (valfritt)';

  @override
  String get assetsTitle => 'Bilagor';

  @override
  String get assetsAdd => 'Lägg till bilaga';

  @override
  String get assetsChooseFile => 'Fil';

  @override
  String get assetsUploading => 'Laddar upp…';

  @override
  String get assetsUploadFailed => 'Bilagan kunde inte laddas upp';

  @override
  String assetsDeleteConfirm(String name) {
    return 'Ta bort “$name” från bilagorna?';
  }

  @override
  String get assetsOpenFailed => 'Bilagan kunde inte öppnas';

  @override
  String get assetsUnsupported =>
      'Mealie stöder bara PDF, bilder, TXT, MD, CSV och JSON.';

  @override
  String get assetsShare => 'Dela';

  @override
  String get mealRulesTitle => 'Mealie-regler';

  @override
  String get mealRulesHint =>
      'Används även av Mealies webbapp. Om flera regler gäller för dagen och måltiden måste alla matcha. Om ingen regel gäller väljer tärningen bland alla recept.';

  @override
  String get mealRuleAdd => 'Lägg till regel';

  @override
  String get mealRuleNewTitle => 'Ny regel';

  @override
  String get mealRuleEditTitle => 'Redigera regel';

  @override
  String get mealRuleDay => 'Dag';

  @override
  String get mealRuleAnyDay => 'Valfri dag';

  @override
  String get mealRuleMealType => 'Måltid';

  @override
  String get mealRuleAnyMeal => 'Valfri måltid';

  @override
  String get mealRuleConditionsTitle => 'Villkor';

  @override
  String get mealRuleAllRecipes => 'Alla recept';

  @override
  String get mealRuleDeleteConfirm => 'Ta bort den här regeln?';

  @override
  String get mealRulesOffline =>
      'Mealie-reglerna är inte tillgängliga just nu – tärningen använder appens urval.';

  @override
  String get mealRulesNoMatches =>
      'Inga recept matchar Mealie-reglerna för den här måltiden.';

  @override
  String get mealTypeSide => 'Tillbehör';

  @override
  String get mealTypeSnack => 'Mellanmål';

  @override
  String get mealTypeDrink => 'Dryck';

  @override
  String get mealTypeDessert => 'Efterrätt';

  @override
  String get foodsTitle => 'Livsmedel';

  @override
  String get unitsTitle => 'Enheter';

  @override
  String get newFood => 'Nytt livsmedel';

  @override
  String get newUnit => 'Ny enhet';

  @override
  String get editFood => 'Redigera livsmedel';

  @override
  String get editUnit => 'Redigera enhet';

  @override
  String get pluralNameLabel => 'Namn i plural';

  @override
  String get abbreviationLabel => 'Förkortning';

  @override
  String get pluralAbbreviationLabel => 'Förkortning i plural';

  @override
  String get mergeAction => 'Slå ihop';

  @override
  String mergeIntoTitle(String name) {
    return 'Slå ihop “$name” med…';
  }

  @override
  String mergeConfirm(String from, String to) {
    return '“$from” slås ihop med “$to”: alla recept och inköpslistor använder sedan “$to”, och “$from” tas bort.';
  }

  @override
  String get mergeFailed => 'Sammanslagningen misslyckades';

  @override
  String foodUnitDeleteConfirm(String name) {
    return 'Ta bort “$name”? Ingredienser som använder den förlorar kopplingen.';
  }

  @override
  String get foodsUnitsEmpty => 'Inga poster än.';

  @override
  String mealRuleConditionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count villkor',
      one: '1 villkor',
    );
    return '$_temp0';
  }

  @override
  String get showAll => 'Visa alla';

  @override
  String get mealDiceModeTitle => 'Tärningen använder';

  @override
  String get mealDiceModeApp => 'Appens urval';

  @override
  String get switchListTitle => 'Byt lista';

  @override
  String get newShoppingList => 'Ny inköpslista';

  @override
  String shoppingListDeleteConfirm(String name) {
    return 'Ta bort “$name”? Alla varor i den tas också bort.';
  }

  @override
  String get labelOrderTitle => 'Sortera etiketter';

  @override
  String get labelOrderHint =>
      'Dra för att sortera. Gäller den här listan – även i Mealies webbapp.';

  @override
  String get labelOrderEmpty => 'Den här listan har inga etiketter än.';

  @override
  String get useAsActiveList => 'Använd som aktiv lista';

  @override
  String get activeListBadge => 'Aktiv';

  @override
  String get foodLabelLabel => 'Etikett';

  @override
  String get foodNoLabel => 'Ingen etikett';

  @override
  String get aliasesLabel => 'Alias';

  @override
  String get aliasAddHint => 'Lägg till alias';

  @override
  String get foodOnHand => 'Finns i hushållet';

  @override
  String get timelineChildRecipesTitle => 'Lägg även till för länkade recept';

  @override
  String timelineMadeForRecipe(String recipe) {
    return 'Skapat för $recipe';
  }

  @override
  String get timelineFilter => 'Filtrera poster';

  @override
  String get timelineTypeComment => 'Lagat och anteckningar';

  @override
  String get timelineTypeInfo => 'Information';

  @override
  String get timelineTypeSystem => 'System';

  @override
  String get listManagementTitle => 'Inköpslistor';

  @override
  String get managementTitle => 'Mer';

  @override
  String get pinToHome => 'Lägg till på startskärmen';

  @override
  String get unpinFromHome => 'Ta bort från startskärmen';

  @override
  String homeScreenFull(int count) {
    return 'Startskärmen är full – högst $count rutor. Ta först bort en annan ruta under “Mer”.';
  }

  @override
  String get selectAction => 'Markera';

  @override
  String selectedCount(int count) {
    return '$count markerade';
  }

  @override
  String get assignLabelAction => 'Tilldela etikett';

  @override
  String get assignLabelOverwriteHint =>
      'Skriver över etiketten för alla markerade livsmedel.';

  @override
  String deleteSelectedConfirm(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ta bort $count poster?',
      one: 'Ta bort 1 post?',
    );
    return '$_temp0';
  }

  @override
  String get seedDataAction => 'Ladda standarddata';

  @override
  String get seedFoodsHint => 'Skapar Mealies standardlivsmedel på valt språk.';

  @override
  String get seedUnitsHint => 'Skapar Mealies standardenheter på valt språk.';

  @override
  String get seedLanguageLabel => 'Språk';

  @override
  String get seedDuplicateWarning =>
      'Du har redan poster. Mealie hanterar inte dubbletter – du får slå ihop dem själv efteråt.';

  @override
  String get seedDone => 'Standarddata har skapats';

  @override
  String get seedFailed => 'Standarddata kunde inte laddas';

  @override
  String get exportAction => 'Exportera';

  @override
  String get substitutionsLabel => 'Ersättningsingredienser';

  @override
  String get substitutionAddHint => 'Lägg till ersättning';

  @override
  String get substitutionFoodLabel => 'Livsmedel (valfritt)';

  @override
  String get substitutionNoteLabel => 'Anteckning (valfritt)';

  @override
  String get substitutionNeedOne => 'Ange ett livsmedel eller en anteckning';

  @override
  String get useAbbreviationLabel => 'Använd förkortning';

  @override
  String get useAbbreviationHint => 'Visa “g” i stället för “gram” i recept';

  @override
  String get fractionLabel => 'Visa som bråk';

  @override
  String get fractionHint => '½ i stället för 0,5';

  @override
  String get standardizationTitle => 'Standardisering';

  @override
  String get standardizationHint =>
      'För omvandlingar: 1 av den här enheten motsvarar … (t.ex. 1 msk = 15 milliliter).';

  @override
  String get standardQuantityLabel => 'Standardmängd';

  @override
  String get standardUnitLabel => 'Standardenhet';

  @override
  String get standardUnitNone => 'Inga';

  @override
  String get stdFluidOunce => 'Flytande uns (fl oz)';

  @override
  String get stdCup => 'Kopp (US)';

  @override
  String get stdOunce => 'Uns (oz)';

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
  String get editLabel => 'Redigera etikett';

  @override
  String get colorLabel => 'Färg';

  @override
  String labelDeleteConfirm(String name) {
    return 'Ta bort “$name”? Varor och livsmedel förlorar den här etiketten.';
  }

  @override
  String get importMenuAction => 'Importera';

  @override
  String get archivedEmpty =>
      'Inga arkiverade inköp än. Tryck på “Avsluta handlingen” efter att du handlat – de avbockade varorna sparas här.';

  @override
  String get sectionTitleLabel => 'Avsnittets rubrik';

  @override
  String get clearSection => 'Ta bort avsnitt';

  @override
  String get noPermissionGeneric =>
      'Du har inte behörighet till detta i Mealie. Fråga en administratör eller hushållsansvarig.';

  @override
  String get noPermissionEditRecipe =>
      'Du kan inte redigera det här receptet – det är låst eller tillhör ett annat hushåll. Bara skaparen eller en administratör kan.';

  @override
  String get noPermissionDeleteRecipe =>
      'Bara receptets skapare eller en administratör kan ta bort det.';

  @override
  String get noPermissionDemoteSelf =>
      'Du kan inte ta bort dina egna administratörsrättigheter.';

  @override
  String get recipeLockedHint => 'Låst – bara skaparen kan redigera';

  @override
  String get recipeDeleteOwnerOnlyHint =>
      'Bara skaparen eller en administratör kan ta bort';

  @override
  String get organizeReadOnlyHint =>
      'Endast visning: att skapa, ändra och ta bort kräver behörigheten “Användaren kan hantera livsmedel, taggar och kategorier”.';

  @override
  String get notesNotSavedNoPermission =>
      'Anteckningen sparades inte – du har inte behörighet att redigera det här receptet.';

  @override
  String get userManagementTitle => 'Användarhantering';

  @override
  String get editUserTitle => 'Ändra användare';

  @override
  String get fullNameLabel => 'Fullständigt namn';

  @override
  String get usernameLabel => 'Användarnamn';

  @override
  String get emailLabel => 'E-post';

  @override
  String get passwordLabel => 'Lösenord';

  @override
  String get householdLabel => 'Hushåll';

  @override
  String get permissionsTitle => 'Behörigheter';

  @override
  String get administratorLabel => 'Administratör';

  @override
  String get permCanInvite => 'Användaren kan bjuda in andra till gruppen';

  @override
  String get permCanManage => 'Användaren kan hantera gruppinställningar';

  @override
  String get permCanManageHousehold => 'Användaren kan hantera hushållet';

  @override
  String get permCanOrganize =>
      'Användaren kan hantera livsmedel, taggar och kategorier';

  @override
  String get advancedFeaturesLabel => 'Aktivera avancerade funktioner';

  @override
  String get passwordResetLinkAction =>
      'Generera länk för lösenordsåterställning';

  @override
  String get resetLockedUsersAction => 'Lås upp låsta användarkonton';

  @override
  String get inviteLinkTitle => 'Inbjudningslänk';

  @override
  String get inviteAction => 'Bjud in';

  @override
  String get userUpdated => 'Användare uppdaterad';

  @override
  String get createUserTitle => 'Skapa användare';

  @override
  String get userCreated => 'Användaren har skapats';

  @override
  String userDeleteConfirm(String name) {
    return 'Ta bort “$name”? Kontot tas bort från Mealie.';
  }

  @override
  String get passwordResetLinkCopied =>
      'Länken har kopierats – ge den till användaren. Den gäller bara en begränsad tid.';

  @override
  String lockedUsersReset(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count användare upplåsta',
      one: '1 användare upplåst',
      zero: 'Inga låsta användare',
    );
    return '$_temp0';
  }

  @override
  String get inviteUsesLabel => 'Antal användningar';

  @override
  String get inviteCreated => 'Inbjudningslänken har skapats';

  @override
  String get inviteEmailHint =>
      'E-postadress (valfritt – Mealie skickar inbjudan)';

  @override
  String get inviteEmailSent => 'Inbjudan har skickats via e-post';

  @override
  String get inviteEmailFailed =>
      'E-postmeddelandet kunde inte skickas (är SMTP konfigurerat i Mealie?). Länken fungerar ändå.';

  @override
  String get copyLinkAction => 'Kopiera länk';

  @override
  String get youLabel => 'Du';

  @override
  String get membersPermissionsHint =>
      'Du kan ändra behörigheterna för hushållets medlemmar – men inte dina egna.';

  @override
  String get householdManagementTitle => 'Hushållshantering';

  @override
  String get householdsTitle => 'Hushåll';

  @override
  String get createHouseholdTitle => 'Skapa hushåll';

  @override
  String get householdNameLabel => 'Hushållets namn';

  @override
  String get householdPreferencesTitle => 'Hushållets inställningar';

  @override
  String get privateHouseholdLabel => 'Privat hushåll';

  @override
  String get privateHouseholdHint =>
      'Om du gör hushållet privat stängs all offentlig visning av. Det gäller även om du har valt offentlig visning för enskilda recept.';

  @override
  String get lockRecipeEditsLabel =>
      'Hindra andra hushåll från att redigera recept';

  @override
  String get lockRecipeEditsHint =>
      'När inställningen är aktiverad kan endast medlemmar i ditt hushåll redigera recept som hushållet har skapat.';

  @override
  String get householdRecipePreferencesTitle =>
      'Hushållets receptinställningar';

  @override
  String get groupsTitle => 'Grupper';

  @override
  String get groupLabel => 'Grupp';

  @override
  String get createGroupTitle => 'Skapa grupp';

  @override
  String get groupNameLabel => 'Gruppnamn';

  @override
  String get groupPreferencesTitle => 'Gruppinställningar';

  @override
  String get privateGroupLabel => 'Privat grupp';

  @override
  String get privateGroupHint =>
      'Om du gör gruppen privat stängs all offentlig visning av. Det gäller även om du har valt offentlig visning för enskilda recept.';

  @override
  String get firstDayOfWeekLabel => 'Första dagen i veckan';

  @override
  String get showAnnouncementsLabel => 'Visa meddelanden från Mealie';

  @override
  String get recipePublicDefaultLabel =>
      'Tillåt användare utanför din grupp att se dina recept';

  @override
  String get recipeShowNutritionDefaultLabel => 'Visa näringsinnehåll';

  @override
  String get recipeShowAssetsDefaultLabel => 'Visa receptbilagor';

  @override
  String get recipeLandscapeDefaultLabel => 'Använd liggande vy som standard';

  @override
  String get recipeDisableCommentsDefaultLabel =>
      'Stäng av kommentarer på recept';

  @override
  String get myHouseholdSection => 'Mitt hushåll';

  @override
  String get myGroupSection => 'Min grupp';

  @override
  String get preferencesSaved => 'Inställningarna har sparats';

  @override
  String get cannotDeleteWithUsers =>
      'Har fortfarande användare – flytta eller ta bort dem i Användarhantering först.';

  @override
  String deleteHouseholdConfirm(String name) {
    return 'Ta bort hushållet “$name”?';
  }

  @override
  String deleteGroupConfirm(String name) {
    return 'Ta bort gruppen “$name”?';
  }

  @override
  String usersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count användare',
      one: '1 användare',
      zero: 'Inga användare',
    );
    return '$_temp0';
  }

  @override
  String get originalUrlLabel => 'Ursprunglig webbadress';

  @override
  String get copyTextAction => 'Kopiera text';

  @override
  String get copiedToClipboard => 'Kopierat till urklipp';

  @override
  String get changelogEnglishHint =>
      'Versionsinformationen finns bara på engelska.';

  @override
  String get favoritesTitle => 'Favoriter';

  @override
  String get favoritesEmpty =>
      'Inga favoriter än. Tryck på hjärtat på ett recept för att samla det här.';

  @override
  String get changelogTitle => 'Nyheter';

  @override
  String get changeProfileImage => 'Byt profilbild';

  @override
  String get profileImageUpdated => 'Profilbilden har uppdaterats';

  @override
  String get profileImageFailed => 'Profilbilden kunde inte laddas upp';

  @override
  String get myAccountTitle => 'Mitt konto';

  @override
  String get ownAccountHint =>
      'Här kan du redigera ditt eget konto. Andra användare hanteras av administratörer och medlemmar med behörigheten “hantera”.';

  @override
  String get changePasswordAction => 'Byt lösenord';

  @override
  String get currentPasswordLabel => 'Nuvarande lösenord';

  @override
  String get newPasswordLabel => 'Nytt lösenord';

  @override
  String get confirmPasswordLabel => 'Bekräfta lösenord';

  @override
  String get passwordTooShort => 'Minst 8 tecken';

  @override
  String get passwordsDoNotMatch => 'Lösenorden matchar inte';

  @override
  String get passwordUpdated => 'Lösenordet har uppdaterats';

  @override
  String get passwordChangeFailed => 'Lösenordet kunde inte ändras';

  @override
  String passwordManagedExternally(String method) {
    return 'Du loggar in via $method — byt lösenord där.';
  }

  @override
  String get bulkAddHint => 'En rad per post.';

  @override
  String bulkAddCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Lägg till $count poster',
      one: 'Lägg till 1 post',
    );
    return '$_temp0';
  }

  @override
  String get linkRecipeAction => 'Länka recept';

  @override
  String get useFoodAction => 'Använd livsmedel i stället för recept';

  @override
  String get addSubstitutionsAction => 'Lägg till ersättningar';

  @override
  String get clearSubstitutionsAction => 'Rensa ersättningar';

  @override
  String get recipeSubstitutionsTitle => 'Ersättningsingredienser';

  @override
  String get substitutionUnknownFood =>
      'Endast befintliga livsmedel – använd annars anteckningen';

  @override
  String get insertAboveAction => 'Infoga ovanför';

  @override
  String get insertBelowAction => 'Infoga nedanför';

  @override
  String get moveToTopAction => 'Flytta överst';

  @override
  String get moveToBottomAction => 'Flytta längst ned';

  @override
  String get linkReferencesAction => 'Koppla referenser';

  @override
  String get editMarkdownAction => 'Redigera Markdown';

  @override
  String get previewMarkdownAction => 'Förhandsgranska Markdown';

  @override
  String get insertStepImageAction => 'Ladda upp bild';

  @override
  String get mergeAboveAction => 'Slå ihop med ovanstående';

  @override
  String get linkedToOtherStep => 'Kopplad till ett annat steg';

  @override
  String get noNotesToLink => 'Inga anteckningar att koppla';

  @override
  String get ownerLabel => 'Ägare';

  @override
  String get ingredientParserTitle => 'Ingredienstolk';

  @override
  String ingredientParserHint(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count ingredienser är inte strukturerade än. Välj en tolk, kontrollera resultatet, tillämpa.',
      one:
          '1 ingrediens är inte strukturerad än. Välj en tolk, kontrollera resultatet, tillämpa.',
    );
    return '$_temp0';
  }

  @override
  String get parserNlp => 'Språkbaserad tolk';

  @override
  String get parserBrute => 'Enkel tolk';

  @override
  String get parserOpenai => 'OpenAI-tolk';

  @override
  String get parserApp => 'Offline (app)';

  @override
  String get parseFailed => 'Tolkningen misslyckades';

  @override
  String get parseAction => 'Tolka';

  @override
  String applyParsedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tillämpa $count ingredienser',
      one: 'Tillämpa 1 ingrediens',
      zero: 'Inget valt',
    );
    return '$_temp0';
  }

  @override
  String get parsedNewBadge => 'ny';

  @override
  String get hoursShort => 'h';

  @override
  String get minutesShort => 'min';

  @override
  String get timeExtraHint => 'Extra, t.ex. “plus över natten”';

  @override
  String get yieldLabel => 'Färdig mängd';

  @override
  String get yieldTextLabel => 'Beskrivning av färdig mängd';

  @override
  String get prepTimeLabel => 'Förberedelsetid';

  @override
  String get performTimeLabel => 'Tillagningstid';

  @override
  String get totalTimeLabel => 'Total tid';

  @override
  String get settingPublicRecipe => 'Offentligt recept';

  @override
  String get settingShowNutrition => 'Visa näringsvärden';

  @override
  String get settingShowAssets => 'Visa bilagor';

  @override
  String get settingLandscapeView => 'Liggande vy';

  @override
  String get settingDisableComments => 'Inaktivera kommentarer';

  @override
  String get settingDisableAmount => 'Inaktivera ingrediensmängder';

  @override
  String get settingLocked => 'Låst';

  @override
  String get settingLockedOwnerOnly =>
      'Bara skaparen kan låsa eller låsa upp receptet.';

  @override
  String get apiExtrasTitle => 'API-tillägg';

  @override
  String get apiExtrasHint =>
      'Egna nyckel/värde-par för tredjepartsappar, t.ex. för att starta automatiseringar.';

  @override
  String get extraKeyLabel => 'Nyckel';

  @override
  String get extraValueLabel => 'Värde';

  @override
  String get addExtraAction => 'Lägg till extra';

  @override
  String durationHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count timmar',
      one: '1 timme',
    );
    return '$_temp0';
  }

  @override
  String durationMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minuter',
      one: '1 minut',
    );
    return '$_temp0';
  }

  @override
  String get discardChangesConfirm => 'Kasta osparade ändringar?';

  @override
  String get discardChanges => 'Förkasta ändringar';

  @override
  String get imageFromUrl => 'Bild från URL';

  @override
  String get deleteRecipeImage => 'Ta bort receptbild';

  @override
  String get deleteRecipeImageConfirm =>
      'Är du säker på att du vill ta bort den här receptbilden?';

  @override
  String get bulkAddIngredients => 'Lägg till flera ingredienser';

  @override
  String get bulkAddSteps => 'Lägg till flera steg';

  @override
  String get stepImageFailed => 'Bilden kunde inte laddas upp';

  @override
  String get servingsAndTimes => 'Portioner och tider';

  @override
  String get recipeSettingsTitle => 'Receptinställningar';

  @override
  String get jsonEditorTitle => 'JSON-redigerare';

  @override
  String get jsonInvalid => 'Ogiltig JSON – kontrollera.';

  @override
  String get editorOfflineHint =>
      'Öppnat offline: för att spara krävs en anslutning. Nyare Mealie-fält (t.ex. ersättningar) lämnas oförändrade.';

  @override
  String get parseLineFailed => 'Kändes inte igen – lämnas oförändrad';

  @override
  String get createManualTitle => 'Skapa recept manuellt';

  @override
  String get createManualHint =>
      'Ange ett namn – ingredienser, steg, bild och allt annat lägger du till efteråt i recepteditorn.';

  @override
  String get createManualButton => 'Skapa och redigera';

  @override
  String get changelogEmpty => 'Inga poster för den här versionen än.';

  @override
  String get finderDescription =>
      'Sök efter recept utifrån de ingredienser du har hemma. Du kan också filtrera efter de redskap du har och ange hur många ingredienser eller redskap som får saknas.';

  @override
  String get finderSelectedIngredients => 'Valda ingredienser';

  @override
  String get finderNoIngredientsSelected => 'Inga ingredienser valda';

  @override
  String get finderMissing => 'Saknas';

  @override
  String get finderNoRecipesFound => 'Inga recept hittades';

  @override
  String get finderNoRecipesFoundDescription =>
      'Prova att lägga till fler ingredienser i sökningen eller ändra filtren';

  @override
  String get finderIncludeFoodsOnHand => 'Ta med ingredienser som finns hemma';

  @override
  String get finderIncludeToolsOnHand => 'Ta med redskap som finns hemma';

  @override
  String get finderIncludeSubstitutions => 'Ta med ersättningsingredienser';

  @override
  String get finderSubstituting => 'Ersätter med';

  @override
  String finderSubstituteForFood(String substitute, String food) {
    return '$substitute i stället för $food';
  }

  @override
  String get finderMaxMissingIngredients =>
      'Högsta antal ingredienser som får saknas';

  @override
  String get finderMaxMissingTools => 'Högsta antal redskap som får saknas';

  @override
  String get finderSelectedTools => 'Valda redskap';

  @override
  String get finderReadyToMake => 'Redo att laga';

  @override
  String get finderAlmostReadyToMake => 'Nästan redo att laga';

  @override
  String get finderSettings => 'Inställningar';

  @override
  String get finderLoadingRecipes => 'Läser in recept';

  @override
  String get finderClearSelection => 'Rensa markering';

  @override
  String get finderOfflineHint =>
      'Ingen anslutning till servern – resultaten kommer från recepten som sparats på den här enheten.';

  @override
  String get sendPeerOfflineHint =>
      'Inte nåbar just nu – kommer fram när appen öppnas där';

  @override
  String sendDeliveredLater(String device) {
    return '“$device” är inte nåbar just nu. Receptet kommer fram så snart appen öppnas där.';
  }

  @override
  String get sendQueuedOffline =>
      'Ingen anslutning just nu. Receptet skickas automatiskt så snart du är online igen.';

  @override
  String get searchHasAll => 'Innehåller alla';

  @override
  String get searchHasAny => 'Innehåller minst en';

  @override
  String get recipeFilterTitle => 'Filter';

  @override
  String get finderOtherFilters => 'Andra filter';

  @override
  String get qfOpEquals => 'lika med';

  @override
  String get qfOpNotEquals => 'inte lika med';

  @override
  String get qfOpGreater => 'är större än';

  @override
  String get qfOpGreaterEq => 'är större än eller lika med';

  @override
  String get qfOpLess => 'är mindre än';

  @override
  String get qfOpLessEq => 'är mindre än eller lika med';

  @override
  String get qfOpNewerThan => 'är nyare än';

  @override
  String get qfOpOlderThan => 'är äldre än';

  @override
  String qfDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'för $count dagar sedan',
      one: 'för 1 dag sedan',
    );
    return '$_temp0';
  }

  @override
  String get filterResetAll => 'Återställ alla filter';

  @override
  String get filterAny => 'Alla';

  @override
  String get filterOfflineIgnored =>
      'Offline kan “Andra filter” bara tillämpas i sin enkla form.';

  @override
  String linkedRecipesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count länkade recept',
      one: 'Ett länkat recept',
      zero: 'Inga länkade recept',
    );
    return '$_temp0';
  }

  @override
  String get shoppingReminderNotificationsOff =>
      'Aviseringar är avstängda för Mealie Recipes — utan dem kan inköpspåminnelsen inte visas. Tillåt aviseringar i inställningarna.';

  @override
  String get shoppingReminderInactiveHint =>
      'Inköpspåminnelsen kan inte fungera just nu: ställ in platsåtkomst på “Alltid” och tillåt aviseringar.';

  @override
  String get bulkImportTitle => 'Importera från flera webbadresser';

  @override
  String get bulkImportDescription =>
      'Med massimport kan du importera flera recept samtidigt. Webbplatserna läggs i kö på servern och recepten hämtas i bakgrunden. Det är praktiskt när du går över till Mealie eller vill importera många recept.';

  @override
  String get bulkAddTitle => 'Lägg till flera';

  @override
  String get bulkImportSetOrganizers => 'Ange kategorier och taggar';

  @override
  String get bulkImportStarted => 'Massimporten har startat';

  @override
  String get bulkImportFailed => 'Massimporten misslyckades';

  @override
  String get bulkImportReports => 'Massimporter';

  @override
  String get bulkImportUrlHint => 'Receptets webbadress';

  @override
  String get migrationsTitle => 'Datamigreringar';

  @override
  String get migrationsDescription =>
      'Du kan komma igång med Mealie genom att importera recept från ett program som Mealie stöder. Använd verktygen för säkerhetskopiering och återställning om du vill flytta data mellan Mealie-instanser eller återställa en äldre säkerhetskopia av Mealie.';

  @override
  String get migrationNew => 'Ny migrering';

  @override
  String get migrationChooseType => 'Välj migreringstyp';

  @override
  String get noFileSelected => 'Ingen fil vald';

  @override
  String migrationTagAll(String tag) {
    return 'Tagga alla recept med taggen $tag';
  }

  @override
  String get migrationPrevious => 'Tidigare migreringar';

  @override
  String get migrationMealieDescription =>
      'Mealie kan importera recept från Mealie-versioner före 1.0. Exportera recepten från din gamla instans och ladda upp zip-filen nedan. Det går bara att importera recepten från exporten. Använd verktygen för säkerhetskopiering och återställning för säkerhetskopior från version 1.0 eller senare.';

  @override
  String get migrationChowdownDescription =>
      'Mealie har inbyggt stöd för Chowdowns kodförrådsformat. Ladda ner kodförrådet som en .zip-fil och ladda upp filen nedan.';

  @override
  String get migrationCopyMeThatDescription =>
      'Mealie kan importera recept från Copy Me That. Exportera dina recept i HTML-format och ladda sedan upp .zip-filen nedan.';

  @override
  String get migrationMyRecipeBoxDescription =>
      'Mealie kan importera recept från My Recipe Box. Exportera dina recept i CSV-format och ladda sedan upp .csv-filen nedan.';

  @override
  String get migrationNextcloudDescription =>
      'Du kan importera Nextcloud-recept från en zip-fil med data från Nextcloud. Kontrollera att mapparna ligger som i exemplet nedan så att recepten kan importeras.';

  @override
  String get migrationPaprikaDescription =>
      'Mealie kan importera recept från Paprika. Exportera dina recept från Paprika, ändra filändelsen till .zip och ladda upp filen nedan.';

  @override
  String get migrationPlanToEatDescription =>
      'Mealie kan importera recept från Plan to Eat. Ladda upp ett zip-arkiv eller en CSV- eller TXT-fil som du har exporterat från Plan to Eat.';

  @override
  String get migrationRecipeKeeperDescription =>
      'Mealie kan importera recept från Recipe Keeper. Exportera dina recept i zip-format och ladda sedan upp .zip-filen nedan.';

  @override
  String get migrationTandoorDescription =>
      'Mealie kan importera recept från Tandoor. Exportera dina data i formatet ”Default” och ladda sedan upp .zip-filen nedan.';

  @override
  String get migrationCooknDescription =>
      'Mealie kan importera recept från DVO Cook\'n X3. Exportera en kokbok eller meny i formatet ”Cook\'n”, ändra filändelsen till .zip och ladda sedan upp filen nedan.';

  @override
  String get reportTitle => 'Rapport';

  @override
  String get recipeDataTitle => 'Receptdata';

  @override
  String get recipeDataDescription =>
      'Här kan du hantera dina recept och göra ändringar i flera recept samtidigt. Du kan exportera dem, ta bort dem, tagga dem eller tilldela dem kategorier.';

  @override
  String get recipeDataTagTitle => 'Tagga recept';

  @override
  String get recipeDataCategorizeTitle => 'Kategorisera recept';

  @override
  String get recipeDataSettingsTitle => 'Uppdatera inställningar';

  @override
  String get recipeDataExportTitle => 'Exportera recept';

  @override
  String get recipeDataDeleteTitle => 'Radera recept';

  @override
  String recipeDataExportConfirm(int count) {
    return 'Följande recept ($count) kommer att exporteras.';
  }

  @override
  String get recipeDataExportsTitle => 'Dataexport';

  @override
  String get recipeDataExportsDescription =>
      'Här finns länkar till exporter som är klara att ladda ner. Ladda ner dem innan de löper ut.';

  @override
  String get recipeDataPurgeExports => 'Rensa exporter';

  @override
  String get recipeDataPurgeConfirm =>
      'Är du säker på att du vill ta bort all exportdata?';

  @override
  String get recipeActionsTitle => 'Receptåtgärder';

  @override
  String get recipeActionNew => 'Ny receptåtgärd';

  @override
  String get recipeActionEdit => 'Redigera receptåtgärd';

  @override
  String get recipeActionTypeLink => 'Länk';

  @override
  String get recipeActionTypePost => 'POST';

  @override
  String get webhooksTitle => 'Webhooks';

  @override
  String get webhooksDescription =>
      'När en måltid har planerats för dagen skickas webhooks enligt inställningarna nedan. Varje webhook innehåller data från dagens recept. Körningen sker med fem minuters intervall, så den faktiska tidpunkten kan avvika med upp till fem minuter från den schemalagda tiden.';

  @override
  String get webhookName => 'Namn på webhook';

  @override
  String get webhookUrl => 'Webhook-URL';

  @override
  String get notifiersTitle => 'Aviseringstjänster';

  @override
  String get notifiersDescription =>
      'Ställ in e-postmeddelanden och pushaviseringar för särskilda händelser.';

  @override
  String get notifierNew => 'Ny avisering';

  @override
  String get notifierDescription =>
      'Mealie använder biblioteket Apprise för att skicka aviseringar via olika tjänster. I Apprises wiki finns anvisningar för hur du skapar en URL för din tjänst. Om det går att välja aviseringstyp kan valet ge tillgång till fler funktioner.';

  @override
  String get notifierAppriseUrl => 'Apprise-URL';

  @override
  String get notifierAppriseUrlSkipped =>
      'Apprise-URL (utelämnas om fältet är tomt)';

  @override
  String get notifierAppriseUrlBlankHint =>
      'Apprise-adresser innehåller ofta känsliga uppgifter. Därför visas inte den aktuella adressen när du redigerar. Ange en ny adress här om du vill ändra den eller lämna fältet tomt för att behålla den nuvarande.';

  @override
  String get notifierEnable => 'Aktivera avisering';

  @override
  String get notifierWhatEvents => 'Vilka händelser ska ge en avisering?';

  @override
  String get notifierRecipeEvents => 'Recepthändelser';

  @override
  String get notifierUserEvents => 'Användarhändelser';

  @override
  String get notifierMealplanEvents => 'Händelser i måltidsplanen';

  @override
  String get notifierShoppingListEvents => 'Händelser i inköpslistan';

  @override
  String get notifierCookbookEvents => 'Kokbokshändelser';

  @override
  String get notifierTagEvents => 'Tagghändelser';

  @override
  String get notifierCategoryEvents => 'Kategorihändelser';

  @override
  String get notifierLabelEvents => 'Etiketthändelser';

  @override
  String get notifierUserSignup => 'När en ny användare går med i din grupp';

  @override
  String get notifierCreate => 'Skapa';

  @override
  String get notifierUpdate => 'Uppdatera';

  @override
  String get notifierDelete => 'Ta bort';

  @override
  String get notifierTestSent => 'Testmeddelandet har skickats';

  @override
  String get adminTitle => 'Administratörsinställningar';

  @override
  String get backupsTitle => 'Säkerhetskopior';

  @override
  String get backupsDescription =>
      'En säkerhetskopia innehåller hela webbplatsens databas och datakatalog så som de såg ut vid ett visst tillfälle. Det går inte att undanta delar av innehållet. Oavsett vilken databas du använder kan du exportera och importera data på det här sättet eller spara en säkerhetskopia av webbplatsen på en extern plats.';

  @override
  String get backupCreateHeading => 'Skapa en säkerhetskopia';

  @override
  String get backupCreated => 'Säkerhetskopian skapades';

  @override
  String get backupCreateFailed =>
      'Det gick inte att skapa säkerhetskopian. Se loggfilen.';

  @override
  String get backupDelete => 'Ta bort säkerhetskopian';

  @override
  String get backupDeleted => 'Säkerhetskopian togs bort';

  @override
  String get backupRestore => 'Återställ säkerhetskopia';

  @override
  String get backupRestoreDescription =>
      'Om du återställer den här säkerhetskopian skrivs all aktuell data i databasen och datakatalogen över med innehållet i säkerhetskopian. Lyckas återställningen loggas du ut.';

  @override
  String get backupCannotBeUndone => 'Åtgärden kan inte ångras. Var försiktig.';

  @override
  String get backupAcknowledge =>
      'Jag förstår att denna åtgärd är oåterkallelig, destruktiv och kan orsaka dataförlust';

  @override
  String get backupRestoreSuccess => 'Återställning slutförd';

  @override
  String get backupRestoreFailed =>
      'Återställningen misslyckades. Mer information finns i serverloggarna.';

  @override
  String get maintenanceTitle => 'Underhåll';

  @override
  String get maintenanceSummary => 'Sammanfattning';

  @override
  String get maintenanceStorage => 'Lagringsinformation';

  @override
  String get maintenanceDataDirSize => 'Datakatalogens storlek';

  @override
  String get maintenanceCleanableDirs => 'Rensbara mappar';

  @override
  String get maintenanceCleanableImages => 'Rensbara bilder';

  @override
  String get maintenanceTempDir => 'Tillfällig mapp (.temp)';

  @override
  String get maintenanceBackupsDir => 'Katalog för säkerhetskopior (backups)';

  @override
  String get maintenanceGroupsDir => 'Gruppkatalog (groups)';

  @override
  String get maintenanceRecipesDir => 'Receptkatalog (recipes)';

  @override
  String get maintenanceUserDir => 'Användarkatalog (user)';

  @override
  String get maintenanceCleanDirs => 'Rensa mappar';

  @override
  String get maintenanceCleanDirsDescription =>
      'Tar bort alla receptmappar vars namn inte är giltiga UUID:n';

  @override
  String get maintenanceCleanTemp => 'Rensa tillfälliga filer';

  @override
  String get maintenanceCleanTempDescription =>
      'Tar bort alla filer och mappar i .temp-katalogen';

  @override
  String get maintenanceCleanImages => 'Rensa bilder';

  @override
  String get maintenanceCleanImagesDescription =>
      'Tar bort alla bilder som inte slutar med .webp';

  @override
  String get maintenanceActions => 'Åtgärder';

  @override
  String get adminConfiguration => 'Konfiguration';

  @override
  String get adminAppVersion => 'Programversion';

  @override
  String get adminUpToDate => 'Mealie är uppdaterat';

  @override
  String adminVersionOutdated(String current, String latest) {
    return 'Din nuvarande version ($current) motsvarar inte den senaste versionen. Överväg att uppdatera till den senaste versionen ($latest).';
  }

  @override
  String get adminBaseUrl => 'Serverns bas-URL';

  @override
  String get adminBaseUrlOk =>
      'Serverns bas-URL skiljer sig från standardvärdet';

  @override
  String get adminBaseUrlError =>
      '`BASE_URL` har fortfarande sitt standardvärde på API-servern. Det ger problem med länkar som servern skapar för aviseringar, exempelvis i e-postmeddelanden.';

  @override
  String adminAuthReady(String provider) {
    return '$provider är redo';
  }

  @override
  String adminAuthNotReady(String provider) {
    return '$provider är inte redo';
  }

  @override
  String adminAuthDisabled(String provider) {
    return '$provider är inaktiverat';
  }

  @override
  String adminAuthSuccessText(String provider) {
    return 'Alla obligatoriska variabler för $provider har angetts.';
  }

  @override
  String adminAuthErrorText(String provider) {
    return 'Vissa inställningar för $provider saknas. Du kan bortse från detta om du inte använder $provider för autentisering.';
  }

  @override
  String adminAuthDisabledText(String envVar) {
    return 'Aktivera funktionen genom att sätta $envVar till true.';
  }

  @override
  String get adminEmailStatus => 'Status för e-postinställningar';

  @override
  String get adminEmailConfigured => 'E-post konfigurerad';

  @override
  String get adminNotReady => 'Inte redo – kontrollera miljövariablerna';

  @override
  String get adminSucceeded => 'Lyckades';

  @override
  String get adminFailed => 'Misslyckades';

  @override
  String get adminSiteStatistics => 'Webbplatsstatistik';

  @override
  String get adminUncategorized => 'Recept utan kategori';

  @override
  String get adminUntagged => 'Recept utan taggar';

  @override
  String get adminGeneralAbout => 'Allmänt om';

  @override
  String get adminVersion => 'Version';

  @override
  String get adminBuild => 'Bygge';

  @override
  String get adminApplicationMode => 'Applikationsläge';

  @override
  String get adminProduction => 'Produktion';

  @override
  String get adminDevelopment => 'Utveckling';

  @override
  String get adminDemoStatus => 'Demoläge';

  @override
  String get adminDemo => 'Demo';

  @override
  String get adminNotDemo => 'Inte demo';

  @override
  String get adminApiPort => 'API-port';

  @override
  String get adminApiDocs => 'API-dokumentation';

  @override
  String get adminDatabaseType => 'Databastyp';

  @override
  String get adminDatabaseUrl => 'Databas-URL';

  @override
  String get adminDefaultGroup => 'Standardgrupp';

  @override
  String get adminDefaultHousehold => 'Standardhushåll';

  @override
  String get adminScraperVersion => 'Version av biblioteket för recepthämtning';

  @override
  String get adminStatUsers => 'Användare';

  @override
  String get adminStatHouseholds => 'Hushåll';

  @override
  String get adminStatGroups => 'Grupper';

  @override
  String get recipeDuplicate => 'Duplicera recept';

  @override
  String get recipeDuplicateAction => 'Duplicera';

  @override
  String get recipeShareLink => 'Dela recept';

  @override
  String get recipeShareExpiration => 'Utgångsdatum';

  @override
  String get recipeShareCopied => 'Receptlänken har kopierats till urklipp';

  @override
  String get enabledLabel => 'Aktiverad';

  @override
  String get disabledLabel => 'Inaktiverad';

  @override
  String get testAction => 'Testa';

  @override
  String get yesLabel => 'Ja';

  @override
  String get noLabel => 'Nej';

  @override
  String get downloadAction => 'Ladda ner';

  @override
  String get backupUpload => 'Ladda upp';

  @override
  String get zipImportButton => 'Importera från zip';

  @override
  String get zipImportDescription =>
      'Importera ett enstaka recept som exporterades från en annan Mealie-instans.';

  @override
  String get reportStatus => 'Status';

  @override
  String get reportDate => 'Datum';

  @override
  String get recipeActionTitleLabel => 'Rubrik';

  @override
  String get clearAll => 'Rensa';

  @override
  String get recipeDataSettingsExplanation =>
      'Inställningarna du väljer här tillämpas på alla markerade recept, med undantag för alternativet som styr om receptet är låst.';

  @override
  String get adminAllowSignup => 'Tillåt registrering';

  @override
  String get adminAllowPasswordLogin => 'Tillåt inloggning med lösenord';

  @override
  String get adminEmailInvalid => 'Ange en giltig e-postadress.';

  @override
  String adminEmailTestResult(String result) {
    return 'E-posttest: $result';
  }

  @override
  String get adminSendTestEmail => 'Skicka testmejl';

  @override
  String get adminTestEmailAddress => 'Mottagare';

  @override
  String get backupCreate => 'Skapa säkerhetskopia';

  @override
  String backupDeleteConfirm(String name) {
    return 'Ta bort säkerhetskopian “$name”?';
  }

  @override
  String get backupPostgresNote =>
      'Om du använder PostgreSQL, läs om säkerhetskopiering/återställning i Mealies dokumentation innan du återställer.';

  @override
  String get backupUploaded => 'Säkerhetskopian har laddats upp';

  @override
  String get backupsEmpty => 'Inga säkerhetskopior än.';

  @override
  String get bulkImportAddRow => 'Lägg till URL';

  @override
  String get bulkImportStart => 'Starta import';

  @override
  String get chooseFileButton => 'Välj fil';

  @override
  String get deselectAllAction => 'Avmarkera alla';

  @override
  String get downloadFailed => 'Nedladdningen misslyckades';

  @override
  String get fileSaved => 'Filen har sparats';

  @override
  String get loadFailed => 'Kunde inte laddas';

  @override
  String get maintenanceActionsWarning =>
      'Underhållsåtgärder är destruktiva och ska användas med försiktighet. Att utföra någon av dem går inte att ångra.';

  @override
  String get maintenanceConfirm =>
      'Den här åtgärden är destruktiv och kan inte ångras. Fortsätta?';

  @override
  String get maintenanceDone => 'Färdig';

  @override
  String get maintenanceFailed => 'Underhållsåtgärden misslyckades';

  @override
  String get maintenanceRun => 'Kör';

  @override
  String get migrationFailed => 'Migreringen misslyckades';

  @override
  String get migrationStart => 'Starta migrering';

  @override
  String get migrationStarted => 'Migreringen är klar — se rapporten nedan.';

  @override
  String get moreImportOptions => 'Fler importalternativ';

  @override
  String notifierDeleteConfirm(String name) {
    return 'Ta bort aviseraren “$name”?';
  }

  @override
  String get notifierEdit => 'Redigera aviserare';

  @override
  String notifierEventCount(int count) {
    return 'Händelser: $count';
  }

  @override
  String get notifierTestFailed => 'Testmeddelandet kunde inte skickas';

  @override
  String get notifiersEmpty => 'Inga aviserare än.';

  @override
  String recipeActionDeleteConfirm(String name) {
    return 'Ta bort receptåtgärden “$name”?';
  }

  @override
  String get recipeActionFailed => 'Receptåtgärden misslyckades';

  @override
  String get recipeActionSent => 'Receptet har skickats';

  @override
  String get recipeActionUrlHint => 'Platshållare';

  @override
  String get recipeActionsDescription =>
      'Receptåtgärder visas i menyn för varje recept. “Länk” öppnar URL:en, “Post” låter Mealie-servern skicka receptet till URL:en.';

  @override
  String get recipeActionsEmpty => 'Inga receptåtgärder än.';

  @override
  String recipeDataDeleteConfirm(int count) {
    return 'Ta bort valda recept ($count)? Åtgärden kan inte ångras.';
  }

  @override
  String recipeDataDeleteForbidden(int count) {
    return 'Du får inte ta bort $count av de valda recepten (bara skaparen eller en administratör kan).';
  }

  @override
  String recipeDataDeleted(int count) {
    return 'Borttagna recept: $count';
  }

  @override
  String get recipeDataExportAction => 'Exportera';

  @override
  String get recipeDataExportDone =>
      'Exporten har skapats — ladda ner den under Dataexporter.';

  @override
  String recipeDataExportExpires(String date) {
    return 'upphör $date';
  }

  @override
  String get recipeDataExportFailed => 'Exporten misslyckades';

  @override
  String get recipeDataExportsEmpty => 'Inga exporter tillgängliga.';

  @override
  String recipeDataUpdated(int count) {
    return 'Uppdaterade recept: $count';
  }

  @override
  String get recipeDuplicated => 'Receptet har duplicerats';

  @override
  String get recipeExportJson => 'Exportera som JSON';

  @override
  String get recipeExportZip => 'Exportera som ZIP (med bild)';

  @override
  String get recipeShareCreate => 'Skapa länk';

  @override
  String get recipeShareDescription =>
      'Alla med länken kan se receptet i webbläsaren — utan konto — tills den upphör.';

  @override
  String get recipeShareEmpty => 'Inga delningslänkar än.';

  @override
  String recipeShareExpiresAt(String date) {
    return 'Upphör $date';
  }

  @override
  String get recipeWebToolsMenu => 'Duplicera, delningslänk och mer';

  @override
  String get reload => 'Ladda om';

  @override
  String get reportDeleteConfirm => 'Ta bort den här rapporten?';

  @override
  String get reportEntries => 'Poster';

  @override
  String get reportFailedEntries => 'Misslyckades';

  @override
  String get reportOnlyFailed => 'Visa bara misslyckade poster';

  @override
  String get reportStatusFailure => 'Misslyckades';

  @override
  String get reportStatusInProgress => 'Pågår';

  @override
  String get reportStatusPartial => 'Delvis';

  @override
  String get reportStatusSuccess => 'Lyckades';

  @override
  String get reportsEmpty => 'Inga rapporter än.';

  @override
  String get uploadFailed => 'Uppladdningen misslyckades';

  @override
  String webhookDeleteConfirm(String name) {
    return 'Ta bort webhooken “$name”?';
  }

  @override
  String get webhookEdit => 'Redigera webhook';

  @override
  String get webhookNew => 'Ny webhook';

  @override
  String get webhookTestFailed => 'Testet kunde inte startas';

  @override
  String get webhookTestSent => 'Testwebhook utlöst';

  @override
  String get webhookTime => 'Tid (lokal)';

  @override
  String get webhooksEmpty => 'Inga webhooks än.';

  @override
  String get zipImportFailed => 'ZIP-importen misslyckades';

  @override
  String get aiProvidersTitle => 'AI-leverantörer';

  @override
  String get aiProvidersDescription =>
      'Ställ in AI-leverantörer för att bland annat få bättre ingredienstolkning och kunna skapa recept från videor.';

  @override
  String get aiProviderSettingsTitle => 'Inställningar för AI-leverantörer';

  @override
  String get aiProvidersList => 'Leverantörer';

  @override
  String get aiProviderCreate => 'Skapa leverantör';

  @override
  String get aiProviderEdit => 'Ändra leverantör';

  @override
  String get aiDefaultProvider => 'Standardleverantör';

  @override
  String get aiDefaultProviderDescription =>
      'Krävs för att aktivera AI-funktioner';

  @override
  String get aiAudioProvider => 'Ljudleverantör';

  @override
  String get aiAudioProviderDescription =>
      'Möjliggör funktioner för ljudtranskription, till exempel att skapa recept från videor';

  @override
  String get aiImageProvider => 'Bildleverantör';

  @override
  String get aiImageProviderDescription =>
      'Möjliggör bildigenkänningsfunktioner, till exempel att skapa recept från bilder';

  @override
  String get aiProviderName => 'Leverantörsnamn';

  @override
  String get aiApiKey => 'API-nyckel';

  @override
  String get aiApiKeyCreateDescription =>
      'Ange leverantörens API-nyckel för autentisering. Du behöver fylla i fältet även om tjänsten du använder, till exempel Ollama, inte kräver någon API-nyckel.';

  @override
  String get aiApiKeyEditDescription =>
      'Lämna fältet tomt om du vill behålla den nuvarande nyckeln.';

  @override
  String get aiBaseUrl => 'Bas-URL';

  @override
  String get aiBaseUrlDescription =>
      'Lämna fältet tomt om du använder OpenAI. Annars anger du en OpenAI-kompatibel slutpunkt, till exempel \"http://localhost:11434/v1\".';

  @override
  String get aiModel => 'Modell';

  @override
  String get aiModelDescription =>
      'Vilken modell din AI-leverantör ska använda (t.ex. \"gpt-5\").';

  @override
  String get aiTimeout => 'Tidsgräns för begäran (sekunder)';

  @override
  String get aiProviderCreated => 'Leverantör skapad';

  @override
  String get aiProviderUpdated => 'Leverantör uppdaterad';

  @override
  String get aiProviderDeleted => 'Leverantör borttagen';

  @override
  String get aiProviderCreateFailed => 'Kunde inte skapa leverantör';

  @override
  String get aiProviderUpdateFailed => 'Kunde inte uppdatera leverantör';

  @override
  String get aiProviderDeleteFailed => 'Kunde inte ta bort leverantör';

  @override
  String get aiRequestHeaders => 'HTTP-huvuden för begäran';

  @override
  String get aiRequestParams => 'Parametrar för begäran';

  @override
  String get aiNoDefaultWarning =>
      'Du har inte angett en standardleverantör, så AI-funktioner är inaktiverade';

  @override
  String get aiTestConnection => 'Testa anslutningen';

  @override
  String get aiTestSucceeded => 'Anslutningen lyckades';

  @override
  String get aiTestFailed => 'Anslutningen misslyckades';

  @override
  String get aiSupportsImages => 'Har stöd för bilder';

  @override
  String get aiTextOnly =>
      'Hanterar bara text och kan därför inte användas som bildleverantör';

  @override
  String get debugAiTitle => 'Felsök AI-leverantörer';

  @override
  String get debugAiDescription =>
      'Här kan du felsöka AI-leverantörer genom att testa anslutningen och se resultatet. Om bildtjänster är aktiverade kan du även bifoga en bild.';

  @override
  String get debugParserTitle => 'Tolk';

  @override
  String get debugParserDescription =>
      'Mealie använder betingade slumpfält (CRF) för att tolka och bearbeta ingredienser. Modellen bygger på en datamängd med över 100 000 ingredienser som New York Times har sammanställt. Den har bara tränats på engelska, så resultaten kan variera för andra språk. Här kan du testa modellen.';

  @override
  String get debugIngredientText => 'Ingredienstext';

  @override
  String get debugTryExample => 'Prova ett exempel';

  @override
  String debugAverageConfidence(String value) {
    return '$value säkerhet';
  }

  @override
  String get debugRunTest => 'Kör test';

  @override
  String get debugQuantity => 'Mängd';

  @override
  String get debugUnit => 'Måttenhet';

  @override
  String get debugFood => 'Livsmedel';

  @override
  String get debugNote => 'Kommentar';

  @override
  String get debugGroup => 'Grupp';

  @override
  String get aiProviderNone => 'Inga';

  @override
  String aiProviderDeleteConfirm(String name) {
    return 'Ta bort leverantören “$name”?';
  }

  @override
  String get aiProvidersEmpty => 'Inga AI-leverantörer än.';

  @override
  String get aiAdvanced => 'Avancerat';

  @override
  String get aiKeyLabel => 'Namn';

  @override
  String get aiValueLabel => 'Värde';

  @override
  String get debugTitle => 'Felsök';

  @override
  String get debugParse => 'Tolka';

  @override
  String get debugParseFailed => 'Ingrediensen kunde inte tolkas';

  @override
  String get debugChooseImage => 'Välj bild';

  @override
  String get debugNoImage => 'Ingen bild (valfritt)';

  @override
  String get updateTitle => 'Sök efter uppdateringar';

  @override
  String get updateInstalledVersion => 'Installerad version';

  @override
  String get updateLastCheck => 'Senast kontrollerat';

  @override
  String get updateCheckNow => 'Kontrollera nu';

  @override
  String get updateChecking => 'Söker efter uppdateringar…';

  @override
  String get updateUpToDate => 'Mealie Recipes är uppdaterat.';

  @override
  String updateAvailable(String version) {
    return 'Version $version är tillgänglig';
  }

  @override
  String get updateAvailableDescription =>
      'En ny version av Mealie Recipes finns. Inget installeras förrän du själv startar uppdateringen.';

  @override
  String get updateShow => 'Visa uppdatering';

  @override
  String get updateLater => 'Senare';

  @override
  String updateDownloading(int percent) {
    return 'Laddar ner … $percent %';
  }

  @override
  String updateReady(String version) {
    return 'Version $version är redo att installeras';
  }

  @override
  String get updateInstalling => 'Installerar — appen startar om automatiskt …';

  @override
  String get updateManual =>
      'Uppdateringen kunde inte installeras automatiskt. Skivavbilden har öppnats: dra Mealie Recipes till Program.';

  @override
  String get updateFailed => 'Uppdateringen misslyckades';

  @override
  String get updateInstallNow => 'Ladda ner och installera';

  @override
  String get updateRestartNow => 'Installera och starta om';

  @override
  String get updateAutoTitle => 'Sök efter uppdateringar vid start';

  @override
  String get updateAutoDescription =>
      'Kontrollerar och meddelar bara — installationen startar du alltid själv.';

  @override
  String get updateBetaTitle => 'Ta emot betaversioner';

  @override
  String get updateBetaDescription =>
      'Erbjuder även förhandsversioner för test. De kan fortfarande innehålla fel.';

  @override
  String get updateNoNotes => 'Ingen versionsinformation.';

  @override
  String get updateSourceHint =>
      'Uppdateringar kommer från Mealie Recipes GitHub-releaser och installeras bara om de är signerade av utvecklaren (macOS).';

  @override
  String get errorNoConnection =>
      'Kan inte nå din Mealie-server. Kontrollera internetanslutningen och serveradressen.';

  @override
  String get errorTimeout => 'Servern tog för lång tid att svara. Försök igen.';

  @override
  String get errorUnauthorized =>
      'Din inloggning har gått ut eller API-token är inte längre giltig. Logga in igen i inställningarna.';

  @override
  String get errorServer =>
      'Mealie-servern rapporterade ett fel. Försök igen senare.';

  @override
  String get errorNotFound =>
      'Hittades inte på servern — det kan ha tagits bort.';

  @override
  String get errorCertificate =>
      'Serverns säkerhetscertifikat är inte betrott.';

  @override
  String get errorGeneric => 'Något gick fel. Försök igen.';

  @override
  String get offlineLabel => 'Offline';

  @override
  String offlineSince(String time) {
    return 'Offline · senast synkat $time';
  }

  @override
  String get mealplanEntryActions => 'Måltidsalternativ';

  @override
  String get mealplanMoveAction => 'Flytta';

  @override
  String get mealplanMoveTitle => 'Flytta måltid';

  @override
  String get mealplanMoveDate => 'Datum';

  @override
  String mealplanMovedTo(String date) {
    return 'Flyttad till $date';
  }

  @override
  String get mealplanShowWeek => 'Visa';

  @override
  String get mealplanMoveFailed => 'Måltiden kunde inte flyttas';

  @override
  String get recentlyViewedTitle => 'Senast visade';

  @override
  String get recentlyViewedEmpty => 'Recept du öppnar visas här.';

  @override
  String get recentlyViewedClear => 'Rensa historik';

  @override
  String get recentlyViewedClearMessage =>
      'Listan över senast visade recept på den här enheten rensas. Själva recepten finns kvar.';

  @override
  String get recentlyViewedClearConfirm => 'Rensa';

  @override
  String get duplicatesTitle => 'Dubblettsökare';

  @override
  String get duplicatesScanning => 'Söker efter dubblettrecept…';

  @override
  String get duplicatesNone => 'Inga dubblettrecept hittades.';

  @override
  String duplicatesFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count möjliga dubbletter hittades.',
      one: '1 möjlig dubblett hittades.',
    );
    return '$_temp0';
  }

  @override
  String get duplicatesIntro =>
      'Tryck på receptet som ska behållas och slå sedan ihop.';

  @override
  String get duplicatesReasonSource => 'Samma källa';

  @override
  String get duplicatesReasonName => 'Samma namn';

  @override
  String duplicatesReasonSimilar(int percent) {
    return 'Liknande · $percent % samma ingredienser';
  }

  @override
  String get duplicatesKeeps => 'Behålls';

  @override
  String get duplicatesWillBeDeleted => 'Tas bort';

  @override
  String get duplicatesMerge => 'Slå ihop';

  @override
  String get duplicatesNotDuplicate => 'Inte en dubblett';

  @override
  String get duplicatesMergeTitle => 'Slå ihop recept?';

  @override
  String duplicatesMergeMessage(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count andra recept tas bort',
      one: '1 annat recept tas bort',
    );
    return '“$name” behålls. $_temp0.\n\nKategorier, taggar, redskap, anteckningar, planerade måltider i ditt hushåll och din favorit flyttas över. Kommentarer, tidslinje och bilagor för de borttagna recepten går förlorade.';
  }

  @override
  String get duplicatesMerged => 'Recepten har slagits ihop';

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
    return 'Visa dolda par igen ($count)';
  }

  @override
  String get duplicatesRescan => 'Sök igen';

  @override
  String get duplicatesOpenRecipe => 'Öppna recept';

  @override
  String get duplicatesMergeNoEditHint =>
      'Du får inte redigera receptet som behålls (någon annans låsta recept eller från ett annat hushåll). Dess kategorier, taggar, redskap och anteckningar förblir därför oförändrade; bara planerade måltider och din favorit flyttas över.';

  @override
  String get recipeOtherHouseholdHint =>
      'Från ett annat hushåll – redigering är låst där';

  @override
  String foodsSavedAsNote(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nya livsmedel behölls',
      one: '1 nytt livsmedel behölls',
    );
    return 'Sparat. $_temp0 som ingrediensanteckning – för att skapa livsmedel krävs behörigheten “Användaren kan hantera livsmedel, taggar och kategorier” i Mealie.';
  }

  @override
  String get a11yRemove => 'Ta bort';

  @override
  String get a11yDecrease => 'Mindre';

  @override
  String get a11yIncrease => 'Mer';

  @override
  String get a11yShowPassword => 'Visa lösenord';

  @override
  String get a11yHidePassword => 'Dölj lösenord';

  @override
  String get a11yClearSearch => 'Rensa sökning';

  @override
  String get notesQueuedOffline =>
      'Offline – anteckningen skickas så snart servern går att nå igen.';

  @override
  String get timelineQueuedOffline =>
      'Offline – det läggs till i tidslinjen så snart servern går att nå igen.';

  @override
  String get syncSectionName => 'Omdöpta';

  @override
  String get pendingRecipesDiscard => 'Kasta';

  @override
  String get undo => 'Ångra';

  @override
  String timerStoppedSnack(String name) {
    return 'Timern “$name” har stoppats';
  }

  @override
  String get cookFriendsEndConfirm =>
      'Avsluta sessionen för alla? Alla gäster kopplas från.';

  @override
  String get weekStartSyncHint =>
      'Sparat i Mealie – gäller hela ditt hushåll, även i webbappen.';

  @override
  String get weekStartNoPermission =>
      'Inställt i Mealie av ditt hushåll. Bara medlemmar som får hantera hushållet kan ändra det.';

  @override
  String get assetsUnsupported329 =>
      'Mealie stöder PDF, bilder, videor (MP4, MOV, WebM), ljud (MP3, M4A), Word/ODT/RTF, TXT, MD, CSV och JSON.';

  @override
  String get assetsRecordVideo => 'Spela in video';

  @override
  String get assetsChooseVideo => 'Välj video';

  @override
  String get shoppingSearchHint => 'Sök i den här listan';

  @override
  String get shoppingSearchNoMatches => 'Inga varor matchar sökningen.';

  @override
  String get mealplanServingsTitle => 'Planerade portioner';

  @override
  String get mealplanServingsHint =>
      'Bara för den här posten i måltidsplanen — själva receptet ändras inte. När receptet öppnas och läggs till på inköpslistan används dessa portioner.';

  @override
  String get calendarFeedTitle => 'Prenumerera på kalender';

  @override
  String get calendarFeedSubtitle =>
      'Visa måltidsplanen i Google, Apple eller någon annan kalender';

  @override
  String get calendarFeedDescription =>
      'Prenumerera på hushållets måltidsplan i Google Kalender, Apple Kalender, Home Assistant eller någon annan app med stöd för iCal-länkar. Alla som har länken kan se måltidsplanen.';

  @override
  String get calendarFeedOff => 'Kalenderlänken är avstängd för ditt hushåll.';

  @override
  String get calendarFeedAskManager =>
      'Be någon med behörighet att hantera hushållet att aktivera länken.';

  @override
  String get calendarFeedTurnOn => 'Slå på';

  @override
  String get calendarFeedTurnOff => 'Stäng av';

  @override
  String get calendarFeedReset => 'Återställ länk';

  @override
  String get calendarFeedResetHint =>
      'Om du återställer eller stänger av länken slutar befintliga prenumerationer att uppdateras.';

  @override
  String get calendarFeedIncludeNotes => 'Ta med anteckningar';

  @override
  String get calendarFeedTimesHint =>
      'Tryck på en måltid för att ange tid. Måltider utan tid visas som heldagshändelser.';

  @override
  String get calendarFeedMealTypes => 'Måltidstyp';

  @override
  String get calendarFeedSubscribe => 'Prenumerera i kalendern';

  @override
  String get calendarFeedNoApp =>
      'Ingen kalenderapp kunde öppnas. Kopiera länken och lägg till den som prenumeration i din kalender.';

  @override
  String get calendarFeedPublicHint =>
      'Länken fungerar utan inloggning — dela den bara med personer som får se din måltidsplan.';

  @override
  String get recipeShareLinkMenu => 'Delningslänk och QR-kod';

  @override
  String get recipeShareShowQr => 'Visa QR-kod';

  @override
  String get recipeShareScanQr =>
      'Skanna QR-koden med mobilkameran för att öppna receptet';

  @override
  String get recipeShareQrShare => 'Dela bild';

  @override
  String get recipeShareQrFailed => 'QR-kodbilden kunde inte skapas';

  @override
  String get mealplanSettingsTitle => 'Inställningar för måltidsplanering';

  @override
  String get mealDiceRulesTitle => 'Tärningsregler';

  @override
  String saveAsNewFood(String name) {
    return 'Spara “$name” som nytt livsmedel';
  }

  @override
  String get shoppingMoreOptions => 'Fler alternativ';

  @override
  String get shoppingFewerOptions => 'Färre alternativ';

  @override
  String nameAlreadyExists(String name) {
    return 'Finns redan: $name';
  }

  @override
  String aliasBelongsTo(String alias, String name) {
    return '“$alias” hör redan till “$name” — slå hellre ihop de två.';
  }

  @override
  String get recipeMatchTitle => 'Recipe Match';

  @override
  String get recipeMatchShuffle => 'Blanda';

  @override
  String recipeMatchCardsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count recept i leken',
      one: '1 recept i leken',
    );
    return '$_temp0';
  }

  @override
  String get recipeMatchNext => 'Nästa';

  @override
  String get recipeMatchKeep => 'Till brickan';

  @override
  String get recipeMatchKept => 'Lagd på brickan';

  @override
  String get recipeMatchAnyTime => 'Valfri tid';

  @override
  String recipeMatchMaxTime(int minutes) {
    return '≤ $minutes min';
  }

  @override
  String get recipeMatchEmpty => 'Inga matchande recept';

  @override
  String get recipeMatchEmptyHint => 'Ändra filtren eller töm brickan.';

  @override
  String get recipeMatchResetFilters => 'Återställ filter';

  @override
  String get recipeMatchFlipHint => 'Tryck: ingredienser · gör så här';

  @override
  String get recipeMatchFlipBack => 'Vänd tillbaka';

  @override
  String get recipeMatchOpenRecipe => 'Hela receptet';

  @override
  String get recipeMatchOnHand => 'finns hemma';

  @override
  String get recipeMatchTray => 'Bricka';

  @override
  String get recipeMatchTrayEmpty => 'Fortfarande tom – dra ett kort nedåt';

  @override
  String recipeMatchTrayCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count recept',
      one: '1 recept',
    );
    return '$_temp0';
  }

  @override
  String get recipeMatchClear => 'Rensa';

  @override
  String get recipeMatchTrayHint =>
      'Ligger kvar tills du tömmer den – även när du stänger leken.';

  @override
  String get recipeMatchRemove => 'Ta bort från brickan';

  @override
  String get recipeMatchToMealplan => 'Lägg till i måltidsplanen';

  @override
  String get recipeMatchToShopping => 'Ingredienser till inköpslistan';

  @override
  String get recipeMatchSelectIngredients => 'Välj ingredienser';

  @override
  String get recipeMatchNoList => 'Välj först en inköpslista.';

  @override
  String get recipeMatchList => 'Lista';

  @override
  String get recipeMatchOnHandHint =>
      'Ingredienser som finns hemma är redan avmarkerade.';

  @override
  String recipeMatchAddCount(int selected, int total) {
    return 'Lägg till $selected av $total ingredienser';
  }

  @override
  String get recipeMatchNoDay => 'Ingen dag än – ligger kvar på brickan';

  @override
  String recipeMatchAddMeals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Lägg till $count måltider',
      one: 'Lägg till 1 måltid',
    );
    return '$_temp0';
  }

  @override
  String recipeMatchMealsAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count måltider tillagda',
      one: '1 måltid tillagd',
    );
    return '$_temp0';
  }

  @override
  String get recipeMatchSwipeUp => 'Svep uppåt för att öppna brickan';

  @override
  String get weekPlannerTitle => 'Planera veckan';

  @override
  String get weekPlannerStepDays => 'Dagar';

  @override
  String get weekPlannerStepPrefs => 'Preferenser';

  @override
  String get weekPlannerStepPreview => 'Förhandsvisning';

  @override
  String get weekPlannerDaysTitle => 'Vilka måltider ska appen fylla?';

  @override
  String get weekPlannerDaysHint =>
      'Tryck på rutorna. Det som redan är planerat förblir som det är.';

  @override
  String get weekPlannerPresetWeekdays => 'Vardagar';

  @override
  String get weekPlannerPlanned => 'planerat';

  @override
  String get weekPlannerMoreMeals => 'Visa fler måltider';

  @override
  String get weekPlannerFewerMeals => 'Färre måltider';

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
  String get weekPlannerPrefsTitle => 'Vad ska appen tänka på?';

  @override
  String get weekPlannerPrefsHint =>
      'Allt är valfritt – utan val väljer den en färgglad blandning av dina recept.';

  @override
  String get weekPlannerQuick => 'Snabbt på vardagar';

  @override
  String weekPlannerQuickSub(int minutes) {
    return 'Mån–fre högst $minutes min';
  }

  @override
  String get weekPlannerStale => 'Länge olagade först';

  @override
  String get weekPlannerStaleSub =>
      'utifrån “Senast tillagat” och måltidsplanen';

  @override
  String get weekPlannerFavorites => 'Planera favoriter oftare';

  @override
  String get weekPlannerFavoritesSub =>
      'hjärtmärkta och högt betygsatta recept';

  @override
  String get weekPlannerVariety => 'Variation';

  @override
  String get weekPlannerVarietySub => 'ingen kategori två gånger i rad';

  @override
  String get weekPlannerOnlyFrom => 'Endast från';

  @override
  String get weekPlannerDiceRules => 'Använd tärningsregler';

  @override
  String get weekPlannerDiceRulesSub =>
      'ditt val per måltid från måltidsplanens inställningar';

  @override
  String weekPlannerMatching(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count matchande recept',
      one: '1 matchande recept',
    );
    return '$_temp0';
  }

  @override
  String weekPlannerForMeals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'för $count måltider',
      one: 'för 1 måltid',
    );
    return '$_temp0';
  }

  @override
  String get weekPlannerSuggest => 'Föreslå';

  @override
  String get weekPlannerPreviewHint =>
      'Tärningen byter, låset behåller. Håll ned en rätt och dra den till en annan dag för att byta plats.';

  @override
  String get weekPlannerRerollAll => 'Slå om alla';

  @override
  String get weekPlannerReroll => 'Slå om';

  @override
  String get weekPlannerLock => 'Lås';

  @override
  String get weekPlannerUnlock => 'Lås upp';

  @override
  String get weekPlannerReasonNever => 'aldrig lagat';

  @override
  String get weekPlannerReasonStale => 'inte lagat på länge';

  @override
  String get weekPlannerReasonFavorite => 'Favorit';

  @override
  String get weekPlannerNoMatch => 'Inget matchande recept';

  @override
  String get weekPlannerThenShopping =>
      'Välj sedan ingredienser till inköpslistan';

  @override
  String get weekPlannerMostlyEmpty => 'Veckan nästan tom';

  @override
  String weekPlannerMostlyEmptySub(int free, int total) {
    return '$free av $total dagar fortfarande lediga – fyll dem i tre steg.';
  }

  @override
  String get previousWeek => 'Föregående vecka';

  @override
  String get nextWeek => 'Nästa vecka';

  @override
  String get weekPlannerAllDays => 'Alla dagar';

  @override
  String get weekPlannerWeekend => 'Helg';

  @override
  String get weekPlannerDinners => 'Middagar';

  @override
  String get weekPlannerLunches => 'Luncher';

  @override
  String get weekPlannerAllMeals => 'Alla måltider';

  @override
  String get mealplanDayEmpty => 'Inget planerat';

  @override
  String get mealplanDropHere => 'Släpp här';

  @override
  String mealplanDayKcal(String kcal) {
    return '$kcal kcal per portion';
  }

  @override
  String mealplanDayKcalPartial(String kcal) {
    return 'minst $kcal kcal per portion';
  }

  @override
  String get globalSearchHint => 'Sök recept, varor, funktioner …';

  @override
  String get globalSearchIntro =>
      'Sök efter recept, varor på inköpslistan, livsmedel och kokböcker – och efter appens funktioner och inställningar, t.ex. “lista”.';

  @override
  String get globalSearchFunctions => 'Funktioner';

  @override
  String globalSearchNoResults(String query) {
    return 'Inga resultat för “$query”';
  }

  @override
  String get searchClear => 'Rensa sökning';

  @override
  String get recipeMatchPlanWeek => 'Planera veckan med de här recepten';

  @override
  String get weekPlannerReasonTray => 'från brickan';

  @override
  String get emptyBrowseRecipes => 'Bläddra bland recept';

  @override
  String get mealplanWeekShopping => 'Ingredienser för den här veckan';

  @override
  String get globalSearchActions => 'Åtgärder';

  @override
  String globalSearchAddToList(String text) {
    return 'Lägg till “$text” på inköpslistan';
  }

  @override
  String globalSearchAdded(String text) {
    return '“$text” har lagts till';
  }

  @override
  String get globalSearchImportUrl => 'Importera recept från den här adressen';

  @override
  String get homeContinueCooking => 'Fortsätt laga';

  @override
  String homeCookingStep(int step, int total) {
    return 'Steg $step av $total';
  }

  @override
  String get homeCookingPrep => 'Förberedelse';

  @override
  String get homeCookingAlmostDone => 'Nästan klart';

  @override
  String get homeCookingContinue => 'fortsätt';

  @override
  String get paneSelectRecipe => 'Välj ett recept till vänster.';

  @override
  String get mealplanDragRecipeHint =>
      'Dra ett recept till en dag för att planera det.';

  @override
  String get desktopDropUnsupported =>
      'De här filerna kan inte läggas till som bilagor.';

  @override
  String desktopDropUploaded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bilagor tillagda',
      one: '1 bilaga tillagd',
    );
    return '$_temp0';
  }

  @override
  String get desktopDropAsAttachment => 'Släpp för att lägga till som bilaga';

  @override
  String get printAction => 'Skriv ut';

  @override
  String get mealplanPrintWeek => 'Skriv ut veckan';

  @override
  String get mealplanEntryCooked => 'Lagat';

  @override
  String get recipeSearchClear => 'Rensa sökning';

  @override
  String get organizerShowRecipes => 'Visa recept';

  @override
  String globalSearchShowAllRecipes(int count) {
    return 'Visa alla $count recept';
  }

  @override
  String get unnamedEntry => '(inget namn)';

  @override
  String get mealplanWholeWeek => 'För hela veckan';

  @override
  String get mealplanWholeWeekDropHint =>
      'Släpp en måltid här för att planera den för hela veckan.';

  @override
  String get mealplanMovedToWholeWeek => 'Planerad för hela veckan';

  @override
  String get mealplanCookToday => 'Lagar den i dag';

  @override
  String get mealplanPlanWholeWeek => 'Planera för hela veckan';

  @override
  String mealplanPlanWholeWeekRange(String from, String to) {
    return '$from – $to';
  }

  @override
  String get calendarFeedDuration => 'Längd (minuter)';

  @override
  String get calendarFeedEventDetails => 'Händelseinformation';

  @override
  String calendarFeedEventDetailsHint(String fields) {
    return 'Anpassa hur måltider visas i kalendern. Kopplingsfält: $fields';
  }

  @override
  String get calendarFeedEventTitle => 'Händelsens rubrik';

  @override
  String get calendarFeedEventDescription => 'Händelsens beskrivning';

  @override
  String get calendarFeedEventDetailsWarning =>
      'Om du ändrar dessa ändras kalenderlänken — har du redan prenumererat, prenumerera igen med den nya länken.';

  @override
  String get stepDurationMinutes => 'Tidsåtgång (minuter)';

  @override
  String stepDurationSaved(String duration) {
    return 'Sparad varaktighet: $duration. Redigering ersätter den med hela minuter.';
  }

  @override
  String get sortTotalTimeShort => 'Kortast total tid';

  @override
  String get sortTotalTimeLong => 'Längst total tid';

  @override
  String recipeCreatedBy(String name) {
    return 'Skapat av $name';
  }

  @override
  String get timelineReplacePhoto => 'Byt foto';

  @override
  String get pasteRecipeTitle => 'Klistra in recept';

  @override
  String get pasteRecipeDescription =>
      'Klistra in ett recept som JSON (schema.org) eller en webbsidas HTML-källkod.';

  @override
  String get pasteRecipeDescription330 =>
      'Klistra in ett recept som exporterats från Mealie (JSON) — det importeras med hela strukturen: livsmedel, enheter och steglänkar. JSON (schema.org) och en webbsidas HTML-källkod fungerar också.';

  @override
  String get pasteRecipeHint => 'Klistra in JSON eller HTML här';

  @override
  String get pasteRecipeButton => 'Klistra in recept';

  @override
  String get pasteRecipeImport => 'Importera';

  @override
  String get aiPromptsTitle => 'AI-instruktioner';

  @override
  String get aiPromptsTeaser =>
      'Anpassa instruktionerna som Mealie ger din AI-leverantör — för alla uppgifter eller för var och en.';

  @override
  String get aiPromptsDescription =>
      'Anpassa instruktionerna som Mealie ger din AI-leverantör för varje uppgift. Mealies instruktioner är skrivna på engelska. Dina recept behåller källans språk om du inte väljer att översätta dem. Du kan skriva egna instruktioner på valfritt språk.';

  @override
  String get aiPromptsGlobal => 'Gemensamma instruktioner';

  @override
  String get aiPromptsGlobalDescription =>
      'Läggs till i alla instruktioner som ger receptdata, till exempel för att skapa recept, tolka ingredienser eller översätta. Systeminstruktionerna påverkas inte.';

  @override
  String get aiPromptsGlobalPlaceholder =>
      'Till exempel: Använd alltid metriska enheter.';

  @override
  String get aiPromptsList => 'Instruktioner';

  @override
  String get aiPromptSystem => 'System';

  @override
  String get aiPromptSystemDescription =>
      'Det här är en systeminstruktion som används för att återge källmaterialet så troget som möjligt innan det blir ett recept. De gemensamma instruktionerna läggs därför inte till här. Du behöver sällan ändra systeminstruktionen, och ändringar kan göra importen mindre tillförlitlig.';

  @override
  String get aiPromptAppended => 'Kompletterad';

  @override
  String get aiPromptOverridden => 'Ersatt';

  @override
  String get aiPromptModeDefault => 'Standard';

  @override
  String get aiPromptModeAppend => 'Komplettera';

  @override
  String get aiPromptModeOverride => 'Ersätt';

  @override
  String get aiPromptAppendDescription =>
      'Dina instruktioner läggs till i Mealies instruktion och har företräde om de säger olika saker.';

  @override
  String get aiPromptOverrideDescription =>
      'Din instruktion ersätter Mealies instruktion helt. Framtida ändringar av Mealies instruktion får därför ingen effekt här. Den information som uppgiften kräver, till exempel din lista över enheter, läggs fortfarande till efter din instruktion.';

  @override
  String get aiPromptDefaultChanged =>
      'Mealie har ändrat sin instruktion sedan du ersatte den. Jämför den med din egen eller återgå till standardinstruktionen för att använda den nya versionen.';

  @override
  String get aiPromptViewDefault => 'Visa standardinstruktionen';

  @override
  String get aiPromptHideDefault => 'Dölj standardinstruktionen';

  @override
  String get aiPromptSaved => 'Instruktionen har sparats';

  @override
  String get aiPromptSaveFailed => 'Det gick inte att spara instruktionen';

  @override
  String get aiPromptTitleBuildRecipe => 'Skapa recept';

  @override
  String get aiPromptTitleParseIngredients => 'Tolka ingredienser';

  @override
  String get aiPromptTitleRecipeVideo => 'Recept från video';

  @override
  String get aiPromptTitleOrganizers => 'Välj taggar, kategorier och redskap';

  @override
  String get aiPromptTitleTranslate => 'Översätt recept';

  @override
  String get aiPromptTitleCompileSource => 'Läs källmaterial';

  @override
  String get aiPromptTitleTranscribe => 'Transkribera ljud';

  @override
  String get aiPromptDescBuildRecipe =>
      'Skapar ett strukturerat recept av material från en webbsida, ett foto eller en text.';

  @override
  String get aiPromptDescParseIngredients =>
      'Används när AI tolkar ingredienser och delar upp varje ingrediens i mängd, enhet, livsmedel och anteckning.';

  @override
  String get aiPromptDescRecipeVideo =>
      'Skapar ett recept utifrån videons transkription och tillhörande text.';

  @override
  String get aiPromptDescOrganizers =>
      'Väljer taggar, kategorier och redskap för ett importerat recept.';

  @override
  String get aiPromptDescTranslate =>
      'Översätter ett importerat recept till det språk du väljer.';

  @override
  String get aiPromptDescCompileSource =>
      'Läser webbsidor, foton och text och återger receptet som ren text.';

  @override
  String get aiPromptDescTranscribe =>
      'Transkriberar ljud när din ljudleverantör inte kan göra det direkt.';

  @override
  String get mealplanNoteHint => 'Anteckning (valfritt)';

  @override
  String get mealplanEditTitle => 'Redigera post';

  @override
  String get mealplanEntryTitleLabel => 'Rubrik';

  @override
  String get mealplanEntryNoteLabel => 'Anteckning';

  @override
  String mealplanCreateRecipe(String name) {
    return 'Nytt recept “$name”';
  }

  @override
  String get mealplanCreateRecipeSubtitle =>
      'Skapar ett tomt recept, planerar det och öppnar editorn';

  @override
  String get importOptionsTitle => 'Importalternativ';

  @override
  String get importOptionsHint =>
      'Hur mycket Mealies AI gör på din server vid import. Varje extra steg är en egen AI-förfrågan – ju färre, desto snabbare.';

  @override
  String get importTranslateTitle => 'Översätt recept';

  @override
  String get importOrganizersTitle => 'Kategorier och taggar';

  @override
  String get importOrganizersCreate => 'Lägg till nya';

  @override
  String get importOrganizersExisting => 'Endast befintliga';

  @override
  String get importOrganizersNone => 'Inga';

  @override
  String get importOrganizersCreateHint =>
      'AI tilldelar taggar, kategorier och redskap och skapar saknade.';

  @override
  String get importOrganizersExistingHint =>
      'AI använder bara taggar, kategorier och redskap som redan finns.';

  @override
  String get importOrganizersNoneHint =>
      'Receptet importeras utan taggar, kategorier och redskap. Mealie kör ändå det här steget, så importen blir inte snabbare.';

  @override
  String get importStarting => 'Skickar till servern…';

  @override
  String get importRunning => 'Importerar recept…';

  @override
  String get aiImagesRunning => 'AI:n läser sidorna…';

  @override
  String get importStreamPhotosTitle => 'Fotoimport med liveförlopp';

  @override
  String get importStreamPhotosHint =>
      'Visar varje steg och håller anslutningen öppen vid långa importer. Stäng av för att ladda upp i en enda förfrågan som tidigare – t.ex. om din proxy blockerar strömning.';

  @override
  String get weekPlannerDiceRulesMealieSub =>
      'ditt hushålls Mealie-regler (måltidsplanens inställningar)';

  @override
  String get syncStarted => 'Laddar om recept, bilder och listor från servern…';

  @override
  String get syncDone => 'Allt är uppdaterat';

  @override
  String get recipeReloaded => 'Receptet har laddats om';

  @override
  String get logoutTitle => 'Logga ut / byt användare';

  @override
  String get logoutConfirm =>
      'Recept, listor och ändringar som inte har synkats tas bort från den här enheten. Appinställningarna och serveradressen finns kvar, så du behöver bara logga in igen.';

  @override
  String get reloadRecipe => 'Ladda om från servern';

  @override
  String get wifiServerTitle => 'Annan adress på Wi-Fi';

  @override
  String get wifiServerHint =>
      'För samma server under en andra adress, t.ex. den lokala IP-adressen hemma och ZeroTier, Tailscale eller en domän på resande fot. På Wi-Fi-nätverket nedan använder appen den här adressen automatiskt, överallt annars serverns URL ovan.';

  @override
  String get wifiSsidLabel => 'Wi-Fi-namn';

  @override
  String get wifiServerUrl => 'Adress på det här Wi-Fi-nätverket';

  @override
  String get wifiUseCurrent => 'Använd nuvarande Wi-Fi';

  @override
  String get wifiNameUnavailable =>
      'Kunde inte läsa Wi-Fi-namnet. Anslut till Wi-Fi och tillåt platsåtkomst – Android och iOS visar bara Wi-Fi-namnet med den.';

  @override
  String wifiServerActive(String ssid) {
    return 'Aktiv: adress på Wi-Fi “$ssid”';
  }

  @override
  String wifiServerStandardActive(String ssid) {
    return 'Aktiv: serverns URL (inte på “$ssid”)';
  }

  @override
  String get wifiServerRemove => 'Ta bort';

  @override
  String get switchUserTitle => 'Byt användare';

  @override
  String switchUserBody(String name) {
    return '$name förblir sparad på den här enheten – med alla recept, listor och ändringar som inte har synkats. Du kan byta tillbaka via profilbilden eller inloggningssidan.';
  }

  @override
  String get allowBiometricTitle => 'Byt tillbaka med enhetsupplåsning';

  @override
  String get allowBiometricHint =>
      'Face ID, fingeravtryck eller enhetens PIN i stället för lösenordet. Alla som kan låsa upp enheten kan då öppna kontot.';

  @override
  String get allow => 'Tillåt';

  @override
  String unlockAccountReason(String name) {
    return 'Byt till $name';
  }

  @override
  String signInAs(String name) {
    return 'Logga in som $name';
  }

  @override
  String wrongAccountError(String name) {
    return 'Det är kontot “$name”. Logga in med det sparade kontot.';
  }

  @override
  String get accountSaveOffline =>
      'Kontot kan inte sparas just nu – servern går inte att nå.';

  @override
  String get signOutRemoveTitle => 'Logga ut och ta bort';

  @override
  String get signOutRemoveConfirm =>
      'Kontot och alla dess data på den här enheten (recept, listor, ej synkade ändringar) tas bort. Appinställningarna finns kvar.';

  @override
  String get removeSavedAccount => 'Ta bort från den här enheten';

  @override
  String removeSavedAccountConfirm(String name) {
    return 'Ta bort “$name” och alla sparade data från den här enheten? Ändringar som inte har synkats går förlorade.';
  }

  @override
  String get savedAccountsTitle => 'Sparade konton';

  @override
  String get addAccount => 'Lägg till ett konto';

  @override
  String get biometricOff => 'Sluta använda enhetsupplåsning';

  @override
  String get orNewAccount => 'Eller logga in med ett annat konto:';

  @override
  String get importVideoTitle => 'Videolänkar';

  @override
  String get importVideoFast => 'Snabb';

  @override
  String get importVideoThorough => 'Grundlig (AI)';

  @override
  String get importVideoFastHint =>
      'Mealie transkriberar videon och bygger receptet med en enda AI-förfrågan – oftast mycket snabbare. Ingen översättning och inga kategorier/taggar. Du kan ändå slå på AI per import.';

  @override
  String get importVideoThoroughHint =>
      'AI-reglaget slås på automatiskt för videolänkar: flera AI-steg, med översättning och kategorier/taggar enligt inställningarna ovan. Tar längre tid.';

  @override
  String get importPresetFast => 'Snabb';

  @override
  String get importPresetThorough => 'Grundlig';

  @override
  String get importPresetCustom => 'Anpassad';

  @override
  String get importPresetFastTitle =>
      'Så få AI-steg som möjligt – kortast väntan';

  @override
  String get importPresetFastVideo =>
      'Videolänkar: Mealie transkriberar videon och bygger receptet med en enda AI-förfrågan (AI-reglaget förblir av).';

  @override
  String get importPresetFastTranslate =>
      'Ingen översättning – receptet behåller originalspråket.';

  @override
  String get importPresetFastOrganizers =>
      'Bara befintliga kategorier och taggar tilldelas, inga nya skapas.';

  @override
  String get importPresetThoroughTitle =>
      'Mealies fullständiga AI-import – tar längre tid, får ut mest';

  @override
  String get importPresetThoroughVideo =>
      'Videolänkar importeras automatiskt med AI – i flera steg (sammanställ källan, bygg receptet, …).';

  @override
  String get importPresetThoroughTranslate =>
      'Receptet översätts till importspråket nedan om det är skrivet på ett annat språk.';

  @override
  String get importPresetThoroughOrganizers =>
      'Passande kategorier och taggar tilldelas; saknade skapas.';

  @override
  String get importPresetCustomTitle => 'Ställ in varje alternativ själv';

  @override
  String get importPresetCustomBody =>
      'Utgå från vad ditt tidigare val gjorde och ändra bara det du behöver – t.ex. snabba videoimporter men med översättning.';

  @override
  String get sidebarPinHint =>
      'Tips: håll ned en ruta och dra den till sidofältet för att fästa den där.';

  @override
  String get sidebarDropHere => 'Släpp här';

  @override
  String sidebarShortcutTitle(String name) {
    return 'Kortkommando för “$name”';
  }

  @override
  String sidebarShortcutPrompt(String modifier) {
    return 'Tryck nu på den tangentkombination du vill ha, inklusive $modifier.';
  }

  @override
  String get sidebarShortcutTaken => 'Den här kombinationen används redan.';

  @override
  String get sidebarShortcutNone => 'Inget kortkommando';

  @override
  String get sidebarShortcutChange => 'Ändra kortkommando';

  @override
  String get sidebarUnpin => 'Ta bort från sidofältet';

  @override
  String sidebarFull(int count) {
    return 'Sidofältet är fullt – högst $count egna poster.';
  }

  @override
  String get tabletSidebar => 'Sidofält i liggande läge';

  @override
  String get tabletSidebarSubtitle =>
      'Visar navigeringen till vänster i stället för längst ned när surfplattan hålls på tvären';

  @override
  String get filterDateCreated => 'Skapandedatum';

  @override
  String get filterDateUpdated => 'Senast uppdaterad';

  @override
  String get errorUploadTooLarge =>
      'Filen är för stor för den här Mealie-servern. Serverns uppladdningsgräns kan höjas med MAX_UPLOAD_SIZE_MB.';

  @override
  String get recipeDownloadPdfMealie => 'Ladda ner PDF (Mealies layout)';

  @override
  String get mealplanNoteMore => 'Visa mer…';

  @override
  String get mealplanNoteLess => 'Visa mindre';

  @override
  String get ingredientCommonlySubstitutedWith => 'Brukar ersättas med';

  @override
  String requiresMealieVersion(String version) {
    return 'Kräver Mealie $version eller senare.';
  }

  @override
  String get apiTokensTitle => 'API-nycklar';

  @override
  String get apiTokensDescription =>
      'Hantera de API-nycklar som ger externa program åtkomst till Mealie.';

  @override
  String get apiTokenNameLabel => 'Nyckelns namn';

  @override
  String get apiTokenGenerate => 'Skapa';

  @override
  String get apiTokensActive => 'AKTIVA API-NYCKLAR';

  @override
  String get apiTokenCopyWarning =>
      'Kopiera nyckeln för att använda den i ett externt program. Nyckeln visas bara den här gången.';

  @override
  String get apiTokenThisApp => 'Används av den här appen';

  @override
  String get apiTokenThisAppHint =>
      'Den här token håller appen inloggad och kan inte tas bort här.';

  @override
  String apiTokenDeleteConfirm(String name) {
    return 'Ta bort token “$name”? Appar som använder den förlorar åtkomsten direkt.';
  }

  @override
  String get apiTokensEmpty => 'Inga tokens än.';

  @override
  String apiTokenCreatedOn(String date) {
    return 'Skapad $date';
  }

  @override
  String get apiTokenCopied => 'Token kopierad';

  @override
  String get qfOpHasNoValue => 'har inget värde';

  @override
  String get qfOpHasValue => 'har ett värde';

  @override
  String get ratingHouseholdAverage => 'hushållets snitt';

  @override
  String get stepLinkedNotes => 'Länkade anteckningar';

  @override
  String get noteFallbackTitle => 'Anteckning';

  @override
  String get aiPromptTitleEnrichInstructions => 'Lägg till stegdetaljer';

  @override
  String get aiPromptDescEnrichInstructions =>
      'Länkar varje steg i ett importerat recept till de ingredienser och anteckningar det använder och plockar ut tid och rubrik.';

  @override
  String get loginAccountLocked => 'Kontot är låst. Försök igen senare';

  @override
  String get loginPasswordDisabled =>
      'Inloggning med lösenord är inaktiverad på den här servern. Använd en API-token i stället.';

  @override
  String get unitSystemTitle => 'Enheter';

  @override
  String get unitSystemAsWritten => 'Som i receptet';

  @override
  String get unitSystemMetric => 'Metriskt';

  @override
  String get unitSystemMetricHint => 'Metriskt (g, ml)';

  @override
  String get unitSystemImperial => 'Angloamerikanska mått';

  @override
  String get unitSystemImperialHint => 'Angloamerikanska mått (koppar, oz)';

  @override
  String get unitSystemHint =>
      'Bara visningen – själva receptet ändras inte. Som i Mealies webbapp gäller valet alla recept på den här enheten.';

  @override
  String get unitSystemUnavailable =>
      'Ingen enhet i det här receptet kan räknas om. Det kräver en standardisering av enheten i Mealie (Livsmedel och enheter → enhet → Standardisering).';

  @override
  String get shoppingCheckAll => 'Bocka av alla varor';

  @override
  String get shoppingUncheckAll => 'Avmarkera alla varor';

  @override
  String get shoppingDeleteChecked => 'Ta bort avbockade varor';

  @override
  String get shoppingCheckAllConfirm => 'Vill du bocka av alla varor?';

  @override
  String get shoppingUncheckAllConfirm => 'Vill du avmarkera alla varor?';

  @override
  String shoppingItemCheckedOff(String item) {
    return 'Kryssat av $item';
  }

  @override
  String get updateGithubUnavailable =>
      'GitHub svarar inte just nu. Försök igen om några minuter.';

  @override
  String get recipeMatchActionOnKeep => 'När du behåller';

  @override
  String get recipeMatchActionOnSkip => 'När du hoppar över';

  @override
  String get recipeMatchActionNone => 'Ingen';

  @override
  String get recipeMatchActionsHint =>
      'Mealie kör den valda åtgärden varje gång du lägger ett recept på brickan eller hoppar över det. Ångra inom 5 sekunder avbryter den.';

  @override
  String recipeMatchActionsNoPost(String type) {
    return 'Ditt hushåll har ännu ingen receptåtgärd av typen ”$type”.';
  }
}
