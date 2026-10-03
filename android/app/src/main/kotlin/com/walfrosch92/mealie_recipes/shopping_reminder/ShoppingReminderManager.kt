package com.walfrosch92.mealie_recipes.shopping_reminder

import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.util.Log
import com.google.android.gms.location.Geofence
import com.google.android.gms.location.GeofencingClient
import com.google.android.gms.location.GeofencingRequest
import com.google.android.gms.location.LocationServices

// ----------------------------------------------------------------------------
// ShoppingReminderManager — registriert/entfernt die echten OS-Geofences für
// "Erinnere mich zum Einkaufen" (Issue #29). Aufgerufen von MainActivity
// (MethodChannel `mealie/shopping_reminder`) und von ShoppingReminderBootReceiver
// (Neu-Registrierung nach Geräte-Neustart, da Android Geofences bei Reboot
// verwirft).
//
// Radius fix 500 m (User-Wunsch 2026-10-02, vorher 100 m): Android liefert
// Hintergrund-Standorte nur wenige Male pro Stunde — bei 100 m kam die
// Erinnerung oft erst ~10 min NACH dem Ankommen. 500 m löst schon bei der
// Annäherung aus. GEOFENCE_TRANSITION_ENTER genügt: die
// eigentliche "hat die Liste offene Artikel"-Prüfung passiert erst im
// GeofenceBroadcastReceiver zum Trigger-Zeitpunkt.
// ----------------------------------------------------------------------------

object ShoppingReminderManager {
    private const val TAG = "ShoppingReminder"
    private const val RADIUS_METERS = 500f

    private fun client(context: Context): GeofencingClient =
        LocationServices.getGeofencingClient(context)

    private fun pendingIntent(context: Context): PendingIntent {
        val intent = Intent(context, GeofenceBroadcastReceiver::class.java)
        // FLAG_MUTABLE ist hier PFLICHT (nicht nur best practice) — das System
        // muss der Intent die GeofencingEvent-Extras selbst anhängen können.
        val flags = PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE
        return PendingIntent.getBroadcast(context, 0, intent, flags)
    }

    /**
     * Ersetzt ALLE bisherigen Geofences durch [locations] (leere Liste =
     * Funktion aus). Persistiert die Liste für Boot-Neu-Registrierung +
     * Notification-Namens-Lookup, auch wenn addGeofences() z. B. mangels
     * Berechtigung fehlschlägt (Dart-Seite hat die Berechtigung VOR dem
     * Aufruf bereits sichergestellt — best-effort hier).
     */
    fun setLocations(context: Context, locations: List<ReminderLocation>) {
        // Welche Standorte sind NEU? Nur für die gilt „schon drin → sofort
        // erinnern" (Standort direkt im Laden gespeichert). Beim bloßen
        // Neu-Registrieren (App-Start, Neustart, Update) NICHT — bei 500 m
        // liegt oft die eigene Wohnung in der Zone eines nahen Ladens, sonst
        // käme bei jedem App-Start eine Erinnerung.
        val knownIds = ShoppingReminderStore.load(context).map { it.id }.toSet()
        ShoppingReminderStore.save(context, locations)
        val pi = pendingIntent(context)
        client(context).removeGeofences(pi).addOnCompleteListener {
            if (locations.isEmpty()) return@addOnCompleteListener
            val (added, existing) = locations.partition { it.id !in knownIds }
            register(context, pi, added, initialEnter = true)
            register(context, pi, existing, initialEnter = false)
        }
    }

    private fun register(
        context: Context,
        pi: PendingIntent,
        locations: List<ReminderLocation>,
        initialEnter: Boolean,
    ) {
        if (locations.isEmpty()) return
        val geofences = locations.map { loc ->
            Geofence.Builder()
                .setRequestId(loc.id)
                .setCircularRegion(loc.lat, loc.lng, RADIUS_METERS)
                .setExpirationDuration(Geofence.NEVER_EXPIRE)
                .setTransitionTypes(Geofence.GEOFENCE_TRANSITION_ENTER)
                .build()
        }
        val request = GeofencingRequest.Builder()
            // 0 = kein Auslösen, nur weil man beim Registrieren schon drin ist.
            .setInitialTrigger(if (initialEnter) GeofencingRequest.INITIAL_TRIGGER_ENTER else 0)
            .addGeofences(geofences)
            .build()
        try {
            client(context).addGeofences(request, pi)
                .addOnFailureListener { e ->
                    Log.w(TAG, "addGeofences failed: ${e.message}")
                }
        } catch (e: SecurityException) {
            // Fehlende ACCESS_FINE_LOCATION/ACCESS_BACKGROUND_LOCATION —
            // die Dart-Seite fordert die Berechtigung zwar vorher an, aber
            // ein Widerruf zwischen Anfrage und diesem Aufruf ist möglich.
            Log.w(TAG, "addGeofences denied: ${e.message}")
        }
    }

    /** Nach Geräte-Neustart: die zuletzt bekannten Standorte neu registrieren. */
    fun reregisterAfterBoot(context: Context) {
        val saved = ShoppingReminderStore.load(context)
        if (saved.isNotEmpty()) setLocations(context, saved)
    }
}
