<p align="center">
  <a href="https://roam.ai" target="_blank" align="left">
    <img src="https://github.com/geosparks/roam-flutter/blob/master/logo.png?raw=true" width="180">
  </a>
  <br />
</p>

[![pub package](https://img.shields.io/pub/v/roam_flutter.svg)](https://pub.dartlang.org/packages/roam_flutter)
[![Pub.dev Publish](https://github.com/roam-ai/roam-flutter/actions/workflows/dart.yml/badge.svg?branch=master)](https://github.com/roam-ai/roam-flutter/actions/workflows/dart.yml)

# Official Roam Flutter SDK
This is the official Roam Flutter SDK developed and maintained by Roam B.V

Note: Before you get started [signup to our dashboard](https://roam.ai) to get your API Keys.

# Quick Start
The Roam Flutter Plugin makes it quick and easy to build a
location tracker for your Flutter app. We provide powerful and
customizable tracking modes and features that can be used to collect
your users location updates.

Here’s a link to our example app : [Example Application](https://github.com/roam-ai/roam-flutter/tree/master/example)

## Install the plugin

Add following lines to your applications pubspec.yml:

```dart
dependencies:
  roam_flutter: ^0.1.6
```
Install the plugin using the following command:
```dart
flutter pub get
```
Alternatively, the code editor might support flutter pub get. Check the editor docs for your editor to learn more.

## Platform Configuration

**iOS**

To configure the location services, add following entries to the
**Info.plist** file.

![](https://gblobscdn.gitbook.com/assets%2F-LSIY5fR7w61d6wHf6iI%2F-LWA3HF19_HBBEZj1hrU%2F-LWA55gjYBsLYYd8f_Oi%2F4.png?alt=media&token=4feb38a5-d013-43ab-81a6-7b69f96e09c4)

Then, in your project settings, go to `Capabilities > Background Modes`
and turn on background fetch, location updates, remote-notifications.

![](https://gblobscdn.gitbook.com/assets%2F-LSIY5fR7w61d6wHf6iI%2F-LWA3HF19_HBBEZj1hrU%2F-LWA5AepQh8EoHoIB3xS%2F3.png?alt=media&token=9436cc91-33b6-4126-8629-c610d80bb281)

Then, go to Build Settings in the project targets and change 'Always
Embed Swift Standard Libraries' to 'Yes'.

**Android**

Add below lines in your `AndroidManifest.xml` file.

``` xml
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_ACCESS_NETWORK_STATE" />
    <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
    <uses-permission android:name="android.permission.SYSTEM_ALERT_WINDOW" />
```

## Initialize SDK

Import the plugin in the main.dart file of your project

``` dart
import 'package:roam_flutter/roam_flutter.dart';
```

Initialize the plugin with your `sdk key`.

``` dart
Roam.initialize(publishKey:'YOUR-SDK-KEY');
```

## Creating Users

Once the SDK is initialized, we need to *create* or *get a user* to
start the tracking and use other methods. Every user created will have a
unique Roam identifier which will be used later to login and access
developer APIs. We can call it as Roam userId.

``` dart
Roam.createUser(description:'Joe',callBack: ({user}) {
// do something on create user
print(user);
});
```
The option *user description* can be used to update your user
information such as name, address or add an existing user ID. Make sure
the information is encrypted if you are planning to save personal user
information like email or phone number.

You can always set or update user descriptions later using the below
code.

```dart
Roam.setDescription(description:'Joe');
```

If you already have a Roam userID which you would like to reuse
instead of creating a new user, use the below to get user session.

``` dart
Roam.getUser(userId:'60181b1f521e0249023652bc',callBack: ({user}) {
// do something on get user
print(user);
});
```

## Request Permissions

Get location permission from the App user on the device. Also check if
the user has turned on location services for the device.

Add this to your package's pubspec.yaml file:

```dart
dependencies:
  permission_handler: ^5.1.0+2
```
Now in your Dart code, you can use:

```dart
import 'package:permission_handler/permission_handler.dart';
```
Used the below below method to request location permissions.
```dart
Permission.locationAlways.request();
```
## Location Tracking
### Start Tracking

``` dart
Roam.startTracking(trackingMode: 'TRACKING-MODE');
```

Use the tracking modes while you use the startTracking method
`Roam.startTracking()`

### **Tracking Modes**

Roam has three default tracking modes along with a custom version.
They differ based on the frequency of location updates and battery
consumption. The higher the frequency, the higher is the battery
consumption.

<div class="table-wrap">

|          |                   |                    |                                |
| -------- | ----------------- | ------------------ | ------------------------------ |
| **Mode** | **Battery usage** | **Updates every ** | **Optimised for/advised for ** |
| Active   | 6% - 12%          | 25 ~ 250 meters    | Ride Hailing / Sharing         |
| Balanced | 3% - 6%           | 50 ~ 500 meters    | On Demand Services             |
| Passive  | 0% - 1%           | 100 ~ 1000 meters  | Social Apps                    |

</div>

```dart
// passive tracking
Roam.startTracking(trackingMode: 'passive');
// balanced tracking
Roam.startTracking(trackingMode: 'balanced');
// active tracking
Roam.startTracking(trackingMode: 'active');
```

### Custom Tracking Modes

The SDK also allows you define a custom tracking mode that allows you to
customize and build your own tracking modes.

**iOS**

``` dart
Roam.startTracking(trackingMode: "custom",customMethods: <CUSTOM_TRACKING_METHOD>);
```

Example

``` dart
Map<String, dynamic> fitnessTracking = {
                          "activityType": "fitness",
                          "pausesLocationUpdatesAutomatically": true,
                          "showsBackgroundLocationIndicator": true,
                          "distanceFilter": 10,
                          "useSignificantLocationChanges": false,
                          "useRegionMonitoring": false,
                          "useVisits": false,
                          "desiredAccuracy": "nearestTenMeters"
                        };
Roam.startTracking(trackingMode: "custom",customMethods: fitnessTracking);
```

You may see a delay if the user's device is in low power mode or has
connectivity issues.

**Android**

In Android, you can set custom tracking to two different tracking options. Once with fixed distance interval and another with time based interval.

``` dart
Map<String, dynamic> fitnessTracking = {
                          "distanceInterval": 10
                        };
Roam.startTracking(trackingMode: "custom",customMethods: fitnessTracking);
```

``` dart
Map<String, dynamic> fitnessTracking = {
                          "timeInterval": 10
                        };
Roam.startTracking(trackingMode: "custom",customMethods: fitnessTracking);
```

### Stop Tracking

To stop the tracking use the below method.

``` dart
Roam.stopTracking();
```

## Location Listener

To receive locations in dart use the below method.


```dart
Roam.onLocation((location) {
                      print(jsonEncode(location));
                    });
```

## SDK Methods
- Please visit our [Developer Center](https://github.com/roam-ai/roam-flutter/wiki/SDK-Methods) for instructions on other SDK methods.
## Contributing
- For developing the SDK, please visit our [CONTRIBUTING.md](https://github.com/roam-ai/roam-flutter/blob/master/CONTRIBUTING.md) to get started.

## Need Help?
If you have any problems or issues over our SDK, feel free to create a github issue or submit a request on [Roam Help](https://geosparkai.atlassian.net/servicedesk/customer/portal/2).
