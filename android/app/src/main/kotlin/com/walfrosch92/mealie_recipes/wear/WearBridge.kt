package com.walfrosch92.mealie_recipes.wear

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Handler
import android.os.Looper
import com.google.android.gms.wearable.PutDataMapRequest
import com.google.android.gms.wearable.PutDataRequest
import com.google.android.gms.wearable.Wearable
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.tasks.await

/**
 * Phone-Seite der Wear-OS-Timer-/Kochmodus-Bridge.
 *
 * Schreibt die aktuell laufenden/pausierten Timer, den Kochmodus-Navigations-
 * zustand und die offene Einkaufsliste als DataItems in den Wearable Data
 * Layer; die Uhr (gleicher applicationId) liest sie und rendert daraus die
 * Anzeige. Empfängt umgekehrt über [PhoneWearListenerService] die
 * Steuer-Aktionen der Uhr (Timer pause/resume/stop, Kochschritt vor/zurück,
 * Einkaufsliste abhaken) und relayed sie über den MethodChannel an Flutter.
 *
 * Die App und die Wear-OS-App MÜSSEN denselben applicationId und Signing-Key
 * haben — sonst stellt Google Play sie nicht als Paar zu und der Data Layer
 * verweigert die Kommunikation.
 */
object WearBridge {
    const val TIMERS_PATH = "/mealie_timers"
    const val COOKING_PATH = "/mealie_cooking"
    const val SHOPPING_PATH = "/mealie_shopping"
    const val LANGUAGE_PATH = "/mealie_language"
    const val ACTION_PATH = "/mealie_timer/action"
    const val COOKING_ACTION_PATH = "/mealie_cooking/action"
    const val SHOPPING_ACTION_PATH = "/mealie_shopping/action"
    const val FINISHED_PATH = "/mealie_timer/finished"

    /** Vom MainActivity beim Engine-Setup gesetzt (Prozess-statisch). */
    @Volatile
    var channel: MethodChannel? = null

    private val mainHandler = Handler(Looper.getMainLooper())

    /** Schreibt/aktualisiert ALLE laufenden/pausierten Timer als EIN DataItem.
     *  `json` = JSON-Array von {id,timerName,recipeName,endDateMillis,
     *  remainingSeconds,totalSeconds,isPaused} — die Uhr blättert per
     *  Wischgeste durch. */
    fun updateTimers(context: Context, json: String) {
        val req = PutDataMapRequest.create(TIMERS_PATH).apply {
            dataMap.putString("json", json)
            // Erzwingt einen DataItem-Change auch wenn sonst alle Felder gleich
            // wären (z.B. nur ein Pause-Toggle) — sonst feuert onDataChanged nicht.
            dataMap.putLong("updatedAt", System.currentTimeMillis())
        }.asPutDataRequest().setUrgent()
        Wearable.getDataClient(context).putDataItem(req)
    }

    /** Entfernt das Timer-DataItem (keine aktiven/pausierten Timer mehr). */
    fun clearTimers(context: Context) = deletePath(context, TIMERS_PATH)

    /** Meldet der Uhr: Kochmodus aktiv, mit Vor/Zurück-Verfügbarkeit für den
     *  aktuellen Kochschritt. */
    fun updateCooking(context: Context, canBack: Boolean, canNext: Boolean) {
        val req = PutDataMapRequest.create(COOKING_PATH).apply {
            dataMap.putBoolean("active", true)
            dataMap.putBoolean("canBack", canBack)
            dataMap.putBoolean("canNext", canNext)
            dataMap.putLong("updatedAt", System.currentTimeMillis())
        }.asPutDataRequest().setUrgent()
        Wearable.getDataClient(context).putDataItem(req)
    }

    /** Kochmodus auf der Uhr beenden — sie fällt zurück auf die Einkaufsliste. */
    fun clearCooking(context: Context) = deletePath(context, COOKING_PATH)

