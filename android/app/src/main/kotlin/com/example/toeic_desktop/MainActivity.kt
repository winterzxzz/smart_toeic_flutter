package com.example.toeic_desktop

import android.app.AlarmManager
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.PowerManager
import android.os.Bundle
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.util.Log
import androidx.glance.appwidget.GlanceAppWidgetManager
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import androidx.glance.appwidget.state.updateAppWidgetState
import androidx.glance.appwidget.updateAll
import com.example.toeic_desktop.model.FlashCard
import com.example.toeic_desktop.data.ContentPreferences
import com.example.toeic_desktop.data.ColorPreferences
import java.util.concurrent.TimeUnit
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin
import android.widget.LinearLayout
import android.widget.TextView
import android.view.ViewGroup
import android.view.Gravity
import android.graphics.Typeface
import android.util.TypedValue
import android.content.res.Resources
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import com.google.android.gms.ads.nativead.MediaView
import android.graphics.drawable.GradientDrawable
import android.widget.Button
import android.graphics.Color
import android.widget.ImageView
import android.widget.FrameLayout
import android.view.View
import android.view.ViewOutlineProvider
import android.graphics.Outline


class MainActivity : FlutterActivity() {
    companion object {
        private const val CHANNEL = "com.example.toeic_desktop/deeplink"
        private const val WIDGET_CHANNEL = "com.example.toeic_desktop/widget"
        private const val DEEPLINK_KEY = "deep_link"
        private const val ALARM_CHANNEL = "exact_alarm_channel"
    }
    private var methodChannel: MethodChannel? = null


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val payload = intent.getStringExtra("notification_payload")
        payload?.let {
            if(it == "tests") {
                sendDeepLinkToFlutter("test://winter-toeic.com/bottom-tab?isFromWidget=true")
            }
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Register NativeAdFactory for Flutter google_mobile_ads (factoryId: "listTile")
        try {
            GoogleMobileAdsPlugin.registerNativeAdFactory(
                flutterEngine,
                "listTile",
                ListTileNativeAdFactory(this)
            )
        } catch (_: Exception) {}

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, ALARM_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "isExactAlarmGranted" -> {
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                            val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
                            result.success(alarmManager.canScheduleExactAlarms())
                        } else {
                            result.success(true)
                        }
                    }

