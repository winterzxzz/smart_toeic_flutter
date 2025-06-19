package com.example.toeic_desktop

import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
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
    }
    
    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        
        // Handle new intent when app is already running
        val route = intent.getStringExtra("route")
        val tabIndex = intent.getIntExtra("tab_index", -1)
        
        if (route != null && methodChannel != null) {
            val data = mapOf(
                "route" to route,
                "tab_index" to tabIndex
            )
            methodChannel?.invokeMethod("navigateFromWidget", data)
        }
    }
}
