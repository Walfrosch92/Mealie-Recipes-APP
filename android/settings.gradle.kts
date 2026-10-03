pluginManagement {
    val flutterSdkPath =
        run {
            val properties = java.util.Properties()
            file("local.properties").inputStream().use { properties.load(it) }
            val flutterSdkPath = properties.getProperty("flutter.sdk")
            require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
            flutterSdkPath
        }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.11.1" apply false
    id("org.jetbrains.kotlin.android") version "2.2.20" apply false
    // Compose compiler plugin — ab Kotlin 2.0 ist der Compose-Compiler ein
    // separates Kotlin-Compiler-Plugin (statt `kotlinCompilerExtensionVersion`
    // in der app/build.gradle). Version muss zur Kotlin-Version passen.
    id("org.jetbrains.kotlin.plugin.compose") version "2.2.20" apply false
    // Kotlinx-Serialization-Plugin — generiert @Serializable-Companion-
    // Codegen (KSerializer) für die Widget-Daten-Klassen. Version muss zur
    // Kotlin-Version passen.
    id("org.jetbrains.kotlin.plugin.serialization") version "2.2.20" apply false
}

include(":app")
// Wear-OS-Companion (eigene APK, gleicher applicationId → Play installiert sie
// automatisch auf eine gekoppelte Uhr, sobald die Handy-App installiert ist).
include(":wear")
