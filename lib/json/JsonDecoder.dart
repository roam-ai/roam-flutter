
import 'dart:developer';

import 'package:roam_flutter/RoamTrackingMode.dart';
import 'package:roam_flutter/models/Coordinates.dart';
import 'package:roam_flutter/trips_v2/models/Data.dart';
import 'package:roam_flutter/trips_v2/models/EndLocation.dart';
import 'package:roam_flutter/trips_v2/models/Error.dart';
import 'package:roam_flutter/trips_v2/models/Errors.dart';
import 'package:roam_flutter/trips_v2/models/Events.dart';
import 'package:roam_flutter/trips_v2/models/Geometry.dart';
import 'package:roam_flutter/trips_v2/models/RoamActiveTripsResponse.dart';
import 'package:roam_flutter/trips_v2/models/RoamDeleteTripResponse.dart';
import 'package:roam_flutter/trips_v2/models/RoamSyncTripResponse.dart';
import 'package:roam_flutter/trips_v2/models/RoamTripResponse.dart';
import 'package:roam_flutter/trips_v2/models/Routes.dart';
import 'package:roam_flutter/trips_v2/models/StartLocation.dart';
import 'package:roam_flutter/trips_v2/models/Stop.dart';
import 'package:roam_flutter/trips_v2/models/Trip.dart' as ResponseTrip;
import 'package:roam_flutter/trips_v2/models/TripDetails.dart';
import 'package:roam_flutter/trips_v2/models/Trips.dart';
import 'package:roam_flutter/trips_v2/models/User.dart';

class JsonDecoder{

  static RoamTripResponse? decodeRoamTripResponse(Map json){

    if(!json.containsKey("trip")){
      return null;
    }


    var code = json['code'];
    String? message = json['message'];
    String? description = json['description'];
    TripDetails? tripDetails = (json['trip'] == "") ? null : JsonDecoder.decodeTripDetails(json['trip']);

    RoamTripResponse roamTripResponse = RoamTripResponse(
      code: code,
      message: message,
      description: description,
      tripDetails: tripDetails
    );
    return roamTripResponse;
  }



  static TripDetails? decodeTripDetails(Object? mapInput){

    if(mapInput == null || !(mapInput is Map?)){
      return null;
    }


    try {
      Map map = mapInput as Map;

      String? id = map['id'];
      String? name = map['name'];
      String? description = map['description'];
      String? tripState = map['trip_state'];
      var totalDistance = map['total_distance'];
      var totalDuration = map['total_duration'];
      var totalElevationGain = map['total_elevation_gain'];
      var metadata = map['metadata'];
      StartLocation? startLocation = JsonDecoder.decodeStartLocation(
          map['start_location']);

      EndLocation? endLocation = JsonDecoder.decodeEndLocation(
          map['end_location']);
      User? user = JsonDecoder.decodeUser(map['user']);
      String? startedAt = map['started_at'];
      String? endedAt = map['ended_at'];
      String? createdAt = map['created_at'];
      String? updatedAt = map['updated_at'];
      bool? isLocal = map['is_local'];
      bool? hasMore = map['has_more'];

      List? stopsMapList = map['stops'];
      List<Stop?> stops = List.empty(growable: true);
      stopsMapList?.forEach((stopMap) {
        Stop? stop = JsonDecoder.decodeStop(stopMap);
        stops.add(stop);
      });

      List? eventsMapList = map['events'];
      List<Events?> eventsList = List.empty(growable: true);
      eventsMapList?.forEach((eventsMap) {
        Events? events = JsonDecoder.decodeEvents(eventsMap);
        eventsList.add(events);
      });

      List? routeMapList = map['route'];
      List<Routes?> routesList = List.empty(growable: true);
      routeMapList?.forEach((routesMap) {
        Routes? routes = JsonDecoder.decodeRoutes(routesMap);
        routesList.add(routes);
      });

      Map? routeIndex = map['routeIndex'];

      TripDetails tripDetails = TripDetails(
          id: id,
          name: name,
          description: description,
          tripState: tripState,
          totalDistance: totalDistance,
          totalDuration: totalDuration,
          totalElevationGain: totalElevationGain,
          metadata: metadata,
          startLocation: startLocation,
          endLocation: endLocation,
          user: user,
          startedAt: startedAt,
          endedAt: endedAt,
          createdAt: createdAt,
          updatedAt: updatedAt,
          isLocal: isLocal,
          hasMore: hasMore,
          stops: stops,
          events: eventsList,
          route: routesList,
          routeIndex: routeIndex
      );
      return tripDetails;
    } catch(error){
      print('decodeTripDetail: ' + error.toString());
      return null;
    }
  }





