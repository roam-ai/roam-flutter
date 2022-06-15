class User{

  late String? name;
  late String? description;
  late Map<String, dynamic>? metadata;
  late String? id;

  User({this.name, this.description, this.metadata, required this.id});

  Map toJson () => {
    'name': name,
    'description': description,
    'metadata': metadata,
    'id': id
  };
}