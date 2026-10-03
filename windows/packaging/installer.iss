; ---------------------------------------------------------------------------
; Mealie Recipes — Windows-Installer (Inno Setup 6)
;
; Baut: build\windows\installer\MealieRecipes-<Version>-windows-setup.exe
; Aufruf über windows\packaging\build_installer.ps1 (setzt AppVersion).
;
; - Installation pro Benutzer (%LOCALAPPDATA%\Programs\Mealie Recipes),
;   KEINE Admin-Abfrage → der Update-Prüfer der App kann still aktualisieren.
; - Deinstallieren über „Apps & Features" bzw. Startmenü; löscht auch die
;   App-Daten (path_provider: %APPDATA%\Walfrosch92\Mealie Recipes).
; - Stilles Update (/VERYSILENT) startet die App danach selbst neu.
; - Dateiname-Muster MUSS zum Update-Prüfer passen:
;   MealieRecipes-<x.y.z>-windows-setup.exe
; ---------------------------------------------------------------------------

#ifndef AppVersion
  #define AppVersion "0.0.0"
#endif
#ifndef SourceDir
  #define SourceDir "..\..\build\windows\x64\runner\Release"
#endif

[Setup]
; Feste AppId — NIE ändern, sonst erkennt Windows Updates nicht als solche.
AppId={{7D2AD1D3-4902-4CE4-8E09-FD4E6F4692D3}
AppName=Mealie Recipes
AppVersion={#AppVersion}
AppVerName=Mealie Recipes {#AppVersion}
AppPublisher=Walfrosch92
AppPublisherURL=https://github.com/Walfrosch92/Mealie-Recipes-APP
AppSupportURL=https://github.com/Walfrosch92/Mealie-Recipes-APP/issues
AppUpdatesURL=https://github.com/Walfrosch92/Mealie-Recipes-APP/releases
VersionInfoVersion={#AppVersion}
DefaultDirName={localappdata}\Programs\Mealie Recipes
DefaultGroupName=Mealie Recipes
DisableProgramGroupPage=yes
DisableDirPage=yes
PrivilegesRequired=lowest
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
OutputDir=..\..\build\windows\installer
OutputBaseFilename=MealieRecipes-{#AppVersion}-windows-setup
SetupIconFile=..\runner\resources\app_icon.ico
UninstallDisplayIcon={app}\MealieRecipes.exe
UninstallDisplayName=Mealie Recipes
Compression=lzma2/max
SolidCompression=yes
WizardStyle=modern
; Laufende App vor dem Ersetzen schließen (Update aus der App heraus).
CloseApplications=force
RestartApplications=no

[Languages]
Name: "de"; MessagesFile: "compiler:Languages\German.isl"
Name: "en"; MessagesFile: "compiler:Default.isl"
Name: "es"; MessagesFile: "compiler:Languages\Spanish.isl"
Name: "fr"; MessagesFile: "compiler:Languages\French.isl"
Name: "hu"; MessagesFile: "compiler:Languages\Hungarian.isl"
Name: "nb"; MessagesFile: "compiler:Languages\Norwegian.isl"
Name: "nl"; MessagesFile: "compiler:Languages\Dutch.isl"
Name: "pl"; MessagesFile: "compiler:Languages\Polish.isl"
Name: "pt"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"
Name: "sl"; MessagesFile: "compiler:Languages\Slovenian.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"

[Files]
; Kompletter Flutter-Release-Ordner (exe, DLLs, data\).
Source: "{#SourceDir}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
#ifdef VCRedistDir
; Visual-C++-Laufzeit neben die exe legen (für PCs ohne VC++ Redistributable).
Source: "{#VCRedistDir}\*.dll"; DestDir: "{app}"; Flags: ignoreversion
#endif

[InstallDelete]
; Alte Programmdateien vor dem Kopieren weg (keine Reste alter Plugins).
Type: filesandordirs; Name: "{app}\data"

[Icons]
Name: "{autoprograms}\Mealie Recipes"; Filename: "{app}\MealieRecipes.exe"
Name: "{autodesktop}\Mealie Recipes"; Filename: "{app}\MealieRecipes.exe"; Tasks: desktopicon

[Run]
; Normale Installation: Häkchen „Mealie Recipes starten".
Filename: "{app}\MealieRecipes.exe"; Description: "{cm:LaunchProgram,Mealie Recipes}"; Flags: nowait postinstall skipifsilent
; Stilles Update aus der App: danach automatisch neu starten.
Filename: "{app}\MealieRecipes.exe"; Flags: nowait; Check: WizardSilent

[UninstallDelete]
; App-Daten (Einstellungen, Rezept-Cache, Bilder, Logs).
Type: filesandordirs; Name: "{userappdata}\Walfrosch92\Mealie Recipes"
Type: dirifempty; Name: "{userappdata}\Walfrosch92"
Type: filesandordirs; Name: "{localappdata}\Walfrosch92\Mealie Recipes"
Type: dirifempty; Name: "{localappdata}\Walfrosch92"
