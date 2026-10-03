// ---------------------------------------------------------------------------
// Sprachen für den KI-Rezeptimport (Mealie `translateLanguage`).
//
// Bewusst VIEL breiter als die 8 App-Sprachen: der Import läuft serverseitig
// über ein Sprachmodell und kann in jede gängige Sprache übersetzen. Nutzer,
// deren Muttersprache es (noch) nicht in die App-Oberfläche geschafft hat,
// bekommen so wenigstens ihre Rezepte in der eigenen Sprache.
//
// Die Namen stehen bewusst in der jeweiligen Landessprache und werden NICHT
// übersetzt — genauso wie die App-Sprachnamen im Sprachpicker.
// ---------------------------------------------------------------------------

class ImportLanguage {
  /// ISO-639-1-Code (ggf. mit Region), geht als `translateLanguage` an Mealie.
  final String code;

  /// Eigenbezeichnung der Sprache — nicht lokalisiert.
  final String name;

  final String flag;

  const ImportLanguage(this.code, this.name, this.flag);
}

/// Alphabetisch nach Code, damit die Liste stabil und vorhersehbar bleibt.
const List<ImportLanguage> kImportLanguages = [
  ImportLanguage('ar', 'العربية', '🇸🇦'),
  ImportLanguage('bg', 'Български', '🇧🇬'),
  ImportLanguage('cs', 'Čeština', '🇨🇿'),
  ImportLanguage('da', 'Dansk', '🇩🇰'),
  ImportLanguage('de', 'Deutsch', '🇩🇪'),
  ImportLanguage('el', 'Ελληνικά', '🇬🇷'),
  ImportLanguage('en', 'English', '🇬🇧'),
  ImportLanguage('es', 'Español', '🇪🇸'),
  ImportLanguage('et', 'Eesti', '🇪🇪'),
  ImportLanguage('fi', 'Suomi', '🇫🇮'),
  ImportLanguage('fr', 'Français', '🇫🇷'),
  ImportLanguage('he', 'עברית', '🇮🇱'),
  ImportLanguage('hi', 'हिन्दी', '🇮🇳'),
  ImportLanguage('hr', 'Hrvatski', '🇭🇷'),
  ImportLanguage('hu', 'Magyar', '🇭🇺'),
  ImportLanguage('id', 'Bahasa Indonesia', '🇮🇩'),
  ImportLanguage('it', 'Italiano', '🇮🇹'),
  ImportLanguage('ja', '日本語', '🇯🇵'),
  ImportLanguage('ko', '한국어', '🇰🇷'),
  ImportLanguage('lt', 'Lietuvių', '🇱🇹'),
  ImportLanguage('lv', 'Latviešu', '🇱🇻'),
  ImportLanguage('nl', 'Nederlands', '🇳🇱'),
  ImportLanguage('nb', 'Norsk (bokmål)', '🇳🇴'),
  ImportLanguage('pl', 'Polski', '🇵🇱'),
  ImportLanguage('pt', 'Português', '🇵🇹'),
  ImportLanguage('pt-BR', 'Português (Brasil)', '🇧🇷'),
  ImportLanguage('ro', 'Română', '🇷🇴'),
  ImportLanguage('ru', 'Русский', '🇷🇺'),
  ImportLanguage('sk', 'Slovenčina', '🇸🇰'),
  ImportLanguage('sl', 'Slovenščina', '🇸🇮'),
  ImportLanguage('sr', 'Српски', '🇷🇸'),
  ImportLanguage('sv', 'Svenska', '🇸🇪'),
  ImportLanguage('th', 'ไทย', '🇹🇭'),
  ImportLanguage('tr', 'Türkçe', '🇹🇷'),
  ImportLanguage('uk', 'Українська', '🇺🇦'),
  ImportLanguage('vi', 'Tiếng Việt', '🇻🇳'),
  ImportLanguage('zh', '中文', '🇨🇳'),
];

/// Eintrag zu einem Code — `null`, wenn der Code (etwa aus einer älteren
/// Version oder einer künftigen App-Sprache) nicht in der Liste steht.
ImportLanguage? importLanguageFor(String code) {
  for (final lang in kImportLanguages) {
    if (lang.code == code) return lang;
  }
  return null;
}
