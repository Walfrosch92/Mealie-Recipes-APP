// ---------------------------------------------------------------------------
// App-Sprachen — EINE Liste für Einstellungen, Einrichtung und den
// Lebensmittel-Seeder (vorher drei getrennte Kopien). Code = arb-Suffix
// (`app_<code>.arb`), Name in der Sprache selbst (bewusst nicht übersetzt),
// Flagge für die Auswahl. Mealie-Code siehe mealie_locale.dart.
// ---------------------------------------------------------------------------

typedef AppLanguage = ({String code, String name, String flag});

const List<AppLanguage> kAppLanguages = [
  (code: 'de', name: 'Deutsch', flag: '🇩🇪'),
  (code: 'en', name: 'English', flag: '🇬🇧'),
  (code: 'fr', name: 'Français', flag: '🇫🇷'),
  (code: 'fr_CA', name: 'Français (Canada)', flag: '🇨🇦'),
  (code: 'es', name: 'Español', flag: '🇪🇸'),
  (code: 'it', name: 'Italiano', flag: '🇮🇹'),
  (code: 'nl', name: 'Nederlands', flag: '🇳🇱'),
  (code: 'nb', name: 'Norsk (bokmål)', flag: '🇳🇴'),
  (code: 'da', name: 'Dansk', flag: '🇩🇰'),
  (code: 'sv', name: 'Svenska', flag: '🇸🇪'),
  (code: 'fi', name: 'Suomi', flag: '🇫🇮'),
  (code: 'pl', name: 'Polski', flag: '🇵🇱'),
  (code: 'cs', name: 'Čeština', flag: '🇨🇿'),
  (code: 'hu', name: 'Magyar', flag: '🇭🇺'),
  (code: 'sl', name: 'Slovenščina', flag: '🇸🇮'),
  (code: 'pt', name: 'Português (Brasil)', flag: '🇧🇷'),
  (code: 'tr', name: 'Türkçe', flag: '🇹🇷'),
  (code: 'ru', name: 'Русский', flag: '🇷🇺'),
  (code: 'uk', name: 'Українська', flag: '🇺🇦'),
  (code: 'ja', name: '日本語', flag: '🇯🇵'),
  (code: 'ko', name: '한국어', flag: '🇰🇷'),
  (code: 'zh', name: '简体中文', flag: '🇨🇳'),
  (code: 'zh_TW', name: '繁體中文', flag: '🇹🇼'),
];

List<String> get kAppLanguageCodes => [for (final l in kAppLanguages) l.code];

String appLanguageName(String code) =>
    kAppLanguages.where((l) => l.code == code).firstOrNull?.name ?? code;

String appLanguageFlag(String code) =>
    kAppLanguages.where((l) => l.code == code).firstOrNull?.flag ?? '🌍';
