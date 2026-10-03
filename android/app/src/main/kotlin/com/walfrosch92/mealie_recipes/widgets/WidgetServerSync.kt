package com.walfrosch92.mealie_recipes.widgets

import android.content.Context
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import kotlinx.serialization.encodeToString
import kotlinx.serialization.json.Json
import kotlinx.serialization.json.JsonArray
import kotlinx.serialization.json.JsonElement
import kotlinx.serialization.json.JsonObject
import kotlinx.serialization.json.JsonPrimitive
import kotlinx.serialization.json.booleanOrNull
import kotlinx.serialization.json.doubleOrNull
import kotlinx.serialization.json.jsonObject
import kotlinx.serialization.json.jsonPrimitive
import java.net.HttpURLConnection
import java.net.URL
import java.util.Calendar
import java.util.Date
import kotlin.math.abs
import kotlin.math.pow
import kotlin.math.roundToLong

/**
 * Holt Einkaufsliste und Essensplan selbst vom Mealie-Server, damit die
 * Widgets auch Änderungen aus der Webapp / von anderen Geräten zeigen, ohne
 * dass die App geöffnet wird. Aufgerufen aus `provideGlance` (Glance-Updates
 * alle 30 min über updatePeriodMillis). Fehler → der zuletzt gespeicherte
 * Stand bleibt (offline-first). Texte 1:1 wie in der App
 * (widget_sync_provider.dart: _shoppingItemText / _mapMealplan) — Pendant zu
 * WidgetServerSync in ios/MealieTimerWidget/WidgetSharedStore.swift.
 */
object WidgetServerSync {
    /** Höchstens alle 10 Minuten wirklich zum Server. */
    private const val MIN_INTERVAL_MS = 10 * 60 * 1000L
    private const val PREFS = "mealie_widget_sync"
    private val JSON = Json { ignoreUnknownKeys = true }

    private data class Access(
        val url: String,
        val token: String,
        val headers: Map<String, String>,
        val listId: String?,
        val exact: Boolean,
    )

    private fun access(context: Context): Access? {
        val raw = WidgetCredentials.load(context) ?: return null
        return try {
            val o = JSON.parseToJsonElement(raw).jsonObject
            val url = o.str("url")
            val token = o.str("token")
            if (url.isEmpty() || token.isEmpty()) return null
            Access(
                url = url.trimEnd('/'),
                token = token,
                headers = (o["headers"] as? JsonObject)?.mapValues { it.value.jsonPrimitive.content }
                    ?: emptyMap(),
                listId = o.str("listId").ifEmpty { null },
                exact = (o["exact"] as? JsonPrimitive)?.booleanOrNull ?: false,
            )
        } catch (_: Exception) {
            null
        }
    }

    private fun due(context: Context, key: String): Boolean {
        val last = context.getSharedPreferences(PREFS, Context.MODE_PRIVATE).getLong(key, 0L)
        return System.currentTimeMillis() - last >= MIN_INTERVAL_MS
    }

    private fun markFetched(context: Context, key: String) {
        context.getSharedPreferences(PREFS, Context.MODE_PRIVATE).edit()
            .putLong(key, System.currentTimeMillis()).apply()
    }

    private suspend fun get(a: Access, path: String): JsonElement? = withContext(Dispatchers.IO) {
        try {
            val conn = URL(a.url + path).openConnection() as HttpURLConnection
            conn.connectTimeout = 12_000
            conn.readTimeout = 12_000
            conn.setRequestProperty("Authorization", "Bearer ${a.token}")
            a.headers.forEach { (k, v) -> conn.setRequestProperty(k, v) }
            try {
                if (conn.responseCode != 200) return@withContext null
                val body = conn.inputStream.bufferedReader().use { it.readText() }
                JSON.parseToJsonElement(body)
            } finally {
                conn.disconnect()
            }
        } catch (_: Exception) {
            null
        }
    }

    /** [force]: Drossel ignorieren (Einkaufserinnerung braucht den aktuellen Stand). */
    suspend fun refreshShopping(context: Context, force: Boolean = false) {
        if (!force && !due(context, "shopping")) return
        val a = access(context) ?: return
        val listId = a.listId ?: return
        val list = get(a, "/api/households/shopping/lists/$listId") as? JsonObject ?: return
        val raw = list["listItems"] as? JsonArray ?: return
        val items = raw.mapNotNull { el ->
            val i = el as? JsonObject ?: return@mapNotNull null
            val id = i.str("id").ifEmpty { return@mapNotNull null }
            WidgetShoppingItem(
                id = id,
                name = ShoppingText.text(i, a.exact),
                checked = (i["checked"] as? JsonPrimitive)?.booleanOrNull ?: false,
                category = (i["label"] as? JsonObject)?.str("name")?.ifEmpty { null },
            )
        }
        WidgetSharedStore.saveShoppingRaw(context, JSON.encodeToString(items))
        markFetched(context, "shopping")
    }

