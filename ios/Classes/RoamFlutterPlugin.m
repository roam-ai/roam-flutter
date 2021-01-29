#import "RoamFlutterPlugin.h"
#if __has_include(<roam_flutter/roam_flutter-Swift.h>)
#import <roam_flutter/roam_flutter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "roam_flutter-Swift.h"
#endif

@implementation RoamFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftRoamFlutterPlugin registerWithRegistrar:registrar];
}
@end
