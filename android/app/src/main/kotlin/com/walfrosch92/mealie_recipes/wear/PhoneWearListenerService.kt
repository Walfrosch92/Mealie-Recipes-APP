package com.walfrosch92.mealie_recipes.wear

import com.google.android.gms.wearable.MessageEvent
import com.google.android.gms.wearable.WearableListenerService

/**
 * Empfängt Steuer-Aktionen (Timer pause/resume/stop, Kochschritt vor/zurück,
 * Einkaufsliste abhaken) von der Wear-OS-Uhr und reicht sie über [WearBridge]
 * an Flutter weiter. Das System startet diesen Service im App-Prozess, sobald
 * eine Nachricht auf dem registrierten Pfad eintrifft — auch wenn keine
 * Activity sichtbar ist.
 *
 * Wire-Format:
 *   • Timer    (`/mealie_timer/action`):    `"<action>:<timerId>"`  z.B. `"pause:3"`
 *   • Kochmodus (`/mealie_cooking/action`): `"next"` oder `"previous"`
 *   • Shopping (`/mealie_shopping/action`):  `"toggle:<itemId>"`
 */
class PhoneWearListenerService : WearableListenerService() {
    override fun onMessageReceived(event: MessageEvent) {
        val payload = String(event.data, Charsets.UTF_8)
        android.util.Log.i("WearShop", "phone onMessageReceived path=${event.path} payload=$payload")
        when (event.path) {
            WearBridge.ACTION_PATH -> {
                val action = payload.substringBefore(":").takeIf { it.isNotEmpty() } ?: return
                val id = payload.substringAfter(":").toIntOrNull() ?: return
                WearBridge.dispatchAction(applicationContext, action, id)
            }
            WearBridge.COOKING_ACTION_PATH -> {
                val action = payload.takeIf { it.isNotEmpty() } ?: return
                WearBridge.dispatchCookingAction(applicationContext, action)
            }
            WearBridge.SHOPPING_ACTION_PATH -> {
                // "toggle:<itemId>" — itemId (UUID) enthält keine Doppelpunkte.
                val itemId = payload.substringAfter(":").takeIf { it.isNotEmpty() } ?: return
                WearBridge.dispatchShoppingAction(applicationContext, itemId)
            }
        }
    }
}