import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:core';
import 'dart:core';
import 'dart:developer';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:roam_flutter/json/JsonDecoder.dart';
import 'package:roam_flutter/RoamTrackingMode.dart';
import 'package:roam_flutter/json/JsonEncoder.dart';
import 'package:roam_flutter/trips_v2/RoamTrip.dart';
import 'package:roam_flutter/trips_v2/callback/ErrorCallback.dart';
import 'package:roam_flutter/trips_v2/callback/RoamActiveTripsCallback.dart';
import 'package:roam_flutter/trips_v2/callback/RoamDeleteTripCallback.dart';
import 'package:roam_flutter/trips_v2/callback/RoamSyncTripCallback.dart';
import 'package:roam_flutter/trips_v2/callback/RoamTripCallback.dart';
import 'package:roam_flutter/trips_v2/models/Error.dart';
import 'package:roam_flutter/trips_v2/models/RoamActiveTripsResponse.dart';
import 'package:roam_flutter/trips_v2/request/RoamTripStops.dart';

typedef void RoamCallBack({String? location});
typedef void RoamUserCallBack({String? user});
typedef void RoamTripCallBack({String? trip});
typedef void RoamLocationCallback(Map? location);

class Roam {
  static const String METHOD_INITIALIZE = "initialize";
  static const String METHOD_GET_CURRENT_LOCATION = "getCurrentLocation";
  static const String METHOD_CREATE_USER = "createUser";
  static const String METHOD_UPDATE_CURRENT_LOCATION = "updateCurrentLocation";
  static const String METHOD_START_TRACKING = "startTracking";
  static const String METHOD_STOP_TRACKING = "stopTracking";
  static const String METHOD_LOGOUT_USER = "logoutUser";
  static const String METHOD_GET_USER = "getUser";
  static const String METHOD_TOGGLE_LISTENER = "toggleListener";
  static const String METHOD_TOGGLE_EVENTS = "toggleEvents";
  static const String METHOD_GET_LISTENER_STATUS = "getListenerStatus";
  static const String METHOD_SUBSCRIBE_LOCATION = "subscribeLocation";
  static const String METHOD_SUBSCRIBE_USER_LOCATION = "subscribeUserLocation";
  static const String METHOD_SUBSCRIBE_EVENTS = "subscribeEvents";
  static const String METHOD_ENABLE_ACCURACY_ENGINE = "enableAccuracyEngine";
  static const String METHOD_DISABLE_ACCURACY_ENGINE = "disableAccuracyEngine";
  static const String METHOD_OFFLINE_TRACKING = "offlineTracking";
  static const String METHOD_CREATE_TRIP = "createTrip";
  static const String METHOD_UPDATE_TRIP = "updateTrip";
  static const String METHOD_GET_TRIP = "getTrip";
  static const String METHOD_GET_TRIP_DETAILS = "getTripDetails";
  static const String METHOD_GET_TRIP_STATUS = "getTripStatus";
  static const String METHOD_SUBSCRIBE_TRIP_STATUS = "subscribeTripStatus";
  static const String METHOD_UNSUBSCRIBE_TRIP_STATUS = "unSubscribeTripStatus";
  static const String METHOD_START_TRIP = "startTrip";
  static const String METHOD_START_QUICK_TRIP = "startQuickTrip";
  static const String METHOD_PAUSE_TRIP = "pauseTrip";
  static const String METHOD_RESUME_TRIP = "resumeTrip";
  static const String METHOD_END_TRIP = "endTrip";
  static const String METHOD_SYNC_TRIP = "syncTrip";
  static const String METHOD_SUBSCRIBE_TRIP = "subscribeTrip";
  static const String METHOD_UNSUBSCRIBE_TRIP = "unsubscribeTrip";
  static const String METHOD_DELETE_TRIP = "deleteTrip";
  static const String METHOD_GET_ACTIVE_TRIPS = "getActiveTrips";
  static const String METHOD_GET_TRIP_SUMMARY = "getTripSummary";
  static const String METHOD_DISABLE_BATTERY_OPTIMIZATION =
      "disableBatteryOptimization";
  static const String METHOD_ALLOW_MOCK_LOCATION = "allowMockLocation";
  static const String METHOD_FOREGROUND_SERVICE = "foregroundService";
  static const String METHOD_ON_LOCATION = "onLocation";

