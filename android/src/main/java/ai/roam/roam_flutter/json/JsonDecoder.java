package ai.roam.roam_flutter.json;

import android.util.Log;

import com.roam.sdk.Roam;
import com.roam.sdk.RoamTrackingMode;
import com.roam.sdk.trips_v2.RoamTrip;
import com.roam.sdk.trips_v2.models.Stop;
import com.roam.sdk.trips_v2.request.RoamTripStops;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

public class JsonDecoder {


    public static RoamTrip decodeRoamTrip(JSONObject roamTripJSON) throws Exception{

        final Boolean isLocal = (roamTripJSON.has("isLocal")) ? roamTripJSON.getBoolean("isLocal") : null;
        final String userIdString = (roamTripJSON.has("userId")) ? roamTripJSON.getString("userId") : null;
        final String metadataString = (roamTripJSON.has("metadata")) ? roamTripJSON.getString("metadata") : null;
        final String tripDescription = (roamTripJSON.has("description")) ? roamTripJSON.getString("description") : null;
        final String tripName = (roamTripJSON.has("name")) ? roamTripJSON.getString("name") : null;
        final String stopListString = (roamTripJSON.has("stops")) ? roamTripJSON.getString("stops") : null;

        JSONObject tripMetadata = null;
        if (metadataString != null && !metadataString.equals("")) {
            try {
                tripMetadata = new JSONObject(metadataString);
            }catch (Exception e){
                Log.e("TAG", "metadata null");
            }
        }

        JSONArray stopsJSON = null;
        List<RoamTripStops> stopsList = null;

        if (stopListString != null && !stopListString.equals("")) {
            stopsJSON = new JSONArray(stopListString);
            stopsList = new ArrayList<>();

            for (int i = 0; i < stopsJSON.length(); i++) {
                JSONObject stopObject = stopsJSON.getJSONObject(i);
                stopsList.add(JsonDecoder.decodeRoamTripStops(stopObject));
            }
        }

        Log.e("TAG", userIdString);
        Log.e("TAG", tripMetadata != null ? tripMetadata.toString() : "null");
        Log.e("TAG", tripDescription);
        Log.e("TAG", tripName);
        Log.e("TAG", isLocal.toString());
        //Log.e("TAG", stopsList.toString());


        return new RoamTrip.Builder()
                .setUserId((userIdString != null) ? userIdString : "")
                .setMetadata(tripMetadata)
                .setTripDescription(tripDescription)
                .setTripName(tripName)
                .setIsLocal(isLocal)
                .setStop(stopsList)
                .build();
    }


    public static RoamTripStops decodeRoamTripStops(JSONObject stopObject) throws Exception{

        JSONObject stopMetadata = stopObject.has("metadata") ? stopObject.getJSONObject("metadata") : null;
        String stopDescription = stopObject.has("description") ? stopObject.getString("description") : null;
        String stopName = stopObject.has("name") ? stopObject.getString("name") : null;
        String stopAddress = stopObject.has("address") ? stopObject.getString("address") : null;
        Double radius = stopObject.has("radius") ? stopObject.getDouble("radius") : null;
        JSONArray geometryArray = stopObject.has("geometry") ? stopObject.getJSONArray("geometry") : null;
        List<Double> geometry = new ArrayList<>();
        if (geometryArray != null) {
            for (int j = 0; j < geometryArray.length(); j++) {
                geometry.add(geometryArray.getDouble(j));
            }
        }
        RoamTripStops tripStop = new RoamTripStops();
        tripStop.setMetadata(stopMetadata);
        tripStop.setStopDescription(stopDescription);
        tripStop.setStopName(stopName);
        tripStop.setAddress(stopAddress);
        tripStop.setGeometryRadius(radius);
        tripStop.setGeometry(geometry);

        return tripStop;
    }


    public static RoamTrackingMode decodeRoamTrackingMode(JSONObject jsonObject) throws Exception {

        int trackingOptions = jsonObject.has("trackingOptions")
                ? jsonObject.getInt("trackingOptions") : 2;

        switch (trackingOptions){

            case 0:
                return RoamTrackingMode.PASSIVE;

            case 1:
                return RoamTrackingMode.BALANCED;

            case 2:
            default:
                return RoamTrackingMode.ACTIVE;

            case 3:
                RoamTrackingMode.DesiredAccuracy desiredAccuracy = jsonObject.has("desiredAccuracy")
                        ? RoamTrackingMode.DesiredAccuracy.toEnum(jsonObject.getString("desiredAccuracy"))
                        : RoamTrackingMode.DesiredAccuracy.HIGH;

                int distanceFilter = jsonObject.has("distanceFilter")
                        ? jsonObject.getInt("distanceFilter") : 0;

                int stopDuration = jsonObject.has("stopDuration")
                        ? jsonObject.getInt("stopDuration") : 0;

                int updateInterval = jsonObject.has("updateInterval")
                        ? jsonObject.getInt("updateInterval") : 0;

                if (updateInterval == 0){
                    //distance based

                    return new RoamTrackingMode.Builder(distanceFilter, stopDuration)
                            .setDesiredAccuracy(desiredAccuracy)
                            .build();
                } else {
                    //time based
                    return new RoamTrackingMode.Builder(updateInterval)
                            .setDesiredAccuracy(desiredAccuracy)
                            .build();
                }


        }

    }







}
