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
