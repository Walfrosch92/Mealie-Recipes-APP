// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Mealie Recipes';

  @override
  String get endCookingMode => 'Encerrar modo de cozinha';

  @override
  String get endCookingModeConfirm =>
      'Você realmente deseja encerrar o modo de cozinha?';

  @override
  String endCookingModeConfirmAll(int count) {
    return 'Isso erá fechar $count receitas no modo de cozinha. Continuar?';
  }

  @override
  String get addTimer => 'Adicionar temporizador';

  @override
  String get recipeFinished => 'Sua receita está pronta.';

  @override
  String get bonAppetit => 'Bom apetite!';

  @override
  String get prepareIngredients =>
      'Por favor tenha a mão os seguintes ingredientes';

  @override
  String prepareIngredientsFor(String servings) {
    return 'Por favor tenha a mão os seguintes ingredientes para $servings porçoes';
  }

  @override
  String get next => 'Próximo';

  @override
  String get navHome => 'Início';

  @override
  String get homeCookToday => 'Cozinhe hoje';

  @override
  String get homeSuggestion => 'Suggestões';

  @override
  String get homeQuickAccess => 'Acesso rápido';

  @override
  String get homePlanned => 'Planejado';

  @override
  String get favorite => 'Favorito';

  @override
  String get navSettings => 'Configurações';

  @override
  String homeWelcomeName(Object name) {
    return 'Bem-Vindo $name,';
  }

  @override
  String get homeWelcomeApp => 'ao Mealie Recipes 👋';

  @override
  String get theme => 'Tema';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Escuro';

  @override
  String get recipes => 'Receitas';

  @override
  String get shoppingList => '🛒 Lista de Compras';

  @override
  String get mealplan => 'Plano de refeições';

  @override
  String get settings => '⚙️ Configurações';

  @override
  String get searchRecipe => 'Buscar receita...';

  @override
  String get loadingRecipes => 'Carregando receitas...';

  @override
  String get loadingRecipe => 'Carregando receita...';

  @override
  String errorLoadingRecipes(String error) {
    return 'Erro ao carregar a receita: $error';
  }

  @override
  String get errorLoadingRecipe => 'Não foi possível carregar a receita.';

  @override
  String get noRecipesForCategory => 'Nenhuma receita com esses filtros.';

  @override
  String get resetFilter => 'Resetar filtros';

  @override
  String get allCategories => 'Todas as categorias';

  @override
  String get all => 'Todas';

  @override
  String get sortRecipes => 'Ordenar receitas';

  @override
  String get refreshRecipes => 'Recarregar';

  @override
  String get sortNameAZ => 'Nome A–Z';

  @override
  String get sortNameZA => 'Nome Z–A';

  @override
  String get sortDateNewest => 'Mais recente primeiro';

  @override
  String get sortDateOldest => 'Mais antiga primeiro';

  @override
  String get sortPrepTimeShort => 'Menor tempo de prepararo';

  @override
  String get sortPrepTimeLong => 'Maior tempo de preparo';

  @override
  String get sortRatingHighest => 'Maior avaliação';

  @override
  String get sortRatingLowest => 'Menor avaliação';

  @override
  String get details => 'Detalhes';

  @override
  String get ingredients => 'Ingredientes';

  @override
  String get instructions => 'Instruções';

  @override
  String get tags => 'Tags';

  @override
  String get notes => 'Notas';

  @override
  String get addNote => 'Adicionar nota';

  @override
  String get editNote => 'Editar nota';

  @override
  String get noteTitleHint => 'Título (opcional)';

  @override
  String get noteTextHint => 'Texto da nota';

  @override
  String get deleteNoteTitle => 'Excluir nota?';

  @override
  String get deleteNoteMessage => 'Esta nota será excluída permanentemente.';

  @override
  String get servings => 'Porções';

  @override
  String get adjustQuantity => 'Ajustar quantidade';

  @override
  String get startTimer => 'Iniciar temporizador';

  @override
  String runningTimer(int minutes, String seconds) {
    return 'Temporizador: $minutes:$seconds';
  }

  @override
  String get planMeal => 'Planejar Receita';

  @override
  String get displayAlwaysOn => 'Manter tela acesa';

  @override
  String get addAllIngredients => 'Adicionar todos os ingredientes';

  @override
  String get addSelectedIngredients => 'Adicionar ingredientes selecionados';

  @override
  String get addIngredientsTitle => 'Ingredientes adicionados';

  @override
  String get addIngredientsMessage =>
      'Os ingredientes foram adicionados a sua lista de compras.';

  @override
  String addIngredientsFailedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ingredientes não puderam ser adicionados.',
      one: '1 ingrediente não pôde ser adicionado.',
    );
    return '$_temp0';
  }

  @override
  String get cookbooks => 'Livros de receitas';

  @override
  String get cookbooksEmpty =>
      'Ainda não há livros de receitas. Toque em “+” no canto superior direito para criar um.';

  @override
  String get cookbookNoMatches => 'Nenhuma receita corresponde a este filtro.';

  @override
  String get cookbookCreateTitle => 'Criar livro de receitas';

  @override
  String get cookbookEditTitle => 'Editar livro de receitas';

  @override
  String get cookbookNameLabel => 'Nome do livro de receitas';

  @override
  String get cookbookFilterSectionTitle => 'Adicionar receitas automaticamente';

  @override
  String get cookbookFieldTools => 'Ferramentas';

  @override
  String get cookbookFieldUsers => 'Usuários';

  @override
  String get cookbookOpIsOneOf => 'é um de';

  @override
  String get cookbookOpIsNotOneOf => 'não é nenhum de';

  @override
  String get cookbookOpContainsAll => 'contém todos';

  @override
  String get cookbookSelectValues => 'Selecionar valores';

  @override
  String get cookbookFilterOptionsUnavailable => 'Nenhuma opção disponível';

  @override
  String get cookbookAddFilterField => 'Adicionar campo';

  @override
  String get cookbookPublicLabel => 'Livro de receitas público';

  @override
  String get cookbookPublicSubtitle => 'Visível para outras casas no servidor';

  @override
  String get cookbookRawModeEnter => 'Editar como texto';

  @override
  String get cookbookRawModeExit => 'Voltar ao construtor';

  @override
  String get cookbookRawModeHint =>
      'Modo especialista deste app: edita o filtro diretamente como texto. Útil quando um filtro existente não pôde ser dividido em linhas simples.';

  @override
  String get cookbookRawModeUnparseable =>
      'Este texto não corresponde ao formato simples de linhas — permanece como texto.';

  @override
  String get saveFailed => 'Falha ao salvar';

  @override
  String get search => 'Buscar';

  @override
  String get apply => 'Aplicar';

  @override
  String get setupCachingTitle => 'Carregando suas receitas';

  @override
  String get setupCachingSubtitle =>
      'Suas receitas estão sendo preparadas para uso offline. Dependendo da quantidade, isso pode levar um momento.';

  @override
  String get setupCachingDone => 'Tudo pronto!';

  @override
  String get setupTipsHeader => 'Você sabia?';

  @override
  String get setupFinish => 'Vamos lá';

  @override
  String get setupSkipCaching => 'Continuar em segundo plano';

  @override
  String get setupTip1 =>
      'Você pode importar receitas por link, foto ou PDF — pelo bloco Importar na tela inicial.';

  @override
  String get setupTip2 =>
      'O modo de cozinha mantém a tela ligada, guia você passo a passo e detecta timers no texto automaticamente.';

  @override
  String get setupTip3 =>
      'A lista de compras também funciona offline — as alterações são sincronizadas automaticamente quando o servidor estiver disponível.';

  @override
  String get setupTip4 =>
      'Segure um bloco da tela inicial para reorganizar o acesso rápido.';

  @override
  String get setupTip5 =>
      'Encontre seus livros de receitas do Mealie no bloco Livros de receitas — com suporte offline.';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Deletar';

  @override
  String get edit => 'Editar';

  @override
  String get save => 'Salvar';

  @override
  String get done => 'Concluir';

  @override
  String get close => 'Fechar';

  @override
  String get add => 'Adicionar';

  @override
  String get send => 'Enviar';

  @override
  String get retry => 'Tentar Novamente';

  @override
  String get confirmDeleteTitle => 'Deletar receita?';

  @override
  String get confirmDeleteMessage => 'Essa ação não pode ser desfeita.';

  @override
  String get sendToDevice => 'Enviar para dispositivo';

  @override
  String get sendToDevicePickerTitle => 'Enviar para dispositivo';

  @override
  String get sendToAllDevices => 'Enviar para todos os dispositivos';

  @override
  String get timerFinished => 'Temporizador finalizado!';

  @override
  String get timerFinishedBody => 'O temporizador da sua receita finalizou.';

  @override
  String get timer => 'Temporizador';

  @override
  String get newTimer => 'Novo temporizador';

  @override
  String get timerDetails => 'Detalhes do temporizador';

  @override
  String get timerNamePlaceholder => 'Nome do temporizador';

  @override
  String get timerNameHint => 'Dê um nome descritivo a seu temporizador.';

  @override
  String get durationLabel => 'Duração';

  @override
  String minutesCount(int count) {
    return '$count minutos';
  }

  @override
  String get start => 'Começar';

  @override
  String get stop => 'Parar';

  @override
  String get pause => 'Pausar';

  @override
  String get resume => 'Retomar';

  @override
  String get finished => 'Finalizado!';

  @override
  String stepNumber(int number) {
    return 'Etapa $number';
  }

  @override
  String get minAbbreviation => 'min';

  @override
  String get cookingMode => 'Modo cozinha';

  @override
  String activeRecipesCount(int count) {
    return '$count receitas ativas';
  }

  @override
  String get endAll => 'Parar todas';

  @override
  String get end => 'Parar';

  @override
  String get endAllRecipesTitle => 'Parar todas as sessões de cozinha?';

  @override
  String endAllRecipesMessage(int count) {
    return 'Você quer parar todas as $count sessões de cozinha?';
  }

  @override
  String get endRecipeTitle => 'Parar receita?';

  @override
  String endRecipeMessage(String name) {
    return 'Você quer parar a sessão de cozinha para \"$name\"?';
  }

  @override
  String get noActiveTimers => 'Nenhum tomporizador ativo';

  @override
  String get noActiveRecipes => 'Nenhuma receita ativa';

  @override
  String get startRecipeToCook =>
      'Abra uma receita e aperte o botão de cozinhar para começar.';

  @override
  String get browseRecipes => 'Mostrar receitas';

  @override
  String timersPausedCount(int count) {
    return '$count temporizador(es) pausado(s)';
  }

  @override
  String get cookFriends => 'Cozinhar com amigos';

  @override
  String get cookingModeAddRecipe => 'Adicionar receita';

  @override
  String get cookingModeAddRecipeSearchHint => 'Buscar receita';

  @override
  String get cookFriendsCode => 'Código da Sessão';

  @override
  String get cookFriendsJoin => 'Entrar numa sessão';

  @override
  String get cookFriendsHost => 'Hospedar uma sessão';

  @override
  String get cookFriendsHostNotFound =>
      'Host não encontrado. Verifique se os dispositivos esão no mesmo Wi-Fi e acesso local está habilitado.';

  @override
  String get cookFriendsConnectionFailed =>
      'Erro de conexão. Por favor tente novamente.';

  @override
  String get cookFriendsEnterCode => 'Digite o código';

  @override
  String cookFriendsConnected(int count) {
    return 'Conectados: $count visitantes';
  }

  @override
  String get joinSession => 'Entrar em sessão';

  @override
  String get hostEndedSessionTitle => 'Sessão finalizada';

  @override
  String get hostEndedSessionMessage => 'O host encerrou a sessão.';

  @override
  String get shoppingListEmpty => 'Sua lista de compras está vazia.';

  @override
  String get addItem => 'Adicionar item';

  @override
  String get itemNote => 'Nome do item';

  @override
  String get unlabeledCategory => 'Descategorizado';

  @override
  String get reorderCategories => 'Reorganizar categorias';

  @override
  String get archiveChecked => 'Arquivar itens marcados';

  @override
  String get archivedLists => '📦 Compras arquivadas';

  @override
  String get syncChanges => 'Sincronizar mudanças';

  @override
  String get noSyncChanges => 'Sem mudanças para sincronizar';

  @override
  String get postimportAction => 'Após a importação';

  @override
  String get postimportHint =>
      'Defina o que deve ocorrer no app (Lembretes / Google Tasks) com as entradas importadas.';

  @override
  String get postimportLeave => 'Apenas adicionar';

  @override
  String get postimportComplete => 'Marcar como completo';

  @override
  String get postimportCompleteDelete => 'Marcar como completo e deletar';

  @override
  String get postimportFailed =>
      'O pos-processamento falhou. Os itens ainda foram adicionados ao servidor Mealie.';

  @override
  String get syncChangesTitle => 'Sincronizar mudanças';

  @override
  String get syncSectionChecked => 'Marcado';

  @override
  String get syncSectionQuantity => 'Quantidade';

  @override
  String get syncSectionCategory => 'Categoria';

  @override
  String get syncSectionAdditions => 'Adicionado recentemente';

  @override
  String get syncLocalLabel => 'Local';

  @override
  String get syncServerLabel => 'Servidor';

  @override
  String get syncNow => 'Sincronizar agora';

  @override
  String get offlineBadge => 'Offline';

  @override
  String get mealplanTitle => '📅 Plano alimentar';

  @override
  String get mealplanSelectMode => 'Selecionar várias receitas';

  @override
  String mealplanSelectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count selecionadas',
      one: '1 selecionada',
      zero: 'Seleção',
    );
    return '$_temp0';
  }

  @override
  String get breakfast => 'Café da manhã';

  @override
  String get lunch => 'Almoço';

  @override
  String get dinner => 'Jantar';

  @override
  String get addMealEntry => 'Adicionar receita';

  @override
  String get selectRecipe => 'Selecione a receita';

  @override
  String get orFreeText => 'ou texto livre';

  @override
  String get entryNote => 'Nota';

  @override
  String get noMealEntries => 'Sem entradas essa semana.';

  @override
  String get importRecipe => 'Importar receita';

  @override
  String get importFromUrl => 'Importar de URL';

  @override
  String get importFromImage => 'Importar de foto';

  @override
  String get importFromJson => 'Importar de JSON';

  @override
  String get url => 'URL';

  @override
  String get urlPlaceholder => 'https://...';

  @override
  String get importLanguage => 'Languagem para OCR';

  @override
  String get importing => 'Importando...';

  @override
  String get importSuccess => 'Receita importada com sucesso!';

  @override
  String importError(String error) {
    return 'Erro ao importar: $error';
  }

  @override
  String get pasteJson => 'Colo o JSON aqui';

  @override
  String get setupTitle => 'Bem-vindo ao Mealie Recipes';

  @override
  String get setupSubtitle => 'Por-favor configure o seu servidor Mealie.';

  @override
  String get serverUrl => 'URL do servidor';

  @override
  String get serverUrlPlaceholder => 'https://mealie.example.com';

  @override
  String get apiToken => 'Token de API';

  @override
  String get apiTokenPlaceholder => 'Seu token de API';

  @override
  String get householdId => 'Casa';

  @override
  String get householdIdPlaceholder => 'Familia';

  @override
  String get shoppingListId => 'ID da lista de compras';

  @override
  String get shoppingListIdPlaceholder => 'Selecione uma lista de compras';

  @override
  String get setupHouseholdListTitle => 'Casa e lista de compras';

  @override
  String get shoppingListLabel => 'Lista de compras';

  @override
  String get setupHouseholdManualHint =>
      'Não foi possível carregar as casas — digite o nome manualmente.';

  @override
  String get setupExactTitle => 'Quantidades na lista de compras';

  @override
  String get setupExactBody =>
      'Na maioria dos países ninguém compra com precisão de gramas — vai 1 pacote de manteiga para o carrinho, não 200 g. Por isso, no modo simples o app converte as quantidades das receitas em “1×”. No modo exato, quantidade e unidade são mantidas 1:1 como no site do Mealie — inclusive ao digitar novos itens (ex.: “200 g de manteiga”). Você pode mudar isso a qualquer momento nas configurações.';

  @override
  String get setupExactSimpleTitle => 'Modo simples (1×)';

  @override
  String get setupExactSimpleBody =>
      'Os ingredientes entram na lista como “1× item” — ideal para marcar rapidinho no mercado.';

  @override
  String get setupExactExactTitle => 'Quantidades exatas';

  @override
  String get setupExactExactBody =>
      'Os itens aparecem com quantidade e unidade, ex.: “200 g de manteiga” — igual ao site.';

  @override
  String get connect => 'Connectar';

  @override
  String get connecting => 'Conectando...';

  @override
  String get connectionSuccess => 'Conectado com sucesso!';

  @override
  String connectionError(String error) {
    return 'Erro de conexão: $error';
  }

  @override
  String get optionalHeaders => 'Headers HTTP opicionais (para proxy-reverso)';

  @override
  String get settingsTitle => '⚙️ Configurações';

  @override
  String get settingsSaved => 'Configurações salvas';

  @override
  String get serverSettings => 'Servidor';

  @override
  String get displaySettings => 'Tela';

  @override
  String get notificationSettings => 'Notificações';

  @override
  String get securitySettings => 'Segurança';

  @override
  String get aboutSettings => 'Sobre';

  @override
  String get showRecipeImages => 'Mostrar imagens de receitas';

  @override
  String get apiVersion => 'Versão de API';

  @override
  String get language => 'Languagem';

  @override
  String get biometricLock => 'Bloqueio biométrico';

  @override
  String get biometricLockDescription =>
      'Desbloqueie o aplicativo com digital/reconhecimento facial';

  @override
  String get criticalAlerts => 'Alertas críticos';

  @override
  String get criticalAlertsDescription => 'Alarm de timer com som desativado';

  @override
  String get enableLogging => 'Ativar logs';

  @override
  String get selectLanguage => 'Selecionar linguagem';

  @override
  String get setupContinue => 'Continuar';

  @override
  String get back => 'Voltar';

  @override
  String get setupConnectStep => 'Connecte-se a seu servidor';

  @override
  String get resetSettings => 'Apagar todas as configurações';

  @override
  String get resetSettingsConfirm =>
      'Isso irá apagar todas as suas configurações. Continuar?';

  @override
  String get guestMode => 'Modo visitante';

  @override
  String get appVersion => 'Versão';

  @override
  String get leftoverFinder => 'Localizador de receitas';

  @override
  String get leftoverFinderSubtitle =>
      'Encontre receitas que usam os ingredientes que você tem';

  @override
  String get addIngredient => 'Adicionar ingredientes';

  @override
  String get ingredientPlaceholder => 'ex. ovos';

  @override
  String get findRecipes => 'Encontrar receitas';

  @override
  String get matchingRecipes => 'receitas encontradas';

  @override
  String get noMatchingRecipes =>
      'Nenhuma receita encontrada para esses ingredientes.';

  @override
  String matchPercent(int percent) {
    return '$percent%';
  }

  @override
  String get biometricPrompt => 'Autentique-se para abrir Mealie Recipes';

  @override
  String get biometricFailed => 'Falha de autenticação';

  @override
  String get whatsNew => 'O que há de novo';

  @override
  String get pendingRecipesTitle => 'Receita recebida';

  @override
  String pendingRecipesMessage(String sender, String name) {
    return 'Você recebeu uma receita de $sender: \"$name\"';
  }

  @override
  String pendingRecipesFrom(Object names) {
    return 'De $names';
  }

  @override
  String get pendingRecipesOpenCooking => 'Abrir modo cozinha';

  @override
  String get pendingRecipesLater => 'Depois';

  @override
  String get openRecipe => 'Abrir receita';

  @override
  String get dismiss => 'Ignorar';

  @override
  String get editRecipe => 'Editar Receita';

  @override
  String get recipeName => 'Nome da receita';

  @override
  String get recipeDescription => 'Descrição';

  @override
  String get prepTime => 'Tempo de preparao (min)';

  @override
  String get cookTime => 'Tempo para cozinhar (min)';

  @override
  String get totalTime => 'Tempo total (min)';

  @override
  String get recipeServings => 'Porções';

  @override
  String get rating => 'Nota';

  @override
  String get addIngredientLine => 'Adicionar ingrediente';

  @override
  String get addInstruction => 'Adicionar etapa';

  @override
  String get removeIngredient => 'Remover ingrediente';

  @override
  String get removeInstruction => 'Remover etapa';

  @override
  String get ingredientName => 'Ingrediente';

  @override
  String get ingredientQuantity => 'Qty';

  @override
  String get ingredientUnit => 'Unidade';

  @override
  String get ingredientNote => 'Nota';

  @override
  String get instructionText => 'Texto da etapa';

  @override
  String get categories => 'Categorias';

  @override
  String get selectCategories => 'Selecionar categorias';

  @override
  String get selectTags => 'Selecionar tags';

  @override
  String get uploadImage => 'Upload de imagem';

  @override
  String get removeImage => 'Remover imagem';

  @override
  String get saveChanges => 'Salvar mudanças';

  @override
  String get saving => 'Salvando...';

  @override
  String get saveSuccess => 'Receita salva.';

  @override
  String saveError(String error) {
    return 'Não foi possível salvar: $error';
  }

  @override
  String get newCategory => 'Nova categoria';

  @override
  String get newTag => 'Nova tag';

  @override
  String get setRating => 'Definir nota';

  @override
  String get removeRating => 'Remover nota';

  @override
  String get ratingRemoved => 'Nota removida';

  @override
  String get googleTasksImport => 'Importar do Google Tarefas';

  @override
  String get googleTasksImportDescription =>
      'Importar do Google Tarefas a sua lista de compras.';

  @override
  String get homeWelcome => 'Bem-vindo ao Mealie Recipes! 👋';

  @override
  String homeWelcomeNamed(String name) {
    return 'Bem-vindo $name, ao Mealie Recipes! 👋';
  }

  @override
  String get shopping => 'Compras';

  @override
  String get planning => 'Planejamento';

  @override
  String get other => 'Outro';

  @override
  String get viewRecipes => '📖 Ver Receitas';

  @override
  String get addRecipe => '➕ Adicionar receita';

  @override
  String get completeShopping => 'Completar compras';

  @override
  String get shoppingCompleted => 'Compras completa';

  @override
  String get shoppingCompletedSubtitle => 'Tudo no carrinho! 🎉';

  @override
  String get essensplan => '📅 Plano alimentar';

  @override
  String get resteverwertung => '🥗 Localizador de receitas';

  @override
  String get newRecipeUpload => 'Upload de receita nova';

  @override
  String get copyCode => 'Copiar código';

  @override
  String get shareLink => 'Compartilhar link';

  @override
  String get connectedFriends => 'Amigos gonectados';

  @override
  String get waitingForFriends => 'Aguardando amigos...';

  @override
  String get endSharing => 'Encerrar compartilhamento';

  @override
  String get cookFriendsDescription => 'Convidar um amigo para cozinhar junto';

  @override
  String get sessionCode => 'CÓDIGO DE SESSÃO';

  @override
  String get adjustQuantityLabel => 'Ajuste a quantidade para essa receita:';

  @override
  String get timerStartForStep => 'Temporizador para essa etapa';

  @override
  String get enterRecipeUrl => 'Coloque o link da receita';

  @override
  String get loading => 'Carregando...';

  @override
  String get urlInvalidScheme =>
      'O link precisa começar com http:// or https://';

  @override
  String get urlAddScheme => 'Adicionar https://';

  @override
  String get addItemPlaceholder => 'Adicionar item...';

  @override
  String get addSuccessToast => 'Adicionado!';

  @override
  String get completedItems => 'Completo';

  @override
  String get completeShoppingTitle => 'Completar compras?';

  @override
  String get completeShoppingMessage => 'Deletar itens completos?';

  @override
  String get recipeListTitle => '📖 Receitas';

  @override
  String get importRecipeTitle => 'Upload de receita';

  @override
  String get uploadRecipeUrl => 'Importar via URL da receita';

  @override
  String get uploadRecipeUrlHint =>
      'Coloque o URL da receita para salvar no seu servidor';

  @override
  String get uploadOpenAI => 'Importar de arquivo via OpenAI';

  @override
  String get uploadOpenAIHint =>
      'Alternativamente, faça upload de fotos ou um PDF de uma receita. Se a receita ocupar várias páginas, adicione várias — elas são analisadas juntas por IA.';

  @override
  String get takePhoto => 'Câmera';

  @override
  String get cameraPermissionDenied =>
      'Sem acesso à câmera. Permita nas configurações do sistema para fotografar receitas.';

  @override
  String get cameraUnavailable =>
      'Nenhuma câmera disponível neste dispositivo.';

  @override
  String get selectPhoto => 'Fotos';

  @override
  String get selectPdf => 'PDF';

  @override
  String get openAIHintTitle => 'informação de analize de foto';

  @override
  String get openAIHintBody =>
      'Analize de receita usa a API OpenAI. Confira se sua chave de API está configurada no servidor.';

  @override
  String get allDeleteConfirm => 'Apagar tudo';

  @override
  String get portionen => 'Porções';

  @override
  String get timerForStep => 'Iniciar temporizador para essa etapa';

  @override
  String get weekNavPrev => 'Semana anterior';

  @override
  String get weekNavNext => 'Próxima semana';

  @override
  String get noMealsThisWeek => 'Nenhuma receita planejada';

  @override
  String get entriesInOtherWeeks => 'Há entradas em outras semanas';

  @override
  String get availableWeeks => 'Semanas disponíveis:';

  @override
  String weekRange(Object end, Object start, Object week) {
    return 'Semana $week ($start – $end)';
  }

  @override
  String get currentWeek => 'Semana Atual';

  @override
  String get rezepteAktualisieren => 'Atualizar receitas';

  @override
  String get leftoverWhatTitle => 'O que isso faz?';

  @override
  String get leftoverWhatBody =>
      'Essa função recarrega todas as receitas do servidor, e atualiza o cache local.';

  @override
  String get leftoverDescription =>
      'Adicione os ingredientes disponíveis para achar receitas e usá-los.';

  @override
  String get leftoverIngredientsHeader => 'Ingredientes em casa';

  @override
  String get leftoverSuggestions => 'Sugestão de receitas';

  @override
  String get leftoverNoMatches => 'Nenhuma receita encontrada.';

  @override
  String get leftoverEnterIngredient => 'Adicione o ingrediente';

  @override
  String matchingPercentText(int percent, int count, int total) {
    return '$percent% ($count/$total)';
  }

  @override
  String get weekAbbreviation => 'Semana';

  @override
  String get today => 'Hoje';

  @override
  String get selectDate => 'Selecionar data';

  @override
  String get selectSlot => 'Selecionar refeição';

  @override
  String get selectedRecipe => 'Receita selecionada';

  @override
  String get confirmMeal => 'Designar receita';

  @override
  String get searchRecipes => 'Buscar receitas';

  @override
  String get addCustomMeal => 'Adicionar receita personalizada';

  @override
  String get diceModeButton => 'Sortear receitas aleatórias';

  @override
  String get diceModeTitle => '3 sugestões aleatórias';

  @override
  String get diceBackToSearch => 'Voltar à busca';

  @override
  String get diceNotEnoughRecipes =>
      'Não há receitas suficientes para o modo aleatório (mín. 3)';

  @override
  String get entrySingular => 'entrada';

  @override
  String get entriesPlural => 'entradas';

  @override
  String listTitle(int n) {
    return 'Lista $n';
  }

  @override
  String get deleteAllConfirmTitle => 'Apagar tudo?';

  @override
  String get deleteAllConfirmMessage =>
      'Deseja excluir todas as compras arquivadas?';

  @override
  String get uploadFromUrlButton => 'Importar receita de URL';

  @override
  String get uploadingImage => 'Fazendo upload...';

  @override
  String get uploadErrorTitle => 'Falha no upload';

  @override
  String get uploadSuccessTitle => 'Upload completo';

  @override
  String get editImportedRecipeQuestion => 'Você quer editar a receita agora?';

  @override
  String get notNow => 'Não';

  @override
  String get pdfTooLarge => 'O PDF é muito grande (max 10 MB).';

  @override
  String get invalidUrl => 'URL inválida. Por favor coloque uma URL válida.';

  @override
  String get cookWithFriends => 'Cozinhar com amigos';

  @override
  String get cookFriendsSubtitle => 'Convide um amigo para cozinhar junto';

  @override
  String get copied => 'Copiado';

  @override
  String get linkCopied => 'Link copiado';

  @override
  String get startCooking => 'Começar a cozinhar';

  @override
  String get hostNoRecipe => 'Abra de uma receita para iniciar a sessão';

  @override
  String get uploadToOwnServer => 'Salvar no meu serividor';

  @override
  String get uploadingRecipe => 'Fazendo upload da receita…';

  @override
  String get recipeUploadedToOwnServer => 'Receita salva no seu servidor';

  @override
  String get recipeUploadFailed => 'Falha no upload';

  @override
  String get allowGuestSaveRecipes =>
      'Deixar convidados salvar receitas no próprio servidor';

  @override
  String get appIcon => 'Ícone do app';

  @override
  String get appIconClassic => 'Classico';

  @override
  String get appIconModern => 'Moderno';

  @override
  String get name => 'Nome';

  @override
  String get color => 'Cor';

  @override
  String get randomColor => 'Cor aleatória';

  @override
  String get createFailed => 'Não foi possível salvar';

  @override
  String get deleteFailed => 'Não foi possível deletar';

  @override
  String deleteOrganizerConfirm(String name) {
    return 'Deletar \"$name\"? Isso também remove no servidor.';
  }

  @override
  String get connectionSection => 'Conexão';

  @override
  String get token => 'Token';

  @override
  String get advancedOptions => 'Opções avançadas';

  @override
  String get mealieApiVersion => 'Versão da API Mealie';

  @override
  String get sendOptionalHeaders => 'Enviar headers opicionais';

  @override
  String get offlineRecipeImages => 'Salvar imagens das receitas offline';

  @override
  String get offlineRecipeImagesHint =>
      'Baixa todas as imagens das receitas para este dispositivo, para que também apareçam sem conexão. Em coleções grandes, isso pode ocupar várias centenas de MB. Desativar exclui as imagens salvas.';

  @override
  String offlineRecipeImagesStatus(int count, int total, String size) {
    return 'Salvas: $count/$total · $size';
  }

  @override
  String get offlineRecipeImagesDisableConfirm =>
      'Excluir todas as imagens de receitas salvas?';

  @override
  String headerNameLabel(int n) {
    return 'Nome do Header $n';
  }

  @override
  String headerValueLabel(int n) {
    return 'Valor do Header $n';
  }

  @override
  String get value => 'Valor';

  @override
  String get personalization => 'Personalização';

  @override
  String get showRecipeImagesSubtitle => 'Mostra imagens na lista de receita';

  @override
  String get exactQuantities => 'Adicionar quantidades exatas';

  @override
  String get exactQuantitiesSubtitle =>
      'Ingredientes e itens digitados mantêm quantidade e unidade (ex.: 200 g de manteiga) em vez de 1x por item — alimentos que faltam são criados no servidor';

  @override
  String get remindToShop => 'Lembre-me de fazer compras';

  @override
  String get remindToShopSubtitle =>
      'Avisa quando você está perto de um local guardado e a lista de compras tem itens pendentes — mesmo com a aplicação fechada';

  @override
  String get shoppingReminderAddLocation => 'Adicionar local';

  @override
  String get shoppingReminderMaxLocations => 'Máximo de 3 locais atingido';

  @override
  String get shoppingReminderLocationServiceDisabled =>
      'Os serviços de localização estão desativados neste dispositivo';

  @override
  String get shoppingReminderPermissionTitle =>
      'Acesso à localização necessário';

  @override
  String get shoppingReminderPermissionMessage =>
      'Para te avisar perto de uma loja, é necessário acesso à localização \"Sempre\" — mesmo com a aplicação fechada. Ative-o nas Definições.';

  @override
  String get openSettings => 'Abrir definições';

  @override
  String get shoppingReminderLocationName => 'Nome';

  @override
  String get shoppingReminderUseCurrentLocation => 'Usar localização atual';

  @override
  String get shoppingReminderOrAddress => 'ou insira um endereço';

  @override
  String get shoppingReminderAddress => 'Endereço';

  @override
  String get shoppingReminderAddressPlaceholder => 'Rua, cidade';

  @override
  String get shoppingReminderSearchAddress => 'Pesquisar';

  @override
  String get shoppingReminderLocationFailed =>
      'Não foi possível determinar a localização';

  @override
  String get shoppingReminderAddressNotFound => 'Endereço não encontrado';

  @override
  String get ratingFailed =>
      'Não foi possível salvar a avaliação — tente novamente.';

  @override
  String get lastCooked => 'Feito pela última vez';

  @override
  String get syncLastCooked => 'Atualizar “feito pela última vez”';

  @override
  String get syncLastCookedSubtitle =>
      'Salva a data de hoje e uma entrada na linha do tempo — como no site do Mealie.';

  @override
  String get developer => 'Desenvolvedor';

  @override
  String get enableLoggingSubtitle =>
      'Grava logs de print/error (ultimas 500 linhas)';

  @override
  String get entriesLabel => 'Entradas';

  @override
  String get fileSize => 'Tamanho do arquivo';

  @override
  String get showAction => 'Mostrar';

  @override
  String get copy => 'Copiar';

  @override
  String logsWithCount(int count) {
    return 'Logs ($count)';
  }

  @override
  String get noLogs => 'Nenhum log disponível';

  @override
  String get logsTitle => 'Logs';

  @override
  String get required => 'Obrigatório';

  @override
  String get connectionFailedCheck =>
      'Rrro ao conectar. Verifique a URL e o token.';

  @override
  String get username => 'Usuário';

  @override
  String get password => 'Senha';

  @override
  String get setupPasswordHint =>
      'Sua senha não é armazenada — o app faz login uma vez e gera um token de API a partir dela (como em Perfil → Tokens de API no site).';

  @override
  String get loginAndConnect => 'Entrar e conectar';

  @override
  String get loginInvalidCredentials => 'Usuário ou senha incorretos.';

  @override
  String get loginAndGenerateToken => 'Entrar e gerar token';

  @override
  String get loggingIn => 'Entrando…';

  @override
  String get apiTokenSaveHint =>
      'Token aplicado — toque em “Salvar alterações” abaixo.';

  @override
  String get renewApiToken => 'Renovar token de API';

  @override
  String get setupAuthChoiceTitle => 'Como você quer entrar?';

  @override
  String get authModePasswordTitle =>
      'Deixar o app criar uma chave de API para mim';

  @override
  String get authModePasswordSubtitle =>
      'Entre com usuário e senha — o app gera um token automaticamente.';

  @override
  String get authModeTokenTitle => 'Já tenho uma chave de API';

  @override
  String get authModeTokenSubtitle =>
      'Copiada do perfil do Mealie (Perfil → Tokens de API).';

  @override
  String keyN(int n) {
    return 'Chave $n';
  }

  @override
  String valueN(int n) {
    return 'Valor $n';
  }

  @override
  String get openCookingMode => 'Abrir modo cozinha';

  @override
  String activeRecipes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count receitas ativas',
      one: '1 receita ativa',
    );
    return '$_temp0';
  }

  @override
  String get reparseIngredients => 'Re-processar ingredientes';

  @override
  String get reparseIngredientsSubtitle =>
      'Dividir quantidade/unidade/ingrediente (ex. “200 g açúcar”)';

  @override
  String get reparseDone =>
      'Ingredientes divididos – aperte “Salvar mudanças” para aplicar';

  @override
  String get reparseNone => 'Nenhum ingrediente divisível encontrado';

  @override
  String get tagsAndCategories => 'Tags, categorias e ferramentas';

  @override
  String get tapToAddPhoto => 'Toque para adicionar uma foto';

  @override
  String get descriptionLabel => 'Descrição';

  @override
  String get searchingDevices => 'Procurando dispositivos no mesmo Wi-Fi…';

  @override
  String get selectAll => 'Selecionar tudo';

  @override
  String get importReminders => 'Importar lembretes';

  @override
  String get importGoogleTasks => 'Importar Google Tarefas';

  @override
  String get noTaskLists => 'Nenhuma tarefa encontrada';

  @override
  String get noReminderLists => 'Nenhuma lista de terefas encontrada';

  @override
  String importCount(int count) {
    return 'Importar $count';
  }

  @override
  String get activeRecipeTimer => 'Temporizador de receita ativo';

  @override
  String get linkIngredients => 'Vincular ingredientes';

  @override
  String get noIngredientsToLink => 'Ainda não há ingredientes para vincular';

  @override
  String get importLanguageSubtitle =>
      'Idioma das receitas importadas de foto ou PDF';

  @override
  String get importLanguageSearch => 'Buscar idioma';

  @override
  String get importLanguageFollowApp => 'Igual ao idioma do app';

  @override
  String get importLanguageNoMatch => 'Nenhum idioma encontrado';

  @override
  String get setupImportLanguageTitle => 'Importação de receitas com IA';

  @override
  String get setupImportLanguageBody =>
      'Fotos e PDFs podem ser transformados em receitas por IA. Escolha o idioma em que elas devem chegar — útil se o seu idioma nativo não estiver disponível como idioma do app. Você pode mudar isso depois nas configurações.';

  @override
  String get setupImportLanguageSearchHint =>
      'Use a busca na lista para encontrar idiomas que a interface do app não oferece.';

  @override
  String get setupCachingKeepOpenTitle => 'Mantenha o app aberto';

  @override
  String get setupCachingKeepOpenBody =>
      'O carregamento roda em primeiro plano. Deixe o app aberto até terminar — se você fechá-lo ou sair por muito tempo, o processo é interrompido e recomeça mais tarde.';

  @override
  String get supportContact => 'Falar com o suporte';

  @override
  String get supportDialogMessage =>
      'Descreva o seu problema e entraremos em contato. O registro ajuda muito na busca pelo erro — você pode anexá-lo como arquivo de texto.';

  @override
  String get supportWithoutLogs => 'Sem registro';

  @override
  String get supportWithLogs => 'Anexar registro';

  @override
  String get supportMailSubject => 'Mealie Recipes — Suporte';

  @override
  String get supportMailHint => 'Descreva seu problema aqui:';

  @override
  String get supportLogsEmpty =>
      'O registro está vazio. Ative o registro, reproduza o problema e envie depois.';

  @override
  String supportAddressCopied(String email) {
    return 'Endereço copiado: $email';
  }

  @override
  String supportNoMailApp(String email) {
    return 'Nenhum app de e-mail encontrado. Endereço copiado: $email';
  }

  @override
  String get createRecipeFromImages => 'Criar receita';

  @override
  String imagePagesSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count páginas selecionadas',
      one: '1 página selecionada',
    );
    return '$_temp0';
  }

  @override
  String get imagePagesHint =>
      'A primeira imagem será a imagem principal da receita. Mantenha uma página pressionada para reordená-la.';

  @override
  String get mainImageBadge => 'Principal';

  @override
  String maxImagesReached(int max) {
    return 'Máximo de $max imagens por receita.';
  }

  @override
  String get removePage => 'Remover página';

  @override
  String get preparingPdf => 'Processando PDF...';

  @override
  String get shareRecipeTitle => 'Compartilhar receita';

  @override
  String get recipeOptionsTitle => 'Opções';

  @override
  String get exportAsPdf => 'Exportar como PDF';

  @override
  String get generatingPdf => 'Gerando PDF…';

  @override
  String get pdfExportFailed => 'Falha ao exportar PDF';

  @override
  String get recipeTime => 'Tempo';

  @override
  String get ingredientSectionTitle => 'Seção';

  @override
  String get addIngredientSection => 'Adicionar seção';

  @override
  String get aiImportToggle => 'Analisar com IA';

  @override
  String get aiImportToggleHint =>
      'Também para vídeos de receitas (YouTube, Instagram, TikTok …) e páginas que a importação normal não consegue ler. Requer um provedor de IA no seu servidor Mealie – para vídeos, também um provedor de áudio.';

  @override
  String get aiImportButton => 'Importar com IA';

  @override
  String get aiImportRunning =>
      'A IA está analisando o link … com vídeos isso pode levar alguns minutos.';

  @override
  String get aiImportFailed =>
      'A importação com IA falhou. Verifique as configurações de IA do seu servidor Mealie.';

  @override
  String get stepHeadingLabel => 'Título da etapa (opcional)';

  @override
  String get linkedRecipeLabel => 'Receita vinculada';

  @override
  String get toolsTitle => 'Ferramentas';

  @override
  String get prepareTools => 'Separe as seguintes ferramentas';

  @override
  String get newTool => 'Nova ferramenta';

  @override
  String get renameAction => 'Renomear';

  @override
  String get organizerEmpty =>
      'Nenhuma entrada ainda. Toque em “+” no canto superior direito para criar uma.';

  @override
  String organizerRecipeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count receitas',
      one: '1 receita',
      zero: 'Nenhuma receita',
    );
    return '$_temp0';
  }

  @override
  String get toolOnHand => 'Disponível';

  @override
  String get mealDiceSettingsTitle => 'Filtro do dado';

  @override
  String get mealDiceSettingsHint =>
      'Escolha categorias e tags para cada refeição. O dado só sugere receitas que tenham pelo menos uma delas. A mesma seleção pode valer para várias refeições.';

  @override
  String get mealDiceSettingsNoneHint =>
      'Nada selecionado para esta refeição: o dado escolhe automaticamente por categorias como “Café da manhã”, “Almoço” ou “Jantar”.';

  @override
  String get mealDiceAutoHintTitle => 'Seleção automática';

  @override
  String get mealDiceAutoHintBody =>
      'Ainda não há categorias nem tags definidas para esta refeição. Por isso o dado procura categorias como “Café da manhã”, “Almoço” ou “Jantar” e completa com outras receitas.\n\nPara escolher você mesmo: no plano de refeições, toque na engrenagem ao lado do “+”.';

  @override
  String get dontShowAgain => 'Não mostrar novamente';

  @override
  String get mealDiceNoMatches =>
      'Nenhuma receita corresponde às categorias e tags escolhidas para esta refeição.';

  @override
  String mealDiceFewMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Apenas $count receitas correspondem',
      one: 'Apenas 1 receita corresponde',
    );
    return '$_temp0';
  }

  @override
  String get commentsTitle => 'Comentários';

  @override
  String get commentHint => 'Escreva um comentário…';

  @override
  String get commentSaveFailed => 'Não foi possível salvar o comentário.';

  @override
  String get commentDeleteConfirm => 'Excluir este comentário?';

  @override
  String get cookingDoneCommentLabel => 'Comentário (opcional)';

  @override
  String get cookingDoneCommentHint => 'Como ficou? Dicas para a próxima vez…';

  @override
  String get nutritionTitle => 'Informação nutricional';

  @override
  String get nutritionPerServing => 'por porção';

  @override
  String get nutritionCalories => 'Calorias';

  @override
  String get nutritionFat => 'Gorduras';

  @override
  String get nutritionSaturatedFat => 'Gorduras saturadas';

  @override
  String get nutritionTransFat => 'Gorduras trans';

  @override
  String get nutritionUnsaturatedFat => 'Gorduras insaturadas';

  @override
  String get nutritionCholesterol => 'Colesterol';

  @override
  String get nutritionSodium => 'Sódio';

  @override
  String get nutritionCarbohydrates => 'Carboidratos';

  @override
  String get nutritionFiber => 'Fibras';

  @override
  String get nutritionSugar => 'Açúcar';

  @override
  String get nutritionProtein => 'Proteínas';

  @override
  String get timelineTitle => 'Linha do tempo';

  @override
  String get timelineMadeThis => 'Eu fiz isso';

  @override
  String timelineUserMadeThis(String name) {
    return '$name fez isso';
  }

  @override
  String get timelineEmpty => 'Ainda não há entradas na linha do tempo.';

  @override
  String get timelineDate => 'Data';

  @override
  String get timelineNoteHint => 'Nota (opcional)';

  @override
  String get timelineAddPhoto => 'Adicionar foto';

  @override
  String get timelineRemovePhoto => 'Remover foto';

  @override
  String get timelineSaved => 'Adicionado à linha do tempo';

  @override
  String get timelineSaveFailed =>
      'Não foi possível adicionar à linha do tempo';

  @override
  String get timelineImageFailed =>
      'Entrada salva, mas não foi possível enviar a foto';

  @override
  String get timelineDeleteConfirm => 'Excluir esta entrada da linha do tempo?';

  @override
  String get timelineEditNote => 'Editar nota';

  @override
  String get timelineUnknownRecipe => 'Receita não encontrada';

  @override
  String get cookingDonePhotoHint =>
      'Foto para a linha do tempo do Mealie (opcional)';

  @override
  String get assetsTitle => 'Anexos';

  @override
  String get assetsAdd => 'Adicionar anexo';

  @override
  String get assetsChooseFile => 'Arquivo';

  @override
  String get assetsUploading => 'Enviando…';

  @override
  String get assetsUploadFailed => 'Não foi possível enviar o anexo';

  @override
  String assetsDeleteConfirm(String name) {
    return 'Remover “$name” dos anexos?';
  }

  @override
  String get assetsOpenFailed => 'Não foi possível abrir o anexo';

  @override
  String get assetsUnsupported =>
      'O Mealie só aceita PDF, imagens, TXT, MD, CSV e JSON.';

  @override
  String get assetsShare => 'Compartilhar';

  @override
  String get mealRulesTitle => 'Regras do Mealie';

  @override
  String get mealRulesHint =>
      'Também valem no app web do Mealie. Se várias regras se aplicarem ao dia e à refeição, todas precisam ser atendidas. Se nenhuma se aplicar, o dado escolhe entre todas as receitas.';

  @override
  String get mealRuleAdd => 'Adicionar regra';

  @override
  String get mealRuleNewTitle => 'Nova regra';

  @override
  String get mealRuleEditTitle => 'Editar regra';

  @override
  String get mealRuleDay => 'Dia';

  @override
  String get mealRuleAnyDay => 'Qualquer dia';

  @override
  String get mealRuleMealType => 'Refeição';

  @override
  String get mealRuleAnyMeal => 'Qualquer refeição';

  @override
  String get mealRuleConditionsTitle => 'Condições';

  @override
  String get mealRuleAllRecipes => 'Todas as receitas';

  @override
  String get mealRuleDeleteConfirm => 'Excluir esta regra?';

  @override
  String get mealRulesOffline =>
      'As regras do Mealie estão indisponíveis agora – o dado usa a seleção da app.';

  @override
  String get mealRulesNoMatches =>
      'Nenhuma receita atende às regras do Mealie para esta refeição.';

  @override
  String get mealTypeSide => 'Acompanhamento';

  @override
  String get mealTypeSnack => 'Lanche';

  @override
  String get mealTypeDrink => 'Bebida';

  @override
  String get mealTypeDessert => 'Sobremesa';

  @override
  String get foodsTitle => 'Alimentos';

  @override
  String get unitsTitle => 'Unidades';

  @override
  String get newFood => 'Novo alimento';

  @override
  String get newUnit => 'Nova unidade';

  @override
  String get editFood => 'Editar alimento';

  @override
  String get editUnit => 'Editar unidade';

  @override
  String get pluralNameLabel => 'Nome no plural';

  @override
  String get abbreviationLabel => 'Abreviação';

  @override
  String get pluralAbbreviationLabel => 'Abreviação no plural';

  @override
  String get mergeAction => 'Mesclar';

  @override
  String mergeIntoTitle(String name) {
    return 'Mesclar “$name” com…';
  }

  @override
  String mergeConfirm(String from, String to) {
    return '“$from” será mesclado com “$to”: todas as receitas e listas de compras passarão a usar “$to” e “$from” será excluído.';
  }

  @override
  String get mergeFailed => 'Falha ao mesclar';

  @override
  String foodUnitDeleteConfirm(String name) {
    return 'Excluir “$name”? Os ingredientes que o usam perderão a referência.';
  }

  @override
  String get foodsUnitsEmpty => 'Ainda não há entradas.';

  @override
  String mealRuleConditionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count condições',
      one: '1 condição',
    );
    return '$_temp0';
  }

  @override
  String get showAll => 'Mostrar tudo';

  @override
  String get mealDiceModeTitle => 'O dado usa';

  @override
  String get mealDiceModeApp => 'Seleção do app';

  @override
  String get switchListTitle => 'Trocar de lista';

  @override
  String get newShoppingList => 'Nova lista de compras';

  @override
  String shoppingListDeleteConfirm(String name) {
    return 'Excluir “$name”? Todos os itens dela também serão excluídos.';
  }

  @override
  String get labelOrderTitle => 'Ordenar marcadores';

  @override
  String get labelOrderHint =>
      'Arraste para ordenar. Vale para esta lista – também no app web do Mealie.';

  @override
  String get labelOrderEmpty => 'Esta lista ainda não tem marcadores.';

  @override
  String get useAsActiveList => 'Usar como lista ativa';

  @override
  String get activeListBadge => 'Ativa';

  @override
  String get foodLabelLabel => 'Marcador';

  @override
  String get foodNoLabel => 'Sem marcador';

  @override
  String get aliasesLabel => 'Apelidos';

  @override
  String get aliasAddHint => 'Adicionar apelido';

  @override
  String get foodOnHand => 'Disponível na casa';

  @override
  String get timelineChildRecipesTitle =>
      'Adicionar também às receitas vinculadas';

  @override
  String timelineMadeForRecipe(String recipe) {
    return 'Feito para $recipe';
  }

  @override
  String get timelineFilter => 'Filtrar entradas';

  @override
  String get timelineTypeComment => 'Feito e notas';

  @override
  String get timelineTypeInfo => 'Informações';

  @override
  String get timelineTypeSystem => 'Sistema';

  @override
  String get listManagementTitle => 'Listas de compras';

  @override
  String get managementTitle => 'Mais';

  @override
  String get pinToHome => 'Adicionar à tela inicial';

  @override
  String get unpinFromHome => 'Remover da tela inicial';

  @override
  String homeScreenFull(int count) {
    return 'A tela inicial está cheia – no máximo $count blocos. Remova antes outro bloco em “Mais”.';
  }

  @override
  String get selectAction => 'Selecionar';

  @override
  String selectedCount(int count) {
    return '$count selecionado(s)';
  }

  @override
  String get assignLabelAction => 'Atribuir marcador';

  @override
  String get assignLabelOverwriteHint =>
      'Substitui o marcador de todos os alimentos selecionados.';

  @override
  String deleteSelectedConfirm(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Excluir $count entradas?',
      one: 'Excluir 1 entrada?',
    );
    return '$_temp0';
  }

  @override
  String get seedDataAction => 'Carregar dados padrão';

  @override
  String get seedFoodsHint =>
      'Cria os alimentos padrão do Mealie no idioma escolhido.';

  @override
  String get seedUnitsHint =>
      'Cria as unidades padrão do Mealie no idioma escolhido.';

  @override
  String get seedLanguageLabel => 'Idioma';

  @override
  String get seedDuplicateWarning =>
      'Você já tem entradas. O Mealie não trata duplicatas – você precisará mesclá-las depois.';

  @override
  String get seedDone => 'Dados padrão criados';

  @override
  String get seedFailed => 'Não foi possível carregar os dados padrão';

  @override
  String get exportAction => 'Exportar';

  @override
  String get substitutionsLabel => 'Substitutos';

  @override
  String get substitutionAddHint => 'Adicionar substituto';

  @override
  String get substitutionFoodLabel => 'Alimento (opcional)';

  @override
  String get substitutionNoteLabel => 'Nota (opcional)';

  @override
  String get substitutionNeedOne => 'Informe um alimento ou uma nota';

  @override
  String get useAbbreviationLabel => 'Usar abreviação';

  @override
  String get useAbbreviationHint =>
      'Mostrar “g” em vez de “grama” nas receitas';

  @override
  String get fractionLabel => 'Exibir como fração';

  @override
  String get fractionHint => '½ em vez de 0,5';

  @override
  String get standardizationTitle => 'Padronização';

  @override
  String get standardizationHint =>
      'Para conversões: 1 desta unidade equivale a … (ex.: 1 colher de sopa = 15 mililitros).';

  @override
  String get standardQuantityLabel => 'Quantidade padrão';

  @override
  String get standardUnitLabel => 'Unidade padrão';

  @override
  String get standardUnitNone => 'Nenhuma';

  @override
  String get stdFluidOunce => 'Onça líquida (fl oz)';

  @override
  String get stdCup => 'Xícara (EUA)';

  @override
  String get stdOunce => 'Onça (oz)';

  @override
  String get stdPound => 'Libra (lb)';

  @override
  String get stdMilliliter => 'Mililitro';

  @override
  String get stdLiter => 'Litro';

  @override
  String get stdGram => 'Grama';

  @override
  String get stdKilogram => 'Quilograma';

  @override
  String get labelsTitle => 'Marcadores';

  @override
  String get newLabel => 'Novo marcador';

  @override
  String get editLabel => 'Editar marcador';

  @override
  String get colorLabel => 'Cor';

  @override
  String labelDeleteConfirm(String name) {
    return 'Excluir “$name”? Itens e alimentos perderão este marcador.';
  }

  @override
  String get importMenuAction => 'Importar';

  @override
  String get archivedEmpty =>
      'Ainda não há compras arquivadas. Toque em “Completar compras” depois de comprar – os itens marcados ficam guardados aqui.';

  @override
  String get sectionTitleLabel => 'Título da seção';

  @override
  String get clearSection => 'Remover seção';

  @override
  String get noPermissionGeneric =>
      'Você não tem permissão para isso no Mealie. Peça a um administrador ou gestor do domicílio.';

  @override
  String get noPermissionEditRecipe =>
      'Você não pode editar esta receita – ela está bloqueada ou pertence a outro domicílio. Só quem a criou ou um administrador pode.';

  @override
  String get noPermissionDeleteRecipe =>
      'Só quem criou a receita ou um administrador pode excluí-la.';

  @override
  String get noPermissionDemoteSelf =>
      'Você não pode remover seus próprios direitos de administrador.';

  @override
  String get recipeLockedHint => 'Bloqueada – só quem a criou pode editar';

  @override
  String get recipeDeleteOwnerOnlyHint =>
      'Só quem criou ou um administrador pode excluir';

  @override
  String get organizeReadOnlyHint =>
      'Somente leitura: criar, alterar e excluir exige a permissão “O usuário pode gerenciar alimentos, tags e categorias”.';

  @override
  String get notesNotSavedNoPermission =>
      'Nota não salva – você não tem permissão para editar esta receita.';

  @override
  String get userManagementTitle => 'Gerenciamento de usuários';

  @override
  String get usersTitle => 'Usuários';

  @override
  String get editUserTitle => 'Editar Usuário';

  @override
  String get fullNameLabel => 'Nome Completo';

  @override
  String get usernameLabel => 'Nome de usuário';

  @override
  String get emailLabel => 'E-mail';

  @override
  String get passwordLabel => 'Senha';

  @override
  String get householdLabel => 'Domicílio';

  @override
  String get permissionsTitle => 'Permissões';

  @override
  String get administratorLabel => 'Administrador';

  @override
  String get permCanInvite => 'O usuário pode convidar outros para o grupo';

  @override
  String get permCanManage =>
      'O usuário pode gerenciar as configurações do grupo';

  @override
  String get permCanManageHousehold => 'O usuário pode gerenciar o domicílio';

  @override
  String get permCanOrganize =>
      'O usuário pode gerenciar alimentos, tags e categorias';

  @override
  String get advancedFeaturesLabel => 'Ativar recursos avançados';

  @override
  String get passwordResetLinkAction => 'Gerar link de redefinição de senha';

  @override
  String get resetLockedUsersAction => 'Redefinir Usuários Bloqueados';

  @override
  String get membersTitle => 'Membros';

  @override
  String get inviteLinkTitle => 'Link de convite';

  @override
  String get inviteAction => 'Convidar';

  @override
  String get userUpdated => 'Usuário atualizado';

  @override
  String get createUserTitle => 'Criar usuário';

  @override
  String get userCreated => 'Usuário criado';

  @override
  String userDeleteConfirm(String name) {
    return 'Excluir “$name”? A conta será removida do Mealie.';
  }

  @override
  String get passwordResetLinkCopied =>
      'Link copiado – repasse ao usuário. Ele é válido só por tempo limitado.';

  @override
  String lockedUsersReset(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count usuários desbloqueados',
      one: '1 usuário desbloqueado',
      zero: 'Nenhum usuário bloqueado',
    );
    return '$_temp0';
  }

  @override
  String get inviteUsesLabel => 'Número de usos';

  @override
  String get inviteCreated => 'Link de convite criado';

  @override
  String get inviteEmailHint =>
      'E-mail (opcional – o Mealie enviará o convite)';

  @override
  String get inviteEmailSent => 'Convite enviado por e-mail';

  @override
  String get inviteEmailFailed =>
      'Não foi possível enviar o e-mail (o SMTP está configurado no Mealie?). O link funciona mesmo assim.';

  @override
  String get copyLinkAction => 'Copiar link';

  @override
  String get youLabel => 'Você';

  @override
  String get membersPermissionsHint =>
      'Você pode alterar as permissões dos membros do seu domicílio – mas não as suas.';

  @override
  String get householdManagementTitle => 'Gerenciamento domiciliar';

  @override
  String get householdsTitle => 'Domicílios';

  @override
  String get createHouseholdTitle => 'Criar domicílio';

  @override
  String get householdNameLabel => 'Nome do domicílio';

  @override
  String get householdPreferencesTitle => 'Preferências do domicílio';

  @override
  String get privateHouseholdLabel => 'Domicílio privado';

  @override
  String get privateHouseholdHint =>
      'Configurar seu domicílio como privado desativará todas as opções de visualização pública. Isso substitui as configurações de visualização pública individual';

  @override
  String get lockRecipeEditsLabel =>
      'Bloquear edições de receitas de outros domicílios';

  @override
  String get lockRecipeEditsHint =>
      'Quando ativado, apenas os membros do seu domicílio podem editar receitas criadas por membros do seu domicílio';

  @override
  String get householdRecipePreferencesTitle =>
      'Preferências das receitas do domicílio';

  @override
  String get groupsTitle => 'Grupos';

  @override
  String get groupLabel => 'Grupo';

  @override
  String get createGroupTitle => 'Criar Grupo';

  @override
  String get groupNameLabel => 'Nome do Grupo';

  @override
  String get groupPreferencesTitle => 'Preferências de Grupo';

  @override
  String get privateGroupLabel => 'Grupo Privado';

  @override
  String get privateGroupHint =>
      'Configurar seu grupo para privado irá desabilitar as opções de visualização pública. Isso substitui qualquer configuração pública individual.';

  @override
  String get firstDayOfWeekLabel => 'Primeiro dia da semana';

  @override
  String get showAnnouncementsLabel => 'Mostrar anúncios do Mealie';

  @override
  String get recipePublicDefaultLabel =>
      'Permitir que usuários fora do seu grupo vejam suas receitas';

  @override
  String get recipeShowNutritionDefaultLabel =>
      'Mostrar informações nutricionais';

  @override
  String get recipeShowAssetsDefaultLabel => 'Mostrar anexos da receita';

  @override
  String get recipeLandscapeDefaultLabel =>
      'Padronizar para visualização em paisagem';

  @override
  String get recipeDisableCommentsDefaultLabel =>
      'Desabilitar usuários de comentar em receitas';

  @override
  String get myHouseholdSection => 'Meu domicílio';

  @override
  String get myGroupSection => 'Meu grupo';

  @override
  String get preferencesSaved => 'Configurações salvas';

  @override
  String get cannotDeleteWithUsers =>
      'Ainda tem usuários – mova-os ou exclua-os primeiro no gerenciamento de usuários.';

  @override
  String deleteHouseholdConfirm(String name) {
    return 'Excluir o domicílio “$name”?';
  }

  @override
  String deleteGroupConfirm(String name) {
    return 'Excluir o grupo “$name”?';
  }

  @override
  String usersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count usuários',
      one: '1 usuário',
      zero: 'Nenhum usuário',
    );
    return '$_temp0';
  }

  @override
  String get originalUrlLabel => 'URL original';

  @override
  String get copyTextAction => 'Copiar texto';

  @override
  String get copiedToClipboard => 'Copiado para a área de transferência';

  @override
  String get changelogEnglishHint =>
      'As novidades estão disponíveis só em inglês – com “Copiar texto” você pode colá-las, por exemplo, em um tradutor.';

  @override
  String get favoritesTitle => 'Favoritos';

  @override
  String get favoritesEmpty =>
      'Ainda não há favoritos. Toque no coração de uma receita para reuni-la aqui.';

  @override
  String get changelogTitle => 'Changelog';

  @override
  String get changeProfileImage => 'Alterar foto de perfil';

  @override
  String get profileImageUpdated => 'Foto de perfil atualizada';

  @override
  String get profileImageFailed => 'Não foi possível enviar a foto de perfil';

  @override
  String get myAccountTitle => 'A minha conta';

  @override
  String get ownAccountHint =>
      'Aqui pode editar a sua própria conta. Os outros utilizadores são geridos por administradores e membros com a permissão \"gerir\".';

  @override
  String get changePasswordAction => 'Alterar palavra-passe';

  @override
  String get currentPasswordLabel => 'Palavra-passe atual';

  @override
  String get newPasswordLabel => 'Nova palavra-passe';

  @override
  String get confirmPasswordLabel => 'Confirmar palavra-passe';

  @override
  String get passwordTooShort => 'Pelo menos 8 caracteres';

  @override
  String get passwordsDoNotMatch => 'As palavras-passe não coincidem';

  @override
  String get passwordUpdated => 'Palavra-passe atualizada';

  @override
  String get passwordChangeFailed => 'Não foi possível alterar a palavra-passe';

  @override
  String passwordManagedExternally(String method) {
    return 'Inicia sessão através de $method — altere a sua palavra-passe lá.';
  }

  @override
  String get bulkAddHint => 'Uma linha por entrada.';

  @override
  String bulkAddCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Adicionar $count entradas',
      one: 'Adicionar 1 entrada',
    );
    return '$_temp0';
  }

  @override
  String get linkRecipeAction => 'Ligar receita';

  @override
  String get useFoodAction => 'Usar alimento em vez de receita';

  @override
  String get addSubstitutionsAction => 'Adicionar substituições';

  @override
  String get clearSubstitutionsAction => 'Limpar substituições';

  @override
  String get recipeSubstitutionsTitle => 'Substituições';

  @override
  String get substitutionUnknownFood =>
      'Apenas alimentos existentes – caso contrário, use a nota';

  @override
  String get insertAboveAction => 'Inserir acima';

  @override
  String get insertBelowAction => 'Inserir abaixo';

  @override
  String get moveToTopAction => 'Mover para o topo';

  @override
  String get moveToBottomAction => 'Mover para o fundo';

  @override
  String get linkReferencesAction => 'Ligar referências';

  @override
  String get editMarkdownAction => 'Editar Markdown';

  @override
  String get previewMarkdownAction => 'Pré-visualizar Markdown';

  @override
  String get insertStepImageAction => 'Carregar imagem';

  @override
  String get mergeAboveAction => 'Fundir acima';

  @override
  String get linkedToOtherStep => 'Ligado a outro passo';

  @override
  String get noNotesToLink => 'Sem notas para ligar';

  @override
  String get ownerLabel => 'Proprietário';

  @override
  String get ingredientParserTitle => 'Analisador de ingredientes';

  @override
  String ingredientParserHint(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count ingredientes ainda não estão estruturados. Escolha um analisador, verifique o resultado e aplique.',
      one:
          '1 ingrediente ainda não está estruturado. Escolha um analisador, verifique o resultado e aplique.',
    );
    return '$_temp0';
  }

  @override
  String get parserNlp => 'Processador de linguagem natural';

  @override
  String get parserBrute => 'Analisador bruto';

  @override
  String get parserOpenai => 'Analisador OpenAI';

  @override
  String get parserApp => 'Offline (app)';

  @override
  String get parseFailed => 'Falha na interpretação';

  @override
  String get parseAction => 'Interpretar';

  @override
  String applyParsedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Aplicar $count ingredientes',
      one: 'Aplicar 1 ingrediente',
      zero: 'Nada selecionado',
    );
    return '$_temp0';
  }

  @override
  String get parsedNewBadge => 'novo';

  @override
  String get hoursShort => 'h';

  @override
  String get minutesShort => 'min';

  @override
  String get timeExtraHint => 'Extra, p. ex. \"mais uma noite\"';

  @override
  String get yieldLabel => 'Rendimento';

  @override
  String get yieldTextLabel => 'Rendimento Texto';

  @override
  String get prepTimeLabel => 'Tempo de preparação';

  @override
  String get performTimeLabel => 'Tempo de cozedura';

  @override
  String get totalTimeLabel => 'Tempo total';

  @override
  String get settingPublicRecipe => 'Receita pública';

  @override
  String get settingShowNutrition => 'Mostrar valores nutricionais';

  @override
  String get settingShowAssets => 'Exibir recursos';

  @override
  String get settingLandscapeView => 'Modo paisagem';

  @override
  String get settingDisableComments => 'Desativar comentários';

  @override
  String get settingDisableAmount => 'Desativar quantidades dos ingredientes';

  @override
  String get settingLocked => 'Bloqueado';

  @override
  String get settingLockedOwnerOnly =>
      'Apenas o criador pode bloquear ou desbloquear a receita.';

  @override
  String get apiExtrasTitle => 'Extras API';

  @override
  String get apiExtrasHint =>
      'Pares chave/valor personalizados para aplicações de terceiros, p. ex. para acionar automações.';

  @override
  String get extraKeyLabel => 'Chave';

  @override
  String get extraValueLabel => 'Valor';

  @override
  String get addExtraAction => 'Adicionar extra';

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
  String get discardChangesConfirm => 'Descartar alterações não guardadas?';

  @override
  String get discardChanges => 'Descartar alterações';

  @override
  String get imageFromUrl => 'Imagem a partir de URL';

  @override
  String get deleteRecipeImage => 'Eliminar imagem da receita';

  @override
  String get deleteRecipeImageConfirm =>
      'Tem a certeza de que pretende eliminar esta imagem da receita?';

  @override
  String get bulkAddIngredients => 'Adicionar vários ingredientes';

  @override
  String get bulkAddSteps => 'Adicionar vários passos';

  @override
  String get stepImageFailed => 'Não foi possível carregar a imagem';

  @override
  String get servingsAndTimes => 'Porções e tempos';

  @override
  String get recipeSettingsTitle => 'Definições da receita';

  @override
  String get jsonEditorTitle => 'Editor de JSON';

  @override
  String get jsonInvalid => 'JSON inválido – verifique.';

  @override
  String get editorOfflineHint =>
      'Aberto offline: guardar requer ligação. Os campos mais recentes do Mealie (p. ex. substituições) mantêm-se inalterados.';

  @override
  String get parseLineFailed => 'Não reconhecido – mantém-se inalterado';

  @override
  String get createManualTitle => 'Criar receita manualmente';

  @override
  String get createManualHint =>
      'Introduza um nome – depois adicione ingredientes, passos, imagem e tudo o resto no editor de receitas.';

  @override
  String get createManualButton => 'Criar e editar';

  @override
  String get changelogEmpty => 'Ainda não há entradas para esta versão.';

  @override
  String get finderDescription =>
      'Procure por receitas baseadas em ingredientes que você tem na mão. Você também pode filtrar por ferramentas disponíveis e definir um número máximo de ingredientes ou ferramentas que faltam.';

  @override
  String get finderSelectedIngredients => 'Ingredientes selecionados';

  @override
  String get finderNoIngredientsSelected => 'Nenhum ingrediente selecionado';

  @override
  String get finderMissing => 'Ausente';

  @override
  String get finderNoRecipesFound => 'Nenhuma receita encontrada';

  @override
  String get finderNoRecipesFoundDescription =>
      'Tente adicionar mais ingredientes à sua busca ou ajuste seus filtros';

  @override
  String get finderIncludeFoodsOnHand => 'Incluir ingredientes disponíveis';

  @override
  String get finderIncludeToolsOnHand => 'Incluir utensílios disponíveis';

  @override
  String get finderIncludeSubstitutions => 'Incluir substitutos';

  @override
  String get finderSubstituting => 'Substituindo';

  @override
  String finderSubstituteForFood(String substitute, String food) {
    return '$substitute no lugar de $food';
  }

  @override
  String get finderMaxMissingIngredients => 'Máximo de ingredientes faltando';

  @override
  String get finderMaxMissingTools => 'Máximo de utensílios faltando';

  @override
  String get finderSelectedTools => 'Ferramentas selecionadas';

  @override
  String get finderReadyToMake => 'Pronto para fazer';

  @override
  String get finderAlmostReadyToMake => 'Quase pronto para fazer';

  @override
  String get finderSettings => 'Configurações';

  @override
  String get finderLoadingRecipes => 'Carregando receitas';

  @override
  String get finderClearSelection => 'Limpar seleção';

  @override
  String get finderOfflineHint =>
      'Sem conexão com o servidor – os resultados vêm das receitas salvas neste dispositivo.';

  @override
  String addIngredientsSkippedOnHand(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Adicionado à lista de compras – $count ingredientes disponíveis foram ignorados.',
      one:
          'Adicionado à lista de compras – 1 ingrediente disponível foi ignorado.',
    );
    return '$_temp0';
  }

  @override
  String get sendPeerOfflineHint =>
      'Indisponível agora – chega quando o app for aberto lá';

  @override
  String sendDeliveredLater(String device) {
    return '“$device” está indisponível agora. A receita chegará assim que o app for aberto lá.';
  }

  @override
  String get sendQueuedOffline =>
      'Sem conexão agora. A receita será enviada automaticamente quando você estiver online de novo.';

  @override
  String get searchHasAll => 'Tem todos';

  @override
  String get searchHasAny => 'Tem alguma';

  @override
  String get recipeFilterTitle => 'Filtro';

  @override
  String get finderOtherFilters => 'Outros Filtros';

  @override
  String get qfOpEquals => 'igual a';

  @override
  String get qfOpNotEquals => 'não é igual a';

  @override
  String get qfOpGreater => 'é maior que';

  @override
  String get qfOpGreaterEq => 'é maior ou igual a';

  @override
  String get qfOpLess => 'é menor que';

  @override
  String get qfOpLessEq => 'é menor ou igual a';

  @override
  String get qfOpNewerThan => 'é mais recente de';

  @override
  String get qfOpOlderThan => 'Mais antigo que';

  @override
  String qfDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dias atrás',
      one: '1 dia atrás',
    );
    return '$_temp0';
  }

  @override
  String get filterResetAll => 'Redefinir todos os filtros';

  @override
  String get filterAny => 'Todos';

  @override
  String get filterOfflineIgnored =>
      'Offline, os “Outros filtros” só podem ser aplicados na forma simples.';

  @override
  String linkedRecipesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count receitas vinculadas',
      one: 'Uma receita vinculada',
      zero: 'Sem receitas vinculadas',
    );
    return '$_temp0';
  }

  @override
  String get shoppingReminderNotificationsOff =>
      'As notificações do Mealie Recipes estão desativadas — sem elas o lembrete de compras não pode aparecer. Permita-as nas configurações.';

  @override
  String get shoppingReminderInactiveHint =>
      'O lembrete de compras não pode funcionar agora: defina o acesso à localização como “Sempre” e permita notificações.';

  @override
  String get bulkImportTitle => 'Importação de URL em massa';

  @override
  String get bulkImportDescription =>
      'O importador de receitas em massa permite que você importe várias receitas de uma vez enfileirando os sites no backend e executando a tarefa em segundo plano. Isso pode ser útil quando inicialmente migrar para Mealie, ou quando você quiser importar um grande número de receitas.';

  @override
  String get bulkAddTitle => 'Adicionar em Massa';

  @override
  String get bulkImportSetOrganizers => 'Definir categorias e marcadores';

  @override
  String get bulkImportStarted => 'Processo de importação em massa iniciado';

  @override
  String get bulkImportFailed => 'Processo de importação em massa falhou';

  @override
  String get bulkImportReports => 'Importações em massa';

  @override
  String get bulkImportUrlHint => 'URL da Receita';

  @override
  String get migrationsTitle => 'Migrações de dados';

  @override
  String get migrationsDescription =>
      'Receitas podem ser migradas de outra aplicação compatível com o Mealie. É uma excelente forma de começar a usar o Mealie. Mover dados entre instâncias do Mealie ou restaurar backup em compensação é feito com as ferramentas de backup e recuperação.';

  @override
  String get migrationNew => 'Nova migração';

  @override
  String get migrationChooseType => 'Escolher Tipo de Migração';

  @override
  String get noFileSelected => 'Nenhum arquivo selecionado';

  @override
  String migrationTagAll(String tag) {
    return 'Marcar todas as receitas com o marcador $tag';
  }

  @override
  String get migrationPrevious => 'Migrações anteriores';

  @override
  String get migrationMealieDescription =>
      'O Mealie pode importar receitas de uma versão anterior à v1.0. Exporte suas receitas da instância na versão anterior e suba o zip no campo abaixo. Esse passo se aplica somente para instâncias anteriores à v1.0. Um backup feito na v1.0 ou mais nova deve ser restaurado com as ferramentas de backup e recuperação.';

  @override
  String get migrationChowdownDescription =>
      'Mealie suporta nativamente o formato de repositório do Chowdown. Baixe o repositório de código como um arquivo .zip e carregue-o abaixo.';

  @override
  String get migrationCopyMeThatDescription =>
      'Mealie pode importar receitas da Copy Me That. Exporte suas receitas no formato HTML e depois carregue o .zip abaixo.';

  @override
  String get migrationMyRecipeBoxDescription =>
      'Mealie pode importar receitas do My Recipe Box. Exporte suas receitas em formato CSV e envie o arquivo abaixo.';

  @override
  String get migrationNextcloudDescription =>
      'As receitas da Nextcloud podem ser importadas a partir de um arquivo .zip que contém os dados armazenados na Nextcloud. Veja abaixo o exemplo da estrutura da pasta para garantir que suas receitas possam ser importadas.';

  @override
  String get migrationPaprikaDescription =>
      'Mealie pode importar receitas do aplicativo Paprika. Exporte suas receitas do Paprika, renomeie a extensão do arquivo para .zip e carregue-o abaixo.';

  @override
  String get migrationPlanToEatDescription =>
      'Mealie consegue importar receitas do Planejar Refeições.';

  @override
  String get migrationRecipeKeeperDescription =>
      'Mealie pode importar receitas do Recipe Keeper. Exporte suas receitas no formato ZIP, então envie o arquivo abaixo.';

  @override
  String get migrationTandoorDescription =>
      'Mealie pode importar receitas do Tandoor. Exporte seus dados no formato \"Padrão\" e faça o upload do arquivo .zip abaixo.';

  @override
  String get migrationCooknDescription =>
      'O Mealie pode importar receitas do DVO Cook’n X3. Exporte um livro de receitas ou menu no formato “Cook\'n”, renomeie a extensão do arquivo exportado para .zip e, em seguida, envie o arquivo .zip abaixo.';

  @override
  String get reportTitle => 'Denunciar';

  @override
  String get recipeDataTitle => 'Dados da Receita';

  @override
  String get recipeDataDescription =>
      'Use esta seção para gerenciar os dados associados a suas receitas. Você pode executar várias ações em massa nas suas receitas, incluindo exportação, exclusão, marcação e atribuição de categorias.';

  @override
  String get recipeDataTagTitle => 'Marcar Receitas';

  @override
  String get recipeDataCategorizeTitle => 'Categorizar Receitas';

  @override
  String get recipeDataSettingsTitle => 'Atualizar configurações';

  @override
  String get recipeDataExportTitle => 'Exportar Receitas';

  @override
  String get recipeDataDeleteTitle => 'Excluir Receitas';

  @override
  String recipeDataExportConfirm(int count) {
    return 'As seguintes receitas ($count) serão exportadas.';
  }

  @override
  String get recipeDataExportsTitle => 'Exportações de Dados';

  @override
  String get recipeDataExportsDescription =>
      'Esta seção fornece links para exportações que estão prontas para download. Essas exportações expiram, então certifique-se de pegá-las enquanto ainda estão disponíveis.';

  @override
  String get recipeDataPurgeExports => 'Limpar exportações';

  @override
  String get recipeDataPurgeConfirm =>
      'Você tem certeza que deseja excluir todos os dados exportados?';

  @override
  String get recipeActionsTitle => 'Ações de Receita';

  @override
  String get recipeActionNew => 'Nova Ação de Receita';

  @override
  String get recipeActionEdit => 'Alterar Ação de Receita';

  @override
  String get recipeActionTypeLink => 'Link';

  @override
  String get recipeActionTypePost => 'Postagem';

  @override
  String get webhooksTitle => 'Webhooks';

  @override
  String get webhooksDescription =>
      'Os webhooks definidos abaixo serão executados quando uma refeição for definida para o dia. No horário programado, os webhooks serão enviados com os dados da receita que está agendada para o dia. Observe que a execução do webhook não é exata. Os webhooks são executados em um intervalo de 5 minutos, de modo que os webhooks serão executados dentro de 5 + /- minutos dos horários agendados.';

  @override
  String get webhookName => 'Nome do Webhook';

  @override
  String get webhookUrl => 'URL do Webhook';

  @override
  String get notifiersTitle => 'Notificadores';

  @override
  String get notifiersDescription =>
      'Configure e-mails e notificações push que desencadeiam eventos específicos.';

  @override
  String get notifierNew => 'Nova Notificação';

  @override
  String get notifierDescription =>
      'Mealie usa a biblioteca Apprise para gerar notificações. Eles oferecem várias opções de serviços para serem usados para notificações. Consulte a wiki para um guia completo sobre como criar a URL para o seu serviço. Se disponível, selecionar o tipo de notificação pode incluir recursos extras.';

  @override
  String get notifierAppriseUrl => 'URL do Apprise';

  @override
  String get notifierAppriseUrlSkipped =>
      'URL Apprise (ignorado se estiver em branco)';

  @override
  String get notifierAppriseUrlBlankHint =>
      'Como URLs de notificação normalmente contém informações confidenciais, este campo foi deixando intencionalmente em branco quando editado. Se você deseja atualizar o URL, por favor insira o novo localizador aqui. Caso contrário, deixe em branco para manter o URL atual.';

  @override
  String get notifierEnable => 'Habilitar Notificador';

  @override
  String get notifierWhatEvents =>
      'A quais eventos este notificador deve subscrever?';

  @override
  String get notifierRecipeEvents => 'Eventos da Receita';

  @override
  String get notifierUserEvents => 'Eventos do usuário';

  @override
  String get notifierMealplanEvents => 'Eventos do plano de refeições';

  @override
  String get notifierShoppingListEvents => 'Eventos da lista de compras';

  @override
  String get notifierCookbookEvents => 'Eventos do Livro de Receitas';

  @override
  String get notifierTagEvents => 'Eventos de Etiqueta';

  @override
  String get notifierCategoryEvents => 'Eventos de Categoria';

  @override
  String get notifierLabelEvents => 'Rotular Eventos';

  @override
  String get notifierUserSignup => 'Quando um novo usuário entrar no seu grupo';

  @override
  String get notifierCreate => 'Criar';

  @override
  String get notifierUpdate => 'Atualizar';

  @override
  String get notifierDelete => 'Excluir';

  @override
  String get notifierTestSent => 'Mensagem de teste enviada';

  @override
  String get adminTitle => 'Configurações de administrador';

  @override
  String get backupsTitle => 'Backups';

  @override
  String get backupsDescription =>
      'Cópias de segurança são \"retratos\" do banco de dados e diretórios de dados do site. Isso inclui todos os dados e não pode segregar subconjuntos de dados. Pense como um retrato do Mealie num momento específico. Elas servem como uma forma agnóstica de exportar e importar dados, ou copiar o site para um local externo.';

  @override
  String get backupCreateHeading => 'Criar um Backup';

  @override
  String get backupCreated => 'Backup criado com sucesso';

  @override
  String get backupCreateFailed =>
      'Erro ao Criar Backup. Consulte o Arquivo de Log';

  @override
  String get backupDelete => 'Excluir Backup';

  @override
  String get backupDeleted => 'Backup excluído';

  @override
  String get backupRestore => 'Restaurar Backup';

  @override
  String get backupRestoreDescription =>
      'Restaurar este backup substituirá todos os dados atuais no seu banco de dados e no diretório de dados e os substituirá pelo conteúdo deste backup. Se a restauração for bem-sucedida, você será desconectado.';

  @override
  String get backupCannotBeUndone =>
      'Esta ação não pode ser desfeita - use com cautela.';

  @override
  String get backupAcknowledge =>
      'Eu entendo que esta ação é irreversível, destrutiva e pode causar perda de dados';

  @override
  String get backupRestoreSuccess => 'Restauração bem-sucedida';

  @override
  String get backupRestoreFailed =>
      'Restauração falhou. Mais detalhes nos registros do servidor';

  @override
  String get maintenanceTitle => 'Manutenção';

  @override
  String get maintenanceSummary => 'Resumo';

  @override
  String get maintenanceStorage => 'Detalhes de armazenamento';

  @override
  String get maintenanceDataDirSize => 'Tamanho do diretório de dados';

  @override
  String get maintenanceCleanableDirs => 'Diretórios Limpáveis';

  @override
  String get maintenanceCleanableImages => 'Imagens limpáveis';

  @override
  String get maintenanceTempDir => 'Diretório temporário (.temp)';

  @override
  String get maintenanceBackupsDir => 'Diretório de Backups (backups)';

  @override
  String get maintenanceGroupsDir => 'Diretório de Grupos (grupos)';

  @override
  String get maintenanceRecipesDir => 'Diretório de Receitas (receitas)';

  @override
  String get maintenanceUserDir => 'Diretório do Usuário (Usuário)';

  @override
  String get maintenanceCleanDirs => 'Limpar diretórios';

  @override
  String get maintenanceCleanDirsDescription =>
      'Remove todas as pastas de receitas que não são UUIDs válidos';

  @override
  String get maintenanceCleanTemp => 'Limpar arquivos temporários';

  @override
  String get maintenanceCleanTempDescription =>
      'Remove todos os arquivos e pastas no diretório .temp';

  @override
  String get maintenanceCleanImages => 'Limpar imagens';

  @override
  String get maintenanceCleanImagesDescription =>
      'Remove todas as imagens que não terminam com .webp';

  @override
  String get maintenanceActions => 'Ações';

  @override
  String get adminConfiguration => 'Configuração';

  @override
  String get adminAppVersion => 'Versão do aplicativo';

  @override
  String get adminUpToDate => 'Mealie está atualizado';

  @override
  String adminVersionOutdated(String current, String latest) {
    return 'Sua versão atual ($current) não coincide com a última versão. Considere atualizar para a última versão ($latest).';
  }

  @override
  String get adminBaseUrl => 'URL base do servidor';

  @override
  String get adminBaseUrlOk => 'A URL do Servidor não coincide com o padrão';

  @override
  String get adminBaseUrlError =>
      '`BASE_URL` ainda é o valor padrão no servidor de API. Isso causará problemas com os links gerados no servidor para e-mails, etc.';

  @override
  String adminAuthReady(String provider) {
    return '$provider pronto';
  }

  @override
  String adminAuthNotReady(String provider) {
    return '$provider não está pronto';
  }

  @override
  String adminAuthDisabled(String provider) {
    return '$provider desativado';
  }

  @override
  String adminAuthSuccessText(String provider) {
    return 'Todas as variáveis necessárias de $provider estão definidas.';
  }

  @override
  String adminAuthErrorText(String provider) {
    return 'Nem todos os valores de $provider estão configurados. Ignore se você não usa a autenticação $provider.';
  }

  @override
  String adminAuthDisabledText(String envVar) {
    return 'Para ativar, defina $envVar como true.';
  }

  @override
  String get adminEmailStatus => 'Status da configuração do e-mail';

  @override
  String get adminEmailConfigured => 'E-mail configurado';

  @override
  String get adminNotReady =>
      'Não está Pronto - Verificar variáveis ambientais';

  @override
  String get adminSucceeded => 'Sucesso';

  @override
  String get adminFailed => 'Falhou';

  @override
  String get adminSiteStatistics => 'Estatísticas do site';

  @override
  String get adminUncategorized => 'Receitas sem categoria';

  @override
  String get adminUntagged => 'Receitas sem tags';

  @override
  String get adminGeneralAbout => 'Sobre';

  @override
  String get adminVersion => 'Versão';

  @override
  String get adminBuild => 'Compilaçāo';

  @override
  String get adminApplicationMode => 'Modo do Aplicativo';

  @override
  String get adminProduction => 'Produção';

  @override
  String get adminDevelopment => 'Desenvolvimento';

  @override
  String get adminDemoStatus => 'Status da Demonstração';

  @override
  String get adminDemo => 'Demonstração';

  @override
  String get adminNotDemo => 'Não é Demonstração';

  @override
  String get adminApiPort => 'Porta da API';

  @override
  String get adminApiDocs => 'Documentação da API';

  @override
  String get adminDatabaseType => 'Tipo do Banco de Dados';

  @override
  String get adminDatabaseUrl => 'URL do banco de dados';

  @override
  String get adminDefaultGroup => 'Grupo Padrão';

  @override
  String get adminDefaultHousehold => 'Casa Padrão';

  @override
  String get adminScraperVersion => 'Versão do receptor de receita';

  @override
  String get adminStatUsers => 'Usuários';

  @override
  String get adminStatHouseholds => 'Domicílios';

  @override
  String get adminStatGroups => 'Grupos';

  @override
  String get recipeDuplicate => 'Duplicar receita';

  @override
  String get recipeDuplicateAction => 'Duplicar';

  @override
  String get recipeShareLink => 'Compartilhar Receita';

  @override
  String get recipeShareExpiration => 'Data de Validade';

  @override
  String get recipeShareCopied =>
      'Link da receita copiado para área de transferência';

  @override
  String get enabledLabel => 'Habilitado';

  @override
  String get disabledLabel => 'Desabilitado';

  @override
  String get testAction => 'Teste';

  @override
  String get yesLabel => 'Sim';

  @override
  String get noLabel => 'Não';

  @override
  String get downloadAction => 'Baixar';

  @override
  String get backupUpload => 'Enviar';

  @override
  String get zipImportButton => 'Importar do .zip';

  @override
  String get zipImportDescription =>
      'Importar uma única receita exportada de outra instância Mealie.';

  @override
  String get reportStatus => 'Estado';

  @override
  String get reportDate => 'Data';

  @override
  String get recipeActionTitleLabel => 'Título';

  @override
  String get clearAll => 'Limpar';

  @override
  String get recipeDataSettingsExplanation =>
      'As configurações escolhidas aqui, excluindo a opção bloqueada, serão aplicadas a todas as receitas selecionadas.';

  @override
  String get adminAllowSignup => 'Permitir cadastro';

  @override
  String get adminAllowPasswordLogin => 'Permitir login com senha';

  @override
  String get adminEmailInvalid => 'Informe um endereço de e-mail válido.';

  @override
  String adminEmailTestResult(String result) {
    return 'Teste de e-mail: $result';
  }

  @override
  String get adminSendTestEmail => 'Enviar e-mail de teste';

  @override
  String get adminTestEmailAddress => 'Destinatário';

  @override
  String get backupCreate => 'Criar backup';

  @override
  String backupDeleteConfirm(String name) {
    return 'Excluir o backup \"$name\"?';
  }

  @override
  String get backupPostgresNote =>
      'Se você usa PostgreSQL, leia o processo de backup/restauração na documentação do Mealie antes de restaurar.';

  @override
  String get backupUploaded => 'Backup enviado';

  @override
  String get backupsEmpty => 'Nenhum backup ainda.';

  @override
  String get bulkImportAddRow => 'Adicionar URL';

  @override
  String get bulkImportStart => 'Iniciar importação';

  @override
  String get chooseFileButton => 'Escolher arquivo';

  @override
  String get deselectAllAction => 'Desmarcar tudo';

  @override
  String get downloadFailed => 'Falha no download';

  @override
  String get fileSaved => 'Arquivo salvo';

  @override
  String get loadFailed => 'Não foi possível carregar';

  @override
  String get maintenanceActionsWarning =>
      'As ações de manutenção são destrutivas e devem ser usadas com cautela. Qualquer uma delas é irreversível.';

  @override
  String get maintenanceConfirm =>
      'Esta ação é destrutiva e não pode ser desfeita. Continuar?';

  @override
  String get maintenanceDone => 'Concluído';

  @override
  String get maintenanceFailed => 'A ação de manutenção falhou';

  @override
  String get maintenanceRun => 'Executar';

  @override
  String get migrationFailed => 'A migração falhou';

  @override
  String get migrationStart => 'Iniciar migração';

  @override
  String get migrationStarted =>
      'Migração concluída — veja o relatório abaixo.';

  @override
  String get moreImportOptions => 'Mais opções de importação';

  @override
  String notifierDeleteConfirm(String name) {
    return 'Excluir a notificação \"$name\"?';
  }

  @override
  String get notifierEdit => 'Editar notificação';

  @override
  String notifierEventCount(int count) {
    return 'Eventos: $count';
  }

  @override
  String get notifierTestFailed =>
      'Não foi possível enviar a mensagem de teste';

  @override
  String get notifiersEmpty => 'Nenhuma notificação ainda.';

  @override
  String recipeActionDeleteConfirm(String name) {
    return 'Excluir a ação de receita \"$name\"?';
  }

  @override
  String get recipeActionFailed => 'A ação de receita falhou';

  @override
  String get recipeActionSent => 'Receita enviada';

  @override
  String get recipeActionUrlHint => 'Marcadores';

  @override
  String get recipeActionsDescription =>
      'As ações de receita aparecem no menu de cada receita. \"Link\" abre a URL; \"Post\" faz o servidor do Mealie enviar a receita para a URL.';

  @override
  String get recipeActionsEmpty => 'Nenhuma ação de receita ainda.';

  @override
  String recipeDataDeleteConfirm(int count) {
    return 'Excluir as receitas selecionadas ($count)? Esta ação não pode ser desfeita.';
  }

  @override
  String recipeDataDeleteForbidden(int count) {
    return 'Você não pode excluir $count das receitas selecionadas (somente o criador ou um administrador).';
  }

  @override
  String recipeDataDeleted(int count) {
    return 'Receitas excluídas: $count';
  }

  @override
  String get recipeDataExportAction => 'Exportar';

  @override
  String get recipeDataExportDone =>
      'Exportação criada — baixe-a em Exportações de dados.';

  @override
  String recipeDataExportExpires(String date) {
    return 'expira em $date';
  }

  @override
  String get recipeDataExportFailed => 'A exportação falhou';

  @override
  String get recipeDataExportsEmpty => 'Nenhuma exportação disponível.';

  @override
  String recipeDataUpdated(int count) {
    return 'Receitas atualizadas: $count';
  }

  @override
  String get recipeDuplicated => 'Receita duplicada';

  @override
  String get recipeExportJson => 'Exportar como JSON';

  @override
  String get recipeExportZip => 'Exportar como ZIP (com imagem)';

  @override
  String get recipeShareCreate => 'Criar link';

  @override
  String get recipeShareDescription =>
      'Qualquer pessoa com o link pode ver esta receita no navegador — sem conta — até expirar.';

  @override
  String get recipeShareEmpty => 'Nenhum link de compartilhamento ainda.';

  @override
  String recipeShareExpiresAt(String date) {
    return 'Expira em $date';
  }

  @override
  String get recipeWebToolsMenu => 'Duplicar, link de compartilhamento e mais';

  @override
  String get reload => 'Recarregar';

  @override
  String get reportDeleteConfirm => 'Excluir este relatório?';

  @override
  String get reportEntries => 'Entradas';

  @override
  String get reportFailedEntries => 'Com falha';

  @override
  String get reportOnlyFailed => 'Mostrar apenas entradas com falha';

  @override
  String get reportStatusFailure => 'Falha';

  @override
  String get reportStatusInProgress => 'Em andamento';

  @override
  String get reportStatusPartial => 'Parcial';

  @override
  String get reportStatusSuccess => 'Sucesso';

  @override
  String get reportsEmpty => 'Nenhum relatório ainda.';

  @override
  String get uploadFailed => 'Falha no envio';

  @override
  String webhookDeleteConfirm(String name) {
    return 'Excluir o webhook \"$name\"?';
  }

  @override
  String get webhookEdit => 'Editar webhook';

  @override
  String get webhookNew => 'Novo webhook';

  @override
  String get webhookTestFailed => 'Não foi possível iniciar o teste';

  @override
  String get webhookTestSent => 'Webhook de teste disparado';

  @override
  String get webhookTime => 'Horário (local)';

  @override
  String get webhooksEmpty => 'Nenhum webhook ainda.';

  @override
  String get zipImportFailed => 'A importação ZIP falhou';

  @override
  String get aiProvidersTitle => 'Provedores de IA';

  @override
  String get aiProvidersDescription =>
      'Configure provedores de IA para ativar recursos com IA, como análise aprimorada de ingredientes, criação de receitas a partir de vídeos e muito mais!';

  @override
  String get aiProviderSettingsTitle => 'Configurações de provedores de IA';

  @override
  String get aiProvidersList => 'Provedores';

  @override
  String get aiProviderCreate => 'Criar provedor';

  @override
  String get aiProviderEdit => 'Editar provedor';

  @override
  String get aiDefaultProvider => 'Provedor padrão';

  @override
  String get aiDefaultProviderDescription =>
      'Necessário para ativar os recursos de IA';

  @override
  String get aiAudioProvider => 'Provedor de áudio';

  @override
  String get aiAudioProviderDescription =>
      'Ativa a transcrição de áudio, como criar receitas a partir de vídeos';

  @override
  String get aiImageProvider => 'Provedor de imagens';

  @override
  String get aiImageProviderDescription =>
      'Ativa o reconhecimento de imagens, como criar receitas a partir de fotos';

  @override
  String get aiProviderName => 'Nome do provedor';

  @override
  String get aiApiKey => 'Chave de API';

  @override
  String get aiApiKeyCreateDescription =>
      'A chave de API do seu provedor para autenticação. Se o serviço (ex.: Ollama) não usar chave de API, ainda assim é preciso preencher algo aqui.';

  @override
  String get aiApiKeyEditDescription =>
      'Deixe em branco, a menos que queira alterá-la.';

  @override
  String get aiBaseUrl => 'URL base';

  @override
  String get aiBaseUrlDescription =>
      'Se você usa OpenAI, deixe em branco. Deve ser um endpoint compatível com OpenAI (ex.: \"http://localhost:11434/v1\").';

  @override
  String get aiModel => 'Modelo';

  @override
  String get aiModelDescription =>
      'Qual modelo o provedor de IA deve usar (ex.: \"gpt-5\").';

  @override
  String get aiTimeout => 'Tempo limite da solicitação (segundos)';

  @override
  String get aiProviderCreated => 'Provedor criado';

  @override
  String get aiProviderUpdated => 'Provedor atualizado';

  @override
  String get aiProviderDeleted => 'Provedor excluído';

  @override
  String get aiProviderCreateFailed => 'Falha ao criar o provedor';

  @override
  String get aiProviderUpdateFailed => 'Falha ao atualizar o provedor';

  @override
  String get aiProviderDeleteFailed => 'Falha ao excluir o provedor';

  @override
  String get aiRequestHeaders => 'Cabeçalhos da solicitação';

  @override
  String get aiRequestParams => 'Parâmetros da solicitação';

  @override
  String get aiNoDefaultWarning =>
      'Você não definiu um provedor padrão, então os recursos de IA estão desativados';

  @override
  String get aiTestConnection => 'Testar conexão';

  @override
  String get aiTestSucceeded => 'Conexão bem-sucedida';

  @override
  String get aiTestFailed => 'Falha na conexão';

  @override
  String get aiSupportsImages => 'Suporta imagens';

  @override
  String get aiTextOnly =>
      'Somente texto — não pode ser seu provedor de imagens';

  @override
  String get debugAiTitle => 'Depurar provedores de IA';

  @override
  String get debugAiDescription =>
      'Use esta página para depurar provedores de IA. Teste a conexão e veja os resultados aqui. Se os serviços de imagem estiverem ativados, você também pode enviar uma imagem.';

  @override
  String get debugParserTitle => 'Analisador';

  @override
  String get debugParserDescription =>
      'Meália usa Campos Aleatórios Condicionais (CRFs) para analisar e processar ingredientes. O modelo usado para ingredientes é baseado em um conjunto de dados de mais de 100 mil ingredientes a partir de um conjunto de dados compilado pelo New York Times. Observe que como o modelo é treinado apenas em inglês, você pode ter resultados variados ao usar o modelo em outros idiomas. Esta página é um playground para testar o modelo.';

  @override
  String get debugIngredientText => 'Texto de Ingrediente';

  @override
  String get debugTryExample => 'Veja um exemplo';

  @override
  String debugAverageConfidence(String value) {
    return '$value confiante';
  }

  @override
  String get debugRunTest => 'Executar teste';

  @override
  String get debugQuantity => 'Quantidade';

  @override
  String get debugUnit => 'Unidade';

  @override
  String get debugFood => 'Comida';

  @override
  String get debugNote => 'Comentário';

  @override
  String get debugGroup => 'Grupo';

  @override
  String get aiProviderNone => 'Nenhum';

  @override
  String aiProviderDeleteConfirm(String name) {
    return 'Excluir o provedor \"$name\"?';
  }

  @override
  String get aiProvidersEmpty => 'Nenhum provedor de IA ainda.';

  @override
  String get aiAdvanced => 'Avançado';

  @override
  String get aiKeyLabel => 'Nome';

  @override
  String get aiValueLabel => 'Valor';

  @override
  String get debugTitle => 'Depuração';

  @override
  String get debugParse => 'Analisar';

  @override
  String get debugParseFailed => 'Não foi possível analisar o ingrediente';

  @override
  String get debugChooseImage => 'Escolher imagem';

  @override
  String get debugNoImage => 'Sem imagem (opcional)';

  @override
  String get updateTitle => 'Verificar atualizações';

  @override
  String get updateInstalledVersion => 'Versão instalada';

  @override
  String get updateLastCheck => 'Última verificação';

  @override
  String get updateCheckNow => 'Verificar agora';

  @override
  String get updateChecking => 'Verificando atualizações…';

  @override
  String get updateUpToDate => 'O Mealie Recipes está atualizado.';

  @override
  String updateAvailable(String version) {
    return 'A versão $version está disponível';
  }

  @override
  String get updateAvailableDescription =>
      'Há uma nova versão do Mealie Recipes. Nada é instalado até você iniciar a atualização.';

  @override
  String get updateShow => 'Ver atualização';

  @override
  String get updateLater => 'Mais tarde';

  @override
  String updateDownloading(int percent) {
    return 'Baixando… $percent %';
  }

  @override
  String updateReady(String version) {
    return 'A versão $version está pronta para instalar';
  }

  @override
  String get updateInstalling =>
      'Instalando — o app será reiniciado em instantes…';

  @override
  String get updateManual =>
      'Não foi possível instalar automaticamente. A imagem de disco foi aberta: arraste o Mealie Recipes para Aplicativos.';

  @override
  String get updateFailed => 'A atualização falhou';

  @override
  String get updateInstallNow => 'Baixar e instalar';

  @override
  String get updateRestartNow => 'Instalar e reiniciar';

  @override
  String get updateAutoTitle => 'Verificar atualizações ao iniciar';

  @override
  String get updateAutoDescription =>
      'Apenas verifica e avisa — a instalação é sempre iniciada por você.';

  @override
  String get updateNoNotes => 'Sem notas da versão.';

  @override
  String get updateSourceHint =>
      'As atualizações vêm dos lançamentos do Mealie Recipes no GitHub e só são instaladas se assinadas pelo desenvolvedor (macOS).';
}