  static StartLocation? decodeStartLocation(Object? mapInput){

    if(mapInput == null || !(mapInput is Map?)){
      return null;
    }

    try {
      Map map = mapInput as Map;

      String? id = map['id'];
      String? name = map['name'];
      String? description = map['description'];
      String? address = map['address'];
      var metadata = map['metadata'];
      String? recordedAt = map['recorded_at'];

      Map<String, dynamic>? geometryMap = map['geometry'];
      String? type = geometryMap?['type'];
      List? coordinates = geometryMap?['coordinates'];

      Geometry geometry = Geometry(type: type, coordinates: coordinates);
      StartLocation startLocation = StartLocation(
          id: id,
          name: name,
          description: description,
          address: address,
          metadata: metadata,
          recordedAt: recordedAt,
          geometry: geometry
      );
      return startLocation;
    } catch(error){
      print('decodeStartLocation' + error.toString());
      return null;
    }
  }

  static EndLocation? decodeEndLocation(Object? mapInput){

    if(mapInput == null || !(mapInput is Map?)){
      return null;
    }

    try {
      Map map = mapInput as Map;

      String? id = map['id'];
      String? name = map['name'];
      String? description = map['description'];
      String? address = map['address'];
      var metadata = map['metadata'];
      String? recordedAt = map['recorded_at'];

      Map<String, dynamic>? geometryMap = map['geometry'];
      String? type = geometryMap?['type'];
      List? coordinates = geometryMap?['coordinates'];

      Geometry geometry = Geometry(type: type, coordinates: coordinates);
      EndLocation endLocation = EndLocation(
          id: id,
          name: name,
          description: description,
          address: address,
          metadata: metadata,
          recordedAt: recordedAt,
          geometry: geometry
      );
      return endLocation;
    } catch(error){
      print('decodeEndLocation' + error.toString());
      return null;
    }
  }


  static User? decodeUser(Object? mapInput){

    if(mapInput == null || !(mapInput is Map?)){
      return null;
    }

    try {
      Map map = mapInput as Map;

      String? name = map['name'];
      String? description = map['description'];
      String? id = map['id'];
      var metadata = map['metadata'];
      User user = User(
          name: name,
          description: description,
          metadata: metadata,
          id: id
      );
      return user;
    } catch (error){
      print('decodeUser ' + error.toString());
      return null;
    }

  }


  static Stop? decodeStop(Object? mapInput){

    if(mapInput == null || !(mapInput is Map?)){
      return null;
    }

    try {
      Map map = mapInput as Map;

      String? id = map['id'];
      String? name = map['name'];
      String? description = map['description'];
      String? address = map['address'];
      var metadata = map['metadata'];
      var geometryRadius = map['geometry_radius'];
      String? createdAt = map['created_at'];
      String? updatedAt = map['updated_at'];
      String? arrivedAt = map['arrived_at'];
      String? departedAt = map['departed_at'];


      var geometryMap = map['geometry'];
      String? type = geometryMap?['type'];
      List? coordinates = geometryMap?['coordinates'];

      Geometry geometry = Geometry(type: type, coordinates: coordinates);

      Stop stop = Stop(
          id: id,
          name: name,
          description: description,
          address: address,
          metadata: metadata,
          geometryRadius: geometryRadius,
          createdAt: createdAt,
          updatedAt: updatedAt,
          arrivedAt: arrivedAt,
          departedAt: departedAt,
          geometry: geometry
      );
      return stop;
    } catch (error){
      print('decodeStop ' + error.toString());
      return null;
    }
  }



  static Events? decodeEvents(Object? mapInput){

    if(mapInput == null || !(mapInput is Map?)){
      return null;
    }

    try {
      Map map = mapInput as Map;

      String? id = map['id'];
      String? tripId = map['trip_id'];
      String? userId = map['user_id'];
      String? eventType = map['event_type'];
      String? createdAt = map['created_at'];
      String? eventSource = map['event_source'];
      String? eventVersion = map['event_version'];
      String? locationId = map['location_id'];

      Events events = Events(
          id: id,
          tripId: tripId,
          userId: userId,
          eventType: eventType,
          createdAt: createdAt,
          eventSource: eventSource,
          eventVersion: eventVersion,
          locationId: locationId
      );
      return events;
    } catch (error){
      print('Decode event '+error.toString());
      return null;
    }
  }



  static Routes? decodeRoutes(Object? mapInput){

    if(mapInput == null || !(mapInput is Map?)){
      return null;
    }

    try {
      Map map = mapInput as Map;
      var metadata = map['metadata'];
      String? activity = map['activity'];
      var speed = map['speed'];
      var altitude = map['altitude'];
      var distance = map['distance'];
      var duration = map['duration'];
      var elevationGain = map['elevation_gain'];


      Map? coordinatesMap = map['coordinates'];
      String? type = coordinatesMap?['type'];
      List? coordinatesList = coordinatesMap?['coordinates'];

      Coordinates? coordinates = Coordinates(
          type: type,
          coordinates: coordinatesList
      );

      String? recordedAt = map['recorded_at'];
      String? locationId = map['location_id'];

      Routes routes = Routes(
          metadata: metadata,
          activity: activity,
          speed: speed,
          altitude: altitude,
          distance: distance,
          duration: duration,
          elevationGain: elevationGain,
          coordinates: coordinates,
          recordedAt: recordedAt,
          locationId: locationId
      );

      return routes;
    } catch(error){
      print('decode route '+error.toString());
      return null;
    }
  }


