import 'package:roam_flutter/trips_v2/models/Events.dart';
import 'package:roam_flutter/trips_v2/models/Stop.dart';
import 'package:roam_flutter/trips_v2/models/User.dart';

class Trips{

  String? id;
  String? tripState;
  double? totalDistance;
  double? totalDuration;
  double? totalElevation_gain;
  Map? metadata;
  User? user;
  String? startedAt;
  String? endedAt;
  String? createdAt;
  String? updatedAt;
  List<Events?>? events = List.empty(growable: true);
  List<Stop?>? stop = List.empty(growable: true);
  String? syncStatus;
  bool? isPaused=false;
  bool? isStarted=false;
  bool? isEnded=false;
  bool? isResumed=false;

  Map toJson () => {
    'id': id,
    'tripState': tripState,
    'totalDistance': totalDistance,
    'totalDuration': totalDuration,
    'totalElevation_gain': totalElevation_gain,
    'metadata': metadata,
    'user': user?.toJson(),
    'startedAt': startedAt,
    'endedAt': endedAt,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    'events': getEventsMapList(events ?? List.empty(growable: true)),
    'stops': getStopList(stop ?? List.empty(growable: true)),
    'syncStatus': syncStatus,
    'isPaused': isPaused,
    'isStarted': isStarted,
    'isEnded': isEnded,
    'isResumed': isResumed
  };


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

}