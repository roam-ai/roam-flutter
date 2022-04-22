class RoamTrackingMode {

  DesiredAccuracy desiredAccuracy = DesiredAccuracy.HIGH;
  int distanceFilter = 0;
  int stopDuration = 0;
  int updateInterval = 0;
  TrackingOptions _trackingOptions = TrackingOptions.CUSTOM;

  RoamTrackingMode._(
  this._trackingOptions,
  {
    required this.desiredAccuracy,
    required this.distanceFilter,
    required this.stopDuration,
    required this.updateInterval
  }
  );



  RoamTrackingMode.distance(
  this.distanceFilter,
  this.stopDuration,
  {
    required this.desiredAccuracy
  });

  RoamTrackingMode.time(
  this.updateInterval,
  {
    required this.desiredAccuracy
  });


  static final RoamTrackingMode PASSIVE = RoamTrackingMode._(
      TrackingOptions.PASSIVE,
      desiredAccuracy: DesiredAccuracy.HIGH,
      distanceFilter: 0,
      stopDuration: 0,
      updateInterval: 0);

  static final RoamTrackingMode BALANCED = RoamTrackingMode._(
      TrackingOptions.BALANCED,
      desiredAccuracy: DesiredAccuracy.HIGH,
      distanceFilter: 0,
      stopDuration: 0,
      updateInterval: 0);

  static final RoamTrackingMode ACTIVE = RoamTrackingMode._(
      TrackingOptions.ACTIVE,
      desiredAccuracy: DesiredAccuracy.HIGH,
      distanceFilter: 0,
      stopDuration: 0,
      updateInterval: 0);

  TrackingOptions get trackingOptions => _trackingOptions;
}


enum AppState {
  FOREGROUND,
  BACKGROUND,
  ALWAYS_ON
}

enum DesiredAccuracy {
  HIGH,
  MEDIUM,
  LOW
}

extension DesiredAccuracyExtension on DesiredAccuracy{
  String get value{
    switch(this){
      case DesiredAccuracy.HIGH:
        return "HIGH";

      case DesiredAccuracy.MEDIUM:
        return "MEDIUM";

      case DesiredAccuracy.LOW:
        return "LOW";
    }
  }
}

enum Trip {
  START,
  PAUSE,
  RESUME,
  STOP,
  FORCE_STOP
}

enum TrackingOptions {
  PASSIVE,
  BALANCED,
  ACTIVE,
  CUSTOM
}

extension TrackingOptionsExtension on TrackingOptions{
  int get value{
    switch(this){
      case TrackingOptions.PASSIVE:
        return 0;

      case TrackingOptions.BALANCED:
        return 1;

      case TrackingOptions.ACTIVE:
        return 2;

      case TrackingOptions.CUSTOM:
        return 3;
    }
  }
}