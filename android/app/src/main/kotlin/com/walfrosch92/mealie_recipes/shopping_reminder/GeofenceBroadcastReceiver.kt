package com.walfrosch92.mealie_recipes.shopping_reminder

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.util.Log
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import com.google.android.gms.location.Geofence
import com.google.android.gms.location.GeofencingEvent
import com.walfrosch92.mealie_recipes.R
import com.walfrosch92.mealie_recipes.widgets.WidgetSharedStore
import com.walfrosch92.mealie_recipes.widgets.WidgetServerSync
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withTimeoutOrNull

// ----------------------------------------------------------------------------
// GeofenceBroadcastReceiver — Ziel des GeofencingClient-PendingIntent für
// "Erinnere mich zum Einkaufen" (Issue #29). Läuft VOLLSTÄNDIG NATIV, ohne
// laufende Flutter-Engine — funktioniert daher auch bei komplett beendeter
// App (Android startet für die Zustellung nötigenfalls einen minimalen
// Prozess). Registriert in AndroidManifest.xml, NICHT an eine Activity
// gebunden.
//
// Zeigt die Benachrichtigung NUR, wenn die Einkaufsliste offene Artikel hat
// — dafür wird bewusst NICHT extra von Dart gepusht, sondern der ohnehin
// stets aktuelle Widget-Store gelesen (WidgetSharedStore, gefüttert von
// widget_sync_provider.dart bei jeder Listenänderung).
// ----------------------------------------------------------------------------

class GeofenceBroadcastReceiver : BroadcastReceiver() {
    companion object {
        private const val TAG = "ShoppingReminder"
        private const val CHANNEL_ID = "shopping_reminder"
    }

    override fun onReceive(context: Context, intent: Intent) {
        val event = GeofencingEvent.fromIntent(intent)
        if (event == null || event.hasError()) {
            Log.w(TAG, "geofencing event error: ${event?.errorCode}")
            return
        }
        if (event.geofenceTransition != Geofence.GEOFENCE_TRANSITION_ENTER) return
        val triggering = event.triggeringGeofences ?: return

        // goAsync: bis ~10 s Zeit, um die Einkaufsliste FRISCH vom Server zu
        // holen. Vorher zählte nur der zuletzt von App/Widget gespeicherte
        // Stand — wurde seitdem in der Webapp etwas auf die Liste gesetzt,
        // blieb die Erinnerung aus. Offline/Fehler → gespeicherter Stand.
        val pending = goAsync()
        CoroutineScope(Dispatchers.IO).launch {
            try {
                withTimeoutOrNull(8_000) {
                    WidgetServerSync.refreshShopping(context, force = true)
                }
                notifyIfNeeded(context, triggering)
            } catch (e: Exception) {
                Log.w(TAG, "reminder failed: ${e.message}")
            } finally {
                pending.finish()
            }
        }
    }

    private suspend fun notifyIfNeeded(context: Context, triggering: List<Geofence>) {
        val hasOpenItems =
            WidgetSharedStore.loadShoppingItems(context).any { !it.checked }
        if (!hasOpenItems) return

        val lang = WidgetSharedStore.loadLanguage(context)
        ensureChannel(context)
        val nm = NotificationManagerCompat.from(context)
        for (geofence in triggering) {
            // Sperrzeit pro Standort: max. 1 Benachrichtigung pro Stunde und
            // Standort.
            if (!ShoppingReminderStore.canNotifyNow(context, geofence.requestId)) continue
            val locationName =
                ShoppingReminderStore.locationName(context, geofence.requestId)
                    ?: continue
            val notification = NotificationCompat.Builder(context, CHANNEL_ID)
                .setSmallIcon(R.mipmap.ic_launcher)
                .setContentTitle(ShoppingReminderL10n.title(lang))
                .setContentText(ShoppingReminderL10n.body(lang, locationName))
                .setPriority(NotificationCompat.PRIORITY_DEFAULT)
                .setAutoCancel(true)
                .setContentIntent(openShoppingListIntent(context))
                .build()
            try {
                nm.notify(geofence.requestId.hashCode(), notification)
                // Sperrzeit nur starten, wenn wirklich etwas gezeigt wurde —
                // schlägt z. B. POST_NOTIFICATIONS fehl, darf der nächste
                // Eintritt sofort wieder versuchen.
                ShoppingReminderStore.markNotified(context, geofence.requestId)
            } catch (e: SecurityException) {
                // POST_NOTIFICATIONS (Android 13+) wurde nicht erteilt.
                Log.w(TAG, "notify denied: ${e.message}")
            }
        }
    }

    private fun openShoppingListIntent(context: Context): PendingIntent {
        // Derselbe mealierecipes://-Deep-Link wie Home-Widget/Notifications —
        // läuft über den bestehenden Intent-Filter in AndroidManifest.xml
        // (app_links/DeepLinkHandler löst ihn auf /shopping auf).
        val intent = Intent(Intent.ACTION_VIEW, Uri.parse("mealierecipes://shopping"))
            .setPackage(context.packageName)
        return PendingIntent.getActivity(
            context, 0, intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
    }

    private fun ensureChannel(context: Context) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return
        val nm = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        if (nm.getNotificationChannel(CHANNEL_ID) != null) return
        nm.createNotificationChannel(
            NotificationChannel(
                CHANNEL_ID,
                "Einkaufserinnerung",
                NotificationManager.IMPORTANCE_DEFAULT,
            ).apply {
                description = "Erinnerung, wenn du in der Nähe eines gespeicherten Standorts bist und die Einkaufsliste offene Artikel hat"
            },
        )
    }
}
