class Data{
  String? tripID;
  bool? isSynced;

  Data(this.tripID, this.isSynced);

  Map toJson () => {
    'tripID': tripID,
    'isSynced': isSynced
  };
}