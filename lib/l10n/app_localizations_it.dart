// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get endCookingMode => 'Termina modalità cucina';

  @override
  String get endCookingModeConfirm =>
      'Vuoi davvero terminare la modalità cucina?';

  @override
  String endCookingModeConfirmAll(int count) {
    return 'Verranno terminate tutte le $count ricette in modalità cucina. Continuare?';
  }

  @override
  String get addTimer => 'Aggiungi timer';

  @override
  String get recipeFinished => 'Il tuo piatto è pronto.';

  @override
  String get bonAppetit => 'Buon appetito!';

  @override
  String get prepareIngredients => 'Prepara i seguenti ingredienti';

  @override
  String prepareIngredientsFor(String servings) {
    return 'Prepara i seguenti ingredienti per $servings porzioni';
  }

  @override
  String get next => 'Avanti';

  @override
  String get navHome => 'Pagina iniziale';

  @override
  String get homeCookToday => 'Da cucinare oggi';

  @override
  String get homeSuggestion => 'Suggerimento';

  @override
  String get homeQuickAccess => 'Accesso rapido';

  @override
  String get homePlanned => 'In programma';

  @override
  String get favorite => 'Preferito';

  @override
  String get navSettings => 'Impostazioni';

  @override
  String homeWelcomeName(Object name) {
    return 'Benvenuto $name,';
  }

  @override
  String get homeWelcomeApp => 'in Mealie Recipes 👋';

  @override
  String get theme => 'Aspetto';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Chiaro';

  @override
  String get themeDark => 'Scuro';

  @override
  String get recipes => 'Ricette';

  @override
  String get shoppingList => '🛒 Lista della spesa';

  @override
  String get mealplan => 'Piano alimentare';

  @override
  String get settings => '⚙️ Impostazioni';

  @override
  String get searchRecipe => 'Cerca ricetta...';

  @override
  String get loadingRecipe => 'Caricamento della ricetta...';

  @override
  String get errorLoadingRecipe => 'Impossibile caricare la ricetta.';

  @override
  String get noRecipesForCategory => 'Nessuna ricetta per questo filtro.';

  @override
  String get resetFilter => 'Reimposta filtro';

  @override
  String get allCategories => 'Tutte le categorie';

  @override
  String get all => 'Tutti';

  @override
  String get sortRecipes => 'Ordina ricette';

  @override
  String get refreshRecipes => 'Aggiorna';

  @override
  String get sortNameAZ => 'Nome A–Z';

  @override
  String get sortNameZA => 'Nome Z–A';

  @override
  String get sortDateNewest => 'Più recenti';

  @override
  String get sortDateOldest => 'Meno recenti';

  @override
  String get sortPrepTimeShort => 'Preparazione più breve';

  @override
  String get sortPrepTimeLong => 'Preparazione più lunga';

  @override
  String get sortRatingHighest => 'Valutazione più alta';

  @override
  String get sortRatingLowest => 'Valutazione più bassa';

  @override
  String get details => 'Dettagli';

  @override
  String get ingredients => 'Ingredienti';

  @override
  String get instructions => 'Istruzioni';

  @override
  String get tags => 'Tag';

  @override
  String get notes => 'Note';

  @override
  String get addNote => 'Aggiungi nota';

  @override
  String get editNote => 'Modifica nota';

  @override
  String get noteTitleHint => 'Titolo (facoltativo)';

  @override
  String get noteTextHint => 'Testo della nota';

  @override
  String get deleteNoteTitle => 'Eliminare la nota?';

  @override
  String get deleteNoteMessage =>
      'Questa nota verrà eliminata definitivamente.';

  @override
  String get servings => 'Porzioni';

  @override
  String get planMeal => 'Pianifica pasto';

  @override
  String get addAllIngredients => 'Aggiungi tutti gli ingredienti';

  @override
  String get addSelectedIngredients => 'Aggiungi ingredienti selezionati';

  @override
  String get addIngredientsMessage =>
      'Gli ingredienti sono stati aggiunti alla lista della spesa.';

  @override
  String addIngredientsFailedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Non è stato possibile aggiungere $count ingredienti.',
      one: 'Non è stato possibile aggiungere 1 ingrediente.',
    );
    return '$_temp0';
  }

  @override
  String get cookbooks => 'Ricettari';

  @override
  String get cookbooksEmpty =>
      'Ancora nessun ricettario. Tocca “+” in alto a destra per crearne uno.';

  @override
  String get cookbookNoMatches =>
      'Nessuna ricetta corrisponde a questo filtro.';

  @override
  String get cookbookCreateTitle => 'Crea ricettario';

  @override
  String get cookbookEditTitle => 'Modifica ricettario';

  @override
  String get cookbookNameLabel => 'Nome del ricettario';

  @override
  String get cookbookFilterSectionTitle => 'Aggiungi ricette automaticamente';

  @override
  String get cookbookFieldTools => 'Strumenti';

  @override
  String get cookbookFieldUsers => 'Utenti';

  @override
  String get cookbookOpIsOneOf => 'è uno di';

  @override
  String get cookbookOpIsNotOneOf => 'non è uno di';

  @override
  String get cookbookOpContainsAll => 'contiene tutti';

  @override
  String get cookbookSelectValues => 'Seleziona valori';

  @override
  String get cookbookFilterOptionsUnavailable => 'Nessuna opzione disponibile';

  @override
  String get cookbookAddFilterField => 'Aggiungi campo';

  @override
  String get cookbookPublicLabel => 'Ricettario pubblico';

  @override
  String get cookbookPublicSubtitle =>
      'Visibile alle altre famiglie sul server';

  @override
  String get cookbookRawModeEnter => 'Modifica come testo';

  @override
  String get cookbookRawModeExit => 'Torna al generatore';

  @override
  String get cookbookRawModeHint =>
      'Modalità esperto dell\'app: modifica il filtro direttamente come testo. Utile quando un filtro esistente non può essere scomposto in righe semplici.';

  @override
  String get cookbookRawModeUnparseable =>
      'Questo testo non corrisponde al formato a righe semplici — resta come testo.';

  @override
  String get saveFailed => 'Salvataggio non riuscito';

  @override
  String get search => 'Cerca';

  @override
  String get apply => 'Applica';

  @override
  String get setupCachingTitle => 'Caricamento delle tue ricette';

  @override
  String get setupCachingSubtitle =>
      'Le tue ricette vengono preparate per l\'uso offline. A seconda di quante sono, potrebbe volerci un momento.';

  @override
  String get setupCachingDone => 'Tutto pronto!';

  @override
  String get setupTipsHeader => 'Lo sapevi?';

  @override
  String get setupFinish => 'Iniziamo';

  @override
  String get setupSkipCaching => 'Continua in background';

  @override
  String get setupTip1 =>
      'Puoi importare ricette da un link, una foto o un PDF — tramite il riquadro Importa nella schermata iniziale.';

  @override
  String get setupTip2 =>
      'La modalità cucina mantiene lo schermo acceso, ti guida passo dopo passo e riconosce automaticamente i timer nel testo.';

  @override
  String get setupTip3 =>
      'La lista della spesa funziona anche offline — le modifiche si sincronizzano automaticamente quando il server è raggiungibile.';

  @override
  String get setupTip4 =>
      'Tieni premuto un riquadro nella schermata iniziale per riordinare l\'accesso rapido.';

  @override
  String get setupTip5 =>
      'Trovi i tuoi ricettari Mealie nel riquadro Ricettari — anche offline.';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancella';

  @override
  String get delete => 'Elimina';

  @override
  String get edit => 'Modifica';

  @override
  String get save => 'Salva';

  @override
  String get done => 'Fatto';

  @override
  String get close => 'Chiudi';

  @override
  String get add => 'Aggiungi';

  @override
  String get send => 'Invia';

  @override
  String get retry => 'Riprova';

  @override
  String get confirmDeleteTitle => 'Eliminare la ricetta?';

  @override
  String get confirmDeleteMessage => 'Questa azione non può essere annullata.';

  @override
  String get sendToDevice => 'Invia al dispositivo';

  @override
  String get timerFinished => 'Timer terminato!';

  @override
  String get timer => 'Timer';

  @override
  String get newTimer => 'Nuovo timer';

  @override
  String get timerNamePlaceholder => 'Nome del timer';

  @override
  String get durationLabel => 'Durata';

  @override
  String get start => 'Inizia';

  @override
  String get stop => 'Ferma';

  @override
  String get pause => 'Pausa';

  @override
  String get resume => 'Riprendi';

  @override
  String get finished => 'Finito!';

  @override
  String stepNumber(int number) {
    return 'Passaggio $number';
  }

  @override
  String get minAbbreviation => 'min';

  @override
  String get cookingMode => 'Modalità cucina';

  @override
  String get endAll => 'Termina tutto';

  @override
  String get end => 'Termina';

  @override
  String get noActiveTimers => 'Nessun timer attivo';

  @override
  String get noActiveRecipes => 'Nessuna ricetta attiva';

  @override
  String get startRecipeToCook =>
      'Apri una ricetta e tocca il pulsante della modalità cucina per iniziare.';

  @override
  String get browseRecipes => 'Sfoglia ricette';

  @override
  String get cookFriends => 'Cucina con gli amici';

  @override
  String get cookingModeAddRecipe => 'Aggiungi ricetta';

  @override
  String get cookingModeAddRecipeSearchHint => 'Cerca ricette';

  @override
  String get cookFriendsCode => 'Codice sessione';

  @override
  String get cookFriendsJoin => 'Partecipa alla sessione';

  @override
  String get cookFriendsHost => 'Ospita sessione';

  @override
  String get cookFriendsHostNotFound =>
      'Host non trovato. Assicurati che entrambi i dispositivi siano sulla stessa rete Wi-Fi e che l\'accesso alla rete locale sia consentito.';

  @override
  String get cookFriendsConnectionFailed =>
      'Connessione non riuscita. Riprova.';

  @override
  String get cookFriendsEnterCode => 'Inserisci codice';

  @override
  String cookFriendsConnected(int count) {
    return 'Connessi: $count ospiti';
  }

  @override
  String get joinSession => 'Partecipa alla sessione';

  @override
  String get hostEndedSessionMessage =>
      'L\'host ha terminato la sessione di cucina.';

  @override
  String get addItem => 'Aggiungi articolo';

  @override
  String get itemNote => 'Nome articolo';

  @override
  String get unlabeledCategory => 'Senza etichetta';

  @override
  String get archivedLists => '📦 Acquisti archiviati';

  @override
  String get postimportAction => 'Dopo l\'importazione';

  @override
  String get postimportHint =>
      'Scegli cosa deve succedere nell\'app di origine (Promemoria / Google Tasks) alle voci importate.';

  @override
  String get postimportLeave => 'Aggiungi soltanto';

  @override
  String get postimportComplete => 'Spunta';

  @override
  String get postimportCompleteDelete => 'Spunta ed elimina';

  @override
  String get postimportFailed =>
      'L\'elaborazione nell\'app di origine non è riuscita. Gli articoli sono comunque stati aggiunti a Mealie.';

  @override
  String get syncChangesTitle => 'Sincronizza modifiche';

  @override
  String get syncSectionChecked => 'Spuntati';

  @override
  String get syncSectionQuantity => 'Quantità';

  @override
  String get syncSectionCategory => 'Categoria';

  @override
  String get syncSectionAdditions => 'Aggiunti di recente';

  @override
  String get syncLocalLabel => 'Locale';

  @override
  String get syncServerLabel => 'Server';

  @override
  String get syncNow => 'Sincronizza ora';

  @override
  String get offlineBadge => 'Offline';

  @override
  String get mealplanTitle => '📅 Piano alimentare';

  @override
  String get breakfast => 'Colazione';

  @override
  String get lunch => 'Pranzo';

  @override
  String get dinner => 'Cena';

  @override
  String get addMealEntry => 'Aggiungi pasto';

  @override
  String get selectRecipe => 'Seleziona ricetta';

  @override
  String get importRecipe => 'Importa ricetta';

  @override
  String get url => 'URL';

  @override
  String get importLanguage => 'Lingua per OCR';

  @override
  String get setupTitle => 'Benvenuto in Mealie Recipes';

  @override
  String get setupSubtitle => 'Configura il tuo server Mealie.';

  @override
  String get serverUrl => 'URL del server';

  @override
  String get serverUrlPlaceholder => 'https://mealie.example.com';

  @override
  String get apiToken => 'Token API';

  @override
  String get apiTokenPlaceholder => 'Il tuo token API';

  @override
  String get householdId => 'Famiglia';

  @override
  String get householdIdPlaceholder => 'Famiglia';

  @override
  String get shoppingListId => 'ID lista della spesa';

  @override
  String get setupHouseholdListTitle => 'Famiglia e lista della spesa';

  @override
  String get shoppingListLabel => 'Lista della spesa';

  @override
  String get setupHouseholdManualHint =>
      'Impossibile caricare le famiglie — inserisci il nome della famiglia manualmente.';

  @override
  String get setupExactTitle => 'Quantità nella lista della spesa';

  @override
  String get setupExactBody =>
      'Nella maggior parte dei paesi non si compra al grammo — si mette nel carrello 1 confezione di burro, non 200 g. In modalità semplice l\'app converte quindi le quantità delle ricette in “1×”. In modalità esatta quantità e unità restano 1:1 come nella web app di Mealie — anche quando si digitano nuovi articoli (es. “200 g burro”). Puoi cambiarlo in qualsiasi momento nelle impostazioni.';

  @override
  String get setupExactSimpleTitle => 'Modalità semplice (1×)';

  @override
  String get setupExactSimpleBody =>
      'Gli ingredienti finiscono nella lista come “1× articolo” — ideale per spuntare velocemente al negozio.';

  @override
  String get setupExactExactTitle => 'Quantità esatte';

  @override
  String get setupExactExactBody =>
      'Gli articoli compaiono con quantità e unità, es. “200 g burro” — esattamente come nella web app.';

  @override
  String get connect => 'Connetti';

  @override
  String connectionError(String error) {
    return 'Connessione non riuscita: $error';
  }

  @override
  String get optionalHeaders =>
      'Intestazioni HTTP facoltative (per reverse proxy)';

  @override
  String get settingsTitle => '⚙️ Impostazioni';

  @override
  String get settingsSaved => 'Impostazioni salvate';

  @override
  String get securitySettings => 'Sicurezza';

  @override
  String get showRecipeImages => 'Mostra immagini delle ricette';

  @override
  String get apiVersion => 'Versione API';

  @override
  String get language => 'Lingua';

  @override
  String get biometricLock => 'Blocco biometrico';

  @override
  String get biometricLockDescription => 'Sblocca l\'app con la biometria';

  @override
  String get enableLogging => 'Attiva registro';

  @override
  String get selectLanguage => 'Seleziona lingua';

  @override
  String get setupContinue => 'Continua';

  @override
  String get back => 'Indietro';

  @override
  String get setupConnectStep => 'Connettiti al tuo server';

  @override
  String get resetSettings => 'Ripristina tutte le impostazioni';

  @override
  String get resetSettingsConfirm =>
      'Tutte le impostazioni verranno ripristinate. Continuare?';

  @override
  String get guestMode => 'Modalità ospite';

  @override
  String get appVersion => 'Versione';

  @override
  String get leftoverFinder => 'Trova ricette';

  @override
  String get addIngredient => 'Aggiungi ingrediente';

  @override
  String get biometricPrompt => 'Autenticati per aprire Mealie Recipes';

  @override
  String get biometricFailed => 'Autenticazione non riuscita';

  @override
  String get pendingRecipesTitle => 'Ricette ricevute';

  @override
  String pendingRecipesFrom(Object names) {
    return 'Da $names';
  }

  @override
  String get pendingRecipesOpenCooking => 'Apri modalità cucina';

  @override
  String get dismiss => 'Ignora';

  @override
  String get editRecipe => 'Modifica ricetta';

  @override
  String get recipeName => 'Nome della ricetta';

  @override
  String get prepTime => 'Tempo di preparazione (min)';

  @override
  String get cookTime => 'Tempo di cottura (min)';

  @override
  String get totalTime => 'Tempo totale (min)';

  @override
  String get recipeServings => 'Porzioni';

  @override
  String get rating => 'Valutazione';

  @override
  String get addIngredientLine => 'Aggiungi ingrediente';

  @override
  String get addInstruction => 'Aggiungi passaggio';

  @override
  String get removeIngredient => 'Rimuovi ingrediente';

  @override
  String get removeInstruction => 'Rimuovi passaggio';

  @override
  String get ingredientName => 'Ingrediente';

  @override
  String get ingredientQuantity => 'Qtà';

  @override
  String get ingredientUnit => 'Unità';

  @override
  String get ingredientNote => 'Nota';

  @override
  String get instructionText => 'Testo del passaggio';

  @override
  String get categories => 'Categorie';

  @override
  String get saveChanges => 'Salva modifiche';

  @override
  String get saveSuccess => 'Ricetta salvata.';

  @override
  String get newCategory => 'Nuova categoria';

  @override
  String get newTag => 'Nuovo tag';

  @override
  String get setRating => 'Imposta valutazione';

  @override
  String get homeWelcome => 'Benvenuto in Mealie Recipes! 👋';

  @override
  String homeWelcomeNamed(String name) {
    return 'Benvenuto $name, in Mealie Recipes! 👋';
  }

  @override
  String get shopping => 'Spesa';

  @override
  String get planning => 'Pianificazione';

  @override
  String get other => 'Altro';

  @override
  String get addRecipe => '➕ Aggiungi ricetta';

  @override
  String get completeShopping => 'Completa la spesa';

  @override
  String get shoppingCompleted => 'Spesa completata';

  @override
  String get shoppingCompletedSubtitle => 'Tutto nel carrello! 🎉';

  @override
  String get shoppingOfflineNoCache => 'Offline – lista non salvata';

  @override
  String get shoppingOfflineNoCacheSubtitle =>
      'Nessun articolo di questa lista è ancora salvato su questo dispositivo. Verrà caricata appena torni online.';

  @override
  String get essensplan => '📅 Piano alimentare';

  @override
  String get resteverwertung => '🥗 Cerca ricette';

  @override
  String get copyCode => 'Copia codice';

  @override
  String get shareLink => 'Condividi link';

  @override
  String get connectedFriends => 'Amici connessi';

  @override
  String get waitingForFriends => 'In attesa degli amici...';

  @override
  String get sessionCode => 'CODICE SESSIONE';

  @override
  String get loading => 'Caricamento...';

  @override
  String get urlInvalidScheme => 'L\'URL deve iniziare con http:// o https://';

  @override
  String get urlAddScheme => 'Aggiungi https://';

  @override
  String get addItemPlaceholder => 'Aggiungi articolo...';

  @override
  String get completedItems => 'Completati';

  @override
  String get completeShoppingTitle => 'Completare la spesa?';

  @override
  String get completeShoppingMessage => 'Eliminare gli articoli completati?';

  @override
  String get recipeListTitle => '📖 Ricette';

  @override
  String get importRecipeTitle => 'Carica nuova ricetta';

  @override
  String get uploadRecipeUrl => 'Importa da URL della ricetta';

  @override
  String get uploadRecipeUrlHint =>
      'Inserisci l\'URL della ricetta per salvarla sul tuo server';

  @override
  String get uploadOpenAI => 'Importa da file tramite OpenAI';

  @override
  String get uploadOpenAIHint =>
      'In alternativa carica foto o un PDF di una ricetta. Se la ricetta occupa più pagine, aggiungine semplicemente più di una — vengono analizzate insieme dall\'IA.';

  @override
  String get takePhoto => 'Fotocamera';

  @override
  String get cameraPermissionDenied =>
      'Nessun accesso alla fotocamera. Consentilo nelle impostazioni di sistema per fotografare le ricette.';

  @override
  String get cameraUnavailable =>
      'Nessuna fotocamera disponibile su questo dispositivo.';

  @override
  String get selectPhoto => 'Foto';

  @override
  String get selectPdf => 'PDF';

  @override
  String get openAIHintTitle => 'Info sull\'analisi dei file';

  @override
  String get openAIHintBody =>
      'L\'analisi della ricetta usa l\'API di OpenAI. Assicurati che la chiave API sia configurata nelle impostazioni del server Mealie.';

  @override
  String get allDeleteConfirm => 'Elimina tutto';

  @override
  String get entriesInOtherWeeks => 'Ci sono voci in altre settimane';

  @override
  String get availableWeeks => 'Settimane disponibili:';

  @override
  String get currentWeek => 'Settimana corrente';

  @override
  String get weekAbbreviation => 'Sett.';

  @override
  String get today => 'Oggi';

  @override
  String get selectDate => 'Seleziona data';

  @override
  String get selectedRecipe => 'Ricetta selezionata';

  @override
  String get confirmMeal => 'Pianifica pasto';

  @override
  String get searchRecipes => 'Cerca ricette';

  @override
  String get addCustomMeal => 'Aggiungi pasto personalizzato';

  @override
  String get diceModeButton => 'Tira ricette a caso';

  @override
  String get diceModeTitle => '3 suggerimenti casuali';

  @override
  String get diceBackToSearch => 'Torna alla ricerca';

  @override
  String get diceNotEnoughRecipes =>
      'Ricette insufficienti per il dado (servono almeno 3)';

  @override
  String get entrySingular => 'voce';

  @override
  String get entriesPlural => 'voci';

  @override
  String get deleteAllConfirmTitle => 'Eliminare tutto?';

  @override
  String get deleteAllConfirmMessage =>
      'Vuoi eliminare tutti gli acquisti archiviati?';

  @override
  String get uploadFromUrlButton => 'Importa ricetta da URL';

  @override
  String get uploadingImage => 'Caricamento...';

  @override
  String get uploadErrorTitle => 'Caricamento non riuscito';

  @override
  String get uploadSuccessTitle => 'Caricamento riuscito';

  @override
  String get editImportedRecipeQuestion =>
      'Vuoi modificare subito la nuova ricetta?';

  @override
  String get notNow => 'Non ora';

  @override
  String get pdfTooLarge => 'Il file PDF è troppo grande (max 10 MB).';

  @override
  String get invalidUrl => 'URL non valido. Inserisci un URL HTTP(S) valido.';

  @override
  String get cookWithFriends => 'Cucina con gli amici';

  @override
  String get cookFriendsSubtitle =>
      'Invita un amico a cucinare questa ricetta insieme';

  @override
  String get copied => 'Copiato';

  @override
  String get linkCopied => 'Link copiato';

  @override
  String get startCooking => 'Inizia a cucinare';

  @override
  String get uploadToOwnServer => 'Salva sul mio server';

  @override
  String get uploadingRecipe => 'Caricamento ricetta…';

  @override
  String get recipeUploadedToOwnServer => 'Ricetta salvata sul tuo server';

  @override
  String get recipeUploadFailed => 'Caricamento non riuscito';

  @override
  String get allowGuestSaveRecipes =>
      'Consenti agli ospiti di salvare le ricette sul proprio server';

  @override
  String get appIcon => 'Icona dell\'app';

  @override
  String get name => 'Nome';

  @override
  String get color => 'Colore';

  @override
  String get randomColor => 'Colore casuale';

  @override
  String get createFailed => 'Impossibile creare';

  @override
  String get deleteFailed => 'Impossibile eliminare';

  @override
  String deleteOrganizerConfirm(String name) {
    return 'Eliminare “$name”? Verrà rimosso anche sul server.';
  }

  @override
  String get connectionSection => 'Connessione';

  @override
  String get token => 'Token';

  @override
  String get advancedOptions => 'Opzioni avanzate';

  @override
  String get mealieApiVersion => 'Versione API di Mealie';

  @override
  String get sendOptionalHeaders => 'Invia intestazioni facoltative';

  @override
  String get offlineRecipeImages => 'Salva le immagini delle ricette offline';

  @override
  String get offlineRecipeImagesHint =>
      'Scarica tutte le immagini delle ricette sul dispositivo – comprese quelle nei passaggi e nelle note – così si vedono anche senza connessione. Le raccolte grandi possono occupare diverse centinaia di MB. Disattivando l\'opzione le immagini salvate vengono eliminate.';

  @override
  String offlineRecipeImagesStatus(int count, int total, String size) {
    return 'Salvate: $count/$total · $size';
  }

  @override
  String get offlineRecipeImagesDisableConfirm =>
      'Eliminare tutte le immagini delle ricette salvate?';

  @override
  String headerNameLabel(int n) {
    return 'Nome intestazione $n';
  }

  @override
  String headerValueLabel(int n) {
    return 'Valore intestazione $n';
  }

  @override
  String get value => 'Valore';

  @override
  String get personalization => 'Personalizzazione';

  @override
  String get showRecipeImagesSubtitle =>
      'Mostra le immagini nell\'elenco delle ricette';

  @override
  String get exactQuantities => 'Aggiungi quantità esatte';

  @override
  String get exactQuantitiesSubtitle =>
      'Ingredienti e articoli digitati mantengono quantità e unità (es. 200 g burro) invece di 1× per articolo';

  @override
  String get remindToShop => 'Ricordami di fare la spesa';

  @override
  String get remindToShopSubtitle =>
      'Ti avvisa quando sei vicino a un luogo salvato e la lista della spesa ha articoli aperti — anche ad app chiusa';

  @override
  String get shoppingReminderAddLocation => 'Aggiungi luogo';

  @override
  String get shoppingReminderMaxLocations => 'Raggiunto il massimo di 3 luoghi';

  @override
  String get shoppingReminderLocationServiceDisabled =>
      'I servizi di localizzazione sono disattivati su questo dispositivo';

  @override
  String get shoppingReminderPermissionTitle =>
      'Serve l\'accesso alla posizione';

  @override
  String get shoppingReminderPermissionMessage =>
      'Per ricordarti quando sei vicino a un negozio serve l\'accesso alla posizione “Sempre” — anche ad app chiusa. Attivalo nelle Impostazioni.';

  @override
  String get openSettings => 'Apri Impostazioni';

  @override
  String get shoppingReminderLocationName => 'Nome';

  @override
  String get shoppingReminderUseCurrentLocation => 'Usa posizione attuale';

  @override
  String get shoppingReminderOrAddress => 'oppure inserisci un indirizzo';

  @override
  String get shoppingReminderAddress => 'Indirizzo';

  @override
  String get shoppingReminderAddressPlaceholder => 'Via, città';

  @override
  String get shoppingReminderSearchAddress => 'Cerca';

  @override
  String get shoppingReminderLocationFailed =>
      'Impossibile determinare la tua posizione';

  @override
  String get shoppingReminderAddressNotFound => 'Indirizzo non trovato';

  @override
  String get ratingFailed => 'Impossibile salvare la valutazione — riprova.';

  @override
  String get lastCooked => 'Ultima preparazione';

  @override
  String get syncLastCooked => 'Aggiorna “ultima preparazione”';

  @override
  String get syncLastCookedSubtitle =>
      'Salva la data di oggi e una voce nella linea temporale sul server — come la web app di Mealie.';

  @override
  String get developer => 'Sviluppatore';

  @override
  String get enableLoggingSubtitle =>
      'Registra i log di stampa/errori (ultime 500 righe)';

  @override
  String get entriesLabel => 'Voci';

  @override
  String get fileSize => 'Dimensione file';

  @override
  String get showAction => 'Mostra';

  @override
  String get copy => 'Copia';

  @override
  String logsWithCount(int count) {
    return 'Log ($count)';
  }

  @override
  String get noLogs => 'Nessun log disponibile';

  @override
  String get logsTitle => 'Log';

  @override
  String get required => 'Obbligatorio';

  @override
  String get connectionFailedCheck =>
      'Connessione non riuscita. Controlla URL e token.';

  @override
  String get username => 'Nome Utente';

  @override
  String get password => 'Password';

  @override
  String get setupPasswordHint =>
      'La password non viene salvata — l\'app accede una volta e genera da essa un token API (come Profilo → Token API nella web app).';

  @override
  String get loginAndConnect => 'Accedi e connetti';

  @override
  String get loginInvalidCredentials => 'Nome utente o password errati.';

  @override
  String get apiTokenSaveHint =>
      'Token applicato — tocca “Salva modifiche” qui sotto.';

  @override
  String get renewApiToken => 'Rinnova token API';

  @override
  String get setupAuthChoiceTitle => 'Come vuoi accedere?';

  @override
  String get authModePasswordTitle =>
      'Lascia che l\'app crei una chiave API per me';

  @override
  String get authModePasswordSubtitle =>
      'Accedi con nome utente e password — l\'app genera un token automaticamente.';

  @override
  String get authModeTokenTitle => 'Ho già una chiave API';

  @override
  String get authModeTokenSubtitle =>
      'Copiata dal profilo Mealie (Profilo → Token API).';

  @override
  String keyN(int n) {
    return 'Chiave $n';
  }

  @override
  String valueN(int n) {
    return 'Valore $n';
  }

  @override
  String get openCookingMode => 'Apri modalità cucina';

  @override
  String activeRecipes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ricette attive',
      one: '1 ricetta attiva',
    );
    return '$_temp0';
  }

  @override
  String get reparseIngredients => 'Analizza di nuovo gli ingredienti';

  @override
  String get reparseIngredientsSubtitle =>
      'Separa quantità/unità/ingrediente (es. “200 g farina”)';

  @override
  String get reparseDone =>
      'Ingredienti separati – tocca “Salva modifiche” per applicare';

  @override
  String get tagsAndCategories => 'Tag, categorie e strumenti';

  @override
  String get tapToAddPhoto => 'Tocca per aggiungere una foto';

  @override
  String get descriptionLabel => 'Descrizione';

  @override
  String get searchingDevices =>
      'Ricerca di dispositivi sulla stessa rete Wi-Fi…';

  @override
  String get selectAll => 'Seleziona tutto';

  @override
  String get importReminders => 'Importa promemoria';

  @override
  String get importGoogleTasks => 'Importa Google Tasks';

  @override
  String get noTaskLists => 'Nessun elenco di attività trovato';

  @override
  String get noReminderLists => 'Nessun elenco di promemoria trovato';

  @override
  String importCount(int count) {
    return 'Importa $count';
  }

  @override
  String get noIngredientsToLink => 'Ancora nessun ingrediente da collegare';

  @override
  String get importLanguageSubtitle =>
      'Lingua per le ricette importate da foto o PDF';

  @override
  String get importLanguageSearch => 'Cerca lingua';

  @override
  String get importLanguageFollowApp => 'Come la lingua dell\'app';

  @override
  String get importLanguageNoMatch => 'Nessuna lingua trovata';

  @override
  String get setupImportLanguageTitle => 'Importazione ricette con IA';

  @override
  String get setupImportLanguageBody =>
      'Foto e PDF possono essere trasformati in ricette dall\'IA. Scegli la lingua in cui devono risultare — utile se la tua lingua madre non è disponibile come lingua dell\'app. Puoi cambiarla in seguito nelle impostazioni.';

  @override
  String get setupImportLanguageSearchHint =>
      'Usa la ricerca nel selettore per trovare lingue che l\'interfaccia dell\'app non offre.';

  @override
  String get setupCachingKeepOpenTitle => 'Tieni aperta l\'app';

  @override
  String get setupCachingKeepOpenBody =>
      'Il caricamento avviene in primo piano. Lascia l\'app aperta finché non termina — se la chiudi o passi ad altro troppo a lungo, il processo si interrompe e riparte più tardi.';

  @override
  String get supportContact => 'Contatta il supporto';

  @override
  String get supportDialogMessage =>
      'Descrivi il tuo problema e ti risponderemo. Il log aiuta molto a trovare l\'errore — puoi allegarlo come file di testo.';

  @override
  String get supportWithoutLogs => 'Senza log';

  @override
  String get supportWithLogs => 'Allega log';

  @override
  String get supportMailSubject => 'Mealie Recipes — Supporto';

  @override
  String get supportMailHint => 'Descrivi qui il tuo problema:';

  @override
  String get supportLogsEmpty =>
      'Il log è vuoto. Attiva il registro, riproduci il problema e poi invialo.';

  @override
  String supportAddressCopied(String email) {
    return 'Indirizzo copiato: $email';
  }

  @override
  String supportNoMailApp(String email) {
    return 'Nessuna app di posta configurata – indirizzo copiato: $email. Scegli un\'altra app per scriverci.';
  }

  @override
  String get createRecipeFromImages => 'Crea ricetta';

  @override
  String imagePagesSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pagine selezionate',
      one: '1 pagina selezionata',
    );
    return '$_temp0';
  }

  @override
  String get imagePagesHint =>
      'La prima immagine diventa l\'immagine principale della ricetta. Tieni premuta una pagina per riordinarla.';

  @override
  String get mainImageBadge => 'Principale';

  @override
  String maxImagesReached(int max) {
    return 'Puoi aggiungere fino a $max immagini per ricetta.';
  }

  @override
  String get removePage => 'Rimuovi pagina';

  @override
  String get preparingPdf => 'Elaborazione PDF...';

  @override
  String get recipeOptionsTitle => 'Opzioni';

  @override
  String get exportAsPdf => 'Esporta come PDF';

  @override
  String get generatingPdf => 'Creazione PDF…';

  @override
  String get pdfExportFailed => 'Esportazione PDF non riuscita';

  @override
  String get recipeTime => 'Tempo';

  @override
  String get addIngredientSection => 'Aggiungi sezione';

  @override
  String get aiImportToggle => 'Analizza con IA';

  @override
  String get aiImportToggleHint =>
      'Anche per video di ricette (YouTube, Instagram, TikTok …) e pagine che l\'importazione normale non riesce a leggere. Richiede un provider IA sul server Mealie — per i video anche un provider audio.';

  @override
  String get aiImportButton => 'Importa con AI';

  @override
  String get aiImportRunning =>
      'L\'IA sta analizzando il link … i video possono richiedere qualche minuto.';

  @override
  String get aiImportFailed =>
      'Importazione con IA non riuscita. Controlla le impostazioni IA del server Mealie.';

  @override
  String get stepHeadingLabel => 'Titolo del passaggio (facoltativo)';

  @override
  String get linkedRecipeLabel => 'Ricetta collegata';

  @override
  String get toolsTitle => 'Strumenti';

  @override
  String get prepareTools => 'Prepara i seguenti strumenti';

  @override
  String get newTool => 'Nuovo strumento';

  @override
  String get renameAction => 'Rinomina';

  @override
  String get organizerEmpty =>
      'Ancora niente qui. Tocca “+” in alto a destra per crearne uno.';

  @override
  String organizerRecipeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ricette',
      one: '1 ricetta',
      zero: 'Nessuna ricetta',
    );
    return '$_temp0';
  }

  @override
  String get toolOnHand => 'Disponibile';

  @override
  String get mealDiceSettingsHint =>
      'Scegli categorie e tag per ogni pasto. Tirando il dado vengono proposte solo ricette con almeno uno di essi. La stessa voce può essere usata per più pasti.';

  @override
  String get mealDiceSettingsNoneHint =>
      'Niente selezionato per questo pasto: il dado sceglie automaticamente in base a nomi di categoria come “Colazione”, “Pranzo” o “Cena”.';

  @override
  String get mealDiceAutoHintTitle => 'Selezione automatica';

  @override
  String get mealDiceAutoHintBody =>
      'Per questo pasto non sono ancora impostate categorie o tag. Il dado cerca quindi categorie come “Colazione”, “Pranzo” o “Cena” e completa con altre ricette.\n\nPer sceglierle tu: nel piano alimentare tocca l\'icona a ingranaggio accanto a “+”.';

  @override
  String get dontShowAgain => 'Non mostrare più';

  @override
  String get mealDiceNoMatches =>
      'Nessuna ricetta corrisponde alle categorie e ai tag scelti per questo pasto.';

  @override
  String mealDiceFewMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Solo $count ricette corrispondenti',
      one: 'Solo 1 ricetta corrispondente',
    );
    return '$_temp0';
  }

  @override
  String get commentsTitle => 'Commenti';

  @override
  String get commentHint => 'Scrivi un commento…';

  @override
  String get commentSaveFailed => 'Impossibile salvare il commento.';

  @override
  String get commentDeleteConfirm => 'Eliminare questo commento?';

  @override
  String get cookingDoneCommentLabel => 'Commento (facoltativo)';

  @override
  String get cookingDoneCommentHint =>
      'Com\'è venuto? Consigli per la prossima volta…';

  @override
  String get nutritionTitle => 'Nutrienti';

  @override
  String get nutritionPerServing => 'per porzione';

  @override
  String get nutritionCalories => 'Calorie';

  @override
  String get nutritionFat => 'Grassi';

  @override
  String get nutritionSaturatedFat => 'Grassi saturi';

  @override
  String get nutritionTransFat => 'Grassi trans';

  @override
  String get nutritionUnsaturatedFat => 'Grassi insaturi';

  @override
  String get nutritionCholesterol => 'Colesterolo';

  @override
  String get nutritionSodium => 'Sodio';

  @override
  String get nutritionCarbohydrates => 'Carboidrati';

  @override
  String get nutritionFiber => 'Fibre';

  @override
  String get nutritionSugar => 'Zuccheri';

  @override
  String get nutritionProtein => 'Proteine';

  @override
  String get timelineTitle => 'Linea temporale';

  @override
  String get timelineMadeThis => 'L\'ho preparato';

  @override
  String timelineUserMadeThis(String name) {
    return '$name l\'ha preparato';
  }

  @override
  String get timelineEmpty => 'Ancora nessuna voce nella linea temporale.';

  @override
  String get timelineDate => 'Data';

  @override
  String get timelineNoteHint => 'Nota (facoltativa)';

  @override
  String get timelineAddPhoto => 'Aggiungi foto';

  @override
  String get timelineRemovePhoto => 'Rimuovi foto';

  @override
  String get timelineSaved => 'Aggiunto alla linea temporale';

  @override
  String get timelineSaveFailed =>
      'Impossibile aggiungere alla linea temporale';

  @override
  String get timelineImageFailed =>
      'Voce salvata, ma non è stato possibile caricare la foto';

  @override
  String get timelineDeleteConfirm =>
      'Eliminare questa voce dalla linea temporale?';

  @override
  String get timelineEditNote => 'Modifica nota';

  @override
  String get timelineUnknownRecipe => 'Ricetta non trovata';

  @override
  String get cookingDonePhotoHint =>
      'Foto per la linea temporale di Mealie (facoltativa)';

  @override
  String get assetsTitle => 'Risorse';

  @override
  String get assetsAdd => 'Aggiungi risorsa';

  @override
  String get assetsChooseFile => 'File';

  @override
  String get assetsUploading => 'Caricamento…';

  @override
  String get assetsUploadFailed => 'Impossibile caricare la risorsa';

  @override
  String assetsDeleteConfirm(String name) {
    return 'Rimuovere “$name” dalle risorse?';
  }

  @override
  String get assetsOpenFailed => 'Impossibile aprire la risorsa';

  @override
  String get assetsUnsupported =>
      'Mealie supporta solo PDF, immagini, TXT, MD, CSV e JSON.';

  @override
  String get assetsShare => 'Condividi';

  @override
  String get mealRulesTitle => 'Regole di Mealie';

  @override
  String get mealRulesHint =>
      'Usate anche dalla web app di Mealie. Se più regole valgono per il giorno e il pasto, devono corrispondere tutte. Se nessuna regola vale, il dado sceglie tra tutte le ricette.';

  @override
  String get mealRuleAdd => 'Aggiungi regola';

  @override
  String get mealRuleNewTitle => 'Nuova regola';

  @override
  String get mealRuleEditTitle => 'Modifica regola';

  @override
  String get mealRuleDay => 'Giorno';

  @override
  String get mealRuleAnyDay => 'Qualsiasi giorno';

  @override
  String get mealRuleMealType => 'Pasto';

  @override
  String get mealRuleAnyMeal => 'Qualsiasi pasto';

  @override
  String get mealRuleConditionsTitle => 'Condizioni';

  @override
  String get mealRuleAllRecipes => 'Tutte le ricette';

  @override
  String get mealRuleDeleteConfirm => 'Eliminare questa regola?';

  @override
  String get mealRulesOffline =>
      'Le regole di Mealie non sono disponibili al momento – il dado usa la selezione dell\'app.';

  @override
  String get mealRulesNoMatches =>
      'Nessuna ricetta corrisponde alle regole di Mealie per questo pasto.';

  @override
  String get mealTypeSide => 'Contorno';

  @override
  String get mealTypeSnack => 'Spuntino';

  @override
  String get mealTypeDrink => 'Bevanda';

  @override
  String get mealTypeDessert => 'Dolce';

  @override
  String get foodsTitle => 'Alimenti';

  @override
  String get unitsTitle => 'Unità';

  @override
  String get newFood => 'Nuovo alimento';

  @override
  String get newUnit => 'Nuova unità';

  @override
  String get editFood => 'Modifica alimento';

  @override
  String get editUnit => 'Modifica unità';

  @override
  String get pluralNameLabel => 'Nome al plurale';

  @override
  String get abbreviationLabel => 'Abbreviazione';

  @override
  String get pluralAbbreviationLabel => 'Abbreviazione al plurale';

  @override
  String get mergeAction => 'Unisci';

  @override
  String mergeIntoTitle(String name) {
    return 'Unisci “$name” in…';
  }

  @override
  String mergeConfirm(String from, String to) {
    return '“$from” verrà unito a “$to”: tutte le ricette e le liste della spesa useranno poi “$to” e “$from” verrà eliminato.';
  }

  @override
  String get mergeFailed => 'Unione non riuscita';

  @override
  String foodUnitDeleteConfirm(String name) {
    return 'Eliminare “$name”? Gli ingredienti che lo usano perderanno il riferimento.';
  }

  @override
  String get foodsUnitsEmpty => 'Ancora nessuna voce.';

  @override
  String mealRuleConditionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count condizioni',
      one: '1 condizione',
    );
    return '$_temp0';
  }

  @override
  String get showAll => 'Mostra tutto';

  @override
  String get mealDiceModeTitle => 'Il dado usa';

  @override
  String get mealDiceModeApp => 'Selezione dell\'app';

  @override
  String get switchListTitle => 'Cambia lista';

  @override
  String get newShoppingList => 'Nuova lista della spesa';

  @override
  String shoppingListDeleteConfirm(String name) {
    return 'Eliminare “$name”? Verranno eliminati anche tutti i suoi articoli.';
  }

  @override
  String get labelOrderTitle => 'Ordina etichette';

  @override
  String get labelOrderHint =>
      'Trascina per ordinare. Vale per questa lista – anche nella web app di Mealie.';

  @override
  String get labelOrderEmpty => 'Questa lista non ha ancora etichette.';

  @override
  String get useAsActiveList => 'Usa come lista attiva';

  @override
  String get activeListBadge => 'Attiva';

  @override
  String get foodLabelLabel => 'Etichetta';

  @override
  String get foodNoLabel => 'Nessuna etichetta';

  @override
  String get aliasesLabel => 'Alias';

  @override
  String get aliasAddHint => 'Aggiungi alias';

  @override
  String get foodOnHand => 'Disponibile in famiglia';

  @override
  String get timelineChildRecipesTitle =>
      'Aggiungi anche per le ricette collegate';

  @override
  String timelineMadeForRecipe(String recipe) {
    return 'Creato per $recipe';
  }

  @override
  String get timelineFilter => 'Filtra voci';

  @override
  String get timelineTypeComment => 'Preparazioni e note';

  @override
  String get timelineTypeInfo => 'Info';

  @override
  String get timelineTypeSystem => 'Sistema';

  @override
  String get listManagementTitle => 'Liste della spesa';

  @override
  String get managementTitle => 'Altro';

  @override
  String get pinToHome => 'Aggiungi alla schermata Home';

  @override
  String get unpinFromHome => 'Rimuovi dalla schermata Home';

  @override
  String homeScreenFull(int count) {
    return 'La schermata Home è piena – al massimo $count riquadri. Rimuovi prima un altro riquadro in “Altro”.';
  }

  @override
  String get selectAction => 'Seleziona';

  @override
  String selectedCount(int count) {
    return '$count selezionati';
  }

  @override
  String get assignLabelAction => 'Assegna etichetta';

  @override
  String get assignLabelOverwriteHint =>
      'Sovrascrive l\'etichetta di tutti gli alimenti selezionati.';

  @override
  String deleteSelectedConfirm(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Eliminare $count voci?',
      one: 'Eliminare 1 voce?',
    );
    return '$_temp0';
  }

  @override
  String get seedDataAction => 'Carica dati predefiniti';

  @override
  String get seedFoodsHint =>
      'Crea gli alimenti predefiniti di Mealie nella lingua selezionata.';

  @override
  String get seedUnitsHint =>
      'Crea le unità predefinite di Mealie nella lingua selezionata.';

  @override
  String get seedLanguageLabel => 'Lingua';

  @override
  String get seedDuplicateWarning =>
      'Hai già delle voci. Mealie non gestisce i duplicati – dovrai unirli tu in seguito.';

  @override
  String get seedDone => 'Dati predefiniti creati';

  @override
  String get seedFailed => 'Impossibile caricare i dati predefiniti';

  @override
  String get exportAction => 'Esporta';

  @override
  String get substitutionsLabel => 'Sostituti';

  @override
  String get substitutionAddHint => 'Aggiungi sostituto';

  @override
  String get substitutionFoodLabel => 'Alimento (facoltativo)';

  @override
  String get substitutionNoteLabel => 'Nota (facoltativa)';

  @override
  String get substitutionNeedOne => 'Inserisci un alimento o una nota';

  @override
  String get useAbbreviationLabel => 'Usa abbreviazione';

  @override
  String get useAbbreviationHint =>
      'Mostra “g” invece di “grammo” nelle ricette';

  @override
  String get fractionLabel => 'Mostra come frazione';

  @override
  String get fractionHint => '½ invece di 0,5';

  @override
  String get standardizationTitle => 'Standardizzazione';

  @override
  String get standardizationHint =>
      'Per le conversioni: 1 di questa unità equivale a … (es. 1 cucchiaio = 15 millilitri).';

  @override
  String get standardQuantityLabel => 'Quantità standard';

  @override
  String get standardUnitLabel => 'Unità standard';

  @override
  String get standardUnitNone => 'Nessuno';

  @override
  String get stdFluidOunce => 'Oncia liquida (fl oz)';

  @override
  String get stdCup => 'Tazza (US)';

  @override
  String get stdOunce => 'Oncia (oz)';

  @override
  String get stdPound => 'Libbra (lb)';

  @override
  String get stdMilliliter => 'Millilitro';

  @override
  String get stdLiter => 'Litro';

  @override
  String get stdGram => 'Grammo';

  @override
  String get stdKilogram => 'Chilogrammo';

  @override
  String get labelsTitle => 'Etichette';

  @override
  String get newLabel => 'Nuova etichetta';

  @override
  String get editLabel => 'Modifica etichetta';

  @override
  String get colorLabel => 'Colore';

  @override
  String labelDeleteConfirm(String name) {
    return 'Eliminare “$name”? Articoli e alimenti perderanno questa etichetta.';
  }

  @override
  String get importMenuAction => 'Importa';

  @override
  String get archivedEmpty =>
      'Ancora nessun acquisto archiviato. Dopo la spesa tocca “Completa la spesa” – gli articoli spuntati verranno salvati qui.';

  @override
  String get sectionTitleLabel => 'Titolo della sezione';

  @override
  String get clearSection => 'Rimuovi sezione';

  @override
  String get noPermissionGeneric =>
      'Non hai l\'autorizzazione per questo in Mealie. Chiedi a un amministratore o al gestore della famiglia.';

  @override
  String get noPermissionEditRecipe =>
      'Non puoi modificare questa ricetta – è bloccata o appartiene a un\'altra famiglia. Può farlo solo chi l\'ha creata o un amministratore.';

  @override
  String get noPermissionDeleteRecipe =>
      'Solo chi ha creato la ricetta o un amministratore può eliminarla.';

  @override
  String get noPermissionDemoteSelf =>
      'Non puoi rimuovere i tuoi diritti di amministratore.';

  @override
  String get recipeLockedHint =>
      'Bloccata – può modificarla solo chi l\'ha creata';

  @override
  String get recipeDeleteOwnerOnlyHint =>
      'Può eliminarla solo chi l\'ha creata o un amministratore';

  @override
  String get organizeReadOnlyHint =>
      'Sola lettura: creare, modificare ed eliminare richiede l\'autorizzazione “L\'utente può gestire alimenti, tag e categorie”.';

  @override
  String get notesNotSavedNoPermission =>
      'Nota non salvata – non hai l\'autorizzazione per modificare questa ricetta.';

  @override
  String get userManagementTitle => 'Gestione Utenti';

  @override
  String get editUserTitle => 'Modifica Utente';

  @override
  String get fullNameLabel => 'Nome';

  @override
  String get usernameLabel => 'Nome Utente';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get householdLabel => 'Famiglia';

  @override
  String get permissionsTitle => 'Permessi';

  @override
  String get administratorLabel => 'Amministratore';

  @override
  String get permCanInvite => 'L\'utente può invitare altre persone nel gruppo';

  @override
  String get permCanManage =>
      'L\'utente può gestire le impostazioni del gruppo';

  @override
  String get permCanManageHousehold => 'L\'utente può gestire la famiglia';

  @override
  String get permCanOrganize =>
      'L\'utente può gestire alimenti, tag e categorie';

  @override
  String get advancedFeaturesLabel => 'Abilita funzionalità avanzate';

  @override
  String get passwordResetLinkAction => 'Genera Link Di Reset Password';

  @override
  String get resetLockedUsersAction => 'Ripristina Utenti Bloccati';

  @override
  String get inviteLinkTitle => 'Collegamento d\'invito';

  @override
  String get inviteAction => 'Invita';

  @override
  String get userUpdated => 'Utente Aggiornato';

  @override
  String get createUserTitle => 'Crea utente';

  @override
  String get userCreated => 'Utente creato';

  @override
  String userDeleteConfirm(String name) {
    return 'Eliminare “$name”? L\'account verrà rimosso da Mealie.';
  }

  @override
  String get passwordResetLinkCopied =>
      'Link copiato – passalo all\'utente. È valido solo per un tempo limitato.';

  @override
  String lockedUsersReset(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count utenti sbloccati',
      one: '1 utente sbloccato',
      zero: 'Nessun utente bloccato',
    );
    return '$_temp0';
  }

  @override
  String get inviteUsesLabel => 'Numero di utilizzi';

  @override
  String get inviteCreated => 'Link di invito creato';

  @override
  String get inviteEmailHint =>
      'Indirizzo email (facoltativo – Mealie invierà l\'invito)';

  @override
  String get inviteEmailSent => 'Invito inviato via email';

  @override
  String get inviteEmailFailed =>
      'Impossibile inviare l\'email (SMTP è configurato in Mealie?). Il link funziona comunque.';

  @override
  String get copyLinkAction => 'Copia link';

  @override
  String get youLabel => 'Tu';

  @override
  String get membersPermissionsHint =>
      'Puoi cambiare le autorizzazioni dei membri della tua famiglia – ma non le tue.';

  @override
  String get householdManagementTitle => 'Gestione Famiglia';

  @override
  String get householdsTitle => 'Famiglie';

  @override
  String get createHouseholdTitle => 'Crea Famiglia';

  @override
  String get householdNameLabel => 'Nome Famiglia';

  @override
  String get householdPreferencesTitle => 'Preferenze Della Famiglia';

  @override
  String get privateHouseholdLabel => 'Famiglia Privata';

  @override
  String get privateHouseholdHint =>
      'Impostare la famiglia in privato disabiliterà tutte le opzioni di visualizzazione pubblica. Questo sovrascrive le impostazioni di visualizzazione pubblica';

  @override
  String get lockRecipeEditsLabel =>
      'Blocca le modifiche della ricetta da altre famiglie';

  @override
  String get lockRecipeEditsHint =>
      'Quando abilitato, solo gli utenti della famiglia possono modificare le ricette create dalla tua famiglia';

  @override
  String get householdRecipePreferencesTitle =>
      'Preferenze Della Ricetta Della Famiglia';

  @override
  String get groupsTitle => 'Gruppi';

  @override
  String get groupLabel => 'Gruppo';

  @override
  String get createGroupTitle => 'Crea Gruppo';

  @override
  String get groupNameLabel => 'Nome Gruppo';

  @override
  String get groupPreferencesTitle => 'Preferenze Gruppo';

  @override
  String get privateGroupLabel => 'Gruppo Privato';

  @override
  String get privateGroupHint =>
      'Impostare il tuo gruppo in privato disabiliterà tutte le opzioni di visualizzazione pubblica. Questo sovrascrive le impostazioni di visualizzazione pubblica';

  @override
  String get firstDayOfWeekLabel => 'Primo giorno della settimana';

  @override
  String get showAnnouncementsLabel => 'Mostra annunci da Mealie';

  @override
  String get recipePublicDefaultLabel =>
      'Consenti agli utenti al di fuori del tuo gruppo di vedere le tue ricette';

  @override
  String get recipeShowNutritionDefaultLabel =>
      'Mostra informazioni nutrizionali';

  @override
  String get recipeShowAssetsDefaultLabel => 'Mostra risorse ricetta';

  @override
  String get recipeLandscapeDefaultLabel =>
      'Visualizzazione predefinita in orizzontale';

  @override
  String get recipeDisableCommentsDefaultLabel =>
      'Impedisci agli utenti di commentare le ricette';

  @override
  String get myHouseholdSection => 'La mia famiglia';

  @override
  String get myGroupSection => 'Il mio gruppo';

  @override
  String get preferencesSaved => 'Impostazioni salvate';

  @override
  String get cannotDeleteWithUsers =>
      'Ha ancora utenti – spostali o eliminali prima in Gestione utenti.';

  @override
  String deleteHouseholdConfirm(String name) {
    return 'Eliminare la famiglia “$name”?';
  }

  @override
  String deleteGroupConfirm(String name) {
    return 'Eliminare il gruppo “$name”?';
  }

  @override
  String usersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count utenti',
      one: '1 utente',
      zero: 'Nessun utente',
    );
    return '$_temp0';
  }

  @override
  String get originalUrlLabel => 'URL Originale';

  @override
  String get copyTextAction => 'Copia testo';

  @override
  String get copiedToClipboard => 'Copiato negli appunti';

  @override
  String get changelogEnglishHint =>
      'Le note di rilascio sono disponibili solo in inglese.';

  @override
  String get favoritesTitle => 'Preferiti';

  @override
  String get favoritesEmpty =>
      'Ancora nessun preferito. Tocca il cuore su una ricetta per raccoglierla qui.';

  @override
  String get changelogTitle => 'Novità';

  @override
  String get changeProfileImage => 'Cambia immagine del profilo';

  @override
  String get profileImageUpdated => 'Immagine del profilo aggiornata';

  @override
  String get profileImageFailed =>
      'Impossibile caricare l\'immagine del profilo';

  @override
  String get myAccountTitle => 'Il mio account';

  @override
  String get ownAccountHint =>
      'Qui puoi modificare il tuo account. Gli altri utenti sono gestiti dagli amministratori e dai membri con l\'autorizzazione “gestire”.';

  @override
  String get changePasswordAction => 'Cambia password';

  @override
  String get currentPasswordLabel => 'Password attuale';

  @override
  String get newPasswordLabel => 'Nuova password';

  @override
  String get confirmPasswordLabel => 'Conferma password';

  @override
  String get passwordTooShort => 'Almeno 8 caratteri';

  @override
  String get passwordsDoNotMatch => 'Le password non coincidono';

  @override
  String get passwordUpdated => 'Password aggiornata';

  @override
  String get passwordChangeFailed => 'Impossibile cambiare la password';

  @override
  String passwordManagedExternally(String method) {
    return 'Accedi tramite $method — cambia lì la password.';
  }

  @override
  String get bulkAddHint => 'Una riga per voce.';

  @override
  String bulkAddCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Aggiungi $count voci',
      one: 'Aggiungi 1 voce',
    );
    return '$_temp0';
  }

  @override
  String get linkRecipeAction => 'Collega ricetta';

  @override
  String get useFoodAction => 'Usa alimento invece della ricetta';

  @override
  String get addSubstitutionsAction => 'Aggiungi sostituti';

  @override
  String get clearSubstitutionsAction => 'Rimuovi sostituti';

  @override
  String get recipeSubstitutionsTitle => 'Sostituti';

  @override
  String get substitutionUnknownFood =>
      'Solo alimenti esistenti – altrimenti usa la nota';

  @override
  String get insertAboveAction => 'Inserisci sopra';

  @override
  String get insertBelowAction => 'Inserisci sotto';

  @override
  String get moveToTopAction => 'Sposta in cima';

  @override
  String get moveToBottomAction => 'Sposta in fondo';

  @override
  String get linkReferencesAction => 'Collega riferimenti';

  @override
  String get editMarkdownAction => 'Modifica Markdown';

  @override
  String get previewMarkdownAction => 'Anteprima Markdown';

  @override
  String get insertStepImageAction => 'Carica immagine';

  @override
  String get mergeAboveAction => 'Unisci con il precedente';

  @override
  String get linkedToOtherStep => 'Collegato ad un altro passaggio';

  @override
  String get noNotesToLink => 'Nessuna nota da collegare';

  @override
  String get ownerLabel => 'Proprietario';

  @override
  String get ingredientParserTitle => 'Analizzatore ingredienti';

  @override
  String ingredientParserHint(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count ingredienti non sono ancora strutturati. Scegli un analizzatore, controlla il risultato, applica.',
      one:
          '1 ingrediente non è ancora strutturato. Scegli un analizzatore, controlla il risultato, applica.',
    );
    return '$_temp0';
  }

  @override
  String get parserNlp => 'Analizzatore di Linguaggio Naturale';

  @override
  String get parserBrute => 'Analizzatore brutale';

  @override
  String get parserOpenai => 'Analizzatore OpenAI';

  @override
  String get parserApp => 'Offline (app)';

  @override
  String get parseFailed => 'Analisi non riuscita';

  @override
  String get parseAction => 'Analizza';

  @override
  String applyParsedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Applica $count ingredienti',
      one: 'Applica 1 ingrediente',
      zero: 'Niente selezionato',
    );
    return '$_temp0';
  }

  @override
  String get parsedNewBadge => 'nuovo';

  @override
  String get hoursShort => 'h';

  @override
  String get minutesShort => 'min';

  @override
  String get timeExtraHint => 'Extra, es. “più una notte”';

  @override
  String get yieldLabel => 'Quantità prodotta';

  @override
  String get yieldTextLabel => 'Unità della quantità prodotta';

  @override
  String get prepTimeLabel => 'Tempo Preparazione';

  @override
  String get performTimeLabel => 'Tempo Cottura';

  @override
  String get totalTimeLabel => 'Tempo Totale';

  @override
  String get settingPublicRecipe => 'Ricetta Pubblica';

  @override
  String get settingShowNutrition => 'Mostra Valori Nutrizionali';

  @override
  String get settingShowAssets => 'Mostra Risorse';

  @override
  String get settingLandscapeView => 'Vista Orizzontale (Prossimamente)';

  @override
  String get settingDisableComments => 'Disattiva Commenti';

  @override
  String get settingDisableAmount => 'Disabilita quantità ingredienti';

  @override
  String get settingLocked => 'Bloccato';

  @override
  String get settingLockedOwnerOnly =>
      'Solo chi ha creato la ricetta può bloccarla o sbloccarla.';

  @override
  String get apiExtrasTitle => 'API Extra';

  @override
  String get apiExtrasHint =>
      'Coppie chiave/valore personalizzate per applicazioni di terze parti, es. per avviare automazioni.';

  @override
  String get extraKeyLabel => 'Chiave';

  @override
  String get extraValueLabel => 'Valore';

  @override
  String get addExtraAction => 'Aggiungi extra';

  @override
  String durationHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ore',
      one: '1 ora',
    );
    return '$_temp0';
  }

  @override
  String durationMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minuti',
      one: '1 minuto',
    );
    return '$_temp0';
  }

  @override
  String get discardChangesConfirm => 'Scartare le modifiche non salvate?';

  @override
  String get discardChanges => 'Scarta le modifiche';

  @override
  String get imageFromUrl => 'Immagine da URL';

  @override
  String get deleteRecipeImage => 'Elimina Immagine Ricetta';

  @override
  String get deleteRecipeImageConfirm =>
      'Sei sicuro di voler eliminare questa immagine della ricetta?';

  @override
  String get bulkAddIngredients => 'Aggiungi ingredienti in blocco';

  @override
  String get bulkAddSteps => 'Aggiungi passaggi in blocco';

  @override
  String get stepImageFailed => 'Impossibile caricare l\'immagine';

  @override
  String get servingsAndTimes => 'Porzioni e tempi';

  @override
  String get recipeSettingsTitle => 'Impostazioni Ricetta';

  @override
  String get jsonEditorTitle => 'Editor JSON';

  @override
  String get jsonInvalid => 'JSON non valido – controlla.';

  @override
  String get editorOfflineHint =>
      'Aperto offline: per salvare serve una connessione. I campi più recenti di Mealie (es. sostituti) restano invariati.';

  @override
  String get parseLineFailed => 'Non riconosciuto – resta invariato';

  @override
  String get createManualTitle => 'Crea ricetta manualmente';

  @override
  String get createManualHint =>
      'Inserisci un nome – ingredienti, passaggi, immagine e tutto il resto li aggiungi poi nell\'editor della ricetta.';

  @override
  String get createManualButton => 'Crea e modifica';

  @override
  String get changelogEmpty => 'Ancora nessuna voce per questa versione.';

  @override
  String get finderDescription =>
      'Cerca ricette in base agli ingredienti a portata di mano. Si può anche filtrare in base agli utensili che si ha a disposizione e impostare un numero massimo d\'ingredienti o utensili mancanti.';

  @override
  String get finderSelectedIngredients => 'Seleziona ingredienti';

  @override
  String get finderNoIngredientsSelected => 'Nessun ingrediente selezionato';

  @override
  String get finderMissing => 'Mancante';

  @override
  String get finderNoRecipesFound => 'Nessuna ricetta trovata';

  @override
  String get finderNoRecipesFoundDescription =>
      'Prova ad aggiungere altri ingredienti alla tua ricerca o a regolare i tuoi filtri';

  @override
  String get finderIncludeFoodsOnHand => 'Includi ingredienti a mano';

  @override
  String get finderIncludeToolsOnHand => 'Includi strumenti a mano';

  @override
  String get finderIncludeSubstitutions => 'Includi sostituti';

  @override
  String get finderSubstituting => 'Sostituzioni';

  @override
  String finderSubstituteForFood(String substitute, String food) {
    return '$substitute al posto di $food';
  }

  @override
  String get finderMaxMissingIngredients => 'Max Ingredienti Mancanti';

  @override
  String get finderMaxMissingTools => 'Massimo Strumenti Mancanti';

  @override
  String get finderSelectedTools => 'Strumenti Selezionati';

  @override
  String get finderReadyToMake => 'Pronto da fare';

  @override
  String get finderAlmostReadyToMake => 'Quasi pronto da fare';

  @override
  String get finderSettings => 'Impostazioni';

  @override
  String get finderLoadingRecipes => 'Caricamento Ricette';

  @override
  String get finderClearSelection => 'Azzera selezione';

  @override
  String get finderOfflineHint =>
      'Nessuna connessione al server – i risultati provengono dalle ricette salvate su questo dispositivo.';

  @override
  String get sendPeerOfflineHint =>
      'Non raggiungibile ora – arriverà quando l\'app verrà aperta lì';

  @override
  String sendDeliveredLater(String device) {
    return '“$device” non è raggiungibile ora. La ricetta arriverà appena l\'app verrà aperta lì.';
  }

  @override
  String get sendQueuedOffline =>
      'Nessuna connessione al momento. La ricetta verrà inviata automaticamente appena torni online.';

  @override
  String get searchHasAll => 'Tutte Le Scelte';

  @override
  String get searchHasAny => 'Una Delle Scelte';

  @override
  String get recipeFilterTitle => 'Filtro';

  @override
  String get finderOtherFilters => 'Altri filtri';

  @override
  String get qfOpEquals => 'è uguale';

  @override
  String get qfOpNotEquals => 'è diverso';

  @override
  String get qfOpGreater => 'è maggiore di';

  @override
  String get qfOpGreaterEq => 'è maggiore o uguale di';

  @override
  String get qfOpLess => 'è minore di';

  @override
  String get qfOpLessEq => 'è minore o uguale di';

  @override
  String get qfOpNewerThan => 'è più recente di';

  @override
  String get qfOpOlderThan => 'è più vecchio di';

  @override
  String qfDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count giorni fa',
      one: '1 giorno fa',
    );
    return '$_temp0';
  }

  @override
  String get filterResetAll => 'Ripristina tutti i filtri';

  @override
  String get filterAny => 'Qualsiasi';

  @override
  String get filterOfflineIgnored =>
      'Offline, gli “Altri filtri” possono essere applicati solo nella forma semplice.';

  @override
  String linkedRecipesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ricette collegate',
      one: 'Una ricetta collegata',
      zero: 'Nessuna ricetta collegata',
    );
    return '$_temp0';
  }

  @override
  String get shoppingReminderNotificationsOff =>
      'Le notifiche per Mealie Recipes sono disattivate — senza di esse il promemoria della spesa non può comparire. Consenti le notifiche nelle impostazioni.';

  @override
  String get shoppingReminderInactiveHint =>
      'Il promemoria della spesa non può funzionare ora: imposta l\'accesso alla posizione su “Sempre” e consenti le notifiche.';

  @override
  String get bulkImportTitle => 'Importazione multipla URL';

  @override
  String get bulkImportDescription =>
      'L\'importatore multipla delle ricette consente di importare più ricette contemporaneamente accodando i siti sul backend ed eseguendo l\'attività in background. Questo può essere utile nella migrazione inizialmente a Mealie, o quando si desidera importare un gran numero di ricette.';

  @override
  String get bulkAddTitle => 'Inserimento Multiplo';

  @override
  String get bulkImportSetOrganizers => 'Imposta Categorie e Tag';

  @override
  String get bulkImportStarted => 'Processo di importazione multipla iniziato';

  @override
  String get bulkImportFailed =>
      'Processo di importazione multipla non riuscito';

  @override
  String get bulkImportReports => 'Importazioni Multiple';

  @override
  String get bulkImportUrlHint => 'URL Ricetta';

  @override
  String get migrationsTitle => 'Migrazioni Dati';

  @override
  String get migrationsDescription =>
      'Puoi migrare in Mealie le ricette di un\'altra applicazione supportata: è un ottimo modo per iniziare. Per spostare dati tra istanze di Mealie, o per ripristinare un backup precedente, usa invece gli strumenti di backup e ripristino.';

  @override
  String get migrationNew => 'Nuova Migrazione';

  @override
  String get migrationChooseType => 'Scegli Il Tipo Di Migrazione';

  @override
  String get noFileSelected => 'Nessun file selezionato';

  @override
  String migrationTagAll(String tag) {
    return 'Aggiungi il tag $tag a tutte le ricette';
  }

  @override
  String get migrationPrevious => 'Migrazioni Precedenti';

  @override
  String get migrationMealieDescription =>
      'Mealie può importare ricette da una versione di Mealie precedente alla 1.0. Esporta le ricette dalla vecchia istanza e carica qui sotto il file zip. Dall\'esportazione si possono importare solo le ricette. Vale solo per le istanze precedenti alla v1.0: un backup fatto dalla v1.0 in poi va ripristinato con gli strumenti di backup e ripristino.';

  @override
  String get migrationChowdownDescription =>
      'Mealie supporta nativamente il formato del repository chowdown. Scarica il repository del codice come file .zip e caricalo qui sotto.';

  @override
  String get migrationCopyMeThatDescription =>
      'Mealie può importare ricette da Copy Me That. Esporta le tue ricette in formato HTML, quindi carica il .zip qui sotto.';

  @override
  String get migrationMyRecipeBoxDescription =>
      'Mealie può importare ricette da My Recipe Box. Esporta le tue ricette in formato HTML, quindi carica il .zip qui sotto.';

  @override
  String get migrationNextcloudDescription =>
      'Le ricette di Nextcloud possono essere importate da un file zip che contiene i dati memorizzati in Nextcloud. Osserva la struttura della cartella di esempio qui sotto per assicurarti che le tue ricette siano in grado di essere importate.';

  @override
  String get migrationPaprikaDescription =>
      'Mealie può importare ricette dall\'applicazione Paprika. Esporta le tue ricette da paprika, rinomina l\'estensione di esportazione in .zip e caricala qui sotto.';

  @override
  String get migrationPlanToEatDescription =>
      'Mealie può importare le ricette da Plan to Eat.';

  @override
  String get migrationRecipeKeeperDescription =>
      'Mealie può importare ricette da Recipe Keeper. Esporta le tue ricette in formato zip, quindi carica lo .zip qui sotto.';

  @override
  String get migrationTandoorDescription =>
      'Mealie può importare ricette da Tandoor. Esporta i tuoi dati nel formato \"Predefinito\", quindi carica il file .zip sottostante.';

  @override
  String get migrationCooknDescription =>
      'Mealie può importare ricette da DVO Cook\'n X3. Per esportare un ricettario o un menu nel formato \"Cook\'n\", rinominare l\'estensione di esportazione in .zip, quindi caricare il file .zip qui sotto.';

  @override
  String get reportTitle => 'Segnala';

  @override
  String get recipeDataTitle => 'Dati Ricetta';

  @override
  String get recipeDataDescription =>
      'Usa questa sezione per gestire i dati associati alle tue ricette. È possibile eseguire diverse azioni massive sulle ricette, tra cui l\'esportazione, cancellazione, tagging, e l\'assegnazione di categorie.';

  @override
  String get recipeDataTagTitle => 'Tag Ricette';

  @override
  String get recipeDataCategorizeTitle => 'Categorizza Ricette';

  @override
  String get recipeDataSettingsTitle => 'Aggiorna Impostazioni';

  @override
  String get recipeDataExportTitle => 'Esporta Ricette';

  @override
  String get recipeDataDeleteTitle => 'Elimina Ricette';

  @override
  String recipeDataExportConfirm(int count) {
    return 'Verranno esportate le seguenti ricette ($count).';
  }

  @override
  String get recipeDataExportsTitle => 'Esportazione Dati';

  @override
  String get recipeDataExportsDescription =>
      'Questa sezione fornisce i link alle esportazioni disponibili pronte per il download. Queste esportazioni hanno una scadenza, quindi assicurati di scaricarle finché sono ancora disponibili.';

  @override
  String get recipeDataPurgeExports => 'Elimina Esportazioni';

  @override
  String get recipeDataPurgeConfirm =>
      'Sei sicuro di voler cancellare tutti i dati di esportazione?';

  @override
  String get recipeActionsTitle => 'Azioni Ricetta';

  @override
  String get recipeActionNew => 'Nuova Azione Ricetta';

  @override
  String get recipeActionEdit => 'Modifica Azione Ricetta';

  @override
  String get recipeActionTypeLink => 'Link';

  @override
  String get recipeActionTypePost => 'Pubblica';

  @override
  String get webhooksTitle => 'Webhook';

  @override
  String get webhooksDescription =>
      'I webhooks definiti di seguito saranno eseguiti quando un pasto è definito per il giorno. All\'orario previsto i webhooks saranno inviati con i dati della ricetta che è prevista per il giorno. Si noti che l\'esecuzione di webhook non è esatta. I webhook sono eseguiti su un intervallo di 5 minuti quindi i webhook saranno eseguiti entro 5 +/- minuti dal previsto.';

  @override
  String get webhookName => 'Nome Webhook';

  @override
  String get webhookUrl => 'URL Webhook';

  @override
  String get notifiersTitle => 'Notifiche';

  @override
  String get notifiersDescription =>
      'Imposta email e notifiche push che si attivano per eventi specifici.';

  @override
  String get notifierNew => 'Nuova Notifica';

  @override
  String get notifierDescription =>
      'Mealie usa la libreria Apprise per generare le notifiche. Offrono molte opzioni per i servizi da usare per le notifiche. Fare riferimento alla loro wiki per una estensiva guida di come creare l\'URL per il tuo sevizio. Selezionando il tipo di notifica, se disponibile, potrebbe includere delle funzionalità extra.';

  @override
  String get notifierAppriseUrl => 'URL Apprise';

  @override
  String get notifierAppriseUrlSkipped => 'Url di Apprise (ignorato se vuoto)';

  @override
  String get notifierAppriseUrlBlankHint =>
      'Poiché gli URL Apprise contengono in genere informazioni sensibili, questo campo viene lasciato intenzionalmente vuoto durante la modifica. Se si desidera aggiornare l\'URL, inserire qui il nuovo URL, altrimenti lasciarlo vuoto per mantenere l\'URL corrente.';

  @override
  String get notifierEnable => 'Abilita Notificatore';

  @override
  String get notifierWhatEvents =>
      'Quali eventi dovrebbe sottoscrivere questo notificatore?';

  @override
  String get notifierRecipeEvents => 'Eventi di ricette';

  @override
  String get notifierUserEvents => 'Eventi Utente';

  @override
  String get notifierMealplanEvents => 'Eventi del piano alimentare';

  @override
  String get notifierShoppingListEvents => 'Eventi Lista Della spesa';

  @override
  String get notifierCookbookEvents => 'Eventi Del Ricettario';

  @override
  String get notifierTagEvents => 'Eventi dei tag';

  @override
  String get notifierCategoryEvents => 'Eventi delle categorie';

  @override
  String get notifierLabelEvents => 'Eventi Etichetta';

  @override
  String get notifierUserSignup =>
      'Quando un nuovo utente entra nel tuo gruppo';

  @override
  String get notifierCreate => 'Crea';

  @override
  String get notifierUpdate => 'Aggiorna';

  @override
  String get notifierDelete => 'Elimina';

  @override
  String get notifierTestSent => 'Messaggio di prova inviato';

  @override
  String get adminTitle => 'Impostazioni Amministratore';

  @override
  String get backupsTitle => 'Backup';

  @override
  String get backupsDescription =>
      'I backup sono immagini complete del database e della cartella dati del sito. Questo include tutti i dati e non è possibile escluderne alcune. Puoi pensare a questo come un\'immagine vera e propria di Mealie a uno specifico orario. Questo funge da metodo agnostico per esportare e importare database e relativi dati, o per fare un backup del sito in una posizione esterna.';

  @override
  String get backupCreateHeading => 'Crea un Backup';

  @override
  String get backupCreated => 'Backup creato con successo';

  @override
  String get backupCreateFailed =>
      'Errore nella creazione del Backup. Vedi il file di log';

  @override
  String get backupDelete => 'Elimina Backup';

  @override
  String get backupDeleted => 'Backup eliminato';

  @override
  String get backupRestore => 'Ripristina Backup';

  @override
  String get backupRestoreDescription =>
      'Il ripristino di questo backup sovrascriverà tutti i dati attuali nel database e nella cartella dei dati, sostituendoli con il contenuto del backup. Se il ripristino riesce, verrai disconnesso.';

  @override
  String get backupCannotBeUndone =>
      'Questa azione non può essere annullata - usa con cautela.';

  @override
  String get backupAcknowledge =>
      'Capisco che questa azione è irreversibile, distruttiva e può causare la perdita di dati';

  @override
  String get backupRestoreSuccess => 'Ripristino riuscito';

  @override
  String get backupRestoreFailed =>
      'Ripristino non riuscito. Controlla i log del tuo server per maggiori dettagli';

  @override
  String get maintenanceTitle => 'Manutenzione';

  @override
  String get maintenanceSummary => 'Riepilogo';

  @override
  String get maintenanceStorage => 'Dettagli Archiviazione';

  @override
  String get maintenanceDataDirSize => 'Dimensione della Directory dei Dati';

  @override
  String get maintenanceCleanableDirs => 'Directory Eliminabili';

  @override
  String get maintenanceCleanableImages => 'Immagini Eliminabili';

  @override
  String get maintenanceTempDir => 'Directory Temporanea (.temp)';

  @override
  String get maintenanceBackupsDir => 'Directory di Backup (Backup)';

  @override
  String get maintenanceGroupsDir => 'Directory Gruppi (gruppi)';

  @override
  String get maintenanceRecipesDir => 'Directory Ricette (ricette)';

  @override
  String get maintenanceUserDir => 'Directory Utente (utente)';

  @override
  String get maintenanceCleanDirs => 'Pulisci Directory';

  @override
  String get maintenanceCleanDirsDescription =>
      'Rimuove tutte le cartelle di ricette che non hanno UUID validi';

  @override
  String get maintenanceCleanTemp => 'Elimina File Temporanei';

  @override
  String get maintenanceCleanTempDescription =>
      'Rimuove tutti i file e le cartelle nella directory .temp';

  @override
  String get maintenanceCleanImages => 'Cancella Immagini';

  @override
  String get maintenanceCleanImagesDescription =>
      'Rimuove tutte le immagini che non finiscono con .webp';

  @override
  String get maintenanceActions => 'Azioni';

  @override
  String get adminConfiguration => 'Configurazione';

  @override
  String get adminAppVersion => 'Versione dell\'applicazione';

  @override
  String get adminUpToDate => 'Mealie è aggiornato';

  @override
  String adminVersionOutdated(String current, String latest) {
    return 'La versione attuale ($current) non corrisponde all\'ultima release. Valuta l\'aggiornamento all\'ultima versione ($latest).';
  }

  @override
  String get adminBaseUrl => 'Url Base Del Server';

  @override
  String get adminBaseUrlOk =>
      'L\'URL del server non corrisponde a quello predefinito';

  @override
  String get adminBaseUrlError =>
      '`BASE_URL` è ancora il valore predefinito sul server API. Questo causerà problemi con i link di notifica generati sul server per le email, ecc.';

  @override
  String adminAuthReady(String provider) {
    return '$provider pronto';
  }

  @override
  String adminAuthNotReady(String provider) {
    return '$provider non pronto';
  }

  @override
  String adminAuthDisabled(String provider) {
    return '$provider disattivato';
  }

  @override
  String adminAuthSuccessText(String provider) {
    return 'Le variabili richieste per $provider sono tutte impostate.';
  }

  @override
  String adminAuthErrorText(String provider) {
    return 'Non tutti i valori di $provider sono configurati. Puoi ignorare questo avviso se non usi l\'autenticazione $provider.';
  }

  @override
  String adminAuthDisabledText(String envVar) {
    return 'Per attivarlo imposta $envVar a true.';
  }

  @override
  String get adminEmailStatus => 'Configurazione e-mail';

  @override
  String get adminEmailConfigured => 'Email configurata';

  @override
  String get adminNotReady => 'Non Pronto - Verifica Variabili Di Ambiente';

  @override
  String get adminSucceeded => 'Operazione riuscita';

  @override
  String get adminFailed => 'Non riuscita';

  @override
  String get adminSiteStatistics => 'Statistiche del sito';

  @override
  String get adminUncategorized => 'Ricette non categorizzate';

  @override
  String get adminUntagged => 'Ricette senza tag';

  @override
  String get adminGeneralAbout => 'Informazioni Generali';

  @override
  String get adminVersion => 'Versione';

  @override
  String get adminBuild => 'Versione';

  @override
  String get adminApplicationMode => 'Modalità';

  @override
  String get adminProduction => 'Produzione';

  @override
  String get adminDevelopment => 'In Sviluppo';

  @override
  String get adminDemoStatus => 'Stato Demo';

  @override
  String get adminDemo => 'Demo';

  @override
  String get adminNotDemo => 'Non Demo';

  @override
  String get adminApiPort => 'Importazione API';

  @override
  String get adminApiDocs => 'Documentazione API';

  @override
  String get adminDatabaseType => 'Tipo Database';

  @override
  String get adminDatabaseUrl => 'URL Database';

  @override
  String get adminDefaultGroup => 'Gruppo Predefinito';

  @override
  String get adminDefaultHousehold => 'Famiglia Predefinita';

  @override
  String get adminScraperVersion => 'Versione Recipe Scraper';

  @override
  String get adminStatUsers => 'Utenti';

  @override
  String get adminStatHouseholds => 'Famiglie';

  @override
  String get adminStatGroups => 'Gruppi';

  @override
  String get recipeDuplicate => 'Duplica ricetta';

  @override
  String get recipeDuplicateAction => 'Duplicato';

  @override
  String get recipeShareLink => 'Condividi ricetta';

  @override
  String get recipeShareExpiration => 'Data di scadenza';

  @override
  String get recipeShareCopied => 'Link della ricetta copiato negli appunti';

  @override
  String get enabledLabel => 'Abilitato';

  @override
  String get disabledLabel => 'Disabilita';

  @override
  String get testAction => 'Prova';

  @override
  String get yesLabel => 'Sì';

  @override
  String get noLabel => 'No';

  @override
  String get downloadAction => 'Scarica';

  @override
  String get backupUpload => 'Carica';

  @override
  String get zipImportButton => 'Importa da Zip';

  @override
  String get zipImportDescription =>
      'Importa una singola ricetta esportata da un\'altra istanza di Mealie.';

  @override
  String get reportStatus => 'Stato';

  @override
  String get reportDate => 'Data';

  @override
  String get recipeActionTitleLabel => 'Titolo';

  @override
  String get clearAll => 'Resetta';

  @override
  String get recipeDataSettingsExplanation =>
      'Le impostazioni selezionate, esclusa l\'opzione Bloccato, saranno applicate a tutte le ricette selezionate.';

  @override
  String get adminAllowSignup => 'Consenti registrazione';

  @override
  String get adminAllowPasswordLogin => 'Consenti accesso con password';

  @override
  String get adminEmailInvalid => 'Inserisci un indirizzo email valido.';

  @override
  String adminEmailTestResult(String result) {
    return 'Test email: $result';
  }

  @override
  String get adminSendTestEmail => 'Invia email di prova';

  @override
  String get adminTestEmailAddress => 'Destinatario';

  @override
  String get backupCreate => 'Crea backup';

  @override
  String backupDeleteConfirm(String name) {
    return 'Eliminare il backup “$name”?';
  }

  @override
  String get backupPostgresNote =>
      'Se usi PostgreSQL, leggi la procedura di backup/ripristino nella documentazione di Mealie prima di ripristinare.';

  @override
  String get backupUploaded => 'Backup caricato';

  @override
  String get backupsEmpty => 'Ancora nessun backup.';

  @override
  String get bulkImportAddRow => 'Aggiungi URL';

  @override
  String get bulkImportStart => 'Avvia importazione';

  @override
  String get chooseFileButton => 'Scegli file';

  @override
  String get deselectAllAction => 'Deseleziona tutto';

  @override
  String get downloadFailed => 'Download non riuscito';

  @override
  String get fileSaved => 'File salvato';

  @override
  String get loadFailed => 'Impossibile caricare';

  @override
  String get maintenanceActionsWarning =>
      'Le azioni di manutenzione sono distruttive e vanno usate con cautela. Eseguire una di queste azioni è irreversibile.';

  @override
  String get maintenanceConfirm =>
      'Questa azione è distruttiva e non può essere annullata. Continuare?';

  @override
  String get maintenanceDone => 'Fatto';

  @override
  String get maintenanceFailed => 'Azione di manutenzione non riuscita';

  @override
  String get maintenanceRun => 'Avvia';

  @override
  String get migrationFailed => 'Migrazione non riuscita';

  @override
  String get migrationStart => 'Avvia migrazione';

  @override
  String get migrationStarted =>
      'Migrazione completata — vedi il rapporto qui sotto.';

  @override
  String get moreImportOptions => 'Altre opzioni di importazione';

  @override
  String notifierDeleteConfirm(String name) {
    return 'Eliminare il notificatore “$name”?';
  }

  @override
  String get notifierEdit => 'Modifica notificatore';

  @override
  String notifierEventCount(int count) {
    return 'Eventi: $count';
  }

  @override
  String get notifierTestFailed => 'Impossibile inviare il messaggio di prova';

  @override
  String get notifiersEmpty => 'Ancora nessun notificatore.';

  @override
  String recipeActionDeleteConfirm(String name) {
    return 'Eliminare l\'azione ricetta “$name”?';
  }

  @override
  String get recipeActionFailed => 'Azione ricetta non riuscita';

  @override
  String get recipeActionSent => 'Ricetta inviata';

  @override
  String get recipeActionUrlHint => 'Segnaposto';

  @override
  String get recipeActionsDescription =>
      'Le azioni ricetta compaiono nel menu di ogni ricetta. “Link” apre l\'URL, “Post” fa inviare la ricetta all\'URL dal server Mealie.';

  @override
  String get recipeActionsEmpty => 'Ancora nessuna azione ricetta.';

  @override
  String recipeDataDeleteConfirm(int count) {
    return 'Eliminare le ricette selezionate ($count)? L\'azione non può essere annullata.';
  }

  @override
  String recipeDataDeleteForbidden(int count) {
    return 'Non puoi eliminare $count delle ricette selezionate (può farlo solo chi le ha create o un amministratore).';
  }

  @override
  String recipeDataDeleted(int count) {
    return 'Ricette eliminate: $count';
  }

  @override
  String get recipeDataExportAction => 'Esporta';

  @override
  String get recipeDataExportDone =>
      'Esportazione creata — scaricala in Esportazioni dati.';

  @override
  String recipeDataExportExpires(String date) {
    return 'scade il $date';
  }

  @override
  String get recipeDataExportFailed => 'Esportazione non riuscita';

  @override
  String get recipeDataExportsEmpty => 'Nessuna esportazione disponibile.';

  @override
  String recipeDataUpdated(int count) {
    return 'Ricette aggiornate: $count';
  }

  @override
  String get recipeDuplicated => 'Ricetta duplicata';

  @override
  String get recipeExportJson => 'Esporta come JSON';

  @override
  String get recipeExportZip => 'Esporta come ZIP (con immagine)';

  @override
  String get recipeShareCreate => 'Crea link';

  @override
  String get recipeShareDescription =>
      'Chiunque abbia il link può vedere questa ricetta nel browser — senza account — fino alla scadenza.';

  @override
  String get recipeShareEmpty => 'Ancora nessun link di condivisione.';

  @override
  String recipeShareExpiresAt(String date) {
    return 'Scade il $date';
  }

  @override
  String get recipeWebToolsMenu => 'Duplica, link di condivisione e altro';

  @override
  String get reload => 'Ricarica';

  @override
  String get reportDeleteConfirm => 'Eliminare questo rapporto?';

  @override
  String get reportEntries => 'Voci';

  @override
  String get reportFailedEntries => 'Non riuscita';

  @override
  String get reportOnlyFailed => 'Mostra solo le voci non riuscite';

  @override
  String get reportStatusFailure => 'Errore';

  @override
  String get reportStatusInProgress => 'In corso';

  @override
  String get reportStatusPartial => 'Parziale';

  @override
  String get reportStatusSuccess => 'Riuscito';

  @override
  String get reportsEmpty => 'Ancora nessun rapporto.';

  @override
  String get uploadFailed => 'Caricamento non riuscito';

  @override
  String webhookDeleteConfirm(String name) {
    return 'Eliminare il webhook “$name”?';
  }

  @override
  String get webhookEdit => 'Modifica webhook';

  @override
  String get webhookNew => 'Nuovo webhook';

  @override
  String get webhookTestFailed => 'Impossibile avviare il test';

  @override
  String get webhookTestSent => 'Webhook di prova attivato';

  @override
  String get webhookTime => 'Ora (locale)';

  @override
  String get webhooksEmpty => 'Ancora nessun webhook.';

  @override
  String get zipImportFailed => 'Importazione ZIP non riuscita';

  @override
  String get aiProvidersTitle => 'Provider AI';

  @override
  String get aiProvidersDescription =>
      'Configura i provider AI per abilitare le funzionalità basate su AI, come l\'analisi migliorata degli ingredienti, la creazione di ricette da video e altro ancora!';

  @override
  String get aiProviderSettingsTitle => 'Impostazioni Provider AI';

  @override
  String get aiProvidersList => 'Provider';

  @override
  String get aiProviderCreate => 'Crea Provider';

  @override
  String get aiProviderEdit => 'Modifica provider';

  @override
  String get aiDefaultProvider => 'Provider Predefinito';

  @override
  String get aiDefaultProviderDescription =>
      'Necessario per abilitare le funzionalità AI';

  @override
  String get aiAudioProvider => 'Provider Audio';

  @override
  String get aiAudioProviderDescription =>
      'Abilita le funzioni di trascrizione audio, come la creazione di ricette da video';

  @override
  String get aiImageProvider => 'Provider Immagini';

  @override
  String get aiImageProviderDescription =>
      'Abilita le funzionalità di riconoscimento delle immagini, come la creazione di ricette dalle immagini';

  @override
  String get aiProviderName => 'Nome provider';

  @override
  String get aiApiKey => 'Chiave API';

  @override
  String get aiApiKeyCreateDescription =>
      'La chiave API del tuo provider per l\'autenticazione. Se il tuo servizio (ad esempio Ollama) non utilizza una chiave API, devi comunque mettere qualcosa qui.';

  @override
  String get aiApiKeyEditDescription =>
      'Lascia questo vuoto a meno che tu non voglia cambiarlo.';

  @override
  String get aiBaseUrl => 'URL Base';

  @override
  String get aiBaseUrlDescription =>
      'Se stai usando OpenAI lascia questo vuoto. Deve essere un endpoint compatibile con OpenAI (es. \"http://localhost:11434/v1\").';

  @override
  String get aiModel => 'Modello';

  @override
  String get aiModelDescription =>
      'Quale modello dovrebbe usare il tuo fornitore di AI (ad esempio \"gpt-5\").';

  @override
  String get aiTimeout => 'Timeout Richiesta (secondi)';

  @override
  String get aiProviderCreated => 'Provider creato';

  @override
  String get aiProviderUpdated => 'Provider aggiornato';

  @override
  String get aiProviderDeleted => 'Provider eliminato';

  @override
  String get aiProviderCreateFailed => 'Errore nella creazione del provider';

  @override
  String get aiProviderUpdateFailed =>
      'Errore nell\'aggiornamento del provider';

  @override
  String get aiProviderDeleteFailed => 'Errore nella rimozione del provider';

  @override
  String get aiRequestHeaders => 'Header della Richiesta';

  @override
  String get aiRequestParams => 'Parametri Della Richiesta';

  @override
  String get aiNoDefaultWarning =>
      'Non hai impostato un provider predefinito, quindi le funzioni AI sono disabilitate';

  @override
  String get aiTestConnection => 'Prova connessione';

  @override
  String get aiTestSucceeded => 'Connessione riuscita';

  @override
  String get aiTestFailed => 'Connessione non riuscita';

  @override
  String get aiSupportsImages => 'Supporta le immagini';

  @override
  String get aiTextOnly =>
      'Solo testo, non può essere il tuo provider di immagini';

  @override
  String get debugAiTitle => 'Debug provider AI';

  @override
  String get debugAiDescription =>
      'Usa questa pagina per fare il debug dei provider AI. Puoi provare la connessione AI e vedere qui i risultati. Se hai attivato i servizi per le immagini, puoi anche fornire un\'immagine.';

  @override
  String get debugParserTitle => 'Analizzatore';

  @override
  String get debugParserDescription =>
      'Mealie utilizza campi casuali condizionali (CRFs) per l\'analisi e la lavorazione di ingredienti. Il modello utilizzato per gli ingredienti è basato su una serie di dati di oltre 100.000 ingredienti da un set di dati compilato dal New York Times. Si noti che poiché il modello è addestrato solo in inglese, si possono avere risultati vari quando si utilizza il modello in altre lingue. Questa pagina è un campo di gioco per testare il modello.';

  @override
  String get debugIngredientText => 'Testo Ingrediente';

  @override
  String get debugTryExample => 'Prova un esempio';

  @override
  String debugAverageConfidence(String value) {
    return 'Affidabilità $value';
  }

  @override
  String get debugRunTest => 'Esegui test';

  @override
  String get debugQuantity => 'Quantità';

  @override
  String get debugUnit => 'Unità';

  @override
  String get debugFood => 'Alimenti';

  @override
  String get debugNote => 'Commento';

  @override
  String get debugGroup => 'Gruppo';

  @override
  String get aiProviderNone => 'Nessuno';

  @override
  String aiProviderDeleteConfirm(String name) {
    return 'Eliminare il provider “$name”?';
  }

  @override
  String get aiProvidersEmpty => 'Ancora nessun provider IA.';

  @override
  String get aiAdvanced => 'Ricerca Avanzata';

  @override
  String get aiKeyLabel => 'Nome';

  @override
  String get aiValueLabel => 'Valore';

  @override
  String get debugTitle => 'Debug';

  @override
  String get debugParse => 'Analizza';

  @override
  String get debugParseFailed => 'Impossibile analizzare l\'ingrediente';

  @override
  String get debugChooseImage => 'Scegli immagine';

  @override
  String get debugNoImage => 'Nessuna immagine (facoltativa)';

  @override
  String get updateTitle => 'Cerca aggiornamenti';

  @override
  String get updateInstalledVersion => 'Versione installata';

  @override
  String get updateLastCheck => 'Ultimo controllo';

  @override
  String get updateCheckNow => 'Controlla ora';

  @override
  String get updateChecking => 'Ricerca aggiornamenti…';

  @override
  String get updateUpToDate => 'Mealie Recipes è aggiornato.';

  @override
  String updateAvailable(String version) {
    return 'È disponibile la versione $version';
  }

  @override
  String get updateAvailableDescription =>
      'È disponibile una nuova versione di Mealie Recipes. Non viene installato nulla finché non avvii tu l\'aggiornamento.';

  @override
  String get updateShow => 'Mostra aggiornamento';

  @override
  String get updateLater => 'Più tardi';

  @override
  String updateDownloading(int percent) {
    return 'Download … $percent %';
  }

  @override
  String updateReady(String version) {
    return 'La versione $version è pronta per l\'installazione';
  }

  @override
  String get updateInstalling =>
      'Installazione — l\'app si riavvia automaticamente …';

  @override
  String get updateManual =>
      'Impossibile installare l\'aggiornamento automaticamente. L\'immagine disco è stata aperta: trascina Mealie Recipes in Applicazioni.';

  @override
  String get updateFailed => 'Aggiornamento non riuscito';

  @override
  String get updateInstallNow => 'Scarica e installa';

  @override
  String get updateRestartNow => 'Installa e riavvia';

  @override
  String get updateAutoTitle => 'Cerca aggiornamenti all\'avvio';

  @override
  String get updateAutoDescription =>
      'Controlla e ti avvisa soltanto — l\'installazione la avvii sempre tu.';

  @override
  String get updateBetaTitle => 'Ricevi versioni beta';

  @override
  String get updateBetaDescription =>
      'Propone anche versioni di anteprima per i test. Potrebbero contenere ancora errori.';

  @override
  String get updateNoNotes => 'Nessuna nota di rilascio.';

  @override
  String get updateSourceHint =>
      'Gli aggiornamenti provengono dalle release GitHub di Mealie Recipes e vengono installati solo se firmati dallo sviluppatore (macOS).';

  @override
  String get errorNoConnection =>
      'Impossibile raggiungere il server Mealie. Controlla la connessione a Internet e l\'indirizzo del server.';

  @override
  String get errorTimeout =>
      'Il server ha impiegato troppo a rispondere. Riprova.';

  @override
  String get errorUnauthorized =>
      'L\'accesso è scaduto o il token API non è più valido. Accedi di nuovo nelle impostazioni.';

  @override
  String get errorServer =>
      'Il server Mealie ha segnalato un errore. Riprova più tardi.';

  @override
  String get errorNotFound =>
      'Non trovato sul server — potrebbe essere stato eliminato.';

  @override
  String get errorCertificate =>
      'Il certificato di sicurezza del server non è attendibile.';

  @override
  String get errorGeneric => 'Qualcosa è andato storto. Riprova.';

  @override
  String get offlineLabel => 'Offline';

  @override
  String offlineSince(String time) {
    return 'Offline · ultima sincronizzazione $time';
  }

  @override
  String get mealplanEntryActions => 'Opzioni del pasto';

  @override
  String get mealplanMoveAction => 'Sposta';

  @override
  String get mealplanMoveTitle => 'Sposta pasto';

  @override
  String get mealplanMoveDate => 'Data';

  @override
  String mealplanMovedTo(String date) {
    return 'Spostato al $date';
  }

  @override
  String get mealplanShowWeek => 'Mostra';

  @override
  String get mealplanMoveFailed => 'Impossibile spostare il pasto';

  @override
  String get recentlyViewedTitle => 'Visti di recente';

  @override
  String get recentlyViewedEmpty => 'Le ricette che apri compariranno qui.';

  @override
  String get recentlyViewedClear => 'Cancella cronologia';

  @override
  String get recentlyViewedClearMessage =>
      'L\'elenco delle ricette viste di recente su questo dispositivo verrà cancellato. Le ricette restano.';

  @override
  String get recentlyViewedClearConfirm => 'Resetta';

  @override
  String get duplicatesTitle => 'Trova duplicati';

  @override
  String get duplicatesScanning => 'Ricerca di ricette duplicate…';

  @override
  String get duplicatesNone => 'Nessuna ricetta duplicata trovata.';

  @override
  String duplicatesFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Trovati $count possibili duplicati.',
      one: 'Trovato 1 possibile duplicato.',
    );
    return '$_temp0';
  }

  @override
  String get duplicatesIntro => 'Tocca la ricetta da tenere, poi unisci.';

  @override
  String get duplicatesReasonSource => 'Stessa fonte';

  @override
  String get duplicatesReasonName => 'Stesso nome';

  @override
  String duplicatesReasonSimilar(int percent) {
    return 'Simile · $percent % di ingredienti uguali';
  }

  @override
  String get duplicatesKeeps => 'Resta';

  @override
  String get duplicatesWillBeDeleted => 'Verrà eliminata';

  @override
  String get duplicatesMerge => 'Unisci';

  @override
  String get duplicatesNotDuplicate => 'Non è un duplicato';

  @override
  String get duplicatesMergeTitle => 'Unire le ricette?';

  @override
  String duplicatesMergeMessage(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count altre ricette verranno eliminate',
      one: '1 altra ricetta verrà eliminata',
    );
    return '“$name” resta. $_temp0.\n\nCategorie, tag, strumenti, note, pasti pianificati della tua famiglia e il tuo preferito vengono trasferiti. Commenti, linea temporale e risorse delle ricette eliminate vanno persi.';
  }

  @override
  String get duplicatesMerged => 'Ricette unite';

  @override
  String duplicatesIngredientCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ingredienti',
      one: '1 ingrediente',
    );
    return '$_temp0';
  }

  @override
  String duplicatesResetIgnored(int count) {
    return 'Mostra di nuovo le coppie nascoste ($count)';
  }

  @override
  String get duplicatesRescan => 'Cerca di nuovo';

  @override
  String get duplicatesOpenRecipe => 'Apri ricetta';

  @override
  String get duplicatesMergeNoEditHint =>
      'Non puoi modificare la ricetta che resta (ricetta altrui bloccata o di un\'altra famiglia). Categorie, tag, strumenti e note restano quindi invariati; vengono trasferiti solo i pasti pianificati e il tuo preferito.';

  @override
  String get recipeOtherHouseholdHint =>
      'Di un\'altra famiglia – lì la modifica è bloccata';

  @override
  String foodsSavedAsNote(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nuovi alimenti sono stati mantenuti',
      one: '1 nuovo alimento è stato mantenuto',
    );
    return 'Salvato. $_temp0 come nota dell\'ingrediente – per creare alimenti serve l\'autorizzazione “L\'utente può gestire alimenti, tag e categorie” in Mealie.';
  }

  @override
  String get a11yRemove => 'Rimuovi';

  @override
  String get a11yDecrease => 'Meno';

  @override
  String get a11yIncrease => 'Più';

  @override
  String get a11yShowPassword => 'Mostra password';

  @override
  String get a11yHidePassword => 'Nascondi password';

  @override
  String get a11yClearSearch => 'Cancella ricerca';

  @override
  String get notesQueuedOffline =>
      'Offline – la nota verrà inviata appena il server sarà di nuovo raggiungibile.';

  @override
  String get timelineQueuedOffline =>
      'Offline – verrà aggiunto alla linea temporale appena il server sarà di nuovo raggiungibile.';

  @override
  String get syncSectionName => 'Rinominati';

  @override
  String get pendingRecipesDiscard => 'Scarta';

  @override
  String get undo => 'Annulla';

  @override
  String timerStoppedSnack(String name) {
    return 'Timer “$name” fermato';
  }

  @override
  String get cookFriendsEndConfirm =>
      'Terminare la sessione per tutti? Tutti gli ospiti verranno disconnessi.';

  @override
  String get weekStartSyncHint =>
      'Salvato in Mealie – vale per tutta la famiglia, anche nella web app.';

  @override
  String get weekStartNoPermission =>
      'Impostato in Mealie dalla tua famiglia. Possono cambiarlo solo i membri che gestiscono la famiglia.';

  @override
  String get assetsUnsupported329 =>
      'Mealie supporta PDF, immagini, video (MP4, MOV, WebM), audio (MP3, M4A), Word/ODT/RTF, TXT, MD, CSV e JSON.';

  @override
  String get assetsRecordVideo => 'Registra video';

  @override
  String get assetsChooseVideo => 'Scegli video';

  @override
  String get shoppingSearchHint => 'Cerca in questa lista';

  @override
  String get shoppingSearchNoMatches =>
      'Nessun articolo corrisponde alla ricerca.';

  @override
  String get mealplanServingsTitle => 'Porzioni pianificate';

  @override
  String get mealplanServingsHint =>
      'Solo per questa voce del piano alimentare — la ricetta resta invariata. Aprendo la ricetta e aggiungendola alla lista della spesa si usano queste porzioni.';

  @override
  String get calendarFeedTitle => 'Iscriviti al calendario';

  @override
  String get calendarFeedSubtitle =>
      'Mostra il piano alimentare in Google, Apple o in qualsiasi altro calendario';

  @override
  String get calendarFeedDescription =>
      'Iscriviti al piano alimentare della tua famiglia da Google Calendar, Calendario di Apple, Home Assistant o qualsiasi altra app che supporti i link iCal. Chiunque abbia il link può vedere il tuo piano alimentare.';

  @override
  String get calendarFeedOff =>
      'Il link del calendario è disattivato per la tua famiglia.';

  @override
  String get calendarFeedAskManager =>
      'Chiedi a chi gestisce la tua famiglia di attivarlo.';

  @override
  String get calendarFeedTurnOn => 'Attiva';

  @override
  String get calendarFeedTurnOff => 'Disattiva';

  @override
  String get calendarFeedReset => 'Reimposta link';

  @override
  String get calendarFeedResetHint =>
      'Se reimposti o disattivi il link, le iscrizioni esistenti smettono di aggiornarsi.';

  @override
  String get calendarFeedIncludeNotes => 'Includi note';

  @override
  String get calendarFeedTimesHint =>
      'Tocca un pasto per impostarne l\'orario. I pasti senza orario compaiono come eventi di tutto il giorno.';

  @override
  String get calendarFeedMealTypes => 'Tipo di Pasto';

  @override
  String get calendarFeedSubscribe => 'Iscriviti nel calendario';

  @override
  String get calendarFeedNoApp =>
      'Impossibile aprire un\'app calendario. Copia il link e aggiungilo al calendario come iscrizione.';

  @override
  String get calendarFeedPublicHint =>
      'Il link funziona senza accesso — condividilo solo con chi può vedere il tuo piano alimentare.';

  @override
  String get recipeShareLinkMenu => 'Link di condivisione e codice QR';

  @override
  String get recipeShareShowQr => 'Mostra codice QR';

  @override
  String get recipeShareScanQr =>
      'Inquadralo con la fotocamera del telefono per aprire questa ricetta';

  @override
  String get recipeShareQrShare => 'Condividi immagine';

  @override
  String get recipeShareQrFailed =>
      'Impossibile creare l\'immagine del codice QR';

  @override
  String get mealplanSettingsTitle => 'Impostazioni del piano alimentare';

  @override
  String get mealDiceRulesTitle => 'Regole del dado';

  @override
  String saveAsNewFood(String name) {
    return 'Salva “$name” come nuovo alimento';
  }

  @override
  String get shoppingMoreOptions => 'Altre opzioni';

  @override
  String get shoppingFewerOptions => 'Meno opzioni';

  @override
  String nameAlreadyExists(String name) {
    return 'Esiste già: $name';
  }

  @override
  String aliasBelongsTo(String alias, String name) {
    return '“$alias” appartiene già a “$name” — meglio unire i due.';
  }

  @override
  String get recipeMatchTitle => 'Recipe Match';

  @override
  String get recipeMatchShuffle => 'Mescola';

  @override
  String recipeMatchCardsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ricette nel mazzo',
      one: '1 ricetta nel mazzo',
    );
    return '$_temp0';
  }

  @override
  String get recipeMatchNext => 'Avanti';

  @override
  String get recipeMatchKeep => 'Sul vassoio';

  @override
  String get recipeMatchKept => 'Messa sul vassoio';

  @override
  String get recipeMatchAnyTime => 'Qualsiasi durata';

  @override
  String recipeMatchMaxTime(int minutes) {
    return '≤ $minutes min';
  }

  @override
  String get recipeMatchEmpty => 'Nessuna ricetta corrispondente';

  @override
  String get recipeMatchEmptyHint => 'Cambia i filtri o svuota il vassoio.';

  @override
  String get recipeMatchResetFilters => 'Ripristina filtri';

  @override
  String get recipeMatchFlipHint => 'Tocca: ingredienti · istruzioni';

  @override
  String get recipeMatchFlipBack => 'Gira di nuovo';

  @override
  String get recipeMatchOpenRecipe => 'Ricetta completa';

  @override
  String get recipeMatchOnHand => 'disponibile';

  @override
  String get recipeMatchTray => 'Vassoio';

  @override
  String get recipeMatchTrayEmpty => 'Ancora vuoto – trascina giù una carta';

  @override
  String recipeMatchTrayCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ricette',
      one: '1 ricetta',
    );
    return '$_temp0';
  }

  @override
  String get recipeMatchClear => 'Resetta';

  @override
  String get recipeMatchTrayHint =>
      'Resta finché non lo svuoti – anche quando chiudi il mazzo.';

  @override
  String get recipeMatchRemove => 'Togli dal vassoio';

  @override
  String get recipeMatchToMealplan => 'Aggiungi al piano alimentare';

  @override
  String get recipeMatchToShopping => 'Ingredienti nella lista della spesa';

  @override
  String get recipeMatchSelectIngredients => 'Seleziona ingredienti';

  @override
  String get recipeMatchNoList => 'Seleziona prima una lista della spesa.';

  @override
  String get recipeMatchList => 'Lista';

  @override
  String get recipeMatchOnHandHint =>
      'Gli ingredienti disponibili sono già deselezionati.';

  @override
  String recipeMatchAddCount(int selected, int total) {
    return 'Aggiungi $selected di $total ingredienti';
  }

  @override
  String get recipeMatchNoDay => 'Nessun giorno ancora – resta sul vassoio';

  @override
  String recipeMatchAddMeals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Aggiungi $count pasti',
      one: 'Aggiungi 1 pasto',
    );
    return '$_temp0';
  }

  @override
  String recipeMatchMealsAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pasti aggiunti',
      one: '1 pasto aggiunto',
    );
    return '$_temp0';
  }

  @override
  String get recipeMatchSwipeUp => 'Scorri verso l\'alto per aprire il vassoio';

  @override
  String get weekPlannerTitle => 'Pianifica la settimana';

  @override
  String get weekPlannerStepDays => 'Giorni';

  @override
  String get weekPlannerStepPrefs => 'Opzioni';

  @override
  String get weekPlannerStepPreview => 'Anteprima';

  @override
  String get weekPlannerDaysTitle => 'Quali pasti deve riempire l\'app?';

  @override
  String get weekPlannerDaysHint =>
      'Tocca le caselle. Ciò che è già pianificato resta com\'è.';

  @override
  String get weekPlannerPresetWeekdays => 'Giorni feriali';

  @override
  String get weekPlannerPlanned => 'pianificato';

  @override
  String get weekPlannerMoreMeals => 'Mostra più pasti';

  @override
  String get weekPlannerFewerMeals => 'Meno pasti';

  @override
  String weekPlannerMealCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pasti',
      one: '1 pasto',
    );
    return '$_temp0';
  }

  @override
  String get weekPlannerPrefsTitle => 'A cosa deve fare attenzione l\'app?';

  @override
  String get weekPlannerPrefsHint =>
      'Tutto facoltativo – senza scelta prende un mix vario delle tue ricette.';

  @override
  String get weekPlannerQuick => 'Veloce nei giorni feriali';

  @override
  String weekPlannerQuickSub(int minutes) {
    return 'Lun–Ven al massimo $minutes min';
  }

  @override
  String get weekPlannerStale => 'Prima quelle non cucinate da tempo';

  @override
  String get weekPlannerStaleSub =>
      'in base a “Ultima preparazione” e al piano alimentare';

  @override
  String get weekPlannerFavorites => 'Pianifica più spesso i preferiti';

  @override
  String get weekPlannerFavoritesSub => 'ricette con il cuore e ben valutate';

  @override
  String get weekPlannerVariety => 'Varietà';

  @override
  String get weekPlannerVarietySub => 'nessuna categoria due volte di seguito';

  @override
  String get weekPlannerOnlyFrom => 'Solo da';

  @override
  String get weekPlannerDiceRules => 'Usa le regole del dado';

  @override
  String get weekPlannerDiceRulesSub =>
      'la tua scelta per pasto dalle impostazioni del piano alimentare';

  @override
  String weekPlannerMatching(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ricette corrispondenti',
      one: '1 ricetta corrispondente',
    );
    return '$_temp0';
  }

  @override
  String weekPlannerForMeals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'per $count pasti',
      one: 'per 1 pasto',
    );
    return '$_temp0';
  }

  @override
  String get weekPlannerSuggest => 'Proponi';

  @override
  String get weekPlannerPreviewHint =>
      'Il dado sostituisce, il lucchetto mantiene. Tieni premuto un piatto e trascinalo su un altro giorno per scambiarli.';

  @override
  String get weekPlannerRerollAll => 'Ritira tutto';

  @override
  String get weekPlannerReroll => 'Ritira';

  @override
  String get weekPlannerLock => 'Blocca';

  @override
  String get weekPlannerUnlock => 'Sblocca';

  @override
  String get weekPlannerReasonNever => 'mai cucinata';

  @override
  String get weekPlannerReasonStale => 'non cucinata da tempo';

  @override
  String get weekPlannerReasonFavorite => 'Preferito';

  @override
  String get weekPlannerNoMatch => 'Nessuna ricetta corrispondente';

  @override
  String get weekPlannerThenShopping =>
      'Poi scegli gli ingredienti per la lista della spesa';

  @override
  String get weekPlannerMostlyEmpty => 'Settimana quasi vuota';

  @override
  String weekPlannerMostlyEmptySub(int free, int total) {
    return '$free giorni su $total ancora liberi – riempili in tre passaggi.';
  }

  @override
  String get previousWeek => 'Settimana precedente';

  @override
  String get nextWeek => 'Settimana successiva';

  @override
  String get weekPlannerAllDays => 'Tutti i giorni';

  @override
  String get weekPlannerWeekend => 'Fine settimana';

  @override
  String get weekPlannerDinners => 'Cene';

  @override
  String get weekPlannerLunches => 'Pranzi';

  @override
  String get weekPlannerAllMeals => 'Tutti i pasti';

  @override
  String get mealplanDayEmpty => 'Niente in programma';

  @override
  String get mealplanDropHere => 'Rilascia qui';

  @override
  String mealplanDayKcal(String kcal) {
    return '$kcal kcal per porzione';
  }

  @override
  String mealplanDayKcalPartial(String kcal) {
    return 'almeno $kcal kcal per porzione';
  }

  @override
  String get globalSearchHint => 'Cerca ricette, articoli, funzioni …';

  @override
  String get globalSearchIntro =>
      'Cerca ricette, articoli della lista della spesa, alimenti e ricettari – e anche funzioni e impostazioni dell\'app, es. “lista”.';

  @override
  String get globalSearchFunctions => 'Funzioni';

  @override
  String globalSearchNoResults(String query) {
    return 'Nessun risultato per “$query”';
  }

  @override
  String get searchClear => 'Cancella ricerca';

  @override
  String get recipeMatchPlanWeek => 'Pianifica la settimana con queste ricette';

  @override
  String get weekPlannerReasonTray => 'dal vassoio';

  @override
  String get emptyBrowseRecipes => 'Sfoglia ricette';

  @override
  String get mealplanWeekShopping => 'Ingredienti per questa settimana';

  @override
  String get globalSearchActions => 'Azioni';

  @override
  String globalSearchAddToList(String text) {
    return 'Aggiungi “$text” alla lista della spesa';
  }

  @override
  String globalSearchAdded(String text) {
    return '“$text” aggiunto';
  }

  @override
  String get globalSearchImportUrl => 'Importa ricetta da questo indirizzo';

  @override
  String get homeContinueCooking => 'Continua a cucinare';

  @override
  String homeCookingStep(int step, int total) {
    return 'Passaggio $step di $total';
  }

  @override
  String get homeCookingPrep => 'Preparazione';

  @override
  String get homeCookingAlmostDone => 'Quasi pronto';

  @override
  String get homeCookingContinue => 'continua';

  @override
  String get paneSelectRecipe => 'Scegli una ricetta a sinistra.';

  @override
  String get mealplanDragRecipeHint =>
      'Trascina una ricetta su un giorno per pianificarla.';

  @override
  String get desktopDropUnsupported =>
      'Questi file non possono essere aggiunti come risorse.';

  @override
  String desktopDropUploaded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count risorse aggiunte',
      one: '1 risorsa aggiunta',
    );
    return '$_temp0';
  }

  @override
  String get desktopDropAsAttachment => 'Rilascia per aggiungere come risorsa';

  @override
  String get printAction => 'Stampa';

  @override
  String get mealplanPrintWeek => 'Stampa settimana';

  @override
  String get mealplanEntryCooked => 'Cucinato';

  @override
  String get recipeSearchClear => 'Cancella ricerca';

  @override
  String get organizerShowRecipes => 'Mostra ricette';

  @override
  String globalSearchShowAllRecipes(int count) {
    return 'Mostra tutte le $count ricette';
  }

  @override
  String get unnamedEntry => '(senza nome)';

  @override
  String get mealplanWholeWeek => 'Per tutta la settimana';

  @override
  String get mealplanWholeWeekDropHint =>
      'Rilascia qui un pasto per pianificarlo per tutta la settimana.';

  @override
  String get mealplanMovedToWholeWeek => 'Pianificato per tutta la settimana';

  @override
  String get mealplanCookToday => 'Lo cucino oggi';

  @override
  String get mealplanPlanWholeWeek => 'Pianifica per tutta la settimana';

  @override
  String mealplanPlanWholeWeekRange(String from, String to) {
    return '$from – $to';
  }

  @override
  String get calendarFeedDuration => 'Durata (minuti)';

  @override
  String get calendarFeedEventDetails => 'Dettagli evento';

  @override
  String calendarFeedEventDetailsHint(String fields) {
    return 'Personalizza come appaiono i pasti nel calendario. Campi unione: $fields';
  }

  @override
  String get calendarFeedEventTitle => 'Titolo evento';

  @override
  String get calendarFeedEventDescription => 'Descrizione evento';

  @override
  String get calendarFeedEventDetailsWarning =>
      'Modificandoli cambia il link del calendario — se ti sei già iscritto, iscriviti di nuovo con il nuovo link.';

  @override
  String get stepDurationMinutes => 'Durata (minuti)';

  @override
  String stepDurationSaved(String duration) {
    return 'Durata salvata: $duration. Modificandola viene sostituita con minuti interi.';
  }

  @override
  String get sortTotalTimeShort => 'Tempo totale più breve';

  @override
  String get sortTotalTimeLong => 'Tempo totale più lungo';

  @override
  String recipeCreatedBy(String name) {
    return 'Creata da $name';
  }

  @override
  String get timelineReplacePhoto => 'Sostituisci foto';

  @override
  String get pasteRecipeTitle => 'Incolla ricetta';

  @override
  String get pasteRecipeDescription =>
      'Incolla una ricetta come JSON (schema.org) o il sorgente HTML di una pagina web.';

  @override
  String get pasteRecipeDescription330 =>
      'Incolla una ricetta esportata da Mealie (JSON) — viene importata con la struttura completa: alimenti, unità e collegamenti ai passaggi. Funzionano anche JSON (schema.org) e il sorgente HTML di una pagina web.';

  @override
  String get pasteRecipeHint => 'Incolla qui JSON o HTML';

  @override
  String get pasteRecipeButton => 'Incolla ricetta';

  @override
  String get pasteRecipeImport => 'Importa';

  @override
  String get aiPromptsTitle => 'Prompt IA';

  @override
  String get aiPromptsTeaser =>
      'Personalizza le istruzioni che Mealie dà al provider IA — per tutte le attività o per ciascuna.';

  @override
  String get aiPromptsDescription =>
      'Personalizza le istruzioni che Mealie fornisce all\'AI per ogni attività. I suggerimenti di Mealia sono scritti in inglese, ma questo non cambia la lingua delle tue ricette: mantengono la lingua della loro origine a meno che tu non scelga di tradurle. Puoi scrivere le tue istruzioni in qualsiasi lingua.';

  @override
  String get aiPromptsGlobal => 'Istruzioni per tutti i Prompt';

  @override
  String get aiPromptsGlobalDescription =>
      'Aggiunte a ogni prompt che produce dati delle ricette, come la creazione delle ricette, l\'analisi degli ingredienti e la traduzione. I prompt di sistema non sono interessati.';

  @override
  String get aiPromptsGlobalPlaceholder => 'es. usare sempre unità metriche.';

  @override
  String get aiPromptsList => 'Prompt';

  @override
  String get aiPromptSystem => 'Sistema';

  @override
  String get aiPromptSystemDescription =>
      'Questo è un prompt di sistema. Trascrive il materiale di partenza in maniera federe prima di essere trasformato in ricetta, così le istruzioni per tutti i prompt non sono aggiunte ogni volta. Non è necessario cambiarlo in quando potrebbe rendere l\'importazione meno affidabile.';

  @override
  String get aiPromptAppended => 'Accodata';

  @override
  String get aiPromptOverridden => 'Sovrascritto';

  @override
  String get aiPromptModeDefault => 'Predefinito';

  @override
  String get aiPromptModeAppend => 'Aggiungi';

  @override
  String get aiPromptModeOverride => 'Sostituisci';

  @override
  String get aiPromptAppendDescription =>
      'Queste istruzioni vengono aggiunte al prompt di Mealie e, dove i due sono in conflitto, hanno la precedenza.';

  @override
  String get aiPromptOverrideDescription =>
      'Il tuo prompt sostituisce completamente quello di Mealie, quindi i futuri aggiornamenti del prompt di Mealie non verranno applicati. I dati necessari all\'attività, come il tuo elenco di unità, vengono comunque aggiunti dopo il tuo prompt.';

  @override
  String get aiPromptDefaultChanged =>
      'Il prompt di Mealie è cambiato da quando l\'hai sostituito. Confrontalo con il tuo, oppure torna a quello predefinito per usare la nuova versione.';

  @override
  String get aiPromptViewDefault => 'Mostra prompt predefinito';

  @override
  String get aiPromptHideDefault => 'Nascondi prompt predefinito';

  @override
  String get aiPromptSaved => 'Prompt salvato';

  @override
  String get aiPromptSaveFailed => 'Impossibile salvare il prompt';

  @override
  String get aiPromptTitleBuildRecipe => 'Genera Ricetta';

  @override
  String get aiPromptTitleParseIngredients => 'Analizza ingredienti';

  @override
  String get aiPromptTitleRecipeVideo => 'Ricetta da video';

  @override
  String get aiPromptTitleOrganizers => 'Assegna Organizzatori';

  @override
  String get aiPromptTitleTranslate => 'Traduci Ricetta';

  @override
  String get aiPromptTitleCompileSource => 'Leggi la fonte';

  @override
  String get aiPromptTitleTranscribe => 'Trascrivi audio';

  @override
  String get aiPromptDescBuildRecipe =>
      'Trasforma il materiale letto da una pagina web, una foto o un testo in una ricetta strutturata.';

  @override
  String get aiPromptDescParseIngredients =>
      'Usato dall\'analizzatore AI per separare ogni ingrediente in quantità, unità, alimento e nota.';

  @override
  String get aiPromptDescRecipeVideo =>
      'Trasforma la trascrizione e la didascalia di un video in una ricetta.';

  @override
  String get aiPromptDescOrganizers =>
      'Sceglie tag, categorie e strumenti per una ricetta importata.';

  @override
  String get aiPromptDescTranslate =>
      'Traduce una ricetta importata nella lingua che scegli.';

  @override
  String get aiPromptDescCompileSource =>
      'Legge pagine web, foto e testo e ne ricava la ricetta in testo semplice.';

  @override
  String get aiPromptDescTranscribe =>
      'Trascrive l\'audio quando il tuo provider audio non riesce a farlo direttamente.';

  @override
  String get mealplanNoteHint => 'Nota (facoltativa)';

  @override
  String get mealplanEditTitle => 'Modifica voce';

  @override
  String get mealplanEntryTitleLabel => 'Titolo';

  @override
  String get mealplanEntryNoteLabel => 'Nota';

  @override
  String mealplanCreateRecipe(String name) {
    return 'Nuova ricetta “$name”';
  }

  @override
  String get mealplanCreateRecipeSubtitle =>
      'Crea una ricetta vuota, la pianifica e apre l\'editor';

  @override
  String get importOptionsTitle => 'Opzioni di importazione';

  @override
  String get importOptionsHint =>
      'Quanto lavoro fa l\'IA di Mealie sul tuo server durante l\'importazione. Ogni passaggio extra è una richiesta IA a sé – meno sono, più è veloce.';

  @override
  String get importTranslateTitle => 'Traduci ricetta';

  @override
  String get importOrganizersTitle => 'Categorie e tag';

  @override
  String get importOrganizersCreate => 'Aggiungi nuovi';

  @override
  String get importOrganizersExisting => 'Solo esistenti';

  @override
  String get importOrganizersNone => 'Nessuno';

  @override
  String get importOrganizersCreateHint =>
      'L\'IA assegna tag, categorie e strumenti e crea quelli mancanti.';

  @override
  String get importOrganizersExistingHint =>
      'L\'IA usa solo tag, categorie e strumenti già esistenti.';

  @override
  String get importOrganizersNoneHint =>
      'La ricetta viene importata senza tag, categorie e strumenti. Mealie esegue comunque questo passaggio, quindi l\'importazione non diventa più veloce.';

  @override
  String get importStarting => 'Invio al server…';

  @override
  String get importRunning => 'Importazione ricetta…';

  @override
  String get aiImagesRunning => 'L\'IA sta leggendo le pagine…';

  @override
  String get importStreamPhotosTitle =>
      'Importazione foto con avanzamento in tempo reale';

  @override
  String get importStreamPhotosHint =>
      'Mostra ogni passaggio e mantiene aperta la connessione durante importazioni lunghe. Disattiva per caricare in un\'unica richiesta come prima – es. se il proxy blocca lo streaming.';

  @override
  String get weekPlannerDiceRulesMealieSub =>
      'le regole Mealie della tua famiglia (impostazioni del piano alimentare)';

  @override
  String get syncStarted =>
      'Ricaricamento di ricette, immagini e liste dal server…';

  @override
  String get syncDone => 'Tutto aggiornato';

  @override
  String get recipeReloaded => 'Ricetta ricaricata';

  @override
  String get logoutTitle => 'Esci / cambia utente';

  @override
  String get logoutConfirm =>
      'Ricette, liste e modifiche non ancora sincronizzate vengono rimosse da questo dispositivo. Le impostazioni dell\'app e l\'indirizzo del server restano, quindi devi solo accedere di nuovo.';

  @override
  String get reloadRecipe => 'Ricarica dal server';

  @override
  String get wifiServerTitle => 'Indirizzo diverso in Wi-Fi';

  @override
  String get wifiServerHint =>
      'Per lo stesso server con un secondo indirizzo, es. l\'IP locale a casa e ZeroTier, Tailscale o un dominio fuori casa. Nella rete Wi-Fi qui sotto l\'app usa automaticamente questo indirizzo, altrove l\'URL del server sopra.';

  @override
  String get wifiSsidLabel => 'Nome Wi-Fi';

  @override
  String get wifiServerUrl => 'Indirizzo in questa rete Wi-Fi';

  @override
  String get wifiUseCurrent => 'Usa Wi-Fi attuale';

  @override
  String get wifiNameUnavailable =>
      'Impossibile leggere il nome della rete Wi-Fi. Connettiti al Wi-Fi e consenti l\'accesso alla posizione – Android e iOS rivelano il nome solo così.';

  @override
  String wifiServerActive(String ssid) {
    return 'Attivo: indirizzo nella rete Wi-Fi “$ssid”';
  }

  @override
  String wifiServerStandardActive(String ssid) {
    return 'Attivo: URL del server (non su “$ssid”)';
  }

  @override
  String get wifiServerRemove => 'Rimuovi';

  @override
  String get switchUserTitle => 'Cambia utente';

  @override
  String switchUserBody(String name) {
    return '$name resta salvato su questo dispositivo – con tutte le ricette, le liste e le modifiche non ancora sincronizzate. Puoi tornare indietro tramite l\'immagine del profilo o la pagina di accesso.';
  }

  @override
  String get allowBiometricTitle =>
      'Torna indietro con lo sblocco del dispositivo';

  @override
  String get allowBiometricHint =>
      'Face ID, impronta o PIN del dispositivo invece della password. Chiunque possa sbloccare questo dispositivo potrà aprire questo account.';

  @override
  String get allow => 'Consenti';

  @override
  String unlockAccountReason(String name) {
    return 'Passa a $name';
  }

  @override
  String signInAs(String name) {
    return 'Accedi come $name';
  }

  @override
  String wrongAccountError(String name) {
    return 'Questo è l\'account “$name”. Accedi con l\'account salvato.';
  }

  @override
  String get accountSaveOffline =>
      'Impossibile salvare l\'account ora – il server non è raggiungibile.';

  @override
  String get signOutRemoveTitle => 'Esci e rimuovi';

  @override
  String get signOutRemoveConfirm =>
      'Questo account e tutti i suoi dati su questo dispositivo (ricette, liste, modifiche non ancora sincronizzate) vengono rimossi. Le impostazioni dell\'app restano.';

  @override
  String get removeSavedAccount => 'Rimuovi da questo dispositivo';

  @override
  String removeSavedAccountConfirm(String name) {
    return 'Rimuovere “$name” e tutti i suoi dati salvati da questo dispositivo? Le modifiche non ancora sincronizzate andranno perse.';
  }

  @override
  String get savedAccountsTitle => 'Account salvati';

  @override
  String get addAccount => 'Aggiungi un altro account';

  @override
  String get biometricOff => 'Non usare più lo sblocco del dispositivo';

  @override
  String get orNewAccount => 'Oppure accedi con un altro account:';

  @override
  String get importVideoTitle => 'Link video';

  @override
  String get importVideoFast => 'Veloce';

  @override
  String get importVideoThorough => 'Accurato (IA)';

  @override
  String get importVideoFastHint =>
      'Mealie trascrive il video e crea la ricetta con un\'unica richiesta IA – di solito molto più veloce. Niente traduzione e niente categorie/tag. Puoi comunque attivare l\'IA per singola importazione.';

  @override
  String get importVideoThoroughHint =>
      'L\'interruttore IA si attiva automaticamente per i link video: diversi passaggi IA, con traduzione e categorie/tag come impostato sopra. Richiede più tempo.';

  @override
  String get importPresetFast => 'Veloce';

  @override
  String get importPresetThorough => 'Accurato';

  @override
  String get importPresetCustom => 'Personalizzato';

  @override
  String get importPresetFastTitle =>
      'Meno passaggi IA possibili – l\'attesa più breve';

  @override
  String get importPresetFastVideo =>
      'Link video: Mealie trascrive il video e crea la ricetta con un\'unica richiesta IA (l\'interruttore IA resta spento).';

  @override
  String get importPresetFastTranslate =>
      'Nessuna traduzione – la ricetta resta nella lingua originale.';

  @override
  String get importPresetFastOrganizers =>
      'Vengono assegnati solo categorie e tag esistenti, non ne vengono creati di nuovi.';

  @override
  String get importPresetThoroughTitle =>
      'L\'importazione IA completa di Mealie – richiede più tempo, ottiene il massimo';

  @override
  String get importPresetThoroughVideo =>
      'I link video vengono importati automaticamente con l\'IA – in più passaggi (raccolta della fonte, creazione della ricetta, …).';

  @override
  String get importPresetThoroughTranslate =>
      'La ricetta viene tradotta nella lingua di importazione qui sotto se è scritta in un\'altra lingua.';

  @override
  String get importPresetThoroughOrganizers =>
      'Vengono assegnati categorie e tag adatti; quelli mancanti vengono creati.';

  @override
  String get importPresetCustomTitle => 'Imposta ogni opzione da solo';

  @override
  String get importPresetCustomBody =>
      'Parti da ciò che faceva la scelta precedente e cambia solo quello che ti serve – es. importazioni video veloci ma con traduzione.';

  @override
  String get sidebarPinHint =>
      'Suggerimento: tieni premuto un riquadro e trascinalo sulla barra laterale per fissarlo lì.';

  @override
  String get sidebarDropHere => 'Rilascia qui';

  @override
  String sidebarShortcutTitle(String name) {
    return 'Scorciatoia per “$name”';
  }

  @override
  String sidebarShortcutPrompt(String modifier) {
    return 'Ora premi la combinazione di tasti che vuoi, incluso $modifier.';
  }

  @override
  String get sidebarShortcutTaken => 'Questa combinazione è già in uso.';

  @override
  String get sidebarShortcutNone => 'Nessuna scorciatoia';

  @override
  String get sidebarShortcutChange => 'Cambia scorciatoia';

  @override
  String get sidebarUnpin => 'Rimuovi dalla barra laterale';

  @override
  String sidebarFull(int count) {
    return 'La barra laterale è piena – al massimo $count voci personali.';
  }

  @override
  String get tabletSidebar => 'Barra laterale in orizzontale';

  @override
  String get tabletSidebarSubtitle =>
      'Mostra la navigazione a sinistra invece che in basso quando il tablet è in orizzontale';

  @override
  String get filterDateCreated => 'Data di Creazione';

  @override
  String get filterDateUpdated => 'Data di aggiornamento';

  @override
  String get errorUploadTooLarge =>
      'Il file è troppo grande per questo server Mealie. Il limite di caricamento del server può essere aumentato con MAX_UPLOAD_SIZE_MB.';

  @override
  String get recipeDownloadPdfMealie => 'Scarica PDF (layout di Mealie)';

  @override
  String get mealplanNoteMore => 'Mostra di più…';

  @override
  String get mealplanNoteLess => 'Mostra meno';

  @override
  String get ingredientCommonlySubstitutedWith =>
      'Di solito si sostituisce con';

  @override
  String requiresMealieVersion(String version) {
    return 'Richiede Mealie $version o successivo.';
  }

  @override
  String get apiTokensTitle => 'API Token';

  @override
  String get apiTokensDescription =>
      'Gestisci i tuoi Token API per l\'accesso da applicazioni esterne.';

  @override
  String get apiTokenNameLabel => 'Nome Token';

  @override
  String get apiTokenGenerate => 'Genera';

  @override
  String get apiTokensActive => 'TOKEN ATTIVI';

  @override
  String get apiTokenCopyWarning =>
      'Copia questo token in modo da utilizzarlo con una applicazione esterna. Questo token non sarà più visibile.';

  @override
  String get apiTokenThisApp => 'Usato da questa app';

  @override
  String get apiTokenThisAppHint =>
      'Questo token mantiene l\'accesso dell\'app e non può essere eliminato qui.';

  @override
  String apiTokenDeleteConfirm(String name) {
    return 'Eliminare il token “$name”? Le app che lo usano perdono subito l\'accesso.';
  }

  @override
  String get apiTokensEmpty => 'Ancora nessun token.';

  @override
  String apiTokenCreatedOn(String date) {
    return 'Creato il $date';
  }

  @override
  String get apiTokenCopied => 'Token copiato';

  @override
  String get qfOpHasNoValue => 'non ha un valore';

  @override
  String get qfOpHasValue => 'ha un valore';

  @override
  String get ratingHouseholdAverage => 'media famiglia';

  @override
  String get stepLinkedNotes => 'Note collegate';

  @override
  String get noteFallbackTitle => 'Nota';

  @override
  String get aiPromptTitleEnrichInstructions => 'Aggiungi dettagli ai passaggi';

  @override
  String get aiPromptDescEnrichInstructions =>
      'Collega ogni passaggio di una ricetta importata agli ingredienti e alle note che usa e ne individua durata e titolo.';

  @override
  String get loginAccountLocked => 'Account bloccato. Riprova più tardi';

  @override
  String get loginPasswordDisabled =>
      'L\'accesso con password è disattivato su questo server. Usa invece un token API.';

  @override
  String get unitSystemTitle => 'Unità';

  @override
  String get unitSystemAsWritten => 'Come scritto';

  @override
  String get unitSystemMetric => 'Sistema Metrico';

  @override
  String get unitSystemMetricHint => 'Sistema Metrico (g, ml)';

  @override
  String get unitSystemImperial => 'Sistema imperiale';

  @override
  String get unitSystemImperialHint => 'Sistema imperiale (tazze, oz)';

  @override
  String get unitSystemHint =>
      'Solo la visualizzazione – la ricetta resta invariata. Come nella web app di Mealie, la scelta vale per tutte le ricette su questo dispositivo.';

  @override
  String get unitSystemUnavailable =>
      'Nessuna unità di questa ricetta può essere convertita. Serve una standardizzazione dell\'unità in Mealie (Alimenti e unità → unità → Standardizzazione).';

  @override
  String get shoppingCheckAll => 'Seleziona Tutti Gli Elementi';

  @override
  String get shoppingUncheckAll => 'Deseleziona tutti gli elementi';

  @override
  String get shoppingDeleteChecked => 'Elimina selezionati';

  @override
  String get shoppingCheckAllConfirm =>
      'Sei sicuro di voler selezionare tutti gli elementi?';

  @override
  String get shoppingUncheckAllConfirm =>
      'Sei sicuro di voler deselezionare tutti gli elementi?';

  @override
  String shoppingItemCheckedOff(String item) {
    return '$item selezionato';
  }

  @override
  String get updateGithubUnavailable =>
      'GitHub non risponde al momento. Riprova tra qualche minuto.';
}
