import UIKit
import Flutter
import GeoSpark

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, GeoSparkDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    GeoSpark.delegate = self
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    //Native to Flutter Channel
    func didUpdateLocation(_ location: GeoSparkLocation) {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let myChannel = FlutterMethodChannel(name: "myChannel", binaryMessenger: controller.binaryMessenger)
        let coordinates: NSDictionary = [
            "latitude": location.location.coordinate.latitude as Any,
            "longitude": location.location.coordinate.longitude as Any
        ]
        let nativeLocation: NSDictionary = [
            "coordinate": coordinates,
            "altitude":location.location.altitude as Any,
            "horizontalAccuracy":location.location.horizontalAccuracy as Any,
            "verticalAccuracy":location.location.verticalAccuracy as Any
        ]
        let payload:NSDictionary = [
            "location": nativeLocation as Any,
            "userId":location.userId as Any
        ]
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: payload,
            options: []) {
            let theJSONText = String(data: theJSONData,encoding: .ascii)
            myChannel.invokeMethod("location", arguments: theJSONText)
        }
    }
}
