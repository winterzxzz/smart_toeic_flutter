package com.example.toeic_desktop

import android.content.Context
import android.util.Log
import androidx.work.*
import java.util.concurrent.TimeUnit
import kotlinx.coroutines.Dispatchers
import com.example.toeic_desktop.data.ContentPreferences
import androidx.work.await
import kotlinx.coroutines.withContext










object WidgetWorkScheduler {

    /**
     * Schedule periodic widget updates (minimum 15 minutes for WorkManager)
     */
    fun schedulePeriodicWidgetUpdate(
        context: Context,
        intervalMinutes: Long = 15,
        timeUnit: TimeUnit = TimeUnit.MINUTES
    ) {


        val inputData = Data.Builder().apply {
            putString("updateType", "content")
        }.build()


        val workRequest = PeriodicWorkRequestBuilder<WidgetUpdateWorker>(intervalMinutes, timeUnit)
            .setInitialDelay(2, TimeUnit.SECONDS)
            .setInputData(inputData)
            .build()

        WorkManager.getInstance(context)
            .enqueueUniquePeriodicWork(
                WidgetUpdateWorker.PERIODIC_UPDATE_WORK,
                ExistingPeriodicWorkPolicy.REPLACE,
                workRequest
            )

        Log.d("WidgetWorkScheduler", "Scheduled periodic widget update every $intervalMinutes ${timeUnit.name.lowercase()}")
    }

    /**
     * Cancel all scheduled widget update work
     */
    fun cancelAllWidgetUpdates(context: Context) {
        WorkManager.getInstance(context).cancelUniqueWork(WidgetUpdateWorker.PERIODIC_UPDATE_WORK)
        Log.d("WidgetWorkScheduler", "Cancelled all widget update work")
    }

    /**
     * Cancel specific widget update work
     */
    fun cancelWidgetUpdate(context: Context, workName: String) {
        WorkManager.getInstance(context).cancelUniqueWork(workName)
        Log.d("WidgetWorkScheduler", "Cancelled widget update work: $workName")
    }

    /**
     * Check if workmanager is running
     */
    
    suspend fun isWorkManagerRunning(context: Context): Boolean {
        return withContext(Dispatchers.IO) {
        try {
            val workInfos = WorkManager.getInstance(context)
                .getWorkInfosForUniqueWork(WidgetUpdateWorker.PERIODIC_UPDATE_WORK)
                .await()
            
            workInfos.isNotEmpty() && workInfos.any { workInfo ->
                workInfo.state in setOf(
                    WorkInfo.State.BLOCKED,
                    WorkInfo.State.ENQUEUED,
                    WorkInfo.State.RUNNING
                )
            }
        } catch (e: Exception) {
            Log.e("WidgetWorkScheduler", "Error checking WorkManager status", e)
                false
            }
        }
    }


} 