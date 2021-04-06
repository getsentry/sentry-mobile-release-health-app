package io.sentry.mobile.app

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.os.AsyncTask
import io.sentry.mobile.app.NativeCrashJava

class MainActivity: FlutterActivity() {
    private val CHANNEL = "app.mobile.sentry.io/nativeCrash"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "crashKotlin") {
                crashingMethod()
            } else if (call.method == "crashJava") {
                NativeCrashJava.crashingFunction()
            }
            result.success(0)
        }
    }

    private fun crashingMethod() {
        AsyncTask.execute {
            throw Exception("Native Crash - Android Kotlin")
        }
    }
}