  static const String TRACKING_MODE_PASSIVE = "passive";
  static const String TRACKING_MODE_BALANCED = "balanced";
  static const String TRACKING_MODE_ACTIVE = "active";

  static const MethodChannel _channel = const MethodChannel('roam_flutter');
  static late RoamCallBack _callBack;
  static late RoamUserCallBack _userCallBack;
  static late RoamTripCallBack _tripCallBack;


  static const EventChannel _locationEventChannel = const EventChannel(
      'roam_flutter_event/location');

  /// Initialize SDK
  /// Accepts SDK Key from Roam Playground Project Setting
  static Future<bool?> initialize({
    required String publishKey,
  }) async {
    final Map<String, dynamic> params = <String, dynamic>{
      'publishKey': publishKey
    };
    final bool? result = await _channel.invokeMethod(METHOD_INITIALIZE, params);
    _channel.setMethodCallHandler(_methodCallHandler);
    return result;
  }

  /// Create User
  /// Accepts Description in String Format
  /// Returns Roam User
  static Future<void> createUser(
      {required String description, required RoamUserCallBack callBack}) async {
    final Map<String, dynamic> params = <String, dynamic>{
      'description': description
    };
    final String? result =
    await _channel.invokeMethod(METHOD_CREATE_USER, params);
    callBack(user: result);
  }

  /// Get User
  /// Accepts Roam User Id in String Format
  /// Returns Roam User
  static Future<void> getUser(
      {required String userId, required RoamUserCallBack callBack}) async {
    final Map<String, dynamic> params = <String, dynamic>{'userId': userId};
    final String? result = await _channel.invokeMethod(METHOD_GET_USER, params);
    callBack(user: result);
  }

  /// Toggle User Listener
  /// Accepts Boolean values for Events & Locations
  /// Returns Roam User
  static Future<void> toggleListener({required bool events,
    bool? locations,
    required RoamUserCallBack callBack}) async {
    final Map<String, dynamic> params = <String, dynamic>{
      'events': events,
      'locations': locations
    };
    final String? result =
    await _channel.invokeMethod(METHOD_TOGGLE_LISTENER, params);
    callBack(user: result);
  }



  /// Location Listener
  /// Accepts RoamLocationCallback object
  /// Returns location map
  static Future<void> onLocation(RoamLocationCallback roamLocationCallback) async {
    _locationEventChannel.receiveBroadcastStream().listen((data) {
      roamLocationCallback(data);
    });
  }




  /// Toggle User Events
  /// Accepts Boolean values for Geofence, Trips, Moving Geofence & Location
  /// Returns Roam User
  static Future<void> toggleEvents({required bool location,
    bool? geofence,
    bool? trips,
    bool? movingGeofence,
    required RoamUserCallBack callBack}) async {
    final Map<String, dynamic> params = <String, dynamic>{
      'geofence': geofence,
      'location': location,
      'trips': trips,
      'movingGeofence': movingGeofence
    };
    final String? result =
    await _channel.invokeMethod(METHOD_TOGGLE_EVENTS, params);
    callBack(user: result);
  }

  /// Get User Listener Status
  /// Accepts Roam User Id in String Format
  /// Returns Roam User
  static Future<void> getListenerStatus(
      {required RoamUserCallBack callBack}) async {
    final String? result =
    await _channel.invokeMethod(METHOD_GET_LISTENER_STATUS);
    callBack(user: result);
  }

  /// Set foreground notification for android
  /// Accepts bool and String
  /// Returns void
  static Future<void> setForeground(bool enabled,
      String title,
      String description,
      String icon,
      String activity) async {
    final Map<String, dynamic> param = <String, dynamic>{
      'enableForeground': enabled,
      'foregroundTitle': title,
      'foregroundDescription': description,
      'foregroundImage': icon,
      'foregroundActivity': activity
    };
    await _channel.invokeMethod(METHOD_FOREGROUND_SERVICE, param);
  }

