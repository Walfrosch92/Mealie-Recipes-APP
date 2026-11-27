// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get endCookingMode => '調理モードを終了';

  @override
  String get endCookingModeConfirm => '調理モードを終了しますか？';

  @override
  String endCookingModeConfirmAll(int count) {
    return '調理モード中の $count 件のレシピをすべて終了します。続けますか？';
  }

  @override
  String get addTimer => 'タイマーを追加';

  @override
  String get recipeFinished => '料理が完成しました。';

  @override
  String get bonAppetit => '召し上がれ！';

  @override
  String get prepareIngredients => '次の材料を準備してください';

  @override
  String prepareIngredientsFor(String servings) {
    return '$servings 人前の材料を準備してください';
  }

  @override
  String get next => '次へ';

  @override
  String get navHome => 'ホーム';

  @override
  String get homeCookToday => '今日作る';

  @override
  String get homeSuggestion => 'おすすめ';

  @override
  String get homeQuickAccess => 'クイックアクセス';

  @override
  String get homePlanned => '予定';

  @override
  String get favorite => 'お気に入り';

  @override
  String get navSettings => '設定';

  @override
  String homeWelcomeName(Object name) {
    return 'ようこそ、$nameさん';
  }

  @override
  String get homeWelcomeApp => 'Mealie Recipes へ 👋';

  @override
  String get theme => '外観';

  @override
  String get themeSystem => 'システム';

  @override
  String get themeLight => 'ライト';

  @override
  String get themeDark => 'ダーク';

  @override
  String get recipes => 'レシピ';

  @override
  String get shoppingList => '🛒 買い物リスト';

  @override
  String get mealplan => '献立';

  @override
  String get settings => '⚙️ 設定';

  @override
  String get searchRecipe => 'レシピを検索...';

  @override
  String get loadingRecipe => 'レシピを読み込み中...';

  @override
  String get errorLoadingRecipe => 'レシピを読み込めませんでした。';

  @override
  String get noRecipesForCategory => 'このフィルターに該当するレシピはありません。';

  @override
  String get resetFilter => 'フィルターをリセット';

  @override
  String get allCategories => 'すべてのカテゴリ';

  @override
  String get all => 'すべて';

  @override
  String get sortRecipes => 'レシピを並べ替え';

  @override
  String get refreshRecipes => '更新';

  @override
  String get sortNameAZ => '名前 A–Z';

  @override
  String get sortNameZA => '名前 Z–A';

  @override
  String get sortDateNewest => '新しい順';

  @override
  String get sortDateOldest => '古い順';

  @override
  String get sortPrepTimeShort => '下準備が短い順';

  @override
  String get sortPrepTimeLong => '下準備が長い順';

  @override
  String get sortRatingHighest => '評価が高い順';

  @override
  String get sortRatingLowest => '評価が低い順';

  @override
  String get details => '詳細';

  @override
  String get ingredients => '材料';

  @override
  String get instructions => '説明';

  @override
  String get tags => 'タグ';

  @override
  String get notes => '備考';

  @override
  String get addNote => 'メモを追加';

  @override
  String get editNote => 'メモを編集';

  @override
  String get noteTitleHint => 'タイトル（任意）';

  @override
  String get noteTextHint => 'メモの本文';

  @override
  String get deleteNoteTitle => 'メモを削除しますか？';

  @override
  String get deleteNoteMessage => 'このメモは完全に削除されます。';

  @override
  String get servings => '人前';

  @override
  String get planMeal => '献立に追加';

  @override
  String get addAllIngredients => 'すべての材料を追加';

  @override
  String get addSelectedIngredients => '選択した材料を追加';

  @override
  String get addIngredientsMessage => '材料を買い物リストに追加しました。';

  @override
  String addIngredientsFailedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 件の材料を追加できませんでした。',
      one: '1 件の材料を追加できませんでした。',
    );
    return '$_temp0';
  }

  @override
  String get cookbooks => '料理本';

  @override
  String get cookbooksEmpty => '料理本はまだありません。右上の「+」をタップして作成してください。';

  @override
  String get cookbookNoMatches => 'このフィルターに該当するレシピはありません。';

  @override
  String get cookbookCreateTitle => '料理本を作成';

  @override
  String get cookbookEditTitle => '料理本を編集';

  @override
  String get cookbookNameLabel => '料理本の名前';

  @override
  String get cookbookFilterSectionTitle => 'レシピを自動で追加';

  @override
  String get cookbookFieldTools => '調理器具';

  @override
  String get cookbookFieldUsers => 'ユーザー';

  @override
  String get cookbookOpIsOneOf => 'のうちの1つです';

  @override
  String get cookbookOpIsNotOneOf => 'のひとつではない';

  @override
  String get cookbookOpContainsAll => 'すべてを含む';

  @override
  String get cookbookSelectValues => '値を選択';

  @override
  String get cookbookFilterOptionsUnavailable => '選択肢がありません';

  @override
  String get cookbookAddFilterField => '項目を追加';

  @override
  String get cookbookPublicLabel => '公開料理本';

  @override
  String get cookbookPublicSubtitle => 'サーバー上の他の世帯にも表示されます';

  @override
  String get cookbookRawModeEnter => 'テキストとして編集';

  @override
  String get cookbookRawModeExit => 'ビルダーに戻る';

  @override
  String get cookbookRawModeHint =>
      'このアプリのエキスパートモード：フィルターをテキストとして直接編集します。既存のフィルターを単純な行に分解できない場合に便利です。';

  @override
  String get cookbookRawModeUnparseable =>
      'このテキストは単純な行形式に合いません — テキストのままになります。';

  @override
  String get saveFailed => '保存に失敗しました';

  @override
  String get search => '検索';

  @override
  String get apply => '適用';

  @override
  String get setupCachingTitle => 'レシピを読み込んでいます';

  @override
  String get setupCachingSubtitle =>
      'オフラインで使えるようにレシピを準備しています。レシピの数によっては少し時間がかかります。';

  @override
  String get setupCachingDone => '準備完了！';

  @override
  String get setupTipsHeader => 'ご存じでしたか？';

  @override
  String get setupFinish => 'はじめる';

  @override
  String get setupSkipCaching => 'バックグラウンドで続行';

  @override
  String get setupTip1 => 'リンク・写真・PDF からレシピを取り込めます — ホーム画面の「インポート」タイルから。';

  @override
  String get setupTip2 => '調理モードは画面をつけたままにし、手順ごとに案内し、本文中のタイマーを自動で見つけます。';

  @override
  String get setupTip3 => '買い物リストはオフラインでも使えます — サーバーに接続できると変更が自動で同期されます。';

  @override
  String get setupTip4 => 'ホーム画面のタイルを長押しすると、クイックアクセスを並べ替えられます。';

  @override
  String get setupTip5 => 'Mealie の料理本は「料理本」タイルにあります — オフラインでも使えます。';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'キャンセル';

  @override
  String get delete => '削除';

  @override
  String get edit => '編集';

  @override
  String get save => '保存';

  @override
  String get done => '完了';

  @override
  String get close => '閉じる';

  @override
  String get add => '追加';

  @override
  String get send => '送信';

  @override
  String get retry => '再試行';

  @override
  String get confirmDeleteTitle => 'レシピを削除しますか？';

  @override
  String get confirmDeleteMessage => 'この操作は元に戻せません。';

  @override
  String get sendToDevice => 'デバイスに送信';

  @override
  String get timerFinished => 'タイマー終了！';

  @override
  String get timer => 'タイマー';

  @override
  String get newTimer => '新しいタイマー';

  @override
  String get timerNamePlaceholder => 'タイマー名';

  @override
  String get durationLabel => '時間';

  @override
  String get start => '開始';

  @override
  String get stop => '停止';

  @override
  String get pause => '一時停止';

  @override
  String get resume => '再開';

  @override
  String get finished => '完了！';

  @override
  String stepNumber(int number) {
    return '手順 $number';
  }

  @override
  String get minAbbreviation => '分';

  @override
  String get cookingMode => '調理モード';

  @override
  String get endAll => 'すべて終了';

  @override
  String get end => '終了';

  @override
  String get noActiveTimers => '動作中のタイマーはありません';

  @override
  String get noActiveRecipes => '調理中のレシピはありません';

  @override
  String get startRecipeToCook => 'レシピを開き、調理モードボタンをタップして始めましょう。';

  @override
  String get browseRecipes => 'レシピを見る';

  @override
  String get cookFriends => '友達と料理';

  @override
  String get cookingModeAddRecipe => 'レシピを追加';

  @override
  String get cookingModeAddRecipeSearchHint => 'レシピを検索';

  @override
  String get cookFriendsCode => 'セッションコード';

  @override
  String get cookFriendsJoin => 'セッションに参加';

  @override
  String get cookFriendsHost => 'セッションを開始';

  @override
  String get cookFriendsHostNotFound =>
      'ホストが見つかりません。両方の端末が同じ Wi-Fi に接続され、ローカルネットワークへのアクセスが許可されていることを確認してください。';

  @override
  String get cookFriendsConnectionFailed => '接続できませんでした。もう一度お試しください。';

  @override
  String get cookFriendsEnterCode => 'コードを入力';

  @override
  String cookFriendsConnected(int count) {
    return '接続中：$count 人のゲスト';
  }

  @override
  String get joinSession => 'セッションに参加';

  @override
  String get hostEndedSessionMessage => 'ホストが調理セッションを終了しました。';

  @override
  String get addItem => 'アイテムを追加';

  @override
  String get itemNote => 'アイテム名';

  @override
  String get unlabeledCategory => 'ラベルなし';

  @override
  String get archivedLists => '📦 アーカイブ済みの買い物';

  @override
  String get postimportAction => '取り込み後';

  @override
  String get postimportHint =>
      '取り込んだ項目を元のアプリ（リマインダー / Google Tasks）でどうするか選んでください。';

  @override
  String get postimportLeave => '追加のみ';

  @override
  String get postimportComplete => '完了にする';

  @override
  String get postimportCompleteDelete => '完了にして削除';

  @override
  String get postimportFailed => '元のアプリでの後処理に失敗しました。アイテムは Mealie に追加されています。';

  @override
  String get syncChangesTitle => '変更を同期';

  @override
  String get syncSectionChecked => 'チェック済み';

  @override
  String get syncSectionQuantity => '分量';

  @override
  String get syncSectionCategory => 'カテゴリ';

  @override
  String get syncSectionAdditions => '新規追加';

  @override
  String get syncLocalLabel => 'ローカル';

  @override
  String get syncServerLabel => 'サーバー';

  @override
  String get syncNow => '今すぐ同期';

  @override
  String get offlineBadge => 'オフライン';

  @override
  String get mealplanTitle => '📅 献立';

  @override
  String get breakfast => '朝食';

  @override
  String get lunch => '昼食';

  @override
  String get dinner => '夕食';

  @override
  String get addMealEntry => '食事を追加';

  @override
  String get selectRecipe => 'レシピを選択';

  @override
  String get importRecipe => 'レシピをインポート';

  @override
  String get url => 'URL';

  @override
  String get importLanguage => 'OCR の言語';

  @override
  String get setupTitle => 'Mealie Recipes へようこそ';

  @override
  String get setupSubtitle => 'Mealie サーバーを設定してください。';

  @override
  String get serverUrl => 'サーバー URL';

  @override
  String get serverUrlPlaceholder => 'https://mealie.example.com';

  @override
  String get apiToken => 'APIトークン';

  @override
  String get apiTokenPlaceholder => 'API トークン';

  @override
  String get householdId => '世帯';

  @override
  String get householdIdPlaceholder => '家族';

  @override
  String get shoppingListId => '買い物リスト ID';

  @override
  String get setupHouseholdListTitle => '世帯と買い物リスト';

  @override
  String get shoppingListLabel => '買い物リスト';

  @override
  String get setupHouseholdManualHint => '世帯を読み込めませんでした — 世帯名を手動で入力してください。';

  @override
  String get setupExactTitle => '買い物リストの分量';

  @override
  String get setupExactBody =>
      '多くの国ではグラム単位では買い物をしません — カートに入れるのはバター 200 g ではなく 1 箱です。そのためシンプルモードではレシピの分量を「1×」に変換します。正確モードでは数量と単位を Mealie ウェブアプリと同じく 1:1 で保持します — 新しいアイテムを入力するときも（例：「200 g バター」）。設定でいつでも変更できます。';

  @override
  String get setupExactSimpleTitle => 'シンプルモード（1×）';

  @override
  String get setupExactSimpleBody =>
      '材料は「1× アイテム」としてリストに入ります — 店でさっとチェックするのに最適です。';

  @override
  String get setupExactExactTitle => '正確な分量';

  @override
  String get setupExactExactBody =>
      'アイテムは数量と単位付きで表示されます（例：「200 g バター」）— ウェブアプリと同じです。';

  @override
  String get connect => '接続';

  @override
  String connectionError(String error) {
    return '接続に失敗しました：$error';
  }

  @override
  String get optionalHeaders => '任意の HTTP ヘッダー（リバースプロキシ用）';

  @override
  String get settingsTitle => '⚙️ 設定';

  @override
  String get settingsSaved => '設定を保存しました';

  @override
  String get securitySettings => 'セキュリティ';

  @override
  String get showRecipeImages => 'レシピ画像を表示';

  @override
  String get apiVersion => 'API バージョン';

  @override
  String get language => '言語設定';

  @override
  String get biometricLock => '生体認証ロック';

  @override
  String get biometricLockDescription => '生体認証でアプリのロックを解除';

  @override
  String get enableLogging => 'ログを有効にする';

  @override
  String get selectLanguage => '言語を選択';

  @override
  String get setupContinue => '続ける';

  @override
  String get back => '戻る';

  @override
  String get setupConnectStep => 'サーバーに接続';

  @override
  String get resetSettings => 'すべての設定をリセット';

  @override
  String get resetSettingsConfirm => 'すべての設定がリセットされます。続けますか？';

  @override
  String get guestMode => 'ゲストモード';

  @override
  String get appVersion => 'バージョン';

  @override
  String get leftoverFinder => 'レシピ検索';

  @override
  String get addIngredient => '材料を追加';

  @override
  String get biometricPrompt => 'Mealie Recipes を開くには認証してください';

  @override
  String get biometricFailed => '認証に失敗しました';

  @override
  String get pendingRecipesTitle => '受け取ったレシピ';

  @override
  String pendingRecipesFrom(Object names) {
    return '$names から';
  }

  @override
  String get pendingRecipesOpenCooking => '調理モードを開く';

  @override
  String get dismiss => '閉じる';

  @override
  String get editRecipe => 'レシピを編集';

  @override
  String get recipeName => 'レシピ名';

  @override
  String get prepTime => '下準備時間（分）';

  @override
  String get cookTime => '調理時間（分）';

  @override
  String get totalTime => '合計時間（分）';

  @override
  String get recipeServings => '人前';

  @override
  String get rating => '評価';

  @override
  String get addIngredientLine => '材料を追加';

  @override
  String get addInstruction => '手順を追加';

  @override
  String get removeIngredient => '材料を削除';

  @override
  String get removeInstruction => '手順を削除';

  @override
  String get ingredientName => '材料';

  @override
  String get ingredientQuantity => '数量';

  @override
  String get ingredientUnit => '単位';

  @override
  String get ingredientNote => '備考';

  @override
  String get instructionText => '手順の本文';

  @override
  String get categories => 'カテゴリ';

  @override
  String get saveChanges => '変更を保存';

  @override
  String get saveSuccess => 'レシピを保存しました。';

  @override
  String get newCategory => '新しいカテゴリ';

  @override
  String get newTag => '新しいタグ';

  @override
  String get setRating => '評価を付ける';

  @override
  String get homeWelcome => 'Mealie Recipes へようこそ！ 👋';

  @override
  String homeWelcomeNamed(String name) {
    return '$nameさん、Mealie Recipes へようこそ！ 👋';
  }

  @override
  String get shopping => '買い物';

  @override
  String get planning => '計画';

  @override
  String get other => 'その他';

  @override
  String get addRecipe => '➕ レシピを追加';

  @override
  String get completeShopping => '買い物を完了';

  @override
  String get shoppingCompleted => '買い物完了';

  @override
  String get shoppingCompletedSubtitle => '全部カートに入りました！ 🎉';

  @override
  String get shoppingOfflineNoCache => 'オフライン – リストは保存されていません';

  @override
  String get shoppingOfflineNoCacheSubtitle =>
      'このリストのアイテムはまだこの端末に保存されていません。オンラインに戻るとすぐに読み込まれます。';

  @override
  String get essensplan => '📅 献立';

  @override
  String get resteverwertung => '🥗 レシピ検索';

  @override
  String get copyCode => 'コードをコピー';

  @override
  String get shareLink => 'リンクを共有';

  @override
  String get connectedFriends => '接続中の友達';

  @override
  String get waitingForFriends => '友達を待っています...';

  @override
  String get sessionCode => 'セッションコード';

  @override
  String get loading => '読み込み中...';

  @override
  String get urlInvalidScheme => 'URL は http:// または https:// で始まる必要があります';

  @override
  String get urlAddScheme => 'https:// を追加';

  @override
  String get addItemPlaceholder => 'アイテムを追加...';

  @override
  String get completedItems => '完了済み';

  @override
  String get completeShoppingTitle => '買い物を完了しますか？';

  @override
  String get completeShoppingMessage => '完了済みのアイテムを削除しますか？';

  @override
  String get recipeListTitle => '📖 レシピ';

  @override
  String get importRecipeTitle => '新しいレシピをアップロード';

  @override
  String get uploadRecipeUrl => 'レシピ URL からインポート';

  @override
  String get uploadRecipeUrlHint => 'レシピの URL を入力してサーバーに保存します';

  @override
  String get uploadOpenAI => 'OpenAI でファイルからインポート';

  @override
  String get uploadOpenAIHint =>
      'レシピの写真や PDF をアップロードすることもできます。複数ページにわたる場合は複数追加してください — AI がまとめて解析します。';

  @override
  String get takePhoto => 'カメラ';

  @override
  String get cameraPermissionDenied =>
      'カメラへのアクセスがありません。レシピを撮影するにはシステム設定で許可してください。';

  @override
  String get cameraUnavailable => 'この端末にはカメラがありません。';

  @override
  String get selectPhoto => '写真';

  @override
  String get selectPdf => 'PDF';

  @override
  String get openAIHintTitle => 'ファイル解析について';

  @override
  String get openAIHintBody =>
      'レシピ解析には OpenAI API を使用します。Mealie サーバーの設定で API キーが構成されていることを確認してください。';

  @override
  String get allDeleteConfirm => 'すべて削除';

  @override
  String get entriesInOtherWeeks => '他の週にエントリーがあります';

  @override
  String get availableWeeks => '利用可能な週：';

  @override
  String get currentWeek => '今週';

  @override
  String get weekAbbreviation => '週';

  @override
  String get today => '今日';

  @override
  String get selectDate => '日付を選択';

  @override
  String get selectedRecipe => '選択したレシピ';

  @override
  String get confirmMeal => '食事を予定';

  @override
  String get searchRecipes => 'レシピを検索';

  @override
  String get addCustomMeal => '自由入力の食事を追加';

  @override
  String get diceModeButton => 'ランダムなレシピ';

  @override
  String get diceModeTitle => 'ランダムな提案 3 件';

  @override
  String get diceBackToSearch => '検索に戻る';

  @override
  String get diceNotEnoughRecipes => 'サイコロモードにはレシピが足りません（3 件以上必要）';

  @override
  String get entrySingular => '件';

  @override
  String get entriesPlural => '件';

  @override
  String get deleteAllConfirmTitle => 'すべて削除しますか？';

  @override
  String get deleteAllConfirmMessage => 'アーカイブ済みの買い物をすべて削除しますか？';

  @override
  String get uploadFromUrlButton => 'URL からレシピをインポート';

  @override
  String get uploadingImage => 'アップロード中...';

  @override
  String get uploadErrorTitle => 'アップロードに失敗しました';

  @override
  String get uploadSuccessTitle => 'アップロードしました';

  @override
  String get editImportedRecipeQuestion => '新しいレシピを今すぐ編集しますか？';

  @override
  String get notNow => '後で';

  @override
  String get pdfTooLarge => 'PDF ファイルが大きすぎます（最大 10 MB）。';

  @override
  String get invalidUrl => '無効な URL です。有効な HTTP(S) URL を入力してください。';

  @override
  String get cookWithFriends => '友達と料理';

  @override
  String get cookFriendsSubtitle => '友達を招待してこのレシピを一緒に作りましょう';

  @override
  String get copied => 'コピーしました';

  @override
  String get linkCopied => 'リンクをコピーしました';

  @override
  String get startCooking => '料理を始める';

  @override
  String get uploadToOwnServer => '自分のサーバーに保存';

  @override
  String get uploadingRecipe => 'レシピをアップロード中…';

  @override
  String get recipeUploadedToOwnServer => 'レシピをサーバーに保存しました';

  @override
  String get recipeUploadFailed => 'アップロードに失敗しました';

  @override
  String get allowGuestSaveRecipes => 'ゲストが自分のサーバーにレシピを保存できるようにする';

  @override
  String get appIcon => 'アプリアイコン';

  @override
  String get name => '名前';

  @override
  String get color => '色';

  @override
  String get randomColor => 'ランダムな色';

  @override
  String get createFailed => '作成できませんでした';

  @override
  String get deleteFailed => '削除できませんでした';

  @override
  String deleteOrganizerConfirm(String name) {
    return '「$name」を削除しますか？サーバーからも削除されます。';
  }

  @override
  String get connectionSection => '接続';

  @override
  String get token => 'トークン';

  @override
  String get advancedOptions => '詳細オプション';

  @override
  String get mealieApiVersion => 'Mealie API バージョン';

  @override
  String get sendOptionalHeaders => '任意のヘッダーを送信';

  @override
  String get offlineRecipeImages => 'レシピ画像をオフライン保存';

  @override
  String get offlineRecipeImagesHint =>
      '手順やメモ内の画像も含め、すべてのレシピ画像を端末にダウンロードし、接続なしでも表示できるようにします。大きなコレクションでは数百 MB になることがあります。オフにすると保存した画像は削除されます。';

  @override
  String offlineRecipeImagesStatus(int count, int total, String size) {
    return '保存済み：$count/$total · $size';
  }

  @override
  String get offlineRecipeImagesDisableConfirm => '保存したレシピ画像をすべて削除しますか？';

  @override
  String headerNameLabel(int n) {
    return 'ヘッダー $n の名前';
  }

  @override
  String headerValueLabel(int n) {
    return 'ヘッダー $n の値';
  }

  @override
  String get value => '値';

  @override
  String get personalization => 'カスタマイズ';

  @override
  String get showRecipeImagesSubtitle => 'レシピ一覧に画像を表示します';

  @override
  String get exactQuantities => '正確な分量で追加';

  @override
  String get exactQuantitiesSubtitle =>
      '材料や入力したアイテムは、1 アイテムにつき 1× ではなく数量と単位を保持します（例：200 g バター）';

  @override
  String get remindToShop => '買い物をリマインド';

  @override
  String get remindToShopSubtitle =>
      '保存した場所の近くにいて、買い物リストに未完了のアイテムがあるときに通知します — アプリを閉じていても';

  @override
  String get shoppingReminderAddLocation => '場所を追加';

  @override
  String get shoppingReminderMaxLocations => '最大 3 か所に達しました';

  @override
  String get shoppingReminderLocationServiceDisabled => 'この端末では位置情報サービスがオフです';

  @override
  String get shoppingReminderPermissionTitle => '位置情報へのアクセスが必要です';

  @override
  String get shoppingReminderPermissionMessage =>
      'お店の近くでリマインドするには、位置情報へのアクセスを「常に」にする必要があります — アプリを閉じていても。設定で有効にしてください。';

  @override
  String get openSettings => '設定を開く';

  @override
  String get shoppingReminderLocationName => '名前';

  @override
  String get shoppingReminderUseCurrentLocation => '現在地を使用';

  @override
  String get shoppingReminderOrAddress => 'または住所を入力';

  @override
  String get shoppingReminderAddress => '住所';

  @override
  String get shoppingReminderAddressPlaceholder => '番地、市区町村';

  @override
  String get shoppingReminderSearchAddress => '検索';

  @override
  String get shoppingReminderLocationFailed => '現在地を特定できませんでした';

  @override
  String get shoppingReminderAddressNotFound => '住所が見つかりません';

  @override
  String get ratingFailed => '評価を保存できませんでした — もう一度お試しください。';

  @override
  String get lastCooked => '最後に作った日';

  @override
  String get syncLastCooked => '「最後に作った日」を更新';

  @override
  String get syncLastCookedSubtitle =>
      '今日の日付とタイムラインのエントリーをサーバーに保存します — Mealie ウェブアプリと同じです。';

  @override
  String get developer => '開発者';

  @override
  String get enableLoggingSubtitle => '出力/エラーログを記録します（最新 500 行）';

  @override
  String get entriesLabel => 'エントリー';

  @override
  String get fileSize => 'ファイルサイズ';

  @override
  String get showAction => '表示';

  @override
  String get copy => 'コピー';

  @override
  String logsWithCount(int count) {
    return 'ログ（$count）';
  }

  @override
  String get noLogs => 'ログはありません';

  @override
  String get logsTitle => 'ログ';

  @override
  String get required => '必須';

  @override
  String get connectionFailedCheck => '接続に失敗しました。URL とトークンを確認してください。';

  @override
  String get username => 'ユーザー名';

  @override
  String get password => 'パスワード';

  @override
  String get setupPasswordHint =>
      'パスワードは保存されません — アプリは一度ログインして API トークンを生成します（ウェブアプリのプロフィール → API トークンと同じ）。';

  @override
  String get loginAndConnect => 'ログインして接続';

  @override
  String get loginInvalidCredentials => 'ユーザー名またはパスワードが正しくありません。';

  @override
  String get apiTokenSaveHint => 'トークンを適用しました — 下の「変更を保存」をタップしてください。';

  @override
  String get renewApiToken => 'API トークンを更新';

  @override
  String get setupAuthChoiceTitle => 'どの方法でサインインしますか？';

  @override
  String get authModePasswordTitle => 'アプリに API キーを作成してもらう';

  @override
  String get authModePasswordSubtitle =>
      'ユーザー名とパスワードでサインイン — アプリが自動でトークンを生成します。';

  @override
  String get authModeTokenTitle => 'API キーを持っている';

  @override
  String get authModeTokenSubtitle => 'Mealie のプロフィールからコピー（プロフィール → API トークン）。';

  @override
  String keyN(int n) {
    return 'キー $n';
  }

  @override
  String valueN(int n) {
    return '値 $n';
  }

  @override
  String get openCookingMode => '調理モードを開く';

  @override
  String activeRecipes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '調理中のレシピ $count 件',
    );
    return '$_temp0';
  }

  @override
  String get reparseIngredients => '材料を再解析';

  @override
  String get reparseIngredientsSubtitle => '数量/単位/材料に分割（例：「小麦粉 200 g」）';

  @override
  String get reparseDone => '材料を分割しました – 反映するには「変更を保存」をタップ';

  @override
  String get tagsAndCategories => 'タグ・カテゴリ・調理器具';

  @override
  String get tapToAddPhoto => 'タップして写真を追加';

  @override
  String get descriptionLabel => '説明';

  @override
  String get searchingDevices => '同じ Wi-Fi 上の端末を検索中…';

  @override
  String get selectAll => 'すべて選択';

  @override
  String get importReminders => 'リマインダーを取り込む';

  @override
  String get importGoogleTasks => 'Google Tasks を取り込む';

  @override
  String get noTaskLists => 'タスクリストが見つかりません';

  @override
  String get noReminderLists => 'リマインダーリストが見つかりません';

  @override
  String importCount(int count) {
    return '$count 件を取り込む';
  }

  @override
  String get noIngredientsToLink => 'リンクできる材料はまだありません';

  @override
  String get importLanguageSubtitle => '写真や PDF から取り込むレシピの言語';

  @override
  String get importLanguageSearch => '言語を検索';

  @override
  String get importLanguageFollowApp => 'アプリの言語と同じ';

  @override
  String get importLanguageNoMatch => '言語が見つかりません';

  @override
  String get setupImportLanguageTitle => 'AI によるレシピ取り込み';

  @override
  String get setupImportLanguageBody =>
      '写真や PDF は AI でレシピに変換できます。仕上がりの言語を選んでください — 母国語がアプリの言語にない場合に便利です。後から設定で変更できます。';

  @override
  String get setupImportLanguageSearchHint =>
      'アプリの画面が対応していない言語は、選択画面の検索で見つけられます。';

  @override
  String get setupCachingKeepOpenTitle => 'アプリを開いたままにしてください';

  @override
  String get setupCachingKeepOpenBody =>
      '読み込みはフォアグラウンドで行われます。完了するまでアプリを開いたままにしてください — 閉じたり長時間ほかのアプリに切り替えたりすると処理が止まり、後で最初からやり直します。';

  @override
  String get supportContact => 'サポートに問い合わせる';

  @override
  String get supportDialogMessage =>
      '問題を説明していただければ、ご連絡します。ログは原因の調査にとても役立ちます — テキストファイルとして添付できます。';

  @override
  String get supportWithoutLogs => 'ログなし';

  @override
  String get supportWithLogs => 'ログを添付';

  @override
  String get supportMailSubject => 'Mealie Recipes — サポート';

  @override
  String get supportMailHint => 'ここに問題を記入してください：';

  @override
  String get supportLogsEmpty => 'ログは空です。ログを有効にして問題を再現してから送信してください。';

  @override
  String supportAddressCopied(String email) {
    return 'アドレスをコピーしました：$email';
  }

  @override
  String supportNoMailApp(String email) {
    return 'メールアプリが設定されていません – アドレスをコピーしました：$email。別のアプリでご連絡ください。';
  }

  @override
  String get createRecipeFromImages => 'レシピを作成';

  @override
  String imagePagesSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ページを選択中',
    );
    return '$_temp0';
  }

  @override
  String get imagePagesHint => '最初の画像がレシピのメイン画像になります。ページを長押しすると並べ替えられます。';

  @override
  String get mainImageBadge => 'メイン';

  @override
  String maxImagesReached(int max) {
    return '1 つのレシピに追加できる画像は最大 $max 枚です。';
  }

  @override
  String get removePage => 'ページを削除';

  @override
  String get preparingPdf => 'PDF を処理中...';

  @override
  String get recipeOptionsTitle => 'オプション';

  @override
  String get exportAsPdf => 'PDF として書き出す';

  @override
  String get generatingPdf => 'PDF を作成中…';

  @override
  String get pdfExportFailed => 'PDF の書き出しに失敗しました';

  @override
  String get recipeTime => '時間';

  @override
  String get addIngredientSection => 'セクションを追加';

  @override
  String get aiImportToggle => 'AI で解析';

  @override
  String get aiImportToggleHint =>
      'レシピ動画（YouTube、Instagram、TikTok …）や通常のインポートで読み取れないページにも対応。Mealie サーバーに AI プロバイダーが必要です — 動画には音声プロバイダーも必要です。';

  @override
  String get aiImportButton => 'AI でインポート';

  @override
  String get aiImportRunning => 'AI がリンクを解析しています … 動画は数分かかることがあります。';

  @override
  String get aiImportFailed => 'AI インポートに失敗しました。Mealie サーバーの AI 設定を確認してください。';

  @override
  String get stepHeadingLabel => '手順の見出し（任意）';

  @override
  String get linkedRecipeLabel => 'リンクしたレシピ';

  @override
  String get toolsTitle => '調理器具';

  @override
  String get prepareTools => '次の調理器具を準備してください';

  @override
  String get newTool => '新しい調理器具';

  @override
  String get renameAction => '名前を変更';

  @override
  String get organizerEmpty => 'まだ何もありません。右上の「+」をタップして作成してください。';

  @override
  String organizerRecipeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 件のレシピ',
      zero: 'レシピなし',
    );
    return '$_temp0';
  }

  @override
  String get toolOnHand => '手持ちあり';

  @override
  String get mealDiceSettingsHint =>
      '食事ごとにカテゴリとタグを選びます。サイコロを振ると、そのいずれかを含むレシピだけが提案されます。同じ項目を複数の食事に使えます。';

  @override
  String get mealDiceSettingsNoneHint =>
      'この食事には何も選択されていません：サイコロは「朝食」「昼食」「夕食」などのカテゴリ名から自動で選びます。';

  @override
  String get mealDiceAutoHintTitle => '自動選択';

  @override
  String get mealDiceAutoHintBody =>
      'この食事にはまだカテゴリやタグが設定されていません。そのためサイコロは「朝食」「昼食」「夕食」などのカテゴリを探し、ほかのレシピで補います。\n\n自分で選ぶには：献立画面で「+」の横にある歯車アイコンをタップします。';

  @override
  String get dontShowAgain => '今後表示しない';

  @override
  String get mealDiceNoMatches => 'この食事に選んだカテゴリとタグに一致するレシピはありません。';

  @override
  String mealDiceFewMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '一致するレシピは $count 件だけです',
    );
    return '$_temp0';
  }

  @override
  String get commentsTitle => 'コメント';

  @override
  String get commentHint => 'コメントを書く…';

  @override
  String get commentSaveFailed => 'コメントを保存できませんでした。';

  @override
  String get commentDeleteConfirm => 'このコメントを削除しますか？';

  @override
  String get cookingDoneCommentLabel => 'コメント（任意）';

  @override
  String get cookingDoneCommentHint => '仕上がりはどうでしたか？次回へのヒント…';

  @override
  String get nutritionTitle => '栄養';

  @override
  String get nutritionPerServing => '1 人前あたり';

  @override
  String get nutritionCalories => 'カロリー';

  @override
  String get nutritionFat => '脂質';

  @override
  String get nutritionSaturatedFat => '飽和脂肪酸';

  @override
  String get nutritionTransFat => 'トランス脂肪';

  @override
  String get nutritionUnsaturatedFat => '不飽和脂肪';

  @override
  String get nutritionCholesterol => 'コレステロール';

  @override
  String get nutritionSodium => 'ナトリウム';

  @override
  String get nutritionCarbohydrates => '炭水化物';

  @override
  String get nutritionFiber => '食物繊維';

  @override
  String get nutritionSugar => '糖質';

  @override
  String get nutritionProtein => 'タンパク質';

  @override
  String get timelineTitle => 'タイムライン';

  @override
  String get timelineMadeThis => '作りました';

  @override
  String timelineUserMadeThis(String name) {
    return '$nameさんが作りました';
  }

  @override
  String get timelineEmpty => 'タイムラインにはまだエントリーがありません。';

  @override
  String get timelineDate => '日付';

  @override
  String get timelineNoteHint => 'メモ（任意）';

  @override
  String get timelineAddPhoto => '写真を追加';

  @override
  String get timelineRemovePhoto => '写真を削除';

  @override
  String get timelineSaved => 'タイムラインに追加しました';

  @override
  String get timelineSaveFailed => 'タイムラインに追加できませんでした';

  @override
  String get timelineImageFailed => 'エントリーは保存しましたが、写真をアップロードできませんでした';

  @override
  String get timelineDeleteConfirm => 'このエントリーをタイムラインから削除しますか？';

  @override
  String get timelineEditNote => 'メモを編集';

  @override
  String get timelineUnknownRecipe => 'レシピが見つかりません';

  @override
  String get cookingDonePhotoHint => 'Mealie タイムライン用の写真（任意）';

  @override
  String get assetsTitle => '添付ファイル';

  @override
  String get assetsAdd => '添付ファイルを追加';

  @override
  String get assetsChooseFile => 'ファイル';

  @override
  String get assetsUploading => 'アップロード中…';

  @override
  String get assetsUploadFailed => '添付ファイルをアップロードできませんでした';

  @override
  String assetsDeleteConfirm(String name) {
    return '「$name」を添付ファイルから削除しますか？';
  }

  @override
  String get assetsOpenFailed => '添付ファイルを開けませんでした';

  @override
  String get assetsUnsupported =>
      'Mealie が対応しているのは PDF、画像、TXT、MD、CSV、JSON のみです。';

  @override
  String get assetsShare => '共有';

  @override
  String get mealRulesTitle => 'Mealie のルール';

  @override
  String get mealRulesHint =>
      'Mealie ウェブアプリでも使われます。曜日と食事に複数のルールが当てはまる場合、すべてを満たす必要があります。当てはまるルールがなければ、サイコロはすべてのレシピから選びます。';

  @override
  String get mealRuleAdd => 'ルールを追加';

  @override
  String get mealRuleNewTitle => '新しいルール';

  @override
  String get mealRuleEditTitle => 'ルールを編集';

  @override
  String get mealRuleDay => '曜日';

  @override
  String get mealRuleAnyDay => 'すべての曜日';

  @override
  String get mealRuleMealType => '食事';

  @override
  String get mealRuleAnyMeal => 'すべての食事';

  @override
  String get mealRuleConditionsTitle => '条件';

  @override
  String get mealRuleAllRecipes => 'すべてのレシピ';

  @override
  String get mealRuleDeleteConfirm => 'このルールを削除しますか？';

  @override
  String get mealRulesOffline => '現在 Mealie のルールを利用できません – サイコロはアプリの選択を使います。';

  @override
  String get mealRulesNoMatches => 'この食事の Mealie ルールに一致するレシピはありません。';

  @override
  String get mealTypeSide => '副菜';

  @override
  String get mealTypeSnack => '間食';

  @override
  String get mealTypeDrink => '飲み物';

  @override
  String get mealTypeDessert => 'デザート';

  @override
  String get foodsTitle => '食材';

  @override
  String get unitsTitle => '単位';

  @override
  String get newFood => '新しい食材';

  @override
  String get newUnit => '新しい単位';

  @override
  String get editFood => '食材を編集';

  @override
  String get editUnit => '単位を編集';

  @override
  String get pluralNameLabel => '複数形の名前';

  @override
  String get abbreviationLabel => '略称';

  @override
  String get pluralAbbreviationLabel => '複数形の略称';

  @override
  String get mergeAction => '統合';

  @override
  String mergeIntoTitle(String name) {
    return '「$name」を統合する先…';
  }

  @override
  String mergeConfirm(String from, String to) {
    return '「$from」を「$to」に統合します：以降すべてのレシピと買い物リストは「$to」を使い、「$from」は削除されます。';
  }

  @override
  String get mergeFailed => '統合に失敗しました';

  @override
  String foodUnitDeleteConfirm(String name) {
    return '「$name」を削除しますか？これを使っている材料は参照を失います。';
  }

  @override
  String get foodsUnitsEmpty => 'まだ項目がありません。';

  @override
  String mealRuleConditionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 件の条件',
    );
    return '$_temp0';
  }

  @override
  String get showAll => 'すべて表示';

  @override
  String get mealDiceModeTitle => 'サイコロの基準';

  @override
  String get mealDiceModeApp => 'アプリの選択';

  @override
  String get switchListTitle => 'リストを切り替え';

  @override
  String get newShoppingList => '新しい買い物リスト';

  @override
  String shoppingListDeleteConfirm(String name) {
    return '「$name」を削除しますか？中のアイテムもすべて削除されます。';
  }

  @override
  String get labelOrderTitle => 'ラベルを並べ替え';

  @override
  String get labelOrderHint => 'ドラッグで並べ替えます。このリストに適用され、Mealie ウェブアプリにも反映されます。';

  @override
  String get labelOrderEmpty => 'このリストにはまだラベルがありません。';

  @override
  String get useAsActiveList => '使用中のリストにする';

  @override
  String get activeListBadge => '使用中';

  @override
  String get foodLabelLabel => 'ラベル';

  @override
  String get foodNoLabel => 'ラベルなし';

  @override
  String get aliasesLabel => '別名';

  @override
  String get aliasAddHint => '別名を追加';

  @override
  String get foodOnHand => '世帯に在庫あり';

  @override
  String get timelineChildRecipesTitle => 'リンクしたレシピにも追加';

  @override
  String timelineMadeForRecipe(String recipe) {
    return '$recipe のために作りました';
  }

  @override
  String get timelineFilter => 'エントリーを絞り込む';

  @override
  String get timelineTypeComment => '作った記録とメモ';

  @override
  String get timelineTypeInfo => 'お知らせ';

  @override
  String get timelineTypeSystem => 'システム';

  @override
  String get listManagementTitle => '買い物リスト';

  @override
  String get managementTitle => 'その他';

  @override
  String get pinToHome => 'ホーム画面に追加';

  @override
  String get unpinFromHome => 'ホーム画面から削除';

  @override
  String homeScreenFull(int count) {
    return 'ホーム画面がいっぱいです – 最大 $count 個のタイル。先に「その他」で別のタイルを外してください。';
  }

  @override
  String get selectAction => '選択';

  @override
  String selectedCount(int count) {
    return '$count 件選択中';
  }

  @override
  String get assignLabelAction => 'ラベルを割り当て';

  @override
  String get assignLabelOverwriteHint => '選択したすべての食材のラベルを上書きします。';

  @override
  String deleteSelectedConfirm(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 件の項目を削除しますか？',
    );
    return '$_temp0';
  }

  @override
  String get seedDataAction => '既定のデータを読み込む';

  @override
  String get seedFoodsHint => '選択した言語で Mealie の既定の食材を作成します。';

  @override
  String get seedUnitsHint => '選択した言語で Mealie の既定の単位を作成します。';

  @override
  String get seedLanguageLabel => '言語設定';

  @override
  String get seedDuplicateWarning =>
      'すでに項目があります。Mealie は重複を整理しません – 後でご自身で統合してください。';

  @override
  String get seedDone => '既定のデータを作成しました';

  @override
  String get seedFailed => '既定のデータを読み込めませんでした';

  @override
  String get exportAction => 'エクスポート';

  @override
  String get substitutionsLabel => '代用品';

  @override
  String get substitutionAddHint => '代用品を追加';

  @override
  String get substitutionFoodLabel => '食材（任意）';

  @override
  String get substitutionNoteLabel => '備考（任意）';

  @override
  String get substitutionNeedOne => '食材または備考を入力してください';

  @override
  String get useAbbreviationLabel => '略称を使う';

  @override
  String get useAbbreviationHint => 'レシピで「グラム」の代わりに「g」と表示';

  @override
  String get fractionLabel => '分数で表示';

  @override
  String get fractionHint => '0.5 の代わりに ½';

  @override
  String get standardizationTitle => '標準化';

  @override
  String get standardizationHint => '換算用：この単位 1 は … に相当（例：大さじ 1 = 15 ミリリットル）。';

  @override
  String get standardQuantityLabel => '標準量';

  @override
  String get standardUnitLabel => '標準単位';

  @override
  String get standardUnitNone => 'なし';

  @override
  String get stdFluidOunce => '液量オンス（fl oz）';

  @override
  String get stdCup => 'カップ（米国）';

  @override
  String get stdOunce => 'オンス（oz）';

  @override
  String get stdPound => 'ポンド（lb）';

  @override
  String get stdMilliliter => 'ミリリットル';

  @override
  String get stdLiter => 'リットル';

  @override
  String get stdGram => 'グラム';

  @override
  String get stdKilogram => 'キログラム';

  @override
  String get labelsTitle => 'ラベル';

  @override
  String get newLabel => '新しいラベル';

  @override
  String get editLabel => 'ラベルを編集';

  @override
  String get colorLabel => '色';

  @override
  String labelDeleteConfirm(String name) {
    return '「$name」を削除しますか？アイテムと食材からこのラベルが外れます。';
  }

  @override
  String get importMenuAction => 'インポート';

  @override
  String get archivedEmpty =>
      'アーカイブ済みの買い物はまだありません。買い物の後に「買い物を完了」をタップすると、チェックしたアイテムがここに保存されます。';

  @override
  String get sectionTitleLabel => 'セクション名';

  @override
  String get clearSection => 'セクションを解除';

  @override
  String get noPermissionGeneric =>
      'Mealie でこの操作を行う権限がありません。管理者または世帯の管理者に依頼してください。';

  @override
  String get noPermissionEditRecipe =>
      'このレシピは編集できません – ロックされているか、別の世帯のものです。作成者か管理者のみ編集できます。';

  @override
  String get noPermissionDeleteRecipe => 'レシピを削除できるのは作成者か管理者だけです。';

  @override
  String get noPermissionDemoteSelf => '自分の管理者権限は外せません。';

  @override
  String get recipeLockedHint => 'ロック中 – 作成者のみ編集できます';

  @override
  String get recipeDeleteOwnerOnlyHint => '作成者か管理者のみ削除できます';

  @override
  String get organizeReadOnlyHint =>
      '閲覧のみ：作成・変更・削除には「ユーザーは食材、タグ、カテゴリを管理できます」の権限が必要です。';

  @override
  String get notesNotSavedNoPermission => 'メモは保存されませんでした – このレシピを編集する権限がありません。';

  @override
  String get userManagementTitle => 'ユーザー管理';

  @override
  String get editUserTitle => 'ユーザーの編集';

  @override
  String get fullNameLabel => '姓名';

  @override
  String get usernameLabel => 'ユーザー名';

  @override
  String get emailLabel => 'Eメール';

  @override
  String get passwordLabel => 'パスワード';

  @override
  String get householdLabel => '世帯';

  @override
  String get permissionsTitle => '権限';

  @override
  String get administratorLabel => '管理者';

  @override
  String get permCanInvite => 'ユーザーは他のユーザーをグループに招待できます';

  @override
  String get permCanManage => 'ユーザーはグループ設定を管理できます';

  @override
  String get permCanManageHousehold => 'ユーザーは世帯を管理することができます';

  @override
  String get permCanOrganize => 'ユーザーは食材、タグ、カテゴリを管理できます';

  @override
  String get advancedFeaturesLabel => '高度な機能を有効にする';

  @override
  String get passwordResetLinkAction => 'パスワードリセット用リンクを生成';

  @override
  String get resetLockedUsersAction => 'ロックされたユーザーをリセット';

  @override
  String get inviteLinkTitle => '招待リンク';

  @override
  String get inviteAction => '招待';

  @override
  String get userUpdated => 'ユーザを更新しました';

  @override
  String get createUserTitle => 'ユーザーを作成';

  @override
  String get userCreated => 'ユーザーを作成しました';

  @override
  String userDeleteConfirm(String name) {
    return '「$name」を削除しますか？アカウントは Mealie から削除されます。';
  }

  @override
  String get passwordResetLinkCopied => 'リンクをコピーしました – ユーザーに渡してください。有効期限があります。';

  @override
  String lockedUsersReset(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 人のユーザーのロックを解除しました',
      zero: 'ロック中のユーザーはいません',
    );
    return '$_temp0';
  }

  @override
  String get inviteUsesLabel => '使用回数';

  @override
  String get inviteCreated => '招待リンクを作成しました';

  @override
  String get inviteEmailHint => 'メールアドレス（任意 – Mealie が招待を送信します）';

  @override
  String get inviteEmailSent => '招待をメールで送信しました';

  @override
  String get inviteEmailFailed =>
      'メールを送信できませんでした（Mealie で SMTP は設定されていますか？）。リンクは引き続き使えます。';

  @override
  String get copyLinkAction => 'リンクをコピー';

  @override
  String get youLabel => 'あなた';

  @override
  String get membersPermissionsHint => '世帯メンバーの権限は変更できますが、自分の権限は変更できません。';

  @override
  String get householdManagementTitle => '世帯管理';

  @override
  String get householdsTitle => '世帯';

  @override
  String get createHouseholdTitle => '世帯の作成';

  @override
  String get householdNameLabel => '世帯名';

  @override
  String get householdPreferencesTitle => '世帯設定';

  @override
  String get privateHouseholdLabel => '非公開世帯';

  @override
  String get privateHouseholdHint =>
      '世帯を非公開に設定すると、すべての公開表示オプションが無効になります。これは、個々の公開表示設定よりも優先されます。';

  @override
  String get lockRecipeEditsLabel => '他の世帯からのレシピの編集をロックする';

  @override
  String get lockRecipeEditsHint =>
      '有効にすると、あなたの世帯のユーザーのみがあなたの世帯で作成されたレシピを編集できます';

  @override
  String get householdRecipePreferencesTitle => '家庭用レシピ設定';

  @override
  String get groupsTitle => 'グループ';

  @override
  String get groupLabel => 'グループ';

  @override
  String get createGroupTitle => 'グループを作成';

  @override
  String get groupNameLabel => 'グループ名';

  @override
  String get groupPreferencesTitle => 'グループ設定';

  @override
  String get privateGroupLabel => '非公開グループ';

  @override
  String get privateGroupHint =>
      'グループを非公開に設定すると、すべての公開表示オプションが無効になります。これにより、個々の公開表示設定が上書きされます。';

  @override
  String get firstDayOfWeekLabel => '週の最初の曜日';

  @override
  String get showAnnouncementsLabel => 'Mealie のお知らせを表示';

  @override
  String get recipePublicDefaultLabel => 'グループ外のユーザーにレシピの表示を許可する';

  @override
  String get recipeShowNutritionDefaultLabel => '栄養情報を表示する';

  @override
  String get recipeShowAssetsDefaultLabel => 'レシピアセットを表示';

  @override
  String get recipeLandscapeDefaultLabel => '横向き表示のデフォルト';

  @override
  String get recipeDisableCommentsDefaultLabel => 'レシピ上のユーザーのコメントを無効にする';

  @override
  String get myHouseholdSection => '自分の世帯';

  @override
  String get myGroupSection => '自分のグループ';

  @override
  String get preferencesSaved => '設定を保存しました';

  @override
  String get cannotDeleteWithUsers => 'まだユーザーがいます – 先にユーザー管理で移動または削除してください。';

  @override
  String deleteHouseholdConfirm(String name) {
    return '世帯「$name」を削除しますか？';
  }

  @override
  String deleteGroupConfirm(String name) {
    return 'グループ「$name」を削除しますか？';
  }

  @override
  String usersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 人のユーザー',
      zero: 'ユーザーなし',
    );
    return '$_temp0';
  }

  @override
  String get originalUrlLabel => '元のURL';

  @override
  String get copyTextAction => 'テキストをコピー';

  @override
  String get copiedToClipboard => 'クリップボードにコピーされました';

  @override
  String get changelogEnglishHint => 'リリースノートは英語のみです。';

  @override
  String get favoritesTitle => 'お気に入り';

  @override
  String get favoritesEmpty => 'お気に入りはまだありません。レシピのハートをタップするとここに集まります。';

  @override
  String get changelogTitle => '更新履歴';

  @override
  String get changeProfileImage => 'プロフィール画像を変更';

  @override
  String get profileImageUpdated => 'プロフィール画像を更新しました';

  @override
  String get profileImageFailed => 'プロフィール画像をアップロードできませんでした';

  @override
  String get myAccountTitle => 'マイアカウント';

  @override
  String get ownAccountHint =>
      'ここでは自分のアカウントを編集できます。ほかのユーザーは管理者と「管理」権限を持つメンバーが管理します。';

  @override
  String get changePasswordAction => 'パスワードを変更';

  @override
  String get currentPasswordLabel => '現在のパスワード';

  @override
  String get newPasswordLabel => '新しいパスワード';

  @override
  String get confirmPasswordLabel => 'パスワードの確認';

  @override
  String get passwordTooShort => '8 文字以上';

  @override
  String get passwordsDoNotMatch => 'パスワードが一致しません';

  @override
  String get passwordUpdated => 'パスワードを更新しました';

  @override
  String get passwordChangeFailed => 'パスワードを変更できませんでした';

  @override
  String passwordManagedExternally(String method) {
    return '$method でサインインしています — パスワードはそちらで変更してください。';
  }

  @override
  String get bulkAddHint => '1 行に 1 項目。';

  @override
  String bulkAddCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 件を追加',
    );
    return '$_temp0';
  }

  @override
  String get linkRecipeAction => 'レシピをリンク';

  @override
  String get useFoodAction => 'レシピの代わりに食材を使う';

  @override
  String get addSubstitutionsAction => '代用品を追加';

  @override
  String get clearSubstitutionsAction => '代用品をクリア';

  @override
  String get recipeSubstitutionsTitle => '代用品';

  @override
  String get substitutionUnknownFood => '既存の食材のみ – それ以外は備考を使ってください';

  @override
  String get insertAboveAction => '上に挿入';

  @override
  String get insertBelowAction => '下に挿入';

  @override
  String get moveToTopAction => '先頭へ移動';

  @override
  String get moveToBottomAction => '末尾へ移動';

  @override
  String get linkReferencesAction => '参照をリンク';

  @override
  String get editMarkdownAction => 'マークダウンの編集';

  @override
  String get previewMarkdownAction => 'マークダウンのプレビュー';

  @override
  String get insertStepImageAction => '画像をアップロード';

  @override
  String get mergeAboveAction => '上と結合';

  @override
  String get linkedToOtherStep => '他のステップにリンクしています';

  @override
  String get noNotesToLink => 'リンクできるメモはありません';

  @override
  String get ownerLabel => '所有者';

  @override
  String get ingredientParserTitle => '材料パーサー';

  @override
  String ingredientParserHint(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 件の材料がまだ構造化されていません。パーサーを選び、結果を確認して適用してください。',
    );
    return '$_temp0';
  }

  @override
  String get parserNlp => '自然言語処理';

  @override
  String get parserBrute => 'Bruteパーサ';

  @override
  String get parserOpenai => 'OpenAI パーサー';

  @override
  String get parserApp => 'オフライン（アプリ）';

  @override
  String get parseFailed => '解析に失敗しました';

  @override
  String get parseAction => '解析';

  @override
  String applyParsedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 件の材料を適用',
      zero: '何も選択されていません',
    );
    return '$_temp0';
  }

  @override
  String get parsedNewBadge => '新規';

  @override
  String get hoursShort => '時間';

  @override
  String get minutesShort => '分';

  @override
  String get timeExtraHint => '補足、例：「＋一晩」';

  @override
  String get yieldLabel => '人分';

  @override
  String get yieldTextLabel => '収入テキスト';

  @override
  String get prepTimeLabel => '準備時間';

  @override
  String get performTimeLabel => '調理時間';

  @override
  String get totalTimeLabel => '合計時間';

  @override
  String get settingPublicRecipe => '公開レシピ';

  @override
  String get settingShowNutrition => '栄養価を表示';

  @override
  String get settingShowAssets => '資産を表示';

  @override
  String get settingLandscapeView => 'Landscape View (Coming Soon)';

  @override
  String get settingDisableComments => 'コメントを無効にする';

  @override
  String get settingDisableAmount => '材料の分量を無効にする';

  @override
  String get settingLocked => 'ロック済み';

  @override
  String get settingLockedOwnerOnly => 'レシピのロック・解除ができるのは作成者だけです。';

  @override
  String get apiExtrasTitle => 'APIの追加';

  @override
  String get apiExtrasHint => 'サードパーティ製アプリ向けの独自のキー/値ペア（例：自動化のトリガー）。';

  @override
  String get extraKeyLabel => 'キー';

  @override
  String get extraValueLabel => '値';

  @override
  String get addExtraAction => '追加項目を追加';

  @override
  String durationHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 時間',
    );
    return '$_temp0';
  }

  @override
  String durationMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 分',
    );
    return '$_temp0';
  }

  @override
  String get discardChangesConfirm => '保存していない変更を破棄しますか？';

  @override
  String get discardChanges => '変更を破棄';

  @override
  String get imageFromUrl => 'URL から画像';

  @override
  String get deleteRecipeImage => 'レシピ画像を削除';

  @override
  String get deleteRecipeImageConfirm => 'このレシピ画像を削除してもよろしいですか？';

  @override
  String get bulkAddIngredients => '材料をまとめて追加';

  @override
  String get bulkAddSteps => '手順をまとめて追加';

  @override
  String get stepImageFailed => '画像をアップロードできませんでした';

  @override
  String get servingsAndTimes => '人数と時間';

  @override
  String get recipeSettingsTitle => 'レシピの設定';

  @override
  String get jsonEditorTitle => 'JSONエディタ';

  @override
  String get jsonInvalid => '無効な JSON です – 確認してください。';

  @override
  String get editorOfflineHint =>
      'オフラインで開いています：保存には接続が必要です。新しい Mealie の項目（代用品など）はそのまま保持されます。';

  @override
  String get parseLineFailed => '認識できません – 変更されません';

  @override
  String get createManualTitle => 'レシピを手動で作成';

  @override
  String get createManualHint => '名前を入力してください – 材料・手順・画像などは後でレシピエディターで追加できます。';

  @override
  String get createManualButton => '作成して編集';

  @override
  String get changelogEmpty => 'このバージョンの項目はまだありません。';

  @override
  String get finderDescription =>
      '手元にある材料に基づいてレシピを検索します。また、利用可能なツールでフィルタリングしたり、不足している材料やツールの最大数を設定したりすることもできます。';

  @override
  String get finderSelectedIngredients => '選択された材料';

  @override
  String get finderNoIngredientsSelected => '材料が選択されていません';

  @override
  String get finderMissing => '見つかりません';

  @override
  String get finderNoRecipesFound => 'レシピが見つかりません';

  @override
  String get finderNoRecipesFoundDescription => '検索に材料を追加するか、フィルターを調整してみてください';

  @override
  String get finderIncludeFoodsOnHand => '手元にある材料を含める';

  @override
  String get finderIncludeToolsOnHand => '手元にあるツールを含める';

  @override
  String get finderIncludeSubstitutions => '代用品を含める';

  @override
  String get finderSubstituting => '代用';

  @override
  String finderSubstituteForFood(String substitute, String food) {
    return '$food の代わりに $substitute';
  }

  @override
  String get finderMaxMissingIngredients => '不足している材料の最大数';

  @override
  String get finderMaxMissingTools => '不足しているツールの最大数';

  @override
  String get finderSelectedTools => '選択されたツール';

  @override
  String get finderReadyToMake => '準備完了';

  @override
  String get finderAlmostReadyToMake => 'ほぼ準備完了';

  @override
  String get finderSettings => '設定';

  @override
  String get finderLoadingRecipes => 'レシピを読み込み中';

  @override
  String get finderClearSelection => '選択を解除';

  @override
  String get finderOfflineHint => 'サーバーに接続できません – 結果はこの端末に保存されたレシピからです。';

  @override
  String get sendPeerOfflineHint => '現在は接続できません – 相手がアプリを開くと届きます';

  @override
  String sendDeliveredLater(String device) {
    return '「$device」には現在接続できません。相手がアプリを開くとすぐにレシピが届きます。';
  }

  @override
  String get sendQueuedOffline => '現在接続されていません。オンラインに戻るとレシピが自動で送信されます。';

  @override
  String get searchHasAll => 'すべての';

  @override
  String get searchHasAny => 'いずれかの';

  @override
  String get recipeFilterTitle => 'フィルタ';

  @override
  String get finderOtherFilters => 'その他のフィルター';

  @override
  String get qfOpEquals => '等しい';

  @override
  String get qfOpNotEquals => '等しくない';

  @override
  String get qfOpGreater => 'より大きい';

  @override
  String get qfOpGreaterEq => '以上';

  @override
  String get qfOpLess => 'より小さい';

  @override
  String get qfOpLessEq => '以下';

  @override
  String get qfOpNewerThan => 'より新しい';

  @override
  String get qfOpOlderThan => 'より古い';

  @override
  String qfDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 日前',
    );
    return '$_temp0';
  }

  @override
  String get filterResetAll => 'すべてのフィルターをリセット';

  @override
  String get filterAny => 'すべて';

  @override
  String get filterOfflineIgnored => 'オフラインでは「その他のフィルター」は単純な形式でしか適用できません。';

  @override
  String linkedRecipesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 件のリンクしたレシピ',
      zero: 'リンクしたレシピはありません',
    );
    return '$_temp0';
  }

  @override
  String get shoppingReminderNotificationsOff =>
      'Mealie Recipes の通知がオフです — 通知がないと買い物リマインダーは表示されません。設定で通知を許可してください。';

  @override
  String get shoppingReminderInactiveHint =>
      '現在、買い物リマインダーは動作できません：位置情報へのアクセスを「常に」にして、通知を許可してください。';

  @override
  String get bulkImportTitle => 'URL 一括インポート';

  @override
  String get bulkImportDescription =>
      'レシピの一括インポート機能を使用すると、バックエンドのサイトをキューに入れてバックグラウンドでタスクを実行することで、複数のレシピを一度にインポートできます。 これは、最初にMealieに移行する場合や、大量のレシピをインポートする場合に便利です。';

  @override
  String get bulkAddTitle => '一括で追加';

  @override
  String get bulkImportSetOrganizers => 'カテゴリとタグを設定';

  @override
  String get bulkImportStarted => '一括インポートの処理が開始されました';

  @override
  String get bulkImportFailed => '一括インポートの処理が失敗しました';

  @override
  String get bulkImportReports => '一括インポート';

  @override
  String get bulkImportUrlHint => 'レシピのURL';

  @override
  String get migrationsTitle => 'データ移行';

  @override
  String get migrationsDescription =>
      '対応している他のアプリから Mealie にレシピを移行できます。Mealie を始めるのに最適な方法です。Mealie インスタンス間のデータ移動や、以前の Mealie バックアップの復元には、代わりにバックアップと復元のツールを使います。';

  @override
  String get migrationNew => '新しい移行';

  @override
  String get migrationChooseType => '移行タイプを選択';

  @override
  String get noFileSelected => 'ファイルが選択されていません';

  @override
  String migrationTagAll(String tag) {
    return 'すべてのレシピに $tag タグを付ける';
  }

  @override
  String get migrationPrevious => '前回の移行';

  @override
  String get migrationMealieDescription =>
      'Mealie は v1.0 より前の Mealie アプリからレシピをインポートできます。古いインスタンスからレシピをエクスポートし、下に zip ファイルをアップロードしてください。エクスポートからインポートできるのはレシピのみです。これは v1.0 より古いインスタンスにのみ当てはまります。v1.0 以降で作成したバックアップは、バックアップと復元のツールで復元してください。';

  @override
  String get migrationChowdownDescription =>
      'Mealieはchowdownのリポジトリ形式をネイティブにサポートしています。コードリポジトリをzipファイルでダウンロードし、以下にアップロードしてください。';

  @override
  String get migrationCopyMeThatDescription =>
      'MealieはCopy Me Thatからレシピをインポートできます。レシピをHTML形式でエクスポートし、以下の.zipをアップロードしてください。';

  @override
  String get migrationMyRecipeBoxDescription =>
      'MealieはMy Recipe Boxからレシピをインポートできます。レシピをCSV形式でエクスポートし、以下に.csvをアップロードしてください。';

  @override
  String get migrationNextcloudDescription =>
      'Nextcloudレシピは、Nextcloudに保存されているデータを含むzipファイルからインポートできます。 以下のフォルダ構造の例を参照して、レシピをインポートできるようにしてください。';

  @override
  String get migrationPaprikaDescription =>
      'MealieはPaprikaアプリからレシピをインポートできます。Paprikaからレシピをエクスポートし、拡張子の名前を.zipに変更し、以下にアップロードしてください。';

  @override
  String get migrationPlanToEatDescription =>
      'Mealieはプランから食べるまでのレシピをインポートできます。';

  @override
  String get migrationRecipeKeeperDescription =>
      'MealieはRecipe Keeperからレシピをインポートできます。レシピをzip形式でエクスポートし、以下に.zipファイルをアップロードしてください。';

  @override
  String get migrationTandoorDescription =>
      'MealieはTandoorからレシピをインポートすることができます。「デフォルト」形式でデータをエクスポートし、以下に.zipをアップロードしてください。';

  @override
  String get migrationCooknDescription =>
      'Mealie は DVO Cook\'n X3 からレシピをインポートできます。料理本またはメニューを \"Cook\'n\" 形式でエクスポートし、拡張子を .zip に変更してから、下に .zip をアップロードしてください。';

  @override
  String get reportTitle => 'レポート';

  @override
  String get recipeDataTitle => 'レシピデータ';

  @override
  String get recipeDataDescription =>
      'このセクションを使用して、レシピに関連付けられたデータを管理します。レシピに対して、エクスポート、削除、タグ付け、カテゴリの割り当てなどの複数の一括アクションを実行できます。';

  @override
  String get recipeDataTagTitle => 'レシピのタグ';

  @override
  String get recipeDataCategorizeTitle => 'レシピをカテゴリ化';

  @override
  String get recipeDataSettingsTitle => '設定を更新';

  @override
  String get recipeDataExportTitle => 'レシピのエクスポート';

  @override
  String get recipeDataDeleteTitle => 'レシピを削除';

  @override
  String recipeDataExportConfirm(int count) {
    return '次のレシピ（$count）がエクスポートされます。';
  }

  @override
  String get recipeDataExportsTitle => 'データのエクスポート';

  @override
  String get recipeDataExportsDescription =>
      'このセクションには、すぐにダウンロードできる利用可能なエクスポートへのリンクが記載されています。これらのエクスポートには有効期限があるため、利用可能なうちに必ず取得してください。';

  @override
  String get recipeDataPurgeExports => 'エクスポートの削除';

  @override
  String get recipeDataPurgeConfirm => 'すべてのエクスポートデータを削除してもよろしいですか?';

  @override
  String get recipeActionsTitle => 'レシピ操作';

  @override
  String get recipeActionNew => '新しいレシピ操作';

  @override
  String get recipeActionEdit => 'レシピ操作の編集';

  @override
  String get recipeActionTypeLink => 'リンク';

  @override
  String get recipeActionTypePost => 'Post';

  @override
  String get webhooksTitle => 'Webフック';

  @override
  String get webhooksDescription =>
      '以下に定義されているWebフックは、その日の食事が定義されたときに実行されます。 スケジュールされた時間にWebフックは、その日に予定されているレシピからのデータと一緒に送信されます。 Webフックの実行は正確ではないことに注意してください。 Webフックは5分間隔で実行されるため、スケジュールされたから5分以内にWebフックが実行されます。';

  @override
  String get webhookName => 'Webフック名';

  @override
  String get webhookUrl => 'WebフックのURL';

  @override
  String get notifiersTitle => '通知';

  @override
  String get notifiersDescription =>
      'Setup email and push notifications that trigger on specific events.';

  @override
  String get notifierNew => '新着通知';

  @override
  String get notifierDescription =>
      'Mealieは、通知を生成するために、Appiseライブラリを使用します。通知に使用するサービスには多くのオプションがあります。 サービスのURLを作成する方法については、wikiを参照してください。 利用可能な場合は、通知の種類を選択すると追加機能が含まれる場合があります。';

  @override
  String get notifierAppriseUrl => 'Apprise URL';

  @override
  String get notifierAppriseUrlSkipped => '通知用URL (空欄の場合はスキップ)';

  @override
  String get notifierAppriseUrlBlankHint =>
      'Apprise URL には通常機密情報が含まれるため、編集時はこの欄を意図的に空欄にしています。URL を更新する場合はここに新しい URL を入力し、そうでなければ空欄のままにすると現在の URL が保持されます。';

  @override
  String get notifierEnable => '通知を有効にする';

  @override
  String get notifierWhatEvents => 'この通知はどのイベントを購読すべきですか？';

  @override
  String get notifierRecipeEvents => 'レシピイベント';

  @override
  String get notifierUserEvents => 'ユーザーイベント';

  @override
  String get notifierMealplanEvents => '献立のイベント';

  @override
  String get notifierShoppingListEvents => '買い物リストイベント';

  @override
  String get notifierCookbookEvents => '料理本イベント';

  @override
  String get notifierTagEvents => 'タグイベント';

  @override
  String get notifierCategoryEvents => 'カテゴリイベント';

  @override
  String get notifierLabelEvents => 'ラベルのイベント';

  @override
  String get notifierUserSignup => '新しいユーザーがグループに参加したとき';

  @override
  String get notifierCreate => '作成';

  @override
  String get notifierUpdate => '更新';

  @override
  String get notifierDelete => '削除';

  @override
  String get notifierTestSent => 'テストメッセージを送信しました';

  @override
  String get adminTitle => '管理設定';

  @override
  String get backupsTitle => 'バックアップ';

  @override
  String get backupsDescription =>
      'バックアップはサイトのデータベースとデータ ディレクトリの合計スナップショットです。これにはすべてのデータが含まれますが、データのサブセットを除外するように設定することはできません。これは、特定の時点での Mealie のスナップショットと考えることができます。これらは、データベースに依存せずにデータをエクスポートおよびインポートしたり、サイトを外部の場所にバックアップしたりする方法として機能します。';

  @override
  String get backupCreateHeading => 'Create a Backup';

  @override
  String get backupCreated => 'バックアップの作成に成功しました';

  @override
  String get backupCreateFailed => 'バックアップの作成中にエラーが発生しました。ログファイルを参照してください';

  @override
  String get backupDelete => 'バックアップを削除';

  @override
  String get backupDeleted => 'バックアップを削除しました';

  @override
  String get backupRestore => 'バックアップから復元';

  @override
  String get backupRestoreDescription =>
      'このバックアップを復元すると、データベースとデータディレクトリの現在のデータはすべてバックアップの内容で上書きされます。復元に成功するとログアウトされます。';

  @override
  String get backupCannotBeUndone => 'この操作は元に戻せません - 注意してください。';

  @override
  String get backupAcknowledge =>
      'このアクションは不可逆的で破壊的で、データ損失を引き起こす可能性があることを理解しています';

  @override
  String get backupRestoreSuccess => '復元に成功しました';

  @override
  String get backupRestoreFailed => '復元に失敗しました。詳細はサーバーのログを確認してください';

  @override
  String get maintenanceTitle => 'メンテナンス';

  @override
  String get maintenanceSummary => '概要';

  @override
  String get maintenanceStorage => 'ストレージの詳細';

  @override
  String get maintenanceDataDirSize => 'データディレクトリサイズ';

  @override
  String get maintenanceCleanableDirs => '消去可能なディレクトリ';

  @override
  String get maintenanceCleanableImages => '消去可能な画像';

  @override
  String get maintenanceTempDir => '一時ディレクトリ (.temp)';

  @override
  String get maintenanceBackupsDir => 'バックアップディレクトリ (backups)';

  @override
  String get maintenanceGroupsDir => 'グループディレクトリ (groups)';

  @override
  String get maintenanceRecipesDir => 'レシピディレクトリ (recipes)';

  @override
  String get maintenanceUserDir => 'ユーザーディレクトリ (user)';

  @override
  String get maintenanceCleanDirs => 'ディレクトリ内を消去';

  @override
  String get maintenanceCleanDirsDescription => '有効なUUIDではないレシピフォルダをすべて削除します。';

  @override
  String get maintenanceCleanTemp => '一時ファイルを消去';

  @override
  String get maintenanceCleanTempDescription =>
      '.tempディレクトリ内のすべてのファイルとフォルダを削除します';

  @override
  String get maintenanceCleanImages => '画像を消去';

  @override
  String get maintenanceCleanImagesDescription => '.webp で終わらない画像をすべて削除します。';

  @override
  String get maintenanceActions => '操作';

  @override
  String get adminConfiguration => '設定';

  @override
  String get adminAppVersion => 'アプリのバージョン';

  @override
  String get adminUpToDate => 'Mealieは最新です';

  @override
  String adminVersionOutdated(String current, String latest) {
    return '現在のバージョン（$current）は最新リリースと一致しません。最新バージョン（$latest）へのアップデートをご検討ください。';
  }

  @override
  String get adminBaseUrl => 'サーバー側のベースURL';

  @override
  String get adminBaseUrlOk => 'サーバー側のURLがデフォルトと一致しません';

  @override
  String get adminBaseUrlError =>
      '`BASE_URL` はAPIサーバーのデフォルト値です。サーバー上でメールなどの通知リンクが生成されると問題が発生します。';

  @override
  String adminAuthReady(String provider) {
    return '$provider 準備完了';
  }

  @override
  String adminAuthNotReady(String provider) {
    return '$provider 未準備';
  }

  @override
  String adminAuthDisabled(String provider) {
    return '$provider 無効';
  }

  @override
  String adminAuthSuccessText(String provider) {
    return '必要な $provider の変数はすべて設定されています。';
  }

  @override
  String adminAuthErrorText(String provider) {
    return '$provider の値がすべては設定されていません。$provider 認証を使わない場合は無視してかまいません。';
  }

  @override
  String adminAuthDisabledText(String envVar) {
    return '有効にするには $envVar を true に設定してください。';
  }

  @override
  String get adminEmailStatus => 'Eメール設定状況';

  @override
  String get adminEmailConfigured => 'Eメールが設定されました';

  @override
  String get adminNotReady => '準備ができていません - 環境変数を確認してください';

  @override
  String get adminSucceeded => '成功しました';

  @override
  String get adminFailed => '失敗しました。';

  @override
  String get adminSiteStatistics => 'サイトの統計';

  @override
  String get adminUncategorized => 'カテゴリ未設定のレシピ';

  @override
  String get adminUntagged => 'タグ未設定のレシピ';

  @override
  String get adminGeneralAbout => '概要';

  @override
  String get adminVersion => 'バージョン';

  @override
  String get adminBuild => 'ビルド';

  @override
  String get adminApplicationMode => 'アプリケーションモード';

  @override
  String get adminProduction => '本番';

  @override
  String get adminDevelopment => '開発';

  @override
  String get adminDemoStatus => '体験版ステータス';

  @override
  String get adminDemo => '体験版';

  @override
  String get adminNotDemo => '非デモ';

  @override
  String get adminApiPort => 'APIポート';

  @override
  String get adminApiDocs => 'APIドキュメント';

  @override
  String get adminDatabaseType => 'データベースタイプ';

  @override
  String get adminDatabaseUrl => 'データベース URL';

  @override
  String get adminDefaultGroup => 'デフォルトグループ';

  @override
  String get adminDefaultHousehold => '既定の世帯';

  @override
  String get adminScraperVersion => 'Recipe Scraper バージョン';

  @override
  String get adminStatUsers => 'ユーザー';

  @override
  String get adminStatHouseholds => '世帯';

  @override
  String get adminStatGroups => 'グループ';

  @override
  String get recipeDuplicate => 'レシピを複製';

  @override
  String get recipeDuplicateAction => '複製';

  @override
  String get recipeShareLink => 'レシピの共有';

  @override
  String get recipeShareExpiration => '有効期限';

  @override
  String get recipeShareCopied => 'レシピのリンクをクリップボードにコピーしました';

  @override
  String get enabledLabel => '有効';

  @override
  String get disabledLabel => '無効';

  @override
  String get testAction => 'テスト';

  @override
  String get yesLabel => 'はい';

  @override
  String get noLabel => 'いいえ';

  @override
  String get downloadAction => 'ダウンロード';

  @override
  String get backupUpload => 'アップロード';

  @override
  String get zipImportButton => 'Zipからインポート';

  @override
  String get zipImportDescription =>
      '別のMealieインスタンスからエクスポートされた1つのレシピをインポートします。';

  @override
  String get reportStatus => '状態';

  @override
  String get reportDate => '日付';

  @override
  String get recipeActionTitleLabel => 'タイトル';

  @override
  String get clearAll => 'クリア';

  @override
  String get recipeDataSettingsExplanation =>
      'ここで選択した設定は、ロックされたオプションを除き、選択したすべてのレシピに適用されます。';

  @override
  String get adminAllowSignup => '新規登録を許可';

  @override
  String get adminAllowPasswordLogin => 'パスワードログインを許可';

  @override
  String get adminEmailInvalid => '有効なメールアドレスを入力してください。';

  @override
  String adminEmailTestResult(String result) {
    return 'メールテスト：$result';
  }

  @override
  String get adminSendTestEmail => 'テストメールを送信';

  @override
  String get adminTestEmailAddress => '宛先';

  @override
  String get backupCreate => 'バックアップを作成';

  @override
  String backupDeleteConfirm(String name) {
    return 'バックアップ「$name」を削除しますか？';
  }

  @override
  String get backupPostgresNote =>
      'PostgreSQL を使っている場合は、復元の前に Mealie ドキュメントのバックアップ/復元手順をお読みください。';

  @override
  String get backupUploaded => 'バックアップをアップロードしました';

  @override
  String get backupsEmpty => 'バックアップはまだありません。';

  @override
  String get bulkImportAddRow => 'URL を追加';

  @override
  String get bulkImportStart => 'インポートを開始';

  @override
  String get chooseFileButton => 'ファイルを選択';

  @override
  String get deselectAllAction => 'すべての選択を解除';

  @override
  String get downloadFailed => 'ダウンロードに失敗しました';

  @override
  String get fileSaved => 'ファイルを保存しました';

  @override
  String get loadFailed => '読み込めませんでした';

  @override
  String get maintenanceActionsWarning =>
      'メンテナンス操作は破壊的なため、慎重に使用してください。これらの操作は元に戻せません。';

  @override
  String get maintenanceConfirm => 'この操作は破壊的で、元に戻せません。続けますか？';

  @override
  String get maintenanceDone => '完了';

  @override
  String get maintenanceFailed => 'メンテナンス操作に失敗しました';

  @override
  String get maintenanceRun => '実行';

  @override
  String get migrationFailed => '移行に失敗しました';

  @override
  String get migrationStart => '移行を開始';

  @override
  String get migrationStarted => '移行が完了しました — 下のレポートをご覧ください。';

  @override
  String get moreImportOptions => 'その他のインポート方法';

  @override
  String notifierDeleteConfirm(String name) {
    return '通知「$name」を削除しますか？';
  }

  @override
  String get notifierEdit => '通知を編集';

  @override
  String notifierEventCount(int count) {
    return 'イベント：$count';
  }

  @override
  String get notifierTestFailed => 'テストメッセージを送信できませんでした';

  @override
  String get notifiersEmpty => '通知はまだありません。';

  @override
  String recipeActionDeleteConfirm(String name) {
    return 'レシピアクション「$name」を削除しますか？';
  }

  @override
  String get recipeActionFailed => 'レシピアクションに失敗しました';

  @override
  String get recipeActionSent => 'レシピを送信しました';

  @override
  String get recipeActionUrlHint => 'プレースホルダー';

  @override
  String get recipeActionsDescription =>
      'レシピアクションはすべてのレシピのメニューに表示されます。「リンク」は URL を開き、「Post」は Mealie サーバーからその URL にレシピを送信します。';

  @override
  String get recipeActionsEmpty => 'レシピアクションはまだありません。';

  @override
  String recipeDataDeleteConfirm(int count) {
    return '選択したレシピ（$count）を削除しますか？この操作は元に戻せません。';
  }

  @override
  String recipeDataDeleteForbidden(int count) {
    return '選択したレシピのうち $count 件は削除できません（作成者か管理者のみ削除できます）。';
  }

  @override
  String recipeDataDeleted(int count) {
    return '削除したレシピ：$count';
  }

  @override
  String get recipeDataExportAction => 'エクスポート';

  @override
  String get recipeDataExportDone => 'エクスポートを作成しました — データエクスポートからダウンロードしてください。';

  @override
  String recipeDataExportExpires(String date) {
    return '$date に期限切れ';
  }

  @override
  String get recipeDataExportFailed => 'エクスポートに失敗しました';

  @override
  String get recipeDataExportsEmpty => '利用できるエクスポートはありません。';

  @override
  String recipeDataUpdated(int count) {
    return '更新したレシピ：$count';
  }

  @override
  String get recipeDuplicated => 'レシピを複製しました';

  @override
  String get recipeExportJson => 'JSON として書き出す';

  @override
  String get recipeExportZip => 'ZIP として書き出す（画像付き）';

  @override
  String get recipeShareCreate => 'リンクを作成';

  @override
  String get recipeShareDescription =>
      'リンクを知っている人は誰でも、期限が切れるまでアカウントなしでブラウザーからこのレシピを閲覧できます。';

  @override
  String get recipeShareEmpty => '共有リンクはまだありません。';

  @override
  String recipeShareExpiresAt(String date) {
    return '$date に期限切れ';
  }

  @override
  String get recipeWebToolsMenu => '複製・共有リンクなど';

  @override
  String get reload => '再読み込み';

  @override
  String get reportDeleteConfirm => 'このレポートを削除しますか？';

  @override
  String get reportEntries => 'エントリー';

  @override
  String get reportFailedEntries => '失敗しました。';

  @override
  String get reportOnlyFailed => '失敗したエントリーのみ表示';

  @override
  String get reportStatusFailure => '失敗';

  @override
  String get reportStatusInProgress => '処理中';

  @override
  String get reportStatusPartial => '一部';

  @override
  String get reportStatusSuccess => '成功';

  @override
  String get reportsEmpty => 'レポートはまだありません。';

  @override
  String get uploadFailed => 'アップロードに失敗しました';

  @override
  String webhookDeleteConfirm(String name) {
    return 'Webhook「$name」を削除しますか？';
  }

  @override
  String get webhookEdit => 'Webhook を編集';

  @override
  String get webhookNew => '新しい Webhook';

  @override
  String get webhookTestFailed => 'テストを開始できませんでした';

  @override
  String get webhookTestSent => 'テスト Webhook を実行しました';

  @override
  String get webhookTime => '時刻（現地）';

  @override
  String get webhooksEmpty => 'Webhook はまだありません。';

  @override
  String get zipImportFailed => 'ZIP のインポートに失敗しました';

  @override
  String get aiProvidersTitle => 'AI プロバイダー';

  @override
  String get aiProvidersDescription =>
      'AI プロバイダーを設定すると、材料の高度な解析や動画からのレシピ作成などの AI 機能が使えるようになります！';

  @override
  String get aiProviderSettingsTitle => 'AI プロバイダー設定';

  @override
  String get aiProvidersList => 'プロバイダー';

  @override
  String get aiProviderCreate => 'プロバイダーを作成';

  @override
  String get aiProviderEdit => 'プロバイダーを編集';

  @override
  String get aiDefaultProvider => '既定のプロバイダー';

  @override
  String get aiDefaultProviderDescription => 'AI 機能を有効にするために必要です';

  @override
  String get aiAudioProvider => '音声プロバイダー';

  @override
  String get aiAudioProviderDescription => '動画からのレシピ作成など、音声の文字起こし機能を有効にします';

  @override
  String get aiImageProvider => '画像プロバイダー';

  @override
  String get aiImageProviderDescription => '画像からのレシピ作成など、画像認識機能を有効にします';

  @override
  String get aiProviderName => 'プロバイダー名';

  @override
  String get aiApiKey => 'API キー';

  @override
  String get aiApiKeyCreateDescription =>
      '認証用のプロバイダーの API キーです。サービス（例：Ollama）が API キーを使わない場合でも、ここに何か入力する必要があります。';

  @override
  String get aiApiKeyEditDescription => '変更しない場合は空欄のままにしてください。';

  @override
  String get aiBaseUrl => 'ベース URL';

  @override
  String get aiBaseUrlDescription =>
      'OpenAI を使う場合は空欄にしてください。OpenAI 互換のエンドポイントである必要があります（例：\"http://localhost:11434/v1\"）。';

  @override
  String get aiModel => 'モデル';

  @override
  String get aiModelDescription => 'AI プロバイダーが使うモデル（例：\"gpt-5\"）。';

  @override
  String get aiTimeout => 'リクエストのタイムアウト（秒）';

  @override
  String get aiProviderCreated => 'プロバイダーを作成しました';

  @override
  String get aiProviderUpdated => 'プロバイダーを更新しました';

  @override
  String get aiProviderDeleted => 'プロバイダーを削除しました';

  @override
  String get aiProviderCreateFailed => 'プロバイダーを作成できませんでした';

  @override
  String get aiProviderUpdateFailed => 'プロバイダーを更新できませんでした';

  @override
  String get aiProviderDeleteFailed => 'プロバイダーを削除できませんでした';

  @override
  String get aiRequestHeaders => 'リクエストヘッダー';

  @override
  String get aiRequestParams => 'リクエストパラメーター';

  @override
  String get aiNoDefaultWarning => '既定のプロバイダーが設定されていないため、AI 機能は無効です';

  @override
  String get aiTestConnection => '接続をテスト';

  @override
  String get aiTestSucceeded => '接続に成功しました';

  @override
  String get aiTestFailed => '接続に失敗しました';

  @override
  String get aiSupportsImages => '画像に対応';

  @override
  String get aiTextOnly => 'テキストのみ。画像プロバイダーにはできません';

  @override
  String get debugAiTitle => 'AI プロバイダーのデバッグ';

  @override
  String get debugAiDescription =>
      'このページで AI プロバイダーをデバッグできます。AI 接続をテストして結果を確認できます。画像サービスが有効なら画像も指定できます。';

  @override
  String get debugParserTitle => '構文解析';

  @override
  String get debugParserDescription =>
      'Mealieは、材料の解析と処理に条件付きランダムフィールド (CRF) を使用します。成分に使用されるモデルは、ニューヨークタイムズが編集したデータセットからの100,000を超える成分のデータ セットに基づいています。モデルは英語のみでトレーニングされるため、他の言語でモデルを使用すると異なる結果が生じる可能性があることに注意してください。このページはモデルをテストするためのプレイグラウンドです。';

  @override
  String get debugIngredientText => '材料テキスト';

  @override
  String get debugTryExample => '例を試してみる';

  @override
  String debugAverageConfidence(String value) {
    return '信頼度 $value';
  }

  @override
  String get debugRunTest => 'テスト実行';

  @override
  String get debugQuantity => '分量';

  @override
  String get debugUnit => '単位';

  @override
  String get debugFood => '食料';

  @override
  String get debugNote => 'コメント';

  @override
  String get debugGroup => 'グループ';

  @override
  String get aiProviderNone => 'なし';

  @override
  String aiProviderDeleteConfirm(String name) {
    return 'プロバイダー「$name」を削除しますか？';
  }

  @override
  String get aiProvidersEmpty => 'AI プロバイダーはまだありません。';

  @override
  String get aiAdvanced => '詳細';

  @override
  String get aiKeyLabel => '名前';

  @override
  String get aiValueLabel => '値';

  @override
  String get debugTitle => 'デバッグ';

  @override
  String get debugParse => '解析';

  @override
  String get debugParseFailed => '材料を解析できませんでした';

  @override
  String get debugChooseImage => '画像を選択';

  @override
  String get debugNoImage => '画像なし（任意）';

  @override
  String get updateTitle => 'アップデートを確認';

  @override
  String get updateInstalledVersion => 'インストール済みのバージョン';

  @override
  String get updateLastCheck => '最終確認';

  @override
  String get updateCheckNow => '今すぐ確認';

  @override
  String get updateChecking => 'アップデートを確認中…';

  @override
  String get updateUpToDate => 'Mealie Recipes は最新です。';

  @override
  String updateAvailable(String version) {
    return 'バージョン $version が利用可能です';
  }

  @override
  String get updateAvailableDescription =>
      'Mealie Recipes の新しいバージョンがあります。ご自身でアップデートを開始するまで何もインストールされません。';

  @override
  String get updateShow => 'アップデートを表示';

  @override
  String get updateLater => '後で';

  @override
  String updateDownloading(int percent) {
    return 'ダウンロード中 … $percent %';
  }

  @override
  String updateReady(String version) {
    return 'バージョン $version のインストール準備ができました';
  }

  @override
  String get updateInstalling => 'インストール中 — アプリは自動で再起動します …';

  @override
  String get updateManual =>
      'アップデートを自動でインストールできませんでした。ディスクイメージを開いたので、Mealie Recipes をアプリケーションにドラッグしてください。';

  @override
  String get updateFailed => 'アップデートに失敗しました';

  @override
  String get updateInstallNow => 'ダウンロードしてインストール';

  @override
  String get updateRestartNow => 'インストールして再起動';

  @override
  String get updateAutoTitle => '起動時にアップデートを確認';

  @override
  String get updateAutoDescription => '確認して通知するだけです — インストールは常にご自身で開始します。';

  @override
  String get updateBetaTitle => 'ベータ版を受け取る';

  @override
  String get updateBetaDescription => 'テスト用のプレリリース版も提案します。まだ不具合が含まれる場合があります。';

  @override
  String get updateNoNotes => 'リリースノートはありません。';

  @override
  String get updateSourceHint =>
      'アップデートは Mealie Recipes の GitHub リリースから取得され、開発者の署名がある場合のみインストールされます（macOS）。';

  @override
  String get errorNoConnection =>
      'Mealie サーバーに接続できません。インターネット接続とサーバーのアドレスを確認してください。';

  @override
  String get errorTimeout => 'サーバーの応答に時間がかかりすぎました。もう一度お試しください。';

  @override
  String get errorUnauthorized =>
      'サインインの有効期限が切れたか、API トークンが無効になりました。設定から再度サインインしてください。';

  @override
  String get errorServer => 'Mealie サーバーでエラーが発生しました。後でもう一度お試しください。';

  @override
  String get errorNotFound => 'サーバーに見つかりません — 削除された可能性があります。';

  @override
  String get errorCertificate => 'サーバーのセキュリティ証明書が信頼されていません。';

  @override
  String get errorGeneric => '問題が発生しました。もう一度お試しください。';

  @override
  String get offlineLabel => 'オフライン';

  @override
  String offlineSince(String time) {
    return 'オフライン · 最終同期 $time';
  }

  @override
  String get mealplanEntryActions => '食事のオプション';

  @override
  String get mealplanMoveAction => '移動';

  @override
  String get mealplanMoveTitle => '食事を移動';

  @override
  String get mealplanMoveDate => '日付';

  @override
  String mealplanMovedTo(String date) {
    return '$date に移動しました';
  }

  @override
  String get mealplanShowWeek => '表示';

  @override
  String get mealplanMoveFailed => '食事を移動できませんでした';

  @override
  String get recentlyViewedTitle => '最近見たレシピ';

  @override
  String get recentlyViewedEmpty => '開いたレシピがここに表示されます。';

  @override
  String get recentlyViewedClear => '履歴を消去';

  @override
  String get recentlyViewedClearMessage => 'この端末の最近見たレシピの一覧を消去します。レシピ自体は残ります。';

  @override
  String get recentlyViewedClearConfirm => 'クリア';

  @override
  String get duplicatesTitle => '重複チェッカー';

  @override
  String get duplicatesScanning => '重複したレシピを検索中…';

  @override
  String get duplicatesNone => '重複したレシピは見つかりませんでした。';

  @override
  String duplicatesFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '重複の可能性があるものが $count 件見つかりました。',
    );
    return '$_temp0';
  }

  @override
  String get duplicatesIntro => '残すレシピをタップしてから統合してください。';

  @override
  String get duplicatesReasonSource => '同じ出典';

  @override
  String get duplicatesReasonName => '同じ名前';

  @override
  String duplicatesReasonSimilar(int percent) {
    return '類似 · 材料の $percent % が同じ';
  }

  @override
  String get duplicatesKeeps => '残す';

  @override
  String get duplicatesWillBeDeleted => '削除されます';

  @override
  String get duplicatesMerge => '統合';

  @override
  String get duplicatesNotDuplicate => '重複ではない';

  @override
  String get duplicatesMergeTitle => 'レシピを統合しますか？';

  @override
  String duplicatesMergeMessage(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ほかの $count 件のレシピは削除されます',
    );
    return '「$name」を残します。$_temp0。\n\nカテゴリ、タグ、調理器具、メモ、世帯の予定した食事、お気に入りは移されます。削除されるレシピのコメント、タイムライン、添付ファイルは失われます。';
  }

  @override
  String get duplicatesMerged => 'レシピを統合しました';

  @override
  String duplicatesIngredientCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '材料 $count 件',
    );
    return '$_temp0';
  }

  @override
  String duplicatesResetIgnored(int count) {
    return '非表示にしたペアを再表示（$count）';
  }

  @override
  String get duplicatesRescan => '再検索';

  @override
  String get duplicatesOpenRecipe => 'レシピを開く';

  @override
  String get duplicatesMergeNoEditHint =>
      '残すレシピは編集できません（ロックされた他人のレシピ、または別の世帯のレシピ）。そのためカテゴリ、タグ、調理器具、メモはそのままで、予定した食事とお気に入りだけが移されます。';

  @override
  String get recipeOtherHouseholdHint => '別の世帯のレシピ – そちらで編集がロックされています';

  @override
  String foodsSavedAsNote(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 件の新しい食材',
    );
    return '保存しました。$_temp0は材料の備考として残しました – 食材を作成するには Mealie で「ユーザーは食材、タグ、カテゴリを管理できます」の権限が必要です。';
  }

  @override
  String get a11yRemove => '削除';

  @override
  String get a11yDecrease => '減らす';

  @override
  String get a11yIncrease => '増やす';

  @override
  String get a11yShowPassword => 'パスワードを表示';

  @override
  String get a11yHidePassword => 'パスワードを隠す';

  @override
  String get a11yClearSearch => '検索をクリア';

  @override
  String get notesQueuedOffline => 'オフライン – サーバーに再接続でき次第メモを送信します。';

  @override
  String get timelineQueuedOffline => 'オフライン – サーバーに再接続でき次第タイムラインに追加します。';

  @override
  String get syncSectionName => '名前変更';

  @override
  String get pendingRecipesDiscard => '破棄';

  @override
  String get undo => '元に戻す';

  @override
  String timerStoppedSnack(String name) {
    return 'タイマー「$name」を停止しました';
  }

  @override
  String get cookFriendsEndConfirm => '全員のセッションを終了しますか？すべてのゲストの接続が切れます。';

  @override
  String get weekStartSyncHint => 'Mealie に保存されます – ウェブアプリを含め、世帯全体に適用されます。';

  @override
  String get weekStartNoPermission =>
      '世帯が Mealie で設定しています。世帯を管理できるメンバーのみ変更できます。';

  @override
  String get assetsUnsupported329 =>
      'Mealie が対応しているのは PDF、画像、動画（MP4、MOV、WebM）、音声（MP3、M4A）、Word/ODT/RTF、TXT、MD、CSV、JSON です。';

  @override
  String get assetsRecordVideo => '動画を撮影';

  @override
  String get assetsChooseVideo => '動画を選択';

  @override
  String get shoppingSearchHint => 'このリストを検索';

  @override
  String get shoppingSearchNoMatches => '検索に一致するアイテムはありません。';

  @override
  String get mealplanServingsTitle => '予定人数';

  @override
  String get mealplanServingsHint =>
      'この献立エントリーのみ — レシピ自体は変わりません。レシピを開いたり買い物リストに追加したりするときにこの人数が使われます。';

  @override
  String get calendarFeedTitle => 'カレンダーを購読';

  @override
  String get calendarFeedSubtitle => '献立を Google、Apple などのカレンダーに表示';

  @override
  String get calendarFeedDescription =>
      'Google カレンダー、Apple カレンダー、Home Assistant など、iCal リンクに対応したアプリから世帯の献立を購読できます。リンクを知っている人は誰でも献立を見られます。';

  @override
  String get calendarFeedOff => '世帯のカレンダーリンクはオフになっています。';

  @override
  String get calendarFeedAskManager => '世帯を管理できる人にオンにしてもらってください。';

  @override
  String get calendarFeedTurnOn => 'オンにする';

  @override
  String get calendarFeedTurnOff => 'オフにする';

  @override
  String get calendarFeedReset => 'リンクをリセット';

  @override
  String get calendarFeedResetHint => 'リンクをリセットまたはオフにすると、既存の購読は更新されなくなります。';

  @override
  String get calendarFeedIncludeNotes => 'メモを含める';

  @override
  String get calendarFeedTimesHint =>
      '食事をタップして時刻を設定します。時刻のない食事は終日の予定として表示されます。';

  @override
  String get calendarFeedMealTypes => '食事の種類';

  @override
  String get calendarFeedSubscribe => 'カレンダーで購読';

  @override
  String get calendarFeedNoApp =>
      'カレンダーアプリを開けませんでした。リンクをコピーし、カレンダーに購読として追加してください。';

  @override
  String get calendarFeedPublicHint =>
      'リンクはサインインなしで使えます — 献立を見てもよい人だけに共有してください。';

  @override
  String get recipeShareLinkMenu => '共有リンクと QR コード';

  @override
  String get recipeShareShowQr => 'QR コードを表示';

  @override
  String get recipeShareScanQr => 'スマートフォンのカメラで読み取るとこのレシピが開きます';

  @override
  String get recipeShareQrShare => '画像を共有';

  @override
  String get recipeShareQrFailed => 'QR コード画像を作成できませんでした';

  @override
  String get mealplanSettingsTitle => '献立設定';

  @override
  String get mealDiceRulesTitle => 'サイコロのルール';

  @override
  String saveAsNewFood(String name) {
    return '「$name」を新しい食材として保存';
  }

  @override
  String get shoppingMoreOptions => 'その他のオプション';

  @override
  String get shoppingFewerOptions => 'オプションを減らす';

  @override
  String nameAlreadyExists(String name) {
    return 'すでに存在します：$name';
  }

  @override
  String aliasBelongsTo(String alias, String name) {
    return '「$alias」はすでに「$name」のものです — 2 つを統合することをおすすめします。';
  }

  @override
  String get recipeMatchTitle => 'Recipe Match';

  @override
  String get recipeMatchShuffle => 'シャッフル';

  @override
  String recipeMatchCardsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '山札に $count 件のレシピ',
    );
    return '$_temp0';
  }

  @override
  String get recipeMatchNext => '次へ';

  @override
  String get recipeMatchKeep => 'トレーへ';

  @override
  String get recipeMatchKept => 'トレーに置きました';

  @override
  String get recipeMatchAnyTime => '時間指定なし';

  @override
  String recipeMatchMaxTime(int minutes) {
    return '≤ $minutes 分';
  }

  @override
  String get recipeMatchEmpty => '一致するレシピはありません';

  @override
  String get recipeMatchEmptyHint => 'フィルターを変えるか、トレーを空にしてください。';

  @override
  String get recipeMatchResetFilters => 'フィルターをリセット';

  @override
  String get recipeMatchFlipHint => 'タップ：材料 · 作り方';

  @override
  String get recipeMatchFlipBack => '裏返す';

  @override
  String get recipeMatchOpenRecipe => 'レシピ全体';

  @override
  String get recipeMatchOnHand => '手持ちあり';

  @override
  String get recipeMatchTray => 'トレー';

  @override
  String get recipeMatchTrayEmpty => 'まだ空です – カードを下にドラッグしてください';

  @override
  String recipeMatchTrayCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 件のレシピ',
    );
    return '$_temp0';
  }

  @override
  String get recipeMatchClear => 'クリア';

  @override
  String get recipeMatchTrayHint => '空にするまで残ります – 山札を閉じても。';

  @override
  String get recipeMatchRemove => 'トレーから外す';

  @override
  String get recipeMatchToMealplan => '献立に追加';

  @override
  String get recipeMatchToShopping => '材料を買い物リストへ';

  @override
  String get recipeMatchSelectIngredients => '材料を選択';

  @override
  String get recipeMatchNoList => '先に買い物リストを選んでください。';

  @override
  String get recipeMatchList => 'リスト';

  @override
  String get recipeMatchOnHandHint => '手持ちの材料はすでに選択を外してあります。';

  @override
  String recipeMatchAddCount(int selected, int total) {
    return '$total 件中 $selected 件の材料を追加';
  }

  @override
  String get recipeMatchNoDay => '日付未定 – トレーに残ります';

  @override
  String recipeMatchAddMeals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 件の食事を追加',
    );
    return '$_temp0';
  }

  @override
  String recipeMatchMealsAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 件の食事を追加しました',
    );
    return '$_temp0';
  }

  @override
  String get recipeMatchSwipeUp => '上にスワイプしてトレーを開く';

  @override
  String get weekPlannerTitle => '1 週間を計画';

  @override
  String get weekPlannerStepDays => '日';

  @override
  String get weekPlannerStepPrefs => '環境設定';

  @override
  String get weekPlannerStepPreview => 'プレビュー';

  @override
  String get weekPlannerDaysTitle => 'アプリに埋めてほしい食事は？';

  @override
  String get weekPlannerDaysHint => 'マスをタップしてください。すでに予定があるものはそのままです。';

  @override
  String get weekPlannerPresetWeekdays => '平日';

  @override
  String get weekPlannerPlanned => '予定あり';

  @override
  String get weekPlannerMoreMeals => '食事をもっと表示';

  @override
  String get weekPlannerFewerMeals => '食事を減らす';

  @override
  String weekPlannerMealCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 食',
    );
    return '$_temp0';
  }

  @override
  String get weekPlannerPrefsTitle => 'アプリに何を考慮してほしいですか？';

  @override
  String get weekPlannerPrefsHint => 'すべて任意です – 選ばなければ、あなたのレシピからバランスよく選びます。';

  @override
  String get weekPlannerQuick => '平日は手早く';

  @override
  String weekPlannerQuickSub(int minutes) {
    return '月〜金は最大 $minutes 分';
  }

  @override
  String get weekPlannerStale => '長く作っていないものを優先';

  @override
  String get weekPlannerStaleSub => '「最後に作った日」と献立に基づく';

  @override
  String get weekPlannerFavorites => 'お気に入りを多めに';

  @override
  String get weekPlannerFavoritesSub => 'ハートを付けたレシピと評価の高いレシピ';

  @override
  String get weekPlannerVariety => 'バラエティ';

  @override
  String get weekPlannerVarietySub => '同じカテゴリを連続させない';

  @override
  String get weekPlannerOnlyFrom => '次からのみ';

  @override
  String get weekPlannerDiceRules => 'サイコロのルールを使う';

  @override
  String get weekPlannerDiceRulesSub => '献立設定での食事ごとの選択';

  @override
  String weekPlannerMatching(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '一致するレシピ $count 件',
    );
    return '$_temp0';
  }

  @override
  String weekPlannerForMeals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 食分',
    );
    return '$_temp0';
  }

  @override
  String get weekPlannerSuggest => '提案';

  @override
  String get weekPlannerPreviewHint =>
      'サイコロで入れ替え、鍵で固定。料理を長押しして別の日にドラッグすると入れ替えられます。';

  @override
  String get weekPlannerRerollAll => 'すべて振り直す';

  @override
  String get weekPlannerReroll => '振り直す';

  @override
  String get weekPlannerLock => '固定';

  @override
  String get weekPlannerUnlock => '固定解除';

  @override
  String get weekPlannerReasonNever => '未調理';

  @override
  String get weekPlannerReasonStale => 'しばらく作っていない';

  @override
  String get weekPlannerReasonFavorite => 'お気に入り';

  @override
  String get weekPlannerNoMatch => '一致するレシピはありません';

  @override
  String get weekPlannerThenShopping => '続けて買い物リストの材料を選ぶ';

  @override
  String get weekPlannerMostlyEmpty => '今週はほぼ空です';

  @override
  String weekPlannerMostlyEmptySub(int free, int total) {
    return '$total 日中 $free 日が空いています – 3 ステップで埋めましょう。';
  }

  @override
  String get previousWeek => '前の週';

  @override
  String get nextWeek => '次の週';

  @override
  String get weekPlannerAllDays => 'すべての日';

  @override
  String get weekPlannerWeekend => '週末';

  @override
  String get weekPlannerDinners => '夕食';

  @override
  String get weekPlannerLunches => '昼食';

  @override
  String get weekPlannerAllMeals => 'すべての食事';

  @override
  String get mealplanDayEmpty => '予定なし';

  @override
  String get mealplanDropHere => 'ここにドロップ';

  @override
  String mealplanDayKcal(String kcal) {
    return '1 人前あたり $kcal kcal';
  }

  @override
  String mealplanDayKcalPartial(String kcal) {
    return '1 人前あたり $kcal kcal 以上';
  }

  @override
  String get globalSearchHint => 'レシピ、アイテム、機能を検索 …';

  @override
  String get globalSearchIntro =>
      'レシピ、買い物リストのアイテム、食材、料理本を検索できます – アプリの機能や設定も検索できます（例：「リスト」）。';

  @override
  String get globalSearchFunctions => '機能';

  @override
  String globalSearchNoResults(String query) {
    return '「$query」の結果はありません';
  }

  @override
  String get searchClear => '検索をクリア';

  @override
  String get recipeMatchPlanWeek => 'これらのレシピで 1 週間を計画';

  @override
  String get weekPlannerReasonTray => 'トレーから';

  @override
  String get emptyBrowseRecipes => 'レシピを見る';

  @override
  String get mealplanWeekShopping => '今週の材料';

  @override
  String get globalSearchActions => '操作';

  @override
  String globalSearchAddToList(String text) {
    return '「$text」を買い物リストに追加';
  }

  @override
  String globalSearchAdded(String text) {
    return '「$text」を追加しました';
  }

  @override
  String get globalSearchImportUrl => 'このアドレスからレシピをインポート';

  @override
  String get homeContinueCooking => '調理を続ける';

  @override
  String homeCookingStep(int step, int total) {
    return '手順 $step/$total';
  }

  @override
  String get homeCookingPrep => '下準備';

  @override
  String get homeCookingAlmostDone => 'もうすぐ完成';

  @override
  String get homeCookingContinue => '続ける';

  @override
  String get paneSelectRecipe => '左側でレシピを選んでください。';

  @override
  String get mealplanDragRecipeHint => 'レシピを日付にドラッグして予定に入れます。';

  @override
  String get desktopDropUnsupported => 'これらのファイルは添付ファイルとして追加できません。';

  @override
  String desktopDropUploaded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 件の添付ファイルを追加しました',
    );
    return '$_temp0';
  }

  @override
  String get desktopDropAsAttachment => 'ドロップして添付ファイルとして追加';

  @override
  String get printAction => '印刷';

  @override
  String get mealplanPrintWeek => '1 週間分を印刷';

  @override
  String get mealplanEntryCooked => '作りました';

  @override
  String get recipeSearchClear => '検索をクリア';

  @override
  String get organizerShowRecipes => 'レシピを表示';

  @override
  String globalSearchShowAllRecipes(int count) {
    return '$count 件のレシピをすべて表示';
  }

  @override
  String get unnamedEntry => '（名前なし）';

  @override
  String get mealplanWholeWeek => '1 週間ずっと';

  @override
  String get mealplanWholeWeekDropHint => 'ここに食事をドロップすると 1 週間分の予定になります。';

  @override
  String get mealplanMovedToWholeWeek => '1 週間分として予定しました';

  @override
  String get mealplanCookToday => '今日作る';

  @override
  String get mealplanPlanWholeWeek => '1 週間分として予定';

  @override
  String mealplanPlanWholeWeekRange(String from, String to) {
    return '$from – $to';
  }

  @override
  String get calendarFeedDuration => '長さ（分）';

  @override
  String get calendarFeedEventDetails => '予定の詳細';

  @override
  String calendarFeedEventDetailsHint(String fields) {
    return 'カレンダーでの食事の表示方法をカスタマイズします。差し込みフィールド：$fields';
  }

  @override
  String get calendarFeedEventTitle => '予定のタイトル';

  @override
  String get calendarFeedEventDescription => '予定の説明';

  @override
  String get calendarFeedEventDetailsWarning =>
      'これを変更するとカレンダーのリンクが変わります — すでに購読している場合は新しいリンクで購読し直してください。';

  @override
  String get stepDurationMinutes => '所要時間（分）';

  @override
  String stepDurationSaved(String duration) {
    return '保存されている所要時間：$duration。編集すると分単位に置き換わります。';
  }

  @override
  String get sortTotalTimeShort => '合計時間が短い順';

  @override
  String get sortTotalTimeLong => '合計時間が長い順';

  @override
  String recipeCreatedBy(String name) {
    return '作成者：$name';
  }

  @override
  String get timelineReplacePhoto => '写真を差し替え';

  @override
  String get pasteRecipeTitle => 'レシピを貼り付け';

  @override
  String get pasteRecipeDescription =>
      'レシピを JSON（schema.org）またはウェブページの HTML ソースとして貼り付けます。';

  @override
  String get pasteRecipeDescription330 =>
      'Mealie からエクスポートしたレシピ（JSON）を貼り付けると、食材・単位・手順のリンクを含む完全な構造でインポートされます。JSON（schema.org）やウェブページの HTML ソースも使えます。';

  @override
  String get pasteRecipeHint => 'ここに JSON または HTML を貼り付け';

  @override
  String get pasteRecipeButton => 'レシピを貼り付け';

  @override
  String get pasteRecipeImport => 'インポート';

  @override
  String get aiPromptsTitle => 'AI プロンプト';

  @override
  String get aiPromptsTeaser =>
      'Mealie が AI プロバイダーに与える指示を、すべてのタスク共通またはタスクごとにカスタマイズします。';

  @override
  String get aiPromptsDescription =>
      'Mealie が AI プロバイダーにタスクごとに与える指示をカスタマイズします。Mealie のプロンプトは英語ですが、レシピの言語は変わりません。翻訳を選ばない限り、元の言語のままです。指示はどの言語でも書けます。';

  @override
  String get aiPromptsGlobal => 'すべてのプロンプトへの指示';

  @override
  String get aiPromptsGlobalDescription =>
      'レシピの作成、材料の解析、翻訳など、レシピデータを作るすべてのプロンプトに追加されます。システムプロンプトには影響しません。';

  @override
  String get aiPromptsGlobalPlaceholder => '例：常にメートル法の単位を使う。';

  @override
  String get aiPromptsList => 'プロンプト';

  @override
  String get aiPromptSystem => 'システム';

  @override
  String get aiPromptSystemDescription =>
      'これはシステムプロンプトです。レシピにする前に元の資料をできるだけ忠実に書き起こすため、すべてのプロンプトへの指示は追加されません。通常は変更不要で、変更するとインポートの信頼性が下がることがあります。';

  @override
  String get aiPromptAppended => '追記';

  @override
  String get aiPromptOverridden => '上書き';

  @override
  String get aiPromptModeDefault => '既定';

  @override
  String get aiPromptModeAppend => '追記';

  @override
  String get aiPromptModeOverride => '上書き';

  @override
  String get aiPromptAppendDescription =>
      'この指示は Mealie のプロンプトに追加され、両者が矛盾する場合は優先されます。';

  @override
  String get aiPromptOverrideDescription =>
      'あなたのプロンプトが Mealie のプロンプトを完全に置き換えるため、今後の Mealie のプロンプト更新は反映されません。単位の一覧など、タスクに必要なデータはあなたのプロンプトの後に追加されます。';

  @override
  String get aiPromptDefaultChanged =>
      '上書きした後に Mealie のプロンプトが変更されました。ご自身のものと比較するか、既定に戻して新しいバージョンを使ってください。';

  @override
  String get aiPromptViewDefault => '既定のプロンプトを表示';

  @override
  String get aiPromptHideDefault => '既定のプロンプトを隠す';

  @override
  String get aiPromptSaved => 'プロンプトを保存しました';

  @override
  String get aiPromptSaveFailed => 'プロンプトを保存できませんでした';

  @override
  String get aiPromptTitleBuildRecipe => 'レシピを作成';

  @override
  String get aiPromptTitleParseIngredients => '材料を解析';

  @override
  String get aiPromptTitleRecipeVideo => '動画からレシピ';

  @override
  String get aiPromptTitleOrganizers => 'オーガナイザーを割り当て';

  @override
  String get aiPromptTitleTranslate => 'レシピを翻訳';

  @override
  String get aiPromptTitleCompileSource => '元の資料を読み取る';

  @override
  String get aiPromptTitleTranscribe => '音声を書き起こす';

  @override
  String get aiPromptDescBuildRecipe =>
      'ウェブページ、写真、テキストから読み取った資料を構造化されたレシピにします。';

  @override
  String get aiPromptDescParseIngredients =>
      'AI 材料パーサーが各材料を数量・単位・食材・備考に分けるために使います。';

  @override
  String get aiPromptDescRecipeVideo => '動画の書き起こしとキャプションをレシピにします。';

  @override
  String get aiPromptDescOrganizers => 'インポートしたレシピのタグ、カテゴリ、調理器具を選びます。';

  @override
  String get aiPromptDescTranslate => 'インポートしたレシピを選んだ言語に翻訳します。';

  @override
  String get aiPromptDescCompileSource =>
      'ウェブページ、写真、テキストを読み取り、レシピのプレーンテキスト記録にします。';

  @override
  String get aiPromptDescTranscribe => '音声プロバイダーが直接書き起こせない場合に音声を書き起こします。';

  @override
  String get mealplanNoteHint => 'メモ（任意）';

  @override
  String get mealplanEditTitle => 'エントリーを編集';

  @override
  String get mealplanEntryTitleLabel => 'タイトル';

  @override
  String get mealplanEntryNoteLabel => 'メモ';

  @override
  String mealplanCreateRecipe(String name) {
    return '新しいレシピ「$name」';
  }

  @override
  String get mealplanCreateRecipeSubtitle => '空のレシピを作成して予定に入れ、エディターを開きます';

  @override
  String get importOptionsTitle => 'インポートのオプション';

  @override
  String get importOptionsHint =>
      'インポート時に Mealie の AI がサーバーでどこまで処理するか。追加の手順はそれぞれ別の AI リクエストになります – 少ないほど速くなります。';

  @override
  String get importTranslateTitle => 'レシピを翻訳';

  @override
  String get importOrganizersTitle => 'カテゴリとタグ';

  @override
  String get importOrganizersCreate => '新規追加';

  @override
  String get importOrganizersExisting => '既存のみ';

  @override
  String get importOrganizersNone => 'なし';

  @override
  String get importOrganizersCreateHint =>
      'AI がタグ、カテゴリ、調理器具を割り当て、足りないものは作成します。';

  @override
  String get importOrganizersExistingHint => 'AI はすでにあるタグ、カテゴリ、調理器具だけを使います。';

  @override
  String get importOrganizersNoneHint =>
      'タグ、カテゴリ、調理器具なしでインポートされます。Mealie はこの手順を実行するため、インポートは速くなりません。';

  @override
  String get importStarting => 'サーバーに送信中…';

  @override
  String get importRunning => 'レシピをインポート中…';

  @override
  String get aiImagesRunning => 'AI がページを読み取っています…';

  @override
  String get importStreamPhotosTitle => '進行状況を表示する写真インポート';

  @override
  String get importStreamPhotosHint =>
      '各手順を表示し、長いインポート中も接続を維持します。プロキシがストリーミングをブロックする場合などは、オフにすると以前のように 1 回のリクエストでアップロードします。';

  @override
  String get weekPlannerDiceRulesMealieSub => '世帯の Mealie ルール（献立設定）';

  @override
  String get syncStarted => 'サーバーからレシピ、画像、リストを再読み込み中…';

  @override
  String get syncDone => 'すべて最新です';

  @override
  String get recipeReloaded => 'レシピを再読み込みしました';

  @override
  String get logoutTitle => 'サインアウト / ユーザーを切り替え';

  @override
  String get logoutConfirm =>
      'レシピ、リスト、まだ同期されていない変更はこの端末から削除されます。アプリの設定とサーバーのアドレスは残るので、再度サインインするだけです。';

  @override
  String get reloadRecipe => 'サーバーから再読み込み';

  @override
  String get wifiServerTitle => 'Wi-Fi で別のアドレス';

  @override
  String get wifiServerHint =>
      '同じサーバーを別のアドレスで使う場合（例：自宅ではローカル IP、外出先では ZeroTier、Tailscale、ドメイン）。下の Wi-Fi ではこのアドレスを自動で使い、それ以外では上のサーバー URL を使います。';

  @override
  String get wifiSsidLabel => 'Wi-Fi 名';

  @override
  String get wifiServerUrl => 'この Wi-Fi でのアドレス';

  @override
  String get wifiUseCurrent => '現在の Wi-Fi を使う';

  @override
  String get wifiNameUnavailable =>
      'Wi-Fi 名を読み取れませんでした。Wi-Fi に接続して位置情報へのアクセスを許可してください – Android と iOS はそれがないと Wi-Fi 名を公開しません。';

  @override
  String wifiServerActive(String ssid) {
    return '使用中：Wi-Fi「$ssid」のアドレス';
  }

  @override
  String wifiServerStandardActive(String ssid) {
    return '使用中：サーバー URL（「$ssid」以外）';
  }

  @override
  String get wifiServerRemove => '削除';

  @override
  String get switchUserTitle => 'ユーザーを切り替え';

  @override
  String switchUserBody(String name) {
    return '$nameさんはこの端末に保存されたままです – すべてのレシピ、リスト、未同期の変更も含みます。プロフィール画像またはサインイン画面から元に戻せます。';
  }

  @override
  String get allowBiometricTitle => '端末のロック解除で戻る';

  @override
  String get allowBiometricHint =>
      'パスワードの代わりに Face ID、指紋、端末の PIN を使います。この端末のロックを解除できる人は誰でもこのアカウントを開けるようになります。';

  @override
  String get allow => '許可';

  @override
  String unlockAccountReason(String name) {
    return '$nameさんに切り替え';
  }

  @override
  String signInAs(String name) {
    return '$nameさんとしてサインイン';
  }

  @override
  String wrongAccountError(String name) {
    return 'これはアカウント「$name」です。保存されたアカウントでサインインしてください。';
  }

  @override
  String get accountSaveOffline => '現在アカウントを保存できません – サーバーに接続できません。';

  @override
  String get signOutRemoveTitle => 'サインアウトして削除';

  @override
  String get signOutRemoveConfirm =>
      'このアカウントと、この端末にあるそのすべてのデータ（レシピ、リスト、未同期の変更）が削除されます。アプリの設定は残ります。';

  @override
  String get removeSavedAccount => 'この端末から削除';

  @override
  String removeSavedAccountConfirm(String name) {
    return '「$name」と保存されたすべてのデータをこの端末から削除しますか？未同期の変更は失われます。';
  }

  @override
  String get savedAccountsTitle => '保存されたアカウント';

  @override
  String get addAccount => '別のアカウントを追加';

  @override
  String get biometricOff => '端末のロック解除を使わない';

  @override
  String get orNewAccount => 'または別のアカウントでサインイン：';

  @override
  String get importVideoTitle => '動画リンク';

  @override
  String get importVideoFast => '高速';

  @override
  String get importVideoThorough => 'じっくり（AI）';

  @override
  String get importVideoFastHint =>
      'Mealie が動画を書き起こし、1 回の AI リクエストでレシピを作成します – 通常はずっと速くなります。翻訳やカテゴリ/タグはありません。インポートごとに AI をオンにすることもできます。';

  @override
  String get importVideoThoroughHint =>
      '動画リンクでは AI スイッチが自動でオンになります：複数の AI 手順で、上の設定どおり翻訳とカテゴリ/タグを行います。時間がかかります。';

  @override
  String get importPresetFast => '高速';

  @override
  String get importPresetThorough => 'じっくり';

  @override
  String get importPresetCustom => 'カスタム';

  @override
  String get importPresetFastTitle => 'AI の手順をできるだけ少なく – 待ち時間が最短';

  @override
  String get importPresetFastVideo =>
      '動画リンク：Mealie が動画を書き起こし、1 回の AI リクエストでレシピを作成します（AI スイッチはオフのまま）。';

  @override
  String get importPresetFastTranslate => '翻訳なし – レシピは元の言語のままです。';

  @override
  String get importPresetFastOrganizers => '既存のカテゴリとタグのみ割り当て、新しいものは作成しません。';

  @override
  String get importPresetThoroughTitle =>
      'Mealie のフル AI インポート – 時間はかかりますが最大限に活用';

  @override
  String get importPresetThoroughVideo =>
      '動画リンクは自動で AI を使ってインポートされます – 複数の手順で（ソースの収集、レシピの作成など）。';

  @override
  String get importPresetThoroughTranslate =>
      'レシピが別の言語で書かれている場合は、下のインポート言語に翻訳されます。';

  @override
  String get importPresetThoroughOrganizers => '合うカテゴリとタグを割り当て、足りないものは作成します。';

  @override
  String get importPresetCustomTitle => '各オプションを自分で設定';

  @override
  String get importPresetCustomBody =>
      '前回の選択内容から始めて、必要な部分だけ変更してください – 例：動画は高速インポート、ただし翻訳あり。';

  @override
  String get sidebarPinHint => 'ヒント：タイルを長押ししてサイドバーにドラッグすると固定できます。';

  @override
  String get sidebarDropHere => 'ここにドロップ';

  @override
  String sidebarShortcutTitle(String name) {
    return '「$name」のショートカット';
  }

  @override
  String sidebarShortcutPrompt(String modifier) {
    return '$modifier を含む、使いたいキーの組み合わせを押してください。';
  }

  @override
  String get sidebarShortcutTaken => 'この組み合わせはすでに使われています。';

  @override
  String get sidebarShortcutNone => 'ショートカットなし';

  @override
  String get sidebarShortcutChange => 'ショートカットを変更';

  @override
  String get sidebarUnpin => 'サイドバーから外す';

  @override
  String sidebarFull(int count) {
    return 'サイドバーがいっぱいです – 独自の項目は最大 $count 件までです。';
  }

  @override
  String get tabletSidebar => '横向きでサイドバー';

  @override
  String get tabletSidebarSubtitle => 'タブレットを横向きにしたとき、ナビゲーションを下ではなく左に表示します';

  @override
  String get filterDateCreated => '作成日';

  @override
  String get filterDateUpdated => '更新日';

  @override
  String get errorUploadTooLarge =>
      'ファイルがこの Mealie サーバーには大きすぎます。サーバーのアップロード上限は MAX_UPLOAD_SIZE_MB で引き上げられます。';

  @override
  String get recipeDownloadPdfMealie => 'PDF をダウンロード（Mealie のレイアウト）';

  @override
  String get mealplanNoteMore => 'もっと見る…';

  @override
  String get mealplanNoteLess => '表示を減らす';

  @override
  String get ingredientCommonlySubstitutedWith => 'よく使われる代用品';

  @override
  String requiresMealieVersion(String version) {
    return 'Mealie $version 以降が必要です。';
  }

  @override
  String get apiTokensTitle => 'APIトークン';

  @override
  String get apiTokensDescription => '外部アプリケーションからアクセスするためのAPIトークンを管理します.';

  @override
  String get apiTokenNameLabel => 'トークンの名前';

  @override
  String get apiTokenGenerate => '生成';

  @override
  String get apiTokensActive => 'トークンをアクティブにする';

  @override
  String get apiTokenCopyWarning =>
      'このトークンを外部アプリケーションで使用するためにコピーします。このトークンは再び表示できません。';

  @override
  String get apiTokenThisApp => 'このアプリが使用中';

  @override
  String get apiTokenThisAppHint => 'このトークンはアプリのサインインを維持しており、ここでは削除できません。';

  @override
  String apiTokenDeleteConfirm(String name) {
    return 'トークン「$name」を削除しますか？使用しているアプリはすぐにアクセスできなくなります。';
  }

  @override
  String get apiTokensEmpty => 'トークンはまだありません。';

  @override
  String apiTokenCreatedOn(String date) {
    return '$date に作成';
  }

  @override
  String get apiTokenCopied => 'トークンをコピーしました';

  @override
  String get qfOpHasNoValue => '値がない';

  @override
  String get qfOpHasValue => '値がある';

  @override
  String get ratingHouseholdAverage => '世帯平均';

  @override
  String get stepLinkedNotes => 'リンクしたメモ';

  @override
  String get noteFallbackTitle => 'メモ';

  @override
  String get aiPromptTitleEnrichInstructions => '手順の詳細を追加';

  @override
  String get aiPromptDescEnrichInstructions =>
      'インポートしたレシピの各手順を、使う材料やメモとリンクし、所要時間と見出しを抽出します。';

  @override
  String get loginAccountLocked => 'アカウントがロックされています。後でもう一度試してください。';

  @override
  String get loginPasswordDisabled =>
      'このサーバーではパスワードログインが無効です。代わりに API トークンを使ってください。';

  @override
  String get unitSystemTitle => '単位';

  @override
  String get unitSystemAsWritten => '元の表記';

  @override
  String get unitSystemMetric => 'メートル法';

  @override
  String get unitSystemMetricHint => 'メートル法 (g, ml)';

  @override
  String get unitSystemImperial => 'ヤード・ポンド法';

  @override
  String get unitSystemImperialHint => 'ヤード・ポンド法 (カップ, oz)';

  @override
  String get unitSystemHint =>
      '表示のみです – レシピ自体は変わりません。Mealie ウェブアプリと同じく、この端末のすべてのレシピに適用されます。';

  @override
  String get unitSystemUnavailable =>
      'このレシピの単位はどれも換算できません。換算には Mealie で単位の標準化が必要です（食材と単位 → 単位 → 標準化）。';

  @override
  String get shoppingCheckAll => 'すべての項目をチェック';

  @override
  String get shoppingUncheckAll => 'すべての項目のチェックを外す';

  @override
  String get shoppingDeleteChecked => 'チェックしたものを削除';

  @override
  String get shoppingCheckAllConfirm => 'すべての項目をチェックしてもよろしいですか?';

  @override
  String get shoppingUncheckAllConfirm => 'すべてのアイテムのチェックを外してもよろしいですか？';

  @override
  String shoppingItemCheckedOff(String item) {
    return '$item をチェックしました';
  }

  @override
  String get updateGithubUnavailable => 'GitHub が現在応答していません。数分後にもう一度お試しください。';

  @override
  String get recipeMatchActionOnKeep => 'キープ時';

  @override
  String get recipeMatchActionOnSkip => 'スキップ時';

  @override
  String get recipeMatchActionNone => 'なし';

  @override
  String get recipeMatchActionsHint =>
      'レシピをトレイに置くかスキップするたびに、Mealie が選択したアクションを実行します。5 秒以内に元に戻すと取り消されます。';

  @override
  String recipeMatchActionsNoPost(String type) {
    return '世帯にはまだ「$type」タイプのレシピアクションがありません。';
  }
}
