package com.walfrosch92.mealie_recipes.widgets

import android.content.Context
import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.core.stringPreferencesKey
import androidx.datastore.preferences.preferencesDataStore
import kotlinx.coroutines.flow.first
import kotlinx.serialization.Serializable
import kotlinx.serialization.json.Json
import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Date
import java.util.Locale
import java.util.TimeZone

// ----------------------------------------------------------------------------
// WidgetSharedStore — gemeinsamer Datenzugriff für alle Home-Screen-Widgets
// der Mealie-Flutter-App (Android-Glance-Port).
//
// 1:1 Port aus `ios/MealieTimerWidget/WidgetSharedStore.swift`.
//   • Identische Daten-Schemas (Codables → @Serializable Kotlin-Data-Klassen).
//   • Identische l10n-Tabelle DE/EN/ES/FR/NL.
//   • Identische Tagesindex-Rotation für `dailyRecipe()`.
//   • Identische Keys (`widgetLanguage`, `widgetMealplan`, `widgetShoppingList`,
//     `widgetDailyRecipes`) — auf iOS UserDefaults, hier DataStore<Preferences>.
//
// Datenfluss:
//   Flutter (lib/core/services/widget_bridge.dart)
//     → MethodChannel("mealie/widget").invokeMethod("save…", …)
//     → MainActivity.kt → WidgetSharedStore.save…(...)
//     → DataStore<Preferences>
//     → Glance-Reader liest beim Recompose.
// ----------------------------------------------------------------------------

// MARK: - Models

@Serializable
data class WidgetMealEntry(
    val date: String,
    val slot: String,
    val slotName: String,
    val recipeName: String,
    val recipeId: String? = null,
)

@Serializable
data class WidgetShoppingItem(
    val id: String,
    val name: String,
    val checked: Boolean,
    val category: String? = null,
)

@Serializable
data class WidgetRecipeSummary(
    val id: String,
    val name: String,
    val description: String? = null,
    val category: String? = null,
)

// MARK: - L10n

/**
 * Statisch eingebaute Mini-Übersetzungstabelle, 1:1 aus `WidgetL10n` in
 * Swift. Der String-Key wird `s("today")` aufgerufen, fällt auf Deutsch
 * zurück wenn die Sprache unbekannt ist, und auf den Key selbst wenn auch
 * Deutsch fehlt (Fail-Soft, wie auf iOS).
 */
class WidgetL10n(private val lang: String) {
    fun s(key: String): String {
        val row = TABLE[key] ?: return key
        return row[lang] ?: row["en"] ?: key
    }

