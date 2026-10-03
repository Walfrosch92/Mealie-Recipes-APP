package com.walfrosch92.mealie_recipes.wear.presentation

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.pager.HorizontalPager
import androidx.compose.foundation.pager.rememberPagerState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.SolidColor
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.lifecycle.lifecycleScope
import androidx.wear.compose.foundation.lazy.ScalingLazyColumn
import androidx.wear.compose.foundation.lazy.items
import androidx.wear.compose.foundation.lazy.rememberScalingLazyListState
import androidx.wear.compose.material.Button
import androidx.wear.compose.material.ButtonDefaults
import androidx.wear.compose.material.Card
import androidx.wear.compose.material.CardDefaults
import androidx.wear.compose.material.Chip
import androidx.wear.compose.material.ChipDefaults
import androidx.wear.compose.material.Colors
import androidx.wear.compose.material.Icon
import androidx.wear.compose.material.MaterialTheme
import androidx.wear.compose.material.Scaffold
import androidx.wear.compose.material.Text
import androidx.wear.compose.material.TimeText
import androidx.wear.compose.material.Vignette
import androidx.wear.compose.material.VignettePosition
import com.google.android.gms.wearable.DataClient
import com.google.android.gms.wearable.DataEvent
import com.google.android.gms.wearable.DataMapItem
import com.google.android.gms.wearable.Wearable
import com.walfrosch92.mealie_recipes.wear.CookingRepository
import com.walfrosch92.mealie_recipes.wear.LanguageRepository
import com.walfrosch92.mealie_recipes.wear.R
import com.walfrosch92.mealie_recipes.wear.ShoppingRepository
import com.walfrosch92.mealie_recipes.wear.TimerRepository
import com.walfrosch92.mealie_recipes.wear.WearCookingState
import com.walfrosch92.mealie_recipes.wear.WearShoppingItem
import com.walfrosch92.mealie_recipes.wear.WearStrings
import com.walfrosch92.mealie_recipes.wear.WearTimerState
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

class MainActivity : ComponentActivity() {

    // Live-Listener während die App im Vordergrund ist → sekundengenaue
    // Updates für Timer UND Einkaufsliste, ohne auf den Hintergrund-Service
    // zu warten.
    private val dataListener = DataClient.OnDataChangedListener { buffer ->
        for (event in buffer) {
            val item = event.dataItem
            val path = item.uri.path.orEmpty()
            when {
                path.startsWith(TimerRepository.TIMERS_PATH) -> {
                    if (event.type == DataEvent.TYPE_DELETED) {
                        TimerRepository.set(emptyList())
                    } else {
                        TimerRepository.set(
                            TimerRepository.parse(DataMapItem.fromDataItem(item).dataMap),
                        )
                    }
                }
                path.startsWith(CookingRepository.COOKING_PATH) -> {
                    if (event.type == DataEvent.TYPE_DELETED) {
                        CookingRepository.set(null)
                    } else {
                        CookingRepository.set(
                            CookingRepository.parse(DataMapItem.fromDataItem(item).dataMap),
                        )
                    }
                }
                path.startsWith(ShoppingRepository.SHOPPING_PATH) -> {
                    if (event.type == DataEvent.TYPE_DELETED) {
                        ShoppingRepository.set(emptyList())
                    } else {
                        ShoppingRepository.set(
                            ShoppingRepository.parse(DataMapItem.fromDataItem(item).dataMap),
                        )
                    }
                }
                path.startsWith(LanguageRepository.LANGUAGE_PATH) -> {
                    if (event.type == DataEvent.TYPE_DELETED) {
                        LanguageRepository.set(null)
                    } else {
                        LanguageRepository.set(
                            LanguageRepository.parse(DataMapItem.fromDataItem(item).dataMap),
                        )
                    }
                }
            }
        }
        buffer.release()
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent { WatchApp() }
    }

    override fun onResume() {
        super.onResume()
        Wearable.getDataClient(this).addListener(dataListener)
        lifecycleScope.launch { TimerRepository.loadInitial(this@MainActivity) }
        lifecycleScope.launch { CookingRepository.loadInitial(this@MainActivity) }
        lifecycleScope.launch { ShoppingRepository.loadInitial(this@MainActivity) }
        lifecycleScope.launch { LanguageRepository.loadInitial(this@MainActivity) }
    }

    override fun onPause() {
        super.onPause()
        Wearable.getDataClient(this).removeListener(dataListener)
    }
}

