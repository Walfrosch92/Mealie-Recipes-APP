import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;

// ---------------------------------------------------------------------------
// Lizenztexte der mitgelieferten Schriften und des Alarmtons.
//
// Die SIL Open Font License verlangt, dass ihr Text mit der Schrift
// weitergegeben wird — auch in der fertigen App. Flutter sammelt die Lizenzen
// aller Pakete selbst; hier kommen die Dateien dazu, die direkt in `assets/`
// liegen. Sichtbar unter Einstellungen → „Lizenzen anzeigen".
// ---------------------------------------------------------------------------

void registerBundledLicenses() {
  LicenseRegistry.addLicense(() async* {
    for (final (name, asset) in const [
      ('Inter (font)', 'assets/fonts/OFL-Inter.txt'),
      ('Plus Jakarta Sans (font)', 'assets/fonts/OFL-PlusJakartaSans.txt'),
    ]) {
      try {
        yield LicenseEntryWithLineBreaks(
            [name], await rootBundle.loadString(asset));
      } catch (_) {/* Lizenzseite ist nie kritisch */}
    }
    yield const LicenseEntryWithLineBreaks(
      ['Alarm sound'],
      '"Alarm clock ringing" by FascinatedSound.\n\n'
      'Included as part of the app only; the license of the source the '
      'file was obtained from applies.',
    );
  });
}
