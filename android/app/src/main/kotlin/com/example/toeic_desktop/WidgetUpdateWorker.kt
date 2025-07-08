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
import android.app.PendingIntent
import android.content.Intent

class WidgetUpdateWorker(
    context: Context,
    workerParams: WorkerParameters
) : CoroutineWorker(context, workerParams) {

    override suspend fun doWork(): Result {
        return try {
            val updateType = inputData.getString("updateType") ?: "content"
            when (updateType) {
                "content" -> {
                    withContext(Dispatchers.IO) {
                        val currentIndex = ContentPreferences.getCurrentFlashCardIndex(applicationContext)
                        val flashCards = ContentPreferences.loadFlashCards(applicationContext)
                        val flashCard = flashCards[currentIndex]
                        if(flashCard != null) {
                            val isCanShowNotification = ContentPreferences.isCanShowNotification(applicationContext)
                            if(isCanShowNotification) {
                            } else {
                                ContentPreferences.setIsCanShowNotification(applicationContext, true)
                            }
                            showNotification("${flashCard.word} ${flashCard.pronunciation}", "(${flashCard.partOfSpeech}) ${flashCard.definition}")
                            if(TOEICGlanceWidget.isWidgetAdded(applicationContext)) {
                                TOEICGlanceWidget.updateSpecificWidgetByGlanceId(applicationContext, flashCard)
                            }
                            ContentPreferences.setCurrentFlashCardIndex(applicationContext, (currentIndex + 1) % flashCards.size)
                        }
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

          // Intent to launch MainActivity with extra data
        val intent = Intent(applicationContext, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
            putExtra("notification_payload", "tests") // ✅ Set your payload here
        }

        val pendingIntent = PendingIntent.getActivity(
            applicationContext,
            0,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val notification = NotificationCompat.Builder(applicationContext, "work_channel")
            .setContentTitle(title)
            .setContentText(message)
            .setSmallIcon(R.mipmap.ic_launcher) // Use app logo
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setContentIntent(pendingIntent)
            .setAutoCancel(true)
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