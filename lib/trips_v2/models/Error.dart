import 'package:roam_flutter/trips_v2/models/Errors.dart';

class Error{

  late var errorCode;
  late String? errorMessage;
  late String? errorDescription;
  late List<Errors> errors = List.empty(growable: true);

  Error({this.errorCode, this.errorMessage, this.errorDescription, required this.errors});
  
  Map toJson () => {
    'errorCode': errorCode,
    'errorMessage': errorMessage,
    'errorDescription': errorDescription,
    'errors': getErrorsMap(errors)
  };

  List<Map> getErrorsMap(List<Errors> errors){
    List<Map> mapList = List.empty(growable: true);
    errors.forEach((element) {
      mapList.add(element.toJson());
    });
    return mapList;
  }

}