  /// Update Current Location
  /// Accepts Accuracy Value in Int format
  /// Returns Location
  static Future<bool?> updateCurrentLocation({
    required int accuracy,
    Map<String, dynamic>? jsonObject
  }) async {
    String jsonString = (jsonObject == null) ? "" : jsonEncode(jsonObject);
    final Map<String, dynamic> params = <String, dynamic>{
      'accuracy': accuracy,
      'jsonObject': jsonString
    };
    final bool? result =
    await _channel.invokeMethod(METHOD_UPDATE_CURRENT_LOCATION, params);
    _channel.setMethodCallHandler(_methodCallHandler);
    return result;
  }

  /// Get Current Location
  /// Accepts Accuracy Value in Int format
  /// Returns Location
  static Future<void> getCurrentLocation(
      {required int accuracy, required RoamCallBack callBack}) async {
    final Map<String, dynamic> params = <String, dynamic>{'accuracy': accuracy};
    final String? result =
    await _channel.invokeMethod(METHOD_GET_CURRENT_LOCATION, params);
    callBack(location: result);
  }

  static Future<bool?> startTracking(
      {required dynamic trackingMode, Map? customMethods}) async {
    final Map<String, dynamic> params = <String, dynamic>{
      'trackingMode': trackingMode,
      'customMethods': customMethods
    };
    final bool? result =
    await _channel.invokeMethod(METHOD_START_TRACKING, params);
    return result;
  }

  static Future<void> offlineTracking(bool enabled) async {
    await _channel.invokeMethod(
        METHOD_OFFLINE_TRACKING, {'offlineTracking': enabled});
  }

  /// Logout User
  /// Use this method to logout current session of the user and before creating/get another user
  static Future<bool?> logoutUser() async {
    final bool? result = await _channel.invokeMethod(METHOD_LOGOUT_USER);
    _channel.setMethodCallHandler(_methodCallHandler);
    return result;
  }

  /// Disable Battery Optimization in Android
  /// This method is only for Android devices to disable all battery optimization settings by OS and allow
  /// the application to track location in background
  static Future<bool?> disableBatteryOptimization() async {
    try {
      final bool? result =
      await _channel.invokeMethod(METHOD_DISABLE_BATTERY_OPTIMIZATION);
      _channel.setMethodCallHandler(_methodCallHandler);
      return result;
    } catch (error) {
      print(error);
    }
  }

  /// Subscribe Location
  /// Use this method to enable subscription to own location updates
  static Future<bool?> subscribeLocation() async {
    final bool? result = await _channel.invokeMethod(METHOD_SUBSCRIBE_LOCATION);
    _channel.setMethodCallHandler(_methodCallHandler);
    return result;
  }

  /// Subscribe Events
  /// Use this method to enable subscription to own events
  static Future<bool?> subscribeEvents() async {
    final bool? result = await _channel.invokeMethod(METHOD_SUBSCRIBE_EVENTS);
    _channel.setMethodCallHandler(_methodCallHandler);
    return result;
  }

  /// Subscribe User Location
  /// Accepts Roam User Id
  /// Use this method to enable subscription to other user's location updates
  static Future<bool?> subscribeUserLocation({
    required String userId,
  }) async {
    final Map<String, dynamic> params = <String, dynamic>{'userId': userId};
    final bool? result =
    await _channel.invokeMethod(METHOD_SUBSCRIBE_USER_LOCATION, params);
    _channel.setMethodCallHandler(_methodCallHandler);
    return result;
  }

  /// Stop Tracking
  /// Use this method to stop the location tracking
  static Future<bool?> stopTracking() async {
    final bool? result = await _channel.invokeMethod(METHOD_STOP_TRACKING);
    _channel.setMethodCallHandler(_methodCallHandler);
    return result;
  }

  /// Enable Accuracy Engine
  /// Use this method improve accuracy for location updates
  static Future<bool?> enableAccuracyEngine() async {
    final bool? result =
    await _channel.invokeMethod(METHOD_ENABLE_ACCURACY_ENGINE);
    _channel.setMethodCallHandler(_methodCallHandler);
    return result;
  }

