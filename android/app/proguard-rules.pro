# Keep the Worker class and its inner members
-keep class com.example.toeic_desktop.WidgetUpdateWorker { *; }

# If you use WorkManager and Data or Constraints (you do)
-keep class androidx.work.impl.** { *; }
-keep class androidx.work.** { *; }
-dontwarn androidx.work.**


## Gson rules
# Gson uses generic type information stored in a class file when working with fields. Proguard
# removes such information by default, so configure it to keep all of it.
-keepattributes Signature

# For using GSON @Expose annotation
-keepattributes *Annotation*

# Gson specific classes
-dontwarn sun.misc.**
#-keep class com.google.gson.stream.** { *; }

# Prevent proguard from stripping interface information from TypeAdapter, TypeAdapterFactory,
# JsonSerializer, JsonDeserializer instances (so they can be used in @JsonAdapter)
-keep class * extends com.google.gson.TypeAdapter
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer

# Prevent R8 from leaving Data object members always null
-keepclassmembers,allowobfuscation class * {
  @com.google.gson.annotations.SerializedName <fields>;
}

# Retain generic signatures of TypeToken and its subclasses with R8 version 3.0 and higher.
-keep,allowobfuscation,allowshrinking class com.google.gson.reflect.TypeToken
-keep,allowobfuscation,allowshrinking class * extends com.google.gson.reflect.TypeToken


# Kotlin coroutines (used by WorkManager internally)
-keepclassmembers class kotlinx.coroutines.** {
    *;
}
-dontwarn kotlinx.coroutines.**

# Needed for Flutter plugin registration
-keep class io.flutter.plugins.GeneratedPluginRegistrant { *; }

# Avoid stripping annotations
-keepattributes *Annotation*

# General Flutter
-keep class io.flutter.** { *; }
-keep class io.flutter.embedding.** { *; }

# Google Play Core - suppress warnings for missing classes
# These classes are part of dynamic feature delivery which may not be used
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.splitinstall.SplitInstallException
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManager
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManagerFactory
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest$Builder
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest
-dontwarn com.google.android.play.core.splitinstall.SplitInstallSessionState
-dontwarn com.google.android.play.core.splitinstall.SplitInstallStateUpdatedListener
-dontwarn com.google.android.play.core.tasks.OnFailureListener
-dontwarn com.google.android.play.core.tasks.OnSuccessListener
-dontwarn com.google.android.play.core.tasks.Task

# Keep AdMob classes
-keep class com.google.android.gms.ads.** { *; }
-dontwarn com.google.android.gms.ads.**