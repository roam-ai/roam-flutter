class Trip{
  String? id;
  bool? isDeleted;

  Trip(this.id, this.isDeleted);

  Map toJson () => {
    'id': id,
    'isDeleted': isDeleted
  };
}