  static Error? decodeError(Object? mapInput){

    if(mapInput == null || !(mapInput is Map?)){
      return null;
    }

    try {
      Map map = mapInput as Map;

      var errorCode = map['errorCode'];
      String? errorMessage = map['errorMessage'];
      String? errorDescription = map['errorDescription'];

      List? errorsMapList = map['errors'];
      List<Errors> errorsList = List.empty(growable: true);
      errorsMapList?.forEach((errorsMap) {
        String? field = errorsMap['field'];
        String? message = errorsMap['message'];
        Errors errors = Errors(
            field: field,
            message: message
        );
        errorsList.add(errors);
      });

      Error error = Error(
          errorCode: errorCode,
          errorMessage: errorMessage,
          errorDescription: errorDescription,
          errors: errorsList
      );
      return error;
    } catch(error){
      print('decodeError '+error.toString());
      return null;
    }
  }


  static RoamDeleteTripResponse? decodeRoamDeleteTripResponse(Map map){

    String? message = map['message'];
    String? description = map['description'];
    var code = map['code'];

    Map<String, dynamic> tripMap = map['trip'];
    String? id = tripMap['id'];
    bool? isDeleted = tripMap['isDeleted'];

    ResponseTrip.Trip? trip = ResponseTrip.Trip(id, isDeleted);

    return RoamDeleteTripResponse(message, description, code, trip);
  }



  static RoamActiveTripResponse? decodeRoamActiveTripResopnse(Map map){


    var code = map['code'];
    var message = map['message'];
    var description = map['description'];
    var hasMore = map['hasMore'];

    List? tripsMapList = map['trips'];
    List<Trips?> trips = List.empty(growable: true);
    tripsMapList?.forEach((map) {
      trips.add(JsonDecoder.decodeTrips(map));
    });

    return RoamActiveTripResponse(code, message, description, hasMore, trips);

  }


  static Trips? decodeTrips(Object? mapInput){

    if(mapInput == null || !(mapInput is Map?)){
      return null;
    }

    try {
      Map map = mapInput as Map;

      String? id = map['id'];
      String? trip_state = map['trip_state'];
      var total_distance = map['total_distance'];
      var total_duration = map['total_duration'];
      var total_elevation_gain = map['total_elevation_gain'];
      var metadata = map['metadata'];
      User? user = JsonDecoder.decodeUser(map['user']);
      String? started_at = map['started_at'];
      String? ended_at = map['ended_at'];
      String? created_at = map['created_at'];
      String? updated_at = map['updated_at'];

      List? eventsMapList = map['events'];
      List<Events?>? events = List.empty(growable: true);
      eventsMapList?.forEach((map) {
        events.add(JsonDecoder.decodeEvents(map));
      });

      List? stopsMapList = map['stops'];
      List<Stop?>? stops = List.empty(growable: true);
      stopsMapList?.forEach((map) {
        stops.add(JsonDecoder.decodeStop(map));
      });

      String? syncStatus = map['syncStatus'];
      bool? isPaused = map['isPaused'];
      bool? isStarted = map['isStarted'];
      bool? isEnded = map['isEnded'];
      bool? isResumed = map['isResumed'];


      Trips? trips = Trips();

      trips.id = id;
      trips.tripState = trip_state;
      trips.totalDistance = total_distance;
      trips.totalDuration = total_duration;
      trips.totalElevation_gain = total_elevation_gain;
      trips.metadata = metadata;
      trips.user = user;
      trips.startedAt = started_at;
      trips.endedAt = ended_at;
      trips.createdAt = created_at;
      trips.updatedAt = updated_at;
      trips.events = events;
      trips.stop = stops;
      trips.syncStatus = syncStatus;
      trips.isPaused = isPaused;
      trips.isStarted = isStarted;
      trips.isEnded = isEnded;
      trips.isResumed = isResumed;


      return trips;
    } catch (error){
      print('decodeTrips '+error.toString());
      return null;
    }
  }



  static RoamSyncTripResponse? decodeRoamSyncTripResponse(Map map){


    String? msg = map['msg'];
    String? description = map['description'];
    var code = map['code'];
    Data? data = JsonDecoder.decodeData(map['data']);

    return RoamSyncTripResponse(msg, description, code, data);

  }

  static Data? decodeData(Object? mapInput){

    if(mapInput == null || !(mapInput is Map?)){
      return null;
    }

    Map map = mapInput as Map;

    String? trip_id = map['trip_id'];
    bool? is_synced = map['is_synced'];

    return Data(trip_id, is_synced);

  }






}