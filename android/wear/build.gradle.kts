import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    // Compose-Compiler-Plugin (Kotlin 2.0+ Pflicht) — die Wear-UI ist Compose.
    id("org.jetbrains.kotlin.plugin.compose")
}

// Signing-Credentials aus android/key.properties (nicht eingecheckt). Die
// Wear-APK MUSS mit demselben Key wie die Handy-App signiert sein — sonst
// koppelt Google Play sie nicht als Paar und der Wearable Data Layer
// verweigert die Kommunikation.
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.walfrosch92.mealie_recipes.wear"
    compileSdk = 35

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // GLEICHER applicationId wie die Handy-App — zwingend für den Wearable
        // Data Layer und für die automatische Play-Installation auf die Uhr.
        applicationId = "com.walfrosch92.mealie_recipes"
        // Wear OS 3 = API 30. OngoingActivity erscheint dort im Smart-Stack.
        minSdk = 30
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
    }

    buildFeatures {
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
            signingConfig = if (keystorePropertiesFile.exists()) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
        }
    }
}

dependencies {
    implementation(platform("androidx.compose:compose-bom:2024.09.00"))
    implementation("androidx.compose.ui:ui")
    implementation("androidx.compose.foundation:foundation")
    implementation("androidx.activity:activity-compose:1.9.2")
    implementation("androidx.core:core-ktx:1.13.1")
    implementation("androidx.lifecycle:lifecycle-runtime-ktx:2.8.7")

    // Wear Compose (Material für die Uhr).
    implementation("androidx.wear.compose:compose-material:1.4.0")
    implementation("androidx.wear.compose:compose-foundation:1.4.0")

    // Wearable Data Layer (Empfang des Timer-DataItems, Senden der Aktionen).
    implementation("com.google.android.gms:play-services-wearable:18.2.0")
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-play-services:1.8.1")

    // OngoingActivity — laufender Countdown im Wear-Smart-Stack (das Pendant
    // zur iOS Live Activity auf der Apple Watch).
    implementation("androidx.wear:wear-ongoing:1.0.0")

    // Tile — glanceable Kachel mit der Restzeit.
    implementation("androidx.wear.tiles:tiles:1.4.0")
    implementation("androidx.wear.protolayout:protolayout:1.2.0")
    implementation("androidx.wear.protolayout:protolayout-material:1.2.0")
    implementation("com.google.guava:guava:33.2.1-android")
}