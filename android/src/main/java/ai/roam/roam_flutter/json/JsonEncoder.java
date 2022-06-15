package ai.roam.roam_flutter.json;

import android.util.Log;

import com.google.gson.Gson;
import com.roam.sdk.trips_v2.RoamTrip;
import com.roam.sdk.trips_v2.models.EndLocation;
import com.roam.sdk.trips_v2.models.Error;
import com.roam.sdk.trips_v2.models.Errors;
import com.roam.sdk.trips_v2.models.Events;
import com.roam.sdk.trips_v2.models.RoamActiveTripsResponse;
import com.roam.sdk.trips_v2.models.RoamDeleteTripResponse;
import com.roam.sdk.trips_v2.models.RoamSyncTripResponse;
import com.roam.sdk.trips_v2.models.RoamTripResponse;
import com.roam.sdk.trips_v2.models.Routes;
import com.roam.sdk.trips_v2.models.StartLocation;
import com.roam.sdk.trips_v2.models.Stop;
import com.roam.sdk.trips_v2.models.Trips;
import com.roam.sdk.trips_v2.models.User;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.Map;

public class JsonEncoder {

    public static JSONObject encodeStartLocation(StartLocation startLocation) throws JSONException {

        if (startLocation == null){
            return null;
        }

        if (startLocation.getGeometry() == null){
            return null;
        }

        JSONObject startLocationJSON = new JSONObject();
        startLocationJSON.put("id", startLocation.getId());
        startLocationJSON.put("name", startLocation.getName());
        startLocationJSON.put("description", startLocation.getDescription());
        startLocationJSON.put("address", startLocation.getAddress());
        startLocationJSON.put("metadata", startLocation.getMetadata());
        startLocationJSON.put("recorded_at", startLocation.getRecordedAt());

        JSONObject geometry = new JSONObject();

        geometry.put("type", startLocation.getGeometry().getType());
        JSONArray coordinates = new JSONArray();
        for (int y=0; y<startLocation.getGeometry().getCoordinates().size(); y++){
            coordinates.put(startLocation.getGeometry().getCoordinates().get(y));
        }
        geometry.put("coordinates", coordinates);
        startLocationJSON.put("geometry", geometry);
        return startLocationJSON;
    }

    public static JSONObject encodeEndLocation(EndLocation endLocation) throws JSONException {

        if(endLocation == null){
            return null;
        }

        if (endLocation.getGeometry() == null){
            return null;
        }

        JSONObject endLocationJSON = new JSONObject();
        endLocationJSON.put("id", endLocation.getId());
        endLocationJSON.put("name", endLocation.getName());
        endLocationJSON.put("description", endLocation.getDescription());
        endLocationJSON.put("address", endLocation.getAddress());
        endLocationJSON.put("metadata", endLocation.getMetadata());
        endLocationJSON.put("recorded_at", endLocation.getRecordedAt());

        JSONObject geometry = new JSONObject();
        geometry.put("type", endLocation.getGeometry().getType());
        JSONArray coordinates = new JSONArray();
        for (int y=0; y<endLocation.getGeometry().getCoordinates().size(); y++){
            coordinates.put(endLocation.getGeometry().getCoordinates().get(y));
        }
        geometry.put("coordinates", coordinates);
        endLocationJSON.put("geometry", geometry);
        return endLocationJSON;
    }

    public static JSONObject encodeUser(User user) throws JSONException {

        if (user == null){return null;}

        JSONObject userJSON = new JSONObject();
        userJSON.put("name", user.getName());
        userJSON.put("description", user.getDescription());
        userJSON.put("id", user.getId());
        JSONObject metadata = null;
        try{
            metadata = new JSONObject((Map) user.getMetadata());
        } catch (Exception e){
            e.printStackTrace();
        }
        userJSON.put("metadata", metadata);
        return userJSON;
    }

    public static JSONObject encodeStop(Stop stop) throws JSONException {

        if (stop == null){return null;}

        JSONObject stopJSON = new JSONObject();
        stopJSON.put("id", stop.getId());
        stopJSON.put("name", stop.getStopName());
        stopJSON.put("description", stop.getStopDescription());
        stopJSON.put("address", stop.getAddress());
        JSONObject metadata = null;
        try{
            metadata = new JSONObject((Map) stop.getMetadata());
        } catch (Exception e){
            e.printStackTrace();
        }
        stopJSON.put("metadata", metadata);
        stopJSON.put("geometry_radius", stop.getGeometryRadius());
        stopJSON.put("created_at", stop.getCreatedAt());
        stopJSON.put("updated_at", stop.getUpdatedAt());
        stopJSON.put("arrived_at", stop.getArrivedAt());
        stopJSON.put("departed_at", stop.getDepartedAt());
        JSONObject geometry = new JSONObject();
        geometry.put("type", stop.getGeometry().getType());
        JSONArray coordinates = new JSONArray();
        for (int y=0; y<stop.getGeometry().getCoordinates().size(); y++){
            coordinates.put(stop.getGeometry().getCoordinates().get(y));
        }
        geometry.put("coordinates", coordinates);
        stopJSON.put("geometry", geometry);
        return stopJSON;
    }

