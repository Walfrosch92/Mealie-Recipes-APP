// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hungarian (`hu`).
class AppLocalizationsHu extends AppLocalizations {
  AppLocalizationsHu([String locale = 'hu']) : super(locale);

  @override
  String get appTitle => 'Mealie Recipes';

  @override
  String get endCookingMode => 'Főzési mód befejezése';

  @override
  String get endCookingModeConfirm => 'Biztosan befejezed a főzési módot?';

  @override
  String endCookingModeConfirmAll(int count) {
    return 'Ez mind a(z) $count receptet befejezi a főzési módban. Folytatod?';
  }

  @override
  String get addTimer => 'Időzítő hozzáadása';

  @override
  String get recipeFinished => 'Az étel elkészült.';

  @override
  String get bonAppetit => 'Jó étvágyat!';

  @override
  String get prepareIngredients => 'Készítsd elő a következő hozzávalókat';

  @override
  String prepareIngredientsFor(String servings) {
    return 'Készítsd elő a következő hozzávalókat $servings adaghoz';
  }

  @override
  String get next => 'Tovább';

  @override
  String get navHome => 'Kezdőlap';

  @override
  String get homeCookToday => 'Főzés mára';

  @override
  String get homeSuggestion => 'Javaslat';

  @override
  String get homeQuickAccess => 'Gyorselérés';

  @override
  String get homePlanned => 'Betervezve';

  @override
  String get favorite => 'Kedvenc';

  @override
  String get navSettings => 'Beállítások';

  @override
  String homeWelcomeName(Object name) {
    return 'Üdvözlünk, $name,';
  }

  @override
  String get homeWelcomeApp => 'a Mealie Recipes appban 👋';

  @override
  String get theme => 'Megjelenés';

  @override
  String get themeSystem => 'Rendszer';

  @override
  String get themeLight => 'Világos';

  @override
  String get themeDark => 'Sötét';

  @override
  String get recipes => 'Receptek';

  @override
  String get shoppingList => '🛒 Bevásárlólista';

  @override
  String get mealplan => 'Étkezési terv';

  @override
  String get settings => '⚙️ Beállítások';

  @override
  String get searchRecipe => 'Recept keresése…';

  @override
  String get loadingRecipes => 'Receptek betöltése…';

  @override
  String get loadingRecipe => 'Recept betöltése…';

  @override
  String errorLoadingRecipes(String error) {
    return 'Hiba a receptek betöltésekor: $error';
  }

  @override
  String get errorLoadingRecipe => 'A recept betöltése nem sikerült.';

  @override
  String get noRecipesForCategory => 'Nincs recept ehhez a szűrőhöz.';

  @override
  String get resetFilter => 'Szűrő visszaállítása';

  @override
  String get allCategories => 'Minden kategória';

  @override
  String get all => 'Mind';

  @override
  String get sortRecipes => 'Receptek rendezése';

  @override
  String get refreshRecipes => 'Frissítés';

  @override
  String get sortNameAZ => 'Név A–Z';

  @override
  String get sortNameZA => 'Név Z–A';

  @override
  String get sortDateNewest => 'Legújabb elöl';

  @override
  String get sortDateOldest => 'Legrégebbi elöl';

  @override
  String get sortPrepTimeShort => 'Legrövidebb előkészítés';

  @override
  String get sortPrepTimeLong => 'Leghosszabb előkészítés';

  @override
  String get sortRatingHighest => 'Legjobb értékelés';

  @override
  String get sortRatingLowest => 'Legrosszabb értékelés';

  @override
  String get details => 'Részletek';

  @override
  String get ingredients => 'Hozzávalók';

  @override
  String get instructions => 'Elkészítés';

  @override
  String get tags => 'Címkék';

  @override
  String get notes => 'Jegyzetek';

  @override
  String get addNote => 'Jegyzet hozzáadása';

  @override
  String get editNote => 'Jegyzet szerkesztése';

  @override
  String get noteTitleHint => 'Cím (opcionális)';

  @override
  String get noteTextHint => 'Jegyzet szövege';

  @override
  String get deleteNoteTitle => 'Törli a jegyzetet?';

  @override
  String get deleteNoteMessage => 'Ez a jegyzet véglegesen törlődik.';

  @override
  String get servings => 'Adagok';

  @override
  String get adjustQuantity => 'Mennyiség módosítása';

  @override
  String get startTimer => 'Időzítő indítása';

  @override
  String runningTimer(int minutes, String seconds) {
    return 'Időzítő: $minutes:$seconds';
  }

  @override
  String get planMeal => 'Étkezés tervezése';

  @override
  String get displayAlwaysOn => 'Képernyő ébren tartása';

  @override
  String get addAllIngredients => 'Összes hozzávaló hozzáadása';

  @override
  String get addSelectedIngredients => 'Kijelölt hozzávalók hozzáadása';

  @override
  String get addIngredientsTitle => 'Hozzávalók hozzáadva';

  @override
  String get addIngredientsMessage =>
      'A hozzávalók felkerültek a bevásárlólistádra.';