    suspend fun refreshMealplan(context: Context) {
        if (!due(context, "mealplan")) return
        val a = access(context) ?: return
        val now = Date()
        val cal = Calendar.getInstance().apply { time = now; add(Calendar.DAY_OF_YEAR, 1) }
        val from = WidgetSharedStore.dateString(now)
        val to = WidgetSharedStore.dateString(cal.time)
        val body = get(a, "/api/households/mealplans?start_date=$from&end_date=$to&perPage=-1")
            as? JsonObject ?: return
        val raw = body["items"] as? JsonArray ?: return
        val l10n = WidgetL10n(WidgetSharedStore.loadLanguage(context))
        val entries = raw.mapNotNull { el ->
            val e = el as? JsonObject ?: return@mapNotNull null
            val date = e.str("date").ifEmpty { return@mapNotNull null }
            val slot = e.str("entryType")
            if (slot !in setOf("breakfast", "lunch", "dinner")) return@mapNotNull null
            val recipe = e["recipe"] as? JsonObject
            val name = recipe?.str("name")?.ifEmpty { null } ?: e.str("title")
            if (name.isEmpty()) return@mapNotNull null
            WidgetMealEntry(
                date = date,
                slot = slot,
                slotName = l10n.s(slot),
                recipeName = name,
                recipeId = recipe?.str("id")?.ifEmpty { null },
            )
        }
        WidgetSharedStore.saveMealplanRaw(context, JSON.encodeToString(entries))
        markFetched(context, "mealplan")
    }
}

internal fun JsonObject.str(key: String): String {
    val p = this[key] as? JsonPrimitive ?: return ""
    return if (p.isString) p.content.trim() else ""
}

/** Artikeltext wie in der App (_shoppingItemText), inkl. Brüche + Plural. */
internal object ShoppingText {
    private val FRACTIONS = listOf(
        0.1 to "⅒", 0.125 to "⅛", 0.1667 to "⅙", 0.2 to "⅕", 0.25 to "¼",
        0.3333 to "⅓", 0.375 to "⅜", 0.4 to "⅖", 0.5 to "½", 0.6 to "⅗",
        0.625 to "⅝", 0.6667 to "⅔", 0.75 to "¾", 0.8 to "⅘", 0.8333 to "⅚",
        0.875 to "⅞",
    )

    private fun round(v: Double, digits: Int): Double {
        val f = 10.0.pow(digits)
        return (v * f).roundToLong() / f
    }

    fun formatQuantity(q: Double): String {
        val clean = round(q, 3)
        if (clean == kotlin.math.truncate(clean)) return clean.toLong().toString()
        val whole = clean.toLong()
        val frac = clean - whole
        for ((value, glyph) in FRACTIONS) {
            if (abs(frac - value) < 0.015) return if (whole > 0) "$whole$glyph" else glyph
        }
        for ((value, glyph) in FRACTIONS) {
            if (frac < value) {
                if (value - frac < 0.03) return "< " + (if (whole > 0) "$whole$glyph" else glyph)
                break
            }
        }
        return String.format(java.util.Locale.US, "%.1f", clean)
    }

    fun shouldPluralize(q: Double): Boolean = round(q, 2) > 1

    fun text(i: JsonObject, exact: Boolean): String {
        val food = i["food"] as? JsonObject
        val unit = i["unit"] as? JsonObject
        val foodName = food?.str("name") ?: ""
        val note = i.str("note")
        val unitName = unit?.str("name") ?: ""
        val foodLeads = foodName.isNotEmpty() &&
            (note.isEmpty() || !note.lowercase().contains(foodName.lowercase()))
        val unitCarriesName = foodLeads && unitName.isNotEmpty() && foodName.length > 2 &&
            foodName.startsWith("(") && foodName.endsWith(")")
        val displayName = when {
            foodLeads -> if (unitCarriesName) "$unitName $foodName" else foodName
            note.isNotEmpty() -> note
            foodName.isNotEmpty() -> foodName
            else -> i.str("display").ifEmpty { "-" }
        }
        fun displayNamePlural(plural: Boolean): String {
            if (plural && foodLeads && !unitCarriesName) {
                val pl = food?.str("pluralName") ?: ""
                if (pl.isNotEmpty()) return pl
            }
            return displayName
        }
        val abbreviation = unit?.str("abbreviation") ?: ""
        val hasUnit = (abbreviation.isNotEmpty() || unitName.isNotEmpty()) && !unitCarriesName
        val rawQty = (i["quantity"] as? JsonPrimitive)?.doubleOrNull
        if (!exact) {
            if (hasUnit) return displayName
            val q = rawQty ?: 1.0
            val qty = if (q <= 0) 1.0 else q
            if (qty == 1.0) return displayName
            return "${formatQuantity(qty)} ${displayNamePlural(shouldPluralize(qty))}"
        }
        val qty = rawQty ?: 0.0
        val plural = shouldPluralize(qty)
        val unitPlural = unit?.str("pluralName") ?: ""
        val unitLabel = when {
            abbreviation.isNotEmpty() -> abbreviation
            plural && unitPlural.isNotEmpty() -> unitPlural
            else -> unitName
        }
        val parts = mutableListOf<String>()
        if (qty > 0) parts.add(formatQuantity(qty))
        if (hasUnit) parts.add(unitLabel)
        parts.add(displayNamePlural(plural))
        return parts.joinToString(" ")
    }
}
