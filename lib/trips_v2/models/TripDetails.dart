import 'package:roam_flutter/trips_v2/models/EndLocation.dart';
import 'package:roam_flutter/trips_v2/models/Events.dart';
import 'package:roam_flutter/trips_v2/models/Routes.dart';
import 'package:roam_flutter/trips_v2/models/StartLocation.dart';
import 'package:roam_flutter/trips_v2/models/Stop.dart';
import 'package:roam_flutter/trips_v2/models/User.dart';

class TripDetails{

  late String? id;
  late String? name;
  late String? description;
  late String? tripState;
  late var totalDistance;
  late var totalDuration;
  late var totalElevationGain;
  late Map? metadata;
  late StartLocation? startLocation;
  late EndLocation? endLocation;
  late User? user;
  late String? startedAt;
  late String? endedAt;
  late String? createdAt;
  late String? updatedAt;
  late bool? isLocal;
  bool? hasMore=false;
  List<Stop?> stops = List.empty(growable: true);
  List<Events?> events = List.empty(growable: true);
  List<Routes?> route = List.empty(growable: true);
  Map? routeIndex;



  Map toJson () => {
    'id': id,
    'name': name,
    'description': description,
    'tripState': tripState,
    'totalDistance': totalDistance,
    'totalDuration': totalDuration,
    'totalElevationGain': totalElevationGain,
    'metadata': metadata,
    'startLocation': startLocation?.toJson(),
    'endLocation': endLocation?.toJson(),
    'user': user?.toJson(),
    'startedAt': startedAt,
    'endedAt': endedAt,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    'isLocal': isLocal,
    'hasMore': hasMore,
    'stops': getStopList(stops),
    'events': getEventsMapList(events),
    'route': getRouteList(route),
    'routeIndex': routeIndex
  };

  TripDetails({
      this.id,
      this.name,
      this.description,
      this.tripState,
      this.totalDistance,
      this.totalDuration,
      this.totalElevationGain,
      this.metadata,
      this.startLocation,
      this.endLocation,
      this.user,
      this.startedAt,
      this.endedAt,
      this.createdAt,
      this.updatedAt,
      this.isLocal,
      this.hasMore,
      required this.stops,
      required this.events,
      required this.route,
      this.routeIndex});

  List<Map> getEventsMapList(List<Events?> events){
    List<Map> mapList = List.empty(growable: true);
    events.forEach((element) {
      mapList.add(element?.toJson() ?? Map());
    });
    return mapList;
  }

  List<Map> getStopList(List<Stop?> stops){
    List<Map> mapList = List.empty(growable: true);
    stops.forEach((element) {
      mapList.add(element?.toJson() ?? Map());
    });
    return mapList;
  }

  List<Map> getRouteList(List<Routes?> routesList){
    List<Map> mapList = List.empty(growable: true);
    routesList.forEach((element) {
      mapList.add(element?.toJson() ?? Map());
    });
    return mapList;
  }

}