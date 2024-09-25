package com.example.parental_control

import android.app.usage.UsageStats
import android.app.usage.UsageStatsManager
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import androidx.annotation.RequiresApi
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.TimeUnit

class ScreenTimeActivity: FlutterActivity() {
    private val CHANNEL = "com.example.parental_control/screen_time"
    private lateinit var sharedPreferences: SharedPreferences

    companion object {
        const val PREFS_NAME = "ScreenTimePrefs"
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState()
                sharedPreferences = getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)

        // Usage Access ruxsatini tekshirish va so'rash
        if (!isUsageStatsPermissionGranted()) {
            startActivity(Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS))
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getUsageStats" -> {
                    val usageStats = getUsageStats()
                    result.success(usageStats)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun isUsageStatsPermissionGranted(): Boolean {
        val appOps = getSystemService(Context.APP_OPS_SERVICE) as android.app.AppOpsManager
        val mode = appOps.checkOpNoThrow(
            android.app.AppOpsManager.OPSTR_GET_USAGE_STATS,
            android.os.Process.myUid(), packageName
        )
        return mode == android.app.AppOpsManager.MODE_ALLOWED
    }

    @RequiresApi(Build.VERSION_CODES.LOLLIPOP_MR1)
    private fun getUsageStats(): Map<String, Long> {
        val usageStatsManager = getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
        val endTime = System.currentTimeMillis()
        val startTime = endTime - TimeUnit.HOURS.toMillis(24)  // So'nggi 24 soat

        // Usage statistikasini olish
        val usageStats: List<UsageStats> = usageStatsManager.queryUsageStats(
            UsageStatsManager.INTERVAL_DAILY, startTime, endTime
        )

        val appUsageMap = mutableMapOf<String, Long>()

        // Har bir ilovaning ishlash vaqtini hisoblash
        usageStats.forEach { stats ->
            val packageName = stats.packageName
            val totalTime = stats.totalTimeInForeground
            if (totalTime > 0) {
                appUsageMap[packageName] = totalTime
            }
        }

        return appUsageMap
    }
}
