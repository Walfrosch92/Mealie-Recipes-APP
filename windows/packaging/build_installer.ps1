# ---------------------------------------------------------------------------
# Baut Mealie Recipes für Windows und packt es als Installer:
#   build\windows\installer\MealieRecipes-<Version>-windows-setup.exe
#
#   powershell -ExecutionPolicy Bypass -File windows\packaging\build_installer.ps1
#
# Voraussetzungen (Windows-PC): Flutter, Visual Studio „Desktop C++",
# Inno Setup 6 (https://jrsoftware.org/isdl.php, Standard-Installationsort).
# Die erzeugte .exe als Asset an das GitHub-Release hängen — der
# Update-Prüfer der App erkennt sie am Dateinamen.
# ---------------------------------------------------------------------------
$ErrorActionPreference = "Stop"
$root = Resolve-Path (Join-Path $PSScriptRoot "..\..")
Set-Location $root

# Version aus pubspec.yaml (ohne +Build).
$line = Select-String -Path "pubspec.yaml" -Pattern '^version:\s*([^+\s]+)' | Select-Object -First 1
if (-not $line) { throw "Keine version: in pubspec.yaml gefunden" }
$version = $line.Matches[0].Groups[1].Value
Write-Host "> Version $version"

Write-Host "> Flutter-Release-Build (Windows) …"
flutter build windows --release
if ($LASTEXITCODE -ne 0) { throw "flutter build windows fehlgeschlagen" }

$iscc = @(
  "${env:ProgramFiles(x86)}\Inno Setup 6\ISCC.exe",
  "$env:ProgramFiles\Inno Setup 6\ISCC.exe",
  "$env:LOCALAPPDATA\Programs\Inno Setup 6\ISCC.exe"
) | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $iscc) { throw "Inno Setup 6 (ISCC.exe) nicht gefunden" }

Write-Host "> Installer erstellen …"
& $iscc "/DAppVersion=$version" "windows\packaging\installer.iss"
if ($LASTEXITCODE -ne 0) { throw "Inno Setup fehlgeschlagen" }

Write-Host "OK - Fertig: build\windows\installer\MealieRecipes-$version-windows-setup.exe"
