import 'package:roam_flutter/models/Coordinates.dart';

class Routes{

  late Map<String, dynamic>? metadata;
  late String? activity;
  double? speed = 0;
  double? altitude = 0;
  double? distance = 0;
  double? duration = 0;
  double? elevationGain = 0;
  late Coordinates? coordinates;
  late String? recordedAt;
  late String? locationId;


  Map toJson () => {
    'metadata': metadata,
    'activity': activity,
    'speed': speed,
    'altitude': altitude,
    'distance': distance,
    'duration': duration,
    'elevationGain': elevationGain,
    'coordinates': coordinates?.toJson(),
    'recordedAt': recordedAt,
    'locationId': locationId
  };


  Routes({
      this.metadata,
      this.activity,
      this.speed,
      this.altitude,
      this.distance,
      this.duration,
      this.elevationGain,
      this.coordinates,
      this.recordedAt,
      this.locationId});
}