package com.walfrosch92.mealie_recipes.widgets

import android.content.Context
import android.content.Intent
import android.net.Uri
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.glance.GlanceId
import androidx.glance.GlanceModifier
import androidx.glance.GlanceTheme
import androidx.glance.Image
import androidx.glance.ImageProvider
import androidx.glance.LocalContext
import androidx.glance.action.clickable
import androidx.glance.appwidget.action.actionStartActivity
import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.SizeMode
import androidx.glance.appwidget.cornerRadius
import androidx.glance.appwidget.provideContent
import androidx.glance.background
import androidx.glance.layout.Alignment
import androidx.glance.layout.Box
import androidx.glance.layout.Column
import androidx.glance.layout.Row
import androidx.glance.layout.Spacer
import androidx.glance.layout.fillMaxHeight
import androidx.glance.layout.fillMaxSize
import androidx.glance.layout.fillMaxWidth
import androidx.glance.layout.height
import androidx.glance.layout.padding
import androidx.glance.layout.size
import androidx.glance.layout.width
import androidx.glance.text.Text
import androidx.glance.LocalSize
import com.walfrosch92.mealie_recipes.MainActivity
import com.walfrosch92.mealie_recipes.R
import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Date
import java.util.Locale

// ----------------------------------------------------------------------------
// MealplanGlanceWidget — 1:1 Port von `ios/MealieTimerWidget/MealplanWidget.swift`.
//
// SizeMode.Responsive mit drei Branches:
//   • small  ≤ 200×200dp  → nur „Heute" + bis zu 3 Slots
//   • medium ≤ 300×200dp  → Heute + Morgen nebeneinander
//   • large  > 300×200dp  → Heute + Morgen untereinander mit Slot-Labels
//
// Hintergrund-Tap → mealierecipes://mealplan
// Slot-Tap mit recipeId → mealierecipes://recipe?id=<id>
// ----------------------------------------------------------------------------

class MealplanGlanceWidget : GlanceAppWidget() {

    // Glance-empfohlene Standardgrößen für AppWidgets — entsprechen ~2x2,
    // 4x2 und 4x4 Launcher-Grid-Slots.
    override val sizeMode: SizeMode = SizeMode.Responsive(
        setOf(
            androidx.compose.ui.unit.DpSize(180.dp, 180.dp),
            androidx.compose.ui.unit.DpSize(300.dp, 180.dp),
            androidx.compose.ui.unit.DpSize(300.dp, 300.dp),
        ),
    )

    override suspend fun provideGlance(context: Context, id: GlanceId) {
        WidgetServerSync.refreshMealplan(context)
        // Daten EINMAL synchron pullen (Glance recomposed bei jeder
        // `updateAll`-Trigger neu — die DataStore-Reads sind dann frisch).
        val lang = WidgetSharedStore.loadLanguage(context)
        val l10n = WidgetL10n(lang)
        val now = Date()
        val cal = Calendar.getInstance().apply { time = now }
        cal.add(Calendar.DAY_OF_YEAR, 1)
        val tomorrow = cal.time

        val todayStr = WidgetSharedStore.dateString(now)
        val tomorrowStr = WidgetSharedStore.dateString(tomorrow)
        val all = WidgetSharedStore.loadMealplan(context)
        val todayMeals = WidgetSharedStore.entriesForDateString(todayStr, all)
        val tomorrowMeals = WidgetSharedStore.entriesForDateString(tomorrowStr, all)

        val fmtDate = SimpleDateFormat("EEE, d. MMM", Locale.getDefault())

        provideContent {
            GlanceTheme {
                MealplanContent(
                    l10n = l10n,
                    todayMeals = todayMeals,
                    tomorrowMeals = tomorrowMeals,
                    formattedToday = fmtDate.format(now),
                    formattedTomorrow = fmtDate.format(tomorrow),
                )
            }
        }
    }
}

@Composable
private fun MealplanContent(
    l10n: WidgetL10n,
    todayMeals: List<WidgetMealEntry>,
    tomorrowMeals: List<WidgetMealEntry>,
    formattedToday: String,
    formattedTomorrow: String,
) {
    val size = LocalSize.current
    Box(
        modifier = GlanceModifier
            .fillMaxSize()
            .background(GlanceTheme.colors.widgetBackground)
            .clickable(actionStartActivity(deepLinkIntent(LocalContext.current, "mealierecipes://mealplan"))),
    ) {
        when {
            size.width < 220.dp -> MealplanSmall(l10n, todayMeals)
            size.height < 220.dp -> MealplanMedium(l10n, todayMeals, tomorrowMeals, formattedToday, formattedTomorrow)
            else -> MealplanLarge(l10n, todayMeals, tomorrowMeals, formattedToday, formattedTomorrow)
        }
    }
}

