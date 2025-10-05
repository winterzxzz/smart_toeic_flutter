package com.example.toeic_desktop

import android.content.Context
import android.util.Log
import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.DpSize
import androidx.compose.ui.unit.sp
import androidx.datastore.preferences.core.Preferences
import androidx.glance.*
import androidx.glance.action.actionParametersOf
import androidx.glance.action.clickable
import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.GlanceAppWidgetManager
import androidx.glance.appwidget.SizeMode
import androidx.glance.appwidget.action.actionRunCallback
import androidx.glance.appwidget.provideContent
import androidx.glance.appwidget.state.updateAppWidgetState
import androidx.glance.appwidget.updateAll
import androidx.glance.background
import androidx.glance.color.ColorProvider
import androidx.glance.currentState
import androidx.glance.layout.*
import androidx.glance.text.FontWeight
import androidx.glance.text.Text
import androidx.glance.text.TextStyle
import androidx.glance.state.GlanceStateDefinition
import androidx.glance.state.PreferencesGlanceStateDefinition
import com.example.toeic_desktop.data.ColorPreferences
import com.example.toeic_desktop.data.ContentPreferences
import com.example.toeic_desktop.model.FlashCard
import kotlinx.coroutines.*

class FlashcardListGlanceWidget : GlanceAppWidget() {

    // Responsive cho phép Glance render chính xác trên nhiều kích thước
    override val sizeMode = SizeMode.Responsive(
        setOf(
            DpSize(200.dp, 100.dp),
            DpSize(300.dp, 200.dp),
            DpSize(400.dp, 300.dp),
        )
    )

    override var stateDefinition: GlanceStateDefinition<*> = PreferencesGlanceStateDefinition

    override suspend fun provideGlance(context: Context, id: GlanceId) {
        provideContent {
            val prefs = currentState<Preferences>()
            val colorHex = prefs[ColorPreferences.COLOR_KEY] ?: "#26A69A"

            // Load dữ liệu trực tiếp (bên trong remember để tránh reload nhiều lần)
            val flashcards: List<FlashCard> = remember(Unit) {
                ContentPreferences.loadFlashCards(context)
            }

            Log.d("FlashcardListWidget", "Loaded ${flashcards.size} flashcards")

            FlashcardListContent(context, colorHex, flashcards)
        }
    }

    @Composable
    private fun FlashcardListContent(
        context: Context,
        colorHex: String,
        flashcards: List<FlashCard>,
    ) {
        val bgColor = try {
            val colorString = if (colorHex.startsWith("#")) colorHex else "#$colorHex"
            Color(android.graphics.Color.parseColor(colorString))
        } catch (e: Exception) {
            Log.e("FlashcardListWidget", "Invalid color: $colorHex")
            Color(android.graphics.Color.parseColor("#26A69A"))
        }

        Box(
            modifier = GlanceModifier
                .fillMaxSize()
                .clickable(
                    actionRunCallback<TOEICGlanceActionCallback>(
                        actionParametersOf(
                            DeepLinkKey to "test://winter-toeic.com/bottom-tab?isFromWidget=true"
                        )
                    )
                )
                .padding(10.dp)
        ) {
            // Card container with rounded corners and light background
            Column(
                modifier = GlanceModifier
                    .fillMaxSize()
                    // Fallback for older Glance versions: emulate rounded corners using inner padding
                    .padding(0.dp)
                    .background(
                        ColorProvider(
                            day = Color(0xFFF7F9FC),
                            night = Color(0xFF1E1F24)
                        )
                    )
            ) {
                // Colored header strip
                Box(
                    modifier = GlanceModifier
                        .fillMaxWidth()
                        .background(ColorProvider(day = bgColor, night = bgColor))
                        .padding(horizontal = 12.dp, vertical = 10.dp)
                ) {
                    Text(
                        text = "Learning words",
                        style = TextStyle(
                            fontSize = 18.sp,
                            fontWeight = FontWeight.Bold,
                            color = ColorProvider(day = Color.White, night = Color.White)
                        )
                    )
                }

                // Content area
                Column(
                    modifier = GlanceModifier
                        .fillMaxSize()
                        .padding(12.dp)
                ) {
                    if (flashcards.isEmpty()) {
                        Text(
                            text = "Open the app to load flashcards.",
                            style = TextStyle(
                                fontSize = 14.sp,
                                color = ColorProvider(day = Color(0xFF6B7280), night = Color(0xFFBEC3CC))
                            )
                        )
                    } else {
                        val maxItems = 6
                        Column(
                            modifier = GlanceModifier
                                .fillMaxWidth()
                        ) {
                            flashcards.take(maxItems).forEachIndexed { index, fc ->
                                Row(
                                    modifier = GlanceModifier
                                        .fillMaxWidth()
                                        .padding(vertical = 4.dp)
                                ) {
                                    Text(
                                        text = "${index + 1}.",
                                        style = TextStyle(
                                            fontSize = 14.sp,
                                            fontWeight = FontWeight.Bold,
                                            color = ColorProvider(day = bgColor, night = bgColor)
                                        ),
                                    )
                                    Text(
                                        text = " ${fc.word} ${fc.pronunciation}",
                                        style = TextStyle(
                                            fontSize = 14.sp,
                                            color = ColorProvider(day = Color(0xFF111827), night = Color(0xFFE5E7EB))
                                        ),
                                    )
                                }
                            }
                            if (flashcards.size > maxItems) {
                                Text(
                                    text = "+${flashcards.size - maxItems} more",
                                    style = TextStyle(
                                        fontSize = 12.sp,
                                        color = ColorProvider(day = Color(0xFF6B7280), night = Color(0xFFBEC3CC))
                                    ),
                                    modifier = GlanceModifier.padding(top = 6.dp)
                                )
                            }
                        }
                    }
                }
            }
        }
    }

    companion object {
        fun updateListStateWithAllFlashcards(context: Context) {
            CoroutineScope(Dispatchers.IO).launch {
                try {
                    val glanceManager = GlanceAppWidgetManager(context)
                    val glanceIds = glanceManager.getGlanceIds(FlashcardListGlanceWidget::class.java)
                    glanceIds.forEach { glanceId ->
                        updateAppWidgetState(context, glanceId) { prefs ->
                            prefs[ColorPreferences.COLOR_KEY] =
                                ColorPreferences.getColorHexImmediate(context)
                        }
                    }
                    FlashcardListGlanceWidget().updateAll(context)
                    Log.d("FlashcardListWidget", "Widget updated successfully")
                } catch (e: Exception) {
                    Log.e("FlashcardListWidget", "Failed to update list state", e)
                }
            }
        }

        suspend fun isWidgetAdded(context: Context): Boolean {
            return withContext(Dispatchers.IO) {
                try {
                    val glanceManager = GlanceAppWidgetManager(context)
                    val glanceIds = glanceManager.getGlanceIds(FlashcardListGlanceWidget::class.java)
                    glanceIds.isNotEmpty()
                } catch (e: Exception) {
                    Log.e("FlashcardListWidget", "Error checking widget", e)
                    false
                }
            }
        }
    }
}