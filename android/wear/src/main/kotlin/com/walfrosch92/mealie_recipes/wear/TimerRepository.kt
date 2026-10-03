package com.walfrosch92.mealie_recipes.wear

import android.content.Context
import com.google.android.gms.wearable.DataMap
import com.google.android.gms.wearable.DataMapItem
import com.google.android.gms.wearable.PutDataRequest
import com.google.android.gms.wearable.Wearable
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch
import kotlinx.coroutines.tasks.await
import org.json.JSONArray

/** Vom Handy gespiegelter Timer-Zustand (einer von ggf. mehreren — die Uhr
 *  blättert per Wischgeste durch). */
data class WearTimerState(
    val id: Int,
    val name: String,
    val recipeName: String,
    val endMillis: Long,
    val remainingSeconds: Int,
    val totalSeconds: Int,
    val isPaused: Boolean,
) {
    /** Aktuell verbleibende Sekunden — läuft (nicht pausiert) aus endMillis. */
    fun liveRemaining(now: Long = System.currentTimeMillis()): Int {
        if (isPaused) return remainingSeconds
        val secs = ((endMillis - now) / 1000L).toInt()
        return if (secs < 0) 0 else secs
    }

    fun displayTime(now: Long = System.currentTimeMillis()): String {
        val r = liveRemaining(now)
        val m = r / 60
        val s = r % 60
        return "%02d:%02d".format(m, s)
    }
}

/**
 * Zentraler Zustands-Halter der Wear-App. Sowohl die Compose-Activity als auch
 * der [WearListenerService] schreiben hier rein; UI und Tile lesen daraus.
 *
 * Gegenstück zur Phone-Seite [WearBridge]:
 *   • Handy schreibt DataItem `/mealie_timers` (JSON-Array) → hier geparst
 *     (parse()) — ALLE laufenden/pausierten Timer, nicht nur einer.
 *   • Uhr sendet `/mealie_timer/action` zurück → sendAction().
 */
object TimerRepository {
    const val TIMERS_PATH = "/mealie_timers"
    const val ACTION_PATH = "/mealie_timer/action"

    private val _state = MutableStateFlow<List<WearTimerState>>(emptyList())
    val state: StateFlow<List<WearTimerState>> = _state

    fun set(value: List<WearTimerState>) {
        _state.value = value
    }

    /** Max. tolerierte Abweichung zwischen gesendetem `endDateMillis` und der
     *  lokal berechneten Endzeit. Innerhalb davon gilt die Differenz als
     *  Zustellverzögerung (DataItems sind Store-and-Forward!) → absolute
     *  Endzeit verwenden. Darüber ist die Handy-Uhr grob verstellt (Emulator:
     *  „559 statt 10 min") → lokale Berechnung als Fallback. */
    private const val CLOCK_SKEW_TOLERANCE_MS = 30L * 60L * 1000L

    fun parse(map: DataMap): List<WearTimerState> = parseJson(map.getString("json", "[]"))

    private fun parseJson(json: String): List<WearTimerState> {
        return try {
            val arr = JSONArray(json)
            val out = ArrayList<WearTimerState>(arr.length())
            for (i in 0 until arr.length()) {
                val o = arr.getJSONObject(i)
                val remaining = o.optInt("remainingSeconds", 0)
                // Endzeit: bevorzugt das vom Handy gesendete absolute
                // `endDateMillis`. DataItems kommen Store-and-Forward an — war
                // die Uhr beim Timer-Start nicht erreichbar, ist
                // `remainingSeconds` beim Eintreffen bereits veraltet und
                // `now + remaining` läge um die Zustellverzögerung daneben
                // (Countdown zu lang, Exact-Alarm zu spät). Nur bei grob
                // abweichender Handy-Uhr (> Toleranz) fällt die Berechnung auf
                // die Uhr-eigene Zeitbasis zurück.
                val sentEnd = o.optLong("endDateMillis", 0L)
                val localEnd = System.currentTimeMillis() + remaining * 1000L
                val end = if (sentEnd > 0L &&
                    kotlin.math.abs(sentEnd - localEnd) <= CLOCK_SKEW_TOLERANCE_MS
                ) {
                    sentEnd
                } else {
                    localEnd
                }
                out.add(
                    WearTimerState(
                        id = o.optInt("id", -1),
                        name = o.optString("timerName", "Timer"),
                        recipeName = o.optString("recipeName", ""),
                        endMillis = end,
                        remainingSeconds = remaining,
                        totalSeconds = o.optInt("totalSeconds", 0),
                        isPaused = o.optBoolean("isPaused", false),
                    ),
                )
            }
            out
        } catch (_: Exception) {
            emptyList()
        }
    }

    /** Initialen Zustand vom Data Layer laden (z.B. beim Öffnen der App/Tile). */
    suspend fun loadInitial(context: Context) {
        try {
            val uri = android.net.Uri.Builder()
                .scheme(PutDataRequest.WEAR_URI_SCHEME)
                .path(TIMERS_PATH)
                .build()
            val items = Wearable.getDataClient(context).getDataItems(uri).await()
            var found: List<WearTimerState> = emptyList()
            for (i in 0 until items.count) {
                found = parse(DataMapItem.fromDataItem(items.get(i)).dataMap)
            }
            items.release()
            _state.value = found
        } catch (_: Exception) {
            // best-effort
        }
    }

    /** Steuer-Aktion (`pause`/`resume`/`stop`) an die Handy-App senden. */
    fun sendAction(context: Context, action: String, id: Int) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val nodes = Wearable.getNodeClient(context).connectedNodes.await()
                val payload = "$action:$id".toByteArray(Charsets.UTF_8)
                val mc = Wearable.getMessageClient(context)
                for (node in nodes) {
                    mc.sendMessage(node.id, ACTION_PATH, payload).await()
                }
            } catch (_: Exception) {
                // best-effort
            }
        }
    }
}