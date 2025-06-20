package com.example.toeic_desktop

import android.content.Intent
import android.os.Bundle
import android.net.Uri
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.util.Log

class MainActivity : FlutterActivity() {

    companion object {
        private const val CHANNEL = "com.example.toeic_desktop/deeplink"
        private const val DEEPLINK_KEY = "deep_link"
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
}