// Premium-Palette — 1:1 zu den AppTokens/AppColors der Phone-App (warmes
// Dunkel + Orange-Verlaufs-Akzent).
private val AccentLight = Color(0xFFFFB23E)
private val Accent = Color(0xFFFF8A00)
private val AccentDeep = Color(0xFFFF6A00)
private val WarmBg = Color(0xFF0E0C0A)
private val WarmCard = Color(0xFF1A1714)
private val WarmSurface2 = Color(0xFF262019)
private val WarmFg = Color(0xFFF5F1EA)
private val WarmFgSub = Color(0xFFA89F92)

private val AccentBrush = Brush.linearGradient(listOf(AccentLight, Accent, AccentDeep))

private val WearColorPalette = Colors(
    primary = Accent,
    primaryVariant = AccentDeep,
    secondary = AccentLight,
    secondaryVariant = AccentDeep,
    background = WarmBg,
    surface = WarmCard,
    error = Color(0xFFE53935),
    onPrimary = Color.White,
    onSecondary = Color.White,
    onBackground = WarmFg,
    onSurface = WarmFg,
    onSurfaceVariant = WarmFgSub,
    onError = Color.White,
)

// Zwei sich AUSSCHLIESSENDE Ansichten (siehe CookingRepository/WearCookingState):
//   • Kochmodus aktiv: Timer wischbar (falls vorhanden) + Vor/Zurück-Buttons,
//     KEINE Einkaufsliste.
//   • Kein Kochmodus: Einkaufsliste (unverändert zum bisherigen Verhalten,
//     abgesehen vom jetzt eigenständigen Timer-Bereich).
@Composable
private fun WatchApp() {
    MaterialTheme(colors = WearColorPalette) {
        val cooking by CookingRepository.state.collectAsState()
        Scaffold(
            timeText = { TimeText() },
            vignette = { Vignette(vignettePosition = VignettePosition.TopAndBottom) },
        ) {
            if (cooking.active) {
                CookingNavScreen(cooking)
            } else {
                ShoppingScreen()
            }
        }
    }
}

@Composable
private fun ShoppingScreen() {
    val listState = rememberScalingLazyListState()
    val shopping by ShoppingRepository.items.collectAsState()
    val lang by LanguageRepository.lang.collectAsState()
    val uncategorized = WearStrings.t("uncategorized", lang)
    val completedLabel = WearStrings.t("completed", lang)
    val open = shopping.filter { !it.checked }
    val done = shopping.filter { it.checked }

    ScalingLazyColumn(
        modifier = Modifier.fillMaxWidth(),
        state = listState,
        horizontalAlignment = Alignment.CenterHorizontally,
    ) {
        item {
            Text(
                text = "${WearStrings.t("shoppingHeader", lang)} (${open.size})",
                style = MaterialTheme.typography.title3.copy(
                    fontWeight = FontWeight.Bold,
                ),
                color = WarmFg,
                modifier = Modifier.padding(top = 4.dp, bottom = 2.dp),
            )
        }

        if (shopping.isEmpty()) {
            item {
                Text(
                    text = WearStrings.t("shoppingEmpty", lang),
                    textAlign = TextAlign.Center,
                    style = MaterialTheme.typography.caption1,
                    color = MaterialTheme.colors.onSurfaceVariant,
                )
            }
        } else {
            // Flache Zeilenliste bauen: farbiger Kategorie-Header (in
            // Erscheinungsreihenfolge) + offene Items, danach „Erledigt".
            val openByCat = open.groupBy { it.category } // LinkedHashMap: Reihenfolge bleibt
            val rows = buildList {
                for ((catName, catItems) in openByCat) {
                    add(
                        ShoppingRowData.Header(
                            title = catName.ifEmpty { uncategorized },
                            colorHex = catItems.firstOrNull()?.categoryColor ?: "",
                            count = catItems.size,
                        ),
                    )
                    for (it in catItems) add(ShoppingRowData.Item(it))
                }
                if (done.isNotEmpty()) {
                    add(ShoppingRowData.Header(completedLabel, "", done.size))
                    for (it in done) add(ShoppingRowData.Item(it))
                }
            }
            items(rows) { row ->
                when (row) {
                    is ShoppingRowData.Header ->
                        CategoryHeader(row.title, row.colorHex, row.count)
                    is ShoppingRowData.Item -> ShoppingRow(row.item)
                }
            }
        }
    }
}

