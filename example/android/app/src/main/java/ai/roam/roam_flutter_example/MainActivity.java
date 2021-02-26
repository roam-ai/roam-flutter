package ai.roam.roam_flutter_example;

import android.content.IntentFilter;

import io.flutter.embedding.android.FlutterActivity;

public class MainActivity extends FlutterActivity {
    private MyGeoSparkReceiver mLocationReceiver;
    private void register() {
        mLocationReceiver = new MyGeoSparkReceiver();
        IntentFilter intentFilter = new IntentFilter();
        intentFilter.addAction("com.geospark.android.RECEIVED");
        registerReceiver(mLocationReceiver, intentFilter);
    }
    private void unRegister() {
        if (mLocationReceiver != null) {
            unregisterReceiver(mLocationReceiver);
        }
    }
    @Override
    protected void onResume() {
        super.onResume();
        register();
    }
    @Override
    protected void onPause() {
        super.onPause();
        unRegister();
    }
}
