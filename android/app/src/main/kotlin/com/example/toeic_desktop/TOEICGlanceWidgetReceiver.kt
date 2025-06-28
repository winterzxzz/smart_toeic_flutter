package com.example.toeic_desktop

import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.GlanceAppWidgetReceiver
import android.util.Log
import android.content.Context
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.launch
import com.example.toeic_desktop.data.ContentPreferences

class TOEICGlanceWidgetReceiver : GlanceAppWidgetReceiver() {
    override val glanceAppWidget: GlanceAppWidget = TOEICGlanceWidget()

    override fun onEnabled(context: Context) {
        super.onEnabled(context)
        Log.d("GlanceWidget", "Widget added to home screen!")
        // Initialize the widget with the first flash card
        CoroutineScope(Dispatchers.IO).launch {
            updateContentWidget(context)
        }
    }

    private suspend fun updateContentWidget(context: Context) {
            val currentIndex = ContentPreferences.getCurrentFlashCardIndex(context)
            val flashCards = ContentPreferences.loadFlashCards(context)
            if(flashCards.isEmpty()) {
                Log.e("GlanceWidget", "No flash cards found")
                return
            }
            val flashCard = flashCards[currentIndex]
            if (flashCard != null) {
                Log.d("GlanceWidget", "Updating widget with flash card: ${flashCard.word}")
                TOEICGlanceWidget.updateSpecificWidgetByGlanceId(context, flashCard)
            } else {
                Log.e("GlanceWidget", "No flash card found at index $currentIndex")
            }
    }

    override fun onDeleted(context: Context, appWidgetIds: IntArray) {
        super.onDeleted(context, appWidgetIds)
        Log.d("GlanceWidget", "Widget(s) removed.")
    }

    override fun onDisabled(context: Context) {
        super.onDisabled(context)
        Log.d("GlanceWidget", "Last widget removed.")
    }
}