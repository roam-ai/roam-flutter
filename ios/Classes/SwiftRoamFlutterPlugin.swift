import Flutter
import UIKit
import GeoSpark

public class SwiftRoamFlutterPlugin: NSObject, FlutterPlugin {
  private static let METHOD_INITIALIZE = "initialize";
  private static let METHOD_GET_CURRENT_LOCATION = "getCurrentLocation";
  private static let METHOD_CREATE_USER = "createUser";
  private static let METHOD_UPDATE_CURRENT_LOCATION = "updateCurrentLocation";
  private static let METHOD_START_TRACKING = "startTracking";
  private static let METHOD_STOP_TRACKING = "stopTracking";
  private static let METHOD_LOGOUT_USER = "logoutUser";

  private static let TRACKING_MODE_PASSIVE = "passive";
  private static let TRACKING_MODE_REACTIVE = "reactive";
  private static let TRACKING_MODE_ACTIVE = "active";

  private static var channel: FlutterMethodChannel?;

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "roam_flutter", binaryMessenger: registrar.messenger())
    let instance = SwiftRoamFlutterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    registrar.addApplicationDelegate(instance)
  }

  public func didUpdateLocation(_ geospark: GeoSparkLocation) {
    debugPrint("Location Received")
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

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch (call.method) {
      case SwiftRoamFlutterPlugin.METHOD_INITIALIZE:
        let arguments = call.arguments as! [String: Any]
        let publishKey = arguments["publishKey"]  as! String;
        GeoSpark.intialize(publishKey)
      case SwiftRoamFlutterPlugin.METHOD_CREATE_USER:
        let arguments = call.arguments as! [String: Any]
        let description = arguments["description"]  as! String;
        GeoSpark.createUser(description)
      case SwiftRoamFlutterPlugin.METHOD_UPDATE_CURRENT_LOCATION:
        let arguments = call.arguments as! [String: Any]
        let accuracy = arguments["accuracy"]  as! Int;
        GeoSpark.updateCurrentLocation(accuracy)
      case SwiftRoamFlutterPlugin.METHOD_GET_CURRENT_LOCATION:
        let arguments = call.arguments as! [String: Any]
        let accuracy = arguments["accuracy"]  as! Int;
        GeoSpark.getCurrentLocation(accuracy) { (location, error) in
          let coordinates: NSDictionary = [
            "latitude": location?.coordinate.latitude as Any,
            "longitude": location?.coordinate.longitude as Any
          ]
          let location: NSDictionary = [
            "coordinate": coordinates,
            "altitude":location?.altitude as Any,
            "horizontalAccuracy":location?.horizontalAccuracy as Any,
            "verticalAccuracy":location?.verticalAccuracy as Any
          ]
          if let theJSONData = try? JSONSerialization.data(
            withJSONObject: location,
            options: []) {
              let theJSONText = String(data: theJSONData,encoding: .ascii)
              result(theJSONText)
              }
        }
      case SwiftRoamFlutterPlugin.METHOD_START_TRACKING:
        let arguments = call.arguments as! [String: Any]
        let trackingMode = arguments["trackingMode"]  as? String;
        var options = GeoSparkTrackingMode.active
        // guard let localtrackingMode = trackingMode else {
        //   GeoSpark.startTracking(trackingMode as GeoSparkTrackingMode);
        //   result(true);
        //   return;
        //   }
        switch (trackingMode!) {
          case SwiftRoamFlutterPlugin.TRACKING_MODE_PASSIVE:
            options = GeoSparkTrackingMode.passive
          case SwiftRoamFlutterPlugin.TRACKING_MODE_REACTIVE:
            options = GeoSparkTrackingMode.reactive
          case SwiftRoamFlutterPlugin.TRACKING_MODE_ACTIVE:
            options = GeoSparkTrackingMode.active
          default:
            options = GeoSparkTrackingMode.active
          }
      GeoSpark.startTracking(options)
      result(true);
      case SwiftRoamFlutterPlugin.METHOD_STOP_TRACKING:
        GeoSpark.stopTracking()
      case SwiftRoamFlutterPlugin.METHOD_LOGOUT_USER:
        GeoSpark.logoutUser()
      default:
        result("iOS " + UIDevice.current.systemVersion)
    }
  }
}
