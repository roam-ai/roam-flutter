class Events{

  late String? id;
  late String? tripId;
  late String? userId;
  late String? eventType;
  late String? createdAt;
  late String? eventSource;
  late String? eventVersion;
  late String? locationId;

  Events({this.id, this.tripId, this.userId, this.eventType, this.createdAt,
      this.eventSource, this.eventVersion, this.locationId});

  Map toJson () => {
    'id': id,
    'tripId': tripId,
    'userId': userId,
    'eventType': eventType,
    'createdAt': createdAt,
    'eventSource': eventSource,
    'eventVersion': eventVersion,
    'locationId': locationId
  };
}