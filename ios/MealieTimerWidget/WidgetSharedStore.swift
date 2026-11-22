import Foundation
import Security

// ----------------------------------------------------------------------------
// WidgetSharedStore — gemeinsamer Datenzugriff für alle Home-Screen-Widgets
// der Mealie-Flutter-App. 1:1 Port aus der Swift-Vorgängerversion
// (`Mealie Recipes_Widget/WidgetSharedStore.swift`).
//
// Daten landen über die App-Group `group.Walfrosch92.MealieRecipes` als JSON
// in den UserDefaults. Die Flutter-Seite schreibt sie über die
// `mealie/widget` MethodChannel-Bridge (siehe Runner/WidgetBridge.swift).
//
// Identische Key-Namen wie im Swift-Original, damit eine User-Migration
// von Swift → Flutter ohne Widget-Datenneuaufbau passiert.
// ----------------------------------------------------------------------------

struct WidgetMealEntry: Codable {
    let date: String
    let slot: String
    let slotName: String
    let recipeName: String
    let recipeId: String?
}

struct WidgetShoppingItem: Codable {
    let id: String
    let name: String
    let checked: Bool
    let category: String?
}

struct WidgetRecipeSummary: Codable {
    let id: String
    let name: String
    let description: String?
    let category: String?
}

// MARK: - L10n

struct WidgetL10n {
    private let lang: String

    init() { self.lang = WidgetSharedStore.loadLanguage() }

    /// Alle 10 App-Sprachen (Codes wie in der App: Norwegisch = "nb",
    /// Portugiesisch (Brasilien) = "pt"). Unbekannt → Englisch.
    func s(_ key: String) -> String {
        // Regionale Variante (z. B. "fr_CA") → eigene Einträge, sonst die
        // Grundsprache ("fr"), sonst Englisch.
        let base = String(lang.split(separator: "_").first ?? "")
        return WidgetL10n.table[key]?[lang] ?? WidgetL10n.table[key]?[base]
            ?? WidgetL10n.table[key]?["en"] ?? key
    }

    static let supported: Set<String> = ["de", "en", "fr", "es", "nl", "hu", "nb", "pl", "pt", "sl", "it", "ru", "sv", "da", "cs", "fi", "tr", "uk", "ja", "ko", "zh", "zh_TW"]