  @override
  String addIngredientsFailedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hozzávalót nem sikerült hozzáadni.',
      one: '1 hozzávalót nem sikerült hozzáadni.',
    );
    return '$_temp0';
  }

  @override
  String get cookbooks => 'Szakácskönyvek';

  @override
  String get cookbooksEmpty =>
      'Még nincsenek szakácskönyvek. Koppints a jobb felső „+” gombra egy létrehozásához.';

  @override
  String get cookbookNoMatches => 'Egy recept sem felel meg ennek a szűrőnek.';

  @override
  String get cookbookCreateTitle => 'Szakácskönyv létrehozása';

  @override
  String get cookbookEditTitle => 'Szakácskönyv szerkesztése';

  @override
  String get cookbookNameLabel => 'Szakácskönyv neve';

  @override
  String get cookbookFilterSectionTitle => 'Receptek automatikus hozzáadása';

  @override
  String get cookbookFieldTools => 'Eszközök';

  @override
  String get cookbookFieldUsers => 'Felhasználók';

  @override
  String get cookbookOpIsOneOf => 'az egyik ezek közül';

  @override
  String get cookbookOpIsNotOneOf => 'egyik sem ezek közül';

  @override
  String get cookbookOpContainsAll => 'mindet tartalmazza';

  @override
  String get cookbookSelectValues => 'Értékek kiválasztása';

  @override
  String get cookbookFilterOptionsUnavailable => 'Nincs elérhető lehetőség';

  @override
  String get cookbookAddFilterField => 'Mező hozzáadása';

  @override
  String get cookbookPublicLabel => 'Nyilvános szakácskönyv';

  @override
  String get cookbookPublicSubtitle =>
      'Látható a szerver többi háztartása számára';

  @override
  String get cookbookRawModeEnter => 'Szerkesztés szövegként';

  @override
  String get cookbookRawModeExit => 'Vissza az összeállítóhoz';

  @override
  String get cookbookRawModeHint =>
      'Ennek az appnak a szakértői módja: közvetlenül szövegként szerkeszti a szűrőt. Akkor hasznos, ha egy meglévő szűrőt nem sikerült egyszerű sorokra bontani.';

  @override
  String get cookbookRawModeUnparseable =>
      'Ez a szöveg nem felel meg az egyszerű sor-formátumnak — szövegként marad.';

  @override
  String get saveFailed => 'A mentés sikertelen';

  @override
  String get search => 'Keresés';

  @override
  String get apply => 'Alkalmaz';

  @override
  String get setupCachingTitle => 'Receptek betöltése';

  @override
  String get setupCachingSubtitle =>
      'A receptjeidet előkészítjük az offline használatra. A számuktól függően ez eltarthat egy pillanatig.';

  @override
  String get setupCachingDone => 'Minden kész!';

  @override
  String get setupTipsHeader => 'Tudtad?';

  @override
  String get setupFinish => 'Kezdjük!';

  @override
  String get setupSkipCaching => 'Folytatás a háttérben';

  @override
  String get setupTip1 =>
      'Recepteket importálhatsz linkből, fotóból vagy PDF-ből — a kezdőlap Importálás csempéjével.';

  @override
  String get setupTip2 =>
      'A főzési mód ébren tartja a képernyőt, lépésről lépésre vezet, és automatikusan felismeri az időzítőket a szövegben.';

  @override
  String get setupTip3 =>
      'A bevásárlólista offline is működik — a változások automatikusan szinkronizálódnak, amint a szerver elérhető.';

  @override
  String get setupTip4 =>
      'Tartsd nyomva a kezdőlap egyik csempéjét a gyorselérés átrendezéséhez.';

  @override
  String get setupTip5 =>
      'A Mealie szakácskönyveidet a Szakácskönyvek csempén találod — offline támogatással.';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Mégse';

  @override
  String get delete => 'Törlés';

  @override
  String get edit => 'Szerkesztés';

  @override
  String get save => 'Mentés';

  @override
  String get done => 'Kész';

  @override
  String get close => 'Bezárás';

  @override
  String get add => 'Hozzáadás';

  @override
  String get send => 'Küldés';

  @override
  String get retry => 'Újra';

  @override
  String get confirmDeleteTitle => 'Törlöd a receptet?';

  @override
  String get confirmDeleteMessage => 'Ez a művelet nem vonható vissza.';

  @override
  String get sendToDevice => 'Küldés eszközre';

  @override
  String get sendToDevicePickerTitle => 'Küldés eszközre';

  @override
  String get sendToAllDevices => 'Küldés minden eszközre';

  @override
  String get timerFinished => 'Az időzítő lejárt!';

  @override
  String get timerFinishedBody => 'A recept időzítője lejárt.';

  @override
  String get timer => 'Időzítő';

  @override
  String get newTimer => 'Új időzítő';

  @override
  String get timerDetails => 'Időzítő részletei';

  @override
  String get timerNamePlaceholder => 'Időzítő neve';

  @override
  String get timerNameHint => 'Adj az időzítőnek beszédes nevet.';

  @override
  String get durationLabel => 'Időtartam';

  @override
  String minutesCount(int count) {
    return '$count perc';
  }

  @override
  String get start => 'Indítás';

  @override
  String get stop => 'Leállítás';

  @override
  String get pause => 'Szünet';

  @override
  String get resume => 'Folytatás';

  @override
  String get finished => 'Kész!';

  @override
  String stepNumber(int number) {
    return '$number. lépés';
  }

  @override
  String get minAbbreviation => 'perc';

  @override
  String get cookingMode => 'Főzési mód';

  @override
  String activeRecipesCount(int count) {
    return '$count aktív recept';
  }

  @override
  String get endAll => 'Összes befejezése';

  @override
  String get end => 'Befejezés';

  @override
  String get endAllRecipesTitle => 'Befejezed az összes receptet?';

  @override
  String endAllRecipesMessage(int count) {
    return 'Befejezed mind a(z) $count aktív főzést?';
  }

  @override
  String get endRecipeTitle => 'Befejezed a receptet?';

  @override
  String endRecipeMessage(String name) {
    return 'Befejezed a(z) \"$name\" főzését?';
  }

  @override
  String get noActiveTimers => 'Nincs aktív időzítő';

  @override
  String get noActiveRecipes => 'Nincs aktív recept';

  @override
  String get startRecipeToCook =>
      'Nyiss meg egy receptet, és koppints a főzési mód gombra a kezdéshez.';

  @override
  String get browseRecipes => 'Receptek böngészése';

  @override
  String timersPausedCount(int count) {
    return '$count időzítő szüneteltetve';
  }

  @override
  String get cookFriends => 'Főzés barátokkal';

  @override
  String get cookingModeAddRecipe => 'Recept hozzáadása';

  @override
  String get cookingModeAddRecipeSearchHint => 'Receptek keresése';

  @override
  String get cookFriendsCode => 'Munkamenet-kód';

  @override
  String get cookFriendsJoin => 'Csatlakozás munkamenethez';

  @override
  String get cookFriendsHost => 'Munkamenet indítása';

  @override
  String get cookFriendsHostNotFound =>
      'A házigazda nem található. Győződj meg róla, hogy mindkét eszköz ugyanazon a Wi-Fi-hálózaton van, és a helyi hálózati hozzáférés engedélyezett.';

  @override
  String get cookFriendsConnectionFailed =>
      'A kapcsolódás nem sikerült. Próbáld újra.';

  @override
  String get cookFriendsEnterCode => 'Add meg a kódot';

  @override
  String cookFriendsConnected(int count) {
    return 'Csatlakozva: $count vendég';
  }

  @override
  String get joinSession => 'Csatlakozás munkamenethez';

  @override
  String get hostEndedSessionTitle => 'A munkamenet véget ért';

  @override
  String get hostEndedSessionMessage => 'A házigazda befejezte a közös főzést.';

  @override
  String get shoppingListEmpty => 'A bevásárlólistád üres.';

  @override
  String get addItem => 'Tétel hozzáadása';

  @override
  String get itemNote => 'Tétel neve';

  @override
  String get unlabeledCategory => 'Címke nélkül';

  @override
  String get reorderCategories => 'Kategóriák átrendezése';

  @override
  String get archiveChecked => 'Kipipált tételek archiválása';

  @override
  String get archivedLists => '📦 Archivált bevásárlások';

  @override
  String get syncChanges => 'Változások szinkronizálása';

  @override
  String get noSyncChanges => 'Nincs szinkronizálandó változás';

  @override
  String get postimportAction => 'Importálás után';

  @override
  String get postimportHint =>
      'Válaszd ki, mi történjen a forrásalkalmazásban (Emlékeztetők / Google Feladatok) az importált elemekkel.';

  @override
  String get postimportLeave => 'Csak hozzáadás';

  @override
  String get postimportComplete => 'Kipipálás';

  @override
  String get postimportCompleteDelete => 'Kipipálás és törlés';

  @override
  String get postimportFailed =>
      'Az utómunka a forrásalkalmazásban nem sikerült. A tételek ettől függetlenül bekerültek a Mealie-be.';

  @override
  String get syncChangesTitle => 'Változások szinkronizálása';

  @override
  String get syncSectionChecked => 'Kipipálva';

  @override
  String get syncSectionQuantity => 'Mennyiség';

  @override
  String get syncSectionCategory => 'Kategória';

  @override
  String get syncSectionAdditions => 'Újonnan hozzáadva';

  @override
  String get syncLocalLabel => 'Helyi';

  @override
  String get syncServerLabel => 'Szerver';

  @override
  String get syncNow => 'Szinkronizálás most';

  @override
  String get offlineBadge => 'Offline';

  @override
  String get mealplanTitle => '📅 Étkezési terv';

  @override
  String get mealplanSelectMode => 'Több recept kiválasztása';

  @override
  String mealplanSelectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kiválasztva',
      one: '1 kiválasztva',
      zero: 'Kiválasztás',
    );
    return '$_temp0';
  }

  @override
  String get breakfast => 'Reggeli';

  @override
  String get lunch => 'Ebéd';

  @override
  String get dinner => 'Vacsora';

  @override
  String get addMealEntry => 'Étkezés hozzáadása';

  @override
  String get selectRecipe => 'Recept kiválasztása';

  @override
  String get orFreeText => 'vagy szabad szöveg';

  @override
  String get entryNote => 'Jegyzet';

  @override
  String get noMealEntries => 'Nincs bejegyzés erre a hétre.';

  @override
  String get importRecipe => 'Recept importálása';

  @override
  String get importFromUrl => 'Importálás URL-ből';

  @override
  String get importFromImage => 'Importálás fotóból';

  @override
  String get importFromJson => 'Importálás JSON-ből';

  @override
  String get url => 'URL';

  @override
  String get urlPlaceholder => 'https://...';

  @override
  String get importLanguage => 'OCR nyelve';

  @override
  String get importing => 'Importálás…';

  @override
  String get importSuccess => 'A recept sikeresen importálva!';

  @override
  String importError(String error) {
    return 'Az importálás nem sikerült: $error';
  }

  @override
  String get pasteJson => 'Illeszd be ide a JSON-t';

  @override
  String get setupTitle => 'Üdvözöl a Mealie Recipes';

  @override
  String get setupSubtitle => 'Állítsd be a Mealie szerveredet.';

  @override
  String get serverUrl => 'Szerver URL';

  @override
  String get serverUrlPlaceholder => 'https://mealie.example.com';

  @override
  String get apiToken => 'API token';

  @override
  String get apiTokenPlaceholder => 'Az API tokened';

  @override
  String get householdId => 'Háztartás';

  @override
  String get householdIdPlaceholder => 'Family';

  @override
  String get shoppingListId => 'Bevásárlólista';

  @override
  String get shoppingListIdPlaceholder => 'Válassz bevásárlólistát';

  @override
  String get setupHouseholdListTitle => 'Háztartás és bevásárlólista';

  @override
  String get shoppingListLabel => 'Bevásárlólista';

  @override
  String get setupHouseholdManualHint =>
      'A háztartásokat nem sikerült betölteni — írd be a nevet kézzel.';

  @override
  String get setupExactTitle => 'Mennyiségek a bevásárlólistán';

  @override
  String get setupExactBody =>
      'A legtöbb országban nem grammra pontosan vásárolunk — a kosárba 1 csomag vaj kerül, nem 200 g. Egyszerű módban ezért az app a receptek mennyiségeit „1×”-re alakítja. Pontos módban a mennyiség és a mértékegység 1:1-ben megmarad, ahogy a Mealie webappban — új tételek beírásakor is (pl. „200 g vaj”). Ezt bármikor módosíthatod a beállításokban.';

  @override
  String get setupExactSimpleTitle => 'Egyszerű mód (1×)';

  @override
  String get setupExactSimpleBody =>
      'A hozzávalók „1× tétel”-ként kerülnek a listára — ideális a gyors kipipáláshoz a boltban.';

  @override
  String get setupExactExactTitle => 'Pontos mennyiségek';

  @override
  String get setupExactExactBody =>
      'A tételek mennyiséggel és mértékegységgel jelennek meg, pl. „200 g vaj” — pont mint a webappban.';

  @override
  String get connect => 'Kapcsolódás';

  @override
  String get connecting => 'Kapcsolódás…';

  @override
  String get connectionSuccess => 'Sikeres kapcsolódás!';

  @override
  String connectionError(String error) {
    return 'A kapcsolódás nem sikerült: $error';
  }

  @override
  String get optionalHeaders => 'Opcionális HTTP-fejlécek (reverse proxyhoz)';

  @override
  String get settingsTitle => '⚙️ Beállítások';

  @override
  String get settingsSaved => 'Beállítások mentve';

  @override
  String get serverSettings => 'Szerver';

  @override
  String get displaySettings => 'Megjelenítés';

  @override
  String get notificationSettings => 'Értesítések';

  @override
  String get securitySettings => 'Biztonság';

  @override
  String get aboutSettings => 'Névjegy';

  @override
  String get showRecipeImages => 'Receptképek megjelenítése';

  @override
  String get apiVersion => 'API-verzió';

  @override
  String get language => 'Nyelv';

  @override
  String get biometricLock => 'Biometrikus zár';

  @override
  String get biometricLockDescription => 'Alkalmazás feloldása biometriával';

  @override
  String get criticalAlerts => 'Kritikus riasztások';

  @override
  String get criticalAlertsDescription => 'Időzítő-riasztás néma módban is';

  @override
  String get enableLogging => 'Naplózás bekapcsolása';

  @override
  String get selectLanguage => 'Válassz nyelvet';

  @override
  String get setupContinue => 'Tovább';

  @override
  String get back => 'Vissza';

  @override
  String get setupConnectStep => 'Kapcsolódj a szerveredhez';

  @override
  String get resetSettings => 'Minden beállítás visszaállítása';

  @override
  String get resetSettingsConfirm =>
      'Ez minden beállítást visszaállít. Folytatod?';

  @override
  String get guestMode => 'Vendégmód';

  @override
  String get appVersion => 'Verzió';

  @override
  String get leftoverFinder => 'Receptkereső';

  @override
  String get leftoverFinderSubtitle =>
      'Találj recepteket a meglévő hozzávalóidhoz';

  @override
  String get addIngredient => 'Hozzávaló hozzáadása';

  @override
  String get ingredientPlaceholder => 'pl. tojás';

  @override
  String get findRecipes => 'Receptek keresése';

  @override
  String get matchingRecipes => 'Találó receptek';

  @override
  String get noMatchingRecipes => 'Nincs recept ezekhez a hozzávalókhoz.';

  @override
  String matchPercent(int percent) {
    return '$percent% egyezés';
  }

  @override
  String get biometricPrompt =>
      'Hitelesítsd magad a Mealie Recipes megnyitásához';

  @override
  String get biometricFailed => 'A hitelesítés nem sikerült';

  @override
  String get whatsNew => 'Újdonságok';

  @override
  String get pendingRecipesTitle => 'Kapott receptek';

  @override
  String pendingRecipesMessage(String sender, String name) {
    return '$sender receptet küldött neked: \"$name\"';
  }

  @override
  String pendingRecipesFrom(Object names) {
    return 'Feladó: $names';
  }

  @override
  String get pendingRecipesOpenCooking => 'Főzési mód megnyitása';

  @override
  String get pendingRecipesLater => 'Később';

  @override
  String get openRecipe => 'Recept megnyitása';

  @override
  String get dismiss => 'Elvetés';

  @override
  String get editRecipe => 'Recept szerkesztése';

  @override
  String get recipeName => 'Recept neve';

  @override
  String get recipeDescription => 'Leírás';

  @override
  String get prepTime => 'Előkészítés (perc)';

  @override
  String get cookTime => 'Főzési idő (perc)';

  @override
  String get totalTime => 'Teljes idő (perc)';

  @override
  String get recipeServings => 'Adagok';

  @override
  String get rating => 'Értékelés';

  @override
  String get addIngredientLine => 'Hozzávaló hozzáadása';

  @override
  String get addInstruction => 'Lépés hozzáadása';

  @override
  String get removeIngredient => 'Hozzávaló eltávolítása';

  @override
  String get removeInstruction => 'Lépés eltávolítása';

  @override
  String get ingredientName => 'Hozzávaló';

  @override
  String get ingredientQuantity => 'Menny.';

  @override
  String get ingredientUnit => 'Egység';

  @override
  String get ingredientNote => 'Jegyzet';

  @override
  String get instructionText => 'Lépés szövege';

  @override
  String get categories => 'Kategóriák';

  @override
  String get selectCategories => 'Kategóriák kiválasztása';

  @override
  String get selectTags => 'Címkék kiválasztása';

  @override
  String get uploadImage => 'Kép feltöltése';

  @override
  String get removeImage => 'Kép eltávolítása';

  @override
  String get saveChanges => 'Változások mentése';

  @override
  String get saving => 'Mentés…';

  @override
  String get saveSuccess => 'Recept mentve.';

  @override
  String saveError(String error) {
    return 'A mentés nem sikerült: $error';
  }

  @override
  String get newCategory => 'Új kategória';

  @override
  String get newTag => 'Új címke';

  @override
  String get setRating => 'Értékelés megadása';

  @override
  String get removeRating => 'Értékelés törlése';

  @override
  String get ratingRemoved => 'Értékelés törölve';

  @override
  String get googleTasksImport => 'Importálás a Google Feladatokból';

  @override
  String get googleTasksImportDescription =>
      'Elemek importálása a Google Feladatokból a bevásárlólistádra.';

  @override
  String get homeWelcome => 'Üdvözöl a Mealie Recipes! 👋';

  @override
  String homeWelcomeNamed(String name) {
    return 'Üdv, $name, a Mealie Recipes appban! 👋';
  }

  @override
  String get shopping => 'Bevásárlás';

  @override
  String get planning => 'Tervezés';

  @override
  String get other => 'Egyéb';

  @override
  String get viewRecipes => '📖 Receptek megtekintése';

  @override
  String get addRecipe => '➕ Recept hozzáadása';

  @override
  String get completeShopping => 'Bevásárlás befejezése';

  @override
  String get shoppingCompleted => 'Bevásárlás kész';

  @override
  String get shoppingCompletedSubtitle => 'Minden a kosárban! 🎉';

  @override
  String get essensplan => '📅 Étkezési terv';

  @override
  String get resteverwertung => '🥗 Receptkereső';

  @override
  String get newRecipeUpload => 'Új recept feltöltése';

  @override
  String get copyCode => 'Kód másolása';

  @override
  String get shareLink => 'Link megosztása';

  @override
  String get connectedFriends => 'Csatlakozott barátok';

  @override
  String get waitingForFriends => 'Várakozás a barátokra…';

  @override
  String get endSharing => 'Megosztás befejezése';

  @override
  String get cookFriendsDescription =>
      'Hívj meg egy barátot, hogy együtt főzzétek meg ezt a receptet';

  @override
  String get sessionCode => 'MUNKAMENET-KÓD';

  @override
  String get adjustQuantityLabel => 'Mennyiség módosítása ehhez a recepthez:';

  @override
  String get timerStartForStep => 'Időzítő a lépéshez';

  @override
  String get enterRecipeUrl => 'Add meg a recept URL-jét';

  @override
  String get loading => 'Betöltés…';

  @override
  String get urlInvalidScheme =>
      'Az URL-nek http:// vagy https:// előtaggal kell kezdődnie';

  @override
  String get urlAddScheme => 'https:// hozzáadása';

  @override
  String get addItemPlaceholder => 'Tétel hozzáadása…';

  @override
  String get addSuccessToast => 'Hozzáadva!';

  @override
  String get completedItems => 'Kész';

  @override
  String get completeShoppingTitle => 'Befejezed a bevásárlást?';

  @override
  String get completeShoppingMessage => 'Törlöd a kipipált tételeket?';

  @override
  String get recipeListTitle => '📖 Receptek';

  @override
  String get importRecipeTitle => 'Új recept feltöltése';

  @override
  String get uploadRecipeUrl => 'Importálás recept-URL-ből';

  @override
  String get uploadRecipeUrlHint =>
      'Add meg a recept URL-jét, hogy elmentsd a szerveredre';

  @override
  String get uploadOpenAI => 'Importálás fájlból OpenAI-jal';

  @override
  String get uploadOpenAIHint =>
      'Vagy tölts fel fényképeket vagy egy PDF-et a receptről. Ha a recept több oldalas, adj hozzá több oldalt — a mesterséges intelligencia együtt elemzi őket.';

  @override
  String get takePhoto => 'Kamera';

  @override
  String get cameraPermissionDenied =>
      'Nincs hozzáférés a kamerához. Engedélyezd a rendszerbeállításokban, hogy receptet fényképezhess.';

  @override
  String get cameraUnavailable => 'Ezen az eszközön nem érhető el kamera.';

  @override
  String get selectPhoto => 'Fotók';

  @override
  String get selectPdf => 'PDF';

  @override
  String get openAIHintTitle => 'Fájlelemzési infó';

  @override
  String get openAIHintBody =>
      'A receptelemzés az OpenAI API-t használja. Győződj meg róla, hogy az API-kulcs be van állítva a Mealie szerver beállításaiban.';

  @override
  String get allDeleteConfirm => 'Összes törlése';

  @override
  String get portionen => 'Adagok';

  @override
  String get timerForStep => 'Időzítő indítása ehhez a lépéshez';

  @override
  String get weekNavPrev => 'Előző hét';

  @override
  String get weekNavNext => 'Következő hét';

  @override
  String get noMealsThisWeek => 'Nincs betervezett étkezés';

  @override
  String get entriesInOtherWeeks => 'Más hetekben vannak bejegyzések';

  @override
  String get availableWeeks => 'Elérhető hetek:';

  @override
  String weekRange(Object end, Object start, Object week) {
    return '$week. hét ($start – $end)';
  }

  @override
  String get currentWeek => 'Aktuális hét';

  @override
  String get rezepteAktualisieren => 'Receptek frissítése';

  @override
  String get leftoverWhatTitle => 'Mit csinál ez?';

  @override
  String get leftoverWhatBody =>
      'Ez a funkció újratölti az összes receptet a szerverről, és frissíti a helyi gyorsítótárat.';

  @override
  String get leftoverDescription =>
      'Add meg az otthon lévő hozzávalókat, hogy találó recepteket kapj, és felhasználd a maradékokat.';

  @override
  String get leftoverIngredientsHeader => 'Otthoni hozzávalók';

  @override
  String get leftoverSuggestions => 'Receptjavaslatok';

  @override
  String get leftoverNoMatches => 'Nem található megfelelő recept.';

  @override
  String get leftoverEnterIngredient => 'Hozzávaló megadása';

  @override
  String matchingPercentText(int percent, int count, int total) {
    return '$percent% egyezés ($count/$total)';
  }

  @override
  String get weekAbbreviation => 'Hét';

  @override
  String get today => 'Ma';

  @override
  String get selectDate => 'Dátum kiválasztása';

  @override
  String get selectSlot => 'Étkezés kiválasztása';

  @override
  String get selectedRecipe => 'Kiválasztott recept';

  @override
  String get confirmMeal => 'Étkezés betervezése';

  @override
  String get searchRecipes => 'Receptek keresése';

  @override
  String get addCustomMeal => 'Egyéni étkezés hozzáadása';

  @override
  String get diceModeButton => 'Véletlenszerű receptek';

  @override
  String get diceModeTitle => '3 véletlenszerű javaslat';

  @override
  String get diceBackToSearch => 'Vissza a kereséshez';

  @override
  String get diceNotEnoughRecipes =>
      'Nincs elég recept a véletlen módhoz (legalább 3 kell)';

  @override
  String get entrySingular => 'bejegyzés';

  @override
  String get entriesPlural => 'bejegyzés';

  @override
  String listTitle(int n) {
    return '$n. lista';
  }

  @override
  String get deleteAllConfirmTitle => 'Mindent törölsz?';

  @override
  String get deleteAllConfirmMessage =>
      'Törölni szeretnéd az összes archivált bevásárlást?';

  @override
  String get uploadFromUrlButton => 'Recept importálása URL-ből';

  @override
  String get uploadingImage => 'Feltöltés…';

  @override
  String get uploadErrorTitle => 'A feltöltés nem sikerült';

  @override
  String get uploadSuccessTitle => 'Sikeres feltöltés';

  @override
  String get editImportedRecipeQuestion =>
      'Szeretnéd most szerkeszteni az új receptet?';

  @override
  String get notNow => 'Most nem';

  @override
  String get pdfTooLarge => 'A PDF-fájl túl nagy (max. 10 MB).';

  @override
  String get invalidUrl =>
      'Érvénytelen URL. Adj meg egy érvényes HTTP(S) URL-t.';

  @override
  String get cookWithFriends => 'Főzés barátokkal';

  @override
  String get cookFriendsSubtitle =>
      'Hívj meg egy barátot, hogy együtt főzzétek meg ezt a receptet';

  @override
  String get copied => 'Másolva';

  @override
  String get linkCopied => 'Link másolva';

  @override
  String get startCooking => 'Főzés indítása';

  @override
  String get hostNoRecipe =>
      'Nyisd meg egy receptből, hogy munkamenetet indíts';

  @override
  String get uploadToOwnServer => 'Mentés a saját szerveremre';

  @override
  String get uploadingRecipe => 'Recept feltöltése…';

  @override
  String get recipeUploadedToOwnServer => 'Recept elmentve a szerveredre';

  @override
  String get recipeUploadFailed => 'A feltöltés nem sikerült';

  @override
  String get allowGuestSaveRecipes =>
      'A vendégek elmenthetik a recepteket a saját szerverükre';

  @override
  String get appIcon => 'Alkalmazásikon';

  @override
  String get appIconClassic => 'Classic';

  @override
  String get appIconModern => 'Modern';

  @override
  String get name => 'Név';

  @override
  String get color => 'Szín';

  @override
  String get randomColor => 'Véletlen szín';

  @override
  String get createFailed => 'A létrehozás nem sikerült';

  @override
  String get deleteFailed => 'A törlés nem sikerült';

  @override
  String deleteOrganizerConfirm(String name) {
    return 'Törlöd: \"$name\"? Ez a szerverről is eltávolítja.';
  }

  @override
  String get connectionSection => 'Kapcsolat';

  @override
  String get token => 'Token';

  @override
  String get advancedOptions => 'Speciális beállítások';

  @override
  String get mealieApiVersion => 'Mealie API-verzió';

  @override
  String get sendOptionalHeaders => 'Opcionális fejlécek küldése';

  @override
  String get offlineRecipeImages => 'Receptképek mentése offline használatra';

  @override
  String get offlineRecipeImagesHint =>
      'Letölti az összes receptképet erre az eszközre, hogy kapcsolat nélkül is megjelenjenek. Nagy gyűjteményeknél ez több száz MB-ot is elfoglalhat. Kikapcsoláskor a mentett képek törlődnek.';

  @override
  String offlineRecipeImagesStatus(int count, int total, String size) {
    return 'Mentve: $count/$total · $size';
  }

  @override
  String get offlineRecipeImagesDisableConfirm =>
      'Törlöd az összes mentett receptképet?';

  @override
  String headerNameLabel(int n) {
    return '$n. fejléc neve';
  }

  @override
  String headerValueLabel(int n) {
    return '$n. fejléc értéke';
  }

  @override
  String get value => 'Érték';

  @override
  String get personalization => 'Személyre szabás';

  @override
  String get showRecipeImagesSubtitle => 'Képek megjelenítése a receptlistában';

  @override
  String get exactQuantities => 'Pontos mennyiségek hozzáadása';

  @override
  String get exactQuantitiesSubtitle =>
      'A hozzávalók és a beírt tételek megtartják a mennyiséget és a mértékegységet (pl. 200 g vaj) darabonkénti 1x helyett — a hiányzó alapanyagokat az app létrehozza a szerveren';

  @override
  String get remindToShop => 'Emlékeztess bevásárolni';

  @override
  String get remindToShopSubtitle =>
      'Értesít, ha egy mentett hely közelében vagy, és a bevásárlólistán nyitott tételek vannak — akkor is, ha az alkalmazás be van zárva';

  @override
  String get shoppingReminderAddLocation => 'Hely hozzáadása';

  @override
  String get shoppingReminderMaxLocations => 'Legfeljebb 3 hely érhető el';

  @override
  String get shoppingReminderLocationServiceDisabled =>
      'A helymeghatározás ki van kapcsolva ezen az eszközön';

  @override
  String get shoppingReminderPermissionTitle => 'Helyhozzáférés szükséges';

  @override
  String get shoppingReminderPermissionMessage =>
      'Ahhoz, hogy egy üzlet közelében értesítést kapj, „Mindig engedélyezve” helyhozzáférésre van szükség — akkor is, ha az alkalmazás be van zárva. Kérjük, engedélyezd a Beállításokban.';

  @override
  String get openSettings => 'Beállítások megnyitása';

  @override
  String get shoppingReminderLocationName => 'Név';

  @override
  String get shoppingReminderUseCurrentLocation => 'Jelenlegi hely használata';

  @override
  String get shoppingReminderOrAddress => 'vagy adj meg egy címet';

  @override
  String get shoppingReminderAddress => 'Cím';

  @override
  String get shoppingReminderAddressPlaceholder => 'Utca, város';

  @override
  String get shoppingReminderSearchAddress => 'Keresés';

  @override
  String get shoppingReminderLocationFailed => 'A hely nem volt megállapítható';

  @override
  String get shoppingReminderAddressNotFound => 'A cím nem található';

  @override
  String get ratingFailed =>
      'Az értékelést nem sikerült menteni — próbáld újra.';

  @override
  String get lastCooked => 'Utoljára elkészítve';

  @override
  String get syncLastCooked => '„Utoljára elkészítve” frissítése';

  @override
  String get syncLastCookedSubtitle =>
      'Elmenti a mai dátumot és egy idővonal-bejegyzést a szerverre — ahogy a Mealie webapp.';

  @override
  String get developer => 'Fejlesztő';

  @override
  String get enableLoggingSubtitle =>
      'Print/hiba naplók rögzítése (utolsó 500 sor)';

  @override
  String get entriesLabel => 'Bejegyzések';

  @override
  String get fileSize => 'Fájlméret';

  @override
  String get showAction => 'Megjelenítés';

  @override
  String get copy => 'Másolás';

  @override
  String logsWithCount(int count) {
    return 'Naplók ($count)';
  }

  @override
  String get noLogs => 'Nincs elérhető napló';

  @override
  String get logsTitle => 'Naplók';

  @override
  String get required => 'Kötelező';

  @override
  String get connectionFailedCheck =>
      'A kapcsolódás nem sikerült. Ellenőrizd az URL-t és a tokent.';

  @override
  String get username => 'Felhasználónév';

  @override
  String get password => 'Jelszó';

  @override
  String get setupPasswordHint =>
      'A jelszavad nem kerül tárolásra — az app egyszer bejelentkezik vele, és abból API-tokent hoz létre (mint a webalkalmazásban a Profil → API-tokenek alatt).';

  @override
  String get loginAndConnect => 'Bejelentkezés és csatlakozás';

  @override
  String get loginInvalidCredentials => 'Hibás felhasználónév vagy jelszó.';

  @override
  String get loginAndGenerateToken => 'Bejelentkezés és token létrehozása';

  @override
  String get loggingIn => 'Bejelentkezés…';

  @override
  String get apiTokenSaveHint =>
      'Token alkalmazva — kérlek koppints lent a „Változtatások mentése” gombra.';

  @override
  String get renewApiToken => 'API-token megújítása';

  @override
  String get setupAuthChoiceTitle => 'Hogyan szeretnél bejelentkezni?';

  @override
  String get authModePasswordTitle =>
      'Az app hozzon létre nekem egy API-kulcsot';

  @override
  String get authModePasswordSubtitle =>
      'Jelentkezz be felhasználónévvel és jelszóval — az app automatikusan létrehoz egy tokent.';

  @override
  String get authModeTokenTitle => 'Már van API-kulcsom';

  @override
  String get authModeTokenSubtitle =>
      'A Mealie-profilból másolva (Profil → API-tokenek).';

  @override
  String keyN(int n) {
    return '$n. kulcs';
  }

  @override
  String valueN(int n) {
    return '$n. érték';
  }

  @override
  String get openCookingMode => 'Főzési mód megnyitása';

  @override
  String activeRecipes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count aktív recept',
      one: '1 aktív recept',
    );
    return '$_temp0';
  }

  @override
  String get reparseIngredients => 'Hozzávalók újraelemzése';

  @override
  String get reparseIngredientsSubtitle =>
      'Mennyiség/egység/hozzávaló szétválasztása (pl. „200 g liszt”)';

  @override
  String get reparseDone =>
      'Hozzávalók szétválasztva – koppints a „Változások mentése” gombra az alkalmazáshoz';

  @override
  String get reparseNone => 'Nem található szétválasztható hozzávaló';

  @override
  String get tagsAndCategories => 'Címkék, kategóriák és eszközök';

  @override
  String get tapToAddPhoto => 'Koppints fotó hozzáadásához';

  @override
  String get descriptionLabel => 'Leírás';

  @override
  String get searchingDevices =>
      'Eszközök keresése ugyanazon a Wi-Fi-hálózaton…';

  @override
  String get selectAll => 'Összes kijelölése';

  @override
  String get importReminders => 'Emlékeztetők importálása';

  @override
  String get importGoogleTasks => 'Google Feladatok importálása';

  @override
  String get noTaskLists => 'Nem található feladatlista';

  @override
  String get noReminderLists => 'Nem található emlékeztetőlista';

  @override
  String importCount(int count) {
    return '$count importálása';
  }

  @override
  String get activeRecipeTimer => 'Aktív receptidőzítő';

  @override
  String get linkIngredients => 'Hozzávalók összekapcsolása';

  @override
  String get noIngredientsToLink => 'Még nincs összekapcsolható hozzávaló';

  @override
  String get importLanguageSubtitle =>
      'A fotóból vagy PDF-ből importált receptek nyelve';

  @override
  String get importLanguageSearch => 'Nyelv keresése';

  @override
  String get importLanguageFollowApp => 'Mint az app nyelve';

  @override
  String get importLanguageNoMatch => 'Nem található nyelv';

  @override
  String get setupImportLanguageTitle => 'MI-alapú receptimportálás';

  @override
  String get setupImportLanguageBody =>
      'A fotókat és PDF-eket mesterséges intelligencia alakíthatja recepetté. Válaszd ki, milyen nyelven készüljenek el — hasznos, ha az anyanyelved nem érhető el app-nyelvként. Ezt később a beállításokban módosíthatod.';

  @override
  String get setupImportLanguageSearchHint =>
      'A választólista keresőjében olyan nyelveket is megtalálsz, amelyeket az app felülete nem kínál.';

  @override
  String get setupCachingKeepOpenTitle => 'Kérjük, hagyd nyitva az appot';

  @override
  String get setupCachingKeepOpenBody =>
      'A betöltés előtérben fut. Hagyd nyitva az appot, amíg befejeződik — ha bezárod vagy túl sokáig váltasz el, a folyamat megszakad, és később kezdődik elölről.';

  @override
  String get supportContact => 'Kapcsolat a támogatással';

  @override
  String get supportDialogMessage =>
      'Írd le a problémát, és jelentkezünk. A napló sokat segít a hibakeresésben — szöveges fájlként csatolhatod.';

  @override
  String get supportWithoutLogs => 'Napló nélkül';

  @override
  String get supportWithLogs => 'Napló csatolása';

  @override
  String get supportMailSubject => 'Mealie Recipes — Támogatás';

  @override
  String get supportMailHint => 'Itt írd le a problémát:';

  @override
  String get supportLogsEmpty =>
      'A napló üres. Kapcsold be a naplózást, idézd elő újra a problémát, és utána küldd el.';

  @override
  String supportAddressCopied(String email) {
    return 'Cím másolva: $email';
  }

  @override
  String supportNoMailApp(String email) {
    return 'Nem található levelezőalkalmazás. Cím másolva: $email';
  }

  @override
  String get createRecipeFromImages => 'Recept létrehozása';

  @override
  String imagePagesSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count oldal kiválasztva',
      one: '1 oldal kiválasztva',
    );
    return '$_temp0';
  }

  @override
  String get imagePagesHint =>
      'Az első kép lesz a recept főképe. Az átrendezéshez tartsd nyomva az oldalt.';

  @override
  String get mainImageBadge => 'Főkép';

  @override
  String maxImagesReached(int max) {
    return 'Legfeljebb $max kép receptenként.';
  }

  @override
  String get removePage => 'Oldal eltávolítása';

  @override
  String get preparingPdf => 'PDF feldolgozása...';

  @override
  String get shareRecipeTitle => 'Recept megosztása';

  @override
  String get recipeOptionsTitle => 'Lehetőségek';

  @override
  String get exportAsPdf => 'Exportálás PDF-be';

  @override
  String get generatingPdf => 'PDF létrehozása…';

  @override
  String get pdfExportFailed => 'A PDF-exportálás sikertelen';

  @override
  String get recipeTime => 'Idő';

  @override
  String get ingredientSectionTitle => 'Szakasz';

  @override
  String get addIngredientSection => 'Szakasz hozzáadása';

  @override
  String get aiImportToggle => 'Elemzés MI-vel';

  @override
  String get aiImportToggleHint =>
      'Receptvideókhoz (YouTube, Instagram, TikTok …) és olyan oldalakhoz is, amelyeket a normál importálás nem tud beolvasni. Ehhez MI-szolgáltató kell a Mealie-szervereden – videókhoz hangszolgáltató is.';

  @override
  String get aiImportButton => 'Importálás MI-vel';

  @override
  String get aiImportRunning =>
      'Az MI elemzi a linket … videóknál ez néhány percig is eltarthat.';

  @override
  String get aiImportFailed =>
      'Az MI-importálás sikertelen. Ellenőrizd a Mealie-szerver MI-beállításait.';

  @override
  String get stepHeadingLabel => 'Lépés címe (nem kötelező)';

  @override
  String get linkedRecipeLabel => 'Hivatkozott recept';

  @override
  String get toolsTitle => 'Eszközök';

  @override
  String get prepareTools => 'Készítsd elő a következő eszközöket';

  @override
  String get newTool => 'Új eszköz';

  @override
  String get renameAction => 'Átnevezés';

  @override
  String get organizerEmpty =>
      'Még nincs bejegyzés. Koppints a jobb felső „+” gombra egy új létrehozásához.';

  @override
  String organizerRecipeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count recept',
      one: '1 recept',
      zero: 'Nincs recept',
    );
    return '$_temp0';
  }

  @override
  String get toolOnHand => 'Megvan';

  @override
  String get mealDiceSettingsTitle => 'Kockaszűrő';

  @override
  String get mealDiceSettingsHint =>
      'Válassz kategóriákat és címkéket minden étkezéshez. A kocka ezután csak olyan recepteket javasol, amelyeknek legalább egy van ezek közül. Ugyanaz a választás több étkezésnél is használható.';

  @override
  String get mealDiceSettingsNoneHint =>
      'Ennél az étkezésnél nincs semmi kiválasztva: a kocka automatikusan választ olyan kategóriák alapján, mint „Reggeli”, „Ebéd” vagy „Vacsora”.';

  @override
  String get mealDiceAutoHintTitle => 'Automatikus választás';

  @override
  String get mealDiceAutoHintBody =>
      'Ehhez az étkezéshez még nincsenek kategóriák vagy címkék beállítva. A kocka ezért olyan kategóriákat keres, mint „Reggeli”, „Ebéd” vagy „Vacsora”, és más receptekkel egészíti ki.\n\nSaját választás: az étkezéstervben koppints a „+” melletti fogaskerékre.';

  @override
  String get dontShowAgain => 'Ne jelenjen meg többé';

  @override
  String get mealDiceNoMatches =>
      'Egyetlen recept sem illik az ehhez az étkezéshez választott kategóriákhoz és címkékhez.';

  @override
  String mealDiceFewMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Csak $count megfelelő recept',
      one: 'Csak 1 megfelelő recept',
    );
    return '$_temp0';
  }

  @override
  String get commentsTitle => 'Megjegyzések';

  @override
  String get commentHint => 'Írj megjegyzést…';

  @override
  String get commentSaveFailed => 'A megjegyzést nem sikerült menteni.';

  @override
  String get commentDeleteConfirm => 'Törlöd ezt a megjegyzést?';

  @override
  String get cookingDoneCommentLabel => 'Megjegyzés (nem kötelező)';

  @override
  String get cookingDoneCommentHint => 'Milyen lett? Tippek legközelebbre…';

  @override
  String get nutritionTitle => 'Tápérték';

  @override
  String get nutritionPerServing => 'adagonként';

  @override
  String get nutritionCalories => 'Kalória';

  @override
  String get nutritionFat => 'Zsír';

  @override
  String get nutritionSaturatedFat => 'Telített zsírsav';

  @override
  String get nutritionTransFat => 'Transzzsír';

  @override
  String get nutritionUnsaturatedFat => 'Telítetlen zsírsav';

  @override
  String get nutritionCholesterol => 'Koleszterin';

  @override
  String get nutritionSodium => 'Nátrium';

  @override
  String get nutritionCarbohydrates => 'Szénhidrát';

  @override
  String get nutritionFiber => 'Rost';

  @override
  String get nutritionSugar => 'Cukor';

  @override
  String get nutritionProtein => 'Fehérje';

  @override
  String get timelineTitle => 'Idővonal';

  @override
  String get timelineMadeThis => 'Elkészítettem ezt';

  @override
  String timelineUserMadeThis(String name) {
    return 'ezt $name készítette el';
  }

  @override
  String get timelineEmpty => 'Még nincs bejegyzés az idővonalon.';

  @override
  String get timelineDate => 'Dátum';

  @override
  String get timelineNoteHint => 'Megjegyzés (nem kötelező)';

  @override
  String get timelineAddPhoto => 'Fotó hozzáadása';

  @override
  String get timelineRemovePhoto => 'Fotó eltávolítása';

  @override
  String get timelineSaved => 'Hozzáadva az idővonalhoz';

  @override
  String get timelineSaveFailed => 'Nem sikerült hozzáadni az idővonalhoz';

  @override
  String get timelineImageFailed =>
      'A bejegyzés elmentve, de a fotót nem sikerült feltölteni';

  @override
  String get timelineDeleteConfirm => 'Törlöd ezt a bejegyzést az idővonalról?';

  @override
  String get timelineEditNote => 'Megjegyzés szerkesztése';

  @override
  String get timelineUnknownRecipe => 'A recept nem található';

  @override
  String get cookingDonePhotoHint =>
      'Fotó a Mealie idővonalához (nem kötelező)';

  @override
  String get assetsTitle => 'Mellékletek';

  @override
  String get assetsAdd => 'Melléklet hozzáadása';

  @override
  String get assetsChooseFile => 'Fájl';

  @override
  String get assetsUploading => 'Feltöltés…';

  @override
  String get assetsUploadFailed => 'A mellékletet nem sikerült feltölteni';

  @override
  String assetsDeleteConfirm(String name) {
    return 'Eltávolítod a(z) „$name” mellékletet?';
  }

  @override
  String get assetsOpenFailed => 'A mellékletet nem sikerült megnyitni';

  @override
  String get assetsUnsupported =>
      'A Mealie csak PDF-et, képeket, TXT-t, MD-t, CSV-t és JSON-t támogat.';

  @override
  String get assetsShare => 'Megosztás';

  @override
  String get mealRulesTitle => 'Mealie-szabályok';

  @override
  String get mealRulesHint =>
      'A Mealie webalkalmazás is ezeket használja. Ha több szabály vonatkozik a napra és az étkezésre, mindegyiknek teljesülnie kell. Ha egyik sem érvényes, a kocka az összes recept közül választ.';

  @override
  String get mealRuleAdd => 'Szabály hozzáadása';

  @override
  String get mealRuleNewTitle => 'Új szabály';

  @override
  String get mealRuleEditTitle => 'Szabály szerkesztése';

  @override
  String get mealRuleDay => 'Nap';

  @override
  String get mealRuleAnyDay => 'Bármely nap';

  @override
  String get mealRuleMealType => 'Étkezés';

  @override
  String get mealRuleAnyMeal => 'Bármely étkezés';

  @override
  String get mealRuleConditionsTitle => 'Feltételek';

  @override
  String get mealRuleAllRecipes => 'Összes recept';

  @override
  String get mealRuleDeleteConfirm => 'Törlöd ezt a szabályt?';

  @override
  String get mealRulesOffline =>
      'A Mealie-szabályok most nem érhetők el – a kocka az alkalmazás kiválasztását használja.';

  @override
  String get mealRulesNoMatches =>
      'Egy recept sem felel meg az étkezéshez tartozó Mealie-szabályoknak.';

  @override
  String get mealTypeSide => 'Köret';

  @override
  String get mealTypeSnack => 'Nasi';

  @override
  String get mealTypeDrink => 'Ital';

  @override
  String get mealTypeDessert => 'Desszert';

  @override
  String get foodsTitle => 'Alapanyagok';

  @override
  String get unitsTitle => 'Mennyiségi egységek';

  @override
  String get newFood => 'Új alapanyag';

  @override
  String get newUnit => 'Új mértékegység';

  @override
  String get editFood => 'Alapanyag szerkesztése';

  @override
  String get editUnit => 'Mértékegység szerkesztése';

  @override
  String get pluralNameLabel => 'Többes számú név';

  @override
  String get abbreviationLabel => 'Rövidítés';

  @override
  String get pluralAbbreviationLabel => 'Többes számú rövidítés';

  @override
  String get mergeAction => 'Összevonás';

  @override
  String mergeIntoTitle(String name) {
    return '„$name” összevonása ezzel…';
  }

  @override
  String mergeConfirm(String from, String to) {
    return 'A(z) „$from” összevonásra kerül ezzel: „$to”. Ezután minden recept és bevásárlólista a(z) „$to” elemet használja, a(z) „$from” törlődik.';
  }

  @override
  String get mergeFailed => 'Az összevonás nem sikerült';

  @override
  String foodUnitDeleteConfirm(String name) {
    return 'Törlöd: „$name”? Az ezt használó hozzávalók elveszítik a hivatkozást.';
  }

  @override
  String get foodsUnitsEmpty => 'Még nincsenek bejegyzések.';

  @override
  String mealRuleConditionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count feltétel',
      one: '1 feltétel',
    );
    return '$_temp0';
  }

  @override
  String get showAll => 'Összes megjelenítése';

  @override
  String get mealDiceModeTitle => 'A kocka ezt használja';

  @override
  String get mealDiceModeApp => 'Alkalmazás választása';

  @override
  String get switchListTitle => 'Lista váltása';

  @override
  String get newShoppingList => 'Új bevásárlólista';

  @override
  String shoppingListDeleteConfirm(String name) {
    return 'Törlöd: „$name”? A benne lévő összes tétel is törlődik.';
  }

  @override
  String get labelOrderTitle => 'Részlegek sorrendje';

  @override
  String get labelOrderHint =>
      'Húzd a rendezéshez. Erre a listára vonatkozik – a Mealie webalkalmazásban is.';

  @override
  String get labelOrderEmpty => 'Ennek a listának még nincsenek részlegei.';

  @override
  String get useAsActiveList => 'Használat aktív listaként';

  @override
  String get activeListBadge => 'Aktív';

  @override
  String get foodLabelLabel => 'Részleg';

  @override
  String get foodNoLabel => 'Nincs részleg';

  @override
  String get aliasesLabel => 'Álnevek';

  @override
  String get aliasAddHint => 'Álnév hozzáadása';

  @override
  String get foodOnHand => 'Otthon van készleten';

  @override
  String get timelineChildRecipesTitle =>
      'Hozzáadás a hivatkozott receptekhez is';

  @override
  String timelineMadeForRecipe(String recipe) {
    return 'Ehhez készült: $recipe';
  }

  @override
  String get timelineFilter => 'Bejegyzések szűrése';

  @override
  String get timelineTypeComment => 'Főzések és megjegyzések';

  @override
  String get timelineTypeInfo => 'Információk';

  @override
  String get timelineTypeSystem => 'Rendszer';

  @override
  String get listManagementTitle => 'Bevásárlólisták';

  @override
  String get managementTitle => 'Továbbiak';

  @override
  String get pinToHome => 'Hozzáadás a kezdőképernyőhöz';

  @override
  String get unpinFromHome => 'Eltávolítás a kezdőképernyőről';

  @override
  String homeScreenFull(int count) {
    return 'A kezdőképernyő megtelt – legfeljebb $count csempe. Előbb vegyél le egy másikat a „Továbbiak” alatt.';
  }

  @override
  String get selectAction => 'Kijelölés';

  @override
  String selectedCount(int count) {
    return '$count kijelölve';
  }

  @override
  String get assignLabelAction => 'Részleg hozzárendelése';

  @override
  String get assignLabelOverwriteHint =>
      'Felülírja az összes kijelölt alapanyag részlegét.';

  @override
  String deleteSelectedConfirm(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Törölsz $count bejegyzést?',
      one: 'Törölsz 1 bejegyzést?',
    );
    return '$_temp0';
  }

  @override
  String get seedDataAction => 'Alapadatok betöltése';

  @override
  String get seedFoodsHint =>
      'Létrehozza a Mealie alapértelmezett alapanyagait a választott nyelven.';

  @override
  String get seedUnitsHint =>
      'Létrehozza a Mealie alapértelmezett mértékegységeit a választott nyelven.';

  @override
  String get seedLanguageLabel => 'Nyelv';

  @override
  String get seedDuplicateWarning =>
      'Már vannak bejegyzéseid. A Mealie nem egyezteti a duplikátumokat – ezeket utána neked kell összevonnod.';

  @override
  String get seedDone => 'Alapadatok létrehozva';

  @override
  String get seedFailed => 'Az alapadatokat nem sikerült betölteni';

  @override
  String get exportAction => 'Exportálás';

  @override
  String get substitutionsLabel => 'Helyettesítők';

  @override
  String get substitutionAddHint => 'Helyettesítő hozzáadása';

  @override
  String get substitutionFoodLabel => 'Alapanyag (nem kötelező)';

  @override
  String get substitutionNoteLabel => 'Megjegyzés (nem kötelező)';

  @override
  String get substitutionNeedOne => 'Adj meg alapanyagot vagy megjegyzést';

  @override
  String get useAbbreviationLabel => 'Rövidítés használata';

  @override
  String get useAbbreviationHint =>
      'A receptekben „g” jelenik meg „gramm” helyett';

  @override
  String get fractionLabel => 'Megjelenítés törtként';

  @override
  String get fractionHint => '½ a 0,5 helyett';

  @override
  String get standardizationTitle => 'Szabványosítás';

  @override
  String get standardizationHint =>
      'Átváltáshoz: ebből az egységből 1 megfelel … (pl. 1 ek = 15 milliliter).';

  @override
  String get standardQuantityLabel => 'Standard mennyiség';

  @override
  String get standardUnitLabel => 'Szabványos egység';

  @override
  String get standardUnitNone => 'Nincs';

  @override
  String get stdFluidOunce => 'Folyadékuncia (fl oz)';

  @override
  String get stdCup => 'Csésze (US)';

  @override
  String get stdOunce => 'Uncia (oz)';

  @override
  String get stdPound => 'Font (lb)';

  @override
  String get stdMilliliter => 'Milliliter';

  @override
  String get stdLiter => 'Liter';

  @override
  String get stdGram => 'Gramm';

  @override
  String get stdKilogram => 'Kilogramm';

  @override
  String get labelsTitle => 'Részlegek';

  @override
  String get newLabel => 'Új részleg';

  @override
  String get editLabel => 'Részleg szerkesztése';

  @override
  String get colorLabel => 'Szín';

  @override
  String labelDeleteConfirm(String name) {
    return 'Törlöd: „$name”? A tételek és alapanyagok elveszítik ezt a részleget.';
  }

  @override
  String get importMenuAction => 'Importálás';

  @override
  String get archivedEmpty =>
      'Még nincsenek archivált bevásárlások. Bevásárlás után koppints a „Bevásárlás befejezése” gombra – a kipipált tételek ide kerülnek.';

  @override
  String get sectionTitleLabel => 'Szakasz címe';

  @override
  String get clearSection => 'Szakasz eltávolítása';

  @override
  String get noPermissionGeneric =>
      'Ehhez nincs jogosultságod a Mealie-ben. Kérdezz meg egy adminisztrátort vagy háztartáskezelőt.';

  @override
  String get noPermissionEditRecipe =>
      'Ezt a receptet nem szerkesztheted – zárolva van, vagy egy másik háztartásé. Csak a létrehozója vagy egy adminisztrátor teheti meg.';

  @override
  String get noPermissionDeleteRecipe =>
      'Csak a recept létrehozója vagy egy adminisztrátor törölheti.';

  @override
  String get noPermissionDemoteSelf =>
      'A saját adminisztrátori jogaidat nem veheted el.';

  @override
  String get recipeLockedHint => 'Zárolva – csak a létrehozója szerkesztheti';

  @override
  String get recipeDeleteOwnerOnlyHint =>
      'Csak a létrehozó vagy egy adminisztrátor törölheti';

  @override
  String get organizeReadOnlyHint =>
      'Csak megtekintés: a létrehozáshoz, módosításhoz és törléshez a „A felhasználó kezelheti az ételeket, a címkéket és a kategóriákat” jogosultság kell.';

  @override
  String get notesNotSavedNoPermission =>
      'A megjegyzés nincs mentve – nincs jogod szerkeszteni ezt a receptet.';

  @override
  String get userManagementTitle => 'Felhasználók kezelése';

  @override
  String get usersTitle => 'Felhasználók';

  @override
  String get editUserTitle => 'Felhasználó szerkesztése';

  @override
  String get fullNameLabel => 'Teljes név';

  @override
  String get usernameLabel => 'Felhasználónév';

  @override
  String get emailLabel => 'E-mail';

  @override
  String get passwordLabel => 'Jelszó';

  @override
  String get householdLabel => 'Háztartás';

  @override
  String get permissionsTitle => 'Engedélyek';

  @override
  String get administratorLabel => 'Adminisztrátor';

  @override
  String get permCanInvite => 'A felhasználó meghívhat másokat a csoportba';

  @override
  String get permCanManage => 'A felhasználó kezelheti a csoport beállításait';

  @override
  String get permCanManageHousehold => 'A felhasználó a háztartást kezelheti';

  @override
  String get permCanOrganize =>
      'A felhasználó kezelheti az ételeket, a címkéket és a kategóriákat';

  @override
  String get advancedFeaturesLabel => 'Haladó funkciók engedélyezése';

  @override
  String get passwordResetLinkAction =>
      'Jelszó visszaállítási link létrehozása';

  @override
  String get resetLockedUsersAction => 'Zárolt felhasználók feloldása';

  @override
  String get membersTitle => 'Tagok';

  @override
  String get inviteLinkTitle => 'Meghívó link';

  @override
  String get inviteAction => 'Meghívás';

  @override
  String get userUpdated => 'Felhasználó frissítve';

  @override
  String get createUserTitle => 'Felhasználó létrehozása';

  @override
  String get userCreated => 'Felhasználó létrehozva';

  @override
  String userDeleteConfirm(String name) {
    return 'Törlöd: „$name”? A fiók törlődik a Mealie-ből.';
  }

  @override
  String get passwordResetLinkCopied =>
      'Link másolva – add tovább a felhasználónak. Csak korlátozott ideig érvényes.';

  @override
  String lockedUsersReset(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count felhasználó feloldva',
      one: '1 felhasználó feloldva',
      zero: 'Nincs zárolt felhasználó',
    );
    return '$_temp0';
  }

  @override
  String get inviteUsesLabel => 'Felhasználások száma';

  @override
  String get inviteCreated => 'Meghívó link létrehozva';

  @override
  String get inviteEmailHint =>
      'E-mail-cím (nem kötelező – a Mealie elküldi a meghívót)';

  @override
  String get inviteEmailSent => 'Meghívó elküldve e-mailben';

  @override
  String get inviteEmailFailed =>
      'Az e-mailt nem sikerült elküldeni (be van állítva az SMTP a Mealie-ben?). A link ettől még működik.';

  @override
  String get copyLinkAction => 'Link másolása';

  @override
  String get youLabel => 'Te';

  @override
  String get membersPermissionsHint =>
      'Módosíthatod a háztartásod tagjainak jogosultságait – a sajátodat nem.';

  @override
  String get householdManagementTitle => 'Háztartás menedzsment';

  @override
  String get householdsTitle => 'Háztartás';

  @override
  String get createHouseholdTitle => 'Háztartás létrehozása';

  @override
  String get householdNameLabel => 'Háztartás megnevezése';

  @override
  String get householdPreferencesTitle => 'Háztartás preferenciái';

  @override
  String get privateHouseholdLabel => 'Privát háztartás';

  @override
  String get privateHouseholdHint =>
      'A háztartás privátra állítása letiltja az összes nyilvános megtekintési lehetőséget. Ez felülírja az egyéni nyilvános megtekintési beállításokat';

  @override
  String get lockRecipeEditsLabel =>
      'Receptmódosítások zárolása más háztartások elől';

  @override
  String get lockRecipeEditsHint =>
      'Ha engedélyezett, csak a háztartás felhasználói szerkeszthetik a háztartás által létrehozott recepteket';

  @override
  String get householdRecipePreferencesTitle => 'Háztartás recept preferenciái';

  @override
  String get groupsTitle => 'Csoportok';

  @override
  String get groupLabel => 'Csoport';

  @override
  String get createGroupTitle => 'Csoport létrehozása';

  @override
  String get groupNameLabel => 'Csoport neve';

  @override
  String get groupPreferencesTitle => 'Csoport beállítások';

  @override
  String get privateGroupLabel => 'Privát csoport';

  @override
  String get privateGroupHint =>
      'Ha a csoportot privátra állítja, akkor minden nyilvános megtekintési lehetőség letiltásra kerül. Ez felülírja az egyéni nyilvános nézetbeállításokat';

  @override
  String get firstDayOfWeekLabel => 'A hét első napja';

  @override
  String get showAnnouncementsLabel => 'Mutasd a Mealie értesítéseit';

  @override
  String get recipePublicDefaultLabel =>
      'Engedélyezze a csoporton kívüli felhasználók számára a receptek megtekintését';

  @override
  String get recipeShowNutritionDefaultLabel =>
      'Táplálkozási információk megjelenítése';

  @override
  String get recipeShowAssetsDefaultLabel => 'Receptmellékletek megjelenítése';

  @override
  String get recipeLandscapeDefaultLabel =>
      'Alapértelmezés szerint fekvő nézet';

  @override
  String get recipeDisableCommentsDefaultLabel =>
      'Letiltja a felhasználóknak, hogy megjegyzéseket fűzzenek a receptekhez';

  @override
  String get myHouseholdSection => 'Saját háztartás';

  @override
  String get myGroupSection => 'Saját csoport';

  @override
  String get preferencesSaved => 'Beállítások mentve';

  @override
  String get cannotDeleteWithUsers =>
      'Még vannak felhasználói – előbb helyezd át vagy töröld őket a Felhasználók kezelésében.';

  @override
  String deleteHouseholdConfirm(String name) {
    return 'Törlöd a(z) „$name” háztartást?';
  }

  @override
  String deleteGroupConfirm(String name) {
    return 'Törlöd a(z) „$name” csoportot?';
  }

  @override
  String usersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count felhasználó',
      one: '1 felhasználó',
      zero: 'Nincs felhasználó',
    );
    return '$_temp0';
  }

  @override
  String get originalUrlLabel => 'Eredeti URL';

  @override
  String get copyTextAction => 'Szöveg másolása';

  @override
  String get copiedToClipboard => 'Vágólapra másolva';

  @override
  String get changelogEnglishHint =>
      'Az újdonságok csak angolul érhetők el – a „Szöveg másolása” gombbal beillesztheted őket például egy fordítóba.';

  @override
  String get favoritesTitle => 'Kedvencek';

  @override
  String get favoritesEmpty =>
      'Még nincsenek kedvencek. Koppints egy recept szívére, hogy ide gyűjtsd.';

  @override
  String get changelogTitle => 'Changelog';

  @override
  String get changeProfileImage => 'Profilkép módosítása';

  @override
  String get profileImageUpdated => 'Profilkép frissítve';

  @override
  String get profileImageFailed => 'A profilképet nem sikerült feltölteni';

  @override
  String get myAccountTitle => 'Saját fiók';

  @override
  String get ownAccountHint =>
      'Itt a saját fiókodat szerkesztheted. A többi felhasználót az adminisztrátorok és a „kezelés\" joggal rendelkező tagok kezelik.';

  @override
  String get changePasswordAction => 'Jelszó módosítása';

  @override
  String get currentPasswordLabel => 'Jelenlegi jelszó';

  @override
  String get newPasswordLabel => 'Új jelszó';

  @override
  String get confirmPasswordLabel => 'Jelszó megerősítése';

  @override
  String get passwordTooShort => 'Legalább 8 karakter';

  @override
  String get passwordsDoNotMatch => 'A jelszavak nem egyeznek';

  @override
  String get passwordUpdated => 'Jelszó frissítve';

  @override
  String get passwordChangeFailed => 'A jelszót nem sikerült módosítani';

  @override
  String passwordManagedExternally(String method) {
    return '$method használatával jelentkezel be — a jelszavadat ott módosíthatod.';
  }

  @override
  String get bulkAddHint => 'Soronként egy bejegyzés.';

  @override
  String bulkAddCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bejegyzés hozzáadása',
    );
    return '$_temp0';
  }

  @override
  String get linkRecipeAction => 'Recept csatolása';

  @override
  String get useFoodAction => 'Élelmiszer recept helyett';

  @override
  String get addSubstitutionsAction => 'Helyettesítések hozzáadása';

  @override
  String get clearSubstitutionsAction => 'Helyettesítések törlése';

  @override
  String get recipeSubstitutionsTitle => 'Helyettesítések';

  @override
  String get substitutionUnknownFood =>
      'Csak meglévő élelmiszer – különben használd a megjegyzést';

  @override
  String get insertAboveAction => 'Beillesztés fent';

  @override
  String get insertBelowAction => 'Beszúrás alá';

  @override
  String get moveToTopAction => 'Ugrás a tetejére';

  @override
  String get moveToBottomAction => 'Ugrás az aljára';

  @override
  String get linkReferencesAction => 'Hivatkozások';

  @override
  String get editMarkdownAction => 'Markdown szerkesztése';

  @override
  String get previewMarkdownAction => 'Markdown előnézet';

  @override
  String get insertStepImageAction => 'Kép feltöltése';

  @override
  String get mergeAboveAction => 'Összevonás a fentivel';

  @override
  String get linkedToOtherStep => 'Egy másik lépéssel összekapcsolva';

  @override
  String get noNotesToLink => 'Nincs hivatkozandó jegyzet';

  @override
  String get ownerLabel => 'Tulajdonos';

  @override
  String get ingredientParserTitle => 'Hozzávaló elemző';

  @override
  String ingredientParserHint(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count hozzávaló még nincs strukturálva. Válassz elemzőt, ellenőrizd az eredményt, majd alkalmazd.',
    );
    return '$_temp0';
  }

  @override
  String get parserNlp => 'Természetes nyelvi feldolgozó';

  @override
  String get parserBrute => 'Brute elemző';

  @override
  String get parserOpenai => 'OpenAI elemző';

  @override
  String get parserApp => 'Offline (app)';

  @override
  String get parseFailed => 'Az elemzés sikertelen';

  @override
  String get parseAction => 'Elemzés';

  @override
  String applyParsedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hozzávaló alkalmazása',
      zero: 'Nincs kiválasztva',
    );
    return '$_temp0';
  }

  @override
  String get parsedNewBadge => 'új';

  @override
  String get hoursShort => 'óra';

  @override
  String get minutesShort => 'perc';

  @override
  String get timeExtraHint => 'Kiegészítés, pl. „plusz egy éjszaka”';

  @override
  String get yieldLabel => 'Adag';

  @override
  String get yieldTextLabel => 'A készített étel';

  @override
  String get prepTimeLabel => 'Előkészítési idő';

  @override
  String get performTimeLabel => 'Főzési idő';

  @override
  String get totalTimeLabel => 'Teljes idő';

  @override
  String get settingPublicRecipe => 'Nyilvános recept';

  @override
  String get settingShowNutrition => 'Tápértékek megjelenítése';

  @override
  String get settingShowAssets => 'Eszközök megjelenítése';

  @override
  String get settingLandscapeView => 'Horizontális nézet';

  @override
  String get settingDisableComments => 'Megjegyzések letiltása';

  @override
  String get settingDisableAmount => 'Hozzávaló mennyiségek letiltása';

  @override
  String get settingLocked => 'Zárolt';

  @override
  String get settingLockedOwnerOnly =>
      'Csak a létrehozó zárolhatja vagy oldhatja fel a receptet.';

  @override
  String get apiExtrasTitle => 'API Extrák';

  @override
  String get apiExtrasHint =>
      'Egyéni kulcs/érték párok külső alkalmazásokhoz, pl. automatizmusok indítására.';

  @override
  String get extraKeyLabel => 'Kulcs';

  @override
  String get extraValueLabel => 'Érték';

  @override
  String get addExtraAction => 'Extra hozzáadása';

  @override
  String durationHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count óra',
    );
    return '$_temp0';
  }

  @override
  String durationMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count perc',
    );
    return '$_temp0';
  }

  @override
  String get discardChangesConfirm => 'Elveted a nem mentett változtatásokat?';

  @override
  String get discardChanges => 'Változtatások elvetése';

  @override
  String get imageFromUrl => 'Kép URL-ből';

  @override
  String get deleteRecipeImage => 'Receptkép törlése';

  @override
  String get deleteRecipeImageConfirm => 'Biztosan törli ezt a receptképet?';

  @override
  String get bulkAddIngredients => 'Hozzávalók tömeges hozzáadása';

  @override
  String get bulkAddSteps => 'Lépések tömeges hozzáadása';

  @override
  String get stepImageFailed => 'A képet nem sikerült feltölteni';

  @override
  String get servingsAndTimes => 'Adagok és idők';

  @override
  String get recipeSettingsTitle => 'Recept beállítások';

  @override
  String get jsonEditorTitle => 'JSON szerkesztő';

  @override
  String get jsonInvalid => 'Érvénytelen JSON – kérjük, ellenőrizd.';

  @override
  String get editorOfflineHint =>
      'Offline megnyitva: a mentéshez kapcsolat kell. Az újabb Mealie-mezők (pl. helyettesítések) változatlanok maradnak.';

  @override
  String get parseLineFailed => 'Nem ismerhető fel – változatlan marad';

  @override
  String get createManualTitle => 'Recept kézi létrehozása';

  @override
  String get createManualHint =>
      'Adj meg egy nevet – a hozzávalókat, lépéseket, képet és minden mást utána a receptszerkesztőben adhatod hozzá.';

  @override
  String get createManualButton => 'Létrehozás és szerkesztés';

  @override
  String get changelogEmpty => 'Ehhez a verzióhoz még nincsenek bejegyzések.';

  @override
  String get finderDescription =>
      'Keressen recepteket a kéznél lévő összetevők alapján. A rendelkezésre álló eszközök alapján is szűrhet, és beállíthatja a hiányzó összetevők vagy eszközök maximális számát.';

  @override
  String get finderSelectedIngredients => 'Kiválasztott összetevők';

  @override
  String get finderNoIngredientsSelected => 'Nincsenek kiválasztott összetevők';

  @override
  String get finderMissing => 'Hiányzó';

  @override
  String get finderNoRecipesFound => 'Nem található recept';

  @override
  String get finderNoRecipesFoundDescription =>
      'Próbáljon meg több összetevőt hozzáadni a kereséshez, vagy állítsa be a szűrőket';

  @override
  String get finderIncludeFoodsOnHand => 'Beleértve a kéznél lévő összetevőket';

  @override
  String get finderIncludeToolsOnHand => 'Beleértve a kéznél lévő eszközöket';

  @override
  String get finderIncludeSubstitutions =>
      'Helyettesítő alapanyagok feltüntetése';

  @override
  String get finderSubstituting => 'Helyettesítés';

  @override
  String finderSubstituteForFood(String substitute, String food) {
    return '$substitute $food helyett';
  }

  @override
  String get finderMaxMissingIngredients =>
      'Maximálisan hiányzó összetevők száma';

  @override
  String get finderMaxMissingTools => 'Maximálisan hiányzó eszközök száma';

  @override
  String get finderSelectedTools => 'Kiválasztott eszközök';

  @override
  String get finderReadyToMake => 'Előkészítve';

  @override
  String get finderAlmostReadyToMake => 'Majdnem készen áll';

  @override
  String get finderSettings => 'Beállítások';

  @override
  String get finderLoadingRecipes => 'Receptek betöltése';

  @override
  String get finderClearSelection => 'Kijelölés törlése';

  @override
  String get finderOfflineHint =>
      'Nincs kapcsolat a szerverrel – a találatok az eszközön tárolt receptekből származnak.';

  @override
  String addIngredientsSkippedOnHand(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Felkerült a bevásárlólistára – $count készleten lévő hozzávaló kimaradt.',
      one:
          'Felkerült a bevásárlólistára – 1 készleten lévő hozzávaló kimaradt.',
    );
    return '$_temp0';
  }

  @override
  String get sendPeerOfflineHint =>
      'Most nem érhető el – megérkezik, amint ott megnyitják az appot';

  @override
  String sendDeliveredLater(String device) {
    return '„$device” most nem érhető el. A recept megérkezik, amint ott megnyitják az appot.';
  }

  @override
  String get sendQueuedOffline =>
      'Most nincs kapcsolat. A recept automatikusan elküldésre kerül, amint újra online leszel.';

  @override
  String get searchHasAll => 'Mind';

  @override
  String get searchHasAny => 'Bármely';

  @override
  String get recipeFilterTitle => 'Szűrő';

  @override
  String get finderOtherFilters => 'További szűrők';

  @override
  String get qfOpEquals => 'egyenlő';

  @override
  String get qfOpNotEquals => 'nem egyenlő';

  @override
  String get qfOpGreater => 'nagyobb, mint';

  @override
  String get qfOpGreaterEq => 'nagyobb vagy egyenlő';

  @override
  String get qfOpLess => 'kevesebb, mint';

  @override
  String get qfOpLessEq => 'kevesebb vagy egyenlő';

  @override
  String get qfOpNewerThan => 'újabb, mint';

  @override
  String get qfOpOlderThan => 'régebbi, mint';

  @override
  String qfDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count napja',
      one: '1 napja',
    );
    return '$_temp0';
  }

  @override
  String get filterResetAll => 'Összes szűrő visszaállítása';

  @override
  String get filterAny => 'Összes';

  @override
  String get filterOfflineIgnored =>
      'Offline a „További szűrők” csak egyszerű formában alkalmazhatók.';

  @override
  String linkedRecipesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count összekapcsolt recept',
      one: 'Egy összekapcsolt recept',
      zero: 'Nincs összekapcsolt recept',
    );
    return '$_temp0';
  }

  @override
  String get shoppingReminderNotificationsOff =>
      'A Mealie Recipes értesítései ki vannak kapcsolva — nélkülük a bevásárlási emlékeztető nem jelenhet meg. Engedélyezd őket a beállításokban.';

  @override
  String get shoppingReminderInactiveHint =>
      'A bevásárlási emlékeztető most nem működhet: állítsd a helyhozzáférést „Mindig” értékre, és engedélyezd az értesítéseket.';

  @override
  String get bulkImportTitle => 'Tömeges URL importálás';

  @override
  String get bulkImportDescription =>
      'A Tömeges receptimportáló lehetővé teszi, hogy egyszerre több receptet importáljon a backendben lévő oldalak sorba állításával és a feladat háttérben történő futtatásával. Ez hasznos lehet Mealie-ra való kezdeti áttéréskor, vagy ha nagyszámú receptet szeretne importálni.';

  @override
  String get bulkAddTitle => 'Tömeges hozzáadás';

  @override
  String get bulkImportSetOrganizers => 'Kategóriák és címkék beállítása';

  @override
  String get bulkImportStarted => 'Tömeges import feldolgozás elkezdődött';

  @override
  String get bulkImportFailed => 'Tömeges import feldolgozás nem sikerült';

  @override
  String get bulkImportReports => 'Tömeges import';

  @override
  String get bulkImportUrlHint => 'Recept URL';

  @override
  String get migrationsTitle => 'Adatmigráció';

  @override
  String get migrationsDescription =>
      'A recepteket át lehet importálni egy másik támogatott alkalmazásból a Mealie-be. Ez remek módja a Mealie használatának megkezdésének. Az adatok áthelyezése a Mealie-példányok között, illetve egy korábbi Mealie-biztonsági mentés visszaállítása a biztonsági mentési és visszaállítási eszközök segítségével történik, a migráció helyett.';

  @override
  String get migrationNew => 'Új migráció';

  @override
  String get migrationChooseType => 'Válassza ki a migrációs típusát';

  @override
  String get noFileSelected => 'Nincs fájl kiválasztva';

  @override
  String migrationTagAll(String tag) {
    return 'Az összes recept címkézése a $tag címkével';
  }

  @override
  String get migrationPrevious => 'Előző migráció';

  @override
  String get migrationMealieDescription =>
      'Mealie képes importálni a v1.0-nál korábbi verziójú Mealie-alkalmazásból származó recepteket. Exportálja a recepteket a régi példányából, majd töltse fel az alábbi Zip-fájlt. Felhívjuk figyelmét, hogy az exportból csak receptek importálhatók. Ez kizárólag a v1.0-nál régebbi példányokra vonatkozik. A v1.0-tól kezdődően készített biztonsági másolatot a biztonsági másolat-készítő és -visszaállító eszközökkel kell visszaállítani.';

  @override
  String get migrationChowdownDescription =>
      'Mealie natívan támogatja a chowdown repository formátumot. Töltse le a kódtárat .zip fájlként, és töltse fel a lenti helyen.';

  @override
  String get migrationCopyMeThatDescription =>
      'Mealie képes recepteket importálni a Copy Me That programból. Exportálja a recepteket HTML formátumban, majd töltse fel az alábbi .zip fájlt.';

  @override
  String get migrationMyRecipeBoxDescription =>
      'A Mealie képest recepteket importálni az Én Receptes Dobozomból. Exportáld a receptjeidet CSV formátúmba, aztán töltsd fel a .csv fájlt lentebb.';

  @override
  String get migrationNextcloudDescription =>
      'A Nextcloud-receptek importálhatók a Nextcloudban tárolt adatokat tartalmazó zip-fájlból. Tekintse meg az alábbi példamappaszerkezetet, hogy receptjei biztosan importálhatók legyenek.';

  @override
  String get migrationPaprikaDescription =>
      'Mealie képes recepteket importálni a Paprika alkalmazásból. Exportálja a receptjeit a Paprikából, nevezze át az export kiterjesztést .zip-re, és töltse fel alább.';

  @override
  String get migrationPlanToEatDescription =>
      'Mealie képes recepteket importálni a Plan to Eat alkalmazásból. ZIP, CSV vagy TXT fájlként feltölthetők a Plan to Eat-ből exportálásuk után.';

  @override
  String get migrationRecipeKeeperDescription =>
      'A Mealie képes recepteket importálni a Recipe Keeperből. Exportálja a receptjeit zip formátumban, majd töltse fel a .zip fájlt az oldal alján.';

  @override
  String get migrationTandoorDescription =>
      'Mealie képes recepteket importálni a Tandoorból. Exportálja adatait az \"Alapértelmezett\" formátumban, majd töltse fel a .zip fájlt lentebb.';

  @override
  String get migrationCooknDescription =>
      'Mealie képes importálni a DVO Cook\'n X3 receptjeit. Exportáljon egy szakácskönyvet vagy menüt „Cook\'n” formátumban, nevezze át az exportált fájl kiterjesztését .zip-re, majd töltse fel az alábbi .zip fájlt.';

  @override
  String get reportTitle => 'Jelentés';

  @override
  String get recipeDataTitle => 'Recept adatok';

  @override
  String get recipeDataDescription =>
      'Ebben a részben kezelheti a receptjeihez kapcsolódó adatokat. Számos tömeges műveletet végezhet a receptjeivel, beleértve az exportálást, a törlést, a címkézést és a kategóriák hozzárendelését.';

  @override
  String get recipeDataTagTitle => 'Receptek címkézése';

  @override
  String get recipeDataCategorizeTitle => 'Receptek kategorizálása';

  @override
  String get recipeDataSettingsTitle => 'Beállítások frissítése';

  @override
  String get recipeDataExportTitle => 'Receptek exportálása';

  @override
  String get recipeDataDeleteTitle => 'Receptek törlése';

  @override
  String recipeDataExportConfirm(int count) {
    return 'A következő receptek ($count) kerülnek exportálásra.';
  }

  @override
  String get recipeDataExportsTitle => 'Adatok exportálása';

  @override
  String get recipeDataExportsDescription =>
      'Ez a szakasz a letölthető, rendelkezésre álló exportok linkjeit tartalmazza. Ezek az exportok érvényessége le fog járni, ezért mindenképpen szerezze be őket, amíg még elérhetők.';

  @override
  String get recipeDataPurgeExports => 'Exportálás tisztítása';

  @override
  String get recipeDataPurgeConfirm =>
      'Biztos, hogy törölni szeretné az összes exportált adatot?';

  @override
  String get recipeActionsTitle => 'Receptekkel kapcsolatos tevékenységek';

  @override
  String get recipeActionNew => 'Új recept tevékenység';

  @override
  String get recipeActionEdit => 'Recept tevékenység szerkesztése';

  @override
  String get recipeActionTypeLink => 'Hivatkozás';

  @override
  String get recipeActionTypePost => 'Közzététel';

  @override
  String get webhooksTitle => 'Webhook-ok';

  @override
  String get webhooksDescription =>
      'Az alábbiakban meghatározott webhookok akkor kerülnek végrehajtásra, amikor az adott napra étkezés kerül beállításra. A tervezett időpontban a webhookok elküldésre kerülnek az adott napra tervezett recept adataival. Vegye figyelembe, hogy a webhookok végrehajtása nem pontos. A webhookok 5 perces időközönként kerülnek végrehajtásra, így a webhookok a tervezett időponthoz képest 5 +/- percen belül fognak végrehajtásra kerülni.';

  @override
  String get webhookName => 'Webhook neve';

  @override
  String get webhookUrl => 'Webhook URL';

  @override
  String get notifiersTitle => 'Értesítések';

  @override
  String get notifiersDescription =>
      'Állítson be olyan e-mail és push-értesítéseket, amelyek meghatározott események esetén lépnek működésbe.';

  @override
  String get notifierNew => 'Új értesítés';

  @override
  String get notifierDescription =>
      'A Mealie az Apprise könyvtárat használja az értesítésekhez. Számos lehetőséget kínál különböző értesítési szolgáltatásokhoz. Nézd meg a wiki oldalukon, hogy kell URL-t létrehozni az általad használt szolgáltatáshoz. Az értesítés típusának kiválasztásával egyéb beállítási lehetőségek jelenhetnek meg.';

  @override
  String get notifierAppriseUrl => 'Apprise cím (URL)';

  @override
  String get notifierAppriseUrlSkipped => 'Értesítendő URL (kihagy, ha üres)';

  @override
  String get notifierAppriseUrlBlankHint =>
      'Mivel Apprise URL-ek gyakran érzékeny információt tartalmaznak, ez a mező szándékosan üres marad szerkesztés közben. Ha frissíteni szeretnéd az URL-t, kérelk írd be ide az újat, különben hagyjad üresena jelenlegi URL megtartásához.';

  @override
  String get notifierEnable => 'Értesítés engedélyezése';

  @override
  String get notifierWhatEvents =>
      'Milyen eseményekre figyeljen ez az értesítés?';

  @override
  String get notifierRecipeEvents => 'Recept esemény';

  @override
  String get notifierUserEvents => 'Felhasználói Események';

  @override
  String get notifierMealplanEvents => 'Menütervező események';

  @override
  String get notifierShoppingListEvents => 'Bevásárlólista események';

  @override
  String get notifierCookbookEvents => 'Szakácskönyv események';

  @override
  String get notifierTagEvents => 'Címke események';

  @override
  String get notifierCategoryEvents => 'Kategória események';

  @override
  String get notifierLabelEvents => 'Címke Események';

  @override
  String get notifierUserSignup =>
      'Amikor egy új felhasználó csatlakozik a csoportodba';

  @override
  String get notifierCreate => 'Létrehozás';

  @override
  String get notifierUpdate => 'Frissítés';

  @override
  String get notifierDelete => 'Törlés';

  @override
  String get notifierTestSent => 'Teszt üzenet elküldve';

  @override
  String get adminTitle => 'Admin beállítások';

  @override
  String get backupsTitle => 'Biztonsági mentések';

  @override
  String get backupsDescription =>
      'A biztonsági mentések az oldal adatbázisának és adatkönyvtárának teljes pillanatfelvételei. Ez az összes adatot tartalmazza, és nem lehet beállítani, hogy az adatok részhalmazait kizárja. Ezt úgy is elképzelheti, mint a Mealie egy adott időpontban készült pillanatfelvételét. Ezek adatbázis-független módon szolgálnak az adatok exportálására és importálására, vagy a webhely külső helyre történő mentésére.';

  @override
  String get backupCreateHeading => 'Biztonsági mentés létrehozása';

  @override
  String get backupCreated => 'Biztonsági mentés sikeresen létrehozva';

  @override
  String get backupCreateFailed =>
      'Hiba a biztonsági mentés létrehozásakor. Lásd a napló fájlt';

  @override
  String get backupDelete => 'Biztonsági mentés törlése';

  @override
  String get backupDeleted => 'Biztonsági mentés törölve';

  @override
  String get backupRestore => 'Biztonsági mentés visszaállítása';

  @override
  String get backupRestoreDescription =>
      'A biztonsági mentés visszaállítása felülírja az adatbázisban és az adatkönyvtárban lévő összes aktuális adatot, és a biztonsági mentés tartalmával helyettesíti azokat. Ha a visszaállítás sikeres, akkor a rendszer kilépteti Önt.';

  @override
  String get backupCannotBeUndone =>
      'Ezt a műveletet visszavonható - óvatosan használja.';

  @override
  String get backupAcknowledge =>
      'Tudomásul veszem, hogy ez a művelet visszafordíthatatlan, helyrehozhatatlan, és adatvesztéssel járhat';

  @override
  String get backupRestoreSuccess => 'Sikeres visszaállítás';

  @override
  String get backupRestoreFailed =>
      'A visszaállítás sikertelen. További részletekért ellenőrizze a szervernaplókat';

  @override
  String get maintenanceTitle => 'Karbantartás';

  @override
  String get maintenanceSummary => 'Összegzés';

  @override
  String get maintenanceStorage => 'Tároló részletei';

  @override
  String get maintenanceDataDirSize => 'Adatkönyvtár mérete';

  @override
  String get maintenanceCleanableDirs => 'Tisztítható könyvtárak';

  @override
  String get maintenanceCleanableImages => 'Tisztítható képek';

  @override
  String get maintenanceTempDir => 'Ideiglenes könyvtár (.temp)';

  @override
  String get maintenanceBackupsDir =>
      'Biztonsági mentések könyvtára (biztonsági mentések)';

  @override
  String get maintenanceGroupsDir => 'Csoportok könyvtára (csoportok)';

  @override
  String get maintenanceRecipesDir => 'Receptek könyvtár (receptek)';

  @override
  String get maintenanceUserDir => 'Felhasználó könyvtár (felhasználó)';

  @override
  String get maintenanceCleanDirs => 'Könyvtárak tisztítása';

  @override
  String get maintenanceCleanDirsDescription =>
      'Minden nem érvényes UUID-jű receptmappa eltávolítása';

  @override
  String get maintenanceCleanTemp => 'Ideiglenes fájlok tisztítása';

  @override
  String get maintenanceCleanTempDescription =>
      'Minden fájl és mappa eltávolítása a .temp könyvtárból';

  @override
  String get maintenanceCleanImages => 'Képek tisztítása';

  @override
  String get maintenanceCleanImagesDescription =>
      'Minden nem .webp kiterjesztésű kép eltávolítása';

  @override
  String get maintenanceActions => 'Műveletek';

  @override
  String get adminConfiguration => 'Beállítás';

  @override
  String get adminAppVersion => 'Alkalmazás verziója';

  @override
  String get adminUpToDate => 'Mealie naprakész';

  @override
  String adminVersionOutdated(String current, String latest) {
    return 'Az aktuális verzió ($current) nem felel meg a legújabb kiadásnak. Fontolja meg a frissítést a legújabb verzióra ($latest).';
  }

  @override
  String get adminBaseUrl => 'Szerver oldali bázis URL';

  @override
  String get adminBaseUrlOk =>
      'A kiszolgálóoldali URL nem egyezik az alapértelmezettel';

  @override
  String get adminBaseUrlError =>
      'A \'BASE_URL` továbbra is az alapértelmezett érték az API-kiszolgálón. Ez problémákat okoz az e-mailekhez stb. a szerveren generált értesítési linkeknél.';

  @override
  String adminAuthReady(String provider) {
    return '$provider kész';
  }

  @override
  String adminAuthNotReady(String provider) {
    return '$provider még nem áll készen';
  }

  @override
  String adminAuthDisabled(String provider) {
    return '$provider letiltva';
  }

  @override
  String adminAuthSuccessText(String provider) {
    return 'Minden szükséges $provider változó beállítva.';
  }

  @override
  String adminAuthErrorText(String provider) {
    return 'Nem minden $provider érték van beállítva. Ezt figyelmen kívül lehet hagyni, ha nem használja a $provider hitelesítést.';
  }

  @override
  String adminAuthDisabledText(String envVar) {
    return 'A $envVar beállítás engedélyezéséhez állítsa be a értéket true-ra.';
  }

  @override
  String get adminEmailStatus => 'Levelezés beállításI státusza';

  @override
  String get adminEmailConfigured => 'Email beállítva';

  @override
  String get adminNotReady => 'Nem kész - Ellenőrizze a környezeti változókat';

  @override
  String get adminSucceeded => 'Sikeres';

  @override
  String get adminFailed => 'Sikertelen ';

  @override
  String get adminSiteStatistics => 'Oldal statisztikák';

  @override
  String get adminUncategorized => 'Nem kategorizált receptek';

  @override
  String get adminUntagged => 'Nem címkézett receptek';

  @override
  String get adminGeneralAbout => 'Általános információk';

  @override
  String get adminVersion => 'Verzió';

  @override
  String get adminBuild => 'Build';

  @override
  String get adminApplicationMode => 'Alkalmazás típus';

  @override
  String get adminProduction => 'Stabil';

  @override
  String get adminDevelopment => 'Fejlesztői';

  @override
  String get adminDemoStatus => 'Demó állapot';

  @override
  String get adminDemo => 'Demó';

  @override
  String get adminNotDemo => 'Nem Demó';

  @override
  String get adminApiPort => 'API Port';

  @override
  String get adminApiDocs => 'API dokumentáció';

  @override
  String get adminDatabaseType => 'Adatbázis típusa';

  @override
  String get adminDatabaseUrl => 'Adatbázis URL';

  @override
  String get adminDefaultGroup => 'Alapértelmezett csoport';

  @override
  String get adminDefaultHousehold => 'Alapértelmezett háztartás';

  @override
  String get adminScraperVersion => 'Receptkinyerő verziója';

  @override
  String get adminStatUsers => 'Felhasználók';

  @override
  String get adminStatHouseholds => 'Háztartás';

  @override
  String get adminStatGroups => 'Csoportok';

  @override
  String get recipeDuplicate => 'Recept duplikálása';

  @override
  String get recipeDuplicateAction => 'Duplikálás';

  @override
  String get recipeShareLink => 'Recept megosztása';

  @override
  String get recipeShareExpiration => 'Lejárati dátum';

  @override
  String get recipeShareCopied => 'Recept linkje a vágólapra másolva';

  @override
  String get enabledLabel => 'Engedélyezve';

  @override
  String get disabledLabel => 'Letiltva';

  @override
  String get testAction => 'Teszt';

  @override
  String get yesLabel => 'Igen';

  @override
  String get noLabel => 'Nem';

  @override
  String get downloadAction => 'Letöltés';

  @override
  String get backupUpload => 'Feltöltés';

  @override
  String get zipImportButton => 'Importálás ZIP-ből';

  @override
  String get zipImportDescription =>
      'Egy másik Mealie-példányból kiexportált recept egyedi importálása.';

  @override
  String get reportStatus => 'Állapot';

  @override
  String get reportDate => 'Dátum';

  @override
  String get recipeActionTitleLabel => 'Cím';

  @override
  String get clearAll => 'Törlés';

  @override
  String get recipeDataSettingsExplanation =>
      'Az itt kiválasztott beállítások - a zárolt opció kivételével - az összes kiválasztott receptre érvényesek lesznek.';

  @override
  String get adminAllowSignup => 'Regisztráció engedélyezve';

  @override
  String get adminAllowPasswordLogin => 'Jelszavas bejelentkezés engedélyezve';

  @override
  String get adminEmailInvalid => 'Adj meg egy érvényes e-mail-címet.';

  @override
  String adminEmailTestResult(String result) {
    return 'E-mail teszt: $result';
  }

  @override
  String get adminSendTestEmail => 'Teszt e-mail küldése';

  @override
  String get adminTestEmailAddress => 'Címzett';

  @override
  String get backupCreate => 'Biztonsági mentés készítése';

  @override
  String backupDeleteConfirm(String name) {
    return 'Törlöd a(z) „$name” biztonsági mentést?';
  }

  @override
  String get backupPostgresNote =>
      'Ha PostgreSQL-t használsz, visszaállítás előtt olvasd el a Mealie dokumentációjában a mentési/visszaállítási folyamatot.';

  @override
  String get backupUploaded => 'Biztonsági mentés feltöltve';

  @override
  String get backupsEmpty => 'Még nincs biztonsági mentés.';

  @override
  String get bulkImportAddRow => 'URL hozzáadása';

  @override
  String get bulkImportStart => 'Importálás indítása';

  @override
  String get chooseFileButton => 'Fájl kiválasztása';

  @override
  String get deselectAllAction => 'Kijelölés megszüntetése';

  @override
  String get downloadFailed => 'A letöltés nem sikerült';

  @override
  String get fileSaved => 'Fájl mentve';

  @override
  String get loadFailed => 'Nem sikerült betölteni';

  @override
  String get maintenanceActionsWarning =>
      'A karbantartási műveletek rombolóak, óvatosan használd őket. Egyik sem vonható vissza.';

  @override
  String get maintenanceConfirm =>
      'Ez a művelet romboló és nem vonható vissza. Folytatod?';

  @override
  String get maintenanceDone => 'Kész';

  @override
  String get maintenanceFailed => 'A karbantartási művelet sikertelen';

  @override
  String get maintenanceRun => 'Futtatás';

  @override
  String get migrationFailed => 'A migráció sikertelen';

  @override
  String get migrationStart => 'Migráció indítása';

  @override
  String get migrationStarted =>
      'A migráció befejeződött – lásd lent a jelentést.';

  @override
  String get moreImportOptions => 'További importálási lehetőségek';

  @override
  String notifierDeleteConfirm(String name) {
    return 'Törlöd a(z) „$name” értesítést?';
  }

  @override
  String get notifierEdit => 'Értesítés szerkesztése';

  @override
  String notifierEventCount(int count) {
    return 'Események: $count';
  }

  @override
  String get notifierTestFailed => 'A tesztüzenetet nem sikerült elküldeni';

  @override
  String get notifiersEmpty => 'Még nincs értesítés.';

  @override
  String recipeActionDeleteConfirm(String name) {
    return 'Törlöd a(z) „$name” receptműveletet?';
  }

  @override
  String get recipeActionFailed => 'A receptművelet sikertelen';

  @override
  String get recipeActionSent => 'Recept elküldve';

  @override
  String get recipeActionUrlHint => 'Helyőrzők';

  @override
  String get recipeActionsDescription =>
      'A receptműveletek minden recept menüjében megjelennek. A „Hivatkozás” megnyitja az URL-t, a „Küldés” esetén a Mealie-szerver elküldi a receptet az URL-re.';

  @override
  String get recipeActionsEmpty => 'Még nincs receptművelet.';

  @override
  String recipeDataDeleteConfirm(int count) {
    return 'Törlöd a kijelölt recepteket ($count)? Ez nem vonható vissza.';
  }

  @override
  String recipeDataDeleteForbidden(int count) {
    return 'A kijelölt receptek közül $count nem törölhető (csak a létrehozó vagy egy admin törölheti).';
  }

  @override
  String recipeDataDeleted(int count) {
    return 'Törölt receptek: $count';
  }

  @override
  String get recipeDataExportAction => 'Exportálás';

  @override
  String get recipeDataExportDone =>
      'Az export elkészült – az Adatexportok alatt töltheted le.';

  @override
  String recipeDataExportExpires(String date) {
    return 'lejár: $date';
  }

  @override
  String get recipeDataExportFailed => 'Az exportálás sikertelen';

  @override
  String get recipeDataExportsEmpty => 'Nincs elérhető export.';

  @override
  String recipeDataUpdated(int count) {
    return 'Frissített receptek: $count';
  }

  @override
  String get recipeDuplicated => 'Recept duplikálva';

  @override
  String get recipeExportJson => 'Exportálás JSON-ként';

  @override
  String get recipeExportZip => 'Exportálás ZIP-ként (képpel)';

  @override
  String get recipeShareCreate => 'Hivatkozás létrehozása';

  @override
  String get recipeShareDescription =>
      'A hivatkozással bárki megtekintheti a receptet a böngészőben – fiók nélkül – a lejáratig.';

  @override
  String get recipeShareEmpty => 'Még nincs megosztási hivatkozás.';

  @override
  String recipeShareExpiresAt(String date) {
    return 'Lejár: $date';
  }

  @override
  String get recipeWebToolsMenu => 'Duplikálás, megosztási hivatkozás és több';

  @override
  String get reload => 'Újratöltés';

  @override
  String get reportDeleteConfirm => 'Törlöd ezt a jelentést?';

  @override
  String get reportEntries => 'Bejegyzések';

  @override
  String get reportFailedEntries => 'Sikertelen';

  @override
  String get reportOnlyFailed => 'Csak a sikertelen bejegyzések';

  @override
  String get reportStatusFailure => 'Sikertelen';

  @override
  String get reportStatusInProgress => 'Folyamatban';

  @override
  String get reportStatusPartial => 'Részleges';

  @override
  String get reportStatusSuccess => 'Sikeres';

  @override
  String get reportsEmpty => 'Még nincs jelentés.';

  @override
  String get uploadFailed => 'A feltöltés nem sikerült';

  @override
  String webhookDeleteConfirm(String name) {
    return 'Törlöd a(z) „$name” webhookot?';
  }

  @override
  String get webhookEdit => 'Webhook szerkesztése';

  @override
  String get webhookNew => 'Új webhook';

  @override
  String get webhookTestFailed => 'A tesztet nem sikerült elindítani';

  @override
  String get webhookTestSent => 'Teszt webhook elküldve';

  @override
  String get webhookTime => 'Időpont (helyi)';

  @override
  String get webhooksEmpty => 'Még nincs webhook.';

  @override
  String get zipImportFailed => 'A ZIP-importálás sikertelen';

  @override
  String get aiProvidersTitle => 'AI szolgáltató';

  @override
  String get aiProvidersDescription =>
      'Állítsa be az AI-szolgáltatókat az AI-alapú funkciók, például a továbbfejlesztett összetevő-elemzés, a videókból történő receptkészítés és még sok más használatához!';

  @override
  String get aiProviderSettingsTitle => 'AI szolgáltató beállítások';

  @override
  String get aiProvidersList => 'Szolgáltatók';

  @override
  String get aiProviderCreate => 'Szolgáltató létrehozása';

  @override
  String get aiProviderEdit => 'Szolgáltató szerkesztése';

  @override
  String get aiDefaultProvider => 'Alapértelmezett szolgáltató';

  @override
  String get aiDefaultProviderDescription =>
      'Az AI-funkciók használatához szükséges';

  @override
  String get aiAudioProvider => 'Audió szolgáltató';

  @override
  String get aiAudioProviderDescription =>
      'Engedélyezi az audió-átírási funkciókat, például a videókból származó receptek létrehozását';

  @override
  String get aiImageProvider => 'Kép szolgáltató';

  @override
  String get aiImageProviderDescription =>
      'Engedélyezi a képfelismerési funkciókat, például a képek alapján történő receptkészítést';

  @override
  String get aiProviderName => 'Szolgáltató neve';

  @override
  String get aiApiKey => 'API Kulcs';

  @override
  String get aiApiKeyCreateDescription =>
      'A szolgáltató hitelesítési API-kulcsa. Ha a szolgáltatása (pl. Ollama) nem használ API-kulcsot, akkor is be kell írnia ide valamit.';

  @override
  String get aiApiKeyEditDescription =>
      'Ha nem szeretné módosítani, hagyja üresen.';

  @override
  String get aiBaseUrl => 'Alap URL';

  @override
  String get aiBaseUrlDescription =>
      'Ha az OpenAI-t használja, hagyja üresen ezt a mezőt. Az endpointnak OpenAI-kompatibilisnek kell lennie (pl. „http://localhost:11434/v1”).';

  @override
  String get aiModel => 'Modell';

  @override
  String get aiModelDescription =>
      'Melyik modellt kell használnia az AI-szolgáltatónak (pl. „gpt-5”).';

  @override
  String get aiTimeout => 'A kérés időtúllépése (másodpercben)';

  @override
  String get aiProviderCreated => 'Szolgáltató létrehozva';

  @override
  String get aiProviderUpdated => 'Szolgáltató frissítve';

  @override
  String get aiProviderDeleted => 'Szolgáltató törölve';

  @override
  String get aiProviderCreateFailed => 'A szolgáltató létrehozása sikertelen';

  @override
  String get aiProviderUpdateFailed => 'A szolgáltató frissítése sikertelen';

  @override
  String get aiProviderDeleteFailed => 'A szolgáltató törlése sikertelen';

  @override
  String get aiRequestHeaders => 'Kérés fejléce';

  @override
  String get aiRequestParams => 'Kérelem paraméterek';

  @override
  String get aiNoDefaultWarning =>
      'Mivel nem állított be alapértelmezett szolgáltatót, az AI-funkciók le vannak tiltva';

  @override
  String get aiTestConnection => 'Kapcsolat tesztelése';

  @override
  String get aiTestSucceeded => 'Sikeres kapcsolódás';

  @override
  String get aiTestFailed => 'Sikertelen kapcsolódás';

  @override
  String get aiSupportsImages => 'Képek támogatása';

  @override
  String get aiTextOnly =>
      'Csak szöveges tartalom érhető el, képeket nem tud biztosítani';

  @override
  String get debugAiTitle => 'MI-szolgáltatók hibakeresése';

  @override
  String get debugAiDescription =>
      'Ezen az oldalon hibakeresést végezhetsz az MI-szolgáltatókon. Tesztelheted a kapcsolatot és itt láthatod az eredményt. Ha a képszolgáltatás be van kapcsolva, képet is megadhatsz.';

  @override
  String get debugParserTitle => 'Szintaxis elemző';

  @override
  String get debugParserDescription =>
      'A Mealie feltételes véletlenszerű mezőt (CRF) használ az hozzávalók elemzéséhez és feldolgozásához. A hozzávalókra használt modell a New York Times által összeállított, több mint 100 000 hozzávalóból álló adathalmazon alapul. Vegye figyelembe, hogy mivel a modell csak angol nyelvre készült, a modell más nyelveken történő használatakor eltérő eredményekre számíthat. Ez az oldal a modell tesztelésének a játéktere.';

  @override
  String get debugIngredientText => 'Hozzávaló szöveg';

  @override
  String get debugTryExample => 'Próbáljon ki egy példát';

  @override
  String debugAverageConfidence(String value) {
    return '$value-os bizonyosság';
  }

  @override
  String get debugRunTest => 'Teszt futtatása';

  @override
  String get debugQuantity => 'Mennyiség';

  @override
  String get debugUnit => 'Mennyiségi egység';

  @override
  String get debugFood => 'Étel';

  @override
  String get debugNote => 'Megjegyzés';

  @override
  String get debugGroup => 'Csoport';

  @override
  String get aiProviderNone => 'Nincs';

  @override
  String aiProviderDeleteConfirm(String name) {
    return 'Törlöd a(z) „$name” szolgáltatót?';
  }

  @override
  String get aiProvidersEmpty => 'Még nincs MI-szolgáltató.';

  @override
  String get aiAdvanced => 'Speciális';

  @override
  String get aiKeyLabel => 'Név';

  @override
  String get aiValueLabel => 'Érték';

  @override
  String get debugTitle => 'Hibakeresés';

  @override
  String get debugParse => 'Elemzés';

  @override
  String get debugParseFailed => 'A hozzávalót nem sikerült elemezni';

  @override
  String get debugChooseImage => 'Kép kiválasztása';

  @override
  String get debugNoImage => 'Nincs kép (opcionális)';

  @override
  String get updateTitle => 'Frissítések keresése';

  @override
  String get updateInstalledVersion => 'Telepített verzió';

  @override
  String get updateLastCheck => 'Utolsó ellenőrzés';

  @override
  String get updateCheckNow => 'Ellenőrzés most';

  @override
  String get updateChecking => 'Frissítések keresése…';

  @override
  String get updateUpToDate => 'A Mealie Recipes naprakész.';

  @override
  String updateAvailable(String version) {
    return 'Elérhető a(z) $version verzió';
  }

  @override
  String get updateAvailableDescription =>
      'Elérhető a Mealie Recipes új verziója. Semmi sem települ, amíg te el nem indítod a frissítést.';

  @override
  String get updateShow => 'Frissítés megtekintése';

  @override
  String get updateLater => 'Később';

  @override
  String updateDownloading(int percent) {
    return 'Letöltés… $percent %';
  }

  @override
  String updateReady(String version) {
    return 'A(z) $version verzió telepítésre kész';
  }

  @override
  String get updateInstalling =>
      'Telepítés – az alkalmazás mindjárt újraindul…';

  @override
  String get updateManual =>
      'A frissítést nem sikerült automatikusan telepíteni. A lemezkép megnyílt: húzd a Mealie Recipes-t az Alkalmazások mappába.';

  @override
  String get updateFailed => 'A frissítés sikertelen';

  @override
  String get updateInstallNow => 'Letöltés és telepítés';

  @override
  String get updateRestartNow => 'Telepítés és újraindítás';

  @override
  String get updateAutoTitle => 'Frissítések keresése indításkor';

  @override
  String get updateAutoDescription =>
      'Csak ellenőriz és szól – a telepítést mindig te indítod.';

  @override
  String get updateNoNotes => 'Nincsenek kiadási megjegyzések.';

  @override
  String get updateSourceHint =>
      'A frissítések a Mealie Recipes GitHub-kiadásaiból érkeznek, és csak a fejlesztő által aláírva települnek (macOS).';
}