  /// Enable Accuracy Engine
  /// Use this method disable accuracy engine for location updates
  static Future<bool?> disableAccuracyEngine() async {
    final bool? result =
    await _channel.invokeMethod(METHOD_DISABLE_ACCURACY_ENGINE);
    _channel.setMethodCallHandler(_methodCallHandler);
    return result;
  }


  static Future<void> createTrip(RoamTrip roamTrip,
      RoamTripCallback roamTripCallback,
      ErrorCallback errorCallback) async {
    Map<String, dynamic> json = JsonEncoder.encodeRoamTrip(roamTrip);

    final String? result = await _channel.invokeMethod(
        METHOD_CREATE_TRIP, {'roamTrip': jsonEncode(json)});

    if (result == null) {
      log("Create trip result null!");
      return;
    }

    try {
      Map json = jsonDecode(result);
      if (json.containsKey("error")) {
        log('error');
        errorCallback(error: JsonDecoder.decodeError(json['error']));
      } else {
        roamTripCallback(
            roamTripResponse: JsonDecoder.decodeRoamTripResponse(json));
      }
    } catch (exception) {
      log('response error: ' + exception.toString());
    }
  }


  static Future<void> updateTrip(RoamTrip roamTrip,
      RoamTripCallback roamTripCallback,
      ErrorCallback errorCallback) async {
    if (roamTrip.tripId == null) {
      roamTrip.tripId = '';
    }
    Map<String, dynamic> json = JsonEncoder.encodeRoamTrip(roamTrip);

    final String? result = await _channel.invokeMethod(
        METHOD_UPDATE_TRIP, {'roamTrip': jsonEncode(json)});

    if (result == null) {
      log("Update trip result null!");
      return;
    }

    try {
      Map json = jsonDecode(result);
      if (json.containsKey("error")) {
        errorCallback(error: JsonDecoder.decodeError(json['error']));
      } else {
        roamTripCallback(
            roamTripResponse: JsonDecoder.decodeRoamTripResponse(json));
      }
    } catch (exception) {
      log(exception.toString());
    }
  }


  static Future<void> getTripDetails(
      {required String tripId, required RoamTripCallBack callBack}) async {
    final Map<String, dynamic> params = <String, dynamic>{'tripId': tripId};
    final String? result =
    await _channel.invokeMethod(METHOD_GET_TRIP_DETAILS, params);
    callBack(trip: result);
  }

  static Future<void> getTripStatus(
      {required String tripId, required RoamTripCallBack callBack}) async {
    final Map<String, dynamic> params = <String, dynamic>{'tripId': tripId};
    final String? result =
    await _channel.invokeMethod(METHOD_GET_TRIP_STATUS, params);
    callBack(trip: result);
  }

  static Future<bool?> subscribeTripStatus({
    required String tripId,
  }) async {
    final Map<String, dynamic> params = <String, dynamic>{'tripId': tripId};
    final bool? result =
    await _channel.invokeMethod(METHOD_SUBSCRIBE_TRIP_STATUS, params);
    _channel.setMethodCallHandler(_methodCallHandler);
    return result;
  }

  static Future<bool?> ubSubscribeTripStatus({
    required String tripId,
  }) async {
    final Map<String, dynamic> params = <String, dynamic>{'tripId': tripId};
    final bool? result =
    await _channel.invokeMethod(METHOD_UNSUBSCRIBE_TRIP_STATUS, params);
    _channel.setMethodCallHandler(_methodCallHandler);
    return result;
  }

  static Future<void> allowMockLocation({
    required bool allow
  }) async {
    await _channel.invokeMethod(
        METHOD_ALLOW_MOCK_LOCATION, {'allowMockLocation': allow});
  }


