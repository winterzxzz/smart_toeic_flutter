package com.example.toeic_desktop

import android.app.AlarmManager
import android.content.Context
import android.content.Intent
import android.os.Build
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.util.Log
import androidx.glance.appwidget.GlanceAppWidgetManager
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import androidx.glance.appwidget.state.updateAppWidgetState
import androidx.glance.appwidget.updateAll
import com.example.toeic_desktop.model.FlashCard
import com.example.toeic_desktop.data.ContentPreferences
import com.example.toeic_desktop.data.ColorPreferences


class MainActivity : FlutterActivity() {
    companion object {
        private const val CHANNEL = "com.example.toeic_desktop/deeplink"
        private const val WIDGET_CHANNEL = "com.example.toeic_desktop/widget"
        private const val DEEPLINK_KEY = "deep_link"
        private const val ALARM_CHANNEL = "exact_alarm_channel"
    }
    private var methodChannel: MethodChannel? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, ALARM_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "isExactAlarmGranted" -> {
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                            val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
                            result.success(alarmManager.canScheduleExactAlarms())
                        } else {
                            result.success(true)
                        }
                    }

                    "requestExactAlarmPermission" -> {
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                            val intent = Intent(Settings.ACTION_REQUEST_SCHEDULE_EXACT_ALARM)
                            intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
                            startActivity(intent)
                        }
                        result.success(null)
                    }

                    else -> result.notImplemented()
                }
            }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, WIDGET_CHANNEL).setMethodCallHandler { call, result ->
                when (call.method) {
                    "updateWidgetColor" -> {
                        val colorHex = call.argument<String>("colorHex") ?: "#26A69A"
                        updateWidgetColorAndRefresh(colorHex)
                        result.success("Widget color updated to $colorHex")
                    }
                    "schedulePeriodicWidgetUpdate" -> {
                        val data = call.argument<HashMap<String, Any>>("flashCardShowInWidgetList")
                        if(data != null) {
                            val list = data["flashCardShowInWidgetList"] as? List<HashMap<String, String>>
                            if(list != null) {
                                val flashcards = list.map {
                                    FlashCard(
                                        word = it["word"] ?: "",
                                        definition = it["definition"] ?: "",
                                        pronunciation = it["pronunciation"] ?: "",
                                        partOfSpeech = it["partOfSpeech"] ?: ""
                                    )
                                }
                                ContentPreferences.saveFlashCards(this, flashcards)
                                WidgetWorkScheduler.schedulePeriodicWidgetUpdate(this, 15)
                            }
                        }
                        result.success("Widget update scheduled after 15 minutes")
                    }
                    "cancelWidgetUpdates" -> {
                        WidgetWorkScheduler.cancelAllWidgetUpdates(this)
                        ContentPreferences.clearAllData(this)
                        result.success("All widget updates cancelled")
                    }
                    else -> {
                        result.notImplemented()
                    }
                }
            }
        }



    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        val destination = intent.extras?.getString(DEEPLINK_KEY)
        if (destination != null) {
            sendDeepLinkToFlutter(destination)
        }
    }

    private fun sendDeepLinkToFlutter(deepLink: String) {
        flutterEngine?.dartExecutor?.binaryMessenger?.let { messenger ->
            MethodChannel(messenger, CHANNEL).invokeMethod("onDeepLinkReceived", deepLink)
        }
    }

    private fun updateWidgetColorAndRefresh(colorHex: String) {
        CoroutineScope(Dispatchers.Default).launch {
            try {
                val glanceAppWidgetManager = GlanceAppWidgetManager(applicationContext)
                val glanceIds = glanceAppWidgetManager.getGlanceIds(TOEICGlanceWidget::class.java)
                
                glanceIds.forEach { glanceId ->
                    updateAppWidgetState(applicationContext, glanceId) { prefs ->
                        prefs[ColorPreferences.COLOR_KEY] = colorHex
                    }
                }
                TOEICGlanceWidget().updateAll(applicationContext)
            } catch (e: Exception) {
                Log.e("MainActivity", "Error updating widget color: ${e.message}", e)
            }
        }
    }
}