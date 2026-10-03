import Foundation

// ----------------------------------------------------------------------------
// WatchL10n — statische Übersetzungstabelle für die watchOS-App.
//
// Die Uhr hat KEIN eigenes System-Locale-basiertes Lookup (Bundle/.strings):
// die App hat eine EIGENE, von der Systemsprache der Uhr unabhängige
// Sprachauswahl (`AppSettings.selectedLanguage`), die per WatchBridge/
// ConnectivityManager.language auf die Uhr gespiegelt wird — genau wie Timer/
// Kochmodus/Einkaufsliste. Ein Bundle-`.strings`-Ansatz würde stattdessen der
// SYSTEMSPRACHE der Uhr folgen, die vom App-internen Sprachwechsel abweichen
// kann. Deckt dieselben Keys ab wie die Android-Seite (siehe
// android/wear/.../WearStrings.kt) — bei neuen Strings BEIDE Tabellen pflegen.
// ----------------------------------------------------------------------------

enum WatchL10n {
    static func t(_ key: String, _ lang: String) -> String {
        (table[lang] ?? table["de"]!)[key] ?? table["de"]![key] ?? key
    }

    private static let table: [String: [String: String]] = [
        "de": [
            "noActiveTimer": "Kein aktiver Timer",
            "openPhoneHint": "Starte einen Timer im Kochmodus auf dem Handy.",
            "pause": "Pausieren",
            "resume": "Fortsetzen",
            "stop": "Stoppen",
            "shoppingHeader": "Einkaufen",
            "shoppingEmpty": "Keine offenen Artikel",
            "completed": "Erledigt",
            "open": "Offen",
            "uncategorized": "Sonstiges",
            "back": "Zurück",
            "next": "Weiter",
        ],
        "en": [
            "noActiveTimer": "No active timer",
            "openPhoneHint": "Start a timer in cooking mode on your phone.",
            "pause": "Pause",
            "resume": "Resume",
            "stop": "Stop",
            "shoppingHeader": "Shopping",
            "shoppingEmpty": "No open items",
            "completed": "Completed",
            "open": "Open",
            "uncategorized": "Other",
            "back": "Back",
            "next": "Next",
        ],
        "es": [
            "noActiveTimer": "Sin temporizador activo",
            "openPhoneHint": "Inicia un temporizador en el modo de cocina en tu teléfono.",
            "pause": "Pausar",
            "resume": "Reanudar",
            "stop": "Detener",
            "shoppingHeader": "Compras",
            "shoppingEmpty": "Sin artículos pendientes",
            "completed": "Completado",
            "open": "Abierto",
            "uncategorized": "Otros",
            "back": "Atrás",
            "next": "Siguiente",
        ],
        "fr": [
            "noActiveTimer": "Aucun minuteur actif",
            "openPhoneHint": "Démarrez un minuteur en mode cuisine sur votre téléphone.",
            "pause": "Mettre en pause",
            "resume": "Reprendre",
            "stop": "Arrêter",
            "shoppingHeader": "Courses",
            "shoppingEmpty": "Aucun article en attente",
            "completed": "Terminé",
            "open": "Ouvert",
            "uncategorized": "Autres",
            "back": "Retour",
            "next": "Suivant",
        ],
        "hu": [
            "noActiveTimer": "Nincs aktív időzítő",
            "openPhoneHint": "Indíts egy időzítőt a főzési módban a telefonon.",
            "pause": "Szünet",
            "resume": "Folytatás",
            "stop": "Leállítás",
            "shoppingHeader": "Bevásárlás",
            "shoppingEmpty": "Nincs nyitott tétel",
            "completed": "Kész",
            "open": "Nyitott",
            "uncategorized": "Egyéb",
            "back": "Vissza",
            "next": "Tovább",
        ],
        "nl": [
            "noActiveTimer": "Geen actieve timer",
            "openPhoneHint": "Start een timer in de kookmodus op je telefoon.",
            "pause": "Pauzeren",
            "resume": "Hervatten",
            "stop": "Stoppen",
            "shoppingHeader": "Boodschappen",
            "shoppingEmpty": "Geen openstaande artikelen",
            "completed": "Voltooid",
            "open": "Open",
            "uncategorized": "Overig",
            "back": "Terug",
            "next": "Volgende",
        ],
        "pl": [
            "noActiveTimer": "Brak aktywnego minutnika",
            "openPhoneHint": "Uruchom minutnik w trybie gotowania na telefonie.",
            "pause": "Wstrzymaj",
            "resume": "Wznów",
            "stop": "Zatrzymaj",
            "shoppingHeader": "Zakupy",
            "shoppingEmpty": "Brak otwartych pozycji",
            "completed": "Zrobione",
            "open": "Otwarte",
            "uncategorized": "Inne",
            "back": "Wstecz",
            "next": "Dalej",
        ],
        "pt": [
            "noActiveTimer": "Nenhum timer ativo",
            "openPhoneHint": "Inicie um timer no modo de cozinhar no celular.",
            "pause": "Pausar",
            "resume": "Retomar",
            "stop": "Parar",
            "shoppingHeader": "Compras",
            "shoppingEmpty": "Nenhum item pendente",
            "completed": "Concluído",
            "open": "Aberto",
            "uncategorized": "Outros",
            "back": "Voltar",
            "next": "Próximo",
        ],
        "sl": [
            "noActiveTimer": "Ni aktivnega časovnika",
            "openPhoneHint": "Zaženi časovnik v načinu kuhanja v telefonu.",
            "pause": "Premor",
            "resume": "Nadaljuj",
            "stop": "Ustavi",
            "shoppingHeader": "Nakupovanje",
            "shoppingEmpty": "Ni odprtih artiklov",
            "completed": "Končano",
            "open": "Odprto",
            "uncategorized": "Drugo",
            "back": "Nazaj",
            "next": "Naprej",
        ],
        "nb": [
            "noActiveTimer": "Ingen aktiv timer",
            "openPhoneHint": "Start en timer i kokemodus på telefonen.",
            "pause": "Pause",
            "resume": "Fortsett",
            "stop": "Stopp",
            "shoppingHeader": "Handling",
            "shoppingEmpty": "Ingen åpne varer",
            "completed": "Fullført",
            "open": "Åpen",
            "uncategorized": "Annet",
            "back": "Tilbake",
            "next": "Neste",
        ],
    ]
}
