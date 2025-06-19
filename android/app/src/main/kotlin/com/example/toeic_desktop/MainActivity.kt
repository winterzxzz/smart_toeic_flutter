package com.example.toeic_desktop

import android.content.Intent
import android.os.Bundle
import android.net.Uri
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
// Log
import android.util.Log

class MainActivity : FlutterActivity() {

    companion object {
        private const val CHANNEL = "com.example.toeic_desktop/deeplink"
    }

    private var initialLink: String? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        handleIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        handleIntent(intent)
    }

    private fun handleIntent(intent: Intent) {
        // Handle deeplink from widget parameters (Glance actionParametersOf)
        intent.getStringExtra("deep_link")?.let { deepLink ->
            Log.d("MainActivity", "Widget deeplink from extra received: $deepLink")
            sendDeepLinkToFlutter(deepLink)
            return
        }
    }

    private fun sendDeepLinkToFlutter(deepLink: String) {
        flutterEngine?.dartExecutor?.binaryMessenger?.let { messenger ->
            MethodChannel(messenger, CHANNEL).invokeMethod("onDeepLinkReceived", deepLink)
        }
    }
}
