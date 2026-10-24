#!/bin/bash
# ---------------------------------------------------------------------------
# Baut Mealie Recipes für macOS (Apple Silicon / arm64) und packt es als
# installierbares DMG:  App  +  Verknüpfung „Programme"  +  Deinstaller.
#
#   ./macos/packaging/build_dmg.sh            # aus dem Projektordner
#
# Optional (Weitergabe an andere Macs ohne Gatekeeper-Warnung):
#   MAC_SIGN_IDENTITY="Developer ID Application: Name (TEAMID)"
#       → signiert App, Deinstaller und DMG mit Hardened Runtime
#   MAC_NOTARY_PROFILE="profilname"
#       → zusätzlich notarisieren (vorher einmalig:
#         xcrun notarytool store-credentials profilname …)
#
# Ohne Identität wird ad-hoc signiert: läuft auf dem eigenen Mac sofort, auf
# anderen Macs muss man beim ersten Start unter Systemeinstellungen →
# Datenschutz & Sicherheit „Dennoch öffnen" wählen.
# ---------------------------------------------------------------------------
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT"

APP_NAME="Mealie Recipes"
UNINSTALLER_NAME="Uninstall Mealie Recipes"
VERSION="$(grep -E '^version:' pubspec.yaml | sed -E 's/version:[[:space:]]*([^+]+).*/\1/')"
OUT_DIR="$ROOT/build/macos/dmg"
STAGING="$OUT_DIR/staging"
DMG="$OUT_DIR/MealieRecipes-$VERSION-arm64.dmg"
APP="$ROOT/build/macos/Build/Products/Release/$APP_NAME.app"
ENTITLEMENTS="$ROOT/macos/Runner/Release.entitlements"
SIGN_ID="${MAC_SIGN_IDENTITY:-}"

echo "▸ Flutter-Release-Build (macOS, arm64) …"
flutter build macos --release

[ -d "$APP" ] || { echo "✗ App nicht gefunden: $APP" >&2; exit 1; }

rm -rf "$OUT_DIR"
mkdir -p "$STAGING"
# Nur Apple Silicon: Flutter baut universal (arm64 + x86_64), ditto kopiert
# ausschließlich die arm64-Teile aller Binaries/Frameworks. Dadurch wird
# die Signatur ungültig → unten wird in jedem Fall neu signiert.
ditto --arch arm64 "$APP" "$STAGING/$APP_NAME.app"
ARCHS="$(lipo -archs "$STAGING/$APP_NAME.app/Contents/MacOS/$APP_NAME")"
echo "  Architektur: $ARCHS"
[ "$ARCHS" = "arm64" ] || { echo "✗ Erwartet nur arm64, ist: $ARCHS" >&2; exit 1; }

echo "▸ Deinstaller erzeugen …"
osacompile -o "$STAGING/$UNINSTALLER_NAME.app" "$ROOT/macos/packaging/uninstall.applescript"
# Gleiches Icon wie die App, damit er im DMG erkennbar ist.
cp "$STAGING/$APP_NAME.app/Contents/Resources/AppIcon.icns" \
   "$STAGING/$UNINSTALLER_NAME.app/Contents/Resources/applet.icns" 2>/dev/null || true

ln -s /Applications "$STAGING/Applications"

if [ -n "$SIGN_ID" ]; then
  echo "▸ Signieren mit: $SIGN_ID"
  SIGN=(codesign --force --timestamp --options runtime -s "$SIGN_ID")
else
  echo "▸ Ad-hoc-Signatur (keine MAC_SIGN_IDENTITY gesetzt)"
  SIGN=(codesign --force --options runtime -s -)
fi
# Eingebettete Frameworks zuerst, dann die App selbst (kein --deep: das
# würde die Entitlements auch auf die Frameworks stempeln).
find "$STAGING/$APP_NAME.app/Contents/Frameworks" -maxdepth 1 \
     \( -name "*.framework" -o -name "*.dylib" \) -print0 |
  xargs -0 -I{} "${SIGN[@]}" "{}"
"${SIGN[@]}" --entitlements "$ENTITLEMENTS" "$STAGING/$APP_NAME.app"
"${SIGN[@]}" "$STAGING/$UNINSTALLER_NAME.app"
codesign --verify --strict "$STAGING/$APP_NAME.app"

echo "▸ DMG erstellen …"
RW_DMG="$OUT_DIR/rw.dmg"
# Ein noch eingehängtes altes DMG gleichen Namens würde das Layout-Skript
# auf das falsche Volume lenken.
if [ -d "/Volumes/$APP_NAME" ]; then
  hdiutil detach "/Volumes/$APP_NAME" -force -quiet || true
fi
hdiutil create -volname "$APP_NAME" -srcfolder "$STAGING" -fs HFS+ \
  -format UDRW -ov "$RW_DMG" >/dev/null

# Finder-Fenster anordnen (App links, Programme rechts, Deinstaller unten).
# Rein kosmetisch — schlägt das fehl (z. B. ohne Automation-Recht für
# Terminal → Finder), entsteht das DMG trotzdem.
MOUNT_DIR="$(hdiutil attach -readwrite -noverify -noautoopen "$RW_DMG" |
  grep -E '/Volumes/' | sed -E 's/.*(\/Volumes\/.*)$/\1/')"
osascript <<EOF || echo "  (Fenster-Layout übersprungen)"
tell application "Finder"
  tell disk "$APP_NAME"
    open
    set current view of container window to icon view
    set toolbar visible of container window to false
    set statusbar visible of container window to false
    set the bounds of container window to {200, 120, 760, 520}
    set opts to the icon view options of container window
    set arrangement of opts to not arranged
    set icon size of opts to 112
    set text size of opts to 13
    set position of item "$APP_NAME.app" of container window to {140, 150}
    set position of item "Applications" of container window to {420, 150}
    set position of item "$UNINSTALLER_NAME.app" of container window to {280, 310}
    update without registering applications
    delay 1
    close
  end tell
end tell
EOF
sync
hdiutil detach "$MOUNT_DIR" -quiet || hdiutil detach "$MOUNT_DIR" -force -quiet

hdiutil convert "$RW_DMG" -format UDZO -imagekey zlib-level=9 -o "$DMG" >/dev/null
rm -f "$RW_DMG"
rm -rf "$STAGING"

if [ -n "$SIGN_ID" ]; then
  codesign --force --timestamp -s "$SIGN_ID" "$DMG"
  if [ -n "${MAC_NOTARY_PROFILE:-}" ]; then
    echo "▸ Notarisieren (kann einige Minuten dauern) …"
    xcrun notarytool submit "$DMG" --keychain-profile "$MAC_NOTARY_PROFILE" --wait
    xcrun stapler staple "$DMG"
  fi
fi

echo "✓ Fertig: $DMG"
