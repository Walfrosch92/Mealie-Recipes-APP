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
        "it" to "È ora di fare la spesa!",
        "ru" to "Пора за покупками!",
        "sv" to "Dags att handla!",
        "da" to "Tid til at handle ind!",
        "cs" to "Čas jít nakoupit!",
        "fi" to "Ostosten aika!",
        "tr" to "Alışveriş zamanı!",
        "uk" to "Час за покупками!",
        "ja" to "買い物の時間です！",
        "ko" to "장보러 갈 시간이에요!",
        "zh" to "该去购物了！",
        "zh_TW" to "該去購物了！",
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
        "it" to "Sei vicino a %s — nella tua lista della spesa ci sono ancora articoli aperti.",
        "ru" to "Вы рядом с %s — в вашем списке покупок ещё есть открытые позиции.",
        "sv" to "Du är nära %s — din inköpslista har fortfarande öppna varor.",
        "da" to "Du er i nærheden af %s — din indkøbsliste har stadig åbne varer.",
        "cs" to "Jste poblíž %s — na nákupním seznamu máte ještě otevřené položky.",
        "fi" to "Olet lähellä kohdetta %s — ostoslistallasi on vielä avoimia tuotteita.",
        "tr" to "%s yakınındasınız — alışveriş listenizde hâlâ açık ürünler var.",
        "uk" to "Ви поруч із %s — у вашому списку покупок ще є відкриті позиції.",
        "ja" to "%s の近くにいます — 買い物リストにまだ未完了のアイテムがあります。",
        "ko" to "%s 근처에 있어요 — 장보기 목록에 아직 남은 항목이 있습니다.",
        "zh" to "你在 %s 附近 — 购物清单中还有未完成的物品。",
        "zh_TW" to "你在 %s 附近 — 購物清單中還有未完成的物品。",
    )

    fun title(lang: String): String = TITLE[lang] ?: TITLE["en"]!!

    fun body(lang: String, locationName: String): String =
        String.format(BODY[lang] ?: BODY["en"]!!, locationName)
}
