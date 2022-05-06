import 'package:roam_flutter/trips_v2/models/Trip.dart';
import 'package:roam_flutter/trips_v2/models/Trips.dart';

class RoamActiveTripResponse{

  var code;
  String? message;
  String? description;
  bool? hasMore;
  List<Trips?> trips = List.empty(growable: true);

  RoamActiveTripResponse(
      this.code, this.message, this.description, this.hasMore, this.trips);

  Map toJson () => {
    'code': code,
    'message': message,
    'description': description,
    'hasMore': hasMore,
    'trips': getTripMapList(trips)
  };

  List<Map> getTripMapList(List<Trips?> trips){
    List<Map> mapList = List.empty(growable: true);
    trips.forEach((element) {
      mapList.add(element?.toJson() ?? Map());
    });
    return mapList;
  }

}