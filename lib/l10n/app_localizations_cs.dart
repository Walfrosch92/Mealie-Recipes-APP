// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class AppLocalizationsCs extends AppLocalizations {
  AppLocalizationsCs([String locale = 'cs']) : super(locale);

  @override
  String get endCookingMode => 'Ukončit režim vaření';

  @override
  String get endCookingModeConfirm => 'Opravdu chcete ukončit režim vaření?';

  @override
  String endCookingModeConfirmAll(int count) {
    return 'Ukončí se všechny recepty v režimu vaření ($count). Pokračovat?';
  }

  @override
  String get addTimer => 'Přidat časovač';

  @override
  String get recipeFinished => 'Vaše jídlo je hotové.';

  @override
  String get bonAppetit => 'Dobrou chuť!';

  @override
  String get prepareIngredients => 'Připravte si následující ingredience';

  @override
  String prepareIngredientsFor(String servings) {
    return 'Připravte si následující ingredience pro $servings porcí';
  }

  @override
  String get next => 'Další';

  @override
  String get navHome => 'Domů';

  @override
  String get homeCookToday => 'Dnes vaříme';

  @override
  String get homeSuggestion => 'Návrh';

  @override
  String get homeQuickAccess => 'Rychlý přístup';

  @override
  String get homePlanned => 'Naplánováno';

  @override
  String get favorite => 'Oblíbené';

  @override
  String get navSettings => 'Nastavení';

  @override
  String homeWelcomeName(Object name) {
    return 'Vítejte, $name,';
  }

  @override
  String get homeWelcomeApp => 'v Mealie Recipes 👋';

  @override
  String get theme => 'Vzhled';

  @override
  String get themeSystem => 'Systém';

  @override
  String get themeLight => 'Světlý';

  @override
  String get themeDark => 'Tmavý';

  @override
  String get recipes => 'Recepty';

  @override
  String get shoppingList => '🛒 Nákupní seznam';

  @override
  String get mealplan => 'Jídelníček';

  @override
  String get settings => '⚙️ Nastavení';

  @override
  String get searchRecipe => 'Hledat recept...';

  @override
  String get loadingRecipe => 'Načítám recept...';

  @override
  String get errorLoadingRecipe => 'Recept se nepodařilo načíst.';

  @override
  String get noRecipesForCategory => 'Pro tento filtr nejsou žádné recepty.';

  @override
  String get resetFilter => 'Zrušit filtr';

  @override
  String get allCategories => 'Všechny kategorie';

  @override
  String get all => 'Vše';

  @override
  String get sortRecipes => 'Seřadit recepty';

  @override
  String get refreshRecipes => 'Obnovit';

  @override
  String get sortNameAZ => 'Název A–Z';

  @override
  String get sortNameZA => 'Název Z–A';

  @override
  String get sortDateNewest => 'Nejnovější první';

  @override
  String get sortDateOldest => 'Nejstarší první';

  @override
  String get sortPrepTimeShort => 'Nejkratší příprava';

  @override
  String get sortPrepTimeLong => 'Nejdelší příprava';

  @override
  String get sortRatingHighest => 'Nejvyšší hodnocení';

  @override
  String get sortRatingLowest => 'Nejnižší hodnocení';

  @override
  String get details => 'Podrobnosti';

  @override
  String get ingredients => 'Ingredience';

  @override
  String get instructions => 'Postup';

  @override
  String get tags => 'Štítky';

  @override
  String get notes => 'Poznámky';

  @override
  String get addNote => 'Přidat poznámku';

  @override
  String get editNote => 'Upravit poznámku';

  @override
  String get noteTitleHint => 'Název (volitelné)';

  @override
  String get noteTextHint => 'Text poznámky';

  @override
  String get deleteNoteTitle => 'Smazat poznámku?';

  @override
  String get deleteNoteMessage => 'Tato poznámka bude trvale smazána.';

  @override
  String get servings => 'Porce';

  @override
  String get planMeal => 'Naplánovat jídlo';

  @override
  String get addAllIngredients => 'Přidat všechny ingredience';

  @override
  String get addSelectedIngredients => 'Přidat vybrané ingredience';

  @override
  String get addIngredientsMessage =>
      'Ingredience byly přidány do nákupního seznamu.';

  @override
  String addIngredientsFailedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ingredience, které se nepodařilo přidat: $count.',
      one: '1 ingredienci se nepodařilo přidat.',
    );
    return '$_temp0';
  }

  @override
  String get cookbooks => 'Kuchařky';

  @override
  String get cookbooksEmpty =>
      'Zatím žádné kuchařky. Klepněte na „+“ vpravo nahoře a vytvořte ji.';

  @override
  String get cookbookNoMatches => 'Tomuto filtru neodpovídají žádné recepty.';

  @override
  String get cookbookCreateTitle => 'Vytvořit kuchařku';

  @override
  String get cookbookEditTitle => 'Upravit kuchařku';

  @override
  String get cookbookNameLabel => 'Název kuchařky';

  @override
  String get cookbookFilterSectionTitle => 'Přidávat recepty automaticky';

  @override
  String get cookbookFieldTools => 'Nástroje';

  @override
  String get cookbookFieldUsers => 'Uživatelé';

  @override
  String get cookbookOpIsOneOf => 'je jedním z';

  @override
  String get cookbookOpIsNotOneOf => 'není jedním z';

  @override
  String get cookbookOpContainsAll => 'obsahuje vše';

  @override
  String get cookbookSelectValues => 'Vybrat hodnoty';

  @override
  String get cookbookFilterOptionsUnavailable =>
      'Nejsou k dispozici žádné možnosti';

  @override
  String get cookbookAddFilterField => 'Přidat pole';

  @override
  String get cookbookPublicLabel => 'Veřejná kuchařka';

  @override
  String get cookbookPublicSubtitle =>
      'Viditelná pro ostatní domácnosti na serveru';

  @override
  String get cookbookRawModeEnter => 'Upravit jako text';

  @override
  String get cookbookRawModeExit => 'Zpět do sestavovače';

  @override
  String get cookbookRawModeHint =>
      'Expertní režim aplikace: upravuje filtr přímo jako text. Hodí se, když existující filtr nešlo rozložit na jednoduché řádky.';

  @override
  String get cookbookRawModeUnparseable =>
      'Tento text neodpovídá jednoduchému řádkovému formátu — zůstane jako text.';

  @override
  String get saveFailed => 'Uložení se nezdařilo';

  @override
  String get search => 'Hledat';

  @override
  String get apply => 'Použít';

  @override
  String get setupCachingTitle => 'Načítání vašich receptů';

  @override
  String get setupCachingSubtitle =>
      'Vaše recepty se připravují pro použití offline. Podle jejich počtu to může chvíli trvat.';

  @override
  String get setupCachingDone => 'Vše připraveno!';

  @override
  String get setupTipsHeader => 'Věděli jste?';

  @override
  String get setupFinish => 'Jdeme na to';

  @override
  String get setupSkipCaching => 'Pokračovat na pozadí';

  @override
  String get setupTip1 =>
      'Recepty můžete importovat z odkazu, fotky nebo PDF — přes dlaždici Import na úvodní obrazovce.';

  @override
  String get setupTip2 =>
      'Režim vaření nechává obrazovku rozsvícenou, provede vás krok za krokem a sám najde časovače v textu.';

  @override
  String get setupTip3 =>
      'Nákupní seznam funguje i offline — změny se automaticky synchronizují, jakmile je server dostupný.';

  @override
  String get setupTip4 =>
      'Podržením dlaždice na úvodní obrazovce změníte pořadí rychlého přístupu.';

  @override
  String get setupTip5 =>
      'Své kuchařky Mealie najdete v dlaždici Kuchařky — i offline.';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Zrušit';

  @override
  String get delete => 'Smazat';

  @override
  String get edit => 'Upravit';

  @override
  String get save => 'Uložit';

  @override
  String get done => 'Hotovo';

  @override
  String get close => 'Zavřít';

  @override
  String get add => 'Přidat';

  @override
  String get send => 'Odeslat';

  @override
  String get retry => 'Zkusit znovu';

  @override
  String get confirmDeleteTitle => 'Smazat recept?';

  @override
  String get confirmDeleteMessage => 'Tuto akci nelze vrátit zpět.';

  @override
  String get sendToDevice => 'Odeslat do zařízení';

  @override
  String get timerFinished => 'Časovač doběhl!';

  @override
  String get timer => 'Časovač';

  @override
  String get newTimer => 'Nový časovač';

  @override
  String get timerNamePlaceholder => 'Název časovače';

  @override
  String get durationLabel => 'Doba';

  @override
  String get start => 'Spustit';

  @override
  String get stop => 'Zastavit';

  @override
  String get pause => 'Pozastavit';

  @override
  String get resume => 'Pokračovat';

  @override
  String get finished => 'Hotovo!';

  @override
  String stepNumber(int number) {
    return 'Krok $number';
  }

  @override
  String get minAbbreviation => 'min';

  @override
  String get cookingMode => 'Režim vaření';

  @override
  String get endAll => 'Ukončit vše';

  @override
  String get end => 'Ukončit';

  @override
  String get noActiveTimers => 'Žádné aktivní časovače';

  @override
  String get noActiveRecipes => 'Žádné aktivní recepty';

  @override
  String get startRecipeToCook =>
      'Otevřete recept a klepnutím na tlačítko režimu vaření začněte.';

  @override
  String get browseRecipes => 'Procházet recepty';

  @override
  String get cookFriends => 'Vaření s přáteli';

  @override
  String get cookingModeAddRecipe => 'Přidat recept';

  @override
  String get cookingModeAddRecipeSearchHint => 'Hledat recepty';

  @override
  String get cookFriendsCode => 'Kód relace';

  @override
  String get cookFriendsJoin => 'Připojit se k relaci';

  @override
  String get cookFriendsHost => 'Hostit relaci';

  @override
  String get cookFriendsHostNotFound =>
      'Hostitel nenalezen. Ujistěte se, že obě zařízení jsou ve stejné síti Wi-Fi a že je povolen přístup k místní síti.';

  @override
  String get cookFriendsConnectionFailed =>
      'Připojení se nezdařilo. Zkuste to znovu.';

  @override
  String get cookFriendsEnterCode => 'Zadejte kód';

  @override
  String cookFriendsConnected(int count) {
    return 'Připojeno hostů: $count';
  }

  @override
  String get joinSession => 'Připojit se k relaci';

  @override
  String get hostEndedSessionMessage => 'Hostitel ukončil relaci vaření.';

  @override
  String get addItem => 'Přidat položku';

  @override
  String get itemNote => 'Název položky';

  @override
  String get unlabeledCategory => 'Bez popisku';

  @override
  String get archivedLists => '📦 Archivované nákupy';

  @override
  String get postimportAction => 'Po importu';

  @override
  String get postimportHint =>
      'Zvolte, co se má stát s importovanými záznamy ve zdrojové aplikaci (Připomínky / Google Tasks).';

  @override
  String get postimportLeave => 'Jen přidat';

  @override
  String get postimportComplete => 'Odškrtnout';

  @override
  String get postimportCompleteDelete => 'Odškrtnout a smazat';

  @override
  String get postimportFailed =>
      'Zpracování ve zdrojové aplikaci se nezdařilo. Položky byly přesto přidány do Mealie.';

  @override
  String get syncChangesTitle => 'Synchronizovat změny';

  @override
  String get syncSectionChecked => 'Odškrtnuté';

  @override
  String get syncSectionQuantity => 'Množství';

  @override
  String get syncSectionCategory => 'Kategorie';

  @override
  String get syncSectionAdditions => 'Nově přidané';

  @override
  String get syncLocalLabel => 'Místní';

  @override
  String get syncServerLabel => 'Server';

  @override
  String get syncNow => 'Synchronizovat nyní';

  @override
  String get offlineBadge => 'Offline';

  @override
  String get mealplanTitle => '📅 Jídelníček';

  @override
  String get breakfast => 'Snídaně';

  @override
  String get lunch => 'Oběd';

  @override
  String get dinner => 'Večeře';

  @override
  String get addMealEntry => 'Přidat jídlo';

  @override
  String get selectRecipe => 'Vybrat recept';

  @override
  String get importRecipe => 'Importovat recept';

  @override
  String get url => 'URL';

  @override
  String get importLanguage => 'Jazyk pro OCR';

  @override
  String get setupTitle => 'Vítejte v Mealie Recipes';

  @override
  String get setupSubtitle => 'Nastavte svůj server Mealie.';

  @override
  String get serverUrl => 'URL serveru';

  @override
  String get serverUrlPlaceholder => 'https://mealie.example.com';

  @override
  String get apiToken => 'API token';

  @override
  String get apiTokenPlaceholder => 'Váš API token';

  @override
  String get householdId => 'Domácnost';

  @override
  String get householdIdPlaceholder => 'Rodina';

  @override
  String get shoppingListId => 'ID nákupního seznamu';

  @override
  String get setupHouseholdListTitle => 'Domácnost a nákupní seznam';

  @override
  String get shoppingListLabel => 'Nákupní seznam';

  @override
  String get setupHouseholdManualHint =>
      'Domácnosti se nepodařilo načíst — zadejte název domácnosti ručně.';

  @override
  String get setupExactTitle => 'Množství v nákupním seznamu';

  @override
  String get setupExactBody =>
      'Ve většině zemí se nenakupuje na gramy — do košíku dáte 1 balení másla, ne 200 g. V jednoduchém režimu proto aplikace převádí množství z receptu na „1×“. V přesném režimu zůstává množství i jednotka 1:1 jako ve webové aplikaci Mealie — i při psaní nových položek (např. „200 g máslo“). Kdykoli to můžete změnit v nastavení.';

  @override
  String get setupExactSimpleTitle => 'Jednoduchý režim (1×)';

  @override
  String get setupExactSimpleBody =>
      'Ingredience se do seznamu dostanou jako „1× položka“ — ideální pro rychlé odškrtávání v obchodě.';

  @override
  String get setupExactExactTitle => 'Přesná množství';

  @override
  String get setupExactExactBody =>
      'Položky se zobrazí s množstvím a jednotkou, např. „200 g máslo“ — přesně jako ve webové aplikaci.';

  @override
  String get connect => 'Připojit';

  @override
  String connectionError(String error) {
    return 'Připojení se nezdařilo: $error';
  }

  @override
  String get optionalHeaders => 'Volitelné HTTP hlavičky (pro reverzní proxy)';

  @override
  String get settingsTitle => '⚙️ Nastavení';

  @override
  String get settingsSaved => 'Nastavení uloženo';

  @override
  String get securitySettings => 'Zabezpečení';

  @override
  String get showRecipeImages => 'Zobrazovat obrázky receptů';

  @override
  String get apiVersion => 'Verze API';

  @override
  String get language => 'Jazyk';

  @override
  String get biometricLock => 'Biometrický zámek';

  @override
  String get biometricLockDescription => 'Odemykat aplikaci biometrií';

  @override
  String get enableLogging => 'Zapnout protokolování';

  @override
  String get selectLanguage => 'Vybrat jazyk';

  @override
  String get setupContinue => 'Pokračovat';

  @override
  String get back => 'Zpět';

  @override
  String get setupConnectStep => 'Připojte se k serveru';

  @override
  String get resetSettings => 'Obnovit všechna nastavení';

  @override
  String get resetSettingsConfirm =>
      'Všechna nastavení budou obnovena. Pokračovat?';

  @override
  String get guestMode => 'Režim hosta';

  @override
  String get appVersion => 'Verze';

  @override
  String get leftoverFinder => 'Vyhledávač receptů';

  @override
  String get addIngredient => 'Přidat ingredienci';

  @override
  String get biometricPrompt => 'Ověřte se pro otevření Mealie Recipes';

  @override
  String get biometricFailed => 'Ověření se nezdařilo';

  @override
  String get pendingRecipesTitle => 'Přijaté recepty';

  @override
  String pendingRecipesFrom(Object names) {
    return 'Od $names';
  }

  @override
  String get pendingRecipesOpenCooking => 'Otevřít režim vaření';

  @override
  String get dismiss => 'Zavřít';

  @override
  String get editRecipe => 'Upravit recept';

  @override
  String get recipeName => 'Název receptu';

  @override
  String get prepTime => 'Doba přípravy (min)';

  @override
  String get cookTime => 'Doba vaření (min)';

  @override
  String get totalTime => 'Celková doba (min)';

  @override
  String get recipeServings => 'Porce';

  @override
  String get rating => 'Hodnocení';

  @override
  String get addIngredientLine => 'Přidat ingredienci';

  @override
  String get addInstruction => 'Přidat krok';

  @override
  String get removeIngredient => 'Odebrat ingredienci';

  @override
  String get removeInstruction => 'Odebrat krok';

  @override
  String get ingredientName => 'Ingredience';

  @override
  String get ingredientQuantity => 'Množství';

  @override
  String get ingredientUnit => 'Jednotka';

  @override
  String get ingredientNote => 'Poznámka';

  @override
  String get instructionText => 'Text kroku';

  @override
  String get categories => 'Kategorie';

  @override
  String get saveChanges => 'Uložit změny';

  @override
  String get saveSuccess => 'Recept uložen.';

  @override
  String get newCategory => 'Nová kategorie';

  @override
  String get newTag => 'Nový štítek';

  @override
  String get setRating => 'Nastavit hodnocení';

  @override
  String get homeWelcome => 'Vítejte v Mealie Recipes! 👋';

  @override
  String homeWelcomeNamed(String name) {
    return 'Vítejte, $name, v Mealie Recipes! 👋';
  }

  @override
  String get shopping => 'Nákup';

  @override
  String get planning => 'Plánování';

  @override
  String get other => 'Ostatní';

  @override
  String get addRecipe => '➕ Přidat recept';

  @override
  String get completeShopping => 'Dokončit nákup';

  @override
  String get shoppingCompleted => 'Nákup dokončen';

  @override
  String get shoppingCompletedSubtitle => 'Vše v košíku! 🎉';

  @override
  String get shoppingOfflineNoCache => 'Offline – seznam není uložen';

  @override
  String get shoppingOfflineNoCacheSubtitle =>
      'Z tohoto seznamu zatím nejsou v zařízení uloženy žádné položky. Načte se, jakmile budete znovu online.';

  @override
  String get essensplan => '📅 Jídelníček';

  @override
  String get resteverwertung => '🥗 Hledání receptů';

  @override
  String get copyCode => 'Kopírovat kód';

  @override
  String get shareLink => 'Sdílet odkaz';

  @override
  String get connectedFriends => 'Připojení přátelé';

  @override
  String get waitingForFriends => 'Čekání na přátele...';

  @override
  String get sessionCode => 'KÓD RELACE';

  @override
  String get loading => 'Načítání...';

  @override
  String get urlInvalidScheme => 'URL musí začínat http:// nebo https://';

  @override
  String get urlAddScheme => 'Přidat https://';

  @override
  String get addItemPlaceholder => 'Přidat položku...';

  @override
  String get completedItems => 'Hotovo';

  @override
  String get completeShoppingTitle => 'Dokončit nákup?';

  @override
  String get completeShoppingMessage => 'Smazat odškrtnuté položky?';

  @override
  String get recipeListTitle => '📖 Recepty';

  @override
  String get importRecipeTitle => 'Nahrát nový recept';

  @override
  String get uploadRecipeUrl => 'Import přes URL receptu';

  @override
  String get uploadRecipeUrlHint =>
      'Zadejte URL receptu a uložte ho na svůj server';

  @override
  String get uploadOpenAI => 'Import ze souboru přes OpenAI';

  @override
  String get uploadOpenAIHint =>
      'Případně nahrajte fotky nebo PDF receptu. Pokud má recept více stránek, přidejte jich prostě víc — AI je zanalyzuje společně.';

  @override
  String get takePhoto => 'Fotoaparát';

  @override
  String get cameraPermissionDenied =>
      'Chybí přístup k fotoaparátu. Povolte ho v nastavení systému, abyste mohli fotit recepty.';

  @override
  String get cameraUnavailable => 'V tomto zařízení není fotoaparát.';

  @override
  String get selectPhoto => 'Fotky';

  @override
  String get selectPdf => 'PDF';

  @override
  String get openAIHintTitle => 'Info k analýze souborů';

  @override
  String get openAIHintBody =>
      'Analýza receptu používá API OpenAI. Ujistěte se, že je klíč API nastaven v nastavení serveru Mealie.';

  @override
  String get allDeleteConfirm => 'Smazat vše';

  @override
  String get entriesInOtherWeeks => 'V jiných týdnech jsou záznamy';

  @override
  String get availableWeeks => 'Dostupné týdny:';

  @override
  String get currentWeek => 'Aktuální týden';

  @override
  String get weekAbbreviation => 'Týd.';

  @override
  String get today => 'Dnes';

  @override
  String get selectDate => 'Vybrat datum';

  @override
  String get selectedRecipe => 'Vybraný recept';

  @override
  String get confirmMeal => 'Naplánovat jídlo';

  @override
  String get searchRecipes => 'Hledat recepty';

  @override
  String get addCustomMeal => 'Přidat vlastní jídlo';

  @override
  String get diceModeButton => 'Hodit náhodné recepty';

  @override
  String get diceModeTitle => '3 náhodné návrhy';

  @override
  String get diceBackToSearch => 'Zpět na hledání';

  @override
  String get diceNotEnoughRecipes =>
      'Málo receptů pro režim kostky (potřeba alespoň 3)';

  @override
  String get entrySingular => 'záznam';

  @override
  String get entriesPlural => 'záznamy';

  @override
  String get deleteAllConfirmTitle => 'Smazat vše?';

  @override
  String get deleteAllConfirmMessage =>
      'Chcete smazat všechny archivované nákupy?';

  @override
  String get uploadFromUrlButton => 'Importovat recept z URL';

  @override
  String get uploadingImage => 'Nahrávání...';

  @override
  String get uploadErrorTitle => 'Nahrání se nezdařilo';

  @override
  String get uploadSuccessTitle => 'Nahrání proběhlo';

  @override
  String get editImportedRecipeQuestion => 'Chcete nový recept upravit hned?';

  @override
  String get notNow => 'Teď ne';

  @override
  String get pdfTooLarge => 'Soubor PDF je příliš velký (max. 10 MB).';

  @override
  String get invalidUrl => 'Neplatná URL. Zadejte platnou adresu HTTP(S).';

  @override
  String get cookWithFriends => 'Vaření s přáteli';

  @override
  String get cookFriendsSubtitle =>
      'Pozvěte přítele, ať tento recept uvaříte spolu';

  @override
  String get copied => 'Zkopírováno';

  @override
  String get linkCopied => 'Odkaz zkopírován';

  @override
  String get startCooking => 'Začít vařit';

  @override
  String get uploadToOwnServer => 'Uložit na můj server';

  @override
  String get uploadingRecipe => 'Nahrávání receptu…';

  @override
  String get recipeUploadedToOwnServer => 'Recept uložen na váš server';

  @override
  String get recipeUploadFailed => 'Nahrání se nezdařilo';

  @override
  String get allowGuestSaveRecipes =>
      'Povolit hostům ukládat recepty na vlastní server';

  @override
  String get appIcon => 'Ikona aplikace';

  @override
  String get name => 'Název';

  @override
  String get color => 'Barva';

  @override
  String get randomColor => 'Náhodná barva';

  @override
  String get createFailed => 'Nelze vytvořit';

  @override
  String get deleteFailed => 'Nelze smazat';

  @override
  String deleteOrganizerConfirm(String name) {
    return 'Smazat „$name“? Odstraní se i na serveru.';
  }

  @override
  String get connectionSection => 'Připojení';

  @override
  String get token => 'Token';

  @override
  String get advancedOptions => 'Pokročilé možnosti';

  @override
  String get mealieApiVersion => 'Verze API Mealie';

  @override
  String get sendOptionalHeaders => 'Odesílat volitelné hlavičky';

  @override
  String get offlineRecipeImages => 'Ukládat obrázky receptů offline';

  @override
  String get offlineRecipeImagesHint =>
      'Stáhne do zařízení všechny obrázky receptů – včetně obrázků v krocích a poznámkách – aby se zobrazily i bez připojení. Velké sbírky mohou zabrat několik set MB. Vypnutím se uložené obrázky smažou.';

  @override
  String offlineRecipeImagesStatus(int count, int total, String size) {
    return 'Uloženo: $count/$total · $size';
  }

  @override
  String get offlineRecipeImagesDisableConfirm =>
      'Smazat všechny uložené obrázky receptů?';

  @override
  String headerNameLabel(int n) {
    return 'Název hlavičky $n';
  }

  @override
  String headerValueLabel(int n) {
    return 'Hodnota hlavičky $n';
  }

  @override
  String get value => 'Hodnota';

  @override
  String get personalization => 'Přizpůsobení';

  @override
  String get showRecipeImagesSubtitle => 'Zobrazuje obrázky v seznamu receptů';

  @override
  String get exactQuantities => 'Přidávat přesná množství';

  @override
  String get exactQuantitiesSubtitle =>
      'Ingredience a napsané položky si ponechají množství a jednotku (např. 200 g máslo) místo 1× za položku';

  @override
  String get remindToShop => 'Připomenout nákup';

  @override
  String get remindToShopSubtitle =>
      'Upozorní vás, když jste blízko uloženého místa a nákupní seznam má otevřené položky — i když je aplikace zavřená';

  @override
  String get shoppingReminderAddLocation => 'Přidat místo';

  @override
  String get shoppingReminderMaxLocations => 'Dosaženo maxima 3 míst';

  @override
  String get shoppingReminderLocationServiceDisabled =>
      'Polohové služby jsou v tomto zařízení vypnuté';

  @override
  String get shoppingReminderPermissionTitle => 'Je potřeba přístup k poloze';

  @override
  String get shoppingReminderPermissionMessage =>
      'Aby vám aplikace mohla připomenout nákup u obchodu, potřebuje přístup k poloze „Vždy“ — i když je zavřená. Povolte ho v Nastavení.';

  @override
  String get openSettings => 'Otevřít Nastavení';

  @override
  String get shoppingReminderLocationName => 'Název';

  @override
  String get shoppingReminderUseCurrentLocation => 'Použít aktuální polohu';

  @override
  String get shoppingReminderOrAddress => 'nebo zadejte adresu';

  @override
  String get shoppingReminderAddress => 'Adresa';

  @override
  String get shoppingReminderAddressPlaceholder => 'Ulice, město';

  @override
  String get shoppingReminderSearchAddress => 'Hledat';

  @override
  String get shoppingReminderLocationFailed =>
      'Nepodařilo se zjistit vaši polohu';

  @override
  String get shoppingReminderAddressNotFound => 'Adresa nenalezena';

  @override
  String get ratingFailed =>
      'Hodnocení se nepodařilo uložit — zkuste to znovu.';

  @override
  String get lastCooked => 'Naposledy uvařeno';

  @override
  String get syncLastCooked => 'Aktualizovat „naposledy uvařeno“';

  @override
  String get syncLastCookedSubtitle =>
      'Uloží dnešní datum a záznam na časové ose serveru — jako webová aplikace Mealie.';

  @override
  String get developer => 'Vývojář';

  @override
  String get enableLoggingSubtitle =>
      'Zaznamenává výpisy a chyby (posledních 500 řádků)';

  @override
  String get entriesLabel => 'Záznamy';

  @override
  String get fileSize => 'Velikost souboru';

  @override
  String get showAction => 'Zobrazit';

  @override
  String get copy => 'Kopírovat';

  @override
  String logsWithCount(int count) {
    return 'Protokoly ($count)';
  }

  @override
  String get noLogs => 'Žádné protokoly';

  @override
  String get logsTitle => 'Protokoly';

  @override
  String get required => 'Povinné';

  @override
  String get connectionFailedCheck =>
      'Připojení se nezdařilo. Zkontrolujte URL a token.';

  @override
  String get username => 'Uživatelské jméno';

  @override
  String get password => 'Heslo';

  @override
  String get setupPasswordHint =>
      'Heslo se neukládá — aplikace se jednou přihlásí a vytvoří z něj API token (stejně jako Profil → API tokeny ve webové aplikaci).';

  @override
  String get loginAndConnect => 'Přihlásit a připojit';

  @override
  String get loginInvalidCredentials =>
      'Uživatelské jméno nebo heslo je nesprávné.';

  @override
  String get apiTokenSaveHint =>
      'Token použit — klepněte níže na „Uložit změny“.';

  @override
  String get renewApiToken => 'Obnovit API token';

  @override
  String get setupAuthChoiceTitle => 'Jak se chcete přihlásit?';

  @override
  String get authModePasswordTitle => 'Ať mi aplikace vytvoří API klíč';

  @override
  String get authModePasswordSubtitle =>
      'Přihlášení uživatelským jménem a heslem — aplikace token vytvoří automaticky.';

  @override
  String get authModeTokenTitle => 'API klíč už mám';

  @override
  String get authModeTokenSubtitle =>
      'Zkopírovaný z profilu Mealie (Profil → API tokeny).';

  @override
  String keyN(int n) {
    return 'Klíč $n';
  }

  @override
  String valueN(int n) {
    return 'Hodnota $n';
  }

  @override
  String get openCookingMode => 'Otevřít režim vaření';

  @override
  String activeRecipes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count aktivních receptů',
      many: '$count aktivního receptu',
      few: '$count aktivní recepty',
      one: '$count aktivní recept',
    );
    return '$_temp0';
  }

  @override
  String get reparseIngredients => 'Znovu rozebrat ingredience';

  @override
  String get reparseIngredientsSubtitle =>
      'Rozdělit množství/jednotku/ingredienci (např. „200 g mouky“)';

  @override
  String get reparseDone =>
      'Ingredience rozděleny – klepněte na „Uložit změny“ pro použití';

  @override
  String get tagsAndCategories => 'Štítky, kategorie a nástroje';

  @override
  String get tapToAddPhoto => 'Klepnutím přidáte fotku';

  @override
  String get descriptionLabel => 'Popis';

  @override
  String get searchingDevices => 'Hledání zařízení ve stejné síti Wi-Fi…';

  @override
  String get selectAll => 'Vybrat vše';

  @override
  String get importReminders => 'Importovat připomínky';

  @override
  String get importGoogleTasks => 'Importovat Google Tasks';

  @override
  String get noTaskLists => 'Nenalezeny žádné seznamy úkolů';

  @override
  String get noReminderLists => 'Nenalezeny žádné seznamy připomínek';

  @override
  String importCount(int count) {
    return 'Importovat $count';
  }

  @override
  String get noIngredientsToLink => 'Zatím žádné ingredience k propojení';

  @override
  String get importLanguageSubtitle =>
      'Jazyk receptů importovaných z fotky nebo PDF';

  @override
  String get importLanguageSearch => 'Hledat jazyk';

  @override
  String get importLanguageFollowApp => 'Stejný jako jazyk aplikace';

  @override
  String get importLanguageNoMatch => 'Jazyk nenalezen';

  @override
  String get setupImportLanguageTitle => 'Import receptů pomocí AI';

  @override
  String get setupImportLanguageBody =>
      'AI umí z fotek a PDF udělat recepty. Vyberte jazyk, ve kterém mají vzniknout — praktické, pokud váš mateřský jazyk není mezi jazyky aplikace. Později to můžete změnit v nastavení.';

  @override
  String get setupImportLanguageSearchHint =>
      'Pomocí hledání ve výběru najdete jazyky, které rozhraní aplikace nenabízí.';

  @override
  String get setupCachingKeepOpenTitle => 'Nechte aplikaci otevřenou';

  @override
  String get setupCachingKeepOpenBody =>
      'Načítání probíhá v popředí. Nechte aplikaci otevřenou, dokud neskončí — pokud ji zavřete nebo se na dlouho přepnete jinam, proces se zastaví a začne později znovu.';

  @override
  String get supportContact => 'Kontaktovat podporu';

  @override
  String get supportDialogMessage =>
      'Popište svůj problém a ozveme se. Protokol velmi pomáhá při hledání chyby — můžete ho přiložit jako textový soubor.';

  @override
  String get supportWithoutLogs => 'Bez protokolu';

  @override
  String get supportWithLogs => 'Přiložit protokol';

  @override
  String get supportMailSubject => 'Mealie Recipes — Podpora';

  @override
  String get supportMailHint => 'Popište zde svůj problém:';

  @override
  String get supportLogsEmpty =>
      'Protokol je prázdný. Zapněte protokolování, zopakujte problém a pak ho odešlete.';

  @override
  String supportAddressCopied(String email) {
    return 'Adresa zkopírována: $email';
  }

  @override
  String supportNoMailApp(String email) {
    return 'Není nastavena žádná poštovní aplikace – adresa zkopírována: $email. Vyberte jinou aplikaci, abyste nám mohli napsat.';
  }

  @override
  String get createRecipeFromImages => 'Vytvořit recept';

  @override
  String imagePagesSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Vybráno $count stránek',
      many: 'Vybráno $count stránky',
      few: 'Vybrány $count stránky',
      one: 'Vybrána $count stránka',
    );
    return '$_temp0';
  }

  @override
  String get imagePagesHint =>
      'První obrázek se stane hlavním obrázkem receptu. Podržením stránky změníte pořadí.';

  @override
  String get mainImageBadge => 'Hlavní';

  @override
  String maxImagesReached(int max) {
    return 'Na recept můžete přidat až $max obrázků.';
  }

  @override
  String get removePage => 'Odebrat stránku';

  @override
  String get preparingPdf => 'Zpracování PDF...';

  @override
  String get recipeOptionsTitle => 'Možnosti';

  @override
  String get exportAsPdf => 'Exportovat jako PDF';

  @override
  String get generatingPdf => 'Vytváření PDF…';

  @override
  String get pdfExportFailed => 'Export PDF se nezdařil';

  @override
  String get recipeTime => 'Čas';

  @override
  String get addIngredientSection => 'Přidat oddíl';

  @override
  String get aiImportToggle => 'Analyzovat pomocí AI';

  @override
  String get aiImportToggleHint =>
      'Také pro videorecepty (YouTube, Instagram, TikTok …) a stránky, které běžný import nepřečte. Vyžaduje poskytovatele AI na serveru Mealie — pro videa i poskytovatele zvuku.';

  @override
  String get aiImportButton => 'Importovat pomocí AI';

  @override
  String get aiImportRunning =>
      'AI analyzuje odkaz … videa mohou trvat několik minut.';

  @override
  String get aiImportFailed =>
      'Import pomocí AI se nezdařil. Zkontrolujte nastavení AI na serveru Mealie.';

  @override
  String get stepHeadingLabel => 'Nadpis kroku (volitelné)';

  @override
  String get linkedRecipeLabel => 'Propojený recept';

  @override
  String get toolsTitle => 'Nástroje';

  @override
  String get prepareTools => 'Připravte si následující nástroje';

  @override
  String get newTool => 'Nový nástroj';

  @override
  String get renameAction => 'Přejmenovat';

  @override
  String get organizerEmpty =>
      'Zatím tu nic není. Klepnutím na „+“ vpravo nahoře vytvoříte.';

  @override
  String organizerRecipeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count receptů',
      many: '$count receptu',
      few: '$count recepty',
      one: '$count recept',
      zero: 'Žádné recepty',
    );
    return '$_temp0';
  }

  @override
  String get toolOnHand => 'K dispozici';

  @override
  String get mealDiceSettingsHint =>
      'Vyberte kategorie a štítky pro každé jídlo. Při hodu kostkou se navrhnou jen recepty s alespoň jedním z nich. Stejnou položku lze použít pro více jídel.';

  @override
  String get mealDiceSettingsNoneHint =>
      'Pro toto jídlo není nic vybráno: kostka vybírá automaticky podle názvů kategorií jako „Snídaně“, „Oběd“ nebo „Večeře“.';

  @override
  String get mealDiceAutoHintTitle => 'Automatický výběr';

  @override
  String get mealDiceAutoHintBody =>
      'Pro toto jídlo zatím nejsou nastaveny kategorie ani štítky. Kostka proto hledá kategorie jako „Snídaně“, „Oběd“ nebo „Večeře“ a doplní je dalšími recepty.\n\nVlastní výběr: v jídelníčku klepněte na ozubené kolečko vedle „+“.';

  @override
  String get dontShowAgain => 'Znovu nezobrazovat';

  @override
  String get mealDiceNoMatches =>
      'Kategoriím a štítkům vybraným pro toto jídlo neodpovídá žádný recept.';

  @override
  String mealDiceFewMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Odpovídá jen $count receptů',
      many: 'Odpovídá jen $count receptu',
      few: 'Odpovídají jen $count recepty',
      one: 'Odpovídá jen $count recept',
    );
    return '$_temp0';
  }

  @override
  String get commentsTitle => 'Komentáře';

  @override
  String get commentHint => 'Napište komentář…';

  @override
  String get commentSaveFailed => 'Komentář se nepodařilo uložit.';

  @override
  String get commentDeleteConfirm => 'Smazat tento komentář?';

  @override
  String get cookingDoneCommentLabel => 'Komentář (volitelné)';

  @override
  String get cookingDoneCommentHint => 'Jak se to povedlo? Tipy na příště…';

  @override
  String get nutritionTitle => 'Výživové hodnoty';

  @override
  String get nutritionPerServing => 'na porci';

  @override
  String get nutritionCalories => 'Kalorie';

  @override
  String get nutritionFat => 'Tuky';

  @override
  String get nutritionSaturatedFat => 'Nasycené tuky';

  @override
  String get nutritionTransFat => 'Trans tuky';

  @override
  String get nutritionUnsaturatedFat => 'Nenasycené tuky';

  @override
  String get nutritionCholesterol => 'Cholesterol';

  @override
  String get nutritionSodium => 'Sodík';

  @override
  String get nutritionCarbohydrates => 'Sacharidy';

  @override
  String get nutritionFiber => 'Vláknina';

  @override
  String get nutritionSugar => 'Cukr';

  @override
  String get nutritionProtein => 'Bílkoviny';

  @override
  String get timelineTitle => 'Časová osa';

  @override
  String get timelineMadeThis => 'Uvařil(a) jsem to';

  @override
  String timelineUserMadeThis(String name) {
    return '$name to uvařil(a)';
  }

  @override
  String get timelineEmpty => 'Na časové ose zatím nejsou žádné záznamy.';

  @override
  String get timelineDate => 'Datum';

  @override
  String get timelineNoteHint => 'Poznámka (volitelné)';

  @override
  String get timelineAddPhoto => 'Přidat fotku';

  @override
  String get timelineRemovePhoto => 'Odebrat fotku';

  @override
  String get timelineSaved => 'Přidáno na časovou osu';

  @override
  String get timelineSaveFailed => 'Nelze přidat na časovou osu';

  @override
  String get timelineImageFailed =>
      'Záznam uložen, ale fotku se nepodařilo nahrát';

  @override
  String get timelineDeleteConfirm => 'Smazat tento záznam z časové osy?';

  @override
  String get timelineEditNote => 'Upravit poznámku';

  @override
  String get timelineUnknownRecipe => 'Recept nenalezen';

  @override
  String get cookingDonePhotoHint => 'Fotka na časovou osu Mealie (volitelné)';

  @override
  String get assetsTitle => 'Přílohy';

  @override
  String get assetsAdd => 'Přidat přílohu';

  @override
  String get assetsChooseFile => 'Soubor';

  @override
  String get assetsUploading => 'Nahrávání…';

  @override
  String get assetsUploadFailed => 'Přílohu se nepodařilo nahrát';

  @override
  String assetsDeleteConfirm(String name) {
    return 'Odebrat „$name“ z příloh?';
  }

  @override
  String get assetsOpenFailed => 'Přílohu se nepodařilo otevřít';

  @override
  String get assetsUnsupported =>
      'Mealie podporuje jen PDF, obrázky, TXT, MD, CSV a JSON.';

  @override
  String get assetsShare => 'Sdílet';

  @override
  String get mealRulesTitle => 'Pravidla Mealie';

  @override
  String get mealRulesHint =>
      'Používá je i webová aplikace Mealie. Pokud pro den a jídlo platí více pravidel, musí odpovídat všechna. Pokud neplatí žádné pravidlo, kostka vybírá ze všech receptů.';

  @override
  String get mealRuleAdd => 'Přidat pravidlo';

  @override
  String get mealRuleNewTitle => 'Nové pravidlo';

  @override
  String get mealRuleEditTitle => 'Upravit pravidlo';

  @override
  String get mealRuleDay => 'Den';

  @override
  String get mealRuleAnyDay => 'Jakýkoli den';

  @override
  String get mealRuleMealType => 'Jídlo';

  @override
  String get mealRuleAnyMeal => 'Jakékoli jídlo';

  @override
  String get mealRuleConditionsTitle => 'Podmínky';

  @override
  String get mealRuleAllRecipes => 'Všechny recepty';

  @override
  String get mealRuleDeleteConfirm => 'Smazat toto pravidlo?';

  @override
  String get mealRulesOffline =>
      'Pravidla Mealie teď nejsou dostupná – kostka používá výběr aplikace.';

  @override
  String get mealRulesNoMatches =>
      'Pravidlům Mealie pro toto jídlo neodpovídá žádný recept.';

  @override
  String get mealTypeSide => 'Příloha';

  @override
  String get mealTypeSnack => 'Svačina';

  @override
  String get mealTypeDrink => 'Nápoje';

  @override
  String get mealTypeDessert => 'Dezerty';

  @override
  String get foodsTitle => 'Potraviny';

  @override
  String get unitsTitle => 'Jednotky';

  @override
  String get newFood => 'Nová potravina';

  @override
  String get newUnit => 'Nová jednotka';

  @override
  String get editFood => 'Upravit potravinu';

  @override
  String get editUnit => 'Upravit jednotku';

  @override
  String get pluralNameLabel => 'Název v množném čísle';

  @override
  String get abbreviationLabel => 'Zkratka';

  @override
  String get pluralAbbreviationLabel => 'Zkratka v množném čísle';

  @override
  String get mergeAction => 'Sloučit';

  @override
  String mergeIntoTitle(String name) {
    return 'Sloučit „$name“ do…';
  }

  @override
  String mergeConfirm(String from, String to) {
    return '„$from“ bude sloučeno do „$to“: všechny recepty a nákupní seznamy pak budou používat „$to“ a „$from“ bude smazáno.';
  }

  @override
  String get mergeFailed => 'Sloučení se nezdařilo';

  @override
  String foodUnitDeleteConfirm(String name) {
    return 'Smazat „$name“? Ingredience, které to používají, přijdou o odkaz.';
  }

  @override
  String get foodsUnitsEmpty => 'Zatím žádné záznamy.';

  @override
  String mealRuleConditionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count podmínek',
      many: '$count podmínky',
      few: '$count podmínky',
      one: '$count podmínka',
    );
    return '$_temp0';
  }

  @override
  String get showAll => 'Zobrazit vše';

  @override
  String get mealDiceModeTitle => 'Kostka používá';

  @override
  String get mealDiceModeApp => 'Výběr aplikace';

  @override
  String get switchListTitle => 'Přepnout seznam';

  @override
  String get newShoppingList => 'Nový nákupní seznam';

  @override
  String shoppingListDeleteConfirm(String name) {
    return 'Smazat „$name“? Smažou se i všechny jeho položky.';
  }

  @override
  String get labelOrderTitle => 'Seřadit popisky';

  @override
  String get labelOrderHint =>
      'Řaďte přetažením. Platí pro tento seznam – i ve webové aplikaci Mealie.';

  @override
  String get labelOrderEmpty => 'Tento seznam zatím nemá popisky.';

  @override
  String get useAsActiveList => 'Použít jako aktivní seznam';

  @override
  String get activeListBadge => 'Aktivní';

  @override
  String get foodLabelLabel => 'Popisek';

  @override
  String get foodNoLabel => 'Bez popisku';

  @override
  String get aliasesLabel => 'Aliasy';

  @override
  String get aliasAddHint => 'Přidat alias';

  @override
  String get foodOnHand => 'K dispozici v domácnosti';

  @override
  String get timelineChildRecipesTitle => 'Přidat i pro propojené recepty';

  @override
  String timelineMadeForRecipe(String recipe) {
    return 'Vytvořeno pro $recipe';
  }

  @override
  String get timelineFilter => 'Filtrovat záznamy';

  @override
  String get timelineTypeComment => 'Uvařeno a poznámky';

  @override
  String get timelineTypeInfo => 'Informace';

  @override
  String get timelineTypeSystem => 'Systém';

  @override
  String get listManagementTitle => 'Nákupní seznamy';

  @override
  String get managementTitle => 'Další';

  @override
  String get pinToHome => 'Přidat na domovskou obrazovku';

  @override
  String get unpinFromHome => 'Odebrat z domovské obrazovky';

  @override
  String homeScreenFull(int count) {
    return 'Domovská obrazovka je plná – nejvýše $count dlaždic. Nejprve odeberte jinou dlaždici v části „Další“.';
  }

  @override
  String get selectAction => 'Vybrat';

  @override
  String selectedCount(int count) {
    return 'Vybráno: $count';
  }

  @override
  String get assignLabelAction => 'Přiřadit popisek';

  @override
  String get assignLabelOverwriteHint =>
      'Přepíše popisek všech vybraných potravin.';

  @override
  String deleteSelectedConfirm(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Smazat $count záznamů?',
      many: 'Smazat $count záznamu?',
      few: 'Smazat $count záznamy?',
      one: 'Smazat $count záznam?',
    );
    return '$_temp0';
  }

  @override
  String get seedDataAction => 'Načíst výchozí data';

  @override
  String get seedFoodsHint =>
      'Vytvoří výchozí potraviny Mealie ve vybraném jazyce.';

  @override
  String get seedUnitsHint =>
      'Vytvoří výchozí jednotky Mealie ve vybraném jazyce.';

  @override
  String get seedLanguageLabel => 'Jazyk';

  @override
  String get seedDuplicateWarning =>
      'Už máte nějaké záznamy. Mealie duplicity neřeší – budete je muset sloučit sami.';

  @override
  String get seedDone => 'Výchozí data vytvořena';

  @override
  String get seedFailed => 'Výchozí data se nepodařilo načíst';

  @override
  String get exportAction => 'Exportovat';

  @override
  String get substitutionsLabel => 'Náhrady';

  @override
  String get substitutionAddHint => 'Přidat náhradu';

  @override
  String get substitutionFoodLabel => 'Potravina (volitelné)';

  @override
  String get substitutionNoteLabel => 'Poznámka (volitelné)';

  @override
  String get substitutionNeedOne => 'Zadejte potravinu nebo poznámku';

  @override
  String get useAbbreviationLabel => 'Použít zkratku';

  @override
  String get useAbbreviationHint => 'V receptech zobrazovat „g“ místo „gram“';

  @override
  String get fractionLabel => 'Zobrazit jako zlomek';

  @override
  String get fractionHint => '½ místo 0,5';

  @override
  String get standardizationTitle => 'Standardizace';

  @override
  String get standardizationHint =>
      'Pro převody: 1 této jednotky odpovídá … (např. 1 lžíce = 15 mililitrů).';

  @override
  String get standardQuantityLabel => 'Standardní množství';

  @override
  String get standardUnitLabel => 'Standardní jednotka';

  @override
  String get standardUnitNone => 'Žádný';

  @override
  String get stdFluidOunce => 'Tekutá unce (fl oz)';

  @override
  String get stdCup => 'Hrnek (US)';

  @override
  String get stdOunce => 'Unce (oz)';

  @override
  String get stdPound => 'Libra (lb)';

  @override
  String get stdMilliliter => 'Mililitr';

  @override
  String get stdLiter => 'Litr';

  @override
  String get stdGram => 'Gram';

  @override
  String get stdKilogram => 'Kilogram';

  @override
  String get labelsTitle => 'Popisky';

  @override
  String get newLabel => 'Nový popisek';

  @override
  String get editLabel => 'Upravit popisek';

  @override
  String get colorLabel => 'Barva';

  @override
  String labelDeleteConfirm(String name) {
    return 'Smazat „$name“? Položky a potraviny o tento popisek přijdou.';
  }

  @override
  String get importMenuAction => 'Importovat';

  @override
  String get archivedEmpty =>
      'Zatím žádné archivované nákupy. Po nákupu klepněte na „Dokončit nákup“ – odškrtnuté položky se uloží sem.';

  @override
  String get sectionTitleLabel => 'Název oddílu';

  @override
  String get clearSection => 'Odebrat oddíl';

  @override
  String get noPermissionGeneric =>
      'K tomu nemáte v Mealie oprávnění. Požádejte správce nebo správce domácnosti.';

  @override
  String get noPermissionEditRecipe =>
      'Tento recept nemůžete upravit – je zamčený nebo patří jiné domácnosti. Může to jen jeho autor nebo správce.';

  @override
  String get noPermissionDeleteRecipe =>
      'Recept může smazat jen jeho autor nebo správce.';

  @override
  String get noPermissionDemoteSelf =>
      'Nemůžete si odebrat vlastní správcovská práva.';

  @override
  String get recipeLockedHint => 'Zamčeno – upravit může jen autor';

  @override
  String get recipeDeleteOwnerOnlyHint => 'Smazat může jen autor nebo správce';

  @override
  String get organizeReadOnlyHint =>
      'Jen pro čtení: vytváření, úpravy a mazání vyžadují oprávnění „Uživatel může spravovat potraviny, štítky a kategorie“.';

  @override
  String get notesNotSavedNoPermission =>
      'Poznámka neuložena – nemáte oprávnění upravovat tento recept.';

  @override
  String get userManagementTitle => 'Správa uživatelů';

  @override
  String get editUserTitle => 'Upravit uživatele';

  @override
  String get fullNameLabel => 'Jméno a příjmení';

  @override
  String get usernameLabel => 'Uživatelské jméno';

  @override
  String get emailLabel => 'E-mail';

  @override
  String get passwordLabel => 'Heslo';

  @override
  String get householdLabel => 'Domácnost';

  @override
  String get permissionsTitle => 'Oprávnění';

  @override
  String get administratorLabel => 'Správce';

  @override
  String get permCanInvite => 'Uživatel může pozvat ostatní do skupiny';

  @override
  String get permCanManage => 'Uživatel může spravovat nastavení skupiny';

  @override
  String get permCanManageHousehold => 'Uživatel může spravovat domácnost';

  @override
  String get permCanOrganize =>
      'Uživatel může spravovat potraviny, štítky a kategorie';

  @override
  String get advancedFeaturesLabel => 'Povolit pokročilé funkce';

  @override
  String get passwordResetLinkAction => 'Vygenerovat odkaz pro obnovení hesla';

  @override
  String get resetLockedUsersAction => 'Obnovení uzamčených uživatelů';

  @override
  String get inviteLinkTitle => 'Odkaz pozvánky';

  @override
  String get inviteAction => 'Pozvat';

  @override
  String get userUpdated => 'Uživatel aktualizován';

  @override
  String get createUserTitle => 'Vytvořit uživatele';

  @override
  String get userCreated => 'Uživatel vytvořen';

  @override
  String userDeleteConfirm(String name) {
    return 'Smazat „$name“? Účet bude z Mealie odstraněn.';
  }

  @override
  String get passwordResetLinkCopied =>
      'Odkaz zkopírován – předejte ho uživateli. Platí jen omezenou dobu.';

  @override
  String lockedUsersReset(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Odemčeno $count uživatelů',
      many: 'Odemčeno $count uživatele',
      few: 'Odemčeni $count uživatelé',
      one: 'Odemčen $count uživatel',
      zero: 'Žádní zamčení uživatelé',
    );
    return '$_temp0';
  }

  @override
  String get inviteUsesLabel => 'Počet použití';

  @override
  String get inviteCreated => 'Odkaz s pozvánkou vytvořen';

  @override
  String get inviteEmailHint =>
      'E-mailová adresa (volitelné – Mealie pozvánku odešle)';

  @override
  String get inviteEmailSent => 'Pozvánka odeslána e-mailem';

  @override
  String get inviteEmailFailed =>
      'E-mail se nepodařilo odeslat (je v Mealie nastaven SMTP?). Odkaz přesto funguje.';

  @override
  String get copyLinkAction => 'Kopírovat odkaz';

  @override
  String get youLabel => 'Vy';

  @override
  String get membersPermissionsHint =>
      'Můžete měnit oprávnění členů své domácnosti – ale ne svá vlastní.';

  @override
  String get householdManagementTitle => 'Správa domácností';

  @override
  String get householdsTitle => 'Domácnosti';

  @override
  String get createHouseholdTitle => 'Vytvořit domácnost';

  @override
  String get householdNameLabel => 'Název domácnosti';

  @override
  String get householdPreferencesTitle => 'Předvolby domácnosti';

  @override
  String get privateHouseholdLabel => 'Soukromá domácnost';

  @override
  String get privateHouseholdHint =>
      'Nastavení domácnosti na soukromou zakáže všechny možnosti veřejného zobrazení. To má přednost před individuálním nastavením veřejného zobrazení';

  @override
  String get lockRecipeEditsLabel =>
      'Uzamknout úpravy receptů z ostatních domácností';

  @override
  String get lockRecipeEditsHint =>
      'Pokud je povoleno, pouze uživatelé ve vaší domácnosti mohou upravovat recepty vytvořené vaší domácností';

  @override
  String get householdRecipePreferencesTitle =>
      'Preference receptů pro domácnost';

  @override
  String get groupsTitle => 'Skupiny';

  @override
  String get groupLabel => 'Skupina';

  @override
  String get createGroupTitle => 'Vytvořit skupinu';

  @override
  String get groupNameLabel => 'Název skupiny';

  @override
  String get groupPreferencesTitle => 'Nastavení skupiny';

  @override
  String get privateGroupLabel => 'Soukromá skupina';

  @override
  String get privateGroupHint =>
      'Nastavení skupiny na soukromou zakáže všechny možnosti veřejného zobrazení. To má přednost před individuálním nastavením veřejného zobrazení';

  @override
  String get firstDayOfWeekLabel => 'První den týdne';

  @override
  String get showAnnouncementsLabel => 'Zobrazit oznámení od Mealie';

  @override
  String get recipePublicDefaultLabel =>
      'Povolit uživatelům mimo vaši skupinu vidět vaše recepty';

  @override
  String get recipeShowNutritionDefaultLabel => 'Zobrazit nutriční informace';

  @override
  String get recipeShowAssetsDefaultLabel => 'Zobrazit položky receptu';

  @override
  String get recipeLandscapeDefaultLabel => 'Výchozí zobrazení na šířku';

  @override
  String get recipeDisableCommentsDefaultLabel =>
      'Zakázat uživatelům komentovat u receptů';

  @override
  String get myHouseholdSection => 'Moje domácnost';

  @override
  String get myGroupSection => 'Moje skupina';

  @override
  String get preferencesSaved => 'Nastavení uloženo';

  @override
  String get cannotDeleteWithUsers =>
      'Stále má uživatele – nejprve je přesuňte nebo smažte ve správě uživatelů.';

  @override
  String deleteHouseholdConfirm(String name) {
    return 'Smazat domácnost „$name“?';
  }

  @override
  String deleteGroupConfirm(String name) {
    return 'Smazat skupinu „$name“?';
  }

  @override
  String usersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count uživatelů',
      many: '$count uživatele',
      few: '$count uživatelé',
      one: '$count uživatel',
      zero: 'Žádní uživatelé',
    );
    return '$_temp0';
  }

  @override
  String get originalUrlLabel => 'Původní URL';

  @override
  String get copyTextAction => 'Kopírovat text';

  @override
  String get copiedToClipboard => 'Zkopírováno do schránky';

  @override
  String get changelogEnglishHint =>
      'Poznámky k vydání jsou dostupné jen v angličtině.';

  @override
  String get favoritesTitle => 'Oblíbené';

  @override
  String get favoritesEmpty =>
      'Zatím žádné oblíbené. Klepnutím na srdíčko u receptu ho sem přidáte.';

  @override
  String get changelogTitle => 'Novinky';

  @override
  String get changeProfileImage => 'Změnit profilový obrázek';

  @override
  String get profileImageUpdated => 'Profilový obrázek aktualizován';

  @override
  String get profileImageFailed => 'Profilový obrázek se nepodařilo nahrát';

  @override
  String get myAccountTitle => 'Můj účet';

  @override
  String get ownAccountHint =>
      'Zde můžete upravit svůj účet. Ostatní uživatele spravují správci a členové s oprávněním „spravovat“.';

  @override
  String get changePasswordAction => 'Změnit heslo';

  @override
  String get currentPasswordLabel => 'Současné heslo';

  @override
  String get newPasswordLabel => 'Nové heslo';

  @override
  String get confirmPasswordLabel => 'Potvrďte heslo';

  @override
  String get passwordTooShort => 'Alespoň 8 znaků';

  @override
  String get passwordsDoNotMatch => 'Hesla se neshodují';

  @override
  String get passwordUpdated => 'Heslo bylo změněno';

  @override
  String get passwordChangeFailed => 'Heslo se nepodařilo změnit';

  @override
  String passwordManagedExternally(String method) {
    return 'Přihlašujete se přes $method — heslo změňte tam.';
  }

  @override
  String get bulkAddHint => 'Jeden řádek na záznam.';

  @override
  String bulkAddCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Přidat $count záznamů',
      many: 'Přidat $count záznamu',
      few: 'Přidat $count záznamy',
      one: 'Přidat $count záznam',
    );
    return '$_temp0';
  }

  @override
  String get linkRecipeAction => 'Propojit recept';

  @override
  String get useFoodAction => 'Použít potravinu místo receptu';

  @override
  String get addSubstitutionsAction => 'Přidat náhrady';

  @override
  String get clearSubstitutionsAction => 'Odebrat náhrady';

  @override
  String get recipeSubstitutionsTitle => 'Náhrady';

  @override
  String get substitutionUnknownFood =>
      'Jen existující potraviny – jinak použijte poznámku';

  @override
  String get insertAboveAction => 'Vložit nad';

  @override
  String get insertBelowAction => 'Vložit pod';

  @override
  String get moveToTopAction => 'Přesunout nahoru';

  @override
  String get moveToBottomAction => 'Přesunout dolů';

  @override
  String get linkReferencesAction => 'Propojit reference';

  @override
  String get editMarkdownAction => 'Upravit Markdown';

  @override
  String get previewMarkdownAction => 'Náhled';

  @override
  String get insertStepImageAction => 'Nahrát obrázek';

  @override
  String get mergeAboveAction => 'Sloučit s předchozím';

  @override
  String get linkedToOtherStep => 'Propojeno s jiným krokem receptu';

  @override
  String get noNotesToLink => 'Žádné poznámky k propojení';

  @override
  String get ownerLabel => 'Vlastník';

  @override
  String get ingredientParserTitle => 'Analyzátor ingrediencí';

  @override
  String ingredientParserHint(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count ingrediencí ještě není strukturováno. Vyberte analyzátor, zkontrolujte výsledek, použijte.',
      many:
          '$count ingredience ještě není strukturováno. Vyberte analyzátor, zkontrolujte výsledek, použijte.',
      few:
          '$count ingredience ještě nejsou strukturované. Vyberte analyzátor, zkontrolujte výsledek, použijte.',
      one:
          '$count ingredience ještě není strukturovaná. Vyberte analyzátor, zkontrolujte výsledek, použijte.',
    );
    return '$_temp0';
  }

  @override
  String get parserNlp => 'Procesor přirozeného jazyka';

  @override
  String get parserBrute => 'Analýza hrubou silou';

  @override
  String get parserOpenai => 'Analyzátor OpenAI';

  @override
  String get parserApp => 'Offline (aplikace)';

  @override
  String get parseFailed => 'Analýza se nezdařila';

  @override
  String get parseAction => 'Analyzovat';

  @override
  String applyParsedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Použít $count ingrediencí',
      many: 'Použít $count ingredience',
      few: 'Použít $count ingredience',
      one: 'Použít $count ingredienci',
      zero: 'Nic nevybráno',
    );
    return '$_temp0';
  }

  @override
  String get parsedNewBadge => 'nové';

  @override
  String get hoursShort => 'h';

  @override
  String get minutesShort => 'min';

  @override
  String get timeExtraHint => 'Navíc, např. „plus přes noc“';

  @override
  String get yieldLabel => 'Výnos';

  @override
  String get yieldTextLabel => 'Text porcí';

  @override
  String get prepTimeLabel => 'Doba přípravy';

  @override
  String get performTimeLabel => 'Doba vaření';

  @override
  String get totalTimeLabel => 'Celková doba přípravy';

  @override
  String get settingPublicRecipe => 'Veřejný recept';

  @override
  String get settingShowNutrition => 'Zobrazit výživové hodnoty';

  @override
  String get settingShowAssets => 'Zobrazit zdroje';

  @override
  String get settingLandscapeView => 'Horizontální orientace (Coming Soon)';

  @override
  String get settingDisableComments => 'Zakázat komentáře';

  @override
  String get settingDisableAmount => 'Zakázat množství ingrediencí';

  @override
  String get settingLocked => 'Uzamčeno';

  @override
  String get settingLockedOwnerOnly =>
      'Recept může zamknout nebo odemknout jen jeho autor.';

  @override
  String get apiExtrasTitle => 'API doplňky';

  @override
  String get apiExtrasHint =>
      'Vlastní páry klíč/hodnota pro aplikace třetích stran, např. ke spouštění automatizací.';

  @override
  String get extraKeyLabel => 'Klíč';

  @override
  String get extraValueLabel => 'Hodnota';

  @override
  String get addExtraAction => 'Přidat doplněk';

  @override
  String durationHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hodin',
      many: '$count hodiny',
      few: '$count hodiny',
      one: '$count hodina',
    );
    return '$_temp0';
  }

  @override
  String durationMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minut',
      many: '$count minuty',
      few: '$count minuty',
      one: '$count minuta',
    );
    return '$_temp0';
  }

  @override
  String get discardChangesConfirm => 'Zahodit neuložené změny?';

  @override
  String get discardChanges => 'Zahodit změny';

  @override
  String get imageFromUrl => 'Obrázek z URL';

  @override
  String get deleteRecipeImage => 'Smazat recept';

  @override
  String get deleteRecipeImageConfirm => 'Opravdu chcete smazat tento recept?';

  @override
  String get bulkAddIngredients => 'Hromadně přidat ingredience';

  @override
  String get bulkAddSteps => 'Hromadně přidat kroky';

  @override
  String get stepImageFailed => 'Obrázek se nepodařilo nahrát';

  @override
  String get servingsAndTimes => 'Porce a časy';

  @override
  String get recipeSettingsTitle => 'Nastavení receptu';

  @override
  String get jsonEditorTitle => 'JSON editor';

  @override
  String get jsonInvalid => 'Neplatný JSON – zkontrolujte ho.';

  @override
  String get editorOfflineHint =>
      'Otevřeno offline: k uložení je potřeba připojení. Novější pole Mealie (např. náhrady) zůstanou beze změny.';

  @override
  String get parseLineFailed => 'Nerozpoznáno – zůstává beze změny';

  @override
  String get createManualTitle => 'Vytvořit recept ručně';

  @override
  String get createManualHint =>
      'Zadejte název – ingredience, kroky, obrázek a vše ostatní přidáte potom v editoru receptu.';

  @override
  String get createManualButton => 'Vytvořit a upravit';

  @override
  String get changelogEmpty => 'Pro tuto verzi zatím nejsou žádné záznamy.';

  @override
  String get finderDescription =>
      'Vyhledávání receptů na základě přísad, které máte na ruce. Můžete také filtrovat pomocí nástrojů, které máte k dispozici, a nastavit maximální počet chybějících ingrediencí nebo nástrojů.';

  @override
  String get finderSelectedIngredients => 'Vybrané ingredience';

  @override
  String get finderNoIngredientsSelected => 'Nebyly vybrány žádné ingredience';

  @override
  String get finderMissing => 'Chybějící';

  @override
  String get finderNoRecipesFound => 'Nebyly nalezeny žádné recepty';

  @override
  String get finderNoRecipesFoundDescription =>
      'Zkuste do hledání přidat další ingredience nebo upravit své filtry';

  @override
  String get finderIncludeFoodsOnHand => 'Zahrnout ingredience jež k dispozici';

  @override
  String get finderIncludeToolsOnHand =>
      'Zahrnout nástroje, které máte po ruce';

  @override
  String get finderIncludeSubstitutions => 'Zahrnout náhrady';

  @override
  String get finderSubstituting => 'Nahrazuje';

  @override
  String finderSubstituteForFood(String substitute, String food) {
    return '$substitute místo $food';
  }

  @override
  String get finderMaxMissingIngredients =>
      'Maximální počet chybějících ingrediencí';

  @override
  String get finderMaxMissingTools => 'Maximální počet chybějících nástrojů';

  @override
  String get finderSelectedTools => 'Vybrané nástroje';

  @override
  String get finderReadyToMake => 'Připraveno';

  @override
  String get finderAlmostReadyToMake => 'Téměř připraveno';

  @override
  String get finderSettings => 'Nastavení';

  @override
  String get finderLoadingRecipes => 'Načítám recepty';

  @override
  String get finderClearSelection => 'Zrušit výběr';

  @override
  String get finderOfflineHint =>
      'Bez spojení se serverem – výsledky pocházejí z receptů uložených v tomto zařízení.';

  @override
  String get sendPeerOfflineHint =>
      'Teď nedostupné – dorazí, až se tam otevře aplikace';

  @override
  String sendDeliveredLater(String device) {
    return '„$device“ teď není dostupné. Recept dorazí, jakmile se tam otevře aplikace.';
  }

  @override
  String get sendQueuedOffline =>
      'Teď nejste připojeni. Recept se odešle automaticky, jakmile budete znovu online.';

  @override
  String get searchHasAll => 'Má všechny';

  @override
  String get searchHasAny => 'Má nějaké';

  @override
  String get recipeFilterTitle => 'Filtr';

  @override
  String get finderOtherFilters => 'Jiné filtry';

  @override
  String get qfOpEquals => 'rovno';

  @override
  String get qfOpNotEquals => 'není rovno';

  @override
  String get qfOpGreater => 'je větší než';

  @override
  String get qfOpGreaterEq => 'je větší než nebo rovno';

  @override
  String get qfOpLess => 'je menší než';

  @override
  String get qfOpLessEq => 'je menší než nebo rovno';

  @override
  String get qfOpNewerThan => 'je novější než';

  @override
  String get qfOpOlderThan => 'je starší než';

  @override
  String qfDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'před $count dny',
      many: 'před $count dne',
      few: 'před $count dny',
      one: 'před $count dnem',
    );
    return '$_temp0';
  }

  @override
  String get filterResetAll => 'Obnovit všechny filtry';

  @override
  String get filterAny => 'Libovolné';

  @override
  String get filterOfflineIgnored =>
      'Offline lze „Další filtry“ použít jen v jednoduché podobě.';

  @override
  String linkedRecipesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count propojených receptů',
      many: '$count propojeného receptu',
      few: '$count propojené recepty',
      one: '$count propojený recept',
      zero: 'Žádné propojené recepty',
    );
    return '$_temp0';
  }

  @override
  String get shoppingReminderNotificationsOff =>
      'Oznámení pro Mealie Recipes jsou vypnutá — bez nich se připomínka nákupu nezobrazí. Povolte oznámení v nastavení.';

  @override
  String get shoppingReminderInactiveHint =>
      'Připomínka nákupu teď nemůže fungovat: nastavte přístup k poloze na „Vždy“ a povolte oznámení.';

  @override
  String get bulkImportTitle => 'Hromadný import adres URL';

  @override
  String get bulkImportDescription =>
      'Hromadný import receptů vám umožní importovat více receptů najednou tím, že ve frontě stránek na podpůrné vrstvě bude spuštěn úkol na pozadí. To může být užitečné při počáteční migraci na Mealie, nebo když chcete importovat velké množství receptů.';

  @override
  String get bulkAddTitle => 'Hromadné přidání';

  @override
  String get bulkImportSetOrganizers => 'Nastavte kategorie a štítky';

  @override
  String get bulkImportStarted => 'Proces hromadného importu byl zahájen';

  @override
  String get bulkImportFailed => 'Proces hromadného importu se nezdařil';

  @override
  String get bulkImportReports => 'Hromadný import';

  @override
  String get bulkImportUrlHint => 'URL receptu';

  @override
  String get migrationsTitle => 'Přenos dat';

  @override
  String get migrationsDescription =>
      'Recepty lze do Mealie převést z jiné podporované aplikace. Je to skvělý způsob, jak s Mealie začít. Přesun dat mezi instancemi Mealie nebo obnovení starší zálohy Mealie se místo toho provádí nástroji pro zálohování a obnovu.';

  @override
  String get migrationNew => 'Nová migrace';

  @override
  String get migrationChooseType => 'Zvolte si typ migrace';

  @override
  String get noFileSelected => 'Nebyl vybrán žádný soubor';

  @override
  String migrationTagAll(String tag) {
    return 'Označit všechny recepty štítkem $tag';
  }

  @override
  String get migrationPrevious => 'Předchozí migrace';

  @override
  String get migrationMealieDescription =>
      'Mealie umí importovat recepty z aplikace Mealie ve verzi starší než v1.0. Exportujte recepty ze staré instance a nahrajte níže soubor zip. Z exportu lze importovat jen recepty. Platí jen pro instance starší než v1.0. Zálohu z v1.0 nebo novější obnovte nástroji pro zálohování a obnovu.';

  @override
  String get migrationChowdownDescription =>
      'Mealie nativně podporuje formát chowdown. Stáhněte si z repozitáře kód jako .zip soubor a nahrajte ho níže.';

  @override
  String get migrationCopyMeThatDescription =>
      'Mealie může importovat recepty z Copy Me That. Exportujte recepty v HTML formátu, poté nahrajte soubor ve formátu .zip.';

  @override
  String get migrationMyRecipeBoxDescription =>
      'Mealie může importovat recepty z My Recipe Box. Exportujte recepty ve formátu CSV, poté nahrajte soubor .zip níže.';

  @override
  String get migrationNextcloudDescription =>
      'Nextcloud recepty lze importovat ze souboru zip, který obsahuje data uložená v Nextcloudu. Podívejte se na příklad struktury složek níže, abyste se ujistili, že vaše recepty lze importovat.';

  @override
  String get migrationPaprikaDescription =>
      'Mealie může importovat recepty z aplikace Paprika. Exportujte své recepty z papriky, přejmenujte příponu exportovaného souboru na .zip a nahrajte jej níže.';

  @override
  String get migrationPlanToEatDescription =>
      'Mealie může importovat recepty z Plan to Eat.';

  @override
  String get migrationRecipeKeeperDescription =>
      'Mealie může importovat recepty z Recipe Keeper. Exportujte recepty v zip formátu, poté nahrajte .zip soubor níže.';

  @override
  String get migrationTandoorDescription =>
      'Mealie může importovat recepty z Tandoor. Exportujte data ve výchozím formátu, poté nahrajte soubor ve formátu .zip.';

  @override
  String get migrationCooknDescription =>
      'Mealie může importovat recept z DVO Cook\'n X3. Exportujte kuchařku nebo menu ve formátu \"Cook\'n\", přejmenujte rozšíření exportu na .zip, poté nahrajte .zip níže.';

  @override
  String get reportTitle => 'Nahlásit';

  @override
  String get recipeDataTitle => 'Data receptu';

  @override
  String get recipeDataDescription =>
      'Použijte tuto sekci pro správu dat spojených s vašimi recepty. Můžete provádět několik hromadných akcí na svých receptech, včetně exportu, mazání, označování a přiřazování kategorií.';

  @override
  String get recipeDataTagTitle => 'Oštítkovat recepty';

  @override
  String get recipeDataCategorizeTitle => 'Kategorizovat recepty';

  @override
  String get recipeDataSettingsTitle => 'Aktualizovat nastavení';

  @override
  String get recipeDataExportTitle => 'Exportovat recepty';

  @override
  String get recipeDataDeleteTitle => 'Smazat recepty';

  @override
  String recipeDataExportConfirm(int count) {
    return 'Budou exportovány následující recepty ($count).';
  }

  @override
  String get recipeDataExportsTitle => 'Export dat';

  @override
  String get recipeDataExportsDescription =>
      'Tato sekce poskytuje odkazy na dostupné exporty, které jsou připraveny ke stažení. Platnost těchto exportů vyprší, takže je určitě využijte, dokud jsou ještě k dispozici.';

  @override
  String get recipeDataPurgeExports => 'Vymazat exporty';

  @override
  String get recipeDataPurgeConfirm =>
      'Jste si jisti, že chcete odstranit všechna data exportu?';

  @override
  String get recipeActionsTitle => 'Akce receptu';

  @override
  String get recipeActionNew => 'Nová akce receptu';

  @override
  String get recipeActionEdit => 'Upravit akci receptu';

  @override
  String get recipeActionTypeLink => 'Odkaz';

  @override
  String get recipeActionTypePost => 'Publikovat';

  @override
  String get webhooksTitle => 'Webhooky';

  @override
  String get webhooksDescription =>
      'Webhooks definované níže budou vykonány, když bude pro daný den definováno jídlo. V plánovaném čase budou webhooks odeslány s daty z receptu, který je naplánován na daný den. Vezměte prosím na vědomí, že vykonání webhooku není přesné. Webhooks jsou vykonávány v intervalech po 5 minutách, takže budou vykonány v rozmezí 5 +/- minut od plánovaného času.';

  @override
  String get webhookName => 'Název webhooku';

  @override
  String get webhookUrl => 'URL webhooku';

  @override
  String get notifiersTitle => 'Oznámení';

  @override
  String get notifiersDescription =>
      'Nastavte e-mailová a push oznámení, která se spustí při konkrétních událostech.';

  @override
  String get notifierNew => 'Nové oznámení';

  @override
  String get notifierDescription =>
      'Mealie používá knihovnu Apprise pro generování oznámení. Nabízí spousty služeb pro zasílání oznámení. Podívejte se do jejich wiki pro komplexní návod jak vytvářet URL pro vaši službu. Výběr typu oznámení může obsahovat další extra funkce.';

  @override
  String get notifierAppriseUrl => 'URL Apprise';

  @override
  String get notifierAppriseUrlSkipped =>
      'Apprise URL (přeskočeno pokud je prázdné)';

  @override
  String get notifierAppriseUrlBlankHint =>
      'Jelikož adresa URL obvykle obsahuje citlivé informace, zůstává toto pole při úpravách záměrně prázdné. Zadejte novou adresu URL, chcete-li ji změnit. V opačném případě ponechejte pole prázdné.';

  @override
  String get notifierEnable => 'Povolit notifikaci';

  @override
  String get notifierWhatEvents =>
      'K jakým událostem by se měl tento oznamovatel přihlásit?';

  @override
  String get notifierRecipeEvents => 'Události receptu';

  @override
  String get notifierUserEvents => 'Uživatelské události';

  @override
  String get notifierMealplanEvents => 'Události jídelního plánu';

  @override
  String get notifierShoppingListEvents => 'Události nákupního seznamu';

  @override
  String get notifierCookbookEvents => 'Události kuchařky';

  @override
  String get notifierTagEvents => 'Události tagu';

  @override
  String get notifierCategoryEvents => 'Události kategorie';

  @override
  String get notifierLabelEvents => 'Události popisků';

  @override
  String get notifierUserSignup =>
      'Když se nový uživatel připojí do vaší skupiny';

  @override
  String get notifierCreate => 'Vytvořit';

  @override
  String get notifierUpdate => 'Aktualizovat';

  @override
  String get notifierDelete => 'Smazat';

  @override
  String get notifierTestSent => 'Testovací zpráva odeslána';

  @override
  String get adminTitle => 'Nastavení Správce';

  @override
  String get backupsTitle => 'Zálohy';

  @override
  String get backupsDescription =>
      'Zálohy jsou celkové snímky databáze a datového adresáře webu. Tato položka zahrnuje všechny údaje a nelze ji nastavit pro vyloučení podsouborů údajů. Můžete ji brát jako snímek Mealie v určitém čase. Tyto slouží jako způsob, jak nezávisle na databázi exportovat a importovat data nebo zálohovat stránky na externí umístění.';

  @override
  String get backupCreateHeading => 'Vytvořit zálohy';

  @override
  String get backupCreated => 'Záloha byla úspěšně vytvořena';

  @override
  String get backupCreateFailed => 'Chyba při vytváření zálohy. Viz log soubor';

  @override
  String get backupDelete => 'Smazat zálohu';

  @override
  String get backupDeleted => 'Záloha smazána';

  @override
  String get backupRestore => 'Obnovit zálohu';

  @override
  String get backupRestoreDescription =>
      'Obnovení této zálohy přepíše všechna současná data v databázi a v datovém adresáři obsahem zálohy. Pokud obnovení proběhne úspěšně, budete odhlášeni.';

  @override
  String get backupCannotBeUndone =>
      'Tuto akci nelze vrátit zpět - používejte ji s opatrností.';

  @override
  String get backupAcknowledge =>
      'Beru na vědomí, že tato akce je nevratná, destruktivní a může způsobit ztrátu dat';

  @override
  String get backupRestoreSuccess => 'Obnovení bylo úspěšné';

  @override
  String get backupRestoreFailed =>
      'Obnovení se nezdařilo. Pro více informací zkontrolujte protokoly serveru';

  @override
  String get maintenanceTitle => 'Údržba';

  @override
  String get maintenanceSummary => 'Souhrn';

  @override
  String get maintenanceStorage => 'Podrobnosti o úložišti';

  @override
  String get maintenanceDataDirSize => 'Velikost adresáře s daty';

  @override
  String get maintenanceCleanableDirs => 'Čistitelné složky';

  @override
  String get maintenanceCleanableImages => 'Čistitelné obrázky';

  @override
  String get maintenanceTempDir => 'Dočasný adresář (.temp)';

  @override
  String get maintenanceBackupsDir => 'Adresář záloh (backups)';

  @override
  String get maintenanceGroupsDir => 'Adresář skupin (groups)';

  @override
  String get maintenanceRecipesDir => 'Adresář receptů (recipes)';

  @override
  String get maintenanceUserDir => 'Adresář uživatelů (users)';

  @override
  String get maintenanceCleanDirs => 'Vyčistit adresáře';

  @override
  String get maintenanceCleanDirsDescription =>
      'Odstraní všechny složky receptů, které nejsou platné UUID';

  @override
  String get maintenanceCleanTemp => 'Vymazat dočasné soubory';

  @override
  String get maintenanceCleanTempDescription =>
      'Odstraní všechny soubory a složky v adresáři .temp';

  @override
  String get maintenanceCleanImages => 'Vymazat obrázky';

  @override
  String get maintenanceCleanImagesDescription =>
      'Odstraní všechny obrázky, které nekončí .webp';

  @override
  String get maintenanceActions => 'Akce';

  @override
  String get adminConfiguration => 'Konfigurace';

  @override
  String get adminAppVersion => 'Verze aplikace';

  @override
  String get adminUpToDate => 'Mealie je aktuální';

  @override
  String adminVersionOutdated(String current, String latest) {
    return 'Vaše současná verze ($current) neodpovídá poslednímu vydání. Zvažte aktualizaci na nejnovější verzi ($latest).';
  }

  @override
  String get adminBaseUrl => 'Výchozí URL adresa serveru';

  @override
  String get adminBaseUrlOk =>
      'Adresa URL na straně serveru neodpovídá výchozímu nastavení';

  @override
  String get adminBaseUrlError =>
      '`BASE_URL` je stále výchozí hodnotou na serveru API. To způsobí problémy s odkazy v oznámení generované na serveru pro e-maily atd.';

  @override
  String adminAuthReady(String provider) {
    return '$provider připraven';
  }

  @override
  String adminAuthNotReady(String provider) {
    return '$provider není připraven';
  }

  @override
  String adminAuthDisabled(String provider) {
    return '$provider zakázán';
  }

  @override
  String adminAuthSuccessText(String provider) {
    return 'Všechny požadované proměnné $provider jsou nastaveny.';
  }

  @override
  String adminAuthErrorText(String provider) {
    return 'Ne všechny hodnoty $provider jsou nakonfigurovány. Toto může být ignorováno, pokud nepoužíváte ověřování $provider.';
  }

  @override
  String adminAuthDisabledText(String envVar) {
    return 'Pro povolení nastavte $envVar na true.';
  }

  @override
  String get adminEmailStatus => 'Stav konfigurace e-mailu';

  @override
  String get adminEmailConfigured => 'Email nastaven';

  @override
  String get adminNotReady => 'Nepřipraveno - zkontrolujte proměnné prostředí';

  @override
  String get adminSucceeded => 'Proběhlo úspěšně';

  @override
  String get adminFailed => 'Nezdařilo se';

  @override
  String get adminSiteStatistics => 'Statistiky stránky';

  @override
  String get adminUncategorized => 'Nekategorizované recepty';

  @override
  String get adminUntagged => 'Recepty bez štítků';

  @override
  String get adminGeneralAbout => 'Obecné informace';

  @override
  String get adminVersion => 'Verze';

  @override
  String get adminBuild => 'Sestavení';

  @override
  String get adminApplicationMode => 'Režim aplikace';

  @override
  String get adminProduction => 'Produkce';

  @override
  String get adminDevelopment => 'Vývoj';

  @override
  String get adminDemoStatus => 'Stav dema';

  @override
  String get adminDemo => 'Demo';

  @override
  String get adminNotDemo => 'Není demo';

  @override
  String get adminApiPort => 'Port API';

  @override
  String get adminApiDocs => 'Dokumentace API';

  @override
  String get adminDatabaseType => 'Typ databáze';

  @override
  String get adminDatabaseUrl => 'URL databáze';

  @override
  String get adminDefaultGroup => 'Výchozí skupina';

  @override
  String get adminDefaultHousehold => 'Výchozí domácnost';

  @override
  String get adminScraperVersion => 'Verze scraperu receptů';

  @override
  String get adminStatUsers => 'Uživatelé';

  @override
  String get adminStatHouseholds => 'Domácnosti';

  @override
  String get adminStatGroups => 'Skupiny';

  @override
  String get recipeDuplicate => 'Duplikovat recept';

  @override
  String get recipeDuplicateAction => 'Duplikovat';

  @override
  String get recipeShareLink => 'Sdílet recept';

  @override
  String get recipeShareExpiration => 'Datum vypršení';

  @override
  String get recipeShareCopied => 'Odkaz na recept byl zkopírován do schránky';

  @override
  String get enabledLabel => 'Povoleno';

  @override
  String get disabledLabel => 'Deaktivováno';

  @override
  String get testAction => 'Otestovat';

  @override
  String get yesLabel => 'Ano';

  @override
  String get noLabel => 'Ne';

  @override
  String get downloadAction => 'Stáhnout';

  @override
  String get backupUpload => 'Nahrát';

  @override
  String get zipImportButton => 'Importovat ze zipu';

  @override
  String get zipImportDescription =>
      'Importovat jeden recept, který byl exportován z jiné instance Mealie.';

  @override
  String get reportStatus => 'Stav';

  @override
  String get reportDate => 'Datum';

  @override
  String get recipeActionTitleLabel => 'Název';

  @override
  String get clearAll => 'Vymazat';

  @override
  String get recipeDataSettingsExplanation =>
      'Zde zvolena nastavení, s výjimkou uzamčené možnosti, se použijí na všechny vybrané recepty.';

  @override
  String get adminAllowSignup => 'Povolit registraci';

  @override
  String get adminAllowPasswordLogin => 'Povolit přihlášení heslem';

  @override
  String get adminEmailInvalid => 'Zadejte platnou e-mailovou adresu.';

  @override
  String adminEmailTestResult(String result) {
    return 'Test e-mailu: $result';
  }

  @override
  String get adminSendTestEmail => 'Odeslat testovací e-mail';

  @override
  String get adminTestEmailAddress => 'Příjemce';

  @override
  String get backupCreate => 'Vytvořit zálohu';

  @override
  String backupDeleteConfirm(String name) {
    return 'Smazat zálohu „$name“?';
  }

  @override
  String get backupPostgresNote =>
      'Pokud používáte PostgreSQL, před obnovením si přečtěte postup zálohování/obnovy v dokumentaci Mealie.';

  @override
  String get backupUploaded => 'Záloha nahrána';

  @override
  String get backupsEmpty => 'Zatím žádné zálohy.';

  @override
  String get bulkImportAddRow => 'Přidat URL';

  @override
  String get bulkImportStart => 'Spustit import';

  @override
  String get chooseFileButton => 'Vybrat soubor';

  @override
  String get deselectAllAction => 'Zrušit výběr';

  @override
  String get downloadFailed => 'Stažení se nezdařilo';

  @override
  String get fileSaved => 'Soubor uložen';

  @override
  String get loadFailed => 'Nelze načíst';

  @override
  String get maintenanceActionsWarning =>
      'Údržbové akce jsou destruktivní a měly by se používat opatrně. Provedení kterékoli z nich je nevratné.';

  @override
  String get maintenanceConfirm =>
      'Tato akce je destruktivní a nelze ji vrátit. Pokračovat?';

  @override
  String get maintenanceDone => 'Hotovo';

  @override
  String get maintenanceFailed => 'Údržbová akce se nezdařila';

  @override
  String get maintenanceRun => 'Spustit';

  @override
  String get migrationFailed => 'Migrace se nezdařila';

  @override
  String get migrationStart => 'Spustit migraci';

  @override
  String get migrationStarted => 'Migrace dokončena — viz zprávu níže.';

  @override
  String get moreImportOptions => 'Další možnosti importu';

  @override
  String notifierDeleteConfirm(String name) {
    return 'Smazat oznamovatel „$name“?';
  }

  @override
  String get notifierEdit => 'Upravit oznamovatel';

  @override
  String notifierEventCount(int count) {
    return 'Události: $count';
  }

  @override
  String get notifierTestFailed => 'Testovací zprávu se nepodařilo odeslat';

  @override
  String get notifiersEmpty => 'Zatím žádné oznamovatele.';

  @override
  String recipeActionDeleteConfirm(String name) {
    return 'Smazat akci receptu „$name“?';
  }

  @override
  String get recipeActionFailed => 'Akce receptu se nezdařila';

  @override
  String get recipeActionSent => 'Recept odeslán';

  @override
  String get recipeActionUrlHint => 'Zástupné symboly';

  @override
  String get recipeActionsDescription =>
      'Akce receptů se zobrazují v nabídce každého receptu. „Odkaz“ otevře URL, „Post“ nechá server Mealie odeslat recept na URL.';

  @override
  String get recipeActionsEmpty => 'Zatím žádné akce receptů.';

  @override
  String recipeDataDeleteConfirm(int count) {
    return 'Smazat vybrané recepty ($count)? Tuto akci nelze vrátit.';
  }

  @override
  String recipeDataDeleteForbidden(int count) {
    return '$count z vybraných receptů smazat nesmíte (může jen jejich autor nebo správce).';
  }

  @override
  String recipeDataDeleted(int count) {
    return 'Smazané recepty: $count';
  }

  @override
  String get recipeDataExportAction => 'Exportovat';

  @override
  String get recipeDataExportDone =>
      'Export vytvořen — stáhněte ho v Exportech dat.';

  @override
  String recipeDataExportExpires(String date) {
    return 'vyprší $date';
  }

  @override
  String get recipeDataExportFailed => 'Export se nezdařil';

  @override
  String get recipeDataExportsEmpty => 'Žádné exporty nejsou k dispozici.';

  @override
  String recipeDataUpdated(int count) {
    return 'Aktualizované recepty: $count';
  }

  @override
  String get recipeDuplicated => 'Recept duplikován';

  @override
  String get recipeExportJson => 'Exportovat jako JSON';

  @override
  String get recipeExportZip => 'Exportovat jako ZIP (s obrázkem)';

  @override
  String get recipeShareCreate => 'Vytvořit odkaz';

  @override
  String get recipeShareDescription =>
      'Kdokoli s odkazem si může recept prohlédnout v prohlížeči — bez účtu — dokud odkaz nevyprší.';

  @override
  String get recipeShareEmpty => 'Zatím žádné odkazy ke sdílení.';

  @override
  String recipeShareExpiresAt(String date) {
    return 'Vyprší $date';
  }

  @override
  String get recipeWebToolsMenu => 'Duplikovat, odkaz ke sdílení a další';

  @override
  String get reload => 'Znovu načíst';

  @override
  String get reportDeleteConfirm => 'Smazat tuto zprávu?';

  @override
  String get reportEntries => 'Záznamy';

  @override
  String get reportFailedEntries => 'Nezdařilo se';

  @override
  String get reportOnlyFailed => 'Zobrazit jen neúspěšné záznamy';

  @override
  String get reportStatusFailure => 'Chyba';

  @override
  String get reportStatusInProgress => 'Probíhá';

  @override
  String get reportStatusPartial => 'Částečně';

  @override
  String get reportStatusSuccess => 'Úspěch';

  @override
  String get reportsEmpty => 'Zatím žádné zprávy.';

  @override
  String get uploadFailed => 'Nahrání se nezdařilo';

  @override
  String webhookDeleteConfirm(String name) {
    return 'Smazat webhook „$name“?';
  }

  @override
  String get webhookEdit => 'Upravit webhook';

  @override
  String get webhookNew => 'Nový webhook';

  @override
  String get webhookTestFailed => 'Test se nepodařilo spustit';

  @override
  String get webhookTestSent => 'Testovací webhook spuštěn';

  @override
  String get webhookTime => 'Čas (místní)';

  @override
  String get webhooksEmpty => 'Zatím žádné webhooky.';

  @override
  String get zipImportFailed => 'Import ZIP se nezdařil';

  @override
  String get aiProvidersTitle => 'AI provideři';

  @override
  String get aiProvidersDescription =>
      'Konfigurujte AI poskytovatele pro povolení funkcí poháněných AI, jako je vylepšení analyzování ingrediencí, vytváření receptů z videí a dalších!';

  @override
  String get aiProviderSettingsTitle => 'Nastavení AI providera';

  @override
  String get aiProvidersList => 'Provideři';

  @override
  String get aiProviderCreate => 'Vytvořit providera';

  @override
  String get aiProviderEdit => 'Upravit providera';

  @override
  String get aiDefaultProvider => 'Výchozí provider';

  @override
  String get aiDefaultProviderDescription =>
      'Požadováno pro povolení AI funkcí';

  @override
  String get aiAudioProvider => 'Audio provider';

  @override
  String get aiAudioProviderDescription =>
      'Povoluje funkce přepisu audia jako vytváření receptů z videí';

  @override
  String get aiImageProvider => 'Provider obrázků';

  @override
  String get aiImageProviderDescription =>
      'Povolit funkce rozpoznávání obrázků jako vytváření receptů z obrázků';

  @override
  String get aiProviderName => 'Název providera';

  @override
  String get aiApiKey => 'Klíč API';

  @override
  String get aiApiKeyCreateDescription =>
      'API klíč vašeho providera pro ověření. Pokud vaše služba (např. Ollama) nepoužívá API klíč, stále je potřeba sem něco vložit.';

  @override
  String get aiApiKeyEditDescription => 'Vyplňte pouze pokud chcete změnit.';

  @override
  String get aiBaseUrl => 'Výchozí URL';

  @override
  String get aiBaseUrlDescription =>
      'Pokud používáte OpenAI, nechte toto prázdné. Musí být koncový bod kompatibilní s OpenAI (např. \"http://localhost:11434/v1\").';

  @override
  String get aiModel => 'Model';

  @override
  String get aiModelDescription =>
      'Jaký model by měl váš AI provider použít (např. \"gpt-5\").';

  @override
  String get aiTimeout => 'Platnost požadavku (sekundy)';

  @override
  String get aiProviderCreated => 'Provider vytvořen';

  @override
  String get aiProviderUpdated => 'Provider aktualizován';

  @override
  String get aiProviderDeleted => 'Provider odstraněn';

  @override
  String get aiProviderCreateFailed => 'Vytvoření providera se nezdařilo';

  @override
  String get aiProviderUpdateFailed => 'Aktualizace providera se nezdařila';

  @override
  String get aiProviderDeleteFailed => 'Odstranění providera se nezdařilo';

  @override
  String get aiRequestHeaders => 'Hlavičky požadavků';

  @override
  String get aiRequestParams => 'Parametry požadavků';

  @override
  String get aiNoDefaultWarning =>
      'Nezvolili jste výchozího providera, AI funkce jsou zakázané';

  @override
  String get aiTestConnection => 'Test připojení';

  @override
  String get aiTestSucceeded => 'Připojení se povedlo';

  @override
  String get aiTestFailed => 'Připojení selhalo';

  @override
  String get aiSupportsImages => 'Podporuje obrázky';

  @override
  String get aiTextOnly =>
      'Pouze text, nemůže být vaším poskytovatelem obrázků';

  @override
  String get debugAiTitle => 'Ladění poskytovatelů AI';

  @override
  String get debugAiDescription =>
      'Na této stránce můžete ladit poskytovatele AI: otestovat připojení k AI a zobrazit výsledky. Máte-li zapnuté služby pro obrázky, můžete zadat i obrázek.';

  @override
  String get debugParserTitle => 'Analyzátor';

  @override
  String get debugParserDescription =>
      'Mealie používá podmíněná náhodná pole (CRF) pro rozbor a zpracování ingrediencí. Model používaný pro ingredience je založen na datovém souboru s více než 100 000 ingrediencemi sestaveného New York Times. Vzhledem k tomu, že model je natrénován pouze v angličtině, můžete mít při používání variabilní výsledky. Tato stránka slouží jako hřiště pro testování tohoto modelu.';

  @override
  String get debugIngredientText => 'Text přísady';

  @override
  String get debugTryExample => 'Vyzkoušejte příklad';

  @override
  String debugAverageConfidence(String value) {
    return 'Jistota $value';
  }

  @override
  String get debugRunTest => 'Spustit test';

  @override
  String get debugQuantity => 'Množství';

  @override
  String get debugUnit => 'Jednotka';

  @override
  String get debugFood => 'Jídlo';

  @override
  String get debugNote => 'Komentář';

  @override
  String get debugGroup => 'Skupina';

  @override
  String get aiProviderNone => 'Žádný';

  @override
  String aiProviderDeleteConfirm(String name) {
    return 'Smazat poskytovatele „$name“?';
  }

  @override
  String get aiProvidersEmpty => 'Zatím žádní poskytovatelé AI.';

  @override
  String get aiAdvanced => 'Pokročilé';

  @override
  String get aiKeyLabel => 'Název';

  @override
  String get aiValueLabel => 'Hodnota';

  @override
  String get debugTitle => 'Ladit';

  @override
  String get debugParse => 'Analyzovat';

  @override
  String get debugParseFailed => 'Ingredienci se nepodařilo analyzovat';

  @override
  String get debugChooseImage => 'Vybrat obrázek';

  @override
  String get debugNoImage => 'Bez obrázku (volitelné)';

  @override
  String get updateTitle => 'Hledat aktualizace';

  @override
  String get updateInstalledVersion => 'Nainstalovaná verze';

  @override
  String get updateLastCheck => 'Poslední kontrola';

  @override
  String get updateCheckNow => 'Zkontrolovat nyní';

  @override
  String get updateChecking => 'Hledání aktualizací…';

  @override
  String get updateUpToDate => 'Mealie Recipes je aktuální.';

  @override
  String updateAvailable(String version) {
    return 'Je dostupná verze $version';
  }

  @override
  String get updateAvailableDescription =>
      'Je dostupná nová verze Mealie Recipes. Nic se nenainstaluje, dokud aktualizaci sami nespustíte.';

  @override
  String get updateShow => 'Zobrazit aktualizaci';

  @override
  String get updateLater => 'Později';

  @override
  String updateDownloading(int percent) {
    return 'Stahování … $percent %';
  }

  @override
  String updateReady(String version) {
    return 'Verze $version je připravena k instalaci';
  }

  @override
  String get updateInstalling =>
      'Instalace — aplikace se automaticky restartuje …';

  @override
  String get updateManual =>
      'Aktualizaci se nepodařilo nainstalovat automaticky. Obraz disku byl otevřen: přetáhněte Mealie Recipes do Aplikací.';

  @override
  String get updateFailed => 'Aktualizace se nezdařila';

  @override
  String get updateInstallNow => 'Stáhnout a nainstalovat';

  @override
  String get updateRestartNow => 'Nainstalovat a restartovat';

  @override
  String get updateAutoTitle => 'Hledat aktualizace při spuštění';

  @override
  String get updateAutoDescription =>
      'Jen zkontroluje a upozorní vás — instalaci vždy spouštíte sami.';

  @override
  String get updateBetaTitle => 'Dostávat beta verze';

  @override
  String get updateBetaDescription =>
      'Nabízí i předběžné verze k testování. Mohou ještě obsahovat chyby.';

  @override
  String get updateNoNotes => 'Žádné poznámky k vydání.';

  @override
  String get updateSourceHint =>
      'Aktualizace pocházejí z vydání Mealie Recipes na GitHubu a instalují se jen tehdy, jsou-li podepsány vývojářem (macOS).';

  @override
  String get errorNoConnection =>
      'Server Mealie není dostupný. Zkontrolujte připojení k internetu a adresu serveru.';

  @override
  String get errorTimeout => 'Server odpovídal příliš dlouho. Zkuste to znovu.';

  @override
  String get errorUnauthorized =>
      'Vaše přihlášení vypršelo nebo API token už není platný. Přihlaste se znovu v nastavení.';

  @override
  String get errorServer => 'Server Mealie ohlásil chybu. Zkuste to později.';

  @override
  String get errorNotFound => 'Na serveru nenalezeno — možná bylo smazáno.';

  @override
  String get errorCertificate =>
      'Bezpečnostní certifikát serveru není důvěryhodný.';

  @override
  String get errorGeneric => 'Něco se pokazilo. Zkuste to znovu.';

  @override
  String get offlineLabel => 'Offline';

  @override
  String offlineSince(String time) {
    return 'Offline · naposledy synchronizováno $time';
  }

  @override
  String get mealplanEntryActions => 'Možnosti jídla';

  @override
  String get mealplanMoveAction => 'Přesunout';

  @override
  String get mealplanMoveTitle => 'Přesunout jídlo';

  @override
  String get mealplanMoveDate => 'Datum';

  @override
  String mealplanMovedTo(String date) {
    return 'Přesunuto na $date';
  }

  @override
  String get mealplanShowWeek => 'Zobrazit';

  @override
  String get mealplanMoveFailed => 'Jídlo se nepodařilo přesunout';

  @override
  String get recentlyViewedTitle => 'Nedávno zobrazené';

  @override
  String get recentlyViewedEmpty => 'Zde se objeví recepty, které otevřete.';

  @override
  String get recentlyViewedClear => 'Vymazat historii';

  @override
  String get recentlyViewedClearMessage =>
      'Seznam nedávno zobrazených receptů v tomto zařízení bude vymazán. Samotné recepty zůstanou.';

  @override
  String get recentlyViewedClearConfirm => 'Vymazat';

  @override
  String get duplicatesTitle => 'Hledání duplicit';

  @override
  String get duplicatesScanning => 'Hledání duplicitních receptů…';

  @override
  String get duplicatesNone => 'Nenalezeny žádné duplicitní recepty.';

  @override
  String duplicatesFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Nalezeno $count možných duplicit.',
      many: 'Nalezeno $count možné duplicity.',
      few: 'Nalezeny $count možné duplicity.',
      one: 'Nalezena $count možná duplicita.',
    );
    return '$_temp0';
  }

  @override
  String get duplicatesIntro =>
      'Klepněte na recept, který má zůstat, a pak slučte.';

  @override
  String get duplicatesReasonSource => 'Stejný zdroj';

  @override
  String get duplicatesReasonName => 'Stejný název';

  @override
  String duplicatesReasonSimilar(int percent) {
    return 'Podobné · $percent % stejných ingrediencí';
  }

  @override
  String get duplicatesKeeps => 'Zůstane';

  @override
  String get duplicatesWillBeDeleted => 'Bude smazán';

  @override
  String get duplicatesMerge => 'Sloučit';

  @override
  String get duplicatesNotDuplicate => 'Není duplicita';

  @override
  String get duplicatesMergeTitle => 'Sloučit recepty?';

  @override
  String duplicatesMergeMessage(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dalších receptů bude smazáno',
      many: '$count dalšího receptu bude smazáno',
      few: '$count další recepty budou smazány',
      one: '$count další recept bude smazán',
    );
    return '„$name“ zůstane. $_temp0.\n\nKategorie, štítky, nástroje, poznámky, naplánovaná jídla vaší domácnosti a vaše oblíbené se přenesou. Komentáře, časová osa a přílohy smazaných receptů se ztratí.';
  }

  @override
  String get duplicatesMerged => 'Recepty sloučeny';

  @override
  String duplicatesIngredientCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ingrediencí',
      many: '$count ingredience',
      few: '$count ingredience',
      one: '$count ingredience',
    );
    return '$_temp0';
  }

  @override
  String duplicatesResetIgnored(int count) {
    return 'Znovu zobrazit skryté páry ($count)';
  }

  @override
  String get duplicatesRescan => 'Hledat znovu';

  @override
  String get duplicatesOpenRecipe => 'Otevřít recept';

  @override
  String get duplicatesMergeNoEditHint =>
      'Recept, který zůstává, nesmíte upravit (cizí zamčený recept nebo z jiné domácnosti). Jeho kategorie, štítky, nástroje a poznámky proto zůstanou beze změny; přenesou se jen naplánovaná jídla a vaše oblíbené.';

  @override
  String get recipeOtherHouseholdHint =>
      'Z jiné domácnosti – úpravy jsou tam zamčené';

  @override
  String foodsSavedAsNote(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nových potravin zůstalo',
      many: '$count nové potraviny zůstalo',
      few: '$count nové potraviny zůstaly',
      one: '$count nová potravina zůstala',
    );
    return 'Uloženo. $_temp0 jako poznámka k ingredienci – vytváření potravin vyžaduje v Mealie oprávnění „Uživatel může spravovat potraviny, štítky a kategorie“.';
  }

  @override
  String get a11yRemove => 'Odebrat';

  @override
  String get a11yDecrease => 'Méně';

  @override
  String get a11yIncrease => 'Více';

  @override
  String get a11yShowPassword => 'Zobrazit heslo';

  @override
  String get a11yHidePassword => 'Skrýt heslo';

  @override
  String get a11yClearSearch => 'Vymazat hledání';

  @override
  String get notesQueuedOffline =>
      'Offline – poznámka se odešle, jakmile bude server znovu dostupný.';

  @override
  String get timelineQueuedOffline =>
      'Offline – přidá se na časovou osu, jakmile bude server znovu dostupný.';

  @override
  String get syncSectionName => 'Přejmenované';

  @override
  String get pendingRecipesDiscard => 'Zahodit';

  @override
  String get undo => 'Zpět';

  @override
  String timerStoppedSnack(String name) {
    return 'Časovač „$name“ zastaven';
  }

  @override
  String get cookFriendsEndConfirm =>
      'Ukončit relaci pro všechny? Všichni hosté budou odpojeni.';

  @override
  String get weekStartSyncHint =>
      'Uloženo v Mealie – platí pro celou vaši domácnost, i ve webové aplikaci.';

  @override
  String get weekStartNoPermission =>
      'Nastavuje vaše domácnost v Mealie. Změnit to mohou jen členové, kteří smějí spravovat domácnost.';

  @override
  String get assetsUnsupported329 =>
      'Mealie podporuje PDF, obrázky, videa (MP4, MOV, WebM), zvuk (MP3, M4A), Word/ODT/RTF, TXT, MD, CSV a JSON.';

  @override
  String get assetsRecordVideo => 'Nahrát video';

  @override
  String get assetsChooseVideo => 'Vybrat video';

  @override
  String get shoppingSearchHint => 'Hledat v tomto seznamu';

  @override
  String get shoppingSearchNoMatches => 'Hledání neodpovídají žádné položky.';

  @override
  String get mealplanServingsTitle => 'Plánované porce';

  @override
  String get mealplanServingsHint =>
      'Jen pro tento záznam jídelníčku — samotný recept zůstane beze změny. Při otevření receptu a přidání do nákupního seznamu se použijí tyto porce.';

  @override
  String get calendarFeedTitle => 'Odebírat kalendář';

  @override
  String get calendarFeedSubtitle =>
      'Zobrazit jídelníček v Googlu, Applu nebo jiném kalendáři';

  @override
  String get calendarFeedDescription =>
      'Odebírejte jídelníček své domácnosti v Kalendáři Google, Kalendáři Apple, Home Assistantu nebo jiné aplikaci s podporou odkazů iCal. Kdokoli s odkazem uvidí váš jídelníček.';

  @override
  String get calendarFeedOff =>
      'Odkaz na kalendář je pro vaši domácnost vypnut.';

  @override
  String get calendarFeedAskManager =>
      'Požádejte někoho, kdo může spravovat vaši domácnost, aby ji zapnul.';

  @override
  String get calendarFeedTurnOn => 'Zapnout';

  @override
  String get calendarFeedTurnOff => 'Vypnout';

  @override
  String get calendarFeedReset => 'Obnovit odkaz';

  @override
  String get calendarFeedResetHint =>
      'Obnovení nebo vypnutí propojení zastaví aktualizace připojených kalendářů.';

  @override
  String get calendarFeedIncludeNotes => 'Zahrnout poznámky';

  @override
  String get calendarFeedTimesHint =>
      'Klepnutím na jídlo nastavíte jeho čas. Jídla bez času se zobrazí jako celodenní události.';

  @override
  String get calendarFeedMealTypes => 'Druh Jídla';

  @override
  String get calendarFeedSubscribe => 'Odebírat v kalendáři';

  @override
  String get calendarFeedNoApp =>
      'Nepodařilo se otevřít aplikaci kalendáře. Zkopírujte odkaz a přidejte ho do kalendáře jako odběr.';

  @override
  String get calendarFeedPublicHint =>
      'Odkaz funguje bez přihlášení — sdílejte ho jen s lidmi, kteří smějí vidět váš jídelníček.';

  @override
  String get recipeShareLinkMenu => 'Odkaz ke sdílení a QR kód';

  @override
  String get recipeShareShowQr => 'Zobrazit QR kód';

  @override
  String get recipeShareScanQr =>
      'Naskenujte fotoaparátem telefonu a otevřete tento recept';

  @override
  String get recipeShareQrShare => 'Sdílet obrázek';

  @override
  String get recipeShareQrFailed => 'Obrázek QR kódu se nepodařilo vytvořit';

  @override
  String get mealplanSettingsTitle => 'Nastavení jídelníčku';

  @override
  String get mealDiceRulesTitle => 'Pravidla kostky';

  @override
  String saveAsNewFood(String name) {
    return 'Uložit „$name“ jako novou potravinu';
  }

  @override
  String get shoppingMoreOptions => 'Více možností';

  @override
  String get shoppingFewerOptions => 'Méně možností';

  @override
  String nameAlreadyExists(String name) {
    return 'Již existuje: $name';
  }

  @override
  String aliasBelongsTo(String alias, String name) {
    return '„$alias“ už patří k „$name“ — raději je slučte.';
  }

  @override
  String get recipeMatchTitle => 'Recipe Match';

  @override
  String get recipeMatchShuffle => 'Zamíchat';

  @override
  String recipeMatchCardsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count receptů v balíčku',
      many: '$count receptu v balíčku',
      few: '$count recepty v balíčku',
      one: '$count recept v balíčku',
    );
    return '$_temp0';
  }

  @override
  String get recipeMatchNext => 'Další';

  @override
  String get recipeMatchKeep => 'Na tác';

  @override
  String get recipeMatchKept => 'Položeno na tác';

  @override
  String get recipeMatchAnyTime => 'Libovolná doba';

  @override
  String recipeMatchMaxTime(int minutes) {
    return '≤ $minutes min';
  }

  @override
  String get recipeMatchEmpty => 'Žádné odpovídající recepty';

  @override
  String get recipeMatchEmptyHint => 'Změňte filtry nebo vyprázdněte tác.';

  @override
  String get recipeMatchResetFilters => 'Obnovit filtry';

  @override
  String get recipeMatchFlipHint => 'Klepněte: ingredience · postup';

  @override
  String get recipeMatchFlipBack => 'Otočit zpět';

  @override
  String get recipeMatchOpenRecipe => 'Celý recept';

  @override
  String get recipeMatchOnHand => 'k dispozici';

  @override
  String get recipeMatchTray => 'Tác';

  @override
  String get recipeMatchTrayEmpty => 'Zatím prázdný – stáhněte kartu dolů';

  @override
  String recipeMatchTrayCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count receptů',
      many: '$count receptu',
      few: '$count recepty',
      one: '$count recept',
    );
    return '$_temp0';
  }

  @override
  String get recipeMatchClear => 'Vymazat';

  @override
  String get recipeMatchTrayHint =>
      'Zůstane, dokud ho nevyprázdníte – i když balíček zavřete.';

  @override
  String get recipeMatchRemove => 'Odebrat z tácu';

  @override
  String get recipeMatchToMealplan => 'Přidat do jídelníčku';

  @override
  String get recipeMatchToShopping => 'Ingredience do nákupního seznamu';

  @override
  String get recipeMatchSelectIngredients => 'Vybrat ingredience';

  @override
  String get recipeMatchNoList => 'Nejprve vyberte nákupní seznam.';

  @override
  String get recipeMatchList => 'Seznam';

  @override
  String get recipeMatchOnHandHint => 'Dostupné ingredience jsou už odznačené.';

  @override
  String recipeMatchAddCount(int selected, int total) {
    return 'Přidat $selected z $total ingrediencí';
  }

  @override
  String get recipeMatchNoDay => 'Zatím bez dne – zůstává na tácu';

  @override
  String recipeMatchAddMeals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Přidat $count jídel',
      many: 'Přidat $count jídla',
      few: 'Přidat $count jídla',
      one: 'Přidat $count jídlo',
    );
    return '$_temp0';
  }

  @override
  String recipeMatchMealsAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Přidáno $count jídel',
      many: 'Přidáno $count jídla',
      few: 'Přidána $count jídla',
      one: 'Přidáno $count jídlo',
    );
    return '$_temp0';
  }

  @override
  String get recipeMatchSwipeUp => 'Přejetím nahoru otevřete tác';

  @override
  String get weekPlannerTitle => 'Naplánovat týden';

  @override
  String get weekPlannerStepDays => 'Dny';

  @override
  String get weekPlannerStepPrefs => 'Předvolby';

  @override
  String get weekPlannerStepPreview => 'Náhled';

  @override
  String get weekPlannerDaysTitle => 'Která jídla má aplikace vyplnit?';

  @override
  String get weekPlannerDaysHint =>
      'Klepejte na políčka. Co je už naplánované, zůstane beze změny.';

  @override
  String get weekPlannerPresetWeekdays => 'Všední dny';

  @override
  String get weekPlannerPlanned => 'naplánováno';

  @override
  String get weekPlannerMoreMeals => 'Zobrazit další jídla';

  @override
  String get weekPlannerFewerMeals => 'Méně jídel';

  @override
  String weekPlannerMealCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jídel',
      many: '$count jídla',
      few: '$count jídla',
      one: '$count jídlo',
    );
    return '$_temp0';
  }

  @override
  String get weekPlannerPrefsTitle => 'Na co má aplikace dbát?';

  @override
  String get weekPlannerPrefsHint =>
      'Vše je volitelné – bez výběru zvolí pestrou směs vašich receptů.';

  @override
  String get weekPlannerQuick => 'Rychle ve všední dny';

  @override
  String weekPlannerQuickSub(int minutes) {
    return 'Po–Pá nejvýše $minutes min';
  }

  @override
  String get weekPlannerStale => 'Dlouho nevařené napřed';

  @override
  String get weekPlannerStaleSub => 'podle „Naposledy uvařeno“ a jídelníčku';

  @override
  String get weekPlannerFavorites => 'Plánovat oblíbené častěji';

  @override
  String get weekPlannerFavoritesSub =>
      'recepty se srdíčkem a s vysokým hodnocením';

  @override
  String get weekPlannerVariety => 'Pestrost';

  @override
  String get weekPlannerVarietySub => 'žádná kategorie dvakrát po sobě';

  @override
  String get weekPlannerOnlyFrom => 'Jen z';

  @override
  String get weekPlannerDiceRules => 'Použít pravidla kostky';

  @override
  String get weekPlannerDiceRulesSub =>
      'váš výběr pro každé jídlo z nastavení jídelníčku';

  @override
  String weekPlannerMatching(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count odpovídajících receptů',
      many: '$count odpovídajícího receptu',
      few: '$count odpovídající recepty',
      one: '$count odpovídající recept',
    );
    return '$_temp0';
  }

  @override
  String weekPlannerForMeals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'pro $count jídel',
      many: 'pro $count jídla',
      few: 'pro $count jídla',
      one: 'pro $count jídlo',
    );
    return '$_temp0';
  }

  @override
  String get weekPlannerSuggest => 'Navrhnout';

  @override
  String get weekPlannerPreviewHint =>
      'Kostka mění, zámek drží. Podržte jídlo a přetáhněte ho na jiný den, chcete-li je prohodit.';

  @override
  String get weekPlannerRerollAll => 'Hodit vše znovu';

  @override
  String get weekPlannerReroll => 'Hodit znovu';

  @override
  String get weekPlannerLock => 'Zamknout';

  @override
  String get weekPlannerUnlock => 'Odemknout';

  @override
  String get weekPlannerReasonNever => 'nikdy nevařeno';

  @override
  String get weekPlannerReasonStale => 'dlouho nevařeno';

  @override
  String get weekPlannerReasonFavorite => 'Oblíbené';

  @override
  String get weekPlannerNoMatch => 'Žádný odpovídající recept';

  @override
  String get weekPlannerThenShopping =>
      'Pak vybrat ingredience do nákupního seznamu';

  @override
  String get weekPlannerMostlyEmpty => 'Týden je skoro prázdný';

  @override
  String weekPlannerMostlyEmptySub(int free, int total) {
    return '$free z $total dní je ještě volných – vyplňte je ve třech krocích.';
  }

  @override
  String get previousWeek => 'Předchozí týden';

  @override
  String get nextWeek => 'Další týden';

  @override
  String get weekPlannerAllDays => 'Všechny dny';

  @override
  String get weekPlannerWeekend => 'Víkend';

  @override
  String get weekPlannerDinners => 'Večeře';

  @override
  String get weekPlannerLunches => 'Obědy';

  @override
  String get weekPlannerAllMeals => 'Všechna jídla';

  @override
  String get mealplanDayEmpty => 'Nic naplánováno';

  @override
  String get mealplanDropHere => 'Pusťte sem';

  @override
  String mealplanDayKcal(String kcal) {
    return '$kcal kcal na porci';
  }

  @override
  String mealplanDayKcalPartial(String kcal) {
    return 'alespoň $kcal kcal na porci';
  }

  @override
  String get globalSearchHint => 'Hledat recepty, položky, funkce …';

  @override
  String get globalSearchIntro =>
      'Hledejte recepty, položky nákupního seznamu, potraviny a kuchařky – i funkce a nastavení aplikace, např. „seznam“.';

  @override
  String get globalSearchFunctions => 'Funkce';

  @override
  String globalSearchNoResults(String query) {
    return 'Žádné výsledky pro „$query“';
  }

  @override
  String get searchClear => 'Vymazat hledání';

  @override
  String get recipeMatchPlanWeek => 'Naplánovat týden s těmito recepty';

  @override
  String get weekPlannerReasonTray => 'z tácu';

  @override
  String get emptyBrowseRecipes => 'Procházet recepty';

  @override
  String get mealplanWeekShopping => 'Ingredience na tento týden';

  @override
  String get globalSearchActions => 'Akce';

  @override
  String globalSearchAddToList(String text) {
    return 'Přidat „$text“ do nákupního seznamu';
  }

  @override
  String globalSearchAdded(String text) {
    return '„$text“ přidáno';
  }

  @override
  String get globalSearchImportUrl => 'Importovat recept z této adresy';

  @override
  String get homeContinueCooking => 'Pokračovat ve vaření';

  @override
  String homeCookingStep(int step, int total) {
    return 'Krok $step z $total';
  }

  @override
  String get homeCookingPrep => 'Příprava';

  @override
  String get homeCookingAlmostDone => 'Skoro hotovo';

  @override
  String get homeCookingContinue => 'pokračovat';

  @override
  String get paneSelectRecipe => 'Vyberte recept vlevo.';

  @override
  String get mealplanDragRecipeHint =>
      'Přetáhněte recept na den a naplánujte ho.';

  @override
  String get desktopDropUnsupported =>
      'Tyto soubory nelze přidat jako přílohy.';

  @override
  String desktopDropUploaded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Přidáno $count příloh',
      many: 'Přidáno $count přílohy',
      few: 'Přidány $count přílohy',
      one: 'Přidána $count příloha',
    );
    return '$_temp0';
  }

  @override
  String get desktopDropAsAttachment => 'Pusťte pro přidání jako přílohy';

  @override
  String get printAction => 'Tisk';

  @override
  String get mealplanPrintWeek => 'Vytisknout týden';

  @override
  String get mealplanEntryCooked => 'Uvařeno';

  @override
  String get recipeSearchClear => 'Vymazat hledání';

  @override
  String get organizerShowRecipes => 'Zobrazit recepty';

  @override
  String globalSearchShowAllRecipes(int count) {
    return 'Zobrazit všechny recepty ($count)';
  }

  @override
  String get unnamedEntry => '(bez názvu)';

  @override
  String get mealplanWholeWeek => 'Na celý týden';

  @override
  String get mealplanWholeWeekDropHint =>
      'Pusťte sem jídlo a naplánujte ho na celý týden.';

  @override
  String get mealplanMovedToWholeWeek => 'Naplánováno na celý týden';

  @override
  String get mealplanCookToday => 'Uvařím dnes';

  @override
  String get mealplanPlanWholeWeek => 'Naplánovat na celý týden';

  @override
  String mealplanPlanWholeWeekRange(String from, String to) {
    return '$from – $to';
  }

  @override
  String get calendarFeedDuration => 'Délka (minuty)';

  @override
  String get calendarFeedEventDetails => 'Podrobnosti události';

  @override
  String calendarFeedEventDetailsHint(String fields) {
    return 'Upravte, jak se jídla zobrazují v kalendáři. Slučovací pole: $fields';
  }

  @override
  String get calendarFeedEventTitle => 'Název události';

  @override
  String get calendarFeedEventDescription => 'Popis události';

  @override
  String get calendarFeedEventDetailsWarning =>
      'Změnou se změní odkaz na kalendář — pokud už odebíráte, přihlaste se znovu s novým odkazem.';

  @override
  String get stepDurationMinutes => 'Doba trvání (minuty)';

  @override
  String stepDurationSaved(String duration) {
    return 'Uložená doba: $duration. Úpravou se nahradí celými minutami.';
  }

  @override
  String get sortTotalTimeShort => 'Nejkratší celková doba';

  @override
  String get sortTotalTimeLong => 'Nejdelší celková doba';

  @override
  String recipeCreatedBy(String name) {
    return 'Vytvořil(a) $name';
  }

  @override
  String get timelineReplacePhoto => 'Nahradit fotku';

  @override
  String get pasteRecipeTitle => 'Vložit recept';

  @override
  String get pasteRecipeDescription =>
      'Vložte recept jako JSON (schema.org) nebo zdrojový HTML kód webové stránky.';

  @override
  String get pasteRecipeDescription330 =>
      'Vložte recept exportovaný z Mealie (JSON) — importuje se s celou strukturou: potraviny, jednotky a odkazy kroků. Funguje i JSON (schema.org) a zdrojový HTML kód webové stránky.';

  @override
  String get pasteRecipeHint => 'Sem vložte JSON nebo HTML';

  @override
  String get pasteRecipeButton => 'Vložit recept';

  @override
  String get pasteRecipeImport => 'Importovat';

  @override
  String get aiPromptsTitle => 'AI prompty';

  @override
  String get aiPromptsTeaser =>
      'Upravte pokyny, které Mealie dává poskytovateli AI — pro všechny úlohy nebo pro každou zvlášť.';

  @override
  String get aiPromptsDescription =>
      'Upravte pokyny, které Mealie dává poskytovateli AI pro každou úlohu. Prompty Mealie jsou psané anglicky, ale to nemění jazyk vašich receptů: zachovají jazyk zdroje, pokud je nepřeložíte. Vlastní pokyny můžete psát v jakémkoli jazyce.';

  @override
  String get aiPromptsGlobal => 'Instrukce pro všechny prompty';

  @override
  String get aiPromptsGlobalDescription =>
      'Přidáno na všechny dotazy, které vytvářejí data o receptu, jako je vytváření receptů, analýza ingrediencí a překládání. Systémové výzvy nejsou ovlivněny.';

  @override
  String get aiPromptsGlobalPlaceholder =>
      'například Vždy používejte metrické jednotky.';

  @override
  String get aiPromptsList => 'Prompty';

  @override
  String get aiPromptSystem => 'Systém';

  @override
  String get aiPromptSystemDescription =>
      'To je systémová výzva. Přepíše váš zdrojový materiál co nejvěrněji, než se změní v recept, takže k němu nejsou přidány instrukce pro všechny prompty. Změna obvykle není nezbytná a může snížit spolehlivost importu.';

  @override
  String get aiPromptAppended => 'Připojeno';

  @override
  String get aiPromptOverridden => 'Přepsáno';

  @override
  String get aiPromptModeDefault => 'Výchozí';

  @override
  String get aiPromptModeAppend => 'Připojit';

  @override
  String get aiPromptModeOverride => 'Přepsat';

  @override
  String get aiPromptAppendDescription =>
      'Tyto pokyny jsou přidány k výzvě aplikace Mealie a mají přednost všude tam, kde jsou v konfliktu.';

  @override
  String get aiPromptOverrideDescription =>
      'Váš prompt zcela nahradí prompt Mealie, takže se na něj nebudou vztahovat budoucí aktualizace promptu Mealie. Data, která úloha potřebuje, např. seznam jednotek, se přesto přidají za váš prompt.';

  @override
  String get aiPromptDefaultChanged =>
      'Prompt Mealie se od vašeho nahrazení změnil. Porovnejte ho se svým nebo se vraťte k výchozímu a použijte novou verzi.';

  @override
  String get aiPromptViewDefault => 'Zobrazit výchozí prompt';

  @override
  String get aiPromptHideDefault => 'Skrýt výchozí prompt';

  @override
  String get aiPromptSaved => 'Prompt uložen';

  @override
  String get aiPromptSaveFailed => 'Nepodařilo se uložit prompt';

  @override
  String get aiPromptTitleBuildRecipe => 'Vytvoř recept';

  @override
  String get aiPromptTitleParseIngredients => 'Zpracuj ingredience';

  @override
  String get aiPromptTitleRecipeVideo => 'Recept z videa';

  @override
  String get aiPromptTitleOrganizers => 'Přiřaď organizátory';

  @override
  String get aiPromptTitleTranslate => 'Přelož recept';

  @override
  String get aiPromptTitleCompileSource => 'Přečti zdrojový materiál';

  @override
  String get aiPromptTitleTranscribe => 'Přepiš audio';

  @override
  String get aiPromptDescBuildRecipe =>
      'Převede zdrojový materiál z webové stránky, fotky nebo textu na strukturovaný recept.';

  @override
  String get aiPromptDescParseIngredients =>
      'Používá ho analyzátor ingrediencí s AI k rozdělení každé ingredience na množství, jednotku, potravinu a poznámku.';

  @override
  String get aiPromptDescRecipeVideo =>
      'Převede přepis a popisek videa na recept.';

  @override
  String get aiPromptDescOrganizers =>
      'Vybere štítky, kategorie a nástroje pro importovaný recept.';

  @override
  String get aiPromptDescTranslate =>
      'Přeloží importovaný recept do zvoleného jazyka.';

  @override
  String get aiPromptDescCompileSource =>
      'Přečte webové stránky, fotky a text do prostého textového záznamu receptu.';

  @override
  String get aiPromptDescTranscribe =>
      'Přepíše zvuk, když ho poskytovatel zvuku nedokáže přepsat přímo.';

  @override
  String get mealplanNoteHint => 'Poznámka (volitelné)';

  @override
  String get mealplanEditTitle => 'Upravit záznam';

  @override
  String get mealplanEntryTitleLabel => 'Název';

  @override
  String get mealplanEntryNoteLabel => 'Poznámka';

  @override
  String mealplanCreateRecipe(String name) {
    return 'Nový recept „$name“';
  }

  @override
  String get mealplanCreateRecipeSubtitle =>
      'Vytvoří prázdný recept, naplánuje ho a otevře editor';

  @override
  String get importOptionsTitle => 'Možnosti importu';

  @override
  String get importOptionsHint =>
      'Kolik práce AI v Mealie dělá při importu na vašem serveru. Každý krok navíc je samostatný požadavek na AI – čím méně, tím rychleji.';

  @override
  String get importTranslateTitle => 'Přeložit recept';

  @override
  String get importOrganizersTitle => 'Kategorie a štítky';

  @override
  String get importOrganizersCreate => 'Přidávat nové';

  @override
  String get importOrganizersExisting => 'Jen existující';

  @override
  String get importOrganizersNone => 'Žádný';

  @override
  String get importOrganizersCreateHint =>
      'AI přiřadí štítky, kategorie a nástroje a vytvoří chybějící.';

  @override
  String get importOrganizersExistingHint =>
      'AI použije jen štítky, kategorie a nástroje, které už existují.';

  @override
  String get importOrganizersNoneHint =>
      'Recept se importuje bez štítků, kategorií a nástrojů. Mealie tento krok přesto provede, takže import se nezrychlí.';

  @override
  String get importStarting => 'Odesílání na server…';

  @override
  String get importRunning => 'Import receptu…';

  @override
  String get aiImagesRunning => 'AI čte stránky…';

  @override
  String get importStreamPhotosTitle =>
      'Import fotek s průběhem v reálném čase';

  @override
  String get importStreamPhotosHint =>
      'Zobrazuje každý krok a drží spojení otevřené při dlouhých importech. Vypněte pro nahrání jedním požadavkem jako dřív – např. když proxy blokuje streamování.';

  @override
  String get weekPlannerDiceRulesMealieSub =>
      'pravidla Mealie vaší domácnosti (nastavení jídelníčku)';

  @override
  String get syncStarted =>
      'Znovu se načítají recepty, obrázky a seznamy ze serveru…';

  @override
  String get syncDone => 'Vše je aktuální';

  @override
  String get recipeReloaded => 'Recept znovu načten';

  @override
  String get logoutTitle => 'Odhlásit / přepnout uživatele';

  @override
  String get logoutConfirm =>
      'Recepty, seznamy a ještě nesynchronizované změny se z tohoto zařízení odstraní. Nastavení aplikace a adresa serveru zůstanou, takže se stačí znovu přihlásit.';

  @override
  String get reloadRecipe => 'Znovu načíst ze serveru';

  @override
  String get wifiServerTitle => 'Jiná adresa ve Wi-Fi';

  @override
  String get wifiServerHint =>
      'Pro tentýž server pod druhou adresou, např. místní IP doma a ZeroTier, Tailscale nebo doména na cestách. Ve Wi-Fi níže aplikace automaticky použije tuto adresu, všude jinde URL serveru výše.';

  @override
  String get wifiSsidLabel => 'Název Wi-Fi';

  @override
  String get wifiServerUrl => 'Adresa v této Wi-Fi';

  @override
  String get wifiUseCurrent => 'Použít aktuální Wi-Fi';

  @override
  String get wifiNameUnavailable =>
      'Název Wi-Fi se nepodařilo zjistit. Připojte se k Wi-Fi a povolte přístup k poloze – Android a iOS název Wi-Fi bez něj nezobrazí.';

  @override
  String wifiServerActive(String ssid) {
    return 'Aktivní: adresa ve Wi-Fi „$ssid“';
  }

  @override
  String wifiServerStandardActive(String ssid) {
    return 'Aktivní: URL serveru (mimo „$ssid“)';
  }

  @override
  String get wifiServerRemove => 'Odebrat';

  @override
  String get switchUserTitle => 'Přepnout uživatele';

  @override
  String switchUserBody(String name) {
    return '$name zůstane uložen v tomto zařízení – se všemi recepty, seznamy a dosud nesynchronizovanými změnami. Zpět se přepnete přes profilový obrázek nebo přihlašovací stránku.';
  }

  @override
  String get allowBiometricTitle => 'Přepínat zpět odemknutím zařízení';

  @override
  String get allowBiometricHint =>
      'Face ID, otisk prstu nebo PIN zařízení místo hesla. Kdokoli, kdo může toto zařízení odemknout, pak může otevřít tento účet.';

  @override
  String get allow => 'Povolit';

  @override
  String unlockAccountReason(String name) {
    return 'Přepnout na $name';
  }

  @override
  String signInAs(String name) {
    return 'Přihlásit se jako $name';
  }

  @override
  String wrongAccountError(String name) {
    return 'To je účet „$name“. Přihlaste se uloženým účtem.';
  }

  @override
  String get accountSaveOffline =>
      'Účet teď nelze uložit – server není dostupný.';

  @override
  String get signOutRemoveTitle => 'Odhlásit a odebrat';

  @override
  String get signOutRemoveConfirm =>
      'Tento účet a všechna jeho data v tomto zařízení (recepty, seznamy, nesynchronizované změny) budou odstraněna. Nastavení aplikace zůstane.';

  @override
  String get removeSavedAccount => 'Odebrat z tohoto zařízení';

  @override
  String removeSavedAccountConfirm(String name) {
    return 'Odebrat „$name“ a všechna uložená data z tohoto zařízení? Nesynchronizované změny se ztratí.';
  }

  @override
  String get savedAccountsTitle => 'Uložené účty';

  @override
  String get addAccount => 'Přidat další účet';

  @override
  String get biometricOff => 'Přestat používat odemknutí zařízení';

  @override
  String get orNewAccount => 'Nebo se přihlaste jiným účtem:';

  @override
  String get importVideoTitle => 'Odkazy na videa';

  @override
  String get importVideoFast => 'Rychle';

  @override
  String get importVideoThorough => 'Důkladně (AI)';

  @override
  String get importVideoFastHint =>
      'Mealie přepíše video a sestaví recept jediným požadavkem na AI – obvykle mnohem rychleji. Bez překladu a bez kategorií/štítků. AI lze přesto zapnout pro jednotlivý import.';

  @override
  String get importVideoThoroughHint =>
      'U odkazů na videa se přepínač AI zapne automaticky: několik kroků AI, s překladem a kategoriemi/štítky podle nastavení výše. Trvá déle.';

  @override
  String get importPresetFast => 'Rychle';

  @override
  String get importPresetThorough => 'Důkladně';

  @override
  String get importPresetCustom => 'Vlastní';

  @override
  String get importPresetFastTitle => 'Co nejméně kroků AI – nejkratší čekání';

  @override
  String get importPresetFastVideo =>
      'Odkazy na videa: Mealie přepíše video a sestaví recept jediným požadavkem na AI (přepínač AI zůstane vypnutý).';

  @override
  String get importPresetFastTranslate =>
      'Bez překladu – recept zůstane v původním jazyce.';

  @override
  String get importPresetFastOrganizers =>
      'Přiřadí se jen existující kategorie a štítky, nové se nevytvářejí.';

  @override
  String get importPresetThoroughTitle =>
      'Úplný import Mealie s AI – trvá déle, vytěží nejvíc';

  @override
  String get importPresetThoroughVideo =>
      'Odkazy na videa se automaticky importují s AI – v několika krocích (sestavení zdroje, sestavení receptu, …).';

  @override
  String get importPresetThoroughTranslate =>
      'Recept se přeloží do jazyka importu níže, pokud je napsán v jiném jazyce.';

  @override
  String get importPresetThoroughOrganizers =>
      'Přiřadí se vhodné kategorie a štítky; chybějící se vytvoří.';

  @override
  String get importPresetCustomTitle => 'Nastavte každou možnost sami';

  @override
  String get importPresetCustomBody =>
      'Vyjděte z toho, co dělala předchozí volba, a změňte jen to, co potřebujete – např. rychlé importy videí, ale s překladem.';

  @override
  String get sidebarPinHint =>
      'Tip: podržte dlaždici a přetáhněte ji na boční panel, kde ji připnete.';

  @override
  String get sidebarDropHere => 'Pusťte sem';

  @override
  String sidebarShortcutTitle(String name) {
    return 'Klávesová zkratka pro „$name“';
  }

  @override
  String sidebarShortcutPrompt(String modifier) {
    return 'Teď stiskněte požadovanou kombinaci kláves včetně $modifier.';
  }

  @override
  String get sidebarShortcutTaken => 'Tato kombinace se už používá.';

  @override
  String get sidebarShortcutNone => 'Bez zkratky';

  @override
  String get sidebarShortcutChange => 'Změnit zkratku';

  @override
  String get sidebarUnpin => 'Odebrat z bočního panelu';

  @override
  String sidebarFull(int count) {
    return 'Boční panel je plný – nejvýše $count vlastních položek.';
  }

  @override
  String get tabletSidebar => 'Boční panel na šířku';

  @override
  String get tabletSidebarSubtitle =>
      'Zobrazuje navigaci vlevo místo dole, když je tablet natočený na šířku';

  @override
  String get filterDateCreated => 'Datum vytvoření';

  @override
  String get filterDateUpdated => 'Datum aktualizace';

  @override
  String get errorUploadTooLarge =>
      'Soubor je pro tento server Mealie příliš velký. Limit nahrávání serveru lze zvýšit pomocí MAX_UPLOAD_SIZE_MB.';

  @override
  String get recipeDownloadPdfMealie => 'Stáhnout PDF (rozvržení Mealie)';

  @override
  String get mealplanNoteMore => 'Zobrazit více…';

  @override
  String get mealplanNoteLess => 'Zobrazit méně';

  @override
  String get ingredientCommonlySubstitutedWith => 'Často nahrazováno s';

  @override
  String requiresMealieVersion(String version) {
    return 'Vyžaduje Mealie $version nebo novější.';
  }

  @override
  String get apiTokensTitle => 'API Tokeny';

  @override
  String get apiTokensDescription =>
      'Spravujte své API tokeny pro přístup z externích aplikací.';

  @override
  String get apiTokenNameLabel => 'Název tokenu';

  @override
  String get apiTokenGenerate => 'Vygenerovat';

  @override
  String get apiTokensActive => 'AKTIVNÍ TOKENY';

  @override
  String get apiTokenCopyWarning =>
      'Zkopírujte tento token pro použití v externí aplikaci. Tento token nebude znovu zobrazen.';

  @override
  String get apiTokenThisApp => 'Používá tato aplikace';

  @override
  String get apiTokenThisAppHint =>
      'Tento token udržuje aplikaci přihlášenou a nelze ho zde smazat.';

  @override
  String apiTokenDeleteConfirm(String name) {
    return 'Smazat token „$name“? Aplikace, které ho používají, okamžitě ztratí přístup.';
  }

  @override
  String get apiTokensEmpty => 'Zatím žádné tokeny.';

  @override
  String apiTokenCreatedOn(String date) {
    return 'Vytvořeno $date';
  }

  @override
  String get apiTokenCopied => 'Token zkopírován';

  @override
  String get qfOpHasNoValue => 'nemá hodnotu';

  @override
  String get qfOpHasValue => 'má hodnotu';

  @override
  String get ratingHouseholdAverage => 'průměr domácnosti';

  @override
  String get stepLinkedNotes => 'Propojené poznámky';

  @override
  String get noteFallbackTitle => 'Poznámka';

  @override
  String get aiPromptTitleEnrichInstructions => 'Doplnit podrobnosti kroků';

  @override
  String get aiPromptDescEnrichInstructions =>
      'Propojí každý krok importovaného receptu s ingrediencemi a poznámkami, které používá, a určí jeho dobu trvání a nadpis.';

  @override
  String get loginAccountLocked => 'Účet je uzamčen. Zkuste to prosím později';

  @override
  String get loginPasswordDisabled =>
      'Přihlášení heslem je na tomto serveru vypnuté. Použijte místo toho API token.';

  @override
  String get unitSystemTitle => 'Jednotky';

  @override
  String get unitSystemAsWritten => 'Jak je napsáno';

  @override
  String get unitSystemMetric => 'Metrické';

  @override
  String get unitSystemMetricHint => 'Metrické (g, ml)';

  @override
  String get unitSystemImperial => 'Imperiální';

  @override
  String get unitSystemImperialHint => 'Imperiální (šálky, unce)';

  @override
  String get unitSystemHint =>
      'Jen zobrazení – samotný recept zůstane beze změny. Jako ve webové aplikaci Mealie platí volba pro všechny recepty v tomto zařízení.';

  @override
  String get unitSystemUnavailable =>
      'Žádnou jednotku tohoto receptu nelze převést. K tomu potřebuje jednotka v Mealie standardizaci (Potraviny a jednotky → jednotka → Standardizace).';

  @override
  String get shoppingCheckAll => 'Vybrat všechny položky';

  @override
  String get shoppingUncheckAll => 'Zrušit výběr všech položek';

  @override
  String get shoppingDeleteChecked => 'Odstranit vybrané';

  @override
  String get shoppingCheckAllConfirm =>
      'Opravdu chcete vybrat všechny položky?';

  @override
  String get shoppingUncheckAllConfirm =>
      'Opravdu chcete zrušit výběr všech položek?';

  @override
  String shoppingItemCheckedOff(String item) {
    return 'Odškrtnuta položka $item';
  }
}
