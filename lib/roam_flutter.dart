import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

typedef void RoamCallBack({String location});
typedef void RoamUserCallBack({String user});
typedef void RoamTripCallBack({String trip});

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

  static const String TRACKING_MODE_PASSIVE = "passive";
  static const String TRACKING_MODE_REACTIVE = "reactive";
  static const String TRACKING_MODE_ACTIVE = "active";

  static const String ACTIVITY_TYPE_FITNESS = "fitness";

  static const MethodChannel _channel = const MethodChannel('roam_flutter');
  static RoamCallBack _callBack;
  static RoamUserCallBack _userCallBack;
  static RoamTripCallBack _tripCallBack;

  static Future<bool> initialize({
    @required String publishKey,
  }) async {
    final Map<String, dynamic> params = <String, dynamic>{
      'publishKey': publishKey
    };
    final bool result = await _channel.invokeMethod(METHOD_INITIALIZE, params);
    _channel.setMethodCallHandler(_methodCallHandler);
    return result;
  }

  static Future<void> createUser(
      {@required String description, RoamUserCallBack callBack}) async {
    final Map<String, dynamic> params = <String, dynamic>{
      'description': description
    };
    final String result =
        await _channel.invokeMethod(METHOD_CREATE_USER, params);
    callBack(user: result);
  }

  static Future<void> getUser(
      {@required String userId, RoamUserCallBack callBack}) async {
    final Map<String, dynamic> params = <String, dynamic>{'userId': userId};
    final String result = await _channel.invokeMethod(METHOD_GET_USER, params);
    callBack(user: result);
  }

  static Future<void> toggleListener(
      {@required bool events,
      bool locations,
      RoamUserCallBack callBack}) async {
    final Map<String, dynamic> params = <String, dynamic>{
      'events': events,
      'locations': locations
    };
    final String result =
        await _channel.invokeMethod(METHOD_TOGGLE_LISTENER, params);
    callBack(user: result);
  }

  static Future<void> toggleEvents(
      {@required bool location,
      bool geofence,
      bool trips,
      bool movingGeofence,
      RoamUserCallBack callBack}) async {
    final Map<String, dynamic> params = <String, dynamic>{
      'geofence': geofence,
      'location': location,
      'trips': trips,
      'movingGeofence': movingGeofence
    };
    final String result =
        await _channel.invokeMethod(METHOD_TOGGLE_EVENTS, params);
    callBack(user: result);
  }

  static Future<void> getListenerStatus({RoamUserCallBack callBack}) async {
    final String result =
        await _channel.invokeMethod(METHOD_GET_LISTENER_STATUS);
    callBack(user: result);
  }

  static Future<bool> updateCurrentLocation({
    @required int accuracy,
  }) async {
    final Map<String, dynamic> params = <String, dynamic>{'accuracy': accuracy};
    final bool result =
        await _channel.invokeMethod(METHOD_UPDATE_CURRENT_LOCATION, params);
    _channel.setMethodCallHandler(_methodCallHandler);
    return result;
  }

  static Future<void> getCurrentLocation(
      {@required int accuracy, RoamCallBack callBack}) async {
    final Map<String, dynamic> params = <String, dynamic>{'accuracy': accuracy};
    final String result =
        await _channel.invokeMethod(METHOD_GET_CURRENT_LOCATION, params);
    callBack(location: result);
  }

  static Future<bool> startTracking(
      {@required dynamic trackingMode, Map customMethods}) async {
    final Map<String, dynamic> params = <String, dynamic>{
      'trackingMode': trackingMode,
      'customMethods': customMethods
    };
    final bool result =
        await _channel.invokeMethod(METHOD_START_TRACKING, params);
    return result;
  }

  static Future<bool> logoutUser() async {
    final bool result = await _channel.invokeMethod(METHOD_LOGOUT_USER);
    _channel.setMethodCallHandler(_methodCallHandler);
    return result;
  }

  static Future<bool> subscribeLocation() async {
    final bool result = await _channel.invokeMethod(METHOD_SUBSCRIBE_LOCATION);
    _channel.setMethodCallHandler(_methodCallHandler);
    return result;
  }

  static Future<bool> subscribeEvents() async {
    final bool result = await _channel.invokeMethod(METHOD_SUBSCRIBE_EVENTS);
    _channel.setMethodCallHandler(_methodCallHandler);
    return result;
  }

  static Future<bool> subscribeUserLocation({
    @required String userId,
  }) async {
    final Map<String, dynamic> params = <String, dynamic>{'userId': userId};
    final bool result =
        await _channel.invokeMethod(METHOD_SUBSCRIBE_USER_LOCATION, params);
    _channel.setMethodCallHandler(_methodCallHandler);
    return result;
  }

  static Future<bool> stopTracking() async {
    final bool result = await _channel.invokeMethod(METHOD_STOP_TRACKING);
    _channel.setMethodCallHandler(_methodCallHandler);
    return result;
  }

  static Future<bool> enableAccuracyEngine() async {
    final bool result =
        await _channel.invokeMethod(METHOD_ENABLE_ACCURACY_ENGINE);
    _channel.setMethodCallHandler(_methodCallHandler);
    return result;
  }

  static Future<bool> disableAccuracyEngine() async {
    final bool result =
        await _channel.invokeMethod(METHOD_DISABLE_ACCURACY_ENGINE);
    _channel.setMethodCallHandler(_methodCallHandler);
    return result;
  }

  static Future<void> createTrip(
      {@required bool isOffline, RoamTripCallBack callBack}) async {
    final Map<String, dynamic> params = <String, dynamic>{
      'isOffline': isOffline
    };
    final String result =
        await _channel.invokeMethod(METHOD_CREATE_TRIP, params);
    callBack(trip: result);
  }

  static Future<void> getTripDetails(
      {@required String tripId, RoamTripCallBack callBack}) async {
    final Map<String, dynamic> params = <String, dynamic>{'tripId': tripId};
    final String result =
        await _channel.invokeMethod(METHOD_GET_TRIP_DETAILS, params);
    callBack(trip: result);
  }

  static Future<void> getTripStatus(
      {@required String tripId, RoamTripCallBack callBack}) async {
    final Map<String, dynamic> params = <String, dynamic>{'tripId': tripId};
    final String result =
        await _channel.invokeMethod(METHOD_GET_TRIP_STATUS, params);
    callBack(trip: result);
  }

  static Future<void> subscribeTripStatus({
    @required String tripId,
  }) async {
    final Map<String, dynamic> params = <String, dynamic>{'tripId': tripId};
    final bool result =
        await _channel.invokeMethod(METHOD_SUBSCRIBE_TRIP_STATUS, params);
    _channel.setMethodCallHandler(_methodCallHandler);
    return result;
  }

  static Future<void> ubSubscribeTripStatus({
    @required String tripId,
  }) async {
    final Map<String, dynamic> params = <String, dynamic>{'tripId': tripId};
    final bool result =
        await _channel.invokeMethod(METHOD_UNSUBSCRIBE_TRIP_STATUS, params);
    _channel.setMethodCallHandler(_methodCallHandler);
    return result;
  }

  static Future<void> startTrip({
    @required String tripId,
  }) async {
    final Map<String, dynamic> params = <String, dynamic>{'tripId': tripId};
    final bool result = await _channel.invokeMethod(METHOD_START_TRIP, params);
    _channel.setMethodCallHandler(_methodCallHandler);
    return result;
  }

  static Future<void> pauseTrip({
    @required String tripId,
  }) async {
    final Map<String, dynamic> params = <String, dynamic>{'tripId': tripId};
    final bool result = await _channel.invokeMethod(METHOD_PAUSE_TRIP, params);
    _channel.setMethodCallHandler(_methodCallHandler);
    return result;
  }

  static Future<void> resumeTrip({
    @required String tripId,
  }) async {
    final Map<String, dynamic> params = <String, dynamic>{'tripId': tripId};
    final bool result = await _channel.invokeMethod(METHOD_RESUME_TRIP, params);
    _channel.setMethodCallHandler(_methodCallHandler);
    return result;
  }

  static Future<void> endTrip({
    @required String tripId,
  }) async {
    final Map<String, dynamic> params = <String, dynamic>{'tripId': tripId};
    final bool result = await _channel.invokeMethod(METHOD_END_TRIP, params);
    _channel.setMethodCallHandler(_methodCallHandler);
    return result;
  }

  static Future<void> getTripSummary(
      {@required String tripId, RoamTripCallBack callBack}) async {
    final Map<String, dynamic> params = <String, dynamic>{'tripId': tripId};
    final String result =
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

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
