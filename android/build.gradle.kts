allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
// Einige Plugins (z. B. bonsoir_android) kompilieren noch gegen ein altes
// Android-SDK; AGP 9 verweigert das, weil ihre AndroidX-Abhängigkeiten
// mindestens SDK 34 verlangen. Für Plugin-Module daher mindestens SDK 36.
subprojects {
    afterEvaluate {
        if (plugins.hasPlugin("com.android.library")) {
            val android = extensions.getByName("android")
            val current = android.javaClass.methods
                .firstOrNull { it.name == "getCompileSdk" && it.parameterCount == 0 }
                ?.invoke(android) as? Int
            if (current == null || current < 36) {
                android.javaClass.methods
                    .first { it.name == "setCompileSdk" && it.parameterCount == 1 }
                    .invoke(android, 36)
            }
        }
    }
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
