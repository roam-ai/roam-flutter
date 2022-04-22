class Coordinates{

  late String? type;
  List? coordinates = List.empty(growable: true);

  Coordinates({this.type, required this.coordinates});

  Map toJson () => {
    'type': type,
    'coordinates': coordinates
  };
}