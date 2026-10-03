package com.walfrosch92.mealie_recipes.widgets

import android.content.Context
import androidx.compose.runtime.Composable
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.glance.GlanceId
import androidx.glance.GlanceModifier
import androidx.glance.GlanceTheme
import androidx.glance.Image
import androidx.glance.ImageProvider
import androidx.glance.LocalContext
import androidx.glance.LocalSize
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
import androidx.glance.layout.fillMaxSize
import androidx.glance.layout.fillMaxWidth
import androidx.glance.layout.height
import androidx.glance.layout.padding
import androidx.glance.layout.size
import androidx.glance.layout.width
import androidx.glance.text.Text
import com.walfrosch92.mealie_recipes.R

// ----------------------------------------------------------------------------
// DailyRecipeGlanceWidget — 1:1 Port von `DailyRecipeWidget.swift`.
//
// SizeMode.Responsive:
//   • small  → Header + Rezeptname (≤3 Zeilen) + optionale Kategorie
//   • medium → Header + Rezeptname (2 Zeilen) + Description (2 Zeilen) +
//              Kategorie-Chip
//   • large  → Header + Divider + Rezept-Titel + Description (6 Zeilen) +
//              Kategorie-Chip
//
// Tap-Target: das gesamte Widget → mealierecipes://recipe?id=<id>
// (Fallback ohne Rezept → mealierecipes://recipe — wird zum Home-Screen routen)
// ----------------------------------------------------------------------------

class DailyRecipeGlanceWidget : GlanceAppWidget() {

    override val sizeMode: SizeMode = SizeMode.Responsive(
        setOf(
            androidx.compose.ui.unit.DpSize(180.dp, 180.dp),
            androidx.compose.ui.unit.DpSize(300.dp, 180.dp),
            androidx.compose.ui.unit.DpSize(300.dp, 300.dp),
        ),
    )

    override suspend fun provideGlance(context: Context, id: GlanceId) {
        val lang = WidgetSharedStore.loadLanguage(context)
        val l10n = WidgetL10n(lang)
        val recipe = WidgetSharedStore.dailyRecipe(context)
        provideContent {
            GlanceTheme {
                DailyContent(l10n, recipe)
            }
        }
    }
}

@Composable
private fun DailyContent(l10n: WidgetL10n, recipe: WidgetRecipeSummary?) {
    val size = LocalSize.current
    val deeplink = if (recipe != null) {
        "mealierecipes://recipe?id=${recipe.id}"
    } else {
        "mealierecipes://recipe"
    }
    Box(
        modifier = GlanceModifier
            .fillMaxSize()
            .background(GlanceTheme.colors.widgetBackground)
            .clickable(actionStartActivity(deepLinkIntent(LocalContext.current, deeplink))),
    ) {
        when {
            size.width < 220.dp -> DailySmall(l10n, recipe)
            size.height < 220.dp -> DailyMedium(l10n, recipe)
            else -> DailyLarge(l10n, recipe)
        }
    }
}

@Composable
private fun DailySmall(l10n: WidgetL10n, recipe: WidgetRecipeSummary?) {
    Column(modifier = GlanceModifier.fillMaxSize().padding(12.dp)) {
        HeaderRow(l10n, iconSize = 12.dp, style = WidgetTheme.Caption2Bold)
        Spacer(modifier = GlanceModifier.height(6.dp))
        if (recipe == null) {
            Text(text = l10n.s("no_recipes"), style = WidgetTheme.CaptionSecondary)
        } else {
            Text(
                text = recipe.name,
                style = WidgetTheme.Subheadline,
                maxLines = 3,
            )
            if (!recipe.category.isNullOrEmpty()) {
                Spacer(modifier = GlanceModifier.height(4.dp))
                Text(
                    text = recipe.category,
                    style = WidgetTheme.Caption2.copy(color = cp(WidgetTheme.OrangeAccent)),
                )
            }
        }
    }
}

@Composable
private fun DailyMedium(l10n: WidgetL10n, recipe: WidgetRecipeSummary?) {
    Column(modifier = GlanceModifier.fillMaxSize().padding(14.dp)) {
        HeaderRow(l10n, iconSize = 14.dp, style = WidgetTheme.SubheadlineBold)
        Spacer(modifier = GlanceModifier.height(6.dp))
        if (recipe == null) {
            Text(text = l10n.s("no_recipes"), style = WidgetTheme.CaptionSecondary)
        } else {
            Text(text = recipe.name, style = WidgetTheme.Headline, maxLines = 2)
            if (!recipe.description.isNullOrEmpty()) {
                Spacer(modifier = GlanceModifier.height(4.dp))
                Text(text = recipe.description, style = WidgetTheme.CaptionSecondary, maxLines = 2)
            }
            if (!recipe.category.isNullOrEmpty()) {
                Spacer(modifier = GlanceModifier.height(6.dp))
                CategoryChip(recipe.category)
            }
        }
    }
}

@Composable
private fun DailyLarge(l10n: WidgetL10n, recipe: WidgetRecipeSummary?) {
    Column(modifier = GlanceModifier.fillMaxSize().padding(16.dp)) {
        HeaderRow(l10n, iconSize = 18.dp, style = WidgetTheme.Headline)
        Spacer(modifier = GlanceModifier.height(10.dp))
        Box(
            modifier = GlanceModifier
                .fillMaxWidth()
                .height(1.dp)
                .background(cp(WidgetTheme.SecondaryText.copy(alpha = 0.3f))),
        ) {}
        Spacer(modifier = GlanceModifier.height(10.dp))
        if (recipe == null) {
            Text(text = l10n.s("no_recipes"), style = WidgetTheme.BodySecondary)
        } else {
            Text(text = recipe.name, style = WidgetTheme.Title3, maxLines = 2)
            if (!recipe.description.isNullOrEmpty()) {
                Spacer(modifier = GlanceModifier.height(8.dp))
                Text(text = recipe.description, style = WidgetTheme.BodySecondary, maxLines = 6)
            }
            if (!recipe.category.isNullOrEmpty()) {
                Spacer(modifier = GlanceModifier.height(8.dp))
                CategoryChip(recipe.category)
            }
        }
    }
}

@Composable
private fun HeaderRow(
    l10n: WidgetL10n,
    iconSize: androidx.compose.ui.unit.Dp,
    style: androidx.glance.text.TextStyle,
) {
    Row(verticalAlignment = Alignment.CenterVertically) {
        Image(
            provider = ImageProvider(R.drawable.ic_widget_sparkles),
            contentDescription = null,
            modifier = GlanceModifier.size(iconSize),
            colorFilter = androidx.glance.ColorFilter.tint(cp(WidgetTheme.OrangeAccent)),
        )
        Spacer(modifier = GlanceModifier.width(6.dp))
        Text(text = l10n.s("daily_recipe"), style = style)
    }
}

@Composable
private fun CategoryChip(text: String) {
    Box(
        modifier = GlanceModifier
            .background(cp(WidgetTheme.OrangeBadgeBg))
            .cornerRadius(6.dp)
            .padding(horizontal = 8.dp, vertical = 3.dp),
    ) {
        Text(
            text = text,
            style = androidx.glance.text.TextStyle(
                fontSize = 11.sp,
                color = cp(WidgetTheme.OrangeAccent),
            ),
        )
    }
}
