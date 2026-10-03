// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'Mealie Recipes';

  @override
  String get endCookingMode => 'Zakończ tryb gotowania';

  @override
  String get endCookingModeConfirm =>
      'Czy na pewno chcesz zakończyć tryb gotowania?';

  @override
  String endCookingModeConfirmAll(int count) {
    return 'Spowoduje to zakończenie wszystkich $count przepisów w trybie gotowania. Kontynuować?';
  }

  @override
  String get addTimer => 'Dodaj minutnik';

  @override
  String get recipeFinished => 'Twoje danie jest gotowe.';

  @override
  String get bonAppetit => 'Smacznego!';

  @override
  String get prepareIngredients => 'Przygotuj następujące składniki';

  @override
  String prepareIngredientsFor(String servings) {
    return 'Przygotuj następujące składniki na $servings porcji';
  }

  @override
  String get next => 'Dalej';

  @override
  String get navHome => 'Start';

  @override
  String get homeCookToday => 'Ugotuj dzisiaj';

  @override
  String get homeSuggestion => 'Propozycja';

  @override
  String get homeQuickAccess => 'Szybki dostęp';

  @override
  String get homePlanned => 'Zaplanowane';

  @override
  String get favorite => 'Ulubione';

  @override
  String get navSettings => 'Ustawienia';

  @override
  String homeWelcomeName(Object name) {
    return 'Witaj, $name,';
  }

  @override
  String get homeWelcomeApp => 'w Mealie Recipes 👋';

  @override
  String get theme => 'Wygląd';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Jasny';

  @override
  String get themeDark => 'Ciemny';

  @override
  String get recipes => 'Przepisy';

  @override
  String get shoppingList => '🛒 Lista zakupów';

  @override
  String get mealplan => 'Plan posiłków';

  @override
  String get settings => '⚙️ Ustawienia';

  @override
  String get searchRecipe => 'Szukaj przepisu...';

  @override
  String get loadingRecipes => 'Wczytywanie przepisów...';

  @override
  String get loadingRecipe => 'Wczytywanie przepisu...';

  @override
  String errorLoadingRecipes(String error) {
    return 'Błąd wczytywania: $error';
  }

  @override
  String get errorLoadingRecipe => 'Nie udało się wczytać przepisu.';

  @override
  String get noRecipesForCategory => 'Brak przepisów dla tego filtra.';

  @override
  String get resetFilter => 'Wyczyść filtr';

  @override
  String get allCategories => 'Wszystkie kategorie';

  @override
  String get all => 'Wszystkie';

  @override
  String get sortRecipes => 'Sortuj przepisy';

  @override
  String get refreshRecipes => 'Odśwież';

  @override
  String get sortNameAZ => 'Nazwa A–Z';

  @override
  String get sortNameZA => 'Nazwa Z–A';

  @override
  String get sortDateNewest => 'Najpierw najnowsze';

  @override
  String get sortDateOldest => 'Najpierw najstarsze';

  @override
  String get sortPrepTimeShort => 'Najkrótszy czas przygotowania';

  @override
  String get sortPrepTimeLong => 'Najdłuższy czas przygotowania';

  @override
  String get sortRatingHighest => 'Najwyższa ocena';

  @override
  String get sortRatingLowest => 'Najniższa ocena';

  @override
  String get details => 'Szczegóły';

  @override
  String get ingredients => 'Składniki';

  @override
  String get instructions => 'Instrukcje';

  @override
  String get tags => 'Tagi';

  @override
  String get notes => 'Notatki';

  @override
  String get addNote => 'Dodaj notatkę';

  @override
  String get editNote => 'Edytuj notatkę';

  @override
  String get noteTitleHint => 'Tytuł (opcjonalnie)';

  @override
  String get noteTextHint => 'Treść notatki';

  @override
  String get deleteNoteTitle => 'Usunąć notatkę?';

  @override
  String get deleteNoteMessage => 'Ta notatka zostanie trwale usunięta.';

  @override
  String get servings => 'Porcje';

  @override
  String get adjustQuantity => 'Dostosuj ilość';

  @override
  String get startTimer => 'Uruchom minutnik';

  @override
  String runningTimer(int minutes, String seconds) {
    return 'Minutnik: $minutes:$seconds';
  }

  @override
  String get planMeal => 'Zaplanuj posiłek';

  @override
  String get displayAlwaysOn => 'Nie wygaszaj ekranu';

  @override
  String get addAllIngredients => 'Dodaj wszystkie składniki';

  @override
  String get addSelectedIngredients => 'Dodaj wybrane składniki';

  @override
  String get addIngredientsTitle => 'Dodano składniki';

  @override
  String get addIngredientsMessage =>
      'Składniki zostały dodane do listy zakupów.';

  @override
  String addIngredientsFailedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Nie udało się dodać $count składnika.',
      many: 'Nie udało się dodać $count składników.',
      few: 'Nie udało się dodać $count składników.',
      one: 'Nie udało się dodać 1 składnika.',
    );
    return '$_temp0';
  }

  @override
  String get cookbooks => 'Książki kucharskie';

  @override
  String get cookbooksEmpty =>
      'Nie masz jeszcze żadnych książek kucharskich. Stuknij „+” w prawym górnym rogu, aby utworzyć jedną.';

  @override
  String get cookbookNoMatches => 'Żaden przepis nie pasuje do tego filtra.';

  @override
  String get cookbookCreateTitle => 'Utwórz książkę kucharską';

  @override
  String get cookbookEditTitle => 'Edytuj książkę kucharską';

  @override
  String get cookbookNameLabel => 'Nazwa książki kucharskiej';

  @override
  String get cookbookFilterSectionTitle => 'Automatycznie dodawaj przepisy';

  @override
  String get cookbookFieldTools => 'Narzędzia';

  @override
  String get cookbookFieldUsers => 'Użytkownicy';

  @override
  String get cookbookOpIsOneOf => 'jest jednym z';

  @override
  String get cookbookOpIsNotOneOf => 'nie jest żadnym z';

  @override
  String get cookbookOpContainsAll => 'zawiera wszystkie';

  @override
  String get cookbookSelectValues => 'Wybierz wartości';

  @override
  String get cookbookFilterOptionsUnavailable => 'Brak dostępnych opcji';

  @override
  String get cookbookAddFilterField => 'Dodaj pole';

  @override
  String get cookbookPublicLabel => 'Publiczna książka kucharska';

  @override
  String get cookbookPublicSubtitle =>
      'Widoczna dla innych gospodarstw domowych na serwerze';

  @override
  String get cookbookRawModeEnter => 'Edytuj jako tekst';

  @override
  String get cookbookRawModeExit => 'Wróć do kreatora';

  @override
  String get cookbookRawModeHint =>
      'Tryb eksperta tej aplikacji: edytuje filtr bezpośrednio jako tekst. Przydatne, gdy istniejącego filtra nie dało się rozłożyć na proste wiersze.';

  @override
  String get cookbookRawModeUnparseable =>
      'Ten tekst nie pasuje do prostego formatu wierszy — pozostaje jako tekst.';

  @override
  String get saveFailed => 'Zapis nie powiódł się';

  @override
  String get search => 'Szukaj';

  @override
  String get apply => 'Zastosuj';

  @override
  String get setupCachingTitle => 'Wczytywanie Twoich przepisów';

  @override
  String get setupCachingSubtitle =>
      'Twoje przepisy są przygotowywane do użytku offline. W zależności od ich liczby może to chwilę potrwać.';

  @override
  String get setupCachingDone => 'Wszystko gotowe!';

  @override
  String get setupTipsHeader => 'Czy wiesz, że...?';

  @override
  String get setupFinish => 'Zaczynajmy';

  @override
  String get setupSkipCaching => 'Kontynuuj w tle';

  @override
  String get setupTip1 =>
      'Możesz importować przepisy z linku, zdjęcia lub PDF-a — przez kafelek Import na ekranie głównym.';

  @override
  String get setupTip2 =>
      'Tryb gotowania nie pozwala zgasnąć ekranowi, prowadzi Cię krok po kroku i automatycznie wykrywa minutniki w tekście.';

  @override
  String get setupTip3 =>
      'Lista zakupów działa też offline — zmiany synchronizują się automatycznie, gdy tylko serwer będzie dostępny.';

  @override
  String get setupTip4 =>
      'Przytrzymaj kafelek na ekranie głównym, aby zmienić kolejność szybkiego dostępu.';

  @override
  String get setupTip5 =>
      'Swoje książki kucharskie z Mealie znajdziesz przez kafelek Książki kucharskie — również w trybie offline.';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Anuluj';

  @override
  String get delete => 'Usuń';

  @override
  String get edit => 'Edytuj';

  @override
  String get save => 'Zapisz';

  @override
  String get done => 'Gotowe';

  @override
  String get close => 'Zamknij';

  @override
  String get add => 'Dodaj';

  @override
  String get send => 'Wyślij';

  @override
  String get retry => 'Spróbuj ponownie';

  @override
  String get confirmDeleteTitle => 'Usunąć przepis?';

  @override
  String get confirmDeleteMessage => 'Tej czynności nie można cofnąć.';

  @override
  String get sendToDevice => 'Wyślij na urządzenie';

  @override
  String get sendToDevicePickerTitle => 'Wyślij na urządzenie';

  @override
  String get sendToAllDevices => 'Wyślij na wszystkie urządzenia';

  @override
  String get timerFinished => 'Minutnik zadzwonił!';

  @override
  String get timerFinishedBody =>
      'Twój minutnik przepisu zakończył odliczanie.';

  @override
  String get timer => 'Minutnik';

  @override
  String get newTimer => 'Nowy minutnik';

  @override
  String get timerDetails => 'Szczegóły minutnika';

  @override
  String get timerNamePlaceholder => 'Nazwa minutnika';

  @override
  String get timerNameHint => 'Nadaj minutnikowi opisową nazwę.';

  @override
  String get durationLabel => 'Czas trwania';

  @override
  String minutesCount(int count) {
    return '$count min';
  }

  @override
  String get start => 'Start';

  @override
  String get stop => 'Zatrzymaj';

  @override
  String get pause => 'Wstrzymaj';

  @override
  String get resume => 'Wznów';

  @override
  String get finished => 'Gotowe!';

  @override
  String stepNumber(int number) {
    return 'Krok $number';
  }

  @override
  String get minAbbreviation => 'min';

  @override
  String get cookingMode => 'Tryb gotowania';

  @override
  String activeRecipesCount(int count) {
    return 'Aktywne przepisy: $count';
  }

  @override
  String get endAll => 'Zakończ wszystkie';

  @override
  String get end => 'Zakończ';

  @override
  String get endAllRecipesTitle => 'Zakończyć wszystkie przepisy?';

  @override
  String endAllRecipesMessage(int count) {
    return 'Czy chcesz zakończyć wszystkie aktywne sesje gotowania ($count)?';
  }

  @override
  String get endRecipeTitle => 'Zakończyć przepis?';

  @override
  String endRecipeMessage(String name) {
    return 'Czy chcesz zakończyć sesję gotowania „$name”?';
  }

  @override
  String get noActiveTimers => 'Brak aktywnych minutników';

  @override
  String get noActiveRecipes => 'Brak aktywnych przepisów';

  @override
  String get startRecipeToCook =>
      'Otwórz przepis i stuknij przycisk trybu gotowania, aby zacząć.';

  @override
  String get browseRecipes => 'Przeglądaj przepisy';

  @override
  String timersPausedCount(int count) {
    return 'Wstrzymane minutniki: $count';
  }

  @override
  String get cookFriends => 'Gotuj ze znajomymi';

  @override
  String get cookingModeAddRecipe => 'Dodaj przepis';

  @override
  String get cookingModeAddRecipeSearchHint => 'Szukaj przepisów';

  @override
  String get cookFriendsCode => 'Kod sesji';

  @override
  String get cookFriendsJoin => 'Dołącz do sesji';

  @override
  String get cookFriendsHost => 'Zorganizuj sesję';

  @override
  String get cookFriendsHostNotFound =>
      'Nie znaleziono hosta. Upewnij się, że oba urządzenia są w tej samej sieci Wi-Fi i że dostęp do sieci lokalnej jest dozwolony.';

  @override
  String get cookFriendsConnectionFailed =>
      'Połączenie nie powiodło się. Spróbuj ponownie.';

  @override
  String get cookFriendsEnterCode => 'Wpisz kod';

  @override
  String cookFriendsConnected(int count) {
    return 'Połączono: $count gości';
  }

  @override
  String get joinSession => 'Dołącz do sesji';

  @override
  String get hostEndedSessionTitle => 'Sesja zakończona';

  @override
  String get hostEndedSessionMessage => 'Host zakończył sesję gotowania.';

  @override
  String get shoppingListEmpty => 'Twoja lista zakupów jest pusta.';

  @override
  String get addItem => 'Dodaj artykuł';

  @override
  String get itemNote => 'Nazwa artykułu';

  @override
  String get unlabeledCategory => 'Bez kategorii';

  @override
  String get reorderCategories => 'Zmień kolejność kategorii';

  @override
  String get archiveChecked => 'Archiwizuj odhaczone';

  @override
  String get archivedLists => '📦 Zarchiwizowane zakupy';

  @override
  String get syncChanges => 'Synchronizuj zmiany';

  @override
  String get noSyncChanges => 'Brak zmian do synchronizacji';

  @override
  String get postimportAction => 'Po imporcie';

  @override
  String get postimportHint =>
      'Wybierz, co ma się stać w aplikacji źródłowej (Przypomnienia / Google Tasks) z zaimportowanymi pozycjami.';

  @override
  String get postimportLeave => 'Tylko dodaj';

  @override
  String get postimportComplete => 'Odhacz';

  @override
  String get postimportCompleteDelete => 'Odhacz i usuń';

  @override
  String get postimportFailed =>
      'Przetwarzanie końcowe w aplikacji źródłowej nie powiodło się. Pozycje zostały mimo to dodane do Mealie.';

  @override
  String get syncChangesTitle => 'Synchronizuj zmiany';

  @override
  String get syncSectionChecked => 'Odhaczone';

  @override
  String get syncSectionQuantity => 'Ilość';

  @override
  String get syncSectionCategory => 'Kategoria';

  @override
  String get syncSectionAdditions => 'Nowo dodane';

  @override
  String get syncLocalLabel => 'Lokalnie';

  @override
  String get syncServerLabel => 'Serwer';

  @override
  String get syncNow => 'Synchronizuj teraz';

  @override
  String get offlineBadge => 'Offline';

  @override
  String get mealplanTitle => '📅 Plan posiłków';

  @override
  String get mealplanSelectMode => 'Zaznacz kilka przepisów';

  @override
  String mealplanSelectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count zaznaczonego',
      many: '$count zaznaczonych',
      few: '$count zaznaczone',
      one: '1 zaznaczony',
      zero: 'Wybór',
    );
    return '$_temp0';
  }

  @override
  String get breakfast => 'Śniadanie';

  @override
  String get lunch => 'Obiad';

  @override
  String get dinner => 'Kolacja';

  @override
  String get addMealEntry => 'Dodaj posiłek';

  @override
  String get selectRecipe => 'Wybierz przepis';

  @override
  String get orFreeText => 'lub dowolny tekst';

  @override
  String get entryNote => 'Notatka';

  @override
  String get noMealEntries => 'Brak wpisów w tym tygodniu.';

  @override
  String get importRecipe => 'Importuj przepis';

  @override
  String get importFromUrl => 'Importuj z URL';

  @override
  String get importFromImage => 'Importuj ze zdjęcia';

  @override
  String get importFromJson => 'Importuj z JSON';

  @override
  String get url => 'URL';

  @override
  String get urlPlaceholder => 'https://...';

  @override
  String get importLanguage => 'Język dla OCR';

  @override
  String get importing => 'Importowanie...';

  @override
  String get importSuccess => 'Przepis zaimportowany pomyślnie!';

  @override
  String importError(String error) {
    return 'Import nie powiódł się: $error';
  }

  @override
  String get pasteJson => 'Wklej tutaj JSON';

  @override
  String get setupTitle => 'Witamy w Mealie Recipes';

  @override
  String get setupSubtitle => 'Skonfiguruj swój serwer Mealie.';

  @override
  String get serverUrl => 'Adres URL serwera';

  @override
  String get serverUrlPlaceholder => 'https://mealie.przyklad.pl';

  @override
  String get apiToken => 'Token API';

  @override
  String get apiTokenPlaceholder => 'Twój token API';

  @override
  String get householdId => 'Gospodarstwo domowe';

  @override
  String get householdIdPlaceholder => 'Family';

  @override
  String get shoppingListId => 'ID listy zakupów';

  @override
  String get shoppingListIdPlaceholder => 'Wybierz listę zakupów';

  @override
  String get setupHouseholdListTitle => 'Gospodarstwo domowe i lista zakupów';

  @override
  String get shoppingListLabel => 'Lista zakupów';

  @override
  String get setupHouseholdManualHint =>
      'Nie udało się wczytać gospodarstw domowych — wpisz nazwę gospodarstwa ręcznie.';

  @override
  String get setupExactTitle => 'Ilości na liście zakupów';

  @override
  String get setupExactBody =>
      'W większości krajów nie kupuje się co do grama — do koszyka trafia 1 kostka masła, a nie 200 g. W trybie prostym aplikacja zamienia więc ilości z przepisu na „1×”. W trybie dokładnym ilość i jednostka są zachowywane 1:1 jak w aplikacji webowej Mealie — również przy wpisywaniu nowych artykułów (np. „200 g masła”). Możesz to zmienić w dowolnym momencie w ustawieniach.';

  @override
  String get setupExactSimpleTitle => 'Tryb prosty (1×)';

  @override
  String get setupExactSimpleBody =>
      'Składniki trafiają na listę jako „1× artykuł” — idealne do szybkiego odhaczania w sklepie.';

  @override
  String get setupExactExactTitle => 'Dokładne ilości';

  @override
  String get setupExactExactBody =>
      'Artykuły pojawiają się z ilością i jednostką, np. „200 g masła” — dokładnie jak w aplikacji webowej.';

  @override
  String get connect => 'Połącz';

  @override
  String get connecting => 'Łączenie...';

  @override
  String get connectionSuccess => 'Połączenie udane!';

  @override
  String connectionError(String error) {
    return 'Połączenie nie powiodło się: $error';
  }

  @override
  String get optionalHeaders => 'Opcjonalne nagłówki HTTP (dla reverse proxy)';

  @override
  String get settingsTitle => '⚙️ Ustawienia';

  @override
  String get settingsSaved => 'Ustawienia zapisane';

  @override
  String get serverSettings => 'Serwer';

  @override
  String get displaySettings => 'Wyświetlanie';

  @override
  String get notificationSettings => 'Powiadomienia';

  @override
  String get securitySettings => 'Bezpieczeństwo';

  @override
  String get aboutSettings => 'O aplikacji';

  @override
  String get showRecipeImages => 'Pokazuj zdjęcia przepisów';

  @override
  String get apiVersion => 'Wersja API';

  @override
  String get language => 'Język';

  @override
  String get biometricLock => 'Blokada biometryczna';

  @override
  String get biometricLockDescription =>
      'Odblokuj aplikację danymi biometrycznymi';

  @override
  String get criticalAlerts => 'Alerty krytyczne';

  @override
  String get criticalAlertsDescription =>
      'Alarm minutnika także w trybie cichym';

  @override
  String get enableLogging => 'Włącz rejestrowanie';

  @override
  String get selectLanguage => 'Wybierz język';

  @override
  String get setupContinue => 'Dalej';

  @override
  String get back => 'Wstecz';

  @override
  String get setupConnectStep => 'Połącz się ze swoim serwerem';

  @override
  String get resetSettings => 'Zresetuj wszystkie ustawienia';

  @override
  String get resetSettingsConfirm =>
      'Wszystkie ustawienia zostaną zresetowane. Kontynuować?';

  @override
  String get guestMode => 'Tryb gościa';

  @override
  String get appVersion => 'Wersja';

  @override
  String get leftoverFinder => 'Wyszukiwarka przepisów';

  @override
  String get leftoverFinderSubtitle =>
      'Znajdź przepisy z posiadanymi składnikami';

  @override
  String get addIngredient => 'Dodaj składnik';

  @override
  String get ingredientPlaceholder => 'np. jajka';

  @override
  String get findRecipes => 'Znajdź przepisy';

  @override
  String get matchingRecipes => 'Pasujące przepisy';

  @override
  String get noMatchingRecipes =>
      'Nie znaleziono przepisów dla tych składników.';

  @override
  String matchPercent(int percent) {
    return 'Dopasowanie: $percent%';
  }

  @override
  String get biometricPrompt =>
      'Uwierzytelnij się, aby otworzyć Mealie Recipes';

  @override
  String get biometricFailed => 'Uwierzytelnianie nie powiodło się';

  @override
  String get whatsNew => 'Co nowego';

  @override
  String get pendingRecipesTitle => 'Otrzymane przepisy';

  @override
  String pendingRecipesMessage(String sender, String name) {
    return 'Otrzymałeś przepis od $sender: „$name”';
  }

  @override
  String pendingRecipesFrom(Object names) {
    return 'Od $names';
  }

  @override
  String get pendingRecipesOpenCooking => 'Otwórz tryb gotowania';

  @override
  String get pendingRecipesLater => 'Później';

  @override
  String get openRecipe => 'Otwórz przepis';

  @override
  String get dismiss => 'Zamknij';

  @override
  String get editRecipe => 'Edytuj przepis';

  @override
  String get recipeName => 'Nazwa przepisu';

  @override
  String get recipeDescription => 'Opis';

  @override
  String get prepTime => 'Czas przygotowania (min)';

  @override
  String get cookTime => 'Czas gotowania (min)';

  @override
  String get totalTime => 'Całkowity czas (min)';

  @override
  String get recipeServings => 'Porcje';

  @override
  String get rating => 'Ocena';

  @override
  String get addIngredientLine => 'Dodaj składnik';

  @override
  String get addInstruction => 'Dodaj krok';

  @override
  String get removeIngredient => 'Usuń składnik';

  @override
  String get removeInstruction => 'Usuń krok';

  @override
  String get ingredientName => 'Składnik';

  @override
  String get ingredientQuantity => 'Ilość';

  @override
  String get ingredientUnit => 'Jednostka';

  @override
  String get ingredientNote => 'Notatka';

  @override
  String get instructionText => 'Treść kroku';

  @override
  String get categories => 'Kategorie';

  @override
  String get selectCategories => 'Wybierz kategorie';

  @override
  String get selectTags => 'Wybierz tagi';

  @override
  String get uploadImage => 'Prześlij zdjęcie';

  @override
  String get removeImage => 'Usuń zdjęcie';

  @override
  String get saveChanges => 'Zapisz zmiany';

  @override
  String get saving => 'Zapisywanie...';

  @override
  String get saveSuccess => 'Przepis zapisany.';

  @override
  String saveError(String error) {
    return 'Nie udało się zapisać: $error';
  }

  @override
  String get newCategory => 'Nowa kategoria';

  @override
  String get newTag => 'Nowy tag';

  @override
  String get setRating => 'Ustaw ocenę';

  @override
  String get removeRating => 'Usuń ocenę';

  @override
  String get ratingRemoved => 'Ocena usunięta';

  @override
  String get googleTasksImport => 'Importuj z Google Tasks';

  @override
  String get googleTasksImportDescription =>
      'Importuj elementy z Google Tasks do listy zakupów.';

  @override
  String get homeWelcome => 'Witaj w Mealie Recipes! 👋';

  @override
  String homeWelcomeNamed(String name) {
    return 'Witaj $name, w Mealie Recipes! 👋';
  }

  @override
  String get shopping => 'Zakupy';

  @override
  String get planning => 'Planowanie';

  @override
  String get other => 'Inne';

  @override
  String get viewRecipes => '📖 Pokaż przepisy';

  @override
  String get addRecipe => '➕ Dodaj przepis';

  @override
  String get completeShopping => 'Zakończ zakupy';

  @override
  String get shoppingCompleted => 'Zakupy zakończone';

  @override
  String get shoppingCompletedSubtitle => 'Wszystko w koszyku! 🎉';

  @override
  String get essensplan => '📅 Plan posiłków';

  @override
  String get resteverwertung => '🥗 Wyszukiwarka przepisów';

  @override
  String get newRecipeUpload => 'Prześlij nowy przepis';

  @override
  String get copyCode => 'Kopiuj kod';

  @override
  String get shareLink => 'Udostępnij link';

  @override
  String get connectedFriends => 'Połączeni znajomi';

  @override
  String get waitingForFriends => 'Oczekiwanie na znajomych...';

  @override
  String get endSharing => 'Zakończ udostępnianie';

  @override
  String get cookFriendsDescription =>
      'Zaproś znajomego, aby wspólnie ugotować ten przepis';

  @override
  String get sessionCode => 'KOD SESJI';

  @override
  String get adjustQuantityLabel =>
      'Dostosuj mnożnik ilości dla tego przepisu:';

  @override
  String get timerStartForStep => 'Minutnik dla kroku';

  @override
  String get enterRecipeUrl => 'Wpisz URL przepisu';

  @override
  String get loading => 'Wczytywanie...';

  @override
  String get urlInvalidScheme =>
      'URL musi zaczynać się od http:// lub https://';

  @override
  String get urlAddScheme => 'Dodaj https://';

  @override
  String get addItemPlaceholder => 'Dodaj artykuł...';

  @override
  String get addSuccessToast => 'Dodano!';

  @override
  String get completedItems => 'Zrobione';

  @override
  String get completeShoppingTitle => 'Zakończyć zakupy?';

  @override
  String get completeShoppingMessage => 'Usunąć zrobione artykuły?';

  @override
  String get recipeListTitle => '📖 Przepisy';

  @override
  String get importRecipeTitle => 'Prześlij nowy przepis';

  @override
  String get uploadRecipeUrl => 'Import przez URL przepisu';

  @override
  String get uploadRecipeUrlHint =>
      'Wpisz URL przepisu, aby zapisać go na swoim serwerze';

  @override
  String get uploadOpenAI => 'Import z pliku przez OpenAI';

  @override
  String get uploadOpenAIHint =>
      'Możesz też przesłać zdjęcia lub PDF przepisu. Jeśli przepis obejmuje kilka stron, dodaj po prostu kilka — zostaną przeanalizowane razem przez AI.';

  @override
  String get takePhoto => 'Aparat';

  @override
  String get cameraPermissionDenied =>
      'Brak dostępu do aparatu. Zezwól na niego w ustawieniach systemowych, aby fotografować przepisy.';

  @override
  String get cameraUnavailable => 'To urządzenie nie ma dostępnego aparatu.';

  @override
  String get selectPhoto => 'Zdjęcia';

  @override
  String get selectPdf => 'PDF';

  @override
  String get openAIHintTitle => 'Informacje o analizie pliku';

  @override
  String get openAIHintBody =>
      'Analiza przepisu korzysta z API OpenAI. Upewnij się, że Twój klucz API jest skonfigurowany w ustawieniach serwera Mealie.';

  @override
  String get allDeleteConfirm => 'Usuń wszystko';

  @override
  String get portionen => 'Porcje';

  @override
  String get timerForStep => 'Uruchom minutnik dla tego kroku';

  @override
  String get weekNavPrev => 'Poprzedni tydzień';

  @override
  String get weekNavNext => 'Następny tydzień';

  @override
  String get noMealsThisWeek => 'Brak zaplanowanych posiłków';

  @override
  String get entriesInOtherWeeks => 'Są wpisy w innych tygodniach';

  @override
  String get availableWeeks => 'Dostępne tygodnie:';

  @override
  String weekRange(Object end, Object start, Object week) {
    return 'Tydzień $week ($start – $end)';
  }

  @override
  String get currentWeek => 'Bieżący tydzień';

  @override
  String get rezepteAktualisieren => 'Aktualizuj przepisy';

  @override
  String get leftoverWhatTitle => 'Co robi ta funkcja?';

  @override
  String get leftoverWhatBody =>
      'Ta funkcja ponownie wczytuje wszystkie przepisy z serwera i aktualizuje lokalną pamięć podręczną.';

  @override
  String get leftoverDescription =>
      'Wpisz dostępne składniki, aby znaleźć pasujące przepisy i wykorzystać resztki.';

  @override
  String get leftoverIngredientsHeader => 'Składniki w domu';

  @override
  String get leftoverSuggestions => 'Propozycje przepisów';

  @override
  String get leftoverNoMatches => 'Nie znaleziono pasujących przepisów.';

  @override
  String get leftoverEnterIngredient => 'Wpisz składnik';

  @override
  String matchingPercentText(int percent, int count, int total) {
    return 'Dopasowanie: $percent% ($count/$total)';
  }

  @override
  String get weekAbbreviation => 'Tydz.';

  @override
  String get today => 'Dzisiaj';

  @override
  String get selectDate => 'Wybierz datę';

  @override
  String get selectSlot => 'Wybierz posiłek';

  @override
  String get selectedRecipe => 'Wybrany przepis';

  @override
  String get confirmMeal => 'Zaplanuj posiłek';

  @override
  String get searchRecipes => 'Szukaj przepisów';

  @override
  String get addCustomMeal => 'Dodaj własny posiłek';

  @override
  String get diceModeButton => 'Wylosuj przepisy';

  @override
  String get diceModeTitle => '3 losowe propozycje';

  @override
  String get diceBackToSearch => 'Powrót do wyszukiwania';

  @override
  String get diceNotEnoughRecipes =>
      'Za mało przepisów na tryb losowy (potrzeba co najmniej 3)';

  @override
  String get entrySingular => 'wpis';

  @override
  String get entriesPlural => 'wpisy';

  @override
  String listTitle(int n) {
    return 'Lista $n';
  }

  @override
  String get deleteAllConfirmTitle => 'Na pewno usunąć?';

  @override
  String get deleteAllConfirmMessage =>
      'Czy usunąć wszystkie zarchiwizowane zakupy?';

  @override
  String get uploadFromUrlButton => 'Importuj przepis z URL';

  @override
  String get uploadingImage => 'Przesyłanie...';

  @override
  String get uploadErrorTitle => 'Przesyłanie nie powiodło się';

  @override
  String get uploadSuccessTitle => 'Przesyłanie zakończone sukcesem';

  @override
  String get editImportedRecipeQuestion =>
      'Czy chcesz teraz edytować nowy przepis?';

  @override
  String get notNow => 'Nie teraz';

  @override
  String get pdfTooLarge => 'Plik PDF jest za duży (maks. 10 MB).';

  @override
  String get invalidUrl => 'Nieprawidłowy URL. Podaj prawidłowy adres HTTP(S).';

  @override
  String get cookWithFriends => 'Gotuj ze znajomymi';

  @override
  String get cookFriendsSubtitle =>
      'Zaproś znajomego, aby wspólnie ugotować ten przepis';

  @override
  String get copied => 'Skopiowano';

  @override
  String get linkCopied => 'Link skopiowany';

  @override
  String get startCooking => 'Zacznij gotować';

  @override
  String get hostNoRecipe => 'Otwórz przepis, aby zorganizować sesję';

  @override
  String get uploadToOwnServer => 'Zapisz na moim serwerze';

  @override
  String get uploadingRecipe => 'Przesyłanie przepisu…';

  @override
  String get recipeUploadedToOwnServer => 'Przepis zapisany na Twoim serwerze';

  @override
  String get recipeUploadFailed => 'Przesyłanie nie powiodło się';

  @override
  String get allowGuestSaveRecipes =>
      'Pozwól gościom zapisywać przepisy na własnym serwerze';

  @override
  String get appIcon => 'Ikona aplikacji';

  @override
  String get appIconClassic => 'Klasyczna';

  @override
  String get appIconModern => 'Nowoczesna';

  @override
  String get name => 'Nazwa';

  @override
  String get color => 'Kolor';

  @override
  String get randomColor => 'Losowy kolor';

  @override
  String get createFailed => 'Nie udało się utworzyć';

  @override
  String get deleteFailed => 'Nie udało się usunąć';

  @override
  String deleteOrganizerConfirm(String name) {
    return 'Usunąć „$name”? Zostanie to usunięte także na serwerze.';
  }

  @override
  String get connectionSection => 'Połączenie';

  @override
  String get token => 'Token';

  @override
  String get advancedOptions => 'Opcje zaawansowane';

  @override
  String get mealieApiVersion => 'Wersja API Mealie';

  @override
  String get sendOptionalHeaders => 'Wysyłaj opcjonalne nagłówki';

  @override
  String get offlineRecipeImages => 'Zapisuj zdjęcia przepisów offline';

  @override
  String get offlineRecipeImagesHint =>
      'Pobiera wszystkie zdjęcia przepisów na to urządzenie, aby były widoczne także bez połączenia. Przy dużych kolekcjach może to zająć kilkaset MB. Wyłączenie usuwa zapisane zdjęcia.';

  @override
  String offlineRecipeImagesStatus(int count, int total, String size) {
    return 'Zapisano: $count/$total · $size';
  }

  @override
  String get offlineRecipeImagesDisableConfirm =>
      'Usunąć wszystkie zapisane zdjęcia przepisów?';

  @override
  String headerNameLabel(int n) {
    return 'Nazwa nagłówka $n';
  }

  @override
  String headerValueLabel(int n) {
    return 'Wartość nagłówka $n';
  }

  @override
  String get value => 'Wartość';

  @override
  String get personalization => 'Personalizacja';

  @override
  String get showRecipeImagesSubtitle => 'Pokazuje zdjęcia na liście przepisów';

  @override
  String get exactQuantities => 'Dodawaj dokładne ilości';

  @override
  String get exactQuantitiesSubtitle =>
      'Składniki i wpisywane ręcznie artykuły zachowują ilość i jednostkę (np. 200 g masła) zamiast 1x na artykuł — brakujące produkty aplikacja tworzy na serwerze';

  @override
  String get remindToShop => 'Przypomnij mi o zakupach';

  @override
  String get remindToShopSubtitle =>
      'Powiadamia Cię, gdy jesteś w pobliżu zapisanej lokalizacji, a lista zakupów zawiera niezaznaczone produkty — nawet gdy aplikacja jest zamknięta';

  @override
  String get shoppingReminderAddLocation => 'Dodaj lokalizację';

  @override
  String get shoppingReminderMaxLocations =>
      'Osiągnięto maksymalnie 3 lokalizacje';

  @override
  String get shoppingReminderLocationServiceDisabled =>
      'Usługi lokalizacji są wyłączone na tym urządzeniu';

  @override
  String get shoppingReminderPermissionTitle =>
      'Wymagany dostęp do lokalizacji';

  @override
  String get shoppingReminderPermissionMessage =>
      'Aby przypominać Ci w pobliżu sklepu, potrzebny jest dostęp do lokalizacji „Zawsze” — nawet gdy aplikacja jest zamknięta. Włącz go w Ustawieniach.';

  @override
  String get openSettings => 'Otwórz ustawienia';

  @override
  String get shoppingReminderLocationName => 'Nazwa';

  @override
  String get shoppingReminderUseCurrentLocation => 'Użyj bieżącej lokalizacji';

  @override
  String get shoppingReminderOrAddress => 'lub wpisz adres';

  @override
  String get shoppingReminderAddress => 'Adres';

  @override
  String get shoppingReminderAddressPlaceholder => 'Ulica, miasto';

  @override
  String get shoppingReminderSearchAddress => 'Szukaj';

  @override
  String get shoppingReminderLocationFailed =>
      'Nie udało się ustalić lokalizacji';

  @override
  String get shoppingReminderAddressNotFound => 'Nie znaleziono adresu';

  @override
  String get ratingFailed => 'Nie udało się zapisać oceny — spróbuj ponownie.';

  @override
  String get lastCooked => 'Ostatnio ugotowane';

  @override
  String get syncLastCooked => 'Zaktualizuj „ostatnio ugotowane”';

  @override
  String get syncLastCookedSubtitle =>
      'Zapisuje dzisiejszą datę i wpis na osi czasu — tak jak w aplikacji webowej Mealie.';

  @override
  String get developer => 'Deweloper';

  @override
  String get enableLoggingSubtitle =>
      'Rejestruje logi print/błędów (ostatnie 500 linii)';

  @override
  String get entriesLabel => 'Wpisy';

  @override
  String get fileSize => 'Rozmiar pliku';

  @override
  String get showAction => 'Pokaż';

  @override
  String get copy => 'Kopiuj';

  @override
  String logsWithCount(int count) {
    return 'Logi ($count)';
  }

  @override
  String get noLogs => 'Brak dostępnych logów';

  @override
  String get logsTitle => 'Logi';

  @override
  String get required => 'Wymagane';

  @override
  String get connectionFailedCheck =>
      'Połączenie nie powiodło się. Sprawdź URL i token.';

  @override
  String get username => 'Nazwa użytkownika';

  @override
  String get password => 'Hasło';

  @override
  String get setupPasswordHint =>
      'Twoje hasło nie jest zapisywane — aplikacja loguje Cię jednorazowo i generuje z tego token API (tak samo jak Profil → Tokeny API w aplikacji webowej).';

  @override
  String get loginAndConnect => 'Zaloguj się i połącz';

  @override
  String get loginInvalidCredentials =>
      'Nieprawidłowa nazwa użytkownika lub hasło.';

  @override
  String get loginAndGenerateToken => 'Zaloguj się i wygeneruj token';

  @override
  String get loggingIn => 'Logowanie…';

  @override
  String get apiTokenSaveHint =>
      'Token zastosowany — stuknij poniżej „Zapisz zmiany”.';

  @override
  String get renewApiToken => 'Odnów token API';

  @override
  String get setupAuthChoiceTitle => 'Jak chcesz się zalogować?';

  @override
  String get authModePasswordTitle =>
      'Niech aplikacja utworzy dla mnie klucz API';

  @override
  String get authModePasswordSubtitle =>
      'Zaloguj się nazwą użytkownika i hasłem — aplikacja automatycznie wygeneruje token.';

  @override
  String get authModeTokenTitle => 'Mam już klucz API';

  @override
  String get authModeTokenSubtitle =>
      'Skopiowany z profilu Mealie (Profil → Tokeny API).';

  @override
  String keyN(int n) {
    return 'Klucz $n';
  }

  @override
  String valueN(int n) {
    return 'Wartość $n';
  }

  @override
  String get openCookingMode => 'Otwórz tryb gotowania';

  @override
  String activeRecipes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count aktywnego przepisu',
      many: '$count aktywnych przepisów',
      few: '$count aktywne przepisy',
      one: '1 aktywny przepis',
    );
    return '$_temp0';
  }

  @override
  String get reparseIngredients => 'Parsuj składniki ponownie';

  @override
  String get reparseIngredientsSubtitle =>
      'Rozdziel ilość/jednostkę/składnik (np. „200 g mąki”)';

  @override
  String get reparseDone =>
      'Składniki rozdzielone – stuknij „Zapisz zmiany”, aby zastosować';

  @override
  String get reparseNone => 'Nie znaleziono składników do rozdzielenia';

  @override
  String get tagsAndCategories => 'Tagi, kategorie i przybory kuchenne';

  @override
  String get tapToAddPhoto => 'Stuknij, aby dodać zdjęcie';

  @override
  String get descriptionLabel => 'Opis';

  @override
  String get searchingDevices => 'Szukanie urządzeń w tej samej sieci Wi-Fi…';

  @override
  String get selectAll => 'Zaznacz wszystko';

  @override
  String get importReminders => 'Importuj przypomnienia';

  @override
  String get importGoogleTasks => 'Importuj Google Tasks';

  @override
  String get noTaskLists => 'Nie znaleziono list zadań';

  @override
  String get noReminderLists => 'Nie znaleziono list przypomnień';

  @override
  String importCount(int count) {
    return 'Importuj $count';
  }

  @override
  String get activeRecipeTimer => 'Aktywny minutnik przepisu';

  @override
  String get linkIngredients => 'Połącz składniki';

  @override
  String get noIngredientsToLink => 'Brak składników do połączenia';

  @override
  String get importLanguageSubtitle =>
      'Język dla przepisów importowanych ze zdjęcia lub PDF-a';

  @override
  String get importLanguageSearch => 'Szukaj języka';

  @override
  String get importLanguageFollowApp => 'Taki sam jak język aplikacji';

  @override
  String get importLanguageNoMatch => 'Nie znaleziono języka';

  @override
  String get setupImportLanguageTitle => 'Import przepisów przez AI';

  @override
  String get setupImportLanguageBody =>
      'Zdjęcia i pliki PDF mogą zostać zamienione w przepisy przez AI. Wybierz język, w którym mają się pojawić — przydatne, jeśli Twój język ojczysty nie jest dostępny jako język aplikacji. Możesz to później zmienić w ustawieniach.';

  @override
  String get setupImportLanguageSearchHint =>
      'Skorzystaj z wyszukiwania w wyborze, aby znaleźć języki, których nie oferuje interfejs aplikacji.';

  @override
  String get setupCachingKeepOpenTitle => 'Nie zamykaj aplikacji';

  @override
  String get setupCachingKeepOpenBody =>
      'Wczytywanie działa na pierwszym planie. Zostaw aplikację otwartą, aż się zakończy — jeśli ją zamkniesz lub przełączysz się na zbyt długo, proces zatrzyma się i wznowi później.';

  @override
  String get supportContact => 'Skontaktuj się z pomocą';

  @override
  String get supportDialogMessage =>
      'Opisz swój problem, a odezwiemy się do Ciebie. Log bardzo pomaga w rozwiązywaniu problemów — możesz dołączyć go jako plik tekstowy.';

  @override
  String get supportWithoutLogs => 'Bez logu';

  @override
  String get supportWithLogs => 'Dołącz log';

  @override
  String get supportMailSubject => 'Mealie Recipes — Wsparcie';

  @override
  String get supportMailHint => 'Opisz tutaj swój problem:';

  @override
  String get supportLogsEmpty =>
      'Log jest pusty. Włącz rejestrowanie, odtwórz problem, a następnie wyślij go.';

  @override
  String supportAddressCopied(String email) {
    return 'Adres skopiowany: $email';
  }

  @override
  String supportNoMailApp(String email) {
    return 'Nie znaleziono aplikacji pocztowej. Adres skopiowany: $email';
  }

  @override
  String get createRecipeFromImages => 'Utwórz przepis';

  @override
  String imagePagesSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Wybrano $count strony',
      many: 'Wybrano $count stron',
      few: 'Wybrano $count strony',
      one: 'Wybrano 1 stronę',
    );
    return '$_temp0';
  }

  @override
  String get imagePagesHint =>
      'Pierwsze zdjęcie stanie się głównym zdjęciem przepisu. Przytrzymaj stronę, aby zmienić jej kolejność.';

  @override
  String get mainImageBadge => 'Główne';

  @override
  String maxImagesReached(int max) {
    return 'Możesz dodać maksymalnie $max zdjęć do jednego przepisu.';
  }

  @override
  String get removePage => 'Usuń stronę';

  @override
  String get preparingPdf => 'Przetwarzanie PDF...';

  @override
  String get shareRecipeTitle => 'Udostępnij przepis';

  @override
  String get recipeOptionsTitle => 'Opcje';

  @override
  String get exportAsPdf => 'Eksportuj jako PDF';

  @override
  String get generatingPdf => 'Tworzenie PDF…';

  @override
  String get pdfExportFailed => 'Eksport do PDF nie powiódł się';

  @override
  String get recipeTime => 'Czas';

  @override
  String get ingredientSectionTitle => 'Sekcja';

  @override
  String get addIngredientSection => 'Dodaj sekcję';

  @override
  String get aiImportToggle => 'Analizuj z AI';

  @override
  String get aiImportToggleHint =>
      'Także dla filmów z przepisami (YouTube, Instagram, TikTok …) i stron, których zwykły import nie potrafi odczytać. Wymaga dostawcy AI na Twoim serwerze Mealie – dla filmów także dostawcy audio.';

  @override
  String get aiImportButton => 'Importuj z AI';

  @override
  String get aiImportRunning =>
      'AI analizuje link … w przypadku filmów może to potrwać kilka minut.';

  @override
  String get aiImportFailed =>
      'Import z AI nie powiódł się. Sprawdź ustawienia AI na swoim serwerze Mealie.';

  @override
  String get stepHeadingLabel => 'Nagłówek kroku (opcjonalnie)';

  @override
  String get linkedRecipeLabel => 'Powiązany przepis';

  @override
  String get toolsTitle => 'Przybory kuchenne';

  @override
  String get prepareTools => 'Przygotuj następujące przybory kuchenne';

  @override
  String get newTool => 'Nowy przybór';

  @override
  String get renameAction => 'Zmień nazwę';

  @override
  String get organizerEmpty =>
      'Brak wpisów. Stuknij „+” w prawym górnym rogu, aby dodać nowy.';

  @override
  String organizerRecipeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count przepisu',
      many: '$count przepisów',
      few: '$count przepisy',
      one: '1 przepis',
      zero: 'Brak przepisów',
    );
    return '$_temp0';
  }

  @override
  String get toolOnHand => 'Dostępny';

  @override
  String get mealDiceSettingsTitle => 'Filtr kostki';

  @override
  String get mealDiceSettingsHint =>
      'Wybierz kategorie i tagi dla każdego posiłku. Kostka zaproponuje wtedy tylko przepisy, które mają co najmniej jeden z nich. Ten sam wybór może dotyczyć kilku posiłków.';

  @override
  String get mealDiceSettingsNoneHint =>
      'Dla tego posiłku nic nie wybrano: kostka wybiera automatycznie według kategorii takich jak „Śniadanie”, „Obiad” czy „Kolacja”.';

  @override
  String get mealDiceAutoHintTitle => 'Wybór automatyczny';

  @override
  String get mealDiceAutoHintBody =>
      'Dla tego posiłku nie ustawiono jeszcze kategorii ani tagów. Kostka szuka więc kategorii takich jak „Śniadanie”, „Obiad” czy „Kolacja” i uzupełnia innymi przepisami.\n\nWłasny wybór: w planie posiłków stuknij koło zębate obok „+”.';

  @override
  String get dontShowAgain => 'Nie pokazuj ponownie';

  @override
  String get mealDiceNoMatches =>
      'Żaden przepis nie pasuje do kategorii i tagów wybranych dla tego posiłku.';

  @override
  String mealDiceFewMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tylko $count pasującego przepisu',
      many: 'Tylko $count pasujących przepisów',
      few: 'Tylko $count pasujące przepisy',
      one: 'Tylko 1 pasujący przepis',
    );
    return '$_temp0';
  }

  @override
  String get commentsTitle => 'Komentarze';

  @override
  String get commentHint => 'Napisz komentarz…';

  @override
  String get commentSaveFailed => 'Nie udało się zapisać komentarza.';

  @override
  String get commentDeleteConfirm => 'Usunąć ten komentarz?';

  @override
  String get cookingDoneCommentLabel => 'Komentarz (opcjonalnie)';

  @override
  String get cookingDoneCommentHint => 'Jak wyszło? Wskazówki na następny raz…';

  @override
  String get nutritionTitle => 'Wartości odżywcze';

  @override
  String get nutritionPerServing => 'na porcję';

  @override
  String get nutritionCalories => 'Kalorie';

  @override
  String get nutritionFat => 'Tłuszcz';

  @override
  String get nutritionSaturatedFat => 'Tłuszcze nasycone';

  @override
  String get nutritionTransFat => 'Tłuszcze trans';

  @override
  String get nutritionUnsaturatedFat => 'Tłuszcze nienasycone';

  @override
  String get nutritionCholesterol => 'Cholesterol';

  @override
  String get nutritionSodium => 'Sód';

  @override
  String get nutritionCarbohydrates => 'Węglowodany';

  @override
  String get nutritionFiber => 'Błonnik';

  @override
  String get nutritionSugar => 'Cukier';

  @override
  String get nutritionProtein => 'Białko';

  @override
  String get timelineTitle => 'Oś czasu';

  @override
  String get timelineMadeThis => 'Ugotowałem/-am to';

  @override
  String timelineUserMadeThis(String name) {
    return '$name ugotował(a) to';
  }

  @override
  String get timelineEmpty => 'Brak wpisów na osi czasu.';

  @override
  String get timelineDate => 'Data';

  @override
  String get timelineNoteHint => 'Notatka (opcjonalnie)';

  @override
  String get timelineAddPhoto => 'Dodaj zdjęcie';

  @override
  String get timelineRemovePhoto => 'Usuń zdjęcie';

  @override
  String get timelineSaved => 'Dodano do osi czasu';

  @override
  String get timelineSaveFailed => 'Nie udało się dodać do osi czasu';

  @override
  String get timelineImageFailed =>
      'Wpis zapisany, ale nie udało się przesłać zdjęcia';

  @override
  String get timelineDeleteConfirm => 'Usunąć ten wpis z osi czasu?';

  @override
  String get timelineEditNote => 'Edytuj notatkę';

  @override
  String get timelineUnknownRecipe => 'Nie znaleziono przepisu';

  @override
  String get cookingDonePhotoHint => 'Zdjęcie na oś czasu Mealie (opcjonalnie)';

  @override
  String get assetsTitle => 'Załączniki';

  @override
  String get assetsAdd => 'Dodaj załącznik';

  @override
  String get assetsChooseFile => 'Plik';

  @override
  String get assetsUploading => 'Przesyłanie…';

  @override
  String get assetsUploadFailed => 'Nie udało się przesłać załącznika';

  @override
  String assetsDeleteConfirm(String name) {
    return 'Usunąć „$name” z załączników?';
  }

  @override
  String get assetsOpenFailed => 'Nie udało się otworzyć załącznika';

  @override
  String get assetsUnsupported =>
      'Mealie obsługuje tylko PDF, obrazy, TXT, MD, CSV i JSON.';

  @override
  String get assetsShare => 'Udostępnij';

  @override
  String get mealRulesTitle => 'Reguły Mealie';

  @override
  String get mealRulesHint =>
      'Działają też w aplikacji webowej Mealie. Jeśli do dnia i posiłku pasuje kilka reguł, muszą być spełnione wszystkie. Jeśli żadna nie pasuje, kostka losuje spośród wszystkich przepisów.';

  @override
  String get mealRuleAdd => 'Dodaj regułę';

  @override
  String get mealRuleNewTitle => 'Nowa reguła';

  @override
  String get mealRuleEditTitle => 'Edytuj regułę';

  @override
  String get mealRuleDay => 'Dzień';

  @override
  String get mealRuleAnyDay => 'Każdy dzień';

  @override
  String get mealRuleMealType => 'Posiłek';

  @override
  String get mealRuleAnyMeal => 'Każdy posiłek';

  @override
  String get mealRuleConditionsTitle => 'Warunki';

  @override
  String get mealRuleAllRecipes => 'Wszystkie przepisy';

  @override
  String get mealRuleDeleteConfirm => 'Usunąć tę regułę?';

  @override
  String get mealRulesOffline =>
      'Reguły Mealie są teraz niedostępne – kostka korzysta z wyboru aplikacji.';

  @override
  String get mealRulesNoMatches =>
      'Żaden przepis nie spełnia reguł Mealie dla tego posiłku.';

  @override
  String get mealTypeSide => 'Dodatek';

  @override
  String get mealTypeSnack => 'Przekąska';

  @override
  String get mealTypeDrink => 'Napój';

  @override
  String get mealTypeDessert => 'Deser';

  @override
  String get foodsTitle => 'Produkty';

  @override
  String get unitsTitle => 'Jednostki';

  @override
  String get newFood => 'Nowy produkt';

  @override
  String get newUnit => 'Nowa jednostka';

  @override
  String get editFood => 'Edytuj produkt';

  @override
  String get editUnit => 'Edytuj jednostkę';

  @override
  String get pluralNameLabel => 'Nazwa w liczbie mnogiej';

  @override
  String get abbreviationLabel => 'Skrót';

  @override
  String get pluralAbbreviationLabel => 'Skrót (liczba mnoga)';

  @override
  String get mergeAction => 'Scal';

  @override
  String mergeIntoTitle(String name) {
    return 'Scal „$name” z…';
  }

  @override
  String mergeConfirm(String from, String to) {
    return '„$from” zostanie scalone z „$to”: wszystkie przepisy i listy zakupów będą potem używać „$to”, a „$from” zostanie usunięte.';
  }

  @override
  String get mergeFailed => 'Scalanie nie powiodło się';

  @override
  String foodUnitDeleteConfirm(String name) {
    return 'Usunąć „$name”? Składniki, które go używają, stracą powiązanie.';
  }

  @override
  String get foodsUnitsEmpty => 'Brak wpisów.';

  @override
  String mealRuleConditionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count warunku',
      many: '$count warunków',
      few: '$count warunki',
      one: '1 warunek',
    );
    return '$_temp0';
  }

  @override
  String get showAll => 'Pokaż wszystko';

  @override
  String get mealDiceModeTitle => 'Kostka używa';

  @override
  String get mealDiceModeApp => 'Wybór aplikacji';

  @override
  String get switchListTitle => 'Zmień listę';

  @override
  String get newShoppingList => 'Nowa lista zakupów';

  @override
  String shoppingListDeleteConfirm(String name) {
    return 'Usunąć „$name”? Wszystkie pozycje na niej też zostaną usunięte.';
  }

  @override
  String get labelOrderTitle => 'Sortuj etykiety';

  @override
  String get labelOrderHint =>
      'Przeciągnij, aby posortować. Dotyczy tej listy – także w aplikacji webowej Mealie.';

  @override
  String get labelOrderEmpty => 'Ta lista nie ma jeszcze etykiet.';

  @override
  String get useAsActiveList => 'Użyj jako aktywnej listy';

  @override
  String get activeListBadge => 'Aktywna';

  @override
  String get foodLabelLabel => 'Etykieta';

  @override
  String get foodNoLabel => 'Brak etykiety';

  @override
  String get aliasesLabel => 'Aliasy';

  @override
  String get aliasAddHint => 'Dodaj alias';

  @override
  String get foodOnHand => 'Dostępne w gospodarstwie';

  @override
  String get timelineChildRecipesTitle => 'Dodaj też do powiązanych przepisów';

  @override
  String timelineMadeForRecipe(String recipe) {
    return 'Przygotowano do: $recipe';
  }

  @override
  String get timelineFilter => 'Filtruj wpisy';

  @override
  String get timelineTypeComment => 'Ugotowane i notatki';

  @override
  String get timelineTypeInfo => 'Informacje';

  @override
  String get timelineTypeSystem => 'System';

  @override
  String get listManagementTitle => 'Listy zakupów';

  @override
  String get managementTitle => 'Więcej';

  @override
  String get pinToHome => 'Dodaj do ekranu głównego';

  @override
  String get unpinFromHome => 'Usuń z ekranu głównego';

  @override
  String homeScreenFull(int count) {
    return 'Ekran główny jest pełny – maksymalnie $count kafelków. Najpierw usuń inny kafelek w „Więcej”.';
  }

  @override
  String get selectAction => 'Zaznacz';

  @override
  String selectedCount(int count) {
    return 'Zaznaczono: $count';
  }

  @override
  String get assignLabelAction => 'Przypisz etykietę';

  @override
  String get assignLabelOverwriteHint =>
      'Nadpisuje etykietę wszystkich zaznaczonych produktów.';

  @override
  String deleteSelectedConfirm(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Usunąć $count wpisu?',
      many: 'Usunąć $count wpisów?',
      few: 'Usunąć $count wpisy?',
      one: 'Usunąć 1 wpis?',
    );
    return '$_temp0';
  }

  @override
  String get seedDataAction => 'Wczytaj dane domyślne';

  @override
  String get seedFoodsHint =>
      'Tworzy domyślne produkty Mealie w wybranym języku.';

  @override
  String get seedUnitsHint =>
      'Tworzy domyślne jednostki Mealie w wybranym języku.';

  @override
  String get seedLanguageLabel => 'Język';

  @override
  String get seedDuplicateWarning =>
      'Masz już wpisy. Mealie nie uzgadnia duplikatów – trzeba je potem scalić samodzielnie.';

  @override
  String get seedDone => 'Utworzono dane domyślne';

  @override
  String get seedFailed => 'Nie udało się wczytać danych domyślnych';

  @override
  String get exportAction => 'Eksportuj';

  @override
  String get substitutionsLabel => 'Zamienniki';

  @override
  String get substitutionAddHint => 'Dodaj zamiennik';

  @override
  String get substitutionFoodLabel => 'Produkt (opcjonalnie)';

  @override
  String get substitutionNoteLabel => 'Notatka (opcjonalnie)';

  @override
  String get substitutionNeedOne => 'Podaj produkt lub notatkę';

  @override
  String get useAbbreviationLabel => 'Używaj skrótu';

  @override
  String get useAbbreviationHint => 'Pokazuj w przepisach „g” zamiast „gram”';

  @override
  String get fractionLabel => 'Pokazuj jako ułamek';

  @override
  String get fractionHint => '½ zamiast 0,5';

  @override
  String get standardizationTitle => 'Standaryzacja';

  @override
  String get standardizationHint =>
      'Do przeliczeń: 1 tej jednostki to … (np. 1 łyżka = 15 mililitrów).';

  @override
  String get standardQuantityLabel => 'Ilość standardowa';

  @override
  String get standardUnitLabel => 'Jednostka standardowa';

  @override
  String get standardUnitNone => 'Brak';

  @override
  String get stdFluidOunce => 'Uncja płynu (fl oz)';

  @override
  String get stdCup => 'Szklanka (US)';

  @override
  String get stdOunce => 'Uncja (oz)';

  @override
  String get stdPound => 'Funt (lb)';

  @override
  String get stdMilliliter => 'Mililitr';

  @override
  String get stdLiter => 'Litr';

  @override
  String get stdGram => 'Gram';

  @override
  String get stdKilogram => 'Kilogram';

  @override
  String get labelsTitle => 'Etykiety';

  @override
  String get newLabel => 'Nowa etykieta';

  @override
  String get editLabel => 'Edytuj etykietę';

  @override
  String get colorLabel => 'Kolor';

  @override
  String labelDeleteConfirm(String name) {
    return 'Usunąć „$name”? Pozycje i produkty stracą tę etykietę.';
  }

  @override
  String get importMenuAction => 'Importuj';

  @override
  String get archivedEmpty =>
      'Brak zarchiwizowanych zakupów. Po zakupach stuknij „Zakończ zakupy” – odhaczone pozycje trafią tutaj.';

  @override
  String get sectionTitleLabel => 'Tytuł sekcji';

  @override
  String get clearSection => 'Usuń sekcję';

  @override
  String get noPermissionGeneric =>
      'Nie masz do tego uprawnień w Mealie. Zapytaj administratora lub zarządcę gospodarstwa.';

  @override
  String get noPermissionEditRecipe =>
      'Nie możesz edytować tego przepisu – jest zablokowany lub należy do innego gospodarstwa. Może to zrobić tylko jego twórca lub administrator.';

  @override
  String get noPermissionDeleteRecipe =>
      'Tylko twórca przepisu lub administrator może go usunąć.';

  @override
  String get noPermissionDemoteSelf =>
      'Nie możesz odebrać sobie uprawnień administratora.';

  @override
  String get recipeLockedHint => 'Zablokowany – edytować może tylko twórca';

  @override
  String get recipeDeleteOwnerOnlyHint =>
      'Usunąć może tylko twórca lub administrator';

  @override
  String get organizeReadOnlyHint =>
      'Tylko podgląd: tworzenie, zmiana i usuwanie wymaga uprawnienia „Użytkownik może zarządzać produktami, tagami i kategoriami”.';

  @override
  String get notesNotSavedNoPermission =>
      'Notatka nie została zapisana – nie masz uprawnień do edycji tego przepisu.';

  @override
  String get userManagementTitle => 'Zarządzanie użytkownikami';

  @override
  String get usersTitle => 'Użytkownicy';

  @override
  String get editUserTitle => 'Edytuj użytkownika';

  @override
  String get fullNameLabel => 'Imię i nazwisko';

  @override
  String get usernameLabel => 'Nazwa użytkownika';

  @override
  String get emailLabel => 'E-mail';

  @override
  String get passwordLabel => 'Hasło';

  @override
  String get householdLabel => 'Gospodarstwo domowe';

  @override
  String get permissionsTitle => 'Uprawnienia';

  @override
  String get administratorLabel => 'Administrator';

  @override
  String get permCanInvite => 'Użytkownik może zaprosić innych do grupy';

  @override
  String get permCanManage => 'Użytkownik może zarządzać ustawieniami grupy';

  @override
  String get permCanManageHousehold =>
      'Użytkownik może zarządzać gospodarstwem domowym';

  @override
  String get permCanOrganize =>
      'Użytkownik może zarządzać produktami, tagami i kategoriami';

  @override
  String get advancedFeaturesLabel => 'Włącz zaawansowane funkcje';

  @override
  String get passwordResetLinkAction => 'Wygeneruj link resetowania hasła';

  @override
  String get resetLockedUsersAction => 'Zresetuj zablokowanych użytkowników';

  @override
  String get membersTitle => 'Członkowie';

  @override
  String get inviteLinkTitle => 'Link do zaproszenia';

  @override
  String get inviteAction => 'Zaproś';

  @override
  String get userUpdated => 'Użytkownik został zaktualizowany';

  @override
  String get createUserTitle => 'Utwórz użytkownika';

  @override
  String get userCreated => 'Utworzono użytkownika';

  @override
  String userDeleteConfirm(String name) {
    return 'Usunąć „$name”? Konto zostanie usunięte z Mealie.';
  }

  @override
  String get passwordResetLinkCopied =>
      'Link skopiowany – przekaż go użytkownikowi. Jest ważny tylko przez ograniczony czas.';

  @override
  String lockedUsersReset(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Odblokowano $count użytkownika',
      many: 'Odblokowano $count użytkowników',
      few: 'Odblokowano $count użytkowników',
      one: 'Odblokowano 1 użytkownika',
      zero: 'Brak zablokowanych użytkowników',
    );
    return '$_temp0';
  }

  @override
  String get inviteUsesLabel => 'Liczba użyć';

  @override
  String get inviteCreated => 'Utworzono link zaproszenia';

  @override
  String get inviteEmailHint =>
      'Adres e-mail (opcjonalnie – Mealie wyśle zaproszenie)';

  @override
  String get inviteEmailSent => 'Zaproszenie wysłane e-mailem';

  @override
  String get inviteEmailFailed =>
      'Nie udało się wysłać e-maila (czy SMTP jest skonfigurowany w Mealie?). Link i tak działa.';

  @override
  String get copyLinkAction => 'Kopiuj link';

  @override
  String get youLabel => 'Ty';

  @override
  String get membersPermissionsHint =>
      'Możesz zmieniać uprawnienia członków swojego gospodarstwa – ale nie własne.';

  @override
  String get householdManagementTitle => 'Zarządzanie gospodarstwem domowym';

  @override
  String get householdsTitle => 'Gospodarstwa domowe';

  @override
  String get createHouseholdTitle => 'Utwórz gospodarstwo domowe';

  @override
  String get householdNameLabel => 'Nazwa gospodarstwa domowego';

  @override
  String get householdPreferencesTitle => 'Preferencje gospodarstwa domowego';

  @override
  String get privateHouseholdLabel => 'Prywatne gospodarstwo domowe';

  @override
  String get privateHouseholdHint =>
      'Ustawienie gospodarstwa domowego na prywatne wyłączy wszystkie opcje widoku publicznego. To nadpisuje wszystkie indywidualne ustawienia widoku publicznego';

  @override
  String get lockRecipeEditsLabel =>
      'Zablokuj możliwość edycji przepisów z innych gospodarstw domowych';

  @override
  String get lockRecipeEditsHint =>
      'Po włączeniu tylko użytkownicy w Twoim gospodarstwie domowym mogą edytować przepisy utworzone przez Twoje gospodarstwo domowe';

  @override
  String get householdRecipePreferencesTitle =>
      'Preferencje przepisów w gospodarstwie domowym';

  @override
  String get groupsTitle => 'Grupy';

  @override
  String get groupLabel => 'Grupa';

  @override
  String get createGroupTitle => 'Utwórz grupę';

  @override
  String get groupNameLabel => 'Nazwa grupy';

  @override
  String get groupPreferencesTitle => 'Preferencje grupy';

  @override
  String get privateGroupLabel => 'Prywatna Grupa';

  @override
  String get privateGroupHint =>
      'Ustawienie twojej grupy na prywatne spowoduje wyłączenie wszystkich opcji widoku publicznego. To nadpisuje wszystkie ustawienia widoku publicznego';

  @override
  String get firstDayOfWeekLabel => 'Pierwszy dzień tygodnia';

  @override
  String get showAnnouncementsLabel => 'Pokazuj ogłoszenia z Mealie';

  @override
  String get recipePublicDefaultLabel =>
      'Zezwalaj użytkownikom spoza twojej grupy na oglądanie twoich przepisów';

  @override
  String get recipeShowNutritionDefaultLabel =>
      'Pokaż informacje o wartości odżywczej';

  @override
  String get recipeShowAssetsDefaultLabel => 'Pokaż załączniki przepisu';

  @override
  String get recipeLandscapeDefaultLabel => 'Domyślnie w widoku poziomym';

  @override
  String get recipeDisableCommentsDefaultLabel =>
      'Zablokuj użytkownikom komentowanie przepisów';

  @override
  String get myHouseholdSection => 'Moje gospodarstwo domowe';

  @override
  String get myGroupSection => 'Moja grupa';

  @override
  String get preferencesSaved => 'Zapisano ustawienia';

  @override
  String get cannotDeleteWithUsers =>
      'Nadal ma użytkowników – najpierw przenieś ich lub usuń w zarządzaniu użytkownikami.';

  @override
  String deleteHouseholdConfirm(String name) {
    return 'Usunąć gospodarstwo domowe „$name”?';
  }

  @override
  String deleteGroupConfirm(String name) {
    return 'Usunąć grupę „$name”?';
  }

  @override
  String usersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count użytkownika',
      many: '$count użytkowników',
      few: '$count użytkowników',
      one: '1 użytkownik',
      zero: 'Brak użytkowników',
    );
    return '$_temp0';
  }

  @override
  String get originalUrlLabel => 'Oryginalny adres URL';

  @override
  String get copyTextAction => 'Kopiuj tekst';

  @override
  String get copiedToClipboard => 'Skopiowano do schowka';

  @override
  String get changelogEnglishHint =>
      'Nowości są dostępne tylko po angielsku – przyciskiem „Kopiuj tekst” wkleisz je np. do tłumacza.';

  @override
  String get favoritesTitle => 'Ulubione';

  @override
  String get favoritesEmpty =>
      'Brak ulubionych. Stuknij serce w przepisie, aby go tu zebrać.';

  @override
  String get changelogTitle => 'Changelog';

  @override
  String get changeProfileImage => 'Zmień zdjęcie profilowe';

  @override
  String get profileImageUpdated => 'Zaktualizowano zdjęcie profilowe';

  @override
  String get profileImageFailed => 'Nie udało się przesłać zdjęcia profilowego';

  @override
  String get myAccountTitle => 'Moje konto';

  @override
  String get ownAccountHint =>
      'Tutaj możesz edytować własne konto. Innymi użytkownikami zarządzają administratorzy i członkowie z uprawnieniem „zarządzanie\".';

  @override
  String get changePasswordAction => 'Zmień hasło';

  @override
  String get currentPasswordLabel => 'Obecne hasło';

  @override
  String get newPasswordLabel => 'Nowe hasło';

  @override
  String get confirmPasswordLabel => 'Potwierdź hasło';

  @override
  String get passwordTooShort => 'Co najmniej 8 znaków';

  @override
  String get passwordsDoNotMatch => 'Hasła nie są zgodne';

  @override
  String get passwordUpdated => 'Hasło zaktualizowane';

  @override
  String get passwordChangeFailed => 'Nie udało się zmienić hasła';

  @override
  String passwordManagedExternally(String method) {
    return 'Logujesz się przez $method — tam zmienisz hasło.';
  }

  @override
  String get bulkAddHint => 'Jedna linia na pozycję.';

  @override
  String bulkAddCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dodaj $count pozycji',
      many: 'Dodaj $count pozycji',
      few: 'Dodaj $count pozycje',
      one: 'Dodaj 1 pozycję',
    );
    return '$_temp0';
  }

  @override
  String get linkRecipeAction => 'Połącz przepis';

  @override
  String get useFoodAction => 'Produkt zamiast przepisu';

  @override
  String get addSubstitutionsAction => 'Dodaj zamienniki';

  @override
  String get clearSubstitutionsAction => 'Usuń zamienniki';

  @override
  String get recipeSubstitutionsTitle => 'Zamienniki';

  @override
  String get substitutionUnknownFood =>
      'Tylko istniejące produkty – w przeciwnym razie użyj notatki';

  @override
  String get insertAboveAction => 'Wstaw powyżej';

  @override
  String get insertBelowAction => 'Wstaw poniżej';

  @override
  String get moveToTopAction => 'Przesuń na samą górę';

  @override
  String get moveToBottomAction => 'Przesuń na sam dół';

  @override
  String get linkReferencesAction => 'Połącz odniesienia';

  @override
  String get editMarkdownAction => 'Edytuj Markdown';

  @override
  String get previewMarkdownAction => 'Podgląd Markdowna';

  @override
  String get insertStepImageAction => 'Prześlij obraz';

  @override
  String get mergeAboveAction => 'Scal z powyższym';

  @override
  String get linkedToOtherStep => 'Powiązane z innym krokiem';

  @override
  String get noNotesToLink => 'Brak notatek do połączenia';

  @override
  String get ownerLabel => 'Właściciel';

  @override
  String get ingredientParserTitle => 'Parser składników';

  @override
  String ingredientParserHint(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count składników nie jest jeszcze ustrukturyzowanych. Wybierz parser, sprawdź wynik, zastosuj.',
      many:
          '$count składników nie jest jeszcze ustrukturyzowanych. Wybierz parser, sprawdź wynik, zastosuj.',
      few:
          '$count składniki nie są jeszcze ustrukturyzowane. Wybierz parser, sprawdź wynik, zastosuj.',
      one:
          '1 składnik nie jest jeszcze ustrukturyzowany. Wybierz parser, sprawdź wynik, zastosuj.',
    );
    return '$_temp0';
  }

  @override
  String get parserNlp => 'Procesor języka naturalnego';

  @override
  String get parserBrute => 'Parser brutalny';

  @override
  String get parserOpenai => 'Parser OpenAI';

  @override
  String get parserApp => 'Offline (aplikacja)';

  @override
  String get parseFailed => 'Analiza nie powiodła się';

  @override
  String get parseAction => 'Analizuj';

  @override
  String applyParsedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Zastosuj $count składników',
      many: 'Zastosuj $count składników',
      few: 'Zastosuj $count składniki',
      one: 'Zastosuj 1 składnik',
      zero: 'Nic nie wybrano',
    );
    return '$_temp0';
  }

  @override
  String get parsedNewBadge => 'nowy';

  @override
  String get hoursShort => 'godz.';

  @override
  String get minutesShort => 'min';

  @override
  String get timeExtraHint => 'Dodatek, np. „plus cała noc”';

  @override
  String get yieldLabel => 'Porcja';

  @override
  String get yieldTextLabel => 'Jednostka „Ilość”';

  @override
  String get prepTimeLabel => 'Czas przyrządzania';

  @override
  String get performTimeLabel => 'Czas gotowania';

  @override
  String get totalTimeLabel => 'Czas całkowity';

  @override
  String get settingPublicRecipe => 'Przepis publiczny';

  @override
  String get settingShowNutrition => 'Pokaż wartości odżywcze';

  @override
  String get settingShowAssets => 'Wyświetl załączniki';

  @override
  String get settingLandscapeView => 'Widok poziomy';

  @override
  String get settingDisableComments => 'Wyłącz komentarze';

  @override
  String get settingDisableAmount => 'Wyłącz ilości składników';

  @override
  String get settingLocked => 'Zablokowany';

  @override
  String get settingLockedOwnerOnly =>
      'Tylko twórca może zablokować lub odblokować przepis.';

  @override
  String get apiExtrasTitle => 'Dodatki API';

  @override
  String get apiExtrasHint =>
      'Własne pary klucz/wartość dla aplikacji zewnętrznych, np. do wyzwalania automatyzacji.';

  @override
  String get extraKeyLabel => 'Klucz';

  @override
  String get extraValueLabel => 'Wartość';

  @override
  String get addExtraAction => 'Dodaj dodatek';

  @override
  String durationHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count godziny',
      many: '$count godzin',
      few: '$count godziny',
      one: '1 godzina',
    );
    return '$_temp0';
  }

  @override
  String durationMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minuty',
      many: '$count minut',
      few: '$count minuty',
      one: '1 minuta',
    );
    return '$_temp0';
  }

  @override
  String get discardChangesConfirm => 'Odrzucić niezapisane zmiany?';

  @override
  String get discardChanges => 'Odrzuć zmiany';

  @override
  String get imageFromUrl => 'Obraz z adresu URL';

  @override
  String get deleteRecipeImage => 'Usuń obrazek przepisu';

  @override
  String get deleteRecipeImageConfirm =>
      'Czy na pewno chcesz usunąć obrazek przepisu?';

  @override
  String get bulkAddIngredients => 'Dodaj składniki zbiorczo';

  @override
  String get bulkAddSteps => 'Dodaj kroki zbiorczo';

  @override
  String get stepImageFailed => 'Nie udało się przesłać obrazu';

  @override
  String get servingsAndTimes => 'Porcje i czasy';

  @override
  String get recipeSettingsTitle => 'Ustawienia przepisu';

  @override
  String get jsonEditorTitle => 'Edytor JSON';

  @override
  String get jsonInvalid => 'Nieprawidłowy JSON – sprawdź.';

  @override
  String get editorOfflineHint =>
      'Otwarto offline: zapis wymaga połączenia. Nowsze pola Mealie (np. zamienniki) pozostaną bez zmian.';

  @override
  String get parseLineFailed => 'Nie rozpoznano – pozostaje bez zmian';

  @override
  String get createManualTitle => 'Utwórz przepis ręcznie';

  @override
  String get createManualHint =>
      'Podaj nazwę – składniki, kroki, zdjęcie i resztę dodasz potem w edytorze przepisu.';

  @override
  String get createManualButton => 'Utwórz i edytuj';

  @override
  String get changelogEmpty => 'Brak jeszcze wpisów dla tej wersji.';

  @override
  String get finderDescription =>
      'Wyszukuj przepisy na podstawie składników, które masz pod ręką. Możesz również filtrować według dostępnych narzędzi oraz ustawić maksymalną liczbę brakujących składników lub przyborów kuchennych.';

  @override
  String get finderSelectedIngredients => 'Wybrane składniki';

  @override
  String get finderNoIngredientsSelected => 'Nie wybrano żadnych składników';

  @override
  String get finderMissing => 'Brakujący';

  @override
  String get finderNoRecipesFound => 'Nie znaleziono przepisów';

  @override
  String get finderNoRecipesFoundDescription =>
      'Spróbuj dodać więcej składników do wyszukiwania lub dostosować filtry';

  @override
  String get finderIncludeFoodsOnHand =>
      'Uwzględnij składniki dostępne pod ręką';

  @override
  String get finderIncludeToolsOnHand =>
      'Uwzględnij przybory kuchenne dostępne pod ręką';

  @override
  String get finderIncludeSubstitutions => 'Uwzględnij zamienniki';

  @override
  String get finderSubstituting => 'Zamiana';

  @override
  String finderSubstituteForFood(String substitute, String food) {
    return '$substitute zamiast $food';
  }

  @override
  String get finderMaxMissingIngredients =>
      'Maks. ilość brakujących składników';

  @override
  String get finderMaxMissingTools =>
      'Maks. ilość brakujących przyborów kuchennych';

  @override
  String get finderSelectedTools => 'Wybrane przybory kuchenne';

  @override
  String get finderReadyToMake => 'Gotowe do przygotowania';

  @override
  String get finderAlmostReadyToMake => 'Prawie gotowe do przygotowania';

  @override
  String get finderSettings => 'Ustawienia';

  @override
  String get finderLoadingRecipes => 'Ładowanie przepisów';

  @override
  String get finderClearSelection => 'Wyczyść zaznaczenie';

  @override
  String get finderOfflineHint =>
      'Brak połączenia z serwerem – wyniki pochodzą z przepisów zapisanych na tym urządzeniu.';

  @override
  String addIngredientsSkippedOnHand(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dodano do listy zakupów – pominięto $count dostępnego składnika.',
      many: 'Dodano do listy zakupów – pominięto $count dostępnych składników.',
      few: 'Dodano do listy zakupów – pominięto $count dostępne składniki.',
      one: 'Dodano do listy zakupów – pominięto 1 dostępny składnik.',
    );
    return '$_temp0';
  }

  @override
  String get sendPeerOfflineHint =>
      'Obecnie niedostępne – dotrze po otwarciu aplikacji na tym urządzeniu';

  @override
  String sendDeliveredLater(String device) {
    return '„$device” jest obecnie niedostępne. Przepis dotrze, gdy tylko aplikacja zostanie tam otwarta.';
  }

  @override
  String get sendQueuedOffline =>
      'Brak połączenia. Przepis zostanie wysłany automatycznie, gdy znów będziesz online.';

  @override
  String get searchHasAll => 'Ma wszystkie';

  @override
  String get searchHasAny => 'Ma dowolny';

  @override
  String get recipeFilterTitle => 'Filtruj';

  @override
  String get finderOtherFilters => 'Inne filtry';

  @override
  String get qfOpEquals => 'jest równe';

  @override
  String get qfOpNotEquals => 'nie równa się';

  @override
  String get qfOpGreater => 'jest większe niż';

  @override
  String get qfOpGreaterEq => 'jest większe lub równe';

  @override
  String get qfOpLess => 'jest mniejsze niż';

  @override
  String get qfOpLessEq => 'jest mniejsze lub równe';

  @override
  String get qfOpNewerThan => 'jest nowsze niż';

  @override
  String get qfOpOlderThan => 'jest starsze niż';

  @override
  String qfDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dnia temu',
      many: '$count dni temu',
      few: '$count dni temu',
      one: '1 dzień temu',
    );
    return '$_temp0';
  }

  @override
  String get filterResetAll => 'Wyczyść wszystkie filtry';

  @override
  String get filterAny => 'Wszystkie';

  @override
  String get filterOfflineIgnored =>
      'Offline „Inne filtry” można stosować tylko w prostej formie.';

  @override
  String linkedRecipesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count powiązanego przepisu',
      many: '$count powiązanych przepisów',
      few: '$count powiązane przepisy',
      one: 'Jeden powiązany przepis',
      zero: 'Brak połączonych przepisów',
    );
    return '$_temp0';
  }

  @override
  String get shoppingReminderNotificationsOff =>
      'Powiadomienia dla Mealie Recipes są wyłączone — bez nich przypomnienie o zakupach nie może się pojawić. Włącz je w ustawieniach.';

  @override
  String get shoppingReminderInactiveHint =>
      'Przypomnienie o zakupach nie może teraz działać: ustaw dostęp do lokalizacji na „Zawsze” i zezwól na powiadomienia.';

  @override
  String get bulkImportTitle => 'Import Zbiorczy z URL';

  @override
  String get bulkImportDescription =>
      'Importer zbiorczy przepisów pozwala importować wiele przepisów naraz poprzez kolejkowanie stron na backendzie i uruchamianie zadania w tle. To może się przydać przy początkowej migracji do Mealie lub kiedy chcesz zaimportować dużą liczbę receptur.';

  @override
  String get bulkAddTitle => 'Dodaj zbiorczo';

  @override
  String get bulkImportSetOrganizers => 'Ustaw kategorie i tagi';

  @override
  String get bulkImportStarted => 'Rozpoczęto import zbiorczy';

  @override
  String get bulkImportFailed => 'Import zbiorczy się nie powiódł';

  @override
  String get bulkImportReports => 'Import zbiorczy';

  @override
  String get bulkImportUrlHint => 'Adres URL przepisu';

  @override
  String get migrationsTitle => 'Migracje Danych';

  @override
  String get migrationsDescription =>
      'Przepisy można przenieść do Mealie z innej obsługiwanej aplikacji. To świetny sposób na rozpoczęcie pracy z Mealie. Dane między instancjami Mealie przenosi się za pomocą kopii zapasowych, a nie migracji.';

  @override
  String get migrationNew => 'Nowa migracja';

  @override
  String get migrationChooseType => 'Wybierz typ migracji';

  @override
  String get noFileSelected => 'Nie wybrano pliku';

  @override
  String migrationTagAll(String tag) {
    return 'Oznacz wszystkie przepisy tagiem $tag';
  }

  @override
  String get migrationPrevious => 'Poprzednie migracje';

  @override
  String get migrationMealieDescription =>
      'Mealie może zaimportować przepisy z wersji Mealie sprzed v1.0. Wyeksportuj przepisy ze starej instancji i prześlij poniżej plik ZIP. Uwaga: importowane są tylko przepisy.';

  @override
  String get migrationChowdownDescription =>
      'Mealie natywnie obsługuje format repozytorium chowdown. Pobierz repozytorium kodu jako plik .zip i prześlij go poniżej.';

  @override
  String get migrationCopyMeThatDescription =>
      'Mealie może zaimportować przepisy z Copy Me That. Wyeksportuj swoje przepisy w formacie HTML, a następnie prześlij plik .zip poniżej.';

  @override
  String get migrationMyRecipeBoxDescription =>
      'Mealie może importować przepisy z My Recipe Box. Eksportuj swoje przepisy w formacie CSV, a następnie prześlij plik .csv poniżej.';

  @override
  String get migrationNextcloudDescription =>
      'Przepisy Nextcloud mogą być zaimportowane z pliku zip, który zawiera dane przechowywane w Nextcloud. Zobacz przykładową strukturę folderu poniżej, aby upewnić się, że Twoje przepisy mogą być importowane.';

  @override
  String get migrationPaprikaDescription =>
      'Mealie może importować przepisy z aplikacji Paprika. Eksportuj swoje przepisy z Paprika, zmień nazwę rozszerzenia eksportu na .zip i prześlij je poniżej.';

  @override
  String get migrationPlanToEatDescription =>
      'Mealie może importować przepisy z Plan to Eat.';

  @override
  String get migrationRecipeKeeperDescription =>
      'Mealie może importować przepisy z Recipe Keeper. Eksportuj przepisy w formacie zip, a następnie prześlij plik .zip poniżej.';

  @override
  String get migrationTandoorDescription =>
      'Mealie może zaimportować przepisy z Tandoor. Wyeksportuj swoje dane w formacie \"Default\", a następnie prześlij plik .zip poniżej.';

  @override
  String get migrationCooknDescription =>
      'Mealie może importować przepisy z DVO Cook\'n X3. Wyeksportuj książkę kucharską lub menu w formacie \"Cook\'n\", zmień rozszerzenie eksportu na .zip, a następnie prześlij plik .zip poniżej.';

  @override
  String get reportTitle => 'Raport';

  @override
  String get recipeDataTitle => 'Dane Przepisów';

  @override
  String get recipeDataDescription =>
      'Użyj tej sekcji do zarządzania danymi powiązanymi z Twoimi przepisami. Możesz wykonać kilka akcji zbiorczych na swoich przepisach, w tym eksportować, usuwać, oznaczać i przypisywać kategorie.';

  @override
  String get recipeDataTagTitle => 'Taguj Przepisy';

  @override
  String get recipeDataCategorizeTitle => 'Skategoryzuj Przepisy';

  @override
  String get recipeDataSettingsTitle => 'Zaktualizuj Ustawienia';

  @override
  String get recipeDataExportTitle => 'Wyeksportuj Przepisy';

  @override
  String get recipeDataDeleteTitle => 'Usuń Przepisy';

  @override
  String recipeDataExportConfirm(int count) {
    return 'Następujące przepisy ($count) zostaną wyeksportowane.';
  }

  @override
  String get recipeDataExportsTitle => 'Eksport danych';

  @override
  String get recipeDataExportsDescription =>
      'Ta sekcja zawiera linki do dostępnych eksportów, które są gotowe do pobrania. Te eksporty wygasają, więc pobierz je, póki są jeszcze dostępne.';

  @override
  String get recipeDataPurgeExports => 'Wyczyść Eksport';

  @override
  String get recipeDataPurgeConfirm =>
      'Czy na pewno chcesz usunąć wszystkie dane eksportu?';

  @override
  String get recipeActionsTitle => 'Akcje przepisów';

  @override
  String get recipeActionNew => 'Nowa akcja przepisu';

  @override
  String get recipeActionEdit => 'Edycja akcji przepisu';

  @override
  String get recipeActionTypeLink => 'Link';

  @override
  String get recipeActionTypePost => 'Żądanie POST';

  @override
  String get webhooksTitle => 'Webhooki';

  @override
  String get webhooksDescription =>
      'Webhooki określone poniżej będą wykonywane kiedy posiłek zostanie określony dla dnia. W zaplanowanym czasie, webhooki będą wysyłane z danymi z przepisu, który został zaplanowany na ten dzień. Zauważ, że wyzwolenie webhooka nie jest dokładne. Webhooki są wyzwalane w 5-minutowych odstępach czasu, więc webhooki zostaną wykonane w ciągu 5 +/- minut od zaplanowanego czasu.';

  @override
  String get webhookName => 'Nazwa webhooka';

  @override
  String get webhookUrl => 'URL webhooka';

  @override
  String get notifiersTitle => 'Powiadomienia';

  @override
  String get notifiersDescription =>
      'Skonfiguruj e-mail i powiadomienia push, które uruchamiają się przy określonych zdarzeniach.';

  @override
  String get notifierNew => 'Nowe powiadomienie';

  @override
  String get notifierDescription =>
      'Mealie używa biblioteki Apprise do generowania powiadomień. Oferują one wiele możliwości korzystania z usług do powiadomień. Zobacz ich wiki w celu uzyskania wyczerpującego poradnika jak utworzyć adres URL dla Twojej usługi. Jeśli jest to możliwe, wybór typu powiadomienia może zawierać dodatkowe funkcje.';

  @override
  String get notifierAppriseUrl => 'URL Apprise';

  @override
  String get notifierAppriseUrlSkipped =>
      'URL Apprise (pominięty, jeśli puste)';

  @override
  String get notifierAppriseUrlBlankHint =>
      'Ponieważ adresy URL Apprise zawierają zazwyczaj poufne informacje, pole to pozostaje celowo puste podczas edycji. Jeśli chcesz zaktualizować adres URL, wprowadź ten nowy tutaj, w przeciwnym razie pozostaw puste, aby zachować bieżący adres URL.';

  @override
  String get notifierEnable => 'Włącz Powiadomienie';

  @override
  String get notifierWhatEvents =>
      'Jakie zdarzenia powinien subskrybować ten powiadamiający?';

  @override
  String get notifierRecipeEvents => 'Zdarzenia Przepisów';

  @override
  String get notifierUserEvents => 'Zdarzenia użytkownika';

  @override
  String get notifierMealplanEvents => 'Zdarzenia planu posiłków';

  @override
  String get notifierShoppingListEvents => 'Wydarzenia listy zakupów';

  @override
  String get notifierCookbookEvents => 'Wydarzenia Książki Kucharskiej';

  @override
  String get notifierTagEvents => 'Zdarzenia tagów';

  @override
  String get notifierCategoryEvents => 'Wydarzenia kategorii';

  @override
  String get notifierLabelEvents => 'Etykiety zdarzeń';

  @override
  String get notifierUserSignup =>
      'Kiedy nowy użytkownik dołączy do Twojej grupy';

  @override
  String get notifierCreate => 'Utwórz';

  @override
  String get notifierUpdate => 'Zaktualizuj';

  @override
  String get notifierDelete => 'Usuń';

  @override
  String get notifierTestSent => 'Testowa wiadomość wysłana';

  @override
  String get adminTitle => 'Ustawienia administratora';

  @override
  String get backupsTitle => 'Kopie zapasowe';

  @override
  String get backupsDescription =>
      'Kopie zapasowe to całkowite zrzuty bazy danych i katalogu danych witryny. Obejmują one wszystkie dane i nie można nic ustawić, aby wykluczyć podzbiory danych. Traktuj je jako stan całego Mealie w określonym momencie czasu. Backupy to agnostyczny sposób eksportowania i importowania danych oraz sposób na zrobienie kopii witryny do zewnętrznej lokalizacji.';

  @override
  String get backupCreateHeading => 'Utwórz kopię zapasową';

  @override
  String get backupCreated => 'Kopia zapasowa utworzona pomyślnie';

  @override
  String get backupCreateFailed =>
      'Wystąpił błąd podczas tworzenia kopii zapasowej, sprawdź plik logu';

  @override
  String get backupDelete => 'Usuń kopię zapasową';

  @override
  String get backupDeleted => 'Kopia zapasowa została usunięta';

  @override
  String get backupRestore => 'Przywróć kopię';

  @override
  String get backupRestoreDescription =>
      'Przywracanie tej kopii zapasowej nadpisze wszystkie aktualne dane w bazie danych i w katalogu danych i zastąpi je zawartością tej kopii zapasowej. Jeśli przywrócenie zakończy się pomyślnie, zostaniesz wylogowany.';

  @override
  String get backupCannotBeUndone =>
      'Tej czynności nie można cofnąć - należy zachować ostrożność.';

  @override
  String get backupAcknowledge =>
      'Rozumiem, że ta operacja jest nieodwracalna, destrukcyjna i może spowodować utratę danych';

  @override
  String get backupRestoreSuccess => 'Przywracanie zakończone sukcesem';

  @override
  String get backupRestoreFailed =>
      'Przywracanie nieudane. Sprawdź logi serwera, aby uzyskać więcej informacji';

  @override
  String get maintenanceTitle => 'Konserwacja';

  @override
  String get maintenanceSummary => 'Podsumowanie';

  @override
  String get maintenanceStorage => 'Szczegóły przechowywania';

  @override
  String get maintenanceDataDirSize => 'Rozmiar katalogu danych';

  @override
  String get maintenanceCleanableDirs => 'Usuwalne katalogi';

  @override
  String get maintenanceCleanableImages => 'Usuwalne zdjęcia';

  @override
  String get maintenanceTempDir => 'Katalog Tymczasowy (.temp)';

  @override
  String get maintenanceBackupsDir => 'Katalog Kopii Zapasowych (backups)';

  @override
  String get maintenanceGroupsDir => 'Katalog Grup (groups)';

  @override
  String get maintenanceRecipesDir => 'Katalog Przepisów (recipes)';

  @override
  String get maintenanceUserDir => 'Katalog Użytkowników (user)';

  @override
  String get maintenanceCleanDirs => 'Wyczyść katalogi';

  @override
  String get maintenanceCleanDirsDescription =>
      'Usuwa wszystkie foldery z przepisami, które nie są poprawnymi UUID';

  @override
  String get maintenanceCleanTemp => 'Wyczyść pliki tymczasowe';

  @override
  String get maintenanceCleanTempDescription =>
      'Usuwa wszystkie pliki i foldery z katalogu .temp';

  @override
  String get maintenanceCleanImages => 'Wyczyść zdjęcia';

  @override
  String get maintenanceCleanImagesDescription =>
      'Usuwa wszystkie zdjęcia, które nie kończą się na .webp';

  @override
  String get maintenanceActions => 'Działania';

  @override
  String get adminConfiguration => 'Konfiguracja';

  @override
  String get adminAppVersion => 'Wersja aplikacji';

  @override
  String get adminUpToDate => 'Mealie jest aktualny';

  @override
  String adminVersionOutdated(String current, String latest) {
    return 'Twoja obecna wersja ($current) nie jest najnowsza. Rozważ aktualizację do najnowszej wersji ($latest).';
  }

  @override
  String get adminBaseUrl => 'Podstawowy Adres URL Serwera';

  @override
  String get adminBaseUrlOk =>
      'Adres strony serwera nie pasuje do wartości domyślnej';

  @override
  String get adminBaseUrlError =>
      '`BASE_URL` jest nadal wartością domyślną na serwerze API. To spowoduje problemy z linkami do powiadomień generowanymi na serwerze dla wiadomości e-mail itp.';

  @override
  String adminAuthReady(String provider) {
    return '$provider gotowy';
  }

  @override
  String adminAuthNotReady(String provider) {
    return '$provider nie jest gotowy';
  }

  @override
  String adminAuthDisabled(String provider) {
    return '$provider wyłączony';
  }

  @override
  String adminAuthSuccessText(String provider) {
    return 'Wszystkie wymagane zmienne $provider są ustawione.';
  }

  @override
  String adminAuthErrorText(String provider) {
    return 'Nie wszystkie wartości $provider są skonfigurowane. Możesz to zignorować, jeśli nie używasz uwierzytelniania $provider.';
  }

  @override
  String adminAuthDisabledText(String envVar) {
    return 'Aby włączyć, ustaw $envVar na true.';
  }

  @override
  String get adminEmailStatus => 'Status konfiguracji Email';

  @override
  String get adminEmailConfigured => 'E-mail skonfigurowany';

  @override
  String get adminNotReady => 'Niegotowy - Sprawdź zmienne środowiskowe';

  @override
  String get adminSucceeded => 'Powiodło się';

  @override
  String get adminFailed => 'Nie powiodło się';

  @override
  String get adminSiteStatistics => 'Statystyki witryny';

  @override
  String get adminUncategorized => 'Przepisy bez kategorii';

  @override
  String get adminUntagged => 'Przepisy bez tagów';

  @override
  String get adminGeneralAbout => 'Informacje Ogólne';

  @override
  String get adminVersion => 'Wersja';

  @override
  String get adminBuild => 'Kompilacja';

  @override
  String get adminApplicationMode => 'Tryb aplikacji';

  @override
  String get adminProduction => 'Produkcyjna';

  @override
  String get adminDevelopment => 'Wersja testowa';

  @override
  String get adminDemoStatus => 'Status demo';

  @override
  String get adminDemo => 'Wersja demonstracyjna';

  @override
  String get adminNotDemo => 'Nie demo';

  @override
  String get adminApiPort => 'Port API';

  @override
  String get adminApiDocs => 'Dokumentacja API';

  @override
  String get adminDatabaseType => 'Rodzaj bazy danych';

  @override
  String get adminDatabaseUrl => 'URL bazy danych';

  @override
  String get adminDefaultGroup => 'Domyślna grupa';

  @override
  String get adminDefaultHousehold => 'Domyślne gospodarstwo domowe';

  @override
  String get adminScraperVersion => 'Wersja Scrapera Przepisów';

  @override
  String get adminStatUsers => 'Użytkownicy';

  @override
  String get adminStatHouseholds => 'Gospodarstwa domowe';

  @override
  String get adminStatGroups => 'Grupy';

  @override
  String get recipeDuplicate => 'Duplikuj przepis';

  @override
  String get recipeDuplicateAction => 'Duplikuj';

  @override
  String get recipeShareLink => 'Udostępnij przepis';

  @override
  String get recipeShareExpiration => 'Data wygaśnięcia';

  @override
  String get recipeShareCopied =>
      'Link z przepisem został skopiowany do schowka';

  @override
  String get enabledLabel => 'Włączone';

  @override
  String get disabledLabel => 'Wyłączone';

  @override
  String get testAction => 'Testuj';

  @override
  String get yesLabel => 'Tak';

  @override
  String get noLabel => 'Nie';

  @override
  String get downloadAction => 'Pobierz';

  @override
  String get backupUpload => 'Prześlij';

  @override
  String get zipImportButton => 'Importuj z pliku Zip';

  @override
  String get zipImportDescription =>
      'Importuj pojedynczy przepis, który został wyeksportowany z innej instancji Mealie.';

  @override
  String get reportStatus => 'Stan';

  @override
  String get reportDate => 'Data';

  @override
  String get recipeActionTitleLabel => 'Tytuł';

  @override
  String get clearAll => 'Wyczyść';

  @override
  String get recipeDataSettingsExplanation =>
      'Ustawienia wybrane tutaj, z wyłączeniem opcji zablokowania, zostaną zastosowane do wszystkich wybranych przepisów.';

  @override
  String get adminAllowSignup => 'Rejestracja dozwolona';

  @override
  String get adminAllowPasswordLogin => 'Logowanie hasłem dozwolone';

  @override
  String get adminEmailInvalid => 'Podaj prawidłowy adres e-mail.';

  @override
  String adminEmailTestResult(String result) {
    return 'Test e-mail: $result';
  }

  @override
  String get adminSendTestEmail => 'Wyślij testowy e-mail';

  @override
  String get adminTestEmailAddress => 'Odbiorca';

  @override
  String get backupCreate => 'Utwórz kopię zapasową';

  @override
  String backupDeleteConfirm(String name) {
    return 'Usunąć kopię zapasową „$name”?';
  }

  @override
  String get backupPostgresNote =>
      'Jeśli używasz PostgreSQL, przed przywróceniem zapoznaj się z procesem kopii/przywracania w dokumentacji Mealie.';

  @override
  String get backupUploaded => 'Kopia zapasowa przesłana';

  @override
  String get backupsEmpty => 'Brak kopii zapasowych.';

  @override
  String get bulkImportAddRow => 'Dodaj URL';

  @override
  String get bulkImportStart => 'Rozpocznij import';

  @override
  String get chooseFileButton => 'Wybierz plik';

  @override
  String get deselectAllAction => 'Odznacz wszystko';

  @override
  String get downloadFailed => 'Pobieranie nie powiodło się';

  @override
  String get fileSaved => 'Plik zapisany';

  @override
  String get loadFailed => 'Nie udało się wczytać';

  @override
  String get maintenanceActionsWarning =>
      'Działania konserwacyjne są destrukcyjne i należy ich używać ostrożnie. Każde z nich jest nieodwracalne.';

  @override
  String get maintenanceConfirm =>
      'To działanie jest destrukcyjne i nieodwracalne. Kontynuować?';

  @override
  String get maintenanceDone => 'Gotowe';

  @override
  String get maintenanceFailed => 'Działanie konserwacyjne nie powiodło się';

  @override
  String get maintenanceRun => 'Uruchom';

  @override
  String get migrationFailed => 'Migracja nie powiodła się';

  @override
  String get migrationStart => 'Rozpocznij migrację';

  @override
  String get migrationStarted => 'Migracja zakończona — zobacz raport poniżej.';

  @override
  String get moreImportOptions => 'Więcej opcji importu';

  @override
  String notifierDeleteConfirm(String name) {
    return 'Usunąć powiadomienie „$name”?';
  }

  @override
  String get notifierEdit => 'Edytuj powiadomienie';

  @override
  String notifierEventCount(int count) {
    return 'Zdarzenia: $count';
  }

  @override
  String get notifierTestFailed => 'Nie udało się wysłać wiadomości testowej';

  @override
  String get notifiersEmpty => 'Brak powiadomień.';

  @override
  String recipeActionDeleteConfirm(String name) {
    return 'Usunąć akcję przepisu „$name”?';
  }

  @override
  String get recipeActionFailed => 'Akcja przepisu nie powiodła się';

  @override
  String get recipeActionSent => 'Przepis wysłany';

  @override
  String get recipeActionUrlHint => 'Symbole zastępcze';

  @override
  String get recipeActionsDescription =>
      'Akcje przepisu pojawiają się w menu każdego przepisu. „Link” otwiera adres URL, „Post” sprawia, że serwer Mealie wysyła przepis na ten adres.';

  @override
  String get recipeActionsEmpty => 'Brak akcji przepisu.';

  @override
  String recipeDataDeleteConfirm(int count) {
    return 'Usunąć wybrane przepisy ($count)? Tej operacji nie można cofnąć.';
  }

  @override
  String recipeDataDeleteForbidden(int count) {
    return 'Nie możesz usunąć $count z wybranych przepisów (tylko autor lub administrator).';
  }

  @override
  String recipeDataDeleted(int count) {
    return 'Usunięte przepisy: $count';
  }

  @override
  String get recipeDataExportAction => 'Eksportuj';

  @override
  String get recipeDataExportDone =>
      'Eksport utworzony — pobierz go w sekcji Eksporty danych.';

  @override
  String recipeDataExportExpires(String date) {
    return 'wygasa $date';
  }

  @override
  String get recipeDataExportFailed => 'Eksport nie powiódł się';

  @override
  String get recipeDataExportsEmpty => 'Brak dostępnych eksportów.';

  @override
  String recipeDataUpdated(int count) {
    return 'Zaktualizowane przepisy: $count';
  }

  @override
  String get recipeDuplicated => 'Przepis zduplikowany';

  @override
  String get recipeExportJson => 'Eksportuj jako JSON';

  @override
  String get recipeExportZip => 'Eksportuj jako ZIP (ze zdjęciem)';

  @override
  String get recipeShareCreate => 'Utwórz link';

  @override
  String get recipeShareDescription =>
      'Każdy, kto ma link, może zobaczyć ten przepis w przeglądarce — bez konta — aż do wygaśnięcia.';

  @override
  String get recipeShareEmpty => 'Brak linków udostępniania.';

  @override
  String recipeShareExpiresAt(String date) {
    return 'Wygasa $date';
  }

  @override
  String get recipeWebToolsMenu => 'Duplikuj, link udostępniania i więcej';

  @override
  String get reload => 'Odśwież';

  @override
  String get reportDeleteConfirm => 'Usunąć ten raport?';

  @override
  String get reportEntries => 'Wpisy';

  @override
  String get reportFailedEntries => 'Nieudane';

  @override
  String get reportOnlyFailed => 'Pokaż tylko nieudane wpisy';

  @override
  String get reportStatusFailure => 'Niepowodzenie';

  @override
  String get reportStatusInProgress => 'W toku';

  @override
  String get reportStatusPartial => 'Częściowo';

  @override
  String get reportStatusSuccess => 'Sukces';

  @override
  String get reportsEmpty => 'Brak raportów.';

  @override
  String get uploadFailed => 'Przesyłanie nie powiodło się';

  @override
  String webhookDeleteConfirm(String name) {
    return 'Usunąć webhook „$name”?';
  }

  @override
  String get webhookEdit => 'Edytuj webhook';

  @override
  String get webhookNew => 'Nowy webhook';

  @override
  String get webhookTestFailed => 'Nie udało się uruchomić testu';

  @override
  String get webhookTestSent => 'Testowy webhook wyzwolony';

  @override
  String get webhookTime => 'Godzina (lokalna)';

  @override
  String get webhooksEmpty => 'Brak webhooków.';

  @override
  String get zipImportFailed => 'Import ZIP nie powiódł się';

  @override
  String get aiProvidersTitle => 'Dostawcy AI';

  @override
  String get aiProvidersDescription =>
      'Skonfiguruj dostawców AI, aby włączyć funkcje oparte na AI, takie jak lepsze rozpoznawanie składników, tworzenie przepisów z filmów i nie tylko!';

  @override
  String get aiProviderSettingsTitle => 'Ustawienia dostawców AI';

  @override
  String get aiProvidersList => 'Dostawcy';

  @override
  String get aiProviderCreate => 'Utwórz dostawcę';

  @override
  String get aiProviderEdit => 'Edytuj dostawcę';

  @override
  String get aiDefaultProvider => 'Domyślny dostawca';

  @override
  String get aiDefaultProviderDescription => 'Wymagany do włączenia funkcji AI';

  @override
  String get aiAudioProvider => 'Dostawca audio';

  @override
  String get aiAudioProviderDescription =>
      'Włącza transkrypcję dźwięku, np. tworzenie przepisów z filmów';

  @override
  String get aiImageProvider => 'Dostawca obrazów';

  @override
  String get aiImageProviderDescription =>
      'Włącza rozpoznawanie obrazów, np. tworzenie przepisów ze zdjęć';

  @override
  String get aiProviderName => 'Nazwa dostawcy';

  @override
  String get aiApiKey => 'Klucz API';

  @override
  String get aiApiKeyCreateDescription =>
      'Klucz API dostawcy do uwierzytelniania. Jeśli usługa (np. Ollama) nie używa klucza API, i tak musisz coś tu wpisać.';

  @override
  String get aiApiKeyEditDescription =>
      'Pozostaw puste, jeśli nie chcesz go zmieniać.';

  @override
  String get aiBaseUrl => 'Bazowy URL';

  @override
  String get aiBaseUrlDescription =>
      'Jeśli używasz OpenAI, pozostaw puste. Musi to być punkt końcowy zgodny z OpenAI (np. \"http://localhost:11434/v1\").';

  @override
  String get aiModel => 'Model';

  @override
  String get aiModelDescription =>
      'Którego modelu ma używać dostawca AI (np. \"gpt-5\").';

  @override
  String get aiTimeout => 'Limit czasu żądania (sekundy)';

  @override
  String get aiProviderCreated => 'Dostawca utworzony';

  @override
  String get aiProviderUpdated => 'Dostawca zaktualizowany';

  @override
  String get aiProviderDeleted => 'Dostawca usunięty';

  @override
  String get aiProviderCreateFailed => 'Nie udało się utworzyć dostawcy';

  @override
  String get aiProviderUpdateFailed => 'Nie udało się zaktualizować dostawcy';

  @override
  String get aiProviderDeleteFailed => 'Nie udało się usunąć dostawcy';

  @override
  String get aiRequestHeaders => 'Nagłówki żądania';

  @override
  String get aiRequestParams => 'Parametry żądania';

  @override
  String get aiNoDefaultWarning =>
      'Nie ustawiono domyślnego dostawcy, więc funkcje AI są wyłączone';

  @override
  String get aiTestConnection => 'Testuj połączenie';

  @override
  String get aiTestSucceeded => 'Połączenie udane';

  @override
  String get aiTestFailed => 'Połączenie nieudane';

  @override
  String get aiSupportsImages => 'Obsługuje obrazy';

  @override
  String get aiTextOnly => 'Tylko tekst — nie może być dostawcą obrazów';

  @override
  String get debugAiTitle => 'Debugowanie dostawców AI';

  @override
  String get debugAiDescription =>
      'Na tej stronie możesz debugować dostawców AI. Przetestuj połączenie i zobacz wyniki. Jeśli usługi obrazów są włączone, możesz też dodać obraz.';

  @override
  String get debugParserTitle => 'Parser składników';

  @override
  String get debugParserDescription =>
      'Mealie korzysta z Warunkowych Pól Losowych (CRF) w celu przetwarzania i analizowania składników. Użyty model opiera się na danych z ponad 100.000 składników ze zbioru danych opracowanego przez redakcję New York Times. Warto zaznaczyć, że z uwagi na to, że model był szkolony wyjącznie w języku angielskim, mogą się pojawić różne wyniki podczas korzystania z modelu w innych językach. Ta strona jest platformą do testowania modelu.';

  @override
  String get debugIngredientText => 'Tekst składnika';

  @override
  String get debugTryExample => 'Wypróbuj przykład';

  @override
  String debugAverageConfidence(String value) {
    return 'Pewność $value';
  }

  @override
  String get debugRunTest => 'Uruchom test';

  @override
  String get debugQuantity => 'Ilość';

  @override
  String get debugUnit => 'Jednostka';

  @override
  String get debugFood => 'Jedzenie';

  @override
  String get debugNote => 'Komentarz';

  @override
  String get debugGroup => 'Grupa';

  @override
  String get aiProviderNone => 'Brak';

  @override
  String aiProviderDeleteConfirm(String name) {
    return 'Usunąć dostawcę „$name”?';
  }

  @override
  String get aiProvidersEmpty => 'Brak dostawców AI.';

  @override
  String get aiAdvanced => 'Zaawansowane';

  @override
  String get aiKeyLabel => 'Nazwa';

  @override
  String get aiValueLabel => 'Wartość';

  @override
  String get debugTitle => 'Debugowanie';

  @override
  String get debugParse => 'Analizuj';

  @override
  String get debugParseFailed => 'Nie udało się przeanalizować składnika';

  @override
  String get debugChooseImage => 'Wybierz obraz';

  @override
  String get debugNoImage => 'Brak obrazu (opcjonalnie)';

  @override
  String get updateTitle => 'Sprawdź aktualizacje';

  @override
  String get updateInstalledVersion => 'Zainstalowana wersja';

  @override
  String get updateLastCheck => 'Ostatnio sprawdzono';

  @override
  String get updateCheckNow => 'Sprawdź teraz';

  @override
  String get updateChecking => 'Sprawdzanie aktualizacji…';

  @override
  String get updateUpToDate => 'Mealie Recipes jest aktualne.';

  @override
  String updateAvailable(String version) {
    return 'Dostępna jest wersja $version';
  }

  @override
  String get updateAvailableDescription =>
      'Dostępna jest nowa wersja Mealie Recipes. Nic nie zostanie zainstalowane, dopóki sam nie uruchomisz aktualizacji.';

  @override
  String get updateShow => 'Pokaż aktualizację';

  @override
  String get updateLater => 'Później';

  @override
  String updateDownloading(int percent) {
    return 'Pobieranie… $percent %';
  }

  @override
  String updateReady(String version) {
    return 'Wersja $version jest gotowa do instalacji';
  }

  @override
  String get updateInstalling =>
      'Instalowanie — aplikacja zaraz uruchomi się ponownie…';

  @override
  String get updateManual =>
      'Nie udało się zainstalować automatycznie. Otwarto obraz dysku: przeciągnij Mealie Recipes do Aplikacji.';

  @override
  String get updateFailed => 'Aktualizacja nie powiodła się';

  @override
  String get updateInstallNow => 'Pobierz i zainstaluj';

  @override
  String get updateRestartNow => 'Zainstaluj i uruchom ponownie';

  @override
  String get updateAutoTitle => 'Sprawdzaj aktualizacje przy starcie';

  @override
  String get updateAutoDescription =>
      'Tylko sprawdza i powiadamia — instalację zawsze uruchamiasz sam.';

  @override
  String get updateNoNotes => 'Brak informacji o wydaniu.';

  @override
  String get updateSourceHint =>
      'Aktualizacje pochodzą z wydań GitHub Mealie Recipes i są instalowane tylko wtedy, gdy są podpisane przez dewelopera (macOS).';
}
