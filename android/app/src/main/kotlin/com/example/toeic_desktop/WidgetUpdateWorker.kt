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
import com.google.gson.Gson
import com.example.toeic_desktop.data.ContentPreferences
import com.example.toeic_desktop.model.FlashCard
import android.app.NotificationManager
import android.app.NotificationChannel
import android.os.Build
import androidx.core.app.NotificationCompat

class WidgetUpdateWorker(
    context: Context,
    workerParams: WorkerParameters
) : CoroutineWorker(context, workerParams) {

    override suspend fun doWork(): Result {
        return try {
            Log.d("WidgetUpdateWorker", "Starting widget update work")
            
            // Get the color data from input
            val currentFlashCardIndex = ContentPreferences.getCurrentFlashCardIndex(applicationContext)
            Log.d("WidgetUpdateWorker", "Current flash card index: $currentFlashCardIndex")
            val updateType = inputData.getString("updateType") ?: "content"
            
            when (updateType) {
                "content" -> {
                    val flashCards = ContentPreferences.loadFlashCards(applicationContext)
                    val flashCard = flashCards[currentFlashCardIndex]
                    if(flashCard != null) {
                        Log.d("WidgetUpdateWorker", "Updating widget content with ${flashCard.word}")
                        updateWidgetContent(flashCard)
                        ContentPreferences.setCurrentFlashCardIndex(applicationContext, (currentFlashCardIndex + 1) % flashCards.size)
                        val isCanShowNotification = ContentPreferences.isCanShowNotification(applicationContext)
                        if (isCanShowNotification) {
                            showNotification("${flashCard.word} ${flashCard.pronunciation}", "(${flashCard.partOfSpeech}) ${flashCard.definition}")
                        }
                        Log.d("WidgetUpdateWorker", "Updated current flash card index to ${ContentPreferences.getCurrentFlashCardIndex(applicationContext)}")
                    }
                }
                else -> {
                    Log.e("WidgetUpdateWorker", "Invalid update type: $updateType")
                    Result.failure()
                }
            }
            
        
            Result.success()
        } catch (e: Exception) {
            Log.e("WidgetUpdateWorker", "Error in widget update work", e)
            Result.failure()
        }
    }

    


    private suspend fun updateWidgetContent(flashCard: FlashCard) {
        withContext(Dispatchers.IO) {
            try {
                val glanceAppWidgetManager = GlanceAppWidgetManager(applicationContext)
                val glanceIds = glanceAppWidgetManager.getGlanceIds(TOEICGlanceWidget::class.java)

                glanceIds.forEach { glanceId ->
                    updateAppWidgetState(applicationContext, glanceId) { prefs ->
                        prefs[ContentPreferences.CONTENT_KEY] = Gson().toJson(flashCard)
                    }
                }

                TOEICGlanceWidget().updateAll(applicationContext)
                Log.d("WidgetUpdateWorker", "Widget content updated")
            } catch (e: Exception) {
                Log.e("WidgetUpdateWorker", "Error updating widget content", e)
                throw e
            }
        }
    }

    private fun showNotification(title: String, message: String) {
        val notificationManager =
            applicationContext.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        // Notification channel for Android 8+
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                "work_channel",
                "WorkManager Notifications",
                NotificationManager.IMPORTANCE_HIGH
            )
            notificationManager.createNotificationChannel(channel)
        }

        val notification = NotificationCompat.Builder(applicationContext, "work_channel")
            .setContentTitle(title)
            .setContentText(message)
            .setSmallIcon(R.mipmap.ic_launcher) // Use app logo
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .build()
        // get now for id
        val now = System.currentTimeMillis().toInt()
        notificationManager.notify(now, notification)
    }

    private fun cancelAllNotifications() {
        val notificationManager =
            applicationContext.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        notificationManager.cancelAll()
    }

    companion object {
        const val PERIODIC_UPDATE_WORK = "widget_periodic_update_work"
    }
} 