// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get endCookingMode => 'Завершити режим готування';

  @override
  String get endCookingModeConfirm =>
      'Ви справді хочете завершити режим готування?';

  @override
  String endCookingModeConfirmAll(int count) {
    return 'Буде завершено всі рецепти в режимі готування ($count). Продовжити?';
  }

  @override
  String get addTimer => 'Додати таймер';

  @override
  String get recipeFinished => 'Ваша страва готова.';

  @override
  String get bonAppetit => 'Смачного!';

  @override
  String get prepareIngredients => 'Підготуйте такі інгредієнти';

  @override
  String prepareIngredientsFor(String servings) {
    return 'Підготуйте такі інгредієнти на $servings порцій';
  }

  @override
  String get next => 'Далі';

  @override
  String get navHome => 'Головна';

  @override
  String get homeCookToday => 'Готуємо сьогодні';

  @override
  String get homeSuggestion => 'Пропозиція';

  @override
  String get homeQuickAccess => 'Швидкий доступ';

  @override
  String get homePlanned => 'Заплановано';

  @override
  String get favorite => 'Улюблене';

  @override
  String get navSettings => 'Налаштування';

  @override
  String homeWelcomeName(Object name) {
    return 'Вітаємо, $name,';
  }

  @override
  String get homeWelcomeApp => 'у Mealie Recipes 👋';

  @override
  String get theme => 'Вигляд';

  @override
  String get themeSystem => 'Система';

  @override
  String get themeLight => 'Світла';

  @override
  String get themeDark => 'Темна';

  @override
  String get recipes => 'Рецепти';

  @override
  String get shoppingList => '🛒 Список покупок';

  @override
  String get mealplan => 'План харчування';

  @override
  String get settings => '⚙️ Налаштування';

  @override
  String get searchRecipe => 'Пошук рецепта...';

  @override
  String get loadingRecipe => 'Завантаження рецепта...';

  @override
  String get errorLoadingRecipe => 'Не вдалося завантажити рецепт.';

  @override
  String get noRecipesForCategory => 'Немає рецептів для цього фільтра.';

  @override
  String get resetFilter => 'Скинути фільтр';

  @override
  String get allCategories => 'Усі категорії';

  @override
  String get all => 'Усі';

  @override
  String get sortRecipes => 'Сортувати рецепти';

  @override
  String get refreshRecipes => 'Оновити';

  @override
  String get sortNameAZ => 'Назва А–Я';

  @override
  String get sortNameZA => 'Назва Я–А';

  @override
  String get sortDateNewest => 'Спочатку нові';

  @override
  String get sortDateOldest => 'Спочатку старі';

  @override
  String get sortPrepTimeShort => 'Найкоротша підготовка';

  @override
  String get sortPrepTimeLong => 'Найдовша підготовка';

  @override
  String get sortRatingHighest => 'Найвищий рейтинг';

  @override
  String get sortRatingLowest => 'Найнижчий рейтинг';

  @override
  String get details => 'Деталі';

  @override
  String get ingredients => 'Інгредієнти';

  @override
  String get instructions => 'Інструкції';

  @override
  String get tags => 'Мітки';

  @override
  String get notes => 'Нотатки';

  @override
  String get addNote => 'Додати нотатку';

  @override
  String get editNote => 'Редагувати нотатку';

  @override
  String get noteTitleHint => 'Заголовок (необовʼязково)';

  @override
  String get noteTextHint => 'Текст нотатки';

  @override
  String get deleteNoteTitle => 'Видалити нотатку?';

  @override
  String get deleteNoteMessage => 'Цю нотатку буде видалено назавжди.';

  @override
  String get servings => 'Порції';

  @override
  String get planMeal => 'Запланувати страву';

  @override
  String get addAllIngredients => 'Додати всі інгредієнти';

  @override
  String get addSelectedIngredients => 'Додати вибрані інгредієнти';

  @override
  String get addIngredientsMessage =>
      'Інгредієнти додано до вашого списку покупок.';

  @override
  String addIngredientsFailedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Не вдалося додати інгредієнти: $count.',
      one: 'Не вдалося додати 1 інгредієнт.',
    );
    return '$_temp0';
  }

  @override
  String get cookbooks => 'Кулінарні книги';

  @override
  String get cookbooksEmpty =>
      'Кулінарних книг ще немає. Торкніться «+» угорі праворуч, щоб створити.';

  @override
  String get cookbookNoMatches => 'Жоден рецепт не відповідає цьому фільтру.';

  @override
  String get cookbookCreateTitle => 'Створити кулінарну книгу';

  @override
  String get cookbookEditTitle => 'Редагувати кулінарну книгу';

  @override
  String get cookbookNameLabel => 'Назва кулінарної книги';

  @override
  String get cookbookFilterSectionTitle => 'Додавати рецепти автоматично';

  @override
  String get cookbookFieldTools => 'Інструменти';

  @override
  String get cookbookFieldUsers => 'Користувачі';

  @override
  String get cookbookOpIsOneOf => 'є одним з';

  @override
  String get cookbookOpIsNotOneOf => 'не є одним з';

  @override
  String get cookbookOpContainsAll => 'містить усі';

  @override
  String get cookbookSelectValues => 'Вибрати значення';

  @override
  String get cookbookFilterOptionsUnavailable => 'Немає доступних варіантів';

  @override
  String get cookbookAddFilterField => 'Додати поле';

  @override
  String get cookbookPublicLabel => 'Публічна кулінарна книга';

  @override
  String get cookbookPublicSubtitle => 'Видима для інших сімей на сервері';

  @override
  String get cookbookRawModeEnter => 'Редагувати як текст';

  @override
  String get cookbookRawModeExit => 'Назад до конструктора';

  @override
  String get cookbookRawModeHint =>
      'Експертний режим застосунку: фільтр редагується безпосередньо як текст. Корисно, якщо наявний фільтр не вдалося розкласти на прості рядки.';

  @override
  String get cookbookRawModeUnparseable =>
      'Цей текст не відповідає простому рядковому формату — він лишається текстом.';

  @override
  String get saveFailed => 'Не вдалося зберегти';

  @override
  String get search => 'Пошук';

  @override
  String get apply => 'Застосувати';

  @override
  String get setupCachingTitle => 'Завантаження ваших рецептів';

  @override
  String get setupCachingSubtitle =>
      'Ваші рецепти готуються до використання офлайн. Залежно від їхньої кількості це може зайняти трохи часу.';

  @override
  String get setupCachingDone => 'Усе готово!';

  @override
  String get setupTipsHeader => 'А ви знали?';

  @override
  String get setupFinish => 'Почнімо';

  @override
  String get setupSkipCaching => 'Продовжити у фоні';

  @override
  String get setupTip1 =>
      'Рецепти можна імпортувати за посиланням, з фото чи PDF — через плитку «Імпорт» на головному екрані.';

  @override
  String get setupTip2 =>
      'Режим готування не дає екрану згаснути, веде вас крок за кроком і сам знаходить таймери в тексті.';

  @override
  String get setupTip3 =>
      'Список покупок працює й офлайн — зміни синхронізуються автоматично, щойно сервер стане доступним.';

  @override
  String get setupTip4 =>
      'Утримуйте плитку на головному екрані, щоб змінити порядок швидкого доступу.';

  @override
  String get setupTip5 =>
      'Ваші кулінарні книги Mealie — у плитці «Кулінарні книги», зокрема офлайн.';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Скасувати';

  @override
  String get delete => 'Видалити';

  @override
  String get edit => 'Редагувати';

  @override
  String get save => 'Зберегти';

  @override
  String get done => 'Готово';

  @override
  String get close => 'Закрити';

  @override
  String get add => 'Додати';

  @override
  String get send => 'Надіслати';

  @override
  String get retry => 'Повторити';

  @override
  String get confirmDeleteTitle => 'Видалити рецепт?';

  @override
  String get confirmDeleteMessage => 'Цю дію неможливо скасувати.';

  @override
  String get sendToDevice => 'Надіслати на пристрій';

  @override
  String get timerFinished => 'Таймер завершено!';

  @override
  String get timer => 'Таймер';

  @override
  String get newTimer => 'Новий таймер';

  @override
  String get timerNamePlaceholder => 'Назва таймера';

  @override
  String get durationLabel => 'Тривалість';

  @override
  String get start => 'Почати';

  @override
  String get stop => 'Стоп';

  @override
  String get pause => 'Пауза';

  @override
  String get resume => 'Продовжити';

  @override
  String get finished => 'Готово!';

  @override
  String stepNumber(int number) {
    return 'Крок $number';
  }

  @override
  String get minAbbreviation => 'хв';

  @override
  String get cookingMode => 'Режим готування';

  @override
  String get endAll => 'Завершити всі';

  @override
  String get end => 'Завершити';

  @override
  String get noActiveTimers => 'Немає активних таймерів';

  @override
  String get noActiveRecipes => 'Немає активних рецептів';

  @override
  String get startRecipeToCook =>
      'Відкрийте рецепт і торкніться кнопки режиму готування, щоб почати.';

  @override
  String get browseRecipes => 'Переглянути рецепти';

  @override
  String get cookFriends => 'Готуємо з друзями';

  @override
  String get cookingModeAddRecipe => 'Додати рецепт';

  @override
  String get cookingModeAddRecipeSearchHint => 'Пошук рецептів';

  @override
  String get cookFriendsCode => 'Код сесії';

  @override
  String get cookFriendsJoin => 'Приєднатися';

  @override
  String get cookFriendsHost => 'Створити сесію';

  @override
  String get cookFriendsHostNotFound =>
      'Хост не знайдено. Переконайтеся, що обидва пристрої в одній мережі Wi-Fi і доступ до локальної мережі дозволено.';

  @override
  String get cookFriendsConnectionFailed =>
      'Не вдалося підключитися. Спробуйте ще раз.';

  @override
  String get cookFriendsEnterCode => 'Введіть код';

  @override
  String cookFriendsConnected(int count) {
    return 'Підключено гостей: $count';
  }

  @override
  String get joinSession => 'Приєднатися';

  @override
  String get hostEndedSessionMessage => 'Хост завершив сесію готування.';

  @override
  String get addItem => 'Додати елемент';

  @override
  String get itemNote => 'Назва позиції';

  @override
  String get unlabeledCategory => 'Без мітки';

  @override
  String get archivedLists => '📦 Архів покупок';

  @override
  String get postimportAction => 'Після імпорту';

  @override
  String get postimportHint =>
      'Виберіть, що робити з імпортованими записами у вихідному застосунку (Нагадування / Google Tasks).';

  @override
  String get postimportLeave => 'Лише додати';

  @override
  String get postimportComplete => 'Позначити виконаним';

  @override
  String get postimportCompleteDelete => 'Позначити й видалити';

  @override
  String get postimportFailed =>
      'Обробка у вихідному застосунку не вдалася. Позиції однаково додано до Mealie.';

  @override
  String get syncChangesTitle => 'Синхронізувати зміни';

  @override
  String get syncSectionChecked => 'Позначені';

  @override
  String get syncSectionQuantity => 'Кількість';

  @override
  String get syncSectionCategory => 'Категорія';

  @override
  String get syncSectionAdditions => 'Нові';

  @override
  String get syncLocalLabel => 'Локально';

  @override
  String get syncServerLabel => 'Сервер';

  @override
  String get syncNow => 'Синхронізувати зараз';

  @override
  String get offlineBadge => 'Офлайн';

  @override
  String get mealplanTitle => '📅 План харчування';

  @override
  String get breakfast => 'Сніданок';

  @override
  String get lunch => 'Обід';

  @override
  String get dinner => 'Вечеря';

  @override
  String get addMealEntry => 'Додати страву';

  @override
  String get selectRecipe => 'Вибрати рецепт';

  @override
  String get importRecipe => 'Імпорт рецепта';

  @override
  String get url => 'URL-адреса';

  @override
  String get importLanguage => 'Мова для OCR';

  @override
  String get setupTitle => 'Вітаємо в Mealie Recipes';

  @override
  String get setupSubtitle => 'Налаштуйте свій сервер Mealie.';

  @override
  String get serverUrl => 'URL сервера';

  @override
  String get serverUrlPlaceholder => 'https://mealie.example.com';

  @override
  String get apiToken => 'Ключ API';

  @override
  String get apiTokenPlaceholder => 'Ваш API-токен';

  @override
  String get householdId => 'Сімʼя';

  @override
  String get householdIdPlaceholder => 'Сімʼя';

  @override
  String get shoppingListId => 'ID списку покупок';

  @override
  String get setupHouseholdListTitle => 'Сімʼя та список покупок';

  @override
  String get shoppingListLabel => 'Список покупок';

  @override
  String get setupHouseholdManualHint =>
      'Не вдалося завантажити сімʼї — введіть назву вручну.';

  @override
  String get setupExactTitle => 'Кількість у списку покупок';

  @override
  String get setupExactBody =>
      'У більшості країн купують не з точністю до грама — у кошик кладуть 1 пачку масла, а не 200 г. Тому в простому режимі застосунок перетворює кількості з рецепта на «1×». У точному режимі кількість і одиниця лишаються 1:1, як у веб-застосунку Mealie, — зокрема під час введення нових позицій (напр. «200 г масла»). Змінити це можна будь-коли в налаштуваннях.';

  @override
  String get setupExactSimpleTitle => 'Простий режим (1×)';

  @override
  String get setupExactSimpleBody =>
      'Інгредієнти потрапляють до списку як «1× позиція» — зручно швидко відмічати в магазині.';

  @override
  String get setupExactExactTitle => 'Точні кількості';

  @override
  String get setupExactExactBody =>
      'Позиції показуються з кількістю та одиницею, напр. «200 г масла», — точно як у веб-застосунку.';

  @override
  String get connect => 'Підключитися';

  @override
  String connectionError(String error) {
    return 'Не вдалося підключитися: $error';
  }

  @override
  String get optionalHeaders =>
      'Додаткові HTTP-заголовки (для зворотного проксі)';

  @override
  String get settingsTitle => '⚙️ Налаштування';

  @override
  String get settingsSaved => 'Налаштування збережено';

  @override
  String get securitySettings => 'Безпека';

  @override
  String get showRecipeImages => 'Показувати зображення рецептів';

  @override
  String get apiVersion => 'Версія API';

  @override
  String get language => 'Мова';

  @override
  String get biometricLock => 'Біометричне блокування';

  @override
  String get biometricLockDescription => 'Розблоковувати застосунок біометрією';

  @override
  String get enableLogging => 'Увімкнути журнал';

  @override
  String get selectLanguage => 'Вибрати мову';

  @override
  String get setupContinue => 'Продовжити';

  @override
  String get back => 'Назад';

  @override
  String get setupConnectStep => 'Підключіться до сервера';

  @override
  String get resetSettings => 'Скинути всі налаштування';

  @override
  String get resetSettingsConfirm =>
      'Усі налаштування буде скинуто. Продовжити?';

  @override
  String get guestMode => 'Гостьовий режим';

  @override
  String get appVersion => 'Версія';

  @override
  String get leftoverFinder => 'Пошук рецептів';

  @override
  String get addIngredient => 'Додати інгредієнт';

  @override
  String get biometricPrompt =>
      'Підтвердьте особу, щоб відкрити Mealie Recipes';

  @override
  String get biometricFailed => 'Не вдалося підтвердити особу';

  @override
  String get pendingRecipesTitle => 'Отримані рецепти';

  @override
  String pendingRecipesFrom(Object names) {
    return 'Від $names';
  }

  @override
  String get pendingRecipesOpenCooking => 'Відкрити режим готування';

  @override
  String get dismiss => 'Закрити';

  @override
  String get editRecipe => 'Редагувати рецепт';

  @override
  String get recipeName => 'Назва рецепта';

  @override
  String get prepTime => 'Час підготовки (хв)';

  @override
  String get cookTime => 'Час готування (хв)';

  @override
  String get totalTime => 'Загальний час (хв)';

  @override
  String get recipeServings => 'Порції';

  @override
  String get rating => 'Рейтинг';

  @override
  String get addIngredientLine => 'Додати інгредієнт';

  @override
  String get addInstruction => 'Додати крок';

  @override
  String get removeIngredient => 'Вилучити інгредієнт';

  @override
  String get removeInstruction => 'Вилучити крок';

  @override
  String get ingredientName => 'Інгредієнт';

  @override
  String get ingredientQuantity => 'К-сть';

  @override
  String get ingredientUnit => 'Одиниця виміру';

  @override
  String get ingredientNote => 'Примітка';

  @override
  String get instructionText => 'Текст кроку';

  @override
  String get categories => 'Категорії';

  @override
  String get saveChanges => 'Зберегти зміни';

  @override
  String get saveSuccess => 'Рецепт збережено.';

  @override
  String get newCategory => 'Нова категорія';

  @override
  String get newTag => 'Нова мітка';

  @override
  String get setRating => 'Поставити оцінку';

  @override
  String get homeWelcome => 'Вітаємо в Mealie Recipes! 👋';

  @override
  String homeWelcomeNamed(String name) {
    return 'Вітаємо, $name, у Mealie Recipes! 👋';
  }

  @override
  String get shopping => 'Покупки';

  @override
  String get planning => 'Планування';

  @override
  String get other => 'Інше';

  @override
  String get addRecipe => '➕ Додати рецепт';

  @override
  String get completeShopping => 'Завершити покупки';

  @override
  String get shoppingCompleted => 'Покупки завершено';

  @override
  String get shoppingCompletedSubtitle => 'Усе в кошику! 🎉';

  @override
  String get shoppingOfflineNoCache => 'Офлайн – список не збережено';

  @override
  String get shoppingOfflineNoCacheSubtitle =>
      'На цьому пристрої ще немає збережених позицій цього списку. Він завантажиться, щойно ви знову будете онлайн.';

  @override
  String get essensplan => '📅 План харчування';

  @override
  String get resteverwertung => '🥗 Пошук рецептів';

  @override
  String get copyCode => 'Копіювати код';

  @override
  String get shareLink => 'Поділитися посиланням';

  @override
  String get connectedFriends => 'Підключені друзі';

  @override
  String get waitingForFriends => 'Очікування друзів...';

  @override
  String get sessionCode => 'КОД СЕСІЇ';

  @override
  String get loading => 'Завантаження...';

  @override
  String get urlInvalidScheme => 'URL має починатися з http:// або https://';

  @override
  String get urlAddScheme => 'Додати https://';

  @override
  String get addItemPlaceholder => 'Додати позицію...';

  @override
  String get completedItems => 'Виконано';

  @override
  String get completeShoppingTitle => 'Завершити покупки?';

  @override
  String get completeShoppingMessage => 'Видалити виконані позиції?';

  @override
  String get recipeListTitle => '📖 Рецепти';

  @override
  String get importRecipeTitle => 'Завантажити новий рецепт';

  @override
  String get uploadRecipeUrl => 'Імпорт за URL рецепта';

  @override
  String get uploadRecipeUrlHint =>
      'Введіть URL рецепта, щоб зберегти його на сервері';

  @override
  String get uploadOpenAI => 'Імпорт із файлу через OpenAI';

  @override
  String get uploadOpenAIHint =>
      'Або завантажте фото чи PDF рецепта. Якщо рецепт займає кілька сторінок, просто додайте кілька — ШІ проаналізує їх разом.';

  @override
  String get takePhoto => 'Камера';

  @override
  String get cameraPermissionDenied =>
      'Немає доступу до камери. Дозвольте його в налаштуваннях системи, щоб фотографувати рецепти.';

  @override
  String get cameraUnavailable => 'На цьому пристрої немає камери.';

  @override
  String get selectPhoto => 'Фото';

  @override
  String get selectPdf => 'PDF';

  @override
  String get openAIHintTitle => 'Про аналіз файлів';

  @override
  String get openAIHintBody =>
      'Аналіз рецепта використовує API OpenAI. Переконайтеся, що ключ API налаштовано в параметрах сервера Mealie.';

  @override
  String get allDeleteConfirm => 'Видалити все';

  @override
  String get entriesInOtherWeeks => 'Є записи на інших тижнях';

  @override
  String get availableWeeks => 'Доступні тижні:';

  @override
  String get currentWeek => 'Поточний тиждень';

  @override
  String get weekAbbreviation => 'Тиж.';

  @override
  String get today => 'Сьогодні';

  @override
  String get selectDate => 'Вибрати дату';

  @override
  String get selectedRecipe => 'Вибраний рецепт';

  @override
  String get confirmMeal => 'Запланувати страву';

  @override
  String get searchRecipes => 'Пошук рецептів';

  @override
  String get addCustomMeal => 'Додати власну страву';

  @override
  String get diceModeButton => 'Випадкові рецепти';

  @override
  String get diceModeTitle => '3 випадкові пропозиції';

  @override
  String get diceBackToSearch => 'Назад до пошуку';

  @override
  String get diceNotEnoughRecipes =>
      'Замало рецептів для кубика (потрібно щонайменше 3)';

  @override
  String get entrySingular => 'запис';

  @override
  String get entriesPlural => 'записи';

  @override
  String get deleteAllConfirmTitle => 'Видалити все?';

  @override
  String get deleteAllConfirmMessage => 'Видалити всі архівні покупки?';

  @override
  String get uploadFromUrlButton => 'Імпортувати рецепт за URL';

  @override
  String get uploadingImage => 'Завантаження...';

  @override
  String get uploadErrorTitle => 'Помилка завантаження';

  @override
  String get uploadSuccessTitle => 'Завантажено';

  @override
  String get editImportedRecipeQuestion => 'Відредагувати новий рецепт зараз?';

  @override
  String get notNow => 'Не зараз';

  @override
  String get pdfTooLarge => 'PDF-файл завеликий (макс. 10 МБ).';

  @override
  String get invalidUrl => 'Недійсний URL. Введіть коректну HTTP(S)-адресу.';

  @override
  String get cookWithFriends => 'Готуємо з друзями';

  @override
  String get cookFriendsSubtitle =>
      'Запросіть друга приготувати цей рецепт разом';

  @override
  String get copied => 'Скопійовано';

  @override
  String get linkCopied => 'Посилання скопійовано';

  @override
  String get startCooking => 'Почати готувати';

  @override
  String get uploadToOwnServer => 'Зберегти на мій сервер';

  @override
  String get uploadingRecipe => 'Завантаження рецепта…';

  @override
  String get recipeUploadedToOwnServer => 'Рецепт збережено на вашому сервері';

  @override
  String get recipeUploadFailed => 'Помилка завантаження';

  @override
  String get allowGuestSaveRecipes =>
      'Дозволити гостям зберігати рецепти на власному сервері';

  @override
  String get appIcon => 'Значок застосунку';

  @override
  String get name => 'Назва';

  @override
  String get color => 'Колір';

  @override
  String get randomColor => 'Випадковий колір';

  @override
  String get createFailed => 'Не вдалося створити';

  @override
  String get deleteFailed => 'Не вдалося видалити';

  @override
  String deleteOrganizerConfirm(String name) {
    return 'Видалити «$name»? Його також буде видалено на сервері.';
  }

  @override
  String get connectionSection => 'Підключення';

  @override
  String get token => 'Токен';

  @override
  String get advancedOptions => 'Додаткові параметри';

  @override
  String get mealieApiVersion => 'Версія API Mealie';

  @override
  String get sendOptionalHeaders => 'Надсилати додаткові заголовки';

  @override
  String get offlineRecipeImages => 'Зберігати зображення рецептів офлайн';

  @override
  String get offlineRecipeImagesHint =>
      'Завантажує на пристрій усі зображення рецептів – зокрема з кроків і нотаток, – щоб вони показувалися без підключення. Великі колекції можуть займати кілька сотень МБ. Вимкнення видаляє збережені зображення.';

  @override
  String offlineRecipeImagesStatus(int count, int total, String size) {
    return 'Збережено: $count/$total · $size';
  }

  @override
  String get offlineRecipeImagesDisableConfirm =>
      'Видалити всі збережені зображення рецептів?';

  @override
  String headerNameLabel(int n) {
    return 'Назва заголовка $n';
  }

  @override
  String headerValueLabel(int n) {
    return 'Значення заголовка $n';
  }

  @override
  String get value => 'Значення';

  @override
  String get personalization => 'Персоналізація';

  @override
  String get showRecipeImagesSubtitle => 'Показує зображення в списку рецептів';

  @override
  String get exactQuantities => 'Додавати точні кількості';

  @override
  String get exactQuantitiesSubtitle =>
      'Інгредієнти й введені позиції зберігають кількість і одиницю (напр. 200 г масла) замість 1× на позицію';

  @override
  String get remindToShop => 'Нагадувати про покупки';

  @override
  String get remindToShopSubtitle =>
      'Сповіщає, коли ви поблизу збереженого місця, а в списку покупок є відкриті позиції, — навіть коли застосунок закрито';

  @override
  String get shoppingReminderAddLocation => 'Додати місце';

  @override
  String get shoppingReminderMaxLocations => 'Досягнуто максимуму — 3 місця';

  @override
  String get shoppingReminderLocationServiceDisabled =>
      'Служби геолокації на цьому пристрої вимкнено';

  @override
  String get shoppingReminderPermissionTitle => 'Потрібен доступ до геолокації';

  @override
  String get shoppingReminderPermissionMessage =>
      'Щоб нагадувати вам поблизу магазину, потрібен доступ до геолокації «Завжди» — навіть коли застосунок закрито. Увімкніть його в Налаштуваннях.';

  @override
  String get openSettings => 'Відкрити Налаштування';

  @override
  String get shoppingReminderLocationName => 'Назва';

  @override
  String get shoppingReminderUseCurrentLocation => 'Використати поточне місце';

  @override
  String get shoppingReminderOrAddress => 'або введіть адресу';

  @override
  String get shoppingReminderAddress => 'Адреса';

  @override
  String get shoppingReminderAddressPlaceholder => 'Вулиця, місто';

  @override
  String get shoppingReminderSearchAddress => 'Пошук';

  @override
  String get shoppingReminderLocationFailed =>
      'Не вдалося визначити ваше місцеперебування';

  @override
  String get shoppingReminderAddressNotFound => 'Адресу не знайдено';

  @override
  String get ratingFailed => 'Не вдалося зберегти оцінку — спробуйте ще раз.';

  @override
  String get lastCooked => 'Востаннє приготовано';

  @override
  String get syncLastCooked => 'Оновлювати «востаннє приготовано»';

  @override
  String get syncLastCookedSubtitle =>
      'Зберігає сьогоднішню дату й запис у хронології на сервері — як веб-застосунок Mealie.';

  @override
  String get developer => 'Розробник';

  @override
  String get enableLoggingSubtitle =>
      'Записує журнали виводу та помилок (останні 500 рядків)';

  @override
  String get entriesLabel => 'Записи';

  @override
  String get fileSize => 'Розмір файлу';

  @override
  String get showAction => 'Показати';

  @override
  String get copy => 'Скопіювати';

  @override
  String logsWithCount(int count) {
    return 'Журнали ($count)';
  }

  @override
  String get noLogs => 'Журналів немає';

  @override
  String get logsTitle => 'Журнали';

  @override
  String get required => 'Обовʼязково';

  @override
  String get connectionFailedCheck =>
      'Не вдалося підключитися. Перевірте URL і токен.';

  @override
  String get username => 'Ім\'я користувача';

  @override
  String get password => 'Пароль';

  @override
  String get setupPasswordHint =>
      'Пароль не зберігається — застосунок один раз входить і створює з нього API-токен (як Профіль → API-токени у веб-застосунку).';

  @override
  String get loginAndConnect => 'Увійти й підключитися';

  @override
  String get loginInvalidCredentials =>
      'Неправильне імʼя користувача або пароль.';

  @override
  String get apiTokenSaveHint =>
      'Токен застосовано — торкніться «Зберегти зміни» нижче.';

  @override
  String get renewApiToken => 'Оновити API-токен';

  @override
  String get setupAuthChoiceTitle => 'Як ви хочете увійти?';

  @override
  String get authModePasswordTitle => 'Нехай застосунок створить API-ключ';

  @override
  String get authModePasswordSubtitle =>
      'Вхід за імʼям користувача й паролем — застосунок сам створить токен.';

  @override
  String get authModeTokenTitle => 'У мене вже є API-ключ';

  @override
  String get authModeTokenSubtitle =>
      'Скопійовано з профілю Mealie (Профіль → API-токени).';

  @override
  String keyN(int n) {
    return 'Ключ $n';
  }

  @override
  String valueN(int n) {
    return 'Значення $n';
  }

  @override
  String get openCookingMode => 'Відкрити режим готування';

  @override
  String activeRecipes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count активного рецепта',
      many: '$count активних рецептів',
      few: '$count активні рецепти',
      one: '$count активний рецепт',
    );
    return '$_temp0';
  }

  @override
  String get reparseIngredients => 'Розібрати інгредієнти знову';

  @override
  String get reparseIngredientsSubtitle =>
      'Розділити кількість/одиницю/інгредієнт (напр. «200 г борошна»)';

  @override
  String get reparseDone =>
      'Інгредієнти розділено – торкніться «Зберегти зміни», щоб застосувати';

  @override
  String get tagsAndCategories => 'Мітки, категорії та інструменти';

  @override
  String get tapToAddPhoto => 'Торкніться, щоб додати фото';

  @override
  String get descriptionLabel => 'Опис';

  @override
  String get searchingDevices => 'Пошук пристроїв у тій самій мережі Wi-Fi…';

  @override
  String get selectAll => 'Вибрати все';

  @override
  String get importReminders => 'Імпорт нагадувань';

  @override
  String get importGoogleTasks => 'Імпорт Google Tasks';

  @override
  String get noTaskLists => 'Списків завдань не знайдено';

  @override
  String get noReminderLists => 'Списків нагадувань не знайдено';

  @override
  String importCount(int count) {
    return 'Імпортувати $count';
  }

  @override
  String get noIngredientsToLink => 'Поки немає інгредієнтів для привʼязки';

  @override
  String get importLanguageSubtitle =>
      'Мова рецептів, імпортованих із фото чи PDF';

  @override
  String get importLanguageSearch => 'Пошук мови';

  @override
  String get importLanguageFollowApp => 'Як мова застосунку';

  @override
  String get importLanguageNoMatch => 'Мову не знайдено';

  @override
  String get setupImportLanguageTitle => 'ШІ-імпорт рецептів';

  @override
  String get setupImportLanguageBody =>
      'ШІ може перетворювати фото й PDF на рецепти. Виберіть мову, якою вони мають вийти, — зручно, якщо вашої рідної мови немає серед мов застосунку. Змінити це можна пізніше в налаштуваннях.';

  @override
  String get setupImportLanguageSearchHint =>
      'Скористайтеся пошуком у списку, щоб знайти мови, яких немає в інтерфейсі застосунку.';

  @override
  String get setupCachingKeepOpenTitle => 'Не закривайте застосунок';

  @override
  String get setupCachingKeepOpenBody =>
      'Завантаження відбувається на передньому плані. Тримайте застосунок відкритим до завершення — якщо закрити його чи надовго перемкнутися, процес зупиниться й почнеться спочатку пізніше.';

  @override
  String get supportContact => 'Звернутися до підтримки';

  @override
  String get supportDialogMessage =>
      'Опишіть проблему, і ми відповімо. Журнал дуже допомагає шукати помилку — його можна додати текстовим файлом.';

  @override
  String get supportWithoutLogs => 'Без журналу';

  @override
  String get supportWithLogs => 'Додати журнал';

  @override
  String get supportMailSubject => 'Mealie Recipes — Підтримка';

  @override
  String get supportMailHint => 'Опишіть проблему тут:';

  @override
  String get supportLogsEmpty =>
      'Журнал порожній. Увімкніть журнал, відтворіть проблему й потім надішліть.';

  @override
  String supportAddressCopied(String email) {
    return 'Адресу скопійовано: $email';
  }

  @override
  String supportNoMailApp(String email) {
    return 'Поштовий застосунок не налаштовано – адресу скопійовано: $email. Виберіть інший застосунок, щоб написати нам.';
  }

  @override
  String get createRecipeFromImages => 'Створити рецепт';

  @override
  String imagePagesSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Вибрано $count сторінки',
      many: 'Вибрано $count сторінок',
      few: 'Вибрано $count сторінки',
      one: 'Вибрано $count сторінку',
    );
    return '$_temp0';
  }

  @override
  String get imagePagesHint =>
      'Перше зображення стане головним зображенням рецепта. Утримуйте сторінку, щоб змінити порядок.';

  @override
  String get mainImageBadge => 'Головне';

  @override
  String maxImagesReached(int max) {
    return 'До рецепта можна додати до $max зображень.';
  }

  @override
  String get removePage => 'Вилучити сторінку';

  @override
  String get preparingPdf => 'Обробка PDF...';

  @override
  String get recipeOptionsTitle => 'Параметри';

  @override
  String get exportAsPdf => 'Експорт у PDF';

  @override
  String get generatingPdf => 'Створення PDF…';

  @override
  String get pdfExportFailed => 'Не вдалося експортувати PDF';

  @override
  String get recipeTime => 'Час';

  @override
  String get addIngredientSection => 'Додати розділ';

  @override
  String get aiImportToggle => 'Аналіз за допомогою ШІ';

  @override
  String get aiImportToggleHint =>
      'Також для відеорецептів (YouTube, Instagram, TikTok …) і сторінок, які звичайний імпорт не може прочитати. Потрібен ШІ-провайдер на сервері Mealie — для відео ще й аудіопровайдер.';

  @override
  String get aiImportButton => 'Імпорт із ШІ';

  @override
  String get aiImportRunning =>
      'ШІ аналізує посилання … відео може тривати кілька хвилин.';

  @override
  String get aiImportFailed =>
      'ШІ-імпорт не вдався. Перевірте налаштування ШІ на сервері Mealie.';

  @override
  String get stepHeadingLabel => 'Заголовок кроку (необовʼязково)';

  @override
  String get linkedRecipeLabel => 'Повʼязаний рецепт';

  @override
  String get toolsTitle => 'Інструменти';

  @override
  String get prepareTools => 'Підготуйте такі інструменти';

  @override
  String get newTool => 'Новий інструмент';

  @override
  String get renameAction => 'Перейменувати';

  @override
  String get organizerEmpty =>
      'Тут поки порожньо. Торкніться «+» угорі праворуч, щоб створити.';

  @override
  String organizerRecipeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count рецепта',
      many: '$count рецептів',
      few: '$count рецепти',
      one: '$count рецепт',
      zero: 'Немає рецептів',
    );
    return '$_temp0';
  }

  @override
  String get toolOnHand => 'Є в наявності';

  @override
  String get mealDiceSettingsHint =>
      'Виберіть категорії й мітки для кожного прийому їжі. Під час кидка кубика пропонуються лише рецепти хоча б з одним із них. Той самий запис можна використати для кількох прийомів їжі.';

  @override
  String get mealDiceSettingsNoneHint =>
      'Для цього прийому їжі нічого не вибрано: кубик обирає автоматично за назвами категорій на кшталт «Сніданок», «Обід» чи «Вечеря».';

  @override
  String get mealDiceAutoHintTitle => 'Автоматичний вибір';

  @override
  String get mealDiceAutoHintBody =>
      'Для цього прийому їжі ще не задано категорій чи міток. Тому кубик шукає категорії на кшталт «Сніданок», «Обід» чи «Вечеря» й доповнює іншими рецептами.\n\nЩоб вибрати самостійно: у плані харчування торкніться значка шестерні поруч із «+».';

  @override
  String get dontShowAgain => 'Більше не показувати';

  @override
  String get mealDiceNoMatches =>
      'Жоден рецепт не відповідає категоріям і міткам, вибраним для цього прийому їжі.';

  @override
  String mealDiceFewMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Підходить лише $count рецепта',
      many: 'Підходить лише $count рецептів',
      few: 'Підходять лише $count рецепти',
      one: 'Підходить лише $count рецепт',
    );
    return '$_temp0';
  }

  @override
  String get commentsTitle => 'Коментарі';

  @override
  String get commentHint => 'Напишіть коментар…';

  @override
  String get commentSaveFailed => 'Не вдалося зберегти коментар.';

  @override
  String get commentDeleteConfirm => 'Видалити цей коментар?';

  @override
  String get cookingDoneCommentLabel => 'Коментар (необовʼязково)';

  @override
  String get cookingDoneCommentHint => 'Як вийшло? Поради на наступний раз…';

  @override
  String get nutritionTitle => 'Харчова цінність';

  @override
  String get nutritionPerServing => 'на порцію';

  @override
  String get nutritionCalories => 'Калорії';

  @override
  String get nutritionFat => 'Жири';

  @override
  String get nutritionSaturatedFat => 'Насичені жири';

  @override
  String get nutritionTransFat => 'Трансжири';

  @override
  String get nutritionUnsaturatedFat => 'Ненасичені жири';

  @override
  String get nutritionCholesterol => 'Холестерин';

  @override
  String get nutritionSodium => 'Натрій';

  @override
  String get nutritionCarbohydrates => 'Вуглеводи';

  @override
  String get nutritionFiber => 'Волокна';

  @override
  String get nutritionSugar => 'Цукор';

  @override
  String get nutritionProtein => 'Білки';

  @override
  String get timelineTitle => 'Хронологія';

  @override
  String get timelineMadeThis => 'Я це приготував(ла)';

  @override
  String timelineUserMadeThis(String name) {
    return '$name це приготував(ла)';
  }

  @override
  String get timelineEmpty => 'У хронології ще немає записів.';

  @override
  String get timelineDate => 'Дата';

  @override
  String get timelineNoteHint => 'Нотатка (необовʼязково)';

  @override
  String get timelineAddPhoto => 'Додати фото';

  @override
  String get timelineRemovePhoto => 'Вилучити фото';

  @override
  String get timelineSaved => 'Додано до хронології';

  @override
  String get timelineSaveFailed => 'Не вдалося додати до хронології';

  @override
  String get timelineImageFailed =>
      'Запис збережено, але фото завантажити не вдалося';

  @override
  String get timelineDeleteConfirm => 'Видалити цей запис із хронології?';

  @override
  String get timelineEditNote => 'Редагувати нотатку';

  @override
  String get timelineUnknownRecipe => 'Рецепт не знайдено';

  @override
  String get cookingDonePhotoHint =>
      'Фото для хронології Mealie (необовʼязково)';

  @override
  String get assetsTitle => 'Вкладення';

  @override
  String get assetsAdd => 'Додати вкладення';

  @override
  String get assetsChooseFile => 'Файл';

  @override
  String get assetsUploading => 'Завантаження…';

  @override
  String get assetsUploadFailed => 'Не вдалося завантажити вкладення';

  @override
  String assetsDeleteConfirm(String name) {
    return 'Вилучити «$name» із вкладень?';
  }

  @override
  String get assetsOpenFailed => 'Не вдалося відкрити вкладення';

  @override
  String get assetsUnsupported =>
      'Mealie підтримує лише PDF, зображення, TXT, MD, CSV і JSON.';

  @override
  String get assetsShare => 'Поділитись';

  @override
  String get mealRulesTitle => 'Правила Mealie';

  @override
  String get mealRulesHint =>
      'Використовуються й веб-застосунком Mealie. Якщо до дня й прийому їжі застосовується кілька правил, мають виконуватися всі. Якщо жодне правило не застосовується, кубик обирає з усіх рецептів.';

  @override
  String get mealRuleAdd => 'Додати правило';

  @override
  String get mealRuleNewTitle => 'Нове правило';

  @override
  String get mealRuleEditTitle => 'Редагувати правило';

  @override
  String get mealRuleDay => 'День';

  @override
  String get mealRuleAnyDay => 'Будь-який день';

  @override
  String get mealRuleMealType => 'Прийом їжі';

  @override
  String get mealRuleAnyMeal => 'Будь-який прийом їжі';

  @override
  String get mealRuleConditionsTitle => 'Умови';

  @override
  String get mealRuleAllRecipes => 'Усі рецепти';

  @override
  String get mealRuleDeleteConfirm => 'Видалити це правило?';

  @override
  String get mealRulesOffline =>
      'Правила Mealie зараз недоступні – кубик використовує вибір застосунку.';

  @override
  String get mealRulesNoMatches =>
      'Жоден рецепт не відповідає правилам Mealie для цього прийому їжі.';

  @override
  String get mealTypeSide => 'Закуска';

  @override
  String get mealTypeSnack => 'Закуска';

  @override
  String get mealTypeDrink => 'Напій';

  @override
  String get mealTypeDessert => 'Десерт';

  @override
  String get foodsTitle => 'Продукти';

  @override
  String get unitsTitle => 'Одиниці виміру';

  @override
  String get newFood => 'Новий продукт';

  @override
  String get newUnit => 'Нова одиниця';

  @override
  String get editFood => 'Редагувати продукт';

  @override
  String get editUnit => 'Редагувати одиницю';

  @override
  String get pluralNameLabel => 'Назва в множині';

  @override
  String get abbreviationLabel => 'Скорочена назва';

  @override
  String get pluralAbbreviationLabel => 'Скорочення в множині';

  @override
  String get mergeAction => 'Обʼєднати';

  @override
  String mergeIntoTitle(String name) {
    return 'Обʼєднати «$name» з…';
  }

  @override
  String mergeConfirm(String from, String to) {
    return '«$from» буде обʼєднано з «$to»: усі рецепти й списки покупок надалі використовуватимуть «$to», а «$from» буде видалено.';
  }

  @override
  String get mergeFailed => 'Не вдалося обʼєднати';

  @override
  String foodUnitDeleteConfirm(String name) {
    return 'Видалити «$name»? Інгредієнти, що його використовують, втратять посилання.';
  }

  @override
  String get foodsUnitsEmpty => 'Записів поки немає.';

  @override
  String mealRuleConditionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count умови',
      many: '$count умов',
      few: '$count умови',
      one: '$count умова',
    );
    return '$_temp0';
  }

  @override
  String get showAll => 'Показати все';

  @override
  String get mealDiceModeTitle => 'Кубик використовує';

  @override
  String get mealDiceModeApp => 'Вибір застосунку';

  @override
  String get switchListTitle => 'Змінити список';

  @override
  String get newShoppingList => 'Новий список покупок';

  @override
  String shoppingListDeleteConfirm(String name) {
    return 'Видалити «$name»? Усі позиції в ньому також буде видалено.';
  }

  @override
  String get labelOrderTitle => 'Сортування міток';

  @override
  String get labelOrderHint =>
      'Перетягуйте для сортування. Діє для цього списку – і у веб-застосунку Mealie.';

  @override
  String get labelOrderEmpty => 'У цьому списку поки немає міток.';

  @override
  String get useAsActiveList => 'Зробити активним списком';

  @override
  String get activeListBadge => 'Активний';

  @override
  String get foodLabelLabel => 'Мітка';

  @override
  String get foodNoLabel => 'Без мітки';

  @override
  String get aliasesLabel => 'Псевдоніми';

  @override
  String get aliasAddHint => 'Додати псевдонім';

  @override
  String get foodOnHand => 'Є в сімʼї';

  @override
  String get timelineChildRecipesTitle => 'Додати й для повʼязаних рецептів';

  @override
  String timelineMadeForRecipe(String recipe) {
    return 'Зроблено для $recipe';
  }

  @override
  String get timelineFilter => 'Фільтр записів';

  @override
  String get timelineTypeComment => 'Приготування й нотатки';

  @override
  String get timelineTypeInfo => 'Інформація';

  @override
  String get timelineTypeSystem => 'Система';

  @override
  String get listManagementTitle => 'Списки покупок';

  @override
  String get managementTitle => 'Більше';

  @override
  String get pinToHome => 'Додати на головний екран';

  @override
  String get unpinFromHome => 'Прибрати з головного екрана';

  @override
  String homeScreenFull(int count) {
    return 'Головний екран заповнено – щонайбільше $count плиток. Спершу приберіть іншу плитку в розділі «Більше».';
  }

  @override
  String get selectAction => 'Вибрати';

  @override
  String selectedCount(int count) {
    return 'Вибрано: $count';
  }

  @override
  String get assignLabelAction => 'Призначити мітку';

  @override
  String get assignLabelOverwriteHint =>
      'Замінює мітку всіх вибраних продуктів.';

  @override
  String deleteSelectedConfirm(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Видалити $count запису?',
      many: 'Видалити $count записів?',
      few: 'Видалити $count записи?',
      one: 'Видалити $count запис?',
    );
    return '$_temp0';
  }

  @override
  String get seedDataAction => 'Завантажити стандартні дані';

  @override
  String get seedFoodsHint =>
      'Створює стандартні продукти Mealie вибраною мовою.';

  @override
  String get seedUnitsHint =>
      'Створює стандартні одиниці Mealie вибраною мовою.';

  @override
  String get seedLanguageLabel => 'Мова';

  @override
  String get seedDuplicateWarning =>
      'У вас уже є записи. Mealie не усуває дублікати – обʼєднувати їх доведеться самостійно.';

  @override
  String get seedDone => 'Стандартні дані створено';

  @override
  String get seedFailed => 'Не вдалося завантажити стандартні дані';

  @override
  String get exportAction => 'Експортувати';

  @override
  String get substitutionsLabel => 'Замінники';

  @override
  String get substitutionAddHint => 'Додати замінник';

  @override
  String get substitutionFoodLabel => 'Продукт (необовʼязково)';

  @override
  String get substitutionNoteLabel => 'Примітка (необовʼязково)';

  @override
  String get substitutionNeedOne => 'Введіть продукт або примітку';

  @override
  String get useAbbreviationLabel => 'Використовувати скорочення';

  @override
  String get useAbbreviationHint => 'Показувати «г» замість «грам» у рецептах';

  @override
  String get fractionLabel => 'Показувати дробом';

  @override
  String get fractionHint => '½ замість 0,5';

  @override
  String get standardizationTitle => 'Стандартизація';

  @override
  String get standardizationHint =>
      'Для перерахунку: 1 цієї одиниці дорівнює … (напр. 1 ст. л. = 15 мілілітрів).';

  @override
  String get standardQuantityLabel => 'Стандартна кількість';

  @override
  String get standardUnitLabel => 'Стандартна одиниця';

  @override
  String get standardUnitNone => 'Нічого';

  @override
  String get stdFluidOunce => 'Рідка унція (fl oz)';

  @override
  String get stdCup => 'Чашка (США)';

  @override
  String get stdOunce => 'Унція (oz)';

  @override
  String get stdPound => 'Фунт (lb)';

  @override
  String get stdMilliliter => 'Мілілітр';

  @override
  String get stdLiter => 'Літр';

  @override
  String get stdGram => 'Грам';

  @override
  String get stdKilogram => 'Кілограм';

  @override
  String get labelsTitle => 'Мітки';

  @override
  String get newLabel => 'Нова мітка';

  @override
  String get editLabel => 'Редагувати мітку';

  @override
  String get colorLabel => 'Колір';

  @override
  String labelDeleteConfirm(String name) {
    return 'Видалити «$name»? Позиції та продукти втратять цю мітку.';
  }

  @override
  String get importMenuAction => 'Імпорт';

  @override
  String get archivedEmpty =>
      'Архівних покупок поки немає. Після покупок торкніться «Завершити покупки» – позначені позиції збережуться тут.';

  @override
  String get sectionTitleLabel => 'Назва розділу';

  @override
  String get clearSection => 'Прибрати розділ';

  @override
  String get noPermissionGeneric =>
      'У вас немає на це прав у Mealie. Зверніться до адміністратора чи керівника сімʼї.';

  @override
  String get noPermissionEditRecipe =>
      'Ви не можете редагувати цей рецепт – його заблоковано або він належить іншій сімʼї. Це може лише автор або адміністратор.';

  @override
  String get noPermissionDeleteRecipe =>
      'Видалити рецепт може лише його автор або адміністратор.';

  @override
  String get noPermissionDemoteSelf =>
      'Не можна зняти з себе права адміністратора.';

  @override
  String get recipeLockedHint => 'Заблоковано – редагувати може лише автор';

  @override
  String get recipeDeleteOwnerOnlyHint =>
      'Видалити може лише автор або адміністратор';

  @override
  String get organizeReadOnlyHint =>
      'Лише перегляд: для створення, зміни й видалення потрібне право «Користувач може керувати продуктами, мітками й категоріями».';

  @override
  String get notesNotSavedNoPermission =>
      'Нотатку не збережено – у вас немає прав редагувати цей рецепт.';

  @override
  String get userManagementTitle => 'Керування користувачами';

  @override
  String get editUserTitle => 'Редагувати користувача';

  @override
  String get fullNameLabel => 'Повне Ім\'я';

  @override
  String get usernameLabel => 'Ім\'я користувача';

  @override
  String get emailLabel => 'Електронна пошта';

  @override
  String get passwordLabel => 'Пароль';

  @override
  String get householdLabel => 'Сімʼя';

  @override
  String get permissionsTitle => 'Дозволи';

  @override
  String get administratorLabel => 'Адміністратор';

  @override
  String get permCanInvite => 'Користувач може запрошувати інших в групу';

  @override
  String get permCanManage => 'Користувач може керувати налаштуваннями групи';

  @override
  String get permCanManageHousehold => 'Користувач може управляти сім\'єю';

  @override
  String get permCanOrganize =>
      'Користувач може керувати продуктами, мітками й категоріями';

  @override
  String get advancedFeaturesLabel => 'Увімкнути додаткові функції';

  @override
  String get passwordResetLinkAction =>
      'Створити посилання для скидання пароля';

  @override
  String get resetLockedUsersAction => 'Скинути заблокованих користувачів';

  @override
  String get inviteLinkTitle => 'Посилання-запрошення';

  @override
  String get inviteAction => 'Запрошення';

  @override
  String get userUpdated => 'Користувача оновлено';

  @override
  String get createUserTitle => 'Створити користувача';

  @override
  String get userCreated => 'Користувача створено';

  @override
  String userDeleteConfirm(String name) {
    return 'Видалити «$name»? Обліковий запис буде видалено з Mealie.';
  }

  @override
  String get passwordResetLinkCopied =>
      'Посилання скопійовано – передайте його користувачу. Воно дійсне обмежений час.';

  @override
  String lockedUsersReset(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Розблоковано $count користувача',
      many: 'Розблоковано $count користувачів',
      few: 'Розблоковано $count користувачів',
      one: 'Розблоковано $count користувача',
      zero: 'Немає заблокованих користувачів',
    );
    return '$_temp0';
  }

  @override
  String get inviteUsesLabel => 'Кількість використань';

  @override
  String get inviteCreated => 'Посилання-запрошення створено';

  @override
  String get inviteEmailHint =>
      'Адреса ел. пошти (необовʼязково – Mealie надішле запрошення)';

  @override
  String get inviteEmailSent => 'Запрошення надіслано поштою';

  @override
  String get inviteEmailFailed =>
      'Не вдалося надіслати лист (чи налаштовано SMTP у Mealie?). Посилання однаково працює.';

  @override
  String get copyLinkAction => 'Копіювати посилання';

  @override
  String get youLabel => 'Ви';

  @override
  String get membersPermissionsHint =>
      'Ви можете змінювати права членів своєї сімʼї – але не власні.';

  @override
  String get householdManagementTitle => 'Сімейне управління';

  @override
  String get householdsTitle => 'Сімʼї';

  @override
  String get createHouseholdTitle => 'Створити сімʼю';

  @override
  String get householdNameLabel => 'Назва сім\'ї';

  @override
  String get householdPreferencesTitle => 'Налаштування сімʼї';

  @override
  String get privateHouseholdLabel => 'Приватна сімʼя';

  @override
  String get privateHouseholdHint =>
      'Якщо зробити сім\'ю приватною, то всі налаштування публічного перегляду буде скинуто. Це замінить індивідуальні налаштування публічного перегляду';

  @override
  String get lockRecipeEditsLabel =>
      'Заблокувати редагування рецептів іншими сім\'ями';

  @override
  String get lockRecipeEditsHint =>
      'Якщо увімкнено, тільки члени вашої сім\'ї зможуть редагувати рецепти, які були створені вашою сім\'єю';

  @override
  String get householdRecipePreferencesTitle => 'Налаштування рецептів сімʼї';

  @override
  String get groupsTitle => 'Групи';

  @override
  String get groupLabel => 'Група';

  @override
  String get createGroupTitle => 'Створити групу';

  @override
  String get groupNameLabel => 'Назва групи';

  @override
  String get groupPreferencesTitle => 'Налаштування групи';

  @override
  String get privateGroupLabel => 'Приватна група';

  @override
  String get privateGroupHint =>
      'Якщо зробити групу приватною, то всі налаштування публічного перегляду буде скинуто. Це замінить індивідуальні налаштування публічного перегляду';

  @override
  String get firstDayOfWeekLabel => 'Перший день тижня';

  @override
  String get showAnnouncementsLabel => 'Показувати сповіщення від Mealie';

  @override
  String get recipePublicDefaultLabel =>
      'Дозволити користувачам за межами вашої групи бачити ваші рецепти';

  @override
  String get recipeShowNutritionDefaultLabel => 'Показувати харчову цінність';

  @override
  String get recipeShowAssetsDefaultLabel => 'Показувати медіаресурси рецепта';

  @override
  String get recipeLandscapeDefaultLabel => 'Альбомний вид за замовчуванням';

  @override
  String get recipeDisableCommentsDefaultLabel =>
      'Вимкнути користувачам можливість коментувати рецепти';

  @override
  String get myHouseholdSection => 'Моя сімʼя';

  @override
  String get myGroupSection => 'Моя група';

  @override
  String get preferencesSaved => 'Налаштування збережено';

  @override
  String get cannotDeleteWithUsers =>
      'Ще має користувачів – спершу перемістіть або видаліть їх у керуванні користувачами.';

  @override
  String deleteHouseholdConfirm(String name) {
    return 'Видалити сімʼю «$name»?';
  }

  @override
  String deleteGroupConfirm(String name) {
    return 'Видалити групу «$name»?';
  }

  @override
  String usersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count користувача',
      many: '$count користувачів',
      few: '$count користувачі',
      one: '$count користувач',
      zero: 'Немає користувачів',
    );
    return '$_temp0';
  }

  @override
  String get originalUrlLabel => 'Оригінальна URL-адреса';

  @override
  String get copyTextAction => 'Копіювати текст';

  @override
  String get copiedToClipboard => 'Скопійовано до буфера обміну';

  @override
  String get changelogEnglishHint =>
      'Примітки до випуску доступні лише англійською.';

  @override
  String get favoritesTitle => 'Улюблені';

  @override
  String get favoritesEmpty =>
      'Улюблених поки немає. Торкніться сердечка на рецепті, щоб зібрати його тут.';

  @override
  String get changelogTitle => 'Що нового';

  @override
  String get changeProfileImage => 'Змінити фото профілю';

  @override
  String get profileImageUpdated => 'Фото профілю оновлено';

  @override
  String get profileImageFailed => 'Не вдалося завантажити фото профілю';

  @override
  String get myAccountTitle => 'Мій обліковий запис';

  @override
  String get ownAccountHint =>
      'Тут можна редагувати власний обліковий запис. Іншими користувачами керують адміністратори й учасники з правом «керувати».';

  @override
  String get changePasswordAction => 'Змінити пароль';

  @override
  String get currentPasswordLabel => 'Поточний пароль';

  @override
  String get newPasswordLabel => 'Новий пароль';

  @override
  String get confirmPasswordLabel => 'Підтвердьте пароль';

  @override
  String get passwordTooShort => 'Щонайменше 8 символів';

  @override
  String get passwordsDoNotMatch => 'Паролі не збігаються';

  @override
  String get passwordUpdated => 'Пароль оновлено';

  @override
  String get passwordChangeFailed => 'Не вдалося змінити пароль';

  @override
  String passwordManagedExternally(String method) {
    return 'Ви входите через $method — змініть пароль там.';
  }

  @override
  String get bulkAddHint => 'Один рядок — один запис.';

  @override
  String bulkAddCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Додати $count запису',
      many: 'Додати $count записів',
      few: 'Додати $count записи',
      one: 'Додати $count запис',
    );
    return '$_temp0';
  }

  @override
  String get linkRecipeAction => 'Привʼязати рецепт';

  @override
  String get useFoodAction => 'Використати продукт замість рецепта';

  @override
  String get addSubstitutionsAction => 'Додати замінники';

  @override
  String get clearSubstitutionsAction => 'Прибрати замінники';

  @override
  String get recipeSubstitutionsTitle => 'Замінники';

  @override
  String get substitutionUnknownFood =>
      'Лише наявні продукти – інакше використайте примітку';

  @override
  String get insertAboveAction => 'Вставити вище';

  @override
  String get insertBelowAction => 'Вставити нижче';

  @override
  String get moveToTopAction => 'Перемістити на початок';

  @override
  String get moveToBottomAction => 'Перемістити в кінець';

  @override
  String get linkReferencesAction => 'Привʼязати посилання';

  @override
  String get editMarkdownAction => 'Редагувати Markdown';

  @override
  String get previewMarkdownAction => 'Попередній перегляд Markdown';

  @override
  String get insertStepImageAction => 'Завантажити зображення';

  @override
  String get mergeAboveAction => 'Обʼєднати з попереднім';

  @override
  String get linkedToOtherStep => 'Зв\'язано з іншим кроком';

  @override
  String get noNotesToLink => 'Немає нотаток для привʼязки';

  @override
  String get ownerLabel => 'Власник';

  @override
  String get ingredientParserTitle => 'Аналізатор інгредієнтів';

  @override
  String ingredientParserHint(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count інгредієнта ще не структуровано. Виберіть аналізатор, перевірте результат, застосуйте.',
      many:
          '$count інгредієнтів ще не структуровано. Виберіть аналізатор, перевірте результат, застосуйте.',
      few:
          '$count інгредієнти ще не структуровано. Виберіть аналізатор, перевірте результат, застосуйте.',
      one:
          '$count інгредієнт ще не структуровано. Виберіть аналізатор, перевірте результат, застосуйте.',
    );
    return '$_temp0';
  }

  @override
  String get parserNlp => 'Аналізатор природної мови';

  @override
  String get parserBrute => 'Простий аналізатор';

  @override
  String get parserOpenai => 'Аналізатор OpenAI';

  @override
  String get parserApp => 'Офлайн (застосунок)';

  @override
  String get parseFailed => 'Не вдалося проаналізувати';

  @override
  String get parseAction => 'Проаналізувати';

  @override
  String applyParsedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Застосувати $count інгредієнта',
      many: 'Застосувати $count інгредієнтів',
      few: 'Застосувати $count інгредієнти',
      one: 'Застосувати $count інгредієнт',
      zero: 'Нічого не вибрано',
    );
    return '$_temp0';
  }

  @override
  String get parsedNewBadge => 'новий';

  @override
  String get hoursShort => 'год';

  @override
  String get minutesShort => 'хв';

  @override
  String get timeExtraHint => 'Додатково, напр. «плюс ніч»';

  @override
  String get yieldLabel => 'Вихід';

  @override
  String get yieldTextLabel => 'Текст виходу';

  @override
  String get prepTimeLabel => 'Час підготовки';

  @override
  String get performTimeLabel => 'Час приготування';

  @override
  String get totalTimeLabel => 'Загальний час';

  @override
  String get settingPublicRecipe => 'Публічний рецепт';

  @override
  String get settingShowNutrition => 'Показати харчову цінність';

  @override
  String get settingShowAssets => 'Показати медіаресурси';

  @override
  String get settingLandscapeView => 'Вид в ландшафтному режимі';

  @override
  String get settingDisableComments => 'Вимкнути коментарі';

  @override
  String get settingDisableAmount => 'Вимкнути кількість інгредієнтів';

  @override
  String get settingLocked => 'Заблоковано';

  @override
  String get settingLockedOwnerOnly =>
      'Блокувати й розблоковувати рецепт може лише його автор.';

  @override
  String get apiExtrasTitle => 'Додаткове API';

  @override
  String get apiExtrasHint =>
      'Власні пари ключ/значення для сторонніх застосунків, напр. для запуску автоматизацій.';

  @override
  String get extraKeyLabel => 'Ключ';

  @override
  String get extraValueLabel => 'Значення';

  @override
  String get addExtraAction => 'Додати поле';

  @override
  String durationHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count години',
      many: '$count годин',
      few: '$count години',
      one: '$count година',
    );
    return '$_temp0';
  }

  @override
  String durationMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count хвилини',
      many: '$count хвилин',
      few: '$count хвилини',
      one: '$count хвилина',
    );
    return '$_temp0';
  }

  @override
  String get discardChangesConfirm => 'Скасувати незбережені зміни?';

  @override
  String get discardChanges => 'Скасувати зміни';

  @override
  String get imageFromUrl => 'Зображення за URL';

  @override
  String get deleteRecipeImage => 'Видалити зображення рецепту';

  @override
  String get deleteRecipeImageConfirm =>
      'Ви впевнені, що хочете видалити це зображення рецепту?';

  @override
  String get bulkAddIngredients => 'Додати інгредієнти списком';

  @override
  String get bulkAddSteps => 'Додати кроки списком';

  @override
  String get stepImageFailed => 'Не вдалося завантажити зображення';

  @override
  String get servingsAndTimes => 'Порції та час';

  @override
  String get recipeSettingsTitle => 'Налаштування рецепта';

  @override
  String get jsonEditorTitle => 'Редактор JSON';

  @override
  String get jsonInvalid => 'Недійсний JSON – перевірте.';

  @override
  String get editorOfflineHint =>
      'Відкрито офлайн: для збереження потрібне підключення. Новіші поля Mealie (напр. замінники) лишаються без змін.';

  @override
  String get parseLineFailed => 'Не розпізнано – лишається без змін';

  @override
  String get createManualTitle => 'Створити рецепт вручну';

  @override
  String get createManualHint =>
      'Введіть назву – інгредієнти, кроки, зображення й усе інше додасте потім у редакторі рецепта.';

  @override
  String get createManualButton => 'Створити й редагувати';

  @override
  String get changelogEmpty => 'Для цієї версії ще немає записів.';

  @override
  String get finderDescription =>
      'Пошук рецептів базується на продуктах, які ви маєте. Ви також можете фільтрувати за наявними інструментами та встановити максимальну кількість відсутніх продуктів або інструментів.';

  @override
  String get finderSelectedIngredients => 'Вибрані продукти';

  @override
  String get finderNoIngredientsSelected => 'Жодного продукту не вибрано';

  @override
  String get finderMissing => 'Відсутні';

  @override
  String get finderNoRecipesFound => 'Рецептів не знайдено';

  @override
  String get finderNoRecipesFoundDescription =>
      'Спробуйте додати більше продуктів до пошукового списку або підлаштувати фільтри';

  @override
  String get finderIncludeFoodsOnHand => 'Включити наявні продукти';

  @override
  String get finderIncludeToolsOnHand => 'Включити наявні інструменти';

  @override
  String get finderIncludeSubstitutions => 'Враховувати замінники';

  @override
  String get finderSubstituting => 'Заміна';

  @override
  String finderSubstituteForFood(String substitute, String food) {
    return '$substitute замість $food';
  }

  @override
  String get finderMaxMissingIngredients => 'Максимум відсутніх продуктів';

  @override
  String get finderMaxMissingTools => 'Максимум відсутніх інструментів';

  @override
  String get finderSelectedTools => 'Вибрані інструменти';

  @override
  String get finderReadyToMake => 'Готове до приготування';

  @override
  String get finderAlmostReadyToMake => 'Майже готове до приготування';

  @override
  String get finderSettings => 'Налаштування';

  @override
  String get finderLoadingRecipes => 'Завантаження рецептів';

  @override
  String get finderClearSelection => 'Очистити вибір';

  @override
  String get finderOfflineHint =>
      'Немає звʼязку із сервером – результати з рецептів, збережених на цьому пристрої.';

  @override
  String get sendPeerOfflineHint =>
      'Зараз недоступно – надійде, коли там відкриють застосунок';

  @override
  String sendDeliveredLater(String device) {
    return '«$device» зараз недоступний. Рецепт надійде, щойно там відкриють застосунок.';
  }

  @override
  String get sendQueuedOffline =>
      'Зараз немає підключення. Рецепт надішлеться автоматично, щойно ви знову будете онлайн.';

  @override
  String get searchHasAll => 'Є всі';

  @override
  String get searchHasAny => 'Містить будь-який';

  @override
  String get recipeFilterTitle => 'Фільтр';

  @override
  String get finderOtherFilters => 'Інші фільтри';

  @override
  String get qfOpEquals => 'дорівнює';

  @override
  String get qfOpNotEquals => 'не дорівнює';

  @override
  String get qfOpGreater => 'більше ніж';

  @override
  String get qfOpGreaterEq => 'більше або дорівнює';

  @override
  String get qfOpLess => 'менше ніж';

  @override
  String get qfOpLessEq => 'менше або дорівнює';

  @override
  String get qfOpNewerThan => 'новіше, ніж';

  @override
  String get qfOpOlderThan => 'старіший ніж';

  @override
  String qfDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count дня тому',
      many: '$count днів тому',
      few: '$count дні тому',
      one: '$count день тому',
    );
    return '$_temp0';
  }

  @override
  String get filterResetAll => 'Скинути всі фільтри';

  @override
  String get filterAny => 'Будь-який';

  @override
  String get filterOfflineIgnored =>
      'Офлайн «Інші фільтри» можна застосувати лише в простій формі.';

  @override
  String linkedRecipesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count повʼязаного рецепта',
      many: '$count повʼязаних рецептів',
      few: '$count повʼязані рецепти',
      one: '$count повʼязаний рецепт',
      zero: 'Немає повʼязаних рецептів',
    );
    return '$_temp0';
  }

  @override
  String get shoppingReminderNotificationsOff =>
      'Сповіщення для Mealie Recipes вимкнено — без них нагадування про покупки не зʼявиться. Дозвольте сповіщення в налаштуваннях.';

  @override
  String get shoppingReminderInactiveHint =>
      'Нагадування про покупки зараз не працює: встановіть доступ до геолокації «Завжди» й дозвольте сповіщення.';

  @override
  String get bulkImportTitle => 'Масовий URL імпорт';

  @override
  String get bulkImportDescription =>
      'Масовий імпортер рецептів дозволяє імпортувати відразу декілька рецептів, додаючи сайти в чергу на сервері та виконуючи завдання у фоновому режимі. Це може бути корисно під час початкового переходу на Mealie або коли ви хочете імпортувати велику кількість рецептів.';

  @override
  String get bulkAddTitle => 'Масове додавання';

  @override
  String get bulkImportSetOrganizers => 'Обрати категорії та мітки';

  @override
  String get bulkImportStarted => 'Процес масового імпорту розпочато';

  @override
  String get bulkImportFailed => 'Помилка масового імпорту';

  @override
  String get bulkImportReports => 'Масовий імпорт';

  @override
  String get bulkImportUrlHint => 'URL-адреса рецепту';

  @override
  String get migrationsTitle => 'Міграції даних';

  @override
  String get migrationsDescription =>
      'Рецепти можна мігрувати з іншого підтримуваного застосунку в Mealie. Це чудовий спосіб розпочати роботу з Mealie. Перенесення даних між екземплярами Mealie або відновлення ранішої резервної копії Mealie здійснюється за допомогою інструментів резервного копіювання та відновлення.';

  @override
  String get migrationNew => 'Нова міграція';

  @override
  String get migrationChooseType => 'Оберіть тип міграції';

  @override
  String get noFileSelected => 'Файл не обрано';

  @override
  String migrationTagAll(String tag) {
    return 'Позначити всі рецепти міткою $tag';
  }

  @override
  String get migrationPrevious => 'Попередні міграції';

  @override
  String get migrationMealieDescription =>
      'Mealie може імпортувати рецепти із застосунку Mealie версій до v1.0. Експортуйте свої рецепти зі старого сервера та завантажте zip-файл нижче. Зверніть увагу, що з експорту можна імпортувати лише рецепти. Це стосується тільки систем, старіших за v1.0. Резервну копію, створену у версії v1.0 або новішій, слід відновлювати за допомогою інструментів резервного копіювання та відновлення.';

  @override
  String get migrationChowdownDescription =>
      'Mealie підтримує формат chowdown репозиторію. Завантажте репозиторій коду як файл .zip і відвантажте його нижче.';

  @override
  String get migrationCopyMeThatDescription =>
      'Mealie може імпортувати рецепти з Copy Me That. Експортуйте ваші рецепти в форматі HTML, а потім відвантажте .zip нижче.';

  @override
  String get migrationMyRecipeBoxDescription =>
      'Mealie може імпортувати рецепти з My Recipe Box. Експортуйте ваші рецепти в форматі CSV, а потім відвантажте .csv файл нижче.';

  @override
  String get migrationNextcloudDescription =>
      'Рецепти Nextcloud можна імпортувати з zip-архіву, який містить дані, що зберігаються в Nextcloud. Перегляньте приклади структури тек нижче, щоб пересвідчитися що ваші рецепти можна імпортувати.';

  @override
  String get migrationPaprikaDescription =>
      'Mealie може імпортувати рецепти з додатка Paprika. Експортуйте ваші рецепти з Paprika, перейменуйте розширення експорту в .zip та відвантажте його нижче.';

  @override
  String get migrationPlanToEatDescription =>
      'Mealie може імпортувати рецепти з Plan to Eat.';

  @override
  String get migrationRecipeKeeperDescription =>
      'Mealie може імпортувати рецепти з Recipe Keeper. Експортувати ваші рецепти у форматі zip, а потім відвантажте файл .zip нижче.';

  @override
  String get migrationTandoorDescription =>
      'Mealie може імпортувати рецепти з Tandoor. Експортуйте свої дані в формат \"Default\", а потім завантажте .zip нижче.';

  @override
  String get migrationCooknDescription =>
      'Mealie може імпортувати рецепти з DVO Cook\'n X3. Експортуйте кулінарну книгу або меню у форматі «Cook\'n», перейменуйте розширення експорту на .zip, а потім завантажте файл .zip нижче.';

  @override
  String get reportTitle => 'Звіт';

  @override
  String get recipeDataTitle => 'Дані рецептів';

  @override
  String get recipeDataDescription =>
      'Використовуйте цей розділ для керування даними, пов\'язаними з вашими рецептами. Ви можете виконати кілька масових дій для ваших рецептів, включаючи експорт, видалення, додавання мітки та присвоєння категорій.';

  @override
  String get recipeDataTagTitle => 'Додати мітки';

  @override
  String get recipeDataCategorizeTitle => 'Упорядкувати рецепти';

  @override
  String get recipeDataSettingsTitle => 'Оновити налаштування';

  @override
  String get recipeDataExportTitle => 'Експорт рецептів';

  @override
  String get recipeDataDeleteTitle => 'Видалити рецепти';

  @override
  String recipeDataExportConfirm(int count) {
    return 'Буде експортовано такі рецепти ($count).';
  }

  @override
  String get recipeDataExportsTitle => 'Експорт даних';

  @override
  String get recipeDataExportsDescription =>
      'Цей розділ містить посилання на експорти які можна завантажити. Ці експорти не будуть зберігатися вічно, так що звантажте їх поки можете.';

  @override
  String get recipeDataPurgeExports => 'Знищити експорт';

  @override
  String get recipeDataPurgeConfirm =>
      'Ви впевнені, що хочете видалити всі експортовані дані?';

  @override
  String get recipeActionsTitle => 'Дії рецепту';

  @override
  String get recipeActionNew => 'Нова дія рецепту';

  @override
  String get recipeActionEdit => 'Редагувати дії рецепта';

  @override
  String get recipeActionTypeLink => 'Посилання';

  @override
  String get recipeActionTypePost => 'Опублікувати';

  @override
  String get webhooksTitle => 'Вебхуки';

  @override
  String get webhooksDescription =>
      'Веб-хуки, визначені нижче, будуть виконуватися, коли буде визначено меню на день. У призначений час веб-хуки будуть надіслані з даними з рецепта, запланованого на цей день. Зверніть увагу, що виконання веб-хуків не є точним. Веб-хуки виконуються з інтервалом у 5 хвилин, тому вони будуть виконані протягом 5 +/- хвилин від призначеного часу.';

  @override
  String get webhookName => 'Назва вебхука';

  @override
  String get webhookUrl => 'URL-адреса вебхука';

  @override
  String get notifiersTitle => 'Нагадувачі';

  @override
  String get notifiersDescription =>
      'Налаштуйте email та push сповіщення, що спрацьовують для певних подій.';

  @override
  String get notifierNew => 'Нове сповіщення';

  @override
  String get notifierDescription =>
      'Mealie використовує бібліотеку Apprise для створення сповіщень. Вони пропонують багато варіантів використання служб для сповіщень. Зверніться до wiki бібліотеки Apprise, щоб отримати повну інструкцію про те, як створити URL-адресу для вашого сервісу. При наявності вибраний тип вашого сповіщення може включати додаткові функції.';

  @override
  String get notifierAppriseUrl => 'URL-адреса Apprise';

  @override
  String get notifierAppriseUrlSkipped =>
      'Apprise URL (пропущено якщо порожній)';

  @override
  String get notifierAppriseUrlBlankHint =>
      'Оскільки URL адреси, як правило, містять конфіденційну інформацію, це поле залишається навмисно порожнім під час редагування. Якщо ви хочете оновити URL адресу, введіть тут новий, інакше залиште його порожнім, щоб зберегти поточну URL адресу.';

  @override
  String get notifierEnable => 'Увімкнути нагадувач';

  @override
  String get notifierWhatEvents =>
      'На які події повинен підписатися цей нагадувач?';

  @override
  String get notifierRecipeEvents => 'Події рецепту';

  @override
  String get notifierUserEvents => 'Події користувача';

  @override
  String get notifierMealplanEvents => 'Події плану харчування';

  @override
  String get notifierShoppingListEvents => 'Події списку покупок';

  @override
  String get notifierCookbookEvents => 'Події кулінарної книги';

  @override
  String get notifierTagEvents => 'Події міток';

  @override
  String get notifierCategoryEvents => 'Події категорій';

  @override
  String get notifierLabelEvents => 'Події мітки';

  @override
  String get notifierUserSignup =>
      'Коли новий користувач приєднується до групи';

  @override
  String get notifierCreate => 'Створити';

  @override
  String get notifierUpdate => 'Оновити';

  @override
  String get notifierDelete => 'Видалити';

  @override
  String get notifierTestSent => 'Тестове повідомлення надіслано';

  @override
  String get adminTitle => 'Адміністративні налаштування';

  @override
  String get backupsTitle => 'Резервні копії';

  @override
  String get backupsDescription =>
      'Резервні копії - це повні знімки бази даних та каталогу даних сайту. Вони містять усі дані, і неможливо виключити з них окремі підмножини даних. Можна уявити це як знімок Mealie в певний момент часу. Вони слугують незалежним від бази даних способом експорту та імпорту даних або створення резервної копії сайту на зовнішньому носії.';

  @override
  String get backupCreateHeading => 'Створити резервну копію';

  @override
  String get backupCreated => 'Резервну копію створено успішно';

  @override
  String get backupCreateFailed =>
      'Помилка створення резервної копії. Перегляньте файл журналу';

  @override
  String get backupDelete => 'Видалити резервну копію';

  @override
  String get backupDeleted => 'Резервна копія видалена';

  @override
  String get backupRestore => 'Відновити з резервної копії';

  @override
  String get backupRestoreDescription =>
      'Відновлення цієї резервної копії перезапише всі поточні дані в базі даних і в каталозі даних її вмістом. Якщо відновлення вдасться, вас буде виведено з облікового запису.';

  @override
  String get backupCannotBeUndone =>
      'Цю дію не можна скасувати - використовуйте з обережністю.';

  @override
  String get backupAcknowledge =>
      'Я розумію, що ця дія незворотна, руйнівна і може спричинити втрату даних';

  @override
  String get backupRestoreSuccess => 'Відновлення успішне';

  @override
  String get backupRestoreFailed =>
      'Не вдалося відновити. Перевірте журнали вашого сервера для більш докладної інформації';

  @override
  String get maintenanceTitle => 'Обслуговування';

  @override
  String get maintenanceSummary => 'Загальна інформація';

  @override
  String get maintenanceStorage => 'Деталі сховища';

  @override
  String get maintenanceDataDirSize => 'Розмір теки з даними';

  @override
  String get maintenanceCleanableDirs => 'Теки що можна видалити';

  @override
  String get maintenanceCleanableImages => 'Зображення що можна видалити';

  @override
  String get maintenanceTempDir => 'Тимчасова тека (.temp)';

  @override
  String get maintenanceBackupsDir => 'Тека резервних копій (backups)';

  @override
  String get maintenanceGroupsDir => 'Тека груп (groups)';

  @override
  String get maintenanceRecipesDir => 'Тека рецептів (recipes)';

  @override
  String get maintenanceUserDir => 'Тека користувачів (user)';

  @override
  String get maintenanceCleanDirs => 'Очистити каталоги';

  @override
  String get maintenanceCleanDirsDescription =>
      'Видаляє всі папки рецептів, які не є дійсними UUID';

  @override
  String get maintenanceCleanTemp => 'Очистити тимчасові файли';

  @override
  String get maintenanceCleanTempDescription =>
      'Видаляє всі файли і теки в каталозі .temp';

  @override
  String get maintenanceCleanImages => 'Видалити зображення';

  @override
  String get maintenanceCleanImagesDescription =>
      'Видалити всі зображення, що не закінчуються на .webp';

  @override
  String get maintenanceActions => 'Дії';

  @override
  String get adminConfiguration => 'Конфігурація';

  @override
  String get adminAppVersion => 'Версія програми';

  @override
  String get adminUpToDate => 'Оновлення не потрібне';

  @override
  String adminVersionOutdated(String current, String latest) {
    return 'Ваша поточна версія ($current) не відповідає останньому випуску. Варто оновитися до останньої версії ($latest).';
  }

  @override
  String get adminBaseUrl => 'URL-адреса сервера';

  @override
  String get adminBaseUrlOk =>
      'URL-адреса на стороні сервера не відповідає значенню за замовчуванням';

  @override
  String get adminBaseUrlError =>
      '`BASE_URL` все ще встановлене в стандартне значення на сервері API. Це призведе до проблем з посиланнями, згенерованими на сервері для листів, і т. д.';

  @override
  String adminAuthReady(String provider) {
    return '$provider готовий';
  }

  @override
  String adminAuthNotReady(String provider) {
    return '$provider не готовий';
  }

  @override
  String adminAuthDisabled(String provider) {
    return '$provider вимкнено';
  }

  @override
  String adminAuthSuccessText(String provider) {
    return 'Усі потрібні змінні $provider задано.';
  }

  @override
  String adminAuthErrorText(String provider) {
    return 'Не всі значення $provider налаштовано. Можна ігнорувати, якщо ви не використовуєте автентифікацію $provider.';
  }

  @override
  String adminAuthDisabledText(String envVar) {
    return 'Щоб увімкнути, встановіть $envVar у true.';
  }

  @override
  String get adminEmailStatus => 'Статус налаштування електронної пошти';

  @override
  String get adminEmailConfigured => 'Електронну пошту налаштовано';

  @override
  String get adminNotReady => 'Не готово - перевірте змінні середовища';

  @override
  String get adminSucceeded => 'Успішно';

  @override
  String get adminFailed => 'Невдало';

  @override
  String get adminSiteStatistics => 'Статистика сайту';

  @override
  String get adminUncategorized => 'Рецепти без категорії';

  @override
  String get adminUntagged => 'Рецепти без міток';

  @override
  String get adminGeneralAbout => 'Основна інформація';

  @override
  String get adminVersion => 'Версія';

  @override
  String get adminBuild => 'Збірка';

  @override
  String get adminApplicationMode => 'Режим додатку';

  @override
  String get adminProduction => 'Користувацький';

  @override
  String get adminDevelopment => 'Розробка';

  @override
  String get adminDemoStatus => 'Статус демо';

  @override
  String get adminDemo => 'Демо';

  @override
  String get adminNotDemo => 'Не демо';

  @override
  String get adminApiPort => 'Порт API';

  @override
  String get adminApiDocs => 'Документація API';

  @override
  String get adminDatabaseType => 'Тип бази даних';

  @override
  String get adminDatabaseUrl => 'URL-адреса бази даних';

  @override
  String get adminDefaultGroup => 'Групи за замовчуванням';

  @override
  String get adminDefaultHousehold => 'Господарство за замовчуванням';

  @override
  String get adminScraperVersion => 'Версія парсера рецептів';

  @override
  String get adminStatUsers => 'Користувачі';

  @override
  String get adminStatHouseholds => 'Сімʼї';

  @override
  String get adminStatGroups => 'Групи';

  @override
  String get recipeDuplicate => 'Дублювати рецепт';

  @override
  String get recipeDuplicateAction => 'Копіювати';

  @override
  String get recipeShareLink => 'Поділитися рецептом';

  @override
  String get recipeShareExpiration => 'Дійсний до';

  @override
  String get recipeShareCopied =>
      'Посилання на рецепт скопійовано в буфер обміну';

  @override
  String get enabledLabel => 'Увімкнено';

  @override
  String get disabledLabel => 'Вимкнено';

  @override
  String get testAction => 'Тест';

  @override
  String get yesLabel => 'Так';

  @override
  String get noLabel => 'Ні';

  @override
  String get downloadAction => 'Завантажити';

  @override
  String get backupUpload => 'Завантажити';

  @override
  String get zipImportButton => 'Імпортувати з Zip';

  @override
  String get zipImportDescription =>
      'Імпортувати один рецепт, який був експортований з іншої Mealie.';

  @override
  String get reportStatus => 'Статус';

  @override
  String get reportDate => 'Дата';

  @override
  String get recipeActionTitleLabel => 'Назва';

  @override
  String get clearAll => 'Очистити';

  @override
  String get recipeDataSettingsExplanation =>
      'Вибрані параметри, за винятком заблокованих варіантів, будуть застосовані до всіх вибраних рецептів.';

  @override
  String get adminAllowSignup => 'Дозволити реєстрацію';

  @override
  String get adminAllowPasswordLogin => 'Дозволити вхід за паролем';

  @override
  String get adminEmailInvalid => 'Введіть коректну адресу ел. пошти.';

  @override
  String adminEmailTestResult(String result) {
    return 'Перевірка пошти: $result';
  }

  @override
  String get adminSendTestEmail => 'Надіслати тестовий лист';

  @override
  String get adminTestEmailAddress => 'Отримувач';

  @override
  String get backupCreate => 'Створити резервну копію';

  @override
  String backupDeleteConfirm(String name) {
    return 'Видалити резервну копію «$name»?';
  }

  @override
  String get backupPostgresNote =>
      'Якщо ви використовуєте PostgreSQL, перед відновленням прочитайте порядок резервного копіювання/відновлення в документації Mealie.';

  @override
  String get backupUploaded => 'Резервну копію вивантажено';

  @override
  String get backupsEmpty => 'Резервних копій ще немає.';

  @override
  String get bulkImportAddRow => 'Додати URL';

  @override
  String get bulkImportStart => 'Почати імпорт';

  @override
  String get chooseFileButton => 'Вибрати файл';

  @override
  String get deselectAllAction => 'Зняти вибір';

  @override
  String get downloadFailed => 'Не вдалося завантажити';

  @override
  String get fileSaved => 'Файл збережено';

  @override
  String get loadFailed => 'Не вдалося завантажити';

  @override
  String get maintenanceActionsWarning =>
      'Дії обслуговування руйнівні й потребують обережності. Будь-яка з них незворотна.';

  @override
  String get maintenanceConfirm =>
      'Ця дія руйнівна й не може бути скасована. Продовжити?';

  @override
  String get maintenanceDone => 'Готово';

  @override
  String get maintenanceFailed => 'Дія обслуговування не вдалася';

  @override
  String get maintenanceRun => 'Виконати';

  @override
  String get migrationFailed => 'Міграція не вдалася';

  @override
  String get migrationStart => 'Почати міграцію';

  @override
  String get migrationStarted => 'Міграцію завершено — див. звіт нижче.';

  @override
  String get moreImportOptions => 'Інші способи імпорту';

  @override
  String notifierDeleteConfirm(String name) {
    return 'Видалити сповіщувач «$name»?';
  }

  @override
  String get notifierEdit => 'Редагувати сповіщувач';

  @override
  String notifierEventCount(int count) {
    return 'Події: $count';
  }

  @override
  String get notifierTestFailed => 'Не вдалося надіслати тестове повідомлення';

  @override
  String get notifiersEmpty => 'Сповіщувачів ще немає.';

  @override
  String recipeActionDeleteConfirm(String name) {
    return 'Видалити дію рецепта «$name»?';
  }

  @override
  String get recipeActionFailed => 'Дія рецепта не вдалася';

  @override
  String get recipeActionSent => 'Рецепт надіслано';

  @override
  String get recipeActionUrlHint => 'Заповнювачі';

  @override
  String get recipeActionsDescription =>
      'Дії рецептів зʼявляються в меню кожного рецепта. «Посилання» відкриває URL, «Post» доручає серверу Mealie надіслати рецепт на URL.';

  @override
  String get recipeActionsEmpty => 'Дій рецептів ще немає.';

  @override
  String recipeDataDeleteConfirm(int count) {
    return 'Видалити вибрані рецепти ($count)? Цю дію неможливо скасувати.';
  }

  @override
  String recipeDataDeleteForbidden(int count) {
    return 'Ви не можете видалити $count з вибраних рецептів (це може лише їхній автор або адміністратор).';
  }

  @override
  String recipeDataDeleted(int count) {
    return 'Видалено рецептів: $count';
  }

  @override
  String get recipeDataExportAction => 'Експортувати';

  @override
  String get recipeDataExportDone =>
      'Експорт створено — завантажте його в розділі «Експорт даних».';

  @override
  String recipeDataExportExpires(String date) {
    return 'спливає $date';
  }

  @override
  String get recipeDataExportFailed => 'Експорт не вдався';

  @override
  String get recipeDataExportsEmpty => 'Немає доступних експортів.';

  @override
  String recipeDataUpdated(int count) {
    return 'Оновлено рецептів: $count';
  }

  @override
  String get recipeDuplicated => 'Рецепт дубльовано';

  @override
  String get recipeExportJson => 'Експорт у JSON';

  @override
  String get recipeExportZip => 'Експорт у ZIP (із зображенням)';

  @override
  String get recipeShareCreate => 'Створити посилання';

  @override
  String get recipeShareDescription =>
      'Будь-хто з посиланням може переглянути цей рецепт у браузері — без облікового запису — доки посилання не спливе.';

  @override
  String get recipeShareEmpty => 'Посилань для поширення ще немає.';

  @override
  String recipeShareExpiresAt(String date) {
    return 'Спливає $date';
  }

  @override
  String get recipeWebToolsMenu => 'Дублювати, посилання й інше';

  @override
  String get reload => 'Оновити';

  @override
  String get reportDeleteConfirm => 'Видалити цей звіт?';

  @override
  String get reportEntries => 'Записи';

  @override
  String get reportFailedEntries => 'Невдало';

  @override
  String get reportOnlyFailed => 'Показувати лише невдалі записи';

  @override
  String get reportStatusFailure => 'Помилка';

  @override
  String get reportStatusInProgress => 'Виконується';

  @override
  String get reportStatusPartial => 'Частково';

  @override
  String get reportStatusSuccess => 'Успішно';

  @override
  String get reportsEmpty => 'Звітів ще немає.';

  @override
  String get uploadFailed => 'Не вдалося вивантажити';

  @override
  String webhookDeleteConfirm(String name) {
    return 'Видалити вебхук «$name»?';
  }

  @override
  String get webhookEdit => 'Редагувати вебхук';

  @override
  String get webhookNew => 'Новий вебхук';

  @override
  String get webhookTestFailed => 'Не вдалося запустити перевірку';

  @override
  String get webhookTestSent => 'Тестовий вебхук запущено';

  @override
  String get webhookTime => 'Час (місцевий)';

  @override
  String get webhooksEmpty => 'Вебхуків ще немає.';

  @override
  String get zipImportFailed => 'Імпорт ZIP не вдався';

  @override
  String get aiProvidersTitle => 'Постачальники ШІ';

  @override
  String get aiProvidersDescription =>
      'Налаштуйте ШІ-провайдерів, щоб увімкнути функції на базі штучного інтелекту, такі як покращений розбір інгредієнтів, створення рецептів із відео тощо!';

  @override
  String get aiProviderSettingsTitle => 'Налаштування постачальника ШІ';

  @override
  String get aiProvidersList => 'Постачальники';

  @override
  String get aiProviderCreate => 'Створити постачальника';

  @override
  String get aiProviderEdit => 'Редагувати постачальника';

  @override
  String get aiDefaultProvider => 'Постачальник за замовчуванням';

  @override
  String get aiDefaultProviderDescription =>
      'Потрібен для увімкнення ШІ функцій';

  @override
  String get aiAudioProvider => 'Аудіо постачальник';

  @override
  String get aiAudioProviderDescription =>
      'Увімкнути функції транскрипції аудіо, такі як створення рецептів із відео';

  @override
  String get aiImageProvider => 'Постачальник обробки зображень';

  @override
  String get aiImageProviderDescription =>
      'Дозволяє розпізнавати зображення, наприклад створювати рецепти з зображень';

  @override
  String get aiProviderName => 'Назва постачальника';

  @override
  String get aiApiKey => 'Ключ API';

  @override
  String get aiApiKeyCreateDescription =>
      'API-ключ вашого постачальника для автентифікації. Якщо ваш сервіс (наприклад, Ollama) не використовує API-ключ, вам все одно потрібно щось сюди вписати.';

  @override
  String get aiApiKeyEditDescription =>
      'Залиште це поле порожнім, якщо не хочете його змінювати.';

  @override
  String get aiBaseUrl => 'Основний URL';

  @override
  String get aiBaseUrlDescription =>
      'Якщо ви використовуєте OpenAI, залиште це поле порожнім. Це має бути OpenAI-сумісний кінцевий пункт (наприклад, \"http://localhost:11434/v1\").';

  @override
  String get aiModel => 'Модель';

  @override
  String get aiModelDescription =>
      'Яку модель вашого постачальника ШІ слід використовувати (наприклад, \"gpt-5\").';

  @override
  String get aiTimeout => 'Час очікування запиту (в секундах)';

  @override
  String get aiProviderCreated => 'Постачальника створено';

  @override
  String get aiProviderUpdated => 'Постачальника оновлено';

  @override
  String get aiProviderDeleted => 'Постачальника видалено';

  @override
  String get aiProviderCreateFailed => 'Не вдалося створити постачальника';

  @override
  String get aiProviderUpdateFailed => 'Не вдалося оновити постачальника';

  @override
  String get aiProviderDeleteFailed => 'Не вдалося видалити постачальника';

  @override
  String get aiRequestHeaders => 'Заголовки запиту';

  @override
  String get aiRequestParams => 'Параметри запиту';

  @override
  String get aiNoDefaultWarning =>
      'Ви не встановили постачальника за замовчуванням, тому ШІ функції вимкнено';

  @override
  String get aiTestConnection => 'Перевірити підключення';

  @override
  String get aiTestSucceeded => 'Підключення успішне';

  @override
  String get aiTestFailed => 'Не вдалося підключитися';

  @override
  String get aiSupportsImages => 'Підтримує зображення';

  @override
  String get aiTextOnly => 'Лише текст, не може бути провайдером зображень';

  @override
  String get debugAiTitle => 'Налагодити ШІ провайдерів';

  @override
  String get debugAiDescription =>
      'Використовуйте цю сторінку для налагодження ШІ-провайдерів. Тут ви можете перевірити підключення до ШІ та переглянути результати. Якщо у вас увімкнено сервіси роботи із зображеннями, ви також можете надати зображення.';

  @override
  String get debugParserTitle => 'Синтаксичний аналізатор (парсер)';

  @override
  String get debugParserDescription =>
      'Mealie використовує умовні випадкові поля (CRF) для аналізу та обробки інгредієнтів. Модель, що використовується для інгредієнтів, базується на наборі даних, що містить понад 100 000 інгредієнтів, зібраних газетою New York Times. Зверніть увагу, що оскільки модель навчена лише англійською мовою, при використанні моделі іншими мовами результати можуть відрізнятися. Ця сторінка є майданчиком для тестування моделі.';

  @override
  String get debugIngredientText => 'Текст інгредієнта';

  @override
  String get debugTryExample => 'Спробувати приклад';

  @override
  String debugAverageConfidence(String value) {
    return 'Впевненість $value';
  }

  @override
  String get debugRunTest => 'Запустити перевірку';

  @override
  String get debugQuantity => 'Кількість';

  @override
  String get debugUnit => 'Одиниця виміру';

  @override
  String get debugFood => 'Продукт';

  @override
  String get debugNote => 'Коментар';

  @override
  String get debugGroup => 'Група';

  @override
  String get aiProviderNone => 'Нічого';

  @override
  String aiProviderDeleteConfirm(String name) {
    return 'Видалити провайдера «$name»?';
  }

  @override
  String get aiProvidersEmpty => 'ШІ-провайдерів ще немає.';

  @override
  String get aiAdvanced => 'Розширений';

  @override
  String get aiKeyLabel => 'Назва';

  @override
  String get aiValueLabel => 'Значення';

  @override
  String get debugTitle => 'Налагодження';

  @override
  String get debugParse => 'Проаналізувати';

  @override
  String get debugParseFailed => 'Не вдалося проаналізувати інгредієнт';

  @override
  String get debugChooseImage => 'Вибрати зображення';

  @override
  String get debugNoImage => 'Без зображення (необовʼязково)';

  @override
  String get updateTitle => 'Перевірка оновлень';

  @override
  String get updateInstalledVersion => 'Встановлена версія';

  @override
  String get updateLastCheck => 'Остання перевірка';

  @override
  String get updateCheckNow => 'Перевірити зараз';

  @override
  String get updateChecking => 'Пошук оновлень…';

  @override
  String get updateUpToDate => 'Mealie Recipes оновлено.';

  @override
  String updateAvailable(String version) {
    return 'Доступна версія $version';
  }

  @override
  String get updateAvailableDescription =>
      'Доступна нова версія Mealie Recipes. Нічого не встановиться, доки ви самі не запустите оновлення.';

  @override
  String get updateShow => 'Показати оновлення';

  @override
  String get updateLater => 'Пізніше';

  @override
  String updateDownloading(int percent) {
    return 'Завантаження … $percent %';
  }

  @override
  String updateReady(String version) {
    return 'Версія $version готова до встановлення';
  }

  @override
  String get updateInstalling =>
      'Встановлення — застосунок перезапуститься автоматично …';

  @override
  String get updateManual =>
      'Не вдалося встановити оновлення автоматично. Образ диска відкрито: перетягніть Mealie Recipes у «Програми».';

  @override
  String get updateFailed => 'Оновлення не вдалося';

  @override
  String get updateInstallNow => 'Завантажити й встановити';

  @override
  String get updateRestartNow => 'Встановити й перезапустити';

  @override
  String get updateAutoTitle => 'Перевіряти оновлення під час запуску';

  @override
  String get updateAutoDescription =>
      'Лише перевіряє й повідомляє — встановлення ви завжди запускаєте самі.';

  @override
  String get updateBetaTitle => 'Отримувати бета-версії';

  @override
  String get updateBetaDescription =>
      'Також пропонує попередні версії для тестування. Вони ще можуть містити помилки.';

  @override
  String get updateNoNotes => 'Немає приміток до випуску.';

  @override
  String get updateSourceHint =>
      'Оновлення надходять із релізів Mealie Recipes на GitHub і встановлюються, лише якщо підписані розробником (macOS).';

  @override
  String get errorNoConnection =>
      'Не вдається звʼязатися із сервером Mealie. Перевірте підключення до інтернету й адресу сервера.';

  @override
  String get errorTimeout =>
      'Сервер надто довго не відповідав. Спробуйте ще раз.';

  @override
  String get errorUnauthorized =>
      'Термін входу сплив або API-токен більше не дійсний. Увійдіть знову в налаштуваннях.';

  @override
  String get errorServer =>
      'Сервер Mealie повідомив про помилку. Спробуйте пізніше.';

  @override
  String get errorNotFound => 'Не знайдено на сервері — можливо, видалено.';

  @override
  String get errorCertificate => 'Сертифікат безпеки сервера не є довіреним.';

  @override
  String get errorGeneric => 'Щось пішло не так. Спробуйте ще раз.';

  @override
  String get offlineLabel => 'Офлайн';

  @override
  String offlineSince(String time) {
    return 'Офлайн · остання синхронізація $time';
  }

  @override
  String get mealplanEntryActions => 'Параметри страви';

  @override
  String get mealplanMoveAction => 'Перемістити';

  @override
  String get mealplanMoveTitle => 'Перемістити страву';

  @override
  String get mealplanMoveDate => 'Дата';

  @override
  String mealplanMovedTo(String date) {
    return 'Переміщено на $date';
  }

  @override
  String get mealplanShowWeek => 'Показати';

  @override
  String get mealplanMoveFailed => 'Не вдалося перемістити страву';

  @override
  String get recentlyViewedTitle => 'Нещодавно переглянуті';

  @override
  String get recentlyViewedEmpty =>
      'Тут зʼявляться рецепти, які ви відкриваєте.';

  @override
  String get recentlyViewedClear => 'Очистити історію';

  @override
  String get recentlyViewedClearMessage =>
      'Список нещодавно переглянутих рецептів на цьому пристрої буде очищено. Самі рецепти залишаться.';

  @override
  String get recentlyViewedClearConfirm => 'Очистити';

  @override
  String get duplicatesTitle => 'Пошук дублікатів';

  @override
  String get duplicatesScanning => 'Пошук рецептів-дублікатів…';

  @override
  String get duplicatesNone => 'Рецептів-дублікатів не знайдено.';

  @override
  String duplicatesFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Знайдено $count можливого дубліката.',
      many: 'Знайдено $count можливих дублікатів.',
      few: 'Знайдено $count можливі дублікати.',
      one: 'Знайдено $count можливий дублікат.',
    );
    return '$_temp0';
  }

  @override
  String get duplicatesIntro =>
      'Торкніться рецепта, який має залишитися, а потім обʼєднайте.';

  @override
  String get duplicatesReasonSource => 'Те саме джерело';

  @override
  String get duplicatesReasonName => 'Та сама назва';

  @override
  String duplicatesReasonSimilar(int percent) {
    return 'Схожий · $percent % однакових інгредієнтів';
  }

  @override
  String get duplicatesKeeps => 'Залишається';

  @override
  String get duplicatesWillBeDeleted => 'Буде видалено';

  @override
  String get duplicatesMerge => 'Обʼєднати';

  @override
  String get duplicatesNotDuplicate => 'Не дублікат';

  @override
  String get duplicatesMergeTitle => 'Обʼєднати рецепти?';

  @override
  String duplicatesMergeMessage(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Буде видалено $count іншого рецепта',
      many: 'Буде видалено $count інших рецептів',
      few: 'Буде видалено $count інші рецепти',
      one: 'Буде видалено $count інший рецепт',
    );
    return '«$name» залишається. $_temp0.\n\nКатегорії, мітки, інструменти, нотатки, заплановані страви вашої сімʼї та ваше улюблене переносяться. Коментарі, хронологія й вкладення видалених рецептів втрачаються.';
  }

  @override
  String get duplicatesMerged => 'Рецепти обʼєднано';

  @override
  String duplicatesIngredientCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count інгредієнта',
      many: '$count інгредієнтів',
      few: '$count інгредієнти',
      one: '$count інгредієнт',
    );
    return '$_temp0';
  }

  @override
  String duplicatesResetIgnored(int count) {
    return 'Знову показати приховані пари ($count)';
  }

  @override
  String get duplicatesRescan => 'Шукати знову';

  @override
  String get duplicatesOpenRecipe => 'Відкрити рецепт';

  @override
  String get duplicatesMergeNoEditHint =>
      'Ви не можете редагувати рецепт, що залишається (чужий заблокований рецепт або з іншої сімʼї). Тому його категорії, мітки, інструменти й нотатки лишаються як є; переносяться лише заплановані страви й ваше улюблене.';

  @override
  String get recipeOtherHouseholdHint =>
      'З іншої сімʼї – редагування там заблоковано';

  @override
  String foodsSavedAsNote(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count нового продукту збережено',
      many: '$count нових продуктів збережено',
      few: '$count нові продукти збережено',
      one: '$count новий продукт збережено',
    );
    return 'Збережено. $_temp0 як примітку до інгредієнта – для створення продуктів потрібне право «Користувач може керувати продуктами, мітками й категоріями» в Mealie.';
  }

  @override
  String get a11yRemove => 'Вилучити';

  @override
  String get a11yDecrease => 'Менше';

  @override
  String get a11yIncrease => 'Більше';

  @override
  String get a11yShowPassword => 'Показати пароль';

  @override
  String get a11yHidePassword => 'Приховати пароль';

  @override
  String get a11yClearSearch => 'Очистити пошук';

  @override
  String get notesQueuedOffline =>
      'Офлайн – нотатку буде надіслано, щойно сервер знову стане доступним.';

  @override
  String get timelineQueuedOffline =>
      'Офлайн – запис буде додано до хронології, щойно сервер знову стане доступним.';

  @override
  String get syncSectionName => 'Перейменовані';

  @override
  String get pendingRecipesDiscard => 'Відхилити';

  @override
  String get undo => 'Скасувати';

  @override
  String timerStoppedSnack(String name) {
    return 'Таймер «$name» зупинено';
  }

  @override
  String get cookFriendsEndConfirm =>
      'Завершити сесію для всіх? Усіх гостей буде відключено.';

  @override
  String get weekStartSyncHint =>
      'Збережено в Mealie – діє для всієї вашої сімʼї, також у веб-застосунку.';

  @override
  String get weekStartNoPermission =>
      'Задається в Mealie вашою сімʼєю. Змінити можуть лише учасники, яким дозволено керувати сімʼєю.';

  @override
  String get assetsUnsupported329 =>
      'Mealie підтримує PDF, зображення, відео (MP4, MOV, WebM), аудіо (MP3, M4A), Word/ODT/RTF, TXT, MD, CSV і JSON.';

  @override
  String get assetsRecordVideo => 'Записати відео';

  @override
  String get assetsChooseVideo => 'Вибрати відео';

  @override
  String get shoppingSearchHint => 'Пошук у цьому списку';

  @override
  String get shoppingSearchNoMatches =>
      'Немає позицій, що відповідають пошуку.';

  @override
  String get mealplanServingsTitle => 'Заплановані порції';

  @override
  String get mealplanServingsHint =>
      'Лише для цього запису плану харчування — сам рецепт не змінюється. Під час відкриття рецепта й додавання до списку покупок використовуються ці порції.';

  @override
  String get calendarFeedTitle => 'Підписатися на календар';

  @override
  String get calendarFeedSubtitle =>
      'Показувати план харчування в Google, Apple чи будь-якому іншому календарі';

  @override
  String get calendarFeedDescription =>
      'Підпишіться на план харчування вашої сімʼї в Google Календарі, Apple Календарі, Home Assistant чи будь-якому іншому застосунку з підтримкою iCal-посилань. Будь-хто з посиланням бачить ваш план харчування.';

  @override
  String get calendarFeedOff =>
      'Посилання на календар вимкнено для вашої сімʼї.';

  @override
  String get calendarFeedAskManager =>
      'Попросіть того, хто керує вашою сімʼєю, увімкнути його.';

  @override
  String get calendarFeedTurnOn => 'Увімкнути';

  @override
  String get calendarFeedTurnOff => 'Вимкнути';

  @override
  String get calendarFeedReset => 'Скинути посилання';

  @override
  String get calendarFeedResetHint =>
      'Після скидання чи вимкнення посилання наявні підписки перестануть оновлюватися.';

  @override
  String get calendarFeedIncludeNotes => 'Включати нотатки';

  @override
  String get calendarFeedTimesHint =>
      'Торкніться прийому їжі, щоб задати час. Прийоми їжі без часу показуються як події на весь день.';

  @override
  String get calendarFeedMealTypes => 'Тип їжі';

  @override
  String get calendarFeedSubscribe => 'Підписатися в календарі';

  @override
  String get calendarFeedNoApp =>
      'Не вдалося відкрити застосунок календаря. Скопіюйте посилання й додайте його в календар як підписку.';

  @override
  String get calendarFeedPublicHint =>
      'Посилання працює без входу — діліться ним лише з тими, кому можна бачити ваш план харчування.';

  @override
  String get recipeShareLinkMenu => 'Посилання й QR-код';

  @override
  String get recipeShareShowQr => 'Показати QR-код';

  @override
  String get recipeShareScanQr =>
      'Відскануйте камерою телефона, щоб відкрити цей рецепт';

  @override
  String get recipeShareQrShare => 'Поділитися зображенням';

  @override
  String get recipeShareQrFailed => 'Не вдалося створити зображення QR-коду';

  @override
  String get mealplanSettingsTitle => 'Налаштування меню';

  @override
  String get mealDiceRulesTitle => 'Правила кубика';

  @override
  String saveAsNewFood(String name) {
    return 'Зберегти «$name» як новий продукт';
  }

  @override
  String get shoppingMoreOptions => 'Більше параметрів';

  @override
  String get shoppingFewerOptions => 'Менше параметрів';

  @override
  String nameAlreadyExists(String name) {
    return 'Уже існує: $name';
  }

  @override
  String aliasBelongsTo(String alias, String name) {
    return '«$alias» уже належить «$name» — краще обʼєднати їх.';
  }

  @override
  String get recipeMatchTitle => 'Recipe Match';

  @override
  String get recipeMatchShuffle => 'Перемішати';

  @override
  String recipeMatchCardsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count рецепта в колоді',
      many: '$count рецептів у колоді',
      few: '$count рецепти в колоді',
      one: '$count рецепт у колоді',
    );
    return '$_temp0';
  }

  @override
  String get recipeMatchNext => 'Далі';

  @override
  String get recipeMatchKeep => 'На тацю';

  @override
  String get recipeMatchKept => 'Покладено на тацю';

  @override
  String get recipeMatchAnyTime => 'Будь-яка тривалість';

  @override
  String recipeMatchMaxTime(int minutes) {
    return '≤ $minutes хв';
  }

  @override
  String get recipeMatchEmpty => 'Немає відповідних рецептів';

  @override
  String get recipeMatchEmptyHint => 'Змініть фільтри або очистіть тацю.';

  @override
  String get recipeMatchResetFilters => 'Скинути фільтри';

  @override
  String get recipeMatchFlipHint => 'Торкніться: інгредієнти · інструкції';

  @override
  String get recipeMatchFlipBack => 'Перевернути назад';

  @override
  String get recipeMatchOpenRecipe => 'Повний рецепт';

  @override
  String get recipeMatchOnHand => 'є в наявності';

  @override
  String get recipeMatchTray => 'Таця';

  @override
  String get recipeMatchTrayEmpty => 'Ще порожня – перетягніть картку вниз';

  @override
  String recipeMatchTrayCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count рецепта',
      many: '$count рецептів',
      few: '$count рецепти',
      one: '$count рецепт',
    );
    return '$_temp0';
  }

  @override
  String get recipeMatchClear => 'Очистити';

  @override
  String get recipeMatchTrayHint =>
      'Лишається, доки ви її не очистите, – навіть якщо закрити колоду.';

  @override
  String get recipeMatchRemove => 'Прибрати з таці';

  @override
  String get recipeMatchToMealplan => 'Додати до плану харчування';

  @override
  String get recipeMatchToShopping => 'Інгредієнти до списку покупок';

  @override
  String get recipeMatchSelectIngredients => 'Вибрати інгредієнти';

  @override
  String get recipeMatchNoList => 'Спершу виберіть список покупок.';

  @override
  String get recipeMatchList => 'Список';

  @override
  String get recipeMatchOnHandHint =>
      'Інгредієнти в наявності вже знято з вибору.';

  @override
  String recipeMatchAddCount(int selected, int total) {
    return 'Додати $selected з $total інгредієнтів';
  }

  @override
  String get recipeMatchNoDay => 'Ще без дня – лишається на таці';

  @override
  String recipeMatchAddMeals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Додати $count страви',
      many: 'Додати $count страв',
      few: 'Додати $count страви',
      one: 'Додати $count страву',
    );
    return '$_temp0';
  }

  @override
  String recipeMatchMealsAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Додано $count страви',
      many: 'Додано $count страв',
      few: 'Додано $count страви',
      one: 'Додано $count страву',
    );
    return '$_temp0';
  }

  @override
  String get recipeMatchSwipeUp => 'Проведіть угору, щоб відкрити тацю';

  @override
  String get weekPlannerTitle => 'Спланувати тиждень';

  @override
  String get weekPlannerStepDays => 'Дні';

  @override
  String get weekPlannerStepPrefs => 'Налаштування';

  @override
  String get weekPlannerStepPreview => 'Перегляд';

  @override
  String get weekPlannerDaysTitle => 'Які прийоми їжі заповнити?';

  @override
  String get weekPlannerDaysHint =>
      'Торкайтеся клітинок. Уже заплановане лишиться як є.';

  @override
  String get weekPlannerPresetWeekdays => 'Будні';

  @override
  String get weekPlannerPlanned => 'заплановано';

  @override
  String get weekPlannerMoreMeals => 'Показати більше прийомів їжі';

  @override
  String get weekPlannerFewerMeals => 'Менше прийомів їжі';

  @override
  String weekPlannerMealCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count прийому їжі',
      many: '$count прийомів їжі',
      few: '$count прийоми їжі',
      one: '$count прийом їжі',
    );
    return '$_temp0';
  }

  @override
  String get weekPlannerPrefsTitle => 'На що звернути увагу?';

  @override
  String get weekPlannerPrefsHint =>
      'Усе необовʼязково – без вибору застосунок підбере різноманітну суміш ваших рецептів.';

  @override
  String get weekPlannerQuick => 'Швидко в будні';

  @override
  String weekPlannerQuickSub(int minutes) {
    return 'Пн–Пт не більше $minutes хв';
  }

  @override
  String get weekPlannerStale => 'Спершу давно не готовані';

  @override
  String get weekPlannerStaleSub =>
      'за «Востаннє приготовано» та планом харчування';

  @override
  String get weekPlannerFavorites => 'Частіше планувати улюблене';

  @override
  String get weekPlannerFavoritesSub =>
      'рецепти із сердечком і високим рейтингом';

  @override
  String get weekPlannerVariety => 'Різноманітність';

  @override
  String get weekPlannerVarietySub => 'жодної категорії двічі поспіль';

  @override
  String get weekPlannerOnlyFrom => 'Лише з';

  @override
  String get weekPlannerDiceRules => 'Використовувати правила кубика';

  @override
  String get weekPlannerDiceRulesSub =>
      'ваш вибір для кожного прийому їжі з налаштувань плану харчування';

  @override
  String weekPlannerMatching(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count відповідного рецепта',
      many: '$count відповідних рецептів',
      few: '$count відповідні рецепти',
      one: '$count відповідний рецепт',
    );
    return '$_temp0';
  }

  @override
  String weekPlannerForMeals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'на $count прийому їжі',
      many: 'на $count прийомів їжі',
      few: 'на $count прийоми їжі',
      one: 'на $count прийом їжі',
    );
    return '$_temp0';
  }

  @override
  String get weekPlannerSuggest => 'Запропонувати';

  @override
  String get weekPlannerPreviewHint =>
      'Кубик міняє, замок тримає. Утримуйте страву й перетягніть на інший день, щоб поміняти їх місцями.';

  @override
  String get weekPlannerRerollAll => 'Перекинути все';

  @override
  String get weekPlannerReroll => 'Перекинути';

  @override
  String get weekPlannerLock => 'Закріпити';

  @override
  String get weekPlannerUnlock => 'Відкріпити';

  @override
  String get weekPlannerReasonNever => 'ще не готували';

  @override
  String get weekPlannerReasonStale => 'давно не готували';

  @override
  String get weekPlannerReasonFavorite => 'Улюблене';

  @override
  String get weekPlannerNoMatch => 'Немає відповідного рецепта';

  @override
  String get weekPlannerThenShopping =>
      'Потім вибрати інгредієнти для списку покупок';

  @override
  String get weekPlannerMostlyEmpty => 'Тиждень майже порожній';

  @override
  String weekPlannerMostlyEmptySub(int free, int total) {
    return 'Вільно $free з $total днів – заповніть їх за три кроки.';
  }

  @override
  String get previousWeek => 'Попередній тиждень';

  @override
  String get nextWeek => 'Наступний тиждень';

  @override
  String get weekPlannerAllDays => 'Усі дні';

  @override
  String get weekPlannerWeekend => 'Вихідні';

  @override
  String get weekPlannerDinners => 'Вечері';

  @override
  String get weekPlannerLunches => 'Обіди';

  @override
  String get weekPlannerAllMeals => 'Усі прийоми їжі';

  @override
  String get mealplanDayEmpty => 'Нічого не заплановано';

  @override
  String get mealplanDropHere => 'Перетягніть сюди';

  @override
  String mealplanDayKcal(String kcal) {
    return '$kcal ккал на порцію';
  }

  @override
  String mealplanDayKcalPartial(String kcal) {
    return 'щонайменше $kcal ккал на порцію';
  }

  @override
  String get globalSearchHint => 'Пошук рецептів, позицій, функцій …';

  @override
  String get globalSearchIntro =>
      'Шукайте рецепти, позиції списку покупок, продукти й кулінарні книги – а також функції та налаштування застосунку, напр. «список».';

  @override
  String get globalSearchFunctions => 'Функції';

  @override
  String globalSearchNoResults(String query) {
    return 'Немає результатів для «$query»';
  }

  @override
  String get searchClear => 'Очистити пошук';

  @override
  String get recipeMatchPlanWeek => 'Спланувати тиждень із цими рецептами';

  @override
  String get weekPlannerReasonTray => 'з таці';

  @override
  String get emptyBrowseRecipes => 'Переглянути рецепти';

  @override
  String get mealplanWeekShopping => 'Інгредієнти на цей тиждень';

  @override
  String get globalSearchActions => 'Дії';

  @override
  String globalSearchAddToList(String text) {
    return 'Додати «$text» до списку покупок';
  }

  @override
  String globalSearchAdded(String text) {
    return '«$text» додано';
  }

  @override
  String get globalSearchImportUrl => 'Імпортувати рецепт із цієї адреси';

  @override
  String get homeContinueCooking => 'Продовжити готування';

  @override
  String homeCookingStep(int step, int total) {
    return 'Крок $step з $total';
  }

  @override
  String get homeCookingPrep => 'Підготовка';

  @override
  String get homeCookingAlmostDone => 'Майже готово';

  @override
  String get homeCookingContinue => 'продовжити';

  @override
  String get paneSelectRecipe => 'Виберіть рецепт ліворуч.';

  @override
  String get mealplanDragRecipeHint =>
      'Перетягніть рецепт на день, щоб запланувати його.';

  @override
  String get desktopDropUnsupported => 'Ці файли не можна додати як вкладення.';

  @override
  String desktopDropUploaded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Додано $count вкладення',
      many: 'Додано $count вкладень',
      few: 'Додано $count вкладення',
      one: 'Додано $count вкладення',
    );
    return '$_temp0';
  }

  @override
  String get desktopDropAsAttachment => 'Відпустіть, щоб додати як вкладення';

  @override
  String get printAction => 'Друк';

  @override
  String get mealplanPrintWeek => 'Друк тижня';

  @override
  String get mealplanEntryCooked => 'Приготовано';

  @override
  String get recipeSearchClear => 'Очистити пошук';

  @override
  String get organizerShowRecipes => 'Показати рецепти';

  @override
  String globalSearchShowAllRecipes(int count) {
    return 'Показати всі рецепти ($count)';
  }

  @override
  String get unnamedEntry => '(без назви)';

  @override
  String get mealplanWholeWeek => 'На весь тиждень';

  @override
  String get mealplanWholeWeekDropHint =>
      'Перетягніть сюди страву, щоб запланувати її на весь тиждень.';

  @override
  String get mealplanMovedToWholeWeek => 'Заплановано на весь тиждень';

  @override
  String get mealplanCookToday => 'Готую сьогодні';

  @override
  String get mealplanPlanWholeWeek => 'Запланувати на весь тиждень';

  @override
  String mealplanPlanWholeWeekRange(String from, String to) {
    return '$from – $to';
  }

  @override
  String get calendarFeedDuration => 'Тривалість (хвилини)';

  @override
  String get calendarFeedEventDetails => 'Деталі події';

  @override
  String calendarFeedEventDetailsHint(String fields) {
    return 'Налаштуйте, як страви відображаються в календарі. Поля підстановки: $fields';
  }

  @override
  String get calendarFeedEventTitle => 'Назва події';

  @override
  String get calendarFeedEventDescription => 'Опис події';

  @override
  String get calendarFeedEventDetailsWarning =>
      'Зміна цих полів змінює посилання на календар — якщо ви вже підписані, підпишіться знову за новим посиланням.';

  @override
  String get stepDurationMinutes => 'Тривалість (хвилини)';

  @override
  String stepDurationSaved(String duration) {
    return 'Збережена тривалість: $duration. Редагування замінить її цілими хвилинами.';
  }

  @override
  String get sortTotalTimeShort => 'Найменший загальний час';

  @override
  String get sortTotalTimeLong => 'Найбільший загальний час';

  @override
  String recipeCreatedBy(String name) {
    return 'Автор: $name';
  }

  @override
  String get timelineReplacePhoto => 'Замінити фото';

  @override
  String get pasteRecipeTitle => 'Вставити рецепт';

  @override
  String get pasteRecipeDescription =>
      'Вставте рецепт у форматі JSON (schema.org) або HTML-код вебсторінки.';

  @override
  String get pasteRecipeDescription330 =>
      'Вставте рецепт, експортований із Mealie (JSON), — його буде імпортовано з повною структурою: продукти, одиниці й звʼязки кроків. Також підходять JSON (schema.org) і HTML-код вебсторінки.';

  @override
  String get pasteRecipeHint => 'Вставте сюди JSON або HTML';

  @override
  String get pasteRecipeButton => 'Вставити рецепт';

  @override
  String get pasteRecipeImport => 'Імпорт';

  @override
  String get aiPromptsTitle => 'Промпти ШІ';

  @override
  String get aiPromptsTeaser =>
      'Налаштуйте інструкції, які Mealie дає ШІ-провайдеру, — для всіх завдань чи для кожного.';

  @override
  String get aiPromptsDescription =>
      'Налаштуйте інструкції, які Mealie дає ШІ-провайдеру для кожного завдання. Промпти Mealie написано англійською, але це не змінює мову ваших рецептів: вони зберігають мову джерела, якщо ви не вирішите їх перекласти. Власні інструкції можна писати будь-якою мовою.';

  @override
  String get aiPromptsGlobal => 'Інструкції для всіх промптів';

  @override
  String get aiPromptsGlobalDescription =>
      'Додаються до кожного промпту, що створює дані рецепта, — наприклад, побудова рецептів, розбір інгредієнтів і переклад. Системні промпти не зачіпаються.';

  @override
  String get aiPromptsGlobalPlaceholder =>
      'напр. Завжди використовуй метричні одиниці.';

  @override
  String get aiPromptsList => 'Промпти';

  @override
  String get aiPromptSystem => 'Система';

  @override
  String get aiPromptSystemDescription =>
      'Це системний промпт. Він якомога точніше переписує вихідний матеріал, перш ніж той стане рецептом, тому інструкції для всіх промптів до нього не додаються. Змінювати його зазвичай не потрібно, і це може зробити імпорт менш надійним.';

  @override
  String get aiPromptAppended => 'Доповнено';

  @override
  String get aiPromptOverridden => 'Замінено';

  @override
  String get aiPromptModeDefault => 'За замовчуванням';

  @override
  String get aiPromptModeAppend => 'Доповнити';

  @override
  String get aiPromptModeOverride => 'Замінити';

  @override
  String get aiPromptAppendDescription =>
      'Ці інструкції додаються до промпту Mealie й мають пріоритет там, де вони суперечать одне одному.';

  @override
  String get aiPromptOverrideDescription =>
      'Ваш промпт повністю замінює промпт Mealie, тому майбутні оновлення промпту Mealie до нього не застосовуватимуться. Потрібні завданню дані, як-от список одиниць, однаково додаються після вашого промпту.';

  @override
  String get aiPromptDefaultChanged =>
      'Промпт Mealie змінився відтоді, як ви його замінили. Порівняйте його зі своїм або поверніться до стандартного, щоб використати нову версію.';

  @override
  String get aiPromptViewDefault => 'Показати стандартний промпт';

  @override
  String get aiPromptHideDefault => 'Приховати стандартний промпт';

  @override
  String get aiPromptSaved => 'Промпт збережено';

  @override
  String get aiPromptSaveFailed => 'Не вдалося зберегти промпт';

  @override
  String get aiPromptTitleBuildRecipe => 'Побудова рецепта';

  @override
  String get aiPromptTitleParseIngredients => 'Розбір інгредієнтів';

  @override
  String get aiPromptTitleRecipeVideo => 'Рецепт із відео';

  @override
  String get aiPromptTitleOrganizers => 'Призначення організаторів';

  @override
  String get aiPromptTitleTranslate => 'Переклад рецепта';

  @override
  String get aiPromptTitleCompileSource => 'Читання вихідного матеріалу';

  @override
  String get aiPromptTitleTranscribe => 'Розшифрування аудіо';

  @override
  String get aiPromptDescBuildRecipe =>
      'Перетворює матеріал, прочитаний із вебсторінки, фото чи тексту, на структурований рецепт.';

  @override
  String get aiPromptDescParseIngredients =>
      'Використовується ШІ-аналізатором інгредієнтів, щоб розділити кожен інгредієнт на кількість, одиницю, продукт і примітку.';

  @override
  String get aiPromptDescRecipeVideo =>
      'Перетворює розшифровку й підпис відео на рецепт.';

  @override
  String get aiPromptDescOrganizers =>
      'Добирає мітки, категорії й інструменти для імпортованого рецепта.';

  @override
  String get aiPromptDescTranslate =>
      'Перекладає імпортований рецепт вибраною мовою.';

  @override
  String get aiPromptDescCompileSource =>
      'Читає вебсторінки, фото й текст у простий текстовий запис рецепта.';

  @override
  String get aiPromptDescTranscribe =>
      'Розшифровує аудіо, коли ваш аудіопровайдер не може зробити це напряму.';

  @override
  String get mealplanNoteHint => 'Нотатка (необовʼязково)';

  @override
  String get mealplanEditTitle => 'Редагувати запис';

  @override
  String get mealplanEntryTitleLabel => 'Назва';

  @override
  String get mealplanEntryNoteLabel => 'Нотатка';

  @override
  String mealplanCreateRecipe(String name) {
    return 'Новий рецепт «$name»';
  }

  @override
  String get mealplanCreateRecipeSubtitle =>
      'Створює порожній рецепт, планує його й відкриває редактор';

  @override
  String get importOptionsTitle => 'Параметри імпорту';

  @override
  String get importOptionsHint =>
      'Скільки роботи ШІ Mealie виконує на вашому сервері під час імпорту. Кожен додатковий крок — окремий запит до ШІ: що їх менше, то швидше.';

  @override
  String get importTranslateTitle => 'Перекласти рецепт';

  @override
  String get importOrganizersTitle => 'Категорії й мітки';

  @override
  String get importOrganizersCreate => 'Додавати нові';

  @override
  String get importOrganizersExisting => 'Лише наявні';

  @override
  String get importOrganizersNone => 'Нічого';

  @override
  String get importOrganizersCreateHint =>
      'ШІ призначає мітки, категорії й інструменти та створює відсутні.';

  @override
  String get importOrganizersExistingHint =>
      'ШІ використовує лише вже наявні мітки, категорії й інструменти.';

  @override
  String get importOrganizersNoneHint =>
      'Рецепт імпортується без міток, категорій та інструментів. Mealie однаково виконує цей крок, тож імпорт не пришвидшиться.';

  @override
  String get importStarting => 'Надсилання на сервер…';

  @override
  String get importRunning => 'Імпорт рецепта…';

  @override
  String get aiImagesRunning => 'ШІ читає сторінки…';

  @override
  String get importStreamPhotosTitle =>
      'Імпорт фото з поступом у реальному часі';

  @override
  String get importStreamPhotosHint =>
      'Показує кожен крок і тримає зʼєднання відкритим під час довгого імпорту. Вимкніть, щоб завантажувати одним запитом, як раніше, — напр. якщо ваш проксі блокує потокову передачу.';

  @override
  String get weekPlannerDiceRulesMealieSub =>
      'правила Mealie вашої сімʼї (налаштування плану харчування)';

  @override
  String get syncStarted =>
      'Перезавантаження рецептів, зображень і списків із сервера…';

  @override
  String get syncDone => 'Усе актуально';

  @override
  String get recipeReloaded => 'Рецепт перезавантажено';

  @override
  String get logoutTitle => 'Вийти / змінити користувача';

  @override
  String get logoutConfirm =>
      'Рецепти, списки й ще не синхронізовані зміни буде видалено з цього пристрою. Налаштування застосунку й адреса сервера лишаться, тож потрібно буде лише знову увійти.';

  @override
  String get reloadRecipe => 'Перезавантажити із сервера';

  @override
  String get wifiServerTitle => 'Інша адреса у Wi-Fi';

  @override
  String get wifiServerHint =>
      'Для того самого сервера під другою адресою, напр. локальна IP удома й ZeroTier, Tailscale чи домен поза домом. У мережі Wi-Fi нижче застосунок автоматично використовує цю адресу, деінде — URL сервера вище.';

  @override
  String get wifiSsidLabel => 'Назва Wi-Fi';

  @override
  String get wifiServerUrl => 'Адреса в цій мережі Wi-Fi';

  @override
  String get wifiUseCurrent => 'Використати поточний Wi-Fi';

  @override
  String get wifiNameUnavailable =>
      'Не вдалося прочитати назву Wi-Fi. Підключіться до Wi-Fi і дозвольте доступ до геолокації – Android та iOS показують назву Wi-Fi лише з ним.';

  @override
  String wifiServerActive(String ssid) {
    return 'Активно: адреса у Wi-Fi «$ssid»';
  }

  @override
  String wifiServerStandardActive(String ssid) {
    return 'Активно: URL сервера (не в «$ssid»)';
  }

  @override
  String get wifiServerRemove => 'Вилучити';

  @override
  String get switchUserTitle => 'Змінити користувача';

  @override
  String switchUserBody(String name) {
    return '$name лишається збереженим на цьому пристрої – з усіма рецептами, списками й ще не синхронізованими змінами. Повернутися можна через фото профілю або сторінку входу.';
  }

  @override
  String get allowBiometricTitle => 'Повертатися розблокуванням пристрою';

  @override
  String get allowBiometricHint =>
      'Face ID, відбиток пальця чи PIN пристрою замість пароля. Будь-хто, хто може розблокувати цей пристрій, зможе відкрити цей обліковий запис.';

  @override
  String get allow => 'Дозволити';

  @override
  String unlockAccountReason(String name) {
    return 'Перейти до $name';
  }

  @override
  String signInAs(String name) {
    return 'Увійти як $name';
  }

  @override
  String wrongAccountError(String name) {
    return 'Це обліковий запис «$name». Увійдіть у збережений обліковий запис.';
  }

  @override
  String get accountSaveOffline =>
      'Зараз не вдається зберегти обліковий запис – сервер недоступний.';

  @override
  String get signOutRemoveTitle => 'Вийти й вилучити';

  @override
  String get signOutRemoveConfirm =>
      'Цей обліковий запис і всі його дані на цьому пристрої (рецепти, списки, несинхронізовані зміни) буде вилучено. Налаштування застосунку лишаться.';

  @override
  String get removeSavedAccount => 'Вилучити з цього пристрою';

  @override
  String removeSavedAccountConfirm(String name) {
    return 'Вилучити «$name» і всі збережені дані з цього пристрою? Несинхронізовані зміни буде втрачено.';
  }

  @override
  String get savedAccountsTitle => 'Збережені облікові записи';

  @override
  String get addAccount => 'Додати інший обліковий запис';

  @override
  String get biometricOff => 'Не використовувати розблокування пристрою';

  @override
  String get orNewAccount => 'Або увійдіть в інший обліковий запис:';

  @override
  String get importVideoTitle => 'Посилання на відео';

  @override
  String get importVideoFast => 'Швидко';

  @override
  String get importVideoThorough => 'Ретельно (ШІ)';

  @override
  String get importVideoFastHint =>
      'Mealie розшифровує відео й створює рецепт одним запитом до ШІ – зазвичай набагато швидше. Без перекладу й без категорій/міток. ШІ однаково можна ввімкнути для окремого імпорту.';

  @override
  String get importVideoThoroughHint =>
      'Для посилань на відео перемикач ШІ вмикається автоматично: кілька кроків ШІ, з перекладом і категоріями/мітками, як задано вище. Триває довше.';

  @override
  String get importPresetFast => 'Швидко';

  @override
  String get importPresetThorough => 'Ретельно';

  @override
  String get importPresetCustom => 'Власне';

  @override
  String get importPresetFastTitle =>
      'Якомога менше кроків ШІ – найкоротше очікування';

  @override
  String get importPresetFastVideo =>
      'Посилання на відео: Mealie розшифровує відео й створює рецепт одним запитом до ШІ (перемикач ШІ лишається вимкненим).';

  @override
  String get importPresetFastTranslate =>
      'Без перекладу – рецепт лишається мовою оригіналу.';

  @override
  String get importPresetFastOrganizers =>
      'Призначаються лише наявні категорії й мітки, нові не створюються.';

  @override
  String get importPresetThoroughTitle =>
      'Повний ШІ-імпорт Mealie – довше, зате з максимальним результатом';

  @override
  String get importPresetThoroughVideo =>
      'Посилання на відео автоматично імпортуються з ШІ – у кілька кроків (збір джерела, побудова рецепта, …).';

  @override
  String get importPresetThoroughTranslate =>
      'Рецепт перекладається мовою імпорту нижче, якщо написаний іншою мовою.';

  @override
  String get importPresetThoroughOrganizers =>
      'Призначаються відповідні категорії й мітки; відсутні створюються.';

  @override
  String get importPresetCustomTitle => 'Налаштуйте кожен параметр самі';

  @override
  String get importPresetCustomBody =>
      'Почніть із того, що робив попередній вибір, і змініть лише потрібне – напр. швидкий імпорт відео, але з перекладом.';

  @override
  String get sidebarPinHint =>
      'Порада: утримуйте плитку й перетягніть її на бічну панель, щоб закріпити.';

  @override
  String get sidebarDropHere => 'Перетягніть сюди';

  @override
  String sidebarShortcutTitle(String name) {
    return 'Сполучення клавіш для «$name»';
  }

  @override
  String sidebarShortcutPrompt(String modifier) {
    return 'Тепер натисніть потрібне сполучення клавіш, включно з $modifier.';
  }

  @override
  String get sidebarShortcutTaken => 'Це сполучення вже використовується.';

  @override
  String get sidebarShortcutNone => 'Без сполучення клавіш';

  @override
  String get sidebarShortcutChange => 'Змінити сполучення клавіш';

  @override
  String get sidebarUnpin => 'Прибрати з бічної панелі';

  @override
  String sidebarFull(int count) {
    return 'Бічну панель заповнено – щонайбільше $count власних пунктів.';
  }

  @override
  String get tabletSidebar => 'Бічна панель в альбомній орієнтації';

  @override
  String get tabletSidebarSubtitle =>
      'Показує навігацію ліворуч, а не внизу, коли планшет тримають горизонтально';

  @override
  String get filterDateCreated => 'Дата Створення';

  @override
  String get filterDateUpdated => 'Дата Оновлення';

  @override
  String get errorUploadTooLarge =>
      'Файл завеликий для цього сервера Mealie. Ліміт завантаження сервера можна збільшити через MAX_UPLOAD_SIZE_MB.';

  @override
  String get recipeDownloadPdfMealie => 'Завантажити PDF (макет Mealie)';

  @override
  String get mealplanNoteMore => 'Показати більше…';

  @override
  String get mealplanNoteLess => 'Показати менше';

  @override
  String get ingredientCommonlySubstitutedWith => 'Зазвичай замінюють на';

  @override
  String requiresMealieVersion(String version) {
    return 'Потрібен Mealie $version або новіший.';
  }

  @override
  String get apiTokensTitle => 'Ключі API';

  @override
  String get apiTokensDescription =>
      'Керуйте своїми ключами API для доступу із зовнішніх програм.';

  @override
  String get apiTokenNameLabel => 'Назва ключа';

  @override
  String get apiTokenGenerate => 'Згенерувати';

  @override
  String get apiTokensActive => 'АКТИВНІ КЛЮЧІ';

  @override
  String get apiTokenCopyWarning =>
      'Скопіюйте цей ключ для використання з зовнішнім додатком. Цей ключ не буде доступним для перегляду знову.';

  @override
  String get apiTokenThisApp => 'Використовується цим застосунком';

  @override
  String get apiTokenThisAppHint =>
      'Цей токен підтримує вхід застосунку, і його не можна видалити тут.';

  @override
  String apiTokenDeleteConfirm(String name) {
    return 'Видалити токен «$name»? Застосунки, що його використовують, одразу втратять доступ.';
  }

  @override
  String get apiTokensEmpty => 'Токенів ще немає.';

  @override
  String apiTokenCreatedOn(String date) {
    return 'Створено $date';
  }

  @override
  String get apiTokenCopied => 'Токен скопійовано';

  @override
  String get qfOpHasNoValue => 'не має значення';

  @override
  String get qfOpHasValue => 'має значення';

  @override
  String get ratingHouseholdAverage => 'серед. по сімʼї';

  @override
  String get stepLinkedNotes => 'Повʼязані нотатки';

  @override
  String get noteFallbackTitle => 'Нотатка';

  @override
  String get aiPromptTitleEnrichInstructions => 'Додати деталі кроків';

  @override
  String get aiPromptDescEnrichInstructions =>
      'Повʼязує кожен крок імпортованого рецепта з інгредієнтами й нотатками, які він використовує, і визначає його тривалість і заголовок.';

  @override
  String get loginAccountLocked =>
      'Акаунт заблоковано. Повторіть спробу пізніше';

  @override
  String get loginPasswordDisabled =>
      'На цьому сервері вхід за паролем вимкнено. Використайте натомість API-токен.';

  @override
  String get unitSystemTitle => 'Одиниці виміру';

  @override
  String get unitSystemAsWritten => 'Як записано';

  @override
  String get unitSystemMetric => 'Метрична система';

  @override
  String get unitSystemMetricHint => 'Метрична (г, мл)';

  @override
  String get unitSystemImperial => 'Імперьска система';

  @override
  String get unitSystemImperialHint => 'Імперська (чашки, унції)';

  @override
  String get unitSystemHint =>
      'Лише відображення – сам рецепт не змінюється. Як у веб-застосунку Mealie, вибір діє для всіх рецептів на цьому пристрої.';

  @override
  String get unitSystemUnavailable =>
      'Жодну одиницю цього рецепта не можна перерахувати. Для цього одиниця в Mealie потребує стандартизації (Продукти й одиниці → одиниця → Стандартизація).';
}
