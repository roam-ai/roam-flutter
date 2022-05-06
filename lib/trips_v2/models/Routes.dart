import 'package:roam_flutter/models/Coordinates.dart';

class Routes{

  late Map? metadata;
  late String? activity;
  var speed = 0;
  var altitude = 0;
  var distance = 0;
  var duration = 0;
  var elevationGain = 0;
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
      required this.speed,
      required this.altitude,
      required this.distance,
      required this.duration,
      required this.elevationGain,
      this.coordinates,
      this.recordedAt,
      this.locationId});
}