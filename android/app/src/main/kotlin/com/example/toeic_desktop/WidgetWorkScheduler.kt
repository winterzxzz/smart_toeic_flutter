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
            putString("updateType", "color")
        }.build()

        val workRequest = PeriodicWorkRequestBuilder<WidgetUpdateWorker>(intervalMinutes, TimeUnit.MINUTES)
            .setInitialDelay(30, TimeUnit.SECONDS)
            .setInputData(inputData)
            .addTag("widget_update_periodic")
            .build()

        WorkManager.getInstance(context)
            .enqueueUniquePeriodicWork(
                WidgetUpdateWorker.PERIODIC_UPDATE_WORK,
                ExistingPeriodicWorkPolicy.REPLACE,
                workRequest
            )

        Log.d("WidgetWorkScheduler", "Scheduled periodic widget update every $intervalMinutes minutes with ${colorList?.size ?: 1} colors")
    }

    /**
     * Cancel all scheduled widget update work
     */
    fun cancelAllWidgetUpdates(context: Context) {
        WorkManager.getInstance(context).cancelAllWorkByTag("widget_update_periodic")
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
} 