    private static let table: [String: [String: String]] = [
        "breakfast": ["de": "Frühstück", "en": "Breakfast", "fr": "Petit-déjeuner", "fr_CA": "Déjeuner", "es": "Desayuno", "nl": "Ontbijt", "hu": "Reggeli", "nb": "Frokost", "pl": "Śniadanie", "pt": "Café da manhã", "sl": "Zajtrk", "it": "Colazione", "ru": "Завтрак", "sv": "Frukost", "da": "Morgenmad", "cs": "Snídaně", "fi": "Aamiainen", "tr": "Kahvaltı", "uk": "Сніданок", "ja": "朝食", "ko": "조식", "zh": "早餐", "zh_TW": "早餐"],
        "lunch": ["de": "Mittagessen", "en": "Lunch", "fr": "Déjeuner", "fr_CA": "Dîner", "es": "Almuerzo", "nl": "Lunch", "hu": "Ebéd", "nb": "Lunsj", "pl": "Obiad", "pt": "Almoço", "sl": "Kosilo", "it": "Pranzo", "ru": "Обед", "sv": "Lunch", "da": "Frokost", "cs": "Oběd", "fi": "Lounas", "tr": "Öğle Yemeği", "uk": "Обід", "ja": "昼食", "ko": "점심", "zh": "午餐", "zh_TW": "午餐"],
        "dinner": ["de": "Abendessen", "en": "Dinner", "fr": "Dîner", "fr_CA": "Souper", "es": "Cena", "nl": "Diner", "hu": "Vacsora", "nb": "Middag", "pl": "Kolacja", "pt": "Jantar", "sl": "Večerja", "it": "Cena", "ru": "Ужин", "sv": "Middag", "da": "Aftensmad", "cs": "Večeře", "fi": "Päivällinen", "tr": "Akşam Yemeği", "uk": "Вечеря", "ja": "夕食", "ko": "저녁 식사", "zh": "晚餐", "zh_TW": "晚餐"],
        "today": ["de": "Heute", "en": "Today", "fr": "Aujourd'hui", "es": "Hoy", "nl": "Vandaag", "hu": "Ma", "nb": "I dag", "pl": "Dzisiaj", "pt": "Hoje", "sl": "Danes", "it": "Oggi", "ru": "Сегодня", "sv": "Idag", "da": "I dag", "cs": "Dnes", "fi": "Tänään", "tr": "Bugün", "uk": "Сьогодні", "ja": "今日", "ko": "오늘", "zh": "今天", "zh_TW": "今天"],
        "tomorrow": ["de": "Morgen", "en": "Tomorrow", "fr": "Demain", "es": "Mañana", "nl": "Morgen", "hu": "Holnap", "nb": "I morgen", "pl": "Jutro", "pt": "Amanhã", "sl": "Jutri", "it": "Domani", "ru": "Завтра", "sv": "Imorgon", "da": "I morgen", "cs": "Zítra", "fi": "Huomenna", "tr": "Yarın", "uk": "Завтра", "ja": "明日", "ko": "내일", "zh": "明天", "zh_TW": "明天"],
        "nothing_planned": ["de": "Nichts geplant", "en": "Nothing planned", "fr": "Rien de prévu", "es": "Nada planificado", "nl": "Niets gepland", "hu": "Nincs terv", "nb": "Ingenting planlagt", "pl": "Nic nie zaplanowano", "pt": "Nada planejado", "sl": "Nič načrtovano", "it": "Niente in programma", "ru": "Ничего не запланировано", "sv": "Inget planerat", "da": "Intet planlagt", "cs": "Nic naplánováno", "fi": "Ei mitään suunniteltu", "tr": "Plan yok", "uk": "Нічого не заплановано", "ja": "予定なし", "ko": "계획 없음", "zh": "暂无计划", "zh_TW": "暫無計畫"],
        "meal_plan": ["de": "Essensplan", "en": "Meal Plan", "fr": "Menus", "es": "Plan de comidas", "nl": "Maaltijdplan", "hu": "Étkezési terv", "nb": "Måltidsplan", "pl": "Plan posiłków", "pt": "Plano de refeições", "sl": "Jedilnik", "it": "Piano alimentare", "ru": "План питания", "sv": "Måltidsplan", "da": "Madplan", "cs": "Jídelníček", "fi": "Ateriasuunnitelma", "tr": "Öğün planı", "uk": "План харчування", "ja": "献立表", "ko": "식단표", "zh": "饮食计划", "zh_TW": "用餐計畫"],
        "no_meals": ["de": "Keine Mahlzeiten geplant", "en": "No meals planned", "fr": "Aucun repas prévu", "es": "Sin comidas planificadas", "nl": "Geen maaltijden gepland", "hu": "Nincs betervezett étkezés", "nb": "Ingen måltider planlagt", "pl": "Brak zaplanowanych posiłków", "pt": "Nenhuma refeição planejada", "sl": "Ni načrtovanih obrokov", "it": "Nessun pasto pianificato", "ru": "Нет запланированных блюд", "sv": "Inga måltider planerade", "da": "Ingen måltider planlagt", "cs": "Žádná naplánovaná jídla", "fi": "Ei suunniteltuja aterioita", "tr": "Planlanmış öğün yok", "uk": "Немає запланованих страв", "ja": "予定された食事はありません", "ko": "계획된 식사가 없습니다", "zh": "未安排餐食", "zh_TW": "未安排餐點"],
        "shopping": ["de": "Einkauf", "en": "Shopping", "fr": "Courses", "fr_CA": "Épicerie", "es": "Compra", "nl": "Boodschappen", "hu": "Bevásárlás", "nb": "Handel", "pl": "Zakupy", "pt": "Compras", "sl": "Nakup", "it": "Spesa", "ru": "Покупки", "sv": "Handla", "da": "Indkøb", "cs": "Nákup", "fi": "Ostokset", "tr": "Alışveriş", "uk": "Покупки", "ja": "買い物", "ko": "장보기", "zh": "购物", "zh_TW": "購物"],
        "shopping_list": ["de": "Einkaufsliste", "en": "Shopping List", "fr": "Liste de courses", "fr_CA": "Liste d'épicerie", "es": "Lista de la compra", "nl": "Boodschappenlijst", "hu": "Bevásárlólista", "nb": "Handleliste", "pl": "Lista zakupów", "pt": "Lista de compras", "sl": "Nakupovalni seznam", "it": "Lista della spesa", "ru": "Список покупок", "sv": "Inköpslista", "da": "Indkøbsliste", "cs": "Nákupní seznam", "fi": "Ostoslista", "tr": "Alışveriş Listesi", "uk": "Список покупок", "ja": "買い物リスト", "ko": "장보기 목록", "zh": "购物清单", "zh_TW": "購物清單"],
        "open": ["de": "offen", "en": "open", "fr": "ouverts", "es": "abiertos", "nl": "open", "hu": "nyitott", "nb": "åpne", "pl": "otwarte", "pt": "em aberto", "sl": "odprto", "it": "aperti", "ru": "открыто", "sv": "öppna", "da": "åbne", "cs": "otevřené", "fi": "avoinna", "tr": "açık", "uk": "відкрито", "ja": "未完了", "ko": "남음", "zh": "未完成", "zh_TW": "未完成"],
        "all_done": ["de": "Alles da!", "en": "All done!", "fr": "Tout prêt!", "es": "¡Todo!", "nl": "Alles klaar!", "hu": "Minden megvan!", "nb": "Alt er klart!", "pl": "Wszystko jest!", "pt": "Tudo pronto!", "sl": "Vse je tu!", "it": "Tutto pronto!", "ru": "Всё готово!", "sv": "Allt klart!", "da": "Alt er klar!", "cs": "Vše hotovo!", "fi": "Kaikki valmiina!", "tr": "Hepsi tamam!", "uk": "Усе готово!", "ja": "すべて揃いました！", "ko": "모두 준비됨!", "zh": "全部齐了！", "zh_TW": "全部齊了！"],
        "all_completed": ["de": "Alles erledigt!", "en": "All completed!", "fr": "Tout terminé!", "es": "¡Todo hecho!", "nl": "Alles klaar!", "hu": "Minden kész!", "nb": "Alt fullført!", "pl": "Wszystko gotowe!", "pt": "Tudo concluído!", "sl": "Vse opravljeno!", "it": "Tutto completato!", "ru": "Всё выполнено!", "sv": "Allt avklarat!", "da": "Alt fuldført!", "cs": "Vše dokončeno!", "fi": "Kaikki tehty!", "tr": "Hepsi tamamlandı!", "uk": "Усе виконано!", "ja": "すべて完了！", "ko": "모두 완료!", "zh": "全部完成！", "zh_TW": "全部完成！"],
        "no_items": ["de": "Keine Artikel", "en": "No items", "fr": "Aucun article", "es": "Sin artículos", "nl": "Geen artikelen", "hu": "Nincs tétel", "nb": "Ingen varer", "pl": "Brak pozycji", "pt": "Nenhum item", "sl": "Ni artiklov", "it": "Nessun articolo", "ru": "Нет позиций", "sv": "Inga varor", "da": "Ingen varer", "cs": "Žádné položky", "fi": "Ei tuotteita", "tr": "Ürün yok", "uk": "Немає позицій", "ja": "アイテムなし", "ko": "항목 없음", "zh": "没有物品", "zh_TW": "沒有物品"],
        "more": ["de": "weitere", "en": "more", "fr": "autres", "es": "más", "nl": "meer", "hu": "további", "nb": "flere", "pl": "więcej", "pt": "mais", "sl": "več", "it": "altri", "ru": "ещё", "sv": "till", "da": "mere", "cs": "další", "fi": "lisää", "tr": "daha", "uk": "ще", "ja": "件", "ko": "개 더", "zh": "更多", "zh_TW": "更多"],
        "daily_recipe": ["de": "Rezept des Tages", "en": "Recipe of the Day", "fr": "Recette du jour", "es": "Receta del día", "nl": "Recept van de dag", "hu": "A nap receptje", "nb": "Dagens oppskrift", "pl": "Przepis dnia", "pt": "Receita do dia", "sl": "Recept dneva", "it": "Ricetta del giorno", "ru": "Рецепт дня", "sv": "Dagens recept", "da": "Dagens opskrift", "cs": "Recept dne", "fi": "Päivän resepti", "tr": "Günün tarifi", "uk": "Рецепт дня", "ja": "今日のレシピ", "ko": "오늘의 레시피", "zh": "每日食谱", "zh_TW": "每日食譜"],
        "no_recipes": ["de": "Keine Rezepte", "en": "No recipes", "fr": "Aucune recette", "es": "Sin recetas", "nl": "Geen recepten", "hu": "Nincsenek receptek", "nb": "Ingen oppskrifter", "pl": "Brak przepisów", "pt": "Nenhuma receita", "sl": "Ni receptov", "it": "Nessuna ricetta", "ru": "Нет рецептов", "sv": "Inga recept", "da": "Ingen opskrifter", "cs": "Žádné recepty", "fi": "Ei reseptejä", "tr": "Tarif yok", "uk": "Немає рецептів", "ja": "レシピがありません", "ko": "레시피 없음", "zh": "没有食谱", "zh_TW": "沒有食譜"],
        "desc_shopping": ["de": "Zeigt offene Artikel der Einkaufsliste.", "en": "Shows open items on your shopping list.", "fr": "Affiche les articles restants de la liste de courses.", "fr_CA": "Affiche les articles restants de la liste d'épicerie.", "es": "Muestra los artículos pendientes de la lista de la compra.", "nl": "Toont openstaande artikelen van de boodschappenlijst.", "hu": "Megjeleníti a bevásárlólista nyitott tételeit.", "nb": "Viser åpne varer på handlelisten.", "pl": "Pokazuje otwarte pozycje listy zakupów.", "pt": "Mostra os itens em aberto da lista de compras.", "sl": "Prikaže odprte artikle nakupovalnega seznama.", "it": "Mostra gli articoli aperti della lista della spesa.", "ru": "Показывает открытые позиции списка покупок.", "sv": "Visar öppna varor på inköpslistan.", "da": "Viser åbne varer på indkøbslisten.", "cs": "Zobrazuje otevřené položky nákupního seznamu.", "fi": "Näyttää ostoslistan avoimet tuotteet.", "tr": "Alışveriş listesindeki açık ürünleri gösterir.", "uk": "Показує відкриті позиції списку покупок.", "ja": "買い物リストの未完了アイテムを表示します。", "ko": "장보기 목록에서 남은 항목을 보여줍니다.", "zh": "显示购物清单中未完成的物品。", "zh_TW": "顯示購物清單中未完成的物品。"],
        "desc_mealplan": ["de": "Zeigt den Essensplan für heute und morgen.", "en": "Shows the meal plan for today and tomorrow.", "fr": "Affiche les menus d'aujourd'hui et de demain.", "es": "Muestra el plan de comidas de hoy y mañana.", "nl": "Toont het maaltijdplan voor vandaag en morgen.", "hu": "Megjeleníti a mai és holnapi étkezési tervet.", "nb": "Viser måltidsplanen for i dag og i morgen.", "pl": "Pokazuje plan posiłków na dziś i jutro.", "pt": "Mostra o plano de refeições de hoje e amanhã.", "sl": "Prikaže jedilnik za danes in jutri.", "it": "Mostra il piano alimentare di oggi e domani.", "ru": "Показывает план питания на сегодня и завтра.", "sv": "Visar måltidsplanen för idag och imorgon.", "da": "Viser madplanen for i dag og i morgen.", "cs": "Zobrazuje jídelníček na dnes a zítra.", "fi": "Näyttää tämän päivän ja huomisen ateriasuunnitelman.", "tr": "Bugünün ve yarının öğün planını gösterir.", "uk": "Показує план харчування на сьогодні й завтра.", "ja": "今日と明日の献立を表示します。", "ko": "오늘과 내일의 식단을 보여줍니다.", "zh": "显示今天和明天的饮食计划。", "zh_TW": "顯示今天和明天的用餐計畫。"],
        "desc_daily": ["de": "Zeigt täglich ein neues Zufallsrezept.", "en": "Shows a new random recipe every day.", "fr": "Affiche chaque jour une nouvelle recette au hasard.", "es": "Muestra cada día una nueva receta al azar.", "nl": "Toont elke dag een nieuw willekeurig recept.", "hu": "Minden nap egy új véletlenszerű receptet mutat.", "nb": "Viser en ny tilfeldig oppskrift hver dag.", "pl": "Codziennie pokazuje nowy losowy przepis.", "pt": "Mostra uma nova receita aleatória todos os dias.", "sl": "Vsak dan prikaže nov naključen recept.", "it": "Mostra ogni giorno una nuova ricetta casuale.", "ru": "Каждый день показывает новый случайный рецепт.", "sv": "Visar ett nytt slumpat recept varje dag.", "da": "Viser en ny tilfældig opskrift hver dag.", "cs": "Každý den zobrazí nový náhodný recept.", "fi": "Näyttää joka päivä uuden satunnaisen reseptin.", "tr": "Her gün yeni bir rastgele tarif gösterir.", "uk": "Щодня показує новий випадковий рецепт.", "ja": "毎日新しいランダムなレシピを表示します。", "ko": "매일 새로운 무작위 레시피를 보여줍니다.", "zh": "每天显示一个新的随机食谱。", "zh_TW": "每天顯示一個新的隨機食譜。"],
    ]
}

