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

/** Vom Handy gespiegelter Kochmodus-Navigationszustand. `active == false`
 *  (Default) → die Uhr zeigt die Einkaufsliste statt der Vor/Zurück-Buttons. */
data class WearCookingState(
    val active: Boolean,
    val canBack: Boolean,
    val canNext: Boolean,
)

private val INACTIVE = WearCookingState(active = false, canBack = false, canNext = false)

/**
 * Hält den vom Handy gespiegelten Kochmodus-Navigationszustand. Gegenstück zur
 * Phone-Seite [WearBridge.updateCooking] (DataItem `/mealie_cooking`).
 * Vor/Zurück-Taps gehen per [sendStepAction] zurück ans Handy.
 */
object CookingRepository {
    const val COOKING_PATH = "/mealie_cooking"
    const val ACTION_PATH = "/mealie_cooking/action"

    private val _state = MutableStateFlow(INACTIVE)
    val state: StateFlow<WearCookingState> = _state

    fun set(value: WearCookingState?) {
        _state.value = value ?: INACTIVE
    }

    fun parse(map: DataMap): WearCookingState = WearCookingState(
        active = map.getBoolean("active", false),
        canBack = map.getBoolean("canBack", false),
        canNext = map.getBoolean("canNext", false),
    )

    /** Initialen Zustand vom Data Layer laden (App-Start). */
    suspend fun loadInitial(context: Context) {
        try {
            val uri = android.net.Uri.Builder()
                .scheme(PutDataRequest.WEAR_URI_SCHEME)
                .path(COOKING_PATH)
                .build()
            val items = Wearable.getDataClient(context).getDataItems(uri).await()
            var found = INACTIVE
            for (i in 0 until items.count) {
                found = parse(DataMapItem.fromDataItem(items.get(i)).dataMap)
            }
            items.release()
            _state.value = found
        } catch (_: Exception) {
            // best-effort
        }
    }

    /** Kochschritt-Navigation (`"next"`/`"previous"`) an die Handy-App senden. */
    fun sendStepAction(context: Context, action: String) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val nodes = Wearable.getNodeClient(context).connectedNodes.await()
                val payload = action.toByteArray(Charsets.UTF_8)
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
