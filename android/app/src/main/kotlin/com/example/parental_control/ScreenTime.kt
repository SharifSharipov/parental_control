package com.example.parental_control

import android.content.Context
import android.content.SharedPreferences
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class ScreenTimeActivity: FlutterActivity() {
    private val CHANNEL = "com.example.parental_control/screen_time"
    private lateinit var sharedPreferences: SharedPreferences

    companion object {
        const val PREFS_NAME = "ScreenTimePrefs"
        const val USAGE_TIME_KEY = "usage_time"
    }

    private var startTime: Long = 0

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        sharedPreferences = getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        startTime = System.currentTimeMillis()
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Setup MethodChannel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getUsageTime" -> {
                    val usageTime = getUsageTime()
                    result.success(usageTime)
                }
                "resetUsageTime" -> {
                    resetUsageTime()
                    result.success(null)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun getUsageTime(): Long {
        return sharedPreferences.getLong(USAGE_TIME_KEY, 0)
    }

    private fun resetUsageTime() {
        sharedPreferences.edit().putLong(USAGE_TIME_KEY, 0).apply()
    }

    override fun onDestroy() {
        super.onDestroy()
        val totalUsageTime = getUsageTime() + (System.currentTimeMillis() - startTime)
        sharedPreferences.edit().putLong(USAGE_TIME_KEY, totalUsageTime).apply()
    }
}
