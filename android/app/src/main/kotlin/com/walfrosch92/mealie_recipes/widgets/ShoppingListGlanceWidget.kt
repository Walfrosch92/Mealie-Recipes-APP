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
import androidx.glance.text.FontWeight
import androidx.glance.text.Text
import androidx.glance.text.TextStyle
import com.walfrosch92.mealie_recipes.R

// ----------------------------------------------------------------------------
// ShoppingListGlanceWidget — 1:1 Port von `ShoppingListWidget.swift`.
//
// SizeMode.Responsive:
//   • small  → großer Counter (offene Items) oder Häkchen
//   • medium → Header + Badge + max 5 Items
//   • large  → Header + Badge + max 12 Items
//
// Tap-Target: das gesamte Widget → mealierecipes://shopping
// ----------------------------------------------------------------------------

class ShoppingListGlanceWidget : GlanceAppWidget() {

    override val sizeMode: SizeMode = SizeMode.Responsive(
        setOf(
            androidx.compose.ui.unit.DpSize(180.dp, 180.dp),
            androidx.compose.ui.unit.DpSize(300.dp, 180.dp),
            androidx.compose.ui.unit.DpSize(300.dp, 300.dp),
        ),
    )

    override suspend fun provideGlance(context: Context, id: GlanceId) {
        // Selbst beim Server nachsehen (Webapp/andere Geräte), sonst der
        // zuletzt gespeicherte Stand.
        WidgetServerSync.refreshShopping(context)
        val lang = WidgetSharedStore.loadLanguage(context)
        val l10n = WidgetL10n(lang)
        val items = WidgetSharedStore.loadShoppingItems(context)
        provideContent {
            GlanceTheme {
                ShoppingContent(l10n, items)
            }
        }
    }
}

@Composable
private fun ShoppingContent(l10n: WidgetL10n, items: List<WidgetShoppingItem>) {
    val size = LocalSize.current
    val unchecked = items.filter { !it.checked }
    Box(
        modifier = GlanceModifier
            .fillMaxSize()
            .background(GlanceTheme.colors.widgetBackground)
            .clickable(actionStartActivity(deepLinkIntent(LocalContext.current, "mealierecipes://shopping"))),
    ) {
        when {
            size.width < 220.dp -> ShoppingSmall(l10n, items, unchecked)
            else -> {
                // Item-Anzahl aus der tatsächlich verfügbaren Höhe ableiten statt
                // fixer 5/12 — so füllt die Liste den Platz (vorher zeigte ein
                // großes Widget nur 4-5, obwohl 7-8+ reinpassen). Eine Zeile ist
                // ~22dp hoch; Header+Divider+Padding ~60-78dp Chrome.
                val rowH = 22f
                val chrome = if (size.height < 220.dp) 60f else 78f
                val maxVisible = (((size.height.value - chrome) / rowH).toInt())
                    .coerceIn(3, 25)
                ShoppingMedium(l10n, items, unchecked, maxVisible)
            }
        }
    }
}

// MARK: - Small

@Composable
private fun ShoppingSmall(
    l10n: WidgetL10n,
    items: List<WidgetShoppingItem>,
    unchecked: List<WidgetShoppingItem>,
) {
    Column(
        modifier = GlanceModifier.fillMaxSize().padding(12.dp),
        verticalAlignment = Alignment.Top,
        horizontalAlignment = Alignment.Start,
    ) {
        Row(verticalAlignment = Alignment.CenterVertically) {
            Image(
                provider = ImageProvider(R.drawable.ic_widget_cart),
                contentDescription = null,
                modifier = GlanceModifier.size(12.dp),
                colorFilter = androidx.glance.ColorFilter.tint(cp(WidgetTheme.GreenAccent)),
            )
            Spacer(modifier = GlanceModifier.width(4.dp))
            Text(text = l10n.s("shopping"), style = WidgetTheme.Caption2Bold)
        }
        Spacer(modifier = GlanceModifier.height(6.dp))
        Box(modifier = GlanceModifier.defaultWeight().fillMaxWidth(), contentAlignment = Alignment.Center) {
            if (items.isEmpty() || unchecked.isEmpty()) {
                Column(horizontalAlignment = Alignment.CenterHorizontally) {
                    Image(
                        provider = ImageProvider(R.drawable.ic_widget_check_circle),
                        contentDescription = null,
                        modifier = GlanceModifier.size(28.dp),
                        colorFilter = androidx.glance.ColorFilter.tint(cp(WidgetTheme.GreenAccent)),
                    )
                    Spacer(modifier = GlanceModifier.height(4.dp))
                    Text(text = l10n.s("all_done"), style = WidgetTheme.Caption2)
                }
            } else {
                Column(horizontalAlignment = Alignment.CenterHorizontally) {
                    Text(
                        text = unchecked.size.toString(),
                        style = TextStyle(
                            fontSize = 40.sp,
                            fontWeight = FontWeight.Bold,
                            color = cp(WidgetTheme.PrimaryText),
                        ),
                    )
                    Text(text = l10n.s("open"), style = WidgetTheme.Caption2)
                }
            }
        }
    }
}

