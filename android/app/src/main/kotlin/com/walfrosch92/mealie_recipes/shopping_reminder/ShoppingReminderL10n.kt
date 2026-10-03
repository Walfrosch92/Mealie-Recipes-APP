package com.walfrosch92.mealie_recipes.shopping_reminder

// ----------------------------------------------------------------------------
// ShoppingReminderL10n — Mini-Übersetzungstabelle für die geofence-ausgelöste
// "Erinnere mich zum Einkaufen"-Benachrichtigung (Issue #29). Feuert komplett
// nativ (GeofenceBroadcastReceiver), ohne laufende Flutter-Engine — daher wie
// schon bei WidgetL10n eine eigene, statisch eingebaute Tabelle statt der
// Dart-l10n. Sprache kommt aus WidgetSharedStore (von WidgetBridge.saveLanguage
// gepflegt), alle 9 App-Sprachen abgedeckt.
// ----------------------------------------------------------------------------

object ShoppingReminderL10n {
    private val TITLE: Map<String, String> = mapOf(
        "de" to "Zeit zum Einkaufen!",
        "en" to "Time to shop!",
        "es" to "¡Hora de comprar!",
        "fr" to "C'est l'heure des courses !",
        "hu" to "Ideje bevásárolni!",
        "nl" to "Tijd om te winkelen!",
        "nb" to "På tide å handle!",
        "pl" to "Czas na zakupy!",
        "pt" to "Hora das compras!",
        "sl" to "Čas za nakupovanje!",
    )

    private val BODY: Map<String, String> = mapOf(
        "de" to "Du bist in der Nähe von %s — auf deiner Einkaufsliste stehen noch offene Artikel.",
        "en" to "You're near %s — your shopping list still has open items.",
        "es" to "Estás cerca de %s — tu lista de la compra todavía tiene artículos pendientes.",
        "fr" to "Vous êtes près de %s — votre liste de courses contient encore des articles à acheter.",
        "hu" to "A közelben vagy: %s — a bevásárlólistádon még nyitott tételek vannak.",
        "nl" to "Je bent in de buurt van %s — je boodschappenlijst heeft nog openstaande items.",
        "nb" to "Du er i nærheten av %s — handlelisten din har fortsatt åpne varer.",
        "pl" to "Jesteś w pobliżu %s — Twoja lista zakupów wciąż ma niezaznaczone produkty.",
        "pt" to "Você está perto de %s — sua lista de compras ainda tem itens pendentes.",
        "sl" to "V bližini si: %s — na nakupovalnem seznamu imaš še odprte artikle.",
    )

    fun title(lang: String): String = TITLE[lang] ?: TITLE["en"]!!

    fun body(lang: String, locationName: String): String =
        String.format(BODY[lang] ?: BODY["en"]!!, locationName)
}