// Kochmodus: laufende/pausierte Timer wischbar (ein Timer pro Seite) + darunter
// Vor/Zurück-Buttons für den aktuellen Kochschritt — größer, wenn kein Timer
// läuft (mehr Platz frei). Pendant zur Phone-App `_StepNavBar`-Pfeilen (der
// mittlere „Erledigt"/„Weiter"-Button bleibt bewusst am Handy).
@Composable
private fun CookingNavScreen(cooking: WearCookingState) {
    val timers by TimerRepository.state.collectAsState()
    Column(
        modifier = Modifier.fillMaxSize().padding(horizontal = 6.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center,
    ) {
        if (timers.isNotEmpty()) {
            val pagerState = rememberPagerState(pageCount = { timers.size })
            HorizontalPager(
                state = pagerState,
                modifier = Modifier.fillMaxWidth().height(150.dp),
            ) { page ->
                TimerCard(timers[page])
            }
            Spacer(Modifier.height(6.dp))
        }
        StepNavButtons(cooking = cooking, big = timers.isEmpty())
    }
}

@Composable
private fun StepNavButtons(cooking: WearCookingState, big: Boolean) {
    val context = LocalContext.current
    val lang by LanguageRepository.lang.collectAsState()
    val size = if (big) 60.dp else 44.dp
    Row(horizontalArrangement = Arrangement.spacedBy(if (big) 22.dp else 14.dp)) {
        StepButton(
            iconRes = android.R.drawable.ic_media_previous,
            contentDescription = WearStrings.t("back", lang),
            enabled = cooking.canBack,
            size = size,
        ) { CookingRepository.sendStepAction(context, "previous") }
        StepButton(
            iconRes = android.R.drawable.ic_media_next,
            contentDescription = WearStrings.t("next", lang),
            enabled = cooking.canNext,
            size = size,
        ) { CookingRepository.sendStepAction(context, "next") }
    }
}

@Composable
private fun StepButton(
    iconRes: Int,
    contentDescription: String,
    enabled: Boolean,
    size: androidx.compose.ui.unit.Dp,
    onClick: () -> Unit,
) {
    // Eigener Kreis statt Wear-Button: dessen ButtonColors nehmen nur eine
    // Volltonfarbe an, hier soll aber derselbe Akzent-Verlauf wie im Rest der
    // Handy-App (AccentGradient) sichtbar sein.
    Box(
        contentAlignment = Alignment.Center,
        modifier = Modifier
            .size(size)
            .clip(CircleShape)
            .background(if (enabled) AccentBrush else SolidColor(WarmSurface2))
            .clickable(enabled = enabled, onClick = onClick),
    ) {
        Icon(
            painter = androidx.compose.ui.res.painterResource(iconRes),
            contentDescription = contentDescription,
            tint = if (enabled) Color.White else WarmFgSub,
        )
    }
}

@Composable
private fun TimerCard(s: WearTimerState) {
    val context = LocalContext.current
    val lang by LanguageRepository.lang.collectAsState()

    var now by remember { mutableStateOf(System.currentTimeMillis()) }
    LaunchedEffect(s.endMillis, s.isPaused) {
        while (true) {
            now = System.currentTimeMillis()
            delay(1000)
        }
    }

    Card(
        onClick = {},
        modifier = Modifier.fillMaxWidth(),
        backgroundPainter = CardDefaults.cardBackgroundPainter(
            startBackgroundColor = WarmCard,
            endBackgroundColor = WarmCard,
        ),
    ) {
        Column(
            modifier = Modifier.fillMaxWidth().padding(4.dp),
            horizontalAlignment = Alignment.CenterHorizontally,
        ) {
            Text(
                text = s.name,
                maxLines = 1,
                style = MaterialTheme.typography.caption1.copy(fontWeight = FontWeight.SemiBold),
                color = WarmFgSub,
            )
            // Countdown im Orange-Verlauf (pausiert: gedämpft).
            Text(
                text = s.displayTime(now),
                style = if (s.isPaused) {
                    MaterialTheme.typography.display2.copy(
                        color = WarmFgSub,
                        fontWeight = FontWeight.Bold,
                    )
                } else {
                    MaterialTheme.typography.display2.copy(
                        brush = AccentBrush,
                        fontWeight = FontWeight.Bold,
                    )
                },
            )
            Spacer(Modifier.height(4.dp))
            Row(horizontalArrangement = Arrangement.spacedBy(10.dp)) {
                Button(
                    onClick = {
                        TimerRepository.sendAction(
                            context,
                            if (s.isPaused) "resume" else "pause",
                            s.id,
                        )
                    },
                    colors = ButtonDefaults.buttonColors(backgroundColor = WarmSurface2),
                ) {
                    Icon(
                        painter = androidx.compose.ui.res.painterResource(
                            if (s.isPaused) android.R.drawable.ic_media_play
                            else android.R.drawable.ic_media_pause,
                        ),
                        contentDescription = WearStrings.t(
                            if (s.isPaused) "resume" else "pause",
                            lang,
                        ),
                        tint = WarmFg,
                    )
                }
                Button(
                    onClick = { TimerRepository.sendAction(context, "stop", s.id) },
                    colors = ButtonDefaults.buttonColors(
                        backgroundColor = MaterialTheme.colors.error,
                    ),
                ) {
                    Icon(
                        painter = androidx.compose.ui.res.painterResource(
                            android.R.drawable.ic_menu_close_clear_cancel,
                        ),
                        contentDescription = WearStrings.t("stop", lang),
                        tint = Color.White,
                    )
                }
            }
        }
    }
}

// Eine Zeile in der gruppierten Einkaufsliste: entweder Kategorie-Header oder Item.
private sealed interface ShoppingRowData {
    data class Header(val title: String, val colorHex: String, val count: Int) : ShoppingRowData
    data class Item(val item: WearShoppingItem) : ShoppingRowData
}

// Farbiger Kategorie-Header — spiegelt den categoryHeaderChip der Phone-View:
// gefüllte Kapsel in Kategorie-Farbe, Text schwarz/weiß je nach Helligkeit,
// Count-Badge. Leerer colorHex (z.B. „Erledigt") → neutrales Grau.
@Composable
private fun CategoryHeader(title: String, colorHex: String, count: Int) {
    val bg = if (colorHex.isEmpty()) WarmSurface2 else colorFromHex(colorHex)
    val fg = if (colorHex.isEmpty()) WarmFg else textColorOn(colorHex)
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(top = 6.dp, bottom = 2.dp)
            .clip(RoundedCornerShape(12.dp))
            .background(bg)
            .padding(horizontal = 12.dp, vertical = 7.dp),
        verticalAlignment = Alignment.CenterVertically,
    ) {
        Text(
            text = title,
            maxLines = 1,
            modifier = Modifier.weight(1f),
            style = MaterialTheme.typography.button.copy(fontWeight = FontWeight.Bold),
            color = fg,
        )
        if (count > 0) {
            Text(
                text = count.toString(),
                style = MaterialTheme.typography.caption2,
                color = fg,
            )
        }
    }
}

