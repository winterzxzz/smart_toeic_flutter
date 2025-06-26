package com.example.toeic_desktop

import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.GlanceAppWidgetReceiver
import android.util.Log
import android.content.Context

class TOEICGlanceWidgetReceiver : GlanceAppWidgetReceiver() {
    override val glanceAppWidget: GlanceAppWidget = TOEICGlanceWidget()

    override fun onEnabled(context: Context) {
        super.onEnabled(context)
        Log.d("GlanceWidget", "Widget added to home screen!")
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