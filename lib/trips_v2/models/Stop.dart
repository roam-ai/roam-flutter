import 'package:roam_flutter/trips_v2/models/Geometry.dart';

class Stop{

  late String? id;
  late String? name;
  late String? description;
  late String? address;
  late Map<String, dynamic>? metadata;
  late double? geometryRadius;
  late String? createdAt;
  late String? updatedAt;
  late String? arrivedAt;
  late String? departedAt;
  late Geometry? geometry;

  Stop({
      required this.id,
      this.name,
      this.description,
      this.address,
      this.metadata,
      required this.geometryRadius,
      this.createdAt,
      this.updatedAt,
      this.arrivedAt,
      this.departedAt,
      required this.geometry});

  Map toJson () => {
    'id': id,
    'name': name,
    'description': description,
    'address': address,
    'metadata': metadata,
    'geometryRadius': geometryRadius,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    'arrivedAt': arrivedAt,
    'departedAt': departedAt,
    'geometry': geometry?.toJson()
  };
}