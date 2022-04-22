import 'package:roam_flutter/trips_v2/models/Trip.dart';

class RoamDeleteTripResponse{

  String? message;
  String? description;
  int? code;
  Trip? trip;

  RoamDeleteTripResponse(this.message, this.description, this.code, this.trip);

  Map toJson () => {
    'message': message,
    'description': description,
    'code': code,
    'trip': trip?.toJson()
  };
}