    companion object {
        /** Alle 10 App-Sprachen (Norwegisch = "nb", Portugiesisch = "pt"). */
        private val TABLE: Map<String, Map<String, String>> = mapOf(
            "breakfast" to mapOf(
                "de" to "Frühstück",
                "en" to "Breakfast",
                "fr" to "Petit-déjeuner",
                "es" to "Desayuno",
                "nl" to "Ontbijt",
                "hu" to "Reggeli",
                "nb" to "Frokost",
                "pl" to "Śniadanie",
                "pt" to "Café da manhã",
                "sl" to "Zajtrk",
            ),
            "lunch" to mapOf(
                "de" to "Mittagessen",
                "en" to "Lunch",
                "fr" to "Déjeuner",
                "es" to "Almuerzo",
                "nl" to "Lunch",
                "hu" to "Ebéd",
                "nb" to "Lunsj",
                "pl" to "Obiad",
                "pt" to "Almoço",
                "sl" to "Kosilo",
            ),
            "dinner" to mapOf(
                "de" to "Abendessen",
                "en" to "Dinner",
                "fr" to "Dîner",
                "es" to "Cena",
                "nl" to "Diner",
                "hu" to "Vacsora",
                "nb" to "Middag",
                "pl" to "Kolacja",
                "pt" to "Jantar",
                "sl" to "Večerja",
            ),
            "today" to mapOf(
                "de" to "Heute",
                "en" to "Today",
                "fr" to "Aujourd'hui",
                "es" to "Hoy",
                "nl" to "Vandaag",
                "hu" to "Ma",
                "nb" to "I dag",
                "pl" to "Dzisiaj",
                "pt" to "Hoje",
                "sl" to "Danes",
            ),
            "tomorrow" to mapOf(
                "de" to "Morgen",
                "en" to "Tomorrow",
                "fr" to "Demain",
                "es" to "Mañana",
                "nl" to "Morgen",
                "hu" to "Holnap",
                "nb" to "I morgen",
                "pl" to "Jutro",
                "pt" to "Amanhã",
                "sl" to "Jutri",
            ),
            "nothing_planned" to mapOf(
                "de" to "Nichts geplant",
                "en" to "Nothing planned",
                "fr" to "Rien de prévu",
                "es" to "Nada planificado",
                "nl" to "Niets gepland",
                "hu" to "Nincs terv",
                "nb" to "Ingenting planlagt",
                "pl" to "Nic nie zaplanowano",
                "pt" to "Nada planejado",
                "sl" to "Nič načrtovano",
            ),
            "meal_plan" to mapOf(
                "de" to "Essensplan",
                "en" to "Meal Plan",
                "fr" to "Plan de repas",
                "es" to "Plan de comidas",
                "nl" to "Maaltijdplan",
                "hu" to "Étkezési terv",
                "nb" to "Måltidsplan",
                "pl" to "Plan posiłków",
                "pt" to "Plano alimentar",
                "sl" to "Jedilnik",
            ),
            "no_meals" to mapOf(
                "de" to "Keine Mahlzeiten geplant",
                "en" to "No meals planned",
                "fr" to "Aucun repas prévu",
                "es" to "Sin comidas planificadas",
                "nl" to "Geen maaltijden gepland",
                "hu" to "Nincs betervezett étkezés",
                "nb" to "Ingen måltider planlagt",
                "pl" to "Brak zaplanowanych posiłków",
                "pt" to "Nenhuma refeição planejada",
                "sl" to "Ni načrtovanih obrokov",
            ),
            "shopping" to mapOf(
                "de" to "Einkauf",
                "en" to "Shopping",
                "fr" to "Courses",
                "es" to "Compra",
                "nl" to "Boodschappen",
                "hu" to "Bevásárlás",
                "nb" to "Handel",
                "pl" to "Zakupy",
                "pt" to "Compras",
                "sl" to "Nakup",
            ),
            "shopping_list" to mapOf(
                "de" to "Einkaufsliste",
                "en" to "Shopping List",
                "fr" to "Liste de courses",
                "es" to "Lista de la compra",
                "nl" to "Boodschappenlijst",
                "hu" to "Bevásárlólista",
                "nb" to "Handleliste",
                "pl" to "Lista zakupów",
                "pt" to "Lista de compras",
                "sl" to "Nakupovalni seznam",
            ),
            "open" to mapOf(
                "de" to "offen",
                "en" to "open",
                "fr" to "ouverts",
                "es" to "abiertos",
                "nl" to "open",
                "hu" to "nyitott",
                "nb" to "åpne",
                "pl" to "otwarte",
                "pt" to "em aberto",
                "sl" to "odprto",
            ),
            "all_done" to mapOf(
                "de" to "Alles da!",
                "en" to "All done!",
                "fr" to "Tout prêt!",
                "es" to "¡Todo!",
                "nl" to "Alles klaar!",
                "hu" to "Minden megvan!",
                "nb" to "Alt er klart!",
                "pl" to "Wszystko jest!",
                "pt" to "Tudo pronto!",
                "sl" to "Vse je tu!",
            ),
            "all_completed" to mapOf(
                "de" to "Alles erledigt!",
                "en" to "All completed!",
                "fr" to "Tout terminé!",
                "es" to "¡Todo hecho!",
                "nl" to "Alles klaar!",
                "hu" to "Minden kész!",
                "nb" to "Alt fullført!",
                "pl" to "Wszystko gotowe!",
                "pt" to "Tudo concluído!",
                "sl" to "Vse opravljeno!",
            ),
            "no_items" to mapOf(
                "de" to "Keine Artikel",
                "en" to "No items",
                "fr" to "Aucun article",
                "es" to "Sin artículos",
                "nl" to "Geen artikelen",
                "hu" to "Nincs tétel",
                "nb" to "Ingen varer",
                "pl" to "Brak pozycji",
                "pt" to "Nenhum item",
                "sl" to "Ni artiklov",
            ),
            "more" to mapOf(
                "de" to "weitere",
                "en" to "more",
                "fr" to "autres",
                "es" to "más",
                "nl" to "meer",
                "hu" to "további",
                "nb" to "flere",
                "pl" to "więcej",
                "pt" to "mais",
                "sl" to "več",
            ),
            "daily_recipe" to mapOf(
                "de" to "Rezept des Tages",
                "en" to "Recipe of the Day",
                "fr" to "Recette du jour",
                "es" to "Receta del día",
                "nl" to "Recept van de dag",
                "hu" to "A nap receptje",
                "nb" to "Dagens oppskrift",
                "pl" to "Przepis dnia",
                "pt" to "Receita do dia",
                "sl" to "Recept dneva",
            ),
            "no_recipes" to mapOf(
                "de" to "Keine Rezepte",
                "en" to "No recipes",
                "fr" to "Aucune recette",
                "es" to "Sin recetas",
                "nl" to "Geen recepten",
                "hu" to "Nincsenek receptek",
                "nb" to "Ingen oppskrifter",
                "pl" to "Brak przepisów",
                "pt" to "Nenhuma receita",
                "sl" to "Ni receptov",
            ),
        )
    }
}

// MARK: - Store

/**
 * Reader + Writer für den persistenten Widget-State. Verwendet einen
 * einzigen `DataStore<Preferences>` namens `mealie_widgets`. Iso zur
 * Swift-Variante, die ein `UserDefaults(suiteName: appGroupID)`-Suite nutzt.
 */
