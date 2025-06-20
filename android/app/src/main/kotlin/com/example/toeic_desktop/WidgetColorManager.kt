package com.example.toeic_desktop

import android.content.Context
import android.util.Log
import androidx.glance.appwidget.GlanceAppWidgetManager
import androidx.glance.action.actionParametersOf
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

// Utility class for easy color updates from Flutter/Activity
object WidgetColorManager {
    
    // Update color immediately from UI thread (for Flutter calls)
    fun updateColorFromFlutter(context: Context, colorHex: String) {
        Log.d("WidgetColorManager", "Updating color from Flutter: $colorHex")
        CoroutineScope(Dispatchers.IO).launch {
            updateColorSync(context, colorHex)
        }
    }
    
    // Update color immediately from UI thread using Color Int
    fun updateColorFromUI(context: Context, colorInt: Int) {
        val colorHex = "#${Integer.toHexString(colorInt).uppercase().padStart(8, '0')}"
        updateColorFromFlutter(context, colorHex)
    }
    
    // Synchronous update for immediate effect
    fun updateColorSync(context: Context, colorHex: String) {
        try {
            // Save to SharedPreferences for immediate effect
            val prefs = context.getSharedPreferences("toeic_prefs", Context.MODE_PRIVATE)
            prefs.edit().putString("bg_color", colorHex).apply()
            Log.d("WidgetColorManager", "Color saved to SharedPreferences: $colorHex")
            
            // Update widget using the callback method (similar to MainActivity approach)
            CoroutineScope(Dispatchers.Default).launch {
                val glanceAppWidgetManager = GlanceAppWidgetManager(context)
                val glanceIds = glanceAppWidgetManager.getGlanceIds(TOEICGlanceWidget::class.java)
                
                Log.d("WidgetColorManager", "Found ${glanceIds.size} widget instances")
                
                glanceIds.forEach { glanceId ->
                    val callback = TOEICGlanceActionCallback()
                    callback.onAction(
                        context,
                        glanceId,
                        actionParametersOf(ColorKey to colorHex)
                    )
                }
            }
        } catch (e: Exception) {
            Log.e("WidgetColorManager", "Error updating widget color: ${e.message}", e)
        }
    }
    
    // Alternative method: Direct widget update
    fun updateWidgetDirectly(context: Context, colorHex: String) {
        // Save color first
        val prefs = context.getSharedPreferences("toeic_prefs", Context.MODE_PRIVATE)
        prefs.edit().putString("bg_color", colorHex).apply()
        
        // Update widget
        TOEICGlanceWidget.updateTOEICGlanceWidget(context)
    }
}