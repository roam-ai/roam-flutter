import 'package:roam_flutter/models/Coordinates.dart';

class Routes{

  late var metadata;
  late var activity;
  var speed;
  var altitude;
  var distance;
  var duration;
  var elevationGain;
  late Coordinates? coordinates;
  late var recordedAt;
  late var locationId;


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