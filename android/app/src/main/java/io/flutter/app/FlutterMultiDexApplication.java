package io.flutter.app;

import androidx.multidex.MultiDex;
import io.flutter.app.FlutterApplication;
import android.content.Context;

public class FlutterMultiDexApplication extends FlutterApplication {
    @Override
    protected void attachBaseContext(Context base) {
        super.attachBaseContext(base);
        MultiDex.install(this);
    }
}