    /** Schreibt/aktualisiert die offene Einkaufsliste. `json` = JSON-Array von
     *  `{"name": "..."}`-Objekten (Anzeigetexte der offenen Artikel). */
    fun updateShopping(context: Context, json: String) {
        val req = PutDataMapRequest.create(SHOPPING_PATH).apply {
            dataMap.putString("json", json)
            dataMap.putLong("updatedAt", System.currentTimeMillis())
        }.asPutDataRequest().setUrgent()
        Wearable.getDataClient(context).putDataItem(req)
    }

    /** Entfernt das Einkaufslisten-DataItem. */
    fun clearShopping(context: Context) = deletePath(context, SHOPPING_PATH)

    /** Spiegelt die in der App gewählte Sprache auf die Uhr — unabhängig von
     *  deren Systemsprache (siehe WearStrings auf der Wear-Seite). */
    fun updateLanguage(context: Context, lang: String) {
        val req = PutDataMapRequest.create(LANGUAGE_PATH).apply {
            dataMap.putString("lang", lang)
            dataMap.putLong("updatedAt", System.currentTimeMillis())
        }.asPutDataRequest().setUrgent()
        Wearable.getDataClient(context).putDataItem(req)
    }

    /** Der Uhr melden, dass Timer [id] abgelaufen ist (läuten/vibrieren). Die id
     *  lässt die Uhr GENAU dessen selbst geplanten Exact-Alarm canceln (sonst
     *  läutet er kurz danach nochmal) — andere, weiter laufende Timer bleiben
     *  unberührt. */
    fun sendTimerFinished(context: Context, id: Int) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val nodes = Wearable.getNodeClient(context).connectedNodes.await()
                val payload = "$id".toByteArray(Charsets.UTF_8)
                val mc = Wearable.getMessageClient(context)
                for (n in nodes) {
                    mc.sendMessage(n.id, FINISHED_PATH, payload).await()
                }
            } catch (_: Exception) {
                // best-effort
            }
        }
    }

    private fun deletePath(context: Context, path: String) {
        val uri = Uri.Builder()
            .scheme(PutDataRequest.WEAR_URI_SCHEME)
            .path(path)
            .build()
        Wearable.getDataClient(context).deleteDataItems(uri)
    }

    /**
     * Relayed eine von der Uhr empfangene Steuer-Aktion an Flutter. Läuft der
     * Flutter-Engine (während ein Timer aktiv ist hält der Foreground-Service
     * den Prozess am Leben), wird sie direkt über den Channel angewandt; sonst
     * holt sie wenigstens die App in den Vordergrund.
     */
    fun dispatchAction(context: Context, action: String, id: Int) {
        val ch = channel
        if (ch != null) {
            mainHandler.post {
                ch.invokeMethod("action", mapOf("action" to action, "id" to id))
            }
            return
        }
        // Fallback: Engine nicht erreichbar → App starten, damit der Nutzer den
        // Timer in-app steuern kann.
        val launch = context.packageManager.getLaunchIntentForPackage(context.packageName)
        launch?.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        launch?.let { context.startActivity(it) }
    }

    /** Relayed eine Kochschritt-Navigation (`next`/`previous`) an Flutter. */
    fun dispatchCookingAction(context: Context, action: String) {
        val ch = channel
        if (ch != null) {
            mainHandler.post {
                ch.invokeMethod("cookingAction", mapOf("action" to action))
            }
            return
        }
        val launch = context.packageManager.getLaunchIntentForPackage(context.packageName)
        launch?.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        launch?.let { context.startActivity(it) }
    }

    /** Relayed das Abhaken eines Einkaufslisten-Artikels an Flutter. */
    fun dispatchShoppingAction(context: Context, itemId: String) {
        val ch = channel
        android.util.Log.i("WearShop", "dispatchShoppingAction id=$itemId channelReady=${ch != null}")
        if (ch != null) {
            mainHandler.post {
                ch.invokeMethod("shoppingAction", mapOf("itemId" to itemId))
            }
            return
        }
        val launch = context.packageManager.getLaunchIntentForPackage(context.packageName)
        launch?.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        launch?.let { context.startActivity(it) }
    }
}