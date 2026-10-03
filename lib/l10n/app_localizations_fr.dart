// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Mealie Recipes';

  @override
  String get endCookingMode => 'Quitter le mode cuisine';

  @override
  String get endCookingModeConfirm =>
      'Voulez-vous vraiment quitter le mode cuisine ?';

  @override
  String endCookingModeConfirmAll(int count) {
    return 'Cela mettra fin aux $count recettes du mode cuisine. Continuer ?';
  }

  @override
  String get addTimer => 'Ajouter un minuteur';

  @override
  String get recipeFinished => 'Votre plat est prêt.';

  @override
  String get bonAppetit => 'Bon appétit !';

  @override
  String get prepareIngredients => 'Préparez les ingrédients suivants';

  @override
  String prepareIngredientsFor(String servings) {
    return 'Préparez les ingrédients suivants pour $servings portions';
  }

  @override
  String get next => 'Suivant';

  @override
  String get navHome => 'Accueil';

  @override
  String get homeCookToday => 'Cuisiner aujourd\'hui';

  @override
  String get homeSuggestion => 'Suggestion';

  @override
  String get homeQuickAccess => 'Accès rapide';

  @override
  String get homePlanned => 'Planifié';

  @override
  String get favorite => 'Favori';

  @override
  String get navSettings => 'Réglages';

  @override
  String homeWelcomeName(Object name) {
    return 'Bienvenue $name,';
  }

  @override
  String get homeWelcomeApp => 'sur Mealie Recipes 👋';

  @override
  String get theme => 'Apparence';

  @override
  String get themeSystem => 'Système';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeDark => 'Sombre';

  @override
  String get recipes => 'Recettes';

  @override
  String get shoppingList => '🛒 Liste de courses';

  @override
  String get mealplan => 'Plan repas';

  @override
  String get settings => '⚙️ Paramètres';

  @override
  String get searchRecipe => 'Chercher une recette...';

  @override
  String get loadingRecipes => 'Chargement des recettes...';

  @override
  String get loadingRecipe => 'Chargement de la recette...';

  @override
  String errorLoadingRecipes(String error) {
    return 'Erreur de chargement: $error';
  }

  @override
  String get errorLoadingRecipe => 'Impossible de charger la recette.';

  @override
  String get noRecipesForCategory => 'Aucune recette pour ce filtre.';

  @override
  String get resetFilter => 'Réinitialiser le filtre';

  @override
  String get allCategories => 'Toutes les catégories';

  @override
  String get all => 'Toutes';

  @override
  String get sortRecipes => 'Trier les recettes';

  @override
  String get refreshRecipes => 'Actualiser';

  @override
  String get sortNameAZ => 'Nom A–Z';

  @override
  String get sortNameZA => 'Nom Z–A';

  @override
  String get sortDateNewest => 'Plus récentes d\'abord';

  @override
  String get sortDateOldest => 'Plus anciennes d\'abord';

  @override
  String get sortPrepTimeShort => 'Préparation la plus courte';

  @override
  String get sortPrepTimeLong => 'Préparation la plus longue';

  @override
  String get sortRatingHighest => 'Meilleures notes';

  @override
  String get sortRatingLowest => 'Notes les plus basses';

  @override
  String get details => 'Détails';

  @override
  String get ingredients => 'Ingrédients';

  @override
  String get instructions => 'Instructions';

  @override
  String get tags => 'Mots-clés';

  @override
  String get notes => 'Notes';

  @override
  String get addNote => 'Ajouter une note';

  @override
  String get editNote => 'Modifier la note';

  @override
  String get noteTitleHint => 'Titre (facultatif)';

  @override
  String get noteTextHint => 'Texte de la note';

  @override
  String get deleteNoteTitle => 'Supprimer la note ?';

  @override
  String get deleteNoteMessage => 'Cette note sera définitivement supprimée.';

  @override
  String get servings => 'Portions';

  @override
  String get adjustQuantity => 'Ajuster la quantité';

  @override
  String get startTimer => 'Démarrer le minuteur';

  @override
  String runningTimer(int minutes, String seconds) {
    return 'Minuteur: $minutes:$seconds';
  }

  @override
  String get planMeal => 'Planifier un repas';

  @override
  String get displayAlwaysOn => 'Écran toujours allumé';

  @override
  String get addAllIngredients => 'Ajouter tous les ingrédients';

  @override
  String get addSelectedIngredients => 'Ajouter les ingrédients sélectionnés';

  @override
  String get addIngredientsTitle => 'Ingrédients ajoutés';

  @override
  String get addIngredientsMessage =>
      'Les ingrédients ont été ajoutés à votre liste de courses.';

  @override
  String addIngredientsFailedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ingrédients n\'ont pas pu être ajoutés.',
      one: '1 ingrédient n\'a pas pu être ajouté.',
    );
    return '$_temp0';
  }

  @override
  String get cookbooks => 'Livres de recettes';

  @override
  String get cookbooksEmpty =>
      'Aucun livre de recettes pour le moment. Appuie sur « + » en haut à droite pour en créer un.';

  @override
  String get cookbookNoMatches => 'Aucune recette ne correspond à ce filtre.';

  @override
  String get cookbookCreateTitle => 'Créer un livre de recettes';

  @override
  String get cookbookEditTitle => 'Modifier le livre de recettes';

  @override
  String get cookbookNameLabel => 'Nom du livre de recettes';

  @override
  String get cookbookFilterSectionTitle =>
      'Ajouter des recettes automatiquement';

  @override
  String get cookbookFieldTools => 'Ustensiles';

  @override
  String get cookbookFieldUsers => 'Utilisateurs';

  @override
  String get cookbookOpIsOneOf => 'est l\'un de';

  @override
  String get cookbookOpIsNotOneOf => 'n\'est aucun de';

  @override
  String get cookbookOpContainsAll => 'contient tous';

  @override
  String get cookbookSelectValues => 'Sélectionner des valeurs';

  @override
  String get cookbookFilterOptionsUnavailable => 'Aucune option disponible';

  @override
  String get cookbookAddFilterField => 'Ajouter un champ';

  @override
  String get cookbookPublicLabel => 'Livre de recettes public';

  @override
  String get cookbookPublicSubtitle =>
      'Visible par les autres foyers du serveur';

  @override
  String get cookbookRawModeEnter => 'Modifier en texte';

  @override
  String get cookbookRawModeExit => 'Retour au générateur';

  @override
  String get cookbookRawModeHint =>
      'Mode expert de cette app : modifie le filtre directement en texte. Utile quand un filtre existant n\'a pas pu être décomposé en lignes simples.';

  @override
  String get cookbookRawModeUnparseable =>
      'Ce texte ne correspond pas au format de lignes simple — il reste tel quel.';

  @override
  String get saveFailed => 'Échec de l\'enregistrement';

  @override
  String get search => 'Rechercher';

  @override
  String get apply => 'Appliquer';

  @override
  String get setupCachingTitle => 'Chargement de vos recettes';

  @override
  String get setupCachingSubtitle =>
      'Vos recettes sont préparées pour une utilisation hors ligne. Selon leur nombre, cela peut prendre un moment.';

  @override
  String get setupCachingDone => 'Tout est prêt !';

  @override
  String get setupTipsHeader => 'Le saviez-vous ?';

  @override
  String get setupFinish => 'C\'est parti';

  @override
  String get setupSkipCaching => 'Continuer en arrière-plan';

  @override
  String get setupTip1 =>
      'Vous pouvez importer des recettes depuis un lien, une photo ou un PDF — via la tuile Importer de l\'écran d\'accueil.';

  @override
  String get setupTip2 =>
      'Le mode cuisine garde l\'écran allumé, vous guide étape par étape et détecte automatiquement les minuteurs dans le texte.';

  @override
  String get setupTip3 =>
      'La liste de courses fonctionne aussi hors ligne — les modifications se synchronisent dès que le serveur est joignable.';

  @override
  String get setupTip4 =>
      'Appuyez longuement sur une tuile de l\'écran d\'accueil pour réorganiser l\'accès rapide.';

  @override
  String get setupTip5 =>
      'Retrouvez vos livres de recettes Mealie via la tuile dédiée — disponible aussi hors ligne.';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Annuler';

  @override
  String get delete => 'Supprimer';

  @override
  String get edit => 'Modifier';

  @override
  String get save => 'Enregistrer';

  @override
  String get done => 'Terminé';

  @override
  String get close => 'Fermer';

  @override
  String get add => 'Ajouter';

  @override
  String get send => 'Envoyer';

  @override
  String get retry => 'Réessayer';

  @override
  String get confirmDeleteTitle => 'Supprimer la recette?';

  @override
  String get confirmDeleteMessage => 'Cette action est irréversible.';

  @override
  String get sendToDevice => 'Envoyer à l\'appareil';

  @override
  String get sendToDevicePickerTitle => 'Envoyer à l\'appareil';

  @override
  String get sendToAllDevices => 'Envoyer à tous les appareils';

  @override
  String get timerFinished => 'Minuteur terminé!';

  @override
  String get timerFinishedBody => 'Votre minuteur de recette est terminé.';

  @override
  String get timer => 'Minuteur';

  @override
  String get newTimer => 'Nouveau minuteur';

  @override
  String get timerDetails => 'Détails du minuteur';

  @override
  String get timerNamePlaceholder => 'Nom du minuteur';

  @override
  String get timerNameHint => 'Donnez un nom descriptif au minuteur.';

  @override
  String get durationLabel => 'Durée';

  @override
  String minutesCount(int count) {
    return '$count minutes';
  }

  @override
  String get start => 'Démarrer';

  @override
  String get stop => 'Arrêter';

  @override
  String get pause => 'Mettre en pause';

  @override
  String get resume => 'Reprendre';

  @override
  String get finished => 'Terminé!';

  @override
  String stepNumber(int number) {
    return 'Étape $number';
  }

  @override
  String get minAbbreviation => 'min';

  @override
  String get cookingMode => 'Mode cuisine';

  @override
  String activeRecipesCount(int count) {
    return '$count recettes actives';
  }

  @override
  String get endAll => 'Tout terminer';

  @override
  String get end => 'Terminer';

  @override
  String get endAllRecipesTitle => 'Terminer toutes les recettes?';

  @override
  String endAllRecipesMessage(int count) {
    return 'Voulez-vous terminer les $count sessions actives?';
  }

  @override
  String get endRecipeTitle => 'Terminer la recette?';

  @override
  String endRecipeMessage(String name) {
    return 'Voulez-vous terminer la session de \"$name\"?';
  }

  @override
  String get noActiveTimers => 'Aucun minuteur actif';

  @override
  String get noActiveRecipes => 'Aucune recette active';

  @override
  String get startRecipeToCook =>
      'Ouvrez une recette et appuyez sur le bouton mode cuisine.';

  @override
  String get browseRecipes => 'Parcourir les recettes';

  @override
  String timersPausedCount(int count) {
    return '$count minuteur(s) en pause';
  }

  @override
  String get cookFriends => 'Cuisiner avec des amis';

  @override
  String get cookingModeAddRecipe => 'Ajouter une recette';

  @override
  String get cookingModeAddRecipeSearchHint => 'Rechercher des recettes';

  @override
  String get cookFriendsCode => 'Code de session';

  @override
  String get cookFriendsJoin => 'Rejoindre une session';

  @override
  String get cookFriendsHost => 'Héberger une session';

  @override
  String get cookFriendsHostNotFound =>
      'Hôte introuvable. Assurez-vous que les deux appareils sont sur le même Wi-Fi et que l\'accès au réseau local est autorisé.';

  @override
  String get cookFriendsConnectionFailed =>
      'Échec de la connexion. Veuillez réessayer.';

  @override
  String get cookFriendsEnterCode => 'Entrer le code';

  @override
  String cookFriendsConnected(int count) {
    return 'Connecté: $count invités';
  }

  @override
  String get joinSession => 'Rejoindre la session';

  @override
  String get hostEndedSessionTitle => 'Session terminée';

  @override
  String get hostEndedSessionMessage => 'L\'hôte a terminé la session.';

  @override
  String get shoppingListEmpty => 'Votre liste de courses est vide.';

  @override
  String get addItem => 'Ajouter un article';

  @override
  String get itemNote => 'Nom de l\'article';

  @override
  String get unlabeledCategory => 'Sans catégorie';

  @override
  String get reorderCategories => 'Réorganiser les catégories';

  @override
  String get archiveChecked => 'Archiver les cochés';

  @override
  String get archivedLists => '📦 Courses archivées';

  @override
  String get syncChanges => 'Synchroniser les modifications';

  @override
  String get noSyncChanges => 'Aucune modification à synchroniser';

  @override
  String get postimportAction => 'Après l\'import';

  @override
  String get postimportHint =>
      'Choisissez ce qui doit se passer dans l\'app source (Rappels / Google Tasks) avec les entrées importées.';

  @override
  String get postimportLeave => 'Ajouter seulement';

  @override
  String get postimportComplete => 'Cocher';

  @override
  String get postimportCompleteDelete => 'Cocher et supprimer';

  @override
  String get postimportFailed =>
      'Le traitement ultérieur dans l\'app source a échoué. Les articles ont quand même été ajoutés à Mealie.';

  @override
  String get syncChangesTitle => 'Synchroniser les modifications';

  @override
  String get syncSectionChecked => 'Coché';

  @override
  String get syncSectionQuantity => 'Quantité';

  @override
  String get syncSectionCategory => 'Catégorie';

  @override
  String get syncSectionAdditions => 'Nouvellement ajoutés';

  @override
  String get syncLocalLabel => 'Local';

  @override
  String get syncServerLabel => 'Serveur';

  @override
  String get syncNow => 'Synchroniser maintenant';

  @override
  String get offlineBadge => 'Hors ligne';

  @override
  String get mealplanTitle => '📅 Plan repas';

  @override
  String get mealplanSelectMode => 'Sélectionner plusieurs recettes';

  @override
  String mealplanSelectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sélectionnées',
      one: '1 sélectionnée',
      zero: 'Sélection',
    );
    return '$_temp0';
  }

  @override
  String get breakfast => 'Petit-déjeuner';

  @override
  String get lunch => 'Déjeuner';

  @override
  String get dinner => 'Dîner';

  @override
  String get addMealEntry => 'Ajouter un repas';

  @override
  String get selectRecipe => 'Sélectionner une recette';

  @override
  String get orFreeText => 'ou texte libre';

  @override
  String get entryNote => 'Note';

  @override
  String get noMealEntries => 'Aucune entrée pour cette semaine.';

  @override
  String get importRecipe => 'Importer une recette';

  @override
  String get importFromUrl => 'Importer depuis une URL';

  @override
  String get importFromImage => 'Importer depuis une photo';

  @override
  String get importFromJson => 'Importer depuis JSON';

  @override
  String get url => 'URL';

  @override
  String get urlPlaceholder => 'https://...';

  @override
  String get importLanguage => 'Langue pour l\'OCR';

  @override
  String get importing => 'Importation...';

  @override
  String get importSuccess => 'Recette importée avec succès!';

  @override
  String importError(String error) {
    return 'Échec de l\'importation: $error';
  }

  @override
  String get pasteJson => 'Collez le JSON ici';

  @override
  String get setupTitle => 'Bienvenue dans Mealie Recipes';

  @override
  String get setupSubtitle => 'Configurez votre serveur Mealie.';

  @override
  String get serverUrl => 'URL du serveur';

  @override
  String get serverUrlPlaceholder => 'https://mealie.exemple.com';

  @override
  String get apiToken => 'Jeton API';

  @override
  String get apiTokenPlaceholder => 'Votre jeton API';

  @override
  String get householdId => 'Ménage';

  @override
  String get householdIdPlaceholder => 'Family';

  @override
  String get shoppingListId => 'ID de la liste de courses';

  @override
  String get shoppingListIdPlaceholder => 'Sélectionner une liste';

  @override
  String get setupHouseholdListTitle => 'Foyer et liste de courses';

  @override
  String get shoppingListLabel => 'Liste de courses';

  @override
  String get setupHouseholdManualHint =>
      'Impossible de charger les foyers — saisis le nom manuellement.';

  @override
  String get setupExactTitle => 'Quantités sur la liste de courses';

  @override
  String get setupExactBody =>
      'Dans la plupart des pays, on n\'achète pas au gramme près : c\'est 1 paquet de beurre qui finit dans le panier, pas 200 g. En mode simple, l\'app convertit donc les quantités des recettes en « 1× ». En mode exact, quantité et unité sont conservées à l\'identique de la webapp Mealie — y compris quand tu saisis de nouveaux articles (p. ex. « 200 g de beurre »). Tu peux changer cela à tout moment dans les réglages.';

  @override
  String get setupExactSimpleTitle => 'Mode simple (1×)';

  @override
  String get setupExactSimpleBody =>
      'Les ingrédients arrivent sur la liste en « 1× article » — idéal pour cocher rapidement en magasin.';

  @override
  String get setupExactExactTitle => 'Quantités exactes';

  @override
  String get setupExactExactBody =>
      'Les articles apparaissent avec quantité et unité, p. ex. « 200 g de beurre » — comme dans la webapp.';

  @override
  String get connect => 'Connecter';

  @override
  String get connecting => 'Connexion...';

  @override
  String get connectionSuccess => 'Connexion réussie!';

  @override
  String connectionError(String error) {
    return 'Échec de connexion: $error';
  }

  @override
  String get optionalHeaders => 'En-têtes HTTP optionnels (pour proxy inverse)';

  @override
  String get settingsTitle => '⚙️ Paramètres';

  @override
  String get settingsSaved => 'Réglages enregistrés';

  @override
  String get serverSettings => 'Serveur';

  @override
  String get displaySettings => 'Affichage';

  @override
  String get notificationSettings => 'Notifications';

  @override
  String get securitySettings => 'Sécurité';

  @override
  String get aboutSettings => 'À propos';

  @override
  String get showRecipeImages => 'Afficher les images';

  @override
  String get apiVersion => 'Version API';

  @override
  String get language => 'Langue';

  @override
  String get biometricLock => 'Verrouillage biométrique';

  @override
  String get biometricLockDescription => 'Déverrouiller avec la biométrie';

  @override
  String get criticalAlerts => 'Alertes critiques';

  @override
  String get criticalAlertsDescription => 'Alarme même en mode silencieux';

  @override
  String get enableLogging => 'Activer la journalisation';

  @override
  String get selectLanguage => 'Sélectionner la langue';

  @override
  String get setupContinue => 'Continuer';

  @override
  String get back => 'Retour';

  @override
  String get setupConnectStep => 'Connectez-vous à votre serveur';

  @override
  String get resetSettings => 'Réinitialiser les paramètres';

  @override
  String get resetSettingsConfirm => 'Réinitialiser tous les paramètres?';

  @override
  String get guestMode => 'Mode invité';

  @override
  String get appVersion => 'Version';

  @override
  String get leftoverFinder => 'Recherche de recette';

  @override
  String get leftoverFinderSubtitle =>
      'Trouvez des recettes avec vos ingrédients';

  @override
  String get addIngredient => 'Ajouter un ingrédient';

  @override
  String get ingredientPlaceholder => 'ex: œufs';

  @override
  String get findRecipes => 'Trouver des recettes';

  @override
  String get matchingRecipes => 'Recettes correspondantes';

  @override
  String get noMatchingRecipes => 'Aucune recette trouvée.';

  @override
  String matchPercent(int percent) {
    return '$percent% de correspondance';
  }

  @override
  String get biometricPrompt => 'Authentification pour Mealie Recipes';

  @override
  String get biometricFailed => 'Authentification échouée';

  @override
  String get whatsNew => 'Nouveautés';

  @override
  String get pendingRecipesTitle => 'Recettes reçues';

  @override
  String pendingRecipesMessage(String sender, String name) {
    return 'Vous avez reçu une recette de $sender: \"$name\"';
  }

  @override
  String pendingRecipesFrom(Object names) {
    return 'De $names';
  }

  @override
  String get pendingRecipesOpenCooking => 'Ouvrir le mode cuisson';

  @override
  String get pendingRecipesLater => 'Plus tard';

  @override
  String get openRecipe => 'Ouvrir la recette';

  @override
  String get dismiss => 'Fermer';

  @override
  String get editRecipe => 'Modifier la recette';

  @override
  String get recipeName => 'Nom de la recette';

  @override
  String get recipeDescription => 'Description';

  @override
  String get prepTime => 'Temps de préparation (min)';

  @override
  String get cookTime => 'Temps de cuisson (min)';

  @override
  String get totalTime => 'Temps total (min)';

  @override
  String get recipeServings => 'Portions';

  @override
  String get rating => 'Note';

  @override
  String get addIngredientLine => 'Ajouter un ingrédient';

  @override
  String get addInstruction => 'Ajouter une étape';

  @override
  String get removeIngredient => 'Supprimer l\'ingrédient';

  @override
  String get removeInstruction => 'Supprimer l\'étape';

  @override
  String get ingredientName => 'Ingrédient';

  @override
  String get ingredientQuantity => 'Quantité';

  @override
  String get ingredientUnit => 'Unité';

  @override
  String get ingredientNote => 'Note';

  @override
  String get instructionText => 'Texte de l\'étape';

  @override
  String get categories => 'Catégories';

  @override
  String get selectCategories => 'Sélectionner des catégories';

  @override
  String get selectTags => 'Sélectionner des mots-clés';

  @override
  String get uploadImage => 'Télécharger une image';

  @override
  String get removeImage => 'Supprimer l\'image';

  @override
  String get saveChanges => 'Enregistrer les modifications';

  @override
  String get saving => 'Enregistrement...';

  @override
  String get saveSuccess => 'Recette enregistrée.';

  @override
  String saveError(String error) {
    return 'Impossible d\'enregistrer: $error';
  }

  @override
  String get newCategory => 'Nouvelle catégorie';

  @override
  String get newTag => 'Nouveau mot-clé';

  @override
  String get setRating => 'Définir la note';

  @override
  String get removeRating => 'Supprimer la note';

  @override
  String get ratingRemoved => 'Note supprimée';

  @override
  String get googleTasksImport => 'Importer depuis Google Tasks';

  @override
  String get googleTasksImportDescription =>
      'Importer des éléments de Google Tasks dans la liste de courses.';

  @override
  String get homeWelcome => 'Bienvenue sur Mealie Recipes ! 👋';

  @override
  String homeWelcomeNamed(String name) {
    return 'Bienvenue $name, sur Mealie Recipes ! 👋';
  }

  @override
  String get shopping => 'Courses';

  @override
  String get planning => 'Planification';

  @override
  String get other => 'Autre';

  @override
  String get viewRecipes => '📖 Voir recettes';

  @override
  String get addRecipe => '➕ Ajouter recette';

  @override
  String get completeShopping => 'Terminer les Courses';

  @override
  String get shoppingCompleted => 'Courses Terminées';

  @override
  String get shoppingCompletedSubtitle => 'Tout dans le panier ! 🎉';

  @override
  String get essensplan => '📅 Plan repas';

  @override
  String get resteverwertung => '🥗 Recherche de recette';

  @override
  String get newRecipeUpload => 'Télécharger une Recette';

  @override
  String get copyCode => 'Copier le Code';

  @override
  String get shareLink => 'Partager le Lien';

  @override
  String get connectedFriends => 'Amis Connectés';

  @override
  String get waitingForFriends => 'En attente d\'amis...';

  @override
  String get endSharing => 'Arrêter le Partage';

  @override
  String get cookFriendsDescription =>
      'Invitez un ami à cuisiner cette recette ensemble';

  @override
  String get sessionCode => 'CODE DE SESSION';

  @override
  String get adjustQuantityLabel => 'Ajuster la quantité pour cette recette :';

  @override
  String get timerStartForStep => 'Minuterie pour l\'étape';

  @override
  String get enterRecipeUrl => 'Saisir l\'URL de la recette';

  @override
  String get loading => 'Chargement...';

  @override
  String get urlInvalidScheme =>
      'L\'URL doit commencer par http:// ou https://';

  @override
  String get urlAddScheme => 'Ajouter https://';

  @override
  String get addItemPlaceholder => 'Ajouter un article...';

  @override
  String get addSuccessToast => 'Ajouté !';

  @override
  String get completedItems => 'Terminé';

  @override
  String get completeShoppingTitle => 'Terminer les courses ?';

  @override
  String get completeShoppingMessage => 'Supprimer les articles terminés ?';

  @override
  String get recipeListTitle => '📖 Recettes';

  @override
  String get importRecipeTitle => 'Nouvelle recette';

  @override
  String get uploadRecipeUrl => 'Import par URL';

  @override
  String get uploadRecipeUrlHint =>
      'Entrez l\'URL pour la sauvegarder sur votre serveur';

  @override
  String get uploadOpenAI => 'Import fichier via OpenAI';

  @override
  String get uploadOpenAIHint =>
      'Vous pouvez également téléverser des photos ou un PDF d\'une recette. Si la recette s\'étend sur plusieurs pages, ajoutez-en plusieurs : elles sont analysées ensemble par l\'IA.';

  @override
  String get takePhoto => 'Appareil photo';

  @override
  String get cameraPermissionDenied =>
      'Pas d’accès à l’appareil photo. Autorise-le dans les réglages du système pour photographier des recettes.';

  @override
  String get cameraUnavailable =>
      'Aucun appareil photo disponible sur cet appareil.';

  @override
  String get selectPhoto => 'Photos';

  @override
  String get selectPdf => 'PDF';

  @override
  String get openAIHintTitle => 'Info analyse';

  @override
  String get openAIHintBody =>
      'L\'analyse utilise l\'API OpenAI. Assurez-vous que votre clé API est configurée dans Mealie.';

  @override
  String get allDeleteConfirm => 'Tout supprimer';

  @override
  String get portionen => 'Portions';

  @override
  String get timerForStep => 'Démarrer minuteur';

  @override
  String get weekNavPrev => 'Semaine précédente';

  @override
  String get weekNavNext => 'Semaine suivante';

  @override
  String get noMealsThisWeek => 'Aucun repas planifié';

  @override
  String get entriesInOtherWeeks =>
      'Il y a des entrées dans d\'autres semaines';

  @override
  String get availableWeeks => 'Semaines disponibles:';

  @override
  String weekRange(Object end, Object start, Object week) {
    return 'Semaine $week ($start – $end)';
  }

  @override
  String get currentWeek => 'Semaine actuelle';

  @override
  String get rezepteAktualisieren => 'Mettre à jour recettes';

  @override
  String get leftoverWhatTitle => 'Que fait cette fonction?';

  @override
  String get leftoverWhatBody =>
      'Cette fonction recharge toutes les recettes du serveur.';

  @override
  String get leftoverDescription =>
      'Entrez les ingrédients disponibles pour trouver des recettes adaptées.';

  @override
  String get leftoverIngredientsHeader => 'Ingrédients à la maison';

  @override
  String get leftoverSuggestions => 'Suggestions de recettes';

  @override
  String get leftoverNoMatches => 'Aucune recette trouvée.';

  @override
  String get leftoverEnterIngredient => 'Saisir un ingrédient';

  @override
  String matchingPercentText(int percent, int count, int total) {
    return '$percent% correspond ($count/$total)';
  }

  @override
  String get weekAbbreviation => 'Sem.';

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get selectDate => 'Choisir une date';

  @override
  String get selectSlot => 'Choisir un repas';

  @override
  String get selectedRecipe => 'Recette sélectionnée';

  @override
  String get confirmMeal => 'Planifier le repas';

  @override
  String get searchRecipes => 'Rechercher des recettes';

  @override
  String get addCustomMeal => 'Ajouter un repas personnalisé';

  @override
  String get diceModeButton => 'Tirer des recettes au hasard';

  @override
  String get diceModeTitle => '3 suggestions aléatoires';

  @override
  String get diceBackToSearch => 'Retour à la recherche';

  @override
  String get diceNotEnoughRecipes =>
      'Pas assez de recettes pour le mode aléatoire (3 minimum)';

  @override
  String get entrySingular => 'entrée';

  @override
  String get entriesPlural => 'entrées';

  @override
  String listTitle(int n) {
    return 'Liste $n';
  }

  @override
  String get deleteAllConfirmTitle => 'Tout supprimer ?';

  @override
  String get deleteAllConfirmMessage =>
      'Voulez-vous supprimer toutes les courses archivées ?';

  @override
  String get uploadFromUrlButton => 'Importer la recette depuis l\'URL';

  @override
  String get uploadingImage => 'Téléchargement...';

  @override
  String get uploadErrorTitle => 'Échec du téléchargement';

  @override
  String get uploadSuccessTitle => 'Téléchargement réussi';

  @override
  String get editImportedRecipeQuestion =>
      'Voulez-vous modifier la nouvelle recette maintenant ?';

  @override
  String get notNow => 'Pas maintenant';

  @override
  String get pdfTooLarge => 'Le fichier PDF est trop volumineux (max 10 Mo).';

  @override
  String get invalidUrl =>
      'URL invalide. Veuillez saisir une URL HTTP(S) valide.';

  @override
  String get cookWithFriends => 'Cuisiner entre amis';

  @override
  String get cookFriendsSubtitle =>
      'Invitez un ami à cuisiner cette recette ensemble';

  @override
  String get copied => 'Copié';

  @override
  String get linkCopied => 'Lien copié';

  @override
  String get startCooking => 'Commencer à cuisiner';

  @override
  String get hostNoRecipe => 'Ouvrez une recette pour héberger une session';

  @override
  String get uploadToOwnServer => 'Enregistrer sur mon serveur';

  @override
  String get uploadingRecipe => 'Téléversement de la recette…';

  @override
  String get recipeUploadedToOwnServer =>
      'Recette enregistrée sur votre serveur';

  @override
  String get recipeUploadFailed => 'Échec du téléversement';

  @override
  String get allowGuestSaveRecipes =>
      'Autoriser les invités à enregistrer les recettes sur leur serveur';

  @override
  String get appIcon => 'Icône de l\'app';

  @override
  String get appIconClassic => 'Classique';

  @override
  String get appIconModern => 'Moderne';

  @override
  String get name => 'Nom';

  @override
  String get color => 'Couleur';

  @override
  String get randomColor => 'Couleur aléatoire';

  @override
  String get createFailed => 'Création impossible';

  @override
  String get deleteFailed => 'Suppression impossible';

  @override
  String deleteOrganizerConfirm(String name) {
    return 'Supprimer « $name » ? Également supprimé du serveur.';
  }

  @override
  String get connectionSection => 'Connexion';

  @override
  String get token => 'Jeton';

  @override
  String get advancedOptions => 'Options avancées';

  @override
  String get mealieApiVersion => 'Version de l\'API Mealie';

  @override
  String get sendOptionalHeaders => 'Envoyer des en-têtes optionnels';

  @override
  String get offlineRecipeImages =>
      'Enregistrer les images des recettes hors ligne';

  @override
  String get offlineRecipeImagesHint =>
      'Télécharge toutes les images des recettes sur cet appareil pour qu\'elles s\'affichent aussi sans connexion. Avec de grandes collections, cela peut occuper plusieurs centaines de Mo. La désactivation supprime les images enregistrées.';

  @override
  String offlineRecipeImagesStatus(int count, int total, String size) {
    return 'Enregistrées : $count/$total · $size';
  }

  @override
  String get offlineRecipeImagesDisableConfirm =>
      'Supprimer toutes les images de recettes enregistrées ?';

  @override
  String headerNameLabel(int n) {
    return 'Nom d\'en-tête $n';
  }

  @override
  String headerValueLabel(int n) {
    return 'Valeur d\'en-tête $n';
  }

  @override
  String get value => 'Valeur';

  @override
  String get personalization => 'Personnalisation';

  @override
  String get showRecipeImagesSubtitle =>
      'Affiche les images dans la liste des recettes';

  @override
  String get exactQuantities => 'Ajouter les quantités exactes';

  @override
  String get exactQuantitiesSubtitle =>
      'Les ingrédients et articles saisis gardent quantité et unité (p. ex. 200 g de beurre) au lieu de 1x par article ; les aliments manquants sont créés sur le serveur';

  @override
  String get remindToShop => 'Me rappeler de faire les courses';

  @override
  String get remindToShopSubtitle =>
      'Vous avertit lorsque vous êtes près d\'un lieu enregistré et que votre liste de courses contient des articles à acheter — même si l\'application est fermée';

  @override
  String get shoppingReminderAddLocation => 'Ajouter un lieu';

  @override
  String get shoppingReminderMaxLocations => 'Maximum de 3 lieux atteint';

  @override
  String get shoppingReminderLocationServiceDisabled =>
      'Le service de localisation est désactivé sur cet appareil';

  @override
  String get shoppingReminderPermissionTitle => 'Accès à la position requis';

  @override
  String get shoppingReminderPermissionMessage =>
      'Pour vous avertir près d\'un magasin, l\'accès à la position « Toujours » est nécessaire — même application fermée. Veuillez l\'activer dans les réglages.';

  @override
  String get openSettings => 'Ouvrir les réglages';

  @override
  String get shoppingReminderLocationName => 'Nom';

  @override
  String get shoppingReminderUseCurrentLocation =>
      'Utiliser la position actuelle';

  @override
  String get shoppingReminderOrAddress => 'ou saisir une adresse';

  @override
  String get shoppingReminderAddress => 'Adresse';

  @override
  String get shoppingReminderAddressPlaceholder => 'Rue, ville';

  @override
  String get shoppingReminderSearchAddress => 'Rechercher';

  @override
  String get shoppingReminderLocationFailed =>
      'Impossible de déterminer votre position';

  @override
  String get shoppingReminderAddressNotFound => 'Adresse introuvable';

  @override
  String get ratingFailed => 'La note n\'a pas pu être enregistrée — réessaie.';

  @override
  String get lastCooked => 'Dernière cuisson';

  @override
  String get syncLastCooked => 'Mettre à jour « dernière cuisson »';

  @override
  String get syncLastCookedSubtitle =>
      'Enregistre la date du jour et une entrée dans l\'historique — comme dans la webapp Mealie.';

  @override
  String get developer => 'Développeur';

  @override
  String get enableLoggingSubtitle =>
      'Enregistre les logs print/erreurs (500 dernières lignes)';

  @override
  String get entriesLabel => 'Entrées';

  @override
  String get fileSize => 'Taille du fichier';

  @override
  String get showAction => 'Afficher';

  @override
  String get copy => 'Copier';

  @override
  String logsWithCount(int count) {
    return 'Logs ($count)';
  }

  @override
  String get noLogs => 'Aucun log disponible';

  @override
  String get logsTitle => 'Logs';

  @override
  String get required => 'Requis';

  @override
  String get connectionFailedCheck =>
      'Échec de la connexion. Vérifiez l\'URL et le jeton.';

  @override
  String get username => 'Nom d\'utilisateur';

  @override
  String get password => 'Mot de passe';

  @override
  String get setupPasswordHint =>
      'Ton mot de passe n\'est pas enregistré — l\'app te connecte une seule fois et en génère un jeton API (comme dans Profil → Jetons API sur la webapp).';

  @override
  String get loginAndConnect => 'Se connecter';

  @override
  String get loginInvalidCredentials =>
      'Nom d\'utilisateur ou mot de passe incorrect.';

  @override
  String get loginAndGenerateToken => 'Se connecter et générer un jeton';

  @override
  String get loggingIn => 'Connexion en cours…';

  @override
  String get apiTokenSaveHint =>
      'Jeton appliqué — appuie sur « Enregistrer les modifications » ci-dessous.';

  @override
  String get renewApiToken => 'Renouveler le jeton API';

  @override
  String get setupAuthChoiceTitle => 'Comment veux-tu te connecter ?';

  @override
  String get authModePasswordTitle =>
      'Laisser l\'app créer une clé API pour moi';

  @override
  String get authModePasswordSubtitle =>
      'Se connecter avec nom d\'utilisateur & mot de passe — l\'app génère un jeton automatiquement.';

  @override
  String get authModeTokenTitle => 'J\'ai déjà une clé API';

  @override
  String get authModeTokenSubtitle =>
      'Copiée depuis le profil Mealie (Profil → Jetons API).';

  @override
  String keyN(int n) {
    return 'Clé $n';
  }

  @override
  String valueN(int n) {
    return 'Valeur $n';
  }

  @override
  String get openCookingMode => 'Ouvrir le mode cuisine';

  @override
  String activeRecipes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count recettes actives',
      one: '1 recette active',
    );
    return '$_temp0';
  }

  @override
  String get reparseIngredients => 'Réanalyser les ingrédients';

  @override
  String get reparseIngredientsSubtitle =>
      'Séparer quantité/unité/ingrédient (ex. « 200 g farine »)';

  @override
  String get reparseDone => 'Ingrédients séparés – appuyez sur « Enregistrer »';

  @override
  String get reparseNone => 'Aucun ingrédient séparable trouvé';

  @override
  String get tagsAndCategories => 'Tags, catégories et ustensiles';

  @override
  String get tapToAddPhoto => 'Toucher pour ajouter une photo';

  @override
  String get descriptionLabel => 'Description';

  @override
  String get searchingDevices => 'Recherche d\'appareils sur le même Wi-Fi…';

  @override
  String get selectAll => 'Tout sélectionner';

  @override
  String get importReminders => 'Importer les rappels';

  @override
  String get importGoogleTasks => 'Importer Google Tasks';

  @override
  String get noTaskLists => 'Aucune liste de tâches trouvée';

  @override
  String get noReminderLists => 'Aucune liste de rappels trouvée';

  @override
  String importCount(int count) {
    return 'Importer $count';
  }

  @override
  String get activeRecipeTimer => 'Minuteur de recette actif';

  @override
  String get linkIngredients => 'Lier les ingrédients';

  @override
  String get noIngredientsToLink => 'Aucun ingrédient à lier pour l’instant';

  @override
  String get importLanguageSubtitle =>
      'Langue des recettes importées depuis une photo ou un PDF';

  @override
  String get importLanguageSearch => 'Rechercher une langue';

  @override
  String get importLanguageFollowApp => 'Comme la langue de l’app';

  @override
  String get importLanguageNoMatch => 'Aucune langue trouvée';

  @override
  String get setupImportLanguageTitle => 'Import de recettes par IA';

  @override
  String get setupImportLanguageBody =>
      'Les photos et les PDF peuvent être transformés en recettes par l’IA. Choisis la langue dans laquelle elles doivent arriver — pratique si ta langue maternelle n’est pas disponible comme langue de l’app. Tu peux modifier ce choix plus tard dans les réglages.';

  @override
  String get setupImportLanguageSearchHint =>
      'Utilise la recherche dans la liste pour trouver des langues que l’interface de l’app ne propose pas.';

  @override
  String get setupCachingKeepOpenTitle => 'Garde l’app ouverte';

  @override
  String get setupCachingKeepOpenBody =>
      'Le chargement s’exécute au premier plan. Laisse l’app ouverte jusqu’à la fin — si tu la fermes ou changes d’app trop longtemps, le processus s’interrompt et recommencera plus tard.';

  @override
  String get supportContact => 'Contacter l’assistance';

  @override
  String get supportDialogMessage =>
      'Décris ton problème, nous te répondrons. Le journal aide beaucoup au diagnostic — tu peux le joindre sous forme de fichier texte.';

  @override
  String get supportWithoutLogs => 'Sans journal';

  @override
  String get supportWithLogs => 'Joindre le journal';

  @override
  String get supportMailSubject => 'Mealie Recipes — Assistance';

  @override
  String get supportMailHint => 'Décris ton problème ici :';

  @override
  String get supportLogsEmpty =>
      'Le journal est vide. Active la journalisation, reproduis le problème puis envoie-le.';

  @override
  String supportAddressCopied(String email) {
    return 'Adresse copiée : $email';
  }

  @override
  String supportNoMailApp(String email) {
    return 'Aucune application de messagerie trouvée. Adresse copiée : $email';
  }

  @override
  String get createRecipeFromImages => 'Créer la recette';

  @override
  String imagePagesSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pages sélectionnées',
      one: '1 page sélectionnée',
    );
    return '$_temp0';
  }

  @override
  String get imagePagesHint =>
      'La première image devient l\'image principale de la recette. Maintenez une page appuyée pour la réorganiser.';

  @override
  String get mainImageBadge => 'Principale';

  @override
  String maxImagesReached(int max) {
    return 'Maximum $max images par recette.';
  }

  @override
  String get removePage => 'Retirer la page';

  @override
  String get preparingPdf => 'Traitement du PDF...';

  @override
  String get shareRecipeTitle => 'Partager la recette';

  @override
  String get recipeOptionsTitle => 'Options';

  @override
  String get exportAsPdf => 'Exporter en PDF';

  @override
  String get generatingPdf => 'Génération du PDF…';

  @override
  String get pdfExportFailed => 'Échec de l\'export PDF';

  @override
  String get recipeTime => 'Temps';

  @override
  String get ingredientSectionTitle => 'Section';

  @override
  String get addIngredientSection => 'Ajouter une section';

  @override
  String get aiImportToggle => 'Analyser avec l\'IA';

  @override
  String get aiImportToggleHint =>
      'Aussi pour les vidéos de recettes (YouTube, Instagram, TikTok …) et les pages que l\'import normal ne sait pas lire. Nécessite un fournisseur d\'IA sur votre serveur Mealie – pour les vidéos, aussi un fournisseur audio.';

  @override
  String get aiImportButton => 'Importer avec l\'IA';

  @override
  String get aiImportRunning =>
      'L\'IA analyse le lien … pour une vidéo, cela peut prendre quelques minutes.';

  @override
  String get aiImportFailed =>
      'L\'import par IA a échoué. Vérifiez les paramètres d\'IA de votre serveur Mealie.';

  @override
  String get stepHeadingLabel => 'Titre de l\'étape (facultatif)';

  @override
  String get linkedRecipeLabel => 'Recette liée';

  @override
  String get toolsTitle => 'Ustensiles';

  @override
  String get prepareTools => 'Préparez les ustensiles suivants';

  @override
  String get newTool => 'Nouvel ustensile';

  @override
  String get renameAction => 'Renommer';

  @override
  String get organizerEmpty =>
      'Aucune entrée pour l\'instant. Touchez « + » en haut à droite pour en créer une.';

  @override
  String organizerRecipeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count recettes',
      one: '1 recette',
      zero: 'Aucune recette',
    );
    return '$_temp0';
  }

  @override
  String get toolOnHand => 'Disponible';

  @override
  String get mealDiceSettingsTitle => 'Filtre du dé';

  @override
  String get mealDiceSettingsHint =>
      'Choisissez des catégories et des tags pour chaque repas. Le dé ne propose alors que des recettes qui en ont au moins un. Une même sélection peut servir pour plusieurs repas.';

  @override
  String get mealDiceSettingsNoneHint =>
      'Rien n\'est sélectionné pour ce repas : le dé choisit automatiquement selon des catégories comme « Petit-déjeuner », « Déjeuner » ou « Dîner ».';

  @override
  String get mealDiceAutoHintTitle => 'Sélection automatique';

  @override
  String get mealDiceAutoHintBody =>
      'Aucune catégorie ni aucun tag n\'est encore défini pour ce repas. Le dé cherche donc des catégories comme « Petit-déjeuner », « Déjeuner » ou « Dîner » et complète avec d\'autres recettes.\n\nPour choisir vous-même : dans le planning des repas, touchez la roue dentée à côté de « + ».';

  @override
  String get dontShowAgain => 'Ne plus afficher';

  @override
  String get mealDiceNoMatches =>
      'Aucune recette ne correspond aux catégories et tags choisis pour ce repas.';

  @override
  String mealDiceFewMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Seulement $count recettes correspondent',
      one: 'Une seule recette correspond',
    );
    return '$_temp0';
  }

  @override
  String get commentsTitle => 'Commentaires';

  @override
  String get commentHint => 'Écrire un commentaire…';

  @override
  String get commentSaveFailed => 'Le commentaire n\'a pas pu être enregistré.';

  @override
  String get commentDeleteConfirm => 'Supprimer ce commentaire ?';

  @override
  String get cookingDoneCommentLabel => 'Commentaire (facultatif)';

  @override
  String get cookingDoneCommentHint =>
      'Comment était-ce ? Astuces pour la prochaine fois…';

  @override
  String get nutritionTitle => 'Valeurs nutritionnelles';

  @override
  String get nutritionPerServing => 'par portion';

  @override
  String get nutritionCalories => 'Calories';

  @override
  String get nutritionFat => 'Lipides';

  @override
  String get nutritionSaturatedFat => 'Acides gras saturés';

  @override
  String get nutritionTransFat => 'Acides gras trans';

  @override
  String get nutritionUnsaturatedFat => 'Acides gras insaturés';

  @override
  String get nutritionCholesterol => 'Cholestérol';

  @override
  String get nutritionSodium => 'Sodium';

  @override
  String get nutritionCarbohydrates => 'Glucides';

  @override
  String get nutritionFiber => 'Fibres';

  @override
  String get nutritionSugar => 'Sucres';

  @override
  String get nutritionProtein => 'Protéines';

  @override
  String get timelineTitle => 'Historique';

  @override
  String get timelineMadeThis => 'Je l\'ai cuisiné';

  @override
  String timelineUserMadeThis(String name) {
    return '$name l\'a cuisiné';
  }

  @override
  String get timelineEmpty =>
      'Aucune entrée dans l\'historique pour le moment.';

  @override
  String get timelineDate => 'Date';

  @override
  String get timelineNoteHint => 'Note (facultatif)';

  @override
  String get timelineAddPhoto => 'Ajouter une photo';

  @override
  String get timelineRemovePhoto => 'Retirer la photo';

  @override
  String get timelineSaved => 'Ajouté à l\'historique';

  @override
  String get timelineSaveFailed => 'Impossible d\'ajouter à l\'historique';

  @override
  String get timelineImageFailed =>
      'Entrée enregistrée, mais la photo n\'a pas pu être envoyée';

  @override
  String get timelineDeleteConfirm =>
      'Supprimer cette entrée de l\'historique ?';

  @override
  String get timelineEditNote => 'Modifier la note';

  @override
  String get timelineUnknownRecipe => 'Recette introuvable';

  @override
  String get cookingDonePhotoHint =>
      'Photo pour l\'historique Mealie (facultatif)';

  @override
  String get assetsTitle => 'Pièces jointes';

  @override
  String get assetsAdd => 'Ajouter une pièce jointe';

  @override
  String get assetsChooseFile => 'Fichier';

  @override
  String get assetsUploading => 'Envoi en cours…';

  @override
  String get assetsUploadFailed => 'La pièce jointe n\'a pas pu être envoyée';

  @override
  String assetsDeleteConfirm(String name) {
    return 'Retirer « $name » des pièces jointes ?';
  }

  @override
  String get assetsOpenFailed => 'La pièce jointe n\'a pas pu être ouverte';

  @override
  String get assetsUnsupported =>
      'Mealie ne prend en charge que PDF, images, TXT, MD, CSV et JSON.';

  @override
  String get assetsShare => 'Partager';

  @override
  String get mealRulesTitle => 'Règles Mealie';

  @override
  String get mealRulesHint =>
      'Également utilisées par l\'application web Mealie. Si plusieurs règles s\'appliquent au jour et au repas, toutes doivent être respectées. Si aucune règle ne s\'applique, le dé choisit parmi toutes les recettes.';

  @override
  String get mealRuleAdd => 'Ajouter une règle';

  @override
  String get mealRuleNewTitle => 'Nouvelle règle';

  @override
  String get mealRuleEditTitle => 'Modifier la règle';

  @override
  String get mealRuleDay => 'Jour';

  @override
  String get mealRuleAnyDay => 'Tous les jours';

  @override
  String get mealRuleMealType => 'Repas';

  @override
  String get mealRuleAnyMeal => 'Tous les repas';

  @override
  String get mealRuleConditionsTitle => 'Conditions';

  @override
  String get mealRuleAllRecipes => 'Toutes les recettes';

  @override
  String get mealRuleDeleteConfirm => 'Supprimer cette règle ?';

  @override
  String get mealRulesOffline =>
      'Les règles Mealie sont indisponibles pour le moment – le dé utilise la sélection de l’app.';

  @override
  String get mealRulesNoMatches =>
      'Aucune recette ne respecte les règles Mealie pour ce repas.';

  @override
  String get mealTypeSide => 'Accompagnement';

  @override
  String get mealTypeSnack => 'Goûter';

  @override
  String get mealTypeDrink => 'Boisson';

  @override
  String get mealTypeDessert => 'Dessert';

  @override
  String get foodsTitle => 'Aliments';

  @override
  String get unitsTitle => 'Unités';

  @override
  String get newFood => 'Nouvel aliment';

  @override
  String get newUnit => 'Nouvelle unité';

  @override
  String get editFood => 'Modifier l\'aliment';

  @override
  String get editUnit => 'Modifier l\'unité';

  @override
  String get pluralNameLabel => 'Nom au pluriel';

  @override
  String get abbreviationLabel => 'Abréviation';

  @override
  String get pluralAbbreviationLabel => 'Abréviation au pluriel';

  @override
  String get mergeAction => 'Fusionner';

  @override
  String mergeIntoTitle(String name) {
    return 'Fusionner « $name » avec…';
  }

  @override
  String mergeConfirm(String from, String to) {
    return '« $from » sera fusionné avec « $to » : toutes les recettes et listes de courses utiliseront ensuite « $to », et « $from » sera supprimé.';
  }

  @override
  String get mergeFailed => 'Échec de la fusion';

  @override
  String foodUnitDeleteConfirm(String name) {
    return 'Supprimer « $name » ? Les ingrédients qui l\'utilisent perdront la référence.';
  }

  @override
  String get foodsUnitsEmpty => 'Aucune entrée pour le moment.';

  @override
  String mealRuleConditionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count conditions',
      one: '1 condition',
    );
    return '$_temp0';
  }

  @override
  String get showAll => 'Tout afficher';

  @override
  String get mealDiceModeTitle => 'Le dé utilise';

  @override
  String get mealDiceModeApp => 'Sélection de l\'app';

  @override
  String get switchListTitle => 'Changer de liste';

  @override
  String get newShoppingList => 'Nouvelle liste de courses';

  @override
  String shoppingListDeleteConfirm(String name) {
    return 'Supprimer « $name » ? Tous ses articles seront également supprimés.';
  }

  @override
  String get labelOrderTitle => 'Trier les étiquettes';

  @override
  String get labelOrderHint =>
      'Faites glisser pour trier. S\'applique à cette liste – aussi dans l\'application web Mealie.';

  @override
  String get labelOrderEmpty => 'Cette liste n\'a pas encore d\'étiquettes.';

  @override
  String get useAsActiveList => 'Utiliser comme liste active';

  @override
  String get activeListBadge => 'Active';

  @override
  String get foodLabelLabel => 'Étiquette';

  @override
  String get foodNoLabel => 'Aucune étiquette';

  @override
  String get aliasesLabel => 'Alias';

  @override
  String get aliasAddHint => 'Ajouter un alias';

  @override
  String get foodOnHand => 'Disponible au foyer';

  @override
  String get timelineChildRecipesTitle => 'Ajouter aussi aux recettes liées';

  @override
  String timelineMadeForRecipe(String recipe) {
    return 'Préparé pour $recipe';
  }

  @override
  String get timelineFilter => 'Filtrer les entrées';

  @override
  String get timelineTypeComment => 'Cuisiné & notes';

  @override
  String get timelineTypeInfo => 'Infos';

  @override
  String get timelineTypeSystem => 'Système';

  @override
  String get listManagementTitle => 'Listes de courses';

  @override
  String get managementTitle => 'Plus';

  @override
  String get pinToHome => 'Ajouter à l\'écran d\'accueil';

  @override
  String get unpinFromHome => 'Retirer de l\'écran d\'accueil';

  @override
  String homeScreenFull(int count) {
    return 'L\'écran d\'accueil est plein – $count tuiles au maximum. Retirez d\'abord une autre tuile dans « Plus ».';
  }

  @override
  String get selectAction => 'Sélectionner';

  @override
  String selectedCount(int count) {
    return '$count sélectionné(s)';
  }

  @override
  String get assignLabelAction => 'Affecter une étiquette';

  @override
  String get assignLabelOverwriteHint =>
      'Remplace l\'étiquette de tous les aliments sélectionnés.';

  @override
  String deleteSelectedConfirm(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Supprimer $count entrées ?',
      one: 'Supprimer 1 entrée ?',
    );
    return '$_temp0';
  }

  @override
  String get seedDataAction => 'Charger les données par défaut';

  @override
  String get seedFoodsHint =>
      'Crée les aliments par défaut de Mealie dans la langue choisie.';

  @override
  String get seedUnitsHint =>
      'Crée les unités par défaut de Mealie dans la langue choisie.';

  @override
  String get seedLanguageLabel => 'Langue';

  @override
  String get seedDuplicateWarning =>
      'Vous avez déjà des entrées. Mealie ne gère pas les doublons – vous devrez les fusionner vous-même ensuite.';

  @override
  String get seedDone => 'Données par défaut créées';

  @override
  String get seedFailed => 'Impossible de charger les données par défaut';

  @override
  String get exportAction => 'Exporter';

  @override
  String get substitutionsLabel => 'Substitutions';

  @override
  String get substitutionAddHint => 'Ajouter une substitution';

  @override
  String get substitutionFoodLabel => 'Aliment (facultatif)';

  @override
  String get substitutionNoteLabel => 'Note (facultatif)';

  @override
  String get substitutionNeedOne => 'Indiquez un aliment ou une note';

  @override
  String get useAbbreviationLabel => 'Utiliser l\'abréviation';

  @override
  String get useAbbreviationHint =>
      'Afficher « g » au lieu de « gramme » dans les recettes';

  @override
  String get fractionLabel => 'Afficher en fraction';

  @override
  String get fractionHint => '½ au lieu de 0,5';

  @override
  String get standardizationTitle => 'Standardisation';

  @override
  String get standardizationHint =>
      'Pour les conversions : 1 de cette unité vaut … (p. ex. 1 c. à s. = 15 millilitres).';

  @override
  String get standardQuantityLabel => 'Quantité standard';

  @override
  String get standardUnitLabel => 'Unité standard';

  @override
  String get standardUnitNone => 'Aucune';

  @override
  String get stdFluidOunce => 'Once liquide (fl oz)';

  @override
  String get stdCup => 'Tasse (US)';

  @override
  String get stdOunce => 'Once (oz)';

  @override
  String get stdPound => 'Livre (lb)';

  @override
  String get stdMilliliter => 'Millilitre';

  @override
  String get stdLiter => 'Litre';

  @override
  String get stdGram => 'Gramme';

  @override
  String get stdKilogram => 'Kilogramme';

  @override
  String get labelsTitle => 'Étiquettes';

  @override
  String get newLabel => 'Nouvelle étiquette';

  @override
  String get editLabel => 'Modifier l\'étiquette';

  @override
  String get colorLabel => 'Couleur';

  @override
  String labelDeleteConfirm(String name) {
    return 'Supprimer « $name » ? Les articles et aliments perdront cette étiquette.';
  }

  @override
  String get importMenuAction => 'Importer';

  @override
  String get archivedEmpty =>
      'Aucune course archivée pour le moment. Touchez « Terminer les Courses » après vos achats – les articles cochés seront rangés ici.';

  @override
  String get sectionTitleLabel => 'Titre de la section';

  @override
  String get clearSection => 'Effacer la section';

  @override
  String get noPermissionGeneric =>
      'Vous n\'avez pas l\'autorisation pour cela dans Mealie. Demandez à un administrateur ou au gestionnaire du foyer.';

  @override
  String get noPermissionEditRecipe =>
      'Vous ne pouvez pas modifier cette recette – elle est verrouillée ou appartient à un autre foyer. Seul son créateur ou un administrateur le peut.';

  @override
  String get noPermissionDeleteRecipe =>
      'Seul le créateur de la recette ou un administrateur peut la supprimer.';

  @override
  String get noPermissionDemoteSelf =>
      'Vous ne pouvez pas retirer vos propres droits d\'administrateur.';

  @override
  String get recipeLockedHint =>
      'Verrouillée – seul son créateur peut la modifier';

  @override
  String get recipeDeleteOwnerOnlyHint =>
      'Seul son créateur ou un administrateur peut la supprimer';

  @override
  String get organizeReadOnlyHint =>
      'Lecture seule : créer, modifier et supprimer nécessite l\'autorisation « L\'utilisateur peut gérer les aliments, les mots-clés et les catégories ».';

  @override
  String get notesNotSavedNoPermission =>
      'Note non enregistrée – vous n\'avez pas l\'autorisation de modifier cette recette.';

  @override
  String get userManagementTitle => 'Gestion des utilisateurs';

  @override
  String get usersTitle => 'Utilisateurs';

  @override
  String get editUserTitle => 'Modifier l’utilisateur';

  @override
  String get fullNameLabel => 'Nom';

  @override
  String get usernameLabel => 'Nom d’utilisateur';

  @override
  String get emailLabel => 'E-mail';

  @override
  String get passwordLabel => 'Mot de passe';

  @override
  String get householdLabel => 'Foyer';

  @override
  String get permissionsTitle => 'Autorisations';

  @override
  String get administratorLabel => 'Administrateur';

  @override
  String get permCanInvite =>
      'L’utilisateur peut inviter d’autres personnes dans le groupe';

  @override
  String get permCanManage =>
      'L\'utilisateur peut gérer les paramètres de groupe';

  @override
  String get permCanManageHousehold => 'L’utilisateur peut gérer le foyer';

  @override
  String get permCanOrganize =>
      'L\'utilisateur peut gérer les aliments, les mots-clés et les catégories';

  @override
  String get advancedFeaturesLabel => 'Activer les fonctions avancées';

  @override
  String get passwordResetLinkAction =>
      'Générer un lien de réinitialisation de mot de passe';

  @override
  String get resetLockedUsersAction =>
      'Réinitialiser les utilisateurs verrouillés';

  @override
  String get membersTitle => 'Membres';

  @override
  String get inviteLinkTitle => 'Lien d\'invitation';

  @override
  String get inviteAction => 'Inviter';

  @override
  String get userUpdated => 'Utilisateur mis à jour';

  @override
  String get createUserTitle => 'Créer un utilisateur';

  @override
  String get userCreated => 'Utilisateur créé';

  @override
  String userDeleteConfirm(String name) {
    return 'Supprimer « $name » ? Le compte sera retiré de Mealie.';
  }

  @override
  String get passwordResetLinkCopied =>
      'Lien copié – transmettez-le à l\'utilisateur. Il n\'est valable que pour une durée limitée.';

  @override
  String lockedUsersReset(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count utilisateurs déverrouillés',
      one: '1 utilisateur déverrouillé',
      zero: 'Aucun utilisateur verrouillé',
    );
    return '$_temp0';
  }

  @override
  String get inviteUsesLabel => 'Nombre d\'utilisations';

  @override
  String get inviteCreated => 'Lien d\'invitation créé';

  @override
  String get inviteEmailHint =>
      'Adresse e-mail (facultatif – Mealie enverra l\'invitation)';

  @override
  String get inviteEmailSent => 'Invitation envoyée par e-mail';

  @override
  String get inviteEmailFailed =>
      'L\'e-mail n\'a pas pu être envoyé (SMTP est-il configuré dans Mealie ?). Le lien fonctionne quand même.';

  @override
  String get copyLinkAction => 'Copier le lien';

  @override
  String get youLabel => 'Vous';

  @override
  String get membersPermissionsHint =>
      'Vous pouvez modifier les autorisations des membres de votre foyer – mais pas les vôtres.';

  @override
  String get householdManagementTitle => 'Gestion du foyer';

  @override
  String get householdsTitle => 'Foyers';

  @override
  String get createHouseholdTitle => 'Créer un foyer';

  @override
  String get householdNameLabel => 'Nom du foyer';

  @override
  String get householdPreferencesTitle => 'Préférences du foyer';

  @override
  String get privateHouseholdLabel => 'Foyer privé';

  @override
  String get privateHouseholdHint =>
      'Rendre votre foyer privé va désactiver toutes les options de vue publique. Cela écrase les paramètres de vue publique';

  @override
  String get lockRecipeEditsLabel =>
      'Verrouiller les éditions de recettes de la part des autres foyers';

  @override
  String get lockRecipeEditsHint =>
      'Si activé, seuls les utilisateurs de votre foyer peuvent modifier les recettes créées par votre foyer';

  @override
  String get householdRecipePreferencesTitle =>
      'Préférences de recette du foyer';

  @override
  String get groupsTitle => 'Groupes';

  @override
  String get groupLabel => 'Groupe';

  @override
  String get createGroupTitle => 'Créer un groupe';

  @override
  String get groupNameLabel => 'Nom du groupe';

  @override
  String get groupPreferencesTitle => 'Préférences du groupe';

  @override
  String get privateGroupLabel => 'Groupe privé';

  @override
  String get privateGroupHint =>
      'Rendre votre groupe privé va désactiver toutes les options de vue publique. Cela écrase les paramètres de vue publique';

  @override
  String get firstDayOfWeekLabel => 'Premier jour de la semaine';

  @override
  String get showAnnouncementsLabel => 'Afficher les annonces de Mealie';

  @override
  String get recipePublicDefaultLabel =>
      'Autoriser les utilisateurs en dehors de votre groupe à voir vos recettes';

  @override
  String get recipeShowNutritionDefaultLabel =>
      'Afficher les informations nutritionnelles';

  @override
  String get recipeShowAssetsDefaultLabel =>
      'Afficher les ressources des recettes';

  @override
  String get recipeLandscapeDefaultLabel => 'Vue paysage par défaut';

  @override
  String get recipeDisableCommentsDefaultLabel =>
      'Désactiver les commentaires utilisateur sur les recettes';

  @override
  String get myHouseholdSection => 'Mon foyer';

  @override
  String get myGroupSection => 'Mon groupe';

  @override
  String get preferencesSaved => 'Paramètres enregistrés';

  @override
  String get cannotDeleteWithUsers =>
      'Contient encore des utilisateurs – déplacez-les ou supprimez-les d\'abord dans la gestion des utilisateurs.';

  @override
  String deleteHouseholdConfirm(String name) {
    return 'Supprimer le foyer « $name » ?';
  }

  @override
  String deleteGroupConfirm(String name) {
    return 'Supprimer le groupe « $name » ?';
  }

  @override
  String usersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count utilisateurs',
      one: '1 utilisateur',
      zero: 'Aucun utilisateur',
    );
    return '$_temp0';
  }

  @override
  String get originalUrlLabel => 'Recette originale';

  @override
  String get copyTextAction => 'Copier le texte';

  @override
  String get copiedToClipboard => 'Copié dans le presse-papiers';

  @override
  String get changelogEnglishHint =>
      'Les nouveautés ne sont disponibles qu’en anglais – avec « Copier le texte », vous pouvez les coller dans un traducteur.';

  @override
  String get favoritesTitle => 'Favoris';

  @override
  String get favoritesEmpty =>
      'Pas encore de favoris. Touchez le cœur d\'une recette pour la retrouver ici.';

  @override
  String get changelogTitle => 'Changelog';

  @override
  String get changeProfileImage => 'Changer la photo de profil';

  @override
  String get profileImageUpdated => 'Photo de profil mise à jour';

  @override
  String get profileImageFailed =>
      'La photo de profil n\'a pas pu être envoyée';

  @override
  String get myAccountTitle => 'Mon compte';

  @override
  String get ownAccountHint =>
      'Ici, vous pouvez modifier votre propre compte. Les autres utilisateurs sont gérés par les administrateurs et les membres disposant de l’autorisation « gérer ».';

  @override
  String get changePasswordAction => 'Changer le mot de passe';

  @override
  String get currentPasswordLabel => 'Mot de passe actuel';

  @override
  String get newPasswordLabel => 'Nouveau mot de passe';

  @override
  String get confirmPasswordLabel => 'Confirmer le mot de passe';

  @override
  String get passwordTooShort => 'Au moins 8 caractères';

  @override
  String get passwordsDoNotMatch => 'Les mots de passe ne correspondent pas';

  @override
  String get passwordUpdated => 'Mot de passe mis à jour';

  @override
  String get passwordChangeFailed => 'Le mot de passe n’a pas pu être modifié';

  @override
  String passwordManagedExternally(String method) {
    return 'Vous vous connectez via $method — modifiez votre mot de passe là-bas.';
  }

  @override
  String get bulkAddHint => 'Une ligne par entrée.';

  @override
  String bulkAddCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ajouter $count entrées',
      one: 'Ajouter 1 entrée',
    );
    return '$_temp0';
  }

  @override
  String get linkRecipeAction => 'Lier une recette';

  @override
  String get useFoodAction => 'Utiliser un aliment au lieu de la recette';

  @override
  String get addSubstitutionsAction => 'Ajouter des substitutions';

  @override
  String get clearSubstitutionsAction => 'Effacer les substitutions';

  @override
  String get recipeSubstitutionsTitle => 'Substitutions';

  @override
  String get substitutionUnknownFood =>
      'Aliments existants uniquement – sinon, utilisez la note';

  @override
  String get insertAboveAction => 'Insérer au-dessus';

  @override
  String get insertBelowAction => 'Insérer en dessous';

  @override
  String get moveToTopAction => 'Déplacer au début';

  @override
  String get moveToBottomAction => 'Déplacer à la fin';

  @override
  String get linkReferencesAction => 'Lier les références';

  @override
  String get editMarkdownAction => 'Modifier le Markdown';

  @override
  String get previewMarkdownAction => 'Aperçu du Markdown';

  @override
  String get insertStepImageAction => 'Envoyer une image';

  @override
  String get mergeAboveAction => 'Fusionner avec au-dessus';

  @override
  String get linkedToOtherStep => 'Déjà associé à une autre étape';

  @override
  String get noNotesToLink => 'Aucune note à lier';

  @override
  String get ownerLabel => 'Propriétaire';

  @override
  String get ingredientParserTitle => 'Analyseur d\'ingrédients';

  @override
  String ingredientParserHint(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count ingrédients ne sont pas encore structurés. Choisissez un analyseur, vérifiez le résultat, appliquez.',
      one:
          '1 ingrédient n\'est pas encore structuré. Choisissez un analyseur, vérifiez le résultat, appliquez.',
    );
    return '$_temp0';
  }

  @override
  String get parserNlp => 'Traitement du langage naturel';

  @override
  String get parserBrute => 'Analyseur brut';

  @override
  String get parserOpenai => 'Parseur OpenAI';

  @override
  String get parserApp => 'Hors ligne (app)';

  @override
  String get parseFailed => 'Échec de l\'analyse';

  @override
  String get parseAction => 'Analyser';

  @override
  String applyParsedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Appliquer $count ingrédients',
      one: 'Appliquer 1 ingrédient',
      zero: 'Rien de sélectionné',
    );
    return '$_temp0';
  }

  @override
  String get parsedNewBadge => 'nouveau';

  @override
  String get hoursShort => 'h';

  @override
  String get minutesShort => 'min';

  @override
  String get timeExtraHint => 'Complément, p. ex. « plus une nuit »';

  @override
  String get yieldLabel => 'Quantité';

  @override
  String get yieldTextLabel => 'Unité';

  @override
  String get prepTimeLabel => 'Temps de préparation';

  @override
  String get performTimeLabel => 'Temps de cuisson';

  @override
  String get totalTimeLabel => 'Temps total';

  @override
  String get settingPublicRecipe => 'Recette publique';

  @override
  String get settingShowNutrition => 'Afficher les valeurs nutritionnelles';

  @override
  String get settingShowAssets => 'Afficher les ressources';

  @override
  String get settingLandscapeView => 'Vue paysage';

  @override
  String get settingDisableComments => 'Désactiver les commentaires';

  @override
  String get settingDisableAmount => 'Désactiver les quantités des ingrédients';

  @override
  String get settingLocked => 'Verrouillé';

  @override
  String get settingLockedOwnerOnly =>
      'Seul le créateur peut verrouiller ou déverrouiller la recette.';

  @override
  String get apiExtrasTitle => 'Extras API';

  @override
  String get apiExtrasHint =>
      'Paires clé/valeur personnalisées pour des applications tierces, p. ex. pour déclencher des automatisations.';

  @override
  String get extraKeyLabel => 'Clé';

  @override
  String get extraValueLabel => 'Valeur';

  @override
  String get addExtraAction => 'Ajouter un extra';

  @override
  String durationHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count heures',
      one: '1 heure',
    );
    return '$_temp0';
  }

  @override
  String durationMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutes',
      one: '1 minute',
    );
    return '$_temp0';
  }

  @override
  String get discardChangesConfirm =>
      'Abandonner les modifications non enregistrées ?';

  @override
  String get discardChanges => 'Annuler les modifications';

  @override
  String get imageFromUrl => 'Image depuis une URL';

  @override
  String get deleteRecipeImage => 'Supprimer l\'image de la recette';

  @override
  String get deleteRecipeImageConfirm =>
      'Êtes-vous sûr de vouloir supprimer l\'image de cette recette ?';

  @override
  String get bulkAddIngredients => 'Ajouter des ingrédients en masse';

  @override
  String get bulkAddSteps => 'Ajouter des étapes en masse';

  @override
  String get stepImageFailed => 'L\'image n\'a pas pu être envoyée';

  @override
  String get servingsAndTimes => 'Portions et temps';

  @override
  String get recipeSettingsTitle => 'Paramètres de la recette';

  @override
  String get jsonEditorTitle => 'Éditeur JSON';

  @override
  String get jsonInvalid => 'JSON invalide – veuillez vérifier.';

  @override
  String get editorOfflineHint =>
      'Ouvert hors ligne : l’enregistrement nécessite une connexion. Les nouveaux champs Mealie (p. ex. substitutions) sont conservés tels quels.';

  @override
  String get parseLineFailed => 'Non reconnu – reste inchangé';

  @override
  String get createManualTitle => 'Créer une recette manuellement';

  @override
  String get createManualHint =>
      'Saisissez un nom – ajoutez ensuite ingrédients, étapes, image et le reste dans l’éditeur de recette.';

  @override
  String get createManualButton => 'Créer et modifier';

  @override
  String get changelogEmpty =>
      'Aucune entrée pour cette version pour le moment.';

  @override
  String get finderDescription =>
      'Recherchez des recettes en fonction des ingrédients que vous avez à disposition. Vous pouvez également filtrer par ustensile disponible et définir un nombre maximum d\'ingrédients ou d\'ustensiles manquants.';

  @override
  String get finderSelectedIngredients => 'Ingrédients sélectionnés';

  @override
  String get finderNoIngredientsSelected => 'Aucun ingrédient sélectionné';

  @override
  String get finderMissing => 'Manquant';

  @override
  String get finderNoRecipesFound => 'Aucune recette trouvée';

  @override
  String get finderNoRecipesFoundDescription =>
      'Essayez d\'ajouter plus d\'ingrédients à votre recherche ou d\'ajuster vos filtres';

  @override
  String get finderIncludeFoodsOnHand =>
      'Inclure les ingrédients à disposition';

  @override
  String get finderIncludeToolsOnHand => 'Inclure les ustensiles à disposition';

  @override
  String get finderIncludeSubstitutions => 'Inclure les substitutions';

  @override
  String get finderSubstituting => 'Substituer';

  @override
  String finderSubstituteForFood(String substitute, String food) {
    return '$substitute pour $food';
  }

  @override
  String get finderMaxMissingIngredients => 'Ingrédients manquants max';

  @override
  String get finderMaxMissingTools => 'Ustensiles manquants max';

  @override
  String get finderSelectedTools => 'Ustensiles sélectionnés';

  @override
  String get finderReadyToMake => 'Prêt à cuisiner';

  @override
  String get finderAlmostReadyToMake => 'Presque prêt à cuisiner';

  @override
  String get finderSettings => 'Paramètres';

  @override
  String get finderLoadingRecipes => 'Chargement des recettes';

  @override
  String get finderClearSelection => 'Effacer la sélection';

  @override
  String get finderOfflineHint =>
      'Pas de connexion au serveur – les résultats proviennent des recettes enregistrées sur cet appareil.';

  @override
  String addIngredientsSkippedOnHand(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Ajouté à votre liste de courses – $count ingrédients disponibles ont été ignorés.',
      one:
          'Ajouté à votre liste de courses – 1 ingrédient disponible a été ignoré.',
    );
    return '$_temp0';
  }

  @override
  String get sendPeerOfflineHint =>
      'Injoignable pour le moment – arrivera à la prochaine ouverture de l\'app';

  @override
  String sendDeliveredLater(String device) {
    return '« $device » est injoignable pour le moment. La recette arrivera dès que l\'app y sera ouverte.';
  }

  @override
  String get sendQueuedOffline =>
      'Pas de connexion pour le moment. La recette sera envoyée automatiquement dès que tu seras de nouveau en ligne.';

  @override
  String get searchHasAll => 'Requiert tout';

  @override
  String get searchHasAny => 'Requiert au moins';

  @override
  String get recipeFilterTitle => 'Filtrer';

  @override
  String get finderOtherFilters => 'Autres filtres';

  @override
  String get qfOpEquals => 'égal';

  @override
  String get qfOpNotEquals => 'n\'est pas égal';

  @override
  String get qfOpGreater => 'est supérieur à';

  @override
  String get qfOpGreaterEq => 'est plus grand que ou égal à';

  @override
  String get qfOpLess => 'est inférieur à';

  @override
  String get qfOpLessEq => 'est inférieur ou égal à';

  @override
  String get qfOpNewerThan => 'est plus récent que';

  @override
  String get qfOpOlderThan => 'est plus ancien que';

  @override
  String qfDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'il y a $count jours',
      one: 'il y a 1 jour',
    );
    return '$_temp0';
  }

  @override
  String get filterResetAll => 'Réinitialiser tous les filtres';

  @override
  String get filterAny => 'Tous';

  @override
  String get filterOfflineIgnored =>
      'Hors ligne, les « Autres filtres » ne s\'appliquent que sous leur forme simple.';

  @override
  String linkedRecipesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count recettes liées',
      one: 'Une recette liée',
      zero: 'Aucune recette liée',
    );
    return '$_temp0';
  }

  @override
  String get shoppingReminderNotificationsOff =>
      'Les notifications de Mealie Recipes sont désactivées — sans elles, le rappel de courses ne peut pas s\'afficher. Autorisez-les dans les réglages.';

  @override
  String get shoppingReminderInactiveHint =>
      'Le rappel de courses ne peut pas fonctionner : réglez l\'accès à la position sur « Toujours » et autorisez les notifications.';

  @override
  String get bulkImportTitle => 'Importation en masse d\'URL';

  @override
  String get bulkImportDescription =>
      'L\'importateur en masse de recettes vous permet d\'importer plusieurs recettes à la fois en lançant l\'import en arrière-plan. Cela peut être utile lors de la migration vers Mealie, ou lorsque vous voulez importer un grand nombre de recettes.';

  @override
  String get bulkAddTitle => 'Ajouter en masse';

  @override
  String get bulkImportSetOrganizers =>
      'Définir des catégories et des étiquettes';

  @override
  String get bulkImportStarted =>
      'Le processus d\'importation en masse a commencé';

  @override
  String get bulkImportFailed =>
      'Le processus d\'importation en masse a échoué';

  @override
  String get bulkImportReports => 'Imports en masse';

  @override
  String get bulkImportUrlHint => 'Adresse de la recette';

  @override
  String get migrationsTitle => 'Migration des données';

  @override
  String get migrationsDescription =>
      'Les recettes peuvent être migrées depuis une autre application supportée vers Mealie. C\'est un excellent moyen de commencer avec Mealie. Le déplacement des données entre les instances de Mealie, ou la restauration d\'une ancienne sauvegarde Mealie, se fait avec les outils de sauvegarde et de restauration.';

  @override
  String get migrationNew => 'Nouvelle migration';

  @override
  String get migrationChooseType => 'Choisissez le type de migration';

  @override
  String get noFileSelected => 'Aucun fichier sélectionné';

  @override
  String migrationTagAll(String tag) {
    return 'Étiquetez toutes les recettes avec le mot-clé $tag';
  }

  @override
  String get migrationPrevious => 'Migrations précédentes';

  @override
  String get migrationMealieDescription =>
      'Mealie peut importer des recettes depuis l\'application Mealie depuis une version antérieure à la v1.0. Exportez vos recettes depuis votre ancienne instance, et téléchargez le fichier zip ci-dessous. Notez que seulement les recettes sont importées depuis l\'exportation. Cela s\'applique uniquement aux instances antérieures à la version v1.0. Une sauvegarde à partir de la version v1.0 ou ultérieure devrait être restaurée avec les outils de sauvegarde et de restauration.';

  @override
  String get migrationChowdownDescription =>
      'Mealie supporte nativement le format du dépôt chowdown. Téléchargez le dépôt de code en tant que fichier .zip et téléchargez-le ci-dessous.';

  @override
  String get migrationCopyMeThatDescription =>
      'Mealie peut importer des recettes à partir de Copy Me That. Exportez vos recettes au format HTML, puis téléchargez le .zip ci-dessous.';

  @override
  String get migrationMyRecipeBoxDescription =>
      'Mealie peut importer des recettes depuis My Recipe Box. Exportez vos recettes au format CSV, puis téléchargez le fichier CSV ci-dessous.';

  @override
  String get migrationNextcloudDescription =>
      'Les recettes Nextcloud peuvent être importées depuis un fichier zip qui contient les données stockées dans Nextcloud. Consultez la structure de dossiers d\'exemple ci-dessous pour vous assurer que vos recettes peuvent être importées.';

  @override
  String get migrationPaprikaDescription =>
      'Mealie peut importer des recettes depuis l\'application Paprika. Exportez vos recettes de paprika, renommez l\'extension d\'exportation en .zip et téléchargez-les ci-dessous.';

  @override
  String get migrationPlanToEatDescription =>
      'Mealie peut importer des recettes depuis Plan to Eat.';

  @override
  String get migrationRecipeKeeperDescription =>
      'Mealie peut importer des recettes depuis Recipe Keeper. Exportez vos recettes au format Zip, puis téléversez le fichier .zip ci-dessous.';

  @override
  String get migrationTandoorDescription =>
      'Mealie peut importer des recettes à partir de Tandoor. Exportez vos données dans le format « Défaut », puis téléchargez le .zip ci-dessous.';

  @override
  String get migrationCooknDescription =>
      'Mealie peut importer des recettes de DVO Cook\'n X3. Exportez un livre de recettes ou un menu au format \"Cook\'n\", renommez l\'extension d\'exportation en .zip, puis téléchargez le .zip ci-dessous.';

  @override
  String get reportTitle => 'Rapport';

  @override
  String get recipeDataTitle => 'Données de la recette';

  @override
  String get recipeDataDescription =>
      'Utilisez cette section pour gérer les données associées à vos recettes. Vous pouvez effectuer plusieurs actions en masse sur vos recettes, y compris l\'exportation, la suppression et l\'assignation de mots-clés et de catégories.';

  @override
  String get recipeDataTagTitle => 'Ajouter des mots-clés aux recettes';

  @override
  String get recipeDataCategorizeTitle => 'Catégoriser les recettes';

  @override
  String get recipeDataSettingsTitle => 'Mettre à jour les paramètres';

  @override
  String get recipeDataExportTitle => 'Exporter les recettes';

  @override
  String get recipeDataDeleteTitle => 'Supprimer les recettes';

  @override
  String recipeDataExportConfirm(int count) {
    return 'Les recettes suivantes ($count) seront exportées.';
  }

  @override
  String get recipeDataExportsTitle => 'Exportations de données';

  @override
  String get recipeDataExportsDescription =>
      'Cette section fournit des liens vers les exportations disponibles qui sont prêtes à être téléchargées. Ces exportations expirent, alors assurez-vous de les récupérer tant qu\'elles sont encore disponibles.';

  @override
  String get recipeDataPurgeExports => 'Purger les exports';

  @override
  String get recipeDataPurgeConfirm =>
      'Voulez-vous vraiment supprimer toutes les données d\'export ?';

  @override
  String get recipeActionsTitle => 'Actions de recette';

  @override
  String get recipeActionNew => 'Nouvelle action de recette';

  @override
  String get recipeActionEdit => 'Modifier l\'action de recette';

  @override
  String get recipeActionTypeLink => 'Lien';

  @override
  String get recipeActionTypePost => 'Publier';

  @override
  String get webhooksTitle => 'Webhooks';

  @override
  String get webhooksDescription =>
      'Les webhooks définis ci-dessous seront exécutés lorsqu\'un repas est défini pour la journée. À l\'heure prévue, les webhooks seront envoyés avec les données de la recette qui est prévue pour la journée. Notez que l\'exécution du webhook n\'est pas exacte. Les webhooks sont exécutés à un intervalle de 5 minutes.';

  @override
  String get webhookName => 'Nom du Webhook';

  @override
  String get webhookUrl => 'Lien du webhook';

  @override
  String get notifiersTitle => 'Notifications';

  @override
  String get notifiersDescription =>
      'Configurer des e-mails et des notifications push qui se déclenchent sur des événements spécifiques.';

  @override
  String get notifierNew => 'Nouvelle notification';

  @override
  String get notifierDescription =>
      'Mealie utilise la bibliothèque Apprise pour générer des notifications. Elle propose de nombreux services à utiliser pour les notifications. Consultez leur wiki pour un guide complet sur la façon de créer l’URL de votre service. Si disponible, sélectionner le type de votre notification peut inclure des fonctionnalités supplémentaires.';

  @override
  String get notifierAppriseUrl => 'URL Apprise';

  @override
  String get notifierAppriseUrlSkipped => 'URL Apprise (ignoré si vide)';

  @override
  String get notifierAppriseUrlBlankHint =>
      'Comme les URL Apprise contiennent généralement des informations sensibles, ce champ est laissé intentionnellement vide lors de l\'édition. Si vous souhaitez mettre à jour l\'URL, veuillez entrer la nouvelle URL ici, sinon laisser vide pour conserver l\'URL courante.';

  @override
  String get notifierEnable => 'Activer la notification';

  @override
  String get notifierWhatEvents =>
      'À quels événements cette notification doit-elle s\'abonner ?';

  @override
  String get notifierRecipeEvents => 'Événements de recette';

  @override
  String get notifierUserEvents => 'Événements utilisateur';

  @override
  String get notifierMealplanEvents => 'Événements du planning de repas';

  @override
  String get notifierShoppingListEvents => 'Événements de la liste de courses';

  @override
  String get notifierCookbookEvents => 'Événements du livre de recettes';

  @override
  String get notifierTagEvents => 'Événements des mots-clés';

  @override
  String get notifierCategoryEvents => 'Événements de catégories';

  @override
  String get notifierLabelEvents => 'Étiquette des événements';

  @override
  String get notifierUserSignup =>
      'Lorsqu\'un nouvel utilisateur rejoint votre groupe';

  @override
  String get notifierCreate => 'Créer';

  @override
  String get notifierUpdate => 'Mettre à jour';

  @override
  String get notifierDelete => 'Supprimer';

  @override
  String get notifierTestSent => 'Message de test envoyé';

  @override
  String get adminTitle => 'Paramètres d’administration';

  @override
  String get backupsTitle => 'Sauvegardes';

  @override
  String get backupsDescription =>
      'Les sauvegardes sont des instantanés complets de la base de données et du répertoire de données du site. Cela inclue toutes les données et il n’est pas possible d’en exclure un sous-ensemble. Vous pouvez le voir comme un instantané de Mealie à un temps donné. Cela peut servir de moyen d’importer et d’exporter les données indépendamment du moteur de base de données, ou bien de sauvegarder le site vers un emplacement externe.';

  @override
  String get backupCreateHeading => 'Créer une sauvegarde';

  @override
  String get backupCreated => 'Sauvegarde créée avec succès';

  @override
  String get backupCreateFailed =>
      'Erreur de création de la sauvegarde. Voir les logs';

  @override
  String get backupDelete => 'Supprimer la sauvegarde';

  @override
  String get backupDeleted => 'Sauvegarde supprimée';

  @override
  String get backupRestore => 'Restaurer une sauvegarde';

  @override
  String get backupRestoreDescription =>
      'La restauration de cette sauvegarde écrasera toutes les données actuelles dans votre base de données et dans le répertoire de données et les remplacera par le contenu de cette sauvegarde. Si la restauration est réussie, vous serez déconnecté.';

  @override
  String get backupCannotBeUndone =>
      'Cette action ne peut pas être annulée - à utiliser avec prudence.';

  @override
  String get backupAcknowledge =>
      'Je comprends que cette action est irréversible, destructrice et peut entraîner une perte de données';

  @override
  String get backupRestoreSuccess => 'Restauration réussie';

  @override
  String get backupRestoreFailed =>
      'Échec de la restauration. Vérifiez les journaux de votre serveur pour plus de détails';

  @override
  String get maintenanceTitle => 'Maintenance';

  @override
  String get maintenanceSummary => 'Résumé';

  @override
  String get maintenanceStorage => 'Détails du stockage';

  @override
  String get maintenanceDataDirSize => 'Taille du répertoire de données';

  @override
  String get maintenanceCleanableDirs => 'Répertoires nettoyables';

  @override
  String get maintenanceCleanableImages => 'Images nettoyables';

  @override
  String get maintenanceTempDir => 'Répertoire temporaire (.temp)';

  @override
  String get maintenanceBackupsDir => 'Répertoire des sauvegardes (backups)';

  @override
  String get maintenanceGroupsDir => 'Répertoire des groupes (groups)';

  @override
  String get maintenanceRecipesDir => 'Répertoire des recettes (recipes)';

  @override
  String get maintenanceUserDir => 'Répertoire utilisateur (user)';

  @override
  String get maintenanceCleanDirs => 'Nettoyer les répertoires';

  @override
  String get maintenanceCleanDirsDescription =>
      'Supprime tous les dossiers de recettes qui ne sont pas des UUID valides';

  @override
  String get maintenanceCleanTemp => 'Nettoyage des fichiers temporaires';

  @override
  String get maintenanceCleanTempDescription =>
      'Supprime tous les fichiers et dossiers du répertoire .temp';

  @override
  String get maintenanceCleanImages => 'Nettoyer les images';

  @override
  String get maintenanceCleanImagesDescription =>
      'Supprime toutes les images qui ne se terminent pas par .webp';

  @override
  String get maintenanceActions => 'Actions';

  @override
  String get adminConfiguration => 'Paramètres';

  @override
  String get adminAppVersion => 'Version de l’application';

  @override
  String get adminUpToDate => 'Mealie est à jour';

  @override
  String adminVersionOutdated(String current, String latest) {
    return 'Votre version actuelle ($current) ne correspond pas à la dernière version. Pensez à mettre à jour vers la dernière version ($latest).';
  }

  @override
  String get adminBaseUrl => 'URL de base côté serveur';

  @override
  String get adminBaseUrlOk =>
      'L\'URL du côté du serveur ne correspond pas à celle par défaut';

  @override
  String get adminBaseUrlError =>
      '`BASE_URL` est encore la valeur par défaut sur le serveur API. Cela causera des problèmes avec les liens générés par les notifications sur le serveur pour les e-mails, etc.';

  @override
  String adminAuthReady(String provider) {
    return '$provider prêt';
  }

  @override
  String adminAuthNotReady(String provider) {
    return '$provider pas prêt';
  }

  @override
  String adminAuthDisabled(String provider) {
    return '$provider désactivé';
  }

  @override
  String adminAuthSuccessText(String provider) {
    return 'Les variables obligatoires de $provider sont toutes définies.';
  }

  @override
  String adminAuthErrorText(String provider) {
    return 'Toutes les valeurs de $provider ne sont pas configurées. Vous pouvez ignorer cela si vous n\'utilisez pas l\'authentification $provider.';
  }

  @override
  String adminAuthDisabledText(String envVar) {
    return 'Pour activer, définissez $envVar à true.';
  }

  @override
  String get adminEmailStatus => 'État de la configuration e-mail';

  @override
  String get adminEmailConfigured => 'E-mail configuré';

  @override
  String get adminNotReady =>
      'Pas prêt - Vérifier les variables d\'environnement';

  @override
  String get adminSucceeded => 'Réussite';

  @override
  String get adminFailed => 'Échec';

  @override
  String get adminSiteStatistics => 'Statistiques du site';

  @override
  String get adminUncategorized => 'Recettes non catégorisées';

  @override
  String get adminUntagged => 'Recettes sans mots-clés';

  @override
  String get adminGeneralAbout => 'À propos';

  @override
  String get adminVersion => 'Version';

  @override
  String get adminBuild => 'Build';

  @override
  String get adminApplicationMode => 'Mode de l’application';

  @override
  String get adminProduction => 'Réalisation';

  @override
  String get adminDevelopment => 'Développement';

  @override
  String get adminDemoStatus => 'Mode démo';

  @override
  String get adminDemo => 'Oui';

  @override
  String get adminNotDemo => 'Non';

  @override
  String get adminApiPort => 'Port de l’API';

  @override
  String get adminApiDocs => 'Documentation de l’API';

  @override
  String get adminDatabaseType => 'Type de base de données';

  @override
  String get adminDatabaseUrl => 'URL de la base de données';

  @override
  String get adminDefaultGroup => 'Groupe par défaut';

  @override
  String get adminDefaultHousehold => 'Foyer par défaut';

  @override
  String get adminScraperVersion => 'Version du Scraper de recette';

  @override
  String get adminStatUsers => 'Utilisateurs';

  @override
  String get adminStatHouseholds => 'Foyers';

  @override
  String get adminStatGroups => 'Groupes';

  @override
  String get recipeDuplicate => 'Dupliquer la recette';

  @override
  String get recipeDuplicateAction => 'Dupliquer';

  @override
  String get recipeShareLink => 'Partager la recette';

  @override
  String get recipeShareExpiration => 'Date d’expiration';

  @override
  String get recipeShareCopied =>
      'Lien de la recette copié dans le presse-papiers';

  @override
  String get enabledLabel => 'Activé';

  @override
  String get disabledLabel => 'Désactivé';

  @override
  String get testAction => 'Tester';

  @override
  String get yesLabel => 'Oui';

  @override
  String get noLabel => 'Non';

  @override
  String get downloadAction => 'Télécharger';

  @override
  String get backupUpload => 'Importer';

  @override
  String get zipImportButton => 'Importer depuis un zip';

  @override
  String get zipImportDescription =>
      'Importer une recette qui a été exportée depuis une autre instance de Mealie.';

  @override
  String get reportStatus => 'Statut';

  @override
  String get reportDate => 'Date';

  @override
  String get recipeActionTitleLabel => 'Titre';

  @override
  String get clearAll => 'Effacer';

  @override
  String get recipeDataSettingsExplanation =>
      'Les paramètres choisis ici, à l\'exception de l\'option de verrouillage, seront appliqués à toutes les recettes sélectionnées.';

  @override
  String get adminAllowSignup => 'Inscription autorisée';

  @override
  String get adminAllowPasswordLogin => 'Connexion par mot de passe autorisée';

  @override
  String get adminEmailInvalid => 'Veuillez saisir une adresse e-mail valide.';

  @override
  String adminEmailTestResult(String result) {
    return 'Test de l’e-mail : $result';
  }

  @override
  String get adminSendTestEmail => 'Envoyer un e-mail de test';

  @override
  String get adminTestEmailAddress => 'Destinataire';

  @override
  String get backupCreate => 'Créer une sauvegarde';

  @override
  String backupDeleteConfirm(String name) {
    return 'Supprimer la sauvegarde « $name » ?';
  }

  @override
  String get backupPostgresNote =>
      'Si vous utilisez PostgreSQL, consultez la procédure de sauvegarde/restauration dans la documentation de Mealie avant de restaurer.';

  @override
  String get backupUploaded => 'Sauvegarde téléversée';

  @override
  String get backupsEmpty => 'Aucune sauvegarde pour le moment.';

  @override
  String get bulkImportAddRow => 'Ajouter une URL';

  @override
  String get bulkImportStart => 'Lancer l’import';

  @override
  String get chooseFileButton => 'Choisir un fichier';

  @override
  String get deselectAllAction => 'Tout désélectionner';

  @override
  String get downloadFailed => 'Échec du téléchargement';

  @override
  String get fileSaved => 'Fichier enregistré';

  @override
  String get loadFailed => 'Chargement impossible';

  @override
  String get maintenanceActionsWarning =>
      'Les actions de maintenance sont destructives et doivent être utilisées avec prudence. Chacune d’elles est irréversible.';

  @override
  String get maintenanceConfirm =>
      'Cette action est destructive et irréversible. Continuer ?';

  @override
  String get maintenanceDone => 'Terminé';

  @override
  String get maintenanceFailed => 'Échec de l’action de maintenance';

  @override
  String get maintenanceRun => 'Exécuter';

  @override
  String get migrationFailed => 'Échec de la migration';

  @override
  String get migrationStart => 'Lancer la migration';

  @override
  String get migrationStarted =>
      'Migration terminée — voir le rapport ci-dessous.';

  @override
  String get moreImportOptions => 'Autres options d’import';

  @override
  String notifierDeleteConfirm(String name) {
    return 'Supprimer la notification « $name » ?';
  }

  @override
  String get notifierEdit => 'Modifier la notification';

  @override
  String notifierEventCount(int count) {
    return 'Événements : $count';
  }

  @override
  String get notifierTestFailed => 'Impossible d’envoyer le message de test';

  @override
  String get notifiersEmpty => 'Aucune notification pour le moment.';

  @override
  String recipeActionDeleteConfirm(String name) {
    return 'Supprimer l’action de recette « $name » ?';
  }

  @override
  String get recipeActionFailed => 'Échec de l’action de recette';

  @override
  String get recipeActionSent => 'Recette envoyée';

  @override
  String get recipeActionUrlHint => 'Variables';

  @override
  String get recipeActionsDescription =>
      'Les actions de recette apparaissent dans le menu de chaque recette. « Lien » ouvre l’URL, « Publier » fait envoyer la recette à l’URL par le serveur Mealie.';

  @override
  String get recipeActionsEmpty => 'Aucune action de recette pour le moment.';

  @override
  String recipeDataDeleteConfirm(int count) {
    return 'Supprimer les recettes sélectionnées ($count) ? Action irréversible.';
  }

  @override
  String recipeDataDeleteForbidden(int count) {
    return 'Vous ne pouvez pas supprimer $count des recettes sélectionnées (seul leur créateur ou un administrateur le peut).';
  }

  @override
  String recipeDataDeleted(int count) {
    return 'Recettes supprimées : $count';
  }

  @override
  String get recipeDataExportAction => 'Exporter';

  @override
  String get recipeDataExportDone =>
      'Export créé — téléchargez-le dans Exports de données.';

  @override
  String recipeDataExportExpires(String date) {
    return 'expire le $date';
  }

  @override
  String get recipeDataExportFailed => 'Échec de l’export';

  @override
  String get recipeDataExportsEmpty => 'Aucun export disponible.';

  @override
  String recipeDataUpdated(int count) {
    return 'Recettes mises à jour : $count';
  }

  @override
  String get recipeDuplicated => 'Recette dupliquée';

  @override
  String get recipeExportJson => 'Exporter en JSON';

  @override
  String get recipeExportZip => 'Exporter en ZIP (avec image)';

  @override
  String get recipeShareCreate => 'Créer un lien';

  @override
  String get recipeShareDescription =>
      'Toute personne disposant du lien peut voir cette recette dans le navigateur — sans compte — jusqu’à son expiration.';

  @override
  String get recipeShareEmpty => 'Aucun lien de partage pour le moment.';

  @override
  String recipeShareExpiresAt(String date) {
    return 'Expire le $date';
  }

  @override
  String get recipeWebToolsMenu => 'Dupliquer, lien de partage et plus';

  @override
  String get reload => 'Recharger';

  @override
  String get reportDeleteConfirm => 'Supprimer ce rapport ?';

  @override
  String get reportEntries => 'Entrées';

  @override
  String get reportFailedEntries => 'Échecs';

  @override
  String get reportOnlyFailed => 'Afficher uniquement les échecs';

  @override
  String get reportStatusFailure => 'Échec';

  @override
  String get reportStatusInProgress => 'En cours';

  @override
  String get reportStatusPartial => 'Partiel';

  @override
  String get reportStatusSuccess => 'Succès';

  @override
  String get reportsEmpty => 'Aucun rapport pour le moment.';

  @override
  String get uploadFailed => 'Échec du téléversement';

  @override
  String webhookDeleteConfirm(String name) {
    return 'Supprimer le webhook « $name » ?';
  }

  @override
  String get webhookEdit => 'Modifier le webhook';

  @override
  String get webhookNew => 'Nouveau webhook';

  @override
  String get webhookTestFailed => 'Impossible de lancer le test';

  @override
  String get webhookTestSent => 'Webhook de test déclenché';

  @override
  String get webhookTime => 'Heure (locale)';

  @override
  String get webhooksEmpty => 'Aucun webhook pour le moment.';

  @override
  String get zipImportFailed => 'Échec de l’import ZIP';

  @override
  String get aiProvidersTitle => 'Fournisseurs d\'IA';

  @override
  String get aiProvidersDescription =>
      'Configurez les fournisseurs d\'IA pour activer les fonctionnalités alimentées par l\'AI, telles que l\'analyse améliorée des ingrédients, la création de recettes à partir de vidéos, et plus encore !';

  @override
  String get aiProviderSettingsTitle => 'Paramètres du fournisseur d\'IA';

  @override
  String get aiProvidersList => 'Fournisseurs';

  @override
  String get aiProviderCreate => 'Créer un fournisseur';

  @override
  String get aiProviderEdit => 'Éditer le fournisseur';

  @override
  String get aiDefaultProvider => 'Fournisseur par défaut';

  @override
  String get aiDefaultProviderDescription =>
      'Requis pour activer les fonctionnalités IA';

  @override
  String get aiAudioProvider => 'Fournisseur audio';

  @override
  String get aiAudioProviderDescription =>
      'Active les fonctionnalités de transcription audio, comme la création de recettes à partir de vidéos';

  @override
  String get aiImageProvider => 'Fournisseur d\'images';

  @override
  String get aiImageProviderDescription =>
      'Active les fonctionnalités de reconnaissance d\'image, comme la création de recettes à partir d\'images';

  @override
  String get aiProviderName => 'Nom du fournisseur';

  @override
  String get aiApiKey => 'Clé API';

  @override
  String get aiApiKeyCreateDescription =>
      'La clé API de votre fournisseur pour l\'authentification. Si votre service (par exemple Ollama) n\'utilise pas une clé API, vous devez malgré tout toujours mettre quelque chose ici.';

  @override
  String get aiApiKeyEditDescription =>
      'Laissez ce champ vide à moins que vous vouliez le modifier.';

  @override
  String get aiBaseUrl => 'URL de base';

  @override
  String get aiBaseUrlDescription =>
      'Si vous utilisez OpenAI laissez ce champ vide. Doit être un point de terminaison compatible OpenAI (par exemple \"http://localhost:11434/v1\").';

  @override
  String get aiModel => 'Modèle';

  @override
  String get aiModelDescription =>
      'Quel modèle doit utiliser votre fournisseur d\'IA (par exemple \"gpt-5\").';

  @override
  String get aiTimeout => 'Délai d\'attente de la requête (secondes)';

  @override
  String get aiProviderCreated => 'Fournisseur créé';

  @override
  String get aiProviderUpdated => 'Fournisseur mis à jour';

  @override
  String get aiProviderDeleted => 'Fournisseur supprimé';

  @override
  String get aiProviderCreateFailed => 'Échec de la création du fournisseur';

  @override
  String get aiProviderUpdateFailed => 'Échec de la mise à jour du fournisseur';

  @override
  String get aiProviderDeleteFailed => 'Échec de la suppression du fournisseur';

  @override
  String get aiRequestHeaders => 'En-têtes de la requête';

  @override
  String get aiRequestParams => 'Paramètres de la requête';

  @override
  String get aiNoDefaultWarning =>
      'Vous n\'avez pas défini de fournisseur par défaut, donc les fonctionnalités IA sont désactivées';

  @override
  String get aiTestConnection => 'Tester la connexion';

  @override
  String get aiTestSucceeded => 'Connexion réussie';

  @override
  String get aiTestFailed => 'Échec de la connexion';

  @override
  String get aiSupportsImages => 'Prend en charge les images';

  @override
  String get aiTextOnly =>
      'Texte uniquement — ne peut pas être votre fournisseur d’images';

  @override
  String get debugAiTitle => 'Déboguer les fournisseurs d’IA';

  @override
  String get debugAiDescription =>
      'Utilisez cette page pour déboguer les fournisseurs d’IA. Vous pouvez tester la connexion et voir les résultats ici. Si les services d’image sont activés, vous pouvez aussi fournir une image.';

  @override
  String get debugParserTitle => 'Analyseur syntaxique';

  @override
  String get debugParserDescription =>
      'Mealie utilise des champs aléatoires conditionnels (CRF) pour l\'analyse et le traitement des ingrédients. Le modèle utilisé pour les ingrédients est basé sur un ensemble de données de plus de 100 000 ingrédients provenant d\'un jeu de données compilé par le New York Times. Notez que le modèle étant formé en anglais uniquement, vous pouvez avoir des résultats différents lorsque vous utilisez le modèle dans d\'autres langues. Cette page est un terrain de jeu pour tester le modèle.';

  @override
  String get debugIngredientText => 'Texte de l\'ingrédient';

  @override
  String get debugTryExample => 'Essayez avec un exemple';

  @override
  String debugAverageConfidence(String value) {
    return 'Confiant à $value';
  }

  @override
  String get debugRunTest => 'Lancer le test';

  @override
  String get debugQuantity => 'Quantité';

  @override
  String get debugUnit => 'Unité';

  @override
  String get debugFood => 'Aliment';

  @override
  String get debugNote => 'Commentaire';

  @override
  String get debugGroup => 'Groupe';

  @override
  String get aiProviderNone => 'Aucun';

  @override
  String aiProviderDeleteConfirm(String name) {
    return 'Supprimer le fournisseur « $name » ?';
  }

  @override
  String get aiProvidersEmpty => 'Aucun fournisseur d’IA pour le moment.';

  @override
  String get aiAdvanced => 'Avancé';

  @override
  String get aiKeyLabel => 'Nom';

  @override
  String get aiValueLabel => 'Valeur';

  @override
  String get debugTitle => 'Débogage';

  @override
  String get debugParse => 'Analyser';

  @override
  String get debugParseFailed => 'Impossible d’analyser l’ingrédient';

  @override
  String get debugChooseImage => 'Choisir une image';

  @override
  String get debugNoImage => 'Aucune image (facultatif)';

  @override
  String get updateTitle => 'Rechercher des mises à jour';

  @override
  String get updateInstalledVersion => 'Version installée';

  @override
  String get updateLastCheck => 'Dernière vérification';

  @override
  String get updateCheckNow => 'Vérifier maintenant';

  @override
  String get updateChecking => 'Recherche de mises à jour…';

  @override
  String get updateUpToDate => 'Mealie Recipes est à jour.';

  @override
  String updateAvailable(String version) {
    return 'La version $version est disponible';
  }

  @override
  String get updateAvailableDescription =>
      'Une nouvelle version de Mealie Recipes est disponible. Rien n’est installé tant que vous ne lancez pas la mise à jour.';

  @override
  String get updateShow => 'Voir la mise à jour';

  @override
  String get updateLater => 'Plus tard';

  @override
  String updateDownloading(int percent) {
    return 'Téléchargement… $percent %';
  }

  @override
  String updateReady(String version) {
    return 'La version $version est prête à être installée';
  }

  @override
  String get updateInstalling => 'Installation… l’app va redémarrer…';

  @override
  String get updateManual =>
      'La mise à jour n’a pas pu être installée automatiquement. L’image disque a été ouverte : glissez Mealie Recipes dans Applications.';

  @override
  String get updateFailed => 'Échec de la mise à jour';

  @override
  String get updateInstallNow => 'Télécharger et installer';

  @override
  String get updateRestartNow => 'Installer et redémarrer';

  @override
  String get updateAutoTitle => 'Rechercher les mises à jour au démarrage';

  @override
  String get updateAutoDescription =>
      'Vérifie et vous prévient uniquement — vous lancez toujours l’installation vous-même.';

  @override
  String get updateNoNotes => 'Aucune note de version.';

  @override
  String get updateSourceHint =>
      'Les mises à jour proviennent des versions GitHub de Mealie Recipes et ne sont installées que si elles sont signées par le développeur (macOS).';
}
