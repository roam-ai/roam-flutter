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
    func didUpdateLocation(_ location: GeoSparkLocation) {
        print("Location Received")
    }
}
