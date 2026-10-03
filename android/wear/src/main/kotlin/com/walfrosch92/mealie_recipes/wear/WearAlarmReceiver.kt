package com.walfrosch92.mealie_recipes.wear

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

/**
 * Feuert den Uhr-Alarm (Vibration + Ton), wenn ein selbst geplanter
 * Timer-Endzeitpunkt erreicht ist. Gesetzt/gecancelt von [WearAlarmScheduler]
 * (ein Alarm pro Timer-id — mehrere gleichzeitig laufende Timer läuten
 * unabhängig voneinander).
 */
class WearAlarmReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == ACTION_FIRE) {
            val id = intent.getIntExtra(EXTRA_TIMER_ID, -1)
            // Eigene Buchführung aufräumen (der zusätzliche `am.cancel` in
            // cancel() ist für den bereits gefeuerten One-Shot-Alarm ein
            // No-op) — ohne das würde ein SPÄTERER Timer mit DERSELBEN id
            // (neuer Countdown) fälschlich als „schon geplant" übersprungen
            // (siehe scheduledTriggers-Check in WearAlarmScheduler.schedule).
            if (id >= 0) WearAlarmScheduler.cancel(context.applicationContext, id)
            WearAlarm.fire(context.applicationContext)
        }
    }

    companion object {
        const val ACTION_FIRE = "com.walfrosch92.mealie_recipes.wear.ALARM_FIRE"
        const val EXTRA_TIMER_ID = "timerId"
    }
}
