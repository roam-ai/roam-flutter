import Flutter
import UIKit
import GeoSpark
import CoreLocation


public class SwiftRoamFlutterPlugin: NSObject, FlutterPlugin, GeoSparkDelegate {
    private static let METHOD_INITIALIZE = "initialize";
    private static let METHOD_GET_CURRENT_LOCATION = "getCurrentLocation";
    private static let METHOD_CREATE_USER = "createUser";
    private static let METHOD_UPDATE_CURRENT_LOCATION = "updateCurrentLocation";
    private static let METHOD_START_TRACKING = "startTracking";
    private static let METHOD_STOP_TRACKING = "stopTracking";
    private static let METHOD_LOGOUT_USER = "logoutUser";
    private static let METHOD_GET_USER = "getUser";
    private static let METHOD_TOGGLE_LISTENER = "toggleListener";
    private static let METHOD_GET_LISTENER_STATUS = "getListenerStatus";
    private static let METHOD_TOGGLE_EVENTS = "toggleEvents";
    private static let METHOD_SUBSCRIBE_LOCATION = "subscribeLocation";
    private static let METHOD_SUBSCRIBE_USER_LOCATION = "subscribeUserLocation";
    private static let METHOD_SUBSCRIBE_EVENTS = "subscribeEvents";
    private static let METHOD_ENABLE_ACCURACY_ENGINE = "enableAccuracyEngine";
    private static let METHOD_DISABLE_ACCURACY_ENGINE = "disableAccuracyEngine";
    private static let METHOD_CREATE_TRIP = "createTrip";
    private static let METHOD_GET_TRIP_DETAILS = "getTripDetails";
    private static let METHOD_GET_TRIP_STATUS = "getTripStatus";
    private static let METHOD_SUBSCRIBE_TRIP_STATUS = "subscribeTripStatus";
    private static let METHOD_UNSUBSCRIBE_TRIP_STATUS = "unSubscribeTripStatus";
    private static let METHOD_START_TRIP = "startTrip";
    private static let METHOD_PAUSE_TRIP = "pauseTrip";
    private static let METHOD_RESUME_TRIP = "resumeTrip";
    private static let METHOD_END_TRIP = "endTrip";
    private static let METHOD_GET_TRIP_SUMMARY = "getTripSummary";

    private static let TRACKING_MODE_PASSIVE = "passive";
    private static let TRACKING_MODE_REACTIVE = "reactive";
    private static let TRACKING_MODE_ACTIVE = "active";
    private static let TRACKING_MODE_CUSTOM = "custom";

    private static let ACTIVITY_TYPE_FITNESS = "fitness";