  static Future<void> startTrip(RoamTripCallback roamTripCallback,
      ErrorCallback errorCallback,
      {
        String? tripId,
        RoamTrip? roamTrip,
        RoamTrackingMode? roamTrackingMode,
      }) async {
    if (roamTrip != null) {
      //start quick trip

      if (roamTrackingMode == null) {
        roamTrackingMode = RoamTrackingMode.ACTIVE;
      }

      Map<String, dynamic> json = Map();

      Map<String, dynamic> roamTripJson = JsonEncoder.encodeRoamTrip(roamTrip);
      json['roamTrip'] = jsonEncode(roamTripJson);

      json['roamTrackingMode'] =
          jsonEncode(JsonEncoder.encodeRoamTrackingMode(roamTrackingMode));

      final String? result = await _channel.invokeMethod(
          METHOD_START_QUICK_TRIP, json);

      if (result == null) {
        log("Update trip result null!");
        return;
      }

      try {
        Map json = jsonDecode(result);
        if (json.containsKey("error")) {
          errorCallback(error: JsonDecoder.decodeError(json['error']));
        } else {
          roamTripCallback(
              roamTripResponse: JsonDecoder.decodeRoamTripResponse(json));
        }
      } catch (exception) {
        log(exception.toString());
      }
    } else {
      //start planned trip

      final String? result = await _channel.invokeMethod(
          METHOD_START_TRIP, {'tripId': tripId ?? ''});

      if (result == null) {
        log("Start trip result null!");
        return;
      }

      print(result);

      try {
        Map json = jsonDecode(result);
        if (json.containsKey("error")) {
          errorCallback(error: JsonDecoder.decodeError(json['error']));
        } else {
          roamTripCallback(
              roamTripResponse: JsonDecoder.decodeRoamTripResponse(json));
        }
      } catch (exception) {
        log(exception.toString());
      }
    }
  }


  static Future<void> pauseTrip(String tripId,
      RoamTripCallback roamTripCallback,
      ErrorCallback errorCallback) async {
    final String? result = await _channel.invokeMethod(
        METHOD_PAUSE_TRIP, {'tripId': tripId ?? ''});

    if (result == null) {
      log("Pause trip result null!");
      return;
    }

    try {
      Map json = jsonDecode(result);
      if (json.containsKey("error")) {
        errorCallback(error: JsonDecoder.decodeError(json['error']));
      } else {
        roamTripCallback(
            roamTripResponse: JsonDecoder.decodeRoamTripResponse(json));
      }
    } catch (exception) {
      log(exception.toString());
    }
  }


  static Future<void> resumeTrip(String tripId,
      RoamTripCallback roamTripCallback,
      ErrorCallback errorCallback) async {
    final String? result = await _channel.invokeMethod(
        METHOD_RESUME_TRIP, {'tripId': tripId ?? ''});

    if (result == null) {
      log("Resume trip result null!");
      return;
    }

    try {
      Map json = jsonDecode(result);
      if (json.containsKey("error")) {
        errorCallback(error: JsonDecoder.decodeError(json['error']));
      } else {
        roamTripCallback(
            roamTripResponse: JsonDecoder.decodeRoamTripResponse(json));
      }
    } catch (exception) {
      log(exception.toString());
    }
  }


  static Future<void> endTrip(String tripId,
      bool stopTracking,
      RoamTripCallback roamTripCallback,
      ErrorCallback errorCallback) async {
    Map<String, dynamic> json = Map();
    json['tripId'] = tripId ?? '';
    json['stopTracking'] = stopTracking;


    final String? result = await _channel.invokeMethod(METHOD_END_TRIP, json);

    if (result == null) {
      log("End trip result null!");
      return;
    }

    try {
      Map json = jsonDecode(result);
      if (json.containsKey("error")) {
        errorCallback(error: JsonDecoder.decodeError(json['error']));
      } else {
        roamTripCallback(
            roamTripResponse: JsonDecoder.decodeRoamTripResponse(json));
      }
    } catch (exception) {
      log(exception.toString());
    }
  }


