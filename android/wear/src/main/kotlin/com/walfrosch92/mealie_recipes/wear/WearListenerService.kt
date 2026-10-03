package com.walfrosch92.mealie_recipes.wear

import androidx.wear.tiles.TileService
import com.google.android.gms.wearable.DataEvent
import com.google.android.gms.wearable.DataEventBuffer
import com.google.android.gms.wearable.DataMapItem
import com.google.android.gms.wearable.MessageEvent
import com.google.android.gms.wearable.WearableListenerService
import com.walfrosch92.mealie_recipes.wear.tile.ShoppingTileService
import com.walfrosch92.mealie_recipes.wear.tile.TimerTileService

/**
 * Empfängt die vom Handy gepushten DataItems (Timer + Kochmodus-Navigation +
 * Einkaufsliste + App-Sprache) — auch wenn die Wear-App nicht geöffnet ist.
 * Aktualisiert die Repositories, zeigt/entfernt die Timer-OngoingActivity und
 * stößt Tile-Refreshes an.
 */
class WearListenerService : WearableListenerService() {
    override fun onDataChanged(dataEvents: DataEventBuffer) {
        var timerChanged = false
        var shoppingChanged = false
        var languageChanged = false

        for (event in dataEvents) {
            val item = event.dataItem
            val path = item.uri.path.orEmpty()
            when {
                path.startsWith(TimerRepository.TIMERS_PATH) -> {
                    timerChanged = true
                    if (event.type == DataEvent.TYPE_DELETED) {
                        TimerRepository.set(emptyList())
                        OngoingTimerNotifier.cancel(this)
                        WearAlarmScheduler.cancelAll(this)
                    } else if (event.type == DataEvent.TYPE_CHANGED) {
                        val list = TimerRepository.parse(
                            DataMapItem.fromDataItem(item).dataMap,
                        )
                        TimerRepository.set(list)

                        // Eigene Exact-Alarme je LAUFENDEM Timer setzen, damit die
                        // Uhr unabhängig vom Handy-Zustand läutet — pausierte/
                        // weggefallene ids werden aufgeräumt (cancelExcept).
                        val runningIds = mutableSetOf<Int>()
                        for (t in list) {
                            if (!t.isPaused) {
                                WearAlarmScheduler.schedule(this, t.id, t.endMillis)
                                runningIds.add(t.id)
                            }
                        }
                        WearAlarmScheduler.cancelExcept(this, runningIds)

                        // Smart-Stack-OngoingActivity zeigt nur den PRIMÄREN (als
                        // nächstes ablaufenden) Timer — analog zur Tile, die
                        // Wischliste in der App zeigt alle.
                        val primary = list.minByOrNull { it.liveRemaining() }
                        if (primary != null) {
                            OngoingTimerNotifier.show(this, primary, LanguageRepository.lang.value)
                        } else {
                            OngoingTimerNotifier.cancel(this)
                        }
                    }
                }
                path.startsWith(CookingRepository.COOKING_PATH) -> {
                    if (event.type == DataEvent.TYPE_DELETED) {
                        CookingRepository.set(null)
                    } else if (event.type == DataEvent.TYPE_CHANGED) {
                        CookingRepository.set(
                            CookingRepository.parse(
                                DataMapItem.fromDataItem(item).dataMap,
                            ),
                        )
                    }
                }
                path.startsWith(ShoppingRepository.SHOPPING_PATH) -> {
                    shoppingChanged = true
                    if (event.type == DataEvent.TYPE_DELETED) {
                        ShoppingRepository.set(emptyList())
                    } else if (event.type == DataEvent.TYPE_CHANGED) {
                        ShoppingRepository.set(
                            ShoppingRepository.parse(
                                DataMapItem.fromDataItem(item).dataMap,
                            ),
                        )
                    }
                }
                path.startsWith(LanguageRepository.LANGUAGE_PATH) -> {
                    languageChanged = true
                    if (event.type == DataEvent.TYPE_DELETED) {
                        LanguageRepository.set(null)
                    } else if (event.type == DataEvent.TYPE_CHANGED) {
                        LanguageRepository.set(
                            LanguageRepository.parse(DataMapItem.fromDataItem(item).dataMap),
                        )
                    }
                }
            }
        }
        dataEvents.release()

        // Betroffene Tiles neu rendern lassen — ein Sprachwechsel betrifft
        // BEIDE Tiles (deren Texte kommen aus WearStrings).
        try {
            if (timerChanged || languageChanged) {
                TileService.getUpdater(this).requestUpdate(TimerTileService::class.java)
            }
            if (shoppingChanged || languageChanged) {
                TileService.getUpdater(this).requestUpdate(ShoppingTileService::class.java)
            }
        } catch (_: Exception) {
            // best-effort
        }
    }

    // Timer-Ende vom Handy → läuten/vibrieren. Das System startet diesen Service
    // dafür auch, wenn die Wear-App nicht im Vordergrund ist.
    override fun onMessageReceived(event: MessageEvent) {
        if (event.path == "/mealie_timer/finished") {
            // Live-Signal vom (noch laufenden) Handy für GENAU diesen Timer: den
            // dafür selbst geplanten Alarm canceln, damit er nicht zusätzlich
            // feuert (Dedup) — andere, weiter laufende Timer bleiben unberührt.
            // Dann sofort läuten. Ist das Handy tot, kommt dieses Signal nie und
            // der selbst geplante Alarm übernimmt.
            val id = String(event.data, Charsets.UTF_8).toIntOrNull() ?: -1
            if (id >= 0) WearAlarmScheduler.cancel(applicationContext, id)
            WearAlarm.fire(applicationContext)
        }
    }
}