                    "requestExactAlarmPermission" -> {
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                            val intent = Intent(Settings.ACTION_REQUEST_SCHEDULE_EXACT_ALARM)
                            intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
                            startActivity(intent)
                        }
                        result.success(null)
                    }

                    else -> result.notImplemented()
                }
            }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, WIDGET_CHANNEL).setMethodCallHandler { call, result ->
                when (call.method) {
                    "updateWidgetColor" -> {
                        val colorHex = call.argument<String>("colorHex") ?: "#26A69A"
                        updateWidgetColorAndRefresh(colorHex)
                        result.success("Widget color updated to $colorHex")
                    }
                    "schedulePeriodicWidgetUpdate" -> {
                        val data = call.argument<HashMap<String, Any>>("flashCardShowInWidgetList")
                        if(data != null) {
                        val list = data["flashCardShowInWidgetList"] as? List<HashMap<String, String>>
                            if(list != null) {
                                val flashcards = list.map {
                                    FlashCard(
                                        word = it["word"] ?: "",
                                        definition = it["definition"] ?: "",
                                        pronunciation = it["pronunciation"] ?: "",
                                        partOfSpeech = it["partOfSpeech"] ?: ""
                                    )
                                }
                                if(flashcards.isNotEmpty()) {
                                    ContentPreferences.saveFlashCards(this, flashcards)
                                    CoroutineScope(Dispatchers.IO).launch {
                                        // Immediate refresh of both widgets
                                        try {
                                            TOEICGlanceWidget.updateSpecificWidgetByGlanceId(this@MainActivity, flashcards.first())
                                        } catch (_: Exception) {}
                                        try {
                                            FlashcardListGlanceWidget.updateListStateWithAllFlashcards(this@MainActivity)
                                        } catch (_: Exception) {}

                                        if(!WidgetWorkScheduler.isWorkManagerRunning(this@MainActivity)) {
                                            val reminderWordAfterTime = ContentPreferences.getReminderWordAfterTime(this@MainActivity)
                                            val value = reminderWordAfterTime.split(" ")?.first()?.toLong()
                                            val unit = reminderWordAfterTime.split(" ")?.last()?.toLowerCase()
                                            if(value != null && unit != null) {
                                                val timeUnit = when (unit) {
                                                    "minutes" -> TimeUnit.MINUTES
                                                    "hours" -> TimeUnit.HOURS
                                                    "days" -> TimeUnit.DAYS
                                                    else -> TimeUnit.MINUTES
                                                }
                                                WidgetWorkScheduler.schedulePeriodicWidgetUpdate(this@MainActivity, value, timeUnit)
                                            } else {
                                                WidgetWorkScheduler.schedulePeriodicWidgetUpdate(this@MainActivity)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        result.success("Widget update scheduled after ${ContentPreferences.getReminderWordAfterTime(this)}")
                    }
                    "updateReminderWordAfterTime" -> {
                        val reminderWordAfterTime = call.argument<String>("reminderWordAfterTime")
                        if(reminderWordAfterTime != null) {
                            ContentPreferences.setReminderWordAfterTime(this, reminderWordAfterTime)
                        }
                        Log.d("MainActivity", "reminderWordAfterTime: $reminderWordAfterTime")
                        val value = reminderWordAfterTime?.split(" ")?.first()?.toLong()
                        val unit = reminderWordAfterTime?.split(" ")?.last()?.toLowerCase()
                        if(value != null && unit != null) {
                            val flashCards = ContentPreferences.loadFlashCards(this)
                            if(flashCards.isNotEmpty()) {
                                ContentPreferences.setIsCanShowNotification(this, false)
                                CoroutineScope(Dispatchers.IO).launch {
                                    if(WidgetWorkScheduler.isWorkManagerRunning(this@MainActivity)) {
                                        WidgetWorkScheduler.cancelWidgetUpdate(this@MainActivity, WidgetUpdateWorker.PERIODIC_UPDATE_WORK)
                                    }
                                    val timeUnit = when (unit) {
                                        "minutes" -> TimeUnit.MINUTES
                                        "hours" -> TimeUnit.HOURS
                                        "days" -> TimeUnit.DAYS
                                        else -> TimeUnit.MINUTES
                                    }
                                    WidgetWorkScheduler.schedulePeriodicWidgetUpdate(this@MainActivity, value, timeUnit)
                                }
                                result.success("Widget update scheduled after $reminderWordAfterTime")
                            } else {
                                result.success("No flash cards available for widget update")
                            }
                        } else {
                            result.success("Invalid reminder word after time format")
                        }
                    }
                    "cancelWidgetUpdate" -> {
                        WidgetWorkScheduler.cancelWidgetUpdate(this, WidgetUpdateWorker.PERIODIC_UPDATE_WORK)
                        result.success("Widget update cancelled")
                    }
                    else -> {
                        result.notImplemented()
                    }
                }
            }
        }



    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        val destination = intent.extras?.getString(DEEPLINK_KEY)
        if (destination != null) {
            sendDeepLinkToFlutter(destination)
        }
    }


    private fun sendDeepLinkToFlutter(deepLink: String) {
        flutterEngine?.dartExecutor?.binaryMessenger?.let { messenger ->
            MethodChannel(messenger, CHANNEL).invokeMethod("onDeepLinkReceived", deepLink)
        }
    }

    private fun updateWidgetColorAndRefresh(colorHex: String) {
        CoroutineScope(Dispatchers.Default).launch {
            try {
                val glanceAppWidgetManager = GlanceAppWidgetManager(applicationContext)
                val glanceIds = glanceAppWidgetManager.getGlanceIds(TOEICGlanceWidget::class.java)
                
                glanceIds.forEach { glanceId ->
                    updateAppWidgetState(applicationContext, glanceId) { prefs ->
                        prefs[ColorPreferences.COLOR_KEY] = colorHex
                    }
                }
                TOEICGlanceWidget().updateAll(applicationContext)
            } catch (e: Exception) {
                Log.e("MainActivity", "Error updating widget color: ${e.message}", e)
            }
        }
    }
}

class ListTileNativeAdFactory(private val context: Context) : GoogleMobileAdsPlugin.NativeAdFactory {
    override fun createNativeAd(
        nativeAd: NativeAd,
        customOptions: MutableMap<String, Any>?
    ): NativeAdView {
        val adView = NativeAdView(context)

        // Root container with rounded white background
        val container = LinearLayout(context).apply {
            orientation = LinearLayout.VERTICAL
            layoutParams = ViewGroup.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            )
            gravity = Gravity.CENTER_VERTICAL
            background = GradientDrawable().apply {
                setColor(Color.WHITE)
                cornerRadius = dp(12).toFloat() // ✅ Bo góc container
            }
            setPadding(dp(12), dp(12), dp(12), dp(12))
        }

        // 1) Image (Media) — rounded top corners
        val mediaContainer = FrameLayout(context).apply {
            layoutParams = LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                dp(180)
            ).apply {
                bottomMargin = dp(12)
            }
            clipToOutline = true
            outlineProvider = object : ViewOutlineProvider() {
                override fun getOutline(view: View, outline: Outline) {
                    // Bo góc trên ảnh
                    outline.setRoundRect(0, 0, view.width, view.height, dp(12).toFloat())
                }
            }
        }

        val mediaView = MediaView(context).apply {
            layoutParams = FrameLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.MATCH_PARENT
            )
            setImageScaleType(ImageView.ScaleType.CENTER_CROP)
        }
        mediaContainer.addView(mediaView)
        adView.mediaView = mediaView
        container.addView(mediaContainer)

        // 2) Content (Headline + Body)
        val contentColumn = LinearLayout(context).apply {
            orientation = LinearLayout.VERTICAL
            layoutParams = LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            )
        }

        val headlineView = TextView(context).apply {
            layoutParams = LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            ).apply {
                bottomMargin = dp(6)
            }
            setTextSize(TypedValue.COMPLEX_UNIT_SP, 16f)
            setTypeface(typeface, Typeface.BOLD)
            setTextColor(Color.BLACK)
        }
        adView.headlineView = headlineView
        contentColumn.addView(headlineView)

        val bodyView = TextView(context).apply {
            layoutParams = LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            ).apply {
                bottomMargin = dp(10)
            }
            setTextSize(TypedValue.COMPLEX_UNIT_SP, 14f)
            setTextColor(Color.parseColor("#555555"))
        }
        adView.bodyView = bodyView
        contentColumn.addView(bodyView)
        container.addView(contentColumn)

        // 3) CTA Button
        val ctaButton = Button(context).apply {
            layoutParams = LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            )
            textSize = 14f
            setTextColor(Color.WHITE)
            isAllCaps = false
            background = GradientDrawable().apply {
                setColor(Color.parseColor("#26A69A"))
                cornerRadius = dp(8).toFloat()
            }
        }
        adView.callToActionView = ctaButton
        container.addView(ctaButton)

        adView.addView(container)

        // Populate ad content
        (adView.headlineView as TextView).text = nativeAd.headline
        (adView.bodyView as TextView).text = nativeAd.body ?: ""
        (adView.callToActionView as Button).text = nativeAd.callToAction ?: "Install now"

        adView.setNativeAd(nativeAd)
        return adView
    }

    private fun dp(value: Int): Int = (value * Resources.getSystem().displayMetrics.density).toInt()
}