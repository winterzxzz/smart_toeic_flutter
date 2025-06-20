package com.example.toeic_desktop

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
    private val Context.dataStore by preferencesDataStore(name = "widget_prefs")
    
    val COLOR_KEY = stringPreferencesKey("widget_color_hex")
    val COLOR_INT_KEY = intPreferencesKey("widget_color_int")

    // Set color using hex string and update widget immediately
    suspend fun setColorHex(context: Context, colorHex: String) {
        // Save to DataStore
        context.dataStore.edit {
            it[COLOR_KEY] = colorHex
        }
        
        // Also save to SharedPreferences for immediate widget access
        val prefs = context.getSharedPreferences("toeic_prefs", Context.MODE_PRIVATE)
        prefs.edit().putString("bg_color", colorHex).apply()
        
        // Update widget immediately
        TOEICGlanceWidget.updateTOEICGlanceWidget(context)
    }
    
    // Set color using integer and update widget immediately
    suspend fun setColorInt(context: Context, color: Int) {
        val colorHex = "#${Integer.toHexString(color).uppercase()}"
        setColorHex(context, colorHex)
    }

    suspend fun getColorHex(context: Context): String {
        val prefs = context.dataStore.data.first()
        return prefs[COLOR_KEY] ?: "#26A69A"
    }
    
    suspend fun getColorInt(context: Context): Int {
        val prefs = context.dataStore.data.first()
        return prefs[COLOR_INT_KEY] ?: android.graphics.Color.parseColor("#26A69A")
    }
    
    // Non-suspend methods for immediate access using SharedPreferences
    fun getColorHexImmediate(context: Context): String {
        val prefs = context.getSharedPreferences("toeic_prefs", Context.MODE_PRIVATE)
        return prefs.getString("bg_color", "#26A69A") ?: "#26A69A"
    }
    
    fun setColorHexImmediate(context: Context, colorHex: String) {
        val prefs = context.getSharedPreferences("toeic_prefs", Context.MODE_PRIVATE)
        prefs.edit().putString("bg_color", colorHex).apply()
    }
}