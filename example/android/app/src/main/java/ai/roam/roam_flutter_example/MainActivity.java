package ai.roam.roam_flutter_example;

import android.content.Intent;

import io.flutter.embedding.android.FlutterActivity;

public class MainActivity extends FlutterActivity {
    @Override
    protected void onResume() {
        super.onResume();
        startService(new Intent(this, GeoSparkForegroundService.class));
    }
}
