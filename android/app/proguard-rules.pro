# Keep the Worker class and its inner members
-keep class com.example.toeic_desktop.WidgetUpdateWorker { *; }

# If you use WorkManager and Data or Constraints (you do)
-keep class androidx.work.** { *; }
-dontwarn androidx.work.**
