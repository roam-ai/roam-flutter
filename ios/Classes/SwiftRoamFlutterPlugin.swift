import Flutter
import UIKit
import Roam
import CoreLocation


public class SwiftRoamFlutterPlugin: NSObject, FlutterPlugin, RoamDelegate {
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [AnyHashable : Any] = [:]) -> Bool {
        Roam.delegate = self
        return true
    }
    
    
    
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
    private static let METHOD_UPDATE_TRIP = "updateTrip";
    private static let METHOD_GET_TRIP_DETAILS = "getTripDetails";
    private static let METHOD_GET_TRIP_STATUS = "getTripStatus";
    private static let METHOD_SUBSCRIBE_TRIP_STATUS = "subscribeTripStatus";
    private static let METHOD_UNSUBSCRIBE_TRIP_STATUS = "unSubscribeTripStatus";
    private static let METHOD_START_TRIP = "startTrip";
    private static let METHOD_START_QUICK_TRIP = "startQuickTrip";
    private static let METHOD_PAUSE_TRIP = "pauseTrip";
    private static let METHOD_RESUME_TRIP = "resumeTrip";
    private static let METHOD_END_TRIP = "endTrip";
    private static let METHOD_DELETE_TRIP = "deleteTrip";
    private static let METHOD_GET_ACTIVE_TRIPS = "getActiveTrips";
    private static let METHOD_GET_TRIP = "getTrip";
    private static let METHOD_GET_TRIP_SUMMARY = "getTripSummary";
    private static let METHOD_SYNC_TRIP = "syncTrip";
    private static let METHOD_SUBSCRIBE_TRIP = "subscribeTrip";
    private static let METHOD_UNSUBSCRIBE_TRIP = "unsubscribeTrip";
    
    private static let METHOD_OFFLINE_TRACKING = "offlineTracking";

    private static let TRACKING_MODE_PASSIVE = "passive";
    private static let TRACKING_MODE_BALANCED = "balanced";
    private static let TRACKING_MODE_ACTIVE = "active";
    private static let TRACKING_MODE_CUSTOM = "custom";

    private static let ACTIVITY_TYPE_FITNESS = "fitness";

    private static var channel: FlutterMethodChannel?;
    private static var locationEventChannel: FlutterEventChannel?;
     static var eventSink: FlutterEventSink?;

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "roam_flutter", binaryMessenger: registrar.messenger())
        let instance = SwiftRoamFlutterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        registrar.addApplicationDelegate(instance)
        let locationEventChannel = FlutterEventChannel(name: "roam_flutter_event/location", binaryMessenger: registrar.messenger())
        locationEventChannel.setStreamHandler(EventStreamHandler())
        
    }
    
    class EventStreamHandler: NSObject, FlutterStreamHandler{
        func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
            SwiftRoamFlutterPlugin.eventSink = events
            return nil;
        }
        
        func onCancel(withArguments arguments: Any?) -> FlutterError? {
            return nil;
        }
    }

    

    public func didUpdateLocation(_ roam: RoamLocation) {
        debugPrint("Location Received SDK")
        let location: NSDictionary = [
            "latitude": roam.location.coordinate.latitude,
            "longitude": roam.location.coordinate.longitude,
            "accuracy": roam.location.horizontalAccuracy,
            "altitude": roam.location.altitude,
            "speed": roam.location.speed,
            "bearing": roam.location.course,
            "userId": roam.userId as Any,
            "activity": roam.activity as Any,
            "recordedAt": roam.recordedAt as Any,
            "timezoneOffset": roam.timezoneOffset as Any,
            "metadata": roam.metaData as Any,
            "batteryStatus": roam.batteryRemaining,
            "networkStatus": roam.networkStatus
        ]
        if(SwiftRoamFlutterPlugin.eventSink != nil){
            SwiftRoamFlutterPlugin.eventSink!(location)
        }
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
            Roam.initialize(publishKey)
        case SwiftRoamFlutterPlugin.METHOD_CREATE_USER:
            let arguments = call.arguments as! [String: Any]
            let description = arguments["description"]  as! String;
            Roam.createUser(description) {(roamUser, error) in
                let user: NSDictionary = [
                    "userId": roamUser?.userId as Any,
                    "description":roamUser?.userDescription as Any
                ]
                if let theJSONData = try? JSONSerialization.data(
                    withJSONObject: user,
                    options: []) {
                    let theJSONText = String(data: theJSONData,encoding: .ascii)
                    print(theJSONText)
                    result(theJSONText)
                }
            }
        case SwiftRoamFlutterPlugin.METHOD_TOGGLE_LISTENER:
            let arguments = call.arguments as! [String: Any]
            let Events = arguments["events"]  as! Bool;
            let Locations = arguments["locations"]  as! Bool;
            Roam.toggleListener(Events: Events, Locations: Locations) {(roamUser, error) in
                let user: NSDictionary = [
                    "locationListener": roamUser?.locationListener as Any,
                    "eventsListener":roamUser?.eventsListener as Any
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
            Roam.toggleEvents(Geofence: Geofence, Trip: Trips, Location: Location, MovingGeofence: MovingGeofence) {(roamUser, error) in
                let user: NSDictionary = [
                    "locationEvents": roamUser?.locationEvents as Any,
                    "geofenceEvents":roamUser?.geofenceEvents as Any,
                    "tripsEvents":roamUser?.tripsEvents as Any,
                    "movingGeofenceEvents":roamUser?.nearbyEvents as Any,
                ]
                if let theJSONData = try? JSONSerialization.data(
                    withJSONObject: user,
                    options: []) {
                    let theJSONText = String(data: theJSONData,encoding: .ascii)
                    result(theJSONText)
                }
            }
        case SwiftRoamFlutterPlugin.METHOD_GET_LISTENER_STATUS:
            Roam.getListenerStatus() {(roamUser, error) in
                let user: NSDictionary = [
                    "locationListener": roamUser?.locationListener as Any,
                    "eventsListener":roamUser?.eventsListener as Any
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
            Roam.getUser(userId) {(roamUser, error) in
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
            Roam.updateCurrentLocation(accuracy)
        case SwiftRoamFlutterPlugin.METHOD_GET_CURRENT_LOCATION:
            let arguments = call.arguments as! [String: Any]
            let accuracy = arguments["accuracy"]  as! Int;
            Roam.getCurrentLocation(accuracy) { (location, error) in
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
            var options = RoamTrackingMode.active
            // guard let localtrackingMode = trackingMode else {
            //   GeoSpark.startTracking(trackingMode as GeoSparkTrackingMode);
            //   result(true);
            //   return;
            //   }
            switch (trackingMode!) {
            case SwiftRoamFlutterPlugin.TRACKING_MODE_PASSIVE:
                options = RoamTrackingMode.passive
                Roam.publishSave()
                Roam.startTracking(options)
            case SwiftRoamFlutterPlugin.TRACKING_MODE_BALANCED:
                options = RoamTrackingMode.balanced
                Roam.publishSave()
                Roam.startTracking(options)
            case SwiftRoamFlutterPlugin.TRACKING_MODE_ACTIVE:
                options = RoamTrackingMode.active
                Roam.publishSave()
                Roam.startTracking(options)
            case SwiftRoamFlutterPlugin.TRACKING_MODE_CUSTOM:
                let options = RoamTrackingCustomMethods.init()
                options.activityType = self.getActivityType(((customMethods?["activityType"] as? String ?? "otherNavigation")))
                options.desiredAccuracy = self.getDesiredAccuracy(((customMethods?["desiredAccuracy"] as? String)!))
                options.allowBackgroundLocationUpdates = customMethods?["allowBackgroundLocationUpdates"] as? Bool
                options.pausesLocationUpdatesAutomatically = customMethods?["pausesLocationUpdatesAutomatically"] as? Bool
                options.showsBackgroundLocationIndicator = customMethods?["showsBackgroundLocationIndicator"] as? Bool
                options.accuracyFilter = customMethods?["accuracyFilter"] as? Int
                options.distanceFilter = customMethods?["distanceFilter"] as? CLLocationDistance
                options.updateInterval = customMethods?["timeInterval"] as? Int
                Roam.startTracking(.custom, options: options)
                Roam.publishSave()
            default:
                options = RoamTrackingMode.active
                Roam.publishSave()
                Roam.startTracking(options)
            }
            result(true);
        case SwiftRoamFlutterPlugin.METHOD_STOP_TRACKING:
            Roam.stopTracking()
        case SwiftRoamFlutterPlugin.METHOD_LOGOUT_USER:
            Roam.logoutUser()
        case SwiftRoamFlutterPlugin.METHOD_SUBSCRIBE_LOCATION:
            Roam.getListenerStatus() {(roamUser, error) in
                let userId = roamUser?.userId
                Roam.subscribe(RoamSubscribe.Location, userId!)
            }
        case SwiftRoamFlutterPlugin.METHOD_SUBSCRIBE_EVENTS:
            Roam.getListenerStatus() {(roamUser, error) in
                let userId = roamUser?.userId
                Roam.subscribe(RoamSubscribe.Events, userId!)
            }
        case SwiftRoamFlutterPlugin.METHOD_ENABLE_ACCURACY_ENGINE:
            Roam.enableAccuracyEngine()
        case SwiftRoamFlutterPlugin.METHOD_DISABLE_ACCURACY_ENGINE:
            Roam.disableAccuracyEngine()
        case SwiftRoamFlutterPlugin.METHOD_SUBSCRIBE_USER_LOCATION:
            let arguments = call.arguments as! [String: Any]
            let userId = arguments["userId"]  as! String;
            Roam.subscribe(RoamSubscribe.Location, userId)
            
        case SwiftRoamFlutterPlugin.METHOD_CREATE_TRIP:
            let arguments = call.arguments as! [String: Any]
            let roamTripString = arguments["roamTrip"]  as! String;
            if let data = roamTripString.data(using: String.Encoding.utf8){
                do{
                    let roamTripDictionary = try JSONSerialization.jsonObject(with: data, options: [])
                    print(roamTripDictionary)
                    let roamTrip = SwiftRoamFlutterPlugin.decodeRoamTrip(tripDictionary: roamTripDictionary as! [String: Any])
                    print(roamTrip)
                    Roam.createTrip(roamTrip){response, error in
                        do{
                            print(response)
                            print(error)
                            if(response != nil){
                                let jsonResponse = try JSONSerialization.data(withJSONObject: SwiftRoamFlutterPlugin.encodeRoamTripResponse(response: response!), options: [])
                                let jsonString = String(data: jsonResponse, encoding: .ascii)
                                result(jsonString)
                            } else {
                                var errorDictionary = [String: Any]()
                                errorDictionary["error"] = SwiftRoamFlutterPlugin.encodeRoamTripError(error:error!)
                                let jsonError = try JSONSerialization.data(withJSONObject: errorDictionary, options: [])
                                let jsonString = String(data: jsonError, encoding: .ascii)
                                result(jsonString)
                            }
                        } catch let error{
                            print(error)
                        }
                    }
                } catch let error{
                    print(error)
                }
            }
            
            
        case SwiftRoamFlutterPlugin.METHOD_OFFLINE_TRACKING:
            let arguments = call.arguments as! [String: Any]
            let offlineTracking = arguments["offlineTracking"] as! Bool
            Roam.offlineLocationTracking(offlineTracking)
            
            
        case SwiftRoamFlutterPlugin.METHOD_UPDATE_TRIP:
            let arguments = call.arguments as! [String: Any]
            let roamTripString = arguments["roamTrip"]  as! String;
            if let data = roamTripString.data(using: String.Encoding.utf8){
                do{
                    let roamTripDictionary = (try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any])!
                    let roamTrip = SwiftRoamFlutterPlugin.decodeRoamTrip(tripDictionary: roamTripDictionary)
                    Roam.updateTrip(roamTrip){response, error in
                        do{
                            if(response != nil){
                                let jsonResponse = try JSONSerialization.data(withJSONObject: SwiftRoamFlutterPlugin.encodeRoamTripResponse(response: response!), options: [])
                                let jsonString = String(data: jsonResponse, encoding: .ascii)
                                result(jsonString)
                            } else {
                                var errorDictionary = [String: Any]()
                                errorDictionary["error"] = SwiftRoamFlutterPlugin.encodeRoamTripError(error:error!)
                                let jsonError = try JSONSerialization.data(withJSONObject: errorDictionary, options: [])
                                let jsonString = String(data: jsonError, encoding: .ascii)
                                result(jsonString)
                            }
                        } catch let error{
                            print(error)
                        }
                    }
                } catch let error{
                    print(error)
                }
            }
            
        case SwiftRoamFlutterPlugin.METHOD_GET_TRIP_DETAILS:
            let arguments = call.arguments as! [String: Any]
            let tripId = arguments["tripId"]  as! String

//            Roam.getTripDetails(tripId) {(roamTrip, error) in
//                let trip: NSDictionary = [
//                    "userId": roamTrip?.userId as Any,
//                    "tripId": roamTrip?.tripId as Any
//                ]
//                if let theJSONData = try? JSONSerialization.data(
//                    withJSONObject: trip,
//                    options: []) {
//                    let theJSONText = String(data: theJSONData,encoding: .ascii)
//                    result(theJSONText)
//                }
//            }
        case SwiftRoamFlutterPlugin.METHOD_GET_TRIP_STATUS:
            let arguments = call.arguments as! [String: Any]
            let tripId = arguments["tripId"]  as! String;
            Roam.getTripStatus(tripId) {(roamTrip, error) in
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
            //Roam.subscribeTripStatus(tripId)
        case SwiftRoamFlutterPlugin.METHOD_UNSUBSCRIBE_TRIP_STATUS:
            let arguments = call.arguments as! [String: Any]
            let tripId = arguments["tripId"]  as! String;
            //Roam.unsubscribeTripStatus(tripId)
            
        case SwiftRoamFlutterPlugin.METHOD_START_TRIP:
            let arguments = call.arguments as! [String: Any]
            let tripId = arguments["tripId"]  as! String;
            print(tripId)
            Roam.startTrip(tripId){response, error in
                do{
                    if(response != nil){
                        let jsonResponse = try JSONSerialization.data(withJSONObject: SwiftRoamFlutterPlugin.encodeRoamTripResponse(response: response!), options: [])
                        let jsonString = String(data: jsonResponse, encoding: .ascii)
                        result(jsonString)
                    } else {
                        var errorDictionary = [String: Any]()
                        errorDictionary["error"] = SwiftRoamFlutterPlugin.encodeRoamTripError(error:error!)
                        let jsonError = try JSONSerialization.data(withJSONObject: errorDictionary, options: [])
                        let jsonString = String(data: jsonError, encoding: .ascii)
                        result(jsonString)
                    }
                } catch let error{
                    print(error)
                }
            }
            
        case SwiftRoamFlutterPlugin.METHOD_START_QUICK_TRIP:
            let arguments = call.arguments as! [String: Any]
            let roamTripString = arguments["roamTrip"]  as! String;
            let roamTrackingModeString = arguments["roamTrackingMode"] as! String
            if let roamTripData = roamTripString.data(using: String.Encoding.utf8){
                do{
                    var roamTripDictionary = try JSONSerialization.jsonObject(with: roamTripData, options: []) as! [String: Any]
                    let roamTrip = SwiftRoamFlutterPlugin.decodeRoamTrip(tripDictionary: roamTripDictionary)
                    if let roamTrackingModeData = roamTrackingModeString.data(using: String.Encoding.utf8){
                        var roamTrackingModeDictionary = try JSONSerialization.jsonObject(with: roamTrackingModeData, options: []) as! [String: Any]
                        var roamTrackingMode = RoamTrackingMode.active
                        let trackingModeInput = roamTrackingModeDictionary["trackingOptions"] as! NSNumber
                        switch(trackingModeInput){
                        case 0:
                            roamTrackingMode = RoamTrackingMode.passive
                        case 1:
                            roamTrackingMode = RoamTrackingMode.balanced
                        case 2:
                            roamTrackingMode = RoamTrackingMode.active
                        case 3:
                            roamTrackingMode = RoamTrackingMode.custom
                        default:
                            roamTrackingMode = RoamTrackingMode.active
                        }
                        var customTrackingOptions = RoamTrackingCustomMethods()
                        if(roamTrackingMode == RoamTrackingMode.custom){
                            customTrackingOptions = SwiftRoamFlutterPlugin.decodeRoamTrackingCustomMethods(trackingModeDisctionary: roamTrackingModeDictionary)
                        }
                        Roam.startTrip(roamTrip, roamTrackingMode, customTrackingOptions){response, error in
                            print(response)
                            print(error)
                            do{
                                if(response != nil){
                                    let jsonResponse = try JSONSerialization.data(withJSONObject: SwiftRoamFlutterPlugin.encodeRoamTripResponse(response: response!), options: [])
                                    let jsonString = String(data: jsonResponse, encoding: .ascii)
                                    result(jsonString)
                                }else {
                                    var errorDictionary = [String: Any]()
                                    errorDictionary["error"] = SwiftRoamFlutterPlugin.encodeRoamTripError(error:error!)
                                    let jsonError = try JSONSerialization.data(withJSONObject: errorDictionary, options: [])
                                    let jsonString = String(data: jsonError, encoding: .ascii)
                                    result(jsonString)
                                }
                            } catch let error{
                                print(error)
                            }
                        }
                    }
                } catch let error{
                    print(error)
                }
            }
            
            
            
        case SwiftRoamFlutterPlugin.METHOD_PAUSE_TRIP:
            let arguments = call.arguments as! [String: Any]
            let tripId = arguments["tripId"]  as! String;
            Roam.pauseTrip(tripId){response, error in
                print(response)
                print(error)
                do{
                    if(response != nil){
                        let jsonResponse = try JSONSerialization.data(withJSONObject: SwiftRoamFlutterPlugin.encodeRoamTripResponse(response: response!), options: [])
                        let jsonString = String(data: jsonResponse, encoding: .ascii)
                        result(jsonString)
                    } else {
                        var errorDictionary = [String: Any]()
                        errorDictionary["error"] = SwiftRoamFlutterPlugin.encodeRoamTripError(error:error!)
                        let jsonError = try JSONSerialization.data(withJSONObject: errorDictionary, options: [])
                        let jsonString = String(data: jsonError, encoding: .ascii)
                        result(jsonString)
                    }
                } catch let error{
                    print(error)
                }
            }
            
        case SwiftRoamFlutterPlugin.METHOD_RESUME_TRIP:
            let arguments = call.arguments as! [String: Any]
            let tripId = arguments["tripId"]  as! String;
            Roam.resumeTrip(tripId){response, error in
                print(response)
                print(error)
                do{
                    if(response != nil){
                        let jsonResponse = try JSONSerialization.data(withJSONObject: SwiftRoamFlutterPlugin.encodeRoamTripResponse(response: response!), options: [])
                        let jsonString = String(data: jsonResponse, encoding: .ascii)
                        result(jsonString)
                    } else {
                        var errorDictionary = [String: Any]()
                        errorDictionary["error"] = SwiftRoamFlutterPlugin.encodeRoamTripError(error:error!)
                        let jsonError = try JSONSerialization.data(withJSONObject: errorDictionary, options: [])
                        let jsonString = String(data: jsonError, encoding: .ascii)
                        result(jsonString)
                    }
                } catch let error{
                    print(error)
                }
            }
            
            
        case SwiftRoamFlutterPlugin.METHOD_END_TRIP:
            let arguments = call.arguments as! [String: Any]
            let tripId = arguments["tripId"]  as! String;
            let forceStopTracking = arguments["stopTracking"] as! Bool
            Roam.endTrip(tripId, forceStopTracking){response, error in
                print(response)
                print(error)
                do{
                    if(response != nil){
                        let jsonResponse = try JSONSerialization.data(withJSONObject: SwiftRoamFlutterPlugin.encodeRoamTripResponse(response: response!), options: [])
                        let jsonString = String(data: jsonResponse, encoding: .ascii)
                        result(jsonString)
                    } else {
                        var errorDictionary = [String: Any]()
                        errorDictionary["error"] = SwiftRoamFlutterPlugin.encodeRoamTripError(error:error!)
                        let jsonError = try JSONSerialization.data(withJSONObject: errorDictionary, options: [])
                        let jsonString = String(data: jsonError, encoding: .ascii)
                        result(jsonString)
                    }
                } catch let error{
                    print(error)
                }
            }
            
            
        case SwiftRoamFlutterPlugin.METHOD_DELETE_TRIP:
            let arguments = call.arguments as! [String: Any]
            let tripId = arguments["tripId"]  as! String;
            Roam.deleteTrip(tripId){response, error in
                do{
                    if(response != nil){
                        let jsonResponse = try JSONSerialization.data(withJSONObject: SwiftRoamFlutterPlugin.encodeRoamTripDeleteResponse(deleteResponse: response!), options: [])
                        let jsonString = String(data: jsonResponse, encoding: .ascii)
                        result(jsonString)
                    } else {
                        var errorDictionary = [String: Any]()
                        errorDictionary["error"] = SwiftRoamFlutterPlugin.encodeRoamTripError(error:error!)
                        let jsonError = try JSONSerialization.data(withJSONObject: errorDictionary, options: [])
                        let jsonString = String(data: jsonError, encoding: .ascii)
                        result(jsonString)
                    }
                } catch let error{
                    print(error)
                }
            }
            
            
        case SwiftRoamFlutterPlugin.METHOD_GET_ACTIVE_TRIPS:
            let arguments = call.arguments as! [String: Any]
            let isLocal = arguments["isLocal"]  as! Bool;
            Roam.getActiveTrips(isLocal){response, error in
                do{
                    if(response != nil){
                        let jsonResponse = try JSONSerialization.data(withJSONObject: SwiftRoamFlutterPlugin.encodeRoamActiveTripResponse(response: response!), options: [])
                        let jsonString = String(data: jsonResponse, encoding: .ascii)
                        result(jsonString)
                    } else {
                        var errorDictionary = [String: Any]()
                        errorDictionary["error"] = SwiftRoamFlutterPlugin.encodeRoamTripError(error:error!)
                        let jsonError = try JSONSerialization.data(withJSONObject: errorDictionary, options: [])
                        let jsonString = String(data: jsonError, encoding: .ascii)
                        result(jsonString)
                    }
                } catch let error{
                    print(error)
                }
            }
            
            
        case SwiftRoamFlutterPlugin.METHOD_GET_TRIP:
            let arguments = call.arguments as! [String: Any]
            let tripId = arguments["tripId"]  as! String;
            Roam.getTrip(tripId){response, error in
                print(response)
                print(error)
                do{
                    if(response != nil){
                        let jsonResponse = try JSONSerialization.data(withJSONObject: SwiftRoamFlutterPlugin.encodeRoamTripResponse(response: response!), options: [])
                        let jsonString = String(data: jsonResponse, encoding: .ascii)
                        result(jsonString)
                    } else {
                        var errorDictionary = [String: Any]()
                        errorDictionary["error"] = SwiftRoamFlutterPlugin.encodeRoamTripError(error:error!)
                        let jsonError = try JSONSerialization.data(withJSONObject: errorDictionary, options: [])
                        let jsonString = String(data: jsonError, encoding: .ascii)
                        result(jsonString)
                    }
                } catch let error{
                    print(error)
                }
            }
            
            
            
            
        case SwiftRoamFlutterPlugin.METHOD_GET_TRIP_SUMMARY:
            let arguments = call.arguments as! [String: Any]
            let tripId = arguments["tripId"]  as! String;
            Roam.getTripSummary(tripId){response, error in
                do{
                    if(response != nil){
                        let jsonResponse = try JSONSerialization.data(withJSONObject: SwiftRoamFlutterPlugin.encodeRoamTripResponse(response: response!), options: [])
                        let jsonString = String(data: jsonResponse, encoding: .ascii)
                        result(jsonString)
                    } else {
                        var errorDictionary = [String: Any]()
                        errorDictionary["error"] = SwiftRoamFlutterPlugin.encodeRoamTripError(error:error!)
                        let jsonError = try JSONSerialization.data(withJSONObject: errorDictionary, options: [])
                        let jsonString = String(data: jsonError, encoding: .ascii)
                        result(jsonString)
                    }
                } catch let error{
                    print(error)
                }
            }
            
            
        case SwiftRoamFlutterPlugin.METHOD_SYNC_TRIP:
            let arguments = call.arguments as! [String: Any]
            let tripId = arguments["tripId"]  as! String;
            Roam.syncTrip(tripId){response, error in
                print(response)
                print(error)
                do{
                    if(response != nil){
                        let jsonResponse = try JSONSerialization.data(withJSONObject: SwiftRoamFlutterPlugin.encodeRoamSyncTripResponse(response: response!), options: [])
                        let jsonString = String(data: jsonResponse, encoding: .ascii)
                        result(jsonString)
                    } else {
                        var errorDictionary = [String: Any]()
                        errorDictionary["error"] = SwiftRoamFlutterPlugin.encodeRoamTripError(error:error!)
                        let jsonError = try JSONSerialization.data(withJSONObject: errorDictionary, options: [])
                        let jsonString = String(data: jsonError, encoding: .ascii)
                        result(jsonString)
                    }
                } catch let error{
                    print(error)
                }
            }
            
        case SwiftRoamFlutterPlugin.METHOD_SUBSCRIBE_TRIP:
            let arguments = call.arguments as! [String: Any]
            let tripId = arguments["tripId"]  as! String;
            Roam.subscribeTrip(tripId)
            
            
            
        case SwiftRoamFlutterPlugin.METHOD_UNSUBSCRIBE_TRIP:
            let arguments = call.arguments as! [String: Any]
            let tripId = arguments["tripId"]  as! String;
            Roam.unsubscribeTrip(tripId)
            
            
            
            
        default:
            result("iOS " + UIDevice.current.systemVersion)
        }
    }
    
    
    
    //JSON encode
    
    public static func encodeRoamTripResponse(response: RoamTripResponse) -> [String: Any]{
        let responseDisctionary: [String: Any] = [
            "code": (response.code ?? 0) as NSNumber,
            "message": (response.message ?? "") as String,
            "description": (response.errorDescription ?? "") as String,
            "trip": encodeRoamTrip(roamTrip: response.trip)
        ]
        return responseDisctionary
    }
    
    public static func encodeRoamTrip(roamTrip: RoamTrip?) -> [String: Any] {
        let tripDictionary: [String: Any] = [
            "id": (roamTrip?.tripId ?? "") as String,
            "name": (roamTrip?.tripName ?? "") as String,
            "description": (roamTrip?.tripDescription ?? "") as String,
            "trip_state": (roamTrip?.tripState ?? "") as String,
            "total_distance": (roamTrip?.totalDistance ?? 0) as NSNumber,
            "total_duration": (roamTrip?.totalDuration ?? 0) as NSNumber,
            "total_elevation_gain": (roamTrip?.totalElevationGain ?? 0) as NSNumber,
            "metadata": (roamTrip?.metadata ?? [:]) as [String: Any],
            "start_location": "" as String,
            "end_location": "" as String,
            "user": encodeRoamTripUser(user: roamTrip?.user),
            "started_at": (roamTrip?.startedAt ?? "") as String,
            "ended_at": (roamTrip?.endedAt ?? "") as String,
            "created_at": (roamTrip?.createdAt ?? "") as String,
            "updated_at": (roamTrip?.updatedAt ?? "") as String,
            "is_local": (roamTrip?.isLocal ?? false) as Bool,
            "has_more": false,
            "stops": encodeRoamTripStopList(stops: roamTrip?.stops ?? []),
            "events": encodeRoamTripEvents(events: roamTrip?.events ?? []),
            "route": encodeRoamTripRoutes(routes: roamTrip?.routes ?? []),
        ]
        return tripDictionary
    }
    
    public static func encodeRoamTripUser(user: RoamTripUser?) -> [String: Any] {
        let userDictionary: [String: Any] = [
            "name": (user?.userName ?? "") as String,
            "description" : (user?.userDescription ?? "") as String,
            "id": (user?.userId ?? "") as String,
            "metadata": (user?.metadata ?? [:]) as [String: Any]
        ]
        return userDictionary
    }
    
    public static func encodeRoamTripStopList(stops: [RoamTripStop]) -> [[String: Any]] {
        var stopList = [[String: Any]]()
        for stop in stops{
            let geometry: [String: Any] = [
                "type": (stop.geometryType ?? "") as String,
                "coordinates": (stop.geometryCoordinates ?? [0,0]) as [Double]
            ]
            let stopDisctionary: [String: Any] = [
                "id": (stop.stopId ?? "") as String,
                "name": (stop.stopName ?? "") as String,
                "description": (stop.stopDescription ?? "") as String,
                "address": (stop.address ?? "") as String,
                "metadata": (stop.metadata ?? [:]) as [String: Any],
                "geometry_radius": stop.geometryRadius as NSNumber,
                "created_at": (stop.createdAt ?? "") as String,
                "updated_at": (stop.updatedAt ?? "") as String,
                "arrived_at": (stop.arrivedAt ?? "") as String,
                "departed_at": (stop.departedAt ?? "") as String,
                "geometry": geometry,
            ]
            stopList.append(stopDisctionary)
        }
        return stopList
    }
    
    public static func encodeRoamTripEvents(events: [RoamTripEvents]) -> [[String: Any]] {
        var eventList = [[String: Any]]()
        for event in events{
            let eventDictionary: [String: Any] = [
                "id": (event.eventsId ?? "") as String,
                "trip_id": (event.tripId ?? "") as String,
                "user_id": (event.userId ?? "") as String,
                "event_type": (event.eventType ?? "") as String,
                "created_at": (event.createAt ?? "") as String,
                "event_source": (event.eventSource ?? "") as String,
                "event_version": (event.eventVersion ?? "") as String,
                "location_id": "" as String,
            ]
            eventList.append(eventDictionary)
        }
        return eventList
    }
    
    public static func encodeRoamTripRoutes(routes: [RoamTripRoutes]) -> [[String: Any]] {
        var routesList = [[String: Any]]()
        for route in routes{
            let coordinate: [String: Any] = [
                "type": "" as String,
                "coordinates": route.coordinates as [Double]
            ]
            let routeDictionary: [String: Any] = [
                "metadata": "" as String,
                "activity": (route.activity ?? "") as String,
                "speed": "" as String,
                "altitude": route.altitude as NSNumber,
                "distance": route.distance as NSNumber,
                "duration": route.duration as NSNumber,
                "elevation_gain": route.elevationGain as NSNumber,
                "coordinates": coordinate as [String: Any],
                "recorded_at": (route.recordedAt ?? "") as String,
                "location_id": "" as String
            ]
            routesList.append(routeDictionary)
        }
        return routesList
    }
    
    public static func encodeRoamTripError(error: RoamTripError) -> [String: Any] {
        let errorCode = error.code as NSNumber
        let errorMessage = (error.message ?? "") as String
        let errorDescription = (error.errorDescription ?? "") as String
        let errors = SwiftRoamFlutterPlugin.encodeRoamtTripErrorsList(errors: error.errors)
        let errorDictionary: [String: Any] = [
            "errorCode": errorCode,
            "errorMessage": errorMessage,
            "errorDescription": errorDescription,
            "errors": errors
        ]
        return errorDictionary
    }
    
    public static func encodeRoamtTripErrorsList(errors: [RoamTripErrors]) -> [[String: Any]] {
        var errorsList = [[String: Any]]()
        for error in errors {
            let field = error.field ?? ""
            let message = error.message ?? ""
            let errorDictionary: [String: Any] = [
                "field": field as String,
                "message": message as String
            ]
            errorsList.append(errorDictionary)
        }
        return errorsList
    }
    
    public static func encodeRoamTripDeleteResponse(deleteResponse: RoamTripDelete) -> [String: Any] {
        var tripDetail = [String: Any]()
        tripDetail["id"] = (deleteResponse.tripId ?? "") as String
        tripDetail["isDeleted"] = deleteResponse.isDeleted as Bool
        
        var response = [String: Any]()
        response["message"] = (deleteResponse.message ?? "") as String
        response["description"] = (deleteResponse.messageDescription ?? "") as String
        response["code"] = (deleteResponse.code ?? 0) as NSNumber
        response["trip"] = tripDetail as [String: Any]
        
        return response
    }
    
    
    public static func encodeRoamActiveTripResponse(response: RoamActiveTripResponse) -> [String: Any] {
        
        var responseDictionary = [String: Any]()
        responseDictionary["code"] = response.code as NSNumber
        responseDictionary["message"] = (response.message ?? "") as String
        responseDictionary["description"] = (response.errorDescription ?? "") as String
        responseDictionary["hasMore"] = response.has_more as Bool
        
        var tripsList = [[String: Any]]()
        for trip in response.trips{
            tripsList.append(SwiftRoamFlutterPlugin.encodeRoamTrip(roamTrip: trip))
        }
        responseDictionary["trips"] = tripsList as [[String: Any]]
        
        return responseDictionary
    }
    
    public static func encodeRoamSyncTripResponse(response: RoamTripSync) -> [String: Any]{
        
        var responseDictionary = [String: Any]()
        responseDictionary["msg"] = (response.message ?? "") as String
        responseDictionary["description"] = (response.messageDescription ?? "") as String
        responseDictionary["code"] = (response.code ?? 0) as NSNumber
        
        var dataDictionary = [String: Any]()
        dataDictionary["trip_id"] = (response.trip_id ?? "") as String
        dataDictionary["is_synced"] = response.isSynced as Bool
        
        responseDictionary["data"] = dataDictionary as [String: Any]
        
        return responseDictionary
    }
    
    
    
    
    
    
    
    //JSON Decode
    public static func decodeRoamTrip(tripDictionary: [String: Any]) -> RoamTrip {
       
        let roamTrip = RoamTrip()
        
        if(tripDictionary["isLocal"] != nil){
            roamTrip.isLocal = tripDictionary["isLocal"] as? Bool ?? false
        }
        
        if(tripDictionary["description"] != nil){
            roamTrip.tripDescription = tripDictionary["description"] as? String ?? ""
        }
        
        if(tripDictionary["name"] != nil){
            roamTrip.tripName = tripDictionary["name"] as? String ?? ""
        }
        
        if(tripDictionary["stops"] != nil){
            roamTrip.stops = decodeRoamTripStopList(stopsDictionary: tripDictionary["stops"] as? [[String: Any]] ?? [[:]])
        }
        
        if(tripDictionary["tripId"] != nil){
            roamTrip.tripId = tripDictionary["tripId"] as? String ?? ""
        }
        
        if(tripDictionary["metadata"] != nil){
            roamTrip.metadata = tripDictionary["metadata"] as? [String: Any] ?? [:]
        }
        
        return roamTrip
    }
    
    
    
    public static func decodeRoamTripStopList(stopsDictionary: [[String: Any]]) -> [RoamTripStop] {
        var stops = [RoamTripStop]()
        for stop in stopsDictionary {
            let address = stop["address"] as? String ?? ""
            let metadata = stop["metadata"] as? [String: Any] ?? [:]
            let name = stop["name"] as? String ?? ""
            let description = stop["description"] as? String ?? ""
            let geometry_radius = stop["geometry_radius"] as? NSNumber ?? 50
            let geometry = stop["geometry"] as? [Double]
            
            
            let stopObj = RoamTripStop()
            stopObj.address = address
            stopObj.metadata = metadata
            stopObj.stopName = name
            stopObj.stopDescription = description
            stopObj.geometryRadius = geometry_radius
            stopObj.geometryCoordinates = geometry
            stops.append(stopObj)
        }
        return stops
    }
    
    public static func decodeRoamTrackingCustomMethods(trackingModeDisctionary: [String: Any]) -> RoamTrackingCustomMethods {
        
        let options = RoamTrackingCustomMethods()
        options.activityType = SwiftRoamFlutterPlugin.getActivityTypeIOS(trackingModeDisctionary["activityType"] as? String ?? "otherNavigation")
        options.desiredAccuracy = SwiftRoamFlutterPlugin.getDesiredAccuracyIOS(trackingModeDisctionary["desiredAccuracyIOS"] as? String ?? "best")
        options.allowBackgroundLocationUpdates = trackingModeDisctionary["allowBackgroundLocationUpdates"] as? Bool
        options.pausesLocationUpdatesAutomatically = trackingModeDisctionary["pausesLocationUpdatesAutomatically"] as? Bool
        options.showsBackgroundLocationIndicator = trackingModeDisctionary["showsBackgroundLocationIndicator"] as? Bool
        options.accuracyFilter = trackingModeDisctionary["accuracyFilter"] as? Int
        options.distanceFilter = trackingModeDisctionary["distanceFilter"] as? CLLocationDistance
        options.updateInterval = trackingModeDisctionary["updateInterval"] as? Int
        
        return options
    }
    
    
    
    
    
    
    private static func getActivityTypeIOS(_ type:String) -> CLActivityType
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

    private static func getDesiredAccuracyIOS(_ type:String) -> LocationAccuracy
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
    
   
    
    
    
}


