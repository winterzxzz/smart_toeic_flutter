package com.example.toeic_desktop

import android.app.AlarmManager
import android.content.Context
import android.content.Intent
import android.os.Build
import android.provider.Settings
import android.content.Intent
import android.os.Bundle
import android.net.Uri
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.util.Log
import android.content.Context
import android.content.ComponentName
import com.example.toeic_desktop.TOEICGlanceWidget



class MainActivity : FlutterActivity() {
    private val CHANNEL = "exact_alarm_channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
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
    private val CHANNEL = "com.example.toeic_desktop/widget_navigation"
    private var methodChannel: MethodChannel? = null
    
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        methodChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "getInitialRoute" -> {
                    val route = intent.getStringExtra("route")
                    val tabIndex = intent.getIntExtra("tab_index", -1)
                    
                    if (route != null) {
                        val data = mapOf(
                            "route" to route,
                            "tab_index" to tabIndex
                        )
                        result.success(data)
                        // Clear the intent data so it doesn't trigger again
                        intent.removeExtra("route")
                        intent.removeExtra("tab_index")
                    } else {
                        result.success(null)
                    }
                }
                else -> result.notImplemented()
            }
        }

    companion object {
        private const val CHANNEL = "com.example.toeic_desktop/deeplink"
        private const val WIDGET_CHANNEL = "com.example.toeic_desktop/widget"
        private const val DEEPLINK_KEY = "deep_link"
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, WIDGET_CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "updateWidgetColor") {
                val colorHex = call.argument<String>("colorHex") ?: "0xff26A69A"
                updateWidgetColorAndRefresh(colorHex)
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }

    override fun onNewIntent(intent: Intent) {
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
        val sharedPref = applicationContext.getSharedPreferences("toeic_prefs", Context.MODE_PRIVATE)
        sharedPref.edit().putString("bg_color", colorHex).apply()
        val glanceWidget = TOEICGlanceWidget()
        glanceWidget.updateTOEICGlanceWidget(applicationContext)
    }
}
