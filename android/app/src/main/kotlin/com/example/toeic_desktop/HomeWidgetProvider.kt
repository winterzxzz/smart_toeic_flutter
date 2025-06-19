package com.example.toeic_desktop

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin


class HomeWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        super.onUpdate(context, appWidgetManager, appWidgetIds)

        for (id in appWidgetIds) {
            val options = appWidgetManager.getAppWidgetOptions(id)
            val minWidth = options.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_WIDTH)
            val minHeight = options.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_HEIGHT)

            val layoutId = when {
                minWidth >= 250 && minHeight >= 150 -> R.layout.home_widget_large
                minWidth >= 200 -> R.layout.home_widget_medium
                else -> R.layout.home_widget_small
            }

            val prefs = HomeWidgetPlugin.getData(context)
            val text = prefs.getString("widgetText", "Welcome") ?: "Welcome"

            val views = RemoteViews(context.packageName, layoutId)
            views.setTextViewText(R.id.widget_text, text)

            appWidgetManager.updateAppWidget(id, views)
        }
    }

    override fun onEnabled(context: Context) {
        super.onEnabled(context)
        val manager = AppWidgetManager.getInstance(context)
        val ids = manager.getAppWidgetIds(ComponentName(context, HomeWidgetProvider::class.java))
        onUpdate(context, manager, ids)
    }
}

