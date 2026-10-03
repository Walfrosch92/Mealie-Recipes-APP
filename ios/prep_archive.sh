#!/bin/sh
# ---------------------------------------------------------------------------
# Vorbereitung für ein iOS-Release-Archive.
#
# Schaltet den Xcode-16-Module-Verifier auf ALLEN Pod-Configs ab — sonst
# scheitert das Archive an Plugins mit quoted `Flutter/Flutter.h`
# (flutter_local_notifications, device_info_plus, sqflite_darwin …) mit
# "could not build module".
#
# WICHTIG: Danach in Xcode  Product ▸ Archive  (Schema „Runner") bauen.
# NICHT `flutter build ipa` benutzen — das re-triggert `pod install` und
# aktiviert den Verifier wieder (nur ~33 von 159 Configs bleiben NO).
# Ein DIREKTES `pod install` (hier) lässt den Podfile-at_exit-Hook voll
# laufen → alle 159 Configs NO.
# ---------------------------------------------------------------------------
set -e
cd "$(dirname "$0")"

echo "▶︎ pod install (Module-Verifier-Hook läuft via Podfile at_exit)…"
pod install

echo "▶︎ stale Archive-DerivedData leeren (gecachtes VerifyModule)…"
rm -rf ~/Library/Developer/Xcode/DerivedData/Runner-*/Build/Intermediates.noindex/ArchiveIntermediates 2>/dev/null || true

# Sicherheitsnetz, falls der Hook mal nicht voll greift:
if grep -q "ENABLE_MODULE_VERIFIER = YES" Pods/Pods.xcodeproj/project.pbxproj 2>/dev/null; then
  echo "▶︎ Rest-YES gefunden → disable_module_verifier.rb…"
  ruby disable_module_verifier.rb
fi

remaining=$(grep -c "ENABLE_MODULE_VERIFIER = YES" Pods/Pods.xcodeproj/project.pbxproj 2>/dev/null || echo 0)
echo "✅ Module-Verifier aus (verbleibende YES: $remaining)."
echo "   Jetzt in Xcode: Product ▸ Archive  (Schema 'Runner')."
