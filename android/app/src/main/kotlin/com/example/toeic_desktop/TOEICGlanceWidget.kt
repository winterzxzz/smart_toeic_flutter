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
import androidx.glance.appwidget.SizeMode
import androidx.glance.state.PreferencesGlanceStateDefinition
import androidx.glance.state.GlanceStateDefinition
import androidx.datastore.preferences.core.Preferences
import androidx.glance.currentState




class TOEICGlanceWidget : GlanceAppWidget() {

    override val sizeMode = SizeMode.Exact

    override var stateDefinition: GlanceStateDefinition<*> = PreferencesGlanceStateDefinition

    override suspend fun provideGlance(context: Context, id: GlanceId) {
        
        provideContent {
            val prefs = currentState<Preferences>()
            val colorHex = prefs[ColorPreferences.COLOR_KEY] ?: "#26A69A"
            TOEICWidgetContent(context, colorHex)
        }
    }

    @Composable
    private fun TOEICWidgetContent(context: Context, colorHex: String) {
        
        val bgColor = try {
            Color(android.graphics.Color.parseColor(colorHex))
        } catch (e: Exception) {
            Log.e("TOEICGlanceWidget", "Invalid color format: $colorHex, using default")
            Color(android.graphics.Color.parseColor("#26A69A")) // Default color
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
                    text = "The coldest season of the year, typically bringing snow, frost, and shorter daylight hours.",
                    style = TextStyle(
                        fontSize = 14.sp,
                        color = ColorProvider(day = Color.White, night = Color.White)
                    )
                )
            }
        }
    }

    companion object {
        // Call this whenever you want to update the widget
        fun updateWidgetImmediately(context: Context) {
            CoroutineScope(Dispatchers.IO).launch {
                try {
                    TOEICGlanceWidget().updateAll(context)
                } catch (e: Exception) {
                }
            }
        }

        // Call this when color changes
        fun updateColorAndRefresh(context: Context, colorHex: String) {
            // Save to SharedPreferences
            ColorPreferences.setColorHexImmediate(context, colorHex)
            
            // Trigger immediate widget update
            updateWidgetImmediately(context)
        }
    }
}