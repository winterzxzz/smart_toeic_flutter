package com.example.toeic_desktop

import android.content.Context
import android.util.Log
import androidx.work.*
import java.util.concurrent.TimeUnit
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

object WidgetWorkScheduler {

    /**
     * Schedule a one-time widget update after 2 minutes
     */
    fun scheduleWidgetUpdateAfter2Minutes(
        context: Context,
        colorHex: String? = null,
        colorList: List<String>? = null,
        updateType: String = "color"
    ) {
        val inputData = Data.Builder().apply {
            colorHex?.let { putString("colorHex", it) }
            colorList?.let { 
                putStringArray("colorList", it.toTypedArray())
                putInt("colorCount", it.size)
            }
            putString("updateType", updateType)
        }.build()

        val workRequest = OneTimeWorkRequestBuilder<WidgetUpdateWorker>()
            .setInitialDelay(1, TimeUnit.MINUTES)
            .setInputData(inputData)
            .addTag("widget_update_2min")
            .build()

        WorkManager.getInstance(context)
            .enqueueUniqueWork(
                WidgetUpdateWorker.WORK_NAME,
                ExistingWorkPolicy.REPLACE,
                workRequest
            )

        Log.d("WidgetWorkScheduler", "Scheduled widget update after 2 minutes with ${colorList?.size ?: 1} colors")
    }

    /**
     * Schedule a one-time widget update with custom delay
     */
    fun scheduleWidgetUpdateAfterDelay(
        context: Context,
        delayMinutes: Long,
        colorHex: String? = null,
        colorList: List<String>? = null,
        updateType: String = "color"
    ) {
        val inputData = Data.Builder().apply {
            colorHex?.let { putString("colorHex", it) }
            colorList?.let { 
                putStringArray("colorList", it.toTypedArray())
                putInt("colorCount", it.size)
            }
            putString("updateType", updateType)
        }.build()

        val workRequest = OneTimeWorkRequestBuilder<WidgetUpdateWorker>()
            .setInitialDelay(delayMinutes, TimeUnit.MINUTES)
            .setInputData(inputData)
            .addTag("widget_update_custom")
            .build()

        WorkManager.getInstance(context)
            .enqueueUniqueWork(
                "${WidgetUpdateWorker.WORK_NAME}_$delayMinutes",
                ExistingWorkPolicy.REPLACE,
                workRequest
            )

        Log.d("WidgetWorkScheduler", "Scheduled widget update after $delayMinutes minutes with ${colorList?.size ?: 1} colors")
    }

    /**
     * Schedule periodic widget updates (minimum 15 minutes for WorkManager)
     */
    fun schedulePeriodicWidgetUpdate(
        context: Context,
        intervalMinutes: Long = 15,
        colorHex: String? = null,
        colorList: List<String>? = null
    ) {
        val inputData = Data.Builder().apply {
            colorHex?.let { putString("colorHex", it) }
            colorList?.let { 
                putStringArray("colorList", it.toTypedArray())
                putInt("colorCount", it.size)
            }
            putString("updateType", "content")
        }.build()

        val workRequest = PeriodicWorkRequestBuilder<WidgetUpdateWorker>(intervalMinutes, TimeUnit.MINUTES)
            .setInputData(inputData)
            .addTag("widget_update_periodic")
            .build()

        WorkManager.getInstance(context)
            .enqueueUniquePeriodicWork(
                "periodic_widget_update",
                ExistingPeriodicWorkPolicy.REPLACE,
                workRequest
            )

        Log.d("WidgetWorkScheduler", "Scheduled periodic widget update every $intervalMinutes minutes with ${colorList?.size ?: 1} colors")
    }

    /**
     * Cancel all scheduled widget update work
     */
    fun cancelAllWidgetUpdates(context: Context) {
        WorkManager.getInstance(context).cancelAllWorkByTag("widget_update_2min")
        WorkManager.getInstance(context).cancelAllWorkByTag("widget_update_custom")
        WorkManager.getInstance(context).cancelAllWorkByTag("widget_update_periodic")
        WorkManager.getInstance(context).cancelUniqueWork(WidgetUpdateWorker.WORK_NAME)
        WorkManager.getInstance(context).cancelUniqueWork("periodic_widget_update")
        
        Log.d("WidgetWorkScheduler", "Cancelled all widget update work")
    }

    /**
     * Cancel specific widget update work
     */
    fun cancelWidgetUpdate(context: Context, workName: String) {
        WorkManager.getInstance(context).cancelUniqueWork(workName)
        Log.d("WidgetWorkScheduler", "Cancelled widget update work: $workName")
    }
} 