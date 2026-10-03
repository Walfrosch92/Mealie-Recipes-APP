package com.walfrosch92.mealie_recipes.widgets

import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.sp
import androidx.glance.text.FontWeight
import androidx.glance.text.TextStyle
import androidx.glance.unit.ColorProvider as GlanceColorProvider
import androidx.glance.unit.FixedColorProvider

/**
 * Glance trennt `unit.ColorProvider` (Interface) und die Factory-Funktion
 * `color.ColorProvider(Color)`. Die Factory-Funktion-Variante ist seit
 * Glance 1.0 stable, aber es gibt einen Naming-Konflikt wenn beide gleichzeitig
 * importiert sind. Wir nehmen den expliziten `FixedColorProvider`-Konstruktor
 * — er ist in `androidx.glance.unit` und Compose-friendly.
 */
internal fun cp(color: Color): GlanceColorProvider = FixedColorProvider(color)

// ----------------------------------------------------------------------------
// WidgetTheme — Compose/Glance-Pendant zu den SwiftUI-`Color`s + `Font`-Stilen
// der iOS-Widgets. Glance bietet kein dynamisches Material-Theming an, also
// pinnen wir die Farben hart auf dieselben Werte wie auf iOS:
//
//   • Frühstück  → systemOrange   ≈ #FF9500
//   • Mittag     → systemGreen    ≈ #34C759
//   • Abend      → systemIndigo   ≈ #5856D6
//   • Sekundärtext → systemGray   ≈ #8E8E93
//   • Primärtext  → systemLabel   (light: #000, dark: #FFF — via OnSurface)
//   • Akzent-Blau (Mealplan „Morgen") → systemBlue ≈ #007AFF
//
// Glance Text rendert Plain-Color-States; das System-Dark-Mode-Switching macht
// die `GlanceTheme`-Material3-Wrapper. Wo wir feste Akzentfarben brauchen,
// nutzen wir `ColorProvider(Color.…)` direkt.
// ----------------------------------------------------------------------------

object WidgetTheme {
    val OrangeAccent = Color(0xFFFF9500)
    val GreenAccent = Color(0xFF34C759)
    val IndigoAccent = Color(0xFF5856D6)
    val BlueAccent = Color(0xFF007AFF)
    val SecondaryText = Color(0xFF8E8E93)
    val PrimaryText = Color(0xFF1C1C1E)
    val PrimaryTextDark = Color(0xFFF2F2F7)
    val GreenBadgeBg = Color(0xCC34C759)
    val OrangeBadgeBg = Color(0x26FF9500) // 15% opacity

    // Slot-Mapping — iOS-Original verwendet SF-Symbol-Strings, hier mappen
    // wir auf die im `drawable/` abgelegten Vector-Drawables.
    data class SlotVisual(val drawableRes: Int, val color: Color)

    fun slotVisual(slot: String): SlotVisual = when (slot) {
        "breakfast" -> SlotVisual(
            drawableRes = com.walfrosch92.mealie_recipes.R.drawable.ic_widget_breakfast,
            color = OrangeAccent,
        )
        "lunch" -> SlotVisual(
            drawableRes = com.walfrosch92.mealie_recipes.R.drawable.ic_widget_lunch,
            color = GreenAccent,
        )
        "dinner" -> SlotVisual(
            drawableRes = com.walfrosch92.mealie_recipes.R.drawable.ic_widget_dinner,
            color = IndigoAccent,
        )
        else -> SlotVisual(
            drawableRes = com.walfrosch92.mealie_recipes.R.drawable.ic_widget_dot,
            color = SecondaryText,
        )
    }

    // Text-Stile — Glance-`TextStyle` ist ein eingeschränkter Strict-Subset
    // von Compose-Foundation (kein lineHeight, kein letterSpacing). Wir
    // mappen die Swift-`.caption2`/`.caption`/`.headline` auf passende sp-Werte.
    val Caption2 = TextStyle(fontSize = 11.sp, color = cp(SecondaryText))
    val Caption2Bold = TextStyle(fontSize = 11.sp, fontWeight = FontWeight.Bold, color = cp(SecondaryText))
    val Caption = TextStyle(fontSize = 12.sp, color = cp(PrimaryText))
    val CaptionSecondary = TextStyle(fontSize = 12.sp, color = cp(SecondaryText))
    val Subheadline = TextStyle(fontSize = 14.sp, fontWeight = FontWeight.Medium, color = cp(PrimaryText))
    val SubheadlineBold = TextStyle(fontSize = 14.sp, fontWeight = FontWeight.Bold, color = cp(PrimaryText))
    val Headline = TextStyle(fontSize = 16.sp, fontWeight = FontWeight.Bold, color = cp(PrimaryText))
    val Title3 = TextStyle(fontSize = 18.sp, fontWeight = FontWeight.Bold, color = cp(PrimaryText))
    val Body = TextStyle(fontSize = 14.sp, color = cp(PrimaryText))
    val BodySecondary = TextStyle(fontSize = 14.sp, color = cp(SecondaryText))
}
