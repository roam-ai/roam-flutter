package ai.roam.roam_flutter_example;

import android.content.Context;

import com.geospark.lib.models.GeoSparkLocation;
import com.geospark.lib.service.GeoSparkReceiver;

public class MyGeoSparkReceiver extends GeoSparkReceiver {
    @Override
    public void onLocationUpdated(Context context, GeoSparkLocation geosparkLocation) {
        // receive own location updates here
        // do something with location data using location
    }
}