// MARK: - Store

enum WidgetSharedStore {
    static let appGroupID = "group.Walfrosch92.MealieRecipes"
    private static var defaults: UserDefaults? { UserDefaults(suiteName: appGroupID) }

    /// App-Sprache (von der App gespeichert). Noch nie gestartet → die
    /// Systemsprache, falls die App sie kann, sonst Englisch — so ist auch
    /// die Widget-Galerie vor dem ersten App-Start in der richtigen Sprache.
    static func loadLanguage() -> String {
        if let saved = defaults?.string(forKey: "widgetLanguage"), !saved.isEmpty {
            return saved
        }
        for pref in Locale.preferredLanguages {
            if pref.lowercased().hasPrefix("fr-ca") { return "fr_CA" }
            var code = String(pref.prefix(2)).lowercased()
            if code == "no" { code = "nb" }
            if WidgetL10n.supported.contains(code) { return code }
        }
        return "en"
    }

    static func loadMealplan() -> [WidgetMealEntry] {
        guard let data = defaults?.data(forKey: "widgetMealplan"),
              let entries = try? JSONDecoder().decode([WidgetMealEntry].self, from: data) else { return [] }
        return entries
    }

    static func loadShoppingItems() -> [WidgetShoppingItem] {
        guard let data = defaults?.data(forKey: "widgetShoppingList"),
              let items = try? JSONDecoder().decode([WidgetShoppingItem].self, from: data) else { return [] }
        return items
    }

