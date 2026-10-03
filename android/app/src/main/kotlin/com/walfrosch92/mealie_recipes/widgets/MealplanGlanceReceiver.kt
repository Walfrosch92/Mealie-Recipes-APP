package com.walfrosch92.mealie_recipes.widgets

import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.GlanceAppWidgetReceiver

// AndroidManifest registriert diesen BroadcastReceiver für das
// `android.appwidget.action.APPWIDGET_UPDATE`-Intent + die korrespondierende
// `<meta-data>` zeigt auf res/xml/widget_mealplan_info.xml.
class MealplanGlanceReceiver : GlanceAppWidgetReceiver() {
    override val glanceAppWidget: GlanceAppWidget = MealplanGlanceWidget()
}
