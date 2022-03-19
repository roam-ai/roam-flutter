import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';

typedef void RoamCallBack({String? location});
typedef void RoamUserCallBack({String? user});
typedef void RoamTripCallBack({String? trip});

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
  static const String METHOD_CREATE_TRIP = "createTrip";
  static const String METHOD_GET_TRIP_DETAILS = "getTripDetails";
  static const String METHOD_GET_TRIP_STATUS = "getTripStatus";
  static const String METHOD_SUBSCRIBE_TRIP_STATUS = "subscribeTripStatus";
  static const String METHOD_UNSUBSCRIBE_TRIP_STATUS = "unSubscribeTripStatus";
  static const String METHOD_START_TRIP = "startTrip";
  static const String METHOD_PAUSE_TRIP = "pauseTrip";
  static const String METHOD_RESUME_TRIP = "resumeTrip";
  static const String METHOD_END_TRIP = "endTrip";
  static const String METHOD_GET_TRIP_SUMMARY = "getTripSummary";
  static const String METHOD_DISABLE_BATTERY_OPTIMIZATION =
      "disableBatteryOptimization";

  static const String TRACKING_MODE_PASSIVE = "passive";
  static const String TRACKING_MODE_BALANCED = "balanced";
  static const String TRACKING_MODE_ACTIVE = "active";

  static const MethodChannel _channel = const MethodChannel('roam_flutter');
  static late RoamCallBack _callBack;
  static late RoamUserCallBack _userCallBack;
  static late RoamTripCallBack _tripCallBack;

  /// Initialize SDK
  /// Accepts SDK Key from GeoSpark Playground Project Setting
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
  /// Returns GeoSpark User
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
  /// Accepts GeoSpark User Id in String Format
  /// Returns GeoSpark User
  static Future<void> getUser(
      {required String userId, required RoamUserCallBack callBack}) async {
    final Map<String, dynamic> params = <String, dynamic>{'userId': userId};
    final String? result = await _channel.invokeMethod(METHOD_GET_USER, params);
    callBack(user: result);
  }

  /// Toggle User Listener
  /// Accepts Boolean values for Events & Locations
  /// Returns GeoSpark User
  static Future<void> toggleListener(
      {required bool events,
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

  /// Toggle User Events
  /// Accepts Boolean values for Geofence, Trips, Moving Geofence & Location
  /// Returns GeoSpark User
  static Future<void> toggleEvents(
      {required bool location,
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
  /// Accepts GeoSpark User Id in String Format
  /// Returns GeoSpark User
  static Future<void> getListenerStatus(
      {required RoamUserCallBack callBack}) async {
    final String? result =
        await _channel.invokeMethod(METHOD_GET_LISTENER_STATUS);
    callBack(user: result);
  }

  /// Update Current Location
  /// Accepts Accuracy Value in Int format
  /// Returns Location
  static Future<bool?> updateCurrentLocation({
    required int accuracy,
    Map<String, dynamic>? jsonObject
  }) async {
    String jsonString = (jsonObject == null) ? "" : jsonEncode(jsonObject);
    final Map<String, dynamic> params = <String, dynamic>{'accuracy': accuracy, 'jsonObject': jsonString};
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
    final bool? result =
        await _channel.invokeMethod(METHOD_DISABLE_BATTERY_OPTIMIZATION);
    _channel.setMethodCallHandler(_methodCallHandler);
    return result;
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
  /// Accepts GeoSpark User Id
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

  static Future<void> createTrip(
      {required bool isOffline, required RoamTripCallBack callBack}) async {
    final Map<String, dynamic> params = <String, dynamic>{
      'isOffline': isOffline
    };
    final String? result =
        await _channel.invokeMethod(METHOD_CREATE_TRIP, params);
    callBack(trip: result);
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

  static Future<bool?> startTrip({
    required String tripId,
  }) async {
    final Map<String, dynamic> params = <String, dynamic>{'tripId': tripId};
    final bool? result = await _channel.invokeMethod(METHOD_START_TRIP, params);
    _channel.setMethodCallHandler(_methodCallHandler);
    return result;
  }

  static Future<bool?> pauseTrip({
    required String tripId,
  }) async {
    final Map<String, dynamic> params = <String, dynamic>{'tripId': tripId};
    final bool? result = await _channel.invokeMethod(METHOD_PAUSE_TRIP, params);
    _channel.setMethodCallHandler(_methodCallHandler);
    return result;
  }

  static Future<bool?> resumeTrip({
    required String tripId,
  }) async {
    final Map<String, dynamic> params = <String, dynamic>{'tripId': tripId};
    final bool? result =
        await _channel.invokeMethod(METHOD_RESUME_TRIP, params);
    _channel.setMethodCallHandler(_methodCallHandler);
    return result;
  }

  static Future<bool?> endTrip({
    required String tripId,
  }) async {
    final Map<String, dynamic> params = <String, dynamic>{'tripId': tripId};
    final bool? result = await _channel.invokeMethod(METHOD_END_TRIP, params);
    _channel.setMethodCallHandler(_methodCallHandler);
    return result;
  }

  static Future<void> getTripSummary(
      {required String tripId, required RoamTripCallBack callBack}) async {
    final Map<String, dynamic> params = <String, dynamic>{'tripId': tripId};
    final String? result =
        await _channel.invokeMethod(METHOD_GET_TRIP_SUMMARY, params);
    callBack(trip: result);
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
