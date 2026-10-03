package com.walfrosch92.mealie_recipes.wear

import android.content.Context
import android.media.RingtoneManager
import android.os.Build
import android.os.VibrationEffect
import android.os.Vibrator
import android.os.VibratorManager

/**
 * Löst die Uhr-Alarmierung aus, wenn ein Timer abgelaufen ist: kräftiges
 * Vibrationsmuster + (best-effort) ein kurzer Klingelton. Auf einer Uhr ist die
 * Vibration der primäre Alarm; Ton ist sekundär (viele Uhren haben keinen/leisen
 * Lautsprecher).
 */
object WearAlarm {
    fun fire(context: Context) {
        vibrate(context)
        playTone(context)
    }

    private fun vibrate(context: Context) {
        try {
            val vibrator: Vibrator = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                (context.getSystemService(Context.VIBRATOR_MANAGER_SERVICE) as VibratorManager)
                    .defaultVibrator
            } else {
                @Suppress("DEPRECATION")
                context.getSystemService(Context.VIBRATOR_SERVICE) as Vibrator
            }
            // Kräftiges, mehrfaches Muster (pause, an, aus, an, …).
            val pattern = longArrayOf(0, 500, 250, 500, 250, 700)
            vibrator.vibrate(VibrationEffect.createWaveform(pattern, -1))
        } catch (_: Exception) {
            // best-effort
        }
    }

    private fun playTone(context: Context) {
        try {
            val uri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM)
                ?: RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION)
            RingtoneManager.getRingtone(context, uri)?.play()
        } catch (_: Exception) {
            // best-effort
        }
    }
}
