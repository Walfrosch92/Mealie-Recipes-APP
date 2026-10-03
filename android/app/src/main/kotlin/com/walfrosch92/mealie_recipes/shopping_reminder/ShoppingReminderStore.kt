package com.walfrosch92.mealie_recipes.shopping_reminder

import android.content.Context
import kotlinx.serialization.Serializable
import kotlinx.serialization.encodeToString
import kotlinx.serialization.json.Json

// ----------------------------------------------------------------------------
// ShoppingReminderStore — persistiert die bis zu 3 gespeicherten Standorte
// (Issue #29 "Erinnere mich zum Einkaufen") in einer eigenen, PLAIN
// SharedPreferences-Datei (bewusst NICHT die DataStore<Preferences> von
// WidgetSharedStore — der GeofenceBroadcastReceiver braucht einen schnellen
// SYNCHRONEN Read in onReceive, ohne Coroutine-Overhead).
//
// Gebraucht für:
//   • Neu-Registrierung der Geofences nach einem Geräte-Neustart (Android
//     verwirft alle Geofence-Registrierungen bei Reboot) — siehe
//     ShoppingReminderBootReceiver.
//   • Anzeigenamen-Lookup für den Notification-Text im
//     GeofenceBroadcastReceiver (die GeofencingEvent liefert nur die
//     requestId/Geofence-id zurück, nicht den Klartextnamen).
// ----------------------------------------------------------------------------

@Serializable
data class ReminderLocation(
    val id: String,
    val name: String,
    val lat: Double,
    val lng: Double,
)

object ShoppingReminderStore {
    private const val PREFS_NAME = "shopping_reminder"
    private const val KEY_LOCATIONS = "locations"
    private const val KEY_LAST_NOTIFIED_AT = "lastNotifiedAtMillis"

    // Sperrzeit PRO STANDORT (User-Wunsch 2026-10-02): derselbe Standort
    // erinnert höchstens einmal pro Stunde, verschiedene Standorte
    // unabhängig voneinander. Schlüssel: KEY_LAST_NOTIFIED_AT + "_" + id.
    private const val COOLDOWN_MILLIS = 60L * 60L * 1000L

    private val JSON = Json { ignoreUnknownKeys = true }

    fun save(context: Context, locations: List<ReminderLocation>) {
        context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            .edit()
            .putString(KEY_LOCATIONS, JSON.encodeToString(locations))
            .apply()
    }

    fun load(context: Context): List<ReminderLocation> {
        val raw = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            .getString(KEY_LOCATIONS, null) ?: return emptyList()
        return runCatching {
            JSON.decodeFromString<List<ReminderLocation>>(raw)
        }.getOrDefault(emptyList())
    }

    fun locationName(context: Context, id: String): String? =
        load(context).firstOrNull { it.id == id }?.name

    /**
     * true, wenn für DIESEN Standort seit der letzten gezeigten
     * Benachrichtigung >= 1h vergangen ist (Sperrzeit pro Standort — zwei
     * verschiedene Geschäfte innerhalb einer Stunde erinnern beide).
     */
    fun canNotifyNow(context: Context, locationId: String): Boolean {
        val last = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            .getLong(KEY_LAST_NOTIFIED_AT + "_" + locationId, 0L)
        return System.currentTimeMillis() - last >= COOLDOWN_MILLIS
    }

    fun markNotified(context: Context, locationId: String) {
        context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            .edit()
            .putLong(KEY_LAST_NOTIFIED_AT + "_" + locationId, System.currentTimeMillis())
            .apply()
    }
}