    static func loadDailyRecipes() -> [WidgetRecipeSummary] {
        guard let data = defaults?.data(forKey: "widgetDailyRecipes"),
              let recipes = try? JSONDecoder().decode([WidgetRecipeSummary].self, from: data) else { return [] }
        return recipes
    }

    /// Wählt das "Rezept des Tages" — deterministisch per Tagesindex,
    /// also rotiert die Liste über die Wochen/Monate hinweg gleichmäßig
    /// statt zufällig (sonst sieht der User u. U. dasselbe Rezept zweimal
    /// am selben Tag wenn das Widget mehrfach reloaded wird).
    static func dailyRecipe() -> WidgetRecipeSummary? {
        let recipes = loadDailyRecipes()
        guard !recipes.isEmpty else { return nil }
        let dayIndex = Calendar.current.ordinality(of: .day, in: .era, for: Date()) ?? 0
        return recipes[dayIndex % recipes.count]
    }

    static func entriesForDateString(_ dateString: String, from entries: [WidgetMealEntry]) -> [WidgetMealEntry] {
        let order = ["breakfast": 0, "lunch": 1, "dinner": 2]
        return entries
            .filter { $0.date == dateString }
            .sorted { (order[$0.slot] ?? 3) < (order[$1.slot] ?? 3) }
    }

