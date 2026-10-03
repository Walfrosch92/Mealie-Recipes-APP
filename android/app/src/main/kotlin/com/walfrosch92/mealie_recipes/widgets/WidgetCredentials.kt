package com.walfrosch92.mealie_recipes.widgets

import android.content.Context
import android.security.keystore.KeyGenParameterSpec
import android.security.keystore.KeyProperties
import android.util.Base64
import java.security.KeyStore
import javax.crypto.Cipher
import javax.crypto.KeyGenerator
import javax.crypto.SecretKey
import javax.crypto.spec.GCMParameterSpec

/**
 * Zugangsdaten für die Selbst-Aktualisierung der Widgets (Server-URL, Token,
 * Zusatz-Header, aktive Liste, „exakte Mengen") — als JSON, verschlüsselt mit
 * einem AES-Schlüssel im Android Keystore (verlässt das Gerät nie). Nur der
 * Chiffretext liegt in den app-privaten SharedPreferences.
 */
object WidgetCredentials {
    private const val KEY_ALIAS = "mealie_widget_access"
    private const val PREFS = "mealie_widget_access"
    private const val PREF_DATA = "data"

    fun save(context: Context, json: String) {
        val prefs = context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
        if (json.isEmpty()) {
            prefs.edit().remove(PREF_DATA).apply()
            return
        }
        try {
            val cipher = Cipher.getInstance("AES/GCM/NoPadding")
            cipher.init(Cipher.ENCRYPT_MODE, key())
            val ct = cipher.doFinal(json.toByteArray(Charsets.UTF_8))
            val blob = cipher.iv + ct
            prefs.edit().putString(PREF_DATA, Base64.encodeToString(blob, Base64.NO_WRAP)).apply()
        } catch (e: Exception) {
            android.util.Log.w("WidgetCredentials", "save failed: ${e.message}")
        }
    }

    fun load(context: Context): String? {
        val raw = context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
            .getString(PREF_DATA, null) ?: return null
        return try {
            val blob = Base64.decode(raw, Base64.NO_WRAP)
            val iv = blob.copyOfRange(0, 12)
            val ct = blob.copyOfRange(12, blob.size)
            val cipher = Cipher.getInstance("AES/GCM/NoPadding")
            cipher.init(Cipher.DECRYPT_MODE, key(), GCMParameterSpec(128, iv))
            String(cipher.doFinal(ct), Charsets.UTF_8)
        } catch (e: Exception) {
            android.util.Log.w("WidgetCredentials", "load failed: ${e.message}")
            null
        }
    }

    private fun key(): SecretKey {
        val ks = KeyStore.getInstance("AndroidKeyStore").apply { load(null) }
        (ks.getKey(KEY_ALIAS, null) as? SecretKey)?.let { return it }
        val gen = KeyGenerator.getInstance(KeyProperties.KEY_ALGORITHM_AES, "AndroidKeyStore")
        gen.init(
            KeyGenParameterSpec.Builder(
                KEY_ALIAS,
                KeyProperties.PURPOSE_ENCRYPT or KeyProperties.PURPOSE_DECRYPT,
            )
                .setBlockModes(KeyProperties.BLOCK_MODE_GCM)
                .setEncryptionPaddings(KeyProperties.ENCRYPTION_PADDING_NONE)
                .setKeySize(256)
                .build(),
        )
        return gen.generateKey()
    }
}
