package com.example.toeic_desktop

import android.content.Context
import android.content.Intent
import android.util.Log
import androidx.glance.GlanceId
import androidx.glance.action.ActionParameters
import androidx.glance.appwidget.action.ActionCallback

class TOEICGlanceActionCallback: ActionCallback {
    override suspend fun onAction(
        context: Context,
        glanceId: GlanceId,
        parameters: ActionParameters
    ) {
        val deepLink = parameters[DeepLinkKey]
        
        // Handle deep link
        if (deepLink != null) {
            Log.d("TOEICGlanceActionCallback", "Handling deep link: $deepLink")
            // Handle deep link by starting MainActivity (Flutter)
            val intent = Intent(context, MainActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
                putExtra("deep_link", deepLink)
            }
            context.startActivity(intent)
        }
    }
}