package com.walfrosch92.mealie_recipes.wear

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import androidx.core.app.NotificationCompat
import androidx.wear.ongoing.OngoingActivity
import androidx.wear.ongoing.Status
import com.walfrosch92.mealie_recipes.wear.presentation.MainActivity

/**
 * Zeigt den laufenden Timer als OngoingActivity im Wear-OS-Smart-Stack — das
 * direkte Pendant zur iOS Live Activity auf der Apple Watch. Der Countdown
 * tickt dank [Status.TimerPart] / Chronometer von selbst, ohne dass das Handy
 * jede Sekunde pushen muss.
 */
object OngoingTimerNotifier {
    private const val CHANNEL_ID = "mealie_timer"
    private const val NOTIF_ID = 4711

    fun show(context: Context, state: WearTimerState, lang: String) {
        ensureChannel(context, lang)

        val tapIntent = Intent(context, MainActivity::class.java)
            .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP)
        val pending = PendingIntent.getActivity(
            context, 0, tapIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )

        val builder = NotificationCompat.Builder(context, CHANNEL_ID)
            .setSmallIcon(R.drawable.ic_timer)
            .setContentTitle(state.name)
            .setContentText(if (state.recipeName.isNotEmpty()) state.recipeName else null)
            .setOngoing(true)
            .setCategory(NotificationCompat.CATEGORY_STOPWATCH)
            .setContentIntent(pending)

        if (!state.isPaused) {
            // Selbst-tickender Countdown auch in der aufgeklappten Notification.
            builder.setUsesChronometer(true)
                .setChronometerCountDown(true)
                .setWhen(state.endMillis)
                .setShowWhen(true)
        } else {
            builder.setUsesChronometer(false)
                .setContentText(
                    (if (state.recipeName.isNotEmpty()) state.recipeName + " · " else "") +
                        "⏸ " + state.displayTime(),
                )
        }

        // Status für die kompakte Smart-Stack-Darstellung: TimerPart zählt live
        // bis endMillis herunter; pausiert zeigen wir die statische Restzeit.
        val status = if (!state.isPaused) {
            Status.Builder()
                .addTemplate("#timer#")
                .addPart("timer", Status.TimerPart(state.endMillis))
                .build()
        } else {
            Status.Builder()
                .addTemplate(WearStrings.t("pause", lang) + " " + state.displayTime())
                .build()
        }

        val ongoing = OngoingActivity.Builder(context, NOTIF_ID, builder)
            .setStaticIcon(R.drawable.ic_timer)
            .setTouchIntent(pending)
            .setStatus(status)
            .build()
        ongoing.apply(context)

        val nm = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        nm.notify(NOTIF_ID, builder.build())
    }

    fun cancel(context: Context) {
        val nm = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        nm.cancel(NOTIF_ID)
    }

    // `createNotificationChannel` mit derselben CHANNEL_ID aktualisiert bei
    // erneutem Aufruf u.a. den Namen eines bereits existierenden Kanals — daher
    // hier bewusst UNBEDINGT (nicht nur beim ersten Mal) aufgerufen, damit ein
    // Sprachwechsel den in den System-Einstellungen sichtbaren Kanalnamen
    // nachträglich aktualisiert.
    private fun ensureChannel(context: Context, lang: String) {
        val nm = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        val ch = NotificationChannel(
            CHANNEL_ID,
            WearStrings.t("channelTimer", lang),
            NotificationManager.IMPORTANCE_LOW,
        ).apply { setShowBadge(false) }
        nm.createNotificationChannel(ch)
    }
}