import '../RoamTrackingMode.dart';
import '../trips_v2/RoamTrip.dart';
import '../trips_v2/request/RoamTripStops.dart';

class JsonEncoder {
  static Map<String, dynamic> encodeRoamTrip(RoamTrip roamTrip) {
    Map<String, dynamic> json = Map();

    List<Map<String, dynamic>> stops = List.empty(growable: true);
    roamTrip.stop?.forEach((stop) {
      stops.add(JsonEncoder.encodeRoamTripStops(stop));
    });
    if (roamTrip.stop != null) {
      json['stops'] = stops;
    }
    if (roamTrip.tripId != null) {
      json['tripId'] = roamTrip.tripId;
    }
    if (roamTrip.isLocal != null) {
      json['isLocal'] = roamTrip.isLocal;
    }
    if (roamTrip.userId != null) {
      json['userId'] = roamTrip.userId;
    }
    if (roamTrip.metadata != null) {
      json['metadata'] = roamTrip.metadata;
    }
    if (roamTrip.description != null) {
      json['description'] = roamTrip.description;
    }
    if (roamTrip.name != null) {
      json['name'] = roamTrip.name;
    }
    if (roamTrip.tripId != null) {
      json['tripId'] = roamTrip.tripId;
    }

    return json;
  }

  static Map<String, dynamic> encodeRoamTripStops(RoamTripStops stop) {
    Map<String, dynamic> stopMap = Map();
    stopMap['metadata'] = stop.metadata ?? "";
    stopMap['description'] = stop.description ?? "";
    stopMap['name'] = stop.name ?? "";
    stopMap['address'] = stop.address ?? "";
    stopMap['radius'] = stop.geometryRadius ?? "";
    stopMap['geometry'] = stop.geometry ?? "";

    return stopMap;
  }

  static Map<String, dynamic> encodeRoamTrackingMode(RoamTrackingMode roamTrackingMode) {
    Map<String, dynamic> map = Map();

    map['desiredAccuracy'] = roamTrackingMode.desiredAccuracy.value;
    map['distanceFilter'] = roamTrackingMode.distanceFilter;
    map['stopDuration'] = roamTrackingMode.stopDuration;
    map['updateInterval'] = roamTrackingMode.updateInterval;
    map['trackingOptions'] = roamTrackingMode.trackingOptions.value;
    map['activityType'] = roamTrackingMode.activityType.value;
    map['desiredAccuracyIOS'] = roamTrackingMode.desiredAccuracyIOS.value;
    map["allowBackgroundLocationUpdates"] = roamTrackingMode.allowBackgroundLocationUpdates;
    map["pausesLocationUpdatesAutomatically"] = roamTrackingMode.pausesLocationUpdatesAutomatically;
    map["showsBackgroundLocationIndicator"] = roamTrackingMode.showsBackgroundLocationIndicator;
    map["accuracyFilter"] = roamTrackingMode.accuracyFilter;

    return map;
  }
}