    /// Lokales Kalenderdatum — Mealie-Essensplan-Daten sind reine Tage
    /// („2026-10-26") ohne Zeitzone. Vorher in UTC formatiert: in Österreich
    /// zeigte „Heute" zwischen 0 und 1/2 Uhr noch die gestrigen Mahlzeiten,
    /// und „Morgen" wurde gar nicht vom Server geholt.
    static func dateString(from date: Date) -> String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.dateFormat = "yyyy-MM-dd"
        f.timeZone = TimeZone.current
        return f.string(from: date)
    }
}

// MARK: - Selbst-Aktualisierung vom Mealie-Server

/// Zugangsdaten für den Widget-eigenen Abruf. Die App legt sie im Keychain
/// ab (Zugriffsgruppe = App Group, geteilt nur mit den eigenen Extensions)
/// — nie im Klartext in den UserDefaults.
struct WidgetServerAccess: Codable {
    let url: String
    let token: String
    let headers: [String: String]?
    let listId: String?
    let exact: Bool?
}

enum WidgetKeychain {
    static let service = "mealie.widget.serverAccess"
    static let account = "access"

    static func load() -> WidgetServerAccess? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecAttrAccessGroup as String: WidgetSharedStore.appGroupID,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne,
        ]
        var out: CFTypeRef?
        guard SecItemCopyMatching(query as CFDictionary, &out) == errSecSuccess,
              let data = out as? Data else { return nil }
        return try? JSONDecoder().decode(WidgetServerAccess.self, from: data)
    }
}

