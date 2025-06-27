package com.example.toeic_desktop.data

import android.content.Context
import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.core.intPreferencesKey
import androidx.datastore.preferences.core.stringPreferencesKey
import androidx.datastore.preferences.preferencesDataStore
import kotlinx.coroutines.flow.first
import com.example.toeic_desktop.model.FlashCard
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken

// Enhanced ColorPreferences with immediate update support
object ContentPreferences {
    val name = "widget_prefs"
    private val Context.dataStore by preferencesDataStore(name = name)

    val CONTENT_KEY = stringPreferencesKey("flashcards_json")
    val CURRENT_FLASH_CARD_INDEX_KEY = intPreferencesKey("flash_card_index")
    val IS_CAN_SHOW_NOTIFICATION_KEY = intPreferencesKey("is_can_show_notification")

    // Non-suspend methods for immediate access using SharedPreferences
    fun loadFlashCards(context: Context): List<FlashCard> {
        val prefs = context.getSharedPreferences(name, Context.MODE_PRIVATE)
        val json = prefs.getString(CONTENT_KEY.name, null)
        return if(!json.isNullOrEmpty()) {
            val type = object : TypeToken<List<FlashCard>>() {}.type
            Gson().fromJson(json, type)
        } else {
            emptyList()
        }
    }
    
    fun saveFlashCards(context: Context, flashCards: List<FlashCard>) {
        val prefs = context.getSharedPreferences(name, Context.MODE_PRIVATE)
        prefs.edit().putInt(CURRENT_FLASH_CARD_INDEX_KEY.name, 0).apply()
        prefs.edit().putString(CONTENT_KEY.name, Gson().toJson(flashCards)).apply()
    }

    fun getCurrentFlashCardIndex(context: Context): Int {
        val prefs = context.getSharedPreferences(name, Context.MODE_PRIVATE)
        return prefs.getInt(CURRENT_FLASH_CARD_INDEX_KEY.name, 0)
    }

    fun setCurrentFlashCardIndex(context: Context, index: Int) {
        val prefs = context.getSharedPreferences(name, Context.MODE_PRIVATE)
        prefs.edit().putInt(CURRENT_FLASH_CARD_INDEX_KEY.name, index).apply()
    }

    // clear all data
    fun clearAllData(context: Context) {
        val prefs = context.getSharedPreferences(name, Context.MODE_PRIVATE)
        prefs.edit().remove(CONTENT_KEY.name).remove(CURRENT_FLASH_CARD_INDEX_KEY.name).apply()
    }

    fun setIsCanShowNotification(context: Context, isCanShow: Boolean) {
        val prefs = context.getSharedPreferences(name, Context.MODE_PRIVATE)
        prefs.edit().putInt(IS_CAN_SHOW_NOTIFICATION_KEY.name, if (isCanShow) 1 else 0).apply()
    }

    fun isCanShowNotification(context: Context): Boolean {
        val prefs = context.getSharedPreferences(name, Context.MODE_PRIVATE)
        return prefs.getInt(IS_CAN_SHOW_NOTIFICATION_KEY.name, 0) == 1
    }
}