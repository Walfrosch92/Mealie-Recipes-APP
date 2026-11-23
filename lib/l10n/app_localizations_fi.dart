// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Finnish (`fi`).
class AppLocalizationsFi extends AppLocalizations {
  AppLocalizationsFi([String locale = 'fi']) : super(locale);

  @override
  String get endCookingMode => 'Lopeta kokkitila';

  @override
  String get endCookingModeConfirm => 'Haluatko varmasti lopettaa kokkitilan?';

  @override
  String endCookingModeConfirmAll(int count) {
    return 'Kaikki $count reseptiä lopetetaan kokkitilassa. Jatketaanko?';
  }

  @override
  String get addTimer => 'Lisää ajastin';

  @override
  String get recipeFinished => 'Ruokasi on valmis.';

  @override
  String get bonAppetit => 'Hyvää ruokahalua!';

  @override
  String get prepareIngredients => 'Valmistele seuraavat ainesosat';

  @override
  String prepareIngredientsFor(String servings) {
    return 'Valmistele seuraavat ainesosat $servings annokselle';
  }

  @override
  String get next => 'Seuraava';

  @override
  String get navHome => 'Koti';

  @override
  String get homeCookToday => 'Tänään kokataan';

  @override
  String get homeSuggestion => 'Ehdotus';

  @override
  String get homeQuickAccess => 'Pikavalinnat';

  @override
  String get homePlanned => 'Suunniteltu';

  @override
  String get favorite => 'Suosikki';

  @override
  String get navSettings => 'Asetukset';

  @override
  String homeWelcomeName(Object name) {
    return 'Tervetuloa $name,';
  }

  @override
  String get homeWelcomeApp => 'Mealie Recipesiin 👋';

  @override
  String get theme => 'Ulkoasu';

  @override
  String get themeSystem => 'Järjestelmä';

  @override
  String get themeLight => 'Vaalea';

  @override
  String get themeDark => 'Tumma';

  @override
  String get recipes => 'Reseptit';

  @override
  String get shoppingList => '🛒 Ostoslista';

  @override
  String get mealplan => 'Ateriasuunnitelma';

  @override
  String get settings => '⚙️ Asetukset';

  @override
  String get searchRecipe => 'Hae reseptiä...';

  @override
  String get loadingRecipe => 'Ladataan reseptiä...';

  @override
  String get errorLoadingRecipe => 'Reseptiä ei voitu ladata.';

  @override
  String get noRecipesForCategory => 'Tälle suodattimelle ei ole reseptejä.';

  @override
  String get resetFilter => 'Nollaa suodatin';

  @override
  String get allCategories => 'Kaikki kategoriat';

  @override
  String get all => 'Kaikki';

  @override
  String get sortRecipes => 'Lajittele reseptit';

  @override
  String get refreshRecipes => 'Päivitä';

  @override
  String get sortNameAZ => 'Nimi A–Ö';

  @override
  String get sortNameZA => 'Nimi Ö–A';

  @override
  String get sortDateNewest => 'Uusimmat ensin';

  @override
  String get sortDateOldest => 'Vanhimmat ensin';

  @override
  String get sortPrepTimeShort => 'Lyhin valmisteluaika';

  @override
  String get sortPrepTimeLong => 'Pisin valmisteluaika';

  @override
  String get sortRatingHighest => 'Paras arvosana';

  @override
  String get sortRatingLowest => 'Heikoin arvosana';

  @override
  String get details => 'Tiedot';

  @override
  String get ingredients => 'Ainesosat';

  @override
  String get instructions => 'Ohjeet';

  @override
  String get tags => 'Tunnisteet';

  @override
  String get notes => 'Merkinnät';

  @override
  String get addNote => 'Lisää merkintä';

  @override
  String get editNote => 'Muokkaa merkintää';

  @override
  String get noteTitleHint => 'Otsikko (valinnainen)';

  @override
  String get noteTextHint => 'Merkinnän teksti';

  @override
  String get deleteNoteTitle => 'Poistetaanko merkintä?';

  @override
  String get deleteNoteMessage => 'Tämä merkintä poistetaan pysyvästi.';

  @override
  String get servings => 'Annokset';

  @override
  String get planMeal => 'Suunnittele ateria';

  @override
  String get addAllIngredients => 'Lisää kaikki ainesosat';

  @override
  String get addSelectedIngredients => 'Lisää valitut ainesosat';

  @override
  String get addIngredientsMessage => 'Ainesosat on lisätty ostoslistaasi.';

