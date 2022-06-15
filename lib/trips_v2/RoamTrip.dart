import 'package:roam_flutter/trips_v2/request/RoamTripStops.dart';

class RoamTrip{

  Map<String, dynamic>? metadata;
  String? description;
  String? name;
  List<RoamTripStops>? stop;
  bool? isLocal;
  String? tripId;
  String? userId;

  RoamTrip(
    {
      this.isLocal,
      this.metadata,
      this.description,
      this.name,
      this.tripId,
      this.userId,
  }) : stop = [];



}