import 'package:roam_flutter/trips_v2/models/TripDetails.dart';

class RoamTripResponse{

  late var code;
  late String? message;
  late String? description;
  late TripDetails? tripDetails;

  RoamTripResponse({this.code, this.message, this.description, this.tripDetails});

  Map toJson () => {
    'code': code,
    'message': message,
    'description': description,
    'tripDetails': tripDetails?.toJson()
  };
}