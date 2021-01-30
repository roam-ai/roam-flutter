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
        // let locationInput = ["latitude":location?.coordinate.latitude,"longitude":location?.coordinate.longitude];
          let args: NSDictionary = [
            "location": location
          ]
          dump(location)
          print(SwiftRoamFlutterPlugin.channel)
          print(args)
          SwiftRoamFlutterPlugin.channel!.invokeMethod("callback", arguments: args);
        }
      default:
        result("iOS " + UIDevice.current.systemVersion)
    }
  }
}
