import 'package:roam_flutter/trips_v2/models/Geometry.dart';

class StartLocation{

  late String? id;
  late String? name;
  late String? description;
  late String? address;
  late Map<String, dynamic>? metadata;
  late String? recordedAt;
  late Geometry? geometry;

  StartLocation({required this.id, this.name, this.description, this.address,
      this.metadata, this.recordedAt, required this.geometry});

  Map toJson () => {
    'id': id,
    'name': name,
    'description': description,
    'address': address,
    'metadata': metadata,
    'recordedAt': recordedAt,
    'geometry': geometry?.toJson()
  };
}