  static Future<void> deleteTrip(String tripId,
      RoamDeleteTripCallback roamDeleteTripCallback,
      ErrorCallback errorCallback) async {
    final String? result = await _channel.invokeMethod(
        METHOD_DELETE_TRIP, {'tripId': tripId ?? ''});

    if (result == null) {
      log("Delete trip result null!");
      return;
    }

    try {
      Map json = jsonDecode(result);
      if (json.containsKey("error")) {
        errorCallback(error: JsonDecoder.decodeError(json['error']));
      } else {
        roamDeleteTripCallback(
            roamDeleteTripResponse: JsonDecoder.decodeRoamDeleteTripResponse(
                json));
      }
    } catch (exception) {
      log(exception.toString());
    }
  }


  static void subscribeTrip(String tripId) {
    _channel.invokeMethod(METHOD_SUBSCRIBE_TRIP, {'tripId': tripId});
  }

  static void unsubscribeTrip(String tripId) {
    _channel.invokeMethod(METHOD_UNSUBSCRIBE_TRIP, {'tripId': tripId});
  }


  static Future<void> getTrip(String tripId,
      RoamTripCallback roamTripCallback,
      ErrorCallback errorCallback) async {
    print('get trip id: ' + tripId);
    final String? result = await _channel.invokeMethod(
        METHOD_GET_TRIP, {'tripId': tripId ?? ''});

    if (result == null) {
      log("Get trip result null!");
      return;
    }

    try {
      Map json = jsonDecode(result);
      if (json.containsKey("error")) {
        errorCallback(error: JsonDecoder.decodeError(json['error']));
      } else {
        roamTripCallback(
            roamTripResponse: JsonDecoder.decodeRoamTripResponse(json));
      }
    } catch (exception) {
      log(exception.toString());
    }
  }


  static Future<void> syncTrip(String tripId,
      RoamSyncTripCallback roamSyncTripCallback,
      ErrorCallback errorCallback) async {
    final String? result = await _channel.invokeMethod(
        METHOD_SYNC_TRIP, {'tripId': tripId ?? ''});

    if (result == null) {
      log("Sync trip result null!");
      return;
    }

    try {
      Map json = jsonDecode(result);
      if (json.containsKey("error")) {
        errorCallback(error: JsonDecoder.decodeError(json['error']));
      } else {
        roamSyncTripCallback(
            roamSyncTripResponse: JsonDecoder.decodeRoamSyncTripResponse(json));
      }
    } catch (exception) {
      log(exception.toString());
    }
  }


  static Future<void> getActiveTrips(bool isLocal,
      RoamActiveTripsCallback roamActiveTripsCallback,
      ErrorCallback errorCallback) async {
    final String? result = await _channel.invokeMethod(
        METHOD_GET_ACTIVE_TRIPS, {'isLocal': isLocal});

    if (result == null) {
      log("Active trip result null!");
      return;
    }

    try {
      Map json = jsonDecode(result);
      if (json.containsKey("error")) {
        errorCallback(error: JsonDecoder.decodeError(json['error']));
      } else {
        roamActiveTripsCallback(
            roamActiveTripResponse: JsonDecoder.decodeRoamActiveTripResopnse(
                json));
      }
    } catch (exception) {
      log(exception.toString());
    }
  }


  static Future<void> getTripSummary(String tripId,
      RoamTripCallback roamTripCallback,
      ErrorCallback errorCallback) async {
    final String? result = await _channel.invokeMethod(
        METHOD_GET_TRIP_SUMMARY, {'tripId': tripId ?? ''});


    if (result == null) {
      log("Get trip result null!");
      return;
    }

    print('summary: ' + result);

    try {
      Map json = jsonDecode(result);
      if (json.containsKey("error")) {
        errorCallback(error: JsonDecoder.decodeError(json['error']));
      } else {
        roamTripCallback(
            roamTripResponse: JsonDecoder.decodeRoamTripResponse(json));
      }
    } catch (exception) {
      log(exception.toString());
    }
  }


  static Future<void> _methodCallHandler(MethodCall call) async {
    switch (call.method) {
      case 'callback':
        _callBack(
          location: call.arguments['location'],
        );
        _userCallBack(
          user: call.arguments['user'],
        );
        _tripCallBack(
          trip: call.arguments['trip'],
        );
        break;

      default:
        print('This normally shouldn\'t happen.');
    }
  }

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}

