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