// MARK: - Small

@Composable
private fun MealplanSmall(l10n: WidgetL10n, todayMeals: List<WidgetMealEntry>) {
    Column(modifier = GlanceModifier.fillMaxSize().padding(12.dp)) {
        Row(verticalAlignment = Alignment.CenterVertically) {
            Image(
                provider = ImageProvider(R.drawable.ic_widget_fork_circle),
                contentDescription = null,
                modifier = GlanceModifier.size(12.dp),
                colorFilter = androidx.glance.ColorFilter.tint(cp(WidgetTheme.OrangeAccent)),
            )
            Spacer(modifier = GlanceModifier.width(4.dp))
            Text(text = l10n.s("today"), style = WidgetTheme.Caption2Bold)
        }
        Spacer(modifier = GlanceModifier.height(4.dp))
        if (todayMeals.isEmpty()) {
            Text(text = l10n.s("nothing_planned"), style = WidgetTheme.Caption2)
        } else {
            todayMeals.take(3).forEach { meal ->
                MealSlotLinkRow(meal = meal, showSlotLabel = false)
                Spacer(modifier = GlanceModifier.height(2.dp))
            }
        }
    }
}

// MARK: - Medium

@Composable
private fun MealplanMedium(
    l10n: WidgetL10n,
    todayMeals: List<WidgetMealEntry>,
    tomorrowMeals: List<WidgetMealEntry>,
    formattedToday: String,
    formattedTomorrow: String,
) {
    Row(modifier = GlanceModifier.fillMaxSize().padding(14.dp)) {
        DayColumn(
            label = l10n.s("today"),
            subLabel = formattedToday,
            meals = todayMeals,
            accent = WidgetTheme.OrangeAccent,
            emptyText = l10n.s("nothing_planned"),
            modifier = GlanceModifier.defaultWeight(),
        )
        // Glance hat keinen Material-Divider — wir simulieren ihn mit einem
        // schmalen, deckenden Box als Trennlinie.
        Spacer(modifier = GlanceModifier.width(10.dp))
        Box(
            modifier = GlanceModifier
                .width(1.dp)
                .fillMaxHeight()
                .background(cp(WidgetTheme.SecondaryText.copy(alpha = 0.3f))),
        ) {}
        Spacer(modifier = GlanceModifier.width(10.dp))
        DayColumn(
            label = l10n.s("tomorrow"),
            subLabel = formattedTomorrow,
            meals = tomorrowMeals,
            accent = WidgetTheme.BlueAccent,
            emptyText = l10n.s("nothing_planned"),
            modifier = GlanceModifier.defaultWeight(),
        )
    }
}

// MARK: - Large

@Composable
private fun MealplanLarge(
    l10n: WidgetL10n,
    todayMeals: List<WidgetMealEntry>,
    tomorrowMeals: List<WidgetMealEntry>,
    formattedToday: String,
    formattedTomorrow: String,
) {
    Column(modifier = GlanceModifier.fillMaxSize().padding(16.dp)) {
        Row(verticalAlignment = Alignment.CenterVertically) {
            Image(
                provider = ImageProvider(R.drawable.ic_widget_fork_circle),
                contentDescription = null,
                modifier = GlanceModifier.size(18.dp),
                colorFilter = androidx.glance.ColorFilter.tint(cp(WidgetTheme.OrangeAccent)),
            )
            Spacer(modifier = GlanceModifier.width(6.dp))
            Text(text = l10n.s("meal_plan"), style = WidgetTheme.Headline)
        }
        HorizontalThinDivider()
        DaySection(
            label = l10n.s("today"),
            subLabel = formattedToday,
            meals = todayMeals,
            accent = WidgetTheme.OrangeAccent,
            emptyText = l10n.s("no_meals"),
        )
        HorizontalThinDivider()
        DaySection(
            label = l10n.s("tomorrow"),
            subLabel = formattedTomorrow,
            meals = tomorrowMeals,
            accent = WidgetTheme.BlueAccent,
            emptyText = l10n.s("no_meals"),
        )
    }
}

