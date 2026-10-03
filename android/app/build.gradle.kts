import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // Compose-Compiler-Plugin (Kotlin 2.0+ pflicht) — wird für Jetpack Glance
    // benötigt, das Compose-Runtime nutzt um die Home-Screen-Widgets zu rendern.
    id("org.jetbrains.kotlin.plugin.compose")
    // Kotlinx-Serialization-Plugin — Codegen für die Widget-Daten-Klassen.
    id("org.jetbrains.kotlin.plugin.serialization")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Load signing credentials from android/key.properties (not committed).
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.walfrosch92.mealie_recipes"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.walfrosch92.mealie_recipes"
        // Glance-AppWidget braucht mindestens API 23; in
        // android/app/build.gradle.kts ist das durch das Flutter-Toolchain-
        // Minimum bereits abgedeckt (Flutter 3.40+ → minSdk 23+).
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        // versionCode BEWUSST entkoppelt von der pubspec-Build-Nummer:
        // Google Play verlangt einen über ALLE Releases hinweg streng
        // steigenden Wert, während iOS die Build-Nummer bei jedem neuen
        // Versionszug wieder bei 1 starten darf (pubspec steht daher auf
        // 1.27.9+1). Bei jedem Play-Upload hier hochzählen — der Wert darf
        // nie kleiner oder gleich einem bereits hochgeladenen sein.
        versionCode = 50
        // versionName bleibt an der pubspec-Version (1.27.9).
        versionName = flutter.versionName
        multiDexEnabled = true
    }

    buildFeatures {
        // Aktiviert Jetpack-Compose-Codegen — erforderlich für Glance, das
        // intern Compose-Runtime + Compose-UI verwendet.
        compose = true
    }

    signingConfigs {
        create("release") {
            if (keystorePropertiesFile.exists()) {
                keyAlias = keystoreProperties["keyAlias"] as String?
                keyPassword = keystoreProperties["keyPassword"] as String?
                storeFile = (keystoreProperties["storeFile"] as String?)?.let { file(it) }
                storePassword = keystoreProperties["storePassword"] as String?
            }
        }
    }

    buildTypes {
        release {
            // Use the upload/release key from key.properties when present,
            // otherwise fall back to debug so `flutter run --release` still works.
            signingConfig = if (keystorePropertiesFile.exists()) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")

    // ---------------------------------------------------------------------
    // Home-Screen-Widgets — Jetpack Glance + Compose Runtime.
    //
    // Glance 1.1.1: stable Composable-AppWidget-Toolkit (1.1 ist der erste
    // production-fähige Release-Branch, 1.1.1 enthält Bugfixes für
    // Android 14/15 Konfigurationen). Bringt seine eigene Compose-Runtime-
    // Abhängigkeit mit, deswegen ist eine explizite Compose-BOM optional —
    // wir pinnen sie trotzdem für deterministische Builds.
    //
    // androidx.datastore-preferences: persistenter Key-Value-Store für die
    // Widget-Daten (Sprache + drei JSON-Strings). Iso zu UserDefaults im
    // iOS-App-Group-Container.
    //
    // kotlinx-serialization-json: parsen der von Flutter via MethodChannel
    // gepushten JSON-Strings (1:1 Schema wie iOS WidgetSharedStore Codables).
    //
    // androidx.lifecycle-runtime-ktx: stellt CoroutineScope `lifecycleScope`
    // & `runBlocking`-Helpers für DataStore I/O bereit.
    // ---------------------------------------------------------------------
    implementation(platform("androidx.compose:compose-bom:2024.09.00"))
    implementation("androidx.compose.runtime:runtime")
    implementation("androidx.compose.ui:ui")
    implementation("androidx.glance:glance:1.1.1")
    implementation("androidx.glance:glance-appwidget:1.1.1")
    implementation("androidx.glance:glance-material3:1.1.1")
    implementation("androidx.datastore:datastore-preferences:1.1.1")
    implementation("org.jetbrains.kotlinx:kotlinx-serialization-json:1.7.3")
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-android:1.8.1")
    implementation("androidx.lifecycle:lifecycle-runtime-ktx:2.8.7")

    // Wearable Data Layer — schiebt den laufenden Timer auf eine gekoppelte
    // Wear-OS-Uhr (DataClient) und empfängt deren Steuer-Aktionen
    // (MessageClient). Gegenstück läuft im :wear-Modul (gleicher applicationId).
    implementation("com.google.android.gms:play-services-wearable:18.2.0")
    // Task.await() für die Wear-MessageClient/NodeClient-Aufrufe in WearBridge.
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-play-services:1.8.1")

    // Geofencing für "Erinnere mich zum Einkaufen" (Issue #29) — feuert die
    // Benachrichtigung über einen eigenständigen BroadcastReceiver, auch wenn
    // die App komplett beendet wurde (siehe shopping_reminder/-Paket).
    implementation("com.google.android.gms:play-services-location:21.3.0")
}
