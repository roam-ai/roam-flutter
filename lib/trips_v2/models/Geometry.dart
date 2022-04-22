class Geometry{

  late String? type;
  List? coordinates = List.empty(growable: true);

  Geometry({required this.type, required this.coordinates});

  Map toJson () => {
    'type': type,
    'coordinates': coordinates
  };
}