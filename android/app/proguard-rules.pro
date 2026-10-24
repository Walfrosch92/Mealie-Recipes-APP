# Wird vom Flutter-Gradle-Plugin automatisch in den Release-Build (R8)
# eingebunden.

# flutter_local_notifications (geplante „Timer fertig"-Notifications) speichert
# und liest seine Notification-Details per Gson mit `new TypeToken<…>() {}`.
# R8 (Full Mode) entfernt sonst die generische Signatur bzw. benennt die
# Modellklassen um → Absturz „IllegalStateException … TypeToken" (Play-Console,
# Build 41: com.google.gson.reflect.TypeToken.getTypeTokenTypeArgument).
# Regeln laut Plugin-Doku.
-keepattributes Signature
-keep class com.google.gson.reflect.TypeToken
-keep class * extends com.google.gson.reflect.TypeToken
-keep public class * implements java.lang.reflect.Type
-keep class com.dexterous.** { *; }

# WorkManager (kommt transitiv über Jetpack Glance, work-runtime 2.7.1 mit
# Room 2.2.5) erzeugt seine Datenbank per Reflection:
# Class.forName("…WorkDatabase_Impl").newInstance(). Die Consumer-Regel von
# Room 2.2.5 („-keep class * extends RoomDatabase“) hält im R8-Full-Mode
# (AGP 9) nur die Klasse, NICHT den parameterlosen Konstruktor → Absturz beim
# App-Start „Failed to create an instance of androidx.work.impl.WorkDatabase“
# (androidx.startup.InitializationProvider). Konstruktor ausdrücklich behalten.
-keep class * extends androidx.room.RoomDatabase { <init>(); }
