class Errors{

  late String? field;
  late String? message;

  Errors({this.field, this.message});

  Map toJson () => {
    'field': field,
    'message': message
  };
}