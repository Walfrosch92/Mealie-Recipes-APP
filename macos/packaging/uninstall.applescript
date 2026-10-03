-- Deinstaller für Mealie Recipes (macOS).
-- Wird von build_dmg.sh per osacompile zu „Uninstall Mealie Recipes.app"
-- übersetzt und liegt neben der App im DMG.
--
-- Ablauf (App läuft seit 2026-10-03 OHNE Sandbox):
-- 1. App beenden, dann mit `--wipe-app-data` starten: die App löscht ihre
--    eigenen Daten selbst (Rezept-Cache, Bilder, Einstellungen, Logs) und
--    den API-Token im Schlüsselbund — ohne Schlüsselbund-Passwortabfrage.
--    Siehe AppDataWiper in macos/Runner/MainFlutterWindow.swift.
-- 2. App-Bundle + verbliebene Datenordner per Finder in den Papierkorb.
-- 3. Alt-Installation mit Sandbox: deren Container (~/Library/Containers/
--    <ID>) schützt macOS vor fremden Programmen. Lässt er sich nicht
--    löschen, bietet der Deinstaller „Im Finder zeigen" an (Ziehen in den
--    Papierkorb durch den Benutzer erlaubt macOS).

property bundleID : "Walfrosch92.MealieRecipes"
property appName : "Mealie Recipes"

on run
	set isGerman to (user locale of (system info)) starts with "de"
	if isGerman then
		set tTitle to "Mealie Recipes deinstallieren"
		set tAsk to "Mealie Recipes und alle zugehörigen Daten (Rezept-Cache, Bilder, Einstellungen, Anmeldung) werden entfernt." & return & return & "Die Rezepte auf deinem Mealie-Server bleiben unverändert."
		set tCancel to "Abbrechen"
		set tGo to "Deinstallieren"
		set tNothing to "Mealie Recipes ist auf diesem Mac nicht (mehr) installiert."
		set tDone to "Mealie Recipes wurde entfernt."
		set tOrphan to "Daten einer früheren Version liegen noch in einem von macOS geschützten Ordner. Nur du darfst ihn entfernen: im Finder zeigen und in den Papierkorb ziehen."
		set tShow to "Im Finder zeigen"
		set tClose to "Schließen"
		set tFailed to "Diese Einträge konnten nicht entfernt werden:"
	else
		set tTitle to "Uninstall Mealie Recipes"
		set tAsk to "Mealie Recipes and all of its data (recipe cache, images, settings, sign-in) will be removed." & return & return & "The recipes on your Mealie server are not affected."
		set tCancel to "Cancel"
		set tGo to "Uninstall"
		set tNothing to "Mealie Recipes is not installed on this Mac."
		set tDone to "Mealie Recipes has been removed."
		set tOrphan to "Data of an earlier version is still in a folder protected by macOS. Only you can remove it: show it in Finder and drag it to the Trash."
		set tShow to "Show in Finder"
		set tClose to "Close"
		set tFailed to "These items could not be removed:"
	end if

	set homePath to POSIX path of (path to home folder)
	set containerPath to homePath & "Library/Containers/" & bundleID
	set scriptsPath to homePath & "Library/Application Scripts/" & bundleID

	set appPath to ""
	repeat with p in {"/Applications/" & appName & ".app", homePath & "Applications/" & appName & ".app"}
		if my pathExists(p as text) then
			set appPath to p as text
			exit repeat
		end if
	end repeat

	-- Datenordner der App (falls die App sie nicht selbst löschen konnte,
	-- z. B. weil sie schon weg ist). Nur nach der Bundle-ID benannte Ordner.
	set extras to {}
	repeat with p in {homePath & "Library/Application Support/" & bundleID, ¬
		homePath & "Library/Caches/" & bundleID, ¬
		homePath & "Library/Caches/libCachedImageData", ¬
		homePath & "Library/HTTPStorages/" & bundleID, ¬
		homePath & "Library/WebKit/" & bundleID, ¬
		homePath & "Library/Preferences/" & bundleID & ".plist", ¬
		homePath & "Library/Saved Application State/" & bundleID & ".savedState"}
		if my pathExists(p as text) then set end of extras to (p as text)
	end repeat

	set hasContainer to my pathExists(containerPath)
	if appPath is "" and extras is {} and not hasContainer and not my tokenExists() then
		display dialog tNothing with title tTitle buttons {"OK"} default button 1 with icon note
		return
	end if

	display dialog tAsk with title tTitle buttons {tCancel, tGo} default button tGo cancel button tCancel with icon caution

	-- 1. Laufende App beenden (sonst schreibt sie Daten zurück) …
	if application id bundleID is running then
		try
			tell application id bundleID to quit
		end try
		repeat 40 times
			if application id bundleID is not running then exit repeat
			delay 0.25
		end repeat
	end if

	-- … und ihre Daten von ihr selbst löschen lassen.
	set wiped to false
	if appPath is not "" then
		try
			do shell script "/usr/bin/open -W -n -a " & quoted form of appPath & " --args --wipe-app-data"
			set wiped to true
		end try
	end if

	-- 2. App-Bundle und Reste außerhalb der Sandbox.
	set failed to {}
	set toDelete to extras
	if appPath is not "" then set toDelete to {appPath} & extras
	repeat with p in toDelete
		set p to p as text
		-- Die App hat ihre Daten evtl. schon selbst gelöscht.
		if not my pathExists(p) then
		else
		try
			tell application "Finder" to delete ((POSIX file p) as alias)
		on error
			try
				do shell script "rm -rf " & quoted form of p with administrator privileges
			on error
				set end of failed to p
			end try
		end try
		end if
	end repeat

	-- 3. System-Ordner der Sandbox: nur versuchen, Fehlschlag ist normal.
	repeat with p in {containerPath, scriptsPath}
		set p to p as text
		if my pathExists(p) then
			try
				tell application "Finder" to delete ((POSIX file p) as alias)
			end try
		end if
	end repeat

	-- Token (falls die App ihn nicht selbst löschen konnte).
	if my tokenExists() then
		try
			do shell script "security delete-generic-password -s " & quoted form of bundleID & " -a apiToken"
		end try
	end if

	if failed is not {} then
		set AppleScript's text item delimiters to return
		set failedText to failed as text
		set AppleScript's text item delimiters to ""
		display dialog tFailed & return & return & failedText with title tTitle buttons {"OK"} default button 1 with icon stop
	else if my pathExists(containerPath) then
		set r to display dialog tOrphan with title tTitle buttons {tClose, tShow} default button tShow with icon caution
		if button returned of r is tShow then
			tell application "Finder"
				reveal ((POSIX file containerPath) as alias)
				activate
			end tell
		end if
	else
		display dialog tDone with title tTitle buttons {"OK"} default button 1 with icon note
	end if
end run

on pathExists(p)
	try
		do shell script "test -e " & quoted form of p
		return true
	on error
		return false
	end try
end pathExists

on tokenExists()
	try
		do shell script "security find-generic-password -s " & quoted form of bundleID & " -a apiToken >/dev/null 2>&1"
		return true
	on error
		return false
	end try
end tokenExists
