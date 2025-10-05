package com.example.toeic_desktop

import android.content.Context
import android.util.Log
import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.GlanceAppWidgetReceiver
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import com.example.toeic_desktop.data.ContentPreferences

class FlashcardListGlanceWidgetReceiver : GlanceAppWidgetReceiver() {
    override val glanceAppWidget: GlanceAppWidget = FlashcardListGlanceWidget()

    override fun onEnabled(context: Context) {
        super.onEnabled(context)
        Log.d("FlashcardListWidget", "List widget added")
        CoroutineScope(Dispatchers.IO).launch {
            FlashcardListGlanceWidget.updateListStateWithAllFlashcards(context)
        }
    }

    override fun onDeleted(context: Context, appWidgetIds: IntArray) {
        super.onDeleted(context, appWidgetIds)
        Log.d("FlashcardListWidget", "List widget removed")
    }

    override fun onDisabled(context: Context) {
        super.onDisabled(context)
        Log.d("FlashcardListWidget", "Last list widget removed")
    }
}


