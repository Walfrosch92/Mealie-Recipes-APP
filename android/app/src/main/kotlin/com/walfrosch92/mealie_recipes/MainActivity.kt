package com.walfrosch92.mealie_recipes

import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import android.view.WindowManager
import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.GlanceAppWidgetManager
import com.walfrosch92.mealie_recipes.widgets.DailyRecipeGlanceReceiver
import com.walfrosch92.mealie_recipes.widgets.DailyRecipeGlanceWidget
import com.walfrosch92.mealie_recipes.widgets.MealplanGlanceReceiver
import com.walfrosch92.mealie_recipes.widgets.MealplanGlanceWidget
import com.walfrosch92.mealie_recipes.widgets.ShoppingListGlanceReceiver
import com.walfrosch92.mealie_recipes.widgets.ShoppingListGlanceWidget
import com.walfrosch92.mealie_recipes.shopping_reminder.ReminderLocation
import com.walfrosch92.mealie_recipes.shopping_reminder.ShoppingReminderManager
import com.walfrosch92.mealie_recipes.widgets.WidgetCredentials
import com.walfrosch92.mealie_recipes.widgets.WidgetSharedStore
import com.walfrosch92.mealie_recipes.wear.WearBridge
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.serialization.json.Json

// FlutterFragmentActivity (statt FlutterActivity): local_auth/BiometricPrompt
// braucht eine FragmentActivity, sonst wirft authenticate() „no_fragment_activity"
// und der Biometrie-Toggle in den Settings lässt sich nicht aktivieren.
class MainActivity : FlutterFragmentActivity() {
    private val wakeLockChannel = "mealie_recipes/wakelock"
    private val widgetChannel = "mealie/widget"
    private val wearChannel = "mealie/wear"
    private val shoppingReminderChannel = "mealie/shopping_reminder"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // ---- WakeLock-Channel (unverändert) ----
        // In-house wakelock replacement (mirrors the iOS WakeLockPlugin) — we
        // dropped the wakelock_plus pod because its iOS umbrella headers fail
        // Xcode 16's module verifier. Keeping behaviour identical here so the
        // shared Dart wrapper stays trivial.
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, wakeLockChannel)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "enable" -> {
                        runOnUiThread {
                            window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
                            result.success(null)
                        }
                    }
                    "disable" -> {
                        runOnUiThread {
                            window.clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
                            result.success(null)
                        }
                    }
                    else -> result.notImplemented()
                }
            }

        // ---- Widget-Bridge-Channel ----
        // Pendant zu `ios/Runner/WidgetBridge.swift`. Schreibt Widget-Daten
        // in DataStore<Preferences> (siehe WidgetSharedStore) und löst
        // anschließend ein Recompose der entsprechenden Glance-Widget-IDs aus.
        //
        // API (1:1 zu Swift-Seite):
        //   • saveLanguage  { lang: String }      → all widgets reload
        //   • saveMealplan  { json: String }      → MealplanGlanceWidget reload
        //   • saveShopping  { json: String }      → ShoppingListGlanceWidget reload
        //   • saveDaily     { json: String }      → DailyRecipeGlanceWidget reload
        //   • reload        { kind?: String }     → ein/alle Widget(s) refresh
        val ctx: Context = applicationContext
        val scope = CoroutineScope(Dispatchers.IO)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, widgetChannel)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "saveLanguage" -> {
                        val lang = call.argument<String>("lang") ?: "de"
                        scope.launch {
                            WidgetSharedStore.saveLanguage(ctx, lang)
                            reloadAll(ctx)
                        }
                        result.success(null)
                    }
                    "saveMealplan" -> {
                        val json = call.argument<String>("json") ?: "[]"
                        scope.launch {
                            WidgetSharedStore.saveMealplanRaw(ctx, json)
                            reload(ctx, "MealplanWidget")
                        }
                        result.success(null)
                    }
                    "saveShopping" -> {
                        val json = call.argument<String>("json") ?: "[]"
                        scope.launch {
                            WidgetSharedStore.saveShoppingRaw(ctx, json)
                            reload(ctx, "ShoppingListWidget")
                        }
                        result.success(null)
                    }
                    "saveDaily" -> {
                        val json = call.argument<String>("json") ?: "[]"
                        scope.launch {
                            WidgetSharedStore.saveDailyRaw(ctx, json)
                            reload(ctx, "DailyRecipeWidget")
                        }
                        result.success(null)
                    }
                    "saveServerAccess" -> {
                        // Zugang für die Selbst-Aktualisierung der Widgets,
                        // Keystore-verschlüsselt (WidgetCredentials).
                        val json = call.argument<String>("json") ?: ""
                        scope.launch {
                            WidgetCredentials.save(ctx, json)
                            reloadAll(ctx)
                        }
                        result.success(null)
                    }
                    "reload" -> {
                        val kind = call.argument<String>("kind")
                        scope.launch {
                            if (kind != null) reload(ctx, kind) else reloadAll(ctx)
                        }
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }

        // ---- Wear-OS-Timer-/Kochmodus-Channel ----
        // Pendant zur iOS LiveActivity: schreibt die laufenden/pausierten
        // Timer + den Kochmodus-Navigationszustand in den Wearable Data Layer
        // (siehe WearBridge) und nimmt Steuer-Aktionen der Uhr (über
        // PhoneWearListenerService → WearBridge.dispatchAction/
        // dispatchCookingAction) als `action`/`cookingAction`-MethodCall
        // zurück an Flutter entgegen.
        val wearMc = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, wearChannel)
        wearMc.setMethodCallHandler { call, result ->
            when (call.method) {
                "updateTimers" -> {
                    val json = call.argument<String>("json") ?: "[]"
                    WearBridge.updateTimers(ctx, json)
                    result.success(null)
                }
                "clearTimers" -> {
                    WearBridge.clearTimers(ctx)
                    result.success(null)
                }
                "updateCookingMode" -> {
                    val canBack = call.argument<Boolean>("canBack") ?: false
                    val canNext = call.argument<Boolean>("canNext") ?: false
                    WearBridge.updateCooking(ctx, canBack, canNext)
                    result.success(null)
                }
                "clearCookingMode" -> {
                    WearBridge.clearCooking(ctx)
                    result.success(null)
                }
                "updateShopping" -> {
                    val json = call.argument<String>("json") ?: "[]"
                    WearBridge.updateShopping(ctx, json)
                    result.success(null)
                }
                "clearShopping" -> {
                    WearBridge.clearShopping(ctx)
                    result.success(null)
                }
                "updateLanguage" -> {
                    val lang = call.argument<String>("lang") ?: "en"
                    WearBridge.updateLanguage(ctx, lang)
                    result.success(null)
                }
                "timerFinished" -> {
                    val id = call.argument<Int>("id") ?: -1
                    WearBridge.sendTimerFinished(ctx, id)
                    result.success(null)
                }
                "dismissFinishedAlarm" -> {
                    // Wear OS hat (anders als die Apple Watch) kein liegendes
                    // „Timer fertig"-Banner zum Wegräumen — der Finish-Alarm ist
                    // transient (Vibration/Ton) und ein evtl. geplanter Exact-
                    // Alarm wird ohnehin schon per clearTimers gecancelt. Daher
                    // hier bewusst ein No-op (nur zur sauberen Channel-Abdeckung;
                    // die mitgesendeten `ids` werden nicht gebraucht).
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
        // Channel-Referenz für eingehende Watch-Aktionen verfügbar machen.
        WearBridge.channel = wearMc

        // ---- Shopping-Reminder-Geofence-Channel (Issue #29) ----
        // Registriert/entfernt die echten OS-Geofences über den GeofencingClient
        // (siehe ShoppingReminderManager). Das eigentliche Feuern der
        // Benachrichtigung läuft komplett unabhängig davon im
        // GeofenceBroadcastReceiver, auch bei beendeter App.
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, shoppingReminderChannel)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "setLocations" -> {
                        val json = call.argument<String>("json") ?: "[]"
                        val locations = runCatching {
                            Json.decodeFromString<List<ReminderLocation>>(json)
                        }.getOrDefault(emptyList())
                        ShoppingReminderManager.setLocations(ctx, locations)
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        // Veraltete Channel-Referenz lösen, sobald die Engine abgebaut wird —
        // sonst würde WearBridge.dispatchAction in einen toten Messenger senden
        // statt auf den App-Start-Fallback auszuweichen.
        WearBridge.channel = null
        super.cleanUpFlutterEngine(flutterEngine)
    }

    /**
     * Triggert einen Recompose aller aktiv platzierten Instanzen eines
     * bestimmten Widget-Kinds. Die Kind-Strings sind die Swift-`Widget.kind`-
     * Identifiers (`MealplanWidget`/`ShoppingListWidget`/`DailyRecipeWidget`),
     * damit die Flutter-Seite plattformneutral bleibt.
     */
    private suspend fun reload(context: Context, kind: String) {
        when (kind) {
            "MealplanWidget" ->
                reloadFor(context, MealplanGlanceReceiver::class.java, MealplanGlanceWidget())
            "ShoppingListWidget" ->
                reloadFor(context, ShoppingListGlanceReceiver::class.java, ShoppingListGlanceWidget())
            "DailyRecipeWidget" ->
                reloadFor(context, DailyRecipeGlanceReceiver::class.java, DailyRecipeGlanceWidget())
            else -> reloadAll(context)
        }
    }

    private suspend fun reloadAll(context: Context) {
        reloadFor(context, MealplanGlanceReceiver::class.java, MealplanGlanceWidget())
        reloadFor(context, ShoppingListGlanceReceiver::class.java, ShoppingListGlanceWidget())
        reloadFor(context, DailyRecipeGlanceReceiver::class.java, DailyRecipeGlanceWidget())
    }

    /**
     * Recomposed NUR die Instanzen des angegebenen Widget-Typs. Die ids kommen
     * vom AUTORITATIVEN `AppWidgetManager` über die explizite Receiver-
     * ComponentName — NICHT über `GlanceAppWidgetManager.getGlanceIds(Class)`,
     * dessen gecachtes Receiver↔Provider-Mapping IDs fremder Widget-Typen
     * zurückliefern kann (Bug: nach App-Foreground wurde z.B. der Shopping-Slot
     * mit Mealplan-Inhalt überschrieben). So trifft jedes update() garantiert
     * nur den richtigen Slot.
     */
    private suspend fun reloadFor(
        context: Context,
        receiver: Class<*>,
        widget: GlanceAppWidget,
    ) {
        try {
            val awm = AppWidgetManager.getInstance(context) ?: return
            val appWidgetIds = awm.getAppWidgetIds(ComponentName(context, receiver))
            if (appWidgetIds.isEmpty()) return
            val gm = GlanceAppWidgetManager(context)
            for (appWidgetId in appWidgetIds) {
                val glanceId = gm.getGlanceIdBy(appWidgetId)
                widget.update(context, glanceId)
            }
        } catch (e: Exception) {
            // Best-effort: auf Geräten ohne AppWidget-Host (z.B. Wear OS, wenn
            // die App mit gleichem applicationId dort landet) ist der Manager
            // null → NPE. Darf die App nicht crashen lassen.
            android.util.Log.w("MainActivity", "Glance reload skipped: ${e.message}")
        }
    }
}
