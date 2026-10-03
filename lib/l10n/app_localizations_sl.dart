// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Slovenian (`sl`).
class AppLocalizationsSl extends AppLocalizations {
  AppLocalizationsSl([String locale = 'sl']) : super(locale);

  @override
  String get appTitle => 'Mealie Recipes';

  @override
  String get endCookingMode => 'Končaj način kuhanja';

  @override
  String get endCookingModeConfirm => 'Ali res želiš končati način kuhanja?';

  @override
  String endCookingModeConfirmAll(int count) {
    return 'S tem boš končal vse recepte ($count) v načinu kuhanja. Nadaljuješ?';
  }

  @override
  String get addTimer => 'Dodaj časovnik';

  @override
  String get recipeFinished => 'Tvoja jed je pripravljena.';

  @override
  String get bonAppetit => 'Dober tek!';

  @override
  String get prepareIngredients => 'Pripravi naslednje sestavine';

  @override
  String prepareIngredientsFor(String servings) {
    return 'Pripravi naslednje sestavine za $servings porcij';
  }

  @override
  String get next => 'Naprej';

  @override
  String get navHome => 'Domov';

  @override
  String get homeCookToday => 'Kuhaj danes';

  @override
  String get homeSuggestion => 'Predlog';

  @override
  String get homeQuickAccess => 'Hitri dostop';

  @override
  String get homePlanned => 'Načrtovano';

  @override
  String get favorite => 'Priljubljeno';

  @override
  String get navSettings => 'Nastavitve';

  @override
  String homeWelcomeName(Object name) {
    return 'Živjo, $name,';
  }

  @override
  String get homeWelcomeApp => 'dobrodošel/-a v Mealie Recipes 👋';

  @override
  String get theme => 'Videz';

  @override
  String get themeSystem => 'Sistemsko';

  @override
  String get themeLight => 'Svetlo';

  @override
  String get themeDark => 'Temno';

  @override
  String get recipes => 'Recepti';

  @override
  String get shoppingList => '🛒 Nakupovalni seznam';

  @override
  String get mealplan => 'Jedilnik';

  @override
  String get settings => '⚙️ Nastavitve';

  @override
  String get searchRecipe => 'Išči recept…';

  @override
  String get loadingRecipes => 'Nalaganje receptov…';

  @override
  String get loadingRecipe => 'Nalaganje recepta…';

  @override
  String errorLoadingRecipes(String error) {
    return 'Napaka pri nalaganju receptov: $error';
  }

  @override
  String get errorLoadingRecipe => 'Recepta ni bilo mogoče naložiti.';

  @override
  String get noRecipesForCategory => 'Ni receptov za ta filter.';

  @override
  String get resetFilter => 'Ponastavi filter';

  @override
  String get allCategories => 'Vse kategorije';

  @override
  String get all => 'Vse';

  @override
  String get sortRecipes => 'Razvrsti recepte';

  @override
  String get refreshRecipes => 'Osveži';

  @override
  String get sortNameAZ => 'Ime A–Ž';

  @override
  String get sortNameZA => 'Ime Ž–A';

  @override
  String get sortDateNewest => 'Najnovejši najprej';

  @override
  String get sortDateOldest => 'Najstarejši najprej';

  @override
  String get sortPrepTimeShort => 'Najkrajša priprava';

  @override
  String get sortPrepTimeLong => 'Najdaljša priprava';

  @override
  String get sortRatingHighest => 'Najvišja ocena';

  @override
  String get sortRatingLowest => 'Najnižja ocena';

  @override
  String get details => 'Podrobnosti';

  @override
  String get ingredients => 'Sestavine';

  @override
  String get instructions => 'Priprava';

  @override
  String get tags => 'Značke';

  @override
  String get notes => 'Opombe';

  @override
  String get addNote => 'Dodaj opombo';

  @override
  String get editNote => 'Uredi opombo';

  @override
  String get noteTitleHint => 'Naslov (neobvezno)';

  @override
  String get noteTextHint => 'Besedilo opombe';

  @override
  String get deleteNoteTitle => 'Izbriši opombo?';

  @override
  String get deleteNoteMessage => 'Ta opomba bo trajno izbrisana.';

  @override
  String get servings => 'Porcije';

  @override
  String get adjustQuantity => 'Prilagodi količino';

  @override
  String get startTimer => 'Zaženi časovnik';

  @override
  String runningTimer(int minutes, String seconds) {
    return 'Časovnik: $minutes:$seconds';
  }

  @override
  String get planMeal => 'Načrtuj obrok';

  @override
  String get displayAlwaysOn => 'Ohrani zaslon vklopljen';

  @override
  String get addAllIngredients => 'Dodaj vse sestavine';

  @override
  String get addSelectedIngredients => 'Dodaj izbrane sestavine';

  @override
  String get addIngredientsTitle => 'Sestavine dodane';

  @override
  String get addIngredientsMessage =>
      'Sestavine so bile dodane na tvoj nakupovalni seznam.';

