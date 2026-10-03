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
import com.walfrosch92.mealie_recipes.wear.ShoppingRepository
import com.walfrosch92.mealie_recipes.wear.WearStrings

/**
 * Glanceable Tile mit den ersten offenen Einkaufslisten-Artikeln + Anzahl.
 * Tippen öffnet die Wear-App. Daten kommen aus [ShoppingRepository] (vom Handy
 * über den Data Layer gespiegelt); ein Antippen in der App selbst zeigt die
 * vollständige Liste.
 */
class ShoppingTileService : TileService() {

    private val resourcesVersion = "1"

    override fun onTileRequest(
        requestParams: RequestBuilders.TileRequest,
    ): ListenableFuture<Tile> {
        // Nur die offenen Artikel auf der Kachel.
        val open = ShoppingRepository.items.value.filter { !it.checked }
        val lang = LanguageRepository.lang.value
        val header = WearStrings.t("shoppingHeader", lang) + " (${open.size})"

        val column = LayoutElementBuilders.Column.Builder()
            .setHorizontalAlignment(LayoutElementBuilders.HORIZONTAL_ALIGN_CENTER)
            .addContent(text(header, 16f, 0xFFFF8A00.toInt()))

        if (open.isEmpty()) {
            column.addContent(text(WearStrings.t("shoppingEmpty", lang), 14f, 0xFFA89F92.toInt()))
        } else {
            // Bis zu 4 Artikel zeigen, Rest als "+N".
            val shown = open.take(4)
            for (item in shown) {
                column.addContent(text(item.text, 14f, 0xFFF5F1EA.toInt()))
            }
            if (open.size > shown.size) {
                column.addContent(
                    text("+${open.size - shown.size}", 13f, 0xFFA89F92.toInt()),
                )
            }
        }

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
                ModifiersBuilders.Modifiers.Builder().setClickable(clickable).build(),
            )
            .addContent(column.build())
            .build()

        val tile = Tile.Builder()
            .setResourcesVersion(resourcesVersion)
            .setFreshnessIntervalMillis(60_000)
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

    private fun text(content: String, size: Float, color: Int) =
        LayoutElementBuilders.Text.Builder()
            .setText(content)
            .setMaxLines(1)
            .setFontStyle(
                LayoutElementBuilders.FontStyle.Builder()
                    .setSize(DimensionBuilders.sp(size))
                    .setColor(argb(color))
                    .build(),
            )
            .build()
}