    public static JSONObject encodeEvents(Events events) throws JSONException {

        if(events == null){return null;}

        JSONObject eventsJSON = new JSONObject();
        eventsJSON.put("id", events.getId());
        eventsJSON.put("trip_id", events.getTripId());
        eventsJSON.put("user_id", events.getUserId());
        eventsJSON.put("event_type", events.getEventType());
        eventsJSON.put("created_at", events.getCreatedAt());
        eventsJSON.put("event_source", events.getEventSource());
        eventsJSON.put("event_version", events.getEventVersion());
        eventsJSON.put("location_id", events.getLocationId());
        return eventsJSON;
    }

    public static JSONObject encodeRoutes(Routes routes) throws JSONException {

        if(routes == null){return null;}

        JSONObject routesJSON = new JSONObject();
        JSONObject metadata = null;
        try{
            metadata = new JSONObject((Map) routes.getMetadata());
        } catch (Exception e){
            e.printStackTrace();
        }
        routesJSON.put("metadata", metadata);
        routesJSON.put("activity", routes.getActivity());
        routesJSON.put("speed", routes.getSpeed());
        routesJSON.put("altitude", routes.getAltitude());
        routesJSON.put("distance", routes.getDistance());
        routesJSON.put("duration", routes.getDuration());
        routesJSON.put("elevation_gain", routes.getElevationGain());

        JSONObject coordinates = new JSONObject();
        coordinates.put("type",routes.getCoordinates().getType());
        JSONArray coordinatesArray = new JSONArray();
        for (int i=0; i<routes.getCoordinates().getCoordinates().size(); i++){
            coordinatesArray.put(routes.getCoordinates().getCoordinates().get(i));
        }
        coordinates.put("coordinates", coordinatesArray);

        routesJSON.put("coordinates", coordinates);
        routesJSON.put("recorded_at", routes.getRecordedAt());
        routesJSON.put("location_id", routes.getLocationId());
        return routesJSON;
    }


    public static JSONObject encodeRoamTripResponse(RoamTripResponse roamTripResponse){
        JSONObject json = new JSONObject();
        try {
            json.put("code", roamTripResponse.getCode().intValue());
            json.put("message", roamTripResponse.getMessage());
            json.put("description", roamTripResponse.getDescription());

            JSONObject tripDetails = new JSONObject();
            tripDetails.put("id", roamTripResponse.getTripDetails().getTripId());
            tripDetails.put("name", roamTripResponse.getTripDetails().getTripName());
            tripDetails.put("description", roamTripResponse.getTripDetails().getTripDescription());
            tripDetails.put("trip_state", roamTripResponse.getTripDetails().getTripState());
            tripDetails.put("total_distance", roamTripResponse.getTripDetails().getTotalDistance());
            tripDetails.put("total_duration", roamTripResponse.getTripDetails().getTotalDuration());
            tripDetails.put("total_elevation_gain", roamTripResponse.getTripDetails().getTotalElevationGain());
            JSONObject metaData = null;
            try {
              //  Log.e("ROAM", roamTripResponse.getTripDetails().getMetadata().getClass().toString());
                metaData = new JSONObject((Map) roamTripResponse.getTripDetails().getMetadata());
            } catch (Exception e) {
                e.printStackTrace();
            }
            tripDetails.put("metadata", metaData);
            tripDetails.put("start_location", JsonEncoder.encodeStartLocation(roamTripResponse.getTripDetails().getStartLocation()));
            tripDetails.put("end_location", JsonEncoder.encodeEndLocation(roamTripResponse.getTripDetails().getEndLocation()));
            tripDetails.put("user", JsonEncoder.encodeUser(roamTripResponse.getTripDetails().getUser()));
            tripDetails.put("started_at", roamTripResponse.getTripDetails().getStartedAt());
            tripDetails.put("ended_at", roamTripResponse.getTripDetails().getEndedAt());
            tripDetails.put("created_at", roamTripResponse.getTripDetails().getCreatedAt());
            tripDetails.put("updated_at", roamTripResponse.getTripDetails().getUpdatedAt());
            tripDetails.put("is_local", roamTripResponse.getTripDetails().getIsLocal());
            tripDetails.put("has_more", roamTripResponse.getTripDetails().getHasMore());

            JSONArray stops = new JSONArray();
            if (roamTripResponse.getTripDetails().getStops() != null) {
                for (Stop stop : roamTripResponse.getTripDetails().getStops()) {
                    stops.put(JsonEncoder.encodeStop(stop));
                }
            }
            tripDetails.put("stops", stops);

            JSONArray eventsArray = new JSONArray();
            if (roamTripResponse.getTripDetails().getEvents() != null) {
                for (Events events : roamTripResponse.getTripDetails().getEvents()) {
                    eventsArray.put(JsonEncoder.encodeEvents(events));
                }
            }
            tripDetails.put("events", eventsArray);

            JSONArray route = new JSONArray();
            if (roamTripResponse.getTripDetails().getRoutes() != null) {
                for (Routes routes : roamTripResponse.getTripDetails().getRoutes()) {
                    route.put(JsonEncoder.encodeRoutes(routes));
                }
            }
            tripDetails.put("route", route);

            tripDetails.put("routeIndex", roamTripResponse.getTripDetails().getRouteIndex());

            json.put("trip", tripDetails);

        } catch (JSONException e) {
            e.printStackTrace();
        }
        return json;
    }


