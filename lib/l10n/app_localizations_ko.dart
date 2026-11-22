// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get endCookingMode => '요리 모드 종료';

  @override
  String get endCookingModeConfirm => '요리 모드를 종료할까요?';

  @override
  String endCookingModeConfirmAll(int count) {
    return '요리 모드의 레시피 $count개를 모두 종료합니다. 계속할까요?';
  }

  @override
  String get addTimer => '타이머 추가';

  @override
  String get recipeFinished => '요리가 완성되었어요.';

  @override
  String get bonAppetit => '맛있게 드세요!';

  @override
  String get prepareIngredients => '다음 재료를 준비하세요';

  @override
  String prepareIngredientsFor(String servings) {
    return '$servings인분 재료를 준비하세요';
  }

  @override
  String get next => '다음';

  @override
  String get navHome => '홈';

  @override
  String get homeCookToday => '오늘 요리';

  @override
  String get homeSuggestion => '추천';

  @override
  String get homeQuickAccess => '빠른 실행';

  @override
  String get homePlanned => '계획됨';

  @override
  String get favorite => '즐겨찾기';

  @override
  String get navSettings => '설정';

  @override
  String homeWelcomeName(Object name) {
    return '$name님,';
  }

  @override
  String get homeWelcomeApp => 'Mealie Recipes에 오신 걸 환영해요 👋';

  @override
  String get theme => '화면 스타일';

  @override
  String get themeSystem => '시스템';

  @override
  String get themeLight => '라이트';

  @override
  String get themeDark => '다크';

  @override
  String get recipes => '레시피';

  @override
  String get shoppingList => '🛒 장보기 목록';

  @override
  String get mealplan => '식단';

  @override
  String get settings => '⚙️ 설정';

  @override
  String get searchRecipe => '레시피 검색...';

  @override
  String get loadingRecipe => '레시피 로딩 중...';

  @override
  String get errorLoadingRecipe => '레시피를 불러오지 못했어요.';

  @override
  String get noRecipesForCategory => '이 필터에 해당하는 레시피가 없어요.';

  @override
  String get resetFilter => '필터 초기화';

  @override
  String get allCategories => '모든 카테고리';

  @override
  String get all => '전체';

  @override
  String get sortRecipes => '레시피 정렬';

  @override
  String get refreshRecipes => '새로고침';

  @override
  String get sortNameAZ => '이름 A–Z';

  @override
  String get sortNameZA => '이름 Z–A';

  @override
  String get sortDateNewest => '최신순';

  @override
  String get sortDateOldest => '오래된 순';

  @override
  String get sortPrepTimeShort => '준비 시간 짧은 순';

  @override
  String get sortPrepTimeLong => '준비 시간 긴 순';

  @override
  String get sortRatingHighest => '평점 높은 순';

  @override
  String get sortRatingLowest => '평점 낮은 순';

  @override
  String get details => '세부 정보';

  @override
  String get ingredients => '재료';

  @override
  String get instructions => '지침';

  @override
  String get tags => '태그';

  @override
  String get notes => '노트';

  @override
  String get addNote => '노트 추가';

  @override
  String get editNote => '노트 편집';

  @override
  String get noteTitleHint => '제목 (선택)';

  @override
  String get noteTextHint => '노트 내용';

  @override
  String get deleteNoteTitle => '노트를 삭제할까요?';

  @override
  String get deleteNoteMessage => '이 노트는 영구적으로 삭제됩니다.';

  @override
  String get servings => '제공량';

  @override
  String get planMeal => '식단에 추가';

  @override
  String get addAllIngredients => '모든 재료 추가';

  @override
  String get addSelectedIngredients => '선택한 재료 추가';

  @override
  String get addIngredientsMessage => '재료를 장보기 목록에 추가했어요.';

  @override
  String addIngredientsFailedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '재료 $count개를 추가하지 못했어요.',
      one: '재료 1개를 추가하지 못했어요.',
    );
    return '$_temp0';
  }

  @override
  String get cookbooks => '요리책';

  @override
  String get cookbooksEmpty => '아직 요리책이 없어요. 오른쪽 위의 “+”를 눌러 만들어 보세요.';

  @override
  String get cookbookNoMatches => '이 필터에 맞는 레시피가 없어요.';

  @override
  String get cookbookCreateTitle => '요리책 만들기';

  @override
  String get cookbookEditTitle => '요리책 편집';

  @override
  String get cookbookNameLabel => '요리책 이름';

  @override
  String get cookbookFilterSectionTitle => '레시피 자동 추가';

  @override
  String get cookbookFieldTools => '도구';

  @override
  String get cookbookFieldUsers => '사용자';

  @override
  String get cookbookOpIsOneOf => '다음에 포함';

  @override
  String get cookbookOpIsNotOneOf => '다음에 포함되지 않음';

  @override
  String get cookbookOpContainsAll => '모두 포함';

  @override
  String get cookbookSelectValues => '값 선택';

  @override
  String get cookbookFilterOptionsUnavailable => '사용할 수 있는 옵션이 없어요';

  @override
  String get cookbookAddFilterField => '항목 추가';

  @override
  String get cookbookPublicLabel => '공개 요리책';

  @override
  String get cookbookPublicSubtitle => '서버의 다른 가구에도 표시돼요';

  @override
  String get cookbookRawModeEnter => '텍스트로 편집';

  @override
  String get cookbookRawModeExit => '빌더로 돌아가기';

  @override
  String get cookbookRawModeHint =>
      '앱의 전문가 모드: 필터를 텍스트로 직접 편집해요. 기존 필터를 단순한 행으로 나눌 수 없을 때 유용해요.';

  @override
  String get cookbookRawModeUnparseable => '이 텍스트는 단순 행 형식에 맞지 않아 텍스트로 유지돼요.';

  @override
  String get saveFailed => '저장하지 못했어요';

  @override
  String get search => '검색';

  @override
  String get apply => '적용';

  @override
  String get setupCachingTitle => '레시피를 불러오는 중';

  @override
  String get setupCachingSubtitle =>
      '오프라인에서 쓸 수 있도록 레시피를 준비하고 있어요. 레시피 수에 따라 잠시 걸릴 수 있어요.';

  @override
  String get setupCachingDone => '준비 완료!';

  @override
  String get setupTipsHeader => '알고 계셨나요?';

  @override
  String get setupFinish => '시작하기';

  @override
  String get setupSkipCaching => '백그라운드에서 계속';

  @override
  String get setupTip1 => '링크, 사진, PDF에서 레시피를 가져올 수 있어요 — 홈 화면의 가져오기 타일에서요.';

  @override
  String get setupTip2 => '요리 모드는 화면을 켜 두고, 단계별로 안내하며, 본문 속 타이머를 자동으로 찾아요.';

  @override
  String get setupTip3 => '장보기 목록은 오프라인에서도 작동해요 — 서버에 연결되면 변경 사항이 자동으로 동기화돼요.';

  @override
  String get setupTip4 => '홈 화면의 타일을 길게 눌러 빠른 실행 순서를 바꿀 수 있어요.';

  @override
  String get setupTip5 => 'Mealie 요리책은 요리책 타일에 있어요 — 오프라인에서도 볼 수 있어요.';

  @override
  String get ok => '확인';

  @override
  String get cancel => '취소';

  @override
  String get delete => '삭제';

  @override
  String get edit => '편집';

  @override
  String get save => '저장';

  @override
  String get done => '완료';

  @override
  String get close => '닫기';

  @override
  String get add => '추가';

  @override
  String get send => '보내기';

  @override
  String get retry => '다시 시도';

  @override
  String get confirmDeleteTitle => '레시피를 삭제할까요?';

  @override
  String get confirmDeleteMessage => '이 작업은 되돌릴 수 없어요.';

  @override
  String get sendToDevice => '기기로 보내기';

  @override
  String get timerFinished => '타이머 종료!';

  @override
  String get timer => '타이머';

  @override
  String get newTimer => '새 타이머';

  @override
  String get timerNamePlaceholder => '타이머 이름';

  @override
  String get durationLabel => '시간';

  @override
  String get start => '시작';

  @override
  String get stop => '정지';

  @override
  String get pause => '일시정지';

  @override
  String get resume => '재개';

  @override
  String get finished => '완료!';

  @override
  String stepNumber(int number) {
    return '$number단계';
  }

  @override
  String get minAbbreviation => '분';

  @override
  String get cookingMode => '요리 모드';

  @override
  String get endAll => '모두 종료';

  @override
  String get end => '종료';

  @override
  String get noActiveTimers => '실행 중인 타이머가 없어요';

  @override
  String get noActiveRecipes => '진행 중인 레시피가 없어요';

  @override
  String get startRecipeToCook => '레시피를 열고 요리 모드 버튼을 눌러 시작하세요.';

  @override
  String get browseRecipes => '레시피 둘러보기';

  @override
  String get cookFriends => '친구와 요리하기';

  @override
  String get cookingModeAddRecipe => '레시피 추가';

  @override
  String get cookingModeAddRecipeSearchHint => '레시피 검색';

  @override
  String get cookFriendsCode => '세션 코드';

  @override
  String get cookFriendsJoin => '세션 참여';

  @override
  String get cookFriendsHost => '세션 열기';

  @override
  String get cookFriendsHostNotFound =>
      '호스트를 찾을 수 없어요. 두 기기가 같은 Wi-Fi에 있고 로컬 네트워크 접근이 허용되었는지 확인하세요.';

  @override
  String get cookFriendsConnectionFailed => '연결하지 못했어요. 다시 시도해 주세요.';

  @override
  String get cookFriendsEnterCode => '코드 입력';

  @override
  String cookFriendsConnected(int count) {
    return '연결됨: 게스트 $count명';
  }

  @override
  String get joinSession => '세션 참여';

  @override
  String get hostEndedSessionMessage => '호스트가 요리 세션을 종료했어요.';

  @override
  String get addItem => '항목 추가';

  @override
  String get itemNote => '항목 이름';

  @override
  String get unlabeledCategory => '라벨 없음';

  @override
  String get archivedLists => '📦 보관된 장보기';

  @override
  String get postimportAction => '가져온 후';

  @override
  String get postimportHint =>
      '가져온 항목을 원래 앱(미리 알림 / Google Tasks)에서 어떻게 할지 선택하세요.';

  @override
  String get postimportLeave => '추가만 하기';

  @override
  String get postimportComplete => '완료로 표시';

  @override
  String get postimportCompleteDelete => '완료로 표시하고 삭제';

  @override
  String get postimportFailed => '원래 앱에서의 후처리에 실패했어요. 항목은 Mealie에 추가되었어요.';

  @override
  String get syncChangesTitle => '변경 사항 동기화';

  @override
  String get syncSectionChecked => '체크됨';

  @override
  String get syncSectionQuantity => '수량';

  @override
  String get syncSectionCategory => '카테고리';

  @override
  String get syncSectionAdditions => '새로 추가됨';

  @override
  String get syncLocalLabel => '로컬';

  @override
  String get syncServerLabel => '서버';

  @override
  String get syncNow => '지금 동기화';

  @override
  String get offlineBadge => '오프라인';

  @override
  String get mealplanTitle => '📅 식단';

  @override
  String get breakfast => '조식';

  @override
  String get lunch => '점심';

  @override
  String get dinner => '저녁 식사';

  @override
  String get addMealEntry => '식사 추가';

  @override
  String get selectRecipe => '레시피 선택';

  @override
  String get importRecipe => '레시피 가져오기';

  @override
  String get url => 'URL';

  @override
  String get importLanguage => 'OCR 언어';

  @override
  String get setupTitle => 'Mealie Recipes에 오신 걸 환영해요';

  @override
  String get setupSubtitle => 'Mealie 서버를 설정하세요.';

  @override
  String get serverUrl => '서버 URL';

  @override
  String get serverUrlPlaceholder => 'https://mealie.example.com';

  @override
  String get apiToken => 'API 토큰';

  @override
  String get apiTokenPlaceholder => 'API 토큰';

  @override
  String get householdId => '가구';

  @override
  String get householdIdPlaceholder => '가족';

  @override
  String get shoppingListId => '장보기 목록 ID';

  @override
  String get setupHouseholdListTitle => '가구 및 장보기 목록';

  @override
  String get shoppingListLabel => '장보기 목록';

  @override
  String get setupHouseholdManualHint => '가구를 불러오지 못했어요 — 가구 이름을 직접 입력하세요.';

  @override
  String get setupExactTitle => '장보기 목록의 수량';

  @override
  String get setupExactBody =>
      '대부분의 나라에서는 그램 단위로 장을 보지 않아요 — 카트에는 200 g이 아니라 버터 1팩을 담죠. 그래서 간단 모드에서는 레시피 분량을 “1×”로 바꿔요. 정확 모드에서는 수량과 단위를 Mealie 웹 앱처럼 1:1로 유지해요 — 새 항목을 입력할 때도요(예: “200 g 버터”). 설정에서 언제든 바꿀 수 있어요.';

  @override
  String get setupExactSimpleTitle => '간단 모드 (1×)';

  @override
  String get setupExactSimpleBody =>
      '재료가 “1× 항목”으로 목록에 들어가요 — 마트에서 빠르게 체크하기 좋아요.';

  @override
  String get setupExactExactTitle => '정확한 수량';

  @override
  String get setupExactExactBody =>
      '항목이 수량과 단위와 함께 표시돼요(예: “200 g 버터”) — 웹 앱과 똑같이요.';

  @override
  String get connect => '연결';

  @override
  String connectionError(String error) {
    return '연결 실패: $error';
  }

  @override
  String get optionalHeaders => '선택적 HTTP 헤더 (리버스 프록시용)';

  @override
  String get settingsTitle => '⚙️ 설정';

  @override
  String get settingsSaved => '설정을 저장했어요';

  @override
  String get securitySettings => '보안';

  @override
  String get showRecipeImages => '레시피 이미지 표시';

  @override
  String get apiVersion => 'API 버전';

  @override
  String get language => '언어';

  @override
  String get biometricLock => '생체 인식 잠금';

  @override
  String get biometricLockDescription => '생체 인식으로 앱 잠금 해제';

  @override
  String get enableLogging => '로그 사용';

  @override
  String get selectLanguage => '언어 선택';

  @override
  String get setupContinue => '계속';

  @override
  String get back => '뒤로';

  @override
  String get setupConnectStep => '서버에 연결';

  @override
  String get resetSettings => '모든 설정 초기화';

  @override
  String get resetSettingsConfirm => '모든 설정이 초기화돼요. 계속할까요?';

  @override
  String get guestMode => '게스트 모드';

  @override
  String get appVersion => '버전';

  @override
  String get leftoverFinder => '레시피 검색';

  @override
  String get addIngredient => '재료 추가';

  @override
  String get biometricPrompt => 'Mealie Recipes를 열려면 인증하세요';

  @override
  String get biometricFailed => '인증에 실패했어요';

  @override
  String get pendingRecipesTitle => '받은 레시피';

  @override
  String pendingRecipesFrom(Object names) {
    return '보낸 사람: $names';
  }

  @override
  String get pendingRecipesOpenCooking => '요리 모드 열기';

  @override
  String get dismiss => '닫기';

  @override
  String get editRecipe => '레시피 편집';

  @override
  String get recipeName => '레시피 이름';

  @override
  String get prepTime => '준비 시간 (분)';

  @override
  String get cookTime => '조리 시간 (분)';

  @override
  String get totalTime => '총 시간 (분)';

  @override
  String get recipeServings => '제공량';

  @override
  String get rating => '평점';

  @override
  String get addIngredientLine => '재료 추가';

  @override
  String get addInstruction => '단계 추가';

  @override
  String get removeIngredient => '재료 삭제';

  @override
  String get removeInstruction => '단계 삭제';

  @override
  String get ingredientName => '재료';

  @override
  String get ingredientQuantity => '양';

  @override
  String get ingredientUnit => '단위';

  @override
  String get ingredientNote => '노트';

  @override
  String get instructionText => '단계 내용';

  @override
  String get categories => '카테고리';

  @override
  String get saveChanges => '변경 사항 저장';

  @override
  String get saveSuccess => '레시피를 저장했어요.';

  @override
  String get newCategory => '새 카테고리';

  @override
  String get newTag => '새 태그';

  @override
  String get setRating => '평점 매기기';

  @override
  String get homeWelcome => 'Mealie Recipes에 오신 걸 환영해요! 👋';

  @override
  String homeWelcomeNamed(String name) {
    return '$name님, Mealie Recipes에 오신 걸 환영해요! 👋';
  }

  @override
  String get shopping => '장보기';

  @override
  String get planning => '계획';

  @override
  String get other => '기타';

  @override
  String get addRecipe => '➕ 레시피 추가';

  @override
  String get completeShopping => '장보기 완료';

  @override
  String get shoppingCompleted => '장보기 완료';

  @override
  String get shoppingCompletedSubtitle => '모두 카트에 담았어요! 🎉';

  @override
  String get shoppingOfflineNoCache => '오프라인 – 목록이 저장되지 않음';

  @override
  String get shoppingOfflineNoCacheSubtitle =>
      '이 목록의 항목이 아직 이 기기에 저장되지 않았어요. 다시 온라인이 되면 바로 불러와요.';

  @override
  String get essensplan => '📅 식단';

  @override
  String get resteverwertung => '🥗 레시피 찾기';

  @override
  String get copyCode => '코드 복사';

  @override
  String get shareLink => '링크 공유';

  @override
  String get connectedFriends => '연결된 친구';

  @override
  String get waitingForFriends => '친구를 기다리는 중...';

  @override
  String get sessionCode => '세션 코드';

  @override
  String get loading => '불러오는 중...';

  @override
  String get urlInvalidScheme => 'URL은 http:// 또는 https://로 시작해야 해요';

  @override
  String get urlAddScheme => 'https:// 추가';

  @override
  String get addItemPlaceholder => '항목 추가...';

  @override
  String get completedItems => '완료됨';

  @override
  String get completeShoppingTitle => '장보기를 완료할까요?';

  @override
  String get completeShoppingMessage => '완료된 항목을 삭제할까요?';

  @override
  String get recipeListTitle => '📖 레시피';

  @override
  String get importRecipeTitle => '새 레시피 업로드';

  @override
  String get uploadRecipeUrl => '레시피 URL로 가져오기';

  @override
  String get uploadRecipeUrlHint => '서버에 저장하려면 레시피 URL을 입력하세요';

  @override
  String get uploadOpenAI => 'OpenAI로 파일에서 가져오기';

  @override
  String get uploadOpenAIHint =>
      '레시피 사진이나 PDF를 올릴 수도 있어요. 여러 페이지라면 여러 장을 추가하세요 — AI가 함께 분석해요.';

  @override
  String get takePhoto => '카메라';

  @override
  String get cameraPermissionDenied =>
      '카메라에 접근할 수 없어요. 레시피를 촬영하려면 시스템 설정에서 허용하세요.';

  @override
  String get cameraUnavailable => '이 기기에는 카메라가 없어요.';

  @override
  String get selectPhoto => '사진';

  @override
  String get selectPdf => 'PDF';

  @override
  String get openAIHintTitle => '파일 분석 안내';

  @override
  String get openAIHintBody =>
      '레시피 분석은 OpenAI API를 사용해요. Mealie 서버 설정에 API 키가 구성되어 있는지 확인하세요.';

  @override
  String get allDeleteConfirm => '모두 삭제';

  @override
  String get entriesInOtherWeeks => '다른 주에 항목이 있어요';

  @override
  String get availableWeeks => '사용 가능한 주:';

  @override
  String get currentWeek => '이번 주';

  @override
  String get weekAbbreviation => '주';

  @override
  String get today => '오늘';

  @override
  String get selectDate => '날짜 선택';

  @override
  String get selectedRecipe => '선택한 레시피';

  @override
  String get confirmMeal => '식사 계획';

  @override
  String get searchRecipes => '레시피 검색';

  @override
  String get addCustomMeal => '직접 식사 추가';

  @override
  String get diceModeButton => '랜덤 레시피 굴리기';

  @override
  String get diceModeTitle => '랜덤 추천 3개';

  @override
  String get diceBackToSearch => '검색으로 돌아가기';

  @override
  String get diceNotEnoughRecipes => '주사위 모드에 필요한 레시피가 부족해요 (최소 3개)';

  @override
  String get entrySingular => '항목';

  @override
  String get entriesPlural => '항목';

  @override
  String get deleteAllConfirmTitle => '모두 삭제할까요?';

  @override
  String get deleteAllConfirmMessage => '보관된 장보기를 모두 삭제할까요?';

  @override
  String get uploadFromUrlButton => 'URL에서 레시피 가져오기';

  @override
  String get uploadingImage => '업로드 중...';

  @override
  String get uploadErrorTitle => '업로드 실패';

  @override
  String get uploadSuccessTitle => '업로드 성공';

  @override
  String get editImportedRecipeQuestion => '새 레시피를 지금 편집할까요?';

  @override
  String get notNow => '나중에';

  @override
  String get pdfTooLarge => 'PDF 파일이 너무 커요 (최대 10 MB).';

  @override
  String get invalidUrl => '잘못된 URL이에요. 올바른 HTTP(S) URL을 입력하세요.';

  @override
  String get cookWithFriends => '친구와 요리하기';

  @override
  String get cookFriendsSubtitle => '친구를 초대해 이 레시피를 함께 요리하세요';

  @override
  String get copied => '복사됨';

  @override
  String get linkCopied => '링크를 복사했어요';

  @override
  String get startCooking => '요리 시작';

  @override
  String get uploadToOwnServer => '내 서버에 저장';

  @override
  String get uploadingRecipe => '레시피 업로드 중…';

  @override
  String get recipeUploadedToOwnServer => '레시피를 서버에 저장했어요';

  @override
  String get recipeUploadFailed => '업로드 실패';

  @override
  String get allowGuestSaveRecipes => '게스트가 자신의 서버에 레시피를 저장하도록 허용';

  @override
  String get appIcon => '앱 아이콘';

  @override
  String get name => '이름';

  @override
  String get color => '색상';

  @override
  String get randomColor => '랜덤 색상';

  @override
  String get createFailed => '만들지 못했어요';

  @override
  String get deleteFailed => '삭제하지 못했어요';

  @override
  String deleteOrganizerConfirm(String name) {
    return '“$name”을(를) 삭제할까요? 서버에서도 삭제돼요.';
  }

  @override
  String get connectionSection => '연결';

  @override
  String get token => '토큰';

  @override
  String get advancedOptions => '고급 옵션';

  @override
  String get mealieApiVersion => 'Mealie API 버전';

  @override
  String get sendOptionalHeaders => '선택적 헤더 보내기';

  @override
  String get offlineRecipeImages => '레시피 이미지 오프라인 저장';

  @override
  String get offlineRecipeImagesHint =>
      '단계와 노트의 이미지를 포함한 모든 레시피 이미지를 기기에 내려받아 연결 없이도 표시해요. 컬렉션이 크면 수백 MB를 차지할 수 있어요. 끄면 저장된 이미지가 삭제돼요.';

  @override
  String offlineRecipeImagesStatus(int count, int total, String size) {
    return '저장됨: $count/$total · $size';
  }

  @override
  String get offlineRecipeImagesDisableConfirm => '저장된 레시피 이미지를 모두 삭제할까요?';

  @override
  String headerNameLabel(int n) {
    return '헤더 $n 이름';
  }

  @override
  String headerValueLabel(int n) {
    return '헤더 $n 값';
  }

  @override
  String get value => '값';

  @override
  String get personalization => '개인 설정';

  @override
  String get showRecipeImagesSubtitle => '레시피 목록에 이미지를 표시해요';

  @override
  String get exactQuantities => '정확한 수량 추가';

  @override
  String get exactQuantitiesSubtitle =>
      '재료와 입력한 항목이 항목당 1× 대신 수량과 단위를 유지해요 (예: 200 g 버터)';

  @override
  String get remindToShop => '장보기 알림';

  @override
  String get remindToShopSubtitle =>
      '저장된 장소 근처에 있고 장보기 목록에 남은 항목이 있으면 알려 줘요 — 앱이 닫혀 있어도요';

  @override
  String get shoppingReminderAddLocation => '장소 추가';

  @override
  String get shoppingReminderMaxLocations => '최대 3곳에 도달했어요';

  @override
  String get shoppingReminderLocationServiceDisabled => '이 기기에서 위치 서비스가 꺼져 있어요';

  @override
  String get shoppingReminderPermissionTitle => '위치 접근 권한 필요';

  @override
  String get shoppingReminderPermissionMessage =>
      '매장 근처에서 알려 드리려면 위치 접근을 “항상”으로 허용해야 해요 — 앱이 닫혀 있어도요. 설정에서 켜 주세요.';

  @override
  String get openSettings => '설정 열기';

  @override
  String get shoppingReminderLocationName => '이름';

  @override
  String get shoppingReminderUseCurrentLocation => '현재 위치 사용';

  @override
  String get shoppingReminderOrAddress => '또는 주소 입력';

  @override
  String get shoppingReminderAddress => '주소';

  @override
  String get shoppingReminderAddressPlaceholder => '도로명, 도시';

  @override
  String get shoppingReminderSearchAddress => '검색';

  @override
  String get shoppingReminderLocationFailed => '위치를 확인하지 못했어요';

  @override
  String get shoppingReminderAddressNotFound => '주소를 찾을 수 없어요';

  @override
  String get ratingFailed => '평점을 저장하지 못했어요 — 다시 시도해 주세요.';

  @override
  String get lastCooked => '마지막 요리';

  @override
  String get syncLastCooked => '“마지막 요리” 업데이트';

  @override
  String get syncLastCookedSubtitle =>
      '오늘 날짜와 타임라인 항목을 서버에 저장해요 — Mealie 웹 앱처럼요.';

  @override
  String get developer => '개발자';

  @override
  String get enableLoggingSubtitle => '출력/오류 로그를 기록해요 (최근 500줄)';

  @override
  String get entriesLabel => '항목';

  @override
  String get fileSize => '파일 크기';

  @override
  String get showAction => '보기';

  @override
  String get copy => '복사';

  @override
  String logsWithCount(int count) {
    return '로그 ($count)';
  }

  @override
  String get noLogs => '로그가 없어요';

  @override
  String get logsTitle => '로그';

  @override
  String get required => '필수';

  @override
  String get connectionFailedCheck => '연결에 실패했어요. URL과 토큰을 확인하세요.';

  @override
  String get username => '사용자 이름';

  @override
  String get password => '비밀번호';

  @override
  String get setupPasswordHint =>
      '비밀번호는 저장되지 않아요 — 앱이 한 번 로그인해 API 토큰을 생성해요 (웹 앱의 프로필 → API 토큰과 같아요).';

  @override
  String get loginAndConnect => '로그인 후 연결';

  @override
  String get loginInvalidCredentials => '사용자 이름 또는 비밀번호가 올바르지 않아요.';

  @override
  String get apiTokenSaveHint => '토큰이 적용됐어요 — 아래의 “변경 사항 저장”을 눌러 주세요.';

  @override
  String get renewApiToken => 'API 토큰 갱신';

  @override
  String get setupAuthChoiceTitle => '어떻게 로그인할까요?';

  @override
  String get authModePasswordTitle => '앱이 API 키를 만들어 주세요';

  @override
  String get authModePasswordSubtitle =>
      '사용자 이름과 비밀번호로 로그인 — 앱이 토큰을 자동으로 생성해요.';

  @override
  String get authModeTokenTitle => 'API 키가 이미 있어요';

  @override
  String get authModeTokenSubtitle => 'Mealie 프로필에서 복사 (프로필 → API 토큰).';

  @override
  String keyN(int n) {
    return '키 $n';
  }

  @override
  String valueN(int n) {
    return '값 $n';
  }

  @override
  String get openCookingMode => '요리 모드 열기';

  @override
  String activeRecipes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '진행 중인 레시피 $count개',
    );
    return '$_temp0';
  }

  @override
  String get reparseIngredients => '재료 다시 분석';

  @override
  String get reparseIngredientsSubtitle => '수량/단위/재료로 나누기 (예: “밀가루 200 g”)';

  @override
  String get reparseDone => '재료를 나눴어요 – 적용하려면 “변경 사항 저장”을 누르세요';

  @override
  String get tagsAndCategories => '태그, 카테고리 및 도구';

  @override
  String get tapToAddPhoto => '눌러서 사진 추가';

  @override
  String get descriptionLabel => '설명';

  @override
  String get searchingDevices => '같은 Wi-Fi의 기기를 찾는 중…';

  @override
  String get selectAll => '모두 선택';

  @override
  String get importReminders => '미리 알림 가져오기';

  @override
  String get importGoogleTasks => 'Google Tasks 가져오기';

  @override
  String get noTaskLists => '할 일 목록이 없어요';

  @override
  String get noReminderLists => '미리 알림 목록이 없어요';

  @override
  String importCount(int count) {
    return '$count개 가져오기';
  }

  @override
  String get noIngredientsToLink => '아직 연결할 재료가 없어요';

  @override
  String get importLanguageSubtitle => '사진이나 PDF에서 가져온 레시피의 언어';

  @override
  String get importLanguageSearch => '언어 검색';

  @override
  String get importLanguageFollowApp => '앱 언어와 동일';

  @override
  String get importLanguageNoMatch => '언어를 찾을 수 없어요';

  @override
  String get setupImportLanguageTitle => 'AI 레시피 가져오기';

  @override
  String get setupImportLanguageBody =>
      '사진과 PDF를 AI로 레시피로 바꿀 수 있어요. 결과물의 언어를 선택하세요 — 모국어가 앱 언어에 없을 때 유용해요. 나중에 설정에서 바꿀 수 있어요.';

  @override
  String get setupImportLanguageSearchHint =>
      '앱 화면에서 지원하지 않는 언어는 선택 화면의 검색으로 찾을 수 있어요.';

  @override
  String get setupCachingKeepOpenTitle => '앱을 열어 두세요';

  @override
  String get setupCachingKeepOpenBody =>
      '불러오기는 포그라운드에서 진행돼요. 끝날 때까지 앱을 열어 두세요 — 닫거나 너무 오래 다른 앱으로 전환하면 중단되고 나중에 처음부터 다시 시작해요.';

  @override
  String get supportContact => '지원팀에 문의';

  @override
  String get supportDialogMessage =>
      '문제를 설명해 주시면 답변드릴게요. 로그는 문제 해결에 큰 도움이 돼요 — 텍스트 파일로 첨부할 수 있어요.';

  @override
  String get supportWithoutLogs => '로그 없이';

  @override
  String get supportWithLogs => '로그 첨부';

  @override
  String get supportMailSubject => 'Mealie Recipes — 지원';

  @override
  String get supportMailHint => '여기에 문제를 설명해 주세요:';

  @override
  String get supportLogsEmpty => '로그가 비어 있어요. 로그를 켜고 문제를 재현한 다음 보내 주세요.';

  @override
  String supportAddressCopied(String email) {
    return '주소를 복사했어요: $email';
  }

  @override
  String supportNoMailApp(String email) {
    return '설정된 메일 앱이 없어요 – 주소를 복사했어요: $email. 다른 앱을 선택해 연락해 주세요.';
  }

  @override
  String get createRecipeFromImages => '레시피 만들기';

  @override
  String imagePagesSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count페이지 선택됨',
    );
    return '$_temp0';
  }

  @override
  String get imagePagesHint =>
      '첫 번째 이미지가 레시피의 대표 이미지가 돼요. 페이지를 길게 눌러 순서를 바꾸세요.';

  @override
  String get mainImageBadge => '대표';

  @override
  String maxImagesReached(int max) {
    return '레시피당 최대 $max개의 이미지를 추가할 수 있어요.';
  }

  @override
  String get removePage => '페이지 삭제';

  @override
  String get preparingPdf => 'PDF 처리 중...';

  @override
  String get recipeOptionsTitle => '옵션';

  @override
  String get exportAsPdf => 'PDF로 내보내기';

  @override
  String get generatingPdf => 'PDF 만드는 중…';

  @override
  String get pdfExportFailed => 'PDF 내보내기 실패';

  @override
  String get recipeTime => '시간';

  @override
  String get addIngredientSection => '섹션 추가';

  @override
  String get aiImportToggle => 'AI로 분석';

  @override
  String get aiImportToggleHint =>
      '레시피 동영상(YouTube, Instagram, TikTok …)과 일반 가져오기로 읽을 수 없는 페이지에도 사용돼요. Mealie 서버에 AI 제공자가 필요해요 — 동영상에는 오디오 제공자도 필요해요.';

  @override
  String get aiImportButton => 'AI로 가져오기';

  @override
  String get aiImportRunning => 'AI가 링크를 분석하고 있어요 … 동영상은 몇 분 걸릴 수 있어요.';

  @override
  String get aiImportFailed => 'AI 가져오기에 실패했어요. Mealie 서버의 AI 설정을 확인하세요.';

  @override
  String get stepHeadingLabel => '단계 제목 (선택)';

  @override
  String get linkedRecipeLabel => '연결된 레시피';

  @override
  String get toolsTitle => '도구';

  @override
  String get prepareTools => '다음 도구를 준비하세요';

  @override
  String get newTool => '새 도구';

  @override
  String get renameAction => '이름 변경';

  @override
  String get organizerEmpty => '아직 아무것도 없어요. 오른쪽 위의 “+”를 눌러 만들어 보세요.';

  @override
  String organizerRecipeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '레시피 $count개',
      zero: '레시피 없음',
    );
    return '$_temp0';
  }

  @override
  String get toolOnHand => '보유 중';

  @override
  String get mealDiceSettingsHint =>
      '식사별로 카테고리와 태그를 선택하세요. 주사위를 굴리면 그중 하나 이상이 있는 레시피만 추천돼요. 같은 항목을 여러 식사에 쓸 수 있어요.';

  @override
  String get mealDiceSettingsNoneHint =>
      '이 식사에는 선택된 것이 없어요: 주사위가 “아침”, “점심”, “저녁” 같은 카테고리 이름으로 자동 선택해요.';

  @override
  String get mealDiceAutoHintTitle => '자동 선택';

  @override
  String get mealDiceAutoHintBody =>
      '이 식사에는 아직 카테고리나 태그가 설정되지 않았어요. 그래서 주사위는 “아침”, “점심”, “저녁” 같은 카테고리를 찾고 다른 레시피로 채워요.\n\n직접 고르려면: 식단에서 “+” 옆의 톱니바퀴 아이콘을 누르세요.';

  @override
  String get dontShowAgain => '다시 보지 않기';

  @override
  String get mealDiceNoMatches => '이 식사에 선택한 카테고리와 태그에 맞는 레시피가 없어요.';

  @override
  String mealDiceFewMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '맞는 레시피가 $count개뿐이에요',
    );
    return '$_temp0';
  }

  @override
  String get commentsTitle => '댓글';

  @override
  String get commentHint => '댓글 쓰기…';

  @override
  String get commentSaveFailed => '댓글을 저장하지 못했어요.';

  @override
  String get commentDeleteConfirm => '이 댓글을 삭제할까요?';

  @override
  String get cookingDoneCommentLabel => '댓글 (선택)';

  @override
  String get cookingDoneCommentHint => '어떻게 됐나요? 다음을 위한 팁…';

  @override
  String get nutritionTitle => '영양성분';

  @override
  String get nutritionPerServing => '1인분 기준';

  @override
  String get nutritionCalories => '칼로리';

  @override
  String get nutritionFat => '지방';

  @override
  String get nutritionSaturatedFat => '포화지방';

  @override
  String get nutritionTransFat => '트랜스지방';

  @override
  String get nutritionUnsaturatedFat => '불포화지방';

  @override
  String get nutritionCholesterol => '콜레스테롤';

  @override
  String get nutritionSodium => '나트륨';

  @override
  String get nutritionCarbohydrates => '탄수화물';

  @override
  String get nutritionFiber => '섬유질';

  @override
  String get nutritionSugar => '당류';

  @override
  String get nutritionProtein => '단백질';

  @override
  String get timelineTitle => '타임라인';

  @override
  String get timelineMadeThis => '만들었어요';

  @override
  String timelineUserMadeThis(String name) {
    return '$name님이 만들었어요';
  }

  @override
  String get timelineEmpty => '아직 타임라인 항목이 없어요.';

  @override
  String get timelineDate => '날짜';

  @override
  String get timelineNoteHint => '노트 (선택)';

  @override
  String get timelineAddPhoto => '사진 추가';

  @override
  String get timelineRemovePhoto => '사진 삭제';

  @override
  String get timelineSaved => '타임라인에 추가했어요';

  @override
  String get timelineSaveFailed => '타임라인에 추가하지 못했어요';

  @override
  String get timelineImageFailed => '항목은 저장했지만 사진을 업로드하지 못했어요';

  @override
  String get timelineDeleteConfirm => '이 항목을 타임라인에서 삭제할까요?';

  @override
  String get timelineEditNote => '노트 편집';

  @override
  String get timelineUnknownRecipe => '레시피를 찾을 수 없어요';

  @override
  String get cookingDonePhotoHint => 'Mealie 타임라인용 사진 (선택)';

  @override
  String get assetsTitle => '첨부 파일';

  @override
  String get assetsAdd => '첨부 파일 추가';

  @override
  String get assetsChooseFile => '파일';

  @override
  String get assetsUploading => '업로드 중…';

  @override
  String get assetsUploadFailed => '첨부 파일을 업로드하지 못했어요';

  @override
  String assetsDeleteConfirm(String name) {
    return '첨부 파일에서 “$name”을(를) 삭제할까요?';
  }

  @override
  String get assetsOpenFailed => '첨부 파일을 열지 못했어요';

  @override
  String get assetsUnsupported => 'Mealie는 PDF, 이미지, TXT, MD, CSV, JSON만 지원해요.';

  @override
  String get assetsShare => '공유';

  @override
  String get mealRulesTitle => 'Mealie 규칙';

  @override
  String get mealRulesHint =>
      'Mealie 웹 앱에서도 사용돼요. 요일과 식사에 여러 규칙이 해당되면 모두 일치해야 해요. 해당하는 규칙이 없으면 주사위가 모든 레시피 중에서 골라요.';

  @override
  String get mealRuleAdd => '규칙 추가';

  @override
  String get mealRuleNewTitle => '새 규칙';

  @override
  String get mealRuleEditTitle => '규칙 편집';

  @override
  String get mealRuleDay => '요일';

  @override
  String get mealRuleAnyDay => '모든 요일';

  @override
  String get mealRuleMealType => '식사';

  @override
  String get mealRuleAnyMeal => '모든 식사';

  @override
  String get mealRuleConditionsTitle => '조건';

  @override
  String get mealRuleAllRecipes => '모든 레시피';

  @override
  String get mealRuleDeleteConfirm => '이 규칙을 삭제할까요?';

  @override
  String get mealRulesOffline => '지금은 Mealie 규칙을 사용할 수 없어요 – 주사위가 앱 선택을 사용해요.';

  @override
  String get mealRulesNoMatches => '이 식사의 Mealie 규칙에 맞는 레시피가 없어요.';

  @override
  String get mealTypeSide => '사이드';

  @override
  String get mealTypeSnack => '간식';

  @override
  String get mealTypeDrink => '음료';

  @override
  String get mealTypeDessert => '디저트';

  @override
  String get foodsTitle => '식품';

  @override
  String get unitsTitle => '단위';

  @override
  String get newFood => '새 식품';

  @override
  String get newUnit => '새 단위';

  @override
  String get editFood => '식품 편집';

  @override
  String get editUnit => '단위 편집';

  @override
  String get pluralNameLabel => '복수형 이름';

  @override
  String get abbreviationLabel => '약어';

  @override
  String get pluralAbbreviationLabel => '복수형 약어';

  @override
  String get mergeAction => '병합';

  @override
  String mergeIntoTitle(String name) {
    return '“$name”을(를) 병합할 대상…';
  }

  @override
  String mergeConfirm(String from, String to) {
    return '“$from”이(가) “$to”(으)로 병합돼요: 이후 모든 레시피와 장보기 목록은 “$to”을(를) 사용하고 “$from”은(는) 삭제돼요.';
  }

  @override
  String get mergeFailed => '병합 실패';

  @override
  String foodUnitDeleteConfirm(String name) {
    return '“$name”을(를) 삭제할까요? 이를 사용하는 재료는 연결이 끊겨요.';
  }

  @override
  String get foodsUnitsEmpty => '아직 항목이 없어요.';

  @override
  String mealRuleConditionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '조건 $count개',
    );
    return '$_temp0';
  }

  @override
  String get showAll => '모두 보기';

  @override
  String get mealDiceModeTitle => '주사위 기준';

  @override
  String get mealDiceModeApp => '앱 선택';

  @override
  String get switchListTitle => '목록 전환';

  @override
  String get newShoppingList => '새 장보기 목록';

  @override
  String shoppingListDeleteConfirm(String name) {
    return '“$name”을(를) 삭제할까요? 안의 항목도 모두 삭제돼요.';
  }

  @override
  String get labelOrderTitle => '라벨 정렬';

  @override
  String get labelOrderHint => '끌어서 정렬하세요. 이 목록에 적용돼요 – Mealie 웹 앱에서도요.';

  @override
  String get labelOrderEmpty => '이 목록에는 아직 라벨이 없어요.';

  @override
  String get useAsActiveList => '활성 목록으로 사용';

  @override
  String get activeListBadge => '활성';

  @override
  String get foodLabelLabel => '라벨';

  @override
  String get foodNoLabel => '라벨 없음';

  @override
  String get aliasesLabel => '별칭';

  @override
  String get aliasAddHint => '별칭 추가';

  @override
  String get foodOnHand => '가구에 보유 중';

  @override
  String get timelineChildRecipesTitle => '연결된 레시피에도 추가';

  @override
  String timelineMadeForRecipe(String recipe) {
    return '$recipe를 위해 만들어짐';
  }

  @override
  String get timelineFilter => '항목 필터';

  @override
  String get timelineTypeComment => '요리 기록 및 노트';

  @override
  String get timelineTypeInfo => '정보';

  @override
  String get timelineTypeSystem => '시스템';

  @override
  String get listManagementTitle => '장보기 목록';

  @override
  String get managementTitle => '더 보기';

  @override
  String get pinToHome => '홈 화면에 추가';

  @override
  String get unpinFromHome => '홈 화면에서 제거';

  @override
  String homeScreenFull(int count) {
    return '홈 화면이 가득 찼어요 – 최대 $count개 타일. 먼저 “더 보기”에서 다른 타일을 제거하세요.';
  }

  @override
  String get selectAction => '선택';

  @override
  String selectedCount(int count) {
    return '$count개 선택됨';
  }

  @override
  String get assignLabelAction => '라벨 지정';

  @override
  String get assignLabelOverwriteHint => '선택한 모든 식품의 라벨을 덮어써요.';

  @override
  String deleteSelectedConfirm(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '항목 $count개를 삭제할까요?',
    );
    return '$_temp0';
  }

  @override
  String get seedDataAction => '기본 데이터 불러오기';

  @override
  String get seedFoodsHint => '선택한 언어로 Mealie 기본 식품을 만들어요.';

  @override
  String get seedUnitsHint => '선택한 언어로 Mealie 기본 단위를 만들어요.';

  @override
  String get seedLanguageLabel => '언어';

  @override
  String get seedDuplicateWarning =>
      '이미 항목이 있어요. Mealie는 중복을 정리하지 않아요 – 나중에 직접 병합해야 해요.';

  @override
  String get seedDone => '기본 데이터를 만들었어요';

  @override
  String get seedFailed => '기본 데이터를 불러오지 못했어요';

  @override
  String get exportAction => '내보내기';

  @override
  String get substitutionsLabel => '대체 재료';

  @override
  String get substitutionAddHint => '대체 재료 추가';

  @override
  String get substitutionFoodLabel => '식품 (선택)';

  @override
  String get substitutionNoteLabel => '노트 (선택)';

  @override
  String get substitutionNeedOne => '식품이나 노트를 입력하세요';

  @override
  String get useAbbreviationLabel => '약어 사용';

  @override
  String get useAbbreviationHint => '레시피에서 “그램” 대신 “g” 표시';

  @override
  String get fractionLabel => '분수로 표시';

  @override
  String get fractionHint => '0.5 대신 ½';

  @override
  String get standardizationTitle => '표준화';

  @override
  String get standardizationHint => '변환용: 이 단위 1은 …에 해당해요 (예: 1큰술 = 15밀리리터).';

  @override
  String get standardQuantityLabel => '표준 수량';

  @override
  String get standardUnitLabel => '표준 단위';

  @override
  String get standardUnitNone => '없음';

  @override
  String get stdFluidOunce => '액량 온스 (fl oz)';

  @override
  String get stdCup => '컵 (미국)';

  @override
  String get stdOunce => '온스 (oz)';

  @override
  String get stdPound => '파운드 (lb)';

  @override
  String get stdMilliliter => '밀리리터';

  @override
  String get stdLiter => '리터';

  @override
  String get stdGram => '그램';

  @override
  String get stdKilogram => '킬로그램';

  @override
  String get labelsTitle => '라벨';

  @override
  String get newLabel => '새 라벨';

  @override
  String get editLabel => '라벨 편집';

  @override
  String get colorLabel => '색상';

  @override
  String labelDeleteConfirm(String name) {
    return '“$name”을(를) 삭제할까요? 항목과 식품에서 이 라벨이 빠져요.';
  }

  @override
  String get importMenuAction => '가져오기';

  @override
  String get archivedEmpty =>
      '아직 보관된 장보기가 없어요. 장을 본 뒤 “장보기 완료”를 누르면 체크한 항목이 여기에 저장돼요.';

  @override
  String get sectionTitleLabel => '섹션 제목';

  @override
  String get clearSection => '섹션 해제';

  @override
  String get noPermissionGeneric =>
      'Mealie에서 이 작업을 할 권한이 없어요. 관리자나 가구 관리자에게 문의하세요.';

  @override
  String get noPermissionEditRecipe =>
      '이 레시피는 편집할 수 없어요 – 잠겨 있거나 다른 가구의 레시피예요. 작성자나 관리자만 편집할 수 있어요.';

  @override
  String get noPermissionDeleteRecipe => '레시피는 작성자나 관리자만 삭제할 수 있어요.';

  @override
  String get noPermissionDemoteSelf => '자신의 관리자 권한은 제거할 수 없어요.';

  @override
  String get recipeLockedHint => '잠김 – 작성자만 편집 가능';

  @override
  String get recipeDeleteOwnerOnlyHint => '작성자나 관리자만 삭제 가능';

  @override
  String get organizeReadOnlyHint =>
      '보기 전용: 만들기, 변경, 삭제에는 “사용자가 식품, 태그 및 카테고리를 관리할 수 있음” 권한이 필요해요.';

  @override
  String get notesNotSavedNoPermission => '노트가 저장되지 않았어요 – 이 레시피를 편집할 권한이 없어요.';

  @override
  String get userManagementTitle => '사용자 관리';

  @override
  String get editUserTitle => '사용자 편집';

  @override
  String get fullNameLabel => '이름';

  @override
  String get usernameLabel => '사용자 이름';

  @override
  String get emailLabel => '이메일';

  @override
  String get passwordLabel => '비밀번호';

  @override
  String get householdLabel => '가구';

  @override
  String get permissionsTitle => '권한';

  @override
  String get administratorLabel => '관리자';

  @override
  String get permCanInvite => '사용자는 다른 사용자를 그룹에 초대할 수 있습니다';

  @override
  String get permCanManage => '사용자가 그룹 설정을 관리할 수 있음';

  @override
  String get permCanManageHousehold => '사용자는 가구를 관리할 수 있습니다';

  @override
  String get permCanOrganize => '사용자가 식품, 태그 및 카테고리를 관리할 수 있음';

  @override
  String get advancedFeaturesLabel => '고급 기능 활성화';

  @override
  String get passwordResetLinkAction => '비밀번호 재설정 링크 생성';

  @override
  String get resetLockedUsersAction => '잠긴 사용자 재설정';

  @override
  String get inviteLinkTitle => '초대 링크';

  @override
  String get inviteAction => '초대하기';

  @override
  String get userUpdated => '사용자 수정됨';

  @override
  String get createUserTitle => '사용자 만들기';

  @override
  String get userCreated => '사용자를 만들었어요';

  @override
  String userDeleteConfirm(String name) {
    return '“$name”을(를) 삭제할까요? 계정이 Mealie에서 삭제돼요.';
  }

  @override
  String get passwordResetLinkCopied =>
      '링크를 복사했어요 – 사용자에게 전달하세요. 제한된 시간 동안만 유효해요.';

  @override
  String lockedUsersReset(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '사용자 $count명의 잠금을 해제했어요',
      zero: '잠긴 사용자가 없어요',
    );
    return '$_temp0';
  }

  @override
  String get inviteUsesLabel => '사용 횟수';

  @override
  String get inviteCreated => '초대 링크를 만들었어요';

  @override
  String get inviteEmailHint => '이메일 주소 (선택 – Mealie가 초대장을 보내요)';

  @override
  String get inviteEmailSent => '초대장을 이메일로 보냈어요';

  @override
  String get inviteEmailFailed =>
      '이메일을 보내지 못했어요 (Mealie에 SMTP가 설정되어 있나요?). 링크는 그대로 사용할 수 있어요.';

  @override
  String get copyLinkAction => '링크 복사';

  @override
  String get youLabel => '나';

  @override
  String get membersPermissionsHint => '가구 구성원의 권한은 바꿀 수 있지만 자신의 권한은 바꿀 수 없어요.';

  @override
  String get householdManagementTitle => '가구 관리';

  @override
  String get householdsTitle => '가구';

  @override
  String get createHouseholdTitle => '가구 생성';

  @override
  String get householdNameLabel => '가구 이름';

  @override
  String get householdPreferencesTitle => '가구 설정';

  @override
  String get privateHouseholdLabel => '개인 가정';

  @override
  String get privateHouseholdHint =>
      '귀하의 가구를 비공개로 설정하면 모든 공개 보기 옵션이 비활성화됩니다. 이는 개별 공개 보기 설정을 재정의합니다.';

  @override
  String get lockRecipeEditsLabel => '다른 가구의 레시피 편집 잠금';

  @override
  String get lockRecipeEditsHint =>
      '이 기능을 활성화하면 귀하의 가구 구성원만 귀하의 가구가 만든 요리법을 편집할 수 있습니다.';

  @override
  String get householdRecipePreferencesTitle => '가구 레시피 설정';

  @override
  String get groupsTitle => '그룹';

  @override
  String get groupLabel => '그룹';

  @override
  String get createGroupTitle => '그룹 생성';

  @override
  String get groupNameLabel => '그룹 이름';

  @override
  String get groupPreferencesTitle => '그룹 설정';

  @override
  String get privateGroupLabel => '비공개 그룹';

  @override
  String get privateGroupHint =>
      '그룹을 비공개로 설정하면 모든 공개 보기 옵션이 비활성화됩니다. 이는 개별 공개 보기 설정을 모두 무효화합니다.';

  @override
  String get firstDayOfWeekLabel => '일주일의 시작 요일';

  @override
  String get showAnnouncementsLabel => 'Mealie 공지 표시';

  @override
  String get recipePublicDefaultLabel => '그룹 외부 사용자가 여러분의 레시피를 볼 수 있도록 허용하세요';

  @override
  String get recipeShowNutritionDefaultLabel => '영양 정보 표시';

  @override
  String get recipeShowAssetsDefaultLabel => '레시피 에셋 표시';

  @override
  String get recipeLandscapeDefaultLabel => '가로 보기로 기본 설정';

  @override
  String get recipeDisableCommentsDefaultLabel => '사용자가 레시피에 댓글을 달 수 없도록 설정';

  @override
  String get myHouseholdSection => '내 가구';

  @override
  String get myGroupSection => '내 그룹';

  @override
  String get preferencesSaved => '설정을 저장했어요';

  @override
  String get cannotDeleteWithUsers => '아직 사용자가 있어요 – 먼저 사용자 관리에서 이동하거나 삭제하세요.';

  @override
  String deleteHouseholdConfirm(String name) {
    return '“$name” 가구를 삭제할까요?';
  }

  @override
  String deleteGroupConfirm(String name) {
    return '“$name” 그룹을 삭제할까요?';
  }

  @override
  String usersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '사용자 $count명',
      zero: '사용자 없음',
    );
    return '$_temp0';
  }

  @override
  String get originalUrlLabel => '원본 URL';

  @override
  String get copyTextAction => '텍스트 복사';

  @override
  String get copiedToClipboard => '클립보드에 복사되었습니다';

  @override
  String get changelogEnglishHint => '릴리스 노트는 영어로만 제공돼요.';

  @override
  String get favoritesTitle => '즐겨찾기';

  @override
  String get favoritesEmpty => '아직 즐겨찾기가 없어요. 레시피의 하트를 눌러 여기에 모아 보세요.';

  @override
  String get changelogTitle => '변경 사항';

  @override
  String get changeProfileImage => '프로필 사진 변경';

  @override
  String get profileImageUpdated => '프로필 사진을 업데이트했어요';

  @override
  String get profileImageFailed => '프로필 사진을 업로드하지 못했어요';

  @override
  String get myAccountTitle => '내 계정';

  @override
  String get ownAccountHint =>
      '여기서 내 계정을 편집할 수 있어요. 다른 사용자는 관리자와 “관리” 권한이 있는 구성원이 관리해요.';

  @override
  String get changePasswordAction => '비밀번호 변경';

  @override
  String get currentPasswordLabel => '현재 비밀번호';

  @override
  String get newPasswordLabel => '새 비밀번호';

  @override
  String get confirmPasswordLabel => '비밀번호 확인';

  @override
  String get passwordTooShort => '8자 이상';

  @override
  String get passwordsDoNotMatch => '비밀번호가 일치하지 않아요';

  @override
  String get passwordUpdated => '비밀번호가 변경되었습니다';

  @override
  String get passwordChangeFailed => '비밀번호를 변경하지 못했어요';

  @override
  String passwordManagedExternally(String method) {
    return '$method(으)로 로그인하고 있어요 — 비밀번호는 그곳에서 변경하세요.';
  }

  @override
  String get bulkAddHint => '항목마다 한 줄씩.';

  @override
  String bulkAddCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '항목 $count개 추가',
    );
    return '$_temp0';
  }

  @override
  String get linkRecipeAction => '레시피 연결';

  @override
  String get useFoodAction => '레시피 대신 식품 사용';

  @override
  String get addSubstitutionsAction => '대체 재료 추가';

  @override
  String get clearSubstitutionsAction => '대체 재료 지우기';

  @override
  String get recipeSubstitutionsTitle => '대체 재료';

  @override
  String get substitutionUnknownFood => '기존 식품만 가능 – 그 외에는 노트를 사용하세요';

  @override
  String get insertAboveAction => '위에 삽입';

  @override
  String get insertBelowAction => '아래에 삽입';

  @override
  String get moveToTopAction => '맨 위로 이동';

  @override
  String get moveToBottomAction => '맨 아래로 이동';

  @override
  String get linkReferencesAction => '참조 연결';

  @override
  String get editMarkdownAction => '마크다운 수정';

  @override
  String get previewMarkdownAction => '마크다운 미리보기';

  @override
  String get insertStepImageAction => '이미지 업로드';

  @override
  String get mergeAboveAction => '위와 병합';

  @override
  String get linkedToOtherStep => '다른 단계와 연결됨';

  @override
  String get noNotesToLink => '연결할 노트가 없어요';

  @override
  String get ownerLabel => '작성자';

  @override
  String get ingredientParserTitle => '재료 분석기';

  @override
  String ingredientParserHint(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '재료 $count개가 아직 구조화되지 않았어요. 분석기를 고르고 결과를 확인한 뒤 적용하세요.',
    );
    return '$_temp0';
  }

  @override
  String get parserNlp => '자연어 처리기';

  @override
  String get parserBrute => '무차별 분석기';

  @override
  String get parserOpenai => 'OpenAI 분석기';

  @override
  String get parserApp => '오프라인 (앱)';

  @override
  String get parseFailed => '분석 실패';

  @override
  String get parseAction => '추출하기';

  @override
  String applyParsedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '재료 $count개 적용',
      zero: '선택된 항목 없음',
    );
    return '$_temp0';
  }

  @override
  String get parsedNewBadge => '새로움';

  @override
  String get hoursShort => '시간';

  @override
  String get minutesShort => '분';

  @override
  String get timeExtraHint => '추가, 예: “+ 하룻밤”';

  @override
  String get yieldLabel => '생성량';

  @override
  String get yieldTextLabel => '생성 단위';

  @override
  String get prepTimeLabel => '준비 시간';

  @override
  String get performTimeLabel => '요리 시간';

  @override
  String get totalTimeLabel => '총 시간';

  @override
  String get settingPublicRecipe => '공개 레시피';

  @override
  String get settingShowNutrition => '영양 성분 표시';

  @override
  String get settingShowAssets => '에셋 보기';

  @override
  String get settingLandscapeView => '가로 뷰';

  @override
  String get settingDisableComments => '댓글 사용 안 함';

  @override
  String get settingDisableAmount => '재료 수량 비활성화';

  @override
  String get settingLocked => '잠김';

  @override
  String get settingLockedOwnerOnly => '작성자만 레시피를 잠그거나 잠금 해제할 수 있어요.';

  @override
  String get apiExtrasTitle => 'API 기타';

  @override
  String get apiExtrasHint => '타사 앱용 사용자 지정 키/값 쌍 (예: 자동화 실행).';

  @override
  String get extraKeyLabel => '키';

  @override
  String get extraValueLabel => '값';

  @override
  String get addExtraAction => '추가 항목 추가';

  @override
  String durationHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count시간',
    );
    return '$_temp0';
  }

  @override
  String durationMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count분',
    );
    return '$_temp0';
  }

  @override
  String get discardChangesConfirm => '저장하지 않은 변경 사항을 버릴까요?';

  @override
  String get discardChanges => '변경사항 취소';

  @override
  String get imageFromUrl => 'URL에서 이미지';

  @override
  String get deleteRecipeImage => '레시피 이미지 삭제';

  @override
  String get deleteRecipeImageConfirm => '이 레시피 이미지를 삭제하시겠습니까?';

  @override
  String get bulkAddIngredients => '재료 일괄 추가';

  @override
  String get bulkAddSteps => '단계 일괄 추가';

  @override
  String get stepImageFailed => '이미지를 업로드하지 못했어요';

  @override
  String get servingsAndTimes => '제공량 및 시간';

  @override
  String get recipeSettingsTitle => '레시피 설정';

  @override
  String get jsonEditorTitle => 'JSON 편집기';

  @override
  String get jsonInvalid => '잘못된 JSON이에요 – 확인해 주세요.';

  @override
  String get editorOfflineHint =>
      '오프라인으로 열었어요: 저장하려면 연결이 필요해요. 최신 Mealie 필드(예: 대체 재료)는 그대로 유지돼요.';

  @override
  String get parseLineFailed => '인식 못 함 – 그대로 유지';

  @override
  String get createManualTitle => '레시피 직접 만들기';

  @override
  String get createManualHint =>
      '이름을 입력하세요 – 재료, 단계, 이미지 등은 나중에 레시피 편집기에서 추가해요.';

  @override
  String get createManualButton => '만들고 편집';

  @override
  String get changelogEmpty => '이 버전에는 아직 항목이 없어요.';

  @override
  String get finderDescription =>
      '가지고 있는 재료로 레시피를 검색하세요. 사용 가능한 도구로도 필터링할 수 있으며, 부족한 재료나 도구의 최대 개수를 설정할 수 있습니다.';

  @override
  String get finderSelectedIngredients => '선택된 재료';

  @override
  String get finderNoIngredientsSelected => '선택된 재료 없음';

  @override
  String get finderMissing => '없음';

  @override
  String get finderNoRecipesFound => '검색 결과가 없습니다.';

  @override
  String get finderNoRecipesFoundDescription =>
      '검색어에 더 많은 항목을 추가하거나 필터를 조정해 보세요.';

  @override
  String get finderIncludeFoodsOnHand => '가지고 있는 재료 포함';

  @override
  String get finderIncludeToolsOnHand => '가지고 있는 도구 포함';

  @override
  String get finderIncludeSubstitutions => '대체 재료 포함';

  @override
  String get finderSubstituting => '대체 중';

  @override
  String finderSubstituteForFood(String substitute, String food) {
    return '$food 대신 $substitute';
  }

  @override
  String get finderMaxMissingIngredients => '없는 재료 최대 수';

  @override
  String get finderMaxMissingTools => '없는 도구 최대 수';

  @override
  String get finderSelectedTools => '선택된 도구';

  @override
  String get finderReadyToMake => '만들 수 있음';

  @override
  String get finderAlmostReadyToMake => '거의 만들 수 있음';

  @override
  String get finderSettings => '설정';

  @override
  String get finderLoadingRecipes => '레시피 로딩 중';

  @override
  String get finderClearSelection => '모두 선택 취소';

  @override
  String get finderOfflineHint => '서버에 연결되지 않았어요 – 이 기기에 저장된 레시피의 결과예요.';

  @override
  String get sendPeerOfflineHint => '지금은 연결할 수 없어요 – 상대가 앱을 열면 도착해요';

  @override
  String sendDeliveredLater(String device) {
    return '“$device”에 지금 연결할 수 없어요. 상대가 앱을 열면 바로 레시피가 도착해요.';
  }

  @override
  String get sendQueuedOffline => '지금은 연결되어 있지 않아요. 다시 온라인이 되면 레시피가 자동으로 전송돼요.';

  @override
  String get searchHasAll => '전부 포함';

  @override
  String get searchHasAny => '적어도 하나 포함';

  @override
  String get recipeFilterTitle => '필터';

  @override
  String get finderOtherFilters => '기타 필터';

  @override
  String get qfOpEquals => '정확히 일치';

  @override
  String get qfOpNotEquals => '일치하지 않음';

  @override
  String get qfOpGreater => '다음보다 큼';

  @override
  String get qfOpGreaterEq => '다음보다 크거나 같음';

  @override
  String get qfOpLess => '다음보다 작음';

  @override
  String get qfOpLessEq => '다음보다 작거나 같음';

  @override
  String get qfOpNewerThan => '~보다 최근임';

  @override
  String get qfOpOlderThan => '~보다 오래됨';

  @override
  String qfDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count일 전',
    );
    return '$_temp0';
  }

  @override
  String get filterResetAll => '모든 필터 초기화';

  @override
  String get filterAny => '모두';

  @override
  String get filterOfflineIgnored => '오프라인에서는 “기타 필터”를 단순한 형태로만 적용할 수 있어요.';

  @override
  String linkedRecipesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '연결된 레시피 $count개',
      zero: '연결된 레시피 없음',
    );
    return '$_temp0';
  }

  @override
  String get shoppingReminderNotificationsOff =>
      'Mealie Recipes 알림이 꺼져 있어요 — 알림 없이는 장보기 알림을 표시할 수 없어요. 설정에서 알림을 허용하세요.';

  @override
  String get shoppingReminderInactiveHint =>
      '지금은 장보기 알림이 작동할 수 없어요: 위치 접근을 “항상”으로 설정하고 알림을 허용하세요.';

  @override
  String get bulkImportTitle => '대량 URL 가져오기';

  @override
  String get bulkImportDescription =>
      '대량 레시피 가져오기 도구는 백엔드에서 사이트를 대기열에 추가하고 백그라운드에서 작업을 실행함으로써 여러 레시피를 한 번에 가져올 수 있게 합니다. 이는 Mealie로 처음 이전할 때나 대량의 레시피를 가져오고 싶을 때 유용합니다.';

  @override
  String get bulkAddTitle => '일괄추가';

  @override
  String get bulkImportSetOrganizers => '카테고리 및 태그 설정';

  @override
  String get bulkImportStarted => '대량 가져오기 시작됨';

  @override
  String get bulkImportFailed => '대량 가져오기 실패함';

  @override
  String get bulkImportReports => '대량 가져오기';

  @override
  String get bulkImportUrlHint => '레시피 URL';

  @override
  String get migrationsTitle => '데이터 이전';

  @override
  String get migrationsDescription =>
      '지원되는 다른 앱에서 Mealie로 레시피를 옮길 수 있어요. Mealie를 시작하기에 좋은 방법이에요. Mealie 인스턴스 간 데이터 이동이나 이전 Mealie 백업 복원은 대신 백업 및 복원 도구로 해요.';

  @override
  String get migrationNew => '새 데이터 이전';

  @override
  String get migrationChooseType => '이전 종류 선택';

  @override
  String get noFileSelected => '선택된 파일이 없습니다';

  @override
  String migrationTagAll(String tag) {
    return '모든 레시피에 $tag 태그 지정';
  }

  @override
  String get migrationPrevious => '이전 데이터 이전';

  @override
  String get migrationMealieDescription =>
      'Mealie는 v1.0 이전 Mealie 앱의 레시피를 가져올 수 있어요. 이전 인스턴스에서 레시피를 내보낸 뒤 아래에 zip 파일을 업로드하세요. 내보내기에서는 레시피만 가져올 수 있어요. 이는 v1.0보다 오래된 인스턴스에만 해당돼요. v1.0 이후에 만든 백업은 백업 및 복원 도구로 복원하세요.';

  @override
  String get migrationChowdownDescription =>
      'Mealie는 기본적으로 Chowdown 저장소 형식을 지원합니다. 코드 저장소를 .zip 파일로 다운로드한 후 아래에 업로드하세요.';

  @override
  String get migrationCopyMeThatDescription =>
      'Mealie는 Copy Me That에서 레시피를 가져올 수 있습니다. 레시피를 HTML 형식으로 내보낸 후, 아래의 .zip 파일을 업로드하세요.';

  @override
  String get migrationMyRecipeBoxDescription =>
      'Mealie는 My Recipe Box에서 레시피를 가져올 수 있습니다. CSV 형식으로 레시피를 내보낸 다음 아래의 .csv 파일을 업로드하세요.';

  @override
  String get migrationNextcloudDescription =>
      'Nextcloud 레시피는 Nextcloud에 저장된 데이터를 포함하는 zip 파일에서 가져올 수 있습니다. 레시피를 가져올 수 있도록 하려면 아래의 예시 폴더 구조를 참조하십시오.';

  @override
  String get migrationPaprikaDescription =>
      'Mealie는 Paprika 애플리케이션에서 레시피를 가져올 수 있습니다. Paprika에서 레시피를 내보낸 후, 내보낸 파일의 확장자를 .zip으로 변경하여 아래에 업로드하세요.';

  @override
  String get migrationPlanToEatDescription =>
      'Mealie는 Plan to Eat에서 레시피를 가져올 수 있습니다.';

  @override
  String get migrationRecipeKeeperDescription =>
      'Mealie는 Recipe Keeper에서 레시피를 가져올 수 있습니다. 레시피를 zip 형식으로 내보낸 다음 아래의 .zip 파일을 업로드하세요.';

  @override
  String get migrationTandoorDescription =>
      'Mealie는 Tandoor에서 레시피를 가져올 수 있습니다. 데이터를 \"기본\" 형식으로 내보낸 후 아래의 .zip 파일을 업로드하세요.';

  @override
  String get migrationCooknDescription =>
      'Mealie는 DVO Cook\'n X3의 레시피를 가져올 수 있습니다. \"Cook\'n\" 형식으로 요리책이나 메뉴를 내보낸 후, 내보낸 파일의 확장자를 .zip으로 변경하고 아래에 .zip 파일을 업로드하세요.';

  @override
  String get reportTitle => '보고서';

  @override
  String get recipeDataTitle => '레시피 데이터';

  @override
  String get recipeDataDescription =>
      '이 섹션을 사용하여 레시피와 관련된 데이터를 관리하세요. 레시피에 대해 내보내기, 삭제, 태그 지정, 카테고리 할당 등 여러 일괄 작업을 수행할 수 있습니다.';

  @override
  String get recipeDataTagTitle => '레시피에 태그 설정';

  @override
  String get recipeDataCategorizeTitle => '레시피에 카테고리 설정';

  @override
  String get recipeDataSettingsTitle => '업데이트 설정';

  @override
  String get recipeDataExportTitle => '레시피 내보내기';

  @override
  String get recipeDataDeleteTitle => '레시피 삭제';

  @override
  String recipeDataExportConfirm(int count) {
    return '다음 레시피($count개)를 내보내요.';
  }

  @override
  String get recipeDataExportsTitle => '데이터 내보내기';

  @override
  String get recipeDataExportsDescription =>
      '이 섹션에서는 다운로드 가능한 내보내기 파일 링크를 제공합니다. 해당 내보내기 파일은 만료되므로, 이용 가능할 때 반드시 다운받으시기 바랍니다.';

  @override
  String get recipeDataPurgeExports => '내보내기 데이터 삭제';

  @override
  String get recipeDataPurgeConfirm => '모든 내보내기 데이터를 삭제하시겠습니까?';

  @override
  String get recipeActionsTitle => '레시피 액션';

  @override
  String get recipeActionNew => '새 레시피 액션';

  @override
  String get recipeActionEdit => '레시피 액션 편집';

  @override
  String get recipeActionTypeLink => '외부 연결';

  @override
  String get recipeActionTypePost => 'POST';

  @override
  String get webhooksTitle => '웹훅';

  @override
  String get webhooksDescription =>
      '아래 정의된 웹훅은 해당 일자에 식단이 설정될 때 실행됩니다. 예약된 시간에 해당 일자에 예약된 레시피의 데이터와 함께 웹훅이 전송됩니다. 웹훅 실행은 정확하지 않다는 점에 유의하십시오. 웹훅은 5분 간격으로 실행되므로 예약된 시간으로부터 5분 +/- 범위 내에서 실행됩니다.';

  @override
  String get webhookName => '웹훅 이름';

  @override
  String get webhookUrl => '웹훅 URL';

  @override
  String get notifiersTitle => '알리미';

  @override
  String get notifiersDescription => '특정 이벤트 발생 시 이메일 및 푸시 알림이 전송되도록 설정하세요.';

  @override
  String get notifierNew => '새 알림';

  @override
  String get notifierDescription =>
      'Mealie는 Apprise 라이브러리를 사용하여 알림을 생성합니다. 알림에 사용할 서비스에 대한 다양한 옵션을 제공합니다. 서비스의 URL을 만드는 방법에 대한 종합적인 가이드는 해당 Wiki 문서를 참조하세요.  알림 유형에 따라 추가 기능이 포함될 수 있습니다.';

  @override
  String get notifierAppriseUrl => 'Apprise URL';

  @override
  String get notifierAppriseUrlSkipped => 'Apprise URL (비워두면 생략합니다)';

  @override
  String get notifierAppriseUrlBlankHint =>
      'Apprise URL에는 일반적으로 민감한 정보가 포함되므로, 편집 시 이 필드는 의도적으로 비워둡니다. URL을 수정하려면 여기에 새 주소를 입력하시고, 현재 URL을 유지하려면 비워두십시오.';

  @override
  String get notifierEnable => '알리미 활성화';

  @override
  String get notifierWhatEvents => '이 알리미는 어떤 이벤트를 구독해야 합니까?';

  @override
  String get notifierRecipeEvents => '레시피 이벤트';

  @override
  String get notifierUserEvents => '사용자 이벤트';

  @override
  String get notifierMealplanEvents => '식단 이벤트';

  @override
  String get notifierShoppingListEvents => '장보기 목록 이벤트';

  @override
  String get notifierCookbookEvents => '요리책 이벤트';

  @override
  String get notifierTagEvents => 'Tag 이벤트';

  @override
  String get notifierCategoryEvents => '카테고리 이벤트';

  @override
  String get notifierLabelEvents => '라벨 이벤트';

  @override
  String get notifierUserSignup => '새로운 사용자가 그룹에 가입하면';

  @override
  String get notifierCreate => '생성';

  @override
  String get notifierUpdate => '업데이트';

  @override
  String get notifierDelete => '삭제';

  @override
  String get notifierTestSent => '테스트 메시지가 전송됐습니다.';

  @override
  String get adminTitle => '관리자 설정';

  @override
  String get backupsTitle => '백업';

  @override
  String get backupsDescription =>
      '백업은 사이트의 데이터베이스와 데이터 디렉터리의 전체 스냅샷입니다. 여기에는 모든 데이터가 포함되며 데이터의 일부를 제외하도록 설정할 수 없습니다. 특정 시점의 Mealie 스냅샷이라고 생각하시면 됩니다. 이는 데이터베이스에 구애받지 않는 방식으로 데이터를 내보내고 가져오거나, 사이트를 외부 위치에 백업하는 역할을 합니다.';

  @override
  String get backupCreateHeading => '백업 생성하기';

  @override
  String get backupCreated => '백업이 성공적으로 완료되었습니다.';

  @override
  String get backupCreateFailed => '백업 생성 중 오류 발생. 로그 파일을 참조하십시오.';

  @override
  String get backupDelete => '백업 삭제';

  @override
  String get backupDeleted => '백업 삭제됨';

  @override
  String get backupRestore => '백업 복원';

  @override
  String get backupRestoreDescription =>
      '이 백업을 복원하면 데이터베이스와 데이터 디렉터리의 현재 데이터가 모두 백업 내용으로 덮어써져요. 복원에 성공하면 로그아웃돼요.';

  @override
  String get backupCannotBeUndone => '이 작업은 되돌릴 수 없습니다 - 주의해서 사용하십시오.';

  @override
  String get backupAcknowledge =>
      '이 작업은 되돌릴 수 없으며 파괴적일 수 있고 데이터 손실을 초래할 수 있음을 이해합니다.';

  @override
  String get backupRestoreSuccess => '복원 성공!';

  @override
  String get backupRestoreFailed => '복원이 실패했습니다. 자세한 내용은 서버 로그를 확인하십시오.';

  @override
  String get maintenanceTitle => '유지보수';

  @override
  String get maintenanceSummary => '요약';

  @override
  String get maintenanceStorage => '저장공간 정보';

  @override
  String get maintenanceDataDirSize => '데이터 디렉토리 크기';

  @override
  String get maintenanceCleanableDirs => '정리 가능한 디렉토리';

  @override
  String get maintenanceCleanableImages => '정리 가능한 이미지';

  @override
  String get maintenanceTempDir => '임시 디렉토리 (.temp)';

  @override
  String get maintenanceBackupsDir => '백업 디렉토리 (backups)';

  @override
  String get maintenanceGroupsDir => '그룹 디렉토리 (groups)';

  @override
  String get maintenanceRecipesDir => '레시피 디렉토리 (recipes)';

  @override
  String get maintenanceUserDir => '사용자 디렉토리 (user)';

  @override
  String get maintenanceCleanDirs => '디렉토리 정리';

  @override
  String get maintenanceCleanDirsDescription => '유효한 UUID가 아닌 모든 레시피 폴더를 제거합니다';

  @override
  String get maintenanceCleanTemp => '임시 파일 정리';

  @override
  String get maintenanceCleanTempDescription =>
      '.temp 디렉토리 내의 모든 파일과 폴더를 제거합니다';

  @override
  String get maintenanceCleanImages => '이미지 정리하기';

  @override
  String get maintenanceCleanImagesDescription => '.webp로 끝나지 않는 모든 이미지를 제거합니다';

  @override
  String get maintenanceActions => '동작';

  @override
  String get adminConfiguration => '설정';

  @override
  String get adminAppVersion => '앱 버전';

  @override
  String get adminUpToDate => 'Mealie가 최신 상태입니다';

  @override
  String adminVersionOutdated(String current, String latest) {
    return '현재 버전($current)이 최신 릴리스와 일치하지 않아요. 최신 버전($latest)으로 업데이트를 고려하세요.';
  }

  @override
  String get adminBaseUrl => '서버 측(server side) Base URL';

  @override
  String get adminBaseUrlOk => '서버 측 URL이 기본값과 일치하지 않습니다.';

  @override
  String get adminBaseUrlError =>
      '`BASE_URL`은 여전히 API 서버의 기본값입니다. 이로 인해 서버에서 생성된 이메일 등의 알림 링크에 문제가 발생할 수 있습니다.';

  @override
  String adminAuthReady(String provider) {
    return '$provider 준비됨';
  }

  @override
  String adminAuthNotReady(String provider) {
    return '$provider 준비 안 됨';
  }

  @override
  String adminAuthDisabled(String provider) {
    return '$provider 비활성화됨';
  }

  @override
  String adminAuthSuccessText(String provider) {
    return '필요한 $provider 변수가 모두 설정되어 있어요.';
  }

  @override
  String adminAuthErrorText(String provider) {
    return '$provider 값이 모두 설정되지는 않았어요. $provider 인증을 쓰지 않는다면 무시해도 돼요.';
  }

  @override
  String adminAuthDisabledText(String envVar) {
    return '사용하려면 $envVar을(를) true로 설정하세요.';
  }

  @override
  String get adminEmailStatus => '이메일 설정 상태';

  @override
  String get adminEmailConfigured => '이메일 설정됨';

  @override
  String get adminNotReady => '준비되지 않음 - 환경 변수 확인 필요';

  @override
  String get adminSucceeded => '성공함';

  @override
  String get adminFailed => '실패함';

  @override
  String get adminSiteStatistics => '사이트 통계';

  @override
  String get adminUncategorized => '카테고리 없는 레시피';

  @override
  String get adminUntagged => '태그 없는 레시피';

  @override
  String get adminGeneralAbout => '일반 정보';

  @override
  String get adminVersion => '버전';

  @override
  String get adminBuild => '빌드';

  @override
  String get adminApplicationMode => '애플리케이션 모드';

  @override
  String get adminProduction => '프로덕션';

  @override
  String get adminDevelopment => '개발';

  @override
  String get adminDemoStatus => '데모 상태';

  @override
  String get adminDemo => '데모';

  @override
  String get adminNotDemo => '데모 아님';

  @override
  String get adminApiPort => 'API 포트';

  @override
  String get adminApiDocs => 'API 문서';

  @override
  String get adminDatabaseType => '데이터베이스 유형';

  @override
  String get adminDatabaseUrl => '데이터베이스 URL';

  @override
  String get adminDefaultGroup => '기본 그룹';

  @override
  String get adminDefaultHousehold => '기본 가구';

  @override
  String get adminScraperVersion => '레시피 스크래퍼 버전';

  @override
  String get adminStatUsers => '사용자';

  @override
  String get adminStatHouseholds => '가구';

  @override
  String get adminStatGroups => '그룹';

  @override
  String get recipeDuplicate => '중복된 레시피';

  @override
  String get recipeDuplicateAction => '복제';

  @override
  String get recipeShareLink => '레시피 공유';

  @override
  String get recipeShareExpiration => '만료 날짜';

  @override
  String get recipeShareCopied => '레시피 링크가 클립보드에 복사되었습니다';

  @override
  String get enabledLabel => '활성화됨';

  @override
  String get disabledLabel => '비활성화됨';

  @override
  String get testAction => '테스트';

  @override
  String get yesLabel => '예';

  @override
  String get noLabel => '아니오';

  @override
  String get downloadAction => '다운로드';

  @override
  String get backupUpload => '업로드';

  @override
  String get zipImportButton => 'Zip 파일에서 가져오기';

  @override
  String get zipImportDescription => '다른 Mealie 인스턴스에서 내보낸 단일 레시피를 가져옵니다.';

  @override
  String get reportStatus => '상태';

  @override
  String get reportDate => '날짜';

  @override
  String get recipeActionTitleLabel => '제목';

  @override
  String get clearAll => '지우기';

  @override
  String get recipeDataSettingsExplanation =>
      '여기서 선택한 설정(잠긴 옵션 제외)은 선택한 모든 레시피에 적용됩니다.';

  @override
  String get adminAllowSignup => '가입 허용';

  @override
  String get adminAllowPasswordLogin => '비밀번호 로그인 허용';

  @override
  String get adminEmailInvalid => '올바른 이메일 주소를 입력하세요.';

  @override
  String adminEmailTestResult(String result) {
    return '이메일 테스트: $result';
  }

  @override
  String get adminSendTestEmail => '테스트 이메일 보내기';

  @override
  String get adminTestEmailAddress => '받는 사람';

  @override
  String get backupCreate => '백업 만들기';

  @override
  String backupDeleteConfirm(String name) {
    return '“$name” 백업을 삭제할까요?';
  }

  @override
  String get backupPostgresNote =>
      'PostgreSQL을 사용한다면 복원하기 전에 Mealie 문서의 백업/복원 절차를 읽어 보세요.';

  @override
  String get backupUploaded => '백업을 업로드했어요';

  @override
  String get backupsEmpty => '아직 백업이 없어요.';

  @override
  String get bulkImportAddRow => 'URL 추가';

  @override
  String get bulkImportStart => '가져오기 시작';

  @override
  String get chooseFileButton => '파일 선택';

  @override
  String get deselectAllAction => '모두 선택 해제';

  @override
  String get downloadFailed => '다운로드 실패';

  @override
  String get fileSaved => '파일을 저장했어요';

  @override
  String get loadFailed => '불러오지 못했어요';

  @override
  String get maintenanceActionsWarning =>
      '유지 관리 작업은 파괴적이므로 신중하게 사용해야 해요. 이 작업은 되돌릴 수 없어요.';

  @override
  String get maintenanceConfirm => '이 작업은 파괴적이며 되돌릴 수 없어요. 계속할까요?';

  @override
  String get maintenanceDone => '완료';

  @override
  String get maintenanceFailed => '유지 관리 작업 실패';

  @override
  String get maintenanceRun => '실행';

  @override
  String get migrationFailed => '마이그레이션 실패';

  @override
  String get migrationStart => '마이그레이션 시작';

  @override
  String get migrationStarted => '마이그레이션 완료 — 아래 보고서를 확인하세요.';

  @override
  String get moreImportOptions => '기타 가져오기 옵션';

  @override
  String notifierDeleteConfirm(String name) {
    return '“$name” 알림을 삭제할까요?';
  }

  @override
  String get notifierEdit => '알림 편집';

  @override
  String notifierEventCount(int count) {
    return '이벤트: $count';
  }

  @override
  String get notifierTestFailed => '테스트 메시지를 보내지 못했어요';

  @override
  String get notifiersEmpty => '아직 알림이 없어요.';

  @override
  String recipeActionDeleteConfirm(String name) {
    return '“$name” 레시피 작업을 삭제할까요?';
  }

  @override
  String get recipeActionFailed => '레시피 작업 실패';

  @override
  String get recipeActionSent => '레시피를 보냈어요';

  @override
  String get recipeActionUrlHint => '자리 표시자';

  @override
  String get recipeActionsDescription =>
      '레시피 작업은 모든 레시피의 메뉴에 표시돼요. “링크”는 URL을 열고, “Post”는 Mealie 서버가 레시피를 URL로 보내게 해요.';

  @override
  String get recipeActionsEmpty => '아직 레시피 작업이 없어요.';

  @override
  String recipeDataDeleteConfirm(int count) {
    return '선택한 레시피($count개)를 삭제할까요? 이 작업은 되돌릴 수 없어요.';
  }

  @override
  String recipeDataDeleteForbidden(int count) {
    return '선택한 레시피 중 $count개는 삭제할 수 없어요 (작성자나 관리자만 가능).';
  }

  @override
  String recipeDataDeleted(int count) {
    return '삭제한 레시피: $count';
  }

  @override
  String get recipeDataExportAction => '내보내기';

  @override
  String get recipeDataExportDone => '내보내기를 만들었어요 — 데이터 내보내기에서 다운로드하세요.';

  @override
  String recipeDataExportExpires(String date) {
    return '$date 만료';
  }

  @override
  String get recipeDataExportFailed => '내보내기 실패';

  @override
  String get recipeDataExportsEmpty => '사용할 수 있는 내보내기가 없어요.';

  @override
  String recipeDataUpdated(int count) {
    return '업데이트한 레시피: $count';
  }

  @override
  String get recipeDuplicated => '레시피를 복제했어요';

  @override
  String get recipeExportJson => 'JSON으로 내보내기';

  @override
  String get recipeExportZip => 'ZIP으로 내보내기 (이미지 포함)';

  @override
  String get recipeShareCreate => '링크 만들기';

  @override
  String get recipeShareDescription =>
      '링크가 있는 사람은 누구나 만료될 때까지 계정 없이 브라우저에서 이 레시피를 볼 수 있어요.';

  @override
  String get recipeShareEmpty => '아직 공유 링크가 없어요.';

  @override
  String recipeShareExpiresAt(String date) {
    return '$date 만료';
  }

  @override
  String get recipeWebToolsMenu => '복제, 공유 링크 등';

  @override
  String get reload => '새로고침';

  @override
  String get reportDeleteConfirm => '이 보고서를 삭제할까요?';

  @override
  String get reportEntries => '항목';

  @override
  String get reportFailedEntries => '실패함';

  @override
  String get reportOnlyFailed => '실패한 항목만 표시';

  @override
  String get reportStatusFailure => '실패';

  @override
  String get reportStatusInProgress => '진행 중';

  @override
  String get reportStatusPartial => '일부';

  @override
  String get reportStatusSuccess => '성공';

  @override
  String get reportsEmpty => '아직 보고서가 없어요.';

  @override
  String get uploadFailed => '업로드 실패';

  @override
  String webhookDeleteConfirm(String name) {
    return '“$name” 웹훅을 삭제할까요?';
  }

  @override
  String get webhookEdit => '웹훅 편집';

  @override
  String get webhookNew => '새 웹훅';

  @override
  String get webhookTestFailed => '테스트를 시작하지 못했어요';

  @override
  String get webhookTestSent => '테스트 웹훅을 실행했어요';

  @override
  String get webhookTime => '시간 (현지)';

  @override
  String get webhooksEmpty => '아직 웹훅이 없어요.';

  @override
  String get zipImportFailed => 'ZIP 가져오기 실패';

  @override
  String get aiProvidersTitle => 'AI 제공자';

  @override
  String get aiProvidersDescription =>
      'AI 제공자를 설정하면 향상된 재료 분석, 동영상에서 레시피 만들기 등 AI 기능을 사용할 수 있어요!';

  @override
  String get aiProviderSettingsTitle => 'AI 제공자 설정';

  @override
  String get aiProvidersList => '제공자';

  @override
  String get aiProviderCreate => '제공자 만들기';

  @override
  String get aiProviderEdit => '제공자 편집';

  @override
  String get aiDefaultProvider => '기본 제공자';

  @override
  String get aiDefaultProviderDescription => 'AI 기능을 사용하려면 필요해요';

  @override
  String get aiAudioProvider => '오디오 제공자';

  @override
  String get aiAudioProviderDescription => '동영상에서 레시피 만들기 같은 오디오 전사 기능을 사용해요';

  @override
  String get aiImageProvider => '이미지 제공자';

  @override
  String get aiImageProviderDescription => '이미지에서 레시피 만들기 같은 이미지 인식 기능을 사용해요';

  @override
  String get aiProviderName => '제공자 이름';

  @override
  String get aiApiKey => 'API 키';

  @override
  String get aiApiKeyCreateDescription =>
      '인증에 쓰는 제공자의 API 키예요. 서비스(예: Ollama)가 API 키를 쓰지 않아도 여기에 무언가를 입력해야 해요.';

  @override
  String get aiApiKeyEditDescription => '변경하지 않으려면 비워 두세요.';

  @override
  String get aiBaseUrl => '기본 URL';

  @override
  String get aiBaseUrlDescription =>
      'OpenAI를 사용한다면 비워 두세요. OpenAI 호환 엔드포인트여야 해요 (예: \"http://localhost:11434/v1\").';

  @override
  String get aiModel => '모델';

  @override
  String get aiModelDescription => 'AI 제공자가 사용할 모델 (예: \"gpt-5\").';

  @override
  String get aiTimeout => '요청 시간 제한 (초)';

  @override
  String get aiProviderCreated => '제공자를 만들었어요';

  @override
  String get aiProviderUpdated => '제공자를 업데이트했어요';

  @override
  String get aiProviderDeleted => '제공자를 삭제했어요';

  @override
  String get aiProviderCreateFailed => '제공자를 만들지 못했어요';

  @override
  String get aiProviderUpdateFailed => '제공자를 업데이트하지 못했어요';

  @override
  String get aiProviderDeleteFailed => '제공자를 삭제하지 못했어요';

  @override
  String get aiRequestHeaders => '요청 헤더';

  @override
  String get aiRequestParams => '요청 매개변수';

  @override
  String get aiNoDefaultWarning => '기본 제공자를 설정하지 않아 AI 기능이 꺼져 있어요';

  @override
  String get aiTestConnection => '연결 테스트';

  @override
  String get aiTestSucceeded => '연결 성공';

  @override
  String get aiTestFailed => '연결 실패';

  @override
  String get aiSupportsImages => '이미지 지원';

  @override
  String get aiTextOnly => '텍스트 전용, 이미지 제공자로 쓸 수 없어요';

  @override
  String get debugAiTitle => 'AI 제공자 디버그';

  @override
  String get debugAiDescription =>
      '이 페이지에서 AI 제공자를 디버그할 수 있어요. AI 연결을 테스트하고 결과를 확인하세요. 이미지 서비스가 켜져 있다면 이미지도 넣을 수 있어요.';

  @override
  String get debugParserTitle => '추출기';

  @override
  String get debugParserDescription =>
      'Mealie는 재료 분석 및 처리에 조건부 랜덤 필드(CRF)를 사용합니다. 재료에 적용되는 모델은 뉴욕 타임즈가 수집한 10만 개 이상의 재료 데이터셋을 기반으로 합니다. 해당 모델은 영어로만 훈련되었으므로 다른 언어로 사용할 경우 결과가 달라질 수 있습니다. 본 페이지는 모델 테스트를 위한 플레이그라운드입니다.';

  @override
  String get debugIngredientText => '재료 텍스트';

  @override
  String get debugTryExample => '예시 시도하기';

  @override
  String debugAverageConfidence(String value) {
    return '신뢰도 $value';
  }

  @override
  String get debugRunTest => '검사 실행';

  @override
  String get debugQuantity => '수량';

  @override
  String get debugUnit => '단위';

  @override
  String get debugFood => '식품';

  @override
  String get debugNote => '댓글';

  @override
  String get debugGroup => '그룹';

  @override
  String get aiProviderNone => '없음';

  @override
  String aiProviderDeleteConfirm(String name) {
    return '“$name” 제공자를 삭제할까요?';
  }

  @override
  String get aiProvidersEmpty => '아직 AI 제공자가 없어요.';

  @override
  String get aiAdvanced => '고급';

  @override
  String get aiKeyLabel => '이름';

  @override
  String get aiValueLabel => '값';

  @override
  String get debugTitle => '디버그';

  @override
  String get debugParse => '추출하기';

  @override
  String get debugParseFailed => '재료를 분석하지 못했어요';

  @override
  String get debugChooseImage => '이미지 선택';

  @override
  String get debugNoImage => '이미지 없음 (선택)';

  @override
  String get updateTitle => '업데이트 확인';

  @override
  String get updateInstalledVersion => '설치된 버전';

  @override
  String get updateLastCheck => '마지막 확인';

  @override
  String get updateCheckNow => '지금 확인';

  @override
  String get updateChecking => '업데이트 확인 중…';

  @override
  String get updateUpToDate => 'Mealie Recipes가 최신 버전이에요.';

  @override
  String updateAvailable(String version) {
    return '$version 버전을 사용할 수 있어요';
  }

  @override
  String get updateAvailableDescription =>
      'Mealie Recipes의 새 버전이 있어요. 직접 업데이트를 시작하기 전에는 아무것도 설치되지 않아요.';

  @override
  String get updateShow => '업데이트 보기';

  @override
  String get updateLater => '나중에';

  @override
  String updateDownloading(int percent) {
    return '다운로드 중 … $percent %';
  }

  @override
  String updateReady(String version) {
    return '$version 버전을 설치할 준비가 됐어요';
  }

  @override
  String get updateInstalling => '설치 중 — 앱이 자동으로 다시 시작돼요 …';

  @override
  String get updateManual =>
      '업데이트를 자동으로 설치하지 못했어요. 디스크 이미지를 열었으니 Mealie Recipes를 응용 프로그램으로 끌어다 놓으세요.';

  @override
  String get updateFailed => '업데이트 실패';

  @override
  String get updateInstallNow => '다운로드 및 설치';

  @override
  String get updateRestartNow => '설치 후 다시 시작';

  @override
  String get updateAutoTitle => '시작 시 업데이트 확인';

  @override
  String get updateAutoDescription => '확인하고 알려 주기만 해요 — 설치는 언제나 직접 시작해요.';

  @override
  String get updateBetaTitle => '베타 버전 받기';

  @override
  String get updateBetaDescription => '테스트용 사전 릴리스 버전도 제공해요. 아직 버그가 있을 수 있어요.';

  @override
  String get updateNoNotes => '릴리스 노트가 없어요.';

  @override
  String get updateSourceHint =>
      '업데이트는 Mealie Recipes의 GitHub 릴리스에서 받으며, 개발자가 서명한 경우에만 설치돼요 (macOS).';

  @override
  String get errorNoConnection => 'Mealie 서버에 연결할 수 없어요. 인터넷 연결과 서버 주소를 확인하세요.';

  @override
  String get errorTimeout => '서버 응답이 너무 오래 걸렸어요. 다시 시도해 주세요.';

  @override
  String get errorUnauthorized =>
      '로그인이 만료되었거나 API 토큰이 더 이상 유효하지 않아요. 설정에서 다시 로그인하세요.';

  @override
  String get errorServer => 'Mealie 서버에서 오류가 발생했어요. 나중에 다시 시도해 주세요.';

  @override
  String get errorNotFound => '서버에서 찾을 수 없어요 — 삭제되었을 수 있어요.';

  @override
  String get errorCertificate => '서버의 보안 인증서를 신뢰할 수 없어요.';

  @override
  String get errorGeneric => '문제가 발생했어요. 다시 시도해 주세요.';

  @override
  String get offlineLabel => '오프라인';

  @override
  String offlineSince(String time) {
    return '오프라인 · 마지막 동기화 $time';
  }

  @override
  String get mealplanEntryActions => '식사 옵션';

  @override
  String get mealplanMoveAction => '이동';

  @override
  String get mealplanMoveTitle => '식사 이동';

  @override
  String get mealplanMoveDate => '날짜';

  @override
  String mealplanMovedTo(String date) {
    return '$date(으)로 이동했어요';
  }

  @override
  String get mealplanShowWeek => '보기';

  @override
  String get mealplanMoveFailed => '식사를 이동하지 못했어요';

  @override
  String get recentlyViewedTitle => '최근 본 레시피';

  @override
  String get recentlyViewedEmpty => '연 레시피가 여기에 표시돼요.';

  @override
  String get recentlyViewedClear => '기록 지우기';

  @override
  String get recentlyViewedClearMessage =>
      '이 기기의 최근 본 레시피 목록이 지워져요. 레시피 자체는 그대로예요.';

  @override
  String get recentlyViewedClearConfirm => '지우기';

  @override
  String get duplicatesTitle => '중복 찾기';

  @override
  String get duplicatesScanning => '중복 레시피를 찾는 중…';

  @override
  String get duplicatesNone => '중복 레시피가 없어요.';

  @override
  String duplicatesFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '중복 가능성이 있는 항목 $count개를 찾았어요.',
    );
    return '$_temp0';
  }

  @override
  String get duplicatesIntro => '남길 레시피를 누른 다음 병합하세요.';

  @override
  String get duplicatesReasonSource => '같은 출처';

  @override
  String get duplicatesReasonName => '같은 이름';

  @override
  String duplicatesReasonSimilar(int percent) {
    return '비슷함 · 재료 $percent% 동일';
  }

  @override
  String get duplicatesKeeps => '남김';

  @override
  String get duplicatesWillBeDeleted => '삭제 예정';

  @override
  String get duplicatesMerge => '병합';

  @override
  String get duplicatesNotDuplicate => '중복 아님';

  @override
  String get duplicatesMergeTitle => '레시피를 병합할까요?';

  @override
  String duplicatesMergeMessage(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '다른 레시피 $count개가 삭제돼요',
    );
    return '“$name”이(가) 남아요. $_temp0.\n\n카테고리, 태그, 도구, 노트, 가구의 계획된 식사와 즐겨찾기가 옮겨져요. 삭제되는 레시피의 댓글, 타임라인, 첨부 파일은 사라져요.';
  }

  @override
  String get duplicatesMerged => '레시피를 병합했어요';

  @override
  String duplicatesIngredientCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '재료 $count개',
    );
    return '$_temp0';
  }

  @override
  String duplicatesResetIgnored(int count) {
    return '숨긴 쌍 다시 보기 ($count)';
  }

  @override
  String get duplicatesRescan => '다시 찾기';

  @override
  String get duplicatesOpenRecipe => '레시피 열기';

  @override
  String get duplicatesMergeNoEditHint =>
      '남는 레시피는 편집할 수 없어요 (잠긴 다른 사람의 레시피 또는 다른 가구의 레시피). 그래서 카테고리, 태그, 도구, 노트는 그대로이고, 계획된 식사와 즐겨찾기만 옮겨져요.';

  @override
  String get recipeOtherHouseholdHint => '다른 가구의 레시피 – 그곳에서 편집이 잠겨 있어요';

  @override
  String foodsSavedAsNote(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '새 식품 $count개',
    );
    return '저장했어요. $_temp0는 재료 노트로 남겼어요 – 식품을 만들려면 Mealie에서 “사용자가 식품, 태그 및 카테고리를 관리할 수 있음” 권한이 필요해요.';
  }

  @override
  String get a11yRemove => '삭제';

  @override
  String get a11yDecrease => '줄이기';

  @override
  String get a11yIncrease => '늘리기';

  @override
  String get a11yShowPassword => '비밀번호 보기';

  @override
  String get a11yHidePassword => '비밀번호 숨기기';

  @override
  String get a11yClearSearch => '검색 지우기';

  @override
  String get notesQueuedOffline => '오프라인 – 서버에 다시 연결되면 노트를 보내요.';

  @override
  String get timelineQueuedOffline => '오프라인 – 서버에 다시 연결되면 타임라인에 추가돼요.';

  @override
  String get syncSectionName => '이름 변경됨';

  @override
  String get pendingRecipesDiscard => '버리기';

  @override
  String get undo => '실행 취소';

  @override
  String timerStoppedSnack(String name) {
    return '“$name” 타이머를 멈췄어요';
  }

  @override
  String get cookFriendsEndConfirm => '모두의 세션을 종료할까요? 모든 게스트의 연결이 끊겨요.';

  @override
  String get weekStartSyncHint => 'Mealie에 저장돼요 – 웹 앱을 포함해 가구 전체에 적용돼요.';

  @override
  String get weekStartNoPermission =>
      '가구가 Mealie에서 설정해요. 가구를 관리할 수 있는 구성원만 바꿀 수 있어요.';

  @override
  String get assetsUnsupported329 =>
      'Mealie는 PDF, 이미지, 동영상(MP4, MOV, WebM), 오디오(MP3, M4A), Word/ODT/RTF, TXT, MD, CSV, JSON을 지원해요.';

  @override
  String get assetsRecordVideo => '동영상 촬영';

  @override
  String get assetsChooseVideo => '동영상 선택';

  @override
  String get shoppingSearchHint => '이 목록에서 검색';

  @override
  String get shoppingSearchNoMatches => '검색과 일치하는 항목이 없어요.';

  @override
  String get mealplanServingsTitle => '계획된 제공량';

  @override
  String get mealplanServingsHint =>
      '이 식단 항목에만 적용돼요 — 레시피 자체는 바뀌지 않아요. 레시피를 열거나 장보기 목록에 추가할 때 이 제공량을 사용해요.';

  @override
  String get calendarFeedTitle => '캘린더 구독';

  @override
  String get calendarFeedSubtitle => 'Google, Apple 또는 다른 캘린더에 식단 표시';

  @override
  String get calendarFeedDescription =>
      'Google 캘린더, Apple 캘린더, Home Assistant 또는 iCal 링크를 지원하는 다른 앱에서 가구의 식단을 구독하세요. 링크가 있는 사람은 누구나 식단을 볼 수 있어요.';

  @override
  String get calendarFeedOff => '가구의 캘린더 링크가 꺼져 있어요.';

  @override
  String get calendarFeedAskManager => '가구를 관리할 수 있는 사람에게 켜 달라고 요청하세요.';

  @override
  String get calendarFeedTurnOn => '켜기';

  @override
  String get calendarFeedTurnOff => '끄기';

  @override
  String get calendarFeedReset => '링크 재설정';

  @override
  String get calendarFeedResetHint => '링크를 재설정하거나 끄면 기존 구독이 더 이상 업데이트되지 않아요.';

  @override
  String get calendarFeedIncludeNotes => '노트 포함';

  @override
  String get calendarFeedTimesHint =>
      '식사를 눌러 시간을 설정하세요. 시간이 없는 식사는 종일 일정으로 표시돼요.';

  @override
  String get calendarFeedMealTypes => '식사 유형';

  @override
  String get calendarFeedSubscribe => '캘린더에서 구독';

  @override
  String get calendarFeedNoApp => '캘린더 앱을 열 수 없어요. 링크를 복사해 캘린더에 구독으로 추가하세요.';

  @override
  String get calendarFeedPublicHint =>
      '링크는 로그인 없이 작동해요 — 식단을 봐도 되는 사람과만 공유하세요.';

  @override
  String get recipeShareLinkMenu => '공유 링크 및 QR 코드';

  @override
  String get recipeShareShowQr => 'QR 코드 보기';

  @override
  String get recipeShareScanQr => '휴대폰 카메라로 스캔해 이 레시피를 여세요';

  @override
  String get recipeShareQrShare => '이미지 공유';

  @override
  String get recipeShareQrFailed => 'QR 코드 이미지를 만들지 못했어요';

  @override
  String get mealplanSettingsTitle => '식단 계획 설정';

  @override
  String get mealDiceRulesTitle => '주사위 규칙';

  @override
  String saveAsNewFood(String name) {
    return '“$name”을(를) 새 식품으로 저장';
  }

  @override
  String get shoppingMoreOptions => '옵션 더 보기';

  @override
  String get shoppingFewerOptions => '옵션 줄이기';

  @override
  String nameAlreadyExists(String name) {
    return '이미 있어요: $name';
  }

  @override
  String aliasBelongsTo(String alias, String name) {
    return '“$alias”은(는) 이미 “$name”에 속해 있어요 — 둘을 병합하는 게 좋아요.';
  }

  @override
  String get recipeMatchTitle => 'Recipe Match';

  @override
  String get recipeMatchShuffle => '섞기';

  @override
  String recipeMatchCardsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '덱에 레시피 $count개',
    );
    return '$_temp0';
  }

  @override
  String get recipeMatchNext => '다음';

  @override
  String get recipeMatchKeep => '트레이로';

  @override
  String get recipeMatchKept => '트레이에 담았어요';

  @override
  String get recipeMatchAnyTime => '시간 무관';

  @override
  String recipeMatchMaxTime(int minutes) {
    return '≤ $minutes분';
  }

  @override
  String get recipeMatchEmpty => '맞는 레시피가 없어요';

  @override
  String get recipeMatchEmptyHint => '필터를 바꾸거나 트레이를 비우세요.';

  @override
  String get recipeMatchResetFilters => '필터 초기화';

  @override
  String get recipeMatchFlipHint => '누르기: 재료 · 지침';

  @override
  String get recipeMatchFlipBack => '다시 뒤집기';

  @override
  String get recipeMatchOpenRecipe => '전체 레시피';

  @override
  String get recipeMatchOnHand => '보유 중';

  @override
  String get recipeMatchTray => '트레이';

  @override
  String get recipeMatchTrayEmpty => '아직 비어 있어요 – 카드를 아래로 끌어 보세요';

  @override
  String recipeMatchTrayCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '레시피 $count개',
    );
    return '$_temp0';
  }

  @override
  String get recipeMatchClear => '지우기';

  @override
  String get recipeMatchTrayHint => '비울 때까지 남아 있어요 – 덱을 닫아도요.';

  @override
  String get recipeMatchRemove => '트레이에서 빼기';

  @override
  String get recipeMatchToMealplan => '식단에 추가';

  @override
  String get recipeMatchToShopping => '재료를 장보기 목록에';

  @override
  String get recipeMatchSelectIngredients => '재료 선택';

  @override
  String get recipeMatchNoList => '먼저 장보기 목록을 선택하세요.';

  @override
  String get recipeMatchList => '목록';

  @override
  String get recipeMatchOnHandHint => '보유 중인 재료는 이미 선택 해제되어 있어요.';

  @override
  String recipeMatchAddCount(int selected, int total) {
    return '재료 $total개 중 $selected개 추가';
  }

  @override
  String get recipeMatchNoDay => '아직 날짜 없음 – 트레이에 남아요';

  @override
  String recipeMatchAddMeals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '식사 $count개 추가',
    );
    return '$_temp0';
  }

  @override
  String recipeMatchMealsAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '식사 $count개를 추가했어요',
    );
    return '$_temp0';
  }

  @override
  String get recipeMatchSwipeUp => '위로 밀어 트레이 열기';

  @override
  String get weekPlannerTitle => '한 주 계획하기';

  @override
  String get weekPlannerStepDays => '요일';

  @override
  String get weekPlannerStepPrefs => '개인 설정';

  @override
  String get weekPlannerStepPreview => '미리 보기';

  @override
  String get weekPlannerDaysTitle => '앱이 어떤 식사를 채울까요?';

  @override
  String get weekPlannerDaysHint => '칸을 누르세요. 이미 계획된 것은 그대로예요.';

  @override
  String get weekPlannerPresetWeekdays => '평일';

  @override
  String get weekPlannerPlanned => '계획됨';

  @override
  String get weekPlannerMoreMeals => '식사 더 보기';

  @override
  String get weekPlannerFewerMeals => '식사 줄이기';

  @override
  String weekPlannerMealCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '식사 $count개',
    );
    return '$_temp0';
  }

  @override
  String get weekPlannerPrefsTitle => '앱이 무엇을 고려할까요?';

  @override
  String get weekPlannerPrefsHint => '모두 선택 사항이에요 – 선택하지 않으면 레시피를 골고루 섞어 골라요.';

  @override
  String get weekPlannerQuick => '평일엔 빠르게';

  @override
  String weekPlannerQuickSub(int minutes) {
    return '월–금 최대 $minutes분';
  }

  @override
  String get weekPlannerStale => '오래 안 만든 것 먼저';

  @override
  String get weekPlannerStaleSub => '“마지막 요리”와 식단 기준';

  @override
  String get weekPlannerFavorites => '즐겨찾기 더 자주';

  @override
  String get weekPlannerFavoritesSub => '하트를 누른 레시피와 평점 높은 레시피';

  @override
  String get weekPlannerVariety => '다양하게';

  @override
  String get weekPlannerVarietySub => '같은 카테고리를 연달아 두 번 쓰지 않음';

  @override
  String get weekPlannerOnlyFrom => '다음에서만';

  @override
  String get weekPlannerDiceRules => '주사위 규칙 사용';

  @override
  String get weekPlannerDiceRulesSub => '식단 설정에서 식사별로 고른 항목';

  @override
  String weekPlannerMatching(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '맞는 레시피 $count개',
    );
    return '$_temp0';
  }

  @override
  String weekPlannerForMeals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '식사 $count개용',
    );
    return '$_temp0';
  }

  @override
  String get weekPlannerSuggest => '추천';

  @override
  String get weekPlannerPreviewHint =>
      '주사위는 바꾸고, 자물쇠는 고정해요. 요리를 길게 눌러 다른 요일로 끌면 서로 바뀌어요.';

  @override
  String get weekPlannerRerollAll => '모두 다시 굴리기';

  @override
  String get weekPlannerReroll => '다시 굴리기';

  @override
  String get weekPlannerLock => '고정';

  @override
  String get weekPlannerUnlock => '고정 해제';

  @override
  String get weekPlannerReasonNever => '만든 적 없음';

  @override
  String get weekPlannerReasonStale => '한동안 안 만듦';

  @override
  String get weekPlannerReasonFavorite => '즐겨찾기';

  @override
  String get weekPlannerNoMatch => '맞는 레시피 없음';

  @override
  String get weekPlannerThenShopping => '이어서 장보기 목록 재료 고르기';

  @override
  String get weekPlannerMostlyEmpty => '이번 주가 거의 비어 있어요';

  @override
  String weekPlannerMostlyEmptySub(int free, int total) {
    return '$total일 중 $free일이 비어 있어요 – 세 단계로 채워 보세요.';
  }

  @override
  String get previousWeek => '이전 주';

  @override
  String get nextWeek => '다음 주';

  @override
  String get weekPlannerAllDays => '모든 요일';

  @override
  String get weekPlannerWeekend => '주말';

  @override
  String get weekPlannerDinners => '저녁';

  @override
  String get weekPlannerLunches => '점심';

  @override
  String get weekPlannerAllMeals => '모든 식사';

  @override
  String get mealplanDayEmpty => '계획 없음';

  @override
  String get mealplanDropHere => '여기에 놓기';

  @override
  String mealplanDayKcal(String kcal) {
    return '1인분 $kcal kcal';
  }

  @override
  String mealplanDayKcalPartial(String kcal) {
    return '1인분 최소 $kcal kcal';
  }

  @override
  String get globalSearchHint => '레시피, 항목, 기능 검색 …';

  @override
  String get globalSearchIntro =>
      '레시피, 장보기 목록 항목, 식품, 요리책을 검색하세요 – 앱의 기능과 설정도 검색할 수 있어요 (예: “목록”).';

  @override
  String get globalSearchFunctions => '기능';

  @override
  String globalSearchNoResults(String query) {
    return '“$query”에 대한 결과가 없어요';
  }

  @override
  String get searchClear => '검색 지우기';

  @override
  String get recipeMatchPlanWeek => '이 레시피로 한 주 계획하기';

  @override
  String get weekPlannerReasonTray => '트레이에서';

  @override
  String get emptyBrowseRecipes => '레시피 둘러보기';

  @override
  String get mealplanWeekShopping => '이번 주 재료';

  @override
  String get globalSearchActions => '동작';

  @override
  String globalSearchAddToList(String text) {
    return '“$text”을(를) 장보기 목록에 추가';
  }

  @override
  String globalSearchAdded(String text) {
    return '“$text”을(를) 추가했어요';
  }

  @override
  String get globalSearchImportUrl => '이 주소에서 레시피 가져오기';

  @override
  String get homeContinueCooking => '요리 계속하기';

  @override
  String homeCookingStep(int step, int total) {
    return '$total단계 중 $step단계';
  }

  @override
  String get homeCookingPrep => '준비';

  @override
  String get homeCookingAlmostDone => '거의 완성';

  @override
  String get homeCookingContinue => '계속';

  @override
  String get paneSelectRecipe => '왼쪽에서 레시피를 고르세요.';

  @override
  String get mealplanDragRecipeHint => '레시피를 요일로 끌어 계획하세요.';

  @override
  String get desktopDropUnsupported => '이 파일은 첨부 파일로 추가할 수 없어요.';

  @override
  String desktopDropUploaded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '첨부 파일 $count개를 추가했어요',
    );
    return '$_temp0';
  }

  @override
  String get desktopDropAsAttachment => '놓으면 첨부 파일로 추가돼요';

  @override
  String get printAction => '인쇄';

  @override
  String get mealplanPrintWeek => '한 주 인쇄';

  @override
  String get mealplanEntryCooked => '요리함';

  @override
  String get recipeSearchClear => '검색 지우기';

  @override
  String get organizerShowRecipes => '레시피 보기';

  @override
  String globalSearchShowAllRecipes(int count) {
    return '레시피 $count개 모두 보기';
  }

  @override
  String get unnamedEntry => '(이름 없음)';

  @override
  String get mealplanWholeWeek => '한 주 전체';

  @override
  String get mealplanWholeWeekDropHint => '여기에 식사를 놓으면 한 주 전체로 계획돼요.';

  @override
  String get mealplanMovedToWholeWeek => '한 주 전체로 계획했어요';

  @override
  String get mealplanCookToday => '오늘 요리해요';

  @override
  String get mealplanPlanWholeWeek => '한 주 전체로 계획';

  @override
  String mealplanPlanWholeWeekRange(String from, String to) {
    return '$from – $to';
  }

  @override
  String get calendarFeedDuration => '길이 (분)';

  @override
  String get calendarFeedEventDetails => '일정 세부 정보';

  @override
  String calendarFeedEventDetailsHint(String fields) {
    return '캘린더에서 식사가 표시되는 방식을 바꾸세요. 병합 필드: $fields';
  }

  @override
  String get calendarFeedEventTitle => '일정 제목';

  @override
  String get calendarFeedEventDescription => '일정 설명';

  @override
  String get calendarFeedEventDetailsWarning =>
      '이 값을 바꾸면 캘린더 링크도 바뀌어요 — 이미 구독했다면 새 링크로 다시 구독하세요.';

  @override
  String get stepDurationMinutes => '소요 시간 (분)';

  @override
  String stepDurationSaved(String duration) {
    return '저장된 소요 시간: $duration. 편집하면 분 단위로 바뀌어요.';
  }

  @override
  String get sortTotalTimeShort => '총 시간 짧은 순';

  @override
  String get sortTotalTimeLong => '총 시간 긴 순';

  @override
  String recipeCreatedBy(String name) {
    return '작성자: $name';
  }

  @override
  String get timelineReplacePhoto => '사진 바꾸기';

  @override
  String get pasteRecipeTitle => '레시피 붙여넣기';

  @override
  String get pasteRecipeDescription =>
      '레시피를 JSON(schema.org) 또는 웹페이지의 HTML 소스로 붙여넣으세요.';

  @override
  String get pasteRecipeDescription330 =>
      'Mealie에서 내보낸 레시피(JSON)를 붙여넣으면 식품, 단위, 단계 연결까지 전체 구조로 가져와요. JSON(schema.org)과 웹페이지의 HTML 소스도 사용할 수 있어요.';

  @override
  String get pasteRecipeHint => '여기에 JSON 또는 HTML 붙여넣기';

  @override
  String get pasteRecipeButton => '레시피 붙여넣기';

  @override
  String get pasteRecipeImport => '가져오기';

  @override
  String get aiPromptsTitle => 'AI 프롬프트';

  @override
  String get aiPromptsTeaser => 'Mealie가 AI 제공자에게 주는 지시를 모든 작업 또는 작업별로 바꾸세요.';

  @override
  String get aiPromptsDescription =>
      'Mealie가 작업마다 AI 제공자에게 주는 지시를 바꾸세요. Mealie의 프롬프트는 영어로 쓰여 있지만 레시피의 언어는 바뀌지 않아요: 번역을 선택하지 않는 한 원본 언어를 유지해요. 직접 쓰는 지시는 어떤 언어로든 쓸 수 있어요.';

  @override
  String get aiPromptsGlobal => '모든 프롬프트에 대한 지시';

  @override
  String get aiPromptsGlobalDescription =>
      '레시피 만들기, 재료 분석, 번역 등 레시피 데이터를 만드는 모든 프롬프트에 추가돼요. 시스템 프롬프트에는 영향을 주지 않아요.';

  @override
  String get aiPromptsGlobalPlaceholder => '예: 항상 미터법 단위를 사용해.';

  @override
  String get aiPromptsList => '프롬프트';

  @override
  String get aiPromptSystem => '시스템';

  @override
  String get aiPromptSystemDescription =>
      '시스템 프롬프트예요. 레시피로 바꾸기 전에 원본 자료를 최대한 충실하게 옮겨 적기 때문에 모든 프롬프트에 대한 지시가 추가되지 않아요. 보통 바꿀 필요가 없고, 바꾸면 가져오기의 신뢰도가 떨어질 수 있어요.';

  @override
  String get aiPromptAppended => '추가됨';

  @override
  String get aiPromptOverridden => '대체됨';

  @override
  String get aiPromptModeDefault => '기본값';

  @override
  String get aiPromptModeAppend => '추가';

  @override
  String get aiPromptModeOverride => '대체';

  @override
  String get aiPromptAppendDescription =>
      '이 지시는 Mealie의 프롬프트에 추가되며, 둘이 충돌하면 우선 적용돼요.';

  @override
  String get aiPromptOverrideDescription =>
      '내 프롬프트가 Mealie의 프롬프트를 완전히 대체하므로 이후 Mealie 프롬프트 업데이트가 적용되지 않아요. 단위 목록처럼 작업에 필요한 데이터는 여전히 내 프롬프트 뒤에 추가돼요.';

  @override
  String get aiPromptDefaultChanged =>
      '대체한 이후 Mealie의 프롬프트가 바뀌었어요. 내 프롬프트와 비교하거나 기본값으로 돌아가 새 버전을 사용하세요.';

  @override
  String get aiPromptViewDefault => '기본 프롬프트 보기';

  @override
  String get aiPromptHideDefault => '기본 프롬프트 숨기기';

  @override
  String get aiPromptSaved => '프롬프트를 저장했어요';

  @override
  String get aiPromptSaveFailed => '프롬프트를 저장하지 못했어요';

  @override
  String get aiPromptTitleBuildRecipe => '레시피 만들기';

  @override
  String get aiPromptTitleParseIngredients => '재료 분석';

  @override
  String get aiPromptTitleRecipeVideo => '동영상에서 레시피';

  @override
  String get aiPromptTitleOrganizers => '정리 항목 지정';

  @override
  String get aiPromptTitleTranslate => '레시피 번역';

  @override
  String get aiPromptTitleCompileSource => '원본 자료 읽기';

  @override
  String get aiPromptTitleTranscribe => '오디오 전사';

  @override
  String get aiPromptDescBuildRecipe =>
      '웹페이지, 사진, 텍스트에서 읽은 원본 자료를 구조화된 레시피로 바꿔요.';

  @override
  String get aiPromptDescParseIngredients =>
      'AI 재료 분석기가 각 재료를 수량, 단위, 식품, 노트로 나눌 때 사용해요.';

  @override
  String get aiPromptDescRecipeVideo => '동영상의 전사본과 캡션을 레시피로 바꿔요.';

  @override
  String get aiPromptDescOrganizers => '가져온 레시피의 태그, 카테고리, 도구를 골라요.';

  @override
  String get aiPromptDescTranslate => '가져온 레시피를 선택한 언어로 번역해요.';

  @override
  String get aiPromptDescCompileSource =>
      '웹페이지, 사진, 텍스트를 읽어 레시피의 일반 텍스트 기록으로 만들어요.';

  @override
  String get aiPromptDescTranscribe => '오디오 제공자가 직접 전사할 수 없을 때 오디오를 전사해요.';

  @override
  String get mealplanNoteHint => '노트 (선택)';

  @override
  String get mealplanEditTitle => '항목 편집';

  @override
  String get mealplanEntryTitleLabel => '제목';

  @override
  String get mealplanEntryNoteLabel => '노트';

  @override
  String mealplanCreateRecipe(String name) {
    return '새 레시피 “$name”';
  }

  @override
  String get mealplanCreateRecipeSubtitle => '빈 레시피를 만들고 계획한 뒤 편집기를 열어요';

  @override
  String get importOptionsTitle => '가져오기 옵션';

  @override
  String get importOptionsHint =>
      '가져올 때 Mealie의 AI가 서버에서 얼마나 작업할지 정해요. 추가 단계마다 별도의 AI 요청이에요 – 적을수록 빨라요.';

  @override
  String get importTranslateTitle => '레시피 번역';

  @override
  String get importOrganizersTitle => '카테고리 및 태그';

  @override
  String get importOrganizersCreate => '새로 추가';

  @override
  String get importOrganizersExisting => '기존 항목만';

  @override
  String get importOrganizersNone => '없음';

  @override
  String get importOrganizersCreateHint => 'AI가 태그, 카테고리, 도구를 지정하고 없는 것은 만들어요.';

  @override
  String get importOrganizersExistingHint => 'AI가 이미 있는 태그, 카테고리, 도구만 사용해요.';

  @override
  String get importOrganizersNoneHint =>
      '태그, 카테고리, 도구 없이 가져와요. Mealie는 이 단계를 그래도 실행하므로 가져오기가 빨라지지 않아요.';

  @override
  String get importStarting => '서버로 보내는 중…';

  @override
  String get importRunning => '레시피 가져오는 중…';

  @override
  String get aiImagesRunning => 'AI가 페이지를 읽고 있어요…';

  @override
  String get importStreamPhotosTitle => '실시간 진행 상황이 보이는 사진 가져오기';

  @override
  String get importStreamPhotosHint =>
      '각 단계를 보여 주고 긴 가져오기 동안 연결을 유지해요. 프록시가 스트리밍을 막는 경우 등에는 꺼서 예전처럼 한 번의 요청으로 업로드하세요.';

  @override
  String get weekPlannerDiceRulesMealieSub => '가구의 Mealie 규칙 (식단 설정)';

  @override
  String get syncStarted => '서버에서 레시피, 이미지, 목록을 다시 불러오는 중…';

  @override
  String get syncDone => '모두 최신 상태예요';

  @override
  String get recipeReloaded => '레시피를 다시 불러왔어요';

  @override
  String get logoutTitle => '로그아웃 / 사용자 전환';

  @override
  String get logoutConfirm =>
      '레시피, 목록, 아직 동기화되지 않은 변경 사항이 이 기기에서 삭제돼요. 앱 설정과 서버 주소는 남으므로 다시 로그인하기만 하면 돼요.';

  @override
  String get reloadRecipe => '서버에서 다시 불러오기';

  @override
  String get wifiServerTitle => 'Wi-Fi에서 다른 주소';

  @override
  String get wifiServerHint =>
      '같은 서버를 두 번째 주소로 쓸 때 사용해요. 예: 집에서는 로컬 IP, 밖에서는 ZeroTier, Tailscale 또는 도메인. 아래 Wi-Fi에서는 이 주소를 자동으로 쓰고, 그 외에는 위의 서버 URL을 써요.';

  @override
  String get wifiSsidLabel => 'Wi-Fi 이름';

  @override
  String get wifiServerUrl => '이 Wi-Fi에서의 주소';

  @override
  String get wifiUseCurrent => '현재 Wi-Fi 사용';

  @override
  String get wifiNameUnavailable =>
      'Wi-Fi 이름을 읽지 못했어요. Wi-Fi에 연결하고 위치 접근을 허용하세요 – Android와 iOS는 그래야 Wi-Fi 이름을 알려 줘요.';

  @override
  String wifiServerActive(String ssid) {
    return '사용 중: Wi-Fi “$ssid”의 주소';
  }

  @override
  String wifiServerStandardActive(String ssid) {
    return '사용 중: 서버 URL (“$ssid” 아님)';
  }

  @override
  String get wifiServerRemove => '삭제';

  @override
  String get switchUserTitle => '사용자 전환';

  @override
  String switchUserBody(String name) {
    return '$name님은 이 기기에 계속 저장돼요 – 모든 레시피, 목록, 아직 동기화되지 않은 변경 사항과 함께요. 프로필 사진이나 로그인 화면에서 다시 전환할 수 있어요.';
  }

  @override
  String get allowBiometricTitle => '기기 잠금 해제로 다시 전환';

  @override
  String get allowBiometricHint =>
      '비밀번호 대신 Face ID, 지문 또는 기기 PIN을 사용해요. 이 기기의 잠금을 해제할 수 있는 사람은 누구나 이 계정을 열 수 있게 돼요.';

  @override
  String get allow => '허용';

  @override
  String unlockAccountReason(String name) {
    return '$name님으로 전환';
  }

  @override
  String signInAs(String name) {
    return '$name님으로 로그인';
  }

  @override
  String wrongAccountError(String name) {
    return '“$name” 계정이에요. 저장된 계정으로 로그인하세요.';
  }

  @override
  String get accountSaveOffline => '지금은 계정을 저장할 수 없어요 – 서버에 연결할 수 없어요.';

  @override
  String get signOutRemoveTitle => '로그아웃 후 삭제';

  @override
  String get signOutRemoveConfirm =>
      '이 계정과 이 기기에 있는 모든 데이터(레시피, 목록, 동기화되지 않은 변경 사항)가 삭제돼요. 앱 설정은 남아요.';

  @override
  String get removeSavedAccount => '이 기기에서 삭제';

  @override
  String removeSavedAccountConfirm(String name) {
    return '“$name”과(와) 저장된 모든 데이터를 이 기기에서 삭제할까요? 동기화되지 않은 변경 사항은 사라져요.';
  }

  @override
  String get savedAccountsTitle => '저장된 계정';

  @override
  String get addAccount => '다른 계정 추가';

  @override
  String get biometricOff => '기기 잠금 해제 사용 중지';

  @override
  String get orNewAccount => '또는 다른 계정으로 로그인:';

  @override
  String get importVideoTitle => '동영상 링크';

  @override
  String get importVideoFast => '빠르게';

  @override
  String get importVideoThorough => '꼼꼼하게 (AI)';

  @override
  String get importVideoFastHint =>
      'Mealie가 동영상을 전사하고 AI 요청 한 번으로 레시피를 만들어요 – 보통 훨씬 빨라요. 번역과 카테고리/태그는 없어요. 가져올 때마다 AI를 켤 수도 있어요.';

  @override
  String get importVideoThoroughHint =>
      '동영상 링크에서는 AI 스위치가 자동으로 켜져요: 여러 AI 단계로, 위에서 설정한 대로 번역과 카테고리/태그를 처리해요. 시간이 더 걸려요.';

  @override
  String get importPresetFast => '빠르게';

  @override
  String get importPresetThorough => '꼼꼼하게';

  @override
  String get importPresetCustom => '사용자 지정';

  @override
  String get importPresetFastTitle => 'AI 단계를 최대한 적게 – 가장 짧은 대기';

  @override
  String get importPresetFastVideo =>
      '동영상 링크: Mealie가 동영상을 전사하고 AI 요청 한 번으로 레시피를 만들어요 (AI 스위치는 꺼진 채로).';

  @override
  String get importPresetFastTranslate => '번역 없음 – 레시피가 원래 언어로 남아요.';

  @override
  String get importPresetFastOrganizers => '기존 카테고리와 태그만 지정하고 새로 만들지 않아요.';

  @override
  String get importPresetThoroughTitle =>
      'Mealie의 전체 AI 가져오기 – 오래 걸리지만 가장 충실해요';

  @override
  String get importPresetThoroughVideo =>
      '동영상 링크는 자동으로 AI로 가져와요 – 여러 단계로 (원본 수집, 레시피 만들기 등).';

  @override
  String get importPresetThoroughTranslate =>
      '레시피가 다른 언어로 쓰여 있으면 아래 가져오기 언어로 번역해요.';

  @override
  String get importPresetThoroughOrganizers =>
      '알맞은 카테고리와 태그를 지정하고, 없는 것은 만들어요.';

  @override
  String get importPresetCustomTitle => '각 옵션을 직접 설정';

  @override
  String get importPresetCustomBody =>
      '이전 선택이 하던 것에서 시작해 필요한 것만 바꾸세요 – 예: 동영상은 빠르게 가져오되 번역은 포함.';

  @override
  String get sidebarPinHint => '팁: 타일을 길게 눌러 사이드바로 끌면 고정돼요.';

  @override
  String get sidebarDropHere => '여기에 놓기';

  @override
  String sidebarShortcutTitle(String name) {
    return '“$name” 단축키';
  }

  @override
  String sidebarShortcutPrompt(String modifier) {
    return '$modifier을(를) 포함해 원하는 키 조합을 누르세요.';
  }

  @override
  String get sidebarShortcutTaken => '이 조합은 이미 사용 중이에요.';

  @override
  String get sidebarShortcutNone => '단축키 없음';

  @override
  String get sidebarShortcutChange => '단축키 변경';

  @override
  String get sidebarUnpin => '사이드바에서 제거';

  @override
  String sidebarFull(int count) {
    return '사이드바가 가득 찼어요 – 직접 추가한 항목은 최대 $count개예요.';
  }

  @override
  String get tabletSidebar => '가로 모드에서 사이드바';

  @override
  String get tabletSidebarSubtitle => '태블릿을 가로로 들면 탐색 메뉴를 아래 대신 왼쪽에 표시해요';

  @override
  String get filterDateCreated => '작성 날짜';

  @override
  String get filterDateUpdated => '업데이트 일자';

  @override
  String get errorUploadTooLarge =>
      '이 Mealie 서버에 비해 파일이 너무 커요. 서버의 업로드 한도는 MAX_UPLOAD_SIZE_MB로 늘릴 수 있어요.';

  @override
  String get recipeDownloadPdfMealie => 'PDF 다운로드 (Mealie 레이아웃)';

  @override
  String get mealplanNoteMore => '더 보기…';

  @override
  String get mealplanNoteLess => '간단히 보기';

  @override
  String get ingredientCommonlySubstitutedWith => '흔히 쓰는 대체 재료';

  @override
  String requiresMealieVersion(String version) {
    return 'Mealie $version 이상이 필요해요.';
  }

  @override
  String get apiTokensTitle => 'API 토큰';

  @override
  String get apiTokensDescription => '외부 애플리케이션에서 액세스하기 위한 API 토큰을 관리하세요.';

  @override
  String get apiTokenNameLabel => '토큰 이름';

  @override
  String get apiTokenGenerate => '생성';

  @override
  String get apiTokensActive => '활성화된 토큰들';

  @override
  String get apiTokenCopyWarning =>
      '이 토큰을 복사하여 외부 애플리케이션에서 사용하십시오. 이 토큰은 다시 볼 수 없습니다.';

  @override
  String get apiTokenThisApp => '이 앱에서 사용 중';

  @override
  String get apiTokenThisAppHint => '이 토큰은 앱의 로그인을 유지하며 여기서 삭제할 수 없어요.';

  @override
  String apiTokenDeleteConfirm(String name) {
    return '“$name” 토큰을 삭제할까요? 이 토큰을 쓰는 앱은 즉시 접근 권한을 잃어요.';
  }

  @override
  String get apiTokensEmpty => '아직 토큰이 없어요.';

  @override
  String apiTokenCreatedOn(String date) {
    return '$date에 생성됨';
  }

  @override
  String get apiTokenCopied => '토큰을 복사했어요';

  @override
  String get qfOpHasNoValue => '값이 없음';

  @override
  String get qfOpHasValue => '값이 있음';

  @override
  String get ratingHouseholdAverage => '가구 평균';

  @override
  String get stepLinkedNotes => '연결된 노트';

  @override
  String get noteFallbackTitle => '노트';

  @override
  String get aiPromptTitleEnrichInstructions => '단계 세부 정보 추가';

  @override
  String get aiPromptDescEnrichInstructions =>
      '가져온 레시피의 각 단계를 사용하는 재료와 노트에 연결하고, 소요 시간과 제목을 뽑아내요.';

  @override
  String get loginAccountLocked => '계정이 잠겼습니다. 나중에 다시 시도해 주세요.';

  @override
  String get loginPasswordDisabled =>
      '이 서버에서는 비밀번호 로그인이 꺼져 있어요. 대신 API 토큰을 사용하세요.';

  @override
  String get unitSystemTitle => '단위';

  @override
  String get unitSystemAsWritten => '원래대로';

  @override
  String get unitSystemMetric => '미터법';

  @override
  String get unitSystemMetricHint => '미터법 (g, ml)';

  @override
  String get unitSystemImperial => '야드파운드법';

  @override
  String get unitSystemImperialHint => '야드파운드법 (컵, oz)';

  @override
  String get unitSystemHint =>
      '표시만 바뀌어요 – 레시피 자체는 그대로예요. Mealie 웹 앱처럼 이 기기의 모든 레시피에 적용돼요.';

  @override
  String get unitSystemUnavailable =>
      '이 레시피의 단위는 모두 변환할 수 없어요. 변환하려면 Mealie에서 단위에 표준화가 있어야 해요 (식품 및 단위 → 단위 → 표준화).';
}
