// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get endCookingMode => 'Завершить режим готовки';

  @override
  String get endCookingModeConfirm =>
      'Вы действительно хотите завершить режим готовки?';

  @override
  String endCookingModeConfirmAll(int count) {
    return 'Будут завершены все рецепты в режиме готовки ($count). Продолжить?';
  }

  @override
  String get addTimer => 'Добавить таймер';

  @override
  String get recipeFinished => 'Ваше блюдо готово.';

  @override
  String get bonAppetit => 'Приятного аппетита!';

  @override
  String get prepareIngredients => 'Подготовьте следующие ингредиенты';

  @override
  String prepareIngredientsFor(String servings) {
    return 'Подготовьте следующие ингредиенты на $servings порций';
  }

  @override
  String get next => 'Следующее';

  @override
  String get navHome => 'Домашняя';

  @override
  String get homeCookToday => 'Готовим сегодня';

  @override
  String get homeSuggestion => 'Предложение';

  @override
  String get homeQuickAccess => 'Быстрый доступ';

  @override
  String get homePlanned => 'Запланировано';

  @override
  String get favorite => 'Избранное';

  @override
  String get navSettings => 'Настройки';

  @override
  String homeWelcomeName(Object name) {
    return 'Добро пожаловать, $name,';
  }

  @override
  String get homeWelcomeApp => 'в Mealie Recipes 👋';

  @override
  String get theme => 'Оформление';

  @override
  String get themeSystem => 'Система';

  @override
  String get themeLight => 'Светлая';

  @override
  String get themeDark => 'Темная';

  @override
  String get recipes => 'Рецепты';

  @override
  String get shoppingList => '🛒 Список покупок';

  @override
  String get mealplan => 'План питания';

  @override
  String get settings => '⚙️ Настройки';

  @override
  String get searchRecipe => 'Поиск рецепта...';

  @override
  String get loadingRecipe => 'Загрузка рецепта...';

  @override
  String get errorLoadingRecipe => 'Не удалось загрузить рецепт.';

  @override
  String get noRecipesForCategory => 'Нет рецептов для этого фильтра.';

  @override
  String get resetFilter => 'Сбросить фильтр';

  @override
  String get allCategories => 'Все категории';

  @override
  String get all => 'Все';

  @override
  String get sortRecipes => 'Сортировка рецептов';

  @override
  String get refreshRecipes => 'Обновить';

  @override
  String get sortNameAZ => 'Название А–Я';

  @override
  String get sortNameZA => 'Название Я–А';

  @override
  String get sortDateNewest => 'Сначала новые';

  @override
  String get sortDateOldest => 'Сначала старые';

  @override
  String get sortPrepTimeShort => 'Быстрее всего готовить';

  @override
  String get sortPrepTimeLong => 'Дольше всего готовить';

  @override
  String get sortRatingHighest => 'Высшая оценка';

  @override
  String get sortRatingLowest => 'Низшая оценка';

  @override
  String get details => 'Подробная информация';

  @override
  String get ingredients => 'Ингредиенты';

  @override
  String get instructions => 'Инструкции';

  @override
  String get tags => 'Теги';

  @override
  String get notes => 'Заметки';

  @override
  String get addNote => 'Добавить заметку';

  @override
  String get editNote => 'Изменить заметку';

  @override
  String get noteTitleHint => 'Заголовок (необязательно)';

  @override
  String get noteTextHint => 'Текст заметки';

  @override
  String get deleteNoteTitle => 'Удалить заметку?';

  @override
  String get deleteNoteMessage => 'Эта заметка будет удалена безвозвратно.';

  @override
  String get servings => 'Порций';

  @override
  String get planMeal => 'Запланировать блюдо';

  @override
  String get addAllIngredients => 'Добавить все ингредиенты';

  @override
  String get addSelectedIngredients => 'Добавить выбранные ингредиенты';

  @override
  String get addIngredientsMessage => 'Ингредиенты добавлены в список покупок.';

  @override
  String addIngredientsFailedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Не удалось добавить ингредиенты: $count.',
      one: 'Не удалось добавить 1 ингредиент.',
    );
    return '$_temp0';
  }

  @override
  String get cookbooks => 'Книги рецептов';

  @override
  String get cookbooksEmpty =>
      'Книг рецептов пока нет. Нажмите «+» вверху справа, чтобы создать.';

  @override
  String get cookbookNoMatches =>
      'Нет рецептов, соответствующих этому фильтру.';

  @override
  String get cookbookCreateTitle => 'Создать книгу рецептов';

  @override
  String get cookbookEditTitle => 'Изменить книгу рецептов';

  @override
  String get cookbookNameLabel => 'Название книги рецептов';

  @override
  String get cookbookFilterSectionTitle => 'Добавлять рецепты автоматически';

  @override
  String get cookbookFieldTools => 'Инструменты';

  @override
  String get cookbookFieldUsers => 'Пользователи';

  @override
  String get cookbookOpIsOneOf => 'один из';

  @override
  String get cookbookOpIsNotOneOf => 'не один из';

  @override
  String get cookbookOpContainsAll => 'содержит все';

  @override
  String get cookbookSelectValues => 'Выбрать значения';

  @override
  String get cookbookFilterOptionsUnavailable => 'Нет доступных вариантов';

  @override
  String get cookbookAddFilterField => 'Добавить поле';

  @override
  String get cookbookPublicLabel => 'Публичная книга рецептов';

  @override
  String get cookbookPublicSubtitle => 'Видна другим домохозяйствам на сервере';

  @override
  String get cookbookRawModeEnter => 'Редактировать как текст';

  @override
  String get cookbookRawModeExit => 'Назад к конструктору';

  @override
  String get cookbookRawModeHint =>
      'Экспертный режим приложения: фильтр редактируется прямо как текст. Полезно, если существующий фильтр нельзя разложить на простые строки.';

  @override
  String get cookbookRawModeUnparseable =>
      'Этот текст не соответствует простому построчному формату — он остаётся текстом.';

  @override
  String get saveFailed => 'Не удалось сохранить';

  @override
  String get search => 'Поиск';

  @override
  String get apply => 'Применить';

  @override
  String get setupCachingTitle => 'Загрузка ваших рецептов';

  @override
  String get setupCachingSubtitle =>
      'Ваши рецепты подготавливаются для работы офлайн. В зависимости от их количества это может занять некоторое время.';

  @override
  String get setupCachingDone => 'Всё готово!';

  @override
  String get setupTipsHeader => 'А вы знали?';

  @override
  String get setupFinish => 'Поехали';

  @override
  String get setupSkipCaching => 'Продолжить в фоне';

  @override
  String get setupTip1 =>
      'Рецепты можно импортировать по ссылке, с фото или из PDF — через плитку «Импорт» на главном экране.';

  @override
  String get setupTip2 =>
      'Режим готовки не даёт экрану погаснуть, ведёт вас шаг за шагом и сам находит таймеры в тексте.';

  @override
  String get setupTip3 =>
      'Список покупок работает и офлайн — изменения синхронизируются автоматически, как только сервер станет доступен.';

  @override
  String get setupTip4 =>
      'Удерживайте плитку на главном экране, чтобы изменить порядок быстрого доступа.';

  @override
  String get setupTip5 =>
      'Ваши книги рецептов Mealie — в плитке «Книги рецептов», в том числе офлайн.';

  @override
  String get ok => 'ОК';

  @override
  String get cancel => 'Отмена';

  @override
  String get delete => 'Удалить';

  @override
  String get edit => 'Изменить';

  @override
  String get save => 'Сохранить';

  @override
  String get done => 'Готово';

  @override
  String get close => 'Закрыть';

  @override
  String get add => 'Добавить';

  @override
  String get send => 'Отправить';

  @override
  String get retry => 'Повторить';

  @override
  String get confirmDeleteTitle => 'Удалить рецепт?';

  @override
  String get confirmDeleteMessage => 'Это действие нельзя отменить.';

  @override
  String get sendToDevice => 'Отправить на устройство';

  @override
  String get timerFinished => 'Таймер завершён!';

  @override
  String get timer => 'Таймер';

  @override
  String get newTimer => 'Новый таймер';

  @override
  String get timerNamePlaceholder => 'Название таймера';

  @override
  String get durationLabel => 'Длительность';

  @override
  String get start => 'Начало';

  @override
  String get stop => 'Стоп';

  @override
  String get pause => 'Пауза';

  @override
  String get resume => 'Продолжить';

  @override
  String get finished => 'Готово!';

  @override
  String stepNumber(int number) {
    return 'Шаг $number';
  }

  @override
  String get minAbbreviation => 'мин';

  @override
  String get cookingMode => 'Режим готовки';

  @override
  String get endAll => 'Завершить все';

  @override
  String get end => 'Завершить';

  @override
  String get noActiveTimers => 'Нет активных таймеров';

  @override
  String get noActiveRecipes => 'Нет активных рецептов';

  @override
  String get startRecipeToCook =>
      'Откройте рецепт и нажмите кнопку режима готовки, чтобы начать.';

  @override
  String get browseRecipes => 'Просмотреть рецепты';

  @override
  String get cookFriends => 'Готовим с друзьями';

  @override
  String get cookingModeAddRecipe => 'Добавить рецепт';

  @override
  String get cookingModeAddRecipeSearchHint => 'Поиск рецептов';

  @override
  String get cookFriendsCode => 'Код сессии';

  @override
  String get cookFriendsJoin => 'Присоединиться';

  @override
  String get cookFriendsHost => 'Создать сессию';

  @override
  String get cookFriendsHostNotFound =>
      'Хост не найден. Убедитесь, что оба устройства в одной сети Wi-Fi и доступ к локальной сети разрешён.';

  @override
  String get cookFriendsConnectionFailed =>
      'Не удалось подключиться. Попробуйте ещё раз.';

  @override
  String get cookFriendsEnterCode => 'Введите код';

  @override
  String cookFriendsConnected(int count) {
    return 'Подключено гостей: $count';
  }

  @override
  String get joinSession => 'Присоединиться';

  @override
  String get hostEndedSessionMessage => 'Хост завершил сессию готовки.';

  @override
  String get addItem => 'Добавить элемент';

  @override
  String get itemNote => 'Название позиции';

  @override
  String get unlabeledCategory => 'Без метки';

  @override
  String get archivedLists => '📦 Архив покупок';

  @override
  String get postimportAction => 'После импорта';

  @override
  String get postimportHint =>
      'Выберите, что делать с импортированными записями в исходном приложении (Напоминания / Google Tasks).';

  @override
  String get postimportLeave => 'Только добавить';

  @override
  String get postimportComplete => 'Отметить выполненными';

  @override
  String get postimportCompleteDelete => 'Отметить и удалить';

  @override
  String get postimportFailed =>
      'Обработка в исходном приложении не удалась. Позиции всё равно добавлены в Mealie.';

  @override
  String get syncChangesTitle => 'Синхронизация изменений';

  @override
  String get syncSectionChecked => 'Отмечено';

  @override
  String get syncSectionQuantity => 'Количество';

  @override
  String get syncSectionCategory => 'Категория';

  @override
  String get syncSectionAdditions => 'Добавлено';

  @override
  String get syncLocalLabel => 'Локально';

  @override
  String get syncServerLabel => 'Сервер';

  @override
  String get syncNow => 'Синхронизировать';

  @override
  String get offlineBadge => 'Офлайн';

  @override
  String get mealplanTitle => '📅 План питания';

  @override
  String get breakfast => 'Завтрак';

  @override
  String get lunch => 'Обед';

  @override
  String get dinner => 'Ужин';

  @override
  String get addMealEntry => 'Добавить блюдо';

  @override
  String get selectRecipe => 'Выбрать рецепт';

  @override
  String get importRecipe => 'Импорт рецепта';

  @override
  String get url => 'URL-адрес';

  @override
  String get importLanguage => 'Язык для OCR';

  @override
  String get setupTitle => 'Добро пожаловать в Mealie Recipes';

  @override
  String get setupSubtitle => 'Настройте ваш сервер Mealie.';

  @override
  String get serverUrl => 'URL сервера';

  @override
  String get serverUrlPlaceholder => 'https://mealie.example.com';

  @override
  String get apiToken => 'API-токен';

  @override
  String get apiTokenPlaceholder => 'Ваш API-токен';

  @override
  String get householdId => 'Домохозяйство';

  @override
  String get householdIdPlaceholder => 'Семья';

  @override
  String get shoppingListId => 'ID списка покупок';

  @override
  String get setupHouseholdListTitle => 'Домохозяйство и список покупок';

  @override
  String get shoppingListLabel => 'Список покупок';

  @override
  String get setupHouseholdManualHint =>
      'Не удалось загрузить домохозяйства — введите название вручную.';

  @override
  String get setupExactTitle => 'Количество в списке покупок';

  @override
  String get setupExactBody =>
      'В большинстве стран покупают не с точностью до грамма — в корзину кладут 1 пачку масла, а не 200 г. Поэтому в простом режиме приложение превращает количества из рецепта в «1×». В точном режиме количество и единица сохраняются 1:1, как в веб-приложении Mealie, — в том числе при вводе новых позиций (например, «200 г масла»). Это можно изменить в настройках в любой момент.';

  @override
  String get setupExactSimpleTitle => 'Простой режим (1×)';

  @override
  String get setupExactSimpleBody =>
      'Ингредиенты попадают в список как «1× позиция» — удобно быстро отмечать в магазине.';

  @override
  String get setupExactExactTitle => 'Точные количества';

  @override
  String get setupExactExactBody =>
      'Позиции показываются с количеством и единицей, например «200 г масла», — точно как в веб-приложении.';

  @override
  String get connect => 'Подключиться';

  @override
  String connectionError(String error) {
    return 'Не удалось подключиться: $error';
  }

  @override
  String get optionalHeaders =>
      'Дополнительные HTTP-заголовки (для обратного прокси)';

  @override
  String get settingsTitle => '⚙️ Настройки';

  @override
  String get settingsSaved => 'Настройки сохранены';

  @override
  String get securitySettings => 'Безопасность';

  @override
  String get showRecipeImages => 'Показывать изображения рецептов';

  @override
  String get apiVersion => 'Версия API';

  @override
  String get language => 'Язык';

  @override
  String get biometricLock => 'Биометрическая блокировка';

  @override
  String get biometricLockDescription =>
      'Разблокировка приложения по биометрии';

  @override
  String get enableLogging => 'Включить журнал';

  @override
  String get selectLanguage => 'Выбрать язык';

  @override
  String get setupContinue => 'Продолжить';

  @override
  String get back => 'Назад';

  @override
  String get setupConnectStep => 'Подключитесь к серверу';

  @override
  String get resetSettings => 'Сбросить все настройки';

  @override
  String get resetSettingsConfirm =>
      'Все настройки будут сброшены. Продолжить?';

  @override
  String get guestMode => 'Гостевой режим';

  @override
  String get appVersion => 'Версия';

  @override
  String get leftoverFinder => 'Поиск рецептов';

  @override
  String get addIngredient => 'Добавить ингредиент';

  @override
  String get biometricPrompt =>
      'Подтвердите личность, чтобы открыть Mealie Recipes';

  @override
  String get biometricFailed => 'Не удалось подтвердить личность';

  @override
  String get pendingRecipesTitle => 'Полученные рецепты';

  @override
  String pendingRecipesFrom(Object names) {
    return 'От $names';
  }

  @override
  String get pendingRecipesOpenCooking => 'Открыть режим готовки';

  @override
  String get dismiss => 'Скрыть';

  @override
  String get editRecipe => 'Изменить рецепт';

  @override
  String get recipeName => 'Название рецепта';

  @override
  String get prepTime => 'Время подготовки (мин)';

  @override
  String get cookTime => 'Время готовки (мин)';

  @override
  String get totalTime => 'Общее время (мин)';

  @override
  String get recipeServings => 'Порций';

  @override
  String get rating => 'Оценка';

  @override
  String get addIngredientLine => 'Добавить ингредиент';

  @override
  String get addInstruction => 'Добавить шаг';

  @override
  String get removeIngredient => 'Удалить ингредиент';

  @override
  String get removeInstruction => 'Удалить шаг';

  @override
  String get ingredientName => 'Ингредиент';

  @override
  String get ingredientQuantity => 'Кол-во';

  @override
  String get ingredientUnit => 'Единица измерения';

  @override
  String get ingredientNote => 'Заметка';

  @override
  String get instructionText => 'Текст шага';

  @override
  String get categories => 'Категории';

  @override
  String get saveChanges => 'Сохранить изменения';

  @override
  String get saveSuccess => 'Рецепт сохранён.';

  @override
  String get newCategory => 'Новая категория';

  @override
  String get newTag => 'Новый тег';

  @override
  String get setRating => 'Поставить оценку';

  @override
  String get homeWelcome => 'Добро пожаловать в Mealie Recipes! 👋';

  @override
  String homeWelcomeNamed(String name) {
    return 'Добро пожаловать, $name, в Mealie Recipes! 👋';
  }

  @override
  String get shopping => 'Покупки';

  @override
  String get planning => 'Планирование';

  @override
  String get other => 'Другое';

  @override
  String get addRecipe => '➕ Добавить рецепт';

  @override
  String get completeShopping => 'Завершить покупки';

  @override
  String get shoppingCompleted => 'Покупки завершены';

  @override
  String get shoppingCompletedSubtitle => 'Всё в корзине! 🎉';

  @override
  String get shoppingOfflineNoCache => 'Офлайн – список не сохранён';

  @override
  String get shoppingOfflineNoCacheSubtitle =>
      'На этом устройстве ещё нет сохранённых позиций этого списка. Он загрузится, как только вы снова будете онлайн.';

  @override
  String get essensplan => '📅 План питания';

  @override
  String get resteverwertung => '🥗 Поиск рецептов';

  @override
  String get copyCode => 'Скопировать код';

  @override
  String get shareLink => 'Поделиться ссылкой';

  @override
  String get connectedFriends => 'Подключённые друзья';

  @override
  String get waitingForFriends => 'Ожидание друзей...';

  @override
  String get sessionCode => 'КОД СЕССИИ';

  @override
  String get loading => 'Загрузка...';

  @override
  String get urlInvalidScheme => 'URL должен начинаться с http:// или https://';

  @override
  String get urlAddScheme => 'Добавить https://';

  @override
  String get addItemPlaceholder => 'Добавить позицию...';

  @override
  String get completedItems => 'Выполнено';

  @override
  String get completeShoppingTitle => 'Завершить покупки?';

  @override
  String get completeShoppingMessage => 'Удалить выполненные позиции?';

  @override
  String get recipeListTitle => '📖 Рецепты';

  @override
  String get importRecipeTitle => 'Загрузить новый рецепт';

  @override
  String get uploadRecipeUrl => 'Импорт по URL рецепта';

  @override
  String get uploadRecipeUrlHint =>
      'Введите URL рецепта, чтобы сохранить его на сервере';

  @override
  String get uploadOpenAI => 'Импорт из файла через OpenAI';

  @override
  String get uploadOpenAIHint =>
      'Или загрузите фото или PDF рецепта. Если рецепт занимает несколько страниц, просто добавьте несколько — ИИ проанализирует их вместе.';

  @override
  String get takePhoto => 'Камера';

  @override
  String get cameraPermissionDenied =>
      'Нет доступа к камере. Разрешите его в настройках системы, чтобы фотографировать рецепты.';

  @override
  String get cameraUnavailable => 'На этом устройстве нет камеры.';

  @override
  String get selectPhoto => 'Фото';

  @override
  String get selectPdf => 'PDF';

  @override
  String get openAIHintTitle => 'Об анализе файлов';

  @override
  String get openAIHintBody =>
      'Анализ рецепта использует API OpenAI. Убедитесь, что ключ API настроен в параметрах сервера Mealie.';

  @override
  String get allDeleteConfirm => 'Удалить все';

  @override
  String get entriesInOtherWeeks => 'Есть записи на других неделях';

  @override
  String get availableWeeks => 'Доступные недели:';

  @override
  String get currentWeek => 'Текущая неделя';

  @override
  String get weekAbbreviation => 'Нед.';

  @override
  String get today => 'Сегодня';

  @override
  String get selectDate => 'Выбрать дату';

  @override
  String get selectedRecipe => 'Выбранный рецепт';

  @override
  String get confirmMeal => 'Запланировать блюдо';

  @override
  String get searchRecipes => 'Поиск рецептов';

  @override
  String get addCustomMeal => 'Добавить своё блюдо';

  @override
  String get diceModeButton => 'Случайные рецепты';

  @override
  String get diceModeTitle => '3 случайных предложения';

  @override
  String get diceBackToSearch => 'Назад к поиску';

  @override
  String get diceNotEnoughRecipes =>
      'Недостаточно рецептов для кубика (нужно минимум 3)';

  @override
  String get entrySingular => 'запись';

  @override
  String get entriesPlural => 'записи';

  @override
  String get deleteAllConfirmTitle => 'Удалить все?';

  @override
  String get deleteAllConfirmMessage => 'Удалить все архивированные покупки?';

  @override
  String get uploadFromUrlButton => 'Импортировать рецепт по URL';

  @override
  String get uploadingImage => 'Загрузка...';

  @override
  String get uploadErrorTitle => 'Ошибка загрузки';

  @override
  String get uploadSuccessTitle => 'Загрузка выполнена';

  @override
  String get editImportedRecipeQuestion => 'Изменить новый рецепт сейчас?';

  @override
  String get notNow => 'Не сейчас';

  @override
  String get pdfTooLarge => 'PDF-файл слишком большой (макс. 10 МБ).';

  @override
  String get invalidUrl =>
      'Недопустимый URL. Введите корректный HTTP(S)-адрес.';

  @override
  String get cookWithFriends => 'Готовим с друзьями';

  @override
  String get cookFriendsSubtitle =>
      'Пригласите друга приготовить этот рецепт вместе';

  @override
  String get copied => 'Скопировано';

  @override
  String get linkCopied => 'Ссылка скопирована';

  @override
  String get startCooking => 'Начать готовить';

  @override
  String get uploadToOwnServer => 'Сохранить на мой сервер';

  @override
  String get uploadingRecipe => 'Загрузка рецепта…';

  @override
  String get recipeUploadedToOwnServer => 'Рецепт сохранён на вашем сервере';

  @override
  String get recipeUploadFailed => 'Ошибка загрузки';

  @override
  String get allowGuestSaveRecipes =>
      'Разрешить гостям сохранять рецепты на своём сервере';

  @override
  String get appIcon => 'Значок приложения';

  @override
  String get name => 'Название';

  @override
  String get color => 'Цвет';

  @override
  String get randomColor => 'Случайный цвет';

  @override
  String get createFailed => 'Не удалось создать';

  @override
  String get deleteFailed => 'Не удалось удалить';

  @override
  String deleteOrganizerConfirm(String name) {
    return 'Удалить «$name»? Он также будет удалён на сервере.';
  }

  @override
  String get connectionSection => 'Подключение';

  @override
  String get token => 'Токен';

  @override
  String get advancedOptions => 'Дополнительно';

  @override
  String get mealieApiVersion => 'Версия API Mealie';

  @override
  String get sendOptionalHeaders => 'Отправлять дополнительные заголовки';

  @override
  String get offlineRecipeImages => 'Сохранять изображения рецептов офлайн';

  @override
  String get offlineRecipeImagesHint =>
      'Загружает на устройство все изображения рецептов – в том числе из шагов и заметок, – чтобы они отображались без подключения. Большие коллекции могут занять несколько сотен МБ. При выключении сохранённые изображения удаляются.';

  @override
  String offlineRecipeImagesStatus(int count, int total, String size) {
    return 'Сохранено: $count/$total · $size';
  }

  @override
  String get offlineRecipeImagesDisableConfirm =>
      'Удалить все сохранённые изображения рецептов?';

  @override
  String headerNameLabel(int n) {
    return 'Имя заголовка $n';
  }

  @override
  String headerValueLabel(int n) {
    return 'Значение заголовка $n';
  }

  @override
  String get value => 'Значение';

  @override
  String get personalization => 'Персонализация';

  @override
  String get showRecipeImagesSubtitle =>
      'Показывает изображения в списке рецептов';

  @override
  String get exactQuantities => 'Добавлять точные количества';

  @override
  String get exactQuantitiesSubtitle =>
      'Ингредиенты и введённые позиции сохраняют количество и единицу (напр. 200 г масла) вместо 1× на позицию';

  @override
  String get remindToShop => 'Напоминать о покупках';

  @override
  String get remindToShopSubtitle =>
      'Уведомляет, когда вы рядом с сохранённым местом, а в списке покупок есть открытые позиции, — даже если приложение закрыто';

  @override
  String get shoppingReminderAddLocation => 'Добавить место';

  @override
  String get shoppingReminderMaxLocations => 'Достигнут максимум — 3 места';

  @override
  String get shoppingReminderLocationServiceDisabled =>
      'Службы геолокации на этом устройстве выключены';

  @override
  String get shoppingReminderPermissionTitle => 'Нужен доступ к геолокации';

  @override
  String get shoppingReminderPermissionMessage =>
      'Чтобы напоминать вам рядом с магазином, нужен доступ к геолокации «Всегда» — даже при закрытом приложении. Включите его в Настройках.';

  @override
  String get openSettings => 'Открыть Настройки';

  @override
  String get shoppingReminderLocationName => 'Название';

  @override
  String get shoppingReminderUseCurrentLocation =>
      'Использовать текущее местоположение';

  @override
  String get shoppingReminderOrAddress => 'или введите адрес';

  @override
  String get shoppingReminderAddress => 'Адрес';

  @override
  String get shoppingReminderAddressPlaceholder => 'Улица, город';

  @override
  String get shoppingReminderSearchAddress => 'Поиск';

  @override
  String get shoppingReminderLocationFailed =>
      'Не удалось определить местоположение';

  @override
  String get shoppingReminderAddressNotFound => 'Адрес не найден';

  @override
  String get ratingFailed =>
      'Не удалось сохранить оценку — попробуйте ещё раз.';

  @override
  String get lastCooked => 'Последнее приготовление';

  @override
  String get syncLastCooked => 'Обновлять «последнее приготовление»';

  @override
  String get syncLastCookedSubtitle =>
      'Сохраняет сегодняшнюю дату и запись в истории на сервере — как веб-приложение Mealie.';

  @override
  String get developer => 'Разработчик';

  @override
  String get enableLoggingSubtitle =>
      'Записывает журналы вывода и ошибок (последние 500 строк)';

  @override
  String get entriesLabel => 'Записи';

  @override
  String get fileSize => 'Размер файла';

  @override
  String get showAction => 'Показать';

  @override
  String get copy => 'Копировать';

  @override
  String logsWithCount(int count) {
    return 'Журналы ($count)';
  }

  @override
  String get noLogs => 'Журналов нет';

  @override
  String get logsTitle => 'Журналы';

  @override
  String get required => 'Обязательно';

  @override
  String get connectionFailedCheck =>
      'Не удалось подключиться. Проверьте URL и токен.';

  @override
  String get username => 'Имя пользователя';

  @override
  String get password => 'Пароль';

  @override
  String get setupPasswordHint =>
      'Пароль не сохраняется — приложение один раз выполняет вход и создаёт по нему API-токен (как Профиль → API-токены в веб-приложении).';

  @override
  String get loginAndConnect => 'Войти и подключиться';

  @override
  String get loginInvalidCredentials => 'Неверное имя пользователя или пароль.';

  @override
  String get apiTokenSaveHint =>
      'Токен применён — нажмите «Сохранить изменения» ниже.';

  @override
  String get renewApiToken => 'Обновить API-токен';

  @override
  String get setupAuthChoiceTitle => 'Как вы хотите войти?';

  @override
  String get authModePasswordTitle => 'Пусть приложение создаст API-ключ';

  @override
  String get authModePasswordSubtitle =>
      'Вход по имени пользователя и паролю — приложение само создаст токен.';

  @override
  String get authModeTokenTitle => 'У меня уже есть API-ключ';

  @override
  String get authModeTokenSubtitle =>
      'Скопирован из профиля Mealie (Профиль → API-токены).';

  @override
  String keyN(int n) {
    return 'Ключ $n';
  }

  @override
  String valueN(int n) {
    return 'Значение $n';
  }

  @override
  String get openCookingMode => 'Открыть режим готовки';

  @override
  String activeRecipes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count активного рецепта',
      many: '$count активных рецептов',
      few: '$count активных рецепта',
      one: '$count активный рецепт',
    );
    return '$_temp0';
  }

  @override
  String get reparseIngredients => 'Разобрать ингредиенты заново';

  @override
  String get reparseIngredientsSubtitle =>
      'Разделить количество/единицу/ингредиент (напр. «200 г муки»)';

  @override
  String get reparseDone =>
      'Ингредиенты разделены – нажмите «Сохранить изменения», чтобы применить';

  @override
  String get tagsAndCategories => 'Теги, категории и инструменты';

  @override
  String get tapToAddPhoto => 'Нажмите, чтобы добавить фото';

  @override
  String get descriptionLabel => 'Описание';

  @override
  String get searchingDevices => 'Поиск устройств в той же сети Wi-Fi…';

  @override
  String get selectAll => 'Выбрать все';

  @override
  String get importReminders => 'Импорт напоминаний';

  @override
  String get importGoogleTasks => 'Импорт Google Tasks';

  @override
  String get noTaskLists => 'Списки задач не найдены';

  @override
  String get noReminderLists => 'Списки напоминаний не найдены';

  @override
  String importCount(int count) {
    return 'Импортировать $count';
  }

  @override
  String get noIngredientsToLink => 'Пока нет ингредиентов для привязки';

  @override
  String get importLanguageSubtitle =>
      'Язык рецептов, импортированных из фото или PDF';

  @override
  String get importLanguageSearch => 'Поиск языка';

  @override
  String get importLanguageFollowApp => 'Как язык приложения';

  @override
  String get importLanguageNoMatch => 'Язык не найден';

  @override
  String get setupImportLanguageTitle => 'ИИ-импорт рецептов';

  @override
  String get setupImportLanguageBody =>
      'ИИ может превращать фото и PDF в рецепты. Выберите язык, на котором они должны получиться, — удобно, если вашего родного языка нет среди языков приложения. Позже это можно изменить в настройках.';

  @override
  String get setupImportLanguageSearchHint =>
      'Используйте поиск в списке, чтобы найти языки, которых нет в интерфейсе приложения.';

  @override
  String get setupCachingKeepOpenTitle => 'Не закрывайте приложение';

  @override
  String get setupCachingKeepOpenBody =>
      'Загрузка идёт на переднем плане. Оставьте приложение открытым до завершения — если закрыть его или надолго переключиться, процесс остановится и начнётся заново позже.';

  @override
  String get supportContact => 'Связаться с поддержкой';

  @override
  String get supportDialogMessage =>
      'Опишите проблему, и мы ответим. Журнал сильно помогает в поиске ошибки — его можно приложить текстовым файлом.';

  @override
  String get supportWithoutLogs => 'Без журнала';

  @override
  String get supportWithLogs => 'Приложить журнал';

  @override
  String get supportMailSubject => 'Mealie Recipes — Поддержка';

  @override
  String get supportMailHint => 'Опишите проблему здесь:';

  @override
  String get supportLogsEmpty =>
      'Журнал пуст. Включите журнал, воспроизведите проблему и затем отправьте.';

  @override
  String supportAddressCopied(String email) {
    return 'Адрес скопирован: $email';
  }

  @override
  String supportNoMailApp(String email) {
    return 'Почтовое приложение не настроено – адрес скопирован: $email. Выберите другое приложение, чтобы написать нам.';
  }

  @override
  String get createRecipeFromImages => 'Создать рецепт';

  @override
  String imagePagesSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Выбрано $count страницы',
      many: 'Выбрано $count страниц',
      few: 'Выбрано $count страницы',
      one: 'Выбрана $count страница',
    );
    return '$_temp0';
  }

  @override
  String get imagePagesHint =>
      'Первое изображение станет главным изображением рецепта. Удерживайте страницу, чтобы изменить порядок.';

  @override
  String get mainImageBadge => 'Главное';

  @override
  String maxImagesReached(int max) {
    return 'Можно добавить до $max изображений на рецепт.';
  }

  @override
  String get removePage => 'Удалить страницу';

  @override
  String get preparingPdf => 'Обработка PDF...';

  @override
  String get recipeOptionsTitle => 'Параметры';

  @override
  String get exportAsPdf => 'Экспорт в PDF';

  @override
  String get generatingPdf => 'Создание PDF…';

  @override
  String get pdfExportFailed => 'Ошибка экспорта PDF';

  @override
  String get recipeTime => 'Время';

  @override
  String get addIngredientSection => 'Добавить раздел';

  @override
  String get aiImportToggle => 'Анализ с помощью ИИ';

  @override
  String get aiImportToggleHint =>
      'Также для видеорецептов (YouTube, Instagram, TikTok …) и страниц, которые обычный импорт не может прочитать. Нужен ИИ-провайдер на сервере Mealie — для видео ещё и аудиопровайдер.';

  @override
  String get aiImportButton => 'Импорт с помощью ИИ';

  @override
  String get aiImportRunning =>
      'ИИ анализирует ссылку … видео может занять несколько минут.';

  @override
  String get aiImportFailed =>
      'ИИ-импорт не удался. Проверьте настройки ИИ на сервере Mealie.';

  @override
  String get stepHeadingLabel => 'Заголовок шага (необязательно)';

  @override
  String get linkedRecipeLabel => 'Связанный рецепт';

  @override
  String get toolsTitle => 'Инструменты';

  @override
  String get prepareTools => 'Подготовьте следующие инструменты';

  @override
  String get newTool => 'Новый инструмент';

  @override
  String get renameAction => 'Переименовать';

  @override
  String get organizerEmpty =>
      'Здесь пока пусто. Нажмите «+» вверху справа, чтобы создать.';

  @override
  String organizerRecipeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count рецепта',
      many: '$count рецептов',
      few: '$count рецепта',
      one: '$count рецепт',
      zero: 'Нет рецептов',
    );
    return '$_temp0';
  }

  @override
  String get toolOnHand => 'В наличии';

  @override
  String get mealDiceSettingsHint =>
      'Выберите категории и теги для каждого приёма пищи. При броске кубика предлагаются только рецепты хотя бы с одним из них. Одну запись можно использовать для нескольких приёмов пищи.';

  @override
  String get mealDiceSettingsNoneHint =>
      'Для этого приёма пищи ничего не выбрано: кубик выбирает автоматически по названиям категорий вроде «Завтрак», «Обед» или «Ужин».';

  @override
  String get mealDiceAutoHintTitle => 'Автоматический выбор';

  @override
  String get mealDiceAutoHintBody =>
      'Для этого приёма пищи ещё не заданы категории или теги. Поэтому кубик ищет категории вроде «Завтрак», «Обед» или «Ужин» и дополняет другими рецептами.\n\nЧтобы выбрать самостоятельно: в плане питания нажмите значок шестерёнки рядом с «+».';

  @override
  String get dontShowAgain => 'Больше не показывать';

  @override
  String get mealDiceNoMatches =>
      'Ни один рецепт не подходит под выбранные для этого приёма пищи категории и теги.';

  @override
  String mealDiceFewMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Подходит только $count рецепта',
      many: 'Подходит только $count рецептов',
      few: 'Подходит только $count рецепта',
      one: 'Подходит только $count рецепт',
    );
    return '$_temp0';
  }

  @override
  String get commentsTitle => 'Комментарии';

  @override
  String get commentHint => 'Напишите комментарий…';

  @override
  String get commentSaveFailed => 'Не удалось сохранить комментарий.';

  @override
  String get commentDeleteConfirm => 'Удалить этот комментарий?';

  @override
  String get cookingDoneCommentLabel => 'Комментарий (необязательно)';

  @override
  String get cookingDoneCommentHint =>
      'Как получилось? Советы на следующий раз…';

  @override
  String get nutritionTitle => 'Пищевая ценность';

  @override
  String get nutritionPerServing => 'на порцию';

  @override
  String get nutritionCalories => 'Энергетическая ценность';

  @override
  String get nutritionFat => 'Жиры';

  @override
  String get nutritionSaturatedFat => 'Насыщенные жиры';

  @override
  String get nutritionTransFat => 'Трансжиры';

  @override
  String get nutritionUnsaturatedFat => 'Ненасыщенные жиры';

  @override
  String get nutritionCholesterol => 'Холестерин';

  @override
  String get nutritionSodium => 'Натрий';

  @override
  String get nutritionCarbohydrates => 'Углеводы';

  @override
  String get nutritionFiber => 'Клетчатка';

  @override
  String get nutritionSugar => 'Сахар';

  @override
  String get nutritionProtein => 'Белки';

  @override
  String get timelineTitle => 'История';

  @override
  String get timelineMadeThis => 'Я приготовил(а)';

  @override
  String timelineUserMadeThis(String name) {
    return '$name приготовил(а) это';
  }

  @override
  String get timelineEmpty => 'В истории пока нет записей.';

  @override
  String get timelineDate => 'Дата';

  @override
  String get timelineNoteHint => 'Заметка (необязательно)';

  @override
  String get timelineAddPhoto => 'Добавить фото';

  @override
  String get timelineRemovePhoto => 'Удалить фото';

  @override
  String get timelineSaved => 'Добавлено в историю';

  @override
  String get timelineSaveFailed => 'Не удалось добавить в историю';

  @override
  String get timelineImageFailed =>
      'Запись сохранена, но фото загрузить не удалось';

  @override
  String get timelineDeleteConfirm => 'Удалить эту запись из истории?';

  @override
  String get timelineEditNote => 'Изменить заметку';

  @override
  String get timelineUnknownRecipe => 'Рецепт не найден';

  @override
  String get cookingDonePhotoHint => 'Фото для истории Mealie (необязательно)';

  @override
  String get assetsTitle => 'Файлы';

  @override
  String get assetsAdd => 'Добавить файл';

  @override
  String get assetsChooseFile => 'Файл';

  @override
  String get assetsUploading => 'Загрузка…';

  @override
  String get assetsUploadFailed => 'Не удалось загрузить файл';

  @override
  String assetsDeleteConfirm(String name) {
    return 'Удалить «$name» из файлов?';
  }

  @override
  String get assetsOpenFailed => 'Не удалось открыть файл';

  @override
  String get assetsUnsupported =>
      'Mealie поддерживает только PDF, изображения, TXT, MD, CSV и JSON.';

  @override
  String get assetsShare => 'Поделиться';

  @override
  String get mealRulesTitle => 'Правила Mealie';

  @override
  String get mealRulesHint =>
      'Используются и веб-приложением Mealie. Если к дню и приёму пищи относится несколько правил, должны выполняться все. Если ни одно правило не подходит, кубик выбирает из всех рецептов.';

  @override
  String get mealRuleAdd => 'Добавить правило';

  @override
  String get mealRuleNewTitle => 'Новое правило';

  @override
  String get mealRuleEditTitle => 'Изменить правило';

  @override
  String get mealRuleDay => 'День';

  @override
  String get mealRuleAnyDay => 'Любой день';

  @override
  String get mealRuleMealType => 'Приём пищи';

  @override
  String get mealRuleAnyMeal => 'Любой приём пищи';

  @override
  String get mealRuleConditionsTitle => 'Условия';

  @override
  String get mealRuleAllRecipes => 'Все рецепты';

  @override
  String get mealRuleDeleteConfirm => 'Удалить это правило?';

  @override
  String get mealRulesOffline =>
      'Правила Mealie сейчас недоступны – кубик использует выбор приложения.';

  @override
  String get mealRulesNoMatches =>
      'Ни один рецепт не соответствует правилам Mealie для этого приёма пищи.';

  @override
  String get mealTypeSide => 'Гарнир';

  @override
  String get mealTypeSnack => 'Закуска';

  @override
  String get mealTypeDrink => 'Напиток';

  @override
  String get mealTypeDessert => 'Десерт';

  @override
  String get foodsTitle => 'Продукты';

  @override
  String get unitsTitle => 'Единицы измерения';

  @override
  String get newFood => 'Новый продукт';

  @override
  String get newUnit => 'Новая единица';

  @override
  String get editFood => 'Изменить продукт';

  @override
  String get editUnit => 'Изменить единицу';

  @override
  String get pluralNameLabel => 'Название во множественном числе';

  @override
  String get abbreviationLabel => 'Аббревиатура';

  @override
  String get pluralAbbreviationLabel => 'Сокращение во множественном числе';

  @override
  String get mergeAction => 'Объединить';

  @override
  String mergeIntoTitle(String name) {
    return 'Объединить «$name» с…';
  }

  @override
  String mergeConfirm(String from, String to) {
    return '«$from» будет объединён с «$to»: все рецепты и списки покупок будут использовать «$to», а «$from» будет удалён.';
  }

  @override
  String get mergeFailed => 'Не удалось объединить';

  @override
  String foodUnitDeleteConfirm(String name) {
    return 'Удалить «$name»? Ингредиенты, которые его используют, потеряют ссылку.';
  }

  @override
  String get foodsUnitsEmpty => 'Записей пока нет.';

  @override
  String mealRuleConditionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count условия',
      many: '$count условий',
      few: '$count условия',
      one: '$count условие',
    );
    return '$_temp0';
  }

  @override
  String get showAll => 'Показать все';

  @override
  String get mealDiceModeTitle => 'Кубик использует';

  @override
  String get mealDiceModeApp => 'Выбор приложения';

  @override
  String get switchListTitle => 'Сменить список';

  @override
  String get newShoppingList => 'Новый список покупок';

  @override
  String shoppingListDeleteConfirm(String name) {
    return 'Удалить «$name»? Все позиции в нём тоже будут удалены.';
  }

  @override
  String get labelOrderTitle => 'Сортировка меток';

  @override
  String get labelOrderHint =>
      'Перетаскивайте для сортировки. Действует для этого списка – и в веб-приложении Mealie.';

  @override
  String get labelOrderEmpty => 'В этом списке пока нет меток.';

  @override
  String get useAsActiveList => 'Сделать активным списком';

  @override
  String get activeListBadge => 'Активный';

  @override
  String get foodLabelLabel => 'Метка';

  @override
  String get foodNoLabel => 'Без метки';

  @override
  String get aliasesLabel => 'Псевдонимы';

  @override
  String get aliasAddHint => 'Добавить псевдоним';

  @override
  String get foodOnHand => 'Есть в домохозяйстве';

  @override
  String get timelineChildRecipesTitle => 'Добавить и для связанных рецептов';

  @override
  String timelineMadeForRecipe(String recipe) {
    return 'Сделано для $recipe';
  }

  @override
  String get timelineFilter => 'Фильтр записей';

  @override
  String get timelineTypeComment => 'Приготовления и заметки';

  @override
  String get timelineTypeInfo => 'Информация';

  @override
  String get timelineTypeSystem => 'Система';

  @override
  String get listManagementTitle => 'Списки покупок';

  @override
  String get managementTitle => 'Ещё';

  @override
  String get pinToHome => 'Добавить на главный экран';

  @override
  String get unpinFromHome => 'Убрать с главного экрана';

  @override
  String homeScreenFull(int count) {
    return 'Главный экран заполнен – не более $count плиток. Сначала уберите другую плитку в разделе «Ещё».';
  }

  @override
  String get selectAction => 'Выбрать';

  @override
  String selectedCount(int count) {
    return 'Выбрано: $count';
  }

  @override
  String get assignLabelAction => 'Назначить метку';

  @override
  String get assignLabelOverwriteHint =>
      'Заменяет метку у всех выбранных продуктов.';

  @override
  String deleteSelectedConfirm(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Удалить $count записи?',
      many: 'Удалить $count записей?',
      few: 'Удалить $count записи?',
      one: 'Удалить $count запись?',
    );
    return '$_temp0';
  }

  @override
  String get seedDataAction => 'Загрузить стандартные данные';

  @override
  String get seedFoodsHint =>
      'Создаёт стандартные продукты Mealie на выбранном языке.';

  @override
  String get seedUnitsHint =>
      'Создаёт стандартные единицы Mealie на выбранном языке.';

  @override
  String get seedLanguageLabel => 'Язык';

  @override
  String get seedDuplicateWarning =>
      'У вас уже есть записи. Mealie не устраняет дубликаты – объединять их придётся вручную.';

  @override
  String get seedDone => 'Стандартные данные созданы';

  @override
  String get seedFailed => 'Не удалось загрузить стандартные данные';

  @override
  String get exportAction => 'Экспортировать';

  @override
  String get substitutionsLabel => 'Замены';

  @override
  String get substitutionAddHint => 'Добавить замену';

  @override
  String get substitutionFoodLabel => 'Продукт (необязательно)';

  @override
  String get substitutionNoteLabel => 'Примечание (необязательно)';

  @override
  String get substitutionNeedOne => 'Введите продукт или примечание';

  @override
  String get useAbbreviationLabel => 'Использовать сокращение';

  @override
  String get useAbbreviationHint => 'Показывать «г» вместо «грамм» в рецептах';

  @override
  String get fractionLabel => 'Показывать дробью';

  @override
  String get fractionHint => '½ вместо 0,5';

  @override
  String get standardizationTitle => 'Стандартизация';

  @override
  String get standardizationHint =>
      'Для пересчёта: 1 этой единицы равна … (напр. 1 ст. л. = 15 миллилитров).';

  @override
  String get standardQuantityLabel => 'Стандартное количество';

  @override
  String get standardUnitLabel => 'Стандартная единица';

  @override
  String get standardUnitNone => 'Ничего';

  @override
  String get stdFluidOunce => 'Жидкая унция (fl oz)';

  @override
  String get stdCup => 'Чашка (США)';

  @override
  String get stdOunce => 'Унция (oz)';

  @override
  String get stdPound => 'Фунт (lb)';

  @override
  String get stdMilliliter => 'Миллилитр';

  @override
  String get stdLiter => 'Литр';

  @override
  String get stdGram => 'Грамм';

  @override
  String get stdKilogram => 'Килограмм';

  @override
  String get labelsTitle => 'Метки';

  @override
  String get newLabel => 'Новая метка';

  @override
  String get editLabel => 'Изменить метку';

  @override
  String get colorLabel => 'Цвет';

  @override
  String labelDeleteConfirm(String name) {
    return 'Удалить «$name»? Позиции и продукты потеряют эту метку.';
  }

  @override
  String get importMenuAction => 'Импортировать';

  @override
  String get archivedEmpty =>
      'Архивированных покупок пока нет. После покупок нажмите «Завершить покупки» – отмеченные позиции сохранятся здесь.';

  @override
  String get sectionTitleLabel => 'Название раздела';

  @override
  String get clearSection => 'Убрать раздел';

  @override
  String get noPermissionGeneric =>
      'У вас нет на это прав в Mealie. Обратитесь к администратору или управляющему домохозяйством.';

  @override
  String get noPermissionEditRecipe =>
      'Вы не можете изменить этот рецепт – он заблокирован или принадлежит другому домохозяйству. Это может только его автор или администратор.';

  @override
  String get noPermissionDeleteRecipe =>
      'Удалить рецепт может только его автор или администратор.';

  @override
  String get noPermissionDemoteSelf =>
      'Нельзя снять с себя права администратора.';

  @override
  String get recipeLockedHint => 'Заблокирован – изменять может только автор';

  @override
  String get recipeDeleteOwnerOnlyHint =>
      'Удалить может только автор или администратор';

  @override
  String get organizeReadOnlyHint =>
      'Только просмотр: для создания, изменения и удаления нужно право «Пользователь может управлять продуктами, тегами и категориями».';

  @override
  String get notesNotSavedNoPermission =>
      'Заметка не сохранена – у вас нет прав на изменение этого рецепта.';

  @override
  String get userManagementTitle => 'Управление пользователями';

  @override
  String get editUserTitle => 'Редактирование пользователя';

  @override
  String get fullNameLabel => 'Полное имя';

  @override
  String get usernameLabel => 'Имя пользователя';

  @override
  String get emailLabel => 'Адрес электронной почты';

  @override
  String get passwordLabel => 'Пароль';

  @override
  String get householdLabel => 'Домохозяйство';

  @override
  String get permissionsTitle => 'Права доступа';

  @override
  String get administratorLabel => 'Администратор';

  @override
  String get permCanInvite => 'Пользователь может пригласить других в группу';

  @override
  String get permCanManage => 'Пользователь может управлять настройками группы';

  @override
  String get permCanManageHousehold =>
      'Пользователь может управлять домохозяйством';

  @override
  String get permCanOrganize =>
      'Пользователь может управлять продуктами, тегами и категориями';

  @override
  String get advancedFeaturesLabel => 'Включить дополнительные функции';

  @override
  String get passwordResetLinkAction =>
      'Сгенерировать ссылку для сброса пароля';

  @override
  String get resetLockedUsersAction => 'Сброс заблокированных пользователей';

  @override
  String get inviteLinkTitle => 'Ссылка-приглашение';

  @override
  String get inviteAction => 'Пригласить';

  @override
  String get userUpdated => 'Пользователь обновлен';

  @override
  String get createUserTitle => 'Создать пользователя';

  @override
  String get userCreated => 'Пользователь создан';

  @override
  String userDeleteConfirm(String name) {
    return 'Удалить «$name»? Учётная запись будет удалена из Mealie.';
  }

  @override
  String get passwordResetLinkCopied =>
      'Ссылка скопирована – передайте её пользователю. Она действует ограниченное время.';

  @override
  String lockedUsersReset(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Разблокировано $count пользователя',
      many: 'Разблокировано $count пользователей',
      few: 'Разблокировано $count пользователя',
      one: 'Разблокирован $count пользователь',
      zero: 'Нет заблокированных пользователей',
    );
    return '$_temp0';
  }

  @override
  String get inviteUsesLabel => 'Число использований';

  @override
  String get inviteCreated => 'Ссылка-приглашение создана';

  @override
  String get inviteEmailHint =>
      'Адрес эл. почты (необязательно – Mealie отправит приглашение)';

  @override
  String get inviteEmailSent => 'Приглашение отправлено по почте';

  @override
  String get inviteEmailFailed =>
      'Не удалось отправить письмо (настроен ли SMTP в Mealie?). Ссылка всё равно работает.';

  @override
  String get copyLinkAction => 'Копировать ссылку';

  @override
  String get youLabel => 'Вы';

  @override
  String get membersPermissionsHint =>
      'Вы можете менять права участников домохозяйства – но не свои.';

  @override
  String get householdManagementTitle => 'Управление домохозяйством';

  @override
  String get householdsTitle => 'Домохозяйства';

  @override
  String get createHouseholdTitle => 'Создать домохозяйство';

  @override
  String get householdNameLabel => 'Название домохозяйства';

  @override
  String get householdPreferencesTitle => 'Параметры домохозяйства';

  @override
  String get privateHouseholdLabel => 'Приватное домохозяйство';

  @override
  String get privateHouseholdHint =>
      'Переключение домохозяйства в приватное отключит все настройки публичного доступа. Это так же переписывает все индивидуальные настройки публичного доступа';

  @override
  String get lockRecipeEditsLabel =>
      'Заблокировать изменения рецепта от других домохозяйств';

  @override
  String get lockRecipeEditsHint =>
      'Если включено, только пользователи в вашем домохозяйстве могут редактировать рецепты, созданные вашим домохозяйством';

  @override
  String get householdRecipePreferencesTitle =>
      'Параметры рецептов домохозяйства';

  @override
  String get groupsTitle => 'Группы';

  @override
  String get groupLabel => 'Группа';

  @override
  String get createGroupTitle => 'Создать группу';

  @override
  String get groupNameLabel => 'Название группы';

  @override
  String get groupPreferencesTitle => 'Настройки группы';

  @override
  String get privateGroupLabel => 'Частная группа';

  @override
  String get privateGroupHint =>
      'Установка для вашей группы в приватную отключит все опции общего просмотра. Это переопределит любые настройки публичного просмотра';

  @override
  String get firstDayOfWeekLabel => 'Первый день недели';

  @override
  String get showAnnouncementsLabel => 'Показывать объявления от Mealie';

  @override
  String get recipePublicDefaultLabel =>
      'Разрешить пользователям за пределами вашей группы видеть ваши рецепты';

  @override
  String get recipeShowNutritionDefaultLabel =>
      'Показать информацию по питательным веществам';

  @override
  String get recipeShowAssetsDefaultLabel => 'Показать приложения рецепта';

  @override
  String get recipeLandscapeDefaultLabel => 'По умолчанию в ландшафтном виде';

  @override
  String get recipeDisableCommentsDefaultLabel =>
      'Запретить пользователям комментировать рецепты';

  @override
  String get myHouseholdSection => 'Моё домохозяйство';

  @override
  String get myGroupSection => 'Моя группа';

  @override
  String get preferencesSaved => 'Настройки сохранены';

  @override
  String get cannotDeleteWithUsers =>
      'Ещё есть пользователи – сначала переместите или удалите их в управлении пользователями.';

  @override
  String deleteHouseholdConfirm(String name) {
    return 'Удалить домохозяйство «$name»?';
  }

  @override
  String deleteGroupConfirm(String name) {
    return 'Удалить группу «$name»?';
  }

  @override
  String usersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count пользователя',
      many: '$count пользователей',
      few: '$count пользователя',
      one: '$count пользователь',
      zero: 'Нет пользователей',
    );
    return '$_temp0';
  }

  @override
  String get originalUrlLabel => 'Исходный URL';

  @override
  String get copyTextAction => 'Копировать текст';

  @override
  String get copiedToClipboard => 'Скопировано в буфер обмена';

  @override
  String get changelogEnglishHint =>
      'Примечания к выпуску доступны только на английском.';

  @override
  String get favoritesTitle => 'Избранное';

  @override
  String get favoritesEmpty =>
      'Избранного пока нет. Нажмите на сердечко у рецепта, чтобы собрать его здесь.';

  @override
  String get changelogTitle => 'Что нового';

  @override
  String get changeProfileImage => 'Изменить фото профиля';

  @override
  String get profileImageUpdated => 'Фото профиля обновлено';

  @override
  String get profileImageFailed => 'Не удалось загрузить фото профиля';

  @override
  String get myAccountTitle => 'Моя учётная запись';

  @override
  String get ownAccountHint =>
      'Здесь можно изменить свою учётную запись. Другими пользователями управляют администраторы и участники с правом «управлять».';

  @override
  String get changePasswordAction => 'Сменить пароль';

  @override
  String get currentPasswordLabel => 'Текущий пароль';

  @override
  String get newPasswordLabel => 'Новый пароль';

  @override
  String get confirmPasswordLabel => 'Подтвердите пароль';

  @override
  String get passwordTooShort => 'Не менее 8 символов';

  @override
  String get passwordsDoNotMatch => 'Пароли не совпадают';

  @override
  String get passwordUpdated => 'Пароль обновлен';

  @override
  String get passwordChangeFailed => 'Не удалось сменить пароль';

  @override
  String passwordManagedExternally(String method) {
    return 'Вы входите через $method — смените пароль там.';
  }

  @override
  String get bulkAddHint => 'Одна строка — одна запись.';

  @override
  String bulkAddCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Добавить $count записи',
      many: 'Добавить $count записей',
      few: 'Добавить $count записи',
      one: 'Добавить $count запись',
    );
    return '$_temp0';
  }

  @override
  String get linkRecipeAction => 'Связать рецепт';

  @override
  String get useFoodAction => 'Использовать продукт вместо рецепта';

  @override
  String get addSubstitutionsAction => 'Добавить замены';

  @override
  String get clearSubstitutionsAction => 'Убрать замены';

  @override
  String get recipeSubstitutionsTitle => 'Замены';

  @override
  String get substitutionUnknownFood =>
      'Только существующие продукты – иначе используйте примечание';

  @override
  String get insertAboveAction => 'Вставить выше';

  @override
  String get insertBelowAction => 'Вставить ниже';

  @override
  String get moveToTopAction => 'Переместить в начало';

  @override
  String get moveToBottomAction => 'Переместить в конец';

  @override
  String get linkReferencesAction => 'Ссылки';

  @override
  String get editMarkdownAction => 'Редактировать Markdown';

  @override
  String get previewMarkdownAction => 'Предпросмотр Markdown';

  @override
  String get insertStepImageAction => 'Загрузить изображение';

  @override
  String get mergeAboveAction => 'Объединить с предыдущим';

  @override
  String get linkedToOtherStep => 'Связан с другим шагом';

  @override
  String get noNotesToLink => 'Нет заметок для связи';

  @override
  String get ownerLabel => 'Владелец';

  @override
  String get ingredientParserTitle => 'Разделитель ингредиентов';

  @override
  String ingredientParserHint(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count ингредиента ещё не структурированы. Выберите парсер, проверьте результат, примените.',
      many:
          '$count ингредиентов ещё не структурированы. Выберите парсер, проверьте результат, примените.',
      few:
          '$count ингредиента ещё не структурированы. Выберите парсер, проверьте результат, примените.',
      one:
          '$count ингредиент ещё не структурирован. Выберите парсер, проверьте результат, примените.',
    );
    return '$_temp0';
  }

  @override
  String get parserNlp => 'Обработчик естественного языка';

  @override
  String get parserBrute => 'Грубый Парсер';

  @override
  String get parserOpenai => 'Парсер OpenAI';

  @override
  String get parserApp => 'Офлайн (приложение)';

  @override
  String get parseFailed => 'Не удалось разобрать';

  @override
  String get parseAction => 'Обработать';

  @override
  String applyParsedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Применить $count ингредиента',
      many: 'Применить $count ингредиентов',
      few: 'Применить $count ингредиента',
      one: 'Применить $count ингредиент',
      zero: 'Ничего не выбрано',
    );
    return '$_temp0';
  }

  @override
  String get parsedNewBadge => 'новый';

  @override
  String get hoursShort => 'ч';

  @override
  String get minutesShort => 'мин';

  @override
  String get timeExtraHint => 'Дополнительно, напр. «плюс ночь»';

  @override
  String get yieldLabel => 'Выход';

  @override
  String get yieldTextLabel => 'Название единицы полученного продукта';

  @override
  String get prepTimeLabel => 'Время подготовки';

  @override
  String get performTimeLabel => 'Время приготовления';

  @override
  String get totalTimeLabel => 'Общее время';

  @override
  String get settingPublicRecipe => 'Открытый рецепт';

  @override
  String get settingShowNutrition => 'Показать пищевую ценность';

  @override
  String get settingShowAssets => 'Показать приложения';

  @override
  String get settingLandscapeView => 'В ландшафтном режиме (скоро)';

  @override
  String get settingDisableComments => 'Отключить комментарии';

  @override
  String get settingDisableAmount => 'Отключить количество ингредиентов';

  @override
  String get settingLocked => 'Заблокировано';

  @override
  String get settingLockedOwnerOnly =>
      'Блокировать и разблокировать рецепт может только его автор.';

  @override
  String get apiExtrasTitle => 'Дополнительные API';

  @override
  String get apiExtrasHint =>
      'Свои пары ключ/значение для сторонних приложений, напр. для запуска автоматизаций.';

  @override
  String get extraKeyLabel => 'Ключ';

  @override
  String get extraValueLabel => 'Значение';

  @override
  String get addExtraAction => 'Добавить поле';

  @override
  String durationHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count часа',
      many: '$count часов',
      few: '$count часа',
      one: '$count час',
    );
    return '$_temp0';
  }

  @override
  String durationMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count минуты',
      many: '$count минут',
      few: '$count минуты',
      one: '$count минута',
    );
    return '$_temp0';
  }

  @override
  String get discardChangesConfirm => 'Отменить несохранённые изменения?';

  @override
  String get discardChanges => 'Отменить изменения';

  @override
  String get imageFromUrl => 'Изображение по URL';

  @override
  String get deleteRecipeImage => 'Удалить изображение рецепта';

  @override
  String get deleteRecipeImageConfirm =>
      'Вы уверены, что хотите удалить данное изображение рецепта?';

  @override
  String get bulkAddIngredients => 'Добавить ингредиенты списком';

  @override
  String get bulkAddSteps => 'Добавить шаги списком';

  @override
  String get stepImageFailed => 'Не удалось загрузить изображение';

  @override
  String get servingsAndTimes => 'Порции и время';

  @override
  String get recipeSettingsTitle => 'Настройки рецепта';

  @override
  String get jsonEditorTitle => 'Редактор JSON';

  @override
  String get jsonInvalid => 'Недопустимый JSON – проверьте.';

  @override
  String get editorOfflineHint =>
      'Открыто офлайн: для сохранения нужно подключение. Новые поля Mealie (напр. замены) остаются без изменений.';

  @override
  String get parseLineFailed => 'Не распознано – остаётся без изменений';

  @override
  String get createManualTitle => 'Создать рецепт вручную';

  @override
  String get createManualHint =>
      'Введите название – ингредиенты, шаги, изображение и всё остальное добавите потом в редакторе рецепта.';

  @override
  String get createManualButton => 'Создать и изменить';

  @override
  String get changelogEmpty => 'Для этой версии записей пока нет.';

  @override
  String get finderDescription =>
      'Поиск рецептов, основанный на ингредиентах, которые есть у вас в наличии. Вы также можете отфильтровать по имеемым инструментам и выставить максимальное количество отсутствующих ингредиентов или инструментов.';

  @override
  String get finderSelectedIngredients => 'Выбранные ингредиенты';

  @override
  String get finderNoIngredientsSelected => 'Нет выбранных ингредиентов';

  @override
  String get finderMissing => 'Отсутствует';

  @override
  String get finderNoRecipesFound => 'Рецепты не найдены';

  @override
  String get finderNoRecipesFoundDescription =>
      'Попробуйте добавить больше ингредиентов для поиска или измените настройки фильтров';

  @override
  String get finderIncludeFoodsOnHand =>
      'Включать ингредиенты в наличии, под рукой';

  @override
  String get finderIncludeToolsOnHand =>
      'Включать инструменты в наличии, под рукой';

  @override
  String get finderIncludeSubstitutions => 'Включить замены';

  @override
  String get finderSubstituting => 'Замена';

  @override
  String finderSubstituteForFood(String substitute, String food) {
    return '$substitute для $food';
  }

  @override
  String get finderMaxMissingIngredients =>
      'Максимальное количество отсутствующих ингредиентов';

  @override
  String get finderMaxMissingTools =>
      'Максимальное количество отсутствующих инструментов';

  @override
  String get finderSelectedTools => 'Выбранные инструменты';

  @override
  String get finderReadyToMake => 'Готово к приготовлению';

  @override
  String get finderAlmostReadyToMake => 'Почти готово к приготовлению';

  @override
  String get finderSettings => 'Настройки';

  @override
  String get finderLoadingRecipes => 'Загрузка рецептов';

  @override
  String get finderClearSelection => 'Снять выделение';

  @override
  String get finderOfflineHint =>
      'Нет связи с сервером – результаты взяты из рецептов, сохранённых на этом устройстве.';

  @override
  String get sendPeerOfflineHint =>
      'Сейчас недоступно – придёт, когда там откроют приложение';

  @override
  String sendDeliveredLater(String device) {
    return '«$device» сейчас недоступно. Рецепт придёт, как только там откроют приложение.';
  }

  @override
  String get sendQueuedOffline =>
      'Сейчас нет подключения. Рецепт отправится автоматически, как только вы снова будете онлайн.';

  @override
  String get searchHasAll => 'Включает все';

  @override
  String get searchHasAny => 'Включает любое';

  @override
  String get recipeFilterTitle => 'Фильтр';

  @override
  String get finderOtherFilters => 'Другие фильтры';

  @override
  String get qfOpEquals => 'равно';

  @override
  String get qfOpNotEquals => 'не равно';

  @override
  String get qfOpGreater => 'больше чем';

  @override
  String get qfOpGreaterEq => 'больше или равно';

  @override
  String get qfOpLess => 'меньше чем';

  @override
  String get qfOpLessEq => 'меньше или равно';

  @override
  String get qfOpNewerThan => 'новее, чем';

  @override
  String get qfOpOlderThan => 'старше чем';

  @override
  String qfDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count дня назад',
      many: '$count дней назад',
      few: '$count дня назад',
      one: '$count день назад',
    );
    return '$_temp0';
  }

  @override
  String get filterResetAll => 'Сбросить все фильтры';

  @override
  String get filterAny => 'Любой';

  @override
  String get filterOfflineIgnored =>
      'Офлайн «Другие фильтры» применяются только в простой форме.';

  @override
  String linkedRecipesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count связанного рецепта',
      many: '$count связанных рецептов',
      few: '$count связанных рецепта',
      one: '$count связанный рецепт',
      zero: 'Нет связанных рецептов',
    );
    return '$_temp0';
  }

  @override
  String get shoppingReminderNotificationsOff =>
      'Уведомления для Mealie Recipes выключены — без них напоминание о покупках не появится. Разрешите уведомления в настройках.';

  @override
  String get shoppingReminderInactiveHint =>
      'Напоминание о покупках сейчас не работает: установите доступ к геолокации «Всегда» и разрешите уведомления.';

  @override
  String get bulkImportTitle => 'Массовый импорт по URL';

  @override
  String get bulkImportDescription =>
      'Массовый импорт рецептов позволяет импортировать сразу несколько рецептов, отдав запросы в очередь и запустив задачу в фоновом режиме. Это может быть полезно при первоначальном переходе на Mealie, или когда вы хотите импортировать большое количество рецептов.';

  @override
  String get bulkAddTitle => 'Массовое добавление';

  @override
  String get bulkImportSetOrganizers => 'Установить категории и теги';

  @override
  String get bulkImportStarted => 'Массовый импорт начался';

  @override
  String get bulkImportFailed => 'Массовый импорт не удался';

  @override
  String get bulkImportReports => 'Массовый импорт';

  @override
  String get bulkImportUrlHint => 'URL-адрес рецепта';

  @override
  String get migrationsTitle => 'Перенос данных';

  @override
  String get migrationsDescription =>
      'Рецепты могут быть перенесены в Mealie из другого поддерживаемого приложения. Это отличный способ начать работу. Перемещение данных между экземплярами Mealie или восстановление более ранней резервной копии производится с помощью инструментов резервного копирования и восстановления.';

  @override
  String get migrationNew => 'Новая миграция';

  @override
  String get migrationChooseType => 'Выберите тип переноса';

  @override
  String get noFileSelected => 'Файл не выбран';

  @override
  String migrationTagAll(String tag) {
    return 'Отметить все рецепты тегом $tag';
  }

  @override
  String get migrationPrevious => 'Предыдущие переносы';

  @override
  String get migrationMealieDescription =>
      'Mealie может импортировать рецепты из приложения версий до 1.0. Экспортируйте рецепты из старого экземпляра, и загрузите zip-файл. Заметьте, что из экспорта могут быть взяты только рецепты. Это относится только к v1.0. Резервная копия, взятая из v1.0 или выше, должна быть восстановлена с помощью инструментов резервного копирования и восстановления.';

  @override
  String get migrationChowdownDescription =>
      'Mealie поддерживает формат chowdown репозитория. Загрузите хранилище кода в формате .zip и загрузите его ниже.';

  @override
  String get migrationCopyMeThatDescription =>
      'Mealie может импортировать рецепты из Copy Me That. Экспортируйте рецепты в формате HTML, затем загрузите .zip ниже.';

  @override
  String get migrationMyRecipeBoxDescription =>
      'Mealie может импортировать рецепты из My Recipe Box. Экспортируйте ваши рецепты в формате CSV, а затем загрузите .csv ниже.';

  @override
  String get migrationNextcloudDescription =>
      'Рецепты Nextcloud могут быть импортированы из zip-файла c данными из Nextcloud. Смотрите пример структуры папок ниже, чтобы убедиться, что ваши рецепты могут быть импортированы.';

  @override
  String get migrationPaprikaDescription =>
      'Mealie может импортировать рецепты из приложения Paprika. Экспортируйте рецепты из paprika, измените расширение для экспорта в .zip и загрузить его ниже.';

  @override
  String get migrationPlanToEatDescription =>
      'Mealie может импортировать рецепты из Plan to Eat.';

  @override
  String get migrationRecipeKeeperDescription =>
      'Mealie может импортировать рецепты из Recipe Keeper. Экспортируйте ваши рецепты в формате zip, а затем загрузите .zip ниже.';

  @override
  String get migrationTandoorDescription =>
      'Mealie может импортировать рецепты из Tandoor. Экспортируйте ваши данные в формате «По умолчанию», затем загрузите .zip ниже.';

  @override
  String get migrationCooknDescription =>
      'Mealie может импортировать рецепты из DVO Cook\'n X3. Экспортируйте книгу рецептов или меню в формате \"Cook\'n\", переименуйте расширение файла экспорта в .zip, затем загрузите .zip ниже.';

  @override
  String get reportTitle => 'Отчет';

  @override
  String get recipeDataTitle => 'Данные рецепта';

  @override
  String get recipeDataDescription =>
      'Используйте этот раздел для управления данными, связанными с вашими рецептами. Вы можете выполнить несколько массовых действий по рецептам, включая экспорт, удаление, пометку и назначение категорий.';

  @override
  String get recipeDataTagTitle => 'Добавить тег к рецептам';

  @override
  String get recipeDataCategorizeTitle => 'Классифицировать рецепты';

  @override
  String get recipeDataSettingsTitle => 'Обновить настройки';

  @override
  String get recipeDataExportTitle => 'Экспортировать рецепты';

  @override
  String get recipeDataDeleteTitle => 'Удалить рецепты';

  @override
  String recipeDataExportConfirm(int count) {
    return 'Будут экспортированы следующие рецепты ($count).';
  }

  @override
  String get recipeDataExportsTitle => 'Экспортированные данные';

  @override
  String get recipeDataExportsDescription =>
      'В этом разделе приведены ссылки на экспортируемые данные, готовые к загрузке. Через некоторое время экспортируемые данные удаляются, поэтому не забудьте скачать их, пока они все еще доступны.';

  @override
  String get recipeDataPurgeExports => 'Очистить экспорты';

  @override
  String get recipeDataPurgeConfirm =>
      'Вы действительно хотите удалить все экспортированные данные?';

  @override
  String get recipeActionsTitle => 'Действия с рецептом';

  @override
  String get recipeActionNew => 'Новое действие с рецептом';

  @override
  String get recipeActionEdit => 'Редактировать действие рецепта';

  @override
  String get recipeActionTypeLink => 'Ссылка';

  @override
  String get recipeActionTypePost => 'Пост';

  @override
  String get webhooksTitle => 'Webhook\'и';

  @override
  String get webhooksDescription =>
      'Webhook\'и определённые ниже будут запущены при установке блюда на день. В установленное время webhook\'и будут отправлены с данными из рецепта установленного на день. Обратите внимание, что время исполнение webhook\'а не точное. Они могут быть отправлены в +/- 5 минутах от указанного времени.';

  @override
  String get webhookName => 'Имя webhook\'а';

  @override
  String get webhookUrl => 'URL вебхука';

  @override
  String get notifiersTitle => 'Уведомления';

  @override
  String get notifiersDescription =>
      'Настройте почту и push-уведомления, которые запускаются при определенных событиях.';

  @override
  String get notifierNew => 'Новое уведомление';

  @override
  String get notifierDescription =>
      'Mealie использует библиотеку Apprise для генерирования уведомлений. Apprise предлагают сервисам многочисленные возможности для использования при создании уведомлений. Обратитесь к их гиду в wiki за подробным руководством по созданию URL для Вашего сервиса. Также при выборе типа уведомления могут стать доступными дополнительные функции.';

  @override
  String get notifierAppriseUrl => 'URL-адрес для уведомлений Apprise';

  @override
  String get notifierAppriseUrlSkipped => 'URL-адрес (пропущен, если пусто)';

  @override
  String get notifierAppriseUrlBlankHint =>
      'Поскольку URL-адреса Apprise обычно содержат конфиденциальную информацию, это поле намеренно остаётся пустым при редактировании. Если вы хотите обновить URL-адрес, введите новый здесь. В противном случае оставьте поле пустым, чтобы сохранить текущий URL-адрес.';

  @override
  String get notifierEnable => 'Включить уведомления';

  @override
  String get notifierWhatEvents =>
      'На какие события следует настроить уведомления?';

  @override
  String get notifierRecipeEvents => 'События Рецепта';

  @override
  String get notifierUserEvents => 'События пользователя';

  @override
  String get notifierMealplanEvents => 'События плана питания';

  @override
  String get notifierShoppingListEvents => 'События списка покупок';

  @override
  String get notifierCookbookEvents => 'События в книге рецептов';

  @override
  String get notifierTagEvents => 'События тегов';

  @override
  String get notifierCategoryEvents => 'События категорий';

  @override
  String get notifierLabelEvents => 'Ярлыки событий';

  @override
  String get notifierUserSignup =>
      'Когда новый пользователь присоединяется к вашей группе';

  @override
  String get notifierCreate => 'Создать';

  @override
  String get notifierUpdate => 'Обновить';

  @override
  String get notifierDelete => 'Удалить';

  @override
  String get notifierTestSent => 'Тестовое сообщение отправлено';

  @override
  String get adminTitle => 'Настройки администратора';

  @override
  String get backupsTitle => 'Резервные копии';

  @override
  String get backupsDescription =>
      'Резервные копии представляют собой полные снапшоты базы данных и каталога данных сайта. Они включают все данные без исключений. По сути, это моментальный снимок Mealie в определенный момент времени. Эти снимки позволяют экспортировать и импортировать данные, а также создавать резервные копии сайта во внешнем хранилище.';

  @override
  String get backupCreateHeading => 'Создать резервную копию';

  @override
  String get backupCreated => 'Резервная копия успешно создана';

  @override
  String get backupCreateFailed =>
      'Ошибка создания резервной копии. Смотрите файл журнала';

  @override
  String get backupDelete => 'Удалить резервную копию';

  @override
  String get backupDeleted => 'Резервная копия удалена';

  @override
  String get backupRestore => 'Восстановить резервную копию';

  @override
  String get backupRestoreDescription =>
      'Восстановление этой резервной копии перезапишет все текущие данные в базе данных и в папке данных содержимым копии. При успешном восстановлении вы будете разлогинены.';

  @override
  String get backupCannotBeUndone =>
      'Это действие нельзя отменить, используйте с осторожностью.';

  @override
  String get backupAcknowledge =>
      'Я понимаю, что это действие является необратимым, разрушительным и может привести к потере данных';

  @override
  String get backupRestoreSuccess => 'Восстановление прошло успешно';

  @override
  String get backupRestoreFailed =>
      'Восстановление не удалось. Проверьте журналы сервера для более подробной информации';

  @override
  String get maintenanceTitle => 'Обслуживание';

  @override
  String get maintenanceSummary => 'Сводка';

  @override
  String get maintenanceStorage => 'Подробности хранилища данных';

  @override
  String get maintenanceDataDirSize => 'Размер папки с данными';

  @override
  String get maintenanceCleanableDirs => 'Удаляемые каталоги';

  @override
  String get maintenanceCleanableImages => 'Удаляемые изображения';

  @override
  String get maintenanceTempDir => 'Временный каталог (.temp)';

  @override
  String get maintenanceBackupsDir => 'Каталог резервных копий (backups)';

  @override
  String get maintenanceGroupsDir => 'Каталог групп (groups)';

  @override
  String get maintenanceRecipesDir => 'Каталог рецептов (recipes)';

  @override
  String get maintenanceUserDir => 'Каталог пользователя (user)';

  @override
  String get maintenanceCleanDirs => 'Очистить каталоги';

  @override
  String get maintenanceCleanDirsDescription =>
      'Удаляет все папки рецептов, не имеющие корректный UUID';

  @override
  String get maintenanceCleanTemp => 'Очистить временные файлы';

  @override
  String get maintenanceCleanTempDescription =>
      'Удаляет все файлы и папки в каталоге .temp';

  @override
  String get maintenanceCleanImages => 'Удалить изображения';

  @override
  String get maintenanceCleanImagesDescription =>
      'Удаляет все изображения, которые не заканчиваются на .webp';

  @override
  String get maintenanceActions => 'Действия';

  @override
  String get adminConfiguration => 'Настройки';

  @override
  String get adminAppVersion => 'Версия приложения';

  @override
  String get adminUpToDate => 'Mealie последней версии';

  @override
  String adminVersionOutdated(String current, String latest) {
    return 'Ваша текущая версия ($current) не совпадает с последним выпуском. Рекомендуем обновиться до последней версии ($latest).';
  }

  @override
  String get adminBaseUrl => 'Базовый URL на стороне сервера';

  @override
  String get adminBaseUrlOk =>
      'Серверный URL-адрес не соответствует значению по умолчанию';

  @override
  String get adminBaseUrlError =>
      '`BASE_URL` все еще является значением по умолчанию на сервере API. Это вызовет проблемы с уведомлениями, ссылками сгенерированными на сервере для электронной почты и т.д.';

  @override
  String adminAuthReady(String provider) {
    return '$provider готов';
  }

  @override
  String adminAuthNotReady(String provider) {
    return '$provider не готов';
  }

  @override
  String adminAuthDisabled(String provider) {
    return '$provider отключён';
  }

  @override
  String adminAuthSuccessText(String provider) {
    return 'Все требуемые переменные $provider установлены.';
  }

  @override
  String adminAuthErrorText(String provider) {
    return 'Не все значения $provider настроены. Можно проигнорировать, если вы не используете аутентификацию $provider.';
  }

  @override
  String adminAuthDisabledText(String envVar) {
    return 'Чтобы включить, установите $envVar в \"true\".';
  }

  @override
  String get adminEmailStatus => 'Статус проверки почты';

  @override
  String get adminEmailConfigured => 'Email настроен';

  @override
  String get adminNotReady => 'Не готово: Проверьте переменные окружения';

  @override
  String get adminSucceeded => 'Выполнено успешно';

  @override
  String get adminFailed => 'Ошибка';

  @override
  String get adminSiteStatistics => 'Статистика сайта';

  @override
  String get adminUncategorized => 'Рецепты без категории';

  @override
  String get adminUntagged => 'Рецепты без меток';

  @override
  String get adminGeneralAbout => 'Общая информация';

  @override
  String get adminVersion => 'Версия';

  @override
  String get adminBuild => 'Сборка';

  @override
  String get adminApplicationMode => 'Статус приложения';

  @override
  String get adminProduction => 'Продуктивная среда';

  @override
  String get adminDevelopment => 'В разработке';

  @override
  String get adminDemoStatus => 'Демо-статус';

  @override
  String get adminDemo => 'Демо';

  @override
  String get adminNotDemo => 'Не демо';

  @override
  String get adminApiPort => 'Порт API';

  @override
  String get adminApiDocs => 'Документация API';

  @override
  String get adminDatabaseType => 'Тип базы данных';

  @override
  String get adminDatabaseUrl => 'URL базы данных';

  @override
  String get adminDefaultGroup => 'Группа по умолчанию';

  @override
  String get adminDefaultHousehold => 'Домохозяйство по умолчанию';

  @override
  String get adminScraperVersion => 'Версия скрейпера рецептов';

  @override
  String get adminStatUsers => 'Пользователи';

  @override
  String get adminStatHouseholds => 'Домохозяйства';

  @override
  String get adminStatGroups => 'Группы';

  @override
  String get recipeDuplicate => 'Повторяющийся рецепт';

  @override
  String get recipeDuplicateAction => 'Создать копию';

  @override
  String get recipeShareLink => 'Поделиться рецептом';

  @override
  String get recipeShareExpiration => 'Дата окончания срока действия';

  @override
  String get recipeShareCopied => 'Ссылка на рецепт скопирована в буфер обмена';

  @override
  String get enabledLabel => 'Включено';

  @override
  String get disabledLabel => 'Отключено';

  @override
  String get testAction => 'Тест';

  @override
  String get yesLabel => 'Да';

  @override
  String get noLabel => 'Нет';

  @override
  String get downloadAction => 'Загрузить';

  @override
  String get backupUpload => 'Загрузить';

  @override
  String get zipImportButton => 'Импорт из архива';

  @override
  String get zipImportDescription =>
      'Импорт одного рецепта, который был экспортирован из другого экземпляра Mealie.';

  @override
  String get reportStatus => 'Статус';

  @override
  String get reportDate => 'Дата';

  @override
  String get recipeActionTitleLabel => 'Оглавление';

  @override
  String get clearAll => 'Очистить';

  @override
  String get recipeDataSettingsExplanation =>
      'Выбранные здесь настройки, исключая заблокированные, будут применены ко всем выбранным рецептам.';

  @override
  String get adminAllowSignup => 'Разрешить регистрацию';

  @override
  String get adminAllowPasswordLogin => 'Разрешить вход по паролю';

  @override
  String get adminEmailInvalid => 'Введите корректный адрес эл. почты.';

  @override
  String adminEmailTestResult(String result) {
    return 'Проверка почты: $result';
  }

  @override
  String get adminSendTestEmail => 'Отправить тестовое письмо';

  @override
  String get adminTestEmailAddress => 'Получатель';

  @override
  String get backupCreate => 'Создать резервную копию';

  @override
  String backupDeleteConfirm(String name) {
    return 'Удалить резервную копию «$name»?';
  }

  @override
  String get backupPostgresNote =>
      'Если вы используете PostgreSQL, перед восстановлением прочитайте порядок резервного копирования/восстановления в документации Mealie.';

  @override
  String get backupUploaded => 'Резервная копия загружена';

  @override
  String get backupsEmpty => 'Резервных копий пока нет.';

  @override
  String get bulkImportAddRow => 'Добавить URL';

  @override
  String get bulkImportStart => 'Начать импорт';

  @override
  String get chooseFileButton => 'Выбрать файл';

  @override
  String get deselectAllAction => 'Снять выбор';

  @override
  String get downloadFailed => 'Не удалось скачать';

  @override
  String get fileSaved => 'Файл сохранён';

  @override
  String get loadFailed => 'Не удалось загрузить';

  @override
  String get maintenanceActionsWarning =>
      'Действия обслуживания разрушительны и требуют осторожности. Любое из них необратимо.';

  @override
  String get maintenanceConfirm =>
      'Это действие разрушительно и не может быть отменено. Продолжить?';

  @override
  String get maintenanceDone => 'Готово';

  @override
  String get maintenanceFailed => 'Действие обслуживания не удалось';

  @override
  String get maintenanceRun => 'Запустить';

  @override
  String get migrationFailed => 'Миграция не удалась';

  @override
  String get migrationStart => 'Начать миграцию';

  @override
  String get migrationStarted => 'Миграция завершена — см. отчёт ниже.';

  @override
  String get moreImportOptions => 'Другие способы импорта';

  @override
  String notifierDeleteConfirm(String name) {
    return 'Удалить уведомитель «$name»?';
  }

  @override
  String get notifierEdit => 'Изменить уведомитель';

  @override
  String notifierEventCount(int count) {
    return 'События: $count';
  }

  @override
  String get notifierTestFailed => 'Не удалось отправить тестовое сообщение';

  @override
  String get notifiersEmpty => 'Уведомителей пока нет.';

  @override
  String recipeActionDeleteConfirm(String name) {
    return 'Удалить действие рецепта «$name»?';
  }

  @override
  String get recipeActionFailed => 'Действие рецепта не удалось';

  @override
  String get recipeActionSent => 'Рецепт отправлен';

  @override
  String get recipeActionUrlHint => 'Заполнители';

  @override
  String get recipeActionsDescription =>
      'Действия рецептов появляются в меню каждого рецепта. «Ссылка» открывает URL, «Post» поручает серверу Mealie отправить рецепт по URL.';

  @override
  String get recipeActionsEmpty => 'Действий рецептов пока нет.';

  @override
  String recipeDataDeleteConfirm(int count) {
    return 'Удалить выбранные рецепты ($count)? Это действие нельзя отменить.';
  }

  @override
  String recipeDataDeleteForbidden(int count) {
    return 'Вы не можете удалить $count из выбранных рецептов (это может только их автор или администратор).';
  }

  @override
  String recipeDataDeleted(int count) {
    return 'Удалено рецептов: $count';
  }

  @override
  String get recipeDataExportAction => 'Экспортировать';

  @override
  String get recipeDataExportDone =>
      'Экспорт создан — скачайте его в разделе «Экспорт данных».';

  @override
  String recipeDataExportExpires(String date) {
    return 'истекает $date';
  }

  @override
  String get recipeDataExportFailed => 'Экспорт не удался';

  @override
  String get recipeDataExportsEmpty => 'Нет доступных экспортов.';

  @override
  String recipeDataUpdated(int count) {
    return 'Обновлено рецептов: $count';
  }

  @override
  String get recipeDuplicated => 'Рецепт дублирован';

  @override
  String get recipeExportJson => 'Экспорт в JSON';

  @override
  String get recipeExportZip => 'Экспорт в ZIP (с изображением)';

  @override
  String get recipeShareCreate => 'Создать ссылку';

  @override
  String get recipeShareDescription =>
      'Любой, у кого есть ссылка, может просматривать этот рецепт в браузере — без учётной записи — пока ссылка не истечёт.';

  @override
  String get recipeShareEmpty => 'Ссылок для общего доступа пока нет.';

  @override
  String recipeShareExpiresAt(String date) {
    return 'Истекает $date';
  }

  @override
  String get recipeWebToolsMenu => 'Дублировать, ссылка и другое';

  @override
  String get reload => 'Обновить';

  @override
  String get reportDeleteConfirm => 'Удалить этот отчёт?';

  @override
  String get reportEntries => 'Записи';

  @override
  String get reportFailedEntries => 'Ошибка';

  @override
  String get reportOnlyFailed => 'Показывать только неудачные записи';

  @override
  String get reportStatusFailure => 'Ошибка';

  @override
  String get reportStatusInProgress => 'Выполняется';

  @override
  String get reportStatusPartial => 'Частично';

  @override
  String get reportStatusSuccess => 'Успешно';

  @override
  String get reportsEmpty => 'Отчётов пока нет.';

  @override
  String get uploadFailed => 'Ошибка загрузки';

  @override
  String webhookDeleteConfirm(String name) {
    return 'Удалить вебхук «$name»?';
  }

  @override
  String get webhookEdit => 'Изменить вебхук';

  @override
  String get webhookNew => 'Новый вебхук';

  @override
  String get webhookTestFailed => 'Не удалось запустить проверку';

  @override
  String get webhookTestSent => 'Тестовый вебхук запущен';

  @override
  String get webhookTime => 'Время (местное)';

  @override
  String get webhooksEmpty => 'Вебхуков пока нет.';

  @override
  String get zipImportFailed => 'Импорт ZIP не удался';

  @override
  String get aiProvidersTitle => 'Провайдеры ИИ';

  @override
  String get aiProvidersDescription =>
      'Настройте провайдеров ИИ для включения функций ИИ, таких как расширенный анализ ингредиентов, создание рецептов из видео и многое другое!';

  @override
  String get aiProviderSettingsTitle => 'Настройки провайдера ИИ';

  @override
  String get aiProvidersList => 'Провайдеры';

  @override
  String get aiProviderCreate => 'Создать провайдера';

  @override
  String get aiProviderEdit => 'Редактировать провайдера';

  @override
  String get aiDefaultProvider => 'Провайдер по умолчанию';

  @override
  String get aiDefaultProviderDescription =>
      'Требуется для включения функций ИИ';

  @override
  String get aiAudioProvider => 'Провайдер для аудио';

  @override
  String get aiAudioProviderDescription =>
      'Включает функции аудио транскрипции, такие как создание рецептов из видео';

  @override
  String get aiImageProvider => 'Провайдер для изображений';

  @override
  String get aiImageProviderDescription =>
      'Включает функции распознавания изображений, такие как создание рецептов из изображений';

  @override
  String get aiProviderName => 'Название провайдера';

  @override
  String get aiApiKey => 'API ключ';

  @override
  String get aiApiKeyCreateDescription =>
      'API ключ вашего провайдера для аутентификации. Если ваш сервис (например, Ollama) не использует API ключ, вам всё равно нужно что-то написать здесь.';

  @override
  String get aiApiKeyEditDescription =>
      'Оставьте поле пустым, если вы не хотите изменить его.';

  @override
  String get aiBaseUrl => 'Базовый URL';

  @override
  String get aiBaseUrlDescription =>
      'Если вы используете OpenAI, оставьте это поле пустым. Должно быть OpenAI-совместимым (например \"http://localhost:11434/v1\").';

  @override
  String get aiModel => 'Модель';

  @override
  String get aiModelDescription =>
      'Какую модель должен использовать ИИ помощник (например, \"gpt-5\").';

  @override
  String get aiTimeout => 'Запросите таймаут (в секундах)';

  @override
  String get aiProviderCreated => 'Помощник создан';

  @override
  String get aiProviderUpdated => 'Помощник обновлён';

  @override
  String get aiProviderDeleted => 'Помощник удалён';

  @override
  String get aiProviderCreateFailed => 'Не удалось создать помощника';

  @override
  String get aiProviderUpdateFailed => 'Не удалось обновить помощника';

  @override
  String get aiProviderDeleteFailed => 'Не удалось удалить помощника';

  @override
  String get aiRequestHeaders => 'Заголовки';

  @override
  String get aiRequestParams => 'Параметры запроса';

  @override
  String get aiNoDefaultWarning =>
      'Вы не установили провайдера по умолчанию, поэтому функции ИИ отключены';

  @override
  String get aiTestConnection => 'Проверка подключения';

  @override
  String get aiTestSucceeded => 'Соединение установлено';

  @override
  String get aiTestFailed => 'Подключиться не удалось';

  @override
  String get aiSupportsImages => 'Поддержка изображений';

  @override
  String get aiTextOnly =>
      'Только текст, не может быть вашим провайдером изображений';

  @override
  String get debugAiTitle => 'Отладка провайдеров ИИ';

  @override
  String get debugAiDescription =>
      'Используйте эту страницу для отладки служб ИИ. Вы можете проверить подключение к ИИ и посмотреть результаты здесь. Если у Вас включены службы изображений, Вы также можете загрузить изображение.';

  @override
  String get debugParserTitle => 'Парсер';

  @override
  String get debugParserDescription =>
      'Mealie использует условные случайные поля (CRFs) для анализа и обработки ингредиентов. Модель, используемая для ингредиентов, основана на наборе данных, содержащих более 100 000 ингредиентов, собранным New York Times. Обратите внимание, что из-за обучения модели только на английском языке результаты могут отличаться на других языках. Эта страница является игровой площадкой для проверки модели.';

  @override
  String get debugIngredientText => 'Описание ингредиента';

  @override
  String get debugTryExample => 'Попробуйте пример';

  @override
  String debugAverageConfidence(String value) {
    return 'Уверенность $value';
  }

  @override
  String get debugRunTest => 'Запустить тест';

  @override
  String get debugQuantity => 'Количество';

  @override
  String get debugUnit => 'Единица измерения';

  @override
  String get debugFood => 'Продукты';

  @override
  String get debugNote => 'Комментарий';

  @override
  String get debugGroup => 'Группа';

  @override
  String get aiProviderNone => 'Ничего';

  @override
  String aiProviderDeleteConfirm(String name) {
    return 'Удалить провайдера «$name»?';
  }

  @override
  String get aiProvidersEmpty => 'ИИ-провайдеров пока нет.';

  @override
  String get aiAdvanced => 'Дополнительно';

  @override
  String get aiKeyLabel => 'Название';

  @override
  String get aiValueLabel => 'Значение';

  @override
  String get debugTitle => 'Отладка';

  @override
  String get debugParse => 'Обработать';

  @override
  String get debugParseFailed => 'Не удалось разобрать ингредиент';

  @override
  String get debugChooseImage => 'Выбрать изображение';

  @override
  String get debugNoImage => 'Без изображения (необязательно)';

  @override
  String get updateTitle => 'Проверка обновлений';

  @override
  String get updateInstalledVersion => 'Установленная версия';

  @override
  String get updateLastCheck => 'Последняя проверка';

  @override
  String get updateCheckNow => 'Проверить сейчас';

  @override
  String get updateChecking => 'Поиск обновлений…';

  @override
  String get updateUpToDate => 'Mealie Recipes обновлён.';

  @override
  String updateAvailable(String version) {
    return 'Доступна версия $version';
  }

  @override
  String get updateAvailableDescription =>
      'Доступна новая версия Mealie Recipes. Ничего не установится, пока вы сами не запустите обновление.';

  @override
  String get updateShow => 'Показать обновление';

  @override
  String get updateLater => 'Позже';

  @override
  String updateDownloading(int percent) {
    return 'Загрузка … $percent %';
  }

  @override
  String updateReady(String version) {
    return 'Версия $version готова к установке';
  }

  @override
  String get updateInstalling =>
      'Установка — приложение перезапустится автоматически …';

  @override
  String get updateManual =>
      'Не удалось установить обновление автоматически. Образ диска открыт: перетащите Mealie Recipes в «Программы».';

  @override
  String get updateFailed => 'Обновление не удалось';

  @override
  String get updateInstallNow => 'Скачать и установить';

  @override
  String get updateRestartNow => 'Установить и перезапустить';

  @override
  String get updateAutoTitle => 'Проверять обновления при запуске';

  @override
  String get updateAutoDescription =>
      'Только проверяет и уведомляет — установку вы всегда запускаете сами.';

  @override
  String get updateBetaTitle => 'Получать бета-версии';

  @override
  String get updateBetaDescription =>
      'Также предлагает предварительные версии для тестирования. В них ещё могут быть ошибки.';

  @override
  String get updateNoNotes => 'Нет примечаний к выпуску.';

  @override
  String get updateSourceHint =>
      'Обновления берутся из релизов Mealie Recipes на GitHub и устанавливаются, только если подписаны разработчиком (macOS).';

  @override
  String get errorNoConnection =>
      'Не удаётся связаться с сервером Mealie. Проверьте подключение к интернету и адрес сервера.';

  @override
  String get errorTimeout =>
      'Сервер слишком долго не отвечал. Попробуйте ещё раз.';

  @override
  String get errorUnauthorized =>
      'Срок входа истёк или API-токен больше не действует. Войдите снова в настройках.';

  @override
  String get errorServer =>
      'Сервер Mealie сообщил об ошибке. Попробуйте позже.';

  @override
  String get errorNotFound => 'Не найдено на сервере — возможно, удалено.';

  @override
  String get errorCertificate =>
      'Сертификат безопасности сервера не является доверенным.';

  @override
  String get errorGeneric => 'Что-то пошло не так. Попробуйте ещё раз.';

  @override
  String get offlineLabel => 'Офлайн';

  @override
  String offlineSince(String time) {
    return 'Офлайн · последняя синхронизация $time';
  }

  @override
  String get mealplanEntryActions => 'Параметры блюда';

  @override
  String get mealplanMoveAction => 'Переместить';

  @override
  String get mealplanMoveTitle => 'Переместить блюдо';

  @override
  String get mealplanMoveDate => 'Дата';

  @override
  String mealplanMovedTo(String date) {
    return 'Перемещено на $date';
  }

  @override
  String get mealplanShowWeek => 'Показать';

  @override
  String get mealplanMoveFailed => 'Не удалось переместить блюдо';

  @override
  String get recentlyViewedTitle => 'Недавно просмотренные';

  @override
  String get recentlyViewedEmpty => 'Здесь появятся открытые вами рецепты.';

  @override
  String get recentlyViewedClear => 'Очистить историю';

  @override
  String get recentlyViewedClearMessage =>
      'Список недавно просмотренных рецептов на этом устройстве будет очищен. Сами рецепты останутся.';

  @override
  String get recentlyViewedClearConfirm => 'Очистить';

  @override
  String get duplicatesTitle => 'Поиск дубликатов';

  @override
  String get duplicatesScanning => 'Поиск дублирующихся рецептов…';

  @override
  String get duplicatesNone => 'Дублирующихся рецептов не найдено.';

  @override
  String duplicatesFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Найдено $count возможного дубликата.',
      many: 'Найдено $count возможных дубликатов.',
      few: 'Найдено $count возможных дубликата.',
      one: 'Найден $count возможный дубликат.',
    );
    return '$_temp0';
  }

  @override
  String get duplicatesIntro =>
      'Нажмите на рецепт, который нужно оставить, затем объедините.';

  @override
  String get duplicatesReasonSource => 'Тот же источник';

  @override
  String get duplicatesReasonName => 'То же название';

  @override
  String duplicatesReasonSimilar(int percent) {
    return 'Похоже · $percent % одинаковых ингредиентов';
  }

  @override
  String get duplicatesKeeps => 'Остаётся';

  @override
  String get duplicatesWillBeDeleted => 'Будет удалён';

  @override
  String get duplicatesMerge => 'Объединить';

  @override
  String get duplicatesNotDuplicate => 'Не дубликат';

  @override
  String get duplicatesMergeTitle => 'Объединить рецепты?';

  @override
  String duplicatesMergeMessage(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Будут удалены $count другого рецепта',
      many: 'Будут удалены $count других рецептов',
      few: 'Будут удалены $count других рецепта',
      one: 'Будет удалён $count другой рецепт',
    );
    return '«$name» остаётся. $_temp0.\n\nКатегории, теги, инструменты, заметки, запланированные блюда вашего домохозяйства и ваше избранное переносятся. Комментарии, история и файлы удаляемых рецептов теряются.';
  }

  @override
  String get duplicatesMerged => 'Рецепты объединены';

  @override
  String duplicatesIngredientCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ингредиента',
      many: '$count ингредиентов',
      few: '$count ингредиента',
      one: '$count ингредиент',
    );
    return '$_temp0';
  }

  @override
  String duplicatesResetIgnored(int count) {
    return 'Снова показать скрытые пары ($count)';
  }

  @override
  String get duplicatesRescan => 'Искать снова';

  @override
  String get duplicatesOpenRecipe => 'Открыть рецепт';

  @override
  String get duplicatesMergeNoEditHint =>
      'Вы не можете изменить остающийся рецепт (чужой заблокированный рецепт или из другого домохозяйства). Поэтому его категории, теги, инструменты и заметки остаются как есть; переносятся только запланированные блюда и ваше избранное.';

  @override
  String get recipeOtherHouseholdHint =>
      'Из другого домохозяйства – изменение там заблокировано';

  @override
  String foodsSavedAsNote(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count нового продукта сохранены',
      many: '$count новых продуктов сохранены',
      few: '$count новых продукта сохранены',
      one: '$count новый продукт сохранён',
    );
    return 'Сохранено. $_temp0 как примечание к ингредиенту – для создания продуктов нужно право «Пользователь может управлять продуктами, тегами и категориями» в Mealie.';
  }

  @override
  String get a11yRemove => 'Удалить';

  @override
  String get a11yDecrease => 'Меньше';

  @override
  String get a11yIncrease => 'Больше';

  @override
  String get a11yShowPassword => 'Показать пароль';

  @override
  String get a11yHidePassword => 'Скрыть пароль';

  @override
  String get a11yClearSearch => 'Очистить поиск';

  @override
  String get notesQueuedOffline =>
      'Офлайн – заметка будет отправлена, как только сервер снова станет доступен.';

  @override
  String get timelineQueuedOffline =>
      'Офлайн – запись будет добавлена в историю, как только сервер снова станет доступен.';

  @override
  String get syncSectionName => 'Переименовано';

  @override
  String get pendingRecipesDiscard => 'Отклонить';

  @override
  String get undo => 'Отмена';

  @override
  String timerStoppedSnack(String name) {
    return 'Таймер «$name» остановлен';
  }

  @override
  String get cookFriendsEndConfirm =>
      'Завершить сессию для всех? Все гости будут отключены.';

  @override
  String get weekStartSyncHint =>
      'Сохранено в Mealie – действует для всего домохозяйства, в том числе в веб-приложении.';

  @override
  String get weekStartNoPermission =>
      'Задаётся в Mealie вашим домохозяйством. Изменить могут только участники, которым разрешено управлять домохозяйством.';

  @override
  String get assetsUnsupported329 =>
      'Mealie поддерживает PDF, изображения, видео (MP4, MOV, WebM), аудио (MP3, M4A), Word/ODT/RTF, TXT, MD, CSV и JSON.';

  @override
  String get assetsRecordVideo => 'Записать видео';

  @override
  String get assetsChooseVideo => 'Выбрать видео';

  @override
  String get shoppingSearchHint => 'Поиск в этом списке';

  @override
  String get shoppingSearchNoMatches => 'Нет позиций, соответствующих поиску.';

  @override
  String get mealplanServingsTitle => 'Запланированные порции';

  @override
  String get mealplanServingsHint =>
      'Только для этой записи плана питания — сам рецепт не меняется. При открытии рецепта и добавлении в список покупок используются эти порции.';

  @override
  String get calendarFeedTitle => 'Подписаться на календарь';

  @override
  String get calendarFeedSubtitle =>
      'Показывать план питания в Google, Apple или любом другом календаре';

  @override
  String get calendarFeedDescription =>
      'Подпишитесь на план питания вашего домохозяйства в Google Calendar, Apple Calendar, Home Assistant или любом другом приложении, которое поддерживает ссылки iCal. Любой, у кого есть ссылка, увидит ваш план питания.';

  @override
  String get calendarFeedOff =>
      'Ссылка на календарь отключена для вашего домохозяйства.';

  @override
  String get calendarFeedAskManager =>
      'Попросите того, кто может управлять вашим домохозяйством, включить её.';

  @override
  String get calendarFeedTurnOn => 'Включить';

  @override
  String get calendarFeedTurnOff => 'Выключить';

  @override
  String get calendarFeedReset => 'Сбросить ссылку';

  @override
  String get calendarFeedResetHint =>
      'Сброс или отключение ссылки останавливает обновление существующих подписок.';

  @override
  String get calendarFeedIncludeNotes => 'Включать заметки';

  @override
  String get calendarFeedTimesHint =>
      'Нажмите на приём пищи, чтобы задать время. Приёмы пищи без времени показываются как события на весь день.';

  @override
  String get calendarFeedMealTypes => 'Тип блюда';

  @override
  String get calendarFeedSubscribe => 'Подписаться в календаре';

  @override
  String get calendarFeedNoApp =>
      'Не удалось открыть приложение календаря. Скопируйте ссылку и добавьте её в календарь как подписку.';

  @override
  String get calendarFeedPublicHint =>
      'Ссылка работает без входа — делитесь ею только с теми, кому можно видеть ваш план питания.';

  @override
  String get recipeShareLinkMenu => 'Ссылка и QR-код';

  @override
  String get recipeShareShowQr => 'Показать QR-код';

  @override
  String get recipeShareScanQr =>
      'Отсканируйте камерой телефона, чтобы открыть этот рецепт';

  @override
  String get recipeShareQrShare => 'Поделиться изображением';

  @override
  String get recipeShareQrFailed => 'Не удалось создать изображение QR-кода';

  @override
  String get mealplanSettingsTitle => 'Настройки плана питания';

  @override
  String get mealDiceRulesTitle => 'Правила кубика';

  @override
  String saveAsNewFood(String name) {
    return 'Сохранить «$name» как новый продукт';
  }

  @override
  String get shoppingMoreOptions => 'Больше параметров';

  @override
  String get shoppingFewerOptions => 'Меньше параметров';

  @override
  String nameAlreadyExists(String name) {
    return 'Уже существует: $name';
  }

  @override
  String aliasBelongsTo(String alias, String name) {
    return '«$alias» уже принадлежит «$name» — лучше объединить их.';
  }

  @override
  String get recipeMatchTitle => 'Recipe Match';

  @override
  String get recipeMatchShuffle => 'Перемешать';

  @override
  String recipeMatchCardsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count рецепта в колоде',
      many: '$count рецептов в колоде',
      few: '$count рецепта в колоде',
      one: '$count рецепт в колоде',
    );
    return '$_temp0';
  }

  @override
  String get recipeMatchNext => 'Следующее';

  @override
  String get recipeMatchKeep => 'На поднос';

  @override
  String get recipeMatchKept => 'Положено на поднос';

  @override
  String get recipeMatchAnyTime => 'Любая длительность';

  @override
  String recipeMatchMaxTime(int minutes) {
    return '≤ $minutes мин';
  }

  @override
  String get recipeMatchEmpty => 'Нет подходящих рецептов';

  @override
  String get recipeMatchEmptyHint => 'Измените фильтры или очистите поднос.';

  @override
  String get recipeMatchResetFilters => 'Сбросить фильтры';

  @override
  String get recipeMatchFlipHint => 'Нажмите: ингредиенты · инструкции';

  @override
  String get recipeMatchFlipBack => 'Перевернуть обратно';

  @override
  String get recipeMatchOpenRecipe => 'Весь рецепт';

  @override
  String get recipeMatchOnHand => 'в наличии';

  @override
  String get recipeMatchTray => 'Поднос';

  @override
  String get recipeMatchTrayEmpty => 'Пока пусто – перетащите карточку вниз';

  @override
  String recipeMatchTrayCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count рецепта',
      many: '$count рецептов',
      few: '$count рецепта',
      one: '$count рецепт',
    );
    return '$_temp0';
  }

  @override
  String get recipeMatchClear => 'Очистить';

  @override
  String get recipeMatchTrayHint =>
      'Остаётся, пока вы его не очистите, – даже если закрыть колоду.';

  @override
  String get recipeMatchRemove => 'Убрать с подноса';

  @override
  String get recipeMatchToMealplan => 'Добавить в план питания';

  @override
  String get recipeMatchToShopping => 'Ингредиенты в список покупок';

  @override
  String get recipeMatchSelectIngredients => 'Выбрать ингредиенты';

  @override
  String get recipeMatchNoList => 'Сначала выберите список покупок.';

  @override
  String get recipeMatchList => 'Список';

  @override
  String get recipeMatchOnHandHint =>
      'Ингредиенты в наличии уже сняты с выбора.';

  @override
  String recipeMatchAddCount(int selected, int total) {
    return 'Добавить $selected из $total ингредиентов';
  }

  @override
  String get recipeMatchNoDay => 'День не выбран – остаётся на подносе';

  @override
  String recipeMatchAddMeals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Добавить $count блюда',
      many: 'Добавить $count блюд',
      few: 'Добавить $count блюда',
      one: 'Добавить $count блюдо',
    );
    return '$_temp0';
  }

  @override
  String recipeMatchMealsAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Добавлено $count блюда',
      many: 'Добавлено $count блюд',
      few: 'Добавлено $count блюда',
      one: 'Добавлено $count блюдо',
    );
    return '$_temp0';
  }

  @override
  String get recipeMatchSwipeUp => 'Проведите вверх, чтобы открыть поднос';

  @override
  String get weekPlannerTitle => 'Спланировать неделю';

  @override
  String get weekPlannerStepDays => 'Дни';

  @override
  String get weekPlannerStepPrefs => 'Настройки';

  @override
  String get weekPlannerStepPreview => 'Просмотр';

  @override
  String get weekPlannerDaysTitle => 'Какие приёмы пищи заполнить?';

  @override
  String get weekPlannerDaysHint =>
      'Нажимайте на ячейки. Уже запланированное останется как есть.';

  @override
  String get weekPlannerPresetWeekdays => 'Будни';

  @override
  String get weekPlannerPlanned => 'запланировано';

  @override
  String get weekPlannerMoreMeals => 'Показать больше приёмов пищи';

  @override
  String get weekPlannerFewerMeals => 'Меньше приёмов пищи';

  @override
  String weekPlannerMealCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count приёма пищи',
      many: '$count приёмов пищи',
      few: '$count приёма пищи',
      one: '$count приём пищи',
    );
    return '$_temp0';
  }

  @override
  String get weekPlannerPrefsTitle => 'На что обратить внимание?';

  @override
  String get weekPlannerPrefsHint =>
      'Всё необязательно – без выбора приложение подберёт разнообразную смесь ваших рецептов.';

  @override
  String get weekPlannerQuick => 'Быстро в будни';

  @override
  String weekPlannerQuickSub(int minutes) {
    return 'Пн–Пт не более $minutes мин';
  }

  @override
  String get weekPlannerStale => 'Сначала давно не готовленные';

  @override
  String get weekPlannerStaleSub =>
      'по «последнему приготовлению» и плану питания';

  @override
  String get weekPlannerFavorites => 'Чаще планировать избранное';

  @override
  String get weekPlannerFavoritesSub => 'рецепты с сердечком и высокой оценкой';

  @override
  String get weekPlannerVariety => 'Разнообразие';

  @override
  String get weekPlannerVarietySub => 'ни одной категории два раза подряд';

  @override
  String get weekPlannerOnlyFrom => 'Только из';

  @override
  String get weekPlannerDiceRules => 'Использовать правила кубика';

  @override
  String get weekPlannerDiceRulesSub =>
      'ваш выбор для каждого приёма пищи из настроек плана питания';

  @override
  String weekPlannerMatching(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count подходящего рецепта',
      many: '$count подходящих рецептов',
      few: '$count подходящих рецепта',
      one: '$count подходящий рецепт',
    );
    return '$_temp0';
  }

  @override
  String weekPlannerForMeals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'на $count приёма пищи',
      many: 'на $count приёмов пищи',
      few: 'на $count приёма пищи',
      one: 'на $count приём пищи',
    );
    return '$_temp0';
  }

  @override
  String get weekPlannerSuggest => 'Предложить';

  @override
  String get weekPlannerPreviewHint =>
      'Кубик меняет, замок сохраняет. Удерживайте блюдо и перетащите на другой день, чтобы поменять их местами.';

  @override
  String get weekPlannerRerollAll => 'Перебросить всё';

  @override
  String get weekPlannerReroll => 'Перебросить';

  @override
  String get weekPlannerLock => 'Закрепить';

  @override
  String get weekPlannerUnlock => 'Открепить';

  @override
  String get weekPlannerReasonNever => 'ещё не готовили';

  @override
  String get weekPlannerReasonStale => 'давно не готовили';

  @override
  String get weekPlannerReasonFavorite => 'Избранное';

  @override
  String get weekPlannerNoMatch => 'Нет подходящего рецепта';

  @override
  String get weekPlannerThenShopping =>
      'Затем выбрать ингредиенты для списка покупок';

  @override
  String get weekPlannerMostlyEmpty => 'Неделя почти пуста';

  @override
  String weekPlannerMostlyEmptySub(int free, int total) {
    return 'Свободно $free из $total дней – заполните их за три шага.';
  }

  @override
  String get previousWeek => 'Предыдущая неделя';

  @override
  String get nextWeek => 'Следующая неделя';

  @override
  String get weekPlannerAllDays => 'Все дни';

  @override
  String get weekPlannerWeekend => 'Выходные';

  @override
  String get weekPlannerDinners => 'Ужины';

  @override
  String get weekPlannerLunches => 'Обеды';

  @override
  String get weekPlannerAllMeals => 'Все приёмы пищи';

  @override
  String get mealplanDayEmpty => 'Ничего не запланировано';

  @override
  String get mealplanDropHere => 'Перетащите сюда';

  @override
  String mealplanDayKcal(String kcal) {
    return '$kcal ккал на порцию';
  }

  @override
  String mealplanDayKcalPartial(String kcal) {
    return 'не менее $kcal ккал на порцию';
  }

  @override
  String get globalSearchHint => 'Поиск рецептов, позиций, функций …';

  @override
  String get globalSearchIntro =>
      'Ищите рецепты, позиции списка покупок, продукты и книги рецептов – а также функции и настройки приложения, например «список».';

  @override
  String get globalSearchFunctions => 'Функции';

  @override
  String globalSearchNoResults(String query) {
    return 'Нет результатов для «$query»';
  }

  @override
  String get searchClear => 'Очистить поиск';

  @override
  String get recipeMatchPlanWeek => 'Спланировать неделю с этими рецептами';

  @override
  String get weekPlannerReasonTray => 'с подноса';

  @override
  String get emptyBrowseRecipes => 'Просмотреть рецепты';

  @override
  String get mealplanWeekShopping => 'Ингредиенты на эту неделю';

  @override
  String get globalSearchActions => 'Действия';

  @override
  String globalSearchAddToList(String text) {
    return 'Добавить «$text» в список покупок';
  }

  @override
  String globalSearchAdded(String text) {
    return '«$text» добавлено';
  }

  @override
  String get globalSearchImportUrl => 'Импортировать рецепт с этого адреса';

  @override
  String get homeContinueCooking => 'Продолжить готовить';

  @override
  String homeCookingStep(int step, int total) {
    return 'Шаг $step из $total';
  }

  @override
  String get homeCookingPrep => 'Подготовка';

  @override
  String get homeCookingAlmostDone => 'Почти готово';

  @override
  String get homeCookingContinue => 'продолжить';

  @override
  String get paneSelectRecipe => 'Выберите рецепт слева.';

  @override
  String get mealplanDragRecipeHint =>
      'Перетащите рецепт на день, чтобы запланировать его.';

  @override
  String get desktopDropUnsupported =>
      'Эти файлы нельзя добавить как вложения.';

  @override
  String desktopDropUploaded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Добавлено $count вложения',
      many: 'Добавлено $count вложений',
      few: 'Добавлено $count вложения',
      one: 'Добавлено $count вложение',
    );
    return '$_temp0';
  }

  @override
  String get desktopDropAsAttachment =>
      'Отпустите, чтобы добавить как вложение';

  @override
  String get printAction => 'Печать';

  @override
  String get mealplanPrintWeek => 'Печать недели';

  @override
  String get mealplanEntryCooked => 'Приготовлено';

  @override
  String get recipeSearchClear => 'Очистить поиск';

  @override
  String get organizerShowRecipes => 'Показать рецепты';

  @override
  String globalSearchShowAllRecipes(int count) {
    return 'Показать все рецепты ($count)';
  }

  @override
  String get unnamedEntry => '(без названия)';

  @override
  String get mealplanWholeWeek => 'На всю неделю';

  @override
  String get mealplanWholeWeekDropHint =>
      'Перетащите сюда блюдо, чтобы запланировать его на всю неделю.';

  @override
  String get mealplanMovedToWholeWeek => 'Запланировано на всю неделю';

  @override
  String get mealplanCookToday => 'Готовлю сегодня';

  @override
  String get mealplanPlanWholeWeek => 'План на всю неделю';

  @override
  String mealplanPlanWholeWeekRange(String from, String to) {
    return '$from – $to';
  }

  @override
  String get calendarFeedDuration => 'Длительность (мин)';

  @override
  String get calendarFeedEventDetails => 'Детали события';

  @override
  String calendarFeedEventDetailsHint(String fields) {
    return 'Настройте, как блюда отображаются в календаре. Поля подстановки: $fields';
  }

  @override
  String get calendarFeedEventTitle => 'Название события';

  @override
  String get calendarFeedEventDescription => 'Описание события';

  @override
  String get calendarFeedEventDetailsWarning =>
      'Изменение этих полей меняет ссылку на календарь — если вы уже подписаны, подпишитесь снова по новой ссылке.';

  @override
  String get stepDurationMinutes => 'Длительность (мин)';

  @override
  String stepDurationSaved(String duration) {
    return 'Сохранённая длительность: $duration. При изменении она заменится целыми минутами.';
  }

  @override
  String get sortTotalTimeShort => 'Наименьшее общее время';

  @override
  String get sortTotalTimeLong => 'Наибольшее общее время';

  @override
  String recipeCreatedBy(String name) {
    return 'Автор: $name';
  }

  @override
  String get timelineReplacePhoto => 'Заменить фото';

  @override
  String get pasteRecipeTitle => 'Вставить рецепт';

  @override
  String get pasteRecipeDescription =>
      'Вставьте рецепт в формате JSON (schema.org) или HTML-код веб-страницы.';

  @override
  String get pasteRecipeDescription330 =>
      'Вставьте рецепт, экспортированный из Mealie (JSON), — он импортируется с полной структурой: продукты, единицы и связи шагов. Также подходят JSON (schema.org) и HTML-код веб-страницы.';

  @override
  String get pasteRecipeHint => 'Вставьте сюда JSON или HTML';

  @override
  String get pasteRecipeButton => 'Вставить рецепт';

  @override
  String get pasteRecipeImport => 'Импортировать';

  @override
  String get aiPromptsTitle => 'Промпты ИИ';

  @override
  String get aiPromptsTeaser =>
      'Настройте инструкции, которые Mealie даёт ИИ-провайдеру, — для всех задач или для каждой.';

  @override
  String get aiPromptsDescription =>
      'Настройте инструкции, которые Mealie передаёт вашему провайдеру ИИ для каждой задачи. Промпты Mealie написаны на английском, но это не влияет на язык ваших рецептов: они остаются на языке источника, если вы не решите их перевести. Свои инструкции можно писать на любом языке.';

  @override
  String get aiPromptsGlobal => 'Инструкции для всех промптов';

  @override
  String get aiPromptsGlobalDescription =>
      'Добавляются к каждому промпту, который создаёт данные рецепта: при составлении рецептов, разборе ингредиентов и переводе. Системные промпты не затрагиваются.';

  @override
  String get aiPromptsGlobalPlaceholder =>
      'Например: всегда использовать метрические единицы.';

  @override
  String get aiPromptsList => 'Промпты';

  @override
  String get aiPromptSystem => 'Система';

  @override
  String get aiPromptSystemDescription =>
      'Это системный промпт. Он максимально точно переписывает исходный материал, прежде чем тот превратится в рецепт, поэтому инструкции для всех промптов к нему не добавляются. Обычно его менять не нужно: это может снизить надёжность импорта.';

  @override
  String get aiPromptAppended => 'Дополнен';

  @override
  String get aiPromptOverridden => 'Заменён';

  @override
  String get aiPromptModeDefault => 'По умолчанию';

  @override
  String get aiPromptModeAppend => 'Дополнить';

  @override
  String get aiPromptModeOverride => 'Заменить';

  @override
  String get aiPromptAppendDescription =>
      'Эти инструкции добавляются к промпту Mealie и имеют приоритет там, где с ним расходятся.';

  @override
  String get aiPromptOverrideDescription =>
      'Ваш промпт полностью заменяет промпт Mealie, поэтому будущие обновления промпта Mealie к нему применяться не будут. Нужные для задачи данные, например список единиц измерения, по-прежнему добавляются после вашего промпта.';

  @override
  String get aiPromptDefaultChanged =>
      'Промпт Mealie изменился с тех пор, как вы его заменили. Сравните его со своим или вернитесь к промпту по умолчанию, чтобы использовать новую версию.';

  @override
  String get aiPromptViewDefault => 'Показать промпт по умолчанию';

  @override
  String get aiPromptHideDefault => 'Скрыть промпт по умолчанию';

  @override
  String get aiPromptSaved => 'Промпт сохранён';

  @override
  String get aiPromptSaveFailed => 'Не удалось сохранить промпт';

  @override
  String get aiPromptTitleBuildRecipe => 'Создание рецепта';

  @override
  String get aiPromptTitleParseIngredients => 'Разбор ингредиентов';

  @override
  String get aiPromptTitleRecipeVideo => 'Рецепт из видео';

  @override
  String get aiPromptTitleOrganizers =>
      'Подбор тегов, категорий и инструментов';

  @override
  String get aiPromptTitleTranslate => 'Перевод рецепта';

  @override
  String get aiPromptTitleCompileSource => 'Чтение исходного материала';

  @override
  String get aiPromptTitleTranscribe => 'Расшифровка аудио';

  @override
  String get aiPromptDescBuildRecipe =>
      'Превращает исходный материал, считанный с веб-страницы, фото или текста, в структурированный рецепт.';

  @override
  String get aiPromptDescParseIngredients =>
      'Используется при разборе ингредиентов с помощью ИИ, чтобы выделить в каждом ингредиенте количество, единицу измерения, продукт и примечание.';

  @override
  String get aiPromptDescRecipeVideo =>
      'Превращает расшифровку и описание видео в рецепт.';

  @override
  String get aiPromptDescOrganizers =>
      'Подбирает теги, категории и инструменты для импортируемого рецепта.';

  @override
  String get aiPromptDescTranslate =>
      'Переводит импортированный рецепт на выбранный вами язык.';

  @override
  String get aiPromptDescCompileSource =>
      'Превращает содержимое веб-страниц, фото и текста в простую текстовую запись рецепта.';

  @override
  String get aiPromptDescTranscribe =>
      'Расшифровывает аудио, если ваш аудиопровайдер не может сделать это напрямую.';

  @override
  String get mealplanNoteHint => 'Заметка (необязательно)';

  @override
  String get mealplanEditTitle => 'Изменить запись';

  @override
  String get mealplanEntryTitleLabel => 'Оглавление';

  @override
  String get mealplanEntryNoteLabel => 'Заметка';

  @override
  String mealplanCreateRecipe(String name) {
    return 'Новый рецепт «$name»';
  }

  @override
  String get mealplanCreateRecipeSubtitle =>
      'Создаёт пустой рецепт, планирует его и открывает редактор';

  @override
  String get importOptionsTitle => 'Параметры импорта';

  @override
  String get importOptionsHint =>
      'Сколько работы ИИ Mealie выполняет на вашем сервере при импорте. Каждый дополнительный шаг — отдельный запрос к ИИ: чем их меньше, тем быстрее.';

  @override
  String get importTranslateTitle => 'Перевести рецепт';

  @override
  String get importOrganizersTitle => 'Категории и теги';

  @override
  String get importOrganizersCreate => 'Добавлять новые';

  @override
  String get importOrganizersExisting => 'Только существующие';

  @override
  String get importOrganizersNone => 'Ничего';

  @override
  String get importOrganizersCreateHint =>
      'ИИ назначает теги, категории и инструменты и создаёт недостающие.';

  @override
  String get importOrganizersExistingHint =>
      'ИИ использует только уже существующие теги, категории и инструменты.';

  @override
  String get importOrganizersNoneHint =>
      'Рецепт импортируется без тегов, категорий и инструментов. Mealie всё равно выполняет этот шаг, поэтому импорт не ускоряется.';

  @override
  String get importStarting => 'Отправка на сервер…';

  @override
  String get importRunning => 'Импорт рецепта…';

  @override
  String get aiImagesRunning => 'ИИ читает страницы…';

  @override
  String get importStreamPhotosTitle => 'Импорт фото с ходом выполнения';

  @override
  String get importStreamPhotosHint =>
      'Показывает каждый шаг и держит соединение открытым при долгом импорте. Выключите, чтобы загружать одним запросом, как раньше, — например, если ваш прокси блокирует потоковую передачу.';

  @override
  String get weekPlannerDiceRulesMealieSub =>
      'правила Mealie вашего домохозяйства (настройки плана питания)';

  @override
  String get syncStarted =>
      'Перезагрузка рецептов, изображений и списков с сервера…';

  @override
  String get syncDone => 'Всё актуально';

  @override
  String get recipeReloaded => 'Рецепт перезагружен';

  @override
  String get logoutTitle => 'Выйти / сменить пользователя';

  @override
  String get logoutConfirm =>
      'Рецепты, списки и ещё не синхронизированные изменения будут удалены с этого устройства. Настройки приложения и адрес сервера останутся — нужно будет только снова войти.';

  @override
  String get reloadRecipe => 'Перезагрузить с сервера';

  @override
  String get wifiServerTitle => 'Другой адрес в Wi-Fi';

  @override
  String get wifiServerHint =>
      'Для того же сервера под вторым адресом, например локальный IP дома и ZeroTier, Tailscale или домен в дороге. В сети Wi-Fi ниже приложение автоматически использует этот адрес, везде иначе — URL сервера выше.';

  @override
  String get wifiSsidLabel => 'Имя Wi-Fi';

  @override
  String get wifiServerUrl => 'Адрес в этой сети Wi-Fi';

  @override
  String get wifiUseCurrent => 'Использовать текущий Wi-Fi';

  @override
  String get wifiNameUnavailable =>
      'Не удалось прочитать имя Wi-Fi. Подключитесь к Wi-Fi и разрешите доступ к геолокации – Android и iOS раскрывают имя Wi-Fi только с ним.';

  @override
  String wifiServerActive(String ssid) {
    return 'Активно: адрес в Wi-Fi «$ssid»';
  }

  @override
  String wifiServerStandardActive(String ssid) {
    return 'Активно: URL сервера (не в «$ssid»)';
  }

  @override
  String get wifiServerRemove => 'Удалить';

  @override
  String get switchUserTitle => 'Сменить пользователя';

  @override
  String switchUserBody(String name) {
    return '$name остаётся сохранённым на этом устройстве – со всеми рецептами, списками и ещё не синхронизированными изменениями. Вернуться можно через фото профиля или страницу входа.';
  }

  @override
  String get allowBiometricTitle => 'Возвращаться разблокировкой устройства';

  @override
  String get allowBiometricHint =>
      'Face ID, отпечаток или PIN устройства вместо пароля. Любой, кто может разблокировать это устройство, сможет открыть эту учётную запись.';

  @override
  String get allow => 'Разрешить';

  @override
  String unlockAccountReason(String name) {
    return 'Переключиться на $name';
  }

  @override
  String signInAs(String name) {
    return 'Войти как $name';
  }

  @override
  String wrongAccountError(String name) {
    return 'Это учётная запись «$name». Войдите в сохранённую учётную запись.';
  }

  @override
  String get accountSaveOffline =>
      'Сейчас нельзя сохранить учётную запись – сервер недоступен.';

  @override
  String get signOutRemoveTitle => 'Выйти и удалить';

  @override
  String get signOutRemoveConfirm =>
      'Эта учётная запись и все её данные на этом устройстве (рецепты, списки, несинхронизированные изменения) будут удалены. Настройки приложения останутся.';

  @override
  String get removeSavedAccount => 'Удалить с этого устройства';

  @override
  String removeSavedAccountConfirm(String name) {
    return 'Удалить «$name» и все сохранённые данные с этого устройства? Несинхронизированные изменения будут потеряны.';
  }

  @override
  String get savedAccountsTitle => 'Сохранённые учётные записи';

  @override
  String get addAccount => 'Добавить учётную запись';

  @override
  String get biometricOff => 'Не использовать разблокировку устройства';

  @override
  String get orNewAccount => 'Или войдите в другую учётную запись:';

  @override
  String get importVideoTitle => 'Ссылки на видео';

  @override
  String get importVideoFast => 'Быстро';

  @override
  String get importVideoThorough => 'Тщательно (ИИ)';

  @override
  String get importVideoFastHint =>
      'Mealie расшифровывает видео и создаёт рецепт одним запросом к ИИ – обычно намного быстрее. Без перевода и без категорий/тегов. ИИ всё равно можно включить для отдельного импорта.';

  @override
  String get importVideoThoroughHint =>
      'Для ссылок на видео переключатель ИИ включается автоматически: несколько шагов ИИ, с переводом и категориями/тегами, как задано выше. Занимает больше времени.';

  @override
  String get importPresetFast => 'Быстро';

  @override
  String get importPresetThorough => 'Тщательно';

  @override
  String get importPresetCustom => 'Своё';

  @override
  String get importPresetFastTitle =>
      'Как можно меньше шагов ИИ – минимальное ожидание';

  @override
  String get importPresetFastVideo =>
      'Ссылки на видео: Mealie расшифровывает видео и создаёт рецепт одним запросом к ИИ (переключатель ИИ остаётся выключенным).';

  @override
  String get importPresetFastTranslate =>
      'Без перевода – рецепт остаётся на исходном языке.';

  @override
  String get importPresetFastOrganizers =>
      'Назначаются только существующие категории и теги, новые не создаются.';

  @override
  String get importPresetThoroughTitle =>
      'Полный ИИ-импорт Mealie – дольше, но с максимальным результатом';

  @override
  String get importPresetThoroughVideo =>
      'Ссылки на видео автоматически импортируются с ИИ – в несколько шагов (сбор источника, построение рецепта, …).';

  @override
  String get importPresetThoroughTranslate =>
      'Рецепт переводится на язык импорта ниже, если написан на другом языке.';

  @override
  String get importPresetThoroughOrganizers =>
      'Назначаются подходящие категории и теги; недостающие создаются.';

  @override
  String get importPresetCustomTitle => 'Настройте каждый параметр сами';

  @override
  String get importPresetCustomBody =>
      'Начните с того, что делал предыдущий вариант, и измените только нужное – например, быстрый импорт видео, но с переводом.';

  @override
  String get sidebarPinHint =>
      'Совет: удерживайте плитку и перетащите её на боковую панель, чтобы закрепить.';

  @override
  String get sidebarDropHere => 'Перетащите сюда';

  @override
  String sidebarShortcutTitle(String name) {
    return 'Сочетание клавиш для «$name»';
  }

  @override
  String sidebarShortcutPrompt(String modifier) {
    return 'Теперь нажмите нужное сочетание клавиш, включая $modifier.';
  }

  @override
  String get sidebarShortcutTaken => 'Это сочетание уже используется.';

  @override
  String get sidebarShortcutNone => 'Без сочетания клавиш';

  @override
  String get sidebarShortcutChange => 'Изменить сочетание клавиш';

  @override
  String get sidebarUnpin => 'Убрать с боковой панели';

  @override
  String sidebarFull(int count) {
    return 'Боковая панель заполнена – не более $count своих пунктов.';
  }

  @override
  String get tabletSidebar => 'Боковая панель в альбомной ориентации';

  @override
  String get tabletSidebarSubtitle =>
      'Показывает навигацию слева, а не снизу, когда планшет повёрнут горизонтально';

  @override
  String get filterDateCreated => 'Дата создания';

  @override
  String get filterDateUpdated => 'Дата обновления';

  @override
  String get errorUploadTooLarge =>
      'Файл слишком большой для этого сервера Mealie. Лимит загрузки можно увеличить через MAX_UPLOAD_SIZE_MB.';

  @override
  String get recipeDownloadPdfMealie => 'Скачать PDF (макет Mealie)';

  @override
  String get mealplanNoteMore => 'Показать больше…';

  @override
  String get mealplanNoteLess => 'Показать меньше';

  @override
  String get ingredientCommonlySubstitutedWith => 'Обычно заменяется на';

  @override
  String requiresMealieVersion(String version) {
    return 'Требуется Mealie $version или новее.';
  }

  @override
  String get apiTokensTitle => 'API-токены';

  @override
  String get apiTokensDescription =>
      'Управляйте вашими API-токенами для доступа сторонних приложений.';

  @override
  String get apiTokenNameLabel => 'Название токена';

  @override
  String get apiTokenGenerate => 'Сгенерировать';

  @override
  String get apiTokensActive => 'АКТИВНЫЕ ТОКЕНЫ';

  @override
  String get apiTokenCopyWarning =>
      'Скопируйте этот токен для использования с внешним приложением. Этот токен не будет доступен для повторного просмотра.';

  @override
  String get apiTokenThisApp => 'Используется этим приложением';

  @override
  String get apiTokenThisAppHint =>
      'Этот токен поддерживает вход приложения, и его нельзя удалить здесь.';

  @override
  String apiTokenDeleteConfirm(String name) {
    return 'Удалить токен «$name»? Приложения, которые его используют, сразу потеряют доступ.';
  }

  @override
  String get apiTokensEmpty => 'Токенов пока нет.';

  @override
  String apiTokenCreatedOn(String date) {
    return 'Создан $date';
  }

  @override
  String get apiTokenCopied => 'Токен скопирован';

  @override
  String get qfOpHasNoValue => 'не содержит значение';

  @override
  String get qfOpHasValue => 'содержит значение';

  @override
  String get ratingHouseholdAverage => 'средн. по домохоз.';

  @override
  String get stepLinkedNotes => 'Связанные заметки';

  @override
  String get noteFallbackTitle => 'Заметка';

  @override
  String get aiPromptTitleEnrichInstructions => 'Добавить детали шагов';

  @override
  String get aiPromptDescEnrichInstructions =>
      'Связывает каждый шаг импортированного рецепта с используемыми ингредиентами и заметками и определяет его длительность и заголовок.';

  @override
  String get loginAccountLocked =>
      'Учетная запись заблокирована. Пожалуйста, повторите попытку позже';

  @override
  String get loginPasswordDisabled =>
      'На этом сервере вход по паролю отключён. Используйте API-токен.';

  @override
  String get unitSystemTitle => 'Единицы измерения';

  @override
  String get unitSystemAsWritten => 'Как записано';

  @override
  String get unitSystemMetric => 'Метрическая';

  @override
  String get unitSystemMetricHint => 'Метрическая (г, мл)';

  @override
  String get unitSystemImperial => 'Британская';

  @override
  String get unitSystemImperialHint => 'Британская (ч, ун)';

  @override
  String get unitSystemHint =>
      'Только отображение – сам рецепт не меняется. Как в веб-приложении Mealie, выбор действует для всех рецептов на этом устройстве.';

  @override
  String get unitSystemUnavailable =>
      'Ни одну единицу этого рецепта нельзя пересчитать. Для этого у единицы в Mealie должна быть стандартизация (Продукты и единицы → единица → Стандартизация).';

  @override
  String get shoppingCheckAll => 'Выделить все элементы';

  @override
  String get shoppingUncheckAll => 'Снять выделение со всех элементов';

  @override
  String get shoppingDeleteChecked => 'Удалить отмеченные';

  @override
  String get shoppingCheckAllConfirm =>
      'Вы уверены, что хотите выбрать все элементы?';

  @override
  String get shoppingUncheckAllConfirm =>
      'Вы уверены, что хотите снять отметку со всех элементов?';

  @override
  String shoppingItemCheckedOff(String item) {
    return 'Отмечено: $item';
  }
}
