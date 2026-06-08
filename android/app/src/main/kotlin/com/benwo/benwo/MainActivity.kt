package com.benwo.benwo

import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "benwo/notification_cache"
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "clearScheduledNotificationsCache" -> {
                    clearScheduledNotificationsCache()
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun clearScheduledNotificationsCache() {
        getSharedPreferences("scheduled_notifications", MODE_PRIVATE)
            .edit()
            .clear()
            .commit()

        val cacheFile = File(applicationInfo.dataDir, "shared_prefs/scheduled_notifications.xml")
        if (cacheFile.exists()) {
            cacheFile.delete()
        }
    }
}
