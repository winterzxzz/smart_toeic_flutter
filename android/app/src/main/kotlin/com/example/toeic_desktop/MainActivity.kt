package com.example.toeic_desktop

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
