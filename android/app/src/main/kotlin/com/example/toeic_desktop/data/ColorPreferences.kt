package com.example.toeic_desktop.data

import android.content.Context
import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.core.intPreferencesKey
import androidx.datastore.preferences.core.stringPreferencesKey
import androidx.datastore.preferences.preferencesDataStore
import kotlinx.coroutines.flow.first

// Enhanced ColorPreferences with immediate update support
object ColorPreferences {
    val name = "widget_prefs"
    private val Context.dataStore by preferencesDataStore(name = name)

    val COLOR_KEY = stringPreferencesKey("widget_color_hex")
    val COLOR_INT_KEY = intPreferencesKey("widget_color_int")
    
    // Non-suspend methods for immediate access using SharedPreferences
    fun getColorHexImmediate(context: Context): String {
        val prefs = context.getSharedPreferences(name, Context.MODE_PRIVATE)
        return prefs.getString(COLOR_KEY.name, "#26A69A") ?: "#26A69A"
    }
    
    fun setColorHexImmediate(context: Context, colorHex: String) {
        val prefs = context.getSharedPreferences(name, Context.MODE_PRIVATE)
        prefs.edit().putString(COLOR_KEY.name, colorHex).apply()
    }
}