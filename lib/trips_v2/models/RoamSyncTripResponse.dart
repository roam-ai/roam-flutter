import 'package:roam_flutter/trips_v2/models/Data.dart';

class RoamSyncTripResponse{

  String? msg;
  String? description;
  int? code;
  Data? data;

  RoamSyncTripResponse(this.msg, this.description, this.code, this.data);

  Map toJson () => {
    'msg': msg,
    'description': description,
    'code': code,
    'data': data?.toJson()
  };
}