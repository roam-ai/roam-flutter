import Flutter
import UIKit
import GeoSpark

public class SwiftRoamFlutterPlugin: NSObject, FlutterPlugin {
  private static let METHOD_INITIALIZE = "initialize";
  private static let METHOD_GET_CURRENT_LOCATION = "getCurrentLocation";
  private static let METHOD_CREATE_USER = "createUser";
  private static let METHOD_UPDATE_CURRENT_LOCATION = "updateCurrentLocation";

  private static var channel: FlutterMethodChannel?;

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "roam_flutter", binaryMessenger: registrar.messenger())
    let instance = SwiftRoamFlutterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
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
      default:
        result("iOS " + UIDevice.current.systemVersion)
    }
  }
}
