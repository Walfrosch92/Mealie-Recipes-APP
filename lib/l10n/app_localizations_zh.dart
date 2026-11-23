// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get endCookingMode => '结束烹饪模式';

  @override
  String get endCookingModeConfirm => '确定要结束烹饪模式吗？';

  @override
  String endCookingModeConfirmAll(int count) {
    return '将结束烹饪模式中的全部 $count 个食谱。继续吗？';
  }

  @override
  String get addTimer => '添加计时器';

  @override
  String get recipeFinished => '你的菜做好了。';

  @override
  String get bonAppetit => '祝你用餐愉快！';

  @override
  String get prepareIngredients => '请准备以下食材';

  @override
  String prepareIngredientsFor(String servings) {
    return '请准备 $servings 人份的以下食材';
  }

  @override
  String get next => '下一步';

  @override
  String get navHome => '首页';

  @override
  String get homeCookToday => '今天做';

  @override
  String get homeSuggestion => '推荐';

  @override
  String get homeQuickAccess => '快捷入口';

  @override
  String get homePlanned => '已计划';

  @override
  String get favorite => '收藏';

  @override
  String get navSettings => '设定';

  @override
  String homeWelcomeName(Object name) {
    return '欢迎你，$name，';
  }

  @override
  String get homeWelcomeApp => '来到 Mealie Recipes 👋';

  @override
  String get theme => '外观';

  @override
  String get themeSystem => '系统';

  @override
  String get themeLight => '浅色';

  @override
  String get themeDark => '深色';

  @override
  String get recipes => '食谱';

  @override
  String get shoppingList => '🛒 购物清单';

  @override
  String get mealplan => '饮食计划';

  @override
  String get settings => '⚙️ 设置';

  @override
  String get searchRecipe => '搜索食谱...';

  @override
  String get loadingRecipe => '正在加载食谱...';

  @override
  String get errorLoadingRecipe => '无法加载食谱。';

  @override
  String get noRecipesForCategory => '没有符合此筛选条件的食谱。';

  @override
  String get resetFilter => '重置筛选';

  @override
  String get allCategories => '全部分类';

  @override
  String get all => '全部';

  @override
  String get sortRecipes => '食谱排序';

  @override
  String get refreshRecipes => '刷新';

  @override
  String get sortNameAZ => '名称 A–Z';

  @override
  String get sortNameZA => '名称 Z–A';

  @override
  String get sortDateNewest => '最新优先';

  @override
  String get sortDateOldest => '最早优先';

  @override
  String get sortPrepTimeShort => '准备时间最短';

  @override
  String get sortPrepTimeLong => '准备时间最长';

  @override
  String get sortRatingHighest => '评分最高';

  @override
  String get sortRatingLowest => '评分最低';

  @override
  String get details => '详情';

  @override
  String get ingredients => '食材';

  @override
  String get instructions => '做法';

  @override
  String get tags => '标签';

  @override
  String get notes => '备注';

  @override
  String get addNote => '添加备注';

  @override
  String get editNote => '编辑备注';

  @override
  String get noteTitleHint => '标题（可选）';

  @override
  String get noteTextHint => '备注内容';

  @override
  String get deleteNoteTitle => '删除备注？';

  @override
  String get deleteNoteMessage => '此备注将被永久删除。';

  @override
  String get servings => '几人份';

  @override
  String get planMeal => '安排餐食';

  @override
  String get addAllIngredients => '添加全部食材';

  @override
  String get addSelectedIngredients => '添加所选食材';

  @override
  String get addIngredientsMessage => '食材已添加到购物清单。';

  @override
  String addIngredientsFailedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '有 $count 种食材无法添加。',
      one: '有 1 种食材无法添加。',
    );
    return '$_temp0';
  }

  @override
  String get cookbooks => '食谱合集';

  @override
  String get cookbooksEmpty => '还没有食谱合集。点击右上角的“+”创建一个。';

  @override
  String get cookbookNoMatches => '没有符合此筛选条件的食谱。';

  @override
  String get cookbookCreateTitle => '创建食谱合集';

  @override
  String get cookbookEditTitle => '编辑食谱合集';

  @override
  String get cookbookNameLabel => '食谱合集名称';

  @override
  String get cookbookFilterSectionTitle => '自动添加食谱';

  @override
  String get cookbookFieldTools => '用具';

  @override
  String get cookbookFieldUsers => '用户';

  @override
  String get cookbookOpIsOneOf => '其中之一';

  @override
  String get cookbookOpIsNotOneOf => '不是其中之一';

  @override
  String get cookbookOpContainsAll => '包含全部';

  @override
  String get cookbookSelectValues => '选择值';

  @override
  String get cookbookFilterOptionsUnavailable => '没有可用选项';

  @override
  String get cookbookAddFilterField => '添加字段';

  @override
  String get cookbookPublicLabel => '公开食谱合集';

  @override
  String get cookbookPublicSubtitle => '服务器上的其他家庭也可见';

  @override
  String get cookbookRawModeEnter => '以文本编辑';

  @override
  String get cookbookRawModeExit => '返回构建器';

  @override
  String get cookbookRawModeHint =>
      '本应用的专家模式：直接以文本编辑筛选条件。当现有筛选条件无法拆分为简单的行时很有用。';

  @override
  String get cookbookRawModeUnparseable => '此文本不符合简单的行格式 — 将保留为文本。';

  @override
  String get saveFailed => '保存失败';

  @override
  String get search => '搜索';

  @override
  String get apply => '应用';

  @override
  String get setupCachingTitle => '正在加载你的食谱';

  @override
  String get setupCachingSubtitle => '正在为离线使用准备你的食谱。视数量而定，可能需要一点时间。';

  @override
  String get setupCachingDone => '全部就绪！';

  @override
  String get setupTipsHeader => '你知道吗？';

  @override
  String get setupFinish => '开始吧';

  @override
  String get setupSkipCaching => '在后台继续';

  @override
  String get setupTip1 => '你可以从链接、照片或 PDF 导入食谱 — 通过主屏幕上的“导入”磁贴。';

  @override
  String get setupTip2 => '烹饪模式会保持屏幕常亮，一步步引导你，并自动识别文中的计时。';

  @override
  String get setupTip3 => '购物清单离线也能用 — 服务器可连接后会自动同步更改。';

  @override
  String get setupTip4 => '长按主屏幕上的磁贴即可重新排列快捷入口。';

  @override
  String get setupTip5 => '你的 Mealie 食谱合集在“食谱合集”磁贴中 — 离线也可用。';

  @override
  String get ok => '确定';

  @override
  String get cancel => '取消';

  @override
  String get delete => '删除';

  @override
  String get edit => '编辑';

  @override
  String get save => '保存';

  @override
  String get done => '完成';

  @override
  String get close => '关闭';

  @override
  String get add => '添加';

  @override
  String get send => '发送';

  @override
  String get retry => '重试';

  @override
  String get confirmDeleteTitle => '删除食谱？';

  @override
  String get confirmDeleteMessage => '此操作无法撤销。';

  @override
  String get sendToDevice => '发送到设备';

  @override
  String get timerFinished => '计时结束！';

  @override
  String get timer => '计时器';

  @override
  String get newTimer => '新计时器';

  @override
  String get timerNamePlaceholder => '计时器名称';

  @override
  String get durationLabel => '时长';

  @override
  String get start => '开始';

  @override
  String get stop => '停止';

  @override
  String get pause => '暂停';

  @override
  String get resume => '继续';

  @override
  String get finished => '完成！';

  @override
  String stepNumber(int number) {
    return '第 $number 步';
  }

  @override
  String get minAbbreviation => '分钟';

  @override
  String get cookingMode => '烹饪模式';

  @override
  String get endAll => '全部结束';

  @override
  String get end => '结束';

  @override
  String get noActiveTimers => '没有正在运行的计时器';

  @override
  String get noActiveRecipes => '没有进行中的食谱';

  @override
  String get startRecipeToCook => '打开一个食谱并点击烹饪模式按钮即可开始。';

  @override
  String get browseRecipes => '浏览食谱';

  @override
  String get cookFriends => '和朋友一起做饭';

  @override
  String get cookingModeAddRecipe => '添加食谱';

  @override
  String get cookingModeAddRecipeSearchHint => '搜索食谱';

  @override
  String get cookFriendsCode => '会话代码';

  @override
  String get cookFriendsJoin => '加入会话';

  @override
  String get cookFriendsHost => '发起会话';

  @override
  String get cookFriendsHostNotFound => '找不到主持设备。请确保两台设备连接同一 Wi-Fi，并已允许访问本地网络。';

  @override
  String get cookFriendsConnectionFailed => '连接失败，请重试。';

  @override
  String get cookFriendsEnterCode => '输入代码';

  @override
  String cookFriendsConnected(int count) {
    return '已连接：$count 位访客';
  }

  @override
  String get joinSession => '加入会话';

  @override
  String get hostEndedSessionMessage => '主持人已结束烹饪会话。';

  @override
  String get addItem => '添加项目';

  @override
  String get itemNote => '物品名称';

  @override
  String get unlabeledCategory => '未标注';

  @override
  String get archivedLists => '📦 已归档的采购';

  @override
  String get postimportAction => '导入后';

  @override
  String get postimportHint => '选择在来源应用（提醒事项 / Google Tasks）中如何处理已导入的条目。';

  @override
  String get postimportLeave => '仅添加';

  @override
  String get postimportComplete => '标记完成';

  @override
  String get postimportCompleteDelete => '标记完成并删除';

  @override
  String get postimportFailed => '来源应用中的后续处理失败。物品仍已添加到 Mealie。';

  @override
  String get syncChangesTitle => '同步更改';

  @override
  String get syncSectionChecked => '已勾选';

  @override
  String get syncSectionQuantity => '数量';

  @override
  String get syncSectionCategory => '分类';

  @override
  String get syncSectionAdditions => '新添加';

  @override
  String get syncLocalLabel => '本地';

  @override
  String get syncServerLabel => '服务器';

  @override
  String get syncNow => '立即同步';

  @override
  String get offlineBadge => '离线';

  @override
  String get mealplanTitle => '📅 饮食计划';

  @override
  String get breakfast => '早餐';

  @override
  String get lunch => '午餐';

  @override
  String get dinner => '晚餐';

  @override
  String get addMealEntry => '添加餐食';

  @override
  String get selectRecipe => '选择食谱';

  @override
  String get importRecipe => '导入食谱';

  @override
  String get url => '网址链接';

  @override
  String get importLanguage => 'OCR 语言';

  @override
  String get setupTitle => '欢迎使用 Mealie Recipes';

  @override
  String get setupSubtitle => '请配置你的 Mealie 服务器。';

  @override
  String get serverUrl => '服务器 URL';

  @override
  String get serverUrlPlaceholder => 'https://mealie.example.com';

  @override
  String get apiToken => 'API 令牌';

  @override
  String get apiTokenPlaceholder => '你的 API 令牌';

  @override
  String get householdId => '家庭';

  @override
  String get householdIdPlaceholder => '家庭';

  @override
  String get shoppingListId => '购物清单 ID';

  @override
  String get setupHouseholdListTitle => '家庭与购物清单';

  @override
  String get shoppingListLabel => '购物清单';

  @override
  String get setupHouseholdManualHint => '无法加载家庭 — 请手动输入家庭名称。';

  @override
  String get setupExactTitle => '购物清单上的数量';

  @override
  String get setupExactBody =>
      '多数国家购物不会精确到克 — 放进购物车的是 1 包黄油，而不是 200 g。因此在简单模式下，应用会把食谱用量换算成“1×”。在精确模式下，数量和单位会像 Mealie 网页版一样 1:1 保留 — 输入新物品时也一样（例如“200 g 黄油”）。你可以随时在设置中更改。';

  @override
  String get setupExactSimpleTitle => '简单模式（1×）';

  @override
  String get setupExactSimpleBody => '食材以“1× 物品”的形式加入清单 — 便于在店里快速勾选。';

  @override
  String get setupExactExactTitle => '精确数量';

  @override
  String get setupExactExactBody => '物品会显示数量和单位，例如“200 g 黄油” — 与网页版完全一致。';

  @override
  String get connect => '连接';

  @override
  String connectionError(String error) {
    return '连接失败：$error';
  }

  @override
  String get optionalHeaders => '可选 HTTP 标头（用于反向代理）';

  @override
  String get settingsTitle => '⚙️ 设置';

  @override
  String get settingsSaved => '设置已保存';

  @override
  String get securitySettings => '安全';

  @override
  String get showRecipeImages => '显示食谱图片';

  @override
  String get apiVersion => 'API 版本';

  @override
  String get language => '语言';

  @override
  String get biometricLock => '生物识别锁';

  @override
  String get biometricLockDescription => '使用生物识别解锁应用';

  @override
  String get enableLogging => '启用日志';

  @override
  String get selectLanguage => '选择语言';

  @override
  String get setupContinue => '继续';

  @override
  String get back => '返回';

  @override
  String get setupConnectStep => '连接到你的服务器';

  @override
  String get resetSettings => '重置所有设置';

  @override
  String get resetSettingsConfirm => '将重置所有设置。继续吗？';

  @override
  String get guestMode => '访客模式';

  @override
  String get appVersion => '版本';

  @override
  String get leftoverFinder => '食谱搜索';

  @override
  String get addIngredient => '添加食材';

  @override
  String get biometricPrompt => '验证身份以打开 Mealie Recipes';

  @override
  String get biometricFailed => '身份验证失败';

  @override
  String get pendingRecipesTitle => '收到的食谱';

  @override
  String pendingRecipesFrom(Object names) {
    return '来自 $names';
  }

  @override
  String get pendingRecipesOpenCooking => '打开烹饪模式';

  @override
  String get dismiss => '关闭';

  @override
  String get editRecipe => '编辑食谱';

  @override
  String get recipeName => '食谱名称';

  @override
  String get prepTime => '准备时间（分钟）';

  @override
  String get cookTime => '烹饪时间（分钟）';

  @override
  String get totalTime => '总时间（分钟）';

  @override
  String get recipeServings => '几人份';

  @override
  String get rating => '评分';

  @override
  String get addIngredientLine => '添加食材';

  @override
  String get addInstruction => '添加步骤';

  @override
  String get removeIngredient => '移除食材';

  @override
  String get removeInstruction => '移除步骤';

  @override
  String get ingredientName => '食材';

  @override
  String get ingredientQuantity => '数量';

  @override
  String get ingredientUnit => '单位';

  @override
  String get ingredientNote => '备注';

  @override
  String get instructionText => '步骤内容';

  @override
  String get categories => '分类';

  @override
  String get saveChanges => '保存更改';

  @override
  String get saveSuccess => '食谱已保存。';

  @override
  String get newCategory => '新分类';

  @override
  String get newTag => '新标签';

  @override
  String get setRating => '评分';

  @override
  String get homeWelcome => '欢迎使用 Mealie Recipes！👋';

  @override
  String homeWelcomeNamed(String name) {
    return '$name，欢迎使用 Mealie Recipes！👋';
  }

  @override
  String get shopping => '购物';

  @override
  String get planning => '计划';

  @override
  String get other => '其他';

  @override
  String get addRecipe => '➕ 添加食谱';

  @override
  String get completeShopping => '完成购物';

  @override
  String get shoppingCompleted => '购物已完成';

  @override
  String get shoppingCompletedSubtitle => '全都放进购物车了！🎉';

  @override
  String get shoppingOfflineNoCache => '离线 – 清单未保存';

  @override
  String get shoppingOfflineNoCacheSubtitle => '此设备上还没有保存这个清单的物品。恢复联网后会立即加载。';

  @override
  String get essensplan => '📅 饮食计划';

  @override
  String get resteverwertung => '🥗 食谱查找';

  @override
  String get copyCode => '复制代码';

  @override
  String get shareLink => '分享链接';

  @override
  String get connectedFriends => '已连接的朋友';

  @override
  String get waitingForFriends => '正在等待朋友...';

  @override
  String get sessionCode => '会话代码';

  @override
  String get loading => '加载中...';

  @override
  String get urlInvalidScheme => 'URL 必须以 http:// 或 https:// 开头';

  @override
  String get urlAddScheme => '添加 https://';

  @override
  String get addItemPlaceholder => '添加物品...';

  @override
  String get completedItems => '已完成';

  @override
  String get completeShoppingTitle => '完成购物？';

  @override
  String get completeShoppingMessage => '删除已完成的物品？';

  @override
  String get recipeListTitle => '📖 食谱';

  @override
  String get importRecipeTitle => '上传新食谱';

  @override
  String get uploadRecipeUrl => '通过食谱 URL 导入';

  @override
  String get uploadRecipeUrlHint => '输入食谱 URL，将其保存到你的服务器';

  @override
  String get uploadOpenAI => '通过 OpenAI 从文件导入';

  @override
  String get uploadOpenAIHint => '也可以上传食谱的照片或 PDF。如果食谱有多页，添加多张即可 — AI 会一起分析。';

  @override
  String get takePhoto => '相机';

  @override
  String get cameraPermissionDenied => '无法访问相机。请在系统设置中允许访问以拍摄食谱。';

  @override
  String get cameraUnavailable => '此设备没有可用的相机。';

  @override
  String get selectPhoto => '照片';

  @override
  String get selectPdf => 'PDF';

  @override
  String get openAIHintTitle => '文件分析说明';

  @override
  String get openAIHintBody =>
      '食谱分析使用 OpenAI API。请确保已在 Mealie 服务器设置中配置 API 密钥。';

  @override
  String get allDeleteConfirm => '全部删除';

  @override
  String get entriesInOtherWeeks => '其他周有条目';

  @override
  String get availableWeeks => '可用的周：';

  @override
  String get currentWeek => '本周';

  @override
  String get weekAbbreviation => '周';

  @override
  String get today => '今天';

  @override
  String get selectDate => '选择日期';

  @override
  String get selectedRecipe => '已选食谱';

  @override
  String get confirmMeal => '安排餐食';

  @override
  String get searchRecipes => '搜索食谱';

  @override
  String get addCustomMeal => '添加自定义餐食';

  @override
  String get diceModeButton => '随机抽取食谱';

  @override
  String get diceModeTitle => '3 个随机推荐';

  @override
  String get diceBackToSearch => '返回搜索';

  @override
  String get diceNotEnoughRecipes => '食谱不足，无法使用骰子模式（至少需要 3 个）';

  @override
  String get entrySingular => '条';

  @override
  String get entriesPlural => '条';

  @override
  String get deleteAllConfirmTitle => '全部删除？';

  @override
  String get deleteAllConfirmMessage => '要删除所有已归档的采购吗？';

  @override
  String get uploadFromUrlButton => '从 URL 导入食谱';

  @override
  String get uploadingImage => '上传中...';

  @override
  String get uploadErrorTitle => '上传失败';

  @override
  String get uploadSuccessTitle => '上传成功';

  @override
  String get editImportedRecipeQuestion => '现在编辑新食谱吗？';

  @override
  String get notNow => '以后再说';

  @override
  String get pdfTooLarge => 'PDF 文件过大（最大 10 MB）。';

  @override
  String get invalidUrl => 'URL 无效。请输入有效的 HTTP(S) URL。';

  @override
  String get cookWithFriends => '和朋友一起做饭';

  @override
  String get cookFriendsSubtitle => '邀请朋友一起做这道菜';

  @override
  String get copied => '已复制';

  @override
  String get linkCopied => '链接已复制';

  @override
  String get startCooking => '开始烹饪';

  @override
  String get uploadToOwnServer => '保存到我的服务器';

  @override
  String get uploadingRecipe => '正在上传食谱…';

  @override
  String get recipeUploadedToOwnServer => '食谱已保存到你的服务器';

  @override
  String get recipeUploadFailed => '上传失败';

  @override
  String get allowGuestSaveRecipes => '允许访客将食谱保存到自己的服务器';

  @override
  String get appIcon => '应用图标';

  @override
  String get name => '名称';

  @override
  String get color => '颜色';

  @override
  String get randomColor => '随机颜色';

  @override
  String get createFailed => '无法创建';

  @override
  String get deleteFailed => '无法删除';

  @override
  String deleteOrganizerConfirm(String name) {
    return '删除“$name”？服务器上也会一并删除。';
  }

  @override
  String get connectionSection => '连接';

  @override
  String get token => '令牌';

  @override
  String get advancedOptions => '高级选项';

  @override
  String get mealieApiVersion => 'Mealie API 版本';

  @override
  String get sendOptionalHeaders => '发送可选标头';

  @override
  String get offlineRecipeImages => '离线保存食谱图片';

  @override
  String get offlineRecipeImagesHint =>
      '将所有食谱图片（包括步骤和备注中的图片）下载到设备，无网络时也能显示。大型收藏可能占用数百 MB。关闭后会删除已保存的图片。';

  @override
  String offlineRecipeImagesStatus(int count, int total, String size) {
    return '已保存：$count/$total · $size';
  }

  @override
  String get offlineRecipeImagesDisableConfirm => '删除所有已保存的食谱图片？';

  @override
  String headerNameLabel(int n) {
    return '标头 $n 名称';
  }

  @override
  String headerValueLabel(int n) {
    return '标头 $n 值';
  }

  @override
  String get value => '值';

  @override
  String get personalization => '个性化';

  @override
  String get showRecipeImagesSubtitle => '在食谱列表中显示图片';

  @override
  String get exactQuantities => '添加精确数量';

  @override
  String get exactQuantitiesSubtitle => '食材和输入的物品保留数量和单位（例如 200 g 黄油），而不是每件 1×';

  @override
  String get remindToShop => '购物提醒';

  @override
  String get remindToShopSubtitle => '当你靠近已保存的地点且购物清单还有未完成的物品时提醒你 — 即使应用已关闭';

  @override
  String get shoppingReminderAddLocation => '添加地点';

  @override
  String get shoppingReminderMaxLocations => '已达到最多 3 个地点';

  @override
  String get shoppingReminderLocationServiceDisabled => '此设备已关闭定位服务';

  @override
  String get shoppingReminderPermissionTitle => '需要位置权限';

  @override
  String get shoppingReminderPermissionMessage =>
      '要在你靠近商店时提醒你，需要“始终”允许位置访问 — 即使应用已关闭。请在设置中开启。';

  @override
  String get openSettings => '打开设置';

  @override
  String get shoppingReminderLocationName => '名称';

  @override
  String get shoppingReminderUseCurrentLocation => '使用当前位置';

  @override
  String get shoppingReminderOrAddress => '或输入地址';

  @override
  String get shoppingReminderAddress => '地址';

  @override
  String get shoppingReminderAddressPlaceholder => '街道，城市';

  @override
  String get shoppingReminderSearchAddress => '搜索';

  @override
  String get shoppingReminderLocationFailed => '无法确定你的位置';

  @override
  String get shoppingReminderAddressNotFound => '未找到地址';

  @override
  String get ratingFailed => '无法保存评分 — 请重试。';

  @override
  String get lastCooked => '上次制作';

  @override
  String get syncLastCooked => '更新“上次制作”';

  @override
  String get syncLastCookedSubtitle => '在服务器上保存今天的日期和一条时间轴记录 — 与 Mealie 网页版相同。';

  @override
  String get developer => '开发人员';

  @override
  String get enableLoggingSubtitle => '记录输出/错误日志（最近 500 行）';

  @override
  String get entriesLabel => '条目';

  @override
  String get fileSize => '文件大小';

  @override
  String get showAction => '显示';

  @override
  String get copy => '复制';

  @override
  String logsWithCount(int count) {
    return '日志（$count）';
  }

  @override
  String get noLogs => '没有日志';

  @override
  String get logsTitle => '日志';

  @override
  String get required => '必填';

  @override
  String get connectionFailedCheck => '连接失败。请检查 URL 和令牌。';

  @override
  String get username => '用户名';

  @override
  String get password => '密码';

  @override
  String get setupPasswordHint =>
      '不会保存你的密码 — 应用只登录一次并据此生成 API 令牌（与网页版的 个人资料 → API 令牌 相同）。';

  @override
  String get loginAndConnect => '登录并连接';

  @override
  String get loginInvalidCredentials => '用户名或密码不正确。';

  @override
  String get apiTokenSaveHint => '令牌已应用 — 请点击下方的“保存更改”。';

  @override
  String get renewApiToken => '更新 API 令牌';

  @override
  String get setupAuthChoiceTitle => '你想如何登录？';

  @override
  String get authModePasswordTitle => '让应用为我创建 API 密钥';

  @override
  String get authModePasswordSubtitle => '使用用户名和密码登录 — 应用会自动生成令牌。';

  @override
  String get authModeTokenTitle => '我已有 API 密钥';

  @override
  String get authModeTokenSubtitle => '从 Mealie 个人资料复制（个人资料 → API 令牌）。';

  @override
  String keyN(int n) {
    return '密钥 $n';
  }

  @override
  String valueN(int n) {
    return '值 $n';
  }

  @override
  String get openCookingMode => '打开烹饪模式';

  @override
  String activeRecipes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 个进行中的食谱',
    );
    return '$_temp0';
  }

  @override
  String get reparseIngredients => '重新解析食材';

  @override
  String get reparseIngredientsSubtitle => '拆分数量/单位/食材（例如“200 g 面粉”）';

  @override
  String get reparseDone => '食材已拆分 – 点击“保存更改”以应用';

  @override
  String get tagsAndCategories => '标签、分类和用具';

  @override
  String get tapToAddPhoto => '点击添加照片';

  @override
  String get descriptionLabel => '描述';

  @override
  String get searchingDevices => '正在搜索同一 Wi-Fi 上的设备…';

  @override
  String get selectAll => '全选';

  @override
  String get importReminders => '导入提醒事项';

  @override
  String get importGoogleTasks => '导入 Google Tasks';

  @override
  String get noTaskLists => '未找到任务列表';

  @override
  String get noReminderLists => '未找到提醒事项列表';

  @override
  String importCount(int count) {
    return '导入 $count 项';
  }

  @override
  String get noIngredientsToLink => '暂无可关联的食材';

  @override
  String get importLanguageSubtitle => '从照片或 PDF 导入的食谱所用语言';

  @override
  String get importLanguageSearch => '搜索语言';

  @override
  String get importLanguageFollowApp => '与应用语言相同';

  @override
  String get importLanguageNoMatch => '未找到语言';

  @override
  String get setupImportLanguageTitle => 'AI 导入食谱';

  @override
  String get setupImportLanguageBody =>
      'AI 可以把照片和 PDF 转换成食谱。选择它们最终使用的语言 — 如果你的母语不在应用语言中，这会很方便。之后可以在设置中更改。';

  @override
  String get setupImportLanguageSearchHint => '使用选择器中的搜索，可以找到应用界面未提供的语言。';

  @override
  String get setupCachingKeepOpenTitle => '请保持应用打开';

  @override
  String get setupCachingKeepOpenBody =>
      '加载在前台进行。请在完成前保持应用打开 — 如果关闭或切换到其他应用太久，过程会中断，稍后重新开始。';

  @override
  String get supportContact => '联系支持';

  @override
  String get supportDialogMessage =>
      '描述你的问题，我们会回复你。日志对排查问题很有帮助 — 你可以将其作为文本文件附上。';

  @override
  String get supportWithoutLogs => '不附日志';

  @override
  String get supportWithLogs => '附上日志';

  @override
  String get supportMailSubject => 'Mealie Recipes — 支持';

  @override
  String get supportMailHint => '请在此描述你的问题：';

  @override
  String get supportLogsEmpty => '日志为空。请开启日志，重现问题后再发送。';

  @override
  String supportAddressCopied(String email) {
    return '地址已复制：$email';
  }

  @override
  String supportNoMailApp(String email) {
    return '未设置邮件应用 – 地址已复制：$email。请选择其他应用联系我们。';
  }

  @override
  String get createRecipeFromImages => '创建食谱';

  @override
  String imagePagesSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已选择 $count 页',
    );
    return '$_temp0';
  }

  @override
  String get imagePagesHint => '第一张图片将成为食谱的主图。长按页面可调整顺序。';

  @override
  String get mainImageBadge => '主图';

  @override
  String maxImagesReached(int max) {
    return '每个食谱最多可添加 $max 张图片。';
  }

  @override
  String get removePage => '移除页面';

  @override
  String get preparingPdf => '正在处理 PDF...';

  @override
  String get recipeOptionsTitle => '选项';

  @override
  String get exportAsPdf => '导出为 PDF';

  @override
  String get generatingPdf => '正在生成 PDF…';

  @override
  String get pdfExportFailed => 'PDF 导出失败';

  @override
  String get recipeTime => '时间';

  @override
  String get addIngredientSection => '添加分组';

  @override
  String get aiImportToggle => '使用 AI 分析';

  @override
  String get aiImportToggleHint =>
      '也适用于食谱视频（YouTube、Instagram、TikTok …）以及普通导入无法读取的页面。需要在 Mealie 服务器上配置 AI 提供商 — 视频还需要音频提供商。';

  @override
  String get aiImportButton => '用 AI 导入';

  @override
  String get aiImportRunning => 'AI 正在分析链接 … 视频可能需要几分钟。';

  @override
  String get aiImportFailed => 'AI 导入失败。请检查 Mealie 服务器上的 AI 设置。';

  @override
  String get stepHeadingLabel => '步骤标题（可选）';

  @override
  String get linkedRecipeLabel => '关联的食谱';

  @override
  String get toolsTitle => '用具';

  @override
  String get prepareTools => '请准备以下用具';

  @override
  String get newTool => '新用具';

  @override
  String get renameAction => '重命名';

  @override
  String get organizerEmpty => '这里还没有内容。点击右上角的“+”创建一个。';

  @override
  String organizerRecipeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 个食谱',
      zero: '没有食谱',
    );
    return '$_temp0';
  }

  @override
  String get toolOnHand => '已有';

  @override
  String get mealDiceSettingsHint => '为每餐选择分类和标签。掷骰子时只会推荐至少包含其中之一的食谱。同一项可用于多餐。';

  @override
  String get mealDiceSettingsNoneHint =>
      '此餐未选择任何内容：骰子会根据“早餐”“午餐”或“晚餐”等分类名称自动选择。';

  @override
  String get mealDiceAutoHintTitle => '自动选择';

  @override
  String get mealDiceAutoHintBody =>
      '此餐尚未设置分类或标签。因此骰子会查找“早餐”“午餐”或“晚餐”等分类，并用其他食谱补足。\n\n如需自行选择：在饮食计划中点击“+”旁边的齿轮图标。';

  @override
  String get dontShowAgain => '不再显示';

  @override
  String get mealDiceNoMatches => '没有符合此餐所选分类和标签的食谱。';

  @override
  String mealDiceFewMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '只有 $count 个符合的食谱',
    );
    return '$_temp0';
  }

  @override
  String get commentsTitle => '评论';

  @override
  String get commentHint => '写评论…';

  @override
  String get commentSaveFailed => '无法保存评论。';

  @override
  String get commentDeleteConfirm => '删除这条评论？';

  @override
  String get cookingDoneCommentLabel => '评论（可选）';

  @override
  String get cookingDoneCommentHint => '做得怎么样？给下次的小贴士…';

  @override
  String get nutritionTitle => '营养';

  @override
  String get nutritionPerServing => '每份';

  @override
  String get nutritionCalories => '卡路里';

  @override
  String get nutritionFat => '脂肪';

  @override
  String get nutritionSaturatedFat => '饱和脂肪';

  @override
  String get nutritionTransFat => '反式脂肪';

  @override
  String get nutritionUnsaturatedFat => '不饱和脂肪';

  @override
  String get nutritionCholesterol => '胆固醇';

  @override
  String get nutritionSodium => '钠';

  @override
  String get nutritionCarbohydrates => '碳水化合物';

  @override
  String get nutritionFiber => '纤维';

  @override
  String get nutritionSugar => '糖';

  @override
  String get nutritionProtein => '蛋白质';

  @override
  String get timelineTitle => '时间轴';

  @override
  String get timelineMadeThis => '我做过了';

  @override
  String timelineUserMadeThis(String name) {
    return '$name 做过了';
  }

  @override
  String get timelineEmpty => '时间轴上还没有记录。';

  @override
  String get timelineDate => '日期';

  @override
  String get timelineNoteHint => '备注（可选）';

  @override
  String get timelineAddPhoto => '添加照片';

  @override
  String get timelineRemovePhoto => '移除照片';

  @override
  String get timelineSaved => '已添加到时间轴';

  @override
  String get timelineSaveFailed => '无法添加到时间轴';

  @override
  String get timelineImageFailed => '记录已保存，但照片上传失败';

  @override
  String get timelineDeleteConfirm => '从时间轴删除这条记录？';

  @override
  String get timelineEditNote => '编辑备注';

  @override
  String get timelineUnknownRecipe => '未找到食谱';

  @override
  String get cookingDonePhotoHint => '用于 Mealie 时间轴的照片（可选）';

  @override
  String get assetsTitle => '附件';

  @override
  String get assetsAdd => '添加附件';

  @override
  String get assetsChooseFile => '文件';

  @override
  String get assetsUploading => '上传中…';

  @override
  String get assetsUploadFailed => '附件上传失败';

  @override
  String assetsDeleteConfirm(String name) {
    return '从附件中移除“$name”？';
  }

  @override
  String get assetsOpenFailed => '无法打开附件';

  @override
  String get assetsUnsupported => 'Mealie 仅支持 PDF、图片、TXT、MD、CSV 和 JSON。';

  @override
  String get assetsShare => '分享';

  @override
  String get mealRulesTitle => 'Mealie 规则';

  @override
  String get mealRulesHint =>
      'Mealie 网页版也会使用。如果某天某餐适用多条规则，则必须全部符合。如果没有适用的规则，骰子会从所有食谱中选择。';

  @override
  String get mealRuleAdd => '添加规则';

  @override
  String get mealRuleNewTitle => '新规则';

  @override
  String get mealRuleEditTitle => '编辑规则';

  @override
  String get mealRuleDay => '日期';

  @override
  String get mealRuleAnyDay => '任意一天';

  @override
  String get mealRuleMealType => '餐次';

  @override
  String get mealRuleAnyMeal => '任意餐次';

  @override
  String get mealRuleConditionsTitle => '条件';

  @override
  String get mealRuleAllRecipes => '所有食谱';

  @override
  String get mealRuleDeleteConfirm => '删除此规则？';

  @override
  String get mealRulesOffline => 'Mealie 规则暂时不可用 – 骰子将使用应用中的选择。';

  @override
  String get mealRulesNoMatches => '没有符合此餐 Mealie 规则的食谱。';

  @override
  String get mealTypeSide => '零食';

  @override
  String get mealTypeSnack => '零食';

  @override
  String get mealTypeDrink => '饮品';

  @override
  String get mealTypeDessert => '甜点';

  @override
  String get foodsTitle => '食品';

  @override
  String get unitsTitle => '单位';

  @override
  String get newFood => '新食品';

  @override
  String get newUnit => '新单位';

  @override
  String get editFood => '编辑食品';

  @override
  String get editUnit => '编辑单位';

  @override
  String get pluralNameLabel => '复数名称';

  @override
  String get abbreviationLabel => '缩写';

  @override
  String get pluralAbbreviationLabel => '复数缩写';

  @override
  String get mergeAction => '合并';

  @override
  String mergeIntoTitle(String name) {
    return '将“$name”合并到…';
  }

  @override
  String mergeConfirm(String from, String to) {
    return '“$from”将合并到“$to”：之后所有食谱和购物清单都将使用“$to”，“$from”会被删除。';
  }

  @override
  String get mergeFailed => '合并失败';

  @override
  String foodUnitDeleteConfirm(String name) {
    return '删除“$name”？使用它的食材将失去关联。';
  }

  @override
  String get foodsUnitsEmpty => '还没有条目。';

  @override
  String mealRuleConditionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 个条件',
    );
    return '$_temp0';
  }

  @override
  String get showAll => '显示全部';

  @override
  String get mealDiceModeTitle => '骰子依据';

  @override
  String get mealDiceModeApp => '应用中的选择';

  @override
  String get switchListTitle => '切换清单';

  @override
  String get newShoppingList => '新购物清单';

  @override
  String shoppingListDeleteConfirm(String name) {
    return '删除“$name”？其中的所有物品也会被删除。';
  }

  @override
  String get labelOrderTitle => '标注排序';

  @override
  String get labelOrderHint => '拖动以排序。适用于此清单 – Mealie 网页版中也一样。';

  @override
  String get labelOrderEmpty => '此清单还没有标注。';

  @override
  String get useAsActiveList => '设为当前清单';

  @override
  String get activeListBadge => '当前';

  @override
  String get foodLabelLabel => '标注';

  @override
  String get foodNoLabel => '无标注';

  @override
  String get aliasesLabel => '别名';

  @override
  String get aliasAddHint => '添加别名';

  @override
  String get foodOnHand => '家中已有';

  @override
  String get timelineChildRecipesTitle => '也为关联的食谱添加';

  @override
  String timelineMadeForRecipe(String recipe) {
    return '$recipe专属';
  }

  @override
  String get timelineFilter => '筛选记录';

  @override
  String get timelineTypeComment => '制作记录和备注';

  @override
  String get timelineTypeInfo => 'Info（信息）';

  @override
  String get timelineTypeSystem => '系统';

  @override
  String get listManagementTitle => '购物清单';

  @override
  String get managementTitle => '更多';

  @override
  String get pinToHome => '添加到主屏幕';

  @override
  String get unpinFromHome => '从主屏幕移除';

  @override
  String homeScreenFull(int count) {
    return '主屏幕已满 – 最多 $count 个磁贴。请先在“更多”中移除其他磁贴。';
  }

  @override
  String get selectAction => '选择';

  @override
  String selectedCount(int count) {
    return '已选择 $count 项';
  }

  @override
  String get assignLabelAction => '指定标注';

  @override
  String get assignLabelOverwriteHint => '将覆盖所有所选食品的标注。';

  @override
  String deleteSelectedConfirm(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '删除 $count 个条目？',
    );
    return '$_temp0';
  }

  @override
  String get seedDataAction => '加载默认数据';

  @override
  String get seedFoodsHint => '以所选语言创建 Mealie 的默认食品。';

  @override
  String get seedUnitsHint => '以所选语言创建 Mealie 的默认单位。';

  @override
  String get seedLanguageLabel => '语言';

  @override
  String get seedDuplicateWarning => '你已有条目。Mealie 不会处理重复项 – 之后需要你自行合并。';

  @override
  String get seedDone => '已创建默认数据';

  @override
  String get seedFailed => '无法加载默认数据';

  @override
  String get exportAction => '导出';

  @override
  String get substitutionsLabel => '替代品';

  @override
  String get substitutionAddHint => '添加替代品';

  @override
  String get substitutionFoodLabel => '食品（可选）';

  @override
  String get substitutionNoteLabel => '备注（可选）';

  @override
  String get substitutionNeedOne => '请输入食品或备注';

  @override
  String get useAbbreviationLabel => '使用缩写';

  @override
  String get useAbbreviationHint => '在食谱中显示“g”而不是“克”';

  @override
  String get fractionLabel => '以分数显示';

  @override
  String get fractionHint => '用 ½ 代替 0.5';

  @override
  String get standardizationTitle => '标准化';

  @override
  String get standardizationHint => '用于换算：此单位的 1 等于 …（例如 1 汤匙 = 15 毫升）。';

  @override
  String get standardQuantityLabel => '标准数量';

  @override
  String get standardUnitLabel => '标准单位';

  @override
  String get standardUnitNone => '无';

  @override
  String get stdFluidOunce => '液量盎司 (fl oz)';

  @override
  String get stdCup => '杯（美制）';

  @override
  String get stdOunce => '盎司 (oz)';

  @override
  String get stdPound => '磅 (lb)';

  @override
  String get stdMilliliter => '毫升';

  @override
  String get stdLiter => '升';

  @override
  String get stdGram => '克';

  @override
  String get stdKilogram => '千克';

  @override
  String get labelsTitle => '标注';

  @override
  String get newLabel => '新标注';

  @override
  String get editLabel => '编辑标注';

  @override
  String get colorLabel => '颜色';

  @override
  String labelDeleteConfirm(String name) {
    return '删除“$name”？物品和食品将失去此标注。';
  }

  @override
  String get importMenuAction => '导入';

  @override
  String get archivedEmpty => '还没有已归档的采购。购物后点击“完成购物” – 已勾选的物品会保存在这里。';

  @override
  String get sectionTitleLabel => '分组标题';

  @override
  String get clearSection => '移除分组';

  @override
  String get noPermissionGeneric => '你在 Mealie 中没有此操作的权限。请联系管理员或家庭管理员。';

  @override
  String get noPermissionEditRecipe => '你无法编辑此食谱 – 它已锁定或属于其他家庭。只有创建者或管理员可以编辑。';

  @override
  String get noPermissionDeleteRecipe => '只有食谱的创建者或管理员可以删除它。';

  @override
  String get noPermissionDemoteSelf => '你不能移除自己的管理员权限。';

  @override
  String get recipeLockedHint => '已锁定 – 仅创建者可编辑';

  @override
  String get recipeDeleteOwnerOnlyHint => '仅创建者或管理员可删除';

  @override
  String get organizeReadOnlyHint => '仅查看：创建、修改和删除需要“用户可以管理食品、标签和分类”权限。';

  @override
  String get notesNotSavedNoPermission => '备注未保存 – 你没有编辑此食谱的权限。';

  @override
  String get userManagementTitle => '多用户管理';

  @override
  String get editUserTitle => '编辑用户';

  @override
  String get fullNameLabel => '全名';

  @override
  String get usernameLabel => '用户名';

  @override
  String get emailLabel => '邮箱';

  @override
  String get passwordLabel => '密码';

  @override
  String get householdLabel => '家庭';

  @override
  String get permissionsTitle => '权限';

  @override
  String get administratorLabel => '管理员';

  @override
  String get permCanInvite => '用户可以邀请其他人加入群组';

  @override
  String get permCanManage => '用户可以管理组设置';

  @override
  String get permCanManageHousehold => '用户可以管理家庭';

  @override
  String get permCanOrganize => '用户可以管理食品、标签和分类';

  @override
  String get advancedFeaturesLabel => '启用高级功能';

  @override
  String get passwordResetLinkAction => '生成重置密码链接';

  @override
  String get resetLockedUsersAction => '解锁被锁定用户';

  @override
  String get inviteLinkTitle => '邀请链接';

  @override
  String get inviteAction => '邀请';

  @override
  String get userUpdated => '用户已更新';

  @override
  String get createUserTitle => '创建用户';

  @override
  String get userCreated => '已创建用户';

  @override
  String userDeleteConfirm(String name) {
    return '删除“$name”？该账户将从 Mealie 中移除。';
  }

  @override
  String get passwordResetLinkCopied => '链接已复制 – 请转交给该用户。它只在有限时间内有效。';

  @override
  String lockedUsersReset(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已解锁 $count 位用户',
      zero: '没有被锁定的用户',
    );
    return '$_temp0';
  }

  @override
  String get inviteUsesLabel => '使用次数';

  @override
  String get inviteCreated => '已创建邀请链接';

  @override
  String get inviteEmailHint => '电子邮件地址（可选 – Mealie 会发送邀请）';

  @override
  String get inviteEmailSent => '邀请已通过电子邮件发送';

  @override
  String get inviteEmailFailed => '无法发送邮件（Mealie 中是否已设置 SMTP？）。链接仍然可用。';

  @override
  String get copyLinkAction => '复制链接';

  @override
  String get youLabel => '你';

  @override
  String get membersPermissionsHint => '你可以更改家庭成员的权限 – 但不能更改自己的。';

  @override
  String get householdManagementTitle => '家庭管理';

  @override
  String get householdsTitle => '家庭';

  @override
  String get createHouseholdTitle => '创建家庭';

  @override
  String get householdNameLabel => '家庭名称';

  @override
  String get householdPreferencesTitle => '家庭偏好设置';

  @override
  String get privateHouseholdLabel => '私有家庭';

  @override
  String get privateHouseholdHint =>
      '将家庭设置为私有后，群组内每个食谱单独配置的可见性选项都将被覆盖，所有食谱都无法被公开访问';

  @override
  String get lockRecipeEditsLabel => '禁止其他家庭编辑食谱';

  @override
  String get lockRecipeEditsHint => '启用时，只有家庭成员可以编辑由您家庭创建的食谱';

  @override
  String get householdRecipePreferencesTitle => '家庭食谱偏好设置';

  @override
  String get groupsTitle => '群组';

  @override
  String get groupLabel => '群组';

  @override
  String get createGroupTitle => '创建群组';

  @override
  String get groupNameLabel => '群组名';

  @override
  String get groupPreferencesTitle => '群组偏好设置';

  @override
  String get privateGroupLabel => '私人群组';

  @override
  String get privateGroupHint => '将群组设为私密会禁用所有公开查看选项，且此设置会覆盖任何个人的公开查看设置';

  @override
  String get firstDayOfWeekLabel => '每周的起始日';

  @override
  String get showAnnouncementsLabel => '显示来自Mealie的公告';

  @override
  String get recipePublicDefaultLabel => '允许组外用户查看你的食谱';

  @override
  String get recipeShowNutritionDefaultLabel => '显示营养信息';

  @override
  String get recipeShowAssetsDefaultLabel => '显示食谱附件';

  @override
  String get recipeLandscapeDefaultLabel => '默认横屏模式';

  @override
  String get recipeDisableCommentsDefaultLabel => '禁止用户评论食谱';

  @override
  String get myHouseholdSection => '我的家庭';

  @override
  String get myGroupSection => '我的群组';

  @override
  String get preferencesSaved => '设置已保存';

  @override
  String get cannotDeleteWithUsers => '仍有用户 – 请先在用户管理中移动或删除他们。';

  @override
  String deleteHouseholdConfirm(String name) {
    return '删除家庭“$name”？';
  }

  @override
  String deleteGroupConfirm(String name) {
    return '删除群组“$name”？';
  }

  @override
  String usersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 位用户',
      zero: '没有用户',
    );
    return '$_temp0';
  }

  @override
  String get originalUrlLabel => '原食谱链接';

  @override
  String get copyTextAction => '复制文本';

  @override
  String get copiedToClipboard => '已复制到剪贴板';

  @override
  String get changelogEnglishHint => '发行说明仅提供英文版。';

  @override
  String get favoritesTitle => '收藏夹';

  @override
  String get favoritesEmpty => '还没有收藏。点击食谱上的爱心即可收集到这里。';

  @override
  String get changelogTitle => '更新日志';

  @override
  String get changeProfileImage => '更换头像';

  @override
  String get profileImageUpdated => '头像已更新';

  @override
  String get profileImageFailed => '头像上传失败';

  @override
  String get myAccountTitle => '我的账户';

  @override
  String get ownAccountHint => '你可以在这里编辑自己的账户。其他用户由管理员和拥有“管理”权限的成员管理。';

  @override
  String get changePasswordAction => '更改密码';

  @override
  String get currentPasswordLabel => '当前密码';

  @override
  String get newPasswordLabel => '新密码';

  @override
  String get confirmPasswordLabel => '确认密码';

  @override
  String get passwordTooShort => '至少 8 个字符';

  @override
  String get passwordsDoNotMatch => '两次输入的密码不一致';

  @override
  String get passwordUpdated => '密码已更新';

  @override
  String get passwordChangeFailed => '无法更改密码';

  @override
  String passwordManagedExternally(String method) {
    return '你通过 $method 登录 — 请在那里更改密码。';
  }

  @override
  String get bulkAddHint => '每行一个条目。';

  @override
  String bulkAddCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '添加 $count 个条目',
    );
    return '$_temp0';
  }

  @override
  String get linkRecipeAction => '关联食谱';

  @override
  String get useFoodAction => '使用食品代替食谱';

  @override
  String get addSubstitutionsAction => '添加替代品';

  @override
  String get clearSubstitutionsAction => '清除替代品';

  @override
  String get recipeSubstitutionsTitle => '替代品';

  @override
  String get substitutionUnknownFood => '仅限现有食品 – 否则请使用备注';

  @override
  String get insertAboveAction => '在上方插入';

  @override
  String get insertBelowAction => '在下方插入';

  @override
  String get moveToTopAction => '移到顶部';

  @override
  String get moveToBottomAction => '移到底部';

  @override
  String get linkReferencesAction => '关联引用';

  @override
  String get editMarkdownAction => '编辑Markdown';

  @override
  String get previewMarkdownAction => '预览Markdown';

  @override
  String get insertStepImageAction => '上传图片';

  @override
  String get mergeAboveAction => '与上方合并';

  @override
  String get linkedToOtherStep => '已关联到其他步骤';

  @override
  String get noNotesToLink => '没有可关联的备注';

  @override
  String get ownerLabel => '所有者';

  @override
  String get ingredientParserTitle => '食材解析器';

  @override
  String ingredientParserHint(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '有 $count 种食材尚未结构化。请选择解析器，检查结果，然后应用。',
    );
    return '$_temp0';
  }

  @override
  String get parserNlp => '自然语言处理器';

  @override
  String get parserBrute => '暴力解析器';

  @override
  String get parserOpenai => 'OpenAI 解析器';

  @override
  String get parserApp => '离线（应用）';

  @override
  String get parseFailed => '解析失败';

  @override
  String get parseAction => '自动解析';

  @override
  String applyParsedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '应用 $count 种食材',
      zero: '未选择任何内容',
    );
    return '$_temp0';
  }

  @override
  String get parsedNewBadge => '新';

  @override
  String get hoursShort => '小时';

  @override
  String get minutesShort => '分钟';

  @override
  String get timeExtraHint => '附加，例如“另加一晚”';

  @override
  String get yieldLabel => '菜量';

  @override
  String get yieldTextLabel => '菜量描述';

  @override
  String get prepTimeLabel => '准备时间';

  @override
  String get performTimeLabel => '烹饪时间';

  @override
  String get totalTimeLabel => '总时间';

  @override
  String get settingPublicRecipe => '公开配方';

  @override
  String get settingShowNutrition => '显示营养价值表';

  @override
  String get settingShowAssets => '显示素材';

  @override
  String get settingLandscapeView => '横向视图';

  @override
  String get settingDisableComments => '禁用评论';

  @override
  String get settingDisableAmount => '禁用食材用量';

  @override
  String get settingLocked => '已锁定';

  @override
  String get settingLockedOwnerOnly => '只有创建者可以锁定或解锁食谱。';

  @override
  String get apiExtrasTitle => 'API附加功能';

  @override
  String get apiExtrasHint => '供第三方应用使用的自定义键/值对，例如用于触发自动化。';

  @override
  String get extraKeyLabel => '键';

  @override
  String get extraValueLabel => '值';

  @override
  String get addExtraAction => '添加附加项';

  @override
  String durationHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 小时',
    );
    return '$_temp0';
  }

  @override
  String durationMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 分钟',
    );
    return '$_temp0';
  }

  @override
  String get discardChangesConfirm => '放弃未保存的更改？';

  @override
  String get discardChanges => '放弃修改';

  @override
  String get imageFromUrl => '从 URL 获取图片';

  @override
  String get deleteRecipeImage => '删除食谱图像';

  @override
  String get deleteRecipeImageConfirm => '您确定要删除此食谱图像吗？';

  @override
  String get bulkAddIngredients => '批量添加食材';

  @override
  String get bulkAddSteps => '批量添加步骤';

  @override
  String get stepImageFailed => '图片上传失败';

  @override
  String get servingsAndTimes => '份量和时间';

  @override
  String get recipeSettingsTitle => '食谱设置';

  @override
  String get jsonEditorTitle => 'JSON 编辑器';

  @override
  String get jsonInvalid => 'JSON 无效 – 请检查。';

  @override
  String get editorOfflineHint => '以离线方式打开：保存需要联网。较新的 Mealie 字段（例如替代品）保持不变。';

  @override
  String get parseLineFailed => '无法识别 – 保持不变';

  @override
  String get createManualTitle => '手动创建食谱';

  @override
  String get createManualHint => '输入名称 – 之后可在食谱编辑器中添加食材、步骤、图片等所有内容。';

  @override
  String get createManualButton => '创建并编辑';

  @override
  String get changelogEmpty => '此版本还没有条目。';

  @override
  String get finderDescription => '根据手头的食材寻找食谱。 您也可以通过可用的用具进行筛选，并设置缺失食材或用具的上限。';

  @override
  String get finderSelectedIngredients => '已选择的食材';

  @override
  String get finderNoIngredientsSelected => '尚未选择食材';

  @override
  String get finderMissing => '缺失';

  @override
  String get finderNoRecipesFound => '未找到匹配食谱';

  @override
  String get finderNoRecipesFoundDescription => '尝试添加更多食材到您的搜索或调整筛选器';

  @override
  String get finderIncludeFoodsOnHand => '包括手头的食材';

  @override
  String get finderIncludeToolsOnHand => '包括手头的工具';

  @override
  String get finderIncludeSubstitutions => '包括替代品';

  @override
  String get finderSubstituting => '替代';

  @override
  String finderSubstituteForFood(String substitute, String food) {
    return '用 $substitute 代替 $food';
  }

  @override
  String get finderMaxMissingIngredients => '缺少最多得的食材';

  @override
  String get finderMaxMissingTools => '缺少最多的工具';

  @override
  String get finderSelectedTools => '选择工具';

  @override
  String get finderReadyToMake => '准备完成';

  @override
  String get finderAlmostReadyToMake => '即将准备完成';

  @override
  String get finderSettings => '设定';

  @override
  String get finderLoadingRecipes => '正在加载食谱';

  @override
  String get finderClearSelection => '清空选择';

  @override
  String get finderOfflineHint => '无法连接服务器 – 结果来自此设备上保存的食谱。';

  @override
  String get sendPeerOfflineHint => '目前无法连接 – 对方打开应用后送达';

  @override
  String sendDeliveredLater(String device) {
    return '目前无法连接“$device”。对方一打开应用，食谱就会送达。';
  }

  @override
  String get sendQueuedOffline => '目前没有网络。恢复联网后食谱会自动发送。';

  @override
  String get searchHasAll => '包含所有';

  @override
  String get searchHasAny => '包含任意';

  @override
  String get recipeFilterTitle => '筛选';

  @override
  String get finderOtherFilters => '其他过滤器';

  @override
  String get qfOpEquals => '等于';

  @override
  String get qfOpNotEquals => '不等于';

  @override
  String get qfOpGreater => '大于';

  @override
  String get qfOpGreaterEq => '大于等于';

  @override
  String get qfOpLess => '小于';

  @override
  String get qfOpLessEq => '小于等于';

  @override
  String get qfOpNewerThan => '新于';

  @override
  String get qfOpOlderThan => '旧于';

  @override
  String qfDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 天前',
    );
    return '$_temp0';
  }

  @override
  String get filterResetAll => '重置所有筛选';

  @override
  String get filterAny => '任意';

  @override
  String get filterOfflineIgnored => '离线时，“其他筛选”只能以简单形式应用。';

  @override
  String linkedRecipesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 个关联的食谱',
      zero: '没有关联的食谱',
    );
    return '$_temp0';
  }

  @override
  String get shoppingReminderNotificationsOff =>
      'Mealie Recipes 的通知已关闭 — 没有通知，购物提醒无法显示。请在设置中允许通知。';

  @override
  String get shoppingReminderInactiveHint => '购物提醒目前无法工作：请将位置访问设为“始终”并允许通知。';

  @override
  String get bulkImportTitle => '批量URL导入';

  @override
  String get bulkImportDescription =>
      '食谱批量导入器可以在后台创建网址队列、依次执行导入任务，从而一次性导入多个食谱。这在你刚上手Mealie做数据迁移，或是导入大量食谱时都非常有用。';

  @override
  String get bulkAddTitle => '批量添加';

  @override
  String get bulkImportSetOrganizers => '设置分类和标签';

  @override
  String get bulkImportStarted => '批量导入开始';

  @override
  String get bulkImportFailed => '批量导入失败';

  @override
  String get bulkImportReports => '批量导入';

  @override
  String get bulkImportUrlHint => '食谱网址';

  @override
  String get migrationsTitle => '数据迁移';

  @override
  String get migrationsDescription =>
      '可以从其他受支持的应用将食谱迁移到 Mealie。这是开始使用 Mealie 的好方法。在 Mealie 实例之间迁移数据或恢复较早的 Mealie 备份，请改用备份与恢复工具。';

  @override
  String get migrationNew => '新的迁移';

  @override
  String get migrationChooseType => '选择迁移类型';

  @override
  String get noFileSelected => '没有选择任何文件';

  @override
  String migrationTagAll(String tag) {
    return '为所有食谱添加 $tag 标签';
  }

  @override
  String get migrationPrevious => '上一次迁移';

  @override
  String get migrationMealieDescription =>
      'Mealie 可以从 v1.0 之前版本的 Mealie 应用导入食谱。从旧实例导出食谱，然后在下方上传 zip 文件。请注意，导出中只能导入食谱。这仅适用于早于 v1.0 的实例。在 v1.0 或更高版本中创建的备份应使用备份与恢复工具恢复。';

  @override
  String get migrationChowdownDescription =>
      'Mealie原生支持chowdown格式，只需将代码仓库打包成zip文件，并在下方上传。';

  @override
  String get migrationCopyMeThatDescription =>
      'Mealie 可以从 Copy Mee That导入食谱。将您的食谱以HTML 格式导出，然后在下面上传 .zip压缩包';

  @override
  String get migrationMyRecipeBoxDescription =>
      'Mealie可以从“My Recipe Box\"导入食谱。把你的食谱导出为CSV模式，然后在下面上传.csv文件。';

  @override
  String get migrationNextcloudDescription =>
      'Nextcloud食谱可以从存储在Nextcloud云端的含有食谱数据的zip文件导入。请参阅下方的文件夹结构示例确保您的食谱可以被正确导入。';

  @override
  String get migrationPaprikaDescription =>
      'Mealie 可以从 Paprika 导入食谱。请从paprika 导出食谱，重命名并压缩导出文件成.zip格式后，在下方上传';

  @override
  String get migrationPlanToEatDescription => 'Mealie支持从 Plan to Eat 中导入食谱。';

  @override
  String get migrationRecipeKeeperDescription =>
      'Mealie 可从 Recipe Keeper 导入食谱。请将您的食谱导出为 zip 格式，再上传下方的 .zip 文件。';

  @override
  String get migrationTandoorDescription =>
      'Mealie支持从Tandoor中导入食谱。在Tandoor中以“默认”格式导出数据，并在下方上传zip文件。';

  @override
  String get migrationCooknDescription =>
      'Mealie 可以从 DVO Cook\'n X3 导入配方。 以 Cook\'n\' 格式导出一个 cookbook 或菜单，重命名导出的文件为 .zip，然后在下方上传 .zip 文件。';

  @override
  String get reportTitle => '报告';

  @override
  String get recipeDataTitle => '食谱数据';

  @override
  String get recipeDataDescription =>
      '使用此部分来管理与食谱相关的数据。你可以对食谱进行一些批量操作，包括导出、删除、以及添加标签和分类。';

  @override
  String get recipeDataTagTitle => '给选中食谱添加标签';

  @override
  String get recipeDataCategorizeTitle => '给选中食谱添加分类';

  @override
  String get recipeDataSettingsTitle => '更新设置';

  @override
  String get recipeDataExportTitle => '导出食谱';

  @override
  String get recipeDataDeleteTitle => '删除食谱';

  @override
  String recipeDataExportConfirm(int count) {
    return '将导出以下食谱（$count）。';
  }

  @override
  String get recipeDataExportsTitle => '已导出数据';

  @override
  String get recipeDataExportsDescription =>
      '此区域提供已准备就绪的导出数据的下载链接。这些导出数据一段时间后会过期，所以请抓紧下载。';

  @override
  String get recipeDataPurgeExports => '清除导出';

  @override
  String get recipeDataPurgeConfirm => '你确认要删除所有导出的数据吗？';

  @override
  String get recipeActionsTitle => '食谱行为';

  @override
  String get recipeActionNew => '新建食谱行为';

  @override
  String get recipeActionEdit => '编辑食谱行为';

  @override
  String get recipeActionTypeLink => '链接';

  @override
  String get recipeActionTypePost => '帖子';

  @override
  String get webhooksTitle => 'Webhook';

  @override
  String get webhooksDescription =>
      '若某天有饮食计划，webhooks会按照下面的设定，在指定的时间发送当天的食谱数据。需要注意的是，webhook的具体执行时刻不是非常精确。因为系统每5分钟检查一次是否需要发送webhook，所以webhook真正的执行时间与预定时间会有正负五分钟的偏差。';

  @override
  String get webhookName => 'Webhook名称';

  @override
  String get webhookUrl => 'Webhook 网址';

  @override
  String get notifiersTitle => '通知方案';

  @override
  String get notifiersDescription => '设置基于特定事件触发的邮件提醒和通知推送。';

  @override
  String get notifierNew => '新通知';

  @override
  String get notifierDescription =>
      'Mealie使用Apprise库生成通知。Apprise适配了多种通知服务方式，若想了解如何为你所使用的通知服务创建URL，可以通过Apprise仓库的维基页面获得详细指南，其中有些通知服务可能包含额外功能。';

  @override
  String get notifierAppriseUrl => 'Apprise 网址';

  @override
  String get notifierAppriseUrlSkipped => 'Apprise URL (如果为空则跳过)';

  @override
  String get notifierAppriseUrlBlankHint =>
      '由于Apprise URL通常包含敏感信息，编辑时此字段留空。 如果您想要更新URL，请在这里输入新URL，否则留空保留当前URL。';

  @override
  String get notifierEnable => '打开消息通知';

  @override
  String get notifierWhatEvents => '该通知器需要订阅哪些事件？';

  @override
  String get notifierRecipeEvents => '食谱事件';

  @override
  String get notifierUserEvents => '用户事件';

  @override
  String get notifierMealplanEvents => '饮食计划事件';

  @override
  String get notifierShoppingListEvents => '购物清单事件';

  @override
  String get notifierCookbookEvents => '食谱合集事件';

  @override
  String get notifierTagEvents => '标签事件';

  @override
  String get notifierCategoryEvents => '分类事件';

  @override
  String get notifierLabelEvents => '活动标签';

  @override
  String get notifierUserSignup => '当新用户加入您的群组时';

  @override
  String get notifierCreate => '创建';

  @override
  String get notifierUpdate => '更新';

  @override
  String get notifierDelete => '删除';

  @override
  String get notifierTestSent => '测试消息已发送';

  @override
  String get adminTitle => '管理设置';

  @override
  String get backupsTitle => '备份';

  @override
  String get backupsDescription =>
      '备份是网站数据库和数据目录的共同快照。它必须包含全部数据，不能排除任何数据。你可以把它视为Mealie在某个时刻的快照。这些备份作为一种与数据库无关的方式，用于导入和导出数据，或将站点备份到外部位置。';

  @override
  String get backupCreateHeading => '创建备份';

  @override
  String get backupCreated => '创建备份成功';

  @override
  String get backupCreateFailed => '创建备份时出错。请查看日志文件';

  @override
  String get backupDelete => '删除备份';

  @override
  String get backupDeleted => '备份已删除';

  @override
  String get backupRestore => '恢复备份';

  @override
  String get backupRestoreDescription =>
      '恢复此备份会用备份内容覆盖数据库和数据目录中的所有当前数据。恢复成功后，你将被登出。';

  @override
  String get backupCannotBeUndone => '该操作无法撤销，请谨慎使用！';

  @override
  String get backupAcknowledge => '我已悉知该操作是不可逆的、有破坏性的，并可能造成数据丢失';

  @override
  String get backupRestoreSuccess => '还原成功';

  @override
  String get backupRestoreFailed => '恢复失败。查看服务器日志了解更多详细信息';

  @override
  String get maintenanceTitle => '维护';

  @override
  String get maintenanceSummary => '概况';

  @override
  String get maintenanceStorage => '存储详情';

  @override
  String get maintenanceDataDirSize => '数据目录大小';

  @override
  String get maintenanceCleanableDirs => '可清除的目录';

  @override
  String get maintenanceCleanableImages => '可清理的图像';

  @override
  String get maintenanceTempDir => '临时目录 (.temp)';

  @override
  String get maintenanceBackupsDir => '备份目录(backups)';

  @override
  String get maintenanceGroupsDir => '群组目录 (groups)';

  @override
  String get maintenanceRecipesDir => '食谱目录 (recipes)';

  @override
  String get maintenanceUserDir => '用户目录 (user)';

  @override
  String get maintenanceCleanDirs => '清理目录';

  @override
  String get maintenanceCleanDirsDescription => '移除所有名称为无效UUID的食谱文件夹';

  @override
  String get maintenanceCleanTemp => '清理临时文件';

  @override
  String get maintenanceCleanTempDescription => '移除 .temp 目录中的所有文件和文件夹';

  @override
  String get maintenanceCleanImages => '清理图片';

  @override
  String get maintenanceCleanImagesDescription => '移除所有不以 .webp 结尾的图像';

  @override
  String get maintenanceActions => '操作';

  @override
  String get adminConfiguration => '配置';

  @override
  String get adminAppVersion => '软件版本';

  @override
  String get adminUpToDate => 'Mealie 是最新版';

  @override
  String adminVersionOutdated(String current, String latest) {
    return '你当前的版本（$current）与最新发行版不一致。建议更新到最新版本（$latest）。';
  }

  @override
  String get adminBaseUrl => '服务器端根URL';

  @override
  String get adminBaseUrlOk => '已配置服务器端URL';

  @override
  String get adminBaseUrlError =>
      '环境变量“BASE_URL“仍是API服务器上的默认值。这可能造成服务器自动发送的邮件所包含的通知链接不可用等问题。';

  @override
  String adminAuthReady(String provider) {
    return '$provider 已就绪';
  }

  @override
  String adminAuthNotReady(String provider) {
    return '$provider 尚未就绪';
  }

  @override
  String adminAuthDisabled(String provider) {
    return '$provider 已禁用';
  }

  @override
  String adminAuthSuccessText(String provider) {
    return '所有必要的 $provider 变量均已设置完成。';
  }

  @override
  String adminAuthErrorText(String provider) {
    return '部分 $provider 配置尚未完成；若未使用 $provider 验证，可忽略此消息。';
  }

  @override
  String adminAuthDisabledText(String envVar) {
    return '要启用，请将 $envVar 设置为 true。';
  }

  @override
  String get adminEmailStatus => '邮件服务配置状态';

  @override
  String get adminEmailConfigured => '已配置邮件服务';

  @override
  String get adminNotReady => '尚未就绪，请检查环境变量';

  @override
  String get adminSucceeded => '成功';

  @override
  String get adminFailed => '失败';

  @override
  String get adminSiteStatistics => '站点统计';

  @override
  String get adminUncategorized => '未分类食谱';

  @override
  String get adminUntagged => '未标记的食谱';

  @override
  String get adminGeneralAbout => '关于';

  @override
  String get adminVersion => '版本';

  @override
  String get adminBuild => '构建';

  @override
  String get adminApplicationMode => '应用模式';

  @override
  String get adminProduction => '生产版';

  @override
  String get adminDevelopment => '开发版';

  @override
  String get adminDemoStatus => '演示状态';

  @override
  String get adminDemo => '演示';

  @override
  String get adminNotDemo => '非演示模式';

  @override
  String get adminApiPort => 'API 端口';

  @override
  String get adminApiDocs => 'API 文档';

  @override
  String get adminDatabaseType => '数据库类型';

  @override
  String get adminDatabaseUrl => '数据库 URL';

  @override
  String get adminDefaultGroup => '默认群组';

  @override
  String get adminDefaultHousehold => '默认家庭';

  @override
  String get adminScraperVersion => '食谱刮削器版本';

  @override
  String get adminStatUsers => '用户';

  @override
  String get adminStatHouseholds => '家庭';

  @override
  String get adminStatGroups => '群组';

  @override
  String get recipeDuplicate => '重复食谱';

  @override
  String get recipeDuplicateAction => '创建副本';

  @override
  String get recipeShareLink => '分享食谱';

  @override
  String get recipeShareExpiration => '到期时间';

  @override
  String get recipeShareCopied => '已复制食谱链接到剪切板';

  @override
  String get enabledLabel => '启用';

  @override
  String get disabledLabel => '已禁用';

  @override
  String get testAction => '测试';

  @override
  String get yesLabel => '是';

  @override
  String get noLabel => '否';

  @override
  String get downloadAction => '下载';

  @override
  String get backupUpload => '上传';

  @override
  String get zipImportButton => '从Zip压缩包导入';

  @override
  String get zipImportDescription => '导入从另一个Mealie应用导出的单个食谱。';

  @override
  String get reportStatus => '状态';

  @override
  String get reportDate => '日期';

  @override
  String get recipeActionTitleLabel => '标题';

  @override
  String get clearAll => '清空';

  @override
  String get recipeDataSettingsExplanation => '除被锁定选项外，下列选择将被应用于所有已选中的食谱。';

  @override
  String get adminAllowSignup => '允许注册';

  @override
  String get adminAllowPasswordLogin => '允许密码登录';

  @override
  String get adminEmailInvalid => '请输入有效的电子邮件地址。';

  @override
  String adminEmailTestResult(String result) {
    return '邮件测试：$result';
  }

  @override
  String get adminSendTestEmail => '发送测试邮件';

  @override
  String get adminTestEmailAddress => '收件人';

  @override
  String get backupCreate => '创建备份';

  @override
  String backupDeleteConfirm(String name) {
    return '删除备份“$name”？';
  }

  @override
  String get backupPostgresNote =>
      '如果你使用 PostgreSQL，请在恢复前阅读 Mealie 文档中的备份/恢复流程。';

  @override
  String get backupUploaded => '备份已上传';

  @override
  String get backupsEmpty => '还没有备份。';

  @override
  String get bulkImportAddRow => '添加 URL';

  @override
  String get bulkImportStart => '开始导入';

  @override
  String get chooseFileButton => '选择文件';

  @override
  String get deselectAllAction => '取消全选';

  @override
  String get downloadFailed => '下载失败';

  @override
  String get fileSaved => '文件已保存';

  @override
  String get loadFailed => '无法加载';

  @override
  String get maintenanceActionsWarning => '维护操作具有破坏性，请谨慎使用。执行其中任何操作都无法撤销。';

  @override
  String get maintenanceConfirm => '此操作具有破坏性且无法撤销。继续吗？';

  @override
  String get maintenanceDone => '完成';

  @override
  String get maintenanceFailed => '维护操作失败';

  @override
  String get maintenanceRun => '运行';

  @override
  String get migrationFailed => '迁移失败';

  @override
  String get migrationStart => '开始迁移';

  @override
  String get migrationStarted => '迁移完成 — 请查看下方报告。';

  @override
  String get moreImportOptions => '更多导入方式';

  @override
  String notifierDeleteConfirm(String name) {
    return '删除通知器“$name”？';
  }

  @override
  String get notifierEdit => '编辑通知器';

  @override
  String notifierEventCount(int count) {
    return '事件：$count';
  }

  @override
  String get notifierTestFailed => '无法发送测试消息';

  @override
  String get notifiersEmpty => '还没有通知器。';

  @override
  String recipeActionDeleteConfirm(String name) {
    return '删除食谱操作“$name”？';
  }

  @override
  String get recipeActionFailed => '食谱操作失败';

  @override
  String get recipeActionSent => '食谱已发送';

  @override
  String get recipeActionUrlHint => '占位符';

  @override
  String get recipeActionsDescription =>
      '食谱操作会显示在每个食谱的菜单中。“链接”打开该 URL，“Post”让 Mealie 服务器将食谱发送到该 URL。';

  @override
  String get recipeActionsEmpty => '还没有食谱操作。';

  @override
  String recipeDataDeleteConfirm(int count) {
    return '删除所选食谱（$count）？此操作无法撤销。';
  }

  @override
  String recipeDataDeleteForbidden(int count) {
    return '你无法删除所选食谱中的 $count 个（只有创建者或管理员可以删除）。';
  }

  @override
  String recipeDataDeleted(int count) {
    return '已删除食谱：$count';
  }

  @override
  String get recipeDataExportAction => '导出';

  @override
  String get recipeDataExportDone => '已创建导出 — 请在“数据导出”中下载。';

  @override
  String recipeDataExportExpires(String date) {
    return '$date 过期';
  }

  @override
  String get recipeDataExportFailed => '导出失败';

  @override
  String get recipeDataExportsEmpty => '没有可用的导出。';

  @override
  String recipeDataUpdated(int count) {
    return '已更新食谱：$count';
  }

  @override
  String get recipeDuplicated => '食谱已复制';

  @override
  String get recipeExportJson => '导出为 JSON';

  @override
  String get recipeExportZip => '导出为 ZIP（含图片）';

  @override
  String get recipeShareCreate => '创建链接';

  @override
  String get recipeShareDescription => '任何拥有链接的人都可以在浏览器中查看此食谱 — 无需账户 — 直到链接过期。';

  @override
  String get recipeShareEmpty => '还没有分享链接。';

  @override
  String recipeShareExpiresAt(String date) {
    return '$date 过期';
  }

  @override
  String get recipeWebToolsMenu => '复制、分享链接等';

  @override
  String get reload => '重新加载';

  @override
  String get reportDeleteConfirm => '删除此报告？';

  @override
  String get reportEntries => '条目';

  @override
  String get reportFailedEntries => '失败';

  @override
  String get reportOnlyFailed => '仅显示失败的条目';

  @override
  String get reportStatusFailure => '失败';

  @override
  String get reportStatusInProgress => '进行中';

  @override
  String get reportStatusPartial => '部分完成';

  @override
  String get reportStatusSuccess => '成功';

  @override
  String get reportsEmpty => '还没有报告。';

  @override
  String get uploadFailed => '上传失败';

  @override
  String webhookDeleteConfirm(String name) {
    return '删除 Webhook“$name”？';
  }

  @override
  String get webhookEdit => '编辑 Webhook';

  @override
  String get webhookNew => '新建 Webhook';

  @override
  String get webhookTestFailed => '无法启动测试';

  @override
  String get webhookTestSent => '已触发测试 Webhook';

  @override
  String get webhookTime => '时间（本地）';

  @override
  String get webhooksEmpty => '还没有 Webhook。';

  @override
  String get zipImportFailed => 'ZIP 导入失败';

  @override
  String get aiProvidersTitle => 'AI 提供者';

  @override
  String get aiProvidersDescription => '设置 AI 提供者以启用 AI功能，例如增强食材解析、从视频中创建食谱等！';

  @override
  String get aiProviderSettingsTitle => 'AI 提供者设置';

  @override
  String get aiProvidersList => '提供者';

  @override
  String get aiProviderCreate => '创建提供者';

  @override
  String get aiProviderEdit => '编辑提供者';

  @override
  String get aiDefaultProvider => '默认提供者';

  @override
  String get aiDefaultProviderDescription => '需要启用 AI 功能';

  @override
  String get aiAudioProvider => '音频提供者';

  @override
  String get aiAudioProviderDescription => '启用音频翻译功能，例如从视频创建食谱';

  @override
  String get aiImageProvider => '图片提供者';

  @override
  String get aiImageProviderDescription => '启用图像识别功能，例如从图像创建食谱';

  @override
  String get aiProviderName => '提供者名称';

  @override
  String get aiApiKey => 'API 密钥';

  @override
  String get aiApiKeyCreateDescription =>
      '您提供商用于身份验证的 API 密钥。如果您的服务（例如 Ollama）不使用 API 密钥，您仍然需要在此处填写一些内容。';

  @override
  String get aiApiKeyEditDescription => '除非你想要更改它，否则将留空。';

  @override
  String get aiBaseUrl => '基本网址';

  @override
  String get aiBaseUrlDescription =>
      '如果您使用 OpenAI 请留空。必须是 OpenAI兼容的端点(例如，\"http://localhost:11434/v1\")。';

  @override
  String get aiModel => '模型';

  @override
  String get aiModelDescription => '您的 AI 提供者应该使用哪个模型(例如，\"gpt-5\")。';

  @override
  String get aiTimeout => '请求超时（秒）';

  @override
  String get aiProviderCreated => '提供者已创建';

  @override
  String get aiProviderUpdated => '提供者已更新';

  @override
  String get aiProviderDeleted => '提供商已删除';

  @override
  String get aiProviderCreateFailed => '创建提供者失败';

  @override
  String get aiProviderUpdateFailed => '更新提供者失败';

  @override
  String get aiProviderDeleteFailed => '删除提供者失败';

  @override
  String get aiRequestHeaders => '请求标头';

  @override
  String get aiRequestParams => '请求参数';

  @override
  String get aiNoDefaultWarning => '您尚未设置默认提供者，所以AI 功能已被禁用';

  @override
  String get aiTestConnection => '测试连接';

  @override
  String get aiTestSucceeded => '连接成功';

  @override
  String get aiTestFailed => '连接失败';

  @override
  String get aiSupportsImages => '支持图片';

  @override
  String get aiTextOnly => '仅支持文本，不能作为图像提供商';

  @override
  String get debugAiTitle => '调试 AI 提供商';

  @override
  String get debugAiDescription =>
      '使用此页面调试 AI 提供商。你可以测试 AI 连接并在此查看结果。如果启用了图像服务，还可以提供一张图片。';

  @override
  String get debugParserTitle => '解析器';

  @override
  String get debugParserDescription =>
      'Mealie用条件随机场(CRFs) 算法解析食材。模型的数据集则基于纽约时报编写的一个包含十万多种食材的数据库。注意该模型仅采用英文数据训练，因此用于其他语言时未必有好的效果。本页面用于测试模型效果。';

  @override
  String get debugIngredientText => '食材文本';

  @override
  String get debugTryExample => '尝试一下示例吧';

  @override
  String debugAverageConfidence(String value) {
    return '置信度 $value';
  }

  @override
  String get debugRunTest => '进行测试';

  @override
  String get debugQuantity => '数量';

  @override
  String get debugUnit => '单位';

  @override
  String get debugFood => '食品';

  @override
  String get debugNote => '评论';

  @override
  String get debugGroup => '群组';

  @override
  String get aiProviderNone => '无';

  @override
  String aiProviderDeleteConfirm(String name) {
    return '删除提供商“$name”？';
  }

  @override
  String get aiProvidersEmpty => '还没有 AI 提供商。';

  @override
  String get aiAdvanced => '高级';

  @override
  String get aiKeyLabel => '名称';

  @override
  String get aiValueLabel => '值';

  @override
  String get debugTitle => '调试';

  @override
  String get debugParse => '自动解析';

  @override
  String get debugParseFailed => '无法解析食材';

  @override
  String get debugChooseImage => '选择图片';

  @override
  String get debugNoImage => '无图片（可选）';

  @override
  String get updateTitle => '检查更新';

  @override
  String get updateInstalledVersion => '已安装版本';

  @override
  String get updateLastCheck => '上次检查';

  @override
  String get updateCheckNow => '立即检查';

  @override
  String get updateChecking => '正在检查更新…';

  @override
  String get updateUpToDate => 'Mealie Recipes 已是最新版本。';

  @override
  String updateAvailable(String version) {
    return '版本 $version 可用';
  }

  @override
  String get updateAvailableDescription =>
      'Mealie Recipes 有新版本可用。在你自己开始更新之前，不会安装任何内容。';

  @override
  String get updateShow => '查看更新';

  @override
  String get updateLater => '稍后';

  @override
  String updateDownloading(int percent) {
    return '正在下载 … $percent %';
  }

  @override
  String updateReady(String version) {
    return '版本 $version 已可安装';
  }

  @override
  String get updateInstalling => '正在安装 — 应用将自动重启 …';

  @override
  String get updateManual => '无法自动安装更新。磁盘映像已打开：请将 Mealie Recipes 拖到“应用程序”中。';

  @override
  String get updateFailed => '更新失败';

  @override
  String get updateInstallNow => '下载并安装';

  @override
  String get updateRestartNow => '安装并重启';

  @override
  String get updateAutoTitle => '启动时检查更新';

  @override
  String get updateAutoDescription => '只检查并通知你 — 安装始终由你自己启动。';

  @override
  String get updateBetaTitle => '接收测试版';

  @override
  String get updateBetaDescription => '也提供用于测试的预发布版本，可能仍有错误。';

  @override
  String get updateNoNotes => '没有发行说明。';

  @override
  String get updateSourceHint =>
      '更新来自 Mealie Recipes 的 GitHub 发行版，且仅在由开发者签名时才会安装（macOS）。';

  @override
  String get errorNoConnection => '无法连接到你的 Mealie 服务器。请检查网络连接和服务器地址。';

  @override
  String get errorTimeout => '服务器响应时间过长。请重试。';

  @override
  String get errorUnauthorized => '你的登录已过期或 API 令牌已失效。请在设置中重新登录。';

  @override
  String get errorServer => 'Mealie 服务器报告了一个错误。请稍后重试。';

  @override
  String get errorNotFound => '服务器上未找到 — 可能已被删除。';

  @override
  String get errorCertificate => '服务器的安全证书不受信任。';

  @override
  String get errorGeneric => '出了点问题。请重试。';

  @override
  String get offlineLabel => '离线';

  @override
  String offlineSince(String time) {
    return '离线 · 上次同步 $time';
  }

  @override
  String get mealplanEntryActions => '餐食选项';

  @override
  String get mealplanMoveAction => '移动';

  @override
  String get mealplanMoveTitle => '移动餐食';

  @override
  String get mealplanMoveDate => '日期';

  @override
  String mealplanMovedTo(String date) {
    return '已移到 $date';
  }

  @override
  String get mealplanShowWeek => '显示';

  @override
  String get mealplanMoveFailed => '无法移动餐食';

  @override
  String get recentlyViewedTitle => '最近查看';

  @override
  String get recentlyViewedEmpty => '你打开的食谱会显示在这里。';

  @override
  String get recentlyViewedClear => '清除历史';

  @override
  String get recentlyViewedClearMessage => '将清除此设备上最近查看的食谱列表。食谱本身会保留。';

  @override
  String get recentlyViewedClearConfirm => '清空';

  @override
  String get duplicatesTitle => '重复查找';

  @override
  String get duplicatesScanning => '正在查找重复的食谱…';

  @override
  String get duplicatesNone => '未找到重复的食谱。';

  @override
  String duplicatesFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '找到 $count 个可能的重复项。',
    );
    return '$_temp0';
  }

  @override
  String get duplicatesIntro => '点击要保留的食谱，然后合并。';

  @override
  String get duplicatesReasonSource => '相同来源';

  @override
  String get duplicatesReasonName => '相同名称';

  @override
  String duplicatesReasonSimilar(int percent) {
    return '相似 · $percent % 食材相同';
  }

  @override
  String get duplicatesKeeps => '保留';

  @override
  String get duplicatesWillBeDeleted => '将被删除';

  @override
  String get duplicatesMerge => '合并';

  @override
  String get duplicatesNotDuplicate => '不是重复项';

  @override
  String get duplicatesMergeTitle => '合并食谱？';

  @override
  String duplicatesMergeMessage(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '另外 $count 个食谱将被删除',
    );
    return '保留“$name”。$_temp0。\n\n分类、标签、用具、备注、家庭已计划的餐食和你的收藏会被转移。被删除食谱的评论、时间轴和附件将丢失。';
  }

  @override
  String get duplicatesMerged => '食谱已合并';

  @override
  String duplicatesIngredientCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 种食材',
    );
    return '$_temp0';
  }

  @override
  String duplicatesResetIgnored(int count) {
    return '重新显示隐藏的配对（$count）';
  }

  @override
  String get duplicatesRescan => '重新查找';

  @override
  String get duplicatesOpenRecipe => '打开食谱';

  @override
  String get duplicatesMergeNoEditHint =>
      '你不能编辑要保留的食谱（他人已锁定的食谱或来自其他家庭）。因此其分类、标签、用具和备注保持不变；只转移已计划的餐食和你的收藏。';

  @override
  String get recipeOtherHouseholdHint => '来自其他家庭 – 在那里已锁定编辑';

  @override
  String foodsSavedAsNote(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 种新食品',
    );
    return '已保存。$_temp0已保留为食材备注 – 在 Mealie 中创建食品需要“用户可以管理食品、标签和分类”权限。';
  }

  @override
  String get a11yRemove => '移除';

  @override
  String get a11yDecrease => '减少';

  @override
  String get a11yIncrease => '增加';

  @override
  String get a11yShowPassword => '显示密码';

  @override
  String get a11yHidePassword => '隐藏密码';

  @override
  String get a11yClearSearch => '清除搜索';

  @override
  String get notesQueuedOffline => '离线 – 服务器恢复可连接后将发送备注。';

  @override
  String get timelineQueuedOffline => '离线 – 服务器恢复可连接后将添加到时间轴。';

  @override
  String get syncSectionName => '已重命名';

  @override
  String get pendingRecipesDiscard => '丢弃';

  @override
  String get undo => '还原';

  @override
  String timerStoppedSnack(String name) {
    return '计时器“$name”已停止';
  }

  @override
  String get cookFriendsEndConfirm => '为所有人结束会话？所有访客都将断开连接。';

  @override
  String get weekStartSyncHint => '已保存到 Mealie – 适用于你的整个家庭，网页版中也一样。';

  @override
  String get weekStartNoPermission => '由你的家庭在 Mealie 中设置。只有可管理家庭的成员才能更改。';

  @override
  String get assetsUnsupported329 =>
      'Mealie 支持 PDF、图片、视频（MP4、MOV、WebM）、音频（MP3、M4A）、Word/ODT/RTF、TXT、MD、CSV 和 JSON。';

  @override
  String get assetsRecordVideo => '录制视频';

  @override
  String get assetsChooseVideo => '选择视频';

  @override
  String get shoppingSearchHint => '在此清单中搜索';

  @override
  String get shoppingSearchNoMatches => '没有符合搜索的物品。';

  @override
  String get mealplanServingsTitle => '计划份量';

  @override
  String get mealplanServingsHint =>
      '仅适用于此饮食计划条目 — 食谱本身保持不变。打开食谱和添加到购物清单时会使用这些份量。';

  @override
  String get calendarFeedTitle => '订阅日历';

  @override
  String get calendarFeedSubtitle => '在 Google、Apple 或其他日历中显示饮食计划';

  @override
  String get calendarFeedDescription =>
      '可从 Google 日历、Apple 日历、Home Assistant 或任何支持 iCal 链接的应用订阅你家庭的饮食计划。任何拥有链接的人都能看到你的饮食计划。';

  @override
  String get calendarFeedOff => '你家庭的日历链接已关闭。';

  @override
  String get calendarFeedAskManager => '请让可管理你家庭的人开启它。';

  @override
  String get calendarFeedTurnOn => '开启';

  @override
  String get calendarFeedTurnOff => '关闭';

  @override
  String get calendarFeedReset => '重置链接';

  @override
  String get calendarFeedResetHint => '重置或关闭链接后，现有订阅将不再更新。';

  @override
  String get calendarFeedIncludeNotes => '包含备注';

  @override
  String get calendarFeedTimesHint => '点击餐次可设置时间。没有时间的餐次显示为全天事件。';

  @override
  String get calendarFeedMealTypes => '用餐时段';

  @override
  String get calendarFeedSubscribe => '在日历中订阅';

  @override
  String get calendarFeedNoApp => '无法打开日历应用。请复制链接并将其作为订阅添加到日历中。';

  @override
  String get calendarFeedPublicHint => '该链接无需登录即可使用 — 只与可以查看你饮食计划的人分享。';

  @override
  String get recipeShareLinkMenu => '分享链接和二维码';

  @override
  String get recipeShareShowQr => '显示二维码';

  @override
  String get recipeShareScanQr => '用手机相机扫描以打开此食谱';

  @override
  String get recipeShareQrShare => '分享图片';

  @override
  String get recipeShareQrFailed => '无法创建二维码图片';

  @override
  String get mealplanSettingsTitle => '饮食计划设置';

  @override
  String get mealDiceRulesTitle => '骰子规则';

  @override
  String saveAsNewFood(String name) {
    return '将“$name”保存为新食品';
  }

  @override
  String get shoppingMoreOptions => '更多选项';

  @override
  String get shoppingFewerOptions => '更少选项';

  @override
  String nameAlreadyExists(String name) {
    return '已存在：$name';
  }

  @override
  String aliasBelongsTo(String alias, String name) {
    return '“$alias”已属于“$name” — 最好将两者合并。';
  }

  @override
  String get recipeMatchTitle => 'Recipe Match';

  @override
  String get recipeMatchShuffle => '洗牌';

  @override
  String recipeMatchCardsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '牌堆中有 $count 个食谱',
    );
    return '$_temp0';
  }

  @override
  String get recipeMatchNext => '下一步';

  @override
  String get recipeMatchKeep => '放到托盘';

  @override
  String get recipeMatchKept => '已放到托盘';

  @override
  String get recipeMatchAnyTime => '任意时长';

  @override
  String recipeMatchMaxTime(int minutes) {
    return '≤ $minutes 分钟';
  }

  @override
  String get recipeMatchEmpty => '没有符合的食谱';

  @override
  String get recipeMatchEmptyHint => '更改筛选条件或清空托盘。';

  @override
  String get recipeMatchResetFilters => '重置筛选';

  @override
  String get recipeMatchFlipHint => '点击：食材 · 做法';

  @override
  String get recipeMatchFlipBack => '翻回';

  @override
  String get recipeMatchOpenRecipe => '完整食谱';

  @override
  String get recipeMatchOnHand => '已有';

  @override
  String get recipeMatchTray => '托盘';

  @override
  String get recipeMatchTrayEmpty => '还是空的 – 把卡片向下拖';

  @override
  String recipeMatchTrayCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 个食谱',
    );
    return '$_temp0';
  }

  @override
  String get recipeMatchClear => '清空';

  @override
  String get recipeMatchTrayHint => '会一直保留，直到你清空它 – 即使关闭牌堆。';

  @override
  String get recipeMatchRemove => '从托盘移除';

  @override
  String get recipeMatchToMealplan => '添加到饮食计划';

  @override
  String get recipeMatchToShopping => '食材加入购物清单';

  @override
  String get recipeMatchSelectIngredients => '选择食材';

  @override
  String get recipeMatchNoList => '请先选择一个购物清单。';

  @override
  String get recipeMatchList => '清单';

  @override
  String get recipeMatchOnHandHint => '已有的食材已取消勾选。';

  @override
  String recipeMatchAddCount(int selected, int total) {
    return '添加 $total 种食材中的 $selected 种';
  }

  @override
  String get recipeMatchNoDay => '尚未选择日期 – 留在托盘中';

  @override
  String recipeMatchAddMeals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '添加 $count 份餐食',
    );
    return '$_temp0';
  }

  @override
  String recipeMatchMealsAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已添加 $count 份餐食',
    );
    return '$_temp0';
  }

  @override
  String get recipeMatchSwipeUp => '向上滑动打开托盘';

  @override
  String get weekPlannerTitle => '规划本周';

  @override
  String get weekPlannerStepDays => '日期';

  @override
  String get weekPlannerStepPrefs => '偏好设置';

  @override
  String get weekPlannerStepPreview => '预览';

  @override
  String get weekPlannerDaysTitle => '应用要填充哪些餐次？';

  @override
  String get weekPlannerDaysHint => '点击格子。已计划的内容保持不变。';

  @override
  String get weekPlannerPresetWeekdays => '工作日';

  @override
  String get weekPlannerPlanned => '已计划';

  @override
  String get weekPlannerMoreMeals => '显示更多餐次';

  @override
  String get weekPlannerFewerMeals => '更少餐次';

  @override
  String weekPlannerMealCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 份餐食',
    );
    return '$_temp0';
  }

  @override
  String get weekPlannerPrefsTitle => '应用需要注意什么？';

  @override
  String get weekPlannerPrefsHint => '全部可选 – 不选择时会从你的食谱中挑选丰富的组合。';

  @override
  String get weekPlannerQuick => '工作日快手';

  @override
  String weekPlannerQuickSub(int minutes) {
    return '周一至周五最多 $minutes 分钟';
  }

  @override
  String get weekPlannerStale => '优先很久没做的';

  @override
  String get weekPlannerStaleSub => '根据“上次制作”和饮食计划';

  @override
  String get weekPlannerFavorites => '更常安排收藏';

  @override
  String get weekPlannerFavoritesSub => '加了爱心和评分高的食谱';

  @override
  String get weekPlannerVariety => '多样化';

  @override
  String get weekPlannerVarietySub => '同一分类不连续出现两次';

  @override
  String get weekPlannerOnlyFrom => '仅限';

  @override
  String get weekPlannerDiceRules => '使用骰子规则';

  @override
  String get weekPlannerDiceRulesSub => '你在饮食计划设置中为每餐所做的选择';

  @override
  String weekPlannerMatching(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 个符合的食谱',
    );
    return '$_temp0';
  }

  @override
  String weekPlannerForMeals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '用于 $count 份餐食',
    );
    return '$_temp0';
  }

  @override
  String get weekPlannerSuggest => '推荐';

  @override
  String get weekPlannerPreviewHint => '骰子替换，锁保留。长按一道菜并拖到另一天即可交换。';

  @override
  String get weekPlannerRerollAll => '全部重掷';

  @override
  String get weekPlannerReroll => '重掷';

  @override
  String get weekPlannerLock => '锁定';

  @override
  String get weekPlannerUnlock => '解锁';

  @override
  String get weekPlannerReasonNever => '从未做过';

  @override
  String get weekPlannerReasonStale => '很久没做';

  @override
  String get weekPlannerReasonFavorite => '收藏';

  @override
  String get weekPlannerNoMatch => '没有符合的食谱';

  @override
  String get weekPlannerThenShopping => '然后为购物清单选择食材';

  @override
  String get weekPlannerMostlyEmpty => '本周几乎是空的';

  @override
  String weekPlannerMostlyEmptySub(int free, int total) {
    return '$total 天中还有 $free 天空着 – 三步即可填满。';
  }

  @override
  String get previousWeek => '上一周';

  @override
  String get nextWeek => '下一周';

  @override
  String get weekPlannerAllDays => '所有日期';

  @override
  String get weekPlannerWeekend => '周末';

  @override
  String get weekPlannerDinners => '晚餐';

  @override
  String get weekPlannerLunches => '午餐';

  @override
  String get weekPlannerAllMeals => '所有餐次';

  @override
  String get mealplanDayEmpty => '没有计划';

  @override
  String get mealplanDropHere => '拖放到这里';

  @override
  String mealplanDayKcal(String kcal) {
    return '每份 $kcal 千卡';
  }

  @override
  String mealplanDayKcalPartial(String kcal) {
    return '每份至少 $kcal 千卡';
  }

  @override
  String get globalSearchHint => '搜索食谱、物品、功能 …';

  @override
  String get globalSearchIntro => '搜索食谱、购物清单物品、食品和食谱合集 – 也可搜索应用的功能和设置，例如“清单”。';

  @override
  String get globalSearchFunctions => '功能';

  @override
  String globalSearchNoResults(String query) {
    return '没有“$query”的结果';
  }

  @override
  String get searchClear => '清除搜索';

  @override
  String get recipeMatchPlanWeek => '用这些食谱规划本周';

  @override
  String get weekPlannerReasonTray => '来自托盘';

  @override
  String get emptyBrowseRecipes => '浏览食谱';

  @override
  String get mealplanWeekShopping => '本周的食材';

  @override
  String get globalSearchActions => '操作';

  @override
  String globalSearchAddToList(String text) {
    return '将“$text”添加到购物清单';
  }

  @override
  String globalSearchAdded(String text) {
    return '已添加“$text”';
  }

  @override
  String get globalSearchImportUrl => '从此地址导入食谱';

  @override
  String get homeContinueCooking => '继续烹饪';

  @override
  String homeCookingStep(int step, int total) {
    return '第 $step 步，共 $total 步';
  }

  @override
  String get homeCookingPrep => '准备';

  @override
  String get homeCookingAlmostDone => '快完成了';

  @override
  String get homeCookingContinue => '继续';

  @override
  String get paneSelectRecipe => '请在左侧选择一个食谱。';

  @override
  String get mealplanDragRecipeHint => '将食谱拖到某一天即可安排。';

  @override
  String get desktopDropUnsupported => '这些文件不能作为附件添加。';

  @override
  String desktopDropUploaded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已添加 $count 个附件',
    );
    return '$_temp0';
  }

  @override
  String get desktopDropAsAttachment => '松开以添加为附件';

  @override
  String get printAction => '打印';

  @override
  String get mealplanPrintWeek => '打印本周';

  @override
  String get mealplanEntryCooked => '已做';

  @override
  String get recipeSearchClear => '清除搜索';

  @override
  String get organizerShowRecipes => '显示食谱';

  @override
  String globalSearchShowAllRecipes(int count) {
    return '显示全部 $count 个食谱';
  }

  @override
  String get unnamedEntry => '（无名称）';

  @override
  String get mealplanWholeWeek => '整周';

  @override
  String get mealplanWholeWeekDropHint => '将餐食拖到这里即可安排整周。';

  @override
  String get mealplanMovedToWholeWeek => '已安排为整周';

  @override
  String get mealplanCookToday => '今天就做';

  @override
  String get mealplanPlanWholeWeek => '安排整周';

  @override
  String mealplanPlanWholeWeekRange(String from, String to) {
    return '$from – $to';
  }

  @override
  String get calendarFeedDuration => '时长（分钟）';

  @override
  String get calendarFeedEventDetails => '事件详情';

  @override
  String calendarFeedEventDetailsHint(String fields) {
    return '自定义餐食在日历中的显示方式。合并字段：$fields';
  }

  @override
  String get calendarFeedEventTitle => '事件标题';

  @override
  String get calendarFeedEventDescription => '事件描述';

  @override
  String get calendarFeedEventDetailsWarning =>
      '更改这些会改变日历链接 — 如果你已经订阅，请使用新链接重新订阅。';

  @override
  String get stepDurationMinutes => '时长（分钟）';

  @override
  String stepDurationSaved(String duration) {
    return '已保存的时长：$duration。编辑后会替换为整数分钟。';
  }

  @override
  String get sortTotalTimeShort => '总时间最短';

  @override
  String get sortTotalTimeLong => '总时间最长';

  @override
  String recipeCreatedBy(String name) {
    return '由 $name 创建';
  }

  @override
  String get timelineReplacePhoto => '替换照片';

  @override
  String get pasteRecipeTitle => '粘贴食谱';

  @override
  String get pasteRecipeDescription => '以 JSON（schema.org）或网页 HTML 源代码的形式粘贴食谱。';

  @override
  String get pasteRecipeDescription330 =>
      '粘贴从 Mealie 导出的食谱（JSON）— 将以完整结构导入：食品、单位和步骤关联。JSON（schema.org）和网页的 HTML 源代码也可以。';

  @override
  String get pasteRecipeHint => '在此粘贴 JSON 或 HTML';

  @override
  String get pasteRecipeButton => '粘贴食谱';

  @override
  String get pasteRecipeImport => '导入';

  @override
  String get aiPromptsTitle => 'AI 提示词';

  @override
  String get aiPromptsTeaser => '自定义 Mealie 向 AI 提供商发出的指令 — 适用于所有任务或单个任务。';

  @override
  String get aiPromptsDescription =>
      '自定义 Mealie 针对每项任务向 AI 提供商发出的指令。Mealie 的提示词以英文编写，但这不会改变你食谱的语言：除非你选择翻译，否则它们会保留来源的语言。你可以用任何语言编写自己的指令。';

  @override
  String get aiPromptsGlobal => '适用于所有提示词的指令';

  @override
  String get aiPromptsGlobalDescription =>
      '添加到每个生成食谱数据的提示词中，例如创建食谱、解析食材和翻译。系统提示词不受影响。';

  @override
  String get aiPromptsGlobalPlaceholder => '例如：始终使用公制单位。';

  @override
  String get aiPromptsList => '提示词';

  @override
  String get aiPromptSystem => '系统';

  @override
  String get aiPromptSystemDescription =>
      '这是一个系统提示词。它会在转换为食谱前尽可能忠实地转录来源材料，因此不会添加适用于所有提示词的指令。通常无需更改，更改可能会降低导入的可靠性。';

  @override
  String get aiPromptAppended => '已追加';

  @override
  String get aiPromptOverridden => '已覆盖';

  @override
  String get aiPromptModeDefault => '默认';

  @override
  String get aiPromptModeAppend => '追加';

  @override
  String get aiPromptModeOverride => '覆盖';

  @override
  String get aiPromptAppendDescription => '这些指令会追加到 Mealie 的提示词中，在两者冲突时优先。';

  @override
  String get aiPromptOverrideDescription =>
      '你的提示词将完全替换 Mealie 的提示词，因此 Mealie 提示词的后续更新不会应用到它。任务所需的数据（例如你的单位列表）仍会添加在你的提示词之后。';

  @override
  String get aiPromptDefaultChanged =>
      '自你覆盖以来，Mealie 的提示词已更改。请与你的进行比较，或切换回默认以使用新版本。';

  @override
  String get aiPromptViewDefault => '查看默认提示词';

  @override
  String get aiPromptHideDefault => '隐藏默认提示词';

  @override
  String get aiPromptSaved => '提示词已保存';

  @override
  String get aiPromptSaveFailed => '保存提示词失败';

  @override
  String get aiPromptTitleBuildRecipe => '创建食谱';

  @override
  String get aiPromptTitleParseIngredients => '解析食材';

  @override
  String get aiPromptTitleRecipeVideo => '从视频生成食谱';

  @override
  String get aiPromptTitleOrganizers => '分配组织项';

  @override
  String get aiPromptTitleTranslate => '翻译食谱';

  @override
  String get aiPromptTitleCompileSource => '读取来源材料';

  @override
  String get aiPromptTitleTranscribe => '转录音频';

  @override
  String get aiPromptDescBuildRecipe => '将从网页、照片或文本读取的来源材料转换为结构化食谱。';

  @override
  String get aiPromptDescParseIngredients => 'AI 食材解析器用它将每种食材拆分为数量、单位、食品和备注。';

  @override
  String get aiPromptDescRecipeVideo => '将视频的转录文本和字幕转换为食谱。';

  @override
  String get aiPromptDescOrganizers => '为导入的食谱选择标签、分类和用具。';

  @override
  String get aiPromptDescTranslate => '将导入的食谱翻译成你选择的语言。';

  @override
  String get aiPromptDescCompileSource => '读取网页、照片和文本，形成食谱的纯文本记录。';

  @override
  String get aiPromptDescTranscribe => '当音频提供商无法直接转录时，转录音频。';

  @override
  String get mealplanNoteHint => '备注（可选）';

  @override
  String get mealplanEditTitle => '编辑条目';

  @override
  String get mealplanEntryTitleLabel => '标题';

  @override
  String get mealplanEntryNoteLabel => '备注';

  @override
  String mealplanCreateRecipe(String name) {
    return '新食谱“$name”';
  }

  @override
  String get mealplanCreateRecipeSubtitle => '创建一个空食谱，安排它并打开编辑器';

  @override
  String get importOptionsTitle => '导入选项';

  @override
  String get importOptionsHint =>
      '导入时 Mealie 的 AI 在你的服务器上做多少工作。每个额外步骤都是一次独立的 AI 请求 – 越少越快。';

  @override
  String get importTranslateTitle => '翻译食谱';

  @override
  String get importOrganizersTitle => '分类和标签';

  @override
  String get importOrganizersCreate => '添加新的';

  @override
  String get importOrganizersExisting => '仅现有的';

  @override
  String get importOrganizersNone => '无';

  @override
  String get importOrganizersCreateHint => 'AI 分配标签、分类和用具，并创建缺少的项。';

  @override
  String get importOrganizersExistingHint => 'AI 只使用已存在的标签、分类和用具。';

  @override
  String get importOrganizersNoneHint =>
      '食谱导入时不带标签、分类和用具。Mealie 仍会运行此步骤，因此导入不会变快。';

  @override
  String get importStarting => '正在发送到服务器…';

  @override
  String get importRunning => '正在导入食谱…';

  @override
  String get aiImagesRunning => 'AI 正在读取页面…';

  @override
  String get importStreamPhotosTitle => '实时显示进度的照片导入';

  @override
  String get importStreamPhotosHint =>
      '显示每个步骤，并在长时间导入时保持连接。若要像以前一样一次性上传，请关闭 – 例如你的代理阻止流式传输时。';

  @override
  String get weekPlannerDiceRulesMealieSub => '你家庭的 Mealie 规则（饮食计划设置）';

  @override
  String get syncStarted => '正在从服务器重新加载食谱、图片和清单…';

  @override
  String get syncDone => '全部已是最新';

  @override
  String get recipeReloaded => '食谱已重新加载';

  @override
  String get logoutTitle => '退出登录 / 切换用户';

  @override
  String get logoutConfirm => '食谱、清单和尚未同步的更改将从此设备移除。应用设置和服务器地址会保留，你只需重新登录。';

  @override
  String get reloadRecipe => '从服务器重新加载';

  @override
  String get wifiServerTitle => 'Wi-Fi 下使用其他地址';

  @override
  String get wifiServerHint =>
      '适用于同一服务器的第二个地址，例如在家用本地 IP，在外用 ZeroTier、Tailscale 或域名。在下方 Wi-Fi 中应用会自动使用此地址，其他情况下使用上方的服务器 URL。';

  @override
  String get wifiSsidLabel => 'Wi-Fi 名称';

  @override
  String get wifiServerUrl => '此 Wi-Fi 下的地址';

  @override
  String get wifiUseCurrent => '使用当前 Wi-Fi';

  @override
  String get wifiNameUnavailable =>
      '无法读取 Wi-Fi 名称。请连接 Wi-Fi 并允许位置访问 – Android 和 iOS 只有这样才会提供 Wi-Fi 名称。';

  @override
  String wifiServerActive(String ssid) {
    return '当前：Wi-Fi“$ssid”下的地址';
  }

  @override
  String wifiServerStandardActive(String ssid) {
    return '当前：服务器 URL（不在“$ssid”）';
  }

  @override
  String get wifiServerRemove => '移除';

  @override
  String get switchUserTitle => '切换用户';

  @override
  String switchUserBody(String name) {
    return '$name 会保留在此设备上 – 包括所有食谱、清单和尚未同步的更改。你可以通过头像或登录页面切换回来。';
  }

  @override
  String get allowBiometricTitle => '用设备解锁切换回来';

  @override
  String get allowBiometricHint =>
      '使用 Face ID、指纹或设备 PIN 代替密码。任何能解锁此设备的人都能打开此账户。';

  @override
  String get allow => '允许';

  @override
  String unlockAccountReason(String name) {
    return '切换到 $name';
  }

  @override
  String signInAs(String name) {
    return '以 $name 身份登录';
  }

  @override
  String wrongAccountError(String name) {
    return '这是账户“$name”。请使用已保存的账户登录。';
  }

  @override
  String get accountSaveOffline => '目前无法保存账户 – 无法连接服务器。';

  @override
  String get signOutRemoveTitle => '退出并移除';

  @override
  String get signOutRemoveConfirm =>
      '此账户及其在此设备上的所有数据（食谱、清单、尚未同步的更改）都将被移除。应用设置会保留。';

  @override
  String get removeSavedAccount => '从此设备移除';

  @override
  String removeSavedAccountConfirm(String name) {
    return '从此设备移除“$name”及其所有已保存数据？尚未同步的更改将丢失。';
  }

  @override
  String get savedAccountsTitle => '已保存的账户';

  @override
  String get addAccount => '添加其他账户';

  @override
  String get biometricOff => '停止使用设备解锁';

  @override
  String get orNewAccount => '或使用其他账户登录：';

  @override
  String get importVideoTitle => '视频链接';

  @override
  String get importVideoFast => '快速';

  @override
  String get importVideoThorough => '全面（AI）';

  @override
  String get importVideoFastHint =>
      'Mealie 会转录视频，并通过一次 AI 请求生成食谱 – 通常快得多。不翻译，也不添加分类/标签。你仍可以在单次导入时开启 AI。';

  @override
  String get importVideoThoroughHint =>
      '视频链接会自动开启 AI 开关：多个 AI 步骤，按上方设置进行翻译和添加分类/标签。耗时更长。';

  @override
  String get importPresetFast => '快速';

  @override
  String get importPresetThorough => '全面';

  @override
  String get importPresetCustom => '自定义';

  @override
  String get importPresetFastTitle => '尽量少的 AI 步骤 – 等待最短';

  @override
  String get importPresetFastVideo =>
      '视频链接：Mealie 会转录视频，并通过一次 AI 请求生成食谱（AI 开关保持关闭）。';

  @override
  String get importPresetFastTranslate => '不翻译 – 食谱保留原始语言。';

  @override
  String get importPresetFastOrganizers => '只分配已有的分类和标签，不创建新的。';

  @override
  String get importPresetThoroughTitle => 'Mealie 的完整 AI 导入 – 耗时更长，效果最好';

  @override
  String get importPresetThoroughVideo =>
      '视频链接会自动使用 AI 导入 – 分多个步骤（整理来源、生成食谱等）。';

  @override
  String get importPresetThoroughTranslate => '如果食谱是用其他语言写的，会翻译成下方的导入语言。';

  @override
  String get importPresetThoroughOrganizers => '分配合适的分类和标签；缺少的会被创建。';

  @override
  String get importPresetCustomTitle => '自行设置每个选项';

  @override
  String get importPresetCustomBody => '从你之前选择的设置开始，只更改需要的部分 – 例如快速导入视频但带翻译。';

  @override
  String get sidebarPinHint => '提示：长按磁贴并拖到侧边栏即可固定。';

  @override
  String get sidebarDropHere => '拖放到这里';

  @override
  String sidebarShortcutTitle(String name) {
    return '“$name”的快捷键';
  }

  @override
  String sidebarShortcutPrompt(String modifier) {
    return '现在按下你想要的组合键，包括 $modifier。';
  }

  @override
  String get sidebarShortcutTaken => '此组合已被使用。';

  @override
  String get sidebarShortcutNone => '无快捷键';

  @override
  String get sidebarShortcutChange => '更改快捷键';

  @override
  String get sidebarUnpin => '从侧边栏移除';

  @override
  String sidebarFull(int count) {
    return '侧边栏已满 – 最多 $count 个自定义条目。';
  }

  @override
  String get tabletSidebar => '横屏时显示侧边栏';

  @override
  String get tabletSidebarSubtitle => '平板横置时，将导航显示在左侧而不是底部';

  @override
  String get filterDateCreated => '创建日期';

  @override
  String get filterDateUpdated => '修改日期';

  @override
  String get errorUploadTooLarge =>
      '文件对此 Mealie 服务器来说太大。可以通过 MAX_UPLOAD_SIZE_MB 提高服务器的上传上限。';

  @override
  String get recipeDownloadPdfMealie => '下载 PDF（Mealie 布局）';

  @override
  String get mealplanNoteMore => '显示更多…';

  @override
  String get mealplanNoteLess => '收起';

  @override
  String get ingredientCommonlySubstitutedWith => '常用替代品';

  @override
  String requiresMealieVersion(String version) {
    return '需要 Mealie $version 或更高版本。';
  }

  @override
  String get apiTokensTitle => 'API 令牌';

  @override
  String get apiTokensDescription => '管理用于外部程序访问的API令牌。';

  @override
  String get apiTokenNameLabel => '令牌名称';

  @override
  String get apiTokenGenerate => '生成';

  @override
  String get apiTokensActive => '当前激活令牌';

  @override
  String get apiTokenCopyWarning => '复制此令牌与外部应用程序一起使用。此令牌将无法再次查看。';

  @override
  String get apiTokenThisApp => '此应用正在使用';

  @override
  String get apiTokenThisAppHint => '此令牌用于保持应用登录，无法在此删除。';

  @override
  String apiTokenDeleteConfirm(String name) {
    return '删除令牌“$name”？使用它的应用将立即失去访问权限。';
  }

  @override
  String get apiTokensEmpty => '还没有令牌。';

  @override
  String apiTokenCreatedOn(String date) {
    return '创建于 $date';
  }

  @override
  String get apiTokenCopied => '令牌已复制';

  @override
  String get qfOpHasNoValue => '没有值';

  @override
  String get qfOpHasValue => '有值';

  @override
  String get ratingHouseholdAverage => '家庭平均';

  @override
  String get stepLinkedNotes => '关联的备注';

  @override
  String get noteFallbackTitle => '备注';

  @override
  String get aiPromptTitleEnrichInstructions => '添加步骤详情';

  @override
  String get aiPromptDescEnrichInstructions =>
      '将导入食谱的每个步骤与其使用的食材和备注关联，并提取其时长和标题。';

  @override
  String get loginAccountLocked => '账户已被锁定，请稍后再试。';

  @override
  String get loginPasswordDisabled => '此服务器已禁用密码登录。请改用 API 令牌。';

  @override
  String get unitSystemTitle => '单位';

  @override
  String get unitSystemAsWritten => '按原文';

  @override
  String get unitSystemMetric => '公制';

  @override
  String get unitSystemMetricHint => '公制 (g, ml)';

  @override
  String get unitSystemImperial => '英制';

  @override
  String get unitSystemImperialHint => '英制 (杯, 盎司)';

  @override
  String get unitSystemHint => '仅影响显示 – 食谱本身不变。与 Mealie 网页版一样，此选择适用于此设备上的所有食谱。';

  @override
  String get unitSystemUnavailable =>
      '此食谱的单位都无法换算。换算需要在 Mealie 中为单位设置标准化（食品和单位 → 单位 → 标准化）。';

  @override
  String get shoppingCheckAll => '勾选所有项目';

  @override
  String get shoppingUncheckAll => '取消勾选所有项目';

  @override
  String get shoppingDeleteChecked => '删除选中';

  @override
  String get shoppingCheckAllConfirm => '您确定要选择所有项目吗？';

  @override
  String get shoppingUncheckAllConfirm => '您确定要取消选中所有项目吗？';

  @override
  String shoppingItemCheckedOff(String item) {
    return '已勾除 $item';
  }

  @override
  String get updateGithubUnavailable => 'GitHub 目前没有响应。请几分钟后再试。';
}

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class AppLocalizationsZhTw extends AppLocalizationsZh {
  AppLocalizationsZhTw() : super('zh_TW');

  @override
  String get endCookingMode => '結束烹飪模式';

  @override
  String get endCookingModeConfirm => '確定要結束烹飪模式嗎？';

  @override
  String endCookingModeConfirmAll(int count) {
    return '將結束烹飪模式中的全部 $count 個食譜。要繼續嗎？';
  }

  @override
  String get addTimer => '新增計時器';

  @override
  String get recipeFinished => '你的料理完成了。';

  @override
  String get bonAppetit => '祝你用餐愉快！';

  @override
  String get prepareIngredients => '請準備以下食材';

  @override
  String prepareIngredientsFor(String servings) {
    return '請準備 $servings 人份的以下食材';
  }

  @override
  String get next => '下一步';

  @override
  String get navHome => '主頁';

  @override
  String get homeCookToday => '今天煮';

  @override
  String get homeSuggestion => '推薦';

  @override
  String get homeQuickAccess => '快速存取';

  @override
  String get homePlanned => '已規劃';

  @override
  String get favorite => '最愛';

  @override
  String get navSettings => '設定';

  @override
  String homeWelcomeName(Object name) {
    return '歡迎你，$name，';
  }

  @override
  String get homeWelcomeApp => '來到 Mealie Recipes 👋';

  @override
  String get theme => '外觀';

  @override
  String get themeSystem => '系統';

  @override
  String get themeLight => '淺色';

  @override
  String get themeDark => '深色';

  @override
  String get recipes => '食譜';

  @override
  String get shoppingList => '🛒 購物清單';

  @override
  String get mealplan => '用餐計畫';

  @override
  String get settings => '⚙️ 設定';

  @override
  String get searchRecipe => '搜尋食譜...';

  @override
  String get loadingRecipe => '載入食譜中...';

  @override
  String get errorLoadingRecipe => '無法載入食譜。';

  @override
  String get noRecipesForCategory => '沒有符合此篩選條件的食譜。';

  @override
  String get resetFilter => '重設篩選';

  @override
  String get allCategories => '全部目錄';

  @override
  String get all => '全部';

  @override
  String get sortRecipes => '食譜排序';

  @override
  String get refreshRecipes => '重新整理';

  @override
  String get sortNameAZ => '名稱 A–Z';

  @override
  String get sortNameZA => '名稱 Z–A';

  @override
  String get sortDateNewest => '最新優先';

  @override
  String get sortDateOldest => '最舊優先';

  @override
  String get sortPrepTimeShort => '準備時間最短';

  @override
  String get sortPrepTimeLong => '準備時間最長';

  @override
  String get sortRatingHighest => '評分最高';

  @override
  String get sortRatingLowest => '評分最低';

  @override
  String get details => '詳細資料';

  @override
  String get ingredients => '食材';

  @override
  String get instructions => '做法';

  @override
  String get tags => '標籤';

  @override
  String get notes => '備註';

  @override
  String get addNote => '新增備註';

  @override
  String get editNote => '編輯備註';

  @override
  String get noteTitleHint => '標題（選填）';

  @override
  String get noteTextHint => '備註內容';

  @override
  String get deleteNoteTitle => '刪除備註？';

  @override
  String get deleteNoteMessage => '此備註將被永久刪除。';

  @override
  String get servings => '份量';

  @override
  String get planMeal => '安排餐點';

  @override
  String get addAllIngredients => '新增全部食材';

  @override
  String get addSelectedIngredients => '新增所選食材';

  @override
  String get addIngredientsMessage => '食材已加入購物清單。';

  @override
  String addIngredientsFailedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '有 $count 項食材無法加入。',
      one: '有 1 項食材無法加入。',
    );
    return '$_temp0';
  }

  @override
  String get cookbooks => '食譜';

  @override
  String get cookbooksEmpty => '還沒有食譜集。點選右上角的「+」建立一個。';

  @override
  String get cookbookNoMatches => '沒有符合此篩選條件的食譜。';

  @override
  String get cookbookCreateTitle => '建立食譜集';

  @override
  String get cookbookEditTitle => '編輯食譜集';

  @override
  String get cookbookNameLabel => '食譜集名稱';

  @override
  String get cookbookFilterSectionTitle => '自動加入食譜';

  @override
  String get cookbookFieldTools => '工具';

  @override
  String get cookbookFieldUsers => '使用者';

  @override
  String get cookbookOpIsOneOf => '是其中之一';

  @override
  String get cookbookOpIsNotOneOf => '不是其中之一';

  @override
  String get cookbookOpContainsAll => '包含全部';

  @override
  String get cookbookSelectValues => '選擇值';

  @override
  String get cookbookFilterOptionsUnavailable => '沒有可用選項';

  @override
  String get cookbookAddFilterField => '新增欄位';

  @override
  String get cookbookPublicLabel => '公開食譜集';

  @override
  String get cookbookPublicSubtitle => '伺服器上的其他家庭群組也看得到';

  @override
  String get cookbookRawModeEnter => '以文字編輯';

  @override
  String get cookbookRawModeExit => '返回建構器';

  @override
  String get cookbookRawModeHint =>
      '本 App 的專家模式：直接以文字編輯篩選條件。當現有篩選條件無法拆成簡單的列時很實用。';

  @override
  String get cookbookRawModeUnparseable => '此文字不符合簡單的列格式 — 會保留為文字。';

  @override
  String get saveFailed => '儲存失敗';

  @override
  String get search => '搜尋';

  @override
  String get apply => '套用';

  @override
  String get setupCachingTitle => '正在載入你的食譜';

  @override
  String get setupCachingSubtitle => '正在為離線使用準備你的食譜。視數量而定，可能需要一點時間。';

  @override
  String get setupCachingDone => '全部就緒！';

  @override
  String get setupTipsHeader => '你知道嗎？';

  @override
  String get setupFinish => '開始吧';

  @override
  String get setupSkipCaching => '在背景繼續';

  @override
  String get setupTip1 => '你可以從連結、照片或 PDF 匯入食譜 — 透過主畫面上的「匯入」方塊。';

  @override
  String get setupTip2 => '烹飪模式會讓螢幕保持開啟，一步步引導你，並自動辨識文中的計時。';

  @override
  String get setupTip3 => '購物清單離線也能用 — 連得上伺服器後會自動同步變更。';

  @override
  String get setupTip4 => '長按主畫面上的方塊即可重新排列快速存取。';

  @override
  String get setupTip5 => '你的 Mealie 食譜集在「食譜集」方塊中 — 離線也能用。';

  @override
  String get ok => '確定';

  @override
  String get cancel => '取消';

  @override
  String get delete => '刪除';

  @override
  String get edit => '編輯';

  @override
  String get save => '儲存';

  @override
  String get done => '完成';

  @override
  String get close => '關閉';

  @override
  String get add => '新增';

  @override
  String get send => '傳送';

  @override
  String get retry => '重試';

  @override
  String get confirmDeleteTitle => '刪除食譜？';

  @override
  String get confirmDeleteMessage => '此動作無法復原。';

  @override
  String get sendToDevice => '傳送到裝置';

  @override
  String get timerFinished => '計時結束！';

  @override
  String get timer => '計時器';

  @override
  String get newTimer => '新計時器';

  @override
  String get timerNamePlaceholder => '計時器名稱';

  @override
  String get durationLabel => '時長';

  @override
  String get start => '開始';

  @override
  String get stop => '停止';

  @override
  String get pause => '暫停';

  @override
  String get resume => '繼續';

  @override
  String get finished => '完成！';

  @override
  String stepNumber(int number) {
    return '第 $number 步';
  }

  @override
  String get minAbbreviation => '分鐘';

  @override
  String get cookingMode => '烹飪模式';

  @override
  String get endAll => '全部結束';

  @override
  String get end => '結束';

  @override
  String get noActiveTimers => '沒有正在執行的計時器';

  @override
  String get noActiveRecipes => '沒有進行中的食譜';

  @override
  String get startRecipeToCook => '開啟食譜並點選烹飪模式按鈕即可開始。';

  @override
  String get browseRecipes => '瀏覽食譜';

  @override
  String get cookFriends => '和朋友一起下廚';

  @override
  String get cookingModeAddRecipe => '新增食譜';

  @override
  String get cookingModeAddRecipeSearchHint => '搜尋食譜';

  @override
  String get cookFriendsCode => '工作階段代碼';

  @override
  String get cookFriendsJoin => '加入工作階段';

  @override
  String get cookFriendsHost => '發起工作階段';

  @override
  String get cookFriendsHostNotFound =>
      '找不到主持裝置。請確認兩台裝置連上同一個 Wi-Fi，且已允許存取區域網路。';

  @override
  String get cookFriendsConnectionFailed => '連線失敗，請再試一次。';

  @override
  String get cookFriendsEnterCode => '輸入代碼';

  @override
  String cookFriendsConnected(int count) {
    return '已連線：$count 位訪客';
  }

  @override
  String get joinSession => '加入工作階段';

  @override
  String get hostEndedSessionMessage => '主持人已結束烹飪工作階段。';

  @override
  String get addItem => '新增項目';

  @override
  String get itemNote => '品項名稱';

  @override
  String get unlabeledCategory => '未加標籤';

  @override
  String get archivedLists => '📦 已封存的採買';

  @override
  String get postimportAction => '匯入後';

  @override
  String get postimportHint => '選擇在來源 App（提醒事項 / Google Tasks）中如何處理已匯入的項目。';

  @override
  String get postimportLeave => '只新增';

  @override
  String get postimportComplete => '標記完成';

  @override
  String get postimportCompleteDelete => '標記完成並刪除';

  @override
  String get postimportFailed => '來源 App 中的後續處理失敗。品項仍已加入 Mealie。';

  @override
  String get syncChangesTitle => '同步變更';

  @override
  String get syncSectionChecked => '已勾選';

  @override
  String get syncSectionQuantity => '數量';

  @override
  String get syncSectionCategory => '目錄';

  @override
  String get syncSectionAdditions => '新加入';

  @override
  String get syncLocalLabel => '本機';

  @override
  String get syncServerLabel => '伺服器';

  @override
  String get syncNow => '立即同步';

  @override
  String get offlineBadge => '離線';

  @override
  String get mealplanTitle => '📅 用餐計畫';

  @override
  String get breakfast => '早餐';

  @override
  String get lunch => '午餐';

  @override
  String get dinner => '晚餐';

  @override
  String get addMealEntry => '新增餐點';

  @override
  String get selectRecipe => '選擇食譜';

  @override
  String get importRecipe => '匯入食譜';

  @override
  String get url => '網址';

  @override
  String get importLanguage => 'OCR 語言';

  @override
  String get setupTitle => '歡迎使用 Mealie Recipes';

  @override
  String get setupSubtitle => '請設定你的 Mealie 伺服器。';

  @override
  String get serverUrl => '伺服器 URL';

  @override
  String get serverUrlPlaceholder => 'https://mealie.example.com';

  @override
  String get apiToken => 'API 密鑰';

  @override
  String get apiTokenPlaceholder => '你的 API 權杖';

  @override
  String get householdId => '家庭群組';

  @override
  String get householdIdPlaceholder => '家庭';

  @override
  String get shoppingListId => '購物清單 ID';

  @override
  String get setupHouseholdListTitle => '家庭群組與購物清單';

  @override
  String get shoppingListLabel => '購物清單';

  @override
  String get setupHouseholdManualHint => '無法載入家庭群組 — 請手動輸入名稱。';

  @override
  String get setupExactTitle => '購物清單上的數量';

  @override
  String get setupExactBody =>
      '多數國家買東西不會精確到公克 — 放進購物車的是 1 盒奶油，而不是 200 g。因此在簡單模式下，App 會把食譜用量換算成「1×」。在精確模式下，數量和單位會像 Mealie 網頁版一樣 1:1 保留 — 輸入新品項時也一樣（例如「200 g 奶油」）。你隨時可以在設定中變更。';

  @override
  String get setupExactSimpleTitle => '簡單模式（1×）';

  @override
  String get setupExactSimpleBody => '食材會以「1× 品項」加入清單 — 方便在店裡快速勾選。';

  @override
  String get setupExactExactTitle => '精確數量';

  @override
  String get setupExactExactBody => '品項會顯示數量和單位，例如「200 g 奶油」— 與網頁版完全相同。';

  @override
  String get connect => '連線';

  @override
  String connectionError(String error) {
    return '連線失敗：$error';
  }

  @override
  String get optionalHeaders => '選用的 HTTP 標頭（用於反向代理）';

  @override
  String get settingsTitle => '⚙️ 設定';

  @override
  String get settingsSaved => '設定已儲存';

  @override
  String get securitySettings => '安全性';

  @override
  String get showRecipeImages => '顯示食譜圖片';

  @override
  String get apiVersion => 'API 版本';

  @override
  String get language => '語言';

  @override
  String get biometricLock => '生物辨識鎖定';

  @override
  String get biometricLockDescription => '使用生物辨識解鎖 App';

  @override
  String get enableLogging => '啟用記錄';

  @override
  String get selectLanguage => '選擇語言';

  @override
  String get setupContinue => '繼續';

  @override
  String get back => '返回';

  @override
  String get setupConnectStep => '連線到你的伺服器';

  @override
  String get resetSettings => '重設所有設定';

  @override
  String get resetSettingsConfirm => '將重設所有設定。要繼續嗎？';

  @override
  String get guestMode => '訪客模式';

  @override
  String get appVersion => '版本';

  @override
  String get leftoverFinder => '食譜搜尋器';

  @override
  String get addIngredient => '新增食材';

  @override
  String get biometricPrompt => '驗證身分以開啟 Mealie Recipes';

  @override
  String get biometricFailed => '驗證失敗';

  @override
  String get pendingRecipesTitle => '收到的食譜';

  @override
  String pendingRecipesFrom(Object names) {
    return '來自 $names';
  }

  @override
  String get pendingRecipesOpenCooking => '開啟烹飪模式';

  @override
  String get dismiss => '關閉';

  @override
  String get editRecipe => '編輯食譜';

  @override
  String get recipeName => '食譜名稱';

  @override
  String get prepTime => '準備時間（分鐘）';

  @override
  String get cookTime => '烹調時間（分鐘）';

  @override
  String get totalTime => '總時間（分鐘）';

  @override
  String get recipeServings => '份量';

  @override
  String get rating => '評分';

  @override
  String get addIngredientLine => '新增食材';

  @override
  String get addInstruction => '新增步驟';

  @override
  String get removeIngredient => '移除食材';

  @override
  String get removeInstruction => '移除步驟';

  @override
  String get ingredientName => '食材';

  @override
  String get ingredientQuantity => '數量';

  @override
  String get ingredientUnit => '單位';

  @override
  String get ingredientNote => '備註';

  @override
  String get instructionText => '步驟內容';

  @override
  String get categories => '目錄';

  @override
  String get saveChanges => '儲存變更';

  @override
  String get saveSuccess => '食譜已儲存。';

  @override
  String get newCategory => '新目錄';

  @override
  String get newTag => '新標籤';

  @override
  String get setRating => '評分';

  @override
  String get homeWelcome => '歡迎使用 Mealie Recipes！👋';

  @override
  String homeWelcomeNamed(String name) {
    return '$name，歡迎使用 Mealie Recipes！👋';
  }

  @override
  String get shopping => '購物';

  @override
  String get planning => '規劃';

  @override
  String get other => '其他';

  @override
  String get addRecipe => '➕ 新增食譜';

  @override
  String get completeShopping => '完成採買';

  @override
  String get shoppingCompleted => '採買完成';

  @override
  String get shoppingCompletedSubtitle => '全都放進購物車了！🎉';

  @override
  String get shoppingOfflineNoCache => '離線 – 清單未儲存';

  @override
  String get shoppingOfflineNoCacheSubtitle => '此裝置上還沒有儲存這個清單的品項。恢復連線後會立即載入。';

  @override
  String get essensplan => '📅 用餐計畫';

  @override
  String get resteverwertung => '🥗 食譜搜尋';

  @override
  String get copyCode => '複製代碼';

  @override
  String get shareLink => '分享連結';

  @override
  String get connectedFriends => '已連線的朋友';

  @override
  String get waitingForFriends => '正在等待朋友...';

  @override
  String get sessionCode => '工作階段代碼';

  @override
  String get loading => '載入中...';

  @override
  String get urlInvalidScheme => 'URL 必須以 http:// 或 https:// 開頭';

  @override
  String get urlAddScheme => '加上 https://';

  @override
  String get addItemPlaceholder => '新增品項...';

  @override
  String get completedItems => '已完成';

  @override
  String get completeShoppingTitle => '完成採買？';

  @override
  String get completeShoppingMessage => '刪除已完成的品項？';

  @override
  String get recipeListTitle => '📖 食譜';

  @override
  String get importRecipeTitle => '上傳新食譜';

  @override
  String get uploadRecipeUrl => '透過食譜 URL 匯入';

  @override
  String get uploadRecipeUrlHint => '輸入食譜 URL，將其儲存到你的伺服器';

  @override
  String get uploadOpenAI => '透過 OpenAI 從檔案匯入';

  @override
  String get uploadOpenAIHint => '也可以上傳食譜的照片或 PDF。如果食譜有多頁，新增多張即可 — AI 會一起分析。';

  @override
  String get takePhoto => '相機';

  @override
  String get cameraPermissionDenied => '無法存取相機。請在系統設定中允許，以便拍攝食譜。';

  @override
  String get cameraUnavailable => '此裝置沒有可用的相機。';

  @override
  String get selectPhoto => '照片';

  @override
  String get selectPdf => 'PDF';

  @override
  String get openAIHintTitle => '檔案分析說明';

  @override
  String get openAIHintBody =>
      '食譜分析使用 OpenAI API。請確認已在 Mealie 伺服器設定中設定 API 金鑰。';

  @override
  String get allDeleteConfirm => '全部刪除';

  @override
  String get entriesInOtherWeeks => '其他週有項目';

  @override
  String get availableWeeks => '可用的週：';

  @override
  String get currentWeek => '本週';

  @override
  String get weekAbbreviation => '週';

  @override
  String get today => '今天';

  @override
  String get selectDate => '選擇日期';

  @override
  String get selectedRecipe => '已選食譜';

  @override
  String get confirmMeal => '安排餐點';

  @override
  String get searchRecipes => '搜尋食譜';

  @override
  String get addCustomMeal => '新增自訂餐點';

  @override
  String get diceModeButton => '隨機抽食譜';

  @override
  String get diceModeTitle => '3 個隨機推薦';

  @override
  String get diceBackToSearch => '返回搜尋';

  @override
  String get diceNotEnoughRecipes => '食譜不足，無法使用骰子模式（至少需要 3 個）';

  @override
  String get entrySingular => '項';

  @override
  String get entriesPlural => '項';

  @override
  String get deleteAllConfirmTitle => '全部刪除？';

  @override
  String get deleteAllConfirmMessage => '要刪除所有已封存的採買嗎？';

  @override
  String get uploadFromUrlButton => '從 URL 匯入食譜';

  @override
  String get uploadingImage => '上傳中...';

  @override
  String get uploadErrorTitle => '上傳失敗';

  @override
  String get uploadSuccessTitle => '上傳成功';

  @override
  String get editImportedRecipeQuestion => '要現在編輯新食譜嗎？';

  @override
  String get notNow => '稍後';

  @override
  String get pdfTooLarge => 'PDF 檔案過大（最大 10 MB）。';

  @override
  String get invalidUrl => 'URL 無效。請輸入有效的 HTTP(S) URL。';

  @override
  String get cookWithFriends => '和朋友一起下廚';

  @override
  String get cookFriendsSubtitle => '邀請朋友一起做這道料理';

  @override
  String get copied => '已複製';

  @override
  String get linkCopied => '已複製連結';

  @override
  String get startCooking => '開始烹飪';

  @override
  String get uploadToOwnServer => '儲存到我的伺服器';

  @override
  String get uploadingRecipe => '正在上傳食譜…';

  @override
  String get recipeUploadedToOwnServer => '食譜已儲存到你的伺服器';

  @override
  String get recipeUploadFailed => '上傳失敗';

  @override
  String get allowGuestSaveRecipes => '允許訪客將食譜儲存到自己的伺服器';

  @override
  String get appIcon => 'App 圖示';

  @override
  String get name => '名稱';

  @override
  String get color => '色彩';

  @override
  String get randomColor => '隨機顏色';

  @override
  String get createFailed => '無法建立';

  @override
  String get deleteFailed => '無法刪除';

  @override
  String deleteOrganizerConfirm(String name) {
    return '刪除「$name」？伺服器上也會一併刪除。';
  }

  @override
  String get connectionSection => '連線';

  @override
  String get token => '權杖';

  @override
  String get advancedOptions => '進階選項';

  @override
  String get mealieApiVersion => 'Mealie API 版本';

  @override
  String get sendOptionalHeaders => '傳送選用標頭';

  @override
  String get offlineRecipeImages => '離線儲存食譜圖片';

  @override
  String get offlineRecipeImagesHint =>
      '將所有食譜圖片（包括步驟和備註中的圖片）下載到裝置，沒有網路時也能顯示。大型收藏可能佔用數百 MB。關閉後會刪除已儲存的圖片。';

  @override
  String offlineRecipeImagesStatus(int count, int total, String size) {
    return '已儲存：$count/$total · $size';
  }

  @override
  String get offlineRecipeImagesDisableConfirm => '刪除所有已儲存的食譜圖片？';

  @override
  String headerNameLabel(int n) {
    return '標頭 $n 名稱';
  }

  @override
  String headerValueLabel(int n) {
    return '標頭 $n 值';
  }

  @override
  String get value => '值';

  @override
  String get personalization => '個人化';

  @override
  String get showRecipeImagesSubtitle => '在食譜清單中顯示圖片';

  @override
  String get exactQuantities => '新增精確數量';

  @override
  String get exactQuantitiesSubtitle =>
      '食材和輸入的品項會保留數量和單位（例如 200 g 奶油），而不是每項 1×';

  @override
  String get remindToShop => '採買提醒';

  @override
  String get remindToShopSubtitle => '當你靠近已儲存的地點且購物清單還有未完成的品項時提醒你 — 即使 App 已關閉';

  @override
  String get shoppingReminderAddLocation => '新增地點';

  @override
  String get shoppingReminderMaxLocations => '已達最多 3 個地點';

  @override
  String get shoppingReminderLocationServiceDisabled => '此裝置已關閉定位服務';

  @override
  String get shoppingReminderPermissionTitle => '需要位置存取權';

  @override
  String get shoppingReminderPermissionMessage =>
      '要在你靠近商店時提醒你，需要「永遠」允許位置存取 — 即使 App 已關閉。請在設定中開啟。';

  @override
  String get openSettings => '開啟設定';

  @override
  String get shoppingReminderLocationName => '名稱';

  @override
  String get shoppingReminderUseCurrentLocation => '使用目前位置';

  @override
  String get shoppingReminderOrAddress => '或輸入地址';

  @override
  String get shoppingReminderAddress => '地址';

  @override
  String get shoppingReminderAddressPlaceholder => '街道，城市';

  @override
  String get shoppingReminderSearchAddress => '搜尋';

  @override
  String get shoppingReminderLocationFailed => '無法判斷你的位置';

  @override
  String get shoppingReminderAddressNotFound => '找不到地址';

  @override
  String get ratingFailed => '無法儲存評分 — 請再試一次。';

  @override
  String get lastCooked => '上次製作';

  @override
  String get syncLastCooked => '更新「上次製作」';

  @override
  String get syncLastCookedSubtitle => '在伺服器上儲存今天的日期和一筆時間軸記錄 — 與 Mealie 網頁版相同。';

  @override
  String get developer => '開發者';

  @override
  String get enableLoggingSubtitle => '記錄輸出/錯誤日誌（最近 500 行）';

  @override
  String get entriesLabel => '項目';

  @override
  String get fileSize => '檔案大小';

  @override
  String get showAction => '顯示';

  @override
  String get copy => '複製';

  @override
  String logsWithCount(int count) {
    return '日誌（$count）';
  }

  @override
  String get noLogs => '沒有日誌';

  @override
  String get logsTitle => '日誌';

  @override
  String get required => '必填';

  @override
  String get connectionFailedCheck => '連線失敗。請檢查 URL 和權杖。';

  @override
  String get username => '使用者名稱';

  @override
  String get password => '密碼';

  @override
  String get setupPasswordHint =>
      '不會儲存你的密碼 — App 只登入一次並據此產生 API 權杖（與網頁版的 個人檔案 → API 權杖 相同）。';

  @override
  String get loginAndConnect => '登入並連線';

  @override
  String get loginInvalidCredentials => '使用者名稱或密碼不正確。';

  @override
  String get apiTokenSaveHint => '已套用權杖 — 請點選下方的「儲存變更」。';

  @override
  String get renewApiToken => '更新 API 權杖';

  @override
  String get setupAuthChoiceTitle => '你想如何登入？';

  @override
  String get authModePasswordTitle => '讓 App 為我建立 API 金鑰';

  @override
  String get authModePasswordSubtitle => '使用使用者名稱和密碼登入 — App 會自動產生權杖。';

  @override
  String get authModeTokenTitle => '我已有 API 金鑰';

  @override
  String get authModeTokenSubtitle => '從 Mealie 個人檔案複製（個人檔案 → API 權杖）。';

  @override
  String keyN(int n) {
    return '金鑰 $n';
  }

  @override
  String valueN(int n) {
    return '值 $n';
  }

  @override
  String get openCookingMode => '開啟烹飪模式';

  @override
  String activeRecipes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 個進行中的食譜',
    );
    return '$_temp0';
  }

  @override
  String get reparseIngredients => '重新解析食材';

  @override
  String get reparseIngredientsSubtitle => '拆分數量/單位/食材（例如「200 g 麵粉」）';

  @override
  String get reparseDone => '食材已拆分 – 點選「儲存變更」以套用';

  @override
  String get tagsAndCategories => '標籤、目錄和工具';

  @override
  String get tapToAddPhoto => '點選以新增照片';

  @override
  String get descriptionLabel => '描述';

  @override
  String get searchingDevices => '正在搜尋同一 Wi-Fi 上的裝置…';

  @override
  String get selectAll => '全選';

  @override
  String get importReminders => '匯入提醒事項';

  @override
  String get importGoogleTasks => '匯入 Google Tasks';

  @override
  String get noTaskLists => '找不到工作清單';

  @override
  String get noReminderLists => '找不到提醒事項清單';

  @override
  String importCount(int count) {
    return '匯入 $count 項';
  }

  @override
  String get noIngredientsToLink => '目前沒有可連結的食材';

  @override
  String get importLanguageSubtitle => '從照片或 PDF 匯入的食譜所用語言';

  @override
  String get importLanguageSearch => '搜尋語言';

  @override
  String get importLanguageFollowApp => '與 App 語言相同';

  @override
  String get importLanguageNoMatch => '找不到語言';

  @override
  String get setupImportLanguageTitle => 'AI 匯入食譜';

  @override
  String get setupImportLanguageBody =>
      'AI 可以把照片和 PDF 轉成食譜。選擇最後要使用的語言 — 如果你的母語不在 App 語言中，這會很實用。之後可以在設定中變更。';

  @override
  String get setupImportLanguageSearchHint => '使用選擇器中的搜尋，可以找到 App 介面未提供的語言。';

  @override
  String get setupCachingKeepOpenTitle => '請保持 App 開啟';

  @override
  String get setupCachingKeepOpenBody =>
      '載入在前景進行。請在完成前保持 App 開啟 — 如果關閉或切換到其他 App 太久，程序會中斷，稍後重新開始。';

  @override
  String get supportContact => '聯絡支援';

  @override
  String get supportDialogMessage =>
      '描述你的問題，我們會回覆你。日誌對排解問題很有幫助 — 你可以將它作為文字檔附上。';

  @override
  String get supportWithoutLogs => '不附日誌';

  @override
  String get supportWithLogs => '附上日誌';

  @override
  String get supportMailSubject => 'Mealie Recipes — 支援';

  @override
  String get supportMailHint => '請在此描述你的問題：';

  @override
  String get supportLogsEmpty => '日誌是空的。請開啟記錄，重現問題後再傳送。';

  @override
  String supportAddressCopied(String email) {
    return '已複製地址：$email';
  }

  @override
  String supportNoMailApp(String email) {
    return '未設定郵件 App – 已複製地址：$email。請選擇其他 App 聯絡我們。';
  }

  @override
  String get createRecipeFromImages => '建立食譜';

  @override
  String imagePagesSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已選擇 $count 頁',
    );
    return '$_temp0';
  }

  @override
  String get imagePagesHint => '第一張圖片會成為食譜的主圖。長按頁面可調整順序。';

  @override
  String get mainImageBadge => '主圖';

  @override
  String maxImagesReached(int max) {
    return '每個食譜最多可新增 $max 張圖片。';
  }

  @override
  String get removePage => '移除頁面';

  @override
  String get preparingPdf => '正在處理 PDF...';

  @override
  String get recipeOptionsTitle => '選項';

  @override
  String get exportAsPdf => '匯出為 PDF';

  @override
  String get generatingPdf => '正在產生 PDF…';

  @override
  String get pdfExportFailed => 'PDF 匯出失敗';

  @override
  String get recipeTime => '時間';

  @override
  String get addIngredientSection => '新增分區';

  @override
  String get aiImportToggle => '使用 AI 分析';

  @override
  String get aiImportToggleHint =>
      '也適用於食譜影片（YouTube、Instagram、TikTok …）以及一般匯入無法讀取的頁面。需要在 Mealie 伺服器上設定 AI 提供者 — 影片還需要音訊提供者。';

  @override
  String get aiImportButton => '使用 AI 匯入';

  @override
  String get aiImportRunning => 'AI 正在分析連結 … 影片可能需要幾分鐘。';

  @override
  String get aiImportFailed => 'AI 匯入失敗。請檢查 Mealie 伺服器上的 AI 設定。';

  @override
  String get stepHeadingLabel => '步驟標題（選填）';

  @override
  String get linkedRecipeLabel => '連結的食譜';

  @override
  String get toolsTitle => '工具';

  @override
  String get prepareTools => '請準備以下工具';

  @override
  String get newTool => '新工具';

  @override
  String get renameAction => '重新命名';

  @override
  String get organizerEmpty => '這裡還沒有內容。點選右上角的「+」建立一個。';

  @override
  String organizerRecipeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 個食譜',
      zero: '沒有食譜',
    );
    return '$_temp0';
  }

  @override
  String get toolOnHand => '已有';

  @override
  String get mealDiceSettingsHint =>
      '為每一餐選擇目錄和標籤。擲骰子時只會推薦至少包含其中之一的食譜。同一項可用於多餐。';

  @override
  String get mealDiceSettingsNoneHint =>
      '此餐未選擇任何項目：骰子會依「早餐」「午餐」或「晚餐」等目錄名稱自動選擇。';

  @override
  String get mealDiceAutoHintTitle => '自動選擇';

  @override
  String get mealDiceAutoHintBody =>
      '此餐尚未設定目錄或標籤。因此骰子會尋找「早餐」「午餐」或「晚餐」等目錄，並以其他食譜補足。\n\n如要自行選擇：在用餐計畫中點選「+」旁的齒輪圖示。';

  @override
  String get dontShowAgain => '不再顯示';

  @override
  String get mealDiceNoMatches => '沒有符合此餐所選目錄和標籤的食譜。';

  @override
  String mealDiceFewMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '只有 $count 個符合的食譜',
    );
    return '$_temp0';
  }

  @override
  String get commentsTitle => '留言';

  @override
  String get commentHint => '撰寫留言…';

  @override
  String get commentSaveFailed => '無法儲存留言。';

  @override
  String get commentDeleteConfirm => '刪除這則留言？';

  @override
  String get cookingDoneCommentLabel => '留言（選填）';

  @override
  String get cookingDoneCommentHint => '做得如何？給下次的小提示…';

  @override
  String get nutritionTitle => '營養成分';

  @override
  String get nutritionPerServing => '每份';

  @override
  String get nutritionCalories => '卡路里';

  @override
  String get nutritionFat => '脂肪';

  @override
  String get nutritionSaturatedFat => '飽和脂肪';

  @override
  String get nutritionTransFat => '反式脂肪';

  @override
  String get nutritionUnsaturatedFat => '不飽和脂肪';

  @override
  String get nutritionCholesterol => '膽固醇';

  @override
  String get nutritionSodium => '鈉';

  @override
  String get nutritionCarbohydrates => '碳水化合物';

  @override
  String get nutritionFiber => '纖維';

  @override
  String get nutritionSugar => '糖';

  @override
  String get nutritionProtein => '蛋白質';

  @override
  String get timelineTitle => '時間軸';

  @override
  String get timelineMadeThis => '我做過了';

  @override
  String timelineUserMadeThis(String name) {
    return '$name 做過了';
  }

  @override
  String get timelineEmpty => '時間軸上還沒有記錄。';

  @override
  String get timelineDate => '日期';

  @override
  String get timelineNoteHint => '備註（選填）';

  @override
  String get timelineAddPhoto => '新增照片';

  @override
  String get timelineRemovePhoto => '移除照片';

  @override
  String get timelineSaved => '已加入時間軸';

  @override
  String get timelineSaveFailed => '無法加入時間軸';

  @override
  String get timelineImageFailed => '記錄已儲存，但照片上傳失敗';

  @override
  String get timelineDeleteConfirm => '從時間軸刪除這筆記錄？';

  @override
  String get timelineEditNote => '編輯備註';

  @override
  String get timelineUnknownRecipe => '找不到食譜';

  @override
  String get cookingDonePhotoHint => '用於 Mealie 時間軸的照片（選填）';

  @override
  String get assetsTitle => '附件';

  @override
  String get assetsAdd => '新增附件';

  @override
  String get assetsChooseFile => '檔案';

  @override
  String get assetsUploading => '上傳中…';

  @override
  String get assetsUploadFailed => '附件上傳失敗';

  @override
  String assetsDeleteConfirm(String name) {
    return '從附件中移除「$name」？';
  }

  @override
  String get assetsOpenFailed => '無法開啟附件';

  @override
  String get assetsUnsupported => 'Mealie 只支援 PDF、圖片、TXT、MD、CSV 和 JSON。';

  @override
  String get assetsShare => '分享';

  @override
  String get mealRulesTitle => 'Mealie 規則';

  @override
  String get mealRulesHint =>
      'Mealie 網頁版也會使用。如果某天某餐適用多條規則，則必須全部符合。如果沒有適用的規則，骰子會從所有食譜中選擇。';

  @override
  String get mealRuleAdd => '新增規則';

  @override
  String get mealRuleNewTitle => '新規則';

  @override
  String get mealRuleEditTitle => '編輯規則';

  @override
  String get mealRuleDay => '日期';

  @override
  String get mealRuleAnyDay => '任何一天';

  @override
  String get mealRuleMealType => '餐別';

  @override
  String get mealRuleAnyMeal => '任何餐別';

  @override
  String get mealRuleConditionsTitle => '條件';

  @override
  String get mealRuleAllRecipes => '所有食譜';

  @override
  String get mealRuleDeleteConfirm => '刪除此規則？';

  @override
  String get mealRulesOffline => 'Mealie 規則目前無法使用 – 骰子會使用 App 中的選擇。';

  @override
  String get mealRulesNoMatches => '沒有符合此餐 Mealie 規則的食譜。';

  @override
  String get mealTypeSide => '配菜';

  @override
  String get mealTypeSnack => '點心';

  @override
  String get mealTypeDrink => '飲品';

  @override
  String get mealTypeDessert => '甜點';

  @override
  String get foodsTitle => '食材';

  @override
  String get unitsTitle => '單位';

  @override
  String get newFood => '新食材';

  @override
  String get newUnit => '新單位';

  @override
  String get editFood => '編輯食材';

  @override
  String get editUnit => '編輯單位';

  @override
  String get pluralNameLabel => '複數名稱';

  @override
  String get abbreviationLabel => '縮寫';

  @override
  String get pluralAbbreviationLabel => '複數縮寫';

  @override
  String get mergeAction => '合併';

  @override
  String mergeIntoTitle(String name) {
    return '將「$name」合併到…';
  }

  @override
  String mergeConfirm(String from, String to) {
    return '「$from」將合併到「$to」：之後所有食譜和購物清單都會使用「$to」，「$from」會被刪除。';
  }

  @override
  String get mergeFailed => '合併失敗';

  @override
  String foodUnitDeleteConfirm(String name) {
    return '刪除「$name」？使用它的食材會失去連結。';
  }

  @override
  String get foodsUnitsEmpty => '還沒有項目。';

  @override
  String mealRuleConditionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 個條件',
    );
    return '$_temp0';
  }

  @override
  String get showAll => '顯示全部';

  @override
  String get mealDiceModeTitle => '骰子依據';

  @override
  String get mealDiceModeApp => 'App 中的選擇';

  @override
  String get switchListTitle => '切換清單';

  @override
  String get newShoppingList => '新購物清單';

  @override
  String shoppingListDeleteConfirm(String name) {
    return '刪除「$name」？其中的所有品項也會被刪除。';
  }

  @override
  String get labelOrderTitle => '標籤排序';

  @override
  String get labelOrderHint => '拖曳以排序。適用於此清單 – Mealie 網頁版中也一樣。';

  @override
  String get labelOrderEmpty => '此清單還沒有標籤。';

  @override
  String get useAsActiveList => '設為目前清單';

  @override
  String get activeListBadge => '目前';

  @override
  String get foodLabelLabel => '標籤';

  @override
  String get foodNoLabel => '無標籤';

  @override
  String get aliasesLabel => '別名';

  @override
  String get aliasAddHint => '新增別名';

  @override
  String get foodOnHand => '家中已有';

  @override
  String get timelineChildRecipesTitle => '也為連結的食譜新增';

  @override
  String timelineMadeForRecipe(String recipe) {
    return '為 $recipe 製作';
  }

  @override
  String get timelineFilter => '篩選記錄';

  @override
  String get timelineTypeComment => '製作記錄與備註';

  @override
  String get timelineTypeInfo => '訊息';

  @override
  String get timelineTypeSystem => '系統';

  @override
  String get listManagementTitle => '購物清單';

  @override
  String get managementTitle => '更多';

  @override
  String get pinToHome => '加入主畫面';

  @override
  String get unpinFromHome => '從主畫面移除';

  @override
  String homeScreenFull(int count) {
    return '主畫面已滿 – 最多 $count 個方塊。請先在「更多」中移除其他方塊。';
  }

  @override
  String get selectAction => '選擇';

  @override
  String selectedCount(int count) {
    return '已選擇 $count 項';
  }

  @override
  String get assignLabelAction => '指定標籤';

  @override
  String get assignLabelOverwriteHint => '會覆寫所有所選食材的標籤。';

  @override
  String deleteSelectedConfirm(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '刪除 $count 個項目？',
    );
    return '$_temp0';
  }

  @override
  String get seedDataAction => '載入預設資料';

  @override
  String get seedFoodsHint => '以所選語言建立 Mealie 的預設食材。';

  @override
  String get seedUnitsHint => '以所選語言建立 Mealie 的預設單位。';

  @override
  String get seedLanguageLabel => '語言';

  @override
  String get seedDuplicateWarning => '你已有項目。Mealie 不會處理重複項 – 之後需要你自行合併。';

  @override
  String get seedDone => '已建立預設資料';

  @override
  String get seedFailed => '無法載入預設資料';

  @override
  String get exportAction => '匯出';

  @override
  String get substitutionsLabel => '替代品';

  @override
  String get substitutionAddHint => '新增替代品';

  @override
  String get substitutionFoodLabel => '食材（選填）';

  @override
  String get substitutionNoteLabel => '備註（選填）';

  @override
  String get substitutionNeedOne => '請輸入食材或備註';

  @override
  String get useAbbreviationLabel => '使用縮寫';

  @override
  String get useAbbreviationHint => '在食譜中顯示「g」而不是「公克」';

  @override
  String get fractionLabel => '以分數顯示';

  @override
  String get fractionHint => '用 ½ 取代 0.5';

  @override
  String get standardizationTitle => '標準化';

  @override
  String get standardizationHint => '用於換算：此單位的 1 等於 …（例如 1 大匙 = 15 毫升）。';

  @override
  String get standardQuantityLabel => '標準數量';

  @override
  String get standardUnitLabel => '標準單位';

  @override
  String get standardUnitNone => '無';

  @override
  String get stdFluidOunce => '液量盎司 (fl oz)';

  @override
  String get stdCup => '杯（美制）';

  @override
  String get stdOunce => '盎司 (oz)';

  @override
  String get stdPound => '磅 (lb)';

  @override
  String get stdMilliliter => '毫升';

  @override
  String get stdLiter => '公升';

  @override
  String get stdGram => '公克';

  @override
  String get stdKilogram => '公斤';

  @override
  String get labelsTitle => '標籤';

  @override
  String get newLabel => '新標籤';

  @override
  String get editLabel => '編輯標籤';

  @override
  String get colorLabel => '色彩';

  @override
  String labelDeleteConfirm(String name) {
    return '刪除「$name」？品項和食材會失去此標籤。';
  }

  @override
  String get importMenuAction => '匯入';

  @override
  String get archivedEmpty => '還沒有已封存的採買。採買後點選「完成採買」– 已勾選的品項會儲存在這裡。';

  @override
  String get sectionTitleLabel => '分區標題';

  @override
  String get clearSection => '移除分區';

  @override
  String get noPermissionGeneric => '你在 Mealie 中沒有此操作的權限。請聯絡管理員或家庭群組管理員。';

  @override
  String get noPermissionEditRecipe =>
      '你無法編輯此食譜 – 它已鎖定或屬於其他家庭群組。只有建立者或管理員可以編輯。';

  @override
  String get noPermissionDeleteRecipe => '只有食譜的建立者或管理員可以刪除它。';

  @override
  String get noPermissionDemoteSelf => '你不能移除自己的管理員權限。';

  @override
  String get recipeLockedHint => '已鎖定 – 僅建立者可編輯';

  @override
  String get recipeDeleteOwnerOnlyHint => '僅建立者或管理員可刪除';

  @override
  String get organizeReadOnlyHint => '僅檢視：建立、變更和刪除需要「使用者可以管理食材、標籤和目錄」權限。';

  @override
  String get notesNotSavedNoPermission => '備註未儲存 – 你沒有編輯此食譜的權限。';

  @override
  String get userManagementTitle => '使用者管理';

  @override
  String get editUserTitle => '編輯使用者';

  @override
  String get fullNameLabel => '全名';

  @override
  String get usernameLabel => '使用者名稱';

  @override
  String get emailLabel => '電子郵件';

  @override
  String get passwordLabel => '密碼';

  @override
  String get householdLabel => '家庭群組';

  @override
  String get permissionsTitle => '權限';

  @override
  String get administratorLabel => '管理員';

  @override
  String get permCanInvite => '使用者可邀請他人加入群組';

  @override
  String get permCanManage => '使用者可管理群組設定';

  @override
  String get permCanManageHousehold => '使用者可以管理家庭';

  @override
  String get permCanOrganize => '使用者可以管理食材、標籤和目錄';

  @override
  String get advancedFeaturesLabel => '啟用進階功能';

  @override
  String get passwordResetLinkAction => '產生密碼重設連結';

  @override
  String get resetLockedUsersAction => '重設已鎖定的使用者';

  @override
  String get inviteLinkTitle => '邀請連結';

  @override
  String get inviteAction => '邀請';

  @override
  String get userUpdated => '使用者已更新';

  @override
  String get createUserTitle => '建立使用者';

  @override
  String get userCreated => '已建立使用者';

  @override
  String userDeleteConfirm(String name) {
    return '刪除「$name」？該帳號將從 Mealie 中移除。';
  }

  @override
  String get passwordResetLinkCopied => '已複製連結 – 請轉交給該使用者。它只在有限時間內有效。';

  @override
  String lockedUsersReset(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已解鎖 $count 位使用者',
      zero: '沒有被鎖定的使用者',
    );
    return '$_temp0';
  }

  @override
  String get inviteUsesLabel => '使用次數';

  @override
  String get inviteCreated => '已建立邀請連結';

  @override
  String get inviteEmailHint => '電子郵件地址（選填 – Mealie 會寄送邀請）';

  @override
  String get inviteEmailSent => '已透過電子郵件寄送邀請';

  @override
  String get inviteEmailFailed => '無法寄送郵件（Mealie 中是否已設定 SMTP？）。連結仍可使用。';

  @override
  String get copyLinkAction => '複製連結';

  @override
  String get youLabel => '你';

  @override
  String get membersPermissionsHint => '你可以變更家庭群組成員的權限 – 但不能變更自己的。';

  @override
  String get householdManagementTitle => '家庭群組管理';

  @override
  String get householdsTitle => '家庭群組';

  @override
  String get createHouseholdTitle => '建立家庭群組';

  @override
  String get householdNameLabel => '家庭群組名稱';

  @override
  String get householdPreferencesTitle => '家庭群組偏好設定';

  @override
  String get privateHouseholdLabel => '私人家庭群組';

  @override
  String get privateHouseholdHint => '將家庭群組設為私人將停用所有公開檢視選項，並覆蓋所有個別的公開檢視設定。';

  @override
  String get lockRecipeEditsLabel => '鎖定其他家庭群組的食譜編輯權限';

  @override
  String get lockRecipeEditsHint => '啟用後，僅限您家庭群組內的用戶可編輯由您家庭群組建立的食譜';

  @override
  String get householdRecipePreferencesTitle => '家庭群組食譜偏好設定';

  @override
  String get groupsTitle => '群組';

  @override
  String get groupLabel => '群組';

  @override
  String get createGroupTitle => '新增群組';

  @override
  String get groupNameLabel => '群組名稱';

  @override
  String get groupPreferencesTitle => '群組偏好設定';

  @override
  String get privateGroupLabel => '私人群組';

  @override
  String get privateGroupHint => '將群組設為私人將停用所有公開檢視選項，並覆蓋所有個別的公開檢視設定。';

  @override
  String get firstDayOfWeekLabel => '一週的起始日';

  @override
  String get showAnnouncementsLabel => '顯示來自Mealie的公告';

  @override
  String get recipePublicDefaultLabel => '允許群組外的用戶查看您的食譜';

  @override
  String get recipeShowNutritionDefaultLabel => '顯示營養資訊';

  @override
  String get recipeShowAssetsDefaultLabel => '顯示食譜附件';

  @override
  String get recipeLandscapeDefaultLabel => '預設橫向檢視';

  @override
  String get recipeDisableCommentsDefaultLabel => '停用用戶對食譜的留言功能';

  @override
  String get myHouseholdSection => '我的家庭群組';

  @override
  String get myGroupSection => '我的群組';

  @override
  String get preferencesSaved => '設定已儲存';

  @override
  String get cannotDeleteWithUsers => '仍有使用者 – 請先在使用者管理中移動或刪除他們。';

  @override
  String deleteHouseholdConfirm(String name) {
    return '刪除家庭群組「$name」？';
  }

  @override
  String deleteGroupConfirm(String name) {
    return '刪除群組「$name」？';
  }

  @override
  String usersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 位使用者',
      zero: '沒有使用者',
    );
    return '$_temp0';
  }

  @override
  String get originalUrlLabel => '原食譜網址';

  @override
  String get copyTextAction => '複製文字';

  @override
  String get copiedToClipboard => '複製到剪貼簿';

  @override
  String get changelogEnglishHint => '版本資訊僅提供英文版。';

  @override
  String get favoritesTitle => '最愛';

  @override
  String get favoritesEmpty => '還沒有最愛。點選食譜上的愛心即可收集到這裡。';

  @override
  String get changelogTitle => '更新記錄';

  @override
  String get changeProfileImage => '變更個人圖片';

  @override
  String get profileImageUpdated => '已更新個人圖片';

  @override
  String get profileImageFailed => '個人圖片上傳失敗';

  @override
  String get myAccountTitle => '我的帳號';

  @override
  String get ownAccountHint => '你可以在這裡編輯自己的帳號。其他使用者由管理員和擁有「管理」權限的成員管理。';

  @override
  String get changePasswordAction => '變更密碼';

  @override
  String get currentPasswordLabel => '目前密碼';

  @override
  String get newPasswordLabel => '新密碼';

  @override
  String get confirmPasswordLabel => '確認密碼';

  @override
  String get passwordTooShort => '至少 8 個字元';

  @override
  String get passwordsDoNotMatch => '兩次輸入的密碼不一致';

  @override
  String get passwordUpdated => '密碼已更新';

  @override
  String get passwordChangeFailed => '無法變更密碼';

  @override
  String passwordManagedExternally(String method) {
    return '你透過 $method 登入 — 請在那裡變更密碼。';
  }

  @override
  String get bulkAddHint => '每行一個項目。';

  @override
  String bulkAddCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '新增 $count 個項目',
    );
    return '$_temp0';
  }

  @override
  String get linkRecipeAction => '連結食譜';

  @override
  String get useFoodAction => '改用食材代替食譜';

  @override
  String get addSubstitutionsAction => '新增替代品';

  @override
  String get clearSubstitutionsAction => '清除替代品';

  @override
  String get recipeSubstitutionsTitle => '替代品';

  @override
  String get substitutionUnknownFood => '僅限現有食材 – 否則請使用備註';

  @override
  String get insertAboveAction => '在上方插入';

  @override
  String get insertBelowAction => '在下方插入';

  @override
  String get moveToTopAction => '移到最上方';

  @override
  String get moveToBottomAction => '移到最下方';

  @override
  String get linkReferencesAction => '連結參照';

  @override
  String get editMarkdownAction => '編輯 Markdown';

  @override
  String get previewMarkdownAction => '預覽 Markdown';

  @override
  String get insertStepImageAction => '上傳圖片';

  @override
  String get mergeAboveAction => '與上方合併';

  @override
  String get linkedToOtherStep => '已連結至其他步驟';

  @override
  String get noNotesToLink => '沒有可連結的備註';

  @override
  String get ownerLabel => '擁有者';

  @override
  String get ingredientParserTitle => '食材解析器';

  @override
  String ingredientParserHint(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '有 $count 項食材尚未結構化。請選擇解析器、檢查結果，然後套用。',
    );
    return '$_temp0';
  }

  @override
  String get parserNlp => '自然語言處理器';

  @override
  String get parserBrute => '暴力解析器';

  @override
  String get parserOpenai => 'OpenAI 解析器';

  @override
  String get parserApp => '離線（App）';

  @override
  String get parseFailed => '解析失敗';

  @override
  String get parseAction => '解析';

  @override
  String applyParsedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '套用 $count 項食材',
      zero: '未選擇任何項目',
    );
    return '$_temp0';
  }

  @override
  String get parsedNewBadge => '新';

  @override
  String get hoursShort => '小時';

  @override
  String get minutesShort => '分鐘';

  @override
  String get timeExtraHint => '額外，例如「再加一晚」';

  @override
  String get yieldLabel => '份量';

  @override
  String get yieldTextLabel => '份量說明';

  @override
  String get prepTimeLabel => '準備時間';

  @override
  String get performTimeLabel => '烹飪時間';

  @override
  String get totalTimeLabel => '總時間';

  @override
  String get settingPublicRecipe => '公開食譜';

  @override
  String get settingShowNutrition => '顯示營養含量';

  @override
  String get settingShowAssets => '顯示資源';

  @override
  String get settingLandscapeView => '橫式畫面（即將推出）';

  @override
  String get settingDisableComments => '關閉留言';

  @override
  String get settingDisableAmount => '停用食材份量';

  @override
  String get settingLocked => '已鎖定';

  @override
  String get settingLockedOwnerOnly => '只有建立者可以鎖定或解鎖食譜。';

  @override
  String get apiExtrasTitle => 'API 更多';

  @override
  String get apiExtrasHint => '供第三方 App 使用的自訂鍵/值組，例如用於觸發自動化。';

  @override
  String get extraKeyLabel => '鍵';

  @override
  String get extraValueLabel => '值';

  @override
  String get addExtraAction => '新增額外欄位';

  @override
  String durationHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 小時',
    );
    return '$_temp0';
  }

  @override
  String durationMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 分鐘',
    );
    return '$_temp0';
  }

  @override
  String get discardChangesConfirm => '要捨棄未儲存的變更嗎？';

  @override
  String get discardChanges => '放棄變更';

  @override
  String get imageFromUrl => '從 URL 取得圖片';

  @override
  String get deleteRecipeImage => '刪除食譜圖片';

  @override
  String get deleteRecipeImageConfirm => '確定要刪除此食譜圖片嗎？';

  @override
  String get bulkAddIngredients => '批次新增食材';

  @override
  String get bulkAddSteps => '批次新增步驟';

  @override
  String get stepImageFailed => '圖片上傳失敗';

  @override
  String get servingsAndTimes => '份量與時間';

  @override
  String get recipeSettingsTitle => '食譜設定';

  @override
  String get jsonEditorTitle => 'JSON 編輯器';

  @override
  String get jsonInvalid => 'JSON 無效 – 請檢查。';

  @override
  String get editorOfflineHint => '以離線方式開啟：儲存需要連線。較新的 Mealie 欄位（例如替代品）會保持不變。';

  @override
  String get parseLineFailed => '無法辨識 – 保持不變';

  @override
  String get createManualTitle => '手動建立食譜';

  @override
  String get createManualHint => '輸入名稱 – 之後可在食譜編輯器中新增食材、步驟、圖片等所有內容。';

  @override
  String get createManualButton => '建立並編輯';

  @override
  String get changelogEmpty => '此版本還沒有項目。';

  @override
  String get finderDescription => '根據您現有的食材搜尋食譜。您也可以依現有工具篩選，並設定缺少食材或工具的最大數量。';

  @override
  String get finderSelectedIngredients => '已選食材';

  @override
  String get finderNoIngredientsSelected => '尚未選擇食材';

  @override
  String get finderMissing => '缺少';

  @override
  String get finderNoRecipesFound => '找不到食譜';

  @override
  String get finderNoRecipesFoundDescription => '請嘗試新增更多食材或調整篩選條件';

  @override
  String get finderIncludeFoodsOnHand => '包含現有食材';

  @override
  String get finderIncludeToolsOnHand => '包含現有工具';

  @override
  String get finderIncludeSubstitutions => '包含替代品';

  @override
  String get finderSubstituting => '替代';

  @override
  String finderSubstituteForFood(String substitute, String food) {
    return '用 $substitute 取代 $food';
  }

  @override
  String get finderMaxMissingIngredients => '最多缺少食材數';

  @override
  String get finderMaxMissingTools => '最多缺少工具數';

  @override
  String get finderSelectedTools => '已選工具';

  @override
  String get finderReadyToMake => '可立即製作';

  @override
  String get finderAlmostReadyToMake => '即將可製作';

  @override
  String get finderSettings => '設定';

  @override
  String get finderLoadingRecipes => '載入食譜中';

  @override
  String get finderClearSelection => '清除選取';

  @override
  String get finderOfflineHint => '無法連線到伺服器 – 結果來自此裝置上儲存的食譜。';

  @override
  String get sendPeerOfflineHint => '目前無法連線 – 對方開啟 App 後送達';

  @override
  String sendDeliveredLater(String device) {
    return '目前無法連線「$device」。對方一開啟 App，食譜就會送達。';
  }

  @override
  String get sendQueuedOffline => '目前沒有連線。恢復連線後食譜會自動傳送。';

  @override
  String get searchHasAll => '全部包含';

  @override
  String get searchHasAny => '包含任一';

  @override
  String get recipeFilterTitle => '篩選';

  @override
  String get finderOtherFilters => '其他篩選條件';

  @override
  String get qfOpEquals => '等於';

  @override
  String get qfOpNotEquals => '不等於';

  @override
  String get qfOpGreater => '大於';

  @override
  String get qfOpGreaterEq => '大於或等於';

  @override
  String get qfOpLess => '小於';

  @override
  String get qfOpLessEq => '小於或等於';

  @override
  String get qfOpNewerThan => '晚於';

  @override
  String get qfOpOlderThan => '早於';

  @override
  String qfDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 天前',
    );
    return '$_temp0';
  }

  @override
  String get filterResetAll => '重設所有篩選';

  @override
  String get filterAny => '任何';

  @override
  String get filterOfflineIgnored => '離線時，「其他篩選」只能以簡單形式套用。';

  @override
  String linkedRecipesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 個連結的食譜',
      zero: '沒有連結的食譜',
    );
    return '$_temp0';
  }

  @override
  String get shoppingReminderNotificationsOff =>
      'Mealie Recipes 的通知已關閉 — 沒有通知，採買提醒就無法顯示。請在設定中允許通知。';

  @override
  String get shoppingReminderInactiveHint => '採買提醒目前無法運作：請將位置存取設為「永遠」並允許通知。';

  @override
  String get bulkImportTitle => '批次網址匯入';

  @override
  String get bulkImportDescription =>
      '批次食譜匯入工具可讓您一次匯入多個食譜，方法是將網站加入後端佇列並在背景執行任務。這在初次遷移至 Mealie 時，或需要匯入大量食譜時非常實用。';

  @override
  String get bulkAddTitle => '批次新增';

  @override
  String get bulkImportSetOrganizers => '設定分類與標籤';

  @override
  String get bulkImportStarted => '批次匯入程序已開始';

  @override
  String get bulkImportFailed => '批次匯入程序失敗';

  @override
  String get bulkImportReports => '批次匯入';

  @override
  String get bulkImportUrlHint => '食譜網址';

  @override
  String get migrationsTitle => '資料遷移';

  @override
  String get migrationsDescription =>
      '可以從其他支援的 App 將食譜遷移到 Mealie。這是開始使用 Mealie 的好方法。在 Mealie 實例之間搬移資料或還原較早的 Mealie 備份，請改用備份與還原工具。';

  @override
  String get migrationNew => '新增遷移';

  @override
  String get migrationChooseType => '選擇遷移類型';

  @override
  String get noFileSelected => '未選擇檔案';

  @override
  String migrationTagAll(String tag) {
    return '為所有食譜加上 $tag 標籤';
  }

  @override
  String get migrationPrevious => '先前的遷移';

  @override
  String get migrationMealieDescription =>
      'Mealie 可以從 v1.0 之前版本的 Mealie App 匯入食譜。從舊實例匯出食譜，然後在下方上傳 zip 檔。請注意，匯出中只能匯入食譜。這僅適用於早於 v1.0 的實例。在 v1.0 或更新版本中建立的備份應使用備份與還原工具還原。';

  @override
  String get migrationChowdownDescription =>
      'Mealie 原生支援 Chowdown 儲存庫格式。請將程式碼儲存庫下載為 .zip 檔案後上傳至下方。';

  @override
  String get migrationCopyMeThatDescription =>
      'Mealie 可從 Copy Me That 匯入食譜。請將您的食譜匯出為 HTML 格式，再將 .zip 檔案上傳至下方。';

  @override
  String get migrationMyRecipeBoxDescription =>
      'Mealie 可從 My Recipe Box 匯入食譜。請將食譜匯出為 CSV 格式，再將 .csv 檔案上傳至下方。';

  @override
  String get migrationNextcloudDescription =>
      'Nextcloud 食譜可從包含 Nextcloud 資料的 zip 檔案匯入。請參閱下方範例資料夾結構，確保您的食譜能夠順利匯入。';

  @override
  String get migrationPaprikaDescription =>
      'Mealie 可從 Paprika 應用程式匯入食譜。請從 Paprika 匯出食譜，將匯出檔案的副檔名改為 .zip 後上傳至下方。';

  @override
  String get migrationPlanToEatDescription => 'Mealie 可從 Plan to Eat 匯入食譜。';

  @override
  String get migrationRecipeKeeperDescription =>
      'Mealie 可從 Recipe Keeper 匯入食譜。請將食譜匯出為 zip 格式，再將 .zip 檔案上傳至下方。';

  @override
  String get migrationTandoorDescription =>
      'Mealie 可從 Tandoor 匯入食譜。請以「Default」格式匯出資料，再將 .zip 檔案上傳至下方。';

  @override
  String get migrationCooknDescription =>
      'Mealie 可從 DVO Cook\'n X3 匯入食譜。請以「Cook\'n」格式匯出食譜書或選單，將匯出檔案的副檔名改為 .zip 後上傳至下方。';

  @override
  String get reportTitle => '報告';

  @override
  String get recipeDataTitle => '食譜資料';

  @override
  String get recipeDataDescription =>
      '使用此區段管理與食譜相關的資料。您可以對食譜執行多種批次操作，包括匯出、刪除、加標籤及分類。';

  @override
  String get recipeDataTagTitle => '為食譜加標籤';

  @override
  String get recipeDataCategorizeTitle => '為食譜分類';

  @override
  String get recipeDataSettingsTitle => '更新設定';

  @override
  String get recipeDataExportTitle => '匯出食譜';

  @override
  String get recipeDataDeleteTitle => '刪除食譜';

  @override
  String recipeDataExportConfirm(int count) {
    return '將匯出以下食譜（$count）。';
  }

  @override
  String get recipeDataExportsTitle => '資料匯出';

  @override
  String get recipeDataExportsDescription =>
      '此區段提供已準備好可下載的匯出檔案連結。匯出檔案有效期限，請及時下載。';

  @override
  String get recipeDataPurgeExports => '清除匯出';

  @override
  String get recipeDataPurgeConfirm => '確定要刪除所有匯出資料嗎？';

  @override
  String get recipeActionsTitle => '食譜操作';

  @override
  String get recipeActionNew => '新增食譜動作';

  @override
  String get recipeActionEdit => '編輯食譜動作';

  @override
  String get recipeActionTypeLink => '連結';

  @override
  String get recipeActionTypePost => '發佈';

  @override
  String get webhooksTitle => 'Webhook';

  @override
  String get webhooksDescription =>
      '下方定義的 Webhooks 將在當日設有餐點時執行。在預定時間，系統會將當日排程食譜的資料傳送至各 Webhook。請注意，Webhook 的執行時間並非精確，系統每 5 分鐘檢查一次，因此實際執行時間可能與預定時間相差 ±5 分鐘。';

  @override
  String get webhookName => 'Webhook 名稱';

  @override
  String get webhookUrl => 'Webhook 網址';

  @override
  String get notifiersTitle => '通知器';

  @override
  String get notifiersDescription => '設定在特定事件觸發的電子郵件與推播通知。';

  @override
  String get notifierNew => '新通知';

  @override
  String get notifierDescription =>
      'Mealie 使用 Apprise 來產生通知。Apprise 提供多種服務的通知選項，請參考其 Wiki 以了解如何為您的服務建立連結。選擇特定通知類型時，可能會包含額外功能。';

  @override
  String get notifierAppriseUrl => 'Apprise 連結';

  @override
  String get notifierAppriseUrlSkipped => 'Apprise 網址（空白則略過）';

  @override
  String get notifierAppriseUrlBlankHint =>
      '由於 Apprise 網址通常包含敏感資訊，編輯時此欄位會刻意留空。若要更新網址，請在此輸入新網址；否則留空以保留目前的網址。';

  @override
  String get notifierEnable => '啟用通知功能';

  @override
  String get notifierWhatEvents => '要訂閱哪些事件通知？';

  @override
  String get notifierRecipeEvents => '食譜事件';

  @override
  String get notifierUserEvents => '使用者相關事件';

  @override
  String get notifierMealplanEvents => '用餐計畫事件';

  @override
  String get notifierShoppingListEvents => '購物清單';

  @override
  String get notifierCookbookEvents => '食譜集事件';

  @override
  String get notifierTagEvents => '標籤事件';

  @override
  String get notifierCategoryEvents => '類別事件';

  @override
  String get notifierLabelEvents => '標籤事件';

  @override
  String get notifierUserSignup => '當新使用者加入您的群組時';

  @override
  String get notifierCreate => '建立';

  @override
  String get notifierUpdate => '更新';

  @override
  String get notifierDelete => '刪除';

  @override
  String get notifierTestSent => '測試訊息已發送';

  @override
  String get adminTitle => '管理員設定';

  @override
  String get backupsTitle => '備份';

  @override
  String get backupsDescription =>
      '備份是網站資料庫與資料目錄的完整快照，包含所有資料且無法排除特定子集。您可以將其視為 Mealie 在特定時間點的快照。這是一種與資料庫無關的匯出、匯入或異地備份方式。';

  @override
  String get backupCreateHeading => '建立備份';

  @override
  String get backupCreated => '備份建立成功';

  @override
  String get backupCreateFailed => '備份失敗。請查看日誌檔案。';

  @override
  String get backupDelete => '刪除備份';

  @override
  String get backupDeleted => '備份已刪除';

  @override
  String get backupRestore => '還原備份';

  @override
  String get backupRestoreDescription =>
      '還原此備份會以備份內容覆寫資料庫和資料目錄中的所有目前資料。還原成功後，你將被登出。';

  @override
  String get backupCannotBeUndone => '此操作無法復原，請謹慎使用。';

  @override
  String get backupAcknowledge => '我了解此操作不可逆、具破壞性，且可能導致資料遺失';

  @override
  String get backupRestoreSuccess => '還原成功';

  @override
  String get backupRestoreFailed => '還原失敗。請查看伺服器日誌以取得更多詳細資訊';

  @override
  String get maintenanceTitle => '維護';

  @override
  String get maintenanceSummary => '摘要';

  @override
  String get maintenanceStorage => '儲存空間詳細資料';

  @override
  String get maintenanceDataDirSize => '資料目錄大小';

  @override
  String get maintenanceCleanableDirs => '可清理目錄';

  @override
  String get maintenanceCleanableImages => '可清理圖片';

  @override
  String get maintenanceTempDir => '暫存目錄（.temp）';

  @override
  String get maintenanceBackupsDir => '備份目錄（backups）';

  @override
  String get maintenanceGroupsDir => '群組目錄（groups）';

  @override
  String get maintenanceRecipesDir => '食譜目錄（recipes）';

  @override
  String get maintenanceUserDir => '使用者目錄（user）';

  @override
  String get maintenanceCleanDirs => '清理目錄';

  @override
  String get maintenanceCleanDirsDescription => '移除所有非有效 UUID 的食譜資料夾';

  @override
  String get maintenanceCleanTemp => '清理暫存檔案';

  @override
  String get maintenanceCleanTempDescription => '移除 .temp 目錄中的所有檔案與資料夾';

  @override
  String get maintenanceCleanImages => '清理圖片';

  @override
  String get maintenanceCleanImagesDescription => '移除所有非 .webp 格式的圖片';

  @override
  String get maintenanceActions => '操作';

  @override
  String get adminConfiguration => '設定';

  @override
  String get adminAppVersion => '應用程式版本';

  @override
  String get adminUpToDate => 'Mealie 已更新';

  @override
  String adminVersionOutdated(String current, String latest) {
    return '你目前的版本（$current）與最新版本不一致。建議更新到最新版本（$latest）。';
  }

  @override
  String get adminBaseUrl => '伺服器端基礎 URL';

  @override
  String get adminBaseUrlOk => '伺服器端 URL 與預設值不符';

  @override
  String get adminBaseUrlError =>
      'API 伺服器上的 `BASE_URL` 仍為預設值，這將導致伺服器產生的通知連結（如電子郵件等）出現問題。';

  @override
  String adminAuthReady(String provider) {
    return '$provider 已就緒';
  }

  @override
  String adminAuthNotReady(String provider) {
    return '$provider 尚未就緒';
  }

  @override
  String adminAuthDisabled(String provider) {
    return '$provider 已停用';
  }

  @override
  String adminAuthSuccessText(String provider) {
    return '所有必要的 $provider 變數均已設定完成。';
  }

  @override
  String adminAuthErrorText(String provider) {
    return '部分 $provider 設定尚未完成；若未使用 $provider 驗證，可忽略此訊息。';
  }

  @override
  String adminAuthDisabledText(String envVar) {
    return '若要啟用，請將 $envVar 設為 true。';
  }

  @override
  String get adminEmailStatus => '電子郵件設定狀態';

  @override
  String get adminEmailConfigured => '電子郵件已設定';

  @override
  String get adminNotReady => '尚未就緒，請檢查環境變數';

  @override
  String get adminSucceeded => '成功';

  @override
  String get adminFailed => '失敗';

  @override
  String get adminSiteStatistics => '網站統計數據';

  @override
  String get adminUncategorized => '未分類食譜';

  @override
  String get adminUntagged => '未標籤食譜';

  @override
  String get adminGeneralAbout => '一般資訊';

  @override
  String get adminVersion => '版本';

  @override
  String get adminBuild => '建置';

  @override
  String get adminApplicationMode => '軟體模式';

  @override
  String get adminProduction => '正式版';

  @override
  String get adminDevelopment => '開發版';

  @override
  String get adminDemoStatus => '展示狀態';

  @override
  String get adminDemo => '展示';

  @override
  String get adminNotDemo => '非展示';

  @override
  String get adminApiPort => 'API 埠號';

  @override
  String get adminApiDocs => 'API 文件';

  @override
  String get adminDatabaseType => '資料庫類型';

  @override
  String get adminDatabaseUrl => '資料庫網址';

  @override
  String get adminDefaultGroup => '預設群組';

  @override
  String get adminDefaultHousehold => '預設家庭群組';

  @override
  String get adminScraperVersion => '食譜擷取器版本';

  @override
  String get adminStatUsers => '使用者';

  @override
  String get adminStatHouseholds => '家庭群組';

  @override
  String get adminStatGroups => '群組';

  @override
  String get recipeDuplicate => '複製食譜';

  @override
  String get recipeDuplicateAction => '複製';

  @override
  String get recipeShareLink => '分享食譜';

  @override
  String get recipeShareExpiration => '到期日';

  @override
  String get recipeShareCopied => '食譜連結已複製到剪貼簿';

  @override
  String get enabledLabel => '已啟用';

  @override
  String get disabledLabel => '已停用';

  @override
  String get testAction => '測試';

  @override
  String get yesLabel => '是';

  @override
  String get noLabel => '否';

  @override
  String get downloadAction => '下載';

  @override
  String get backupUpload => '上傳';

  @override
  String get zipImportButton => '從 Zip 匯入';

  @override
  String get zipImportDescription => '匯入從其他 Mealie 執行個體匯出的單一食譜。';

  @override
  String get reportStatus => '狀態';

  @override
  String get reportDate => '日期';

  @override
  String get recipeActionTitleLabel => '標題';

  @override
  String get clearAll => '清除';

  @override
  String get recipeDataSettingsExplanation => '此處所選設定（鎖定選項除外）將套用至所有已選食譜。';

  @override
  String get adminAllowSignup => '允許註冊';

  @override
  String get adminAllowPasswordLogin => '允許密碼登入';

  @override
  String get adminEmailInvalid => '請輸入有效的電子郵件地址。';

  @override
  String adminEmailTestResult(String result) {
    return '郵件測試：$result';
  }

  @override
  String get adminSendTestEmail => '寄送測試郵件';

  @override
  String get adminTestEmailAddress => '收件人';

  @override
  String get backupCreate => '建立備份';

  @override
  String backupDeleteConfirm(String name) {
    return '刪除備份「$name」？';
  }

  @override
  String get backupPostgresNote =>
      '如果你使用 PostgreSQL，請在還原前閱讀 Mealie 文件中的備份/還原流程。';

  @override
  String get backupUploaded => '已上傳備份';

  @override
  String get backupsEmpty => '還沒有備份。';

  @override
  String get bulkImportAddRow => '新增 URL';

  @override
  String get bulkImportStart => '開始匯入';

  @override
  String get chooseFileButton => '選擇檔案';

  @override
  String get deselectAllAction => '取消全選';

  @override
  String get downloadFailed => '下載失敗';

  @override
  String get fileSaved => '已儲存檔案';

  @override
  String get loadFailed => '無法載入';

  @override
  String get maintenanceActionsWarning => '維護操作具有破壞性，請謹慎使用。執行其中任何操作都無法復原。';

  @override
  String get maintenanceConfirm => '此操作具有破壞性且無法復原。要繼續嗎？';

  @override
  String get maintenanceDone => '完成';

  @override
  String get maintenanceFailed => '維護操作失敗';

  @override
  String get maintenanceRun => '執行';

  @override
  String get migrationFailed => '遷移失敗';

  @override
  String get migrationStart => '開始遷移';

  @override
  String get migrationStarted => '遷移完成 — 請查看下方報告。';

  @override
  String get moreImportOptions => '更多匯入方式';

  @override
  String notifierDeleteConfirm(String name) {
    return '刪除通知器「$name」？';
  }

  @override
  String get notifierEdit => '編輯通知器';

  @override
  String notifierEventCount(int count) {
    return '事件：$count';
  }

  @override
  String get notifierTestFailed => '無法傳送測試訊息';

  @override
  String get notifiersEmpty => '還沒有通知器。';

  @override
  String recipeActionDeleteConfirm(String name) {
    return '刪除食譜動作「$name」？';
  }

  @override
  String get recipeActionFailed => '食譜動作失敗';

  @override
  String get recipeActionSent => '已傳送食譜';

  @override
  String get recipeActionUrlHint => '預留位置';

  @override
  String get recipeActionsDescription =>
      '食譜動作會顯示在每個食譜的選單中。「連結」會開啟該 URL，「Post」會讓 Mealie 伺服器將食譜傳送到該 URL。';

  @override
  String get recipeActionsEmpty => '還沒有食譜動作。';

  @override
  String recipeDataDeleteConfirm(int count) {
    return '刪除所選食譜（$count）？此動作無法復原。';
  }

  @override
  String recipeDataDeleteForbidden(int count) {
    return '你無法刪除所選食譜中的 $count 個（只有建立者或管理員可以刪除）。';
  }

  @override
  String recipeDataDeleted(int count) {
    return '已刪除食譜：$count';
  }

  @override
  String get recipeDataExportAction => '匯出';

  @override
  String get recipeDataExportDone => '已建立匯出 — 請在「資料匯出」中下載。';

  @override
  String recipeDataExportExpires(String date) {
    return '$date 到期';
  }

  @override
  String get recipeDataExportFailed => '匯出失敗';

  @override
  String get recipeDataExportsEmpty => '沒有可用的匯出。';

  @override
  String recipeDataUpdated(int count) {
    return '已更新食譜：$count';
  }

  @override
  String get recipeDuplicated => '已複製食譜';

  @override
  String get recipeExportJson => '匯出為 JSON';

  @override
  String get recipeExportZip => '匯出為 ZIP（含圖片）';

  @override
  String get recipeShareCreate => '建立連結';

  @override
  String get recipeShareDescription => '任何擁有連結的人都可以在瀏覽器中檢視此食譜 — 不需帳號 — 直到連結到期。';

  @override
  String get recipeShareEmpty => '還沒有分享連結。';

  @override
  String recipeShareExpiresAt(String date) {
    return '$date 到期';
  }

  @override
  String get recipeWebToolsMenu => '複製、分享連結等';

  @override
  String get reload => '重新載入';

  @override
  String get reportDeleteConfirm => '刪除此報告？';

  @override
  String get reportEntries => '項目';

  @override
  String get reportFailedEntries => '失敗';

  @override
  String get reportOnlyFailed => '只顯示失敗的項目';

  @override
  String get reportStatusFailure => '失敗';

  @override
  String get reportStatusInProgress => '進行中';

  @override
  String get reportStatusPartial => '部分完成';

  @override
  String get reportStatusSuccess => '成功';

  @override
  String get reportsEmpty => '還沒有報告。';

  @override
  String get uploadFailed => '上傳失敗';

  @override
  String webhookDeleteConfirm(String name) {
    return '刪除 Webhook「$name」？';
  }

  @override
  String get webhookEdit => '編輯 Webhook';

  @override
  String get webhookNew => '新增 Webhook';

  @override
  String get webhookTestFailed => '無法啟動測試';

  @override
  String get webhookTestSent => '已觸發測試 Webhook';

  @override
  String get webhookTime => '時間（當地）';

  @override
  String get webhooksEmpty => '還沒有 Webhook。';

  @override
  String get zipImportFailed => 'ZIP 匯入失敗';

  @override
  String get aiProvidersTitle => 'AI 提供者';

  @override
  String get aiProvidersDescription => '請設定AI提供者以啟用AI輔助功能，如強化食材解析，從影片建立食譜，及更多！';

  @override
  String get aiProviderSettingsTitle => 'AI 提供者設定';

  @override
  String get aiProvidersList => '提供者';

  @override
  String get aiProviderCreate => '新增提供者';

  @override
  String get aiProviderEdit => '編輯提供者';

  @override
  String get aiDefaultProvider => '預設提供者';

  @override
  String get aiDefaultProviderDescription => '必須選擇以啟用AI功能';

  @override
  String get aiAudioProvider => '音訊提供者';

  @override
  String get aiAudioProviderDescription => '啟用音訊轉錄功能，如從影片建立食譜';

  @override
  String get aiImageProvider => '圖片提供者';

  @override
  String get aiImageProviderDescription => '啟用圖片辨識功能，如從圖片建立食譜';

  @override
  String get aiProviderName => '提供者名稱';

  @override
  String get aiApiKey => 'API 密鑰';

  @override
  String get aiApiKeyCreateDescription =>
      '你的提供者用作認證的API密鑰。如果你的服務 (如 Ollama) 不使用API密鑰，你仍需在此欄填寫一些東西。';

  @override
  String get aiApiKeyEditDescription => '除非你需要更改，請留空此欄。';

  @override
  String get aiBaseUrl => '基本網址';

  @override
  String get aiBaseUrlDescription =>
      '如使用OpenAI請留空。必須為OpenAI兼容接口 (如 \"http://localhost:11434/v1\")。';

  @override
  String get aiModel => '模型';

  @override
  String get aiModelDescription => 'AI提供者使用的模型 (如 \"gpt-5\")。';

  @override
  String get aiTimeout => '請求逾時 (秒)';

  @override
  String get aiProviderCreated => '提供者已建立';

  @override
  String get aiProviderUpdated => '提供者已更新';

  @override
  String get aiProviderDeleted => '提供者已刪除';

  @override
  String get aiProviderCreateFailed => '提供者建立失敗';

  @override
  String get aiProviderUpdateFailed => '提供者更新失敗';

  @override
  String get aiProviderDeleteFailed => '提供者刪除失敗';

  @override
  String get aiRequestHeaders => '請求標頭';

  @override
  String get aiRequestParams => '請求參數';

  @override
  String get aiNoDefaultWarning => '你未設置預設提供者，所以AI功能已停用';

  @override
  String get aiTestConnection => '測試連線';

  @override
  String get aiTestSucceeded => '連線成功';

  @override
  String get aiTestFailed => '連線失敗';

  @override
  String get aiSupportsImages => '支援圖片';

  @override
  String get aiTextOnly => '僅支援文字，不能作為影像提供者';

  @override
  String get debugAiTitle => '偵錯 AI 提供者';

  @override
  String get debugAiDescription =>
      '使用此頁面偵錯 AI 提供者。你可以測試 AI 連線並在此查看結果。如果已啟用影像服務，也可以提供一張圖片。';

  @override
  String get debugParserTitle => '解析器';

  @override
  String get debugParserDescription =>
      'Mealie 使用條件隨機場（CRF）來解析和處理食材。食材所使用的模型基於紐約時報彙整的超過 10 萬筆食材資料集。由於模型僅以英文訓練，在其他語言下的結果可能有所差異。此頁面為測試模型的練習場。';

  @override
  String get debugIngredientText => '食材文字';

  @override
  String get debugTryExample => '試試範例';

  @override
  String debugAverageConfidence(String value) {
    return '信心度 $value';
  }

  @override
  String get debugRunTest => '執行測試';

  @override
  String get debugQuantity => '數量';

  @override
  String get debugUnit => '單位';

  @override
  String get debugFood => '食材';

  @override
  String get debugNote => '留言';

  @override
  String get debugGroup => '群組';

  @override
  String get aiProviderNone => '無';

  @override
  String aiProviderDeleteConfirm(String name) {
    return '刪除提供者「$name」？';
  }

  @override
  String get aiProvidersEmpty => '還沒有 AI 提供者。';

  @override
  String get aiAdvanced => '進階';

  @override
  String get aiKeyLabel => '名稱';

  @override
  String get aiValueLabel => '值';

  @override
  String get debugTitle => '除錯';

  @override
  String get debugParse => '解析';

  @override
  String get debugParseFailed => '無法解析食材';

  @override
  String get debugChooseImage => '選擇圖片';

  @override
  String get debugNoImage => '無圖片（選填）';

  @override
  String get updateTitle => '檢查更新';

  @override
  String get updateInstalledVersion => '已安裝版本';

  @override
  String get updateLastCheck => '上次檢查';

  @override
  String get updateCheckNow => '立即檢查';

  @override
  String get updateChecking => '正在檢查更新…';

  @override
  String get updateUpToDate => 'Mealie Recipes 已是最新版本。';

  @override
  String updateAvailable(String version) {
    return '版本 $version 可用';
  }

  @override
  String get updateAvailableDescription =>
      'Mealie Recipes 有新版本可用。在你自行開始更新之前，不會安裝任何內容。';

  @override
  String get updateShow => '查看更新';

  @override
  String get updateLater => '稍後';

  @override
  String updateDownloading(int percent) {
    return '正在下載 … $percent %';
  }

  @override
  String updateReady(String version) {
    return '版本 $version 已可安裝';
  }

  @override
  String get updateInstalling => '正在安裝 — App 會自動重新啟動 …';

  @override
  String get updateManual => '無法自動安裝更新。磁碟映像檔已開啟：請將 Mealie Recipes 拖到「應用程式」中。';

  @override
  String get updateFailed => '更新失敗';

  @override
  String get updateInstallNow => '下載並安裝';

  @override
  String get updateRestartNow => '安裝並重新啟動';

  @override
  String get updateAutoTitle => '啟動時檢查更新';

  @override
  String get updateAutoDescription => '只檢查並通知你 — 安裝一律由你自行開始。';

  @override
  String get updateBetaTitle => '接收測試版';

  @override
  String get updateBetaDescription => '也提供測試用的預先發行版本，可能仍有錯誤。';

  @override
  String get updateNoNotes => '沒有版本資訊。';

  @override
  String get updateSourceHint =>
      '更新來自 Mealie Recipes 的 GitHub 發行版，且僅在經開發者簽署時才會安裝（macOS）。';

  @override
  String get errorNoConnection => '無法連線到你的 Mealie 伺服器。請檢查網路連線和伺服器位址。';

  @override
  String get errorTimeout => '伺服器回應時間過長。請再試一次。';

  @override
  String get errorUnauthorized => '你的登入已過期或 API 權杖已失效。請在設定中重新登入。';

  @override
  String get errorServer => 'Mealie 伺服器回報了錯誤。請稍後再試。';

  @override
  String get errorNotFound => '在伺服器上找不到 — 可能已被刪除。';

  @override
  String get errorCertificate => '伺服器的安全性憑證不受信任。';

  @override
  String get errorGeneric => '發生問題。請再試一次。';

  @override
  String get offlineLabel => '離線';

  @override
  String offlineSince(String time) {
    return '離線 · 上次同步 $time';
  }

  @override
  String get mealplanEntryActions => '餐點選項';

  @override
  String get mealplanMoveAction => '移動';

  @override
  String get mealplanMoveTitle => '移動餐點';

  @override
  String get mealplanMoveDate => '日期';

  @override
  String mealplanMovedTo(String date) {
    return '已移到 $date';
  }

  @override
  String get mealplanShowWeek => '顯示';

  @override
  String get mealplanMoveFailed => '無法移動餐點';

  @override
  String get recentlyViewedTitle => '最近檢視';

  @override
  String get recentlyViewedEmpty => '你開啟的食譜會顯示在這裡。';

  @override
  String get recentlyViewedClear => '清除記錄';

  @override
  String get recentlyViewedClearMessage => '將清除此裝置上最近檢視的食譜清單。食譜本身會保留。';

  @override
  String get recentlyViewedClearConfirm => '清除';

  @override
  String get duplicatesTitle => '重複項目搜尋';

  @override
  String get duplicatesScanning => '正在搜尋重複的食譜…';

  @override
  String get duplicatesNone => '找不到重複的食譜。';

  @override
  String duplicatesFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '找到 $count 個可能的重複項目。',
    );
    return '$_temp0';
  }

  @override
  String get duplicatesIntro => '點選要保留的食譜，然後合併。';

  @override
  String get duplicatesReasonSource => '相同來源';

  @override
  String get duplicatesReasonName => '相同名稱';

  @override
  String duplicatesReasonSimilar(int percent) {
    return '相似 · $percent % 食材相同';
  }

  @override
  String get duplicatesKeeps => '保留';

  @override
  String get duplicatesWillBeDeleted => '將被刪除';

  @override
  String get duplicatesMerge => '合併';

  @override
  String get duplicatesNotDuplicate => '不是重複項目';

  @override
  String get duplicatesMergeTitle => '合併食譜？';

  @override
  String duplicatesMergeMessage(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '另外 $count 個食譜將被刪除',
    );
    return '保留「$name」。$_temp0。\n\n目錄、標籤、工具、備註、家庭群組已規劃的餐點和你的最愛會被轉移。被刪除食譜的留言、時間軸和附件將會遺失。';
  }

  @override
  String get duplicatesMerged => '已合併食譜';

  @override
  String duplicatesIngredientCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 項食材',
    );
    return '$_temp0';
  }

  @override
  String duplicatesResetIgnored(int count) {
    return '重新顯示隱藏的配對（$count）';
  }

  @override
  String get duplicatesRescan => '重新搜尋';

  @override
  String get duplicatesOpenRecipe => '開啟食譜';

  @override
  String get duplicatesMergeNoEditHint =>
      '你不能編輯要保留的食譜（他人已鎖定的食譜或來自其他家庭群組）。因此它的目錄、標籤、工具和備註保持不變；只會轉移已規劃的餐點和你的最愛。';

  @override
  String get recipeOtherHouseholdHint => '來自其他家庭群組 – 在那裡已鎖定編輯';

  @override
  String foodsSavedAsNote(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 項新食材',
    );
    return '已儲存。$_temp0已保留為食材備註 – 在 Mealie 中建立食材需要「使用者可以管理食材、標籤和目錄」權限。';
  }

  @override
  String get a11yRemove => '移除';

  @override
  String get a11yDecrease => '減少';

  @override
  String get a11yIncrease => '增加';

  @override
  String get a11yShowPassword => '顯示密碼';

  @override
  String get a11yHidePassword => '隱藏密碼';

  @override
  String get a11yClearSearch => '清除搜尋';

  @override
  String get notesQueuedOffline => '離線 – 伺服器恢復連線後將傳送備註。';

  @override
  String get timelineQueuedOffline => '離線 – 伺服器恢復連線後將加入時間軸。';

  @override
  String get syncSectionName => '已重新命名';

  @override
  String get pendingRecipesDiscard => '捨棄';

  @override
  String get undo => '還原';

  @override
  String timerStoppedSnack(String name) {
    return '計時器「$name」已停止';
  }

  @override
  String get cookFriendsEndConfirm => '要為所有人結束工作階段嗎？所有訪客都會中斷連線。';

  @override
  String get weekStartSyncHint => '已儲存到 Mealie – 適用於你的整個家庭群組，網頁版中也一樣。';

  @override
  String get weekStartNoPermission => '由你的家庭群組在 Mealie 中設定。只有可管理家庭群組的成員才能變更。';

  @override
  String get assetsUnsupported329 =>
      'Mealie 支援 PDF、圖片、影片（MP4、MOV、WebM）、音訊（MP3、M4A）、Word/ODT/RTF、TXT、MD、CSV 和 JSON。';

  @override
  String get assetsRecordVideo => '錄製影片';

  @override
  String get assetsChooseVideo => '選擇影片';

  @override
  String get shoppingSearchHint => '在此清單中搜尋';

  @override
  String get shoppingSearchNoMatches => '沒有符合搜尋的品項。';

  @override
  String get mealplanServingsTitle => '規劃份量';

  @override
  String get mealplanServingsHint =>
      '僅適用於此用餐計畫項目 — 食譜本身保持不變。開啟食譜和加入購物清單時會使用這些份量。';

  @override
  String get calendarFeedTitle => '訂閱行事曆';

  @override
  String get calendarFeedSubtitle => '在 Google、Apple 或其他行事曆中顯示用餐計畫';

  @override
  String get calendarFeedDescription =>
      '可從 Google 日曆、Apple 行事曆、Home Assistant 或任何支援 iCal 連結的 App 訂閱你家庭群組的用餐計畫。任何擁有連結的人都能看到你的用餐計畫。';

  @override
  String get calendarFeedOff => '你家庭群組的行事曆連結已關閉。';

  @override
  String get calendarFeedAskManager => '請可管理你家庭群組的人開啟它。';

  @override
  String get calendarFeedTurnOn => '開啟';

  @override
  String get calendarFeedTurnOff => '關閉';

  @override
  String get calendarFeedReset => '重設連結';

  @override
  String get calendarFeedResetHint => '重設或關閉連結後，現有的訂閱將不再更新。';

  @override
  String get calendarFeedIncludeNotes => '包含備註';

  @override
  String get calendarFeedTimesHint => '點選餐別即可設定時間。沒有時間的餐別會顯示為全天活動。';

  @override
  String get calendarFeedMealTypes => '餐點類型';

  @override
  String get calendarFeedSubscribe => '在行事曆中訂閱';

  @override
  String get calendarFeedNoApp => '無法開啟行事曆 App。請複製連結，並將它以訂閱方式加入行事曆。';

  @override
  String get calendarFeedPublicHint => '此連結不需登入即可使用 — 只與可以查看你用餐計畫的人分享。';

  @override
  String get recipeShareLinkMenu => '分享連結與 QR 碼';

  @override
  String get recipeShareShowQr => '顯示 QR 碼';

  @override
  String get recipeShareScanQr => '用手機相機掃描以開啟此食譜';

  @override
  String get recipeShareQrShare => '分享圖片';

  @override
  String get recipeShareQrFailed => '無法建立 QR 碼圖片';

  @override
  String get mealplanSettingsTitle => '用餐計劃設定';

  @override
  String get mealDiceRulesTitle => '骰子規則';

  @override
  String saveAsNewFood(String name) {
    return '將「$name」儲存為新食材';
  }

  @override
  String get shoppingMoreOptions => '更多選項';

  @override
  String get shoppingFewerOptions => '較少選項';

  @override
  String nameAlreadyExists(String name) {
    return '已存在：$name';
  }

  @override
  String aliasBelongsTo(String alias, String name) {
    return '「$alias」已屬於「$name」— 最好將兩者合併。';
  }

  @override
  String get recipeMatchTitle => 'Recipe Match';

  @override
  String get recipeMatchShuffle => '洗牌';

  @override
  String recipeMatchCardsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '牌堆中有 $count 個食譜',
    );
    return '$_temp0';
  }

  @override
  String get recipeMatchNext => '下一步';

  @override
  String get recipeMatchKeep => '放到托盤';

  @override
  String get recipeMatchKept => '已放到托盤';

  @override
  String get recipeMatchAnyTime => '任何時長';

  @override
  String recipeMatchMaxTime(int minutes) {
    return '≤ $minutes 分鐘';
  }

  @override
  String get recipeMatchEmpty => '沒有符合的食譜';

  @override
  String get recipeMatchEmptyHint => '變更篩選條件或清空托盤。';

  @override
  String get recipeMatchResetFilters => '重設篩選';

  @override
  String get recipeMatchFlipHint => '點選：食材 · 做法';

  @override
  String get recipeMatchFlipBack => '翻回';

  @override
  String get recipeMatchOpenRecipe => '完整食譜';

  @override
  String get recipeMatchOnHand => '已有';

  @override
  String get recipeMatchTray => '托盤';

  @override
  String get recipeMatchTrayEmpty => '還是空的 – 將卡片往下拖';

  @override
  String recipeMatchTrayCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 個食譜',
    );
    return '$_temp0';
  }

  @override
  String get recipeMatchClear => '清除';

  @override
  String get recipeMatchTrayHint => '會一直保留，直到你清空它 – 即使關閉牌堆也一樣。';

  @override
  String get recipeMatchRemove => '從托盤移除';

  @override
  String get recipeMatchToMealplan => '加入用餐計畫';

  @override
  String get recipeMatchToShopping => '食材加入購物清單';

  @override
  String get recipeMatchSelectIngredients => '選擇食材';

  @override
  String get recipeMatchNoList => '請先選擇一個購物清單。';

  @override
  String get recipeMatchList => '清單';

  @override
  String get recipeMatchOnHandHint => '已有的食材已取消勾選。';

  @override
  String recipeMatchAddCount(int selected, int total) {
    return '新增 $total 項食材中的 $selected 項';
  }

  @override
  String get recipeMatchNoDay => '尚未選擇日期 – 留在托盤中';

  @override
  String recipeMatchAddMeals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '新增 $count 份餐點',
    );
    return '$_temp0';
  }

  @override
  String recipeMatchMealsAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已新增 $count 份餐點',
    );
    return '$_temp0';
  }

  @override
  String get recipeMatchSwipeUp => '向上滑動以開啟托盤';

  @override
  String get weekPlannerTitle => '規劃本週';

  @override
  String get weekPlannerStepDays => '日期';

  @override
  String get weekPlannerStepPrefs => '偏好設定';

  @override
  String get weekPlannerStepPreview => '預覽';

  @override
  String get weekPlannerDaysTitle => '要讓 App 填入哪些餐別？';

  @override
  String get weekPlannerDaysHint => '點選格子。已規劃的內容會保持不變。';

  @override
  String get weekPlannerPresetWeekdays => '平日';

  @override
  String get weekPlannerPlanned => '已規劃';

  @override
  String get weekPlannerMoreMeals => '顯示更多餐別';

  @override
  String get weekPlannerFewerMeals => '較少餐別';

  @override
  String weekPlannerMealCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 份餐點',
    );
    return '$_temp0';
  }

  @override
  String get weekPlannerPrefsTitle => 'App 需要注意什麼？';

  @override
  String get weekPlannerPrefsHint => '全部選填 – 若不選擇，會從你的食譜中挑出豐富的組合。';

  @override
  String get weekPlannerQuick => '平日快速上桌';

  @override
  String weekPlannerQuickSub(int minutes) {
    return '週一至週五最多 $minutes 分鐘';
  }

  @override
  String get weekPlannerStale => '優先很久沒煮的';

  @override
  String get weekPlannerStaleSub => '依據「上次製作」與用餐計畫';

  @override
  String get weekPlannerFavorites => '更常安排最愛';

  @override
  String get weekPlannerFavoritesSub => '加了愛心和評分高的食譜';

  @override
  String get weekPlannerVariety => '多樣化';

  @override
  String get weekPlannerVarietySub => '同一目錄不連續出現兩次';

  @override
  String get weekPlannerOnlyFrom => '僅限';

  @override
  String get weekPlannerDiceRules => '使用骰子規則';

  @override
  String get weekPlannerDiceRulesSub => '你在用餐計畫設定中為每餐所做的選擇';

  @override
  String weekPlannerMatching(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 個符合的食譜',
    );
    return '$_temp0';
  }

  @override
  String weekPlannerForMeals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '用於 $count 份餐點',
    );
    return '$_temp0';
  }

  @override
  String get weekPlannerSuggest => '推薦';

  @override
  String get weekPlannerPreviewHint => '骰子替換，鎖定保留。長按一道菜並拖到另一天即可交換。';

  @override
  String get weekPlannerRerollAll => '全部重擲';

  @override
  String get weekPlannerReroll => '重擲';

  @override
  String get weekPlannerLock => '鎖定';

  @override
  String get weekPlannerUnlock => '解鎖';

  @override
  String get weekPlannerReasonNever => '從未煮過';

  @override
  String get weekPlannerReasonStale => '很久沒煮';

  @override
  String get weekPlannerReasonFavorite => '最愛';

  @override
  String get weekPlannerNoMatch => '沒有符合的食譜';

  @override
  String get weekPlannerThenShopping => '接著為購物清單選擇食材';

  @override
  String get weekPlannerMostlyEmpty => '本週幾乎是空的';

  @override
  String weekPlannerMostlyEmptySub(int free, int total) {
    return '$total 天中還有 $free 天空著 – 三個步驟即可填滿。';
  }

  @override
  String get previousWeek => '上一週';

  @override
  String get nextWeek => '下一週';

  @override
  String get weekPlannerAllDays => '所有日期';

  @override
  String get weekPlannerWeekend => '週末';

  @override
  String get weekPlannerDinners => '晚餐';

  @override
  String get weekPlannerLunches => '午餐';

  @override
  String get weekPlannerAllMeals => '所有餐別';

  @override
  String get mealplanDayEmpty => '沒有規劃';

  @override
  String get mealplanDropHere => '拖放到這裡';

  @override
  String mealplanDayKcal(String kcal) {
    return '每份 $kcal 大卡';
  }

  @override
  String mealplanDayKcalPartial(String kcal) {
    return '每份至少 $kcal 大卡';
  }

  @override
  String get globalSearchHint => '搜尋食譜、品項、功能 …';

  @override
  String get globalSearchIntro =>
      '搜尋食譜、購物清單品項、食材和食譜集 – 也能搜尋 App 的功能和設定，例如「清單」。';

  @override
  String get globalSearchFunctions => '功能';

  @override
  String globalSearchNoResults(String query) {
    return '沒有「$query」的結果';
  }

  @override
  String get searchClear => '清除搜尋';

  @override
  String get recipeMatchPlanWeek => '用這些食譜規劃本週';

  @override
  String get weekPlannerReasonTray => '來自托盤';

  @override
  String get emptyBrowseRecipes => '瀏覽食譜';

  @override
  String get mealplanWeekShopping => '本週的食材';

  @override
  String get globalSearchActions => '操作';

  @override
  String globalSearchAddToList(String text) {
    return '將「$text」加入購物清單';
  }

  @override
  String globalSearchAdded(String text) {
    return '已新增「$text」';
  }

  @override
  String get globalSearchImportUrl => '從此網址匯入食譜';

  @override
  String get homeContinueCooking => '繼續烹飪';

  @override
  String homeCookingStep(int step, int total) {
    return '第 $step 步，共 $total 步';
  }

  @override
  String get homeCookingPrep => '準備';

  @override
  String get homeCookingAlmostDone => '快完成了';

  @override
  String get homeCookingContinue => '繼續';

  @override
  String get paneSelectRecipe => '請在左側選擇一個食譜。';

  @override
  String get mealplanDragRecipeHint => '將食譜拖到某一天即可規劃。';

  @override
  String get desktopDropUnsupported => '這些檔案無法作為附件新增。';

  @override
  String desktopDropUploaded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已新增 $count 個附件',
    );
    return '$_temp0';
  }

  @override
  String get desktopDropAsAttachment => '放開即可新增為附件';

  @override
  String get printAction => '列印';

  @override
  String get mealplanPrintWeek => '列印本週';

  @override
  String get mealplanEntryCooked => '已煮';

  @override
  String get recipeSearchClear => '清除搜尋';

  @override
  String get organizerShowRecipes => '顯示食譜';

  @override
  String globalSearchShowAllRecipes(int count) {
    return '顯示全部 $count 個食譜';
  }

  @override
  String get unnamedEntry => '（無名稱）';

  @override
  String get mealplanWholeWeek => '整週';

  @override
  String get mealplanWholeWeekDropHint => '將餐點拖到這裡即可規劃整週。';

  @override
  String get mealplanMovedToWholeWeek => '已規劃為整週';

  @override
  String get mealplanCookToday => '今天就煮';

  @override
  String get mealplanPlanWholeWeek => '規劃整週';

  @override
  String mealplanPlanWholeWeekRange(String from, String to) {
    return '$from – $to';
  }

  @override
  String get calendarFeedDuration => '長度（分鐘）';

  @override
  String get calendarFeedEventDetails => '活動詳細資料';

  @override
  String calendarFeedEventDetailsHint(String fields) {
    return '自訂餐點在行事曆中的顯示方式。合併欄位：$fields';
  }

  @override
  String get calendarFeedEventTitle => '活動標題';

  @override
  String get calendarFeedEventDescription => '活動說明';

  @override
  String get calendarFeedEventDetailsWarning =>
      '變更這些會變更行事曆連結 — 如果你已訂閱，請用新連結重新訂閱。';

  @override
  String get stepDurationMinutes => '時長（分鐘）';

  @override
  String stepDurationSaved(String duration) {
    return '已儲存的時長：$duration。編輯後會換成整數分鐘。';
  }

  @override
  String get sortTotalTimeShort => '總時間最短';

  @override
  String get sortTotalTimeLong => '總時間最長';

  @override
  String recipeCreatedBy(String name) {
    return '由 $name 建立';
  }

  @override
  String get timelineReplacePhoto => '替換照片';

  @override
  String get pasteRecipeTitle => '貼上食譜';

  @override
  String get pasteRecipeDescription => '以 JSON（schema.org）或網頁 HTML 原始碼的形式貼上食譜。';

  @override
  String get pasteRecipeDescription330 =>
      '貼上從 Mealie 匯出的食譜（JSON）— 會以完整結構匯入：食材、單位和步驟連結。JSON（schema.org）和網頁的 HTML 原始碼也可以。';

  @override
  String get pasteRecipeHint => '在此貼上 JSON 或 HTML';

  @override
  String get pasteRecipeButton => '貼上食譜';

  @override
  String get pasteRecipeImport => '匯入';

  @override
  String get aiPromptsTitle => 'AI 提示詞';

  @override
  String get aiPromptsTeaser => '自訂 Mealie 給 AI 提供者的指示 — 適用於所有工作或個別工作。';

  @override
  String get aiPromptsDescription =>
      '自訂 Mealie 針對每項工作給 AI 提供者的指示。Mealie 的提示詞以英文撰寫，但這不會改變你食譜的語言：除非你選擇翻譯，否則會保留來源的語言。你可以用任何語言撰寫自己的指示。';

  @override
  String get aiPromptsGlobal => '適用於所有提示詞的指示';

  @override
  String get aiPromptsGlobalDescription =>
      '加入每個產生食譜資料的提示詞，例如建立食譜、解析食材和翻譯。系統提示詞不受影響。';

  @override
  String get aiPromptsGlobalPlaceholder => '例如：一律使用公制單位。';

  @override
  String get aiPromptsList => '提示詞';

  @override
  String get aiPromptSystem => '系統';

  @override
  String get aiPromptSystemDescription =>
      '這是系統提示詞。它會在轉成食譜前盡可能忠實地轉錄來源資料，因此不會加入適用於所有提示詞的指示。通常不需要變更，變更可能會降低匯入的可靠性。';

  @override
  String get aiPromptAppended => '已附加';

  @override
  String get aiPromptOverridden => '已覆寫';

  @override
  String get aiPromptModeDefault => '預設';

  @override
  String get aiPromptModeAppend => '附加';

  @override
  String get aiPromptModeOverride => '覆寫';

  @override
  String get aiPromptAppendDescription => '這些指示會附加到 Mealie 的提示詞中，兩者衝突時以此為準。';

  @override
  String get aiPromptOverrideDescription =>
      '你的提示詞會完全取代 Mealie 的提示詞，因此 Mealie 提示詞日後的更新不會套用。工作所需的資料（例如你的單位清單）仍會加在你的提示詞之後。';

  @override
  String get aiPromptDefaultChanged =>
      '自你覆寫以來，Mealie 的提示詞已變更。請與你的版本比較，或切換回預設以使用新版本。';

  @override
  String get aiPromptViewDefault => '檢視預設提示詞';

  @override
  String get aiPromptHideDefault => '隱藏預設提示詞';

  @override
  String get aiPromptSaved => '已儲存提示詞';

  @override
  String get aiPromptSaveFailed => '儲存提示詞失敗';

  @override
  String get aiPromptTitleBuildRecipe => '建立食譜';

  @override
  String get aiPromptTitleParseIngredients => '解析食材';

  @override
  String get aiPromptTitleRecipeVideo => '從影片產生食譜';

  @override
  String get aiPromptTitleOrganizers => '指派分類項目';

  @override
  String get aiPromptTitleTranslate => '翻譯食譜';

  @override
  String get aiPromptTitleCompileSource => '讀取來源資料';

  @override
  String get aiPromptTitleTranscribe => '轉錄音訊';

  @override
  String get aiPromptDescBuildRecipe => '將從網頁、照片或文字讀取的來源資料轉成結構化食譜。';

  @override
  String get aiPromptDescParseIngredients => 'AI 食材解析器用它將每項食材拆成數量、單位、食材和備註。';

  @override
  String get aiPromptDescRecipeVideo => '將影片的逐字稿和說明文字轉成食譜。';

  @override
  String get aiPromptDescOrganizers => '為匯入的食譜挑選標籤、目錄和工具。';

  @override
  String get aiPromptDescTranslate => '將匯入的食譜翻譯成你選擇的語言。';

  @override
  String get aiPromptDescCompileSource => '讀取網頁、照片和文字，產生食譜的純文字記錄。';

  @override
  String get aiPromptDescTranscribe => '當音訊提供者無法直接轉錄時，轉錄音訊。';

  @override
  String get mealplanNoteHint => '備註（選填）';

  @override
  String get mealplanEditTitle => '編輯項目';

  @override
  String get mealplanEntryTitleLabel => '標題';

  @override
  String get mealplanEntryNoteLabel => '備註';

  @override
  String mealplanCreateRecipe(String name) {
    return '新食譜「$name」';
  }

  @override
  String get mealplanCreateRecipeSubtitle => '建立空白食譜、加以規劃並開啟編輯器';

  @override
  String get importOptionsTitle => '匯入選項';

  @override
  String get importOptionsHint =>
      '匯入時 Mealie 的 AI 在你的伺服器上做多少工作。每個額外步驟都是一次獨立的 AI 請求 – 越少越快。';

  @override
  String get importTranslateTitle => '翻譯食譜';

  @override
  String get importOrganizersTitle => '目錄和標籤';

  @override
  String get importOrganizersCreate => '新增新的';

  @override
  String get importOrganizersExisting => '僅限現有';

  @override
  String get importOrganizersNone => '無';

  @override
  String get importOrganizersCreateHint => 'AI 會指派標籤、目錄和工具，並建立缺少的項目。';

  @override
  String get importOrganizersExistingHint => 'AI 只使用已存在的標籤、目錄和工具。';

  @override
  String get importOrganizersNoneHint =>
      '食譜匯入時不帶標籤、目錄和工具。Mealie 仍會執行此步驟，因此匯入不會變快。';

  @override
  String get importStarting => '正在傳送到伺服器…';

  @override
  String get importRunning => '正在匯入食譜…';

  @override
  String get aiImagesRunning => 'AI 正在讀取頁面…';

  @override
  String get importStreamPhotosTitle => '即時顯示進度的照片匯入';

  @override
  String get importStreamPhotosHint =>
      '顯示每個步驟，並在長時間匯入時保持連線。若要像以前一樣一次上傳，請關閉 – 例如你的代理伺服器封鎖串流時。';

  @override
  String get weekPlannerDiceRulesMealieSub => '你家庭群組的 Mealie 規則（用餐計畫設定）';

  @override
  String get syncStarted => '正在從伺服器重新載入食譜、圖片和清單…';

  @override
  String get syncDone => '全部都是最新的';

  @override
  String get recipeReloaded => '已重新載入食譜';

  @override
  String get logoutTitle => '登出 / 切換使用者';

  @override
  String get logoutConfirm => '食譜、清單和尚未同步的變更會從此裝置移除。App 設定和伺服器位址會保留，你只需重新登入。';

  @override
  String get reloadRecipe => '從伺服器重新載入';

  @override
  String get wifiServerTitle => 'Wi-Fi 下使用其他位址';

  @override
  String get wifiServerHint =>
      '適用於同一台伺服器的第二個位址，例如在家用區域 IP，在外用 ZeroTier、Tailscale 或網域。在下方 Wi-Fi 中 App 會自動使用此位址，其他情況則使用上方的伺服器 URL。';

  @override
  String get wifiSsidLabel => 'Wi-Fi 名稱';

  @override
  String get wifiServerUrl => '此 Wi-Fi 下的位址';

  @override
  String get wifiUseCurrent => '使用目前的 Wi-Fi';

  @override
  String get wifiNameUnavailable =>
      '無法讀取 Wi-Fi 名稱。請連上 Wi-Fi 並允許位置存取 – Android 和 iOS 只有這樣才會提供 Wi-Fi 名稱。';

  @override
  String wifiServerActive(String ssid) {
    return '使用中：Wi-Fi「$ssid」下的位址';
  }

  @override
  String wifiServerStandardActive(String ssid) {
    return '使用中：伺服器 URL（不在「$ssid」）';
  }

  @override
  String get wifiServerRemove => '移除';

  @override
  String get switchUserTitle => '切換使用者';

  @override
  String switchUserBody(String name) {
    return '$name 會保留在此裝置上 – 包括所有食譜、清單和尚未同步的變更。你可以透過個人圖片或登入頁面切換回來。';
  }

  @override
  String get allowBiometricTitle => '用裝置解鎖切換回來';

  @override
  String get allowBiometricHint =>
      '使用 Face ID、指紋或裝置 PIN 碼取代密碼。任何能解鎖此裝置的人都能開啟此帳號。';

  @override
  String get allow => '允許';

  @override
  String unlockAccountReason(String name) {
    return '切換到 $name';
  }

  @override
  String signInAs(String name) {
    return '以 $name 身分登入';
  }

  @override
  String wrongAccountError(String name) {
    return '這是帳號「$name」。請使用已儲存的帳號登入。';
  }

  @override
  String get accountSaveOffline => '目前無法儲存帳號 – 無法連線到伺服器。';

  @override
  String get signOutRemoveTitle => '登出並移除';

  @override
  String get signOutRemoveConfirm =>
      '此帳號及其在此裝置上的所有資料（食譜、清單、尚未同步的變更）都會被移除。App 設定會保留。';

  @override
  String get removeSavedAccount => '從此裝置移除';

  @override
  String removeSavedAccountConfirm(String name) {
    return '要從此裝置移除「$name」及其所有已儲存資料嗎？尚未同步的變更將會遺失。';
  }

  @override
  String get savedAccountsTitle => '已儲存的帳號';

  @override
  String get addAccount => '新增其他帳號';

  @override
  String get biometricOff => '停止使用裝置解鎖';

  @override
  String get orNewAccount => '或使用其他帳號登入：';

  @override
  String get importVideoTitle => '影片連結';

  @override
  String get importVideoFast => '快速';

  @override
  String get importVideoThorough => '完整（AI）';

  @override
  String get importVideoFastHint =>
      'Mealie 會轉錄影片，並以一次 AI 請求產生食譜 – 通常快得多。不翻譯，也不加入目錄/標籤。你仍可在個別匯入時開啟 AI。';

  @override
  String get importVideoThoroughHint =>
      '影片連結會自動開啟 AI 開關：多個 AI 步驟，依上方設定進行翻譯並加入目錄/標籤。耗時較長。';

  @override
  String get importPresetFast => '快速';

  @override
  String get importPresetThorough => '完整';

  @override
  String get importPresetCustom => '自訂';

  @override
  String get importPresetFastTitle => '盡量少的 AI 步驟 – 等待最短';

  @override
  String get importPresetFastVideo =>
      '影片連結：Mealie 會轉錄影片，並以一次 AI 請求產生食譜（AI 開關保持關閉）。';

  @override
  String get importPresetFastTranslate => '不翻譯 – 食譜保留原始語言。';

  @override
  String get importPresetFastOrganizers => '只指派現有的目錄和標籤，不會建立新的。';

  @override
  String get importPresetThoroughTitle => 'Mealie 的完整 AI 匯入 – 耗時較長，效果最好';

  @override
  String get importPresetThoroughVideo =>
      '影片連結會自動使用 AI 匯入 – 分多個步驟（彙整來源、產生食譜等）。';

  @override
  String get importPresetThoroughTranslate => '如果食譜以其他語言撰寫，會翻譯成下方的匯入語言。';

  @override
  String get importPresetThoroughOrganizers => '指派合適的目錄和標籤；缺少的會被建立。';

  @override
  String get importPresetCustomTitle => '自行設定每個選項';

  @override
  String get importPresetCustomBody => '從你先前選擇的設定開始，只變更需要的部分 – 例如快速匯入影片但包含翻譯。';

  @override
  String get sidebarPinHint => '提示：長按方塊並拖到側邊欄即可固定。';

  @override
  String get sidebarDropHere => '拖放到這裡';

  @override
  String sidebarShortcutTitle(String name) {
    return '「$name」的快速鍵';
  }

  @override
  String sidebarShortcutPrompt(String modifier) {
    return '現在按下你想要的按鍵組合，包括 $modifier。';
  }

  @override
  String get sidebarShortcutTaken => '此組合已在使用中。';

  @override
  String get sidebarShortcutNone => '無快速鍵';

  @override
  String get sidebarShortcutChange => '變更快速鍵';

  @override
  String get sidebarUnpin => '從側邊欄移除';

  @override
  String sidebarFull(int count) {
    return '側邊欄已滿 – 最多 $count 個自訂項目。';
  }

  @override
  String get tabletSidebar => '橫向時顯示側邊欄';

  @override
  String get tabletSidebarSubtitle => '平板橫放時，將導覽顯示在左側而非底部';

  @override
  String get filterDateCreated => '建立日期';

  @override
  String get filterDateUpdated => '更新日期';

  @override
  String get errorUploadTooLarge =>
      '檔案對此 Mealie 伺服器來說太大。可透過 MAX_UPLOAD_SIZE_MB 提高伺服器的上傳上限。';

  @override
  String get recipeDownloadPdfMealie => '下載 PDF（Mealie 版面）';

  @override
  String get mealplanNoteMore => '顯示更多…';

  @override
  String get mealplanNoteLess => '顯示較少';

  @override
  String get ingredientCommonlySubstitutedWith => '常見替代品';

  @override
  String requiresMealieVersion(String version) {
    return '需要 Mealie $version 或更新版本。';
  }

  @override
  String get apiTokensTitle => 'API 密鑰';

  @override
  String get apiTokensDescription => '管理您的 API 金鑰，以供外部應用程式存取。';

  @override
  String get apiTokenNameLabel => '密鑰名稱';

  @override
  String get apiTokenGenerate => '產生';

  @override
  String get apiTokensActive => '使用中的密鑰';

  @override
  String get apiTokenCopyWarning => '複製此密鑰以供外部應用程式使用。此密鑰將無法再次查看。';

  @override
  String get apiTokenThisApp => '此 App 使用中';

  @override
  String get apiTokenThisAppHint => '此權杖用於保持 App 登入，無法在此刪除。';

  @override
  String apiTokenDeleteConfirm(String name) {
    return '刪除權杖「$name」？使用它的 App 會立即失去存取權。';
  }

  @override
  String get apiTokensEmpty => '還沒有權杖。';

  @override
  String apiTokenCreatedOn(String date) {
    return '建立於 $date';
  }

  @override
  String get apiTokenCopied => '已複製權杖';

  @override
  String get qfOpHasNoValue => '沒有值';

  @override
  String get qfOpHasValue => '有值';

  @override
  String get ratingHouseholdAverage => '家庭群組平均';

  @override
  String get stepLinkedNotes => '連結的備註';

  @override
  String get noteFallbackTitle => '備註';

  @override
  String get aiPromptTitleEnrichInstructions => '新增步驟詳細資料';

  @override
  String get aiPromptDescEnrichInstructions =>
      '將匯入食譜的每個步驟連結到其使用的食材和備註，並找出時長和標題。';

  @override
  String get loginAccountLocked => '帳戶已鎖定，請稍後再試';

  @override
  String get loginPasswordDisabled => '此伺服器已停用密碼登入。請改用 API 權杖。';

  @override
  String get unitSystemTitle => '單位';

  @override
  String get unitSystemAsWritten => '依原文';

  @override
  String get unitSystemMetric => '公制';

  @override
  String get unitSystemMetricHint => '公制 (g, ml)';

  @override
  String get unitSystemImperial => '英制';

  @override
  String get unitSystemImperialHint => '英制 (杯, 盎司)';

  @override
  String get unitSystemHint => '僅影響顯示 – 食譜本身不變。與 Mealie 網頁版相同，此選擇適用於此裝置上的所有食譜。';

  @override
  String get unitSystemUnavailable =>
      '此食譜的單位都無法換算。換算需要在 Mealie 中為單位設定標準化（食材與單位 → 單位 → 標準化）。';

  @override
  String get shoppingCheckAll => '勾選所有項目';

  @override
  String get shoppingUncheckAll => '取消勾選所有項目';

  @override
  String get shoppingDeleteChecked => '刪除已勾選項目';

  @override
  String get shoppingCheckAllConfirm => '確定要勾選所有項目嗎？';

  @override
  String get shoppingUncheckAllConfirm => '確定要取消勾選所有項目嗎？';

  @override
  String shoppingItemCheckedOff(String item) {
    return '已勾除 $item';
  }

  @override
  String get updateGithubUnavailable => 'GitHub 目前沒有回應。請幾分鐘後再試。';
}
