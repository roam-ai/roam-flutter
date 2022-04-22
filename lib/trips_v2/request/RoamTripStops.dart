class RoamTripStops{

  String? id = "";
  Map<String, dynamic>? metadata = Map();
  String? description = "";
  String? name = "";
  String? address = "";
  double? geometryRadius = 0;
  List<double>? geometry = List.empty(growable: true);

  RoamTripStops(
      this.geometryRadius,
      this.geometry,
      {
        this.id,
        this.metadata,
        this.description,
        this.name,
        this.address
      });

  Map toJson () => {
    'id': id,
    'metadata': metadata,
    'description': description,
    'name': name,
    'address': address,
    'geometryRadius': geometryRadius,
    'geometry': geometry
  };

}