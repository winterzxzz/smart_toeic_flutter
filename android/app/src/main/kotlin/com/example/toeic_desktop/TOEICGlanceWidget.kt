package com.example.toeic_desktop

import android.content.Context
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.glance.GlanceId
import androidx.glance.GlanceModifier
import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.provideContent
import androidx.glance.background
import androidx.glance.layout.Alignment
import androidx.glance.layout.Column
import androidx.glance.layout.Box
import androidx.glance.layout.fillMaxSize
import androidx.glance.layout.padding
import androidx.glance.color.ColorProvider
import androidx.glance.text.Text
import androidx.glance.text.TextStyle
import androidx.glance.text.FontWeight
import androidx.glance.action.clickable
import androidx.glance.action.actionParametersOf
import androidx.glance.appwidget.updateAll
import androidx.glance.appwidget.action.actionRunCallback
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import android.util.Log
import com.example.toeic_desktop.ColorPreferences

class TOEICGlanceWidget : GlanceAppWidget() {
    
    override suspend fun provideGlance(context: Context, id: GlanceId) {
        provideContent {
            TOEICWidgetContent(context)
        }
    }

    @Composable
    private fun TOEICWidgetContent(context: Context) {
        val colorHex = ColorPreferences.getColorHexImmediate(context)
        
        Log.d("TOEICGlanceWidget", "Widget recomposing with colorHex: $colorHex")
        
        val bgColor = try {
            Color(android.graphics.Color.parseColor(colorHex))
        } catch (e: Exception) {
            Log.e("TOEICGlanceWidget", "Invalid color format: $colorHex, using default")
            Color(android.graphics.Color.parseColor("#26A69A"))
        }
        
        Box(
            modifier = GlanceModifier
                .fillMaxSize()
                .background(ColorProvider(day = bgColor, night = bgColor))
                .clickable(
                    actionRunCallback<TOEICGlanceActionCallback>(
                        actionParametersOf(
                            DeepLinkKey to "test://winter-toeic.com/bottom-tab"
                        )
                    )
                )
        ) {
            Column(
                modifier = GlanceModifier
                    .fillMaxSize()
                    .padding(16.dp),
                verticalAlignment = Alignment.Top,
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                Text(
                    text = "Winter",
                    style = TextStyle(
                        fontSize = 18.sp,
                        fontWeight = FontWeight.Bold,
                        color = ColorProvider(day = Color.White, night = Color.White)
                    )
                )
                Text(
                    text = "The coldest season of the year, occurring between autumn and spring, typically characterized by cold temperatures, shorter days, and in many regions, snowfall.",
                    style = TextStyle(
                        fontSize = 14.sp,
                        color = ColorProvider(day = Color.White, night = Color.White)
                    )
                )
            }
        }
    }

    companion object {
        // Method 1: Update all widgets immediately
        fun updateTOEICGlanceWidget(context: Context) {
            Log.d("TOEICGlanceWidget", "updateTOEICGlanceWidget called")
            CoroutineScope(Dispatchers.IO).launch {
                try {
                    val widget = TOEICGlanceWidget()
                    widget.updateAll(context)
                    Log.d("TOEICGlanceWidget", "Widget updateAll completed")
                } catch (e: Exception) {
                    Log.e("TOEICGlanceWidget", "Error updating widget: ${e.message}", e)
                }
            }
        }
        
        // Method 2: Update specific widget by ID
        suspend fun updateWidget(context: Context, glanceId: GlanceId) {
            try {
                val widget = TOEICGlanceWidget()
                widget.update(context, glanceId)
                Log.d("TOEICGlanceWidget", "Single widget updated for ID: $glanceId")
            } catch (e: Exception) {
                Log.e("TOEICGlanceWidget", "Error updating single widget: ${e.message}", e)
            }
        }
        
        // Method 3: Update color and refresh immediately
        fun updateColorAndRefresh(context: Context, colorHex: String) {
            Log.d("TOEICGlanceWidget", "Updating color to: $colorHex")
            
            // Save color to SharedPreferences
            ColorPreferences.setColorHexImmediate(context, colorHex)
            
            // Immediately update all widgets
            updateTOEICGlanceWidget(context)
        }
    }
}