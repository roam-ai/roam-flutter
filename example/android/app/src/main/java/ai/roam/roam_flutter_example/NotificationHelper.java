package ai.roam.roam_flutter_example;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.os.Build;

import androidx.annotation.RequiresApi;

public class NotificationHelper {
    public static final int NOTIFICATION_ID = 102;
    private static final int PENDING_INTENT_REQUEST_CODE = 103;
    private static final String ANDROID_CHANNEL_ID = "ai.roam.roam_flutter_example";
    private static final String ANDROID_CHANNEL_NAME = "roam";

    @RequiresApi(api = Build.VERSION_CODES.O)
    private static Notification.Builder getAndroidChannelNotification(Context context) {
        int resIcon = R.drawable.ic_geospark;
        String contentTitle = "App is running";
        String contentText = "Click here to open the app";
        return new Notification.Builder(context, ANDROID_CHANNEL_ID)
                .setSmallIcon(resIcon)
                .setContentTitle(contentTitle)
                .setContentText(contentText)
                .setStyle(new Notification.BigTextStyle().bigText(contentText))
                .setAutoCancel(true);
    }

    @RequiresApi(api = Build.VERSION_CODES.O)
    public static Notification showNotification(Context context) {
        NotificationManager notificationManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
        NotificationChannel channel = new NotificationChannel(ANDROID_CHANNEL_ID, ANDROID_CHANNEL_NAME, NotificationManager.IMPORTANCE_LOW);
        channel.enableLights(false);
        channel.enableVibration(false);
        channel.setLockscreenVisibility(Notification.VISIBILITY_PRIVATE);
        notificationManager.createNotificationChannel(channel);
        Intent intent = context.getPackageManager().getLaunchIntentForPackage(context.getPackageName());
        intent.addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP);
        PendingIntent pendingIntent = PendingIntent.getActivity(context, PENDING_INTENT_REQUEST_CODE, intent, PendingIntent.FLAG_UPDATE_CURRENT);
        Notification.Builder nb = getAndroidChannelNotification(context);
        nb.setContentIntent(pendingIntent);
        return nb.build();
    }

    public static void cancelNotification(Context context) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationManager manager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
            manager.cancel(NOTIFICATION_ID);
        }
    }
}
