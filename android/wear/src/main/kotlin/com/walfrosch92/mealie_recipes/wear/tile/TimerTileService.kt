package com.walfrosch92.mealie_recipes.wear.tile

import androidx.wear.protolayout.ActionBuilders
import androidx.wear.protolayout.ColorBuilders.argb
import androidx.wear.protolayout.DimensionBuilders
import androidx.wear.protolayout.LayoutElementBuilders
import androidx.wear.protolayout.ModifiersBuilders
import androidx.wear.protolayout.ResourceBuilders.Resources
import androidx.wear.protolayout.TimelineBuilders.Timeline
import androidx.wear.tiles.RequestBuilders
import androidx.wear.tiles.TileBuilders.Tile
import androidx.wear.tiles.TileService
import com.google.common.util.concurrent.Futures
import com.google.common.util.concurrent.ListenableFuture
import com.walfrosch92.mealie_recipes.wear.LanguageRepository
import com.walfrosch92.mealie_recipes.wear.TimerRepository
import com.walfrosch92.mealie_recipes.wear.WearStrings

/**
 * Glanceable Tile mit der Restzeit des laufenden Timers. ProtoLayout kann
 * keinen echten Chronometer rendern, daher zeigt die Kachel einen Schnappschuss
 * der Restzeit und frischt sich alle 10 s auf (plus sofortiges requestUpdate aus
 * dem [com.walfrosch92.mealie_recipes.wear.WearListenerService] bei Datenänderung).
 * Der laufende Countdown sekundengenau läuft in der OngoingActivity & der App.
 */
class TimerTileService : TileService() {

    private val resourcesVersion = "1"

    override fun onTileRequest(
        requestParams: RequestBuilders.TileRequest,
    ): ListenableFuture<Tile> {
        // Primärer (als nächstes ablaufender) Timer — die Tile zeigt nur EINEN
        // Schnappschuss, die App selbst zeigt alle wischbar.
        val state = TimerRepository.state.value.minByOrNull { it.liveRemaining() }
        val lang = LanguageRepository.lang.value

        val title: String
        val time: String
        if (state == null) {
            title = WearStrings.t("noActiveTimer", lang)
            time = "--:--"
        } else {
            title = if (state.recipeName.isNotEmpty()) state.recipeName else state.name
            time = state.displayTime()
        }

        val column = LayoutElementBuilders.Column.Builder()
            .setHorizontalAlignment(LayoutElementBuilders.HORIZONTAL_ALIGN_CENTER)
            .addContent(
                LayoutElementBuilders.Text.Builder()
                    .setText(title)
                    .setMaxLines(1)
                    .setFontStyle(
                        LayoutElementBuilders.FontStyle.Builder()
                            .setSize(DimensionBuilders.sp(14f))
                            .setColor(argb(0xFFA89F92.toInt()))
                            .build(),
                    )
                    .build(),
            )
            .addContent(
                LayoutElementBuilders.Text.Builder()
                    .setText(time)
                    .setFontStyle(
                        LayoutElementBuilders.FontStyle.Builder()
                            .setSize(DimensionBuilders.sp(34f))
                            .setWeight(LayoutElementBuilders.FONT_WEIGHT_BOLD)
                            .setColor(argb(0xFFFF8A00.toInt()))
                            .build(),
                    )
                    .build(),
            )
            .build()

        val clickable = ModifiersBuilders.Clickable.Builder()
            .setId("open")
            .setOnClick(
                ActionBuilders.LaunchAction.Builder()
                    .setAndroidActivity(
                        ActionBuilders.AndroidActivity.Builder()
                            .setPackageName(packageName)
                            .setClassName(
                                "com.walfrosch92.mealie_recipes.wear.presentation.MainActivity",
                            )
                            .build(),
                    )
                    .build(),
            )
            .build()

        val root = LayoutElementBuilders.Box.Builder()
            .setWidth(DimensionBuilders.expand())
            .setHeight(DimensionBuilders.expand())
            .setVerticalAlignment(LayoutElementBuilders.VERTICAL_ALIGN_CENTER)
            .setHorizontalAlignment(LayoutElementBuilders.HORIZONTAL_ALIGN_CENTER)
            .setModifiers(
                ModifiersBuilders.Modifiers.Builder()
                    .setClickable(clickable)
                    .build(),
            )
            .addContent(column)
            .build()

        val tile = Tile.Builder()
            .setResourcesVersion(resourcesVersion)
            .setFreshnessIntervalMillis(10_000)
            .setTileTimeline(Timeline.fromLayoutElement(root))
            .build()
        return Futures.immediateFuture(tile)
    }

    override fun onTileResourcesRequest(
        requestParams: RequestBuilders.ResourcesRequest,
    ): ListenableFuture<Resources> {
        return Futures.immediateFuture(
            Resources.Builder().setVersion(resourcesVersion).build(),
        )
    }
}