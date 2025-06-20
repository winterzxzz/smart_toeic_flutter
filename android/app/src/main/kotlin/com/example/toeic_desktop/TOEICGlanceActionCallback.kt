package com.example.toeic_desktop

import android.content.Context
import android.content.Intent
import android.util.Log
import androidx.glance.GlanceId
import androidx.glance.action.ActionParameters
import androidx.glance.appwidget.action.ActionCallback
import com.example.toeic_desktop.ColorPreferences

class TOEICGlanceActionCallback: ActionCallback {
    override suspend fun onAction(
        context: Context,
        glanceId: GlanceId,
        parameters: ActionParameters
    ) {
        val deepLink = parameters[DeepLinkKey]
        val colorHex = parameters[ColorKey]
        
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
        
        // Handle color update
        if (colorHex != null) {
            Log.d("TOEICGlanceActionCallback", "Updating widget color: $colorHex")
            
            // Save color to SharedPreferences for immediate widget access
            ColorPreferences.setColorHex(context, colorHex)
            
            // Update the widget immediately
            TOEICGlanceWidget.updateColorAndRefresh(context, colorHex)
        }
    }
}