  @override
  String addIngredientsFailedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sestavin ni bilo mogoče dodati.',
      few: '$count sestavin ni bilo mogoče dodati.',
      two: '$count sestavin ni bilo mogoče dodati.',
      one: '1 sestavine ni bilo mogoče dodati.',
    );
    return '$_temp0';
  }

  @override
  String get cookbooks => 'Kuharske knjige';

  @override
  String get cookbooksEmpty =>
      'Kuharskih knjig še ni. Tapni „+“ zgoraj desno, da jo ustvariš.';

  @override
  String get cookbookNoMatches => 'Noben recept ne ustreza temu filtru.';

  @override
  String get cookbookCreateTitle => 'Ustvari kuharsko knjigo';

  @override
  String get cookbookEditTitle => 'Uredi kuharsko knjigo';

  @override
  String get cookbookNameLabel => 'Ime kuharske knjige';

  @override
  String get cookbookFilterSectionTitle => 'Samodejno dodajanje receptov';

  @override
  String get cookbookFieldTools => 'Pripomočki';

  @override
  String get cookbookFieldUsers => 'Uporabniki';

  @override
  String get cookbookOpIsOneOf => 'je eno od';

  @override
  String get cookbookOpIsNotOneOf => 'ni nobeno od';

  @override
  String get cookbookOpContainsAll => 'vsebuje vse';

  @override
  String get cookbookSelectValues => 'Izberi vrednosti';

  @override
  String get cookbookFilterOptionsUnavailable => 'Ni razpoložljivih možnosti';

  @override
  String get cookbookAddFilterField => 'Dodaj polje';

  @override
  String get cookbookPublicLabel => 'Javna kuharska knjiga';

  @override
  String get cookbookPublicSubtitle =>
      'Vidna drugim gospodinjstvom na strežniku';

  @override
  String get cookbookRawModeEnter => 'Uredi kot besedilo';

  @override
  String get cookbookRawModeExit => 'Nazaj na gradilnik';

  @override
  String get cookbookRawModeHint =>
      'Napredni način te aplikacije: filter uredi neposredno kot besedilo. Uporabno, kadar obstoječega filtra ni bilo mogoče razčleniti na preproste vrstice.';

  @override
  String get cookbookRawModeUnparseable =>
      'To besedilo ne ustreza preprosti obliki vrstic — ostane kot besedilo.';

  @override
  String get saveFailed => 'Shranjevanje ni uspelo';

  @override
  String get search => 'Iskanje';

  @override
  String get apply => 'Uporabi';

  @override
  String get setupCachingTitle => 'Nalaganje tvojih receptov';

  @override
  String get setupCachingSubtitle =>
      'Tvoji recepti se pripravljajo za uporabo brez povezave. Odvisno od njihovega števila lahko to traja nekaj časa.';

  @override
  String get setupCachingDone => 'Vse pripravljeno!';

  @override
  String get setupTipsHeader => 'Zanimivost';

  @override
  String get setupFinish => 'Začnimo';

  @override
  String get setupSkipCaching => 'Nadaljuj v ozadju';

  @override
  String get setupTip1 =>
      'Recepte lahko uvoziš prek povezave, fotografije ali PDF-ja — s ploščico Uvoz na domačem zaslonu.';

  @override
  String get setupTip2 =>
      'Način kuhanja ohranja zaslon vklopljen, te vodi korak za korakom in samodejno prepozna časovnike v besedilu.';

  @override
  String get setupTip3 =>
      'Nakupovalni seznam deluje tudi brez povezave — spremembe se samodejno sinhronizirajo, ko je strežnik dosegljiv.';

  @override
  String get setupTip4 =>
      'Za preureditev hitrega dostopa pridrži ploščico na domačem zaslonu.';

  @override
  String get setupTip5 =>
      'Svoje kuharske knjige Mealie najdeš na ploščici Kuharske knjige — tudi brez povezave.';

  @override
  String get ok => 'V redu';

  @override
  String get cancel => 'Prekliči';

  @override
  String get delete => 'Izbriši';

  @override
  String get edit => 'Uredi';

  @override
  String get save => 'Shrani';

  @override
  String get done => 'Končano';

  @override
  String get close => 'Zapri';

  @override
  String get add => 'Dodaj';

  @override
  String get send => 'Pošlji';

  @override
  String get retry => 'Poskusi znova';

  @override
  String get confirmDeleteTitle => 'Izbrišem recept?';

  @override
  String get confirmDeleteMessage => 'Tega dejanja ni mogoče razveljaviti.';

  @override
  String get sendToDevice => 'Pošlji na napravo';

  @override
  String get sendToDevicePickerTitle => 'Pošlji na napravo';

  @override
  String get sendToAllDevices => 'Pošlji na vse naprave';

  @override
  String get timerFinished => 'Časovnik je potekel!';

  @override
  String get timerFinishedBody => 'Časovnik tvojega recepta je potekel.';

  @override
  String get timer => 'Časovnik';

  @override
  String get newTimer => 'Nov časovnik';

  @override
  String get timerDetails => 'Podrobnosti časovnika';

  @override
  String get timerNamePlaceholder => 'Ime časovnika';

  @override
  String get timerNameHint => 'Daj časovniku opisno ime.';

  @override
  String get durationLabel => 'Trajanje';

  @override
  String minutesCount(int count) {
    return '$count min';
  }

  @override
  String get start => 'Začni';

  @override
  String get stop => 'Ustavi';

  @override
  String get pause => 'Premor';

  @override
  String get resume => 'Nadaljuj';

  @override
  String get finished => 'Končano!';

  @override
  String stepNumber(int number) {
    return '$number. korak';
  }

  @override
  String get minAbbreviation => 'min';

  @override
  String get cookingMode => 'Način kuhanja';

  @override
  String activeRecipesCount(int count) {
    return 'Aktivnih receptov: $count';
  }

  @override
  String get endAll => 'Končaj vse';

  @override
  String get end => 'Končaj';

  @override
  String get endAllRecipesTitle => 'Končam vse recepte?';

  @override
  String endAllRecipesMessage(int count) {
    return 'Ali želiš končati vse aktivne kuharske seje ($count)?';
  }

  @override
  String get endRecipeTitle => 'Končam recept?';

  @override
  String endRecipeMessage(String name) {
    return 'Ali želiš končati kuhanje recepta \"$name\"?';
  }

  @override
  String get noActiveTimers => 'Ni aktivnih časovnikov';

  @override
  String get noActiveRecipes => 'Ni aktivnih receptov';

  @override
  String get startRecipeToCook =>
      'Odpri recept in tapni gumb za način kuhanja, da začneš.';

  @override
  String get browseRecipes => 'Prebrskaj recepte';

  @override
  String timersPausedCount(int count) {
    return 'Zaustavljenih časovnikov: $count';
  }

  @override
  String get cookFriends => 'Kuhanje s prijatelji';

  @override
  String get cookingModeAddRecipe => 'Dodaj recept';

  @override
  String get cookingModeAddRecipeSearchHint => 'Išči recepte';

  @override
  String get cookFriendsCode => 'Koda seje';

  @override
  String get cookFriendsJoin => 'Pridruži se seji';

  @override
  String get cookFriendsHost => 'Gosti sejo';

  @override
  String get cookFriendsHostNotFound =>
      'Gostitelja ni mogoče najti. Preveri, da sta obe napravi v istem omrežju Wi-Fi in da je dovoljen dostop do lokalnega omrežja.';

  @override
  String get cookFriendsConnectionFailed =>
      'Povezava ni uspela. Poskusi znova.';

  @override
  String get cookFriendsEnterCode => 'Vnesi kodo';

  @override
  String cookFriendsConnected(int count) {
    return 'Povezanih gostov: $count';
  }

  @override
  String get joinSession => 'Pridruži se seji';

  @override
  String get hostEndedSessionTitle => 'Seja je končana';

  @override
  String get hostEndedSessionMessage => 'Gostitelj je končal skupno kuhanje.';

  @override
  String get shoppingListEmpty => 'Tvoj nakupovalni seznam je prazen.';

  @override
  String get addItem => 'Dodaj artikel';

  @override
  String get itemNote => 'Ime artikla';

  @override
  String get unlabeledCategory => 'Brez oznake';

  @override
  String get reorderCategories => 'Preuredi kategorije';

  @override
  String get archiveChecked => 'Arhiviraj odkljukane artikle';

  @override
  String get archivedLists => '📦 Arhivirani nakupi';

  @override
  String get syncChanges => 'Sinhroniziraj spremembe';

  @override
  String get noSyncChanges => 'Ni sprememb za sinhronizacijo';

  @override
  String get postimportAction => 'Po uvozu';

  @override
  String get postimportHint =>
      'Izberi, kaj naj se v izvorni aplikaciji (Opomniki / Google Opravila) zgodi z uvoženimi vnosi.';

  @override
  String get postimportLeave => 'Samo dodaj';

  @override
  String get postimportComplete => 'Odkljukaj';

  @override
  String get postimportCompleteDelete => 'Odkljukaj in izbriši';

  @override
  String get postimportFailed =>
      'Obdelava v izvorni aplikaciji ni uspela. Artikli so bili kljub temu dodani v Mealie.';

  @override
  String get syncChangesTitle => 'Sinhroniziraj spremembe';

  @override
  String get syncSectionChecked => 'Odkljukano';

  @override
  String get syncSectionQuantity => 'Količina';

  @override
  String get syncSectionCategory => 'Kategorija';

  @override
  String get syncSectionAdditions => 'Na novo dodano';

  @override
  String get syncLocalLabel => 'Lokalno';

  @override
  String get syncServerLabel => 'Strežnik';

  @override
  String get syncNow => 'Sinhroniziraj zdaj';

  @override
  String get offlineBadge => 'Brez povezave';

  @override
  String get mealplanTitle => '📅 Jedilnik';

  @override
  String get mealplanSelectMode => 'Izberi več receptov';

  @override
  String mealplanSelectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count izbranih',
      few: '$count izbrani',
      two: '$count izbrana',
      one: '1 izbran',
    );
    return '$_temp0';
  }

  @override
  String get breakfast => 'Zajtrk';

  @override
  String get lunch => 'Kosilo';

  @override
  String get dinner => 'Večerja';

  @override
  String get addMealEntry => 'Dodaj obrok';

  @override
  String get selectRecipe => 'Izberi recept';

  @override
  String get orFreeText => 'ali prosto besedilo';

  @override
  String get entryNote => 'Opomba';

  @override
  String get noMealEntries => 'Za ta teden ni vnosov.';

  @override
  String get importRecipe => 'Uvozi recept';

  @override
  String get importFromUrl => 'Uvoz iz URL-ja';

  @override
  String get importFromImage => 'Uvoz iz fotografije';

  @override
  String get importFromJson => 'Uvoz iz JSON-a';

  @override
  String get url => 'URL';

  @override
  String get urlPlaceholder => 'https://...';

  @override
  String get importLanguage => 'Jezik za OCR';

  @override
  String get importing => 'Uvažanje…';

  @override
  String get importSuccess => 'Recept uspešno uvožen!';

  @override
  String importError(String error) {
    return 'Uvoz ni uspel: $error';
  }

  @override
  String get pasteJson => 'Sem prilepi JSON';

  @override
  String get setupTitle => 'Dobrodošli v Mealie Recipes';

  @override
  String get setupSubtitle => 'Nastavi svoj strežnik Mealie.';

  @override
  String get serverUrl => 'URL strežnika';

  @override
  String get serverUrlPlaceholder => 'https://mealie.example.com';

  @override
  String get apiToken => 'Žeton API';

  @override
  String get apiTokenPlaceholder => 'Tvoj žeton API';

  @override
  String get householdId => 'Gospodinjstvo';

  @override
  String get householdIdPlaceholder => 'Family';

  @override
  String get shoppingListId => 'Nakupovalni seznam';

  @override
  String get shoppingListIdPlaceholder => 'Izberi nakupovalni seznam';

  @override
  String get setupHouseholdListTitle => 'Gospodinjstvo in nakupovalni seznam';

  @override
  String get shoppingListLabel => 'Nakupovalni seznam';

  @override
  String get setupHouseholdManualHint =>
      'Gospodinjstev ni bilo mogoče naložiti — ime vnesi ročno.';

  @override
  String get setupExactTitle => 'Količine na nakupovalnem seznamu';

  @override
  String get setupExactBody =>
      'V večini držav ne kupujemo na gram natančno — v košarico gre 1 zavitek masla, ne 200 g. V preprostem načinu aplikacija zato količine iz receptov pretvori v „1ד. V natančnem načinu se količina in enota ohranita 1:1 kot v spletni aplikaciji Mealie — tudi pri vnosu novih artiklov (npr. „200 g masla“). To lahko kadar koli spremeniš v nastavitvah.';

  @override
  String get setupExactSimpleTitle => 'Preprosti način (1×)';

  @override
  String get setupExactSimpleBody =>
      'Sestavine pridejo na seznam kot „1× artikel“ — idealno za hitro odkljukanje v trgovini.';

  @override
  String get setupExactExactTitle => 'Natančne količine';

  @override
  String get setupExactExactBody =>
      'Artikli so prikazani s količino in enoto, npr. „200 g masla“ — enako kot v spletni aplikaciji.';

  @override
  String get connect => 'Poveži';

  @override
  String get connecting => 'Povezovanje…';

  @override
  String get connectionSuccess => 'Povezava uspešna!';

  @override
  String connectionError(String error) {
    return 'Povezava ni uspela: $error';
  }

  @override
  String get optionalHeaders => 'Neobvezne glave HTTP (za povratni proxy)';

  @override
  String get settingsTitle => '⚙️ Nastavitve';

  @override
  String get settingsSaved => 'Nastavitve shranjene';

  @override
  String get serverSettings => 'Strežnik';

  @override
  String get displaySettings => 'Prikaz';

  @override
  String get notificationSettings => 'Obvestila';

  @override
  String get securitySettings => 'Varnost';

  @override
  String get aboutSettings => 'O aplikaciji';

  @override
  String get showRecipeImages => 'Prikaži slike receptov';

  @override
  String get apiVersion => 'Različica API';

  @override
  String get language => 'Jezik';

  @override
  String get biometricLock => 'Biometrično zaklepanje';

  @override
  String get biometricLockDescription => 'Odkleni aplikacijo z biometrijo';

  @override
  String get criticalAlerts => 'Kritična opozorila';

  @override
  String get criticalAlertsDescription => 'Alarm časovnika tudi v tihem načinu';

  @override
  String get enableLogging => 'Omogoči beleženje';

  @override
  String get selectLanguage => 'Izberi jezik';

  @override
  String get setupContinue => 'Naprej';

  @override
  String get back => 'Nazaj';

  @override
  String get setupConnectStep => 'Poveži se s svojim strežnikom';

  @override
  String get resetSettings => 'Ponastavi vse nastavitve';

  @override
  String get resetSettingsConfirm =>
      'To bo ponastavilo vse nastavitve. Nadaljuješ?';

  @override
  String get guestMode => 'Način za goste';

  @override
  String get appVersion => 'Različica';

  @override
  String get leftoverFinder => 'Iskalnik receptov';

  @override
  String get leftoverFinderSubtitle =>
      'Najdi recepte s sestavinami, ki jih imaš';

  @override
  String get addIngredient => 'Dodaj sestavino';

  @override
  String get ingredientPlaceholder => 'npr. jajca';

  @override
  String get findRecipes => 'Najdi recepte';

  @override
  String get matchingRecipes => 'Ustrezni recepti';

  @override
  String get noMatchingRecipes => 'Za te sestavine ni najdenih receptov.';

  @override
  String matchPercent(int percent) {
    return '$percent % ujemanje';
  }

  @override
  String get biometricPrompt =>
      'Overi se za odpiranje aplikacije Mealie Recipes';

  @override
  String get biometricFailed => 'Overitev ni uspela';

  @override
  String get whatsNew => 'Novosti';

  @override
  String get pendingRecipesTitle => 'Prejeti recepti';

  @override
  String pendingRecipesMessage(String sender, String name) {
    return '$sender ti pošilja recept: \"$name\"';
  }

  @override
  String pendingRecipesFrom(Object names) {
    return 'Od: $names';
  }

  @override
  String get pendingRecipesOpenCooking => 'Odpri način kuhanja';

  @override
  String get pendingRecipesLater => 'Pozneje';

  @override
  String get openRecipe => 'Odpri recept';

  @override
  String get dismiss => 'Opusti';

  @override
  String get editRecipe => 'Uredi recept';

  @override
  String get recipeName => 'Ime recepta';

  @override
  String get recipeDescription => 'Opis';

  @override
  String get prepTime => 'Priprava (min)';

  @override
  String get cookTime => 'Kuhanje (min)';

  @override
  String get totalTime => 'Skupni čas (min)';

  @override
  String get recipeServings => 'Porcije';

  @override
  String get rating => 'Ocena';

  @override
  String get addIngredientLine => 'Dodaj sestavino';

  @override
  String get addInstruction => 'Dodaj korak';

  @override
  String get removeIngredient => 'Odstrani sestavino';

  @override
  String get removeInstruction => 'Odstrani korak';

  @override
  String get ingredientName => 'Sestavina';

  @override
  String get ingredientQuantity => 'Kol.';

  @override
  String get ingredientUnit => 'Enota';

  @override
  String get ingredientNote => 'Opomba';

  @override
  String get instructionText => 'Besedilo koraka';

  @override
  String get categories => 'Kategorije';

  @override
  String get selectCategories => 'Izberi kategorije';

  @override
  String get selectTags => 'Izberi značke';

  @override
  String get uploadImage => 'Naloži sliko';

  @override
  String get removeImage => 'Odstrani sliko';

  @override
  String get saveChanges => 'Shrani spremembe';

  @override
  String get saving => 'Shranjevanje…';

  @override
  String get saveSuccess => 'Recept shranjen.';

  @override
  String saveError(String error) {
    return 'Shranjevanje ni uspelo: $error';
  }

  @override
  String get newCategory => 'Nova kategorija';

  @override
  String get newTag => 'Nova značka';

  @override
  String get setRating => 'Nastavi oceno';

  @override
  String get removeRating => 'Odstrani oceno';

  @override
  String get ratingRemoved => 'Ocena odstranjena';

  @override
  String get googleTasksImport => 'Uvoz iz Google Opravil';

  @override
  String get googleTasksImportDescription =>
      'Uvozi vnose iz Google Opravil na svoj nakupovalni seznam.';

  @override
  String get homeWelcome => 'Dobrodošli v Mealie Recipes! 👋';

  @override
  String homeWelcomeNamed(String name) {
    return 'Živjo, $name, dobrodošli v Mealie Recipes! 👋';
  }

  @override
  String get shopping => 'Nakupovanje';

  @override
  String get planning => 'Načrtovanje';

  @override
  String get other => 'Drugo';

  @override
  String get viewRecipes => '📖 Ogled receptov';

  @override
  String get addRecipe => '➕ Dodaj recept';

  @override
  String get completeShopping => 'Zaključi nakup';

  @override
  String get shoppingCompleted => 'Nakup zaključen';

  @override
  String get shoppingCompletedSubtitle => 'Vse v košarici! 🎉';

  @override
  String get essensplan => '📅 Jedilnik';

  @override
  String get resteverwertung => '🥗 Iskalnik receptov';

  @override
  String get newRecipeUpload => 'Naloži nov recept';

  @override
  String get copyCode => 'Kopiraj kodo';

  @override
  String get shareLink => 'Deli povezavo';

  @override
  String get connectedFriends => 'Povezani prijatelji';

  @override
  String get waitingForFriends => 'Čakanje na prijatelje…';

  @override
  String get endSharing => 'Končaj deljenje';

  @override
  String get cookFriendsDescription =>
      'Povabi prijatelja, da skupaj skuhata ta recept';

  @override
  String get sessionCode => 'KODA SEJE';

  @override
  String get adjustQuantityLabel => 'Prilagodi količino za ta recept:';

  @override
  String get timerStartForStep => 'Časovnik za korak';

  @override
  String get enterRecipeUrl => 'Vnesi URL recepta';

  @override
  String get loading => 'Nalaganje…';

  @override
  String get urlInvalidScheme => 'URL se mora začeti s http:// ali https://';

  @override
  String get urlAddScheme => 'Dodaj https://';

  @override
  String get addItemPlaceholder => 'Dodaj artikel…';

  @override
  String get addSuccessToast => 'Dodano!';

  @override
  String get completedItems => 'Opravljeno';

  @override
  String get completeShoppingTitle => 'Zaključim nakup?';

  @override
  String get completeShoppingMessage => 'Izbrišem opravljene artikle?';

  @override
  String get recipeListTitle => '📖 Recepti';

  @override
  String get importRecipeTitle => 'Naloži nov recept';

  @override
  String get uploadRecipeUrl => 'Uvoz prek URL-ja recepta';

  @override
  String get uploadRecipeUrlHint =>
      'Vnesi URL recepta, da ga shraniš na svoj strežnik';

  @override
  String get uploadOpenAI => 'Uvoz iz datoteke z OpenAI';

  @override
  String get uploadOpenAIHint =>
      'Lahko pa naložiš fotografije ali PDF recepta. Če recept obsega več strani, dodaj več strani — umetna inteligenca jih analizira skupaj.';

  @override
  String get takePhoto => 'Kamera';

  @override
  String get cameraPermissionDenied =>
      'Ni dostopa do kamere. Dovoli ga v sistemskih nastavitvah, da lahko fotografiraš recepte.';

  @override
  String get cameraUnavailable => 'Na tej napravi ni na voljo nobene kamere.';

  @override
  String get selectPhoto => 'Fotografije';

  @override
  String get selectPdf => 'PDF';

  @override
  String get openAIHintTitle => 'Informacije o analizi datotek';

  @override
  String get openAIHintBody =>
      'Analiza receptov uporablja API OpenAI. Preveri, da je ključ API nastavljen v nastavitvah strežnika Mealie.';

  @override
  String get allDeleteConfirm => 'Izbriši vse';

  @override
  String get portionen => 'Porcije';

  @override
  String get timerForStep => 'Zaženi časovnik za ta korak';

  @override
  String get weekNavPrev => 'Prejšnji teden';

  @override
  String get weekNavNext => 'Naslednji teden';

  @override
  String get noMealsThisWeek => 'Ni načrtovanih obrokov';

  @override
  String get entriesInOtherWeeks => 'V drugih tednih so vnosi';

  @override
  String get availableWeeks => 'Razpoložljivi tedni:';

  @override
  String weekRange(Object end, Object start, Object week) {
    return '$week. teden ($start – $end)';
  }

  @override
  String get currentWeek => 'Trenutni teden';

  @override
  String get rezepteAktualisieren => 'Posodobi recepte';

  @override
  String get leftoverWhatTitle => 'Kaj to naredi?';

  @override
  String get leftoverWhatBody =>
      'Ta funkcija znova naloži vse recepte s strežnika in posodobi lokalni predpomnilnik.';

  @override
  String get leftoverDescription =>
      'Vnesi razpoložljive sestavine, da najdeš ustrezne recepte in porabiš ostanke.';

  @override
  String get leftoverIngredientsHeader => 'Sestavine doma';

  @override
  String get leftoverSuggestions => 'Predlogi receptov';

  @override
  String get leftoverNoMatches => 'Ni ustreznih receptov.';

  @override
  String get leftoverEnterIngredient => 'Vnesi sestavino';

  @override
  String matchingPercentText(int percent, int count, int total) {
    return '$percent % ujemanje ($count/$total)';
  }

  @override
  String get weekAbbreviation => 'Teden';

  @override
  String get today => 'Danes';

  @override
  String get selectDate => 'Izberi datum';

  @override
  String get selectSlot => 'Izberi obrok';

  @override
  String get selectedRecipe => 'Izbrani recept';

  @override
  String get confirmMeal => 'Načrtuj obrok';

  @override
  String get searchRecipes => 'Išči recepte';

  @override
  String get addCustomMeal => 'Dodaj obrok po meri';

  @override
  String get diceModeButton => 'Naključni recepti';

  @override
  String get diceModeTitle => '3 naključni predlogi';

  @override
  String get diceBackToSearch => 'Nazaj na iskanje';

  @override
  String get diceNotEnoughRecipes =>
      'Premalo receptov za naključni način (potrebni vsaj 3)';

  @override
  String get entrySingular => 'vnos';

  @override
  String get entriesPlural => 'vnosov';

  @override
  String listTitle(int n) {
    return 'Seznam $n';
  }

  @override
  String get deleteAllConfirmTitle => 'Izbrišem vse?';

  @override
  String get deleteAllConfirmMessage =>
      'Želiš izbrisati vse arhivirane nakupe?';

  @override
  String get uploadFromUrlButton => 'Uvozi recept iz URL-ja';

  @override
  String get uploadingImage => 'Nalaganje…';

  @override
  String get uploadErrorTitle => 'Nalaganje ni uspelo';

  @override
  String get uploadSuccessTitle => 'Nalaganje uspešno';

  @override
  String get editImportedRecipeQuestion =>
      'Ali želiš zdaj urediti novi recept?';

  @override
  String get notNow => 'Ne zdaj';

  @override
  String get pdfTooLarge => 'Datoteka PDF je prevelika (največ 10 MB).';

  @override
  String get invalidUrl => 'Neveljaven URL. Vnesi veljaven URL HTTP(S).';

  @override
  String get cookWithFriends => 'Kuhanje s prijatelji';

  @override
  String get cookFriendsSubtitle =>
      'Povabi prijatelja, da skupaj skuhata ta recept';

  @override
  String get copied => 'Kopirano';

  @override
  String get linkCopied => 'Povezava kopirana';

  @override
  String get startCooking => 'Začni kuhati';

  @override
  String get hostNoRecipe => 'Odpri iz recepta, da gostiš sejo';

  @override
  String get uploadToOwnServer => 'Shrani na moj strežnik';

  @override
  String get uploadingRecipe => 'Nalaganje recepta…';

  @override
  String get recipeUploadedToOwnServer => 'Recept shranjen na tvoj strežnik';

  @override
  String get recipeUploadFailed => 'Nalaganje ni uspelo';

  @override
  String get allowGuestSaveRecipes =>
      'Dovoli gostom shranjevanje receptov na njihov strežnik';

  @override
  String get appIcon => 'Ikona aplikacije';

  @override
  String get appIconClassic => 'Classic';

  @override
  String get appIconModern => 'Modern';

  @override
  String get name => 'Ime';

  @override
  String get color => 'Barva';

  @override
  String get randomColor => 'Naključna barva';

  @override
  String get createFailed => 'Ustvarjanje ni uspelo';

  @override
  String get deleteFailed => 'Brisanje ni uspelo';

  @override
  String deleteOrganizerConfirm(String name) {
    return 'Izbrišem \"$name\"? S tem se odstrani tudi s strežnika.';
  }

  @override
  String get connectionSection => 'Povezava';

  @override
  String get token => 'Žeton';

  @override
  String get advancedOptions => 'Napredne možnosti';

  @override
  String get mealieApiVersion => 'Različica Mealie API';

  @override
  String get sendOptionalHeaders => 'Pošlji neobvezne glave';

  @override
  String get offlineRecipeImages =>
      'Shrani slike receptov za uporabo brez povezave';

  @override
  String get offlineRecipeImagesHint =>
      'Prenese vse slike receptov v to napravo, da so prikazane tudi brez povezave. Pri velikih zbirkah lahko to zasede več sto MB. Izklop izbriše shranjene slike.';

  @override
  String offlineRecipeImagesStatus(int count, int total, String size) {
    return 'Shranjeno: $count/$total · $size';
  }

  @override
  String get offlineRecipeImagesDisableConfirm =>
      'Izbrišem vse shranjene slike receptov?';

  @override
  String headerNameLabel(int n) {
    return 'Ime glave $n';
  }

  @override
  String headerValueLabel(int n) {
    return 'Vrednost glave $n';
  }

  @override
  String get value => 'Vrednost';

  @override
  String get personalization => 'Prilagoditev';

  @override
  String get showRecipeImagesSubtitle => 'Prikaže slike na seznamu receptov';

  @override
  String get exactQuantities => 'Dodaj natančne količine';

  @override
  String get exactQuantitiesSubtitle =>
      'Sestavine in vneseni artikli ohranijo količino in enoto (npr. 200 g masla) namesto 1x na artikel — manjkajoča živila aplikacija ustvari na strežniku';

  @override
  String get remindToShop => 'Opomni me na nakupovanje';

  @override
  String get remindToShopSubtitle =>
      'Obvesti te, ko si v bližini shranjene lokacije in imaš na nakupovalnem seznamu odprte artikle — tudi če je aplikacija zaprta';

  @override
  String get shoppingReminderAddLocation => 'Dodaj lokacijo';

  @override
  String get shoppingReminderMaxLocations => 'Doseženo največ 3 lokacije';

  @override
  String get shoppingReminderLocationServiceDisabled =>
      'Lokacijske storitve so na tej napravi izklopljene';

  @override
  String get shoppingReminderPermissionTitle =>
      'Potreben je dostop do lokacije';

  @override
  String get shoppingReminderPermissionMessage =>
      'Za opomnik v bližini trgovine je potreben dostop do lokacije »Vedno« — tudi ko je aplikacija zaprta. Omogoči ga v nastavitvah.';

  @override
  String get openSettings => 'Odpri nastavitve';

  @override
  String get shoppingReminderLocationName => 'Ime';

  @override
  String get shoppingReminderUseCurrentLocation => 'Uporabi trenutno lokacijo';

  @override
  String get shoppingReminderOrAddress => 'ali vnesi naslov';

  @override
  String get shoppingReminderAddress => 'Naslov';

  @override
  String get shoppingReminderAddressPlaceholder => 'Ulica, kraj';

  @override
  String get shoppingReminderSearchAddress => 'Išči';

  @override
  String get shoppingReminderLocationFailed =>
      'Lokacije ni bilo mogoče določiti';

  @override
  String get shoppingReminderAddressNotFound => 'Naslova ni mogoče najti';

  @override
  String get ratingFailed => 'Ocene ni bilo mogoče shraniti — poskusi znova.';

  @override
  String get lastCooked => 'Nazadnje skuhano';

  @override
  String get syncLastCooked => 'Posodobi „nazadnje skuhano“';

  @override
  String get syncLastCookedSubtitle =>
      'Na strežnik shrani današnji datum in vnos na časovnici — kot v spletni aplikaciji Mealie.';

  @override
  String get developer => 'Razvijalec';

  @override
  String get enableLoggingSubtitle =>
      'Beleži izpise/napake (zadnjih 500 vrstic)';

  @override
  String get entriesLabel => 'Vnosi';

  @override
  String get fileSize => 'Velikost datoteke';

  @override
  String get showAction => 'Prikaži';

  @override
  String get copy => 'Kopiraj';

  @override
  String logsWithCount(int count) {
    return 'Dnevniki ($count)';
  }

  @override
  String get noLogs => 'Ni dnevnikov';

  @override
  String get logsTitle => 'Dnevniki';

  @override
  String get required => 'Obvezno';

  @override
  String get connectionFailedCheck =>
      'Povezava ni uspela. Preveri URL in žeton.';

  @override
  String get username => 'Uporabniško ime';

  @override
  String get password => 'Geslo';

  @override
  String get setupPasswordHint =>
      'Tvoje geslo se ne shrani — aplikacija se enkrat prijavi in iz tega ustvari API-žeton (enako kot pod Profil → API-žetoni v spletni aplikaciji).';

  @override
  String get loginAndConnect => 'Prijava in povezava';

  @override
  String get loginInvalidCredentials => 'Napačno uporabniško ime ali geslo.';

  @override
  String get loginAndGenerateToken => 'Prijava in ustvarjanje žetona';

  @override
  String get loggingIn => 'Prijavljanje…';

  @override
  String get apiTokenSaveHint =>
      'Žeton uporabljen — spodaj tapni „Shrani spremembe“.';

  @override
  String get renewApiToken => 'Obnovi API-žeton';

  @override
  String get setupAuthChoiceTitle => 'Kako se želiš prijaviti?';

  @override
  String get authModePasswordTitle => 'Naj aplikacija zame ustvari API-ključ';

  @override
  String get authModePasswordSubtitle =>
      'Prijavi se z uporabniškim imenom in geslom — aplikacija samodejno ustvari žeton.';

  @override
  String get authModeTokenTitle => 'Že imam API-ključ';

  @override
  String get authModeTokenSubtitle =>
      'Kopiran iz profila Mealie (Profil → API-žetoni).';

  @override
  String keyN(int n) {
    return 'Ključ $n';
  }

  @override
  String valueN(int n) {
    return 'Vrednost $n';
  }

  @override
  String get openCookingMode => 'Odpri način kuhanja';

  @override
  String activeRecipes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count aktivnih receptov',
      few: '$count aktivni recepti',
      two: '$count aktivna recepta',
      one: '1 aktiven recept',
    );
    return '$_temp0';
  }

  @override
  String get reparseIngredients => 'Znova razčleni sestavine';

  @override
  String get reparseIngredientsSubtitle =>
      'Loči količino/enoto/sestavino (npr. „200 g moke“)';

  @override
  String get reparseDone =>
      'Sestavine ločene – tapni „Shrani spremembe“, da uveljaviš';

  @override
  String get reparseNone => 'Ni sestavin za ločevanje';

  @override
  String get tagsAndCategories => 'Značke, kategorije in pripomočki';

  @override
  String get tapToAddPhoto => 'Tapni za dodajanje fotografije';

  @override
  String get descriptionLabel => 'Opis';

  @override
  String get searchingDevices => 'Iskanje naprav v istem omrežju Wi-Fi…';

  @override
  String get selectAll => 'Izberi vse';

  @override
  String get importReminders => 'Uvozi opomnike';

  @override
  String get importGoogleTasks => 'Uvozi Google Opravila';

  @override
  String get noTaskLists => 'Ni najdenih seznamov opravil';

  @override
  String get noReminderLists => 'Ni najdenih seznamov opomnikov';

  @override
  String importCount(int count) {
    return 'Uvozi $count';
  }

  @override
  String get activeRecipeTimer => 'Aktivni časovnik recepta';

  @override
  String get linkIngredients => 'Poveži sestavine';

  @override
  String get noIngredientsToLink => 'Ni še sestavin za povezavo';

  @override
  String get importLanguageSubtitle =>
      'Jezik receptov, uvoženih iz fotografije ali PDF-ja';

  @override
  String get importLanguageSearch => 'Išči jezik';

  @override
  String get importLanguageFollowApp => 'Enako kot jezik aplikacije';

  @override
  String get importLanguageNoMatch => 'Nobenega jezika ni bilo mogoče najti';

  @override
  String get setupImportLanguageTitle => 'Uvoz receptov z UI';

  @override
  String get setupImportLanguageBody =>
      'Fotografije in PDF-je lahko v recepte pretvori umetna inteligenca. Izberi jezik, v katerem naj nastanejo — priročno, če tvoj materni jezik ni na voljo kot jezik aplikacije. To lahko pozneje spremeniš v nastavitvah.';

  @override
  String get setupImportLanguageSearchHint =>
      'Z iskalnikom v izbirniku najdeš tudi jezike, ki jih vmesnik aplikacije ne ponuja.';

  @override
  String get setupCachingKeepOpenTitle => 'Aplikacijo pusti odprto';

  @override
  String get setupCachingKeepOpenBody =>
      'Nalaganje teče v ospredju. Pusti aplikacijo odprto, dokler se ne konča — če jo zapreš ali predolgo preklopiš drugam, se postopek prekine in se pozneje začne znova.';

  @override
  String get supportContact => 'Stik s podporo';

  @override
  String get supportDialogMessage =>
      'Opiši svojo težavo in oglasili se bomo. Dnevnik zelo pomaga pri iskanju napake — priložiš ga lahko kot besedilno datoteko.';

  @override
  String get supportWithoutLogs => 'Brez dnevnika';

  @override
  String get supportWithLogs => 'Priloži dnevnik';

  @override
  String get supportMailSubject => 'Mealie Recipes — Podpora';

  @override
  String get supportMailHint => 'Tukaj opiši svojo težavo:';

  @override
  String get supportLogsEmpty =>
      'Dnevnik je prazen. Vklopi beleženje, ponovno izzovi težavo in jo nato pošlji.';

  @override
  String supportAddressCopied(String email) {
    return 'Naslov kopiran: $email';
  }

  @override
  String supportNoMailApp(String email) {
    return 'Nobene poštne aplikacije ni bilo mogoče najti. Naslov kopiran: $email';
  }

  @override
  String get createRecipeFromImages => 'Ustvari recept';

  @override
  String imagePagesSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count strani izbranih',
      few: '$count strani izbrane',
      two: '$count strani izbrani',
      one: '1 stran izbrana',
    );
    return '$_temp0';
  }

  @override
  String get imagePagesHint =>
      'Prva slika postane glavna slika recepta. Za prerazporeditev pridrži stran.';

  @override
  String get mainImageBadge => 'Glavna';

  @override
  String maxImagesReached(int max) {
    return 'Največ $max slik na recept.';
  }

  @override
  String get removePage => 'Odstrani stran';

  @override
  String get preparingPdf => 'Obdelava PDF...';

  @override
  String get shareRecipeTitle => 'Deli recept';

  @override
  String get recipeOptionsTitle => 'Možnosti';

  @override
  String get exportAsPdf => 'Izvozi kot PDF';

  @override
  String get generatingPdf => 'Ustvarjanje PDF-ja…';

  @override
  String get pdfExportFailed => 'Izvoz PDF-ja ni uspel';

  @override
  String get recipeTime => 'Čas';

  @override
  String get ingredientSectionTitle => 'Razdelek';

  @override
  String get addIngredientSection => 'Dodaj razdelek';

  @override
  String get aiImportToggle => 'Analiziraj z UI';

  @override
  String get aiImportToggleHint =>
      'Tudi za videe z recepti (YouTube, Instagram, TikTok …) in strani, ki jih običajni uvoz ne zna prebrati. Na tvojem strežniku Mealie mora biti nastavljen ponudnik UI – za videe tudi ponudnik zvoka.';

  @override
  String get aiImportButton => 'Uvozi z UI';

  @override
  String get aiImportRunning =>
      'UI analizira povezavo … pri videih lahko to traja nekaj minut.';

  @override
  String get aiImportFailed =>
      'Uvoz z UI ni uspel. Preveri nastavitve UI na svojem strežniku Mealie.';

  @override
  String get stepHeadingLabel => 'Naslov koraka (neobvezno)';

  @override
  String get linkedRecipeLabel => 'Povezan recept';

  @override
  String get toolsTitle => 'Pripomočki';

  @override
  String get prepareTools => 'Pripravi naslednje pripomočke';

  @override
  String get newTool => 'Nov pripomoček';

  @override
  String get renameAction => 'Preimenuj';

  @override
  String get organizerEmpty =>
      'Še ni vnosov. Tapni »+« zgoraj desno, da ga dodaš.';

  @override
  String organizerRecipeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count receptov',
      few: '$count recepti',
      two: '$count recepta',
      one: '$count recept',
      zero: 'Ni receptov',
    );
    return '$_temp0';
  }

  @override
  String get toolOnHand => 'Na voljo';

  @override
  String get mealDiceSettingsTitle => 'Filter kocke';

  @override
  String get mealDiceSettingsHint =>
      'Za vsak obrok izberi kategorije in značke. Kocka bo nato predlagala le recepte, ki imajo vsaj eno od njih. Ista izbira lahko velja za več obrokov.';

  @override
  String get mealDiceSettingsNoneHint =>
      'Za ta obrok ni izbrano nič: kocka samodejno izbira po kategorijah, kot so »Zajtrk«, »Kosilo« ali »Večerja«.';

  @override
  String get mealDiceAutoHintTitle => 'Samodejna izbira';

  @override
  String get mealDiceAutoHintBody =>
      'Za ta obrok še ni nastavljenih kategorij ali značk. Kocka zato išče kategorije, kot so »Zajtrk«, »Kosilo« ali »Večerja«, in dopolni z drugimi recepti.\n\nLastna izbira: v načrtu obrokov tapni zobnik poleg »+«.';

  @override
  String get dontShowAgain => 'Ne prikaži več';

  @override
  String get mealDiceNoMatches =>
      'Noben recept se ne ujema s kategorijami in značkami, izbranimi za ta obrok.';

  @override
  String mealDiceFewMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Samo $count ustreznih receptov',
      few: 'Samo $count ustrezni recepti',
      two: 'Samo $count ustrezna recepta',
      one: 'Samo $count ustrezen recept',
    );
    return '$_temp0';
  }

  @override
  String get commentsTitle => 'Komentarji';

  @override
  String get commentHint => 'Napiši komentar…';

  @override
  String get commentSaveFailed => 'Komentarja ni bilo mogoče shraniti.';

  @override
  String get commentDeleteConfirm => 'Izbrišem ta komentar?';

  @override
  String get cookingDoneCommentLabel => 'Komentar (neobvezno)';

  @override
  String get cookingDoneCommentHint => 'Kako je uspelo? Nasveti za naslednjič…';

  @override
  String get nutritionTitle => 'Hranilne vrednosti';

  @override
  String get nutritionPerServing => 'na porcijo';

  @override
  String get nutritionCalories => 'Kalorije';

  @override
  String get nutritionFat => 'Maščobe';

  @override
  String get nutritionSaturatedFat => 'Nasičene maščobe';

  @override
  String get nutritionTransFat => 'Transmaščobe';

  @override
  String get nutritionUnsaturatedFat => 'Nenasičene maščobe';

  @override
  String get nutritionCholesterol => 'Holesterol';

  @override
  String get nutritionSodium => 'Natrij';

  @override
  String get nutritionCarbohydrates => 'Ogljikovi hidrati';

  @override
  String get nutritionFiber => 'Vlaknine';

  @override
  String get nutritionSugar => 'Sladkor';

  @override
  String get nutritionProtein => 'Beljakovine';

  @override
  String get timelineTitle => 'Časovnica';

  @override
  String get timelineMadeThis => 'Naredil sem to';

  @override
  String timelineUserMadeThis(String name) {
    return '$name je tole pripravil/a';
  }

  @override
  String get timelineEmpty => 'Na časovnici še ni vnosov.';

  @override
  String get timelineDate => 'Datum';

  @override
  String get timelineNoteHint => 'Opomba (neobvezno)';

  @override
  String get timelineAddPhoto => 'Dodaj fotografijo';

  @override
  String get timelineRemovePhoto => 'Odstrani fotografijo';

  @override
  String get timelineSaved => 'Dodano na časovnico';

  @override
  String get timelineSaveFailed => 'Ni bilo mogoče dodati na časovnico';

  @override
  String get timelineImageFailed =>
      'Vnos je shranjen, fotografije pa ni bilo mogoče naložiti';

  @override
  String get timelineDeleteConfirm => 'Izbrišem ta vnos s časovnice?';

  @override
  String get timelineEditNote => 'Uredi opombo';

  @override
  String get timelineUnknownRecipe => 'Recepta ni bilo mogoče najti';

  @override
  String get cookingDonePhotoHint =>
      'Fotografija za časovnico Mealie (neobvezno)';

  @override
  String get assetsTitle => 'Priloge';

  @override
  String get assetsAdd => 'Dodaj prilogo';

  @override
  String get assetsChooseFile => 'Datoteka';

  @override
  String get assetsUploading => 'Nalaganje …';

  @override
  String get assetsUploadFailed => 'Priloge ni bilo mogoče naložiti';

  @override
  String assetsDeleteConfirm(String name) {
    return 'Odstranim »$name« iz prilog?';
  }

  @override
  String get assetsOpenFailed => 'Priloge ni bilo mogoče odpreti';

  @override
  String get assetsUnsupported =>
      'Mealie podpira le PDF, slike, TXT, MD, CSV in JSON.';

  @override
  String get assetsShare => 'Deli';

  @override
  String get mealRulesTitle => 'Pravila Mealie';

  @override
  String get mealRulesHint =>
      'Veljajo tudi v spletni aplikaciji Mealie. Če za dan in obrok velja več pravil, morajo biti izpolnjena vsa. Če ne velja nobeno, kocka izbira med vsemi recepti.';

  @override
  String get mealRuleAdd => 'Dodaj pravilo';

  @override
  String get mealRuleNewTitle => 'Novo pravilo';

  @override
  String get mealRuleEditTitle => 'Uredi pravilo';

  @override
  String get mealRuleDay => 'Dan';

  @override
  String get mealRuleAnyDay => 'Vsak dan';

  @override
  String get mealRuleMealType => 'Obrok';

  @override
  String get mealRuleAnyMeal => 'Vsak obrok';

  @override
  String get mealRuleConditionsTitle => 'Pogoji';

  @override
  String get mealRuleAllRecipes => 'Vsi recepti';

  @override
  String get mealRuleDeleteConfirm => 'Izbrišem to pravilo?';

  @override
  String get mealRulesOffline =>
      'Pravila Mealie trenutno niso dosegljiva – kocka uporablja izbor aplikacije.';

  @override
  String get mealRulesNoMatches =>
      'Noben recept ne ustreza pravilom Mealie za ta obrok.';

  @override
  String get mealTypeSide => 'Priloga';

  @override
  String get mealTypeSnack => 'Prigrizek';

  @override
  String get mealTypeDrink => 'Pijača';

  @override
  String get mealTypeDessert => 'Sladica';

  @override
  String get foodsTitle => 'Živila';

  @override
  String get unitsTitle => 'Enote';

  @override
  String get newFood => 'Novo živilo';

  @override
  String get newUnit => 'Nova enota';

  @override
  String get editFood => 'Uredi živilo';

  @override
  String get editUnit => 'Uredi enoto';

  @override
  String get pluralNameLabel => 'Ime v množini';

  @override
  String get abbreviationLabel => 'Okrajšava';

  @override
  String get pluralAbbreviationLabel => 'Okrajšava (množina)';

  @override
  String get mergeAction => 'Združi';

  @override
  String mergeIntoTitle(String name) {
    return 'Združi »$name« z …';
  }

  @override
  String mergeConfirm(String from, String to) {
    return '»$from« bo združeno z »$to«: vsi recepti in nakupovalni seznami bodo nato uporabljali »$to«, »$from« pa bo izbrisano.';
  }

  @override
  String get mergeFailed => 'Združevanje ni uspelo';

  @override
  String foodUnitDeleteConfirm(String name) {
    return 'Izbrišem »$name«? Sestavine, ki ga uporabljajo, bodo izgubile povezavo.';
  }

  @override
  String get foodsUnitsEmpty => 'Še ni vnosov.';

  @override
  String mealRuleConditionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pogojev',
      few: '$count pogoji',
      two: '$count pogoja',
      one: '$count pogoj',
    );
    return '$_temp0';
  }

  @override
  String get showAll => 'Prikaži vse';

  @override
  String get mealDiceModeTitle => 'Kocka uporablja';

  @override
  String get mealDiceModeApp => 'Izbor aplikacije';

  @override
  String get switchListTitle => 'Zamenjaj seznam';

  @override
  String get newShoppingList => 'Nov nakupovalni seznam';

  @override
  String shoppingListDeleteConfirm(String name) {
    return 'Izbrišem »$name«? Izbrisani bodo tudi vsi elementi v njem.';
  }

  @override
  String get labelOrderTitle => 'Razvrsti oznake';

  @override
  String get labelOrderHint =>
      'Povleci za razvrščanje. Velja za ta seznam – tudi v spletni aplikaciji Mealie.';

  @override
  String get labelOrderEmpty => 'Ta seznam še nima oznak.';

  @override
  String get useAsActiveList => 'Uporabi kot aktivni seznam';

  @override
  String get activeListBadge => 'Aktiven';

  @override
  String get foodLabelLabel => 'Oznaka';

  @override
  String get foodNoLabel => 'Brez oznake';

  @override
  String get aliasesLabel => 'Vzdevki';

  @override
  String get aliasAddHint => 'Dodaj vzdevek';

  @override
  String get foodOnHand => 'Na zalogi v gospodinjstvu';

  @override
  String get timelineChildRecipesTitle => 'Dodaj tudi povezanim receptom';

  @override
  String timelineMadeForRecipe(String recipe) {
    return 'Pripravljeno za $recipe';
  }

  @override
  String get timelineFilter => 'Filtriraj vnose';

  @override
  String get timelineTypeComment => 'Skuhano in opombe';

  @override
  String get timelineTypeInfo => 'Informacije';

  @override
  String get timelineTypeSystem => 'Sistem';

  @override
  String get listManagementTitle => 'Nakupovalni seznami';

  @override
  String get managementTitle => 'Več';

  @override
  String get pinToHome => 'Dodaj na začetni zaslon';

  @override
  String get unpinFromHome => 'Odstrani z začetnega zaslona';

  @override
  String homeScreenFull(int count) {
    return 'Začetni zaslon je poln – največ $count ploščic. Najprej odstrani drugo ploščico v »Več«.';
  }

  @override
  String get selectAction => 'Izberi';

  @override
  String selectedCount(int count) {
    return 'Izbrano: $count';
  }

  @override
  String get assignLabelAction => 'Dodeli oznako';

  @override
  String get assignLabelOverwriteHint => 'Prepiše oznako vseh izbranih živil.';

  @override
  String deleteSelectedConfirm(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Izbrišem $count vnosov?',
      few: 'Izbrišem $count vnose?',
      two: 'Izbrišem $count vnosa?',
      one: 'Izbrišem $count vnos?',
    );
    return '$_temp0';
  }

  @override
  String get seedDataAction => 'Naloži privzete podatke';

  @override
  String get seedFoodsHint =>
      'Ustvari privzeta živila Mealie v izbranem jeziku.';

  @override
  String get seedUnitsHint =>
      'Ustvari privzete enote Mealie v izbranem jeziku.';

  @override
  String get seedLanguageLabel => 'Jezik';

  @override
  String get seedDuplicateWarning =>
      'Vnosi že obstajajo. Mealie ne usklajuje dvojnikov – združiti jih boš moral/-a sam/-a.';

  @override
  String get seedDone => 'Privzeti podatki ustvarjeni';

  @override
  String get seedFailed => 'Privzetih podatkov ni bilo mogoče naložiti';

  @override
  String get exportAction => 'Izvozi';

  @override
  String get substitutionsLabel => 'Zamenjave';

  @override
  String get substitutionAddHint => 'Dodaj zamenjavo';

  @override
  String get substitutionFoodLabel => 'Živilo (neobvezno)';

  @override
  String get substitutionNoteLabel => 'Opomba (neobvezno)';

  @override
  String get substitutionNeedOne => 'Vnesi živilo ali opombo';

  @override
  String get useAbbreviationLabel => 'Uporabi okrajšavo';

  @override
  String get useAbbreviationHint => 'V receptih prikaži »g« namesto »gram«';

  @override
  String get fractionLabel => 'Prikaži kot ulomek';

  @override
  String get fractionHint => '½ namesto 0,5';

  @override
  String get standardizationTitle => 'Standardizacija';

  @override
  String get standardizationHint =>
      'Za pretvorbe: 1 te enote je … (npr. 1 žlica = 15 mililitrov).';

  @override
  String get standardQuantityLabel => 'Standardna količina';

  @override
  String get standardUnitLabel => 'Standardna enota';

  @override
  String get standardUnitNone => 'Brez';

  @override
  String get stdFluidOunce => 'Tekočinska unča (fl oz)';

  @override
  String get stdCup => 'Skodelica (ZDA)';

  @override
  String get stdOunce => 'Unča (oz)';

  @override
  String get stdPound => 'Funt (lb)';

  @override
  String get stdMilliliter => 'Mililiter';

  @override
  String get stdLiter => 'Liter';

  @override
  String get stdGram => 'Gram';

  @override
  String get stdKilogram => 'Kilogram';

  @override
  String get labelsTitle => 'Oznake';

  @override
  String get newLabel => 'Nova oznaka';

  @override
  String get editLabel => 'Uredi oznako';

  @override
  String get colorLabel => 'Barva';

  @override
  String labelDeleteConfirm(String name) {
    return 'Izbrišem »$name«? Elementi in živila bodo izgubili to oznako.';
  }

  @override
  String get importMenuAction => 'Uvozi';

  @override
  String get archivedEmpty =>
      'Še ni arhiviranih nakupov. Po nakupu tapni »Zaključi nakup« – obkljukani elementi se shranijo sem.';

  @override
  String get sectionTitleLabel => 'Naslov odseka';

  @override
  String get clearSection => 'Počisti razdelek';

  @override
  String get noPermissionGeneric =>
      'Za to v Mealie nimaš dovoljenja. Vprašaj skrbnika ali upravitelja gospodinjstva.';

  @override
  String get noPermissionEditRecipe =>
      'Tega recepta ne moreš urejati – zaklenjen je ali pripada drugemu gospodinjstvu. To lahko stori le ustvarjalec ali skrbnik.';

  @override
  String get noPermissionDeleteRecipe =>
      'Recept lahko izbriše le njegov ustvarjalec ali skrbnik.';

  @override
  String get noPermissionDemoteSelf =>
      'Svojih skrbniških pravic si ne moreš odvzeti.';

  @override
  String get recipeLockedHint => 'Zaklenjeno – ureja lahko le ustvarjalec';

  @override
  String get recipeDeleteOwnerOnlyHint =>
      'Izbriše lahko le ustvarjalec ali skrbnik';

  @override
  String get organizeReadOnlyHint =>
      'Samo ogled: za ustvarjanje, spreminjanje in brisanje potrebuješ dovoljenje »Uporabnik lahko upravlja živila, oznake in kategorije«.';

  @override
  String get notesNotSavedNoPermission =>
      'Opomba ni shranjena – nimaš dovoljenja za urejanje tega recepta.';

  @override
  String get userManagementTitle => 'Upravljanje z uporabniki';

  @override
  String get usersTitle => 'Uporabniki';

  @override
  String get editUserTitle => 'Uredi uporabnika';

  @override
  String get fullNameLabel => 'Polno ime';

  @override
  String get usernameLabel => 'Uporabniško ime';

  @override
  String get emailLabel => 'E-mail';

  @override
  String get passwordLabel => 'Geslo';

  @override
  String get householdLabel => 'Gospodinjstvo';

  @override
  String get permissionsTitle => 'Dovoljenja';

  @override
  String get administratorLabel => 'Skrbnik';

  @override
  String get permCanInvite => 'Uporabnih lahko povabi druge v skupino';

  @override
  String get permCanManage => 'Uporabnik lahko upravlja nastavitve skupine';

  @override
  String get permCanManageHousehold => 'Uporabnik lahko upravlja gospodinjstvo';

  @override
  String get permCanOrganize =>
      'Uporabnik lahko upravlja živila, oznake in kategorije';

  @override
  String get advancedFeaturesLabel => 'Vključi napredne funkcije';

  @override
  String get passwordResetLinkAction =>
      'Ustvari povezavo za ponastavljanje gesla';

  @override
  String get resetLockedUsersAction => 'Ponastavi zaklenjene uporabnike';

  @override
  String get membersTitle => 'Člani';

  @override
  String get inviteLinkTitle => 'Povezava za povabilo';

  @override
  String get inviteAction => 'Povabi';

  @override
  String get userUpdated => 'Uporabnik posodobljen';

  @override
  String get createUserTitle => 'Ustvari uporabnika';

  @override
  String get userCreated => 'Uporabnik ustvarjen';

  @override
  String userDeleteConfirm(String name) {
    return 'Izbrišem »$name«? Račun bo odstranjen iz Mealie.';
  }

  @override
  String get passwordResetLinkCopied =>
      'Povezava kopirana – posreduj jo uporabniku. Velja le omejen čas.';

  @override
  String lockedUsersReset(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count uporabnikov odklenjenih',
      few: '$count uporabniki odklenjeni',
      two: '$count uporabnika odklenjena',
      one: '$count uporabnik odklenjen',
      zero: 'Ni zaklenjenih uporabnikov',
    );
    return '$_temp0';
  }

  @override
  String get inviteUsesLabel => 'Število uporab';

  @override
  String get inviteCreated => 'Povezava za povabilo ustvarjena';

  @override
  String get inviteEmailHint =>
      'E-poštni naslov (neobvezno – Mealie pošlje povabilo)';

  @override
  String get inviteEmailSent => 'Povabilo poslano po e-pošti';

  @override
  String get inviteEmailFailed =>
      'E-pošte ni bilo mogoče poslati (je SMTP nastavljen v Mealie?). Povezava vseeno deluje.';

  @override
  String get copyLinkAction => 'Kopiraj povezavo';

  @override
  String get youLabel => 'Ti';

  @override
  String get membersPermissionsHint =>
      'Spremeniš lahko dovoljenja članov svojega gospodinjstva – svojih pa ne.';

  @override
  String get householdManagementTitle => 'Upravljanje gospodinjstva';

  @override
  String get householdsTitle => 'Gospodinjstva';

  @override
  String get createHouseholdTitle => 'Ustvari gospodinjstvo';

  @override
  String get householdNameLabel => 'Ime gospodinjstva';

  @override
  String get householdPreferencesTitle => 'Nastavitve gospodinjstva';

  @override
  String get privateHouseholdLabel => 'Zasebno gospodinjstvo';

  @override
  String get privateHouseholdHint =>
      'Če svoje gospodinjstvo nastavite na zasebno, boste onemogočili vse možnosti javnega pogleda. To preglasi vse posamezne nastavitve javnega pogleda';

  @override
  String get lockRecipeEditsLabel =>
      'Zakleni urejanje receptov iz drugih gospodinjstev';

  @override
  String get lockRecipeEditsHint =>
      'Ko je omogočeno, lahko samo uporabniki v vašem gospodinjstvu urejajo recepte, ki jih je ustvarilo vaše gospodinjstvo';

  @override
  String get householdRecipePreferencesTitle =>
      'Nastavitve gospodinjskih receptov';

  @override
  String get groupsTitle => 'Skupine';

  @override
  String get groupLabel => 'Skupina';

  @override
  String get createGroupTitle => 'Ustvari skupino';

  @override
  String get groupNameLabel => 'Ime skupine';

  @override
  String get groupPreferencesTitle => 'Nastavitve za skupine';

  @override
  String get privateGroupLabel => 'Zasebna skupina';

  @override
  String get privateGroupHint =>
      'Če svojo skupino nastavite na zasebno, boste onemogočili vse možnosti javnega pogleda. To preglasi vse posamezne nastavitve javnega pogleda';

  @override
  String get firstDayOfWeekLabel => 'Prvi dan v tednu';

  @override
  String get showAnnouncementsLabel => 'Prikaži obvestila od Mealie';

  @override
  String get recipePublicDefaultLabel =>
      'Dovoli uporabnikom zunaj tvoje skupine, da vidijo tvoje recepte';

  @override
  String get recipeShowNutritionDefaultLabel => 'Pokaži hranilne vrednosti';

  @override
  String get recipeShowAssetsDefaultLabel => 'Pokaži priloge recepta';

  @override
  String get recipeLandscapeDefaultLabel => 'Privzeto uporabi ležeči pogled';

  @override
  String get recipeDisableCommentsDefaultLabel =>
      'Onemogoči komentiranje na recepte';

  @override
  String get myHouseholdSection => 'Moje gospodinjstvo';

  @override
  String get myGroupSection => 'Moja skupina';

  @override
  String get preferencesSaved => 'Nastavitve shranjene';

  @override
  String get cannotDeleteWithUsers =>
      'Še ima uporabnike – najprej jih premakni ali izbriši v upravljanju uporabnikov.';

  @override
  String deleteHouseholdConfirm(String name) {
    return 'Izbrišem gospodinjstvo »$name«?';
  }

  @override
  String deleteGroupConfirm(String name) {
    return 'Izbrišem skupino »$name«?';
  }

  @override
  String usersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count uporabnikov',
      few: '$count uporabniki',
      two: '$count uporabnika',
      one: '$count uporabnik',
      zero: 'Ni uporabnikov',
    );
    return '$_temp0';
  }

  @override
  String get originalUrlLabel => 'Izvorni URL';

  @override
  String get copyTextAction => 'Kopiraj besedilo';

  @override
  String get copiedToClipboard => 'Kopirano v odložišče';

  @override
  String get changelogEnglishHint =>
      'Novosti so na voljo le v angleščini – z »Kopiraj besedilo« jih lahko prilepiš npr. v prevajalnik.';

  @override
  String get favoritesTitle => 'Priljubljene';

  @override
  String get favoritesEmpty =>
      'Še ni priljubljenih. Tapni srce pri receptu, da ga zbereš tukaj.';

  @override
  String get changelogTitle => 'Changelog';

  @override
  String get changeProfileImage => 'Spremeni profilno sliko';

  @override
  String get profileImageUpdated => 'Profilna slika posodobljena';

  @override
  String get profileImageFailed => 'Profilne slike ni bilo mogoče naložiti';

  @override
  String get myAccountTitle => 'Moj račun';

  @override
  String get ownAccountHint =>
      'Tukaj lahko urejaš svoj račun. Druge uporabnike upravljajo skrbniki in člani z dovoljenjem »upravljanje«.';

  @override
  String get changePasswordAction => 'Spremeni geslo';

  @override
  String get currentPasswordLabel => 'Trenutno geslo';

  @override
  String get newPasswordLabel => 'Novo geslo';

  @override
  String get confirmPasswordLabel => 'Potrdi geslo';

  @override
  String get passwordTooShort => 'Vsaj 8 znakov';

  @override
  String get passwordsDoNotMatch => 'Gesli se ne ujemata';

  @override
  String get passwordUpdated => 'Geslo posodobljeno';

  @override
  String get passwordChangeFailed => 'Gesla ni bilo mogoče spremeniti';

  @override
  String passwordManagedExternally(String method) {
    return 'Prijavljaš se prek $method — geslo spremeni tam.';
  }

  @override
  String get bulkAddHint => 'Ena vrstica na vnos.';

  @override
  String bulkAddCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dodaj $count vnosov',
      few: 'Dodaj $count vnose',
      two: 'Dodaj $count vnosa',
      one: 'Dodaj 1 vnos',
    );
    return '$_temp0';
  }

  @override
  String get linkRecipeAction => 'Poveži recept';

  @override
  String get useFoodAction => 'Živilo namesto recepta';

  @override
  String get addSubstitutionsAction => 'Dodaj zamenjave';

  @override
  String get clearSubstitutionsAction => 'Počisti zamenjave';

  @override
  String get recipeSubstitutionsTitle => 'Zamenjave';

  @override
  String get substitutionUnknownFood =>
      'Samo obstoječa živila – sicer uporabi opombo';

  @override
  String get insertAboveAction => 'Vstavi zgoraj';

  @override
  String get insertBelowAction => 'Vstavi spodaj';

  @override
  String get moveToTopAction => 'Premakni na vrh';

  @override
  String get moveToBottomAction => 'Premakni na dno';

  @override
  String get linkReferencesAction => 'Povezave do virov';

  @override
  String get editMarkdownAction => 'Uredi markdown';

  @override
  String get previewMarkdownAction => 'Predogled Markdown';

  @override
  String get insertStepImageAction => 'Naloži sliko';

  @override
  String get mergeAboveAction => 'Združi z zgornjim';

  @override
  String get linkedToOtherStep => 'Povezano z drugim korakom';

  @override
  String get noNotesToLink => 'Ni zapiskov za povezavo';

  @override
  String get ownerLabel => 'Lastnik';

  @override
  String get ingredientParserTitle => 'Razčlenjevalnik sestavin';

  @override
  String ingredientParserHint(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count sestavin še ni strukturiranih. Izberi razčlenjevalnik, preveri rezultat, uporabi.',
      few:
          '$count sestavine še niso strukturirane. Izberi razčlenjevalnik, preveri rezultat, uporabi.',
      two:
          '$count sestavini še nista strukturirani. Izberi razčlenjevalnik, preveri rezultat, uporabi.',
      one:
          '1 sestavina še ni strukturirana. Izberi razčlenjevalnik, preveri rezultat, uporabi.',
    );
    return '$_temp0';
  }

  @override
  String get parserNlp => 'Procesor naravnega jezika';

  @override
  String get parserBrute => 'Surov razčlenjevalnik';

  @override
  String get parserOpenai => 'Razčlenjevalnik OpenAI';

  @override
  String get parserApp => 'Brez povezave (aplikacija)';

  @override
  String get parseFailed => 'Razčlenjevanje ni uspelo';

  @override
  String get parseAction => 'Razčleni';

  @override
  String applyParsedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Uporabi $count sestavin',
      few: 'Uporabi $count sestavine',
      two: 'Uporabi $count sestavini',
      one: 'Uporabi 1 sestavino',
      zero: 'Nič izbrano',
    );
    return '$_temp0';
  }

  @override
  String get parsedNewBadge => 'novo';

  @override
  String get hoursShort => 'ur';

  @override
  String get minutesShort => 'min';

  @override
  String get timeExtraHint => 'Dodatek, npr. »plus čez noč«';

  @override
  String get yieldLabel => 'Donos';

  @override
  String get yieldTextLabel => 'Besedilo donosa';

  @override
  String get prepTimeLabel => 'Čas priprave';

  @override
  String get performTimeLabel => 'Čas kuhanja';

  @override
  String get totalTimeLabel => 'Skupni čas';

  @override
  String get settingPublicRecipe => 'Javen recept';

  @override
  String get settingShowNutrition => 'Prikaži hranilne vrednosti';

  @override
  String get settingShowAssets => 'Prikaži vire';

  @override
  String get settingLandscapeView => 'Ležeči pogled';

  @override
  String get settingDisableComments => 'Onemogoči komentarje';

  @override
  String get settingDisableAmount => 'Onemogoči količine sestavin';

  @override
  String get settingLocked => 'Zaklenjeno';

  @override
  String get settingLockedOwnerOnly =>
      'Recept lahko zaklene ali odklene le avtor.';

  @override
  String get apiExtrasTitle => 'API dodatno';

  @override
  String get apiExtrasHint =>
      'Lastni pari ključ/vrednost za zunanje aplikacije, npr. za sprožanje avtomatizacij.';

  @override
  String get extraKeyLabel => 'Ključ';

  @override
  String get extraValueLabel => 'Vrednost';

  @override
  String get addExtraAction => 'Dodaj dodatek';

  @override
  String durationHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ur',
      few: '$count ure',
      two: '$count uri',
      one: '1 ura',
    );
    return '$_temp0';
  }

  @override
  String durationMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minut',
      few: '$count minute',
      two: '$count minuti',
      one: '1 minuta',
    );
    return '$_temp0';
  }

  @override
  String get discardChangesConfirm => 'Zavržem neshranjene spremembe?';

  @override
  String get discardChanges => 'Zavrzi spremembe';

  @override
  String get imageFromUrl => 'Slika iz URL-ja';

  @override
  String get deleteRecipeImage => 'Izbriši sliko recepta';

  @override
  String get deleteRecipeImageConfirm =>
      'Ali res želiš izbrisati to sliko recepta?';

  @override
  String get bulkAddIngredients => 'Množično dodaj sestavine';

  @override
  String get bulkAddSteps => 'Množično dodaj korake';

  @override
  String get stepImageFailed => 'Slike ni bilo mogoče naložiti';

  @override
  String get servingsAndTimes => 'Porcije in časi';

  @override
  String get recipeSettingsTitle => 'Nastavitve recepta';

  @override
  String get jsonEditorTitle => 'JSON urejevalnik';

  @override
  String get jsonInvalid => 'Neveljaven JSON – preveri.';

  @override
  String get editorOfflineHint =>
      'Odprto brez povezave: shranjevanje zahteva povezavo. Novejša polja Mealie (npr. zamenjave) ostanejo nespremenjena.';

  @override
  String get parseLineFailed => 'Ni prepoznano – ostane nespremenjeno';

  @override
  String get createManualTitle => 'Ročno ustvari recept';

  @override
  String get createManualHint =>
      'Vnesi ime – sestavine, korake, sliko in vse ostalo dodaš nato v urejevalniku recepta.';

  @override
  String get createManualButton => 'Ustvari in uredi';

  @override
  String get changelogEmpty => 'Za to različico še ni vnosov.';

  @override
  String get finderDescription =>
      'Poiščite recepte na podlagi sestavin, ki jih imate pri roki. Filtrirate lahko tudi po orodjih, ki jih imate na voljo, in nastavite največje število manjkajočih sestavin ali orodij.';

  @override
  String get finderSelectedIngredients => 'Izbrane sestavine';

  @override
  String get finderNoIngredientsSelected => 'Ni izbranih sestavin';

  @override
  String get finderMissing => 'Manjka';

  @override
  String get finderNoRecipesFound => 'Ni receptov';

  @override
  String get finderNoRecipesFoundDescription =>
      'Poskusite iskanju dodati več sestavin ali prilagoditi filtre';

  @override
  String get finderIncludeFoodsOnHand => 'Vključite sestavine pri roki';

  @override
  String get finderIncludeToolsOnHand => 'Vključite priročna orodja';

  @override
  String get finderIncludeSubstitutions => 'Vključi zamenjave';

  @override
  String get finderSubstituting => 'Zamenjava';

  @override
  String finderSubstituteForFood(String substitute, String food) {
    return '$substitute za $food';
  }

  @override
  String get finderMaxMissingIngredients => 'Največ manjkajočih sestavin';

  @override
  String get finderMaxMissingTools => 'Največ manjkajočih orodij';

  @override
  String get finderSelectedTools => 'Izbrana orodja';

  @override
  String get finderReadyToMake => 'Pripravljen za izdelavo';

  @override
  String get finderAlmostReadyToMake => 'Skoraj pripravljeno za izdelavo';

  @override
  String get finderSettings => 'Nastavitve';

  @override
  String get finderLoadingRecipes => 'Nalagam recepte';

  @override
  String get finderClearSelection => 'Počisti izbor';

  @override
  String get finderOfflineHint =>
      'Ni povezave s strežnikom – rezultati izvirajo iz receptov, shranjenih v tej napravi.';

  @override
  String addIngredientsSkippedOnHand(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Dodano na nakupovalni seznam – $count sestavin na zalogi je bilo izpuščenih.',
      few:
          'Dodano na nakupovalni seznam – $count sestavine na zalogi so bile izpuščene.',
      two:
          'Dodano na nakupovalni seznam – $count sestavini na zalogi sta bili izpuščeni.',
      one:
          'Dodano na nakupovalni seznam – 1 sestavina na zalogi je bila izpuščena.',
    );
    return '$_temp0';
  }

  @override
  String get sendPeerOfflineHint =>
      'Trenutno ni dosegljivo – prispe, ko se tam odpre aplikacija';

  @override
  String sendDeliveredLater(String device) {
    return '»$device« trenutno ni dosegljivo. Recept bo prispel, ko se tam odpre aplikacija.';
  }

  @override
  String get sendQueuedOffline =>
      'Trenutno ni povezave. Recept bo samodejno poslan, ko boš spet na spletu.';

  @override
  String get searchHasAll => 'Ima vse';

  @override
  String get searchHasAny => 'Ima enega izmed';

  @override
  String get recipeFilterTitle => 'Filter';

  @override
  String get finderOtherFilters => 'Drugi filtri';

  @override
  String get qfOpEquals => 'je enako';

  @override
  String get qfOpNotEquals => 'ni enako';

  @override
  String get qfOpGreater => 'je več kot';

  @override
  String get qfOpGreaterEq => 'je več kot ali enako kot';

  @override
  String get qfOpLess => 'je manj kot';

  @override
  String get qfOpLessEq => 'je manj kot ali enako kot';

  @override
  String get qfOpNewerThan => 'je novejše od';

  @override
  String get qfOpOlderThan => 'je starejše od';

  @override
  String qfDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'pred $count dnevi',
      few: 'pred $count dnevi',
      two: 'pred $count dnevoma',
      one: 'pred $count dnem',
    );
    return '$_temp0';
  }

  @override
  String get filterResetAll => 'Ponastavi vse filtre';

  @override
  String get filterAny => 'Vse';

  @override
  String get filterOfflineIgnored =>
      'Brez povezave je mogoče »Druge filtre« uporabiti le v preprosti obliki.';

  @override
  String linkedRecipesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count povezanih receptov',
      few: '$count povezani recepti',
      two: '$count povezana recepta',
      one: '$count povezan recept',
      zero: 'Ni povezanih receptov',
    );
    return '$_temp0';
  }

  @override
  String get shoppingReminderNotificationsOff =>
      'Obvestila za Mealie Recipes so izklopljena — brez njih se opomnik za nakupovanje ne more prikazati. Dovoli jih v nastavitvah.';

  @override
  String get shoppingReminderInactiveHint =>
      'Opomnik za nakupovanje trenutno ne more delovati: dostop do lokacije nastavi na »Vedno« in dovoli obvestila.';

  @override
  String get bulkImportTitle => 'Masovno uvozi preko URLja';

  @override
  String get bulkImportDescription =>
      'Masovni uvoz receptov ti omogoča uvoz večih receptov hkrati z uvrščanjem spletnih strani v čakalno vrsto in izvajanjem nalog v ozadju. To je dobrodošlo ob začetni migraciji na Mealie ali ko želiš uvoziti večjo količino receptov.';

  @override
  String get bulkAddTitle => 'Množično dodajanje';

  @override
  String get bulkImportSetOrganizers => 'Nastavi kategorije in značke';

  @override
  String get bulkImportStarted => 'Masovni uvoz se je pričel';

  @override
  String get bulkImportFailed => 'Masovni uvoz ni uspel';

  @override
  String get bulkImportReports => 'Masovni uvoz';

  @override
  String get bulkImportUrlHint => 'URL recepta';

  @override
  String get migrationsTitle => 'Migracije podatkov';

  @override
  String get migrationsDescription =>
      'Recepte je mogoče prenesti v Mealie iz druge podprte aplikacije. To je odličen način za začetek uporabe programa Mealie. Za prenos podatkov med različnimi namestitvami programa Mealie ali za obnovitev prejšnje varnostne kopije pa se namesto tega uporabljajo orodja za varnostno kopiranje in obnovitev.';

  @override
  String get migrationNew => 'Nova migracija';

  @override
  String get migrationChooseType => 'Izberi tip migracije';

  @override
  String get noFileSelected => 'Nobena datoteka ni izbrana';

  @override
  String migrationTagAll(String tag) {
    return 'Označi vse recepte z $tag značko';
  }

  @override
  String get migrationPrevious => 'Prejšnje migracije';

  @override
  String get migrationMealieDescription =>
      'Mealie lahko uvozi recepte iz različice aplikacije Mealie, starejše od v1.0. Izvozite recepte iz svoje stare instance in naložite spodnjo datoteko ZIP. Upoštevajte, da je iz izvožene datoteke mogoče uvoziti le recepte. To velja samo za instance, starejše od različice v1.0. Varnostne kopije, ustvarjene v različici v1.0 ali novejši, je treba obnoviti z ustreznimi orodji za varnostno kopiranje in obnovitev.';

  @override
  String get migrationChowdownDescription =>
      'Mealie podpira chowdown format shrambe podatkov. Prenesi shrambo podatkov kot .zip datoteko in jo naloži spodaj.';

  @override
  String get migrationCopyMeThatDescription =>
      'Mealie lahko uvozi recepte iz aplikacije Copy Me That. Izvozi recepte v HTML format in spodaj naloži .zip datoteko.';

  @override
  String get migrationMyRecipeBoxDescription =>
      'Mealie lahko uvozi recepte iz aplikacije My Recipe Box. Izvozi recepte v CSV formatu, nato pa .csv datoteko naloži spodaj.';

  @override
  String get migrationNextcloudDescription =>
      'Nextcloud recepte lahko uvoziš z zip datoteko, ki vsebuje podatke shranjene na Nextcloudu. Poglej primer strukture mape spodaj, da zagotoviš primerno strukturo za uvoz receptov.';

  @override
  String get migrationPaprikaDescription =>
      'Mealie lahko uvozi recepte iz aplikacije Paprika. Izvozi recepte iz aplikacije Paprika, preimenuj končnico datoteke v .zip in jo naloži spodaj.';

  @override
  String get migrationPlanToEatDescription =>
      'Mealie lahko uvozi recepte iz aplikacije Plan to Eat. Naložite ZIP arhiv, CSV ali TXT datoteko, izvoženo iz Plan to Eat.';

  @override
  String get migrationRecipeKeeperDescription =>
      'Mealie lahko uvozi recepte iz Recipe Keeper. Izvozi svoje recepte v .zip formatu, nato spodaj naloži .zip datoteko.';

  @override
  String get migrationTandoorDescription =>
      'Mealie lahko uvozi recepte iz aplikacije Tandoor. Izvozi podatke v \"Default\" formatu, nato spodaj naloži .zip datoteko.';

  @override
  String get migrationCooknDescription =>
      'Mealie lahko uvozi recepte iz DVO Cook\'n X3. Izvozite kuharsko knjigo ali jedilnik v formatu »Cook\'n«, preimenujte izvozno končnico v .zip in nato naložite spodnjo datoteko .zip.';

  @override
  String get reportTitle => 'Prijavi';

  @override
  String get recipeDataTitle => 'Podatki o receptu';

  @override
  String get recipeDataDescription =>
      'Uporabi to sekcijo za urejanje podatkov povezanih s svojimi recepti. Na voljo so ti masovne akcije vključno z izvozom, brisanjem, označevanjem in kategorizacijo receptov.';

  @override
  String get recipeDataTagTitle => 'Označi recepte';

  @override
  String get recipeDataCategorizeTitle => 'Kategoriziraj recepte';

  @override
  String get recipeDataSettingsTitle => 'Posodobi nastavitve';

  @override
  String get recipeDataExportTitle => 'Izvozi recepte';

  @override
  String get recipeDataDeleteTitle => 'Izbriši recepte';

  @override
  String recipeDataExportConfirm(int count) {
    return 'Sledeči recepti ($count) bodo izvoženi.';
  }

  @override
  String get recipeDataExportsTitle => 'Izvozi podatkov';

  @override
  String get recipeDataExportsDescription =>
      'Ta odsek nudi povezave do vseh izvozov, ki so pripravljeni na prenos. Izvozi po določenem času potečejo, tako da jih prenesi dokler so še na voljo.';

  @override
  String get recipeDataPurgeExports => 'Počisti izvoze';

  @override
  String get recipeDataPurgeConfirm =>
      'Zagotovo želiš izbrisati vse izvoze podatkov?';

  @override
  String get recipeActionsTitle => 'Opravila na receptu';

  @override
  String get recipeActionNew => 'Novo opravilo na receptu';

  @override
  String get recipeActionEdit => 'Urejaj opravilo na receptu';

  @override
  String get recipeActionTypeLink => 'Povezava';

  @override
  String get recipeActionTypePost => 'Objava';

  @override
  String get webhooksTitle => 'Webbhook-i';

  @override
  String get webhooksDescription =>
      'Spodaj definirani webhooki bodo izvedeni na dneve, ki imajo definirane obroke. Ob določenem času bodo na webhook poslani podatki iz recepta, ki je planiran na ta dan. Upoštevaj, da izvedba webhookov ni točna. Webhooki se izvajajo v 5 minutnih intervalih, kar pomeni, da bo webhook izveden v okviru +/- 5 minut od planiranega časa.';

  @override
  String get webhookName => 'Ime Webhooka';

  @override
  String get webhookUrl => 'URL spletnega kavlja';

  @override
  String get notifiersTitle => 'Obveščevalci';

  @override
  String get notifiersDescription =>
      'Setup email and push notifications that trigger on specific events.';

  @override
  String get notifierNew => 'Novo obvestilo';

  @override
  String get notifierDescription =>
      'Mealie uporablja Apprise knjižnico za kreiranje obvestil. Omogoča več različnih servisov za uporabo obvestil. Preglejte njihovo wiki stran, za bolj natančen vodič, kako izdelati URL za vaš servis. Če je na voljo, so za vaš izbran servis obvestil, na voljo tudi dodane možnosti.';

  @override
  String get notifierAppriseUrl => 'Apprise URL';

  @override
  String get notifierAppriseUrlSkipped =>
      'Apprise URL (preskočeno, če je prazno)';

  @override
  String get notifierAppriseUrlBlankHint =>
      'Ker URL-ji Apprise običajno vsebujejo občutljive podatke, je to polje med urejanjem namerno prazno. Če želite posodobiti URL, vnesite novega tukaj, sicer pustite prazno, da ohranite trenutni URL.';

  @override
  String get notifierEnable => 'Vključi obvestila';

  @override
  String get notifierWhatEvents =>
      'Katere dogodke naj spremlja obveščevalni sistem?';

  @override
  String get notifierRecipeEvents => 'Dogodki receptov';

  @override
  String get notifierUserEvents => 'Dogodki uporabnika';

  @override
  String get notifierMealplanEvents => 'Dogodki načrta obrokov';

  @override
  String get notifierShoppingListEvents => 'Dogodki nakupovalnega seznama';

  @override
  String get notifierCookbookEvents => 'Dogodki kuharske knjige';

  @override
  String get notifierTagEvents => 'Dogodki značk';

  @override
  String get notifierCategoryEvents => 'Dogodki kategorij';

  @override
  String get notifierLabelEvents => 'Dogodki oznak';

  @override
  String get notifierUserSignup =>
      'Ko se novi uporabnik pridruži tvoji skupini';

  @override
  String get notifierCreate => 'Ustvari';

  @override
  String get notifierUpdate => 'Posodobi';

  @override
  String get notifierDelete => 'Izbriši';

  @override
  String get notifierTestSent => 'Testno sporočilo je bilo poslano';

  @override
  String get adminTitle => 'Administratorske nastavitve';

  @override
  String get backupsTitle => 'Varnostne kopije';

  @override
  String get backupsDescription =>
      'Varnostne kopije so popolni posnetki podatkovne zbirke in podatkovne mape. To vključuje vse podatke in ni mogoče izključiti posameznih sklopov podatkov. Varnostno kopijo si lahko predstavljaš kot posnetek Mealie aplikacije v danem trenutku. To služi kot možnost za shranjevanje varnostne kopije na drugo lokacijo ali kot način za izvoz in uvoz podatkov, ki ni odvisen od tipa podatkovne baze.';

  @override
  String get backupCreateHeading => 'Izdelaj varnostno kopijo';

  @override
  String get backupCreated => 'Varnostna kopija uspešno ustvarjena';

  @override
  String get backupCreateFailed =>
      'Napaka pri izdelovanju varnostni kopije. Preveri strežniške datoteke';

  @override
  String get backupDelete => 'Izbriši varnostno kopijo';

  @override
  String get backupDeleted => 'Varnostna kopija je izbrisana';

  @override
  String get backupRestore => 'Obnovi varnostno kopijo';

  @override
  String get backupRestoreDescription =>
      'Obnavljanje varnostne kopije bo prepisalo trenutne podatke v podatkovni zbirki in v podatkovni mapi in jih zamenjalo s podatki v tej varnostni kopiji. Če je obnavljanje varnostne kopije uspešno, te bo sistem na koncu izpisal iz tvojega uporabniškega računa.';

  @override
  String get backupCannotBeUndone =>
      'Te akcije ni mogoče razveljaviti - uporabljaj previdno.';

  @override
  String get backupAcknowledge =>
      'Razumem, da tega ukaza ni mogoče razveljaviti in da lahko povzroči izgubo podatkov';

  @override
  String get backupRestoreSuccess => 'Obnovitev uspešna';

  @override
  String get backupRestoreFailed =>
      'Obnovitev ni uspela. Za več podrobnosti preverite dnevnike strežnika';

  @override
  String get maintenanceTitle => 'Vzdrževanje';

  @override
  String get maintenanceSummary => 'Povzetek';

  @override
  String get maintenanceStorage => 'Podrobni pregled';

  @override
  String get maintenanceDataDirSize => 'Velikosti mape s podatki';

  @override
  String get maintenanceCleanableDirs => 'Odvečne mape';

  @override
  String get maintenanceCleanableImages => 'Odvečne slike';

  @override
  String get maintenanceTempDir => 'Začasna mapa (.temp)';

  @override
  String get maintenanceBackupsDir => 'Mapa z varnostnimi kopijami (backups)';

  @override
  String get maintenanceGroupsDir => 'Mapa s skupinami (groups)';

  @override
  String get maintenanceRecipesDir => 'Mapa z recepti (recipes)';

  @override
  String get maintenanceUserDir => 'Uporabniška mapa (user)';

  @override
  String get maintenanceCleanDirs => 'Počisti mape';

  @override
  String get maintenanceCleanDirsDescription =>
      'Izbriše vse mape z recepti, ki niso veljavni UUID';

  @override
  String get maintenanceCleanTemp => 'Počisti začasne datoteke';

  @override
  String get maintenanceCleanTempDescription =>
      'Počisti vse mape in datoteke v .temp mapi';

  @override
  String get maintenanceCleanImages => 'Počisti slike';

  @override
  String get maintenanceCleanImagesDescription =>
      'Odstrani vse slike, ki nimajo končnice .webp';

  @override
  String get maintenanceActions => 'Opravila';

  @override
  String get adminConfiguration => 'Nastavitve';

  @override
  String get adminAppVersion => 'Verzija aplikacije';

  @override
  String get adminUpToDate => 'Mealie je v najnovejši različici';

  @override
  String adminVersionOutdated(String current, String latest) {
    return 'Tvoja trenutna verzija ($current) se ne ujema z najnovejšo verzijo. Priporočamo nadgradnjo na najnovejšo verzijo ($latest).';
  }

  @override
  String get adminBaseUrl => 'Strežniški URL';

  @override
  String get adminBaseUrlOk =>
      'Strežniški URL se ne ujema s privzeto vrednostjo';

  @override
  String get adminBaseUrlError =>
      '`BASE_URL` se še vedno ujema s privzeto vrednostjo API strežnika. To bo povzročalo težave s povezavami do obvestil generiranih za emaile ipd.';

  @override
  String adminAuthReady(String provider) {
    return '$provider Pripravljen';
  }

  @override
  String adminAuthNotReady(String provider) {
    return '$provider Ni pripravljen';
  }

  @override
  String adminAuthDisabled(String provider) {
    return '$provider Onemogočen';
  }

  @override
  String adminAuthSuccessText(String provider) {
    return 'Zahtevane spremenljivke $provider so nastavljene.';
  }

  @override
  String adminAuthErrorText(String provider) {
    return 'Vse vrednosti $provider niso konfigurirane. To lahko prezrete, če ne uporabljate preverjanja pristnosti $provider.';
  }

  @override
  String adminAuthDisabledText(String envVar) {
    return 'Če želite omogočiti, nastavite $envVar na true.';
  }

  @override
  String get adminEmailStatus => 'Email status';

  @override
  String get adminEmailConfigured => 'Email nastavljen';

  @override
  String get adminNotReady =>
      'Ni pripravljeno - Preverite okoljske spremenljivke';

  @override
  String get adminSucceeded => 'Uspelo je';

  @override
  String get adminFailed => 'Ni uspelo';

  @override
  String get adminSiteStatistics => 'Statistika spletnega mesta';

  @override
  String get adminUncategorized => 'Nekategorizirani recepti';

  @override
  String get adminUntagged => 'Neoznačeni recepti';

  @override
  String get adminGeneralAbout => 'Splošne informacije';

  @override
  String get adminVersion => 'Verzija';

  @override
  String get adminBuild => 'Gradnja';

  @override
  String get adminApplicationMode => 'Način aplikacije';

  @override
  String get adminProduction => 'Produkcija';

  @override
  String get adminDevelopment => 'Razvoj';

  @override
  String get adminDemoStatus => 'Status testa';

  @override
  String get adminDemo => 'Testno';

  @override
  String get adminNotDemo => 'Ni testno';

  @override
  String get adminApiPort => 'API vrata';

  @override
  String get adminApiDocs => 'API dokumentacija';

  @override
  String get adminDatabaseType => 'Tip podatkovne baze';

  @override
  String get adminDatabaseUrl => 'URL naslov podatkovne baze';

  @override
  String get adminDefaultGroup => 'Privzeta skupina';

  @override
  String get adminDefaultHousehold => 'Privzeto gospodinjstvo';

  @override
  String get adminScraperVersion => 'Verzija strgalnika receptov';

  @override
  String get adminStatUsers => 'Uporabniki';

  @override
  String get adminStatHouseholds => 'Gospodinjstva';

  @override
  String get adminStatGroups => 'Skupine';

  @override
  String get recipeDuplicate => 'Podvoji recept';

  @override
  String get recipeDuplicateAction => 'Podvoji';

  @override
  String get recipeShareLink => 'Deli recept';

  @override
  String get recipeShareExpiration => 'Poteče';

  @override
  String get recipeShareCopied => 'Povezava recepta je kopirana v odložišče';

  @override
  String get enabledLabel => 'Omogočeno';

  @override
  String get disabledLabel => 'Onemogočeno';

  @override
  String get testAction => 'Test';

  @override
  String get yesLabel => 'Da';

  @override
  String get noLabel => 'Ne';

  @override
  String get downloadAction => 'Prenesi';

  @override
  String get backupUpload => 'Naloži';

  @override
  String get zipImportButton => 'Uvozi z Zip';

  @override
  String get zipImportDescription =>
      'Uvozi posamezen recept, ki je bil izvožen iz druge instance Mealie aplikacije.';

  @override
  String get reportStatus => 'Stanje';

  @override
  String get reportDate => 'Datum';

  @override
  String get recipeActionTitleLabel => 'Naslov';

  @override
  String get clearAll => 'Počisti';

  @override
  String get recipeDataSettingsExplanation =>
      'Te nastavitve, z izjemo možnosti zaklepanja, bodo uporabljene na vseh izbranih receptih.';

  @override
  String get adminAllowSignup => 'Dovoli registracijo';

  @override
  String get adminAllowPasswordLogin => 'Dovoli prijavo z geslom';

  @override
  String get adminEmailInvalid => 'Vnesi veljaven e-poštni naslov.';

  @override
  String adminEmailTestResult(String result) {
    return 'Preizkus e-pošte: $result';
  }

  @override
  String get adminSendTestEmail => 'Pošlji preizkusno e-pošto';

  @override
  String get adminTestEmailAddress => 'Prejemnik';

  @override
  String get backupCreate => 'Ustvari varnostno kopijo';

  @override
  String backupDeleteConfirm(String name) {
    return 'Izbrišem varnostno kopijo »$name«?';
  }

  @override
  String get backupPostgresNote =>
      'Če uporabljaš PostgreSQL, pred obnovitvijo preberi postopek varnostnega kopiranja/obnove v dokumentaciji Mealie.';

  @override
  String get backupUploaded => 'Varnostna kopija naložena';

  @override
  String get backupsEmpty => 'Še ni varnostnih kopij.';

  @override
  String get bulkImportAddRow => 'Dodaj URL';

  @override
  String get bulkImportStart => 'Začni uvoz';

  @override
  String get chooseFileButton => 'Izberi datoteko';

  @override
  String get deselectAllAction => 'Počisti izbor';

  @override
  String get downloadFailed => 'Prenos ni uspel';

  @override
  String get fileSaved => 'Datoteka shranjena';

  @override
  String get loadFailed => 'Nalaganje ni uspelo';

  @override
  String get maintenanceActionsWarning =>
      'Vzdrževalna dejanja so uničujoča in jih uporabljaj previdno. Nobenega ni mogoče razveljaviti.';

  @override
  String get maintenanceConfirm =>
      'To dejanje je uničujoče in ga ni mogoče razveljaviti. Nadaljujem?';

  @override
  String get maintenanceDone => 'Končano';

  @override
  String get maintenanceFailed => 'Vzdrževalno dejanje ni uspelo';

  @override
  String get maintenanceRun => 'Zaženi';

  @override
  String get migrationFailed => 'Selitev ni uspela';

  @override
  String get migrationStart => 'Začni selitev';

  @override
  String get migrationStarted => 'Selitev končana – poglej poročilo spodaj.';

  @override
  String get moreImportOptions => 'Več možnosti uvoza';

  @override
  String notifierDeleteConfirm(String name) {
    return 'Izbrišem obvestilo »$name«?';
  }

  @override
  String get notifierEdit => 'Uredi obvestilo';

  @override
  String notifierEventCount(int count) {
    return 'Dogodki: $count';
  }

  @override
  String get notifierTestFailed =>
      'Preizkusnega sporočila ni bilo mogoče poslati';

  @override
  String get notifiersEmpty => 'Še ni obvestil.';

  @override
  String recipeActionDeleteConfirm(String name) {
    return 'Izbrišem dejanje recepta »$name«?';
  }

  @override
  String get recipeActionFailed => 'Dejanje recepta ni uspelo';

  @override
  String get recipeActionSent => 'Recept poslan';

  @override
  String get recipeActionUrlHint => 'Nadomestne oznake';

  @override
  String get recipeActionsDescription =>
      'Dejanja recepta so v meniju vsakega recepta. »Povezava« odpre URL, »Objavi« pa naroči strežniku Mealie, naj recept pošlje na URL.';

  @override
  String get recipeActionsEmpty => 'Še ni dejanj recepta.';

  @override
  String recipeDataDeleteConfirm(int count) {
    return 'Izbrišem izbrane recepte ($count)? Tega ni mogoče razveljaviti.';
  }

  @override
  String recipeDataDeleteForbidden(int count) {
    return 'Izbranih receptov ne smeš izbrisati: $count (samo avtor ali skrbnik).';
  }

  @override
  String recipeDataDeleted(int count) {
    return 'Izbrisani recepti: $count';
  }

  @override
  String get recipeDataExportAction => 'Izvozi';

  @override
  String get recipeDataExportDone =>
      'Izvoz ustvarjen – prenesi ga pod Izvozi podatkov.';

  @override
  String recipeDataExportExpires(String date) {
    return 'poteče $date';
  }

  @override
  String get recipeDataExportFailed => 'Izvoz ni uspel';

  @override
  String get recipeDataExportsEmpty => 'Ni razpoložljivih izvozov.';

  @override
  String recipeDataUpdated(int count) {
    return 'Posodobljeni recepti: $count';
  }

  @override
  String get recipeDuplicated => 'Recept podvojen';

  @override
  String get recipeExportJson => 'Izvozi kot JSON';

  @override
  String get recipeExportZip => 'Izvozi kot ZIP (s sliko)';

  @override
  String get recipeShareCreate => 'Ustvari povezavo';

  @override
  String get recipeShareDescription =>
      'Kdor ima povezavo, si lahko ogleda ta recept v brskalniku – brez računa – dokler ne poteče.';

  @override
  String get recipeShareEmpty => 'Še ni povezav za deljenje.';

  @override
  String recipeShareExpiresAt(String date) {
    return 'Poteče $date';
  }

  @override
  String get recipeWebToolsMenu => 'Podvoji, povezava za deljenje in več';

  @override
  String get reload => 'Znova naloži';

  @override
  String get reportDeleteConfirm => 'Izbrišem to poročilo?';

  @override
  String get reportEntries => 'Vnosi';

  @override
  String get reportFailedEntries => 'Neuspešni';

  @override
  String get reportOnlyFailed => 'Prikaži samo neuspešne vnose';

  @override
  String get reportStatusFailure => 'Neuspeh';

  @override
  String get reportStatusInProgress => 'V teku';

  @override
  String get reportStatusPartial => 'Delno';

  @override
  String get reportStatusSuccess => 'Uspešno';

  @override
  String get reportsEmpty => 'Še ni poročil.';

  @override
  String get uploadFailed => 'Nalaganje ni uspelo';

  @override
  String webhookDeleteConfirm(String name) {
    return 'Izbrišem webhook »$name«?';
  }

  @override
  String get webhookEdit => 'Uredi webhook';

  @override
  String get webhookNew => 'Nov webhook';

  @override
  String get webhookTestFailed => 'Preizkusa ni bilo mogoče zagnati';

  @override
  String get webhookTestSent => 'Preizkusni webhook sprožen';

  @override
  String get webhookTime => 'Čas (lokalni)';

  @override
  String get webhooksEmpty => 'Še ni webhookov.';

  @override
  String get zipImportFailed => 'Uvoz ZIP ni uspel';

  @override
  String get aiProvidersTitle => 'Ponudniki umetne inteligence';

  @override
  String get aiProvidersDescription =>
      'Konfigurirajte ponudnike umetne inteligence, da omogočite funkcije, ki jih poganja umetna inteligenca, kot so izboljšano razčlenjevanje sestavin, ustvarjanje receptov iz videoposnetkov in še več!';

  @override
  String get aiProviderSettingsTitle =>
      'Nastavitve ponudnika umetne inteligence';

  @override
  String get aiProvidersList => 'Ponudniki';

  @override
  String get aiProviderCreate => 'Ustvari ponudnika';

  @override
  String get aiProviderEdit => 'Uredi ponudnika';

  @override
  String get aiDefaultProvider => 'Privzeti ponudnik';

  @override
  String get aiDefaultProviderDescription =>
      'Potrebno za omogočanje funkcij umetne inteligence';

  @override
  String get aiAudioProvider => 'Ponudnik zvoka';

  @override
  String get aiAudioProviderDescription =>
      'Omogoča funkcije prepisovanja zvoka, kot je ustvarjanje receptov iz videoposnetkov';

  @override
  String get aiImageProvider => 'Ponudnik slik';

  @override
  String get aiImageProviderDescription =>
      'Omogoča funkcije prepoznavanja slik, kot je ustvarjanje receptov iz slik';

  @override
  String get aiProviderName => 'Ime ponudnika';

  @override
  String get aiApiKey => 'API Ključ';

  @override
  String get aiApiKeyCreateDescription =>
      'Ključ API vašega ponudnika za preverjanje pristnosti. Če vaša storitev (npr. Ollama) ne uporablja ključa API, morate vseeno nekaj vnesti tukaj.';

  @override
  String get aiApiKeyEditDescription =>
      'Pustite to prazno, razen če želite to spremeniti.';

  @override
  String get aiBaseUrl => 'Osnovni URL';

  @override
  String get aiBaseUrlDescription =>
      'Če uporabljate OpenAI, pustite to polje prazno. Mora biti končna točka, združljiva z OpenAI (npr. \"http://localhost:11434/v1\").';

  @override
  String get aiModel => 'Model';

  @override
  String get aiModelDescription =>
      'Kateri model naj uporablja vaš ponudnik umetne inteligence (npr. \"gpt-5\").';

  @override
  String get aiTimeout => 'Časovna omejitev zahteve (sekunde)';

  @override
  String get aiProviderCreated => 'Ponudnik ustvarjen';

  @override
  String get aiProviderUpdated => 'Ponudnik posodobljen';

  @override
  String get aiProviderDeleted => 'Ponudnik izbrisan';

  @override
  String get aiProviderCreateFailed => 'Ustvarjanje ponudnika ni uspelo';

  @override
  String get aiProviderUpdateFailed => 'Ponudnika ni bilo mogoče posodobiti';

  @override
  String get aiProviderDeleteFailed => 'Brisanje ponudnika ni uspelo';

  @override
  String get aiRequestHeaders => 'Glave zahtev';

  @override
  String get aiRequestParams => 'Parametri zahteve';

  @override
  String get aiNoDefaultWarning =>
      'Niste nastavili privzetega ponudnika, zato so funkcije umetne inteligence onemogočene';

  @override
  String get aiTestConnection => 'Preizkusi povezavo';

  @override
  String get aiTestSucceeded => 'Povezava uspešna';

  @override
  String get aiTestFailed => 'Povezava ni uspela';

  @override
  String get aiSupportsImages => 'Podpira slike';

  @override
  String get aiTextOnly => 'Samo besedilo – ne more biti tvoj ponudnik slik';

  @override
  String get debugAiTitle => 'Razhroščevanje ponudnikov UI';

  @override
  String get debugAiDescription =>
      'Na tej strani razhroščuješ ponudnike UI. Preizkusi povezavo in si oglej rezultate. Če so slikovne storitve vklopljene, lahko dodaš tudi sliko.';

  @override
  String get debugParserTitle => 'Razčlenjevalnik';

  @override
  String get debugParserDescription =>
      'Mealie uporablja Conditional Random Fields (CRFs) za razčlenjevanje in procesiranje sestavin. Ta model je osnovan na podatkih čez 100000 sestavin iz zbirke podatkov New York Times. Upoštevaj, da je model treniran na angleškem besedilu, zato lahko v drugih jezikih pričakuješ slabše rezultate. Ta stran služi igranju z omenjenim modelom.';

  @override
  String get debugIngredientText => 'Besedilo s sestavino';

  @override
  String get debugTryExample => 'Poskusi na primeru';

  @override
  String debugAverageConfidence(String value) {
    return '$value zanesljivost';
  }

  @override
  String get debugRunTest => 'Zaženi test';

  @override
  String get debugQuantity => 'Količina';

  @override
  String get debugUnit => 'Enota';

  @override
  String get debugFood => 'Živilo';

  @override
  String get debugNote => 'Komentar';

  @override
  String get debugGroup => 'Skupina';

  @override
  String get aiProviderNone => 'Brez';

  @override
  String aiProviderDeleteConfirm(String name) {
    return 'Izbrišem ponudnika »$name«?';
  }

  @override
  String get aiProvidersEmpty => 'Še ni ponudnikov UI.';

  @override
  String get aiAdvanced => 'Napredno';

  @override
  String get aiKeyLabel => 'Ime';

  @override
  String get aiValueLabel => 'Vrednost';

  @override
  String get debugTitle => 'Razhroščevanje';

  @override
  String get debugParse => 'Razčleni';

  @override
  String get debugParseFailed => 'Sestavine ni bilo mogoče razčleniti';

  @override
  String get debugChooseImage => 'Izberi sliko';

  @override
  String get debugNoImage => 'Brez slike (neobvezno)';

  @override
  String get updateTitle => 'Preveri posodobitve';

  @override
  String get updateInstalledVersion => 'Nameščena različica';

  @override
  String get updateLastCheck => 'Nazadnje preverjeno';

  @override
  String get updateCheckNow => 'Preveri zdaj';

  @override
  String get updateChecking => 'Iskanje posodobitev …';

  @override
  String get updateUpToDate => 'Mealie Recipes je posodobljen.';

  @override
  String updateAvailable(String version) {
    return 'Na voljo je različica $version';
  }

  @override
  String get updateAvailableDescription =>
      'Na voljo je nova različica Mealie Recipes. Nič se ne namesti, dokler posodobitve ne zaženeš sam.';

  @override
  String get updateShow => 'Prikaži posodobitev';

  @override
  String get updateLater => 'Pozneje';

  @override
  String updateDownloading(int percent) {
    return 'Prenašanje … $percent %';
  }

  @override
  String updateReady(String version) {
    return 'Različica $version je pripravljena za namestitev';
  }

  @override
  String get updateInstalling =>
      'Nameščanje – aplikacija se bo kmalu znova zagnala …';

  @override
  String get updateManual =>
      'Posodobitve ni bilo mogoče samodejno namestiti. Slika diska je odprta: povleci Mealie Recipes v Programe.';

  @override
  String get updateFailed => 'Posodobitev ni uspela';

  @override
  String get updateInstallNow => 'Prenesi in namesti';

  @override
  String get updateRestartNow => 'Namesti in znova zaženi';

  @override
  String get updateAutoTitle => 'Ob zagonu preveri posodobitve';

  @override
  String get updateAutoDescription =>
      'Samo preveri in obvesti – namestitev vedno zaženeš sam.';

  @override
  String get updateNoNotes => 'Ni opomb ob izdaji.';

  @override
  String get updateSourceHint =>
      'Posodobitve prihajajo iz izdaj Mealie Recipes na GitHubu in se namestijo le, če jih je podpisal razvijalec (macOS).';
}
