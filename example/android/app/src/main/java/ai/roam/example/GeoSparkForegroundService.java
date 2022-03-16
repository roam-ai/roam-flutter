package ai.roam.example;

import android.app.Service;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Build;
import android.os.IBinder;

public class GeoSparkForegroundService extends Service {
    private MyGeoSparkReceiver mLocationReceiver;

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public void onCreate() {
        super.onCreate();
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startForeground(NotificationHelper.NOTIFICATION_ID, NotificationHelper.showNotification(this));
        }
        register();
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        return START_STICKY;
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        NotificationHelper.cancelNotification(this);
        unRegister();
    }

    private void register() {
        mLocationReceiver = new MyGeoSparkReceiver();
        IntentFilter intentFilter = new IntentFilter();
        intentFilter.addAction("com.roam.android.RECEIVED");
        registerReceiver(mLocationReceiver, intentFilter);
    }

    private void unRegister() {
        if (mLocationReceiver != null) {
            unregisterReceiver(mLocationReceiver);
        }
    }
}
