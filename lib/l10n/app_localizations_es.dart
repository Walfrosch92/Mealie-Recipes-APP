// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Mealie Recipes';

  @override
  String get endCookingMode => 'Finalizar modo cocina';

  @override
  String get endCookingModeConfirm =>
      '¿Seguro que quieres finalizar el modo cocina?';

  @override
  String endCookingModeConfirmAll(int count) {
    return 'Esto finalizará las $count recetas del modo cocina. ¿Continuar?';
  }

  @override
  String get addTimer => 'Añadir temporizador';

  @override
  String get recipeFinished => 'Tu plato está listo.';

  @override
  String get bonAppetit => '¡Buen provecho!';

  @override
  String get prepareIngredients => 'Prepara los siguientes ingredientes';

  @override
  String prepareIngredientsFor(String servings) {
    return 'Prepara los siguientes ingredientes para $servings porciones';
  }

  @override
  String get next => 'Siguiente';

  @override
  String get navHome => 'Inicio';

  @override
  String get homeCookToday => 'Cocina hoy';

  @override
  String get homeSuggestion => 'Sugerencia';

  @override
  String get homeQuickAccess => 'Acceso rápido';

  @override
  String get homePlanned => 'Planificado';

  @override
  String get favorite => 'Favorito';

  @override
  String get navSettings => 'Ajustes';

  @override
  String homeWelcomeName(Object name) {
    return 'Bienvenido $name,';
  }

  @override
  String get homeWelcomeApp => 'a Mealie Recipes 👋';

  @override
  String get theme => 'Apariencia';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get recipes => 'Recetas';

  @override
  String get shoppingList => '🛒 Lista de compras';

  @override
  String get mealplan => 'Plan de comidas';

  @override
  String get settings => '⚙️ Ajustes';

  @override
  String get searchRecipe => 'Buscar receta...';

  @override
  String get loadingRecipes => 'Cargando recetas...';

  @override
  String get loadingRecipe => 'Cargando receta...';

  @override
  String errorLoadingRecipes(String error) {
    return 'Error al cargar: $error';
  }

  @override
  String get errorLoadingRecipe => 'No se pudo cargar la receta.';

  @override
  String get noRecipesForCategory => 'No hay recetas para este filtro.';

  @override
  String get resetFilter => 'Restablecer filtro';

  @override
  String get allCategories => 'Todas las categorías';

  @override
  String get all => 'Todas';

  @override
  String get sortRecipes => 'Ordenar recetas';

  @override
  String get refreshRecipes => 'Actualizar';

  @override
  String get sortNameAZ => 'Nombre A–Z';

  @override
  String get sortNameZA => 'Nombre Z–A';

  @override
  String get sortDateNewest => 'Más recientes primero';

  @override
  String get sortDateOldest => 'Más antiguas primero';

  @override
  String get sortPrepTimeShort => 'Menor tiempo de preparación';

  @override
  String get sortPrepTimeLong => 'Mayor tiempo de preparación';

  @override
  String get sortRatingHighest => 'Mayor valoración';

  @override
  String get sortRatingLowest => 'Menor valoración';

  @override
  String get details => 'Detalles';

  @override
  String get ingredients => 'Ingredientes';

  @override
  String get instructions => 'Instrucciones';

  @override
  String get tags => 'Etiquetas';

  @override
  String get notes => 'Notas';

  @override
  String get addNote => 'Añadir nota';

  @override
  String get editNote => 'Editar nota';

  @override
  String get noteTitleHint => 'Título (opcional)';

  @override
  String get noteTextHint => 'Texto de la nota';

  @override
  String get deleteNoteTitle => '¿Eliminar nota?';

  @override
  String get deleteNoteMessage => 'Esta nota se eliminará de forma permanente.';

  @override
  String get servings => 'Raciones';

  @override
  String get adjustQuantity => 'Ajustar cantidad';

  @override
  String get startTimer => 'Iniciar temporizador';

  @override
  String runningTimer(int minutes, String seconds) {
    return 'Temporizador: $minutes:$seconds';
  }

  @override
  String get planMeal => 'Planificar comida';

  @override
  String get displayAlwaysOn => 'Mantener pantalla encendida';

  @override
  String get addAllIngredients => 'Añadir todos los ingredientes';

  @override
  String get addSelectedIngredients => 'Añadir ingredientes seleccionados';

  @override
  String get addIngredientsTitle => 'Ingredientes añadidos';

  @override
  String get addIngredientsMessage =>
      'Los ingredientes se han añadido a la lista de compras.';

  @override
  String addIngredientsFailedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'No se pudieron añadir $count ingredientes.',
      one: 'No se pudo añadir 1 ingrediente.',
    );
    return '$_temp0';
  }

  @override
  String get cookbooks => 'Recetarios';

  @override
  String get cookbooksEmpty =>
      'Aún no hay recetarios. Toca «+» arriba a la derecha para crear uno.';

  @override
  String get cookbookNoMatches => 'Ninguna receta coincide con este filtro.';

  @override
  String get cookbookCreateTitle => 'Crear recetario';

  @override
  String get cookbookEditTitle => 'Editar recetario';

  @override
  String get cookbookNameLabel => 'Nombre del recetario';

  @override
  String get cookbookFilterSectionTitle => 'Añadir recetas automáticamente';

  @override
  String get cookbookFieldTools => 'Utensilios';

  @override
  String get cookbookFieldUsers => 'Usuarios';

  @override
  String get cookbookOpIsOneOf => 'es uno de';

  @override
  String get cookbookOpIsNotOneOf => 'no es ninguno de';

  @override
  String get cookbookOpContainsAll => 'contiene todos';

  @override
  String get cookbookSelectValues => 'Seleccionar valores';

  @override
  String get cookbookFilterOptionsUnavailable => 'No hay opciones disponibles';

  @override
  String get cookbookAddFilterField => 'Añadir campo';

  @override
  String get cookbookPublicLabel => 'Recetario público';

  @override
  String get cookbookPublicSubtitle =>
      'Visible para otros hogares del servidor';

  @override
  String get cookbookRawModeEnter => 'Editar como texto';

  @override
  String get cookbookRawModeExit => 'Volver al asistente';

  @override
  String get cookbookRawModeHint =>
      'Modo experto de esta app: edita el filtro directamente como texto. Útil cuando un filtro existente no se pudo descomponer en filas simples.';

  @override
  String get cookbookRawModeUnparseable =>
      'Este texto no coincide con el formato simple de filas — se mantiene como texto.';

  @override
  String get saveFailed => 'Error al guardar';

  @override
  String get search => 'Buscar';

  @override
  String get apply => 'Aplicar';

  @override
  String get setupCachingTitle => 'Cargando tus recetas';

  @override
  String get setupCachingSubtitle =>
      'Tus recetas se están preparando para el uso sin conexión. Según la cantidad, puede tardar un momento.';

  @override
  String get setupCachingDone => '¡Todo listo!';

  @override
  String get setupTipsHeader => '¿Sabías que…?';

  @override
  String get setupFinish => '¡Vamos!';

  @override
  String get setupSkipCaching => 'Continuar en segundo plano';

  @override
  String get setupTip1 =>
      'Puedes importar recetas desde un enlace, una foto o un PDF — con el mosaico Importar de la pantalla de inicio.';

  @override
  String get setupTip2 =>
      'El modo cocina mantiene la pantalla encendida, te guía paso a paso y detecta temporizadores en el texto automáticamente.';

  @override
  String get setupTip3 =>
      'La lista de compras también funciona sin conexión — los cambios se sincronizan automáticamente cuando el servidor está disponible.';

  @override
  String get setupTip4 =>
      'Mantén pulsado un mosaico de la pantalla de inicio para reordenar el acceso rápido.';

  @override
  String get setupTip5 =>
      'Encuentra tus recetarios de Mealie en el mosaico Recetarios — también sin conexión.';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Eliminar';

  @override
  String get edit => 'Editar';

  @override
  String get save => 'Guardar';

  @override
  String get done => 'Listo';

  @override
  String get close => 'Cerrar';

  @override
  String get add => 'Añadir';

  @override
  String get send => 'Enviar';

  @override
  String get retry => 'Reintentar';

  @override
  String get confirmDeleteTitle => '¿Eliminar receta?';

  @override
  String get confirmDeleteMessage => 'Esta acción no se puede deshacer.';

  @override
  String get sendToDevice => 'Enviar al dispositivo';

  @override
  String get sendToDevicePickerTitle => 'Enviar al dispositivo';

  @override
  String get sendToAllDevices => 'Enviar a todos los dispositivos';

  @override
  String get timerFinished => '¡Temporizador finalizado!';

  @override
  String get timerFinishedBody => 'Tu temporizador de receta ha terminado.';

  @override
  String get timer => 'Temporizador';

  @override
  String get newTimer => 'Nuevo temporizador';

  @override
  String get timerDetails => 'Detalles del temporizador';

  @override
  String get timerNamePlaceholder => 'Nombre del temporizador';

  @override
  String get timerNameHint => 'Dale un nombre descriptivo al temporizador.';

  @override
  String get durationLabel => 'Duración';

  @override
  String minutesCount(int count) {
    return '$count minutos';
  }

  @override
  String get start => 'Iniciar';

  @override
  String get stop => 'Detener';

  @override
  String get pause => 'Pausar';

  @override
  String get resume => 'Reanudar';

  @override
  String get finished => '¡Terminado!';

  @override
  String stepNumber(int number) {
    return 'Paso $number';
  }

  @override
  String get minAbbreviation => 'min';

  @override
  String get cookingMode => 'Modo cocina';

  @override
  String activeRecipesCount(int count) {
    return '$count recetas activas';
  }

  @override
  String get endAll => 'Terminar todo';

  @override
  String get end => 'Terminar';

  @override
  String get endAllRecipesTitle => '¿Terminar todas las recetas?';

  @override
  String endAllRecipesMessage(int count) {
    return '¿Quieres terminar las $count sesiones activas?';
  }

  @override
  String get endRecipeTitle => '¿Terminar receta?';

  @override
  String endRecipeMessage(String name) {
    return '¿Quieres terminar la sesión de \"$name\"?';
  }

  @override
  String get noActiveTimers => 'Sin temporizadores activos';

  @override
  String get noActiveRecipes => 'Sin recetas activas';

  @override
  String get startRecipeToCook =>
      'Abre una receta y pulsa el botón de modo cocina.';

  @override
  String get browseRecipes => 'Explorar recetas';

  @override
  String timersPausedCount(int count) {
    return '$count temporizador(es) pausado(s)';
  }

  @override
  String get cookFriends => 'Cocinar con amigos';

  @override
  String get cookingModeAddRecipe => 'Agregar receta';

  @override
  String get cookingModeAddRecipeSearchHint => 'Buscar recetas';

  @override
  String get cookFriendsCode => 'Código de sesión';

  @override
  String get cookFriendsJoin => 'Unirse a sesión';

  @override
  String get cookFriendsHost => 'Organizar sesión';

  @override
  String get cookFriendsHostNotFound =>
      'Anfitrión no encontrado. Asegúrate de que ambos dispositivos estén en la misma Wi-Fi y que el acceso a la red local esté permitido.';

  @override
  String get cookFriendsConnectionFailed =>
      'Error de conexión. Inténtalo de nuevo.';

  @override
  String get cookFriendsEnterCode => 'Introducir código';

  @override
  String cookFriendsConnected(int count) {
    return 'Conectado: $count invitados';
  }

  @override
  String get joinSession => 'Unirse a sesión';

  @override
  String get hostEndedSessionTitle => 'Sesión terminada';

  @override
  String get hostEndedSessionMessage => 'El anfitrión ha terminado la sesión.';

  @override
  String get shoppingListEmpty => 'Tu lista de compras está vacía.';

  @override
  String get addItem => 'Añadir artículo';

  @override
  String get itemNote => 'Nombre del artículo';

  @override
  String get unlabeledCategory => 'Sin categoría';

  @override
  String get reorderCategories => 'Reordenar categorías';

  @override
  String get archiveChecked => 'Archivar marcados';

  @override
  String get archivedLists => '📦 Compras archivadas';

  @override
  String get syncChanges => 'Sincronizar cambios';

  @override
  String get noSyncChanges => 'Sin cambios para sincronizar';

  @override
  String get postimportAction => 'Después de importar';

  @override
  String get postimportHint =>
      'Elige qué debe ocurrir en la app de origen (Recordatorios / Google Tasks) con las entradas importadas.';

  @override
  String get postimportLeave => 'Solo añadir';

  @override
  String get postimportComplete => 'Marcar como completado';

  @override
  String get postimportCompleteDelete => 'Marcar y eliminar';

  @override
  String get postimportFailed =>
      'El procesamiento posterior en la app de origen falló. Los artículos se añadieron a Mealie de todos modos.';

  @override
  String get syncChangesTitle => 'Sincronizar cambios';

  @override
  String get syncSectionChecked => 'Marcado';

  @override
  String get syncSectionQuantity => 'Cantidad';

  @override
  String get syncSectionCategory => 'Categoría';

  @override
  String get syncSectionAdditions => 'Recién añadidos';

  @override
  String get syncLocalLabel => 'Local';

  @override
  String get syncServerLabel => 'Servidor';

  @override
  String get syncNow => 'Sincronizar ahora';

  @override
  String get offlineBadge => 'Sin conexión';

  @override
  String get mealplanTitle => '📅 Plan de comidas';

  @override
  String get mealplanSelectMode => 'Seleccionar varias recetas';

  @override
  String mealplanSelectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count seleccionadas',
      one: '1 seleccionada',
      zero: 'Selección',
    );
    return '$_temp0';
  }

  @override
  String get breakfast => 'Desayuno';

  @override
  String get lunch => 'Almuerzo';

  @override
  String get dinner => 'Cena';

  @override
  String get addMealEntry => 'Añadir comida';

  @override
  String get selectRecipe => 'Seleccionar receta';

  @override
  String get orFreeText => 'o texto libre';

  @override
  String get entryNote => 'Nota';

  @override
  String get noMealEntries => 'Sin entradas para esta semana.';

  @override
  String get importRecipe => 'Importar receta';

  @override
  String get importFromUrl => 'Importar desde URL';

  @override
  String get importFromImage => 'Importar desde foto';

  @override
  String get importFromJson => 'Importar desde JSON';

  @override
  String get url => 'URL';

  @override
  String get urlPlaceholder => 'https://...';

  @override
  String get importLanguage => 'Idioma para OCR';

  @override
  String get importing => 'Importando...';

  @override
  String get importSuccess => '¡Receta importada correctamente!';

  @override
  String importError(String error) {
    return 'Error al importar: $error';
  }

  @override
  String get pasteJson => 'Pega el JSON aquí';

  @override
  String get setupTitle => 'Bienvenido a Mealie Recipes';

  @override
  String get setupSubtitle => 'Configura tu servidor Mealie.';

  @override
  String get serverUrl => 'URL del servidor';

  @override
  String get serverUrlPlaceholder => 'https://mealie.ejemplo.com';

  @override
  String get apiToken => 'Token API';

  @override
  String get apiTokenPlaceholder => 'Tu token API';

  @override
  String get householdId => 'Hogar';

  @override
  String get householdIdPlaceholder => 'Family';

  @override
  String get shoppingListId => 'ID de lista de compras';

  @override
  String get shoppingListIdPlaceholder => 'Seleccionar lista';

  @override
  String get setupHouseholdListTitle => 'Hogar y lista de la compra';

  @override
  String get shoppingListLabel => 'Lista de la compra';

  @override
  String get setupHouseholdManualHint =>
      'No se pudieron cargar los hogares; introduce el nombre manualmente.';

  @override
  String get setupExactTitle => 'Cantidades en la lista de la compra';

  @override
  String get setupExactBody =>
      'En la mayoría de los países no se compra al gramo: en el carrito acaba 1 paquete de mantequilla, no 200 g. Por eso, en el modo sencillo la app convierte las cantidades de las recetas en «1×». En el modo exacto se mantienen cantidad y unidad tal como en la web de Mealie, también al escribir artículos nuevos (p. ej., «200 g de mantequilla»). Puedes cambiarlo en cualquier momento en los ajustes.';

  @override
  String get setupExactSimpleTitle => 'Modo sencillo (1×)';

  @override
  String get setupExactSimpleBody =>
      'Los ingredientes llegan a la lista como «1× artículo», ideal para marcarlos rápido al comprar.';

  @override
  String get setupExactExactTitle => 'Cantidades exactas';

  @override
  String get setupExactExactBody =>
      'Los artículos aparecen con cantidad y unidad, p. ej., «200 g de mantequilla», igual que en la web.';

  @override
  String get connect => 'Conectar';

  @override
  String get connecting => 'Conectando...';

  @override
  String get connectionSuccess => '¡Conexión exitosa!';

  @override
  String connectionError(String error) {
    return 'Error de conexión: $error';
  }

  @override
  String get optionalHeaders =>
      'Cabeceras HTTP opcionales (para proxy inverso)';

  @override
  String get settingsTitle => '⚙️ Ajustes';

  @override
  String get settingsSaved => 'Ajustes guardados';

  @override
  String get serverSettings => 'Servidor';

  @override
  String get displaySettings => 'Pantalla';

  @override
  String get notificationSettings => 'Notificaciones';

  @override
  String get securitySettings => 'Seguridad';

  @override
  String get aboutSettings => 'Acerca de';

  @override
  String get showRecipeImages => 'Mostrar imágenes';

  @override
  String get apiVersion => 'Versión API';

  @override
  String get language => 'Idioma';

  @override
  String get biometricLock => 'Bloqueo biométrico';

  @override
  String get biometricLockDescription =>
      'Desbloquear la app con datos biométricos';

  @override
  String get criticalAlerts => 'Alertas críticas';

  @override
  String get criticalAlertsDescription => 'Alarma aunque esté en silencio';

  @override
  String get enableLogging => 'Activar registro';

  @override
  String get selectLanguage => 'Seleccionar idioma';

  @override
  String get setupContinue => 'Continuar';

  @override
  String get back => 'Atrás';

  @override
  String get setupConnectStep => 'Conéctate a tu servidor';

  @override
  String get resetSettings => 'Restablecer ajustes';

  @override
  String get resetSettingsConfirm => '¿Restablecer todos los ajustes?';

  @override
  String get guestMode => 'Modo invitado';

  @override
  String get appVersion => 'Versión';

  @override
  String get leftoverFinder => 'Buscador de recetas';

  @override
  String get leftoverFinderSubtitle =>
      'Encuentra recetas con los ingredientes que tienes';

  @override
  String get addIngredient => 'Añadir ingrediente';

  @override
  String get ingredientPlaceholder => 'p.ej. huevos';

  @override
  String get findRecipes => 'Buscar recetas';

  @override
  String get matchingRecipes => 'Recetas coincidentes';

  @override
  String get noMatchingRecipes => 'No se encontraron recetas.';

  @override
  String matchPercent(int percent) {
    return '$percent% coincidencia';
  }

  @override
  String get biometricPrompt => 'Autenticación para Mealie Recipes';

  @override
  String get biometricFailed => 'Autenticación fallida';

  @override
  String get whatsNew => 'Novedades';

  @override
  String get pendingRecipesTitle => 'Recetas recibidas';

  @override
  String pendingRecipesMessage(String sender, String name) {
    return 'Recibiste una receta de $sender: \"$name\"';
  }

  @override
  String pendingRecipesFrom(Object names) {
    return 'De $names';
  }

  @override
  String get pendingRecipesOpenCooking => 'Abrir modo cocina';

  @override
  String get pendingRecipesLater => 'Más tarde';

  @override
  String get openRecipe => 'Abrir receta';

  @override
  String get dismiss => 'Cerrar';

  @override
  String get editRecipe => 'Editar receta';

  @override
  String get recipeName => 'Nombre de la receta';

  @override
  String get recipeDescription => 'Descripción';

  @override
  String get prepTime => 'Tiempo de preparación (min)';

  @override
  String get cookTime => 'Tiempo de cocción (min)';

  @override
  String get totalTime => 'Tiempo total (min)';

  @override
  String get recipeServings => 'Raciones';

  @override
  String get rating => 'Valoración';

  @override
  String get addIngredientLine => 'Añadir ingrediente';

  @override
  String get addInstruction => 'Añadir paso';

  @override
  String get removeIngredient => 'Eliminar ingrediente';

  @override
  String get removeInstruction => 'Eliminar paso';

  @override
  String get ingredientName => 'Ingrediente';

  @override
  String get ingredientQuantity => 'Cantidad';

  @override
  String get ingredientUnit => 'Unidad';

  @override
  String get ingredientNote => 'Nota';

  @override
  String get instructionText => 'Texto del paso';

  @override
  String get categories => 'Categorías';

  @override
  String get selectCategories => 'Seleccionar categorías';

  @override
  String get selectTags => 'Seleccionar etiquetas';

  @override
  String get uploadImage => 'Subir imagen';

  @override
  String get removeImage => 'Eliminar imagen';

  @override
  String get saveChanges => 'Guardar cambios';

  @override
  String get saving => 'Guardando...';

  @override
  String get saveSuccess => 'Receta guardada.';

  @override
  String saveError(String error) {
    return 'Error al guardar: $error';
  }

  @override
  String get newCategory => 'Nueva categoría';

  @override
  String get newTag => 'Nueva etiqueta';

  @override
  String get setRating => 'Establecer valoración';

  @override
  String get removeRating => 'Eliminar valoración';

  @override
  String get ratingRemoved => 'Valoración eliminada';

  @override
  String get googleTasksImport => 'Importar desde Google Tasks';

  @override
  String get googleTasksImportDescription =>
      'Importar elementos de Google Tasks a la lista de compras.';

  @override
  String get homeWelcome => '¡Bienvenido a Mealie Recipes! 👋';

  @override
  String homeWelcomeNamed(String name) {
    return '¡Bienvenido $name, a Mealie Recipes! 👋';
  }

  @override
  String get shopping => 'Compras';

  @override
  String get planning => 'Planificación';

  @override
  String get other => 'Otros';

  @override
  String get viewRecipes => '📖 Ver recetas';

  @override
  String get addRecipe => '➕ Añadir receta';

  @override
  String get completeShopping => 'Completar Compra';

  @override
  String get shoppingCompleted => 'Compra Completada';

  @override
  String get shoppingCompletedSubtitle => '¡Todo en el carrito! 🎉';

  @override
  String get essensplan => '📅 Plan de comidas';

  @override
  String get resteverwertung => '🥗 Buscador de recetas';

  @override
  String get newRecipeUpload => 'Subir Nueva Receta';

  @override
  String get copyCode => 'Copiar Código';

  @override
  String get shareLink => 'Compartir Enlace';

  @override
  String get connectedFriends => 'Amigos Conectados';

  @override
  String get waitingForFriends => 'Esperando amigos...';

  @override
  String get endSharing => 'Terminar Compartir';

  @override
  String get cookFriendsDescription =>
      'Invita a un amigo a cocinar esta receta juntos';

  @override
  String get sessionCode => 'CÓDIGO DE SESIÓN';

  @override
  String get adjustQuantityLabel => 'Ajustar cantidad para esta receta:';

  @override
  String get timerStartForStep => 'Temporizador para paso';

  @override
  String get enterRecipeUrl => 'Introduce la URL de la receta';

  @override
  String get loading => 'Cargando...';

  @override
  String get urlInvalidScheme => 'La URL debe comenzar con http:// o https://';

  @override
  String get urlAddScheme => 'Añadir https://';

  @override
  String get addItemPlaceholder => 'Agregar artículo...';

  @override
  String get addSuccessToast => '¡Añadido!';

  @override
  String get completedItems => 'Completado';

  @override
  String get completeShoppingTitle => '¿Completar compra?';

  @override
  String get completeShoppingMessage => '¿Eliminar artículos completados?';

  @override
  String get recipeListTitle => '📖 Recetas';

  @override
  String get importRecipeTitle => 'Subir nueva receta';

  @override
  String get uploadRecipeUrl => 'Importar por URL';

  @override
  String get uploadRecipeUrlHint =>
      'Introduce la URL para guardarla en tu servidor';

  @override
  String get uploadOpenAI => 'Importar archivo con OpenAI';

  @override
  String get uploadOpenAIHint =>
      'También puedes subir fotos o un PDF de una receta. Si la receta ocupa varias páginas, añade varias: se analizan juntas con IA.';

  @override
  String get takePhoto => 'Cámara';

  @override
  String get cameraPermissionDenied =>
      'Sin acceso a la cámara. Permítelo en los ajustes del sistema para fotografiar recetas.';

  @override
  String get cameraUnavailable =>
      'No hay cámara disponible en este dispositivo.';

  @override
  String get selectPhoto => 'Fotos';

  @override
  String get selectPdf => 'PDF';

  @override
  String get openAIHintTitle => 'Info de análisis';

  @override
  String get openAIHintBody =>
      'El análisis usa la API de OpenAI. Asegúrate de tener configurada tu clave API en Mealie.';

  @override
  String get allDeleteConfirm => 'Eliminar todo';

  @override
  String get portionen => 'Raciones';

  @override
  String get timerForStep => 'Iniciar temporizador';

  @override
  String get weekNavPrev => 'Semana anterior';

  @override
  String get weekNavNext => 'Semana siguiente';

  @override
  String get noMealsThisWeek => 'Sin comidas planificadas';

  @override
  String get entriesInOtherWeeks => 'Hay entradas en otras semanas';

  @override
  String get availableWeeks => 'Semanas disponibles:';

  @override
  String weekRange(Object end, Object start, Object week) {
    return 'Semana $week ($start – $end)';
  }

  @override
  String get currentWeek => 'Semana actual';

  @override
  String get rezepteAktualisieren => 'Actualizar recetas';

  @override
  String get leftoverWhatTitle => '¿Qué hace esto?';

  @override
  String get leftoverWhatBody =>
      'Esta función recarga todas las recetas del servidor y actualiza el caché local.';

  @override
  String get leftoverDescription =>
      'Introduce los ingredientes disponibles para encontrar recetas y aprovechar las sobras.';

  @override
  String get leftoverIngredientsHeader => 'Ingredientes en casa';

  @override
  String get leftoverSuggestions => 'Sugerencias de recetas';

  @override
  String get leftoverNoMatches => 'No se encontraron recetas.';

  @override
  String get leftoverEnterIngredient => 'Introducir ingrediente';

  @override
  String matchingPercentText(int percent, int count, int total) {
    return '$percent% coincide ($count/$total)';
  }

  @override
  String get weekAbbreviation => 'Sem.';

  @override
  String get today => 'Hoy';

  @override
  String get selectDate => 'Seleccionar fecha';

  @override
  String get selectSlot => 'Seleccionar comida';

  @override
  String get selectedRecipe => 'Receta seleccionada';

  @override
  String get confirmMeal => 'Planificar comida';

  @override
  String get searchRecipes => 'Buscar recetas';

  @override
  String get addCustomMeal => 'Añadir comida personalizada';

  @override
  String get diceModeButton => 'Sortear recetas al azar';

  @override
  String get diceModeTitle => '3 sugerencias aleatorias';

  @override
  String get diceBackToSearch => 'Volver a la búsqueda';

  @override
  String get diceNotEnoughRecipes =>
      'No hay suficientes recetas para el modo aleatorio (mínimo 3)';

  @override
  String get entrySingular => 'entrada';

  @override
  String get entriesPlural => 'entradas';

  @override
  String listTitle(int n) {
    return 'Lista $n';
  }

  @override
  String get deleteAllConfirmTitle => '¿Eliminar todo?';

  @override
  String get deleteAllConfirmMessage =>
      '¿Quieres eliminar todas las compras archivadas?';

  @override
  String get uploadFromUrlButton => 'Importar receta desde URL';

  @override
  String get uploadingImage => 'Subiendo...';

  @override
  String get uploadErrorTitle => 'Error al subir';

  @override
  String get uploadSuccessTitle => 'Subida correcta';

  @override
  String get editImportedRecipeQuestion =>
      '¿Quieres editar la nueva receta ahora?';

  @override
  String get notNow => 'Ahora no';

  @override
  String get pdfTooLarge => 'El archivo PDF es demasiado grande (máx. 10 MB).';

  @override
  String get invalidUrl => 'URL no válida. Introduce una URL HTTP(S) válida.';

  @override
  String get cookWithFriends => 'Cocinar con amigos';

  @override
  String get cookFriendsSubtitle =>
      'Invita a un amigo a cocinar juntos esta receta';

  @override
  String get copied => 'Copiado';

  @override
  String get linkCopied => 'Enlace copiado';

  @override
  String get startCooking => 'Empezar a cocinar';

  @override
  String get hostNoRecipe => 'Abre una receta para iniciar una sesión';

  @override
  String get uploadToOwnServer => 'Guardar en mi servidor';

  @override
  String get uploadingRecipe => 'Subiendo receta…';

  @override
  String get recipeUploadedToOwnServer => 'Receta guardada en tu servidor';

  @override
  String get recipeUploadFailed => 'Error al subir';

  @override
  String get allowGuestSaveRecipes =>
      'Permitir que los invitados guarden recetas en su propio servidor';

  @override
  String get appIcon => 'Icono de la app';

  @override
  String get appIconClassic => 'Clásico';

  @override
  String get appIconModern => 'Moderno';

  @override
  String get name => 'Nombre';

  @override
  String get color => 'Color';

  @override
  String get randomColor => 'Color aleatorio';

  @override
  String get createFailed => 'No se pudo crear';

  @override
  String get deleteFailed => 'No se pudo eliminar';

  @override
  String deleteOrganizerConfirm(String name) {
    return '¿Eliminar «$name»? También se elimina del servidor.';
  }

  @override
  String get connectionSection => 'Conexión';

  @override
  String get token => 'Token';

  @override
  String get advancedOptions => 'Opciones avanzadas';

  @override
  String get mealieApiVersion => 'Versión de la API de Mealie';

  @override
  String get sendOptionalHeaders => 'Enviar cabeceras opcionales';

  @override
  String get offlineRecipeImages => 'Guardar imágenes de recetas sin conexión';

  @override
  String get offlineRecipeImagesHint =>
      'Descarga todas las imágenes de recetas en este dispositivo para que también se muestren sin conexión. Con colecciones grandes puede ocupar varios cientos de MB. Al desactivarlo se eliminan las imágenes guardadas.';

  @override
  String offlineRecipeImagesStatus(int count, int total, String size) {
    return 'Guardadas: $count/$total · $size';
  }

  @override
  String get offlineRecipeImagesDisableConfirm =>
      '¿Eliminar todas las imágenes de recetas guardadas?';

  @override
  String headerNameLabel(int n) {
    return 'Nombre de cabecera $n';
  }

  @override
  String headerValueLabel(int n) {
    return 'Valor de cabecera $n';
  }

  @override
  String get value => 'Valor';

  @override
  String get personalization => 'Personalización';

  @override
  String get showRecipeImagesSubtitle =>
      'Muestra imágenes en la lista de recetas';

  @override
  String get exactQuantities => 'Añadir cantidades exactas';

  @override
  String get exactQuantitiesSubtitle =>
      'Los ingredientes y artículos escritos conservan cantidad y unidad (p. ej., 200 g de mantequilla) en lugar de 1x por artículo; los alimentos que falten se crean en el servidor';

  @override
  String get remindToShop => 'Recuérdame ir de compras';

  @override
  String get remindToShopSubtitle =>
      'Te avisa cuando estás cerca de un lugar guardado y tu lista de la compra tiene artículos pendientes, incluso con la app cerrada';

  @override
  String get shoppingReminderAddLocation => 'Añadir ubicación';

  @override
  String get shoppingReminderMaxLocations =>
      'Máximo de 3 ubicaciones alcanzado';

  @override
  String get shoppingReminderLocationServiceDisabled =>
      'El servicio de ubicación está desactivado en este dispositivo';

  @override
  String get shoppingReminderPermissionTitle =>
      'Se necesita acceso a la ubicación';

  @override
  String get shoppingReminderPermissionMessage =>
      'Para avisarte cerca de una tienda, se necesita acceso a la ubicación “Siempre” — incluso con la app cerrada. Actívalo en Ajustes.';

  @override
  String get openSettings => 'Abrir ajustes';

  @override
  String get shoppingReminderLocationName => 'Nombre';

  @override
  String get shoppingReminderUseCurrentLocation => 'Usar ubicación actual';

  @override
  String get shoppingReminderOrAddress => 'o introduce una dirección';

  @override
  String get shoppingReminderAddress => 'Dirección';

  @override
  String get shoppingReminderAddressPlaceholder => 'Calle, ciudad';

  @override
  String get shoppingReminderSearchAddress => 'Buscar';

  @override
  String get shoppingReminderLocationFailed =>
      'No se pudo determinar tu ubicación';

  @override
  String get shoppingReminderAddressNotFound => 'Dirección no encontrada';

  @override
  String get ratingFailed =>
      'No se pudo guardar la valoración; inténtalo de nuevo.';

  @override
  String get lastCooked => 'Última vez cocinado';

  @override
  String get syncLastCooked => 'Actualizar «última vez cocinado»';

  @override
  String get syncLastCookedSubtitle =>
      'Guarda la fecha de hoy y una entrada en la cronología, como en la web de Mealie.';

  @override
  String get developer => 'Desarrollador';

  @override
  String get enableLoggingSubtitle =>
      'Registra logs de print/errores (últimas 500 líneas)';

  @override
  String get entriesLabel => 'Entradas';

  @override
  String get fileSize => 'Tamaño del archivo';

  @override
  String get showAction => 'Mostrar';

  @override
  String get copy => 'Copiar';

  @override
  String logsWithCount(int count) {
    return 'Logs ($count)';
  }

  @override
  String get noLogs => 'No hay logs disponibles';

  @override
  String get logsTitle => 'Logs';

  @override
  String get required => 'Obligatorio';

  @override
  String get connectionFailedCheck =>
      'Conexión fallida. Comprueba la URL y el token.';

  @override
  String get username => 'Usuario';

  @override
  String get password => 'Contraseña';

  @override
  String get setupPasswordHint =>
      'Tu contraseña no se guarda — la app te conecta una vez y genera un token de API a partir de ella (igual que en Perfil → Tokens de API en la web).';

  @override
  String get loginAndConnect => 'Iniciar sesión y conectar';

  @override
  String get loginInvalidCredentials => 'Usuario o contraseña incorrectos.';

  @override
  String get loginAndGenerateToken => 'Iniciar sesión y generar token';

  @override
  String get loggingIn => 'Iniciando sesión…';

  @override
  String get apiTokenSaveHint =>
      'Token aplicado — toca «Guardar cambios» abajo.';

  @override
  String get renewApiToken => 'Renovar token de API';

  @override
  String get setupAuthChoiceTitle => '¿Cómo quieres iniciar sesión?';

  @override
  String get authModePasswordTitle => 'Que la app cree una clave de API por mí';

  @override
  String get authModePasswordSubtitle =>
      'Inicia sesión con usuario y contraseña — la app genera un token automáticamente.';

  @override
  String get authModeTokenTitle => 'Ya tengo una clave de API';

  @override
  String get authModeTokenSubtitle =>
      'Copiada del perfil de Mealie (Perfil → Tokens de API).';

  @override
  String keyN(int n) {
    return 'Clave $n';
  }

  @override
  String valueN(int n) {
    return 'Valor $n';
  }

  @override
  String get openCookingMode => 'Abrir modo de cocina';

  @override
  String activeRecipes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count recetas activas',
      one: '1 receta activa',
    );
    return '$_temp0';
  }

  @override
  String get reparseIngredients => 'Reanalizar ingredientes';

  @override
  String get reparseIngredientsSubtitle =>
      'Separar cantidad/unidad/ingrediente (p. ej. «200 g harina»)';

  @override
  String get reparseDone => 'Ingredientes separados: pulsa «Guardar cambios»';

  @override
  String get reparseNone => 'No se encontraron ingredientes separables';

  @override
  String get tagsAndCategories => 'Etiquetas, categorías y utensilios';

  @override
  String get tapToAddPhoto => 'Toca para añadir foto';

  @override
  String get descriptionLabel => 'Descripción';

  @override
  String get searchingDevices => 'Buscando dispositivos en la misma Wi-Fi…';

  @override
  String get selectAll => 'Seleccionar todo';

  @override
  String get importReminders => 'Importar recordatorios';

  @override
  String get importGoogleTasks => 'Importar Google Tasks';

  @override
  String get noTaskLists => 'No se encontraron listas de tareas';

  @override
  String get noReminderLists => 'No se encontraron listas de recordatorios';

  @override
  String importCount(int count) {
    return 'Importar $count';
  }

  @override
  String get activeRecipeTimer => 'Temporizador de receta activo';

  @override
  String get linkIngredients => 'Vincular ingredientes';

  @override
  String get noIngredientsToLink => 'Aún no hay ingredientes para vincular';

  @override
  String get importLanguageSubtitle =>
      'Idioma de las recetas importadas desde una foto o un PDF';

  @override
  String get importLanguageSearch => 'Buscar idioma';

  @override
  String get importLanguageFollowApp => 'Igual que el idioma de la app';

  @override
  String get importLanguageNoMatch => 'No se encontró ningún idioma';

  @override
  String get setupImportLanguageTitle => 'Importación de recetas con IA';

  @override
  String get setupImportLanguageBody =>
      'Las fotos y los PDF se pueden convertir en recetas mediante IA. Elige el idioma en el que deben quedar: útil si tu lengua materna no está disponible como idioma de la app. Puedes cambiarlo más tarde en los ajustes.';

  @override
  String get setupImportLanguageSearchHint =>
      'Usa el buscador de la lista para encontrar idiomas que la interfaz de la app no ofrece.';

  @override
  String get setupCachingKeepOpenTitle => 'Mantén la app abierta';

  @override
  String get setupCachingKeepOpenBody =>
      'La carga se ejecuta en primer plano. Deja la app abierta hasta que termine: si la cierras o cambias de app demasiado tiempo, el proceso se interrumpe y volverá a empezar más tarde.';

  @override
  String get supportContact => 'Contactar con soporte';

  @override
  String get supportDialogMessage =>
      'Describe tu problema y te responderemos. El registro ayuda mucho a localizar el fallo: puedes adjuntarlo como archivo de texto.';

  @override
  String get supportWithoutLogs => 'Sin registro';

  @override
  String get supportWithLogs => 'Adjuntar registro';

  @override
  String get supportMailSubject => 'Mealie Recipes — Soporte';

  @override
  String get supportMailHint => 'Describe aquí tu problema:';

  @override
  String get supportLogsEmpty =>
      'El registro está vacío. Activa el registro, reproduce el problema y envíalo después.';

  @override
  String supportAddressCopied(String email) {
    return 'Dirección copiada: $email';
  }

  @override
  String supportNoMailApp(String email) {
    return 'No se encontró ninguna app de correo. Dirección copiada: $email';
  }

  @override
  String get createRecipeFromImages => 'Crear receta';

  @override
  String imagePagesSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count páginas seleccionadas',
      one: '1 página seleccionada',
    );
    return '$_temp0';
  }

  @override
  String get imagePagesHint =>
      'La primera imagen será la imagen principal de la receta. Mantén pulsada una página para reordenarla.';

  @override
  String get mainImageBadge => 'Principal';

  @override
  String maxImagesReached(int max) {
    return 'Máximo $max imágenes por receta.';
  }

  @override
  String get removePage => 'Quitar página';

  @override
  String get preparingPdf => 'Procesando PDF...';

  @override
  String get shareRecipeTitle => 'Compartir receta';

  @override
  String get recipeOptionsTitle => 'Opciones';

  @override
  String get exportAsPdf => 'Exportar como PDF';

  @override
  String get generatingPdf => 'Generando PDF…';

  @override
  String get pdfExportFailed => 'No se pudo exportar el PDF';

  @override
  String get recipeTime => 'Tiempo';

  @override
  String get ingredientSectionTitle => 'Sección';

  @override
  String get addIngredientSection => 'Añadir sección';

  @override
  String get aiImportToggle => 'Analizar con IA';

  @override
  String get aiImportToggleHint =>
      'También para vídeos de recetas (YouTube, Instagram, TikTok …) y páginas que la importación normal no puede leer. Requiere un proveedor de IA en tu servidor Mealie; para vídeos, además un proveedor de audio.';

  @override
  String get aiImportButton => 'Importar con IA';

  @override
  String get aiImportRunning =>
      'La IA está analizando el enlace … con vídeos puede tardar unos minutos.';

  @override
  String get aiImportFailed =>
      'La importación con IA ha fallado. Revisa los ajustes de IA de tu servidor Mealie.';

  @override
  String get stepHeadingLabel => 'Título del paso (opcional)';

  @override
  String get linkedRecipeLabel => 'Receta enlazada';

  @override
  String get toolsTitle => 'Utensilios';

  @override
  String get prepareTools => 'Prepara los siguientes utensilios';

  @override
  String get newTool => 'Nuevo utensilio';

  @override
  String get renameAction => 'Renombrar';

  @override
  String get organizerEmpty =>
      'Aún no hay entradas. Toca «+» arriba a la derecha para crear una.';

  @override
  String organizerRecipeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count recetas',
      one: '1 receta',
      zero: 'Sin recetas',
    );
    return '$_temp0';
  }

  @override
  String get toolOnHand => 'Disponible';

  @override
  String get mealDiceSettingsTitle => 'Filtro del dado';

  @override
  String get mealDiceSettingsHint =>
      'Elige categorías y etiquetas para cada comida. Al tirar el dado solo se sugieren recetas que tengan al menos una de ellas. La misma selección puede usarse en varias comidas.';

  @override
  String get mealDiceSettingsNoneHint =>
      'No hay nada seleccionado para esta comida: el dado elige automáticamente por categorías como «Desayuno», «Almuerzo» o «Cena».';

  @override
  String get mealDiceAutoHintTitle => 'Selección automática';

  @override
  String get mealDiceAutoHintBody =>
      'Todavía no hay categorías ni etiquetas para esta comida. Por eso el dado busca categorías como «Desayuno», «Almuerzo» o «Cena» y completa con otras recetas.\n\nPara elegir las tuyas: en el plan de comidas, toca la rueda dentada junto a «+».';

  @override
  String get dontShowAgain => 'No volver a mostrar';

  @override
  String get mealDiceNoMatches =>
      'Ninguna receta coincide con las categorías y etiquetas elegidas para esta comida.';

  @override
  String mealDiceFewMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Solo $count recetas coinciden',
      one: 'Solo 1 receta coincide',
    );
    return '$_temp0';
  }

  @override
  String get commentsTitle => 'Comentarios';

  @override
  String get commentHint => 'Escribe un comentario…';

  @override
  String get commentSaveFailed => 'No se pudo guardar el comentario.';

  @override
  String get commentDeleteConfirm => '¿Eliminar este comentario?';

  @override
  String get cookingDoneCommentLabel => 'Comentario (opcional)';

  @override
  String get cookingDoneCommentHint =>
      '¿Qué tal salió? Consejos para la próxima vez…';

  @override
  String get nutritionTitle => 'Información nutricional';

  @override
  String get nutritionPerServing => 'por ración';

  @override
  String get nutritionCalories => 'Calorías';

  @override
  String get nutritionFat => 'Grasas';

  @override
  String get nutritionSaturatedFat => 'Grasas saturadas';

  @override
  String get nutritionTransFat => 'Grasas trans';

  @override
  String get nutritionUnsaturatedFat => 'Grasas insaturadas';

  @override
  String get nutritionCholesterol => 'Colesterol';

  @override
  String get nutritionSodium => 'Sodio';

  @override
  String get nutritionCarbohydrates => 'Carbohidratos';

  @override
  String get nutritionFiber => 'Fibra';

  @override
  String get nutritionSugar => 'Azúcar';

  @override
  String get nutritionProtein => 'Proteínas';

  @override
  String get timelineTitle => 'Cronología';

  @override
  String get timelineMadeThis => 'Lo hice';

  @override
  String timelineUserMadeThis(String name) {
    return '$name hizo esto';
  }

  @override
  String get timelineEmpty => 'Todavía no hay entradas en la cronología.';

  @override
  String get timelineDate => 'Fecha';

  @override
  String get timelineNoteHint => 'Nota (opcional)';

  @override
  String get timelineAddPhoto => 'Añadir foto';

  @override
  String get timelineRemovePhoto => 'Quitar foto';

  @override
  String get timelineSaved => 'Añadido a la cronología';

  @override
  String get timelineSaveFailed => 'No se pudo añadir a la cronología';

  @override
  String get timelineImageFailed =>
      'Entrada guardada, pero no se pudo subir la foto';

  @override
  String get timelineDeleteConfirm =>
      '¿Eliminar esta entrada de la cronología?';

  @override
  String get timelineEditNote => 'Editar nota';

  @override
  String get timelineUnknownRecipe => 'Receta no encontrada';

  @override
  String get cookingDonePhotoHint =>
      'Foto para la cronología de Mealie (opcional)';

  @override
  String get assetsTitle => 'Adjuntos';

  @override
  String get assetsAdd => 'Añadir adjunto';

  @override
  String get assetsChooseFile => 'Archivo';

  @override
  String get assetsUploading => 'Subiendo…';

  @override
  String get assetsUploadFailed => 'No se pudo subir el adjunto';

  @override
  String assetsDeleteConfirm(String name) {
    return '¿Quitar «$name» de los adjuntos?';
  }

  @override
  String get assetsOpenFailed => 'No se pudo abrir el adjunto';

  @override
  String get assetsUnsupported =>
      'Mealie solo admite PDF, imágenes, TXT, MD, CSV y JSON.';

  @override
  String get assetsShare => 'Compartir';

  @override
  String get mealRulesTitle => 'Reglas de Mealie';

  @override
  String get mealRulesHint =>
      'También se usan en la web de Mealie. Si varias reglas se aplican al día y la comida, deben cumplirse todas. Si no se aplica ninguna, el dado elige entre todas las recetas.';

  @override
  String get mealRuleAdd => 'Añadir regla';

  @override
  String get mealRuleNewTitle => 'Nueva regla';

  @override
  String get mealRuleEditTitle => 'Editar regla';

  @override
  String get mealRuleDay => 'Día';

  @override
  String get mealRuleAnyDay => 'Cualquier día';

  @override
  String get mealRuleMealType => 'Comida';

  @override
  String get mealRuleAnyMeal => 'Cualquier comida';

  @override
  String get mealRuleConditionsTitle => 'Condiciones';

  @override
  String get mealRuleAllRecipes => 'Todas las recetas';

  @override
  String get mealRuleDeleteConfirm => '¿Eliminar esta regla?';

  @override
  String get mealRulesOffline =>
      'Las reglas de Mealie no están disponibles ahora; el dado usa la selección de la app.';

  @override
  String get mealRulesNoMatches =>
      'Ninguna receta cumple las reglas de Mealie para esta comida.';

  @override
  String get mealTypeSide => 'Guarnición';

  @override
  String get mealTypeSnack => 'Tentempié';

  @override
  String get mealTypeDrink => 'Bebida';

  @override
  String get mealTypeDessert => 'Postre';

  @override
  String get foodsTitle => 'Alimentos';

  @override
  String get unitsTitle => 'Unidades';

  @override
  String get newFood => 'Nuevo alimento';

  @override
  String get newUnit => 'Nueva unidad';

  @override
  String get editFood => 'Editar alimento';

  @override
  String get editUnit => 'Editar unidad';

  @override
  String get pluralNameLabel => 'Nombre en plural';

  @override
  String get abbreviationLabel => 'Abreviatura';

  @override
  String get pluralAbbreviationLabel => 'Abreviatura en plural';

  @override
  String get mergeAction => 'Combinar';

  @override
  String mergeIntoTitle(String name) {
    return 'Combinar «$name» con…';
  }

  @override
  String mergeConfirm(String from, String to) {
    return '«$from» se combinará con «$to»: todas las recetas y listas de la compra usarán después «$to» y «$from» se eliminará.';
  }

  @override
  String get mergeFailed => 'No se pudo combinar';

  @override
  String foodUnitDeleteConfirm(String name) {
    return '¿Eliminar «$name»? Los ingredientes que lo usan perderán la referencia.';
  }

  @override
  String get foodsUnitsEmpty => 'Todavía no hay entradas.';

  @override
  String mealRuleConditionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count condiciones',
      one: '1 condición',
    );
    return '$_temp0';
  }

  @override
  String get showAll => 'Mostrar todo';

  @override
  String get mealDiceModeTitle => 'El dado usa';

  @override
  String get mealDiceModeApp => 'Selección de la app';

  @override
  String get switchListTitle => 'Cambiar de lista';

  @override
  String get newShoppingList => 'Nueva lista de la compra';

  @override
  String shoppingListDeleteConfirm(String name) {
    return '¿Eliminar «$name»? También se eliminarán todos sus artículos.';
  }

  @override
  String get labelOrderTitle => 'Ordenar secciones';

  @override
  String get labelOrderHint =>
      'Arrastra para ordenar. Se aplica a esta lista, también en la web de Mealie.';

  @override
  String get labelOrderEmpty => 'Esta lista todavía no tiene secciones.';

  @override
  String get useAsActiveList => 'Usar como lista activa';

  @override
  String get activeListBadge => 'Activa';

  @override
  String get foodLabelLabel => 'Sección';

  @override
  String get foodNoLabel => 'Sin sección';

  @override
  String get aliasesLabel => 'Alias';

  @override
  String get aliasAddHint => 'Añadir alias';

  @override
  String get foodOnHand => 'Disponible en el hogar';

  @override
  String get timelineChildRecipesTitle =>
      'Añadir también a las recetas vinculadas';

  @override
  String timelineMadeForRecipe(String recipe) {
    return 'Hecho para $recipe';
  }

  @override
  String get timelineFilter => 'Filtrar entradas';

  @override
  String get timelineTypeComment => 'Cocinado y notas';

  @override
  String get timelineTypeInfo => 'Información';

  @override
  String get timelineTypeSystem => 'Sistema';

  @override
  String get listManagementTitle => 'Listas de la compra';

  @override
  String get managementTitle => 'Más';

  @override
  String get pinToHome => 'Añadir a la pantalla de inicio';

  @override
  String get unpinFromHome => 'Quitar de la pantalla de inicio';

  @override
  String homeScreenFull(int count) {
    return 'La pantalla de inicio está llena: máximo $count mosaicos. Quita primero otro en «Más».';
  }

  @override
  String get selectAction => 'Seleccionar';

  @override
  String selectedCount(int count) {
    return '$count seleccionados';
  }

  @override
  String get assignLabelAction => 'Asignar sección';

  @override
  String get assignLabelOverwriteHint =>
      'Sobrescribe la sección de todos los alimentos seleccionados.';

  @override
  String deleteSelectedConfirm(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '¿Eliminar $count entradas?',
      one: '¿Eliminar 1 entrada?',
    );
    return '$_temp0';
  }

  @override
  String get seedDataAction => 'Cargar datos predeterminados';

  @override
  String get seedFoodsHint =>
      'Crea los alimentos predeterminados de Mealie en el idioma elegido.';

  @override
  String get seedUnitsHint =>
      'Crea las unidades predeterminadas de Mealie en el idioma elegido.';

  @override
  String get seedLanguageLabel => 'Idioma';

  @override
  String get seedDuplicateWarning =>
      'Ya tienes entradas. Mealie no resuelve duplicados; tendrás que combinarlos tú después.';

  @override
  String get seedDone => 'Datos predeterminados creados';

  @override
  String get seedFailed => 'No se pudieron cargar los datos predeterminados';

  @override
  String get exportAction => 'Exportar';

  @override
  String get substitutionsLabel => 'Sustitutos';

  @override
  String get substitutionAddHint => 'Añadir sustituto';

  @override
  String get substitutionFoodLabel => 'Alimento (opcional)';

  @override
  String get substitutionNoteLabel => 'Nota (opcional)';

  @override
  String get substitutionNeedOne => 'Indica un alimento o una nota';

  @override
  String get useAbbreviationLabel => 'Usar abreviatura';

  @override
  String get useAbbreviationHint =>
      'Mostrar «g» en lugar de «gramo» en las recetas';

  @override
  String get fractionLabel => 'Mostrar como fracción';

  @override
  String get fractionHint => '½ en lugar de 0,5';

  @override
  String get standardizationTitle => 'Estandarización';

  @override
  String get standardizationHint =>
      'Para conversiones: 1 de esta unidad equivale a… (p. ej., 1 cda = 15 mililitros).';

  @override
  String get standardQuantityLabel => 'Cantidad estándar';

  @override
  String get standardUnitLabel => 'Unidad estándar';

  @override
  String get standardUnitNone => 'Ninguna';

  @override
  String get stdFluidOunce => 'Onza líquida (fl oz)';

  @override
  String get stdCup => 'Taza (EE. UU.)';

  @override
  String get stdOunce => 'Onza (oz)';

  @override
  String get stdPound => 'Libra (lb)';

  @override
  String get stdMilliliter => 'Mililitro';

  @override
  String get stdLiter => 'Litro';

  @override
  String get stdGram => 'Gramo';

  @override
  String get stdKilogram => 'Kilogramo';

  @override
  String get labelsTitle => 'Secciones';

  @override
  String get newLabel => 'Nueva sección';

  @override
  String get editLabel => 'Editar sección';

  @override
  String get colorLabel => 'Color';

  @override
  String labelDeleteConfirm(String name) {
    return '¿Eliminar «$name»? Los artículos y alimentos perderán esta sección.';
  }

  @override
  String get importMenuAction => 'Importar';

  @override
  String get archivedEmpty =>
      'Todavía no hay compras archivadas. Toca «Completar Compra» después de comprar: los artículos marcados se guardarán aquí.';

  @override
  String get sectionTitleLabel => 'Título de la sección';

  @override
  String get clearSection => 'Quitar sección';

  @override
  String get noPermissionGeneric =>
      'No tienes permiso para esto en Mealie. Pregunta a un administrador o gestor del hogar.';

  @override
  String get noPermissionEditRecipe =>
      'No puedes editar esta receta: está bloqueada o pertenece a otro hogar. Solo su creador o un administrador pueden hacerlo.';

  @override
  String get noPermissionDeleteRecipe =>
      'Solo el creador de la receta o un administrador pueden eliminarla.';

  @override
  String get noPermissionDemoteSelf =>
      'No puedes quitarte tus propios permisos de administrador.';

  @override
  String get recipeLockedHint => 'Bloqueada: solo su creador puede editarla';

  @override
  String get recipeDeleteOwnerOnlyHint =>
      'Solo su creador o un administrador pueden eliminarla';

  @override
  String get organizeReadOnlyHint =>
      'Solo lectura: crear, cambiar y eliminar requiere el permiso «El usuario puede administrar comidas, etiquetas y categorías».';

  @override
  String get notesNotSavedNoPermission =>
      'Nota no guardada: no tienes permiso para editar esta receta.';

  @override
  String get userManagementTitle => 'Gestión de Usuarios';

  @override
  String get usersTitle => 'Usuarios';

  @override
  String get editUserTitle => 'Editar Usuario';

  @override
  String get fullNameLabel => 'Nombre completo';

  @override
  String get usernameLabel => 'Usuario';

  @override
  String get emailLabel => 'Correo electrónico';

  @override
  String get passwordLabel => 'Contraseña';

  @override
  String get householdLabel => 'Casa';

  @override
  String get permissionsTitle => 'Permisos';

  @override
  String get administratorLabel => 'Administrador';

  @override
  String get permCanInvite => 'El usuario puede invitar a otros al grupo';

  @override
  String get permCanManage =>
      'El usuario puede administrar la configuración del grupo';

  @override
  String get permCanManageHousehold => 'El usuario puede administrar el hogar';

  @override
  String get permCanOrganize =>
      'El usuario puede administrar comidas, etiquetas y categorías';

  @override
  String get advancedFeaturesLabel => 'Habilitar Características Avanzadas';

  @override
  String get passwordResetLinkAction =>
      'Generar enlace para restablecer contraseña';

  @override
  String get resetLockedUsersAction => 'Restablecer usuarios bloqueados';

  @override
  String get membersTitle => 'Miembros';

  @override
  String get inviteLinkTitle => 'Link de invitación';

  @override
  String get inviteAction => 'Invitar';

  @override
  String get userUpdated => 'Usuario actualizado';

  @override
  String get createUserTitle => 'Crear usuario';

  @override
  String get userCreated => 'Usuario creado';

  @override
  String userDeleteConfirm(String name) {
    return '¿Eliminar «$name»? La cuenta se eliminará de Mealie.';
  }

  @override
  String get passwordResetLinkCopied =>
      'Enlace copiado: pásaselo al usuario. Solo es válido por tiempo limitado.';

  @override
  String lockedUsersReset(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count usuarios desbloqueados',
      one: '1 usuario desbloqueado',
      zero: 'No hay usuarios bloqueados',
    );
    return '$_temp0';
  }

  @override
  String get inviteUsesLabel => 'Número de usos';

  @override
  String get inviteCreated => 'Enlace de invitación creado';

  @override
  String get inviteEmailHint =>
      'Correo electrónico (opcional: Mealie enviará la invitación)';

  @override
  String get inviteEmailSent => 'Invitación enviada por correo';

  @override
  String get inviteEmailFailed =>
      'No se pudo enviar el correo (¿está configurado SMTP en Mealie?). El enlace sigue funcionando.';

  @override
  String get copyLinkAction => 'Copiar enlace';

  @override
  String get youLabel => 'Tú';

  @override
  String get membersPermissionsHint =>
      'Puedes cambiar los permisos de los miembros de tu hogar, pero no los tuyos.';

  @override
  String get householdManagementTitle => 'Gestión de la Casa';

  @override
  String get householdsTitle => 'Casas';

  @override
  String get createHouseholdTitle => 'Crear Casa';

  @override
  String get householdNameLabel => 'Nombre de la Casa';

  @override
  String get householdPreferencesTitle => 'Preferencias de la Casa';

  @override
  String get privateHouseholdLabel => 'Casa Privada';

  @override
  String get privateHouseholdHint =>
      'Establecer tu hogar como privado, desactivará todas las opciones de vista pública. Esto sobreescribe cualquier configuración individual de vista pública';

  @override
  String get lockRecipeEditsLabel =>
      'Bloquear la edición de receta de otros hogares';

  @override
  String get lockRecipeEditsHint =>
      'Cuando está habilitado, sólo los usuarios de tu hogar pueden editar las recetas creadas por tu hogar';

  @override
  String get householdRecipePreferencesTitle =>
      'Preferencias de la Receta de la Casa';

  @override
  String get groupsTitle => 'Grupos';

  @override
  String get groupLabel => 'Grupo';

  @override
  String get createGroupTitle => 'Crear Grupo';

  @override
  String get groupNameLabel => 'Nombre del Grupo';

  @override
  String get groupPreferencesTitle => 'Preferencias de grupo';

  @override
  String get privateGroupLabel => 'Grupo privado';

  @override
  String get privateGroupHint =>
      'Establecer tu grupo como privado, desactivará todas las opciones de vista pública. Esto sobreescribe cualquier configuración individual de vista pública';

  @override
  String get firstDayOfWeekLabel => 'Primer día de la semana';

  @override
  String get showAnnouncementsLabel => 'Mostrar anuncios de Mealie';

  @override
  String get recipePublicDefaultLabel =>
      'Permite a los usuarios fuera de tu grupo ver tus recetas';

  @override
  String get recipeShowNutritionDefaultLabel =>
      'Mostrar la información nutricional';

  @override
  String get recipeShowAssetsDefaultLabel => 'Mostrar recursos de las recetas';

  @override
  String get recipeLandscapeDefaultLabel => 'Vista apaisada por defecto';

  @override
  String get recipeDisableCommentsDefaultLabel =>
      'Desactivar los comentarios de los usuarios';

  @override
  String get myHouseholdSection => 'Mi casa';

  @override
  String get myGroupSection => 'Mi grupo';

  @override
  String get preferencesSaved => 'Configuración guardada';

  @override
  String get cannotDeleteWithUsers =>
      'Todavía tiene usuarios: muévelos o elimínalos primero en Gestión de usuarios.';

  @override
  String deleteHouseholdConfirm(String name) {
    return '¿Eliminar la casa «$name»?';
  }

  @override
  String deleteGroupConfirm(String name) {
    return '¿Eliminar el grupo «$name»?';
  }

  @override
  String usersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count usuarios',
      one: '1 usuario',
      zero: 'Sin usuarios',
    );
    return '$_temp0';
  }

  @override
  String get originalUrlLabel => 'URL original';

  @override
  String get copyTextAction => 'Copiar texto';

  @override
  String get copiedToClipboard => 'Copiado al portapapeles';

  @override
  String get changelogEnglishHint =>
      'Las novedades solo están en inglés: con «Copiar texto» puedes pegarlas, por ejemplo, en un traductor.';

  @override
  String get favoritesTitle => 'Favoritos';

  @override
  String get favoritesEmpty =>
      'Aún no hay favoritos. Toca el corazón en una receta para guardarla aquí.';

  @override
  String get changelogTitle => 'Changelog';

  @override
  String get changeProfileImage => 'Cambiar foto de perfil';

  @override
  String get profileImageUpdated => 'Foto de perfil actualizada';

  @override
  String get profileImageFailed => 'No se pudo subir la foto de perfil';

  @override
  String get myAccountTitle => 'Mi cuenta';

  @override
  String get ownAccountHint =>
      'Aquí puedes editar tu propia cuenta. Los demás usuarios los gestionan los administradores y los miembros con el permiso «gestionar».';

  @override
  String get changePasswordAction => 'Cambiar contraseña';

  @override
  String get currentPasswordLabel => 'Contraseña actual';

  @override
  String get newPasswordLabel => 'Nueva contraseña';

  @override
  String get confirmPasswordLabel => 'Confirmar contraseña';

  @override
  String get passwordTooShort => 'Al menos 8 caracteres';

  @override
  String get passwordsDoNotMatch => 'Las contraseñas no coinciden';

  @override
  String get passwordUpdated => 'Contraseña actualizada';

  @override
  String get passwordChangeFailed => 'No se pudo cambiar la contraseña';

  @override
  String passwordManagedExternally(String method) {
    return 'Inicias sesión mediante $method: cambia tu contraseña allí.';
  }

  @override
  String get bulkAddHint => 'Una línea por entrada.';

  @override
  String bulkAddCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Añadir $count entradas',
      one: 'Añadir 1 entrada',
    );
    return '$_temp0';
  }

  @override
  String get linkRecipeAction => 'Vincular receta';

  @override
  String get useFoodAction => 'Usar alimento en lugar de receta';

  @override
  String get addSubstitutionsAction => 'Añadir sustituciones';

  @override
  String get clearSubstitutionsAction => 'Quitar sustituciones';

  @override
  String get recipeSubstitutionsTitle => 'Sustituciones';

  @override
  String get substitutionUnknownFood =>
      'Solo alimentos existentes; si no, usa la nota';

  @override
  String get insertAboveAction => 'Insertar arriba';

  @override
  String get insertBelowAction => 'Insertar debajo';

  @override
  String get moveToTopAction => 'Mover al inicio';

  @override
  String get moveToBottomAction => 'Mover al fondo';

  @override
  String get linkReferencesAction => 'Vincular referencias';

  @override
  String get editMarkdownAction => 'Editar Markdown';

  @override
  String get previewMarkdownAction => 'Vista previa Markdown';

  @override
  String get insertStepImageAction => 'Subir imagen';

  @override
  String get mergeAboveAction => 'Combinar por encima';

  @override
  String get linkedToOtherStep => 'Enlazado a otro paso';

  @override
  String get noNotesToLink => 'No hay notas para vincular';

  @override
  String get ownerLabel => 'Propietario';

  @override
  String get ingredientParserTitle => 'Analizador de ingredientes';

  @override
  String ingredientParserHint(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count ingredientes aún no están estructurados. Elige un analizador, revisa el resultado y aplícalo.',
      one:
          '1 ingrediente aún no está estructurado. Elige un analizador, revisa el resultado y aplícalo.',
    );
    return '$_temp0';
  }

  @override
  String get parserNlp => 'Procesador de lenguaje natural';

  @override
  String get parserBrute => 'Analizador bruto';

  @override
  String get parserOpenai => 'Analizador OpenAI';

  @override
  String get parserApp => 'Sin conexión (app)';

  @override
  String get parseFailed => 'Error al analizar';

  @override
  String get parseAction => 'Analizar';

  @override
  String applyParsedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Aplicar $count ingredientes',
      one: 'Aplicar 1 ingrediente',
      zero: 'Nada seleccionado',
    );
    return '$_temp0';
  }

  @override
  String get parsedNewBadge => 'nuevo';

  @override
  String get hoursShort => 'h';

  @override
  String get minutesShort => 'min';

  @override
  String get timeExtraHint => 'Extra, p. ej. «más toda la noche»';

  @override
  String get yieldLabel => 'Raciones';

  @override
  String get yieldTextLabel => 'Texto de raciones';

  @override
  String get prepTimeLabel => 'Tiempo de preparación';

  @override
  String get performTimeLabel => 'Tiempo de cocción';

  @override
  String get totalTimeLabel => 'Tiempo total';

  @override
  String get settingPublicRecipe => 'Receta pública';

  @override
  String get settingShowNutrition => 'Mostrar valores nutricionales';

  @override
  String get settingShowAssets => 'Mostrar recursos';

  @override
  String get settingLandscapeView => 'Vista apaisada';

  @override
  String get settingDisableComments => 'Desactivar comentarios';

  @override
  String get settingDisableAmount => 'Desactivar cantidades de ingredientes';

  @override
  String get settingLocked => 'Bloqueada';

  @override
  String get settingLockedOwnerOnly =>
      'Solo el creador puede bloquear o desbloquear la receta.';

  @override
  String get apiExtrasTitle => 'API Extras';

  @override
  String get apiExtrasHint =>
      'Pares clave/valor personalizados para aplicaciones de terceros, p. ej. para activar automatizaciones.';

  @override
  String get extraKeyLabel => 'Clave';

  @override
  String get extraValueLabel => 'Valor';

  @override
  String get addExtraAction => 'Añadir extra';

  @override
  String durationHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count horas',
      one: '1 hora',
    );
    return '$_temp0';
  }

  @override
  String durationMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutos',
      one: '1 minuto',
    );
    return '$_temp0';
  }

  @override
  String get discardChangesConfirm => '¿Descartar los cambios no guardados?';

  @override
  String get discardChanges => 'Descartar cambios';

  @override
  String get imageFromUrl => 'Imagen desde URL';

  @override
  String get deleteRecipeImage => 'Borrar la imagen de la receta';

  @override
  String get deleteRecipeImageConfirm =>
      '¿Estás seguro de que quieres borrar esta imagen de la receta?';

  @override
  String get bulkAddIngredients => 'Añadir ingredientes en masa';

  @override
  String get bulkAddSteps => 'Añadir pasos en masa';

  @override
  String get stepImageFailed => 'No se pudo subir la imagen';

  @override
  String get servingsAndTimes => 'Porciones y tiempos';

  @override
  String get recipeSettingsTitle => 'Ajustes de la receta';

  @override
  String get jsonEditorTitle => 'Editor de JSON';

  @override
  String get jsonInvalid => 'JSON no válido: revísalo.';

  @override
  String get editorOfflineHint =>
      'Abierto sin conexión: para guardar se necesita conexión. Los campos nuevos de Mealie (p. ej. sustituciones) se conservan sin cambios.';

  @override
  String get parseLineFailed => 'No reconocido: se mantiene sin cambios';

  @override
  String get createManualTitle => 'Crear receta manualmente';

  @override
  String get createManualHint =>
      'Introduce un nombre: después añade ingredientes, pasos, imagen y todo lo demás en el editor de recetas.';

  @override
  String get createManualButton => 'Crear y editar';

  @override
  String get changelogEmpty => 'Todavía no hay entradas para esta versión.';

  @override
  String get finderDescription =>
      'Busca recetas basadas en los ingredientes que tengas disponibles. También puede filtrar por utensilios disponibles, y establecer un número máximo de ingredientes o herramientas que faltan.';

  @override
  String get finderSelectedIngredients => 'Ingredientes seleccionados';

  @override
  String get finderNoIngredientsSelected => 'Ningún ingrediente seleccionado';

  @override
  String get finderMissing => 'Faltan';

  @override
  String get finderNoRecipesFound => 'No se encontraron recetas';

  @override
  String get finderNoRecipesFoundDescription =>
      'Intenta añadir más ingredientes a tu búsqueda o ajustar tus filtros';

  @override
  String get finderIncludeFoodsOnHand => 'Incluye ingredientes a mano';

  @override
  String get finderIncludeToolsOnHand => 'Incluye utensilios disponibles';

  @override
  String get finderIncludeSubstitutions => 'Incluir sustitutos';

  @override
  String get finderSubstituting => 'Sustituyendo';

  @override
  String finderSubstituteForFood(String substitute, String food) {
    return '$substitute en lugar de $food';
  }

  @override
  String get finderMaxMissingIngredients => 'Máximo de ingredientes que faltan';

  @override
  String get finderMaxMissingTools => 'Máximo de utensilios que faltan';

  @override
  String get finderSelectedTools => 'Utensilios seleccionados';

  @override
  String get finderReadyToMake => 'Listo para hacer';

  @override
  String get finderAlmostReadyToMake => 'Casi listo para hacer';

  @override
  String get finderSettings => 'Ajustes';

  @override
  String get finderLoadingRecipes => 'Cargando recetas';

  @override
  String get finderClearSelection => 'Borrar selección';

  @override
  String get finderOfflineHint =>
      'Sin conexión con el servidor: los resultados proceden de las recetas guardadas en este dispositivo.';

  @override
  String addIngredientsSkippedOnHand(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Añadido a la lista de compras: se omitieron $count ingredientes disponibles.',
      one: 'Añadido a la lista de compras: se omitió 1 ingrediente disponible.',
    );
    return '$_temp0';
  }

  @override
  String get sendPeerOfflineHint =>
      'No disponible ahora – llegará cuando se abra la app en ese dispositivo';

  @override
  String sendDeliveredLater(String device) {
    return '«$device» no está disponible ahora. La receta llegará en cuanto se abra la app en ese dispositivo.';
  }

  @override
  String get sendQueuedOffline =>
      'Sin conexión ahora. La receta se enviará automáticamente cuando vuelvas a estar en línea.';

  @override
  String get searchHasAll => 'Tiene todo';

  @override
  String get searchHasAny => 'Tiene alguna';

  @override
  String get recipeFilterTitle => 'Filtro';

  @override
  String get finderOtherFilters => 'Otros filtros';

  @override
  String get qfOpEquals => 'es igual a';

  @override
  String get qfOpNotEquals => 'no se corresponde';

  @override
  String get qfOpGreater => 'es mayor que';

  @override
  String get qfOpGreaterEq => 'es mayor que o igual a';

  @override
  String get qfOpLess => 'es menor que';

  @override
  String get qfOpLessEq => 'es menor que o igual a';

  @override
  String get qfOpNewerThan => 'es más reciente que';

  @override
  String get qfOpOlderThan => 'es anterior a';

  @override
  String qfDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'hace $count días',
      one: 'hace 1 día',
    );
    return '$_temp0';
  }

  @override
  String get filterResetAll => 'Restablecer todos los filtros';

  @override
  String get filterAny => 'Todos';

  @override
  String get filterOfflineIgnored =>
      'Sin conexión, los «Otros filtros» solo se aplican en su forma sencilla.';

  @override
  String linkedRecipesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count recetas vinculadas',
      one: 'Una receta vinculada',
      zero: 'No hay recetas vinculadas',
    );
    return '$_temp0';
  }

  @override
  String get shoppingReminderNotificationsOff =>
      'Las notificaciones de Mealie Recipes están desactivadas; sin ellas no puede aparecer el recordatorio de compra. Actívalas en los ajustes.';

  @override
  String get shoppingReminderInactiveHint =>
      'El recordatorio de compra no puede funcionar ahora: permite el acceso a la ubicación «Siempre» y las notificaciones.';

  @override
  String get bulkImportTitle => 'Importación masiva desde URL';

  @override
  String get bulkImportDescription =>
      'El importador masivo de recetas te permite importar múltiples recetas a la vez poniendo en cola los sitios en el backend y ejecutando la tarea en segundo plano. Esto puede ser útil al migrar inicialmente a Mealie, o cuando desea importar un gran número de recetas.';

  @override
  String get bulkAddTitle => 'Añadir en masa';

  @override
  String get bulkImportSetOrganizers => 'Establecer categorías y etiquetas';

  @override
  String get bulkImportStarted =>
      'El proceso de importación masiva se ha iniciado';

  @override
  String get bulkImportFailed => 'El proceso de importación masiva ha fallado';

  @override
  String get bulkImportReports => 'Importación masiva';

  @override
  String get bulkImportUrlHint => 'URL de la receta';

  @override
  String get migrationsTitle => 'Migración de datos';

  @override
  String get migrationsDescription =>
      'Las recetas pueden migrarse desde otra aplicación soportada a Mealie. Esta es una excelente manera de empezar con Mealie. Mover datos entre las instancias de Mealie, o restaurar una copia de seguridad de Mealie anterior, se hace con las herramientas de copia de seguridad y restauración.';

  @override
  String get migrationNew => 'Nueva Migración';

  @override
  String get migrationChooseType => 'Elegir tipo de migración';

  @override
  String get noFileSelected => 'Ningún Archivo Seleccionado';

  @override
  String migrationTagAll(String tag) {
    return 'Etiqueta todas las recetas con la etiqueta $tag';
  }

  @override
  String get migrationPrevious => 'Migraciones Anteriores';

  @override
  String get migrationMealieDescription =>
      'Mealie puede importar recetas de la aplicación Mealie desde una versión pre v1.0. Exporta tus recetas de tu antigua instancia y sube el archivo zip a continuación. Tenga en cuenta que sólo se pueden importar recetas de la exportación. Esto sólo se aplica a instancias anteriores a v1. . Una copia de seguridad tomada de la v1.0 o posterior debería ser restaurada con las herramientas de copia de seguridad y restauración.';

  @override
  String get migrationChowdownDescription =>
      'Mealie soporta nativamente el formato de repositorio chowdown. Descarga el código del repositorio como un archivo .zip y súbelo abajo.';

  @override
  String get migrationCopyMeThatDescription =>
      'Mealie puede importar recetas desde Copie Me That. Exporta tus recetas en formato HTML, luego sube el archivo .zip.';

  @override
  String get migrationMyRecipeBoxDescription =>
      'Mealie puede importar recetas de My Recipe Box. Exporta tus recetas en formato CSV y sube el archivo a continuación.';

  @override
  String get migrationNextcloudDescription =>
      'Las recetas Nextcloud se pueden importar desde un archivo zip que contiene los datos almacenados en Nextcloud. Consulte la estructura de carpetas de ejemplo a continuación para asegurarse de que sus recetas pueden ser importadas.';

  @override
  String get migrationPaprikaDescription =>
      'Mealie puede importar recetas de la aplicación Paprika. Exporta tus recetas de paprika, renombra la extensión del fichero a .zip y súbala a continuación.';

  @override
  String get migrationPlanToEatDescription =>
      'Mealie puede importar recetas de Plan to Eat.';

  @override
  String get migrationRecipeKeeperDescription =>
      'Mealie puede importar recetas de Recipe Keeper. Exporta tus recetas en formato zip y luego sube el archivo a continuación.';

  @override
  String get migrationTandoorDescription =>
      'Mealie puede importar recetas de Tandoor. Exporta tus datos en el formato \"Por defecto\" y luego sube el archivo .zip.';

  @override
  String get migrationCooknDescription =>
      'Mealie no puede importar recetas de DVO Cook\'n X3. Exporta un recetario o un menú en el formato \"Cook\'n\", renómbralo a la extensión .zip y sube el .zip en la sección de abajo.';

  @override
  String get reportTitle => 'Informe';

  @override
  String get recipeDataTitle => 'Datos de la receta';

  @override
  String get recipeDataDescription =>
      'Utiliza esta sección para gestionar los datos asociados a tus recetas. Puedes realizar varias acciones de forma masiva en tus recetas, como exportar, eliminar, etiquetar y asignar categorías.';

  @override
  String get recipeDataTagTitle => 'Etiquetar Recetas';

  @override
  String get recipeDataCategorizeTitle => 'Categorizar recetas';

  @override
  String get recipeDataSettingsTitle => 'Actualizar configuración';

  @override
  String get recipeDataExportTitle => 'Exportar recetas';

  @override
  String get recipeDataDeleteTitle => 'Borrar Recetas';

  @override
  String recipeDataExportConfirm(int count) {
    return 'Las siguientes recetas ($count) serán exportadas.';
  }

  @override
  String get recipeDataExportsTitle => 'Exportación de datos';

  @override
  String get recipeDataExportsDescription =>
      'Esta sección proporciona enlaces a las exportaciones disponibles listas para descargar. Estas exportaciones caducan, así que asegúrate de descargarlas mientras estén disponibles.';

  @override
  String get recipeDataPurgeExports => 'Limpiar exportaciones';

  @override
  String get recipeDataPurgeConfirm =>
      '¿Está seguro de que desea eliminar todos sus datos de exportación?';

  @override
  String get recipeActionsTitle => 'Acciones de Receta';

  @override
  String get recipeActionNew => 'Nueva Acción de Receta';

  @override
  String get recipeActionEdit => 'Editar Acción de Receta';

  @override
  String get recipeActionTypeLink => 'Enlace';

  @override
  String get recipeActionTypePost => 'Publicar';

  @override
  String get webhooksTitle => 'Webhooks';

  @override
  String get webhooksDescription =>
      'Los webhooks definidos a continuación se ejecutarán cuando una comida esté definida para el día. A la hora prevista se enviarán los webhooks con los datos de la receta programada para el día. Tenga en cuenta que la ejecución de webhook no es exacta. Los webhooks se ejecutan en un intervalo de 5 minutos, por lo que los webhooks se ejecutarán en 5 minutos +/- de los programados.';

  @override
  String get webhookName => 'Nombre del Webhook';

  @override
  String get webhookUrl => 'Dirección URL del Webhook';

  @override
  String get notifiersTitle => 'Notificaciones';

  @override
  String get notifiersDescription =>
      'Setup email and push notifications that trigger on specific events.';

  @override
  String get notifierNew => 'Nueva notificación';

  @override
  String get notifierDescription =>
      'Mealie utiliza la biblioteca Apprise para generar notificaciones. Ofrecen muchas opciones para que los servicios se usen para notificaciones. Consulte su wiki para obtener una guía completa sobre cómo crear la URL para su servicio. Si está disponible, seleccionar el tipo de notificación puede incluir características extra.';

  @override
  String get notifierAppriseUrl => 'URL de aviso';

  @override
  String get notifierAppriseUrlSkipped =>
      'URL de Apprise (omitida si está en blanco)';

  @override
  String get notifierAppriseUrlBlankHint =>
      'Dado que las URL de Apprise suelen contener información confidencial, este campo se deja en blanco intencionalmente durante la edición. Si desea actualizar la URL introdúzcala aquí, de lo contrario, déjelo en blanco para conservar la URL actual.\n';

  @override
  String get notifierEnable => 'Habilitar notificador';

  @override
  String get notifierWhatEvents =>
      '¿A qué eventos debe suscribirse este notificador?';

  @override
  String get notifierRecipeEvents => 'Eventos de receta';

  @override
  String get notifierUserEvents => 'Eventos de los usuarios';

  @override
  String get notifierMealplanEvents => 'Eventos del plan de comidas';

  @override
  String get notifierShoppingListEvents => 'Eventos de lista de la compra';

  @override
  String get notifierCookbookEvents => 'Eventos del recetario';

  @override
  String get notifierTagEvents => 'Eventos de etiqueta';

  @override
  String get notifierCategoryEvents => 'Eventos de Categoría';

  @override
  String get notifierLabelEvents => 'Eventos de etiqueta';

  @override
  String get notifierUserSignup => 'Cuando un nuevo usuario se une a tu grupo';

  @override
  String get notifierCreate => 'Crear';

  @override
  String get notifierUpdate => 'Actualizar';

  @override
  String get notifierDelete => 'Eliminar';

  @override
  String get notifierTestSent => 'Mensaje enviado';

  @override
  String get adminTitle => 'Opciones del adminstrador';

  @override
  String get backupsTitle => 'Copias de Seguridad';

  @override
  String get backupsDescription =>
      'Las copias de seguridad son guardados completos de las carpetas database y data del sitio. Esto incluye todo y no puede ser configurado para excluir subconjuntos de datos. Puedes pensar en ello como una \'instantánea\' de Mealie en un momento en específico. Estas sirven para exportar e importar datos, o clonar el sitio a otra ubicación de manera intercompatible.';

  @override
  String get backupCreateHeading => 'Crear una copia de seguridad';

  @override
  String get backupCreated => 'Copia de seguridad creada con éxito';

  @override
  String get backupCreateFailed =>
      'Error al crear la copia de seguridad. Ver archivo de registro';

  @override
  String get backupDelete => 'Eliminar copia de seguridad';

  @override
  String get backupDeleted => 'Copia de seguridad eliminada';

  @override
  String get backupRestore => 'Restaurar copia de seguridad';

  @override
  String get backupRestoreDescription =>
      'Restaurar esta copia de seguridad sobrescribirá todos los datos actuales de su base de datos y del directorio de datos y los sustituirá por el contenido de esta copia. Si la restauración se realiza correctamente, se cerrará su sesión.';

  @override
  String get backupCannotBeUndone =>
      'Esta acción no se puede deshacer, use con precaución.';

  @override
  String get backupAcknowledge =>
      'Entiendo que esta acción es irreversible, destructiva y puede causar pérdida de datos';

  @override
  String get backupRestoreSuccess => 'Restauración exitosa';

  @override
  String get backupRestoreFailed =>
      'Restauración fallida. Compruebe los registros de su servidor para más detalles';

  @override
  String get maintenanceTitle => 'Mantenimiento';

  @override
  String get maintenanceSummary => 'Índice';

  @override
  String get maintenanceStorage => 'Detalle del almacenamiento';

  @override
  String get maintenanceDataDirSize => 'Tamaño del Directorio de Datos';

  @override
  String get maintenanceCleanableDirs => 'Directorios Eliminables';

  @override
  String get maintenanceCleanableImages => 'Imágenes Eliminables';

  @override
  String get maintenanceTempDir => 'Directorio temporal (.temp)';

  @override
  String get maintenanceBackupsDir =>
      'Directorio de Copias de Seguridad (respaldos)';

  @override
  String get maintenanceGroupsDir => 'Directorio de Grupos (grupos)';

  @override
  String get maintenanceRecipesDir => 'Directorio de Recetas (recetas)';

  @override
  String get maintenanceUserDir => 'Directorio de usuario (usuario)';

  @override
  String get maintenanceCleanDirs => 'Limpiar directorios';

  @override
  String get maintenanceCleanDirsDescription =>
      'Remueve todas las carpetas de receta sin UUID válido';

  @override
  String get maintenanceCleanTemp => 'Eliminar archivos temporales';

  @override
  String get maintenanceCleanTempDescription =>
      'Eliminar todos los archivos y carpetas del directorio .temp';

  @override
  String get maintenanceCleanImages => 'Limpiar imágenes';

  @override
  String get maintenanceCleanImagesDescription =>
      'Elimina todas las imágenes que no terminan con .webp';

  @override
  String get maintenanceActions => 'Acciones';

  @override
  String get adminConfiguration => 'Configuración';

  @override
  String get adminAppVersion => 'Versión de la aplicación';

  @override
  String get adminUpToDate => 'Mealie está actualizada';

  @override
  String adminVersionOutdated(String current, String latest) {
    return 'Su versión actual ($current) no coincide con la última versión. Considere actualizar a la última versión ($latest).';
  }

  @override
  String get adminBaseUrl => 'URL base del servidor';

  @override
  String get adminBaseUrlOk =>
      'La URL del servidor no coincide con la predeterminada';

  @override
  String get adminBaseUrlError =>
      '`BASE_URL` sigue siendo el valor por defecto en el servidor API. Esto causará problemas con las notificaciones generadas en el servidor de correos electrónicos, etc.';

  @override
  String adminAuthReady(String provider) {
    return '$provider listo';
  }

  @override
  String adminAuthNotReady(String provider) {
    return '$provider no está listo';
  }

  @override
  String adminAuthDisabled(String provider) {
    return '$provider desactivado';
  }

  @override
  String adminAuthSuccessText(String provider) {
    return 'Todas las variables necesarias de $provider están configuradas.';
  }

  @override
  String adminAuthErrorText(String provider) {
    return 'No todos los valores de $provider están configurados. Puedes ignorarlo si no usas la autenticación $provider.';
  }

  @override
  String adminAuthDisabledText(String envVar) {
    return 'Para activarlo, establece $envVar en true.';
  }

  @override
  String get adminEmailStatus =>
      'Estado de la Configuración del Correo Electrónico';

  @override
  String get adminEmailConfigured => 'Email configurado';

  @override
  String get adminNotReady => 'No Listo - Comprobar variables de ambiente';

  @override
  String get adminSucceeded => 'Logrado';

  @override
  String get adminFailed => 'Error';

  @override
  String get adminSiteStatistics => 'Estadísticas del Sitio';

  @override
  String get adminUncategorized => 'Recetas sin categorizar';

  @override
  String get adminUntagged => 'Recetas sin etiquetar';

  @override
  String get adminGeneralAbout => 'Información General';

  @override
  String get adminVersion => 'Versión';

  @override
  String get adminBuild => 'Compilación';

  @override
  String get adminApplicationMode => 'Modo de Aplicación';

  @override
  String get adminProduction => 'Producción';

  @override
  String get adminDevelopment => 'Desarrollo';

  @override
  String get adminDemoStatus => 'Modo Demo';

  @override
  String get adminDemo => 'Versión Demo';

  @override
  String get adminNotDemo => 'No Demo';

  @override
  String get adminApiPort => 'Puerto de API';

  @override
  String get adminApiDocs => 'Documentación de API';

  @override
  String get adminDatabaseType => 'Tipo de base de datos';

  @override
  String get adminDatabaseUrl => 'URL de base de datos';

  @override
  String get adminDefaultGroup => 'Grupo Predeterminado';

  @override
  String get adminDefaultHousehold => 'Casa predeterminada';

  @override
  String get adminScraperVersion => 'Versión de Analizador de Recetas';

  @override
  String get adminStatUsers => 'Usuarios';

  @override
  String get adminStatHouseholds => 'Casas';

  @override
  String get adminStatGroups => 'Grupos';

  @override
  String get recipeDuplicate => 'Duplicar receta';

  @override
  String get recipeDuplicateAction => 'Duplicar';

  @override
  String get recipeShareLink => 'Compartir receta';

  @override
  String get recipeShareExpiration => 'Fecha de vencimiento';

  @override
  String get recipeShareCopied => 'Enlace copiado al portapapeles';

  @override
  String get enabledLabel => 'Habilitado';

  @override
  String get disabledLabel => 'Deshabilitado';

  @override
  String get testAction => 'Prueba';

  @override
  String get yesLabel => 'Si';

  @override
  String get noLabel => 'No';

  @override
  String get downloadAction => 'Descargar';

  @override
  String get backupUpload => 'Subir';

  @override
  String get zipImportButton => 'Importar desde zip';

  @override
  String get zipImportDescription =>
      'Importa una receta única que fue exportada desde otra instancia de Mealie.';

  @override
  String get reportStatus => 'Estado';

  @override
  String get reportDate => 'Fecha';

  @override
  String get recipeActionTitleLabel => 'Título';

  @override
  String get clearAll => 'Eliminar';

  @override
  String get recipeDataSettingsExplanation =>
      'Los ajustes seleccionados aquí, excluyendo la opción bloqueada, se aplicarán a todas las recetas seleccionadas.';

  @override
  String get adminAllowSignup => 'Permitir registro';

  @override
  String get adminAllowPasswordLogin =>
      'Permitir inicio de sesión con contraseña';

  @override
  String get adminEmailInvalid => 'Introduce una dirección de correo válida.';

  @override
  String adminEmailTestResult(String result) {
    return 'Prueba de correo: $result';
  }

  @override
  String get adminSendTestEmail => 'Enviar correo de prueba';

  @override
  String get adminTestEmailAddress => 'Destinatario';

  @override
  String get backupCreate => 'Crear copia de seguridad';

  @override
  String backupDeleteConfirm(String name) {
    return '¿Eliminar la copia de seguridad «$name»?';
  }

  @override
  String get backupPostgresNote =>
      'Si usas PostgreSQL, revisa el proceso de copia/restauración en la documentación de Mealie antes de restaurar.';

  @override
  String get backupUploaded => 'Copia de seguridad subida';

  @override
  String get backupsEmpty => 'Aún no hay copias de seguridad.';

  @override
  String get bulkImportAddRow => 'Añadir URL';

  @override
  String get bulkImportStart => 'Iniciar importación';

  @override
  String get chooseFileButton => 'Elegir archivo';

  @override
  String get deselectAllAction => 'Deseleccionar todo';

  @override
  String get downloadFailed => 'Error en la descarga';

  @override
  String get fileSaved => 'Archivo guardado';

  @override
  String get loadFailed => 'No se pudo cargar';

  @override
  String get maintenanceActionsWarning =>
      'Las acciones de mantenimiento son destructivas y deben usarse con precaución. Cualquiera de ellas es irreversible.';

  @override
  String get maintenanceConfirm =>
      'Esta acción es destructiva y no se puede deshacer. ¿Continuar?';

  @override
  String get maintenanceDone => 'Hecho';

  @override
  String get maintenanceFailed => 'La acción de mantenimiento falló';

  @override
  String get maintenanceRun => 'Ejecutar';

  @override
  String get migrationFailed => 'La migración falló';

  @override
  String get migrationStart => 'Iniciar migración';

  @override
  String get migrationStarted =>
      'Migración terminada: consulta el informe abajo.';

  @override
  String get moreImportOptions => 'Más opciones de importación';

  @override
  String notifierDeleteConfirm(String name) {
    return '¿Eliminar la notificación «$name»?';
  }

  @override
  String get notifierEdit => 'Editar notificación';

  @override
  String notifierEventCount(int count) {
    return 'Eventos: $count';
  }

  @override
  String get notifierTestFailed => 'No se pudo enviar el mensaje de prueba';

  @override
  String get notifiersEmpty => 'Aún no hay notificaciones.';

  @override
  String recipeActionDeleteConfirm(String name) {
    return '¿Eliminar la acción de receta «$name»?';
  }

  @override
  String get recipeActionFailed => 'La acción de receta falló';

  @override
  String get recipeActionSent => 'Receta enviada';

  @override
  String get recipeActionUrlHint => 'Marcadores';

  @override
  String get recipeActionsDescription =>
      'Las acciones de receta aparecen en el menú de cada receta. «Enlace» abre la URL; «Publicar» hace que el servidor de Mealie envíe la receta a la URL.';

  @override
  String get recipeActionsEmpty => 'Aún no hay acciones de receta.';

  @override
  String recipeDataDeleteConfirm(int count) {
    return '¿Eliminar las recetas seleccionadas ($count)? No se puede deshacer.';
  }

  @override
  String recipeDataDeleteForbidden(int count) {
    return 'No puedes eliminar $count de las recetas seleccionadas (solo su creador o un administrador).';
  }

  @override
  String recipeDataDeleted(int count) {
    return 'Recetas eliminadas: $count';
  }

  @override
  String get recipeDataExportAction => 'Exportar';

  @override
  String get recipeDataExportDone =>
      'Exportación creada: descárgala en Exportaciones de datos.';

  @override
  String recipeDataExportExpires(String date) {
    return 'caduca $date';
  }

  @override
  String get recipeDataExportFailed => 'La exportación falló';

  @override
  String get recipeDataExportsEmpty => 'No hay exportaciones disponibles.';

  @override
  String recipeDataUpdated(int count) {
    return 'Recetas actualizadas: $count';
  }

  @override
  String get recipeDuplicated => 'Receta duplicada';

  @override
  String get recipeExportJson => 'Exportar como JSON';

  @override
  String get recipeExportZip => 'Exportar como ZIP (con imagen)';

  @override
  String get recipeShareCreate => 'Crear enlace';

  @override
  String get recipeShareDescription =>
      'Cualquiera con el enlace puede ver esta receta en el navegador, sin cuenta, hasta que caduque.';

  @override
  String get recipeShareEmpty => 'Aún no hay enlaces compartidos.';

  @override
  String recipeShareExpiresAt(String date) {
    return 'Caduca $date';
  }

  @override
  String get recipeWebToolsMenu => 'Duplicar, enlace para compartir y más';

  @override
  String get reload => 'Recargar';

  @override
  String get reportDeleteConfirm => '¿Eliminar este informe?';

  @override
  String get reportEntries => 'Entradas';

  @override
  String get reportFailedEntries => 'Fallidas';

  @override
  String get reportOnlyFailed => 'Mostrar solo las entradas fallidas';

  @override
  String get reportStatusFailure => 'Error';

  @override
  String get reportStatusInProgress => 'En curso';

  @override
  String get reportStatusPartial => 'Parcial';

  @override
  String get reportStatusSuccess => 'Correcto';

  @override
  String get reportsEmpty => 'Aún no hay informes.';

  @override
  String get uploadFailed => 'Error al subir';

  @override
  String webhookDeleteConfirm(String name) {
    return '¿Eliminar el webhook «$name»?';
  }

  @override
  String get webhookEdit => 'Editar webhook';

  @override
  String get webhookNew => 'Nuevo webhook';

  @override
  String get webhookTestFailed => 'No se pudo iniciar la prueba';

  @override
  String get webhookTestSent => 'Webhook de prueba enviado';

  @override
  String get webhookTime => 'Hora (local)';

  @override
  String get webhooksEmpty => 'Aún no hay webhooks.';

  @override
  String get zipImportFailed => 'La importación ZIP falló';

  @override
  String get aiProvidersTitle => 'Proveedores de IA';

  @override
  String get aiProvidersDescription =>
      'Configure los proveedores de IA para habilitar funciones alimentadas por AI, como análisis mejorado de ingredientes, creando recetas a partir de vídeos, ¡y más!';

  @override
  String get aiProviderSettingsTitle => 'Ajustes de proveedor de IA';

  @override
  String get aiProvidersList => 'Proveedores';

  @override
  String get aiProviderCreate => 'Crear proveedor';

  @override
  String get aiProviderEdit => 'Editar proveedor';

  @override
  String get aiDefaultProvider => 'Proveedor predeterminado';

  @override
  String get aiDefaultProviderDescription =>
      'Necesario para habilitar funciones de IA';

  @override
  String get aiAudioProvider => 'Proveedor de audio';

  @override
  String get aiAudioProviderDescription =>
      'Activa las funciones de transcripción de audio, como la creación de recetas a partir de vídeos';

  @override
  String get aiImageProvider => 'Proveedor de imágenes';

  @override
  String get aiImageProviderDescription =>
      'Permite funciones de reconocimiento de imágenes, como la creación de recetas a partir de imágenes';

  @override
  String get aiProviderName => 'Nombre del proveedor';

  @override
  String get aiApiKey => 'Clave API';

  @override
  String get aiApiKeyCreateDescription =>
      'La clave API de tu proveedor para la autenticación. Si tu servicio (por ejemplo, Ollama) no usa una clave API, todavía tienes que poner algo aquí.';

  @override
  String get aiApiKeyEditDescription =>
      'Deja esto en blanco a menos que quieras cambiarlo.';

  @override
  String get aiBaseUrl => 'URL base';

  @override
  String get aiBaseUrlDescription =>
      'Si estás usando OpenAI deja esto en blanco. Debe ser un endpoint compatible con OpenAI (por ejemplo, \"http://localhost:11434/v1\").';

  @override
  String get aiModel => 'Modelo';

  @override
  String get aiModelDescription =>
      'Qué modelo debe utilizar su proveedor de IA (por ejemplo, \"gpt-5\").';

  @override
  String get aiTimeout => 'Tiempo de espera de solicitud (segundos)';

  @override
  String get aiProviderCreated => 'Proveedor creado';

  @override
  String get aiProviderUpdated => 'Proveedor actualizado';

  @override
  String get aiProviderDeleted => 'Proveedor eliminado';

  @override
  String get aiProviderCreateFailed => 'No se pudo crear el proveedor';

  @override
  String get aiProviderUpdateFailed => 'No se pudo actualizar el proveedor';

  @override
  String get aiProviderDeleteFailed => 'No se pudo eliminar el proveedor';

  @override
  String get aiRequestHeaders => 'Encabezados de solicitud';

  @override
  String get aiRequestParams => 'Parámetros de solicitud';

  @override
  String get aiNoDefaultWarning =>
      'No ha establecido un proveedor por defecto, por lo que las características de IA están desactivadas';

  @override
  String get aiTestConnection => 'Probar conexión';

  @override
  String get aiTestSucceeded => 'Conexión correcta';

  @override
  String get aiTestFailed => 'Error de conexión';

  @override
  String get aiSupportsImages => 'Admite imágenes';

  @override
  String get aiTextOnly => 'Solo texto: no puede ser tu proveedor de imágenes';

  @override
  String get debugAiTitle => 'Depurar proveedores de IA';

  @override
  String get debugAiDescription =>
      'Usa esta página para depurar proveedores de IA. Puedes probar la conexión y ver aquí los resultados. Si tienes servicios de imagen activos, también puedes añadir una imagen.';

  @override
  String get debugParserTitle => 'Procesador';

  @override
  String get debugParserDescription =>
      'Mealie usa CRFs (Campos Condicionales Aleatorios) para analizar y procesar ingredientes. El modelo para ingredientes está basado en un conjunto de más de 100.000 ingredientes de una base de datos perteneciente a New York Times. Ya que el modelo sólo está entrenado en inglés, puede que obtengas resultados variados al utilizar otros lenguajes. Esta página es un sitio de prueba para probar el modelo.';

  @override
  String get debugIngredientText => 'Texto del ingrediente';

  @override
  String get debugTryExample => 'Prueba un ejemplo';

  @override
  String debugAverageConfidence(String value) {
    return '$value Confianza';
  }

  @override
  String get debugRunTest => 'Iniciar prueba';

  @override
  String get debugQuantity => 'Cantidad';

  @override
  String get debugUnit => 'Unidades';

  @override
  String get debugFood => 'Alimentos';

  @override
  String get debugNote => 'Comentario';

  @override
  String get debugGroup => 'Grupo';

  @override
  String get aiProviderNone => 'Ninguno';

  @override
  String aiProviderDeleteConfirm(String name) {
    return '¿Eliminar el proveedor «$name»?';
  }

  @override
  String get aiProvidersEmpty => 'Aún no hay proveedores de IA.';

  @override
  String get aiAdvanced => 'Avanzado';

  @override
  String get aiKeyLabel => 'Nombre';

  @override
  String get aiValueLabel => 'Valor';

  @override
  String get debugTitle => 'Depuración';

  @override
  String get debugParse => 'Analizar';

  @override
  String get debugParseFailed => 'No se pudo analizar el ingrediente';

  @override
  String get debugChooseImage => 'Elegir imagen';

  @override
  String get debugNoImage => 'Sin imagen (opcional)';

  @override
  String get updateTitle => 'Buscar actualizaciones';

  @override
  String get updateInstalledVersion => 'Versión instalada';

  @override
  String get updateLastCheck => 'Última comprobación';

  @override
  String get updateCheckNow => 'Comprobar ahora';

  @override
  String get updateChecking => 'Buscando actualizaciones…';

  @override
  String get updateUpToDate => 'Mealie Recipes está actualizado.';

  @override
  String updateAvailable(String version) {
    return 'La versión $version está disponible';
  }

  @override
  String get updateAvailableDescription =>
      'Hay una nueva versión de Mealie Recipes. No se instalará nada hasta que inicies tú la actualización.';

  @override
  String get updateShow => 'Ver actualización';

  @override
  String get updateLater => 'Más tarde';

  @override
  String updateDownloading(int percent) {
    return 'Descargando… $percent %';
  }

  @override
  String updateReady(String version) {
    return 'La versión $version está lista para instalarse';
  }

  @override
  String get updateInstalling => 'Instalando: la app se reiniciará enseguida…';

  @override
  String get updateManual =>
      'No se pudo instalar automáticamente. Se abrió la imagen de disco: arrastra Mealie Recipes a Aplicaciones.';

  @override
  String get updateFailed => 'La actualización falló';

  @override
  String get updateInstallNow => 'Descargar e instalar';

  @override
  String get updateRestartNow => 'Instalar y reiniciar';

  @override
  String get updateAutoTitle => 'Buscar actualizaciones al iniciar';

  @override
  String get updateAutoDescription =>
      'Solo comprueba y avisa; la instalación siempre la inicias tú.';

  @override
  String get updateNoNotes => 'Sin notas de la versión.';

  @override
  String get updateSourceHint =>
      'Las actualizaciones provienen de las versiones de GitHub de Mealie Recipes y solo se instalan si están firmadas por el desarrollador (macOS).';
}