    private static var channel: FlutterMethodChannel?;

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "roam_flutter", binaryMessenger: registrar.messenger())
        let instance = SwiftRoamFlutterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        registrar.addApplicationDelegate(instance)
    }

    public func didUpdateLocation(_ geospark: GeoSparkLocation) {
        debugPrint("Location Received SDK")
    }

    public func applicationDidBecomeActive(_ application: UIApplication) {
        debugPrint("applicationDidBecomeActive")
    }

    public func applicationWillTerminate(_ application: UIApplication) {
        debugPrint("applicationWillTerminate")
    }

    public func applicationWillResignActive(_ application: UIApplication) {
        debugPrint("applicationWillResignActive")
    }

    public func applicationDidEnterBackground(_ application: UIApplication) {
        debugPrint("applicationDidEnterBackground")
    }

    public func applicationWillEnterForeground(_ application: UIApplication) {
        print("applicationWillEnterForeground")
    }

    private func getActivityType(_ type:String) -> CLActivityType
    {
        if type == "fitness"{
            return .fitness
        }else if type == "airborne"{
            if #available(iOS 12.0, *) {
                return .airborne
            } else {
                return .other
            }
        }
        else if type == "automotiveNavigation"{
            return .automotiveNavigation
        }
        else if type == "other"{
            return .other
        }
        else if type == "otherNavigation"{
            return .otherNavigation
        }
        else {
            return .other
        }
    }

    private func getDesiredAccuracy(_ type:String) -> LocationAccuracy
    {
        if type == "best"{
            return .kCLLocationAccuracyBest
        }
        else if type == "bestForNavigation"{
            return .kCLLocationAccuracyBestForNavigation
        }
        else if type == "hundredMetres"{
            return .kCLLocationAccuracyHundredMeters
        }
        else if type == "kilometers"{
            return .kCLLocationAccuracyKilometer
        }
        else if type == "nearestTenMeters"{
            return .kCLLocationAccuracyNearestTenMeters
        }
        else if type == "threeKilometers"{
            return .kCLLocationAccuracyThreeKilometers
        }
        else {
            return .kCLLocationAccuracyHundredMeters
        }
    }


    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch (call.method) {
        case SwiftRoamFlutterPlugin.METHOD_INITIALIZE:
            let arguments = call.arguments as! [String: Any]
            let publishKey = arguments["publishKey"]  as! String;
            GeoSpark.initialize(publishKey)
        case SwiftRoamFlutterPlugin.METHOD_CREATE_USER:
            let arguments = call.arguments as! [String: Any]
            let description = arguments["description"]  as! String;
            GeoSpark.createUser(description) {(roamUser, error) in
                let user: NSDictionary = [
                    "userId": roamUser?.userId as Any,
                    "description":roamUser?.userDescription as Any
                ]
                if let theJSONData = try? JSONSerialization.data(
                    withJSONObject: user,
                    options: []) {
                    let theJSONText = String(data: theJSONData,encoding: .ascii)
                    result(theJSONText)
                }
            }
        case SwiftRoamFlutterPlugin.METHOD_TOGGLE_LISTENER:
            let arguments = call.arguments as! [String: Any]
            let Events = arguments["events"]  as! Bool;
            let Locations = arguments["locations"]  as! Bool;
            GeoSpark.toggleListener(Events: Events, Locations: Locations) {(roamUser, error) in
                let user: NSDictionary = [
                    "locationListener": roamUser?.locationListener,
                    "eventsListener":roamUser?.eventsListener
                ]
                if let theJSONData = try? JSONSerialization.data(
                    withJSONObject: user,
                    options: []) {
                    let theJSONText = String(data: theJSONData,encoding: .ascii)
                    result(theJSONText)
                }
            }
        case SwiftRoamFlutterPlugin.METHOD_TOGGLE_EVENTS:
            let arguments = call.arguments as! [String: Any]
            let Geofence = arguments["geofence"]  as! Bool;
            let Location = arguments["location"]  as! Bool;
            let Trips = arguments["trips"]  as! Bool;
            let MovingGeofence = arguments["movingGeofence"]  as! Bool;
            GeoSpark.toggleEvents(Geofence: Geofence, Trip: Trips, Location: Location, MovingGeofence: MovingGeofence) {(roamUser, error) in
                let user: NSDictionary = [
                    "locationEvents": roamUser?.locationEvents,
                    "geofenceEvents":roamUser?.geofenceEvents,
                    "tripsEvents":roamUser?.tripsEvents,
                    "movingGeofenceEvents":roamUser?.nearbyEvents,
                ]
                if let theJSONData = try? JSONSerialization.data(
                    withJSONObject: user,
                    options: []) {
                    let theJSONText = String(data: theJSONData,encoding: .ascii)
                    result(theJSONText)
                }
            }
        case SwiftRoamFlutterPlugin.METHOD_GET_LISTENER_STATUS:
            GeoSpark.getListenerStatus() {(roamUser, error) in
                let user: NSDictionary = [
                    "locationListener": roamUser?.locationListener,
                    "eventsListener":roamUser?.eventsListener
                ]
                if let theJSONData = try? JSONSerialization.data(
                    withJSONObject: user,
                    options: []) {
                    let theJSONText = String(data: theJSONData,encoding: .ascii)
                    result(theJSONText)
                }
            }
        case SwiftRoamFlutterPlugin.METHOD_GET_USER:
            let arguments = call.arguments as! [String: Any]
            let userId = arguments["userId"]  as! String;
            GeoSpark.getUser(userId) {(roamUser, error) in
                let user: NSDictionary = [
                    "userId": roamUser?.userId as Any,
                    "description":roamUser?.userDescription as Any
                ]
                if let theJSONData = try? JSONSerialization.data(
                    withJSONObject: user,
                    options: []) {
                    let theJSONText = String(data: theJSONData,encoding: .ascii)
                    result(theJSONText)
                }
            }
        case SwiftRoamFlutterPlugin.METHOD_UPDATE_CURRENT_LOCATION:
            let arguments = call.arguments as! [String: Any]
            let accuracy = arguments["accuracy"]  as! Int;
            GeoSpark.updateCurrentLocation(accuracy)
        case SwiftRoamFlutterPlugin.METHOD_GET_CURRENT_LOCATION:
            let arguments = call.arguments as! [String: Any]
            let accuracy = arguments["accuracy"]  as! Int;
            GeoSpark.getCurrentLocation(accuracy) { (location, error) in
                if  error == nil{
                    let coordinates: NSDictionary = [
                        "latitude": location?.coordinate.latitude as Any,
                        "longitude": location?.coordinate.longitude as Any
                    ]
                    let location: NSDictionary = [
                        "coordinate": coordinates,
                        "altitude":location?.altitude as Any,
                        "horizontalAccuracy":location?.horizontalAccuracy as Any,
                        "verticalAccuracy":location?.verticalAccuracy as Any,
//                        "timestamp":location!.timestamp as Date
                    ]
                    if let theJSONData = try? JSONSerialization.data(
                        withJSONObject: location,
                        options: []) {
                        let theJSONText = String(data: theJSONData,encoding: .ascii)
                        result(theJSONText)
                    }
                }
                else {
                    let error: NSDictionary = [
                        "code": error?.code as Any,
                        "message": error?.message as Any
                    ]
                    if let theJSONData = try? JSONSerialization.data(
                        withJSONObject: error,
                        options: []) {
                        let theJSONText = String(data: theJSONData,encoding: .ascii)
                        result(theJSONText)
                    }

                }
            }
        case SwiftRoamFlutterPlugin.METHOD_START_TRACKING:
            let arguments = call.arguments as! [String: Any]
            let trackingMode = arguments["trackingMode"]  as? String;
            let customMethods = arguments["customMethods"]  as? NSDictionary;
            var options = GeoSparkTrackingMode.active
            // guard let localtrackingMode = trackingMode else {
            //   GeoSpark.startTracking(trackingMode as GeoSparkTrackingMode);
            //   result(true);
            //   return;
            //   }
            switch (trackingMode!) {
            case SwiftRoamFlutterPlugin.TRACKING_MODE_PASSIVE:
                options = GeoSparkTrackingMode.passive
                GeoSpark.publishSave()
                GeoSpark.startTracking(options)
            case SwiftRoamFlutterPlugin.TRACKING_MODE_REACTIVE:
                options = GeoSparkTrackingMode.balanced
                GeoSpark.publishSave()
                GeoSpark.startTracking(options)
            case SwiftRoamFlutterPlugin.TRACKING_MODE_ACTIVE:
                options = GeoSparkTrackingMode.active
                GeoSpark.publishSave()
                GeoSpark.startTracking(options)
            case SwiftRoamFlutterPlugin.TRACKING_MODE_CUSTOM:
                let options = GeoSparkTrackingCustomMethods.init()
                options.activityType = self.getActivityType(((customMethods?["activityType"] as? String ?? "otherNavigation")))
                options.desiredAccuracy = self.getDesiredAccuracy(((customMethods?["desiredAccuracy"] as? String)!))
                options.allowBackgroundLocationUpdates = customMethods?["allowBackgroundLocationUpdates"] as? Bool
                options.pausesLocationUpdatesAutomatically = customMethods?["pausesLocationUpdatesAutomatically"] as? Bool
                options.showsBackgroundLocationIndicator = customMethods?["showsBackgroundLocationIndicator"] as? Bool
                options.accuracyFilter = customMethods?["accuracyFilter"] as? Int
                options.distanceFilter = customMethods?["distanceFilter"] as? CLLocationDistance
                options.updateInterval = customMethods?["timeInterval"] as? Int
                GeoSpark.startTracking(.custom, options: options)
                GeoSpark.publishSave()
            default:
                options = GeoSparkTrackingMode.active
                GeoSpark.publishSave()
                GeoSpark.startTracking(options)
            }
            result(true);
        case SwiftRoamFlutterPlugin.METHOD_STOP_TRACKING:
            GeoSpark.stopTracking()
        case SwiftRoamFlutterPlugin.METHOD_LOGOUT_USER:
            GeoSpark.logoutUser()
        case SwiftRoamFlutterPlugin.METHOD_SUBSCRIBE_LOCATION:
            GeoSpark.getListenerStatus() {(roamUser, error) in
                let userId = roamUser?.userId
                GeoSpark.subscribe(GeoSparkSubscribe.Location, userId!)
            }
        case SwiftRoamFlutterPlugin.METHOD_SUBSCRIBE_EVENTS:
            GeoSpark.getListenerStatus() {(roamUser, error) in
                let userId = roamUser?.userId
                GeoSpark.subscribe(GeoSparkSubscribe.Events, userId!)
            }
        case SwiftRoamFlutterPlugin.METHOD_ENABLE_ACCURACY_ENGINE:
            GeoSpark.enableAccuracyEngine()
        case SwiftRoamFlutterPlugin.METHOD_DISABLE_ACCURACY_ENGINE:
            GeoSpark.disableAccuracyEngine()
        case SwiftRoamFlutterPlugin.METHOD_SUBSCRIBE_USER_LOCATION:
            let arguments = call.arguments as! [String: Any]
            let userId = arguments["userId"]  as! String;
            GeoSpark.subscribe(GeoSparkSubscribe.Location, userId)
        case SwiftRoamFlutterPlugin.METHOD_CREATE_TRIP:
            let arguments = call.arguments as! [String: Any]
            let isOffline = arguments["isOffline"]  as! Bool;
            GeoSpark.createTrip(isOffline, nil) {(roamTrip, error) in
                let trip: NSDictionary = [
                    "userId": roamTrip?.userId as Any,
                    "tripId": roamTrip?.tripId as Any
                ]
                if let theJSONData = try? JSONSerialization.data(
                    withJSONObject: trip,
                    options: []) {
                    let theJSONText = String(data: theJSONData,encoding: .ascii)
                    result(theJSONText)
                }
            }
        case SwiftRoamFlutterPlugin.METHOD_GET_TRIP_DETAILS:
            let arguments = call.arguments as! [String: Any]
            let tripId = arguments["tripId"]  as! String;
            GeoSpark.getTripDetails(tripId) {(roamTrip, error) in
                let trip: NSDictionary = [
                    "userId": roamTrip?.userId as Any,
                    "tripId": roamTrip?.tripId as Any
                ]
                if let theJSONData = try? JSONSerialization.data(
                    withJSONObject: trip,
                    options: []) {
                    let theJSONText = String(data: theJSONData,encoding: .ascii)
                    result(theJSONText)
                }
            }
        case SwiftRoamFlutterPlugin.METHOD_GET_TRIP_STATUS:
            let arguments = call.arguments as! [String: Any]
            let tripId = arguments["tripId"]  as! String;
            GeoSpark.getTripStatus(tripId) {(roamTrip, error) in
                let trip: NSDictionary = [
                    "distance": roamTrip?.distance as Any,
                    "speed": roamTrip?.speed as Any,
                    "duration": roamTrip?.duration as Any,
                    "tripId": roamTrip?.tripId as Any
                ]
                if let theJSONData = try? JSONSerialization.data(
                    withJSONObject: trip,
                    options: []) {
                    let theJSONText = String(data: theJSONData,encoding: .ascii)
                    result(theJSONText)
                }
            }
        case SwiftRoamFlutterPlugin.METHOD_SUBSCRIBE_TRIP_STATUS:
            let arguments = call.arguments as! [String: Any]
            let tripId = arguments["tripId"]  as! String;
            GeoSpark.subscribeTripStatus(tripId)
        case SwiftRoamFlutterPlugin.METHOD_UNSUBSCRIBE_TRIP_STATUS:
            let arguments = call.arguments as! [String: Any]
            let tripId = arguments["tripId"]  as! String;
            GeoSpark.unsubscribeTripStatus(tripId)
        case SwiftRoamFlutterPlugin.METHOD_START_TRIP:
            let arguments = call.arguments as! [String: Any]
            let tripId = arguments["tripId"]  as! String;
            GeoSpark.startTrip(tripId)
        case SwiftRoamFlutterPlugin.METHOD_PAUSE_TRIP:
            let arguments = call.arguments as! [String: Any]
            let tripId = arguments["tripId"]  as! String;
            GeoSpark.pauseTrip(tripId)
        case SwiftRoamFlutterPlugin.METHOD_RESUME_TRIP:
            let arguments = call.arguments as! [String: Any]
            let tripId = arguments["tripId"]  as! String;
            GeoSpark.resumeTrip(tripId)
        case SwiftRoamFlutterPlugin.METHOD_END_TRIP:
            let arguments = call.arguments as! [String: Any]
            let tripId = arguments["tripId"]  as! String;
            GeoSpark.stopTrip(tripId)
        case SwiftRoamFlutterPlugin.METHOD_GET_TRIP_SUMMARY:
            let arguments = call.arguments as! [String: Any]
            let tripId = arguments["tripId"]  as! String;
            GeoSpark.getTripSummary(tripId) {(roamTrip, error) in

                roamTrip?.route.forEach({ (route) in
                    let coordinates: NSDictionary = [
                        "latitude": route.coordinates[0],
                        "longitude": route.coordinates[1]
                    ]
                    let route: NSDictionary = [
                        "activity": route.activity!,
                        "altitude":route.altitude!,
                        "recordedAt": route.recordedAt!,
                        "coordinates": coordinates
                    ]
                    let trip: NSDictionary = [
                        "distance": roamTrip?.distanceCovered as Any,
                        "duration": roamTrip?.duration as Any,
                        "tripId": roamTrip?.tripId as Any,
                        "route": route
                    ]
                    if let theJSONData = try? JSONSerialization.data(
                        withJSONObject: trip,
                        options: []) {
                        let theJSONText = String(data: theJSONData,encoding: .ascii)
                        result(theJSONText)
                    }
                })
            }
        default:
            result("iOS " + UIDevice.current.systemVersion)
        }
    }
}
