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
import androidx.glance.layout.Row
import androidx.glance.layout.Box
import androidx.glance.layout.Spacer
import androidx.glance.layout.fillMaxSize
import androidx.glance.layout.fillMaxWidth
import androidx.glance.layout.padding
import androidx.glance.layout.ContentScale
import androidx.glance.color.ColorProvider
import androidx.glance.text.Text
import androidx.glance.text.TextStyle
import androidx.glance.text.FontWeight
import androidx.glance.action.clickable
import androidx.glance.action.actionParametersOf
import androidx.glance.appwidget.updateAll
import androidx.glance.appwidget.action.actionRunCallback
import androidx.glance.Image
import androidx.glance.ImageProvider
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import android.util.Log
import androidx.glance.appwidget.SizeMode
import androidx.glance.state.PreferencesGlanceStateDefinition
import androidx.glance.state.GlanceStateDefinition
import androidx.datastore.preferences.core.Preferences
import androidx.glance.currentState
import com.google.gson.Gson
import com.example.toeic_desktop.data.ColorPreferences
import com.example.toeic_desktop.data.ContentPreferences
import com.example.toeic_desktop.model.FlashCard




class TOEICGlanceWidget : GlanceAppWidget() {

    override val sizeMode = SizeMode.Exact

    override var stateDefinition: GlanceStateDefinition<*> = PreferencesGlanceStateDefinition

    override suspend fun provideGlance(context: Context, id: GlanceId) {
        
        provideContent {
            val prefs = currentState<Preferences>()
            val colorHex = prefs[ColorPreferences.COLOR_KEY] ?: "#26A69A" 
            val flashCardJson = prefs[ContentPreferences.CONTENT_KEY] ?: ""
            val flashCard = if(flashCardJson.isNotEmpty()) {
                Gson().fromJson(flashCardJson, FlashCard::class.java)
            } else {
                null
            }
            TOEICWidgetContent(context, colorHex, flashCard)
        }
    }

    @Composable
    private fun TOEICWidgetContent(context: Context, colorHex: String, flashCard: FlashCard?) {
        
        val bgColor = try {
            val colorString = if (colorHex.startsWith("#")) colorHex else "#$colorHex"
            Color(android.graphics.Color.parseColor(colorString))
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
                            DeepLinkKey to "test://winter-toeic.com/bottom-tab?isFromWidget=true"
                        )
                    )
                )
        ) {

            Image(
                provider = ImageProvider(R.drawable.bg_flashcard),
                contentDescription = "Background",
                modifier = GlanceModifier.fillMaxSize(),
                contentScale = ContentScale.Crop,
            )

            Box(
                modifier = GlanceModifier
                    .fillMaxSize()
                    .background(ColorProvider(day = Color(0xAA000000), night = Color(0xAA000000))) // semi-transparent black
            ) {}

            
            if(flashCard != null) {
            Column(
                modifier = GlanceModifier
                    .fillMaxSize()
                    .padding(16.dp),
                verticalAlignment = Alignment.Top,
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                Row(
                    modifier = GlanceModifier
                        .fillMaxWidth()
                        .padding(8.dp),
                        horizontalAlignment = Alignment.CenterHorizontally
                ) {
                    Text(
                        text = flashCard.word,
                        style = TextStyle(
                            fontSize = 24.sp,
                            fontWeight = FontWeight.Bold,
                            color = ColorProvider(day = Color.White, night = Color.White)
                        )
                    )
                    Text(
                        text = flashCard.pronunciation,
                        style = TextStyle(
                            fontSize = 14.sp,
                            color = ColorProvider(day = Color.White, night = Color.White)
                        ),
                        modifier = GlanceModifier.padding(start = 8.dp)
                    )
                }
                Text(
                        text = "(${flashCard.partOfSpeech}) ${flashCard.definition}",
                        style = TextStyle(
                            fontSize = 14.sp,
                            color = ColorProvider(day = Color.White, night = Color.White)
                        )
                )
            }
            } else {
                Column(
                modifier = GlanceModifier
                    .fillMaxSize()
                    .padding(16.dp),
                verticalAlignment = Alignment.Top,
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                    Text(
                        text = "No data",
                        style = TextStyle(
                            fontSize = 24.sp,
                            fontWeight = FontWeight.Bold,
                            color = ColorProvider(day = Color.White, night = Color.White)
                        )
                    )
                    Text(
                        text = "Open the app to load flashcards.",
                        style = TextStyle(
                            fontSize = 14.sp,
                            color = ColorProvider(day = Color.White, night = Color.White)
                        )
                    )
                }
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