/// Holt Einkaufsliste und Essensplan selbst vom Server, damit die Widgets
/// auch Änderungen aus der Webapp / von anderen Geräten zeigen, ohne dass
/// die App geöffnet wird. Fehler (offline, Token ungültig) → der zuletzt
/// gespeicherte Stand bleibt (offline-first). Texte 1:1 wie in der App
/// (widget_sync_provider.dart: _shoppingItemText / _mapMealplan).
enum WidgetServerSync {
    /// WidgetKit fragt bei App-Pushes oft mehrfach nach — höchstens alle
    /// 10 Minuten wirklich zum Server.
    private static let minInterval: TimeInterval = 10 * 60
    private static var defaults: UserDefaults? { UserDefaults(suiteName: WidgetSharedStore.appGroupID) }

    private static func due(_ key: String) -> Bool {
        let last = defaults?.double(forKey: key) ?? 0
        return Date().timeIntervalSince1970 - last >= minInterval
    }

    private static func get(_ access: WidgetServerAccess, _ path: String) async -> Any? {
        let base = access.url.hasSuffix("/") ? String(access.url.dropLast()) : access.url
        guard let url = URL(string: base + path) else { return nil }
        var req = URLRequest(url: url, timeoutInterval: 12)
        req.setValue("Bearer \(access.token)", forHTTPHeaderField: "Authorization")
        for (k, v) in access.headers ?? [:] { req.setValue(v, forHTTPHeaderField: k) }
        guard let (data, resp) = try? await URLSession.shared.data(for: req),
              (resp as? HTTPURLResponse)?.statusCode == 200 else { return nil }
        return try? JSONSerialization.jsonObject(with: data)
    }

