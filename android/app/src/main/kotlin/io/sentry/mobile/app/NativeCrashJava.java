package io.sentry.mobile.app;
import android.os.AsyncTask;

public class NativeCrashJava {
    public static void crashingFunction() {
        AsyncTask.execute(() -> {
            String test = null;
            test.length();
        });
    }
}