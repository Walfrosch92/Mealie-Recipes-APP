package com.walfrosch92.mealie_recipes.shopping_reminder

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

// ----------------------------------------------------------------------------
// ShoppingReminderBootReceiver — Android verwirft ALLE Geofence-
// Registrierungen bei einem Geräte-Neustart. Ohne diesen Receiver würde
// "Erinnere mich zum Einkaufen" (Issue #29) nach jedem Reboot stillschweigend
// aufhören zu funktionieren, bis der Nutzer die App zufällig erneut öffnet.
// ----------------------------------------------------------------------------

class ShoppingReminderBootReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        // Auch nach einem App-Update neu registrieren — sonst bliebe die
        // Erinnerung bis zum nächsten App-Start stumm, falls das System die
        // Geofences dabei verworfen hat.
        if (intent.action != Intent.ACTION_BOOT_COMPLETED &&
            intent.action != Intent.ACTION_MY_PACKAGE_REPLACED
        ) return
        ShoppingReminderManager.reregisterAfterBoot(context)
    }
}
