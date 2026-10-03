package com.walfrosch92.mealie_recipes.wear

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build

/**
 * Plant EXAKTE Alarme direkt auf der Uhr zu den Timer-Endzeitpunkten — das
 * Pendant zu den selbst geplanten lokalen Notifications der Apple Watch
 * (UNTimeIntervalNotificationTrigger in ConnectivityManager.swift). Ein Alarm
 * PRO Timer-id, damit mehrere gleichzeitig laufende Timer unabhängig
 * voneinander zuverlässig läuten.
 *
 * Damit läutet die Uhr ZUVERLÄSSIG zum Ende, auch wenn die Handy-App
 * gekillt/suspended ist und deshalb kein `/mealie_timer/finished`-Signal mehr
 * schickt (genau die Lücke, die die Uhr vorher von der laufenden Handy-App
 * abhängig machte). Wird pro laufendem Timer gesetzt und bei dessen
 * Pause/Stop/Ende gecancelt.
 */
object WearAlarmScheduler {
    private const val BASE_REQUEST_CODE = 4712

    /** Zuletzt geplanter Trigger je Timer-id — verhindert Neu-Planen bei jedem
     *  Sekunden-Push des Handys (endMillis bleibt dabei ~konstant). */
    private val scheduledTriggers = mutableMapOf<Int, Long>()

    fun schedule(context: Context, id: Int, triggerAtMillis: Long) {
        if (triggerAtMillis <= System.currentTimeMillis()) return
        // Schon (nahezu) auf diese Zeit geplant → nichts tun.
        val existing = scheduledTriggers[id]
        if (existing != null && kotlin.math.abs(triggerAtMillis - existing) < 1500L) return
        scheduledTriggers[id] = triggerAtMillis
        val am = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val pi = pendingIntent(context, id)
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S && !am.canScheduleExactAlarms()) {
                // Ohne Exact-Alarm-Berechtigung wenigstens doze-tauglich (inexakt).
                am.setAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, triggerAtMillis, pi)
            } else {
                am.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, triggerAtMillis, pi)
            }
        } catch (_: SecurityException) {
            am.setAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, triggerAtMillis, pi)
        }
    }

    /** Cancelt den Alarm eines einzelnen Timers (Pause/Stop/Ablauf). */
    fun cancel(context: Context, id: Int) {
        scheduledTriggers.remove(id)
        val am = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        am.cancel(pendingIntent(context, id))
    }

    /** Cancelt ALLE aktuell geplanten Timer-Alarme (z.B. keine Timer mehr aktiv). */
    fun cancelAll(context: Context) {
        for (id in scheduledTriggers.keys.toList()) cancel(context, id)
    }

    /** Cancelt alle geplanten Alarme AUSSER den gegebenen ids — für Timer, die
     *  seit dem letzten Push pausiert wurden oder ganz weggefallen sind. */
    fun cancelExcept(context: Context, keepIds: Set<Int>) {
        for (id in scheduledTriggers.keys.toList()) {
            if (id !in keepIds) cancel(context, id)
        }
    }

    private fun pendingIntent(context: Context, id: Int): PendingIntent {
        val intent = Intent(context, WearAlarmReceiver::class.java)
            .setAction(WearAlarmReceiver.ACTION_FIRE)
            .putExtra(WearAlarmReceiver.EXTRA_TIMER_ID, id)
        return PendingIntent.getBroadcast(
            context,
            BASE_REQUEST_CODE + id,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
    }
}