  @override
  String addIngredientsFailedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ainesosaa ei voitu lisätä.',
      one: '1 ainesosaa ei voitu lisätä.',
    );
    return '$_temp0';
  }

  @override
  String get cookbooks => 'Keittokirjat';

  @override
  String get cookbooksEmpty =>
      'Ei vielä keittokirjoja. Luo uusi napauttamalla “+” oikeassa yläkulmassa.';

  @override
  String get cookbookNoMatches => 'Mikään resepti ei vastaa tätä suodatinta.';

  @override
  String get cookbookCreateTitle => 'Luo keittokirja';

  @override
  String get cookbookEditTitle => 'Muokkaa keittokirjaa';

  @override
  String get cookbookNameLabel => 'Keittokirjan nimi';

  @override
  String get cookbookFilterSectionTitle => 'Lisää reseptit automaattisesti';

  @override
  String get cookbookFieldTools => 'Keittiövälineet';

  @override
  String get cookbookFieldUsers => 'Käyttäjät';

  @override
  String get cookbookOpIsOneOf => 'on yksi näistä';

  @override
  String get cookbookOpIsNotOneOf => 'ei ole yksi näistä';

  @override
  String get cookbookOpContainsAll => 'sisältää kaikki';

  @override
  String get cookbookSelectValues => 'Valitse arvot';

  @override
  String get cookbookFilterOptionsUnavailable => 'Ei vaihtoehtoja saatavilla';

  @override
  String get cookbookAddFilterField => 'Lisää kenttä';

  @override
  String get cookbookPublicLabel => 'Julkinen keittokirja';

  @override
  String get cookbookPublicSubtitle =>
      'Näkyy palvelimen muille kotitalouksille';

  @override
  String get cookbookRawModeEnter => 'Muokkaa tekstinä';

  @override
  String get cookbookRawModeExit => 'Takaisin rakentajaan';

  @override
  String get cookbookRawModeHint =>
      'Sovelluksen asiantuntijatila: muokkaa suodatinta suoraan tekstinä. Hyödyllinen, kun olemassa olevaa suodatinta ei voitu jakaa yksinkertaisiksi riveiksi.';

  @override
  String get cookbookRawModeUnparseable =>
      'Tämä teksti ei vastaa yksinkertaista rivimuotoa — se säilyy tekstinä.';

  @override
  String get saveFailed => 'Tallennus epäonnistui';

  @override
  String get search => 'Hae';

  @override
  String get apply => 'Käytä';

  @override
  String get setupCachingTitle => 'Ladataan reseptejäsi';

  @override
  String get setupCachingSubtitle =>
      'Reseptejäsi valmistellaan offline-käyttöön. Niiden määrästä riippuen tämä voi kestää hetken.';

  @override
  String get setupCachingDone => 'Kaikki valmista!';

  @override
  String get setupTipsHeader => 'Tiesitkö?';

  @override
  String get setupFinish => 'Aloitetaan';

  @override
  String get setupSkipCaching => 'Jatka taustalla';

  @override
  String get setupTip1 =>
      'Voit tuoda reseptejä linkistä, kuvasta tai PDF:stä — aloitusnäytön Tuo-ruudun kautta.';

  @override
  String get setupTip2 =>
      'Kokkitila pitää näytön päällä, opastaa vaihe vaiheelta ja tunnistaa ajastimet tekstistä automaattisesti.';

  @override
  String get setupTip3 =>
      'Ostoslista toimii myös offline-tilassa — muutokset synkronoituvat automaattisesti, kun palvelin on tavoitettavissa.';

  @override
  String get setupTip4 =>
      'Järjestä pikavalinnat uudelleen pitämällä aloitusnäytön ruutua painettuna.';

  @override
  String get setupTip5 =>
      'Mealie-keittokirjasi löydät Keittokirjat-ruudusta — myös offline-tilassa.';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Peruuta';

  @override
  String get delete => 'Poista';

  @override
  String get edit => 'Muokkaa';

  @override
  String get save => 'Tallenna';

  @override
  String get done => 'Valmis';

  @override
  String get close => 'Sulje';

  @override
  String get add => 'Lisää';

  @override
  String get send => 'Lähetä';

  @override
  String get retry => 'Yritä uudelleen';

  @override
  String get confirmDeleteTitle => 'Poistetaanko resepti?';

  @override
  String get confirmDeleteMessage => 'Tätä toimintoa ei voi kumota.';

  @override
  String get sendToDevice => 'Lähetä laitteeseen';

  @override
  String get timerFinished => 'Ajastin päättyi!';

  @override
  String get timer => 'Ajastin';

  @override
  String get newTimer => 'Uusi ajastin';

  @override
  String get timerNamePlaceholder => 'Ajastimen nimi';

  @override
  String get durationLabel => 'Kesto';

  @override
  String get start => 'Aloita';

  @override
  String get stop => 'Pysäytä';

  @override
  String get pause => 'Tauko';

  @override
  String get resume => 'Jatka';

  @override
  String get finished => 'Valmis!';

  @override
  String stepNumber(int number) {
    return 'Vaihe $number';
  }

  @override
  String get minAbbreviation => 'min';

  @override
  String get cookingMode => 'Kokkitila';

  @override
  String get endAll => 'Lopeta kaikki';

  @override
  String get end => 'Lopeta';

  @override
  String get noActiveTimers => 'Ei aktiivisia ajastimia';

  @override
  String get noActiveRecipes => 'Ei aktiivisia reseptejä';

  @override
  String get startRecipeToCook =>
      'Avaa resepti ja aloita napauttamalla kokkitilan painiketta.';

  @override
  String get browseRecipes => 'Selaa reseptejä';

  @override
  String get cookFriends => 'Kokkaa ystävien kanssa';

  @override
  String get cookingModeAddRecipe => 'Lisää resepti';

  @override
  String get cookingModeAddRecipeSearchHint => 'Hae reseptejä';

  @override
  String get cookFriendsCode => 'Istunnon koodi';

  @override
  String get cookFriendsJoin => 'Liity istuntoon';

  @override
  String get cookFriendsHost => 'Isännöi istuntoa';

  @override
  String get cookFriendsHostNotFound =>
      'Isäntää ei löytynyt. Varmista, että molemmat laitteet ovat samassa Wi-Fi-verkossa ja että lähiverkon käyttö on sallittu.';

  @override
  String get cookFriendsConnectionFailed =>
      'Yhteys epäonnistui. Yritä uudelleen.';

  @override
  String get cookFriendsEnterCode => 'Syötä koodi';

  @override
  String cookFriendsConnected(int count) {
    return 'Yhdistetty: $count vierasta';
  }

  @override
  String get joinSession => 'Liity istuntoon';

  @override
  String get hostEndedSessionMessage => 'Isäntä lopetti kokkausistunnon.';

  @override
  String get addItem => 'Lisää kohde';

  @override
  String get itemNote => 'Tuotteen nimi';

  @override
  String get unlabeledCategory => 'Ei tunnistetta';

  @override
  String get archivedLists => '📦 Arkistoidut ostokset';

  @override
  String get postimportAction => 'Tuonnin jälkeen';

  @override
  String get postimportHint =>
      'Valitse, mitä tuoduille merkinnöille tapahtuu lähdesovelluksessa (Muistutukset / Google Tasks).';

  @override
  String get postimportLeave => 'Vain lisää';

  @override
  String get postimportComplete => 'Merkitse tehdyksi';

  @override
  String get postimportCompleteDelete => 'Merkitse tehdyksi ja poista';

  @override
  String get postimportFailed =>
      'Jälkikäsittely lähdesovelluksessa epäonnistui. Tuotteet lisättiin silti Mealieen.';

  @override
  String get syncChangesTitle => 'Synkronoi muutokset';

  @override
  String get syncSectionChecked => 'Merkityt';

  @override
  String get syncSectionQuantity => 'Määrä';

  @override
  String get syncSectionCategory => 'Kategoria';

  @override
  String get syncSectionAdditions => 'Uudet lisäykset';

  @override
  String get syncLocalLabel => 'Paikallinen';

  @override
  String get syncServerLabel => 'Palvelin';

  @override
  String get syncNow => 'Synkronoi nyt';

  @override
  String get offlineBadge => 'Offline';

  @override
  String get mealplanTitle => '📅 Ateriasuunnitelma';

  @override
  String get breakfast => 'Aamiainen';

  @override
  String get lunch => 'Lounas';

  @override
  String get dinner => 'Päivällinen';

  @override
  String get addMealEntry => 'Lisää ateria';

  @override
  String get selectRecipe => 'Valitse resepti';

  @override
  String get importRecipe => 'Tuo resepti';

  @override
  String get url => 'URL';

  @override
  String get importLanguage => 'OCR-kieli';

  @override
  String get setupTitle => 'Tervetuloa Mealie Recipesiin';

  @override
  String get setupSubtitle => 'Määritä Mealie-palvelimesi.';

  @override
  String get serverUrl => 'Palvelimen URL';

  @override
  String get serverUrlPlaceholder => 'https://mealie.example.com';

  @override
  String get apiToken => 'API-tokeni';

  @override
  String get apiTokenPlaceholder => 'API-tunnuksesi';

  @override
  String get householdId => 'Kotitalous';

  @override
  String get householdIdPlaceholder => 'Perhe';

  @override
  String get shoppingListId => 'Ostoslistan ID';

  @override
  String get setupHouseholdListTitle => 'Kotitalous ja ostoslista';

  @override
  String get shoppingListLabel => 'Ostoslista';

  @override
  String get setupHouseholdManualHint =>
      'Kotitalouksia ei voitu ladata — syötä kotitalouden nimi käsin.';

  @override
  String get setupExactTitle => 'Määrät ostoslistalla';

  @override
  String get setupExactBody =>
      'Useimmissa maissa ei osteta gramman tarkkuudella — ostoskoriin laitetaan 1 paketti voita, ei 200 g. Yksinkertaisessa tilassa sovellus muuntaa siksi reseptin määrät muotoon “1×”. Tarkassa tilassa määrä ja yksikkö säilyvät 1:1 kuten Mealien verkkosovelluksessa — myös uusia tuotteita kirjoitettaessa (esim. “200 g voita”). Voit muuttaa tätä milloin tahansa asetuksissa.';

  @override
  String get setupExactSimpleTitle => 'Yksinkertainen tila (1×)';

  @override
  String get setupExactSimpleBody =>
      'Ainesosat päätyvät listalle muodossa “1× tuote” — ihanteellinen nopeaan merkitsemiseen kaupassa.';

  @override
  String get setupExactExactTitle => 'Tarkat määrät';

  @override
  String get setupExactExactBody =>
      'Tuotteet näkyvät määrän ja yksikön kanssa, esim. “200 g voita” — täsmälleen kuten verkkosovelluksessa.';

  @override
  String get connect => 'Yhdistä';

  @override
  String connectionError(String error) {
    return 'Yhteys epäonnistui: $error';
  }

  @override
  String get optionalHeaders =>
      'Valinnaiset HTTP-otsakkeet (käänteisvälityspalvelimelle)';

  @override
  String get settingsTitle => '⚙️ Asetukset';

  @override
  String get settingsSaved => 'Asetukset tallennettu';

  @override
  String get securitySettings => 'Tietoturva';

  @override
  String get showRecipeImages => 'Näytä reseptikuvat';

  @override
  String get apiVersion => 'API-versio';

  @override
  String get language => 'Kieli';

  @override
  String get biometricLock => 'Biometrinen lukitus';

  @override
  String get biometricLockDescription => 'Avaa sovellus biometriikalla';

  @override
  String get enableLogging => 'Ota lokitus käyttöön';

  @override
  String get selectLanguage => 'Valitse kieli';

  @override
  String get setupContinue => 'Jatka';

  @override
  String get back => 'Takaisin';

  @override
  String get setupConnectStep => 'Yhdistä palvelimeesi';

  @override
  String get resetSettings => 'Palauta kaikki asetukset';

  @override
  String get resetSettingsConfirm =>
      'Kaikki asetukset palautetaan. Jatketaanko?';

  @override
  String get guestMode => 'Vierastila';

  @override
  String get appVersion => 'Versio';

  @override
  String get leftoverFinder => 'Reseptihaku';

  @override
  String get addIngredient => 'Lisää ainesosa';

  @override
  String get biometricPrompt => 'Tunnistaudu avataksesi Mealie Recipesin';

  @override
  String get biometricFailed => 'Tunnistautuminen epäonnistui';

  @override
  String get pendingRecipesTitle => 'Vastaanotetut reseptit';

  @override
  String pendingRecipesFrom(Object names) {
    return 'Lähettäjä $names';
  }

  @override
  String get pendingRecipesOpenCooking => 'Avaa kokkitila';

  @override
  String get dismiss => 'Ohita';

  @override
  String get editRecipe => 'Muokkaa reseptiä';

  @override
  String get recipeName => 'Reseptin nimi';

  @override
  String get prepTime => 'Valmisteluaika (min)';

  @override
  String get cookTime => 'Kypsennysaika (min)';

  @override
  String get totalTime => 'Kokonaisaika (min)';

  @override
  String get recipeServings => 'Annokset';

  @override
  String get rating => 'Arvosana';

  @override
  String get addIngredientLine => 'Lisää ainesosa';

  @override
  String get addInstruction => 'Lisää vaihe';

  @override
  String get removeIngredient => 'Poista ainesosa';

  @override
  String get removeInstruction => 'Poista vaihe';

  @override
  String get ingredientName => 'Aineosa';

  @override
  String get ingredientQuantity => 'Määrä';

  @override
  String get ingredientUnit => 'Yksikkö';

  @override
  String get ingredientNote => 'Merkintä';

  @override
  String get instructionText => 'Vaiheen teksti';

  @override
  String get categories => 'Kategoriat';

  @override
  String get saveChanges => 'Tallenna muutokset';

  @override
  String get saveSuccess => 'Resepti tallennettu.';

  @override
  String get newCategory => 'Uusi kategoria';

  @override
  String get newTag => 'Uusi tunniste';

  @override
  String get setRating => 'Anna arvosana';

  @override
  String get homeWelcome => 'Tervetuloa Mealie Recipesiin! 👋';

  @override
  String homeWelcomeNamed(String name) {
    return 'Tervetuloa $name, Mealie Recipesiin! 👋';
  }

  @override
  String get shopping => 'Ostokset';

  @override
  String get planning => 'Suunnittelu';

  @override
  String get other => 'Muut';

  @override
  String get addRecipe => '➕ Lisää resepti';

  @override
  String get completeShopping => 'Päätä ostokset';

  @override
  String get shoppingCompleted => 'Ostokset tehty';

  @override
  String get shoppingCompletedSubtitle => 'Kaikki korissa! 🎉';

  @override
  String get shoppingOfflineNoCache => 'Offline – listaa ei ole tallennettu';

  @override
  String get shoppingOfflineNoCacheSubtitle =>
      'Tämän listan tuotteita ei ole vielä tallennettu tähän laitteeseen. Lista latautuu heti, kun olet taas verkossa.';

  @override
  String get essensplan => '📅 Ateriasuunnitelma';

  @override
  String get resteverwertung => '🥗 Reseptihaku';

  @override
  String get copyCode => 'Kopioi koodi';

  @override
  String get shareLink => 'Jaa linkki';

  @override
  String get connectedFriends => 'Yhdistetyt ystävät';

  @override
  String get waitingForFriends => 'Odotetaan ystäviä...';

  @override
  String get sessionCode => 'ISTUNNON KOODI';

  @override
  String get loading => 'Ladataan...';

  @override
  String get urlInvalidScheme =>
      'URL-osoitteen on alettava http:// tai https://';

  @override
  String get urlAddScheme => 'Lisää https://';

  @override
  String get addItemPlaceholder => 'Lisää tuote...';

  @override
  String get completedItems => 'Valmiit';

  @override
  String get completeShoppingTitle => 'Päätetäänkö ostokset?';

  @override
  String get completeShoppingMessage => 'Poistetaanko merkityt tuotteet?';

  @override
  String get recipeListTitle => '📖 Reseptit';

  @override
  String get importRecipeTitle => 'Lataa uusi resepti';

  @override
  String get uploadRecipeUrl => 'Tuo reseptin URL-osoitteella';

  @override
  String get uploadRecipeUrlHint =>
      'Syötä reseptin URL tallentaaksesi sen palvelimellesi';

  @override
  String get uploadOpenAI => 'Tuo tiedostosta OpenAI:n avulla';

  @override
  String get uploadOpenAIHint =>
      'Voit myös ladata kuvia tai reseptin PDF:n. Jos resepti on usealla sivulla, lisää vain useampi — tekoäly analysoi ne yhdessä.';

  @override
  String get takePhoto => 'Kamera';

  @override
  String get cameraPermissionDenied =>
      'Ei pääsyä kameraan. Salli se järjestelmäasetuksissa, jotta voit kuvata reseptejä.';

  @override
  String get cameraUnavailable => 'Laitteessa ei ole kameraa.';

  @override
  String get selectPhoto => 'Kuvat';

  @override
  String get selectPdf => 'PDF';

  @override
  String get openAIHintTitle => 'Tietoa tiedostoanalyysistä';

  @override
  String get openAIHintBody =>
      'Reseptianalyysi käyttää OpenAI:n API:a. Varmista, että API-avain on määritetty Mealie-palvelimen asetuksissa.';

  @override
  String get allDeleteConfirm => 'Poista kaikki';

  @override
  String get entriesInOtherWeeks => 'Muilla viikoilla on merkintöjä';

  @override
  String get availableWeeks => 'Saatavilla olevat viikot:';

  @override
  String get currentWeek => 'Tämä viikko';

  @override
  String get weekAbbreviation => 'Vk';

  @override
  String get today => 'Tänään';

  @override
  String get selectDate => 'Valitse päivä';

  @override
  String get selectedRecipe => 'Valittu resepti';

  @override
  String get confirmMeal => 'Suunnittele ateria';

  @override
  String get searchRecipes => 'Hae reseptejä';

  @override
  String get addCustomMeal => 'Lisää oma ateria';

  @override
  String get diceModeButton => 'Arvo reseptejä';

  @override
  String get diceModeTitle => '3 satunnaista ehdotusta';

  @override
  String get diceBackToSearch => 'Takaisin hakuun';

  @override
  String get diceNotEnoughRecipes =>
      'Liian vähän reseptejä noppatilaan (vähintään 3 tarvitaan)';

  @override
  String get entrySingular => 'merkintä';

  @override
  String get entriesPlural => 'merkintää';

  @override
  String get deleteAllConfirmTitle => 'Poistetaanko kaikki?';

  @override
  String get deleteAllConfirmMessage =>
      'Haluatko poistaa kaikki arkistoidut ostokset?';

  @override
  String get uploadFromUrlButton => 'Tuo resepti URL-osoitteesta';

  @override
  String get uploadingImage => 'Ladataan...';

  @override
  String get uploadErrorTitle => 'Lataus epäonnistui';

  @override
  String get uploadSuccessTitle => 'Lataus onnistui';

  @override
  String get editImportedRecipeQuestion =>
      'Haluatko muokata uutta reseptiä nyt?';

  @override
  String get notNow => 'Ei nyt';

  @override
  String get pdfTooLarge => 'PDF-tiedosto on liian suuri (enint. 10 Mt).';

  @override
  String get invalidUrl =>
      'Virheellinen URL. Syötä kelvollinen HTTP(S)-osoite.';

  @override
  String get cookWithFriends => 'Kokkaa ystävien kanssa';

  @override
  String get cookFriendsSubtitle =>
      'Kutsu ystävä kokkaamaan tätä reseptiä yhdessä';

  @override
  String get copied => 'Kopioitu';

  @override
  String get linkCopied => 'Linkki kopioitu';

  @override
  String get startCooking => 'Aloita kokkaus';

  @override
  String get uploadToOwnServer => 'Tallenna omalle palvelimelleni';

  @override
  String get uploadingRecipe => 'Ladataan reseptiä…';

  @override
  String get recipeUploadedToOwnServer => 'Resepti tallennettu palvelimellesi';

  @override
  String get recipeUploadFailed => 'Lataus epäonnistui';

  @override
  String get allowGuestSaveRecipes =>
      'Salli vieraiden tallentaa reseptejä omalle palvelimelleen';

  @override
  String get appIcon => 'Sovelluksen kuvake';

  @override
  String get name => 'Nimi';

  @override
  String get color => 'Väri';

  @override
  String get randomColor => 'Satunnainen väri';

  @override
  String get createFailed => 'Luominen epäonnistui';

  @override
  String get deleteFailed => 'Poisto epäonnistui';

  @override
  String deleteOrganizerConfirm(String name) {
    return 'Poistetaanko “$name”? Se poistetaan myös palvelimelta.';
  }

  @override
  String get connectionSection => 'Yhteys';

  @override
  String get token => 'Tunnus';

  @override
  String get advancedOptions => 'Lisäasetukset';

  @override
  String get mealieApiVersion => 'Mealien API-versio';

  @override
  String get sendOptionalHeaders => 'Lähetä valinnaiset otsakkeet';

  @override
  String get offlineRecipeImages => 'Tallenna reseptikuvat offline-käyttöön';

  @override
  String get offlineRecipeImagesHint =>
      'Lataa kaikki reseptikuvat laitteeseen – myös vaiheiden ja merkintöjen kuvat – jotta ne näkyvät ilman yhteyttä. Suuret kokoelmat voivat viedä satoja megatavuja. Asetuksen poistaminen käytöstä poistaa tallennetut kuvat.';

  @override
  String offlineRecipeImagesStatus(int count, int total, String size) {
    return 'Tallennettu: $count/$total · $size';
  }

  @override
  String get offlineRecipeImagesDisableConfirm =>
      'Poistetaanko kaikki tallennetut reseptikuvat?';

  @override
  String headerNameLabel(int n) {
    return 'Otsakkeen $n nimi';
  }

  @override
  String headerValueLabel(int n) {
    return 'Otsakkeen $n arvo';
  }

  @override
  String get value => 'Arvo';

  @override
  String get personalization => 'Mukautus';

  @override
  String get showRecipeImagesSubtitle => 'Näyttää kuvat reseptiluettelossa';

  @override
  String get exactQuantities => 'Lisää tarkat määrät';

  @override
  String get exactQuantitiesSubtitle =>
      'Ainesosat ja kirjoitetut tuotteet säilyttävät määrän ja yksikön (esim. 200 g voita) sen sijaan, että jokainen olisi 1×';

  @override
  String get remindToShop => 'Muistuta ostoksista';

  @override
  String get remindToShopSubtitle =>
      'Ilmoittaa, kun olet lähellä tallennettua paikkaa ja ostoslistalla on avoimia tuotteita — myös sovelluksen ollessa suljettuna';

  @override
  String get shoppingReminderAddLocation => 'Lisää paikka';

  @override
  String get shoppingReminderMaxLocations => 'Enintään 3 paikkaa on saavutettu';

  @override
  String get shoppingReminderLocationServiceDisabled =>
      'Sijaintipalvelut ovat pois päältä tässä laitteessa';

  @override
  String get shoppingReminderPermissionTitle =>
      'Sijainnin käyttöoikeus tarvitaan';

  @override
  String get shoppingReminderPermissionMessage =>
      'Jotta voimme muistuttaa sinua kaupan lähellä, tarvitaan sijainnin käyttöoikeus “Aina” — myös sovelluksen ollessa suljettuna. Ota se käyttöön Asetuksissa.';

  @override
  String get openSettings => 'Avaa Asetukset';

  @override
  String get shoppingReminderLocationName => 'Nimi';

  @override
  String get shoppingReminderUseCurrentLocation => 'Käytä nykyistä sijaintia';

  @override
  String get shoppingReminderOrAddress => 'tai syötä osoite';

  @override
  String get shoppingReminderAddress => 'Osoite';

  @override
  String get shoppingReminderAddressPlaceholder => 'Katu, kaupunki';

  @override
  String get shoppingReminderSearchAddress => 'Hae';

  @override
  String get shoppingReminderLocationFailed => 'Sijaintiasi ei voitu määrittää';

  @override
  String get shoppingReminderAddressNotFound => 'Osoitetta ei löytynyt';

  @override
  String get ratingFailed => 'Arvosanaa ei voitu tallentaa — yritä uudelleen.';

  @override
  String get lastCooked => 'Viimeksi tehty';

  @override
  String get syncLastCooked => 'Päivitä “viimeksi tehty”';

  @override
  String get syncLastCookedSubtitle =>
      'Tallentaa tämän päivän ja aikajanamerkinnän palvelimelle — kuten Mealien verkkosovellus.';

  @override
  String get developer => 'Kehittäjä';

  @override
  String get enableLoggingSubtitle =>
      'Tallentaa tulostus- ja virhelokit (viimeiset 500 riviä)';

  @override
  String get entriesLabel => 'Merkinnät';

  @override
  String get fileSize => 'Tiedostokoko';

  @override
  String get showAction => 'Näytä';

  @override
  String get copy => 'Kopioi';

  @override
  String logsWithCount(int count) {
    return 'Lokit ($count)';
  }

  @override
  String get noLogs => 'Ei lokeja';

  @override
  String get logsTitle => 'Lokit';

  @override
  String get required => 'Pakollinen';

  @override
  String get connectionFailedCheck =>
      'Yhteys epäonnistui. Tarkista URL ja tunnus.';

  @override
  String get username => 'Käyttäjänimi';

  @override
  String get password => 'Salasana';

  @override
  String get setupPasswordHint =>
      'Salasanaasi ei tallenneta — sovellus kirjautuu kerran ja luo sen avulla API-tunnuksen (kuten Profiili → API-tunnukset verkkosovelluksessa).';

  @override
  String get loginAndConnect => 'Kirjaudu ja yhdistä';

  @override
  String get loginInvalidCredentials =>
      'Käyttäjätunnus tai salasana on väärin.';

  @override
  String get apiTokenSaveHint =>
      'Tunnus otettu käyttöön — napauta alta “Tallenna muutokset”.';

  @override
  String get renewApiToken => 'Uusi API-tunnus';

  @override
  String get setupAuthChoiceTitle => 'Miten haluat kirjautua?';

  @override
  String get authModePasswordTitle =>
      'Anna sovelluksen luoda API-avain minulle';

  @override
  String get authModePasswordSubtitle =>
      'Kirjaudu käyttäjätunnuksella ja salasanalla — sovellus luo tunnuksen automaattisesti.';

  @override
  String get authModeTokenTitle => 'Minulla on jo API-avain';

  @override
  String get authModeTokenSubtitle =>
      'Kopioitu Mealie-profiilista (Profiili → API-tunnukset).';

  @override
  String keyN(int n) {
    return 'Avain $n';
  }

  @override
  String valueN(int n) {
    return 'Arvo $n';
  }

  @override
  String get openCookingMode => 'Avaa kokkitila';

  @override
  String activeRecipes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count aktiivista reseptiä',
      one: '1 aktiivinen resepti',
    );
    return '$_temp0';
  }

  @override
  String get reparseIngredients => 'Jäsennä ainesosat uudelleen';

  @override
  String get reparseIngredientsSubtitle =>
      'Erottele määrä/yksikkö/ainesosa (esim. “200 g jauhoja”)';

  @override
  String get reparseDone =>
      'Ainesosat eroteltu – napauta “Tallenna muutokset” ottaaksesi käyttöön';

  @override
  String get tagsAndCategories => 'Tunnisteet, kategoriat ja keittiövälineet';

  @override
  String get tapToAddPhoto => 'Lisää kuva napauttamalla';

  @override
  String get descriptionLabel => 'Kuvaus';

  @override
  String get searchingDevices => 'Etsitään laitteita samasta Wi-Fi-verkosta…';

  @override
  String get selectAll => 'Valitse kaikki';

  @override
  String get importReminders => 'Tuo muistutukset';

  @override
  String get importGoogleTasks => 'Tuo Google Tasks';

  @override
  String get noTaskLists => 'Tehtäväluetteloita ei löytynyt';

  @override
  String get noReminderLists => 'Muistutusluetteloita ei löytynyt';

  @override
  String importCount(int count) {
    return 'Tuo $count';
  }

  @override
  String get noIngredientsToLink => 'Ei vielä linkitettäviä ainesosia';

  @override
  String get importLanguageSubtitle =>
      'Kuvasta tai PDF:stä tuotujen reseptien kieli';

  @override
  String get importLanguageSearch => 'Hae kieltä';

  @override
  String get importLanguageFollowApp => 'Sama kuin sovelluksen kieli';

  @override
  String get importLanguageNoMatch => 'Kieltä ei löytynyt';

  @override
  String get setupImportLanguageTitle => 'Reseptien tekoälytuonti';

  @override
  String get setupImportLanguageBody =>
      'Tekoäly voi muuttaa kuvia ja PDF-tiedostoja resepteiksi. Valitse kieli, jolla niiden pitää valmistua — kätevää, jos äidinkielesi ei ole sovelluksen kielenä. Voit muuttaa tätä myöhemmin asetuksissa.';

  @override
  String get setupImportLanguageSearchHint =>
      'Käytä valitsimen hakua löytääksesi kieliä, joita sovelluksen käyttöliittymä ei tarjoa.';

  @override
  String get setupCachingKeepOpenTitle => 'Pidä sovellus auki';

  @override
  String get setupCachingKeepOpenBody =>
      'Lataus tapahtuu etualalla. Pidä sovellus auki, kunnes se on valmis — jos suljet sen tai vaihdat muualle liian pitkäksi aikaa, prosessi pysähtyy ja alkaa myöhemmin alusta.';

  @override
  String get supportContact => 'Ota yhteyttä tukeen';

  @override
  String get supportDialogMessage =>
      'Kuvaile ongelmasi, niin palaamme asiaan. Loki auttaa paljon vianetsinnässä — voit liittää sen tekstitiedostona.';

  @override
  String get supportWithoutLogs => 'Ilman lokia';

  @override
  String get supportWithLogs => 'Liitä loki';

  @override
  String get supportMailSubject => 'Mealie Recipes — Tuki';

  @override
  String get supportMailHint => 'Kuvaile ongelmasi tähän:';

  @override
  String get supportLogsEmpty =>
      'Loki on tyhjä. Ota lokitus käyttöön, toista ongelma ja lähetä se sitten.';

  @override
  String supportAddressCopied(String email) {
    return 'Osoite kopioitu: $email';
  }

  @override
  String supportNoMailApp(String email) {
    return 'Sähköpostisovellusta ei ole määritetty – osoite kopioitu: $email. Valitse toinen sovellus kirjoittaaksesi meille.';
  }

  @override
  String get createRecipeFromImages => 'Luo resepti';

  @override
  String imagePagesSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sivua valittu',
      one: '1 sivu valittu',
    );
    return '$_temp0';
  }

  @override
  String get imagePagesHint =>
      'Ensimmäisestä kuvasta tulee reseptin pääkuva. Muuta järjestystä painamalla sivua pitkään.';

  @override
  String get mainImageBadge => 'Pääkuva';

  @override
  String maxImagesReached(int max) {
    return 'Voit lisätä enintään $max kuvaa reseptiä kohden.';
  }

  @override
  String get removePage => 'Poista sivu';

  @override
  String get preparingPdf => 'Käsitellään PDF:ää...';

  @override
  String get recipeOptionsTitle => 'Valinnat';

  @override
  String get exportAsPdf => 'Vie PDF:nä';

  @override
  String get generatingPdf => 'Luodaan PDF:ää…';

  @override
  String get pdfExportFailed => 'PDF-vienti epäonnistui';

  @override
  String get recipeTime => 'Aika';

  @override
  String get addIngredientSection => 'Lisää osio';

  @override
  String get aiImportToggle => 'Analysoi tekoälyllä';

  @override
  String get aiImportToggleHint =>
      'Myös reseptivideoille (YouTube, Instagram, TikTok …) ja sivuille, joita tavallinen tuonti ei pysty lukemaan. Vaatii tekoälypalvelun Mealie-palvelimellasi — videoille myös äänipalvelun.';

  @override
  String get aiImportButton => 'Tuo tekoälyllä';

  @override
  String get aiImportRunning =>
      'Tekoäly analysoi linkkiä … videoissa voi kestää muutama minuutti.';

  @override
  String get aiImportFailed =>
      'Tekoälytuonti epäonnistui. Tarkista Mealie-palvelimen tekoälyasetukset.';

  @override
  String get stepHeadingLabel => 'Vaiheen otsikko (valinnainen)';

  @override
  String get linkedRecipeLabel => 'Linkitetty resepti';

  @override
  String get toolsTitle => 'Keittiövälineet';

  @override
  String get prepareTools => 'Ota esiin seuraavat keittiövälineet';

  @override
  String get newTool => 'Uusi keittiöväline';

  @override
  String get renameAction => 'Nimeä uudelleen';

  @override
  String get organizerEmpty =>
      'Täällä ei ole vielä mitään. Luo uusi napauttamalla “+” oikeassa yläkulmassa.';

  @override
  String organizerRecipeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reseptiä',
      one: '1 resepti',
      zero: 'Ei reseptejä',
    );
    return '$_temp0';
  }

  @override
  String get toolOnHand => 'Saatavilla';

  @override
  String get mealDiceSettingsHint =>
      'Valitse kategoriat ja tunnisteet kullekin aterialle. Noppaa heitettäessä ehdotetaan vain reseptejä, joissa on vähintään yksi niistä. Samaa merkintää voi käyttää usealle aterialle.';

  @override
  String get mealDiceSettingsNoneHint =>
      'Tälle aterialle ei ole valittu mitään: noppa valitsee automaattisesti kategorioiden nimien, kuten “Aamiainen”, “Lounas” tai “Päivällinen”, perusteella.';

  @override
  String get mealDiceAutoHintTitle => 'Automaattinen valinta';

  @override
  String get mealDiceAutoHintBody =>
      'Tälle aterialle ei ole vielä asetettu kategorioita tai tunnisteita. Siksi noppa etsii kategorioita kuten “Aamiainen”, “Lounas” tai “Päivällinen” ja täydentää muilla resepteillä.\n\nOman valinnan tekemiseksi: napauta ateriasuunnitelmassa “+”-merkin vieressä olevaa ratasta.';

  @override
  String get dontShowAgain => 'Älä näytä uudelleen';

  @override
  String get mealDiceNoMatches =>
      'Mikään resepti ei vastaa tälle aterialle valittuja kategorioita ja tunnisteita.';

  @override
  String mealDiceFewMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Vain $count sopivaa reseptiä',
      one: 'Vain 1 sopiva resepti',
    );
    return '$_temp0';
  }

  @override
  String get commentsTitle => 'Kommentit';

  @override
  String get commentHint => 'Kirjoita kommentti…';

  @override
  String get commentSaveFailed => 'Kommenttia ei voitu tallentaa.';

  @override
  String get commentDeleteConfirm => 'Poistetaanko tämä kommentti?';

  @override
  String get cookingDoneCommentLabel => 'Kommentti (valinnainen)';

  @override
  String get cookingDoneCommentHint => 'Miten onnistui? Vinkkejä ensi kertaan…';

  @override
  String get nutritionTitle => 'Ravintoaineet';

  @override
  String get nutritionPerServing => 'annosta kohden';

  @override
  String get nutritionCalories => 'Kalorit';

  @override
  String get nutritionFat => 'Rasva';

  @override
  String get nutritionSaturatedFat => 'Tyydyttynyt rasva';

  @override
  String get nutritionTransFat => 'Transrasva';

  @override
  String get nutritionUnsaturatedFat => 'Tyydyttymätön rasva';

  @override
  String get nutritionCholesterol => 'Kolesteroli';

  @override
  String get nutritionSodium => 'Natrium';

  @override
  String get nutritionCarbohydrates => 'Hiilihydraatit';

  @override
  String get nutritionFiber => 'Ravintokuitu';

  @override
  String get nutritionSugar => 'Sokeri';

  @override
  String get nutritionProtein => 'Proteiini';

  @override
  String get timelineTitle => 'Aikajana';

  @override
  String get timelineMadeThis => 'Tein tämän';

  @override
  String timelineUserMadeThis(String name) {
    return '$name teki tämän';
  }

  @override
  String get timelineEmpty => 'Aikajanalla ei ole vielä merkintöjä.';

  @override
  String get timelineDate => 'Päivämäärä';

  @override
  String get timelineNoteHint => 'Merkintä (valinnainen)';

  @override
  String get timelineAddPhoto => 'Lisää kuva';

  @override
  String get timelineRemovePhoto => 'Poista kuva';

  @override
  String get timelineSaved => 'Lisätty aikajanalle';

  @override
  String get timelineSaveFailed => 'Aikajanalle lisääminen epäonnistui';

  @override
  String get timelineImageFailed =>
      'Merkintä tallennettu, mutta kuvaa ei voitu ladata';

  @override
  String get timelineDeleteConfirm => 'Poistetaanko tämä merkintä aikajanalta?';

  @override
  String get timelineEditNote => 'Muokkaa merkintää';

  @override
  String get timelineUnknownRecipe => 'Reseptiä ei löytynyt';

  @override
  String get cookingDonePhotoHint => 'Kuva Mealien aikajanalle (valinnainen)';

  @override
  String get assetsTitle => 'Liitteet';

  @override
  String get assetsAdd => 'Lisää liite';

  @override
  String get assetsChooseFile => 'Tiedosto';

  @override
  String get assetsUploading => 'Ladataan…';

  @override
  String get assetsUploadFailed => 'Liitettä ei voitu ladata';

  @override
  String assetsDeleteConfirm(String name) {
    return 'Poistetaanko “$name” liitteistä?';
  }

  @override
  String get assetsOpenFailed => 'Liitettä ei voitu avata';

  @override
  String get assetsUnsupported =>
      'Mealie tukee vain PDF-, kuva-, TXT-, MD-, CSV- ja JSON-tiedostoja.';

  @override
  String get assetsShare => 'Jaa';

  @override
  String get mealRulesTitle => 'Mealie-säännöt';

  @override
  String get mealRulesHint =>
      'Myös Mealien verkkosovellus käyttää näitä. Jos päivään ja ateriaan pätee useita sääntöjä, kaikkien on täytyttävä. Jos mikään sääntö ei päde, noppa valitsee kaikista resepteistä.';

  @override
  String get mealRuleAdd => 'Lisää sääntö';

  @override
  String get mealRuleNewTitle => 'Uusi sääntö';

  @override
  String get mealRuleEditTitle => 'Muokkaa sääntöä';

  @override
  String get mealRuleDay => 'Päivä';

  @override
  String get mealRuleAnyDay => 'Mikä tahansa päivä';

  @override
  String get mealRuleMealType => 'Ateria';

  @override
  String get mealRuleAnyMeal => 'Mikä tahansa ateria';

  @override
  String get mealRuleConditionsTitle => 'Ehdot';

  @override
  String get mealRuleAllRecipes => 'Kaikki reseptit';

  @override
  String get mealRuleDeleteConfirm => 'Poistetaanko tämä sääntö?';

  @override
  String get mealRulesOffline =>
      'Mealie-säännöt eivät ole juuri nyt käytettävissä – noppa käyttää sovelluksen valintaa.';

  @override
  String get mealRulesNoMatches =>
      'Mikään resepti ei vastaa tämän aterian Mealie-sääntöjä.';

  @override
  String get mealTypeSide => 'Lisuke';

  @override
  String get mealTypeSnack => 'Välipala';

  @override
  String get mealTypeDrink => 'Juoma';

  @override
  String get mealTypeDessert => 'Jälkiruoka';

  @override
  String get foodsTitle => 'Ruoat';

  @override
  String get unitsTitle => 'Yksiköt';

  @override
  String get newFood => 'Uusi ruoka';

  @override
  String get newUnit => 'Uusi yksikkö';

  @override
  String get editFood => 'Muokkaa ruokaa';

  @override
  String get editUnit => 'Muokkaa yksikköä';

  @override
  String get pluralNameLabel => 'Nimi monikossa';

  @override
  String get abbreviationLabel => 'Lyhenne';

  @override
  String get pluralAbbreviationLabel => 'Lyhenne monikossa';

  @override
  String get mergeAction => 'Yhdistä';

  @override
  String mergeIntoTitle(String name) {
    return 'Yhdistä “$name” kohteeseen…';
  }

  @override
  String mergeConfirm(String from, String to) {
    return '“$from” yhdistetään kohteeseen “$to”: kaikki reseptit ja ostoslistat käyttävät sen jälkeen kohdetta “$to”, ja “$from” poistetaan.';
  }

  @override
  String get mergeFailed => 'Yhdistäminen epäonnistui';

  @override
  String foodUnitDeleteConfirm(String name) {
    return 'Poistetaanko “$name”? Sitä käyttävät ainesosat menettävät viittauksen.';
  }

  @override
  String get foodsUnitsEmpty => 'Ei vielä merkintöjä.';

  @override
  String mealRuleConditionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ehtoa',
      one: '1 ehto',
    );
    return '$_temp0';
  }

  @override
  String get showAll => 'Näytä kaikki';

  @override
  String get mealDiceModeTitle => 'Noppa käyttää';

  @override
  String get mealDiceModeApp => 'Sovelluksen valinta';

  @override
  String get switchListTitle => 'Vaihda listaa';

  @override
  String get newShoppingList => 'Uusi ostoslista';

  @override
  String shoppingListDeleteConfirm(String name) {
    return 'Poistetaanko “$name”? Myös kaikki sen tuotteet poistetaan.';
  }

  @override
  String get labelOrderTitle => 'Järjestä tunnisteet';

  @override
  String get labelOrderHint =>
      'Järjestä vetämällä. Koskee tätä listaa – myös Mealien verkkosovelluksessa.';

  @override
  String get labelOrderEmpty => 'Tällä listalla ei ole vielä tunnisteita.';

  @override
  String get useAsActiveList => 'Käytä aktiivisena listana';

  @override
  String get activeListBadge => 'Aktiivinen';

  @override
  String get foodLabelLabel => 'Tunnus';

  @override
  String get foodNoLabel => 'Ei tunnistetta';

  @override
  String get aliasesLabel => 'Aliakset';

  @override
  String get aliasAddHint => 'Lisää alias';

  @override
  String get foodOnHand => 'Saatavilla kotitaloudessa';

  @override
  String get timelineChildRecipesTitle =>
      'Lisää myös linkitetyille resepteille';

  @override
  String timelineMadeForRecipe(String recipe) {
    return 'Tehty reseptiin $recipe';
  }

  @override
  String get timelineFilter => 'Suodata merkintöjä';

  @override
  String get timelineTypeComment => 'Tehdyt ja merkinnät';

  @override
  String get timelineTypeInfo => 'Tiedot';

  @override
  String get timelineTypeSystem => 'Järjestelmä';

  @override
  String get listManagementTitle => 'Ostoslistat';

  @override
  String get managementTitle => 'Lisää';

  @override
  String get pinToHome => 'Lisää aloitusnäyttöön';

  @override
  String get unpinFromHome => 'Poista aloitusnäytöstä';

  @override
  String homeScreenFull(int count) {
    return 'Aloitusnäyttö on täynnä – enintään $count ruutua. Poista ensin jokin toinen ruutu kohdasta “Lisää”.';
  }

  @override
  String get selectAction => 'Valitse';

  @override
  String selectedCount(int count) {
    return '$count valittu';
  }

  @override
  String get assignLabelAction => 'Määritä tunniste';

  @override
  String get assignLabelOverwriteHint =>
      'Korvaa kaikkien valittujen ruokien tunnisteen.';

  @override
  String deleteSelectedConfirm(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Poistetaanko $count merkintää?',
      one: 'Poistetaanko 1 merkintä?',
    );
    return '$_temp0';
  }

  @override
  String get seedDataAction => 'Lataa oletustiedot';

  @override
  String get seedFoodsHint => 'Luo Mealien oletusruoat valitulla kielellä.';

  @override
  String get seedUnitsHint => 'Luo Mealien oletusyksiköt valitulla kielellä.';

  @override
  String get seedLanguageLabel => 'Kieli';

  @override
  String get seedDuplicateWarning =>
      'Sinulla on jo merkintöjä. Mealie ei käsittele kaksoiskappaleita – ne on yhdistettävä itse jälkikäteen.';

  @override
  String get seedDone => 'Oletustiedot luotu';

  @override
  String get seedFailed => 'Oletustietoja ei voitu ladata';

  @override
  String get exportAction => 'Vienti';

  @override
  String get substitutionsLabel => 'Korvikkeet';

  @override
  String get substitutionAddHint => 'Lisää korvike';

  @override
  String get substitutionFoodLabel => 'Ruoka (valinnainen)';

  @override
  String get substitutionNoteLabel => 'Merkintä (valinnainen)';

  @override
  String get substitutionNeedOne => 'Syötä ruoka tai merkintä';

  @override
  String get useAbbreviationLabel => 'Käytä lyhennettä';

  @override
  String get useAbbreviationHint => 'Näytä resepteissä “g” eikä “gramma”';

  @override
  String get fractionLabel => 'Näytä murtolukuna';

  @override
  String get fractionHint => '½ eikä 0,5';

  @override
  String get standardizationTitle => 'Standardointi';

  @override
  String get standardizationHint =>
      'Muunnoksia varten: 1 tätä yksikköä vastaa … (esim. 1 rkl = 15 millilitraa).';

  @override
  String get standardQuantityLabel => 'Vakiomäärä';

  @override
  String get standardUnitLabel => 'Vakioyksikkö';

  @override
  String get standardUnitNone => 'Tyhjä';

  @override
  String get stdFluidOunce => 'Nesteunssi (fl oz)';

  @override
  String get stdCup => 'Kuppi (US)';

  @override
  String get stdOunce => 'Unssi (oz)';

  @override
  String get stdPound => 'Pauna (lb)';

  @override
  String get stdMilliliter => 'Millilitra';

  @override
  String get stdLiter => 'Litra';

  @override
  String get stdGram => 'Gramma';

  @override
  String get stdKilogram => 'Kilogramma';

  @override
  String get labelsTitle => 'Tunnisteet';

  @override
  String get newLabel => 'Uusi tunniste';

  @override
  String get editLabel => 'Muokkaa tunnistetta';

  @override
  String get colorLabel => 'Väri';

  @override
  String labelDeleteConfirm(String name) {
    return 'Poistetaanko “$name”? Tuotteet ja ruoat menettävät tämän tunnisteen.';
  }

  @override
  String get importMenuAction => 'Tuo';

  @override
  String get archivedEmpty =>
      'Ei vielä arkistoituja ostoksia. Napauta ostosten jälkeen “Päätä ostokset” – merkityt tuotteet tallennetaan tänne.';

  @override
  String get sectionTitleLabel => 'Osion otsikko';

  @override
  String get clearSection => 'Poista osio';

  @override
  String get noPermissionGeneric =>
      'Sinulla ei ole tähän oikeutta Mealiessa. Kysy ylläpitäjältä tai kotitalouden hallinnoijalta.';

  @override
  String get noPermissionEditRecipe =>
      'Et voi muokata tätä reseptiä – se on lukittu tai kuuluu toiseen kotitalouteen. Vain sen luoja tai ylläpitäjä voi.';

  @override
  String get noPermissionDeleteRecipe =>
      'Vain reseptin luoja tai ylläpitäjä voi poistaa sen.';

  @override
  String get noPermissionDemoteSelf =>
      'Et voi poistaa omia ylläpitäjän oikeuksiasi.';

  @override
  String get recipeLockedHint => 'Lukittu – vain luoja voi muokata';

  @override
  String get recipeDeleteOwnerOnlyHint =>
      'Vain luoja tai ylläpitäjä voi poistaa';

  @override
  String get organizeReadOnlyHint =>
      'Vain luku: luominen, muuttaminen ja poistaminen vaativat oikeuden “Käyttäjä voi hallita ruokia, tunnisteita ja kategorioita”.';

  @override
  String get notesNotSavedNoPermission =>
      'Merkintää ei tallennettu – sinulla ei ole oikeutta muokata tätä reseptiä.';

  @override
  String get userManagementTitle => 'Käyttäjien Hallinta';

  @override
  String get editUserTitle => 'Muokkaa käyttäjää';

  @override
  String get fullNameLabel => 'Koko nimi';

  @override
  String get usernameLabel => 'Käyttäjänimi';

  @override
  String get emailLabel => 'Sähköpostiosoite';

  @override
  String get passwordLabel => 'Salasana';

  @override
  String get householdLabel => 'Kotitalous';

  @override
  String get permissionsTitle => 'Käyttöoikeudet';

  @override
  String get administratorLabel => 'Ylläpitäjä';

  @override
  String get permCanInvite => 'Käyttäjä voi kutsua muita ryhmään';

  @override
  String get permCanManage => 'Käyttäjä voi hallita ryhmän asetuksia';

  @override
  String get permCanManageHousehold => 'Käyttäjä voi hallita kotitaloutta';

  @override
  String get permCanOrganize =>
      'Käyttäjä voi hallita ruokia, tunnisteita ja kategorioita';

  @override
  String get advancedFeaturesLabel => 'Salli edistyneemmät ominaisuudet';

  @override
  String get passwordResetLinkAction => 'Luo Salasanan Nollauslinkki';

  @override
  String get resetLockedUsersAction => 'Nollaa Lukitut Käyttäjät';

  @override
  String get inviteLinkTitle => 'Kutsulinkki';

  @override
  String get inviteAction => 'Kutsu';

  @override
  String get userUpdated => 'Käyttäjää päivitetty';

  @override
  String get createUserTitle => 'Luo käyttäjä';

  @override
  String get userCreated => 'Käyttäjä luotu';

  @override
  String userDeleteConfirm(String name) {
    return 'Poistetaanko “$name”? Tili poistetaan Mealiesta.';
  }

  @override
  String get passwordResetLinkCopied =>
      'Linkki kopioitu – välitä se käyttäjälle. Se on voimassa vain rajoitetun ajan.';

  @override
  String lockedUsersReset(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count käyttäjän lukitus avattu',
      one: '1 käyttäjän lukitus avattu',
      zero: 'Ei lukittuja käyttäjiä',
    );
    return '$_temp0';
  }

  @override
  String get inviteUsesLabel => 'Käyttökertojen määrä';

  @override
  String get inviteCreated => 'Kutsulinkki luotu';

  @override
  String get inviteEmailHint =>
      'Sähköpostiosoite (valinnainen – Mealie lähettää kutsun)';

  @override
  String get inviteEmailSent => 'Kutsu lähetetty sähköpostitse';

  @override
  String get inviteEmailFailed =>
      'Sähköpostia ei voitu lähettää (onko SMTP määritetty Mealiessa?). Linkki toimii silti.';

  @override
  String get copyLinkAction => 'Kopioi linkki';

  @override
  String get youLabel => 'Sinä';

  @override
  String get membersPermissionsHint =>
      'Voit muuttaa kotitaloutesi jäsenten oikeuksia – mutta et omiasi.';

  @override
  String get householdManagementTitle => 'Kotitalouksien Hallinta';

  @override
  String get householdsTitle => 'Kotitaloudet';

  @override
  String get createHouseholdTitle => 'Luo Kotitalous';

  @override
  String get householdNameLabel => 'Kotitalouden Nimi';

  @override
  String get householdPreferencesTitle => 'Kotitalouksien asetukset';

  @override
  String get privateHouseholdLabel => 'Yksityinen Kotitalous';

  @override
  String get privateHouseholdHint =>
      'Kotitalouden asettaminen yksityiseksi poistaa kaikki julkiset näkymävaihtoehdot käytöstä. Tämä kumoaa kaikki yksittäiset julkisen näkymän asetukset';

  @override
  String get lockRecipeEditsLabel =>
      'Lukitse reseptimuokkaukset muilta kotitalouksilta';

  @override
  String get lockRecipeEditsHint =>
      'Kun tämä on käytössä, vain kotitaloutesi käyttäjät voivat muokata kotitaloutesi luomia reseptejä.';

  @override
  String get householdRecipePreferencesTitle =>
      'Kotitalouksien reseptiasetukset';

  @override
  String get groupsTitle => 'Ryhmät';

  @override
  String get groupLabel => 'Ryhmä';

  @override
  String get createGroupTitle => 'Luo ryhmä';

  @override
  String get groupNameLabel => 'Ryhmän nimi';

  @override
  String get groupPreferencesTitle => 'Ryhmän oletusasetukset';

  @override
  String get privateGroupLabel => 'Yksityinen ryhmä';

  @override
  String get privateGroupHint =>
      'Ryhmän asettaminen yksityiseksi poistaa kaikki julkiset näkymävaihtoehdot käytöstä. Tämä kumoaa kaikki yksittäiset julkisen näkymän asetukset';

  @override
  String get firstDayOfWeekLabel => 'Viikon ensimmäinen päivä';

  @override
  String get showAnnouncementsLabel => 'Näytä Mealien ilmoitukset';

  @override
  String get recipePublicDefaultLabel =>
      'Anna muiden kuin ryhmäsi jäsenten nähdä reseptisi';

  @override
  String get recipeShowNutritionDefaultLabel => 'Näytä ravintotiedot';

  @override
  String get recipeShowAssetsDefaultLabel => 'Näytä reseptin sisältö';

  @override
  String get recipeLandscapeDefaultLabel => 'Käytä vaaka-näkymää oletuksena';

  @override
  String get recipeDisableCommentsDefaultLabel =>
      'Estä käyttäjiä kommentoimasta reseptiä';

  @override
  String get myHouseholdSection => 'Oma kotitalous';

  @override
  String get myGroupSection => 'Oma ryhmä';

  @override
  String get preferencesSaved => 'Asetukset tallennettu';

  @override
  String get cannotDeleteWithUsers =>
      'Siinä on vielä käyttäjiä – siirrä tai poista heidät ensin käyttäjien hallinnassa.';

  @override
  String deleteHouseholdConfirm(String name) {
    return 'Poistetaanko kotitalous “$name”?';
  }

  @override
  String deleteGroupConfirm(String name) {
    return 'Poistetaanko ryhmä “$name”?';
  }

  @override
  String usersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count käyttäjää',
      one: '1 käyttäjä',
      zero: 'Ei käyttäjiä',
    );
    return '$_temp0';
  }

  @override
  String get originalUrlLabel => 'Alkuperäinen URL-osoite';

  @override
  String get copyTextAction => 'Kopioi teksti';

  @override
  String get copiedToClipboard => 'Kopioitu leikepöydälle';

  @override
  String get changelogEnglishHint =>
      'Julkaisutiedot ovat saatavilla vain englanniksi.';

  @override
  String get favoritesTitle => 'Suosikit';

  @override
  String get favoritesEmpty =>
      'Ei vielä suosikkeja. Kerää resepti tänne napauttamalla sen sydäntä.';

  @override
  String get changelogTitle => 'Muutokset';

  @override
  String get changeProfileImage => 'Vaihda profiilikuva';

  @override
  String get profileImageUpdated => 'Profiilikuva päivitetty';

  @override
  String get profileImageFailed => 'Profiilikuvaa ei voitu ladata';

  @override
  String get myAccountTitle => 'Oma tili';

  @override
  String get ownAccountHint =>
      'Täällä voit muokata omaa tiliäsi. Muita käyttäjiä hallitsevat ylläpitäjät ja jäsenet, joilla on “hallinta”-oikeus.';

  @override
  String get changePasswordAction => 'Vaihda salasana';

  @override
  String get currentPasswordLabel => 'Nykyinen salasana';

  @override
  String get newPasswordLabel => 'Uusi salasana';

  @override
  String get confirmPasswordLabel => 'Vahvista salasana';

  @override
  String get passwordTooShort => 'Vähintään 8 merkkiä';

  @override
  String get passwordsDoNotMatch => 'Salasanat eivät täsmää';

  @override
  String get passwordUpdated => 'Salasana päivitetty';

  @override
  String get passwordChangeFailed => 'Salasanaa ei voitu vaihtaa';

  @override
  String passwordManagedExternally(String method) {
    return 'Kirjaudut palvelun $method kautta — vaihda salasana siellä.';
  }

  @override
  String get bulkAddHint => 'Yksi rivi merkintää kohden.';

  @override
  String bulkAddCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Lisää $count merkintää',
      one: 'Lisää 1 merkintä',
    );
    return '$_temp0';
  }

  @override
  String get linkRecipeAction => 'Linkitä resepti';

  @override
  String get useFoodAction => 'Käytä ruokaa reseptin sijaan';

  @override
  String get addSubstitutionsAction => 'Lisää korvikkeita';

  @override
  String get clearSubstitutionsAction => 'Tyhjennä korvikkeet';

  @override
  String get recipeSubstitutionsTitle => 'Korvikkeet';

  @override
  String get substitutionUnknownFood =>
      'Vain olemassa olevat ruoat – käytä muuten merkintää';

  @override
  String get insertAboveAction => 'Lisää yläpuolelle';

  @override
  String get insertBelowAction => 'Lisää alapuolelle';

  @override
  String get moveToTopAction => 'Siirrä ylimmäksi';

  @override
  String get moveToBottomAction => 'Siirrä alimmaksi';

  @override
  String get linkReferencesAction => 'Linkitä viittaukset';

  @override
  String get editMarkdownAction => 'Muokkaa Markdownia';

  @override
  String get previewMarkdownAction => 'Esikatsele Markdownia';

  @override
  String get insertStepImageAction => 'Lataa kuva';

  @override
  String get mergeAboveAction => 'Yhdistä edelliseen';

  @override
  String get linkedToOtherStep => 'Linkitetty toiseen vaiheeseen';

  @override
  String get noNotesToLink => 'Ei linkitettäviä merkintöjä';

  @override
  String get ownerLabel => 'Omistaja';

  @override
  String get ingredientParserTitle => 'Ainesosan jäsentäjä';

  @override
  String ingredientParserHint(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count ainesosaa ei ole vielä jäsennelty. Valitse jäsennin, tarkista tulos, ota käyttöön.',
      one:
          '1 ainesosaa ei ole vielä jäsennelty. Valitse jäsennin, tarkista tulos, ota käyttöön.',
    );
    return '$_temp0';
  }

  @override
  String get parserNlp => 'Luonnollisen kielen prosessointityökalu';

  @override
  String get parserBrute => 'Voimakas jäsentäjätyökalu';

  @override
  String get parserOpenai => 'OpenAI-jäsennin';

  @override
  String get parserApp => 'Offline (sovellus)';

  @override
  String get parseFailed => 'Jäsentäminen epäonnistui';

  @override
  String get parseAction => 'Jäsennä';

  @override
  String applyParsedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ota käyttöön $count ainesosaa',
      one: 'Ota käyttöön 1 ainesosa',
      zero: 'Mitään ei valittu',
    );
    return '$_temp0';
  }

  @override
  String get parsedNewBadge => 'uusi';

  @override
  String get hoursShort => 'h';

  @override
  String get minutesShort => 'min';

  @override
  String get timeExtraHint => 'Lisäksi, esim. “plus yön yli”';

  @override
  String get yieldLabel => 'Tuotto';

  @override
  String get yieldTextLabel => 'Tuotosteksti';

  @override
  String get prepTimeLabel => 'Valmisteluaika';

  @override
  String get performTimeLabel => 'Kokkausaika';

  @override
  String get totalTimeLabel => 'Kokonaisaika';

  @override
  String get settingPublicRecipe => 'Julkinen resepti';

  @override
  String get settingShowNutrition => 'Näytä ravintoarvot';

  @override
  String get settingShowAssets => 'Näytä liitteet';

  @override
  String get settingLandscapeView => 'Landscape View (Coming Soon)';

  @override
  String get settingDisableComments => 'Poista kommentit käytöstä';

  @override
  String get settingDisableAmount => 'Poista ainesosien määrät käytöstä';

  @override
  String get settingLocked => 'Lukittu';

  @override
  String get settingLockedOwnerOnly =>
      'Vain luoja voi lukita reseptin tai avata sen lukituksen.';

  @override
  String get apiExtrasTitle => 'API-lisäominaisuudet';

  @override
  String get apiExtrasHint =>
      'Omat avain/arvo-parit kolmannen osapuolen sovelluksille, esim. automaatioiden käynnistämiseen.';

  @override
  String get extraKeyLabel => 'Avain';

  @override
  String get extraValueLabel => 'Arvo';

  @override
  String get addExtraAction => 'Lisää lisätieto';

  @override
  String durationHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tuntia',
      one: '1 tunti',
    );
    return '$_temp0';
  }

  @override
  String durationMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minuuttia',
      one: '1 minuutti',
    );
    return '$_temp0';
  }

  @override
  String get discardChangesConfirm => 'Hylätäänkö tallentamattomat muutokset?';

  @override
  String get discardChanges => 'Hylkää muutokset';

  @override
  String get imageFromUrl => 'Kuva URL-osoitteesta';

  @override
  String get deleteRecipeImage => 'Poista Reseptin Kuva';

  @override
  String get deleteRecipeImageConfirm =>
      'Haluatko varmasti poistaa reseptikuvan?';

  @override
  String get bulkAddIngredients => 'Lisää ainesosia kerralla';

  @override
  String get bulkAddSteps => 'Lisää vaiheita kerralla';

  @override
  String get stepImageFailed => 'Kuvaa ei voitu ladata';

  @override
  String get servingsAndTimes => 'Annokset ja ajat';

  @override
  String get recipeSettingsTitle => 'Reseptiasetukset';

  @override
  String get jsonEditorTitle => 'JSON-muokkain';

  @override
  String get jsonInvalid => 'Virheellinen JSON – tarkista.';

  @override
  String get editorOfflineHint =>
      'Avattu offline-tilassa: tallentaminen vaatii yhteyden. Uudemmat Mealie-kentät (esim. korvikkeet) säilyvät ennallaan.';

  @override
  String get parseLineFailed => 'Ei tunnistettu – pysyy ennallaan';

  @override
  String get createManualTitle => 'Luo resepti käsin';

  @override
  String get createManualHint =>
      'Syötä nimi – ainesosat, vaiheet, kuvan ja kaiken muun lisäät jälkikäteen reseptieditorissa.';

  @override
  String get createManualButton => 'Luo ja muokkaa';

  @override
  String get changelogEmpty => 'Tälle versiolle ei ole vielä merkintöjä.';

  @override
  String get finderDescription =>
      'Etsi sopivia reseptejä saatavilla olevien ainesosien perusteella. Voit myös suodattaa tulokset saatavilla olevien keittiövälineiden perusteella, ja asettaa enimmäismäärän puuttuvia ainesosia tai välineitä.';

  @override
  String get finderSelectedIngredients => 'Valitut ainesosat';

  @override
  String get finderNoIngredientsSelected => 'Ei valittuja ainesosia';

  @override
  String get finderMissing => 'Puuttuu';

  @override
  String get finderNoRecipesFound => 'Reseptejä ei löytynyt';

  @override
  String get finderNoRecipesFoundDescription =>
      'Kokeile lisätä enemmän ainesosia hakuun tai säätää suodattimia';

  @override
  String get finderIncludeFoodsOnHand =>
      'Sisällytä saatavilla olevat ainesosat';

  @override
  String get finderIncludeToolsOnHand => 'Sisällytä saatavilla olevat välineet';

  @override
  String get finderIncludeSubstitutions => 'Sisällytä korvikkeet';

  @override
  String get finderSubstituting => 'Korvataan';

  @override
  String finderSubstituteForFood(String substitute, String food) {
    return '$substitute ruoan $food sijaan';
  }

  @override
  String get finderMaxMissingIngredients => 'Puuttuvien ainesten enimmäismäärä';

  @override
  String get finderMaxMissingTools => 'Puuttuvien välineiden enimmäismäärä';

  @override
  String get finderSelectedTools => 'Valitut keittiövälineet';

  @override
  String get finderReadyToMake => 'Valmis tekemään';

  @override
  String get finderAlmostReadyToMake => 'Melkein valmis tekemään';

  @override
  String get finderSettings => 'Asetukset';

  @override
  String get finderLoadingRecipes => 'Ladataan reseptejä';

  @override
  String get finderClearSelection => 'Tyhjennä valinnat';

  @override
  String get finderOfflineHint =>
      'Ei yhteyttä palvelimeen – tulokset ovat tähän laitteeseen tallennetuista resepteistä.';

  @override
  String get sendPeerOfflineHint =>
      'Ei tavoitettavissa nyt – saapuu, kun sovellus avataan siellä';

  @override
  String sendDeliveredLater(String device) {
    return '“$device” ei ole nyt tavoitettavissa. Resepti saapuu heti, kun sovellus avataan siellä.';
  }

  @override
  String get sendQueuedOffline =>
      'Ei yhteyttä juuri nyt. Resepti lähetetään automaattisesti heti, kun olet taas verkossa.';

  @override
  String get searchHasAll => 'On Kaikki';

  @override
  String get searchHasAny => 'On Mikä Tahansa';

  @override
  String get recipeFilterTitle => 'Suodatin';

  @override
  String get finderOtherFilters => 'Muut suodattimet';

  @override
  String get qfOpEquals => 'on yhtä kuin';

  @override
  String get qfOpNotEquals => 'ei ole yhtä kuin';

  @override
  String get qfOpGreater => 'on suurempi kuin';

  @override
  String get qfOpGreaterEq => 'on suurempi tai yhtäsuuri kuin';

  @override
  String get qfOpLess => 'on vähemmän kuin';

  @override
  String get qfOpLessEq => 'on vähemmän tai yhtäsuuri kuin';

  @override
  String get qfOpNewerThan => 'on uudempi kuin';

  @override
  String get qfOpOlderThan => 'on vanhempi kuin';

  @override
  String qfDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count päivää sitten',
      one: '1 päivä sitten',
    );
    return '$_temp0';
  }

  @override
  String get filterResetAll => 'Nollaa kaikki suodattimet';

  @override
  String get filterAny => 'Mikä tahansa';

  @override
  String get filterOfflineIgnored =>
      'Offline-tilassa “Muut suodattimet” voidaan käyttää vain yksinkertaisessa muodossaan.';

  @override
  String linkedRecipesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count linkitettyä reseptiä',
      one: 'Yksi linkitetty resepti',
      zero: 'Ei linkitettyjä reseptejä',
    );
    return '$_temp0';
  }

  @override
  String get shoppingReminderNotificationsOff =>
      'Ilmoitukset ovat pois päältä Mealie Recipesille — ilman niitä ostosmuistutus ei voi näkyä. Salli ilmoitukset asetuksissa.';

  @override
  String get shoppingReminderInactiveHint =>
      'Ostosmuistutus ei voi nyt toimia: aseta sijainnin käyttöoikeudeksi “Aina” ja salli ilmoitukset.';

  @override
  String get bulkImportTitle => 'Massa tuonti URL-osoitteesta';

  @override
  String get bulkImportDescription =>
      'Reseptien massatuonnin avulla voit tuoda useita reseptejä kerralla asettamalla sivustot jonoon taustajärjestelmässä ja suorittamalla tehtävän taustalla. Tästä voi olla hyötyä, kun siirryt Mealieen tai kun haluat tuoda suuren määrän reseptejä.';

  @override
  String get bulkAddTitle => 'Lisää useita kerralla';

  @override
  String get bulkImportSetOrganizers => 'Aseta kategoriat ja tunnisteet';

  @override
  String get bulkImportStarted => 'Massatuonnin prosessi on alkanut';

  @override
  String get bulkImportFailed => 'Massatuonnin prosessi epäonnistui';

  @override
  String get bulkImportReports => 'Massatuonti';

  @override
  String get bulkImportUrlHint => 'Reseptin URL';

  @override
  String get migrationsTitle => 'Tietojen migraatiot';

  @override
  String get migrationsDescription =>
      'Reseptejä voi siirtää Mealieen toisesta tuetusta sovelluksesta. Se on hyvä tapa aloittaa Mealien käyttö. Tietojen siirto Mealie-instanssien välillä tai aiemman Mealie-varmuuskopion palautus tehdään sen sijaan varmuuskopiointi- ja palautustyökaluilla.';

  @override
  String get migrationNew => 'Uusi migraatio';

  @override
  String get migrationChooseType => 'Valitse migraatiotyyppi';

  @override
  String get noFileSelected => 'Tiedostoa ei ole valittu';

  @override
  String migrationTagAll(String tag) {
    return 'Merkitse kaikki reseptit tunnisteella $tag';
  }

  @override
  String get migrationPrevious => 'Aikaisemmat mikraatiot';

  @override
  String get migrationMealieDescription =>
      'Mealie voi tuoda reseptejä Mealie-sovelluksesta, jonka versio on vanhempi kuin v1.0. Vie reseptisi vanhasta instanssista ja lataa zip-tiedosto alle. Huomaa, että viennistä voidaan tuoda vain reseptit. Tämä koskee vain v1.0:aa vanhempia instansseja. V1.0:sta tai uudemmasta otettu varmuuskopio palautetaan varmuuskopiointi- ja palautustyökaluilla.';

  @override
  String get migrationChowdownDescription =>
      'Mealie tukee natiivisti chowdown arkiston muotoa. Lataa koodiarkisto .zip tiedostoksi ja lataa se alta.';

  @override
  String get migrationCopyMeThatDescription =>
      'Mealie voi tuoda reseptejä Copy Me That -sovelluksesta. Vie reseptisi HTML-muodossa ja lataa sitten zip-tiedosto.';

  @override
  String get migrationMyRecipeBoxDescription =>
      'Voit tuoda Mealieen reseptejä reseptilaatikosta. Tuo reseptisi csv-muodossa ja lataa sitten csv-tiedosto alempaa.';

  @override
  String get migrationNextcloudDescription =>
      'Nextcloud reseptejä voidaan tuoda zip-tiedostosta, joka sisältää Nextcloudin tallennetut tiedot. Katso esimerkkikansiorakenne alla varmistaaksesi, että reseptisi voidaan tuoda.';

  @override
  String get migrationPaprikaDescription =>
      'Mealie voi tuoda reseptejä Paprika-sovelluksesta. Vie reseptisi ohjelmasta ulos, nimeä tiedoston pääte uudelleen .zip ja lataa se alla.';

  @override
  String get migrationPlanToEatDescription =>
      'Mealieen voi tuoda reseptejä Plan to Eat -sovelluksesta.';

  @override
  String get migrationRecipeKeeperDescription =>
      'Mealieen voi tuoda reseptejä reseptinsäilyttäjästä. Tuo reseptit zip-muodossa ja sitten lataa zip-tiedosto alempaa.';

  @override
  String get migrationTandoorDescription =>
      'Mealie voi tuoda reseptejä Tandoorista. Vie tietosi \"Oletus\" -muodossa ja lataa sitten .zip alla.';

  @override
  String get migrationCooknDescription =>
      'Mealie voi tuoda reseptejä DVO Cook\'n X3:sta. Vie keittokirja tai valikko \"Cook\'n\"-muodossa, nimeä tiedosto uudelleen .zip-muotoon ja lataa sitten Mealieen alta.';

  @override
  String get reportTitle => 'Raportti';

  @override
  String get recipeDataTitle => 'Reseptin Tiedot';

  @override
  String get recipeDataDescription =>
      'Tämän osion avulla voit hallita resepteihisi liittyviä tietoja. Voit suorittaa useita massamuokkauksia resepteillesi, mukaan lukien vieminen, poistaminen, merkitseminen ja luokkien määrittäminen.';

  @override
  String get recipeDataTagTitle => 'Lisää tunnisteet resepteihin';

  @override
  String get recipeDataCategorizeTitle => 'Luokittele Reseptit';

  @override
  String get recipeDataSettingsTitle => 'Päivitysasetukset';

  @override
  String get recipeDataExportTitle => 'Vie Reseptit';

  @override
  String get recipeDataDeleteTitle => 'Poista Reseptit';

  @override
  String recipeDataExportConfirm(int count) {
    return 'Seuraavat reseptit ($count) viedään.';
  }

  @override
  String get recipeDataExportsTitle => 'Tietojen vienti';

  @override
  String get recipeDataExportsDescription =>
      'Tässä osiossa on linkkejä saatavilla oleviin vienteihin, jotka ovat valmiita ladattavaksi. Nämä vanhenevat, joten muista hakea ne, kun niitä on vielä saatavilla.';

  @override
  String get recipeDataPurgeExports => 'Tyhjennä Vientitiedostot';

  @override
  String get recipeDataPurgeConfirm =>
      'Oletko varma, että haluat poistaa kaikki vientitiedot?';

  @override
  String get recipeActionsTitle => 'Reseptin toiminnot';

  @override
  String get recipeActionNew => 'Uusi reseptin toiminto';

  @override
  String get recipeActionEdit => 'Muuta reseptin toimintoa';

  @override
  String get recipeActionTypeLink => 'Linkki';

  @override
  String get recipeActionTypePost => 'Lähetä';

  @override
  String get webhooksTitle => 'Webhookit';

  @override
  String get webhooksDescription =>
      'Alla olevat nettikoukut suoritetaan, kun päivälle on määritelty ateria. Tiettynä ajankohtana koukut lähetetään päivän mukaisen reseptin tietojen mukana. Koukkujen suoritusaika ei ole tarkka, vaan niitä suoritetaan viiden minuutin välein.';

  @override
  String get webhookName => 'Webhookin nimi';

  @override
  String get webhookUrl => 'Webhookin URL';

  @override
  String get notifiersTitle => 'Ilmoitukset';

  @override
  String get notifiersDescription =>
      'Määritä sähköposti- ja push-ilmoitukset, jotka käynnistävät tiettyjä tapahtumia.';

  @override
  String get notifierNew => 'Uusi ilmoitus';

  @override
  String get notifierDescription =>
      'Mealie käyttää Apprise-kirjastoa ilmoitusten luomiseen. Se tarjoaa monia ilmoituspalvelveluvaihtoehtoja. Lisää tietoa siitä, kuinka luoda URL palvelua varten, löydät Apprisen wikistä. Joihinkin ilmoitustyyppeihin voi sisältyä lisäominaisuuksia.';

  @override
  String get notifierAppriseUrl => 'Apprise-url';

  @override
  String get notifierAppriseUrlSkipped =>
      'Ilmoitusverkko-osoite (voi jättää tyhjäksi)';

  @override
  String get notifierAppriseUrlBlankHint =>
      'Apprise URL-osoitteet sisältävät yleensä arkaluonteisia tietoja, joten tämä kenttä on tarkoituksellisesti tyhjä muokattaessa. Jos haluat päivittää URL-osoitteen, kirjoita uusi osoite tähän, muuten jätä se tyhjäksi pitääksesi nykyisen URL-osoitteen.';

  @override
  String get notifierEnable => 'Ota ilmoittaja käyttöön';

  @override
  String get notifierWhatEvents => 'Mistä tapahtumista tulisi ilmoittaa?';

  @override
  String get notifierRecipeEvents => 'Reseptitapahtumat';

  @override
  String get notifierUserEvents => 'Käyttäjän tapahtumat';

  @override
  String get notifierMealplanEvents => 'Ateriasuunnitelman tapahtumat';

  @override
  String get notifierShoppingListEvents => 'Ostoslistatapahtumat';

  @override
  String get notifierCookbookEvents => 'Keittokirjatapahtumat';

  @override
  String get notifierTagEvents => 'Valitse tapahtumat';

  @override
  String get notifierCategoryEvents => 'Luokkatapahtumat';

  @override
  String get notifierLabelEvents => 'Merkitse Tapahtumat';

  @override
  String get notifierUserSignup => 'Kun ryhmääsi liittyy uusi jäsen';

  @override
  String get notifierCreate => 'Luo';

  @override
  String get notifierUpdate => 'Päivitä';

  @override
  String get notifierDelete => 'Poista';

  @override
  String get notifierTestSent => 'Viesti lähetetty';

  @override
  String get adminTitle => 'Ylläpitäjän asetukset';

  @override
  String get backupsTitle => 'Varmuuskopiot';

  @override
  String get backupsDescription =>
      'Varmuuskopiot ovat sivuston tietokannan ja -hakemiston tilannekuvia. Siihen sisältyy kaikki tieto, eikä siitä voi poistaa tietojen osajoukkoja. Tämä on verrattavissa tilannekuvaan Mealiesta tiettynä ajankohtana. Nämä toimivat tietokantojen tapana tuoda ja viedä tietoja sekä sivuston varmuuskopioina ulkoisessa sijainnissa.';

  @override
  String get backupCreateHeading => 'Luo varmuuskopio';

  @override
  String get backupCreated => 'Varmuuskopio luotu';

  @override
  String get backupCreateFailed =>
      'Virhe varmuuskopiota luodessa. Katso lokitiedosto';

  @override
  String get backupDelete => 'Poista varmuuskopio';

  @override
  String get backupDeleted => 'Varmuuskopio poistettu';

  @override
  String get backupRestore => 'Palauta varmuuskopio';

  @override
  String get backupRestoreDescription =>
      'Tämän varmuuskopion palauttaminen korvaa kaikki tietokannan ja datahakemiston nykyiset tiedot varmuuskopion sisällöllä. Jos palautus onnistuu, sinut kirjataan ulos.';

  @override
  String get backupCannotBeUndone =>
      'Tätä toimintoa ei voi kumota - käytä varoen.';

  @override
  String get backupAcknowledge =>
      'Ymmärrän, että tämä toiminta on peruuttamatonta ja voi aiheuttaa tietojen häviämistä';

  @override
  String get backupRestoreSuccess => 'Palautus onnistui';

  @override
  String get backupRestoreFailed =>
      'Palautus epäonnistui. Tarkista palvelinloki saadaksesi lisätietoja';

  @override
  String get maintenanceTitle => 'Ylläpito';

  @override
  String get maintenanceSummary => 'Yhteenveto';

  @override
  String get maintenanceStorage => 'Tallennustilan tiedot';

  @override
  String get maintenanceDataDirSize => 'Datahakemiston koko';

  @override
  String get maintenanceCleanableDirs => 'Siivottavat hakemistot';

  @override
  String get maintenanceCleanableImages => 'Siivottavat kuvat';

  @override
  String get maintenanceTempDir => 'Väliaikainen hakemisto (.temp)';

  @override
  String get maintenanceBackupsDir =>
      'Varmuuskopiointihakemisto (varmuuskopiot)';

  @override
  String get maintenanceGroupsDir => 'Ryhmien hakemisto (ryhmät)';

  @override
  String get maintenanceRecipesDir => 'Reseptihakemisto (reseptit)';

  @override
  String get maintenanceUserDir => 'Käyttäjähakemisto (käyttäjä)';

  @override
  String get maintenanceCleanDirs => 'Puhdista hakemistot';

  @override
  String get maintenanceCleanDirsDescription =>
      'Poistaa kaikki reseptikansiot, jotka eivät ole kelvollisia UUID-koodeja';

  @override
  String get maintenanceCleanTemp => 'Poista väliaikaiset tiedostot';

  @override
  String get maintenanceCleanTempDescription =>
      'Poistaa kaikki tiedostot ja kansiot .temp kansiosta';

  @override
  String get maintenanceCleanImages => 'Puhdista kuvat';

  @override
  String get maintenanceCleanImagesDescription =>
      'Poistaa kaikki kuvat, jotka eivät pääty .webp';

  @override
  String get maintenanceActions => 'Toiminnot';

  @override
  String get adminConfiguration => 'Konfigurointi';

  @override
  String get adminAppVersion => 'Sovellusversio';

  @override
  String get adminUpToDate => 'Mealie on ajan tasalla';

  @override
  String adminVersionOutdated(String current, String latest) {
    return 'Nykyinen versiosi ($current) ei vastaa uusinta julkaisua. Harkitse päivittämistä uusimpaan versioon ($latest).';
  }

  @override
  String get adminBaseUrl => 'Palvelimen pohja-URL';

  @override
  String get adminBaseUrlOk => 'Palvelimen nettiosoite ei vastaa oletusta';

  @override
  String get adminBaseUrlError =>
      '`BASE_URL` on API-palvelimen oletusarvo. Tämä aiheuttaa ongelmia ilmoitusten linkkien kanssa, jotka on luotu palvelimella sähköposteja varten jne.';

  @override
  String adminAuthReady(String provider) {
    return '$provider valmis';
  }

  @override
  String adminAuthNotReady(String provider) {
    return '$provider ei valmis';
  }

  @override
  String adminAuthDisabled(String provider) {
    return '$provider poistettu käytöstä';
  }

  @override
  String adminAuthSuccessText(String provider) {
    return 'Kaikki vaaditut $provider-muuttujat on asetettu.';
  }

  @override
  String adminAuthErrorText(String provider) {
    return 'Kaikkia $provider-arvoja ei ole määritetty. Tämän voi ohittaa, jos et käytä $provider-todennusta.';
  }

  @override
  String adminAuthDisabledText(String envVar) {
    return 'Ota käyttöön asettamalla $envVar arvoon true.';
  }

  @override
  String get adminEmailStatus => 'Sähköpostin varmistuksen tila';

  @override
  String get adminEmailConfigured => 'Sähköposti on määritelty';

  @override
  String get adminNotReady => 'Ei Valmis - Tarkista Ympäristömuuttujat';

  @override
  String get adminSucceeded => 'Onnistui';

  @override
  String get adminFailed => 'Epäonnistui';

  @override
  String get adminSiteStatistics => 'Sivuston tilastot';

  @override
  String get adminUncategorized => 'Reseptit ilman kategoriaa';

  @override
  String get adminUntagged => 'Reseptit ilman tunnisteita';

  @override
  String get adminGeneralAbout => 'Yleistä';

  @override
  String get adminVersion => 'Versio';

  @override
  String get adminBuild => 'Koonti';

  @override
  String get adminApplicationMode => 'Sovellustila';

  @override
  String get adminProduction => 'Tuotanto';

  @override
  String get adminDevelopment => 'Kehitys';

  @override
  String get adminDemoStatus => 'Esittelytila';

  @override
  String get adminDemo => 'Esittelytila';

  @override
  String get adminNotDemo => 'Ei käytössä';

  @override
  String get adminApiPort => 'API-portti';

  @override
  String get adminApiDocs => 'API-dokumentaatio';

  @override
  String get adminDatabaseType => 'Tietokannan tyyppi';

  @override
  String get adminDatabaseUrl => 'Tietokannan URL-osoite';

  @override
  String get adminDefaultGroup => 'Oletusryhmä';

  @override
  String get adminDefaultHousehold => 'Oletuskotitalous';

  @override
  String get adminScraperVersion => 'Reseptikaappaimen versio';

  @override
  String get adminStatUsers => 'Käyttäjät';

  @override
  String get adminStatHouseholds => 'Kotitaloudet';

  @override
  String get adminStatGroups => 'Ryhmät';

  @override
  String get recipeDuplicate => 'Monista resepti';

  @override
  String get recipeDuplicateAction => 'Monista';

  @override
  String get recipeShareLink => 'Reseptin kaappain';

  @override
  String get recipeShareExpiration => 'Päättymispäivä';

  @override
  String get recipeShareCopied => 'Reseptin linkki kopioitu leikepöydälle';

  @override
  String get enabledLabel => 'Käytössä';

  @override
  String get disabledLabel => 'Poistettu käytöstä';

  @override
  String get testAction => 'Testi';

  @override
  String get yesLabel => 'Kyllä';

  @override
  String get noLabel => 'Ei';

  @override
  String get downloadAction => 'Lataa';

  @override
  String get backupUpload => 'Lähetä';

  @override
  String get zipImportButton => 'Tuo zip-arkistosta';

  @override
  String get zipImportDescription =>
      'Tuo yksi resepti, joka on viety toisesta Mealie-asennuksesta.';

  @override
  String get reportStatus => 'Tila';

  @override
  String get reportDate => 'Päivämäärä';

  @override
  String get recipeActionTitleLabel => 'Otsikko';

  @override
  String get clearAll => 'Tyhjennä';

  @override
  String get recipeDataSettingsExplanation =>
      'Asetukset, jotka on valittu täällä, lukuun ottamatta lukittua vaihtoehtoa, sovelletaan kaikkiin valittuihin resepteihin.';

  @override
  String get adminAllowSignup => 'Salli rekisteröityminen';

  @override
  String get adminAllowPasswordLogin => 'Salli salasanakirjautuminen';

  @override
  String get adminEmailInvalid => 'Syötä kelvollinen sähköpostiosoite.';

  @override
  String adminEmailTestResult(String result) {
    return 'Sähköpostitesti: $result';
  }

  @override
  String get adminSendTestEmail => 'Lähetä testisähköposti';

  @override
  String get adminTestEmailAddress => 'Vastaanottaja';

  @override
  String get backupCreate => 'Luo varmuuskopio';

  @override
  String backupDeleteConfirm(String name) {
    return 'Poistetaanko varmuuskopio “$name”?';
  }

  @override
  String get backupPostgresNote =>
      'Jos käytät PostgreSQL:ää, lue varmuuskopioinnin/palautuksen ohjeet Mealien dokumentaatiosta ennen palautusta.';

  @override
  String get backupUploaded => 'Varmuuskopio lähetetty';

  @override
  String get backupsEmpty => 'Ei vielä varmuuskopioita.';

  @override
  String get bulkImportAddRow => 'Lisää URL';

  @override
  String get bulkImportStart => 'Aloita tuonti';

  @override
  String get chooseFileButton => 'Valitse tiedosto';

  @override
  String get deselectAllAction => 'Poista kaikki valinnat';

  @override
  String get downloadFailed => 'Lataus epäonnistui';

  @override
  String get fileSaved => 'Tiedosto tallennettu';

  @override
  String get loadFailed => 'Lataaminen epäonnistui';

  @override
  String get maintenanceActionsWarning =>
      'Ylläpitotoiminnot ovat tuhoavia, ja niitä tulee käyttää varoen. Minkä tahansa niistä suorittaminen on peruuttamatonta.';

  @override
  String get maintenanceConfirm =>
      'Tämä toiminto on tuhoava eikä sitä voi perua. Jatketaanko?';

  @override
  String get maintenanceDone => 'Valmis';

  @override
  String get maintenanceFailed => 'Ylläpitotoiminto epäonnistui';

  @override
  String get maintenanceRun => 'Suorita';

  @override
  String get migrationFailed => 'Siirto epäonnistui';

  @override
  String get migrationStart => 'Aloita siirto';

  @override
  String get migrationStarted => 'Siirto valmis — katso raportti alta.';

  @override
  String get moreImportOptions => 'Lisää tuontivaihtoehtoja';

  @override
  String notifierDeleteConfirm(String name) {
    return 'Poistetaanko ilmoittaja “$name”?';
  }

  @override
  String get notifierEdit => 'Muokkaa ilmoittajaa';

  @override
  String notifierEventCount(int count) {
    return 'Tapahtumat: $count';
  }

  @override
  String get notifierTestFailed => 'Testiviestiä ei voitu lähettää';

  @override
  String get notifiersEmpty => 'Ei vielä ilmoittajia.';

  @override
  String recipeActionDeleteConfirm(String name) {
    return 'Poistetaanko reseptitoiminto “$name”?';
  }

  @override
  String get recipeActionFailed => 'Reseptitoiminto epäonnistui';

  @override
  String get recipeActionSent => 'Resepti lähetetty';

  @override
  String get recipeActionUrlHint => 'Paikkamerkit';

  @override
  String get recipeActionsDescription =>
      'Reseptitoiminnot näkyvät jokaisen reseptin valikossa. “Linkki” avaa URL-osoitteen, “Post” antaa Mealie-palvelimen lähettää reseptin URL-osoitteeseen.';

  @override
  String get recipeActionsEmpty => 'Ei vielä reseptitoimintoja.';

  @override
  String recipeDataDeleteConfirm(int count) {
    return 'Poistetaanko valitut reseptit ($count)? Toimintoa ei voi perua.';
  }

  @override
  String recipeDataDeleteForbidden(int count) {
    return 'Et saa poistaa $count valituista resepteistä (vain niiden luoja tai ylläpitäjä voi).';
  }

  @override
  String recipeDataDeleted(int count) {
    return 'Poistetut reseptit: $count';
  }

  @override
  String get recipeDataExportAction => 'Vienti';

  @override
  String get recipeDataExportDone =>
      'Vienti luotu — lataa se kohdasta Tietojen viennit.';

  @override
  String recipeDataExportExpires(String date) {
    return 'vanhenee $date';
  }

  @override
  String get recipeDataExportFailed => 'Vienti epäonnistui';

  @override
  String get recipeDataExportsEmpty => 'Ei vientejä saatavilla.';

  @override
  String recipeDataUpdated(int count) {
    return 'Päivitetyt reseptit: $count';
  }

  @override
  String get recipeDuplicated => 'Resepti monistettu';

  @override
  String get recipeExportJson => 'Vie JSON-muodossa';

  @override
  String get recipeExportZip => 'Vie ZIP-muodossa (kuvan kanssa)';

  @override
  String get recipeShareCreate => 'Luo linkki';

  @override
  String get recipeShareDescription =>
      'Kuka tahansa linkin omaava voi katsoa reseptiä selaimessa — ilman tiliä — kunnes linkki vanhenee.';

  @override
  String get recipeShareEmpty => 'Ei vielä jakolinkkejä.';

  @override
  String recipeShareExpiresAt(String date) {
    return 'Vanhenee $date';
  }

  @override
  String get recipeWebToolsMenu => 'Monista, jakolinkki ja muuta';

  @override
  String get reload => 'Lataa uudelleen';

  @override
  String get reportDeleteConfirm => 'Poistetaanko tämä raportti?';

  @override
  String get reportEntries => 'Merkinnät';

  @override
  String get reportFailedEntries => 'Epäonnistui';

  @override
  String get reportOnlyFailed => 'Näytä vain epäonnistuneet merkinnät';

  @override
  String get reportStatusFailure => 'Epäonnistui';

  @override
  String get reportStatusInProgress => 'Käynnissä';

  @override
  String get reportStatusPartial => 'Osittainen';

  @override
  String get reportStatusSuccess => 'Onnistui';

  @override
  String get reportsEmpty => 'Ei vielä raportteja.';

  @override
  String get uploadFailed => 'Lähetys epäonnistui';

  @override
  String webhookDeleteConfirm(String name) {
    return 'Poistetaanko webhook “$name”?';
  }

  @override
  String get webhookEdit => 'Muokkaa webhookia';

  @override
  String get webhookNew => 'Uusi webhook';

  @override
  String get webhookTestFailed => 'Testiä ei voitu käynnistää';

  @override
  String get webhookTestSent => 'Testiwebhook käynnistetty';

  @override
  String get webhookTime => 'Aika (paikallinen)';

  @override
  String get webhooksEmpty => 'Ei vielä webhookeja.';

  @override
  String get zipImportFailed => 'ZIP-tuonti epäonnistui';

  @override
  String get aiProvidersTitle => 'Tekoälypalvelut';

  @override
  String get aiProvidersDescription =>
      'Määritä tekoälypalvelut ottaaksesi käyttöön tekoälyominaisuuksia, kuten tehostetun ainesosien jäsennyksen, reseptien luomisen videoista ja paljon muuta!';

  @override
  String get aiProviderSettingsTitle => 'Tekoälypalvelun asetukset';

  @override
  String get aiProvidersList => 'Palvelut';

  @override
  String get aiProviderCreate => 'Luo palvelu';

  @override
  String get aiProviderEdit => 'Muokkaa palvelua';

  @override
  String get aiDefaultProvider => 'Oletuspalvelu';

  @override
  String get aiDefaultProviderDescription =>
      'Vaaditaan tekoälyominaisuuksien käyttöön';

  @override
  String get aiAudioProvider => 'Äänipalvelu';

  @override
  String get aiAudioProviderDescription =>
      'Ottaa käyttöön äänen litteroinnin, kuten reseptien luomisen videoista';

  @override
  String get aiImageProvider => 'Kuvapalvelu';

  @override
  String get aiImageProviderDescription =>
      'Ottaa käyttöön kuvantunnistuksen, kuten reseptien luomisen kuvista';

  @override
  String get aiProviderName => 'Palvelun nimi';

  @override
  String get aiApiKey => 'API-avain';

  @override
  String get aiApiKeyCreateDescription =>
      'Palvelusi API-avain todennusta varten. Jos palvelu (esim. Ollama) ei käytä API-avainta, kirjoita tähän silti jotain.';

  @override
  String get aiApiKeyEditDescription =>
      'Jätä tyhjäksi, ellet halua vaihtaa sitä.';

  @override
  String get aiBaseUrl => 'Perus-URL';

  @override
  String get aiBaseUrlDescription =>
      'Jos käytät OpenAI:ta, jätä tyhjäksi. On oltava OpenAI-yhteensopiva päätepiste (esim. \"http://localhost:11434/v1\").';

  @override
  String get aiModel => 'Malli';

  @override
  String get aiModelDescription =>
      'Mitä mallia tekoälypalvelun tulee käyttää (esim. \"gpt-5\").';

  @override
  String get aiTimeout => 'Pyynnön aikakatkaisu (sekuntia)';

  @override
  String get aiProviderCreated => 'Palvelu luotu';

  @override
  String get aiProviderUpdated => 'Palvelu päivitetty';

  @override
  String get aiProviderDeleted => 'Palvelu poistettu';

  @override
  String get aiProviderCreateFailed => 'Palvelun luominen epäonnistui';

  @override
  String get aiProviderUpdateFailed => 'Palvelun päivittäminen epäonnistui';

  @override
  String get aiProviderDeleteFailed => 'Palvelun poistaminen epäonnistui';

  @override
  String get aiRequestHeaders => 'Pyynnön otsakkeet';

  @override
  String get aiRequestParams => 'Pyynnön parametrit';

  @override
  String get aiNoDefaultWarning =>
      'Et ole asettanut oletuspalvelua, joten tekoälyominaisuudet ovat pois käytöstä';

  @override
  String get aiTestConnection => 'Testaa yhteys';

  @override
  String get aiTestSucceeded => 'Yhteys onnistui';

  @override
  String get aiTestFailed => 'Yhteys epäonnistui';

  @override
  String get aiSupportsImages => 'Tukee kuvia';

  @override
  String get aiTextOnly => 'Vain teksti, ei voi olla kuvapalvelusi';

  @override
  String get debugAiTitle => 'Tekoälypalveluiden vianetsintä';

  @override
  String get debugAiDescription =>
      'Käytä tätä sivua tekoälypalveluiden vianetsintään. Voit testata tekoälyyhteyden ja nähdä tulokset täällä. Jos kuvapalvelut ovat käytössä, voit myös antaa kuvan.';

  @override
  String get debugParserTitle => 'Jäsentäjä';

  @override
  String get debugParserDescription =>
      'Mealie käyttää Conditional Random Fields (CRF) ainesosien jäsentämiseen ja prosessointiin. Ainesosien osalta käytetty malli perustuu yli 100000 ainesosan aineistoon New York Timesin kokoamasta aineistosta. Huomaa, että koska malli on koulutettu vain englanniksi, mallilla voi olla vaihtelevia tuloksia, kun käytät mallia muilla kielillä. Tämä sivu on mallin testaamiseen tarkoitettu leikkipaikka.';

  @override
  String get debugIngredientText => 'Ainesosan Teksti';

  @override
  String get debugTryExample => 'Kokeile esimerkkiä';

  @override
  String debugAverageConfidence(String value) {
    return 'Varmuus $value';
  }

  @override
  String get debugRunTest => 'Suorita testi';

  @override
  String get debugQuantity => 'Määrä';

  @override
  String get debugUnit => 'Yksikkö';

  @override
  String get debugFood => 'Elintarvikkeet';

  @override
  String get debugNote => 'Kommentti';

  @override
  String get debugGroup => 'Ryhmä';

  @override
  String get aiProviderNone => 'Tyhjä';

  @override
  String aiProviderDeleteConfirm(String name) {
    return 'Poistetaanko palvelu “$name”?';
  }

  @override
  String get aiProvidersEmpty => 'Ei vielä tekoälypalveluita.';

  @override
  String get aiAdvanced => 'Lisäasetukset';

  @override
  String get aiKeyLabel => 'Nimi';

  @override
  String get aiValueLabel => 'Arvo';

  @override
  String get debugTitle => 'Vianhaku';

  @override
  String get debugParse => 'Jäsennä';

  @override
  String get debugParseFailed => 'Ainesosaa ei voitu jäsentää';

  @override
  String get debugChooseImage => 'Valitse kuva';

  @override
  String get debugNoImage => 'Ei kuvaa (valinnainen)';

  @override
  String get updateTitle => 'Tarkista päivitykset';

  @override
  String get updateInstalledVersion => 'Asennettu versio';

  @override
  String get updateLastCheck => 'Viimeksi tarkistettu';

  @override
  String get updateCheckNow => 'Tarkista nyt';

  @override
  String get updateChecking => 'Etsitään päivityksiä…';

  @override
  String get updateUpToDate => 'Mealie Recipes on ajan tasalla.';

  @override
  String updateAvailable(String version) {
    return 'Versio $version on saatavilla';
  }

  @override
  String get updateAvailableDescription =>
      'Mealie Recipesista on saatavilla uusi versio. Mitään ei asenneta ennen kuin käynnistät päivityksen itse.';

  @override
  String get updateShow => 'Näytä päivitys';

  @override
  String get updateLater => 'Myöhemmin';

  @override
  String updateDownloading(int percent) {
    return 'Ladataan … $percent %';
  }

  @override
  String updateReady(String version) {
    return 'Versio $version on valmis asennettavaksi';
  }

  @override
  String get updateInstalling =>
      'Asennetaan — sovellus käynnistyy automaattisesti uudelleen …';

  @override
  String get updateManual =>
      'Päivitystä ei voitu asentaa automaattisesti. Levykuva on avattu: vedä Mealie Recipes Ohjelmat-kansioon.';

  @override
  String get updateFailed => 'Päivitys epäonnistui';

  @override
  String get updateInstallNow => 'Lataa ja asenna';

  @override
  String get updateRestartNow => 'Asenna ja käynnistä uudelleen';

  @override
  String get updateAutoTitle => 'Tarkista päivitykset käynnistettäessä';

  @override
  String get updateAutoDescription =>
      'Vain tarkistaa ja ilmoittaa — asennuksen käynnistät aina itse.';

  @override
  String get updateBetaTitle => 'Vastaanota beetaversioita';

  @override
  String get updateBetaDescription =>
      'Tarjoaa myös esiversioita testattavaksi. Niissä voi vielä olla virheitä.';

  @override
  String get updateNoNotes => 'Ei julkaisutietoja.';

  @override
  String get updateSourceHint =>
      'Päivitykset tulevat Mealie Recipesin GitHub-julkaisuista, ja ne asennetaan vain, jos kehittäjä on allekirjoittanut ne (macOS).';

  @override
  String get errorNoConnection =>
      'Mealie-palvelinta ei tavoiteta. Tarkista internetyhteys ja palvelimen osoite.';

  @override
  String get errorTimeout =>
      'Palvelin vastasi liian hitaasti. Yritä uudelleen.';

  @override
  String get errorUnauthorized =>
      'Kirjautumisesi on vanhentunut tai API-tunnus ei ole enää voimassa. Kirjaudu uudelleen asetuksissa.';

  @override
  String get errorServer =>
      'Mealie-palvelin ilmoitti virheestä. Yritä myöhemmin uudelleen.';

  @override
  String get errorNotFound =>
      'Ei löytynyt palvelimelta — se on ehkä poistettu.';

  @override
  String get errorCertificate => 'Palvelimen suojausvarmenteeseen ei luoteta.';

  @override
  String get errorGeneric => 'Jokin meni pieleen. Yritä uudelleen.';

  @override
  String get offlineLabel => 'Offline';

  @override
  String offlineSince(String time) {
    return 'Offline · viimeksi synkronoitu $time';
  }

  @override
  String get mealplanEntryActions => 'Aterian valinnat';

  @override
  String get mealplanMoveAction => 'Siirrä';

  @override
  String get mealplanMoveTitle => 'Siirrä ateria';

  @override
  String get mealplanMoveDate => 'Päivämäärä';

  @override
  String mealplanMovedTo(String date) {
    return 'Siirretty päivälle $date';
  }

  @override
  String get mealplanShowWeek => 'Näytä';

  @override
  String get mealplanMoveFailed => 'Ateriaa ei voitu siirtää';

  @override
  String get recentlyViewedTitle => 'Viimeksi katsotut';

  @override
  String get recentlyViewedEmpty => 'Avaamasi reseptit näkyvät täällä.';

  @override
  String get recentlyViewedClear => 'Tyhjennä historia';

  @override
  String get recentlyViewedClearMessage =>
      'Tämän laitteen viimeksi katsottujen reseptien luettelo tyhjennetään. Itse reseptit säilyvät.';

  @override
  String get recentlyViewedClearConfirm => 'Tyhjennä';

  @override
  String get duplicatesTitle => 'Kaksoiskappaleiden etsijä';

  @override
  String get duplicatesScanning => 'Etsitään päällekkäisiä reseptejä…';

  @override
  String get duplicatesNone => 'Päällekkäisiä reseptejä ei löytynyt.';

  @override
  String duplicatesFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Löytyi $count mahdollista kaksoiskappaletta.',
      one: 'Löytyi 1 mahdollinen kaksoiskappale.',
    );
    return '$_temp0';
  }

  @override
  String get duplicatesIntro =>
      'Napauta reseptiä, joka säilytetään, ja yhdistä sitten.';

  @override
  String get duplicatesReasonSource => 'Sama lähde';

  @override
  String get duplicatesReasonName => 'Sama nimi';

  @override
  String duplicatesReasonSimilar(int percent) {
    return 'Samankaltainen · $percent % samoja ainesosia';
  }

  @override
  String get duplicatesKeeps => 'Säilyy';

  @override
  String get duplicatesWillBeDeleted => 'Poistetaan';

  @override
  String get duplicatesMerge => 'Yhdistä';

  @override
  String get duplicatesNotDuplicate => 'Ei kaksoiskappale';

  @override
  String get duplicatesMergeTitle => 'Yhdistetäänkö reseptit?';

  @override
  String duplicatesMergeMessage(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count muuta reseptiä poistetaan',
      one: '1 toinen resepti poistetaan',
    );
    return '“$name” säilyy. $_temp0.\n\nKategoriat, tunnisteet, keittiövälineet, merkinnät, kotitaloutesi suunnitellut ateriat ja suosikkisi siirretään. Poistettujen reseptien kommentit, aikajana ja liitteet menetetään.';
  }

  @override
  String get duplicatesMerged => 'Reseptit yhdistetty';

  @override
  String duplicatesIngredientCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ainesosaa',
      one: '1 ainesosa',
    );
    return '$_temp0';
  }

  @override
  String duplicatesResetIgnored(int count) {
    return 'Näytä piilotetut parit uudelleen ($count)';
  }

  @override
  String get duplicatesRescan => 'Hae uudelleen';

  @override
  String get duplicatesOpenRecipe => 'Avaa resepti';

  @override
  String get duplicatesMergeNoEditHint =>
      'Et saa muokata säilyvää reseptiä (jonkun muun lukittu resepti tai toisesta kotitaloudesta). Sen kategoriat, tunnisteet, keittiövälineet ja merkinnät säilyvät siksi ennallaan; vain suunnitellut ateriat ja suosikkisi siirretään.';

  @override
  String get recipeOtherHouseholdHint =>
      'Toisesta kotitaloudesta – muokkaus on siellä lukittu';

  @override
  String foodsSavedAsNote(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count uutta ruokaa säilytettiin',
      one: '1 uusi ruoka säilytettiin',
    );
    return 'Tallennettu. $_temp0 ainesosan merkintänä – ruokien luominen vaatii Mealiessa oikeuden “Käyttäjä voi hallita ruokia, tunnisteita ja kategorioita”.';
  }

  @override
  String get a11yRemove => 'Poista';

  @override
  String get a11yDecrease => 'Vähemmän';

  @override
  String get a11yIncrease => 'Enemmän';

  @override
  String get a11yShowPassword => 'Näytä salasana';

  @override
  String get a11yHidePassword => 'Piilota salasana';

  @override
  String get a11yClearSearch => 'Tyhjennä haku';

  @override
  String get notesQueuedOffline =>
      'Offline – merkintä lähetetään heti, kun palvelin on taas tavoitettavissa.';

  @override
  String get timelineQueuedOffline =>
      'Offline – se lisätään aikajanalle heti, kun palvelin on taas tavoitettavissa.';

  @override
  String get syncSectionName => 'Nimetty uudelleen';

  @override
  String get pendingRecipesDiscard => 'Hylkää';

  @override
  String get undo => 'Peru';

  @override
  String timerStoppedSnack(String name) {
    return 'Ajastin “$name” pysäytetty';
  }

  @override
  String get cookFriendsEndConfirm =>
      'Lopetetaanko istunto kaikilta? Kaikkien vieraiden yhteys katkaistaan.';

  @override
  String get weekStartSyncHint =>
      'Tallennettu Mealieen – koskee koko kotitalouttasi, myös verkkosovelluksessa.';

  @override
  String get weekStartNoPermission =>
      'Kotitaloutesi asettaa tämän Mealiessa. Vain jäsenet, jotka saavat hallita kotitaloutta, voivat muuttaa sitä.';

  @override
  String get assetsUnsupported329 =>
      'Mealie tukee PDF-, kuva-, video- (MP4, MOV, WebM), ääni- (MP3, M4A), Word/ODT/RTF-, TXT-, MD-, CSV- ja JSON-tiedostoja.';

  @override
  String get assetsRecordVideo => 'Tallenna video';

  @override
  String get assetsChooseVideo => 'Valitse video';

  @override
  String get shoppingSearchHint => 'Hae tästä listasta';

  @override
  String get shoppingSearchNoMatches => 'Mikään tuote ei vastaa hakua.';

  @override
  String get mealplanServingsTitle => 'Suunnitellut annokset';

  @override
  String get mealplanServingsHint =>
      'Vain tälle ateriasuunnitelman merkinnälle — itse resepti ei muutu. Kun resepti avataan ja lisätään ostoslistalle, käytetään näitä annoksia.';

  @override
  String get calendarFeedTitle => 'Tilaa kalenteri';

  @override
  String get calendarFeedSubtitle =>
      'Näytä ateriasuunnitelma Googlen, Applen tai muussa kalenterissa';

  @override
  String get calendarFeedDescription =>
      'Tilaa kotitaloutesi ateriasuunnitelma Google-kalenteriin, Apple-kalenteriin, Home Assistantiin tai muuhun sovellukseen, joka tukee iCal-linkkejä. Kuka tahansa linkin omaava näkee ateriasuunnitelmasi.';

  @override
  String get calendarFeedOff =>
      'Kalenterilinkki on pois päältä kotitaloudessasi.';

  @override
  String get calendarFeedAskManager =>
      'Pyydä kotitaloutta hallinnoivaa ottamaan se käyttöön.';

  @override
  String get calendarFeedTurnOn => 'Ota käyttöön';

  @override
  String get calendarFeedTurnOff => 'Poista käytöstä';

  @override
  String get calendarFeedReset => 'Nollaa linkki';

  @override
  String get calendarFeedResetHint =>
      'Linkin nollaaminen tai poistaminen käytöstä lopettaa olemassa olevien tilausten päivittymisen.';

  @override
  String get calendarFeedIncludeNotes => 'Sisällytä merkinnät';

  @override
  String get calendarFeedTimesHint =>
      'Aseta aterian aika napauttamalla sitä. Ateriat ilman aikaa näytetään koko päivän tapahtumina.';

  @override
  String get calendarFeedMealTypes => 'Aterian tyyppi';

  @override
  String get calendarFeedSubscribe => 'Tilaa kalenterissa';

  @override
  String get calendarFeedNoApp =>
      'Kalenterisovellusta ei voitu avata. Kopioi linkki ja lisää se kalenteriisi tilauksena.';

  @override
  String get calendarFeedPublicHint =>
      'Linkki toimii ilman kirjautumista — jaa se vain niille, jotka saavat nähdä ateriasuunnitelmasi.';

  @override
  String get recipeShareLinkMenu => 'Jakolinkki ja QR-koodi';

  @override
  String get recipeShareShowQr => 'Näytä QR-koodi';

  @override
  String get recipeShareScanQr =>
      'Skannaa puhelimen kameralla avataksesi reseptin';

  @override
  String get recipeShareQrShare => 'Jaa kuva';

  @override
  String get recipeShareQrFailed => 'QR-koodikuvaa ei voitu luoda';

  @override
  String get mealplanSettingsTitle => 'Ateriasuunnitelman asetukset';

  @override
  String get mealDiceRulesTitle => 'Nopan säännöt';

  @override
  String saveAsNewFood(String name) {
    return 'Tallenna “$name” uutena ruokana';
  }

  @override
  String get shoppingMoreOptions => 'Lisää valintoja';

  @override
  String get shoppingFewerOptions => 'Vähemmän valintoja';

  @override
  String nameAlreadyExists(String name) {
    return 'On jo olemassa: $name';
  }

  @override
  String aliasBelongsTo(String alias, String name) {
    return '“$alias” kuuluu jo kohteelle “$name” — yhdistä ne mieluummin.';
  }

  @override
  String get recipeMatchTitle => 'Recipe Match';

  @override
  String get recipeMatchShuffle => 'Sekoita';

  @override
  String recipeMatchCardsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reseptiä pakassa',
      one: '1 resepti pakassa',
    );
    return '$_temp0';
  }

  @override
  String get recipeMatchNext => 'Seuraava';

  @override
  String get recipeMatchKeep => 'Tarjottimelle';

  @override
  String get recipeMatchKept => 'Laitettu tarjottimelle';

  @override
  String get recipeMatchAnyTime => 'Mikä tahansa kesto';

  @override
  String recipeMatchMaxTime(int minutes) {
    return '≤ $minutes min';
  }

  @override
  String get recipeMatchEmpty => 'Ei sopivia reseptejä';

  @override
  String get recipeMatchEmptyHint => 'Muuta suodattimia tai tyhjennä tarjotin.';

  @override
  String get recipeMatchResetFilters => 'Nollaa suodattimet';

  @override
  String get recipeMatchFlipHint => 'Napauta: ainesosat · ohjeet';

  @override
  String get recipeMatchFlipBack => 'Käännä takaisin';

  @override
  String get recipeMatchOpenRecipe => 'Koko resepti';

  @override
  String get recipeMatchOnHand => 'saatavilla';

  @override
  String get recipeMatchTray => 'Tarjotin';

  @override
  String get recipeMatchTrayEmpty => 'Vielä tyhjä – vedä kortti alas';

  @override
  String recipeMatchTrayCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reseptiä',
      one: '1 resepti',
    );
    return '$_temp0';
  }

  @override
  String get recipeMatchClear => 'Tyhjennä';

  @override
  String get recipeMatchTrayHint =>
      'Pysyy, kunnes tyhjennät sen – myös kun suljet pakan.';

  @override
  String get recipeMatchRemove => 'Poista tarjottimelta';

  @override
  String get recipeMatchToMealplan => 'Lisää ateriasuunnitelmaan';

  @override
  String get recipeMatchToShopping => 'Ainesosat ostoslistalle';

  @override
  String get recipeMatchSelectIngredients => 'Valitse ainesosat';

  @override
  String get recipeMatchNoList => 'Valitse ensin ostoslista.';

  @override
  String get recipeMatchList => 'Lista';

  @override
  String get recipeMatchOnHandHint =>
      'Saatavilla olevien ainesosien valinta on jo poistettu.';

  @override
  String recipeMatchAddCount(int selected, int total) {
    return 'Lisää $selected/$total ainesosaa';
  }

  @override
  String get recipeMatchNoDay => 'Ei vielä päivää – pysyy tarjottimella';

  @override
  String recipeMatchAddMeals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Lisää $count ateriaa',
      one: 'Lisää 1 ateria',
    );
    return '$_temp0';
  }

  @override
  String recipeMatchMealsAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ateriaa lisätty',
      one: '1 ateria lisätty',
    );
    return '$_temp0';
  }

  @override
  String get recipeMatchSwipeUp => 'Avaa tarjotin pyyhkäisemällä ylös';

  @override
  String get weekPlannerTitle => 'Suunnittele viikko';

  @override
  String get weekPlannerStepDays => 'Päivät';

  @override
  String get weekPlannerStepPrefs => 'Asetukset';

  @override
  String get weekPlannerStepPreview => 'Esikatselu';

  @override
  String get weekPlannerDaysTitle => 'Mitkä ateriat sovellus täyttää?';

  @override
  String get weekPlannerDaysHint =>
      'Napauta ruutuja. Jo suunnitellut pysyvät ennallaan.';

  @override
  String get weekPlannerPresetWeekdays => 'Arkipäivät';

  @override
  String get weekPlannerPlanned => 'suunniteltu';

  @override
  String get weekPlannerMoreMeals => 'Näytä lisää aterioita';

  @override
  String get weekPlannerFewerMeals => 'Vähemmän aterioita';

  @override
  String weekPlannerMealCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ateriaa',
      one: '1 ateria',
    );
    return '$_temp0';
  }

  @override
  String get weekPlannerPrefsTitle =>
      'Mihin sovelluksen pitää kiinnittää huomiota?';

  @override
  String get weekPlannerPrefsHint =>
      'Kaikki valinnaista – ilman valintaa se poimii monipuolisen sekoituksen resepteistäsi.';

  @override
  String get weekPlannerQuick => 'Nopeasti arkisin';

  @override
  String weekPlannerQuickSub(int minutes) {
    return 'Ma–pe enintään $minutes min';
  }

  @override
  String get weekPlannerStale => 'Pitkään tekemättömät ensin';

  @override
  String get weekPlannerStaleSub =>
      '“Viimeksi tehty” -tiedon ja ateriasuunnitelman perusteella';

  @override
  String get weekPlannerFavorites => 'Suunnittele suosikkeja useammin';

  @override
  String get weekPlannerFavoritesSub =>
      'sydämellä merkityt ja korkealle arvioidut reseptit';

  @override
  String get weekPlannerVariety => 'Vaihtelu';

  @override
  String get weekPlannerVarietySub => 'ei samaa kategoriaa kahdesti peräkkäin';

  @override
  String get weekPlannerOnlyFrom => 'Vain kohteesta';

  @override
  String get weekPlannerDiceRules => 'Käytä nopan sääntöjä';

  @override
  String get weekPlannerDiceRulesSub =>
      'ateriakohtainen valintasi ateriasuunnitelman asetuksista';

  @override
  String weekPlannerMatching(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sopivaa reseptiä',
      one: '1 sopiva resepti',
    );
    return '$_temp0';
  }

  @override
  String weekPlannerForMeals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count aterialle',
      one: '1 aterialle',
    );
    return '$_temp0';
  }

  @override
  String get weekPlannerSuggest => 'Ehdota';

  @override
  String get weekPlannerPreviewHint =>
      'Noppa vaihtaa, lukko pitää. Pidä ruokaa painettuna ja vedä se toiselle päivälle vaihtaaksesi ne.';

  @override
  String get weekPlannerRerollAll => 'Heitä kaikki uudelleen';

  @override
  String get weekPlannerReroll => 'Heitä uudelleen';

  @override
  String get weekPlannerLock => 'Lukitse';

  @override
  String get weekPlannerUnlock => 'Avaa lukitus';

  @override
  String get weekPlannerReasonNever => 'ei koskaan tehty';

  @override
  String get weekPlannerReasonStale => 'ei tehty pitkään aikaan';

  @override
  String get weekPlannerReasonFavorite => 'Suosikki';

  @override
  String get weekPlannerNoMatch => 'Ei sopivaa reseptiä';

  @override
  String get weekPlannerThenShopping =>
      'Valitse sitten ainesosat ostoslistalle';

  @override
  String get weekPlannerMostlyEmpty => 'Viikko lähes tyhjä';

  @override
  String weekPlannerMostlyEmptySub(int free, int total) {
    return '$free/$total päivää vielä vapaana – täytä ne kolmessa vaiheessa.';
  }

  @override
  String get previousWeek => 'Edellinen viikko';

  @override
  String get nextWeek => 'Seuraava viikko';

  @override
  String get weekPlannerAllDays => 'Kaikki päivät';

  @override
  String get weekPlannerWeekend => 'Viikonloppu';

  @override
  String get weekPlannerDinners => 'Päivälliset';

  @override
  String get weekPlannerLunches => 'Lounaat';

  @override
  String get weekPlannerAllMeals => 'Kaikki ateriat';

  @override
  String get mealplanDayEmpty => 'Ei mitään suunniteltu';

  @override
  String get mealplanDropHere => 'Pudota tähän';

  @override
  String mealplanDayKcal(String kcal) {
    return '$kcal kcal annosta kohden';
  }

  @override
  String mealplanDayKcalPartial(String kcal) {
    return 'vähintään $kcal kcal annosta kohden';
  }

  @override
  String get globalSearchHint => 'Hae reseptejä, tuotteita, toimintoja …';

  @override
  String get globalSearchIntro =>
      'Hae reseptejä, ostoslistan tuotteita, ruokia ja keittokirjoja – sekä sovelluksen toimintoja ja asetuksia, esim. “lista”.';

  @override
  String get globalSearchFunctions => 'Toiminnot';

  @override
  String globalSearchNoResults(String query) {
    return 'Ei tuloksia haulle “$query”';
  }

  @override
  String get searchClear => 'Tyhjennä haku';

  @override
  String get recipeMatchPlanWeek => 'Suunnittele viikko näillä resepteillä';

  @override
  String get weekPlannerReasonTray => 'tarjottimelta';

  @override
  String get emptyBrowseRecipes => 'Selaa reseptejä';

  @override
  String get mealplanWeekShopping => 'Tämän viikon ainesosat';

  @override
  String get globalSearchActions => 'Toiminnot';

  @override
  String globalSearchAddToList(String text) {
    return 'Lisää “$text” ostoslistalle';
  }

  @override
  String globalSearchAdded(String text) {
    return '“$text” lisätty';
  }

  @override
  String get globalSearchImportUrl => 'Tuo resepti tästä osoitteesta';

  @override
  String get homeContinueCooking => 'Jatka kokkausta';

  @override
  String homeCookingStep(int step, int total) {
    return 'Vaihe $step/$total';
  }

  @override
  String get homeCookingPrep => 'Valmistelu';

  @override
  String get homeCookingAlmostDone => 'Melkein valmis';

  @override
  String get homeCookingContinue => 'jatka';

  @override
  String get paneSelectRecipe => 'Valitse resepti vasemmalta.';

  @override
  String get mealplanDragRecipeHint =>
      'Suunnittele resepti vetämällä se päivän kohdalle.';

  @override
  String get desktopDropUnsupported =>
      'Näitä tiedostoja ei voi lisätä liitteiksi.';

  @override
  String desktopDropUploaded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count liitettä lisätty',
      one: '1 liite lisätty',
    );
    return '$_temp0';
  }

  @override
  String get desktopDropAsAttachment => 'Pudota lisätäksesi liitteeksi';

  @override
  String get printAction => 'Tulosta';

  @override
  String get mealplanPrintWeek => 'Tulosta viikko';

  @override
  String get mealplanEntryCooked => 'Tehty';

  @override
  String get recipeSearchClear => 'Tyhjennä haku';

  @override
  String get organizerShowRecipes => 'Näytä reseptit';

  @override
  String globalSearchShowAllRecipes(int count) {
    return 'Näytä kaikki $count reseptiä';
  }

  @override
  String get unnamedEntry => '(ei nimeä)';

  @override
  String get mealplanWholeWeek => 'Koko viikolle';

  @override
  String get mealplanWholeWeekDropHint =>
      'Pudota ateria tähän suunnitellaksesi sen koko viikolle.';

  @override
  String get mealplanMovedToWholeWeek => 'Suunniteltu koko viikolle';

  @override
  String get mealplanCookToday => 'Teen sen tänään';

  @override
  String get mealplanPlanWholeWeek => 'Suunnittele koko viikolle';

  @override
  String mealplanPlanWholeWeekRange(String from, String to) {
    return '$from – $to';
  }

  @override
  String get calendarFeedDuration => 'Kesto (minuuttia)';

  @override
  String get calendarFeedEventDetails => 'Tapahtuman tiedot';

  @override
  String calendarFeedEventDetailsHint(String fields) {
    return 'Mukauta, miten ateriat näkyvät kalenterissasi. Yhdistämiskentät: $fields';
  }

  @override
  String get calendarFeedEventTitle => 'Tapahtuman otsikko';

  @override
  String get calendarFeedEventDescription => 'Tapahtuman kuvaus';

  @override
  String get calendarFeedEventDetailsWarning =>
      'Näiden muuttaminen muuttaa kalenterilinkkiä — jos olet jo tilannut, tilaa uudelleen uudella linkillä.';

  @override
  String get stepDurationMinutes => 'Kesto (minuuttia)';

  @override
  String stepDurationSaved(String duration) {
    return 'Tallennettu kesto: $duration. Muokkaus korvaa sen kokonaisilla minuuteilla.';
  }

  @override
  String get sortTotalTimeShort => 'Lyhin kokonaisaika';

  @override
  String get sortTotalTimeLong => 'Pisin kokonaisaika';

  @override
  String recipeCreatedBy(String name) {
    return 'Luonut $name';
  }

  @override
  String get timelineReplacePhoto => 'Vaihda kuva';

  @override
  String get pasteRecipeTitle => 'Liitä resepti';

  @override
  String get pasteRecipeDescription =>
      'Liitä resepti JSON-muodossa (schema.org) tai verkkosivun HTML-lähdekoodina.';

  @override
  String get pasteRecipeDescription330 =>
      'Liitä Mealiesta viety resepti (JSON) — se tuodaan koko rakenteineen: ruoat, yksiköt ja vaiheiden linkit. Myös JSON (schema.org) ja verkkosivun HTML-lähdekoodi toimivat.';

  @override
  String get pasteRecipeHint => 'Liitä JSON tai HTML tähän';

  @override
  String get pasteRecipeButton => 'Liitä resepti';

  @override
  String get pasteRecipeImport => 'Tuo';

  @override
  String get aiPromptsTitle => 'Tekoälykehotteet';

  @override
  String get aiPromptsTeaser =>
      'Mukauta ohjeita, jotka Mealie antaa tekoälypalvelullesi — kaikille tehtäville tai kullekin erikseen.';

  @override
  String get aiPromptsDescription =>
      'Mukauta ohjeita, jotka Mealie antaa tekoälypalvelullesi kullekin tehtävälle. Mealien kehotteet on kirjoitettu englanniksi, mutta se ei muuta reseptiesi kieltä: ne säilyttävät lähteen kielen, ellet valitse kääntää niitä. Voit kirjoittaa omat ohjeesi millä tahansa kielellä.';

  @override
  String get aiPromptsGlobal => 'Ohjeet kaikille kehotteille';

  @override
  String get aiPromptsGlobalDescription =>
      'Lisätään jokaiseen kehotteeseen, joka tuottaa reseptitietoja, kuten reseptien rakentaminen, ainesosien jäsentäminen ja kääntäminen. Järjestelmäkehotteisiin ei vaikuteta.';

  @override
  String get aiPromptsGlobalPlaceholder =>
      'esim. Käytä aina metrisiä yksiköitä.';

  @override
  String get aiPromptsList => 'Kehotteet';

  @override
  String get aiPromptSystem => 'Järjestelmä';

  @override
  String get aiPromptSystemDescription =>
      'Tämä on järjestelmäkehote. Se litteroi lähdemateriaalin mahdollisimman tarkasti ennen kuin siitä tehdään resepti, joten kaikkien kehotteiden ohjeita ei lisätä siihen. Sen muuttaminen ei yleensä ole tarpeen ja voi heikentää tuontien luotettavuutta.';

  @override
  String get aiPromptAppended => 'Täydennetty';

  @override
  String get aiPromptOverridden => 'Korvattu';

  @override
  String get aiPromptModeDefault => 'Oletus';

  @override
  String get aiPromptModeAppend => 'Täydennä';

  @override
  String get aiPromptModeOverride => 'Korvaa';

  @override
  String get aiPromptAppendDescription =>
      'Nämä ohjeet lisätään Mealien kehotteeseen, ja ne ovat etusijalla, jos ne ovat ristiriidassa.';

  @override
  String get aiPromptOverrideDescription =>
      'Kehotteesi korvaa Mealien kehotteen kokonaan, joten Mealien kehotteen tulevat päivitykset eivät koske sitä. Tehtävän tarvitsemat tiedot, kuten yksikköluettelosi, lisätään silti kehotteesi perään.';

  @override
  String get aiPromptDefaultChanged =>
      'Mealien kehote on muuttunut sen jälkeen, kun korvasit sen. Vertaa sitä omaasi tai palaa oletukseen käyttääksesi uutta versiota.';

  @override
  String get aiPromptViewDefault => 'Näytä oletuskehote';

  @override
  String get aiPromptHideDefault => 'Piilota oletuskehote';

  @override
  String get aiPromptSaved => 'Kehote tallennettu';

  @override
  String get aiPromptSaveFailed => 'Kehotteen tallentaminen epäonnistui';

  @override
  String get aiPromptTitleBuildRecipe => 'Rakenna resepti';

  @override
  String get aiPromptTitleParseIngredients => 'Jäsennä ainesosat';

  @override
  String get aiPromptTitleRecipeVideo => 'Resepti videosta';

  @override
  String get aiPromptTitleOrganizers => 'Määritä järjestäjät';

  @override
  String get aiPromptTitleTranslate => 'Käännä resepti';

  @override
  String get aiPromptTitleCompileSource => 'Lue lähdemateriaali';

  @override
  String get aiPromptTitleTranscribe => 'Litteroi ääni';

  @override
  String get aiPromptDescBuildRecipe =>
      'Muuttaa verkkosivulta, kuvasta tai tekstistä luetun lähdemateriaalin jäsennellyksi reseptiksi.';

  @override
  String get aiPromptDescParseIngredients =>
      'Tekoälyn ainesosajäsennin käyttää tätä jakaakseen jokaisen ainesosan määrään, yksikköön, ruokaan ja merkintään.';

  @override
  String get aiPromptDescRecipeVideo =>
      'Muuttaa videon litteroinnin ja kuvatekstin reseptiksi.';

  @override
  String get aiPromptDescOrganizers =>
      'Valitsee tunnisteet, kategoriat ja keittiövälineet tuodulle reseptille.';

  @override
  String get aiPromptDescTranslate =>
      'Kääntää tuodun reseptin valitsemallesi kielelle.';

  @override
  String get aiPromptDescCompileSource =>
      'Lukee verkkosivut, kuvat ja tekstin reseptin pelkkänä tekstinä.';

  @override
  String get aiPromptDescTranscribe =>
      'Litteroi äänen, kun äänipalvelusi ei voi litteroida sitä suoraan.';

  @override
  String get mealplanNoteHint => 'Merkintä (valinnainen)';

  @override
  String get mealplanEditTitle => 'Muokkaa merkintää';

  @override
  String get mealplanEntryTitleLabel => 'Otsikko';

  @override
  String get mealplanEntryNoteLabel => 'Merkintä';

  @override
  String mealplanCreateRecipe(String name) {
    return 'Uusi resepti “$name”';
  }

  @override
  String get mealplanCreateRecipeSubtitle =>
      'Luo tyhjän reseptin, suunnittelee sen ja avaa editorin';

  @override
  String get importOptionsTitle => 'Tuonnin valinnat';

  @override
  String get importOptionsHint =>
      'Kuinka paljon Mealien tekoäly tekee palvelimellasi tuonnin aikana. Jokainen lisävaihe on oma tekoälypyyntönsä – mitä vähemmän, sitä nopeammin.';

  @override
  String get importTranslateTitle => 'Käännä resepti';

  @override
  String get importOrganizersTitle => 'Kategoriat ja tunnisteet';

  @override
  String get importOrganizersCreate => 'Lisää uusia';

  @override
  String get importOrganizersExisting => 'Vain olemassa olevat';

  @override
  String get importOrganizersNone => 'Tyhjä';

  @override
  String get importOrganizersCreateHint =>
      'Tekoäly määrittää tunnisteet, kategoriat ja keittiövälineet ja luo puuttuvat.';

  @override
  String get importOrganizersExistingHint =>
      'Tekoäly käyttää vain jo olemassa olevia tunnisteita, kategorioita ja keittiövälineitä.';

  @override
  String get importOrganizersNoneHint =>
      'Resepti tuodaan ilman tunnisteita, kategorioita ja keittiövälineitä. Mealie suorittaa tämän vaiheen silti, joten tuonti ei nopeudu.';

  @override
  String get importStarting => 'Lähetetään palvelimelle…';

  @override
  String get importRunning => 'Tuodaan reseptiä…';

  @override
  String get aiImagesRunning => 'Tekoäly lukee sivuja…';

  @override
  String get importStreamPhotosTitle =>
      'Kuvatuonti reaaliaikaisella edistymisellä';

  @override
  String get importStreamPhotosHint =>
      'Näyttää jokaisen vaiheen ja pitää yhteyden auki pitkien tuontien ajan. Poista käytöstä, jos haluat lähettää yhdellä pyynnöllä kuten ennen – esim. jos välityspalvelimesi estää suoratoiston.';

  @override
  String get weekPlannerDiceRulesMealieSub =>
      'kotitaloutesi Mealie-säännöt (ateriasuunnitelman asetukset)';

  @override
  String get syncStarted =>
      'Ladataan reseptejä, kuvia ja listoja uudelleen palvelimelta…';

  @override
  String get syncDone => 'Kaikki on ajan tasalla';

  @override
  String get recipeReloaded => 'Resepti ladattu uudelleen';

  @override
  String get logoutTitle => 'Kirjaudu ulos / vaihda käyttäjää';

  @override
  String get logoutConfirm =>
      'Reseptit, listat ja vielä synkronoimattomat muutokset poistetaan tästä laitteesta. Sovelluksen asetukset ja palvelimen osoite säilyvät, joten sinun tarvitsee vain kirjautua uudelleen.';

  @override
  String get reloadRecipe => 'Lataa uudelleen palvelimelta';

  @override
  String get wifiServerTitle => 'Eri osoite Wi-Fi-verkossa';

  @override
  String get wifiServerHint =>
      'Samalle palvelimelle toisella osoitteella, esim. paikallinen IP kotona ja ZeroTier, Tailscale tai verkkotunnus liikkeellä. Alla olevassa Wi-Fi-verkossa sovellus käyttää automaattisesti tätä osoitetta, muualla yllä olevaa palvelimen URL-osoitetta.';

  @override
  String get wifiSsidLabel => 'Wi-Fi-verkon nimi';

  @override
  String get wifiServerUrl => 'Osoite tässä Wi-Fi-verkossa';

  @override
  String get wifiUseCurrent => 'Käytä nykyistä Wi-Fi-verkkoa';

  @override
  String get wifiNameUnavailable =>
      'Wi-Fi-verkon nimeä ei voitu lukea. Yhdistä Wi-Fi-verkkoon ja salli sijainnin käyttö – Android ja iOS paljastavat verkon nimen vain sen kanssa.';

  @override
  String wifiServerActive(String ssid) {
    return 'Käytössä: osoite Wi-Fi-verkossa “$ssid”';
  }

  @override
  String wifiServerStandardActive(String ssid) {
    return 'Käytössä: palvelimen URL (ei verkossa “$ssid”)';
  }

  @override
  String get wifiServerRemove => 'Poista';

  @override
  String get switchUserTitle => 'Vaihda käyttäjää';

  @override
  String switchUserBody(String name) {
    return '$name pysyy tallennettuna tähän laitteeseen – kaikkine resepteineen, listoineen ja synkronoimattomine muutoksineen. Voit vaihtaa takaisin profiilikuvan tai kirjautumissivun kautta.';
  }

  @override
  String get allowBiometricTitle => 'Vaihda takaisin laitteen avauksella';

  @override
  String get allowBiometricHint =>
      'Face ID, sormenjälki tai laitteen PIN salasanan sijaan. Kuka tahansa, joka voi avata tämän laitteen, voi silloin avata tämän tilin.';

  @override
  String get allow => 'Salli';

  @override
  String unlockAccountReason(String name) {
    return 'Vaihda käyttäjään $name';
  }

  @override
  String signInAs(String name) {
    return 'Kirjaudu käyttäjänä $name';
  }

  @override
  String wrongAccountError(String name) {
    return 'Tämä on tili “$name”. Kirjaudu tallennetulla tilillä.';
  }

  @override
  String get accountSaveOffline =>
      'Tiliä ei voi tallentaa juuri nyt – palvelinta ei tavoiteta.';

  @override
  String get signOutRemoveTitle => 'Kirjaudu ulos ja poista';

  @override
  String get signOutRemoveConfirm =>
      'Tämä tili ja kaikki sen tiedot tässä laitteessa (reseptit, listat, synkronoimattomat muutokset) poistetaan. Sovelluksen asetukset säilyvät.';

  @override
  String get removeSavedAccount => 'Poista tästä laitteesta';

  @override
  String removeSavedAccountConfirm(String name) {
    return 'Poistetaanko “$name” ja kaikki sen tallennetut tiedot tästä laitteesta? Synkronoimattomat muutokset menetetään.';
  }

  @override
  String get savedAccountsTitle => 'Tallennetut tilit';

  @override
  String get addAccount => 'Lisää toinen tili';

  @override
  String get biometricOff => 'Lopeta laitteen avauksen käyttö';

  @override
  String get orNewAccount => 'Tai kirjaudu toisella tilillä:';

  @override
  String get importVideoTitle => 'Videolinkit';

  @override
  String get importVideoFast => 'Nopea';

  @override
  String get importVideoThorough => 'Perusteellinen (tekoäly)';

  @override
  String get importVideoFastHint =>
      'Mealie litteroi videon ja rakentaa reseptin yhdellä tekoälypyynnöllä – yleensä paljon nopeammin. Ei käännöstä eikä kategorioita/tunnisteita. Voit silti ottaa tekoälyn käyttöön tuontikohtaisesti.';

  @override
  String get importVideoThoroughHint =>
      'Tekoälykytkin kytkeytyy videolinkeille automaattisesti: useita tekoälyvaiheita, käännös ja kategoriat/tunnisteet yllä asetetun mukaan. Kestää pidempään.';

  @override
  String get importPresetFast => 'Nopea';

  @override
  String get importPresetThorough => 'Perusteellinen';

  @override
  String get importPresetCustom => 'Mukautettu';

  @override
  String get importPresetFastTitle =>
      'Mahdollisimman vähän tekoälyvaiheita – lyhin odotus';

  @override
  String get importPresetFastVideo =>
      'Videolinkit: Mealie litteroi videon ja rakentaa reseptin yhdellä tekoälypyynnöllä (tekoälykytkin pysyy pois päältä).';

  @override
  String get importPresetFastTranslate =>
      'Ei käännöstä – resepti pysyy alkuperäisellä kielellä.';

  @override
  String get importPresetFastOrganizers =>
      'Vain olemassa olevat kategoriat ja tunnisteet määritetään, uusia ei luoda.';

  @override
  String get importPresetThoroughTitle =>
      'Mealien täysi tekoälytuonti – kestää pidempään, saa eniten irti';

  @override
  String get importPresetThoroughVideo =>
      'Videolinkit tuodaan automaattisesti tekoälyllä – useassa vaiheessa (lähteen kokoaminen, reseptin rakentaminen, …).';

  @override
  String get importPresetThoroughTranslate =>
      'Resepti käännetään alla olevalle tuontikielelle, jos se on kirjoitettu toisella kielellä.';

  @override
  String get importPresetThoroughOrganizers =>
      'Sopivat kategoriat ja tunnisteet määritetään; puuttuvat luodaan.';

  @override
  String get importPresetCustomTitle => 'Aseta jokainen valinta itse';

  @override
  String get importPresetCustomBody =>
      'Lähde siitä, mitä aiempi valintasi teki, ja muuta vain tarvittava – esim. nopeat videotuonnit mutta käännöksellä.';

  @override
  String get sidebarPinHint =>
      'Vinkki: pidä ruutua painettuna ja vedä se sivupalkkiin kiinnittääksesi sen sinne.';

  @override
  String get sidebarDropHere => 'Pudota tähän';

  @override
  String sidebarShortcutTitle(String name) {
    return 'Pikanäppäin kohteelle “$name”';
  }

  @override
  String sidebarShortcutPrompt(String modifier) {
    return 'Paina nyt haluamaasi näppäinyhdistelmää, mukaan lukien $modifier.';
  }

  @override
  String get sidebarShortcutTaken => 'Tämä yhdistelmä on jo käytössä.';

  @override
  String get sidebarShortcutNone => 'Ei pikanäppäintä';

  @override
  String get sidebarShortcutChange => 'Vaihda pikanäppäin';

  @override
  String get sidebarUnpin => 'Poista sivupalkista';

  @override
  String sidebarFull(int count) {
    return 'Sivupalkki on täynnä – enintään $count omaa kohdetta.';
  }

  @override
  String get tabletSidebar => 'Sivupalkki vaakatilassa';

  @override
  String get tabletSidebarSubtitle =>
      'Näyttää navigoinnin vasemmalla alareunan sijaan, kun tablettia pidetään vaakatasossa';

  @override
  String get filterDateCreated => 'Luontipäivä';

  @override
  String get filterDateUpdated => 'Päivitetty';

  @override
  String get errorUploadTooLarge =>
      'Tiedosto on liian suuri tälle Mealie-palvelimelle. Palvelimen latausrajaa voi nostaa asetuksella MAX_UPLOAD_SIZE_MB.';

  @override
  String get recipeDownloadPdfMealie => 'Lataa PDF (Mealien asettelu)';

  @override
  String get mealplanNoteMore => 'Näytä lisää…';

  @override
  String get mealplanNoteLess => 'Näytä vähemmän';

  @override
  String get ingredientCommonlySubstitutedWith => 'Korvataan usein';

  @override
  String requiresMealieVersion(String version) {
    return 'Vaatii Mealien $version tai uudemman.';
  }

  @override
  String get apiTokensTitle => 'API-tokenit';

  @override
  String get apiTokensDescription =>
      'Hallitse ulkoisten sovellusten API-tunnisteitasi.';

  @override
  String get apiTokenNameLabel => 'Tokenin nimi';

  @override
  String get apiTokenGenerate => 'Generoi';

  @override
  String get apiTokensActive => 'AKTIIVISET TOKENIT';

  @override
  String get apiTokenCopyWarning =>
      'Kopioi tokeni käyttääksesi sitä muussa sovelluksessa. Et voi nähdä tokenia tämän jälkeen.';

  @override
  String get apiTokenThisApp => 'Tämän sovelluksen käytössä';

  @override
  String get apiTokenThisAppHint =>
      'Tämä tunnus pitää sovelluksen kirjautuneena, eikä sitä voi poistaa täältä.';

  @override
  String apiTokenDeleteConfirm(String name) {
    return 'Poistetaanko tunnus “$name”? Sitä käyttävät sovellukset menettävät käyttöoikeuden heti.';
  }

  @override
  String get apiTokensEmpty => 'Ei vielä tunnuksia.';

  @override
  String apiTokenCreatedOn(String date) {
    return 'Luotu $date';
  }

  @override
  String get apiTokenCopied => 'Tunnus kopioitu';

  @override
  String get qfOpHasNoValue => 'ei ole arvoa';

  @override
  String get qfOpHasValue => 'on arvo';

  @override
  String get ratingHouseholdAverage => 'kotitalouden ka.';

  @override
  String get stepLinkedNotes => 'Linkitetyt merkinnät';

  @override
  String get noteFallbackTitle => 'Merkintä';

  @override
  String get aiPromptTitleEnrichInstructions => 'Lisää vaiheiden tiedot';

  @override
  String get aiPromptDescEnrichInstructions =>
      'Linkittää tuodun reseptin jokaisen vaiheen sen käyttämiin ainesosiin ja merkintöihin sekä poimii vaiheen keston ja otsikon.';

  @override
  String get loginAccountLocked => 'Tili lukittu. Yritä myöhemmin uudelleen';

  @override
  String get loginPasswordDisabled =>
      'Salasanakirjautuminen on poistettu käytöstä tällä palvelimella. Käytä sen sijaan API-tunnusta.';

  @override
  String get unitSystemTitle => 'Yksiköt';

  @override
  String get unitSystemAsWritten => 'Kuten kirjoitettu';

  @override
  String get unitSystemMetric => 'Metrinen';

  @override
  String get unitSystemMetricHint => 'Metrinen (g, ml)';

  @override
  String get unitSystemImperial => 'Imperiaalinen';

  @override
  String get unitSystemImperialHint => 'Imperiaalinen (kupit, oz)';

  @override
  String get unitSystemHint =>
      'Vain näyttö – itse resepti ei muutu. Kuten Mealien verkkosovelluksessa, valinta koskee kaikkia tämän laitteen reseptejä.';

  @override
  String get unitSystemUnavailable =>
      'Mitään tämän reseptin yksikköä ei voi muuntaa. Se vaatii yksikölle standardoinnin Mealiessa (Ruoat ja yksiköt → yksikkö → Standardointi).';

  @override
  String get shoppingCheckAll => 'Valitse kaikki kohteet';

  @override
  String get shoppingUncheckAll => 'Poista valinta kaikista kohdista';

  @override
  String get shoppingDeleteChecked => 'Poista valitut';

  @override
  String get shoppingCheckAllConfirm =>
      'Haluatko varmasti valita kaikki kohteet?';

  @override
  String get shoppingUncheckAllConfirm =>
      'Haluatko varmasti poistaa kaikki valinnat?';

  @override
  String shoppingItemCheckedOff(String item) {
    return '$item valittu';
  }

  @override
  String get updateGithubUnavailable =>
      'GitHub ei vastaa juuri nyt. Yritä uudelleen muutaman minuutin kuluttua.';
}