object WidgetSharedStore {

    // Public extension on Context so we kriegen einen App-weiten Singleton
    // (DataStore lebt am Application-Lifecycle, nicht am Activity-Lifecycle).
    private val Context.dataStore: DataStore<Preferences> by preferencesDataStore(
        name = "mealie_widgets",
    )

    // Keys — exakt die Swift-UserDefault-Keys.
    private val KEY_LANGUAGE = stringPreferencesKey("widgetLanguage")
    private val KEY_MEALPLAN = stringPreferencesKey("widgetMealplan")
    private val KEY_SHOPPING = stringPreferencesKey("widgetShoppingList")
    private val KEY_DAILY = stringPreferencesKey("widgetDailyRecipes")

    private val JSON = Json {
        ignoreUnknownKeys = true
        encodeDefaults = false
    }

    // ---- Reader (suspend, vom Glance-Composable via runBlocking gepullt) ----

    /** App-Sprache; noch nie gestartet → Systemsprache (falls unterstützt), sonst Englisch. */
    suspend fun loadLanguage(context: Context): String {
        val prefs = context.dataStore.data.first()
        val saved = prefs[KEY_LANGUAGE]
        if (!saved.isNullOrEmpty()) return saved
        var sys = java.util.Locale.getDefault().language.lowercase()
        if (sys == "no") sys = "nb"
        return if (sys in SUPPORTED_LANGUAGES) sys else "en"
    }

    private val SUPPORTED_LANGUAGES =
        setOf("de", "en", "fr", "es", "nl", "hu", "nb", "pl", "pt", "sl")

    suspend fun loadMealplan(context: Context): List<WidgetMealEntry> {
        val raw = context.dataStore.data.first()[KEY_MEALPLAN] ?: return emptyList()
        return runCatching { JSON.decodeFromString<List<WidgetMealEntry>>(raw) }.getOrDefault(emptyList())
    }

    suspend fun loadShoppingItems(context: Context): List<WidgetShoppingItem> {
        val raw = context.dataStore.data.first()[KEY_SHOPPING] ?: return emptyList()
        return runCatching { JSON.decodeFromString<List<WidgetShoppingItem>>(raw) }.getOrDefault(emptyList())
    }

    suspend fun loadDailyRecipes(context: Context): List<WidgetRecipeSummary> {
        val raw = context.dataStore.data.first()[KEY_DAILY] ?: return emptyList()
        return runCatching { JSON.decodeFromString<List<WidgetRecipeSummary>>(raw) }.getOrDefault(emptyList())
    }

    /**
     * Wählt das „Rezept des Tages" — deterministisch per Tagesindex
     * (Calendar.DAY_OF_YEAR + Year-Offset für jahresübergreifenden
     * gleichmäßigen Lauf). Iso zum Swift-`ordinality(of:.day, in:.era)`.
     */
    suspend fun dailyRecipe(context: Context): WidgetRecipeSummary? {
        val recipes = loadDailyRecipes(context)
        if (recipes.isEmpty()) return null
        val cal = Calendar.getInstance()
        // Era ist auf iOS effektiv "Tage seit Jahr 1". Wir simulieren das mit
        // dayOfYear + year*366 — die genauen Zahlen sind irrelevant, wichtig
        // ist nur ein streng monoton wachsender Tagesindex.
        val dayIndex = cal.get(Calendar.YEAR) * 366L + cal.get(Calendar.DAY_OF_YEAR).toLong()
        val mod = (dayIndex % recipes.size).toInt()
        val idx = if (mod < 0) mod + recipes.size else mod
        return recipes[idx]
    }

    // ---- Filter-Helpers, 1:1 zu Swift ----

    fun entriesForDateString(dateString: String, from: List<WidgetMealEntry>): List<WidgetMealEntry> {
        val order = mapOf("breakfast" to 0, "lunch" to 1, "dinner" to 2)
        return from
            .filter { it.date == dateString }
            .sortedBy { order[it.slot] ?: 3 }
    }

    fun dateString(date: Date): String {
        val f = SimpleDateFormat("yyyy-MM-dd", Locale.US)
        f.timeZone = TimeZone.getTimeZone("UTC")
        return f.format(date)
    }

    // ---- Writer (von MainActivity über MethodChannel aufgerufen) ----

    suspend fun saveLanguage(context: Context, lang: String) {
        context.dataStore.edit { it[KEY_LANGUAGE] = lang }
    }

    suspend fun saveMealplanRaw(context: Context, json: String) {
        context.dataStore.edit { it[KEY_MEALPLAN] = json }
    }

    suspend fun saveShoppingRaw(context: Context, json: String) {
        context.dataStore.edit { it[KEY_SHOPPING] = json }
    }

    suspend fun saveDailyRaw(context: Context, json: String) {
        context.dataStore.edit { it[KEY_DAILY] = json }
    }
}