// MARK: - Medium / Large (only `maxVisible` differs)

@Composable
private fun ShoppingMedium(
    l10n: WidgetL10n,
    items: List<WidgetShoppingItem>,
    unchecked: List<WidgetShoppingItem>,
    maxVisible: Int,
) {
    val padding = if (maxVisible >= 12) 16.dp else 14.dp
    Column(modifier = GlanceModifier.fillMaxSize().padding(padding)) {
        Row(
            modifier = GlanceModifier.fillMaxWidth(),
            verticalAlignment = Alignment.CenterVertically,
        ) {
            Image(
                provider = ImageProvider(R.drawable.ic_widget_cart),
                contentDescription = null,
                modifier = GlanceModifier.size(14.dp),
                colorFilter = androidx.glance.ColorFilter.tint(cp(WidgetTheme.GreenAccent)),
            )
            Spacer(modifier = GlanceModifier.width(6.dp))
            Text(
                text = l10n.s("shopping_list"),
                style = if (maxVisible >= 12) WidgetTheme.Headline else WidgetTheme.SubheadlineBold,
                modifier = GlanceModifier.defaultWeight(),
            )
            if (unchecked.isNotEmpty()) {
                Box(
                    modifier = GlanceModifier
                        .background(cp(WidgetTheme.GreenBadgeBg))
                        .cornerRadius(6.dp)
                        .padding(horizontal = 8.dp, vertical = 3.dp),
                ) {
                    Text(
                        text = "${unchecked.size} ${l10n.s("open")}",
                        style = TextStyle(
                            fontSize = 11.sp,
                            color = cp(androidx.compose.ui.graphics.Color.White),
                        ),
                    )
                }
            }
        }
        Spacer(modifier = GlanceModifier.height(8.dp))
        Box(
            modifier = GlanceModifier
                .fillMaxWidth()
                .height(1.dp)
                .background(cp(WidgetTheme.SecondaryText.copy(alpha = 0.3f))),
        ) {}
        Spacer(modifier = GlanceModifier.height(8.dp))

        if (items.isEmpty()) {
            Text(text = l10n.s("no_items"), style = WidgetTheme.Caption)
        } else if (unchecked.isEmpty()) {
            Row(verticalAlignment = Alignment.CenterVertically) {
                Image(
                    provider = ImageProvider(R.drawable.ic_widget_check_circle),
                    contentDescription = null,
                    modifier = GlanceModifier.size(16.dp),
                    colorFilter = androidx.glance.ColorFilter.tint(cp(WidgetTheme.GreenAccent)),
                )
                Spacer(modifier = GlanceModifier.width(6.dp))
                Text(text = l10n.s("all_completed"), style = WidgetTheme.Caption)
            }
        } else {
            unchecked.take(maxVisible).forEach { item ->
                ShoppingItemRow(item = item)
                Spacer(modifier = GlanceModifier.height(2.dp))
            }
            if (unchecked.size > maxVisible) {
                Text(
                    text = "+ ${unchecked.size - maxVisible} ${l10n.s("more")}",
                    style = WidgetTheme.Caption2,
                    modifier = GlanceModifier.padding(start = 20.dp),
                )
            }
        }
    }
}

@Composable
private fun ShoppingItemRow(item: WidgetShoppingItem) {
    Row(
        modifier = GlanceModifier.fillMaxWidth(),
        verticalAlignment = Alignment.CenterVertically,
    ) {
        Image(
            provider = ImageProvider(
                if (item.checked) R.drawable.ic_widget_check_circle else R.drawable.ic_widget_circle,
            ),
            contentDescription = null,
            modifier = GlanceModifier.size(14.dp),
            colorFilter = androidx.glance.ColorFilter.tint(
                cp(if (item.checked) WidgetTheme.GreenAccent else WidgetTheme.SecondaryText),
            ),
        )
        Spacer(modifier = GlanceModifier.width(6.dp))
        Text(
            text = item.name,
            // Glance unterstützt KEIN strikethrough als TextStyle-Attribut
            // (Compose-foundation-only). Wir nutzen stattdessen den
            // sekundären Grauton für „checked" Items, was visuell sehr nah
            // an iOS' .strikethrough + .secondary kommt.
            style = if (item.checked) WidgetTheme.CaptionSecondary else WidgetTheme.Caption,
            maxLines = 1,
        )
    }
}