    public static JSONObject encodeError(Error error){
        JSONObject errorJson = new JSONObject();
        try {
            errorJson.put("errorCode", error.getErrorCode().intValue());
            errorJson.put("errorMessage", error.getErrorMessage());
            errorJson.put("errorDescription", error.getErrorDescription());
            JSONArray errors = new JSONArray();
            for (Errors e : error.getErrors()) {
                JSONObject errorsObj = new JSONObject();
                errorsObj.put("field", e.getField());
                errorsObj.put("message", e.getMessage());
                errors.put(errorsObj);
            }
            errorJson.put("errors", errors);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return errorJson;
    }


    public static JSONObject encodeRoamDeleteTripResponse(RoamDeleteTripResponse response){
        JSONObject json = new JSONObject();

        try {

            json.put("message", response.getMessage());
            json.put("description", response.getDescription());
            json.put("code", response.getCode());

            JSONObject trip = new JSONObject();
            trip.put("id", response.getTrip().getId());
            trip.put("isDeleted", response.getTrip().getIs_deleted());

            json.put("trip", trip);

        } catch (Exception e){
            e.printStackTrace();
        }

        return json;
    }



    public static JSONObject encodeRoamActiveTripsResponse(RoamActiveTripsResponse response){

        JSONObject json = new JSONObject();
        try {
            json.put("code", response.getCode());
            json.put("message", response.getMessage());
            json.put("description", response.getDescription());
            json.put("hasMore", response.isHas_more());

            Log.e("ROAM", "trip size: " + response.getTrips().size());
            JSONArray trips = new JSONArray();
            for (Trips responseTrip : response.getTrips()) {
                Log.e("ROAM", "encoding trip");
                Log.e("ROAM", "Trip Gson: " + new Gson().toJson(responseTrip));
                trips.put(JsonEncoder.encodeTrips(responseTrip));
            }
            json.put("trips", trips);
        }catch (Exception e){
            e.printStackTrace();
        }

        return json;
    }



    public static JSONObject encodeTrips(Trips trips) {

        JSONObject json = new JSONObject();
        try {
            json.put("id", trips.getTripId());
            json.put("trip_state", trips.getTripState());
            json.put("total_distance", trips.getTotalDistance());
            json.put("total_duration", trips.getTotalDuration());
            json.put("total_elevation_gain", trips.getTotalElevationGain());
            try {
                json.put("metadata", trips.metadata());
            } catch (Exception e) {
                e.printStackTrace();
            }
            json.put("user", JsonEncoder.encodeUser(trips.getUser()));
            json.put("started_at", trips.getStartedAt());
            json.put("ended_at", trips.getEndedAt());
            json.put("created_at", trips.getCreatedAt());
            json.put("updated_at", trips.getUpdatedAt());

            JSONArray events = new JSONArray();
            for (Events event : trips.getEvents()) {
                events.put(JsonEncoder.encodeEvents(event));
            }
            json.put("events", events);

            JSONArray stops = new JSONArray();
            for (Stop stop : trips.getStop()) {
                stops.put(JsonEncoder.encodeStop(stop));
            }
            json.put("stops", stops);

            json.put("syncStatus", trips.getSyncStatus());
            json.put("isPaused", trips.isPaused());
            json.put("isStarted", trips.isStarted());
            json.put("isEnded", trips.isEnded());
            json.put("isResumed", trips.isEnded());
        } catch (Exception e){
            e.printStackTrace();
        }

        return json;
    }


    public static JSONObject encodeRoamSyncTripResponse(RoamSyncTripResponse response){

        JSONObject json = new JSONObject();

        try{
            json.put("msg", response.getMessage());
            json.put("description", response.getDescription());
            json.put("code", response.getCode());

            JSONObject data = new JSONObject();
            if (response.getData() != null) {
                data.put("trip_id", response.getData().getTrip_id());
                data.put("is_synced", response.getData().getIsSynced());
            }
            json.put("data", data);

        } catch (Exception e){
            e.printStackTrace();
        }

        return json;
    }





}