private fun colorFromHex(hex: String): Color {
    return try {
        Color(android.graphics.Color.parseColor("#" + hex.removePrefix("#")))
    } catch (_: Exception) {
        Color(0xFF555555)
    }
}

// Schwarz/weiß je nach Helligkeit — 1:1 zur _brightness-Formel der Phone-View.
private fun textColorOn(hex: String): Color {
    return try {
        val v = android.graphics.Color.parseColor("#" + hex.removePrefix("#"))
        val r = android.graphics.Color.red(v) / 255.0
        val g = android.graphics.Color.green(v) / 255.0
        val b = android.graphics.Color.blue(v) / 255.0
        if (0.299 * r + 0.587 * g + 0.114 * b < 0.5) Color.White else Color.Black
    } catch (_: Exception) {
        Color.White
    }
}

@Composable
private fun ShoppingRow(item: WearShoppingItem) {
    val context = LocalContext.current
    val lang by LanguageRepository.lang.collectAsState()
    // Tippen hakt ab/stellt wieder her → toggle ans Handy (synct zum Server).
    Chip(
        onClick = { ShoppingRepository.sendToggle(context, item.id) },
        modifier = Modifier.fillMaxWidth(),
        colors = ChipDefaults.secondaryChipColors(),
        icon = {
            Icon(
                painter = androidx.compose.ui.res.painterResource(
                    if (item.checked) R.drawable.ic_check_box
                    else R.drawable.ic_check_box_blank,
                ),
                contentDescription = WearStrings.t(if (item.checked) "completed" else "open", lang),
                tint = if (item.checked) MaterialTheme.colors.primary
                else MaterialTheme.colors.onSurfaceVariant,
                modifier = Modifier.size(24.dp),
            )
        },
        label = {
            Text(
                text = item.text,
                maxLines = 2,
                style = MaterialTheme.typography.button,
                color = if (item.checked) MaterialTheme.colors.onSurfaceVariant
                else MaterialTheme.colors.onSurface,
            )
        },
    )
}
