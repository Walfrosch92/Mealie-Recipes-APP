// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get endCookingMode => 'Pişirme modunu bitir';

  @override
  String get endCookingModeConfirm =>
      'Pişirme modunu gerçekten bitirmek istiyor musunuz?';

  @override
  String endCookingModeConfirmAll(int count) {
    return 'Pişirme modundaki $count tarifin tümü bitirilecek. Devam edilsin mi?';
  }

  @override
  String get addTimer => 'Zamanlayıcı ekle';

  @override
  String get recipeFinished => 'Yemeğiniz hazır.';

  @override
  String get bonAppetit => 'Afiyet olsun!';

  @override
  String get prepareIngredients => 'Lütfen şu malzemeleri hazırlayın';

  @override
  String prepareIngredientsFor(String servings) {
    return 'Lütfen şu malzemeleri $servings porsiyon için hazırlayın';
  }

  @override
  String get next => 'Sonraki';

  @override
  String get navHome => 'Ana Sayfa';

  @override
  String get homeCookToday => 'Bugün pişir';

  @override
  String get homeSuggestion => 'Öneri';

  @override
  String get homeQuickAccess => 'Hızlı erişim';

  @override
  String get homePlanned => 'Planlanan';

  @override
  String get favorite => 'Favori';

  @override
  String get navSettings => 'Ayarlar';

  @override
  String homeWelcomeName(Object name) {
    return 'Hoş geldiniz $name,';
  }

  @override
  String get homeWelcomeApp => 'Mealie Recipes\'e 👋';

  @override
  String get theme => 'Görünüm';

  @override
  String get themeSystem => 'Sistem';

  @override
  String get themeLight => 'Aydınlık';

  @override
  String get themeDark => 'Koyu';

  @override
  String get recipes => 'Tarifler';

  @override
  String get shoppingList => '🛒 Alışveriş Listesi';

  @override
  String get mealplan => 'Öğün planı';

  @override
  String get settings => '⚙️ Ayarlar';

  @override
  String get searchRecipe => 'Tarif ara...';

  @override
  String get loadingRecipe => 'Tarifler Yükleniyor...';

  @override
  String get errorLoadingRecipe => 'Tarif yüklenemedi.';

  @override
  String get noRecipesForCategory => 'Bu filtre için tarif yok.';

  @override
  String get resetFilter => 'Filtreyi sıfırla';

  @override
  String get allCategories => 'Tüm kategoriler';

  @override
  String get all => 'Tümü';

  @override
  String get sortRecipes => 'Tarifleri sırala';

  @override
  String get refreshRecipes => 'Yenile';

  @override
  String get sortNameAZ => 'Ad A–Z';

  @override
  String get sortNameZA => 'Ad Z–A';

  @override
  String get sortDateNewest => 'Önce en yeni';

  @override
  String get sortDateOldest => 'Önce en eski';

  @override
  String get sortPrepTimeShort => 'En kısa hazırlık süresi';

  @override
  String get sortPrepTimeLong => 'En uzun hazırlık süresi';

  @override
  String get sortRatingHighest => 'En yüksek puan';

  @override
  String get sortRatingLowest => 'En düşük puan';

  @override
  String get details => 'Ayrıntılar';

  @override
  String get ingredients => 'Malzemeler';

  @override
  String get instructions => 'Yapılışı';

  @override
  String get tags => 'Etiketler';

  @override
  String get notes => 'Notlar';

  @override
  String get addNote => 'Not ekle';

  @override
  String get editNote => 'Notu düzenle';

  @override
  String get noteTitleHint => 'Başlık (isteğe bağlı)';

  @override
  String get noteTextHint => 'Not metni';

  @override
  String get deleteNoteTitle => 'Not silinsin mi?';

  @override
  String get deleteNoteMessage => 'Bu not kalıcı olarak silinecek.';

  @override
  String get servings => 'Porsiyon';

  @override
  String get planMeal => 'Öğün planla';

  @override
  String get addAllIngredients => 'Tüm malzemeleri ekle';

  @override
  String get addSelectedIngredients => 'Seçili malzemeleri ekle';

  @override
  String get addIngredientsMessage => 'Malzemeler alışveriş listenize eklendi.';

  @override
  String addIngredientsFailedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count malzeme eklenemedi.',
      one: '1 malzeme eklenemedi.',
    );
    return '$_temp0';
  }

  @override
  String get cookbooks => 'Yemek Kitapları';

  @override
  String get cookbooksEmpty =>
      'Henüz yemek kitabı yok. Oluşturmak için sağ üstteki “+” simgesine dokunun.';

  @override
  String get cookbookNoMatches => 'Bu filtreyle eşleşen tarif yok.';

  @override
  String get cookbookCreateTitle => 'Yemek kitabı oluştur';

  @override
  String get cookbookEditTitle => 'Yemek kitabını düzenle';

  @override
  String get cookbookNameLabel => 'Yemek kitabı adı';

  @override
  String get cookbookFilterSectionTitle => 'Tarifleri otomatik ekle';

  @override
  String get cookbookFieldTools => 'Araçlar';

  @override
  String get cookbookFieldUsers => 'Kullanıcılar';

  @override
  String get cookbookOpIsOneOf => 'şunlardan biri';

  @override
  String get cookbookOpIsNotOneOf => 'şunlardan biri değil';

  @override
  String get cookbookOpContainsAll => 'tümünü içerir';

  @override
  String get cookbookSelectValues => 'Değer seç';

  @override
  String get cookbookFilterOptionsUnavailable => 'Kullanılabilir seçenek yok';

  @override
  String get cookbookAddFilterField => 'Alan ekle';

  @override
  String get cookbookPublicLabel => 'Herkese açık yemek kitabı';

  @override
  String get cookbookPublicSubtitle =>
      'Sunucudaki diğer ev halkları tarafından görülebilir';

  @override
  String get cookbookRawModeEnter => 'Metin olarak düzenle';

  @override
  String get cookbookRawModeExit => 'Oluşturucuya dön';

  @override
  String get cookbookRawModeHint =>
      'Uygulamanın uzman modu: filtreyi doğrudan metin olarak düzenler. Mevcut bir filtre basit satırlara ayrılamadığında işe yarar.';

  @override
  String get cookbookRawModeUnparseable =>
      'Bu metin basit satır biçimine uymuyor — metin olarak kalır.';

  @override
  String get saveFailed => 'Kaydedilemedi';

  @override
  String get search => 'Ara';

  @override
  String get apply => 'Uygula';

  @override
  String get setupCachingTitle => 'Tarifleriniz yükleniyor';

  @override
  String get setupCachingSubtitle =>
      'Tarifleriniz çevrimdışı kullanım için hazırlanıyor. Sayısına bağlı olarak bu biraz sürebilir.';

  @override
  String get setupCachingDone => 'Her şey hazır!';

  @override
  String get setupTipsHeader => 'Biliyor muydunuz?';

  @override
  String get setupFinish => 'Başlayalım';

  @override
  String get setupSkipCaching => 'Arka planda devam et';

  @override
  String get setupTip1 =>
      'Tarifleri bir bağlantıdan, fotoğraftan veya PDF\'den içe aktarabilirsiniz — ana ekrandaki İçe Aktar kutucuğuyla.';

  @override
  String get setupTip2 =>
      'Pişirme modu ekranı açık tutar, sizi adım adım yönlendirir ve metindeki zamanlayıcıları otomatik algılar.';

  @override
  String get setupTip3 =>
      'Alışveriş listesi çevrimdışı da çalışır — sunucuya ulaşılınca değişiklikler otomatik eşitlenir.';

  @override
  String get setupTip4 =>
      'Hızlı erişimi yeniden düzenlemek için ana ekrandaki bir kutucuğa uzun basın.';

  @override
  String get setupTip5 =>
      'Mealie yemek kitaplarınızı Yemek Kitapları kutucuğunda bulursunuz — çevrimdışı da.';

  @override
  String get ok => 'Tamam';

  @override
  String get cancel => 'İptal';

  @override
  String get delete => 'Sil';

  @override
  String get edit => 'Düzenle';

  @override
  String get save => 'Kaydet';

  @override
  String get done => 'Tamamlandı';

  @override
  String get close => 'Kapat';

  @override
  String get add => 'Ekle';

  @override
  String get send => 'Gönder';

  @override
  String get retry => 'Tekrar dene';

  @override
  String get confirmDeleteTitle => 'Tarif silinsin mi?';

  @override
  String get confirmDeleteMessage => 'Bu işlem geri alınamaz.';

  @override
  String get sendToDevice => 'Cihaza gönder';

  @override
  String get timerFinished => 'Zamanlayıcı bitti!';

  @override
  String get timer => 'Zamanlayıcı';

  @override
  String get newTimer => 'Yeni zamanlayıcı';

  @override
  String get timerNamePlaceholder => 'Zamanlayıcı adı';

  @override
  String get durationLabel => 'Süre';

  @override
  String get start => 'Başlat';

  @override
  String get stop => 'Durdur';

  @override
  String get pause => 'Duraklat';

  @override
  String get resume => 'Devam et';

  @override
  String get finished => 'Bitti!';

  @override
  String stepNumber(int number) {
    return 'Adım $number';
  }

  @override
  String get minAbbreviation => 'dk';

  @override
  String get cookingMode => 'Pişirme Modu';

  @override
  String get endAll => 'Tümünü bitir';

  @override
  String get end => 'Bitir';

  @override
  String get noActiveTimers => 'Etkin zamanlayıcı yok';

  @override
  String get noActiveRecipes => 'Etkin tarif yok';

  @override
  String get startRecipeToCook =>
      'Başlamak için bir tarif açın ve pişirme modu düğmesine dokunun.';

  @override
  String get browseRecipes => 'Tariflere göz at';

  @override
  String get cookFriends => 'Arkadaşlarla pişir';

  @override
  String get cookingModeAddRecipe => 'Tarif ekle';

  @override
  String get cookingModeAddRecipeSearchHint => 'Tarif ara';

  @override
  String get cookFriendsCode => 'Oturum kodu';

  @override
  String get cookFriendsJoin => 'Oturuma katıl';

  @override
  String get cookFriendsHost => 'Oturum başlat';

  @override
  String get cookFriendsHostNotFound =>
      'Ana cihaz bulunamadı. İki cihazın da aynı Wi-Fi ağında olduğundan ve yerel ağ erişimine izin verildiğinden emin olun.';

  @override
  String get cookFriendsConnectionFailed =>
      'Bağlantı kurulamadı. Lütfen tekrar deneyin.';

  @override
  String get cookFriendsEnterCode => 'Kodu girin';

  @override
  String cookFriendsConnected(int count) {
    return 'Bağlı: $count misafir';
  }

  @override
  String get joinSession => 'Oturuma katıl';

  @override
  String get hostEndedSessionMessage => 'Ev sahibi pişirme oturumunu bitirdi.';

  @override
  String get addItem => 'Öge ekle';

  @override
  String get itemNote => 'Ürün adı';

  @override
  String get unlabeledCategory => 'Etiketsiz';

  @override
  String get archivedLists => '📦 Arşivlenmiş alışverişler';

  @override
  String get postimportAction => 'İçe aktarma sonrası';

  @override
  String get postimportHint =>
      'İçe aktarılan kayıtlara kaynak uygulamada (Anımsatıcılar / Google Tasks) ne olacağını seçin.';

  @override
  String get postimportLeave => 'Yalnızca ekle';

  @override
  String get postimportComplete => 'İşaretle';

  @override
  String get postimportCompleteDelete => 'İşaretle ve sil';

  @override
  String get postimportFailed =>
      'Kaynak uygulamadaki son işlem başarısız oldu. Ürünler yine de Mealie\'ye eklendi.';

  @override
  String get syncChangesTitle => 'Değişiklikleri eşitle';

  @override
  String get syncSectionChecked => 'İşaretlenenler';

  @override
  String get syncSectionQuantity => 'Miktar';

  @override
  String get syncSectionCategory => 'Kategori';

  @override
  String get syncSectionAdditions => 'Yeni eklenenler';

  @override
  String get syncLocalLabel => 'Yerel';

  @override
  String get syncServerLabel => 'Sunucu';

  @override
  String get syncNow => 'Şimdi eşitle';

  @override
  String get offlineBadge => 'Çevrimdışı';

  @override
  String get mealplanTitle => '📅 Öğün planı';

  @override
  String get breakfast => 'Kahvaltı';

  @override
  String get lunch => 'Öğle Yemeği';

  @override
  String get dinner => 'Akşam Yemeği';

  @override
  String get addMealEntry => 'Öğün ekle';

  @override
  String get selectRecipe => 'Tarif seç';

  @override
  String get importRecipe => 'Tarif içe aktar';

  @override
  String get url => 'URL';

  @override
  String get importLanguage => 'OCR dili';

  @override
  String get setupTitle => 'Mealie Recipes\'e hoş geldiniz';

  @override
  String get setupSubtitle => 'Lütfen Mealie sunucunuzu yapılandırın.';

  @override
  String get serverUrl => 'Sunucu URL\'si';

  @override
  String get serverUrlPlaceholder => 'https://mealie.example.com';

  @override
  String get apiToken => 'API Anahtarı';

  @override
  String get apiTokenPlaceholder => 'API anahtarınız';

  @override
  String get householdId => 'Ev Halkı';

  @override
  String get householdIdPlaceholder => 'Aile';

  @override
  String get shoppingListId => 'Alışveriş listesi kimliği';

  @override
  String get setupHouseholdListTitle => 'Ev halkı ve alışveriş listesi';

  @override
  String get shoppingListLabel => 'Alışveriş listesi';

  @override
  String get setupHouseholdManualHint =>
      'Ev halkları yüklenemedi — ev halkının adını elle girin.';

  @override
  String get setupExactTitle => 'Alışveriş listesindeki miktarlar';

  @override
  String get setupExactBody =>
      'Çoğu ülkede gram hassasiyetinde alışveriş yapılmaz — sepete 200 g değil, 1 paket tereyağı konur. Bu yüzden basit modda uygulama tarif miktarlarını “1×” olarak çevirir. Tam modda miktar ve birim, Mealie web uygulamasındaki gibi 1:1 korunur — yeni ürün yazarken de (ör. “200 g tereyağı”). Bunu ayarlardan istediğiniz zaman değiştirebilirsiniz.';

  @override
  String get setupExactSimpleTitle => 'Basit mod (1×)';

  @override
  String get setupExactSimpleBody =>
      'Malzemeler listeye “1× ürün” olarak eklenir — markette hızlıca işaretlemek için ideal.';

  @override
  String get setupExactExactTitle => 'Tam miktarlar';

  @override
  String get setupExactExactBody =>
      'Ürünler miktar ve birimle görünür, ör. “200 g tereyağı” — tıpkı web uygulamasındaki gibi.';

  @override
  String get connect => 'Bağlan';

  @override
  String connectionError(String error) {
    return 'Bağlantı başarısız: $error';
  }

  @override
  String get optionalHeaders =>
      'İsteğe bağlı HTTP başlıkları (ters proxy için)';

  @override
  String get settingsTitle => '⚙️ Ayarlar';

  @override
  String get settingsSaved => 'Ayarlar kaydedildi';

  @override
  String get securitySettings => 'Güvenlik';

  @override
  String get showRecipeImages => 'Tarif görsellerini göster';

  @override
  String get apiVersion => 'API sürümü';

  @override
  String get language => 'Dil';

  @override
  String get biometricLock => 'Biyometrik kilit';

  @override
  String get biometricLockDescription => 'Uygulamanın kilidini biyometriyle aç';

  @override
  String get enableLogging => 'Günlüğü etkinleştir';

  @override
  String get selectLanguage => 'Dil seç';

  @override
  String get setupContinue => 'Devam';

  @override
  String get back => 'Geri';

  @override
  String get setupConnectStep => 'Sunucunuza bağlanın';

  @override
  String get resetSettings => 'Tüm ayarları sıfırla';

  @override
  String get resetSettingsConfirm =>
      'Tüm ayarlar sıfırlanacak. Devam edilsin mi?';

  @override
  String get guestMode => 'Misafir modu';

  @override
  String get appVersion => 'Sürüm';

  @override
  String get leftoverFinder => 'Tarif Bulucu';

  @override
  String get addIngredient => 'Malzeme ekle';

  @override
  String get biometricPrompt =>
      'Mealie Recipes\'i açmak için kimliğinizi doğrulayın';

  @override
  String get biometricFailed => 'Kimlik doğrulama başarısız';

  @override
  String get pendingRecipesTitle => 'Alınan tarifler';

  @override
  String pendingRecipesFrom(Object names) {
    return 'Gönderen: $names';
  }

  @override
  String get pendingRecipesOpenCooking => 'Pişirme modunu aç';

  @override
  String get dismiss => 'Kapat';

  @override
  String get editRecipe => 'Tarifi düzenle';

  @override
  String get recipeName => 'Tarif adı';

  @override
  String get prepTime => 'Hazırlık süresi (dk)';

  @override
  String get cookTime => 'Pişirme süresi (dk)';

  @override
  String get totalTime => 'Toplam süre (dk)';

  @override
  String get recipeServings => 'Porsiyon';

  @override
  String get rating => 'Puan';

  @override
  String get addIngredientLine => 'Malzeme ekle';

  @override
  String get addInstruction => 'Adım ekle';

  @override
  String get removeIngredient => 'Malzemeyi kaldır';

  @override
  String get removeInstruction => 'Adımı kaldır';

  @override
  String get ingredientName => 'İçindekiler';

  @override
  String get ingredientQuantity => 'Adet';

  @override
  String get ingredientUnit => 'Birim';

  @override
  String get ingredientNote => 'Not';

  @override
  String get instructionText => 'Adım metni';

  @override
  String get categories => 'Kategoriler';

  @override
  String get saveChanges => 'Değişiklikleri kaydet';

  @override
  String get saveSuccess => 'Tarif kaydedildi.';

  @override
  String get newCategory => 'Yeni kategori';

  @override
  String get newTag => 'Yeni etiket';

  @override
  String get setRating => 'Puan ver';

  @override
  String get homeWelcome => 'Mealie Recipes\'e hoş geldiniz! 👋';

  @override
  String homeWelcomeNamed(String name) {
    return 'Mealie Recipes\'e hoş geldiniz, $name! 👋';
  }

  @override
  String get shopping => 'Alışveriş';

  @override
  String get planning => 'Planlama';

  @override
  String get other => 'Diğer';

  @override
  String get addRecipe => '➕ Tarif ekle';

  @override
  String get completeShopping => 'Alışverişi tamamla';

  @override
  String get shoppingCompleted => 'Alışveriş tamamlandı';

  @override
  String get shoppingCompletedSubtitle => 'Hepsi sepette! 🎉';

  @override
  String get shoppingOfflineNoCache => 'Çevrimdışı – liste kaydedilmedi';

  @override
  String get shoppingOfflineNoCacheSubtitle =>
      'Bu listenin hiçbir ürünü henüz bu cihazda kayıtlı değil. Tekrar çevrimiçi olduğunuzda yüklenecek.';

  @override
  String get essensplan => '📅 Öğün planı';

  @override
  String get resteverwertung => '🥗 Tarif bulucu';

  @override
  String get copyCode => 'Kodu kopyala';

  @override
  String get shareLink => 'Bağlantıyı paylaş';

  @override
  String get connectedFriends => 'Bağlı arkadaşlar';

  @override
  String get waitingForFriends => 'Arkadaşlar bekleniyor...';

  @override
  String get sessionCode => 'OTURUM KODU';

  @override
  String get loading => 'Yükleniyor...';

  @override
  String get urlInvalidScheme => 'URL http:// veya https:// ile başlamalıdır';

  @override
  String get urlAddScheme => 'https:// ekle';

  @override
  String get addItemPlaceholder => 'Ürün ekle...';

  @override
  String get completedItems => 'Tamamlananlar';

  @override
  String get completeShoppingTitle => 'Alışveriş tamamlansın mı?';

  @override
  String get completeShoppingMessage => 'Tamamlanan ürünler silinsin mi?';

  @override
  String get recipeListTitle => '📖 Tarifler';

  @override
  String get importRecipeTitle => 'Yeni tarif yükle';

  @override
  String get uploadRecipeUrl => 'Tarif URL\'si ile içe aktar';

  @override
  String get uploadRecipeUrlHint =>
      'Sunucunuza kaydetmek için tarifin URL\'sini girin';

  @override
  String get uploadOpenAI => 'OpenAI ile dosyadan içe aktar';

  @override
  String get uploadOpenAIHint =>
      'Ya da bir tarifin fotoğraflarını veya PDF\'ini yükleyin. Tarif birkaç sayfaysa birden fazla ekleyin — yapay zekâ bunları birlikte analiz eder.';

  @override
  String get takePhoto => 'Kamera';

  @override
  String get cameraPermissionDenied =>
      'Kameraya erişim yok. Tarif fotoğraflamak için sistem ayarlarından izin verin.';

  @override
  String get cameraUnavailable => 'Bu cihazda kamera yok.';

  @override
  String get selectPhoto => 'Fotoğraflar';

  @override
  String get selectPdf => 'PDF';

  @override
  String get openAIHintTitle => 'Dosya analizi hakkında';

  @override
  String get openAIHintBody =>
      'Tarif analizi OpenAI API\'sini kullanır. API anahtarınızın Mealie sunucu ayarlarında yapılandırıldığından emin olun.';

  @override
  String get allDeleteConfirm => 'Tümünü sil';

  @override
  String get entriesInOtherWeeks => 'Başka haftalarda kayıtlar var';

  @override
  String get availableWeeks => 'Mevcut haftalar:';

  @override
  String get currentWeek => 'Bu hafta';

  @override
  String get weekAbbreviation => 'Hf.';

  @override
  String get today => 'Bugün';

  @override
  String get selectDate => 'Tarih seç';

  @override
  String get selectedRecipe => 'Seçili tarif';

  @override
  String get confirmMeal => 'Öğünü planla';

  @override
  String get searchRecipes => 'Tarif ara';

  @override
  String get addCustomMeal => 'Özel öğün ekle';

  @override
  String get diceModeButton => 'Rastgele tarif at';

  @override
  String get diceModeTitle => '3 rastgele öneri';

  @override
  String get diceBackToSearch => 'Aramaya dön';

  @override
  String get diceNotEnoughRecipes =>
      'Zar modu için yeterli tarif yok (en az 3 gerekli)';

  @override
  String get entrySingular => 'kayıt';

  @override
  String get entriesPlural => 'kayıt';

  @override
  String get deleteAllConfirmTitle => 'Tümü silinsin mi?';

  @override
  String get deleteAllConfirmMessage =>
      'Tüm arşivlenmiş alışverişleri silmek istiyor musunuz?';

  @override
  String get uploadFromUrlButton => 'URL\'den tarif içe aktar';

  @override
  String get uploadingImage => 'Yükleniyor...';

  @override
  String get uploadErrorTitle => 'Yükleme başarısız';

  @override
  String get uploadSuccessTitle => 'Yükleme başarılı';

  @override
  String get editImportedRecipeQuestion =>
      'Yeni tarifi şimdi düzenlemek ister misiniz?';

  @override
  String get notNow => 'Şimdi değil';

  @override
  String get pdfTooLarge => 'PDF dosyası çok büyük (en fazla 10 MB).';

  @override
  String get invalidUrl =>
      'Geçersiz URL. Lütfen geçerli bir HTTP(S) URL\'si girin.';

  @override
  String get cookWithFriends => 'Arkadaşlarla pişir';

  @override
  String get cookFriendsSubtitle =>
      'Bu tarifi birlikte pişirmek için bir arkadaşınızı davet edin';

  @override
  String get copied => 'Kopyalandı';

  @override
  String get linkCopied => 'Bağlantı kopyalandı';

  @override
  String get startCooking => 'Pişirmeye başla';

  @override
  String get uploadToOwnServer => 'Kendi sunucuma kaydet';

  @override
  String get uploadingRecipe => 'Tarif yükleniyor…';

  @override
  String get recipeUploadedToOwnServer => 'Tarif sunucunuza kaydedildi';

  @override
  String get recipeUploadFailed => 'Yükleme başarısız';

  @override
  String get allowGuestSaveRecipes =>
      'Misafirlerin tarifleri kendi sunucularına kaydetmesine izin ver';

  @override
  String get appIcon => 'Uygulama simgesi';

  @override
  String get name => 'İsim';

  @override
  String get color => 'Renk';

  @override
  String get randomColor => 'Rastgele renk';

  @override
  String get createFailed => 'Oluşturulamadı';

  @override
  String get deleteFailed => 'Silinemedi';

  @override
  String deleteOrganizerConfirm(String name) {
    return '“$name” silinsin mi? Sunucudan da kaldırılır.';
  }

  @override
  String get connectionSection => 'Bağlantı';

  @override
  String get token => 'Anahtar';

  @override
  String get advancedOptions => 'Gelişmiş seçenekler';

  @override
  String get mealieApiVersion => 'Mealie API sürümü';

  @override
  String get sendOptionalHeaders => 'İsteğe bağlı başlıkları gönder';

  @override
  String get offlineRecipeImages => 'Tarif görsellerini çevrimdışı kaydet';

  @override
  String get offlineRecipeImagesHint =>
      'Tüm tarif görsellerini – adımlardaki ve notlardaki görseller dahil – cihaza indirir, böylece bağlantı olmadan da görünürler. Büyük koleksiyonlar birkaç yüz MB yer kaplayabilir. Kapatıldığında kayıtlı görseller silinir.';

  @override
  String offlineRecipeImagesStatus(int count, int total, String size) {
    return 'Kaydedilen: $count/$total · $size';
  }

  @override
  String get offlineRecipeImagesDisableConfirm =>
      'Kayıtlı tüm tarif görselleri silinsin mi?';

  @override
  String headerNameLabel(int n) {
    return 'Başlık $n adı';
  }

  @override
  String headerValueLabel(int n) {
    return 'Başlık $n değeri';
  }

  @override
  String get value => 'Değer';

  @override
  String get personalization => 'Kişiselleştirme';

  @override
  String get showRecipeImagesSubtitle => 'Tarif listesinde görselleri gösterir';

  @override
  String get exactQuantities => 'Tam miktarları ekle';

  @override
  String get exactQuantitiesSubtitle =>
      'Malzemeler ve yazılan ürünler, ürün başına 1× yerine miktar ve birimi korur (ör. 200 g tereyağı)';

  @override
  String get remindToShop => 'Alışverişi hatırlat';

  @override
  String get remindToShopSubtitle =>
      'Kayıtlı bir konumun yakınındayken ve alışveriş listenizde açık ürün varken sizi bilgilendirir — uygulama kapalıyken bile';

  @override
  String get shoppingReminderAddLocation => 'Konum ekle';

  @override
  String get shoppingReminderMaxLocations => 'En fazla 3 konuma ulaşıldı';

  @override
  String get shoppingReminderLocationServiceDisabled =>
      'Bu cihazda konum servisleri kapalı';

  @override
  String get shoppingReminderPermissionTitle => 'Konum erişimi gerekli';

  @override
  String get shoppingReminderPermissionMessage =>
      'Bir mağazanın yakınındayken size hatırlatmak için “Her zaman” konum erişimi gerekir — uygulama kapalıyken bile. Lütfen Ayarlar\'dan etkinleştirin.';

  @override
  String get openSettings => 'Ayarları aç';

  @override
  String get shoppingReminderLocationName => 'İsim';

  @override
  String get shoppingReminderUseCurrentLocation => 'Geçerli konumu kullan';

  @override
  String get shoppingReminderOrAddress => 'veya bir adres girin';

  @override
  String get shoppingReminderAddress => 'Adres';

  @override
  String get shoppingReminderAddressPlaceholder => 'Sokak, şehir';

  @override
  String get shoppingReminderSearchAddress => 'Ara';

  @override
  String get shoppingReminderLocationFailed => 'Konumunuz belirlenemedi';

  @override
  String get shoppingReminderAddressNotFound => 'Adres bulunamadı';

  @override
  String get ratingFailed => 'Puan kaydedilemedi — lütfen tekrar deneyin.';

  @override
  String get lastCooked => 'Son yapılış';

  @override
  String get syncLastCooked => '“Son yapılış”ı güncelle';

  @override
  String get syncLastCookedSubtitle =>
      'Bugünün tarihini ve bir zaman çizelgesi kaydını sunucuya kaydeder — Mealie web uygulaması gibi.';

  @override
  String get developer => 'Geliştirici';

  @override
  String get enableLoggingSubtitle =>
      'Çıktı/hata günlüklerini kaydeder (son 500 satır)';

  @override
  String get entriesLabel => 'Kayıtlar';

  @override
  String get fileSize => 'Dosya boyutu';

  @override
  String get showAction => 'Göster';

  @override
  String get copy => 'Kopyala';

  @override
  String logsWithCount(int count) {
    return 'Günlükler ($count)';
  }

  @override
  String get noLogs => 'Günlük yok';

  @override
  String get logsTitle => 'Günlükler';

  @override
  String get required => 'Zorunlu';

  @override
  String get connectionFailedCheck =>
      'Bağlantı başarısız. URL\'yi ve anahtarı kontrol edin.';

  @override
  String get username => 'Kullanıcı Adı';

  @override
  String get password => 'Şifre';

  @override
  String get setupPasswordHint =>
      'Şifreniz saklanmaz — uygulama bir kez giriş yapar ve bundan bir API anahtarı oluşturur (web uygulamasındaki Profil → API Anahtarları gibi).';

  @override
  String get loginAndConnect => 'Giriş yap ve bağlan';

  @override
  String get loginInvalidCredentials => 'Kullanıcı adı veya şifre yanlış.';

  @override
  String get apiTokenSaveHint =>
      'Anahtar uygulandı — lütfen aşağıdaki “Değişiklikleri kaydet”e dokunun.';

  @override
  String get renewApiToken => 'API anahtarını yenile';

  @override
  String get setupAuthChoiceTitle => 'Nasıl giriş yapmak istersiniz?';

  @override
  String get authModePasswordTitle =>
      'Uygulama benim için bir API anahtarı oluştursun';

  @override
  String get authModePasswordSubtitle =>
      'Kullanıcı adı ve şifreyle giriş yapın — uygulama otomatik olarak bir anahtar oluşturur.';

  @override
  String get authModeTokenTitle => 'Zaten bir API anahtarım var';

  @override
  String get authModeTokenSubtitle =>
      'Mealie profilinden kopyalandı (Profil → API Anahtarları).';

  @override
  String keyN(int n) {
    return 'Anahtar $n';
  }

  @override
  String valueN(int n) {
    return 'Değer $n';
  }

  @override
  String get openCookingMode => 'Pişirme modunu aç';

  @override
  String activeRecipes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count etkin tarif',
      one: '1 etkin tarif',
    );
    return '$_temp0';
  }

  @override
  String get reparseIngredients => 'Malzemeleri yeniden ayrıştır';

  @override
  String get reparseIngredientsSubtitle =>
      'Miktar/birim/malzemeyi ayır (ör. “200 g un”)';

  @override
  String get reparseDone =>
      'Malzemeler ayrıldı – uygulamak için “Değişiklikleri kaydet”e dokunun';

  @override
  String get tagsAndCategories => 'Etiketler, kategoriler ve araçlar';

  @override
  String get tapToAddPhoto => 'Fotoğraf eklemek için dokunun';

  @override
  String get descriptionLabel => 'Açıklama';

  @override
  String get searchingDevices => 'Aynı Wi-Fi\'daki cihazlar aranıyor…';

  @override
  String get selectAll => 'Tümünü seç';

  @override
  String get importReminders => 'Anımsatıcıları içe aktar';

  @override
  String get importGoogleTasks => 'Google Tasks\'ı içe aktar';

  @override
  String get noTaskLists => 'Görev listesi bulunamadı';

  @override
  String get noReminderLists => 'Anımsatıcı listesi bulunamadı';

  @override
  String importCount(int count) {
    return '$count öğeyi içe aktar';
  }

  @override
  String get noIngredientsToLink => 'Henüz bağlanacak malzeme yok';

  @override
  String get importLanguageSubtitle =>
      'Fotoğraf veya PDF\'den içe aktarılan tariflerin dili';

  @override
  String get importLanguageSearch => 'Dil ara';

  @override
  String get importLanguageFollowApp => 'Uygulama diliyle aynı';

  @override
  String get importLanguageNoMatch => 'Dil bulunamadı';

  @override
  String get setupImportLanguageTitle => 'Yapay zekâ ile tarif içe aktarma';

  @override
  String get setupImportLanguageBody =>
      'Fotoğraflar ve PDF\'ler yapay zekâ ile tariflere dönüştürülebilir. Hangi dilde olmaları gerektiğini seçin — ana diliniz uygulama dili olarak yoksa kullanışlıdır. Bunu daha sonra ayarlardan değiştirebilirsiniz.';

  @override
  String get setupImportLanguageSearchHint =>
      'Uygulama arayüzünün sunmadığı dilleri bulmak için seçicideki aramayı kullanın.';

  @override
  String get setupCachingKeepOpenTitle => 'Lütfen uygulamayı açık tutun';

  @override
  String get setupCachingKeepOpenBody =>
      'Yükleme ön planda çalışır. Bitene kadar uygulamayı açık bırakın — kapatır veya uzun süre başka uygulamaya geçerseniz işlem durur ve daha sonra baştan başlar.';

  @override
  String get supportContact => 'Destekle iletişime geç';

  @override
  String get supportDialogMessage =>
      'Sorununuzu anlatın, size geri dönelim. Günlük, sorun gidermede çok yardımcı olur — metin dosyası olarak ekleyebilirsiniz.';

  @override
  String get supportWithoutLogs => 'Günlüksüz';

  @override
  String get supportWithLogs => 'Günlüğü ekle';

  @override
  String get supportMailSubject => 'Mealie Recipes — Destek';

  @override
  String get supportMailHint => 'Lütfen sorununuzu buraya yazın:';

  @override
  String get supportLogsEmpty =>
      'Günlük boş. Günlüğü etkinleştirin, sorunu yeniden oluşturun ve ardından gönderin.';

  @override
  String supportAddressCopied(String email) {
    return 'Adres kopyalandı: $email';
  }

  @override
  String supportNoMailApp(String email) {
    return 'Kurulu e-posta uygulaması yok – adres kopyalandı: $email. Bize yazmak için başka bir uygulama seçin.';
  }

  @override
  String get createRecipeFromImages => 'Tarif oluştur';

  @override
  String imagePagesSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sayfa seçildi',
      one: '1 sayfa seçildi',
    );
    return '$_temp0';
  }

  @override
  String get imagePagesHint =>
      'İlk görsel tarifin ana görseli olur. Sırasını değiştirmek için bir sayfaya basılı tutun.';

  @override
  String get mainImageBadge => 'Ana';

  @override
  String maxImagesReached(int max) {
    return 'Tarif başına en fazla $max görsel ekleyebilirsiniz.';
  }

  @override
  String get removePage => 'Sayfayı kaldır';

  @override
  String get preparingPdf => 'PDF işleniyor...';

  @override
  String get recipeOptionsTitle => 'Seçenekler';

  @override
  String get exportAsPdf => 'PDF olarak dışa aktar';

  @override
  String get generatingPdf => 'PDF oluşturuluyor…';

  @override
  String get pdfExportFailed => 'PDF dışa aktarma başarısız';

  @override
  String get recipeTime => 'Süre';

  @override
  String get addIngredientSection => 'Bölüm ekle';

  @override
  String get aiImportToggle => 'Yapay zekâ ile analiz et';

  @override
  String get aiImportToggleHint =>
      'Tarif videoları (YouTube, Instagram, TikTok …) ve normal içe aktarmanın okuyamadığı sayfalar için de. Mealie sunucunuzda bir yapay zekâ sağlayıcısı gerekir — videolar için ayrıca bir ses sağlayıcısı.';

  @override
  String get aiImportButton => 'YZ ile İçe Aktar';

  @override
  String get aiImportRunning =>
      'Yapay zekâ bağlantıyı analiz ediyor … videolar birkaç dakika sürebilir.';

  @override
  String get aiImportFailed =>
      'Yapay zekâ ile içe aktarma başarısız. Mealie sunucunuzdaki yapay zekâ ayarlarını kontrol edin.';

  @override
  String get stepHeadingLabel => 'Adım başlığı (isteğe bağlı)';

  @override
  String get linkedRecipeLabel => 'Bağlı tarif';

  @override
  String get toolsTitle => 'Araçlar';

  @override
  String get prepareTools => 'Lütfen şu araçları hazırlayın';

  @override
  String get newTool => 'Yeni araç';

  @override
  String get renameAction => 'Yeniden adlandır';

  @override
  String get organizerEmpty =>
      'Burada henüz bir şey yok. Oluşturmak için sağ üstteki “+” simgesine dokunun.';

  @override
  String organizerRecipeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tarif',
      one: '1 tarif',
      zero: 'Tarif yok',
    );
    return '$_temp0';
  }

  @override
  String get toolOnHand => 'Mevcut';

  @override
  String get mealDiceSettingsHint =>
      'Her öğün için kategori ve etiket seçin. Zar atıldığında yalnızca bunlardan en az birine sahip tarifler önerilir. Aynı öğe birden çok öğün için kullanılabilir.';

  @override
  String get mealDiceSettingsNoneHint =>
      'Bu öğün için hiçbir şey seçilmedi: zar, “Kahvaltı”, “Öğle Yemeği” veya “Akşam Yemeği” gibi kategori adlarına göre otomatik seçer.';

  @override
  String get mealDiceAutoHintTitle => 'Otomatik seçim';

  @override
  String get mealDiceAutoHintBody =>
      'Bu öğün için henüz kategori veya etiket ayarlanmadı. Bu yüzden zar “Kahvaltı”, “Öğle Yemeği” veya “Akşam Yemeği” gibi kategorileri arar ve diğer tariflerle tamamlar.\n\nKendiniz seçmek için: öğün planında “+” simgesinin yanındaki dişli simgesine dokunun.';

  @override
  String get dontShowAgain => 'Bir daha gösterme';

  @override
  String get mealDiceNoMatches =>
      'Bu öğün için seçilen kategori ve etiketlerle eşleşen tarif yok.';

  @override
  String mealDiceFewMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Yalnızca $count eşleşen tarif',
      one: 'Yalnızca 1 eşleşen tarif',
    );
    return '$_temp0';
  }

  @override
  String get commentsTitle => 'Yorumlar';

  @override
  String get commentHint => 'Yorum yazın…';

  @override
  String get commentSaveFailed => 'Yorum kaydedilemedi.';

  @override
  String get commentDeleteConfirm => 'Bu yorum silinsin mi?';

  @override
  String get cookingDoneCommentLabel => 'Yorum (isteğe bağlı)';

  @override
  String get cookingDoneCommentHint =>
      'Nasıl oldu? Bir dahaki sefere ipuçları…';

  @override
  String get nutritionTitle => 'Besin Değeri';

  @override
  String get nutritionPerServing => 'porsiyon başına';

  @override
  String get nutritionCalories => 'Kalori';

  @override
  String get nutritionFat => 'Yağ';

  @override
  String get nutritionSaturatedFat => 'Doymuş yağ';

  @override
  String get nutritionTransFat => 'Trans yağ';

  @override
  String get nutritionUnsaturatedFat => 'Doymuş yağ';

  @override
  String get nutritionCholesterol => 'Kolesterol';

  @override
  String get nutritionSodium => 'Sodyum';

  @override
  String get nutritionCarbohydrates => 'Karbonhidrat';

  @override
  String get nutritionFiber => 'Lif';

  @override
  String get nutritionSugar => 'Şeker';

  @override
  String get nutritionProtein => 'Protein';

  @override
  String get timelineTitle => 'Zaman çizelgesi';

  @override
  String get timelineMadeThis => 'Bunu yaptım';

  @override
  String timelineUserMadeThis(String name) {
    return '$name bunu yaptı';
  }

  @override
  String get timelineEmpty => 'Zaman çizelgesinde henüz kayıt yok.';

  @override
  String get timelineDate => 'Tarih';

  @override
  String get timelineNoteHint => 'Not (isteğe bağlı)';

  @override
  String get timelineAddPhoto => 'Fotoğraf ekle';

  @override
  String get timelineRemovePhoto => 'Fotoğrafı kaldır';

  @override
  String get timelineSaved => 'Zaman çizelgesine eklendi';

  @override
  String get timelineSaveFailed => 'Zaman çizelgesine eklenemedi';

  @override
  String get timelineImageFailed =>
      'Kayıt kaydedildi, ancak fotoğraf yüklenemedi';

  @override
  String get timelineDeleteConfirm =>
      'Bu kayıt zaman çizelgesinden silinsin mi?';

  @override
  String get timelineEditNote => 'Notu düzenle';

  @override
  String get timelineUnknownRecipe => 'Tarif bulunamadı';

  @override
  String get cookingDonePhotoHint =>
      'Mealie zaman çizelgesi için fotoğraf (isteğe bağlı)';

  @override
  String get assetsTitle => 'Ekler';

  @override
  String get assetsAdd => 'Ek ekle';

  @override
  String get assetsChooseFile => 'Dosya';

  @override
  String get assetsUploading => 'Yükleniyor…';

  @override
  String get assetsUploadFailed => 'Ek yüklenemedi';

  @override
  String assetsDeleteConfirm(String name) {
    return '“$name” eklerden kaldırılsın mı?';
  }

  @override
  String get assetsOpenFailed => 'Ek açılamadı';

  @override
  String get assetsUnsupported =>
      'Mealie yalnızca PDF, görsel, TXT, MD, CSV ve JSON destekler.';

  @override
  String get assetsShare => 'Paylaş';

  @override
  String get mealRulesTitle => 'Mealie kuralları';

  @override
  String get mealRulesHint =>
      'Mealie web uygulaması da kullanır. Gün ve öğün için birden fazla kural geçerliyse hepsi eşleşmelidir. Hiçbir kural geçerli değilse zar tüm tarifler arasından seçer.';

  @override
  String get mealRuleAdd => 'Kural ekle';

  @override
  String get mealRuleNewTitle => 'Yeni kural';

  @override
  String get mealRuleEditTitle => 'Kuralı düzenle';

  @override
  String get mealRuleDay => 'Gün';

  @override
  String get mealRuleAnyDay => 'Herhangi bir gün';

  @override
  String get mealRuleMealType => 'Öğün';

  @override
  String get mealRuleAnyMeal => 'Herhangi bir öğün';

  @override
  String get mealRuleConditionsTitle => 'Koşullar';

  @override
  String get mealRuleAllRecipes => 'Tüm tarifler';

  @override
  String get mealRuleDeleteConfirm => 'Bu kural silinsin mi?';

  @override
  String get mealRulesOffline =>
      'Mealie kuralları şu anda kullanılamıyor – zar uygulamanın seçimini kullanıyor.';

  @override
  String get mealRulesNoMatches =>
      'Bu öğün için Mealie kurallarıyla eşleşen tarif yok.';

  @override
  String get mealTypeSide => 'Taraf';

  @override
  String get mealTypeSnack => 'Atıştırmalık';

  @override
  String get mealTypeDrink => 'İçecek';

  @override
  String get mealTypeDessert => 'Tatlı';

  @override
  String get foodsTitle => 'Yemekler';

  @override
  String get unitsTitle => 'Birimler';

  @override
  String get newFood => 'Yeni yemek';

  @override
  String get newUnit => 'Yeni birim';

  @override
  String get editFood => 'Yemeği düzenle';

  @override
  String get editUnit => 'Birimi düzenle';

  @override
  String get pluralNameLabel => 'Çoğul ad';

  @override
  String get abbreviationLabel => 'Kısaltma';

  @override
  String get pluralAbbreviationLabel => 'Çoğul kısaltma';

  @override
  String get mergeAction => 'Birleştir';

  @override
  String mergeIntoTitle(String name) {
    return '“$name” şununla birleştir…';
  }

  @override
  String mergeConfirm(String from, String to) {
    return '“$from”, “$to” ile birleştirilecek: tüm tarifler ve alışveriş listeleri bundan sonra “$to” kullanacak ve “$from” silinecek.';
  }

  @override
  String get mergeFailed => 'Birleştirme başarısız';

  @override
  String foodUnitDeleteConfirm(String name) {
    return '“$name” silinsin mi? Bunu kullanan malzemeler bağlantıyı kaybeder.';
  }

  @override
  String get foodsUnitsEmpty => 'Henüz kayıt yok.';

  @override
  String mealRuleConditionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count koşul',
      one: '1 koşul',
    );
    return '$_temp0';
  }

  @override
  String get showAll => 'Tümünü göster';

  @override
  String get mealDiceModeTitle => 'Zarın kullandığı';

  @override
  String get mealDiceModeApp => 'Uygulama seçimi';

  @override
  String get switchListTitle => 'Listeyi değiştir';

  @override
  String get newShoppingList => 'Yeni alışveriş listesi';

  @override
  String shoppingListDeleteConfirm(String name) {
    return '“$name” silinsin mi? İçindeki tüm ürünler de silinir.';
  }

  @override
  String get labelOrderTitle => 'Etiketleri sırala';

  @override
  String get labelOrderHint =>
      'Sıralamak için sürükleyin. Bu liste için geçerlidir – Mealie web uygulamasında da.';

  @override
  String get labelOrderEmpty => 'Bu listede henüz etiket yok.';

  @override
  String get useAsActiveList => 'Etkin liste olarak kullan';

  @override
  String get activeListBadge => 'Etkin';

  @override
  String get foodLabelLabel => 'Etiket';

  @override
  String get foodNoLabel => 'Etiket yok';

  @override
  String get aliasesLabel => 'Takma adlar';

  @override
  String get aliasAddHint => 'Takma ad ekle';

  @override
  String get foodOnHand => 'Ev halkında mevcut';

  @override
  String get timelineChildRecipesTitle => 'Bağlı tarifler için de ekle';

  @override
  String timelineMadeForRecipe(String recipe) {
    return '$recipe için yapıldı';
  }

  @override
  String get timelineFilter => 'Kayıtları filtrele';

  @override
  String get timelineTypeComment => 'Yapılanlar ve notlar';

  @override
  String get timelineTypeInfo => 'Bilgi';

  @override
  String get timelineTypeSystem => 'Sistem';

  @override
  String get listManagementTitle => 'Alışveriş listeleri';

  @override
  String get managementTitle => 'Daha fazla';

  @override
  String get pinToHome => 'Ana ekrana ekle';

  @override
  String get unpinFromHome => 'Ana ekrandan kaldır';

  @override
  String homeScreenFull(int count) {
    return 'Ana ekran dolu – en fazla $count kutucuk. Önce “Daha fazla” altında başka bir kutucuğu kaldırın.';
  }

  @override
  String get selectAction => 'Seç';

  @override
  String selectedCount(int count) {
    return '$count seçildi';
  }

  @override
  String get assignLabelAction => 'Etiket ata';

  @override
  String get assignLabelOverwriteHint =>
      'Seçili tüm yemeklerin etiketinin üzerine yazar.';

  @override
  String deleteSelectedConfirm(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kayıt silinsin mi?',
      one: '1 kayıt silinsin mi?',
    );
    return '$_temp0';
  }

  @override
  String get seedDataAction => 'Varsayılan verileri yükle';

  @override
  String get seedFoodsHint =>
      'Mealie\'nin varsayılan yemeklerini seçili dilde oluşturur.';

  @override
  String get seedUnitsHint =>
      'Mealie\'nin varsayılan birimlerini seçili dilde oluşturur.';

  @override
  String get seedLanguageLabel => 'Dil';

  @override
  String get seedDuplicateWarning =>
      'Zaten kayıtlarınız var. Mealie yinelenenleri ayıklamaz – sonradan kendiniz birleştirmeniz gerekir.';

  @override
  String get seedDone => 'Varsayılan veriler oluşturuldu';

  @override
  String get seedFailed => 'Varsayılan veriler yüklenemedi';

  @override
  String get exportAction => 'Dışa Aktar';

  @override
  String get substitutionsLabel => 'Alternatifler';

  @override
  String get substitutionAddHint => 'Alternatif ekle';

  @override
  String get substitutionFoodLabel => 'Yemek (isteğe bağlı)';

  @override
  String get substitutionNoteLabel => 'Not (isteğe bağlı)';

  @override
  String get substitutionNeedOne => 'Bir yemek veya not girin';

  @override
  String get useAbbreviationLabel => 'Kısaltma kullan';

  @override
  String get useAbbreviationHint => 'Tariflerde “gram” yerine “g” göster';

  @override
  String get fractionLabel => 'Kesir olarak göster';

  @override
  String get fractionHint => '0,5 yerine ½';

  @override
  String get standardizationTitle => 'Standartlaştırma';

  @override
  String get standardizationHint =>
      'Dönüşümler için: bu birimin 1\'i … eder (ör. 1 yemek kaşığı = 15 mililitre).';

  @override
  String get standardQuantityLabel => 'Standart miktar';

  @override
  String get standardUnitLabel => 'Standart birim';

  @override
  String get standardUnitNone => 'Yok';

  @override
  String get stdFluidOunce => 'Sıvı ons (fl oz)';

  @override
  String get stdCup => 'Su bardağı (ABD)';

  @override
  String get stdOunce => 'Ons (oz)';

  @override
  String get stdPound => 'Libre (lb)';

  @override
  String get stdMilliliter => 'Mililitre';

  @override
  String get stdLiter => 'Litre';

  @override
  String get stdGram => 'Gram';

  @override
  String get stdKilogram => 'Kilogram';

  @override
  String get labelsTitle => 'Etiketler';

  @override
  String get newLabel => 'Yeni etiket';

  @override
  String get editLabel => 'Etiketi düzenle';

  @override
  String get colorLabel => 'Renk';

  @override
  String labelDeleteConfirm(String name) {
    return '“$name” silinsin mi? Ürünler ve yemekler bu etiketi kaybeder.';
  }

  @override
  String get importMenuAction => 'İçe Aktar';

  @override
  String get archivedEmpty =>
      'Henüz arşivlenmiş alışveriş yok. Alışverişten sonra “Alışverişi tamamla”ya dokunun – işaretli ürünler burada saklanır.';

  @override
  String get sectionTitleLabel => 'Bölüm başlığı';

  @override
  String get clearSection => 'Bölümü kaldır';

  @override
  String get noPermissionGeneric =>
      'Mealie\'de bunun için izniniz yok. Bir yöneticiye veya ev halkı yöneticisine danışın.';

  @override
  String get noPermissionEditRecipe =>
      'Bu tarifi düzenleyemezsiniz – kilitli veya başka bir ev halkına ait. Yalnızca oluşturan kişi veya bir yönetici düzenleyebilir.';

  @override
  String get noPermissionDeleteRecipe =>
      'Tarifi yalnızca oluşturan kişi veya bir yönetici silebilir.';

  @override
  String get noPermissionDemoteSelf =>
      'Kendi yönetici haklarınızı kaldıramazsınız.';

  @override
  String get recipeLockedHint => 'Kilitli – yalnızca oluşturan düzenleyebilir';

  @override
  String get recipeDeleteOwnerOnlyHint =>
      'Yalnızca oluşturan veya bir yönetici silebilir';

  @override
  String get organizeReadOnlyHint =>
      'Yalnızca görüntüleme: oluşturma, değiştirme ve silme için “Kullanıcı yemekleri, etiketleri ve kategorileri yönetebilir” izni gerekir.';

  @override
  String get notesNotSavedNoPermission =>
      'Not kaydedilmedi – bu tarifi düzenleme izniniz yok.';

  @override
  String get userManagementTitle => 'Kullanıcı Yönetimi';

  @override
  String get editUserTitle => 'Kullanıcıyı Düzenle';

  @override
  String get fullNameLabel => 'Ad Soyad';

  @override
  String get usernameLabel => 'Kullanıcı Adı';

  @override
  String get emailLabel => 'E-Posta';

  @override
  String get passwordLabel => 'Şifre';

  @override
  String get householdLabel => 'Ev Halkı';

  @override
  String get permissionsTitle => 'İzinler';

  @override
  String get administratorLabel => 'Yönetici';

  @override
  String get permCanInvite => 'Kullanıcı, başkalarını gruba davet edebilir';

  @override
  String get permCanManage => 'Kullanıcı grup ayarlarını yönetebilir';

  @override
  String get permCanManageHousehold => 'Kullanıcı Hane\'yi düzenleyebilir';

  @override
  String get permCanOrganize =>
      'Kullanıcı yemekleri, etiketleri ve kategorileri yönetebilir';

  @override
  String get advancedFeaturesLabel => 'Gelişmiş özellikleri etkinleştir';

  @override
  String get passwordResetLinkAction => 'Parola Sıfırlama Bağlantısı Oluştur';

  @override
  String get resetLockedUsersAction => 'Kilitli Kullanıcıları Sıfırla';

  @override
  String get inviteLinkTitle => 'Davet Linki';

  @override
  String get inviteAction => 'Davet Et';

  @override
  String get userUpdated => 'Kullanıcı güncellendi';

  @override
  String get createUserTitle => 'Kullanıcı oluştur';

  @override
  String get userCreated => 'Kullanıcı oluşturuldu';

  @override
  String userDeleteConfirm(String name) {
    return '“$name” silinsin mi? Hesap Mealie\'den kaldırılacak.';
  }

  @override
  String get passwordResetLinkCopied =>
      'Bağlantı kopyalandı – kullanıcıya iletin. Yalnızca sınırlı bir süre geçerlidir.';

  @override
  String lockedUsersReset(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kullanıcının kilidi açıldı',
      one: '1 kullanıcının kilidi açıldı',
      zero: 'Kilitli kullanıcı yok',
    );
    return '$_temp0';
  }

  @override
  String get inviteUsesLabel => 'Kullanım sayısı';

  @override
  String get inviteCreated => 'Davet bağlantısı oluşturuldu';

  @override
  String get inviteEmailHint =>
      'E-posta adresi (isteğe bağlı – daveti Mealie gönderir)';

  @override
  String get inviteEmailSent => 'Davet e-postayla gönderildi';

  @override
  String get inviteEmailFailed =>
      'E-posta gönderilemedi (Mealie\'de SMTP kurulu mu?). Bağlantı yine de çalışır.';

  @override
  String get copyLinkAction => 'Bağlantıyı kopyala';

  @override
  String get youLabel => 'Siz';

  @override
  String get membersPermissionsHint =>
      'Ev halkı üyelerinizin izinlerini değiştirebilirsiniz – ama kendinizinkini değil.';

  @override
  String get householdManagementTitle => 'Ev Yönetimi';

  @override
  String get householdsTitle => 'Ev Halkı';

  @override
  String get createHouseholdTitle => 'Hane Halkını Yönet';

  @override
  String get householdNameLabel => 'Hane Adı';

  @override
  String get householdPreferencesTitle => 'Grup Tarif Tercihleri';

  @override
  String get privateHouseholdLabel => 'Hane Halkını Yönet';

  @override
  String get privateHouseholdHint =>
      'Grubunuzu özel olarak ayarlamak, tüm genel görünüm seçeneklerini varsayılan hale getirecektir. Bu, bireysel tariflerin genel görünüm ayarlarını geçersiz kılar';

  @override
  String get lockRecipeEditsLabel =>
      'Diğer hanelerden gelen tarif düzenlemelerini kilitleyin';

  @override
  String get lockRecipeEditsHint =>
      'Etkinleştirildiğinde, yalnızca evinizdeki kullanıcılar eviniz tarafından oluşturulan tarifleri düzenleyebilir';

  @override
  String get householdRecipePreferencesTitle => 'Grup Tarif Tercihleri';

  @override
  String get groupsTitle => 'Gruplar';

  @override
  String get groupLabel => 'Grup';

  @override
  String get createGroupTitle => 'Grup Oluştur';

  @override
  String get groupNameLabel => 'Grup Adı';

  @override
  String get groupPreferencesTitle => 'Grup Tercihleri';

  @override
  String get privateGroupLabel => 'Özel Grup';

  @override
  String get privateGroupHint =>
      'Grubunuzu özel olarak ayarlamak, tüm genel görünüm seçeneklerini varsayılan hale getirecektir. Bu, bireysel tariflerin genel görünüm ayarlarını geçersiz kılar';

  @override
  String get firstDayOfWeekLabel => 'Haftanın ilk günü';

  @override
  String get showAnnouncementsLabel => 'Mealie duyurularını göster';

  @override
  String get recipePublicDefaultLabel =>
      'Grubunuz dışındaki kullanıcıların tariflerinizi görmesini sağlar';

  @override
  String get recipeShowNutritionDefaultLabel => 'Besin değerlerini göster';

  @override
  String get recipeShowAssetsDefaultLabel => 'Tarif malzemelerini göster';

  @override
  String get recipeLandscapeDefaultLabel => 'Yatay görünümü varsayılan yap';

  @override
  String get recipeDisableCommentsDefaultLabel =>
      'Kullanıcıların yorum yapmasını engelle';

  @override
  String get myHouseholdSection => 'Ev halkım';

  @override
  String get myGroupSection => 'Grubum';

  @override
  String get preferencesSaved => 'Ayarlar kaydedildi';

  @override
  String get cannotDeleteWithUsers =>
      'Hâlâ kullanıcıları var – önce Kullanıcı Yönetimi\'nde onları taşıyın veya silin.';

  @override
  String deleteHouseholdConfirm(String name) {
    return '“$name” ev halkı silinsin mi?';
  }

  @override
  String deleteGroupConfirm(String name) {
    return '“$name” grubu silinsin mi?';
  }

  @override
  String usersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kullanıcı',
      one: '1 kullanıcı',
      zero: 'Kullanıcı yok',
    );
    return '$_temp0';
  }

  @override
  String get originalUrlLabel => 'Orijinal URL';

  @override
  String get copyTextAction => 'Metni kopyala';

  @override
  String get copiedToClipboard => 'Panoya kopyalandı';

  @override
  String get changelogEnglishHint =>
      'Sürüm notları yalnızca İngilizce mevcuttur.';

  @override
  String get favoritesTitle => 'Favoriler';

  @override
  String get favoritesEmpty =>
      'Henüz favori yok. Burada toplamak için bir tarifteki kalbe dokunun.';

  @override
  String get changelogTitle => 'Yenilikler';

  @override
  String get changeProfileImage => 'Profil resmini değiştir';

  @override
  String get profileImageUpdated => 'Profil resmi güncellendi';

  @override
  String get profileImageFailed => 'Profil resmi yüklenemedi';

  @override
  String get myAccountTitle => 'Hesabım';

  @override
  String get ownAccountHint =>
      'Burada kendi hesabınızı düzenleyebilirsiniz. Diğer kullanıcıları yöneticiler ve “yönetme” iznine sahip üyeler yönetir.';

  @override
  String get changePasswordAction => 'Şifreyi değiştir';

  @override
  String get currentPasswordLabel => 'Mevcut şifre';

  @override
  String get newPasswordLabel => 'Yeni şifre';

  @override
  String get confirmPasswordLabel => 'Şifreyi onayla';

  @override
  String get passwordTooShort => 'En az 8 karakter';

  @override
  String get passwordsDoNotMatch => 'Şifreler eşleşmiyor';

  @override
  String get passwordUpdated => 'Şifre güncellendi';

  @override
  String get passwordChangeFailed => 'Şifre değiştirilemedi';

  @override
  String passwordManagedExternally(String method) {
    return '$method ile giriş yapıyorsunuz — şifrenizi orada değiştirin.';
  }

  @override
  String get bulkAddHint => 'Her kayıt için bir satır.';

  @override
  String bulkAddCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kayıt ekle',
      one: '1 kayıt ekle',
    );
    return '$_temp0';
  }

  @override
  String get linkRecipeAction => 'Tarif bağla';

  @override
  String get useFoodAction => 'Tarif yerine yemek kullan';

  @override
  String get addSubstitutionsAction => 'Alternatif ekle';

  @override
  String get clearSubstitutionsAction => 'Alternatifleri temizle';

  @override
  String get recipeSubstitutionsTitle => 'Alternatifler';

  @override
  String get substitutionUnknownFood =>
      'Yalnızca mevcut yemekler – aksi halde notu kullanın';

  @override
  String get insertAboveAction => 'Üstüne ekle';

  @override
  String get insertBelowAction => 'Altına ekle';

  @override
  String get moveToTopAction => 'En üste taşı';

  @override
  String get moveToBottomAction => 'En alta taşı';

  @override
  String get linkReferencesAction => 'Referansları bağla';

  @override
  String get editMarkdownAction => 'Markdown\'ı Düzenle';

  @override
  String get previewMarkdownAction => 'Markdown Önizle';

  @override
  String get insertStepImageAction => 'Resim yükleyin';

  @override
  String get mergeAboveAction => 'Üsttekiyle birleştir';

  @override
  String get linkedToOtherStep => 'Başka bir adıma bağlı';

  @override
  String get noNotesToLink => 'Bağlanacak not yok';

  @override
  String get ownerLabel => 'Sahip';

  @override
  String get ingredientParserTitle => 'Malzeme Ayrıştırıcı';

  @override
  String ingredientParserHint(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count malzeme henüz yapılandırılmamış. Bir ayrıştırıcı seçin, sonucu kontrol edin, uygulayın.',
      one:
          '1 malzeme henüz yapılandırılmamış. Bir ayrıştırıcı seçin, sonucu kontrol edin, uygulayın.',
    );
    return '$_temp0';
  }

  @override
  String get parserNlp => 'Doğal Dil İşleme';

  @override
  String get parserBrute => 'Kaba Ayrıştırıcı';

  @override
  String get parserOpenai => 'OpenAI Ayrıştırıcı';

  @override
  String get parserApp => 'Çevrimdışı (uygulama)';

  @override
  String get parseFailed => 'Ayrıştırma başarısız';

  @override
  String get parseAction => 'Ayrıştırma';

  @override
  String applyParsedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count malzemeyi uygula',
      one: '1 malzemeyi uygula',
      zero: 'Hiçbir şey seçilmedi',
    );
    return '$_temp0';
  }

  @override
  String get parsedNewBadge => 'yeni';

  @override
  String get hoursShort => 'sa';

  @override
  String get minutesShort => 'dk';

  @override
  String get timeExtraHint => 'Ek, ör. “artı bir gece”';

  @override
  String get yieldLabel => 'Verim';

  @override
  String get yieldTextLabel => 'Verim Metni';

  @override
  String get prepTimeLabel => 'Hazırlık Süresi';

  @override
  String get performTimeLabel => 'Pişirme Süresi';

  @override
  String get totalTimeLabel => 'Toplam Süre';

  @override
  String get settingPublicRecipe => 'Herkese Açık Tarif';

  @override
  String get settingShowNutrition => 'Besin Değerlerini Göster';

  @override
  String get settingShowAssets => 'Malzemeleri Göster';

  @override
  String get settingLandscapeView => 'Landscape View (Coming Soon)';

  @override
  String get settingDisableComments => 'Yorumları Devre Dışı Bırak';

  @override
  String get settingDisableAmount => 'Malzeme Miktarlarını Devre Dışı Bırak';

  @override
  String get settingLocked => 'Kilitli';

  @override
  String get settingLockedOwnerOnly =>
      'Tarifi yalnızca oluşturan kişi kilitleyebilir veya kilidini açabilir.';

  @override
  String get apiExtrasTitle => 'API Ekstraları';

  @override
  String get apiExtrasHint =>
      'Üçüncü taraf uygulamalar için özel anahtar/değer çiftleri, ör. otomasyonları tetiklemek için.';

  @override
  String get extraKeyLabel => 'Anahtar';

  @override
  String get extraValueLabel => 'Değer';

  @override
  String get addExtraAction => 'Ek alan ekle';

  @override
  String durationHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count saat',
      one: '1 saat',
    );
    return '$_temp0';
  }

  @override
  String durationMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dakika',
      one: '1 dakika',
    );
    return '$_temp0';
  }

  @override
  String get discardChangesConfirm => 'Kaydedilmemiş değişiklikler atılsın mı?';

  @override
  String get discardChanges => 'Değişiklikleri İptal Et';

  @override
  String get imageFromUrl => 'URL\'den görsel';

  @override
  String get deleteRecipeImage => 'Tarif Resmini Sil';

  @override
  String get deleteRecipeImageConfirm =>
      'Bu tarif görselini silmek istediğinizden emin misiniz?';

  @override
  String get bulkAddIngredients => 'Toplu malzeme ekle';

  @override
  String get bulkAddSteps => 'Toplu adım ekle';

  @override
  String get stepImageFailed => 'Görsel yüklenemedi';

  @override
  String get servingsAndTimes => 'Porsiyonlar ve süreler';

  @override
  String get recipeSettingsTitle => 'Tarif Ayarları';

  @override
  String get jsonEditorTitle => 'JSON Editör';

  @override
  String get jsonInvalid => 'Geçersiz JSON – lütfen kontrol edin.';

  @override
  String get editorOfflineHint =>
      'Çevrimdışı açıldı: kaydetmek için bağlantı gerekir. Daha yeni Mealie alanları (ör. alternatifler) değiştirilmeden korunur.';

  @override
  String get parseLineFailed => 'Tanınmadı – değişmeden kalır';

  @override
  String get createManualTitle => 'Tarifi elle oluştur';

  @override
  String get createManualHint =>
      'Bir ad girin – malzemeleri, adımları, görseli ve diğer her şeyi sonra tarif düzenleyicide ekleyin.';

  @override
  String get createManualButton => 'Oluştur ve düzenle';

  @override
  String get changelogEmpty => 'Bu sürüm için henüz kayıt yok.';

  @override
  String get finderDescription =>
      'Elinizdeki malzemelere göre tarif arayın. Ayrıca sahip olduğunuz araçlara göre süzme yapabilir ve eksik malzeme veya araç sayısı için bir üst sınır belirleyebilirsiniz.';

  @override
  String get finderSelectedIngredients => 'Seçilen malzemeler';

  @override
  String get finderNoIngredientsSelected => 'Hiçbir malzeme seçilmedi';

  @override
  String get finderMissing => 'Eksik';

  @override
  String get finderNoRecipesFound => 'Herhangi bir tarif bulunamadı';

  @override
  String get finderNoRecipesFoundDescription =>
      'Aramanıza daha fazla malzeme eklemeyi ya da süzgeçlerinizi ayarlamayı deneyin';

  @override
  String get finderIncludeFoodsOnHand => 'Elindeki Malzemeleri Dahil Et';

  @override
  String get finderIncludeToolsOnHand => 'Elindeki Araç Gereçleri Dahil Et';

  @override
  String get finderIncludeSubstitutions => 'Alternatifleri Dahil Et';

  @override
  String get finderSubstituting => 'Yerine kullanılan';

  @override
  String finderSubstituteForFood(String substitute, String food) {
    return '$food yerine $substitute';
  }

  @override
  String get finderMaxMissingIngredients => 'Maksimum Eksik Malzeme Sayısı';

  @override
  String get finderMaxMissingTools => 'Maksimum Eksik Araç Sayısı';

  @override
  String get finderSelectedTools => 'Seçilen Araçlar';

  @override
  String get finderReadyToMake => 'Yapmaya Hazır';

  @override
  String get finderAlmostReadyToMake => 'Yapmaya Neredeyse Hazır';

  @override
  String get finderSettings => 'Ayarlar';

  @override
  String get finderLoadingRecipes => 'Tarifler Yükleniyor';

  @override
  String get finderClearSelection => 'Seçimi Temizle';

  @override
  String get finderOfflineHint =>
      'Sunucuya bağlantı yok – sonuçlar bu cihazda kayıtlı tariflerden geliyor.';

  @override
  String get sendPeerOfflineHint =>
      'Şu anda ulaşılamıyor – uygulama orada açıldığında ulaşır';

  @override
  String sendDeliveredLater(String device) {
    return '“$device” şu anda ulaşılamıyor. Tarif, uygulama orada açılır açılmaz ulaşacak.';
  }

  @override
  String get sendQueuedOffline =>
      'Şu anda bağlantı yok. Tarif, tekrar çevrimiçi olduğunuzda otomatik gönderilecek.';

  @override
  String get searchHasAll => 'Hepsi var';

  @override
  String get searchHasAny => 'Herhangi biri var';

  @override
  String get recipeFilterTitle => 'Süzgeç';

  @override
  String get finderOtherFilters => 'Diğer süzgeçler';

  @override
  String get qfOpEquals => 'eşittir';

  @override
  String get qfOpNotEquals => 'eşit değildir';

  @override
  String get qfOpGreater => 'daha büyük';

  @override
  String get qfOpGreaterEq => 'daha büyük veya eşit';

  @override
  String get qfOpLess => 'daha mı az';

  @override
  String get qfOpLessEq => 'daha az veya eşit mi';

  @override
  String get qfOpNewerThan => 'şundan yeni';

  @override
  String get qfOpOlderThan => 'şundan eski';

  @override
  String qfDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gün önce',
      one: '1 gün önce',
    );
    return '$_temp0';
  }

  @override
  String get filterResetAll => 'Tüm filtreleri sıfırla';

  @override
  String get filterAny => 'Herhangi';

  @override
  String get filterOfflineIgnored =>
      'Çevrimdışıyken “Diğer Filtreler” yalnızca basit biçimde uygulanabilir.';

  @override
  String linkedRecipesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bağlı tarif',
      one: 'Bir bağlı tarif',
      zero: 'Bağlı tarif yok',
    );
    return '$_temp0';
  }

  @override
  String get shoppingReminderNotificationsOff =>
      'Mealie Recipes için bildirimler kapalı — bunlar olmadan alışveriş hatırlatıcısı görünemez. Lütfen ayarlardan bildirimlere izin verin.';

  @override
  String get shoppingReminderInactiveHint =>
      'Alışveriş hatırlatıcısı şu anda çalışamıyor: lütfen konum erişimini “Her zaman” yapın ve bildirimlere izin verin.';

  @override
  String get bulkImportTitle => 'Toplu URL İçe Aktarma';

  @override
  String get bulkImportDescription =>
      'Toplu tarif içe aktarıcı, arka uçtaki siteleri sıraya koyarak ve görevi arka planda çalıştırarak aynı anda birden fazla tarifi içe aktarmanıza olanak tanır. Bu, başlangıçta Mealie\'ye geçiş yaparken veya çok sayıda tarifi içe aktarmak istediğinizde yararlı olabilir.';

  @override
  String get bulkAddTitle => 'Toplu Ekle';

  @override
  String get bulkImportSetOrganizers => 'Kategorileri ve Etiketleri Belirleyin';

  @override
  String get bulkImportStarted => 'Toplu İçe Aktarma işlemi başladı';

  @override
  String get bulkImportFailed => 'Toplu içe aktarma işlemi başarısız oldu';

  @override
  String get bulkImportReports => 'Toplu İçe Aktarmalar';

  @override
  String get bulkImportUrlHint => 'Tarif Bağlantısı';

  @override
  String get migrationsTitle => 'Veri Taşımaları';

  @override
  String get migrationsDescription =>
      'Tarifler, desteklenen başka bir uygulamadan Mealie\'ye taşınabilir. Bu, Mealie\'ye başlamanın harika bir yoludur. Mealie örnekleri arasında veri taşımak veya önceki bir Mealie yedeğini geri yüklemek ise yedekleme ve geri yükleme araçlarıyla yapılır.';

  @override
  String get migrationNew => 'Yeni Yer Değiştirme';

  @override
  String get migrationChooseType => 'Taşıma Türünü Seçin';

  @override
  String get noFileSelected => 'Dosya seçilmedi';

  @override
  String migrationTagAll(String tag) {
    return 'Tüm tarifleri $tag etiketiyle etiketle';
  }

  @override
  String get migrationPrevious => 'Önceki Yer Değiştirme';

  @override
  String get migrationMealieDescription =>
      'Mealie, v1.0 öncesi bir Mealie sürümünden tarifleri içe aktarabilir. Tariflerinizi eski örneğinizden dışa aktarın ve zip dosyasını aşağıya yükleyin. Dışa aktarılan dosyadan yalnızca tariflerin içe aktarılabileceğini unutmayın. Bu yalnızca v1.0\'dan eski örnekler için geçerlidir. v1.0 veya sonrasında alınmış bir yedek, yedekleme ve geri yükleme araçlarıyla geri yüklenmelidir.';

  @override
  String get migrationChowdownDescription =>
      'Mealie yerel olarak chowdown veri havuzu biçimini destekler. Kod havuzunu bir .zip dosyası olarak indirin ve aşağıya yükleyin.';

  @override
  String get migrationCopyMeThatDescription =>
      'Mealie, Copy Me That\'den tarifleri içe aktarabilir. Tariflerinizi HTML biçiminde dışa aktarın, ardından aşağıdaki .zip dosyasını yükleyin.';

  @override
  String get migrationMyRecipeBoxDescription =>
      'Mealie Tarife Kutum\'dan tarifleri içe aktarabilir. Tariflerinizi CSV formatında dışa aktarın, ardından .csv dosyasını aşağıya yükleyin.';

  @override
  String get migrationNextcloudDescription =>
      'Nextcloud tarifleri, Nextcloud\'da saklanan verileri içeren bir zip dosyasından içe aktarılabilir. Tariflerinizin içe aktarılabilmesini sağlamak için aşağıdaki örnek klasör yapısına bakın.';

  @override
  String get migrationPaprikaDescription =>
      'Mealie, Paprika uygulamasından tarifleri içe aktarabilir. Tariflerinizi paprika\'dan dışa aktarın, dışa aktarma uzantısını .zip olarak yeniden adlandırın ve aşağıda yükleyin.';

  @override
  String get migrationPlanToEatDescription =>
      'Mealie, Plan to Eat\'ten tarifleri içe aktarabilir.';

  @override
  String get migrationRecipeKeeperDescription =>
      'Mealie tarifleri Recipe Keeper\'dan içe aktarabilir. Tariflerinizi zip formatında dışa aktarın, daha sonra .zip dosyasını aşağıdan yükleyin.';

  @override
  String get migrationTandoorDescription =>
      'Mealie, Tandoor\'dan tarifleri içe aktarabilir. Verilerinizi \"Varsayılan\" biçimde dışa aktarın, ardından aşağıdaki .zip dosyasını yükleyin.';

  @override
  String get migrationCooknDescription =>
      'Mealie, DVO Cook\'n X3\'ten tarifleri içe aktarabilir. Bir yemek kitabını veya menüyü \"Cook\'n\" biçiminde dışa aktarın, dışa aktarılan dosyanın uzantısını .zip olarak değiştirin, ardından .zip dosyasını aşağıya yükleyin.';

  @override
  String get reportTitle => 'Rapor Et';

  @override
  String get recipeDataTitle => 'Tarif Verisi';

  @override
  String get recipeDataDescription =>
      'Tariflerinizle ilişkili verileri yönetmek için bu bölümü kullanın. Tariflerinizde dışa aktarma, silme, etiketleme ve kategori atama dahil çeşitli toplu işlemler gerçekleştirebilirsiniz.';

  @override
  String get recipeDataTagTitle => 'Tarifleri Etiketle';

  @override
  String get recipeDataCategorizeTitle => 'Tarifleri Kategorize Et';

  @override
  String get recipeDataSettingsTitle => 'Ayarları Güncelle';

  @override
  String get recipeDataExportTitle => 'Tarifleri Dışa Aktar';

  @override
  String get recipeDataDeleteTitle => 'Tarifleri Sil';

  @override
  String recipeDataExportConfirm(int count) {
    return 'Şu tarifler ($count) dışa aktarılacak.';
  }

  @override
  String get recipeDataExportsTitle => 'Veri Dışa Aktarımları';

  @override
  String get recipeDataExportsDescription =>
      'Bu bölümde indirilmeye hazır mevcut dışa aktarmalara bağlantılar sağlanır. Bu dışa aktarmaların süresi dolacağından, bunları hala kullanılabilir durumdayken aldığınızdan emin olun.';

  @override
  String get recipeDataPurgeExports => 'Dışa Aktarılanları Temizle';

  @override
  String get recipeDataPurgeConfirm =>
      'Tüm dışa aktarılan verilerinizi silmek istediğinizden emin misiniz?';

  @override
  String get recipeActionsTitle => 'Tarif İşlemleri';

  @override
  String get recipeActionNew => 'Yeni Tarif İşlemi';

  @override
  String get recipeActionEdit => 'Tarif İşlemini Düzenle';

  @override
  String get recipeActionTypeLink => 'Bağlantı';

  @override
  String get recipeActionTypePost => 'Gönder';

  @override
  String get webhooksTitle => 'Webhooklar';

  @override
  String get webhooksDescription =>
      'Aşağıda tanımlanan web kancaları, gün için bir yemek tanımlandığında yürütülecektir. Planlanan zamanda webhooklar, o gün için planlanan tarifteki verilerle birlikte gönderilecektir. Webhook yürütmesinin kesin olmadığını unutmayın. Webhooklar 5 dakikalık aralıklarla yürütülür, böylece webhooklar planlanandan 5 +/- dakika sonra yürütülür.';

  @override
  String get webhookName => 'Webhook Adı';

  @override
  String get webhookUrl => 'Webhook URL\'si';

  @override
  String get notifiersTitle => 'Bildirimciler';

  @override
  String get notifiersDescription =>
      'Belirli etkinliklerde tetiklenen e-posta ve anlık bildirimleri ayarlayın.';

  @override
  String get notifierNew => 'Yeni bildirim';

  @override
  String get notifierDescription =>
      'Mealie bildirimleri oluşturmak için Apprise kütüphanesini kullanır. Apprise bildirimlerde kullanmak için pek çok seçenek sunar. Servisiniz için URL oluşturmak için onların wiki sayfasına göz atın. Eğer mümkünse, bilidiriminizin tipini seçmek size bazı ek özellikler sunabilir.';

  @override
  String get notifierAppriseUrl => 'Url\'yi bildir';

  @override
  String get notifierAppriseUrlSkipped => 'Apprise URL\'si (boşsa geçilir)';

  @override
  String get notifierAppriseUrlBlankHint =>
      'Apprise URL\'leri genellikle hassas bilgiler içerdiğinden, bu alan düzenleme sırasında kasıtlı olarak boş bırakılır. URL\'yi güncellemek isterseniz, lütfen yeni URL\'yi buraya girin, aksi takdirde mevcut URL\'yi korumak için boş bırakın.';

  @override
  String get notifierEnable => 'Bildiriciyi Etkinleştir';

  @override
  String get notifierWhatEvents =>
      'Bu bildirimci hangi olaylara abone olmalıdır?';

  @override
  String get notifierRecipeEvents => 'Tarif Etkinlikleri';

  @override
  String get notifierUserEvents => 'Kullanıcı Etkinlikleri';

  @override
  String get notifierMealplanEvents => 'Yemek Planı Etkinlikleri';

  @override
  String get notifierShoppingListEvents => 'Alışveriş Listesi Etkinlikleri';

  @override
  String get notifierCookbookEvents => 'Tarif Kitabı Etkinlikleri';

  @override
  String get notifierTagEvents => 'Etiket Etkinlikleri';

  @override
  String get notifierCategoryEvents => 'Kategori Etkinlikleri';

  @override
  String get notifierLabelEvents => 'Etiket Etkinlikleri';

  @override
  String get notifierUserSignup => 'Grubunuza yeni bir kullanıcı katıldığında';

  @override
  String get notifierCreate => 'Oluştur';

  @override
  String get notifierUpdate => 'Güncelle';

  @override
  String get notifierDelete => 'Sil';

  @override
  String get notifierTestSent => 'Test Mesajı Gönderildi';

  @override
  String get adminTitle => 'Yönetici Ayarları';

  @override
  String get backupsTitle => 'Yedeklemeler';

  @override
  String get backupsDescription =>
      'Yedeklemeler, sitenin veritabanının ve veri dizininin toplam anlık görüntüleridir. Bu, tüm verileri içerir ve verilerin alt kümelerini hariç tutacak şekilde ayarlanamaz. Bunu Mealie\'nin belirli bir andaki anlık görüntüsü olarak düşünebilirsiniz. Bunlar, verileri dışa ve içe aktarmanın veya siteyi harici bir konuma yedeklemenin veritabanından bağımsız bir yolu olarak hizmet eder.';

  @override
  String get backupCreateHeading => 'Create a Backup';

  @override
  String get backupCreated => 'Yedekleme başarıyla oluşturuldu';

  @override
  String get backupCreateFailed =>
      'Yedek Oluşturma Hatası. Günlük Dosyasına Bakın';

  @override
  String get backupDelete => 'Yedeği Sil';

  @override
  String get backupDeleted => 'Yedekleme silindi';

  @override
  String get backupRestore => 'Yedeği Geri Yükle';

  @override
  String get backupRestoreDescription =>
      'Bu yedeği geri yüklemek, veritabanınızdaki ve veri dizinindeki tüm mevcut verilerin üzerine bu yedeğin içeriğini yazar. Geri yükleme başarılı olursa oturumunuz kapatılır.';

  @override
  String get backupCannotBeUndone =>
      'Bu işlem geri alınamaz - dikkatli kullanın.';

  @override
  String get backupAcknowledge =>
      'Bu işlemin geri döndürülemez, yıkıcı ve veri kaybına neden olabileceğini anlıyorum';

  @override
  String get backupRestoreSuccess => 'Geri yükleme başarılı';

  @override
  String get backupRestoreFailed =>
      'Geri yükleme başarısız oldu. Daha fazla detay için sunucu kayıtlarınızı kontrol edin';

  @override
  String get maintenanceTitle => 'Bakım';

  @override
  String get maintenanceSummary => 'Özet';

  @override
  String get maintenanceStorage => 'Depolama Ayrıntıları';

  @override
  String get maintenanceDataDirSize => 'Veri Dizini Boyutu';

  @override
  String get maintenanceCleanableDirs => 'Temizlenebilir Dizinler';

  @override
  String get maintenanceCleanableImages => 'Temizlenebilir Görüntüler';

  @override
  String get maintenanceTempDir => 'Geçici Dizin (.temp)';

  @override
  String get maintenanceBackupsDir => 'Yedekler Dizini (backups)';

  @override
  String get maintenanceGroupsDir => 'Gruplar Dizini (groups)';

  @override
  String get maintenanceRecipesDir => 'Tarifler Dizini (recipes)';

  @override
  String get maintenanceUserDir => 'Kullanıcı Dizini (user)';

  @override
  String get maintenanceCleanDirs => 'Dizinleri Temizle';

  @override
  String get maintenanceCleanDirsDescription =>
      'Geçerli UUID\'ler olmayan tüm tarif klasörlerini kaldırır';

  @override
  String get maintenanceCleanTemp => 'Geçici Dizinleri Temizle';

  @override
  String get maintenanceCleanTempDescription =>
      '.temp dizinindeki tüm dosya ve klasörleri kaldırır';

  @override
  String get maintenanceCleanImages => 'Görüntüleri Temizle';

  @override
  String get maintenanceCleanImagesDescription =>
      '.webp ile bitmeyen tüm resimleri kaldırır';

  @override
  String get maintenanceActions => 'Eylemler';

  @override
  String get adminConfiguration => 'Yapılandırma';

  @override
  String get adminAppVersion => 'Uygulama Sürümü';

  @override
  String get adminUpToDate => 'Mealie güncel';

  @override
  String adminVersionOutdated(String current, String latest) {
    return 'Mevcut sürümünüz ($current) son sürümle eşleşmiyor. Son sürüme ($latest) güncellemeyi düşünün.';
  }

  @override
  String get adminBaseUrl => 'Sunucu Tarafı Temel URL\'si';

  @override
  String get adminBaseUrlOk => 'Sunucu Tarafı URL\'si varsayılanla eşleşmiyor';

  @override
  String get adminBaseUrlError =>
      '\"BASE_URL\", API Sunucusunda hala varsayılan değerdir. Bu, e-postalar vb. için sunucuda oluşturulan bildirim bağlantılarında sorunlara neden olacaktır.';

  @override
  String adminAuthReady(String provider) {
    return '$provider Hazır';
  }

  @override
  String adminAuthNotReady(String provider) {
    return '$provider Hazır Değil';
  }

  @override
  String adminAuthDisabled(String provider) {
    return '$provider Devre Dışı';
  }

  @override
  String adminAuthSuccessText(String provider) {
    return 'Gerekli tüm $provider değişkenleri ayarlanmış.';
  }

  @override
  String adminAuthErrorText(String provider) {
    return 'Tüm $provider değerleri yapılandırılmamış. $provider Kimlik Doğrulaması kullanmıyorsanız bu göz ardı edilebilir.';
  }

  @override
  String adminAuthDisabledText(String envVar) {
    return 'Etkinleştirmek için $envVar değerini true olarak ayarlayın.';
  }

  @override
  String get adminEmailStatus => 'E-posta Yapılandırma Durumu';

  @override
  String get adminEmailConfigured => 'E-posta Yapılandırıldı';

  @override
  String get adminNotReady =>
      'Hazır Değil - Çevresel Değişkenleri Kontrol Edin';

  @override
  String get adminSucceeded => 'Başarılı';

  @override
  String get adminFailed => 'Başarısız';

  @override
  String get adminSiteStatistics => 'Site İstatistikleri';

  @override
  String get adminUncategorized => 'Kategorisiz Tarifler';

  @override
  String get adminUntagged => 'Etiketsiz Tarifler';

  @override
  String get adminGeneralAbout => 'Genel Hakkında';

  @override
  String get adminVersion => 'Sürüm';

  @override
  String get adminBuild => 'Yapı';

  @override
  String get adminApplicationMode => 'Uygulama Modu';

  @override
  String get adminProduction => 'Üretim';

  @override
  String get adminDevelopment => 'Geliştirme';

  @override
  String get adminDemoStatus => 'Demo Durumu';

  @override
  String get adminDemo => 'Demo';

  @override
  String get adminNotDemo => 'Demo Değil';

  @override
  String get adminApiPort => 'API Portu';

  @override
  String get adminApiDocs => 'API Dokümantasyonu';

  @override
  String get adminDatabaseType => 'Veritabanı Türü';

  @override
  String get adminDatabaseUrl => 'Veritabanı Sunucu URL\'si';

  @override
  String get adminDefaultGroup => 'Varsayılan Grup';

  @override
  String get adminDefaultHousehold => 'Varsayılan Hane';

  @override
  String get adminScraperVersion => 'Tarif Kazıyıcı Sürümü';

  @override
  String get adminStatUsers => 'Kullanıcılar';

  @override
  String get adminStatHouseholds => 'Ev Halkı';

  @override
  String get adminStatGroups => 'Gruplar';

  @override
  String get recipeDuplicate => 'Tarifi yinele';

  @override
  String get recipeDuplicateAction => 'Çiftle';

  @override
  String get recipeShareLink => 'Tarifi Paylaş';

  @override
  String get recipeShareExpiration => 'Son Kullanma Tarihi';

  @override
  String get recipeShareCopied => 'Tarif bağlantısı panoya kopyalandı';

  @override
  String get enabledLabel => 'Etkin';

  @override
  String get disabledLabel => 'Devre Dışı';

  @override
  String get testAction => 'Dene';

  @override
  String get yesLabel => 'Evet';

  @override
  String get noLabel => 'Hayır';

  @override
  String get downloadAction => 'İndir';

  @override
  String get backupUpload => 'Yükle';

  @override
  String get zipImportButton => 'Zip\'ten içeri aktar';

  @override
  String get zipImportDescription =>
      'Başka bir Mealie örneğinden dışa aktarılmış tek bir tarifi içe aktarın.';

  @override
  String get reportStatus => 'Durum';

  @override
  String get reportDate => 'Tarih';

  @override
  String get recipeActionTitleLabel => 'Başlık';

  @override
  String get clearAll => 'Temizle';

  @override
  String get recipeDataSettingsExplanation =>
      'Burada seçilen ayarlar, kilitli seçenek hariç, seçilen tüm tariflere uygulanacaktır.';

  @override
  String get adminAllowSignup => 'Kayda izin ver';

  @override
  String get adminAllowPasswordLogin => 'Şifreyle girişe izin ver';

  @override
  String get adminEmailInvalid => 'Lütfen geçerli bir e-posta adresi girin.';

  @override
  String adminEmailTestResult(String result) {
    return 'E-posta testi: $result';
  }

  @override
  String get adminSendTestEmail => 'Test e-postası gönder';

  @override
  String get adminTestEmailAddress => 'Alıcı';

  @override
  String get backupCreate => 'Yedek oluştur';

  @override
  String backupDeleteConfirm(String name) {
    return '“$name” yedeği silinsin mi?';
  }

  @override
  String get backupPostgresNote =>
      'PostgreSQL kullanıyorsanız, geri yüklemeden önce Mealie belgelerindeki yedekleme/geri yükleme sürecini okuyun.';

  @override
  String get backupUploaded => 'Yedek yüklendi';

  @override
  String get backupsEmpty => 'Henüz yedek yok.';

  @override
  String get bulkImportAddRow => 'URL ekle';

  @override
  String get bulkImportStart => 'İçe aktarmayı başlat';

  @override
  String get chooseFileButton => 'Dosya seç';

  @override
  String get deselectAllAction => 'Tüm seçimleri kaldır';

  @override
  String get downloadFailed => 'İndirme başarısız';

  @override
  String get fileSaved => 'Dosya kaydedildi';

  @override
  String get loadFailed => 'Yüklenemedi';

  @override
  String get maintenanceActionsWarning =>
      'Bakım işlemleri yıkıcıdır ve dikkatle kullanılmalıdır. Bu işlemlerden herhangi biri geri alınamaz.';

  @override
  String get maintenanceConfirm =>
      'Bu işlem yıkıcıdır ve geri alınamaz. Devam edilsin mi?';

  @override
  String get maintenanceDone => 'Tamamlandı';

  @override
  String get maintenanceFailed => 'Bakım işlemi başarısız';

  @override
  String get maintenanceRun => 'Çalıştır';

  @override
  String get migrationFailed => 'Taşıma başarısız';

  @override
  String get migrationStart => 'Taşımayı başlat';

  @override
  String get migrationStarted => 'Taşıma tamamlandı — aşağıdaki rapora bakın.';

  @override
  String get moreImportOptions => 'Diğer içe aktarma seçenekleri';

  @override
  String notifierDeleteConfirm(String name) {
    return '“$name” bildiricisi silinsin mi?';
  }

  @override
  String get notifierEdit => 'Bildiriciyi düzenle';

  @override
  String notifierEventCount(int count) {
    return 'Olaylar: $count';
  }

  @override
  String get notifierTestFailed => 'Test mesajı gönderilemedi';

  @override
  String get notifiersEmpty => 'Henüz bildirici yok.';

  @override
  String recipeActionDeleteConfirm(String name) {
    return '“$name” tarif eylemi silinsin mi?';
  }

  @override
  String get recipeActionFailed => 'Tarif eylemi başarısız';

  @override
  String get recipeActionSent => 'Tarif gönderildi';

  @override
  String get recipeActionUrlHint => 'Yer tutucular';

  @override
  String get recipeActionsDescription =>
      'Tarif eylemleri her tarifin menüsünde görünür. “Bağlantı” URL\'yi açar, “Post” tarifi Mealie sunucusunun URL\'ye göndermesini sağlar.';

  @override
  String get recipeActionsEmpty => 'Henüz tarif eylemi yok.';

  @override
  String recipeDataDeleteConfirm(int count) {
    return 'Seçili tarifler ($count) silinsin mi? Bu işlem geri alınamaz.';
  }

  @override
  String recipeDataDeleteForbidden(int count) {
    return 'Seçili tariflerden $count tanesini silemezsiniz (yalnızca oluşturan kişi veya bir yönetici silebilir).';
  }

  @override
  String recipeDataDeleted(int count) {
    return 'Silinen tarifler: $count';
  }

  @override
  String get recipeDataExportAction => 'Dışa Aktar';

  @override
  String get recipeDataExportDone =>
      'Dışa aktarma oluşturuldu — Veri Dışa Aktarımları altından indirin.';

  @override
  String recipeDataExportExpires(String date) {
    return '$date tarihinde sona erer';
  }

  @override
  String get recipeDataExportFailed => 'Dışa aktarma başarısız';

  @override
  String get recipeDataExportsEmpty => 'Kullanılabilir dışa aktarma yok.';

  @override
  String recipeDataUpdated(int count) {
    return 'Güncellenen tarifler: $count';
  }

  @override
  String get recipeDuplicated => 'Tarif çoğaltıldı';

  @override
  String get recipeExportJson => 'JSON olarak dışa aktar';

  @override
  String get recipeExportZip => 'ZIP olarak dışa aktar (görselle)';

  @override
  String get recipeShareCreate => 'Bağlantı oluştur';

  @override
  String get recipeShareDescription =>
      'Bağlantıya sahip herkes bu tarifi tarayıcıda — hesap olmadan — süresi dolana kadar görüntüleyebilir.';

  @override
  String get recipeShareEmpty => 'Henüz paylaşım bağlantısı yok.';

  @override
  String recipeShareExpiresAt(String date) {
    return '$date tarihinde sona erer';
  }

  @override
  String get recipeWebToolsMenu =>
      'Çoğalt, paylaşım bağlantısı ve daha fazlası';

  @override
  String get reload => 'Yeniden yükle';

  @override
  String get reportDeleteConfirm => 'Bu rapor silinsin mi?';

  @override
  String get reportEntries => 'Kayıtlar';

  @override
  String get reportFailedEntries => 'Başarısız';

  @override
  String get reportOnlyFailed => 'Yalnızca başarısız kayıtları göster';

  @override
  String get reportStatusFailure => 'Başarısız';

  @override
  String get reportStatusInProgress => 'Devam ediyor';

  @override
  String get reportStatusPartial => 'Kısmi';

  @override
  String get reportStatusSuccess => 'Başarılı';

  @override
  String get reportsEmpty => 'Henüz rapor yok.';

  @override
  String get uploadFailed => 'Yükleme başarısız';

  @override
  String webhookDeleteConfirm(String name) {
    return '“$name” webhook\'u silinsin mi?';
  }

  @override
  String get webhookEdit => 'Webhook\'u düzenle';

  @override
  String get webhookNew => 'Yeni webhook';

  @override
  String get webhookTestFailed => 'Test başlatılamadı';

  @override
  String get webhookTestSent => 'Test webhook\'u tetiklendi';

  @override
  String get webhookTime => 'Saat (yerel)';

  @override
  String get webhooksEmpty => 'Henüz webhook yok.';

  @override
  String get zipImportFailed => 'ZIP içe aktarma başarısız';

  @override
  String get aiProvidersTitle => 'YZ Sağlayıcıları';

  @override
  String get aiProvidersDescription =>
      'Gelişmiş malzeme ayrıştırma, videolardan tarif oluşturma ve daha fazlası gibi YZ destekli özellikleri etkinleştirmek için YZ sağlayıcılarını yapılandırın!';

  @override
  String get aiProviderSettingsTitle => 'YZ Sağlayıcı Ayarları';

  @override
  String get aiProvidersList => 'Sağlayıcılar';

  @override
  String get aiProviderCreate => 'Sağlayıcı Oluştur';

  @override
  String get aiProviderEdit => 'Sağlayıcıyı Düzenle';

  @override
  String get aiDefaultProvider => 'Varsayılan Sağlayıcı';

  @override
  String get aiDefaultProviderDescription =>
      'YZ özelliklerini etkinleştirmek için gereklidir';

  @override
  String get aiAudioProvider => 'Ses Sağlayıcısı';

  @override
  String get aiAudioProviderDescription =>
      'Videolardan tarif oluşturma gibi ses yazıya dökme özelliklerini etkinleştirir';

  @override
  String get aiImageProvider => 'Resim Sağlayıcısı';

  @override
  String get aiImageProviderDescription =>
      'Görsellerden tarif oluşturma gibi görüntü tanıma özelliklerini etkinleştirir';

  @override
  String get aiProviderName => 'Sağlayıcı Adı';

  @override
  String get aiApiKey => 'API Anahtarı';

  @override
  String get aiApiKeyCreateDescription =>
      'Kimlik doğrulama için sağlayıcınızın API anahtarı. Hizmetiniz (ör. Ollama) API anahtarı kullanmıyorsa bile buraya bir şey yazmanız gerekir.';

  @override
  String get aiApiKeyEditDescription =>
      'Değiştirmek istemiyorsanız bunu boş bırakın.';

  @override
  String get aiBaseUrl => 'Temel URL';

  @override
  String get aiBaseUrlDescription =>
      'OpenAI kullanıyorsanız bunu boş bırakın. OpenAI uyumlu bir uç nokta olmalıdır (ör. \"http://localhost:11434/v1\").';

  @override
  String get aiModel => 'Model';

  @override
  String get aiModelDescription =>
      'YZ sağlayıcınızın hangi modeli kullanacağı (ör. \"gpt-5\").';

  @override
  String get aiTimeout => 'İstek Zaman Aşımı (Saniye)';

  @override
  String get aiProviderCreated => 'Sağlayıcı oluşturuldu';

  @override
  String get aiProviderUpdated => 'Sağlayıcı güncellendi';

  @override
  String get aiProviderDeleted => 'Sağlayıcı silindi';

  @override
  String get aiProviderCreateFailed => 'Sağlayıcı oluşturulamadı';

  @override
  String get aiProviderUpdateFailed => 'Sağlayıcı güncellenemedi';

  @override
  String get aiProviderDeleteFailed => 'Sağlayıcı silinemedi';

  @override
  String get aiRequestHeaders => 'İstek Başlıkları';

  @override
  String get aiRequestParams => 'İstek Parametreleri';

  @override
  String get aiNoDefaultWarning =>
      'Varsayılan bir sağlayıcı belirlemediğiniz için YZ özellikleri devre dışı';

  @override
  String get aiTestConnection => 'Bağlantıyı Test Et';

  @override
  String get aiTestSucceeded => 'Bağlantı başarılı';

  @override
  String get aiTestFailed => 'Bağlantı başarısız';

  @override
  String get aiSupportsImages => 'Görselleri destekler';

  @override
  String get aiTextOnly => 'Yalnızca metin, görsel sağlayıcınız olamaz';

  @override
  String get debugAiTitle => 'YZ Sağlayıcılarında Hata Ayıkla';

  @override
  String get debugAiDescription =>
      'YZ sağlayıcılarında hata ayıklamak için bu sayfayı kullanın. YZ bağlantınızı test edip sonuçları burada görebilirsiniz. Görsel hizmetleri etkinse bir görsel de sağlayabilirsiniz.';

  @override
  String get debugParserTitle => 'Ayrıştırıcı';

  @override
  String get debugParserDescription =>
      'Mealie, bileşenleri ayrıştırmak ve işlemek için Koşullu Rastgele Alanlar (CRF\'ler) kullanır. İçerikler için kullanılan model, New York Times tarafından derlenen bir veri setinden 100.000\'den fazla içerikten oluşan bir veri setine dayanmaktadır. Model yalnızca İngilizce olarak oluşturulduğundan, modeli diğer dillerde kullanırken farklı sonuçlar elde edebileceğinizi unutmayın. Bu sayfa, modeli test etmek için bir oyun alanıdır.';

  @override
  String get debugIngredientText => 'İçerik Metni';

  @override
  String get debugTryExample => 'Bir örnek deneyin';

  @override
  String debugAverageConfidence(String value) {
    return '$value güven';
  }

  @override
  String get debugRunTest => 'Testi Çalıştır';

  @override
  String get debugQuantity => 'Miktar';

  @override
  String get debugUnit => 'Birim';

  @override
  String get debugFood => 'Gıda';

  @override
  String get debugNote => 'Yorum';

  @override
  String get debugGroup => 'Grup';

  @override
  String get aiProviderNone => 'Yok';

  @override
  String aiProviderDeleteConfirm(String name) {
    return '“$name” sağlayıcısı silinsin mi?';
  }

  @override
  String get aiProvidersEmpty => 'Henüz yapay zekâ sağlayıcısı yok.';

  @override
  String get aiAdvanced => 'Gelişmiş';

  @override
  String get aiKeyLabel => 'İsim';

  @override
  String get aiValueLabel => 'Değer';

  @override
  String get debugTitle => 'Hata ayıklama';

  @override
  String get debugParse => 'Ayrıştırma';

  @override
  String get debugParseFailed => 'Malzeme ayrıştırılamadı';

  @override
  String get debugChooseImage => 'Görsel seç';

  @override
  String get debugNoImage => 'Görsel yok (isteğe bağlı)';

  @override
  String get updateTitle => 'Güncellemeleri denetle';

  @override
  String get updateInstalledVersion => 'Yüklü sürüm';

  @override
  String get updateLastCheck => 'Son denetim';

  @override
  String get updateCheckNow => 'Şimdi denetle';

  @override
  String get updateChecking => 'Güncellemeler denetleniyor…';

  @override
  String get updateUpToDate => 'Mealie Recipes güncel.';

  @override
  String updateAvailable(String version) {
    return '$version sürümü mevcut';
  }

  @override
  String get updateAvailableDescription =>
      'Mealie Recipes\'in yeni bir sürümü mevcut. Güncellemeyi siz başlatana kadar hiçbir şey yüklenmez.';

  @override
  String get updateShow => 'Güncellemeyi göster';

  @override
  String get updateLater => 'Daha sonra';

  @override
  String updateDownloading(int percent) {
    return 'İndiriliyor … %$percent';
  }

  @override
  String updateReady(String version) {
    return '$version sürümü yüklenmeye hazır';
  }

  @override
  String get updateInstalling =>
      'Yükleniyor — uygulama otomatik olarak yeniden başlar …';

  @override
  String get updateManual =>
      'Güncelleme otomatik yüklenemedi. Disk görüntüsü açıldı: Mealie Recipes\'i Uygulamalar\'a sürükleyin.';

  @override
  String get updateFailed => 'Güncelleme başarısız';

  @override
  String get updateInstallNow => 'İndir ve yükle';

  @override
  String get updateRestartNow => 'Yükle ve yeniden başlat';

  @override
  String get updateAutoTitle => 'Açılışta güncellemeleri denetle';

  @override
  String get updateAutoDescription =>
      'Yalnızca denetler ve bildirir — yüklemeyi her zaman siz başlatırsınız.';

  @override
  String get updateBetaTitle => 'Beta sürümleri al';

  @override
  String get updateBetaDescription =>
      'Test için ön sürümleri de sunar. Hâlâ hata içerebilirler.';

  @override
  String get updateNoNotes => 'Sürüm notu yok.';

  @override
  String get updateSourceHint =>
      'Güncellemeler Mealie Recipes\'in GitHub sürümlerinden gelir ve yalnızca geliştirici tarafından imzalanmışsa yüklenir (macOS).';

  @override
  String get errorNoConnection =>
      'Mealie sunucunuza ulaşılamıyor. İnternet bağlantınızı ve sunucu adresini kontrol edin.';

  @override
  String get errorTimeout =>
      'Sunucu yanıt vermekte çok gecikti. Lütfen tekrar deneyin.';

  @override
  String get errorUnauthorized =>
      'Oturumunuzun süresi doldu veya API anahtarı artık geçerli değil. Lütfen ayarlardan yeniden giriş yapın.';

  @override
  String get errorServer =>
      'Mealie sunucusu bir hata bildirdi. Lütfen daha sonra tekrar deneyin.';

  @override
  String get errorNotFound => 'Sunucuda bulunamadı — silinmiş olabilir.';

  @override
  String get errorCertificate =>
      'Sunucunun güvenlik sertifikasına güvenilmiyor.';

  @override
  String get errorGeneric => 'Bir şeyler ters gitti. Lütfen tekrar deneyin.';

  @override
  String get offlineLabel => 'Çevrimdışı';

  @override
  String offlineSince(String time) {
    return 'Çevrimdışı · son eşitleme $time';
  }

  @override
  String get mealplanEntryActions => 'Öğün seçenekleri';

  @override
  String get mealplanMoveAction => 'Taşı';

  @override
  String get mealplanMoveTitle => 'Öğünü taşı';

  @override
  String get mealplanMoveDate => 'Tarih';

  @override
  String mealplanMovedTo(String date) {
    return '$date tarihine taşındı';
  }

  @override
  String get mealplanShowWeek => 'Göster';

  @override
  String get mealplanMoveFailed => 'Öğün taşınamadı';

  @override
  String get recentlyViewedTitle => 'Son görüntülenenler';

  @override
  String get recentlyViewedEmpty => 'Açtığınız tarifler burada görünür.';

  @override
  String get recentlyViewedClear => 'Geçmişi temizle';

  @override
  String get recentlyViewedClearMessage =>
      'Bu cihazdaki son görüntülenen tarifler listesi temizlenecek. Tariflerin kendisi kalır.';

  @override
  String get recentlyViewedClearConfirm => 'Temizle';

  @override
  String get duplicatesTitle => 'Yinelenen bulucu';

  @override
  String get duplicatesScanning => 'Yinelenen tarifler aranıyor…';

  @override
  String get duplicatesNone => 'Yinelenen tarif bulunamadı.';

  @override
  String duplicatesFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count olası yinelenen bulundu.',
      one: '1 olası yinelenen bulundu.',
    );
    return '$_temp0';
  }

  @override
  String get duplicatesIntro => 'Kalacak tarife dokunun, sonra birleştirin.';

  @override
  String get duplicatesReasonSource => 'Aynı kaynak';

  @override
  String get duplicatesReasonName => 'Aynı ad';

  @override
  String duplicatesReasonSimilar(int percent) {
    return 'Benzer · malzemelerin %$percent aynı';
  }

  @override
  String get duplicatesKeeps => 'Kalır';

  @override
  String get duplicatesWillBeDeleted => 'Silinecek';

  @override
  String get duplicatesMerge => 'Birleştir';

  @override
  String get duplicatesNotDuplicate => 'Yinelenen değil';

  @override
  String get duplicatesMergeTitle => 'Tarifler birleştirilsin mi?';

  @override
  String duplicatesMergeMessage(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count diğer tarif silinecek',
      one: '1 diğer tarif silinecek',
    );
    return '“$name” kalır. $_temp0.\n\nKategoriler, etiketler, araçlar, notlar, ev halkınızın planlanan öğünleri ve favoriniz aktarılır. Silinen tariflerin yorumları, zaman çizelgesi ve ekleri kaybolur.';
  }

  @override
  String get duplicatesMerged => 'Tarifler birleştirildi';

  @override
  String duplicatesIngredientCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count malzeme',
      one: '1 malzeme',
    );
    return '$_temp0';
  }

  @override
  String duplicatesResetIgnored(int count) {
    return 'Gizlenen çiftleri yeniden göster ($count)';
  }

  @override
  String get duplicatesRescan => 'Yeniden ara';

  @override
  String get duplicatesOpenRecipe => 'Tarifi aç';

  @override
  String get duplicatesMergeNoEditHint =>
      'Kalacak tarifi düzenleyemezsiniz (başkasının kilitli tarifi veya başka bir ev halkından). Bu yüzden kategorileri, etiketleri, araçları ve notları olduğu gibi kalır; yalnızca planlanan öğünler ve favoriniz aktarılır.';

  @override
  String get recipeOtherHouseholdHint =>
      'Başka bir ev halkından – orada düzenleme kilitli';

  @override
  String foodsSavedAsNote(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count yeni yemek',
      one: '1 yeni yemek',
    );
    return 'Kaydedildi. $_temp0 malzeme notu olarak tutuldu – yemek oluşturmak için Mealie\'de “Kullanıcı yemekleri, etiketleri ve kategorileri yönetebilir” izni gerekir.';
  }

  @override
  String get a11yRemove => 'Kaldır';

  @override
  String get a11yDecrease => 'Azalt';

  @override
  String get a11yIncrease => 'Artır';

  @override
  String get a11yShowPassword => 'Şifreyi göster';

  @override
  String get a11yHidePassword => 'Şifreyi gizle';

  @override
  String get a11yClearSearch => 'Aramayı temizle';

  @override
  String get notesQueuedOffline =>
      'Çevrimdışı – sunucuya yeniden ulaşılınca not gönderilecek.';

  @override
  String get timelineQueuedOffline =>
      'Çevrimdışı – sunucuya yeniden ulaşılınca zaman çizelgesine eklenecek.';

  @override
  String get syncSectionName => 'Yeniden adlandırılanlar';

  @override
  String get pendingRecipesDiscard => 'At';

  @override
  String get undo => 'Geri al';

  @override
  String timerStoppedSnack(String name) {
    return '“$name” zamanlayıcısı durduruldu';
  }

  @override
  String get cookFriendsEndConfirm =>
      'Oturum herkes için bitirilsin mi? Tüm misafirlerin bağlantısı kesilecek.';

  @override
  String get weekStartSyncHint =>
      'Mealie\'ye kaydedildi – web uygulaması dahil tüm ev halkınız için geçerli.';

  @override
  String get weekStartNoPermission =>
      'Mealie\'de ev halkınız tarafından ayarlanır. Yalnızca ev halkını yönetebilen üyeler değiştirebilir.';

  @override
  String get assetsUnsupported329 =>
      'Mealie PDF, görseller, videolar (MP4, MOV, WebM), ses (MP3, M4A), Word/ODT/RTF, TXT, MD, CSV ve JSON destekler.';

  @override
  String get assetsRecordVideo => 'Video kaydet';

  @override
  String get assetsChooseVideo => 'Video seç';

  @override
  String get shoppingSearchHint => 'Bu listede ara';

  @override
  String get shoppingSearchNoMatches => 'Aramanızla eşleşen ürün yok.';

  @override
  String get mealplanServingsTitle => 'Planlanan porsiyonlar';

  @override
  String get mealplanServingsHint =>
      'Yalnızca bu öğün planı kaydı için — tarifin kendisi değişmez. Tarifi açmak ve alışveriş listesine eklemek bu porsiyonları kullanır.';

  @override
  String get calendarFeedTitle => 'Takvime abone ol';

  @override
  String get calendarFeedSubtitle =>
      'Öğün planını Google, Apple veya başka bir takvimde göster';

  @override
  String get calendarFeedDescription =>
      'Ev halkınızın öğün planına Google Takvim, Apple Takvim, Home Assistant veya iCal bağlantılarını destekleyen başka bir uygulamadan abone olun. Bağlantıya sahip herkes öğün planınızı görebilir.';

  @override
  String get calendarFeedOff => 'Takvim bağlantısı ev halkınız için kapalı.';

  @override
  String get calendarFeedAskManager =>
      'Ev halkınızı yönetebilen birinden açmasını isteyin.';

  @override
  String get calendarFeedTurnOn => 'Aç';

  @override
  String get calendarFeedTurnOff => 'Kapat';

  @override
  String get calendarFeedReset => 'Bağlantıyı sıfırla';

  @override
  String get calendarFeedResetHint =>
      'Bağlantıyı sıfırlamak veya kapatmak, mevcut aboneliklerin güncellenmesini durdurur.';

  @override
  String get calendarFeedIncludeNotes => 'Notları dahil et';

  @override
  String get calendarFeedTimesHint =>
      'Saatini ayarlamak için bir öğüne dokunun. Saati olmayan öğünler tüm gün etkinliği olarak gösterilir.';

  @override
  String get calendarFeedMealTypes => 'Öğün Tipi';

  @override
  String get calendarFeedSubscribe => 'Takvimde abone ol';

  @override
  String get calendarFeedNoApp =>
      'Takvim uygulaması açılamadı. Bağlantıyı kopyalayıp takviminize abonelik olarak ekleyin.';

  @override
  String get calendarFeedPublicHint =>
      'Bağlantı giriş yapmadan çalışır — yalnızca öğün planınızı görebilecek kişilerle paylaşın.';

  @override
  String get recipeShareLinkMenu => 'Paylaşım bağlantısı ve QR kodu';

  @override
  String get recipeShareShowQr => 'QR kodunu göster';

  @override
  String get recipeShareScanQr =>
      'Bu tarifi açmak için telefon kamerasıyla tarayın';

  @override
  String get recipeShareQrShare => 'Görseli paylaş';

  @override
  String get recipeShareQrFailed => 'QR kodu görseli oluşturulamadı';

  @override
  String get mealplanSettingsTitle => 'Öğün Planı Ayarları';

  @override
  String get mealDiceRulesTitle => 'Zar kuralları';

  @override
  String saveAsNewFood(String name) {
    return '“$name” yeni yemek olarak kaydet';
  }

  @override
  String get shoppingMoreOptions => 'Daha fazla seçenek';

  @override
  String get shoppingFewerOptions => 'Daha az seçenek';

  @override
  String nameAlreadyExists(String name) {
    return 'Zaten var: $name';
  }

  @override
  String aliasBelongsTo(String alias, String name) {
    return '“$alias” zaten “$name” adına ait — ikisini birleştirmek daha iyi.';
  }

  @override
  String get recipeMatchTitle => 'Recipe Match';

  @override
  String get recipeMatchShuffle => 'Karıştır';

  @override
  String recipeMatchCardsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Destede $count tarif',
      one: 'Destede 1 tarif',
    );
    return '$_temp0';
  }

  @override
  String get recipeMatchNext => 'Sonraki';

  @override
  String get recipeMatchKeep => 'Tepsiye';

  @override
  String get recipeMatchKept => 'Tepsiye kondu';

  @override
  String get recipeMatchAnyTime => 'Herhangi bir süre';

  @override
  String recipeMatchMaxTime(int minutes) {
    return '≤ $minutes dk';
  }

  @override
  String get recipeMatchEmpty => 'Eşleşen tarif yok';

  @override
  String get recipeMatchEmptyHint =>
      'Filtreleri değiştirin veya tepsiyi boşaltın.';

  @override
  String get recipeMatchResetFilters => 'Filtreleri sıfırla';

  @override
  String get recipeMatchFlipHint => 'Dokunun: malzemeler · yapılışı';

  @override
  String get recipeMatchFlipBack => 'Geri çevir';

  @override
  String get recipeMatchOpenRecipe => 'Tarifin tamamı';

  @override
  String get recipeMatchOnHand => 'mevcut';

  @override
  String get recipeMatchTray => 'Tepsi';

  @override
  String get recipeMatchTrayEmpty => 'Hâlâ boş – bir kartı aşağı sürükleyin';

  @override
  String recipeMatchTrayCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tarif',
      one: '1 tarif',
    );
    return '$_temp0';
  }

  @override
  String get recipeMatchClear => 'Temizle';

  @override
  String get recipeMatchTrayHint =>
      'Siz boşaltana kadar kalır – desteyi kapatsanız bile.';

  @override
  String get recipeMatchRemove => 'Tepsiden kaldır';

  @override
  String get recipeMatchToMealplan => 'Öğün planına ekle';

  @override
  String get recipeMatchToShopping => 'Malzemeleri alışveriş listesine';

  @override
  String get recipeMatchSelectIngredients => 'Malzemeleri seç';

  @override
  String get recipeMatchNoList => 'Önce bir alışveriş listesi seçin.';

  @override
  String get recipeMatchList => 'Liste';

  @override
  String get recipeMatchOnHandHint =>
      'Mevcut malzemelerin seçimi zaten kaldırıldı.';

  @override
  String recipeMatchAddCount(int selected, int total) {
    return '$total malzemeden $selected tanesini ekle';
  }

  @override
  String get recipeMatchNoDay => 'Henüz gün yok – tepside kalır';

  @override
  String recipeMatchAddMeals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count öğün ekle',
      one: '1 öğün ekle',
    );
    return '$_temp0';
  }

  @override
  String recipeMatchMealsAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count öğün eklendi',
      one: '1 öğün eklendi',
    );
    return '$_temp0';
  }

  @override
  String get recipeMatchSwipeUp => 'Tepsiyi açmak için yukarı kaydırın';

  @override
  String get weekPlannerTitle => 'Haftayı planla';

  @override
  String get weekPlannerStepDays => 'Günler';

  @override
  String get weekPlannerStepPrefs => 'Tercihler';

  @override
  String get weekPlannerStepPreview => 'Önizleme';

  @override
  String get weekPlannerDaysTitle => 'Uygulama hangi öğünleri doldursun?';

  @override
  String get weekPlannerDaysHint =>
      'Hücrelere dokunun. Zaten planlanmış olanlar olduğu gibi kalır.';

  @override
  String get weekPlannerPresetWeekdays => 'Hafta içi';

  @override
  String get weekPlannerPlanned => 'planlandı';

  @override
  String get weekPlannerMoreMeals => 'Daha fazla öğün göster';

  @override
  String get weekPlannerFewerMeals => 'Daha az öğün';

  @override
  String weekPlannerMealCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count öğün',
      one: '1 öğün',
    );
    return '$_temp0';
  }

  @override
  String get weekPlannerPrefsTitle => 'Uygulama neye dikkat etsin?';

  @override
  String get weekPlannerPrefsHint =>
      'Hepsi isteğe bağlı – seçim yapmazsanız tariflerinizden renkli bir karışım seçer.';

  @override
  String get weekPlannerQuick => 'Hafta içi hızlı';

  @override
  String weekPlannerQuickSub(int minutes) {
    return 'Pzt–Cum en fazla $minutes dk';
  }

  @override
  String get weekPlannerStale => 'Uzun süredir yapılmayanlar önce';

  @override
  String get weekPlannerStaleSub => '“Son yapılış” ve öğün planına göre';

  @override
  String get weekPlannerFavorites => 'Favorileri daha sık planla';

  @override
  String get weekPlannerFavoritesSub => 'kalpli ve yüksek puanlı tarifler';

  @override
  String get weekPlannerVariety => 'Çeşitlilik';

  @override
  String get weekPlannerVarietySub => 'aynı kategori arka arkaya iki kez olmaz';

  @override
  String get weekPlannerOnlyFrom => 'Yalnızca şuradan';

  @override
  String get weekPlannerDiceRules => 'Zar kurallarını kullan';

  @override
  String get weekPlannerDiceRulesSub =>
      'öğün planı ayarlarından her öğün için seçiminiz';

  @override
  String weekPlannerMatching(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count eşleşen tarif',
      one: '1 eşleşen tarif',
    );
    return '$_temp0';
  }

  @override
  String weekPlannerForMeals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count öğün için',
      one: '1 öğün için',
    );
    return '$_temp0';
  }

  @override
  String get weekPlannerSuggest => 'Öner';

  @override
  String get weekPlannerPreviewHint =>
      'Zar değiştirir, kilit tutar. Yer değiştirmek için bir yemeğe basılı tutup başka bir güne sürükleyin.';

  @override
  String get weekPlannerRerollAll => 'Hepsini yeniden at';

  @override
  String get weekPlannerReroll => 'Yeniden at';

  @override
  String get weekPlannerLock => 'Kilitle';

  @override
  String get weekPlannerUnlock => 'Kilidi aç';

  @override
  String get weekPlannerReasonNever => 'hiç yapılmadı';

  @override
  String get weekPlannerReasonStale => 'uzun süredir yapılmadı';

  @override
  String get weekPlannerReasonFavorite => 'Favori';

  @override
  String get weekPlannerNoMatch => 'Eşleşen tarif yok';

  @override
  String get weekPlannerThenShopping =>
      'Ardından alışveriş listesi için malzemeleri seç';

  @override
  String get weekPlannerMostlyEmpty => 'Hafta neredeyse boş';

  @override
  String weekPlannerMostlyEmptySub(int free, int total) {
    return '$total günden $free gün hâlâ boş – üç adımda doldurun.';
  }

  @override
  String get previousWeek => 'Önceki hafta';

  @override
  String get nextWeek => 'Sonraki hafta';

  @override
  String get weekPlannerAllDays => 'Tüm günler';

  @override
  String get weekPlannerWeekend => 'Hafta sonu';

  @override
  String get weekPlannerDinners => 'Akşam yemekleri';

  @override
  String get weekPlannerLunches => 'Öğle yemekleri';

  @override
  String get weekPlannerAllMeals => 'Tüm öğünler';

  @override
  String get mealplanDayEmpty => 'Planlanmış bir şey yok';

  @override
  String get mealplanDropHere => 'Buraya bırakın';

  @override
  String mealplanDayKcal(String kcal) {
    return 'Porsiyon başına $kcal kcal';
  }

  @override
  String mealplanDayKcalPartial(String kcal) {
    return 'Porsiyon başına en az $kcal kcal';
  }

  @override
  String get globalSearchHint => 'Tarif, ürün, özellik ara …';

  @override
  String get globalSearchIntro =>
      'Tarifleri, alışveriş listesi ürünlerini, yemekleri ve yemek kitaplarını arayın – uygulamanın özelliklerini ve ayarlarını da, ör. “liste”.';

  @override
  String get globalSearchFunctions => 'Özellikler';

  @override
  String globalSearchNoResults(String query) {
    return '“$query” için sonuç yok';
  }

  @override
  String get searchClear => 'Aramayı temizle';

  @override
  String get recipeMatchPlanWeek => 'Haftayı bu tariflerle planla';

  @override
  String get weekPlannerReasonTray => 'tepsiden';

  @override
  String get emptyBrowseRecipes => 'Tariflere göz at';

  @override
  String get mealplanWeekShopping => 'Bu haftanın malzemeleri';

  @override
  String get globalSearchActions => 'Eylemler';

  @override
  String globalSearchAddToList(String text) {
    return '“$text” öğesini alışveriş listesine ekle';
  }

  @override
  String globalSearchAdded(String text) {
    return '“$text” eklendi';
  }

  @override
  String get globalSearchImportUrl => 'Bu adresten tarif içe aktar';

  @override
  String get homeContinueCooking => 'Pişirmeye devam et';

  @override
  String homeCookingStep(int step, int total) {
    return 'Adım $step / $total';
  }

  @override
  String get homeCookingPrep => 'Hazırlık';

  @override
  String get homeCookingAlmostDone => 'Neredeyse bitti';

  @override
  String get homeCookingContinue => 'devam';

  @override
  String get paneSelectRecipe => 'Soldan bir tarif seçin.';

  @override
  String get mealplanDragRecipeHint =>
      'Planlamak için bir tarifi bir güne sürükleyin.';

  @override
  String get desktopDropUnsupported => 'Bu dosyalar ek olarak eklenemez.';

  @override
  String desktopDropUploaded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ek eklendi',
      one: '1 ek eklendi',
    );
    return '$_temp0';
  }

  @override
  String get desktopDropAsAttachment => 'Ek olarak eklemek için bırakın';

  @override
  String get printAction => 'Yazdır';

  @override
  String get mealplanPrintWeek => 'Haftayı yazdır';

  @override
  String get mealplanEntryCooked => 'Pişirildi';

  @override
  String get recipeSearchClear => 'Aramayı temizle';

  @override
  String get organizerShowRecipes => 'Tarifleri göster';

  @override
  String globalSearchShowAllRecipes(int count) {
    return '$count tarifin tümünü göster';
  }

  @override
  String get unnamedEntry => '(adsız)';

  @override
  String get mealplanWholeWeek => 'Tüm hafta için';

  @override
  String get mealplanWholeWeekDropHint =>
      'Tüm hafta için planlamak üzere bir öğünü buraya bırakın.';

  @override
  String get mealplanMovedToWholeWeek => 'Tüm hafta için planlandı';

  @override
  String get mealplanCookToday => 'Bugün pişiriyorum';

  @override
  String get mealplanPlanWholeWeek => 'Tüm hafta için planla';

  @override
  String mealplanPlanWholeWeekRange(String from, String to) {
    return '$from – $to';
  }

  @override
  String get calendarFeedDuration => 'Süre (dakika)';

  @override
  String get calendarFeedEventDetails => 'Etkinlik Ayrıntıları';

  @override
  String calendarFeedEventDetailsHint(String fields) {
    return 'Öğünlerin takviminizde nasıl görüneceğini özelleştirin. Birleştirme alanları: $fields';
  }

  @override
  String get calendarFeedEventTitle => 'Etkinlik Başlığı';

  @override
  String get calendarFeedEventDescription => 'Etkinlik Açıklaması';

  @override
  String get calendarFeedEventDetailsWarning =>
      'Bunları değiştirmek takvim bağlantısını değiştirir — zaten abone olduysanız yeni bağlantıyla yeniden abone olun.';

  @override
  String get stepDurationMinutes => 'Süre (dakika)';

  @override
  String stepDurationSaved(String duration) {
    return 'Kayıtlı süre: $duration. Düzenlemek bunu tam dakikalarla değiştirir.';
  }

  @override
  String get sortTotalTimeShort => 'En kısa toplam süre';

  @override
  String get sortTotalTimeLong => 'En uzun toplam süre';

  @override
  String recipeCreatedBy(String name) {
    return 'Oluşturan: $name';
  }

  @override
  String get timelineReplacePhoto => 'Fotoğrafı değiştir';

  @override
  String get pasteRecipeTitle => 'Tarif yapıştır';

  @override
  String get pasteRecipeDescription =>
      'Bir tarifi JSON (schema.org) olarak veya bir web sayfasının HTML kaynağı olarak yapıştırın.';

  @override
  String get pasteRecipeDescription330 =>
      'Mealie\'den dışa aktarılmış bir tarifi (JSON) yapıştırın — tam yapısıyla içe aktarılır: yemekler, birimler ve adım bağlantıları. JSON (schema.org) ve bir web sayfasının HTML kaynağı da çalışır.';

  @override
  String get pasteRecipeHint => 'JSON veya HTML\'yi buraya yapıştırın';

  @override
  String get pasteRecipeButton => 'Tarif yapıştır';

  @override
  String get pasteRecipeImport => 'İçe Aktar';

  @override
  String get aiPromptsTitle => 'Yapay Zekâ İstemleri';

  @override
  String get aiPromptsTeaser =>
      'Mealie\'nin yapay zekâ sağlayıcınıza verdiği talimatları özelleştirin — tüm görevler için veya her biri için.';

  @override
  String get aiPromptsDescription =>
      'Mealie\'nin yapay zekâ sağlayıcınıza her görev için verdiği talimatları özelleştirin. Mealie\'nin istemleri İngilizce yazılmıştır, ancak bu tariflerinizin dilini değiştirmez: siz çevirmeyi seçmedikçe kaynağın dilini korurlar. Kendi talimatlarınızı herhangi bir dilde yazabilirsiniz.';

  @override
  String get aiPromptsGlobal => 'Tüm istemler için talimatlar';

  @override
  String get aiPromptsGlobalDescription =>
      'Tarif oluşturma, malzeme ayrıştırma ve çeviri gibi tarif verisi üreten her isteme eklenir. Sistem istemleri etkilenmez.';

  @override
  String get aiPromptsGlobalPlaceholder =>
      'ör. Her zaman metrik birimler kullan.';

  @override
  String get aiPromptsList => 'İstemler';

  @override
  String get aiPromptSystem => 'Sistem';

  @override
  String get aiPromptSystemDescription =>
      'Bu bir sistem istemidir. Kaynak materyali tarife dönüştürülmeden önce olabildiğince sadık biçimde yazıya döker, bu yüzden tüm istemler için talimatlar buna eklenmez. Değiştirmek genellikle gerekmez ve içe aktarmaları daha az güvenilir yapabilir.';

  @override
  String get aiPromptAppended => 'Eklendi';

  @override
  String get aiPromptOverridden => 'Geçersiz kılındı';

  @override
  String get aiPromptModeDefault => 'Varsayılan';

  @override
  String get aiPromptModeAppend => 'Ekle';

  @override
  String get aiPromptModeOverride => 'Geçersiz kıl';

  @override
  String get aiPromptAppendDescription =>
      'Bu talimatlar Mealie\'nin istemine eklenir ve ikisi çeliştiğinde önceliklidir.';

  @override
  String get aiPromptOverrideDescription =>
      'İsteminiz Mealie\'nin istemini tamamen değiştirir, bu yüzden Mealie isteminin gelecekteki güncellemeleri buna uygulanmaz. Görevin ihtiyaç duyduğu veriler, örneğin birim listeniz, yine isteminizin ardından eklenir.';

  @override
  String get aiPromptDefaultChanged =>
      'Mealie\'nin istemi siz geçersiz kıldıktan sonra değişti. Sizinkiyle karşılaştırın veya yeni sürümü kullanmak için varsayılana dönün.';

  @override
  String get aiPromptViewDefault => 'Varsayılan istemi göster';

  @override
  String get aiPromptHideDefault => 'Varsayılan istemi gizle';

  @override
  String get aiPromptSaved => 'İstem kaydedildi';

  @override
  String get aiPromptSaveFailed => 'İstem kaydedilemedi';

  @override
  String get aiPromptTitleBuildRecipe => 'Tarif oluştur';

  @override
  String get aiPromptTitleParseIngredients => 'Malzemeleri ayrıştır';

  @override
  String get aiPromptTitleRecipeVideo => 'Videodan tarif';

  @override
  String get aiPromptTitleOrganizers => 'Düzenleyicileri ata';

  @override
  String get aiPromptTitleTranslate => 'Tarifi çevir';

  @override
  String get aiPromptTitleCompileSource => 'Kaynak materyali oku';

  @override
  String get aiPromptTitleTranscribe => 'Sesi yazıya dök';

  @override
  String get aiPromptDescBuildRecipe =>
      'Bir web sayfasından, fotoğraftan veya metinden okunan kaynak materyali yapılandırılmış bir tarife dönüştürür.';

  @override
  String get aiPromptDescParseIngredients =>
      'Yapay zekâ malzeme ayrıştırıcısı tarafından her malzemeyi miktar, birim, yemek ve nota ayırmak için kullanılır.';

  @override
  String get aiPromptDescRecipeVideo =>
      'Bir videonun dökümünü ve açıklamasını tarife dönüştürür.';

  @override
  String get aiPromptDescOrganizers =>
      'İçe aktarılan bir tarif için etiketleri, kategorileri ve araçları seçer.';

  @override
  String get aiPromptDescTranslate =>
      'İçe aktarılan bir tarifi seçtiğiniz dile çevirir.';

  @override
  String get aiPromptDescCompileSource =>
      'Web sayfalarını, fotoğrafları ve metni tarifin düz metin kaydına okur.';

  @override
  String get aiPromptDescTranscribe =>
      'Ses sağlayıcınız doğrudan yazıya dökemediğinde sesi yazıya döker.';

  @override
  String get mealplanNoteHint => 'Not (isteğe bağlı)';

  @override
  String get mealplanEditTitle => 'Kaydı düzenle';

  @override
  String get mealplanEntryTitleLabel => 'Başlık';

  @override
  String get mealplanEntryNoteLabel => 'Not';

  @override
  String mealplanCreateRecipe(String name) {
    return 'Yeni tarif “$name”';
  }

  @override
  String get mealplanCreateRecipeSubtitle =>
      'Boş bir tarif oluşturur, planlar ve düzenleyiciyi açar';

  @override
  String get importOptionsTitle => 'İçe aktarma seçenekleri';

  @override
  String get importOptionsHint =>
      'Mealie\'nin yapay zekâsının içe aktarırken sunucunuzda ne kadar iş yaptığı. Her ek adım ayrı bir yapay zekâ isteğidir – ne kadar az, o kadar hızlı.';

  @override
  String get importTranslateTitle => 'Tarifi çevir';

  @override
  String get importOrganizersTitle => 'Kategoriler ve etiketler';

  @override
  String get importOrganizersCreate => 'Yeni ekle';

  @override
  String get importOrganizersExisting => 'Yalnızca mevcutlar';

  @override
  String get importOrganizersNone => 'Yok';

  @override
  String get importOrganizersCreateHint =>
      'Yapay zekâ etiket, kategori ve araç atar ve eksik olanları oluşturur.';

  @override
  String get importOrganizersExistingHint =>
      'Yapay zekâ yalnızca zaten var olan etiket, kategori ve araçları kullanır.';

  @override
  String get importOrganizersNoneHint =>
      'Tarif etiket, kategori ve araç olmadan içe aktarılır. Mealie bu adımı yine de çalıştırır, bu yüzden içe aktarma hızlanmaz.';

  @override
  String get importStarting => 'Sunucuya gönderiliyor…';

  @override
  String get importRunning => 'Tarif içe aktarılıyor…';

  @override
  String get aiImagesRunning => 'Yapay zekâ sayfaları okuyor…';

  @override
  String get importStreamPhotosTitle =>
      'Canlı ilerlemeyle fotoğraf içe aktarma';

  @override
  String get importStreamPhotosHint =>
      'Her adımı gösterir ve uzun içe aktarmalarda bağlantıyı açık tutar. Önceki gibi tek istekte yüklemek için kapatın – ör. proxy\'niz akışı engelliyorsa.';

  @override
  String get weekPlannerDiceRulesMealieSub =>
      'ev halkınızın Mealie kuralları (öğün planı ayarları)';

  @override
  String get syncStarted =>
      'Tarifler, görseller ve listeler sunucudan yeniden yükleniyor…';

  @override
  String get syncDone => 'Her şey güncel';

  @override
  String get recipeReloaded => 'Tarif yeniden yüklendi';

  @override
  String get logoutTitle => 'Çıkış yap / kullanıcı değiştir';

  @override
  String get logoutConfirm =>
      'Tarifler, listeler ve henüz eşitlenmemiş değişiklikler bu cihazdan kaldırılır. Uygulama ayarlarınız ve sunucu adresi kalır, yalnızca yeniden giriş yapmanız gerekir.';

  @override
  String get reloadRecipe => 'Sunucudan yeniden yükle';

  @override
  String get wifiServerTitle => 'Wi-Fi\'da farklı adres';

  @override
  String get wifiServerHint =>
      'Aynı sunucu için ikinci bir adres, ör. evde yerel IP, dışarıda ZeroTier, Tailscale veya bir alan adı. Aşağıdaki Wi-Fi\'da uygulama bu adresi otomatik kullanır, diğer her yerde yukarıdaki sunucu URL\'sini.';

  @override
  String get wifiSsidLabel => 'Wi-Fi adı';

  @override
  String get wifiServerUrl => 'Bu Wi-Fi\'daki adres';

  @override
  String get wifiUseCurrent => 'Geçerli Wi-Fi\'ı kullan';

  @override
  String get wifiNameUnavailable =>
      'Wi-Fi adı okunamadı. Wi-Fi\'a bağlanın ve konum erişimine izin verin – Android ve iOS Wi-Fi adını yalnızca bununla gösterir.';

  @override
  String wifiServerActive(String ssid) {
    return 'Etkin: “$ssid” Wi-Fi\'daki adres';
  }

  @override
  String wifiServerStandardActive(String ssid) {
    return 'Etkin: sunucu URL\'si (“$ssid” üzerinde değil)';
  }

  @override
  String get wifiServerRemove => 'Kaldır';

  @override
  String get switchUserTitle => 'Kullanıcı değiştir';

  @override
  String switchUserBody(String name) {
    return '$name bu cihazda kayıtlı kalır – tüm tarifler, listeler ve henüz eşitlenmemiş değişikliklerle. Profil resminizden veya giriş sayfasından geri geçebilirsiniz.';
  }

  @override
  String get allowBiometricTitle => 'Cihaz kilidiyle geri geç';

  @override
  String get allowBiometricHint =>
      'Şifre yerine Face ID, parmak izi veya cihaz PIN\'i. Bu cihazın kilidini açabilen herkes bu hesabı açabilir.';

  @override
  String get allow => 'İzin ver';

  @override
  String unlockAccountReason(String name) {
    return '$name hesabına geç';
  }

  @override
  String signInAs(String name) {
    return '$name olarak giriş yap';
  }

  @override
  String wrongAccountError(String name) {
    return 'Bu “$name” hesabı. Lütfen kayıtlı hesapla giriş yapın.';
  }

  @override
  String get accountSaveOffline =>
      'Hesap şu anda kaydedilemiyor – sunucuya ulaşılamıyor.';

  @override
  String get signOutRemoveTitle => 'Çıkış yap ve kaldır';

  @override
  String get signOutRemoveConfirm =>
      'Bu hesap ve bu cihazdaki tüm verileri (tarifler, listeler, henüz eşitlenmemiş değişiklikler) kaldırılır. Uygulama ayarlarınız kalır.';

  @override
  String get removeSavedAccount => 'Bu cihazdan kaldır';

  @override
  String removeSavedAccountConfirm(String name) {
    return '“$name” ve kayıtlı tüm verileri bu cihazdan kaldırılsın mı? Henüz eşitlenmemiş değişiklikler kaybolur.';
  }

  @override
  String get savedAccountsTitle => 'Kayıtlı hesaplar';

  @override
  String get addAccount => 'Başka hesap ekle';

  @override
  String get biometricOff => 'Cihaz kilidini kullanmayı bırak';

  @override
  String get orNewAccount => 'Veya başka bir hesapla giriş yapın:';

  @override
  String get importVideoTitle => 'Video bağlantıları';

  @override
  String get importVideoFast => 'Hızlı';

  @override
  String get importVideoThorough => 'Kapsamlı (YZ)';

  @override
  String get importVideoFastHint =>
      'Mealie videoyu yazıya döker ve tarifi tek bir yapay zekâ isteğiyle oluşturur – genellikle çok daha hızlı. Çeviri ve kategori/etiket yok. İçe aktarma başına yine de yapay zekâyı açabilirsiniz.';

  @override
  String get importVideoThoroughHint =>
      'Video bağlantıları için yapay zekâ anahtarı otomatik açılır: birkaç yapay zekâ adımı, yukarıdaki ayarlara göre çeviri ve kategori/etiketlerle. Daha uzun sürer.';

  @override
  String get importPresetFast => 'Hızlı';

  @override
  String get importPresetThorough => 'Kapsamlı';

  @override
  String get importPresetCustom => 'Özel';

  @override
  String get importPresetFastTitle =>
      'Olabildiğince az yapay zekâ adımı – en kısa bekleme';

  @override
  String get importPresetFastVideo =>
      'Video bağlantıları: Mealie videoyu yazıya döker ve tarifi tek bir yapay zekâ isteğiyle oluşturur (yapay zekâ anahtarı kapalı kalır).';

  @override
  String get importPresetFastTranslate =>
      'Çeviri yok – tarif orijinal dilinde kalır.';

  @override
  String get importPresetFastOrganizers =>
      'Yalnızca mevcut kategori ve etiketler atanır, yenileri oluşturulmaz.';

  @override
  String get importPresetThoroughTitle =>
      'Mealie\'nin tam yapay zekâ içe aktarması – daha uzun sürer, en iyi sonucu verir';

  @override
  String get importPresetThoroughVideo =>
      'Video bağlantıları otomatik olarak yapay zekâyla içe aktarılır – birkaç adımda (kaynağı derleme, tarifi oluşturma, …).';

  @override
  String get importPresetThoroughTranslate =>
      'Tarif başka bir dilde yazılmışsa aşağıdaki içe aktarma diline çevrilir.';

  @override
  String get importPresetThoroughOrganizers =>
      'Uygun kategori ve etiketler atanır; eksik olanlar oluşturulur.';

  @override
  String get importPresetCustomTitle => 'Her seçeneği kendiniz ayarlayın';

  @override
  String get importPresetCustomBody =>
      'Önceki seçiminizin yaptığından başlayın ve yalnızca gerekeni değiştirin – ör. hızlı video içe aktarma ama çeviriyle.';

  @override
  String get sidebarPinHint =>
      'İpucu: bir kutucuğa basılı tutun ve sabitlemek için kenar çubuğuna sürükleyin.';

  @override
  String get sidebarDropHere => 'Buraya bırakın';

  @override
  String sidebarShortcutTitle(String name) {
    return '“$name” için kısayol';
  }

  @override
  String sidebarShortcutPrompt(String modifier) {
    return 'Şimdi $modifier dahil istediğiniz tuş kombinasyonuna basın.';
  }

  @override
  String get sidebarShortcutTaken => 'Bu kombinasyon zaten kullanılıyor.';

  @override
  String get sidebarShortcutNone => 'Kısayol yok';

  @override
  String get sidebarShortcutChange => 'Kısayolu değiştir';

  @override
  String get sidebarUnpin => 'Kenar çubuğundan kaldır';

  @override
  String sidebarFull(int count) {
    return 'Kenar çubuğu dolu – en fazla $count kendi öğeniz.';
  }

  @override
  String get tabletSidebar => 'Yatayda kenar çubuğu';

  @override
  String get tabletSidebarSubtitle =>
      'Tablet yatay tutulduğunda gezinmeyi altta yerine solda gösterir';

  @override
  String get filterDateCreated => 'Oluşturma Tarihi';

  @override
  String get filterDateUpdated => 'Güncellenme tarihi';

  @override
  String get errorUploadTooLarge =>
      'Dosya bu Mealie sunucusu için çok büyük. Sunucunun yükleme sınırı MAX_UPLOAD_SIZE_MB ile artırılabilir.';

  @override
  String get recipeDownloadPdfMealie => 'PDF indir (Mealie düzeni)';

  @override
  String get mealplanNoteMore => 'Daha fazla göster…';

  @override
  String get mealplanNoteLess => 'Daha az göster';

  @override
  String get ingredientCommonlySubstitutedWith =>
      'Genellikle yerine kullanılanlar';

  @override
  String requiresMealieVersion(String version) {
    return 'Mealie $version veya daha yenisi gerekir.';
  }

  @override
  String get apiTokensTitle => 'API Anahtarları';

  @override
  String get apiTokensDescription =>
      'Harici uygulamalardan erişim için API Anahtarlarınızı yönetin.';

  @override
  String get apiTokenNameLabel => 'Anahtar Adı';

  @override
  String get apiTokenGenerate => 'Oluştur';

  @override
  String get apiTokensActive => 'AKTİF ANAHTARLAR';

  @override
  String get apiTokenCopyWarning =>
      'Bu anahtarı harici bir uygulamayla kullanmak için kopyalayın. Bu anahtar bir daha görüntülenemeyecek.';

  @override
  String get apiTokenThisApp => 'Bu uygulama kullanıyor';

  @override
  String get apiTokenThisAppHint =>
      'Bu anahtar uygulamanın oturumunu açık tutar ve burada silinemez.';

  @override
  String apiTokenDeleteConfirm(String name) {
    return '“$name” anahtarı silinsin mi? Onu kullanan uygulamalar erişimi hemen kaybeder.';
  }

  @override
  String get apiTokensEmpty => 'Henüz anahtar yok.';

  @override
  String apiTokenCreatedOn(String date) {
    return '$date tarihinde oluşturuldu';
  }

  @override
  String get apiTokenCopied => 'Anahtar kopyalandı';

  @override
  String get qfOpHasNoValue => 'değeri yok';

  @override
  String get qfOpHasValue => 'değeri var';

  @override
  String get ratingHouseholdAverage => 'ev halkı ort.';

  @override
  String get stepLinkedNotes => 'Bağlı notlar';

  @override
  String get noteFallbackTitle => 'Not';

  @override
  String get aiPromptTitleEnrichInstructions => 'Adım ayrıntılarını ekle';

  @override
  String get aiPromptDescEnrichInstructions =>
      'İçe aktarılan bir tarifin her adımını kullandığı malzeme ve notlara bağlar, süresini ve başlığını belirler.';

  @override
  String get loginAccountLocked =>
      'Hesap kilitlendi. Lütfen daha sonra tekrar deneyin';

  @override
  String get loginPasswordDisabled =>
      'Bu sunucuda şifreyle giriş devre dışı. Bunun yerine bir API anahtarı kullanın.';

  @override
  String get unitSystemTitle => 'Birimler';

  @override
  String get unitSystemAsWritten => 'Yazıldığı gibi';

  @override
  String get unitSystemMetric => 'Metrik';

  @override
  String get unitSystemMetricHint => 'Metrik (g, ml)';

  @override
  String get unitSystemImperial => 'Emperyal';

  @override
  String get unitSystemImperialHint => 'Emperyal (cup, oz)';

  @override
  String get unitSystemHint =>
      'Yalnızca görünüm – tarifin kendisi değişmez. Mealie web uygulamasında olduğu gibi seçim bu cihazdaki tüm tarifler için geçerlidir.';

  @override
  String get unitSystemUnavailable =>
      'Bu tarifin hiçbir birimi dönüştürülemez. Bunun için birimin Mealie\'de standartlaştırılmış olması gerekir (Yemekler ve birimler → birim → Standartlaştırma).';
}