    /// Gilt der Zugang, mit dem abgerufen wurde, noch? (Benutzer wechseln
    /// in der App ersetzt ihn — ein laufender Abruf darf danach nichts mehr
    /// schreiben.)
    private static func isStillCurrent(_ access: WidgetServerAccess) -> Bool {
        guard let now = WidgetKeychain.load() else { return false }
        return now.url == access.url && now.token == access.token
    }

    static func refreshShopping() async {
        guard due("widgetShoppingFetchedAt"),
              let access = WidgetKeychain.load(),
              let listId = access.listId, !listId.isEmpty,
              let list = await get(access, "/api/households/shopping/lists/\(listId)") as? [String: Any],
              let raw = list["listItems"] as? [[String: Any]] else { return }
        let exact = access.exact ?? false
        let items: [WidgetShoppingItem] = raw.compactMap { i in
            guard let id = i["id"] as? String else { return nil }
            let label = (i["label"] as? [String: Any])?["name"] as? String
            return WidgetShoppingItem(id: id, name: ShoppingText.text(i, exact: exact),
                                      checked: i["checked"] as? Bool ?? false, category: label)
        }
        // Während des Abrufs das Konto gewechselt (App hat den Zugang
        // ersetzt/gelöscht)? Dann gehört das Ergebnis zum alten Konto.
        guard isStillCurrent(access),
              let data = try? JSONEncoder().encode(items) else { return }
        defaults?.set(data, forKey: "widgetShoppingList")
        defaults?.set(Date().timeIntervalSince1970, forKey: "widgetShoppingFetchedAt")
    }

    static func refreshMealplan() async {
        guard due("widgetMealplanFetchedAt"),
              let access = WidgetKeychain.load() else { return }
        let today = Date()
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today) ?? today
        let from = WidgetSharedStore.dateString(from: today)
        let to = WidgetSharedStore.dateString(from: tomorrow)
        guard let body = await get(access, "/api/households/mealplans?start_date=\(from)&end_date=\(to)&perPage=-1") as? [String: Any],
              let raw = body["items"] as? [[String: Any]] else { return }
        let l10n = WidgetL10n()
        let entries: [WidgetMealEntry] = raw.compactMap { e in
            guard let date = e["date"] as? String,
                  let slot = e["entryType"] as? String,
                  ["breakfast", "lunch", "dinner"].contains(slot) else { return nil }
            let recipe = e["recipe"] as? [String: Any]
            let name = (recipe?["name"] as? String) ?? (e["title"] as? String) ?? ""
            if name.isEmpty { return nil }
            return WidgetMealEntry(date: date, slot: slot, slotName: l10n.s(slot),
                                   recipeName: name, recipeId: recipe?["id"] as? String)
        }
        guard isStillCurrent(access),
              let data = try? JSONEncoder().encode(entries) else { return }
        defaults?.set(data, forKey: "widgetMealplan")
        defaults?.set(Date().timeIntervalSince1970, forKey: "widgetMealplanFetchedAt")
    }
}

/// Artikeltext wie in der App (_shoppingItemText): „exakte Mengen" AN =
/// „150 g Joghurt", AUS = Stückkauf-Sicht; Brüche + Plural wie dort.
enum ShoppingText {
    // Synchron zu formatQuantity in lib/core/utils/ingredient_display.dart:
    // 1/16 als Text (kein Glyph), Text-Brüche mit Leerzeichen („1 1/16"),
    // sonst bis zu 2 Nachkommastellen ohne Nullen am Ende.
    private static let fractions: [(Double, String)] = [
        (0.0625, "1/16"), (0.1, "⅒"), (0.125, "⅛"), (0.1667, "⅙"), (0.2, "⅕"), (0.25, "¼"),
        (0.3333, "⅓"), (0.375, "⅜"), (0.4, "⅖"), (0.5, "½"), (0.6, "⅗"),
        (0.625, "⅝"), (0.6667, "⅔"), (0.75, "¾"), (0.8, "⅘"), (0.8333, "⅚"),
        (0.875, "⅞"),
    ]

