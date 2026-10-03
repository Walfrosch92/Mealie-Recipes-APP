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

/** Ein Einkaufslisten-Artikel auf der Uhr. */
data class WearShoppingItem(
    val id: String,
    val text: String,
    val category: String,
    /// 6-stelliger Hex (RRGGBB) der Kategorie-Farbe, vom Handy aufgelöst.
    val categoryColor: String,
    val checked: Boolean,
)

/**
 * Hält die vom Handy gespiegelten Einkaufslisten-Artikel (alle, inkl. abgehakt;
 * nach Kategorie gruppierbar). Gegenstück zur Phone-Seite
 * [WearBridge.updateShopping] (DataItem `/mealie_shopping`, Feld `json` = Array
 * von `{"id","text","category","checked"}`). Abhaken geht per [sendToggle]
 * zurück ans Handy.
 */
object ShoppingRepository {
    const val SHOPPING_PATH = "/mealie_shopping"
    const val ACTION_PATH = "/mealie_shopping/action"

    private val _items = MutableStateFlow<List<WearShoppingItem>>(emptyList())
    val items: StateFlow<List<WearShoppingItem>> = _items

    fun set(value: List<WearShoppingItem>) {
        _items.value = value
    }

    fun parse(map: DataMap): List<WearShoppingItem> = parseJson(map.getString("json", "[]"))

    private fun parseJson(json: String): List<WearShoppingItem> {
        return try {
            val arr = JSONArray(json)
            val out = ArrayList<WearShoppingItem>(arr.length())
            for (i in 0 until arr.length()) {
                val o = arr.getJSONObject(i)
                val id = o.optString("id", "")
                // Rückwärtskompat: altes Format hatte nur `name`.
                val text = o.optString("text", o.optString("name", "")).trim()
                if (text.isEmpty()) continue
                out.add(
                    WearShoppingItem(
                        id = id,
                        text = text,
                        category = o.optString("category", ""),
                        categoryColor = o.optString("categoryColor", ""),
                        checked = o.optBoolean("checked", false),
                    ),
                )
            }
            out
        } catch (_: Exception) {
            emptyList()
        }
    }

    /** Initialen Zustand vom Data Layer laden (App-/Tile-Start). */
    suspend fun loadInitial(context: Context) {
        try {
            val uri = android.net.Uri.Builder()
                .scheme(PutDataRequest.WEAR_URI_SCHEME)
                .path(SHOPPING_PATH)
                .build()
            val dataItems = Wearable.getDataClient(context).getDataItems(uri).await()
            var found: List<WearShoppingItem> = emptyList()
            for (i in 0 until dataItems.count) {
                found = parse(DataMapItem.fromDataItem(dataItems.get(i)).dataMap)
            }
            dataItems.release()
            _items.value = found
        } catch (_: Exception) {
            // best-effort
        }
    }

    /**
     * Abhaken/Wiederherstellen eines Artikels ans Handy melden (`toggle:<id>`).
     * Optimistisch lokal toggeln, damit die UI sofort reagiert; das Handy
     * pusht danach den echten Zustand zurück.
     */
    fun sendToggle(context: Context, id: String) {
        _items.value = _items.value.map {
            if (it.id == id) it.copy(checked = !it.checked) else it
        }
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val nodes = Wearable.getNodeClient(context).connectedNodes.await()
                android.util.Log.i("WearShop", "sendToggle id=$id → ${nodes.size} node(s)")
                val payload = "toggle:$id".toByteArray(Charsets.UTF_8)
                val mc = Wearable.getMessageClient(context)
                for (node in nodes) {
                    mc.sendMessage(node.id, ACTION_PATH, payload).await()
                    android.util.Log.i("WearShop", "  sent to ${node.displayName}")
                }
            } catch (e: Exception) {
                android.util.Log.w("WearShop", "sendToggle failed: ${e.message}")
            }
        }
    }
}
