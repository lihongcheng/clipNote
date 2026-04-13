# Flutter
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Isar
-keep class dev.isar.** { *; }
-dontwarn dev.isar.**

# Keep our models
-keep class cn.inaiworld.clipnote.** { *; }

# Kotlin
-keep class kotlin.** { *; }
-keepclassmembers class **$WhenMappings {
    <fields>;
}

# Share Plus
-keep class com.example.share_plus.** { *; }

# Flutter embedding may keep optional deferred-components references even when
# this app doesn't use Play deferred components directly.
-dontwarn com.google.android.play.core.tasks.OnFailureListener
-dontwarn com.google.android.play.core.tasks.OnSuccessListener
-dontwarn com.google.android.play.core.tasks.Task