    private static func round(_ v: Double, _ digits: Double) -> Double {
        let f = pow(10, digits)
        return (v * f).rounded() / f
    }

    static func formatQuantity(_ q: Double) -> String {
        let clean = round(q, 3)
        if clean == clean.rounded(.towardZero) { return String(Int(clean)) }
        let whole = Int(clean.rounded(.towardZero))
        let frac = clean - Double(whole)
        func mixed(_ glyph: String) -> String {
            guard whole > 0 else { return glyph }
            return glyph.contains("/") ? "\(whole) \(glyph)" : "\(whole)\(glyph)"
        }
        for (value, glyph) in fractions where abs(frac - value) < 0.015 {
            return mixed(glyph)
        }
        for (value, glyph) in fractions where frac < value {
            if value - frac < 0.03 { return "< " + mixed(glyph) }
            break
        }
        var text = String(format: "%.2f", clean)
        while text.hasSuffix("0") { text.removeLast() }
        if text.hasSuffix(".") { text.removeLast() }
        return text
    }

    static func shouldPluralize(_ q: Double) -> Bool { round(q, 2) > 1 }

    private static func str(_ m: [String: Any]?, _ k: String) -> String {
        ((m?[k] as? String) ?? "").trimmingCharacters(in: .whitespaces)
    }

    static func text(_ i: [String: Any], exact: Bool) -> String {
        let food = i["food"] as? [String: Any]
        let unit = i["unit"] as? [String: Any]
        let foodName = str(food, "name")
        let note = ((i["note"] as? String) ?? "").trimmingCharacters(in: .whitespaces)
        let unitName = str(unit, "name")
        let foodLeads = !foodName.isEmpty &&
            (note.isEmpty || !note.lowercased().contains(foodName.lowercased()))
        let unitCarriesName = foodLeads && !unitName.isEmpty && foodName.count > 2 &&
            foodName.hasPrefix("(") && foodName.hasSuffix(")")
        var displayName: String {
            if foodLeads { return unitCarriesName ? "\(unitName) \(foodName)" : foodName }
            if !note.isEmpty { return note }
            if !foodName.isEmpty { return foodName }
            let display = str(i, "display")
            return display.isEmpty ? "-" : display
        }
        func displayNamePlural(_ plural: Bool) -> String {
            if plural && foodLeads && !unitCarriesName {
                let pl = str(food, "pluralName")
                if !pl.isEmpty { return pl }
            }
            return displayName
        }
        let abbreviation = str(unit, "abbreviation")
        let hasUnit = (!abbreviation.isEmpty || !unitName.isEmpty) && !unitCarriesName
        let rawQty = (i["quantity"] as? NSNumber)?.doubleValue
        if !exact {
            if hasUnit { return displayName }
            let q = rawQty ?? 1
            let qty = q <= 0 ? 1 : q
            if qty == 1 { return displayName }
            return "\(formatQuantity(qty)) \(displayNamePlural(shouldPluralize(qty)))"
        }
        let qty = rawQty ?? 0
        let plural = shouldPluralize(qty)
        let unitLabel = !abbreviation.isEmpty ? abbreviation
            : ((plural && !str(unit, "pluralName").isEmpty) ? str(unit, "pluralName") : unitName)
        var parts: [String] = []
        if qty > 0 { parts.append(formatQuantity(qty)) }
        if hasUnit { parts.append(unitLabel) }
        parts.append(displayNamePlural(plural))
        return parts.joined(separator: " ")
    }
}
