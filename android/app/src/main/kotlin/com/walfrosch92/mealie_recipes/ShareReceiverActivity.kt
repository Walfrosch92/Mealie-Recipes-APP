package com.walfrosch92.mealie_recipes

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.os.Bundle

// Empfängt geteilte Links aus dem Android-Share-Sheet (z.B. Chrome „Teilen"
// → Rezept-URL) und reicht sie als `mealierecipes://import?url=…`-Deep-Link
// an MainActivity weiter — nutzt damit exakt dieselbe app_links/
// DeepLinkHandler-Pipeline wie Widget-Taps und Notification-Taps (siehe
// DeepLinkHandler._resolvePath, case 'import'). Eigene Activity statt
// MainActivity.onCreate/onNewIntent zu überladen: MainActivity ist an
// mehreren Stellen (Edge-to-Edge-Insets, Lockscreen) bewusst schlank
// gehalten, das soll so bleiben. Theme.NoDisplay: nie sichtbar, nur
// Weiterleitung + sofortiges finish().
class ShareReceiverActivity : Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val url = findUrl(intent)
        if (url != null) {
            val deepLink = Uri.parse("mealierecipes://import?url=${Uri.encode(url)}")
            startActivity(
                Intent(Intent.ACTION_VIEW, deepLink, this, MainActivity::class.java)
                    .addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP or Intent.FLAG_ACTIVITY_NEW_TASK)
            )
        }
        finish()
    }

    // Sucht den ersten http(s)-Link in allen Stellen, an denen Apps Text
    // mitgeben. Browser teilen die reine URL als EXTRA_TEXT (String). Koch-
    // Apps (Chefkoch, Kptn Cook, …) liefern oft formatierten Text
    // (CharSequence/Spanned → getStringExtra wäre null!), „Titel + Link" oder
    // den Link nur im Betreff bzw. in ClipData.
    private fun findUrl(intent: Intent?): String? {
        if (intent == null) return null
        val texts = mutableListOf<CharSequence?>(
            intent.getCharSequenceExtra(Intent.EXTRA_TEXT),
            intent.getStringExtra(Intent.EXTRA_SUBJECT),
            intent.dataString,
        )
        intent.clipData?.let { clip ->
            for (i in 0 until clip.itemCount) {
                val item = clip.getItemAt(i)
                texts.add(item.text)
                texts.add(item.uri?.toString())
            }
        }
        for (t in texts) {
            extractUrl(t?.toString())?.let { return it }
        }
        return null
    }

    // Erstes http(s)-Match; angehängte Satzzeichen („…Knoepfle.html)." oder
    // Anführungszeichen) gehören nicht zur URL.
    private fun extractUrl(text: String?): String? {
        if (text.isNullOrBlank()) return null
        val raw = Regex("https?://\\S+", RegexOption.IGNORE_CASE).find(text)?.value
            ?: return null
        return raw.trimEnd('.', ',', ';', ':', '!', '?', ')', ']', '}', '"', '\'', '»', '“', '”')
    }
}
