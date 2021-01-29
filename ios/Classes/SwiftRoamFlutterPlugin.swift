import Flutter
import UIKit
import GeoSpark

public class SwiftRoamFlutterPlugin: NSObject, FlutterPlugin {
  private static let METHOD_INITIALIZE = "initialize";
  private static let METHOD_GET_CURRENT_LOCATION = "getCurrentLocation";
  private static let METHOD_CREATE_USER = "createUser";

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
      default:
        result("iOS " + UIDevice.current.systemVersion)
    }
  }
}