// MARK: - Helpers

@Composable
private fun DayColumn(
    label: String,
    subLabel: String,
    meals: List<WidgetMealEntry>,
    accent: Color,
    emptyText: String,
    modifier: GlanceModifier,
) {
    Column(modifier = modifier) {
        Text(
            text = label,
            style = WidgetTheme.Caption2Bold.copy(color = cp(accent)),
        )
        Text(text = subLabel, style = WidgetTheme.Caption2)
        Spacer(modifier = GlanceModifier.height(6.dp))
        if (meals.isEmpty()) {
            Text(text = emptyText, style = WidgetTheme.Caption2)
        } else {
            meals.forEach { meal ->
                MealSlotLinkRow(meal = meal, showSlotLabel = false)
                Spacer(modifier = GlanceModifier.height(2.dp))
            }
        }
    }
}

@Composable
private fun DaySection(
    label: String,
    subLabel: String,
    meals: List<WidgetMealEntry>,
    accent: Color,
    emptyText: String,
) {
    Column(modifier = GlanceModifier.fillMaxWidth().padding(vertical = 8.dp)) {
        Row(verticalAlignment = Alignment.CenterVertically) {
            Text(
                text = label,
                style = WidgetTheme.SubheadlineBold.copy(color = cp(accent)),
            )
            Spacer(modifier = GlanceModifier.width(6.dp))
            Text(text = subLabel, style = WidgetTheme.Caption)
        }
        Spacer(modifier = GlanceModifier.height(6.dp))
        if (meals.isEmpty()) {
            Text(
                text = emptyText,
                style = WidgetTheme.Caption,
                modifier = GlanceModifier.padding(start = 4.dp),
            )
        } else {
            meals.forEach { meal ->
                MealSlotLinkRow(meal = meal, showSlotLabel = true)
                Spacer(modifier = GlanceModifier.height(2.dp))
            }
        }
    }
}

@Composable
private fun MealSlotLinkRow(meal: WidgetMealEntry, showSlotLabel: Boolean) {
    val visual = WidgetTheme.slotVisual(meal.slot)
    val ctx = LocalContext.current
    val rowMod = if (!meal.recipeId.isNullOrEmpty()) {
        GlanceModifier
            .fillMaxWidth()
            .clickable(actionStartActivity(deepLinkIntent(ctx, "mealierecipes://recipe?id=${meal.recipeId}")))
    } else {
        GlanceModifier.fillMaxWidth()
    }
    Row(modifier = rowMod, verticalAlignment = Alignment.CenterVertically) {
        Image(
            provider = ImageProvider(visual.drawableRes),
            contentDescription = null,
            modifier = GlanceModifier.size(14.dp),
            colorFilter = androidx.glance.ColorFilter.tint(cp(visual.color)),
        )
        Spacer(modifier = GlanceModifier.width(5.dp))
        Text(
            text = meal.recipeName,
            style = WidgetTheme.Caption,
            maxLines = 1,
            modifier = GlanceModifier.defaultWeight(),
        )
        if (showSlotLabel) {
            Spacer(modifier = GlanceModifier.width(4.dp))
            Text(text = meal.slotName, style = WidgetTheme.Caption2)
        }
    }
}

@Composable
private fun HorizontalThinDivider() {
    Spacer(modifier = GlanceModifier.height(10.dp))
    Box(
        modifier = GlanceModifier
            .fillMaxWidth()
            .height(1.dp)
            .background(cp(WidgetTheme.SecondaryText.copy(alpha = 0.3f))),
    ) {}
    Spacer(modifier = GlanceModifier.height(10.dp))
}

// MARK: - Intent-Helper

/**
 * Baut ein VIEW-Intent auf das angegebene Custom-Scheme. Ziel ist
 * MainActivity — die existierende `mealierecipes`-Intent-Filter im
 * AndroidManifest macht das Routing zu uni_links/go_router auf Dart-Seite.
 *
 * Wichtig: Bei AppWidgets MUSS der Intent ein `FLAG_ACTIVITY_NEW_TASK`
 * setzen, weil der Widget-Host keinen eigenen Task-Stack hat.
 */
internal fun deepLinkIntent(context: Context, uri: String): Intent {
    return Intent(Intent.ACTION_VIEW, Uri.parse(uri)).apply {
        setClass(context, MainActivity::class.java)
        addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP)
    }
}

