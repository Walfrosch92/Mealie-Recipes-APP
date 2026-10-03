package com.walfrosch92.mealie_recipes.wear

import android.content.Context
import com.google.android.gms.wearable.DataMap
import com.google.android.gms.wearable.DataMapItem
import com.google.android.gms.wearable.PutDataRequest
import com.google.android.gms.wearable.Wearable
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.tasks.await

/**
 * Hält die vom Handy gespiegelte App-Sprache (unabhängig von der
 * Systemsprache der Uhr — siehe [WearStrings]). Gegenstück zur Phone-Seite
 * `WearBridge.updateLanguage` (DataItem `/mealie_language`, Feld `lang`).
 * „de" als Default, solange noch kein Sync stattgefunden hat (deckt sich mit
 * dem bisherigen, fest deutschen Text).
 */
object LanguageRepository {
    const val LANGUAGE_PATH = "/mealie_language"

    private val _lang = MutableStateFlow("de")
    val lang: StateFlow<String> = _lang

    fun set(value: String?) {
        _lang.value = value?.takeIf { it.isNotEmpty() } ?: "de"
    }

    fun parse(map: DataMap): String = map.getString("lang", "de")

    /** Initiale Sprache vom Data Layer laden (App-/Tile-Start). */
    suspend fun loadInitial(context: Context) {
        try {
            val uri = android.net.Uri.Builder()
                .scheme(PutDataRequest.WEAR_URI_SCHEME)
                .path(LANGUAGE_PATH)
                .build()
            val items = Wearable.getDataClient(context).getDataItems(uri).await()
            var found = "de"
            for (i in 0 until items.count) {
                found = parse(DataMapItem.fromDataItem(items.get(i)).dataMap)
            }
            items.release()
            _lang.value = found
        } catch (_: Exception) {
            // best-effort
        }
    }
}
