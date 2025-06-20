package com.example.toeic_desktop

import android.content.Context
import android.util.Log
import androidx.work.Worker
import androidx.work.WorkerParameters
import androidx.work.CoroutineWorker
import androidx.glance.appwidget.GlanceAppWidgetManager
import androidx.glance.appwidget.updateAll
import androidx.glance.appwidget.state.updateAppWidgetState
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

class WidgetUpdateWorker(
    context: Context,
    workerParams: WorkerParameters
) : CoroutineWorker(context, workerParams) {

    override suspend fun doWork(): Result {
        return try {
            Log.d("WidgetUpdateWorker", "Starting widget update work")
            
            // Get the color data from input
            val colorHex = inputData.getString("colorHex")
            val colorList = inputData.getStringArray("colorList")?.toList()
            val updateType = inputData.getString("updateType") ?: "color"
            
            when (updateType) {
                "color" -> {
                    if (colorList != null && colorList.isNotEmpty()) {
                        updateWidgetWithColorList(colorList)
                    } else {
                        updateWidgetColor(colorHex ?: "#26A69A")
                    }
                }
                "content" -> updateWidgetContent()
                else -> {
                    if (colorList != null && colorList.isNotEmpty()) {
                        updateWidgetWithColorList(colorList)
                    } else {
                        updateWidgetColor(colorHex ?: "#26A69A")
                    }
                }
            }
            
            Log.d("WidgetUpdateWorker", "Widget update work completed successfully")
            Result.success()
        } catch (e: Exception) {
            Log.e("WidgetUpdateWorker", "Error in widget update work", e)
            Result.failure()
        }
    }

    private suspend fun updateWidgetColor(colorHex: String) {
        withContext(Dispatchers.IO) {
            try {
                val glanceAppWidgetManager = GlanceAppWidgetManager(applicationContext)
                val glanceIds = glanceAppWidgetManager.getGlanceIds(TOEICGlanceWidget::class.java)
                
                // Update widget state with new color
                glanceIds.forEach { glanceId ->
                    updateAppWidgetState(applicationContext, glanceId) { prefs ->
                        prefs[ColorPreferences.COLOR_KEY] = colorHex
                    }
                }
                
                // Trigger widget refresh
                TOEICGlanceWidget().updateAll(applicationContext)
                
                Log.d("WidgetUpdateWorker", "Widget color updated to: $colorHex")
            } catch (e: Exception) {
                Log.e("WidgetUpdateWorker", "Error updating widget color", e)
                throw e
            }
        }
    }

    private suspend fun updateWidgetWithColorList(colorList: List<String>) {
        withContext(Dispatchers.IO) {
            try {
                val glanceAppWidgetManager = GlanceAppWidgetManager(applicationContext)
                val glanceIds = glanceAppWidgetManager.getGlanceIds(TOEICGlanceWidget::class.java)
                
                // Get a random color from the list or cycle through them
                val selectedColor = getNextColorFromList(colorList)
                
                // Update widget state with selected color
                glanceIds.forEach { glanceId ->
                    updateAppWidgetState(applicationContext, glanceId) { prefs ->
                        prefs[ColorPreferences.COLOR_KEY] = selectedColor
                    }
                }
                
                // Trigger widget refresh
                TOEICGlanceWidget().updateAll(applicationContext)
                
                Log.d("WidgetUpdateWorker", "Widget color updated to: $selectedColor from list of ${colorList.size} colors")
            } catch (e: Exception) {
                Log.e("WidgetUpdateWorker", "Error updating widget with color list", e)
                throw e
            }
        }
    }

    private fun getNextColorFromList(colorList: List<String>): String {
        // You can implement different strategies here:
        // 1. Random selection
        // 2. Sequential cycling
        // 3. Time-based selection
        
        // For now, let's use a simple approach based on current time
        val currentTimeSeconds = System.currentTimeMillis() / 1000
        val index = (currentTimeSeconds % colorList.size).toInt()
        
        return colorList[index]
    }

    private suspend fun updateWidgetContent() {
        withContext(Dispatchers.IO) {
            try {
                // Just trigger a widget refresh to update content
                TOEICGlanceWidget().updateAll(applicationContext)
                
                Log.d("WidgetUpdateWorker", "Widget content updated")
            } catch (e: Exception) {
                Log.e("WidgetUpdateWorker", "Error updating widget content", e)
                throw e
            }
        }
    }

    companion object {
        const val WORK_NAME = "widget_update_work"
        const val COLOR_UPDATE_WORK = "widget_color_update_work"
        const val CONTENT_UPDATE_WORK = "widget_content_update_work"
    }
} 