import UIKit
import Flutter
import Roam

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    //Roam.delegate = self
    //Roam.initialize("fd7bd6d1b1ecbfbd456bf9ccd3f4157323eb184d919e5cd341ad0fad216d0b06")
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let myChannel = FlutterMethodChannel(name: "roam_example", binaryMessenger: controller.binaryMessenger)
      myChannel.setMethodCallHandler({ [weak self](call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
          switch call.method {
          case "send_notification":
              let arguments = call.arguments as! [String: Any]
              let notificationBody = arguments["body"] as! String;
              let content = UNMutableNotificationContent()
              content.subtitle = notificationBody
              let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
              let request = UNNotificationRequest(identifier: "notification.id.01", content: content, trigger: trigger)
              UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
              
          default: break
              
          }
      })

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  
    //Native to Flutter Channel
//    func didUpdateLocation(_ location: RoamLocation) {
//        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
//        let myChannel = FlutterMethodChannel(name: "myChannel", binaryMessenger: controller.binaryMessenger)
//        let coordinates: NSDictionary = [
//            "latitude": location.location.coordinate.latitude as Any,
//            "longitude": location.location.coordinate.longitude as Any
//        ]
//        let nativeLocation: NSDictionary = [
//            "coordinate": coordinates,
//            "altitude":location.location.altitude as Any,
//            "horizontalAccuracy":location.location.horizontalAccuracy as Any,
//            "verticalAccuracy":location.location.verticalAccuracy as Any
//        ]
//        let payload:NSDictionary = [
//            "location": nativeLocation as Any,
//            "userId":location.userId as Any
//        ]
//        if let theJSONData = try? JSONSerialization.data(
//            withJSONObject: payload,
//            options: []) {
//            let theJSONText = String(data: theJSONData,encoding: .ascii)
//            myChannel.invokeMethod("location", arguments: theJSONText)
//        }
//    }
}
