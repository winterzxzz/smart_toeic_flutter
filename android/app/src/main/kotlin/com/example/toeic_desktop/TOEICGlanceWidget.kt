package com.example.toeic_desktop

import android.content.ComponentName
import androidx.glance.action.actionParametersOf
import android.content.Context
import android.content.Intent
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.glance.GlanceId
import androidx.glance.GlanceModifier
import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.GlanceAppWidgetReceiver
import androidx.glance.appwidget.provideContent
import androidx.glance.background
import androidx.glance.layout.Alignment
import androidx.glance.layout.Column
import androidx.glance.layout.Box
import androidx.glance.layout.fillMaxSize
import androidx.glance.layout.padding
import androidx.glance.layout.ContentScale
import androidx.glance.Image
import androidx.glance.ImageProvider
import androidx.glance.color.ColorProvider
import androidx.glance.text.Text
import androidx.glance.text.TextStyle
import androidx.glance.text.FontWeight
import androidx.glance.action.clickable
import androidx.glance.action.ActionParameters
import androidx.glance.action.actionStartActivity
import androidx.glance.appwidget.GlanceAppWidgetManager
import androidx.glance.appwidget.updateAll
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch


val DeepLinkKey = ActionParameters.Key<String>("deep_link")

class TOEICGlanceWidget : GlanceAppWidget() {

    override suspend fun provideGlance(context: Context, id: GlanceId) {
        provideContent {
            TOEICWidgetContent(context)
        }
    }

    @Composable
    private fun TOEICWidgetContent(context: Context) {
        val prefs = context.getSharedPreferences("toeic_prefs", Context.MODE_PRIVATE)
        val colorHex = prefs.getString("bg_color", "#26A69A")!!
        val bgColor = Color(android.graphics.Color.parseColor(colorHex))
        Box(
            modifier = GlanceModifier
                .fillMaxSize()
                .background(ColorProvider(day = bgColor, night = bgColor))
                .clickable(
                    actionStartActivity<MainActivity>(
                        actionParametersOf(DeepLinkKey to "test://winter-toeic.com/bottom-tab")
                    )
                )
        ) {
            Column(
                modifier = GlanceModifier
                    .fillMaxSize()
                    .padding(16.dp),
                verticalAlignment = Alignment.CenterVertically,
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

    fun updateTOEICGlanceWidget(context: Context) {
        CoroutineScope(Dispatchers.Default).launch {
            val glanceIds = GlanceAppWidgetManager(context).getGlanceIds(TOEICGlanceWidget::class.java)
            glanceIds.forEach { glanceId ->
                TOEICGlanceWidget().update(context, glanceId)
            }
        }
    }
    
}

class TOEICGlanceWidgetReceiver : GlanceAppWidgetReceiver() {
    override val glanceAppWidget: GlanceAppWidget = TOEICGlanceWidget()
}

