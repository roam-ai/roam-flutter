import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:roam_flutter/roam_flutter.dart';

import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var routes = <String, WidgetBuilder>{
      MyItemsPage.routeName: (BuildContext context) =>
          new MyItemsPage(title: "Trips Page"),
      MyUsersPage.routeName: (BuildContext context) =>
          new MyUsersPage(title: "Users Page"),
      MySubcriptionPage.routeName: (BuildContext context) =>
          new MySubcriptionPage(title: "Subcription Page"),
      MyAccuracyEnginePage.routeName: (BuildContext context) =>
          new MyAccuracyEnginePage(title: "Accuracy Engine Page"),
      MyLocationTrackingPage.routeName: (BuildContext context) =>
          new MyLocationTrackingPage(title: "Location Tracking Page"),
    };
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(
        title: 'Demo',
      ),
      routes: routes,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _MyHomePage createState() => _MyHomePage();
}

class _MyHomePage extends State<MyHomePage> {
  String _platformVersion = 'Unknown';
  bool isTracking = false;
  String myLocation;
  String myUser;
  bool isAccuracyEngineEnabled = false;

  //Native to Flutter Channel
  static const platform = const MethodChannel("myChannel");

  @override
  void initState() {
    platform.setMethodCallHandler(
        nativeMethodCallHandler); //Native to Flutter Channel
    super.initState();
    initPlatformState();
    Roam.initialize(
        publishKey:
            "411076002016f3a85d9299806df465f24fe49feea904eb75076bbf0d8e8d5834");
  }

  //Native to Flutter Channel
  Future<dynamic> nativeMethodCallHandler(MethodCall methodCall) async {
    switch (methodCall.method) {
      case "location":
        print(methodCall.arguments);
        setState(() {
          myLocation = methodCall.arguments;
        });
        break;
      default:
        return "Nothing";
        break;
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await Roam.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Roam Plugin Example App'),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SelectableText('Running on: $_platformVersion\n'),
            SelectableText(
              'Received Location:\n $myLocation\n',
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
                child: Text('Request Location Permissions'),
                onPressed: () async {
                  try {
                    await Permission.locationAlways.request();
                  } on PlatformException {
                    print('Error getting location permissions');
                  }
                }),
            ElevatedButton(
                child: Text('Disable Battery Optimization'),
                onPressed: () async {
                  try {
                    await Roam.disableBatteryOptimization();
                  } on PlatformException {
                    print('Disable Battery Optimization Error');
                  }
                }),
            ElevatedButton(
                child: Text('Get Current Location'),
                onPressed: () async {
                  setState(() {
                    myLocation = "fetching location..";
                  });
                  try {
                    await Roam.getCurrentLocation(
                      accuracy: 100,
                      callBack: ({location}) {
                        setState(() {
                          myLocation = location;
                        });
                        print(location);
                      },
                    );
                  } on PlatformException {
                    print('Get Current Location Error');
                  }
                }),
            ElevatedButton(
                child: Text('Initialize SDK'),
                onPressed: () async {
                  try {
                    await Roam.initialize(
                        publishKey:
                            '14ea570d8a40782d1595d12e0f73d42544a05f139bf0206396b9efd0ee42f837');
                  } on PlatformException {
                    print('Initialization Error');
                  }
                }),
            ElevatedButton(
                child: Text('Users'), onPressed: _onUsersButtonPressed),
            ElevatedButton(
                child: Text('Subcribe Location/Events'),
                onPressed: _onSubscriptionButtonPressed),
            ElevatedButton(
                child: Text('Accuracy Engine'),
                onPressed: _onAccuracyEngineButtonPressed),
            ElevatedButton(
                child: Text('Location Tracking'),
                onPressed: _onLocationTrackingButtonPressed),
            ElevatedButton(child: Text('Trips'), onPressed: _onButtonPressed),
          ],
        )),
      ),
    );
  }

  void _onButtonPressed() {
    Navigator.pushNamed(context, MyItemsPage.routeName);
  }

  void _onUsersButtonPressed() {
    Navigator.pushNamed(context, MyUsersPage.routeName);
  }

  void _onSubscriptionButtonPressed() {
    Navigator.pushNamed(context, MySubcriptionPage.routeName);
  }

  void _onAccuracyEngineButtonPressed() {
    Navigator.pushNamed(context, MyAccuracyEnginePage.routeName);
  }

  void _onLocationTrackingButtonPressed() {
    Navigator.pushNamed(context, MyLocationTrackingPage.routeName);
  }
}

class MyItemsPage extends StatefulWidget {
  MyItemsPage({Key key, this.title}) : super(key: key);

  static const String routeName = "/MyItemsPage";

  final String title;

  @override
  _MyItemsPageState createState() => new _MyItemsPageState();
}

class _MyItemsPageState extends State<MyItemsPage> {
  String myTrip;
  String tripId;


  TextEditingController _textFieldController = TextEditingController();

  Future<void> _displayTripsInputDialog(
      BuildContext context, String type) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Enter Trip Id'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  tripId = value;
                });
              },
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "Enter Trip Id"),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.red,
                textColor: Colors.white,
                child: Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              FlatButton(
                color: Colors.green,
                textColor: Colors.white,
                child: Text('OK'),
                onPressed: () async {
                  try {
                    switch (type) {
                      case "getTripStatus":
                        Roam.getTripStatus(
                            tripId: tripId,
                            callBack: ({trip}) {
                              setState(() {
                                myTrip = trip;
                              });
                              print(trip);
                            });
                        break;
                      case "getTripDetails":
                        Roam.getTripDetails(
                            tripId: tripId,
                            callBack: ({trip}) {
                              setState(() {
                                myTrip = trip;
                              });
                              print(trip);
                            });
                        break;
                      case "subscribeTripStatus":
                        Roam.subscribeTripStatus(
                          tripId: tripId,
                        );
                        break;
                      case "unSubscribeTripStatus":
                        print("unSubscribeTripStatus");
                        Roam.ubSubscribeTripStatus(
                          tripId: tripId,
                        );
                        break;
                      case "startTrip":
                        Roam.startTrip(
                          tripId: tripId,
                        );
                        break;
                      case "pauseTrip":
                        Roam.pauseTrip(
                          tripId: tripId,
                        );
                        break;
                      case "resumeTrip":
                        Roam.resumeTrip(
                          tripId: tripId,
                        );
                        break;
                      case "endTrip":
                        Roam.endTrip(
                          tripId: tripId,
                        );
                        break;
                      case "getTripSummary":
                        Roam.getTripSummary(
                            tripId: tripId,
                            callBack: ({trip}) {
                              setState(() {
                                myTrip = trip;
                              });
                              print(trip);
                            });
                        break;
                      default:
                        print("default");
                        Navigator.pop(context);
                        break;
                    }
                  } on PlatformException {
                    print('Trip Error');
                  }
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            SelectableText(
              '\nTrip Details:\n $myTrip\n',
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
                child: Text('Create Trip'),
                onPressed: () async {
                  setState(() {
                    myTrip = "creating trip..";
                  });
                  try {
                    await Roam.createTrip(
                        isOffline: false,
                        callBack: ({trip}) {
                          setState(() {
                            myTrip = trip;
                          });
                          print(trip);
                        });
                  } on PlatformException {
                    print('Create Trip Error');
                  }
                }),
            ElevatedButton(
                child: Text('Get Trip Details'),
                onPressed: () async {
                  _displayTripsInputDialog(context, "getTripDetails");
                }),
            ElevatedButton(
                child: Text('Get Trip Status'),
                onPressed: () async {
                  _displayTripsInputDialog(context, "getTripStatus");
                }),
            ElevatedButton(
                child: Text('Subscribe Trip Status'),
                onPressed: () async {
                  setState(() {
                    myTrip = 'trip subscribed';
                  });
                  try {
                    _displayTripsInputDialog(context, "subscribeTripStatus");
                  } on PlatformException {
                    print('Subscribe Trip Status Error');
                  }
                }),
            ElevatedButton(
                child: Text('Unsubscribe Trip Status'),
                onPressed: () async {
                  setState(() {
                    myTrip = 'trip unsubscribed';
                  });
                  try {
                    _displayTripsInputDialog(context, "unSubscribeTripStatus");
                  } on PlatformException {
                    print('Unsubscribe Trip Status Error');
                  }
                }),
            ElevatedButton(
                child: Text('Start Trip'),
                onPressed: () async {
                  try {
                    _displayTripsInputDialog(context, "startTrip");
                  } on PlatformException {
                    print('Start Trip Error');
                  }
                }),
            ElevatedButton(
                child: Text('Pause Trip'),
                onPressed: () async {
                  try {
                    _displayTripsInputDialog(context, "pauseTrip");
                  } on PlatformException {
                    print('Pause Trip Error');
                  }
                }),
            ElevatedButton(
                child: Text('Resume Trip'),
                onPressed: () async {
                  try {
                    _displayTripsInputDialog(context, "resumeTrip");
                  } on PlatformException {
                    print('Resume Trip Error');
                  }
                }),
            ElevatedButton(
                child: Text('End Trip'),
                onPressed: () async {
                  try {
                    _displayTripsInputDialog(context, "endTrip");
                  } on PlatformException {
                    print('End Trip Error');
                  }
                }),
            ElevatedButton(
                child: Text('Get Trip Summary'),
                onPressed: () async {
                  setState(() {
                    myTrip = "fetching trip summary..";
                  });
                  try {
                    _displayTripsInputDialog(context, "getTripSummary");
                  } on PlatformException {
                    print('Get Trip Summary Error');
                  }
                }),
          ],
        ),
      ),
    );
  }
}

class MyUsersPage extends StatefulWidget {
  MyUsersPage({Key key, this.title}) : super(key: key);
  static const String routeName = "/MyUsersPage";
  final String title;
  @override
  _MyUsersPageState createState() => new _MyUsersPageState();
}

class _MyUsersPageState extends State<MyUsersPage> {
  String myUser;
  String codeDialog;
  String valueText;
  TextEditingController _textFieldController = TextEditingController();
  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Enter User Id'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "Enter User Id"),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.red,
                textColor: Colors.white,
                child: Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              FlatButton(
                color: Colors.green,
                textColor: Colors.white,
                child: Text('OK'),
                onPressed: () async {
                  setState(() {
                    try {
                      Roam.getUser(
                          userId: valueText,
                          callBack: ({user}) {
                            setState(() {
                              myUser = user;
                            });
                            print(user);
                          });
                    } on PlatformException {
                      print('Create User Error');
                    }
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            SelectableText(
              '\nUser Details:\n $myUser\n',
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
                child: Text('Create User'),
                onPressed: () async {
                  setState(() {
                    myUser = "creating user..";
                  });
                  try {
                    await Roam.createUser(
                        description: 'Joe',
                        callBack: ({user}) {
                          setState(() {
                            myUser = user;
                          });
                          print(user);
                        });
                  } on PlatformException {
                    print('Create User Error');
                  }
                }),
            ElevatedButton(
                child: Text('Get User'),
                onPressed: () async {
                  _displayTextInputDialog(context);
                }),
            ElevatedButton(
                child: Text('Toogle Listener'),
                onPressed: () async {
                  setState(() {
                    myUser = "updating user listener status..";
                  });
                  try {
                    await Roam.toggleListener(
                        locations: true,
                        events: true,
                        callBack: ({user}) {
                          setState(() {
                            myUser = user;
                          });
                          print(user);
                        });
                  } on PlatformException {
                    print('Toggle Listener Error');
                  }
                }),
            ElevatedButton(
                child: Text('Toogle Events'),
                onPressed: () async {
                  setState(() {
                    myUser = "updating user events status..";
                  });
                  try {
                    await Roam.toggleEvents(
                        location: true,
                        geofence: true,
                        trips: true,
                        movingGeofence: true,
                        callBack: ({user}) {
                          setState(() {
                            myUser = user;
                          });
                          print(user);
                        });
                  } on PlatformException {
                    print('Toggle Events Error');
                  }
                }),
            ElevatedButton(
                child: Text('Get Listener Status'),
                onPressed: () async {
                  setState(() {
                    myUser = "fetching user listener status..";
                  });
                  try {
                    await Roam.getListenerStatus(callBack: ({user}) {
                      setState(() {
                        myUser = user;
                      });
                      print(user);
                    });
                  } on PlatformException {
                    print('Get Listener Status Error');
                  }
                }),
            ElevatedButton(
                child: Text('Logout User'),
                onPressed: () async {
                  try {
                    await Roam.logoutUser();
                  } on PlatformException {
                    print('Logout User Error');
                  }
                }),
          ],
        ),
      ),
    );
  }
}

class MySubcriptionPage extends StatefulWidget {
  MySubcriptionPage({Key key, this.title}) : super(key: key);
  static const String routeName = "/MySubcriptionPage";
  final String title;
  @override
  _MySubcriptionPageState createState() => new _MySubcriptionPageState();
}

class _MySubcriptionPageState extends State<MySubcriptionPage> {
  String myUser;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            SelectableText(
              '\nUser Details:\n $myUser\n',
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
                child: Text('Subscribe Location'),
                onPressed: () async {
                  setState(() {
                    myUser = "user location subscribed";
                  });
                  try {
                    await Roam.subscribeLocation();
                  } on PlatformException {
                    print('Subscribe Location Error');
                  }
                }),
            ElevatedButton(
                child: Text('Subscribe User Location'),
                onPressed: () async {
                  try {
                    setState(() {
                      myUser = "user location subscribed";
                    });
                    await Roam.subscribeUserLocation(
                        userId: '60181b1f521e0249023652bc');
                  } on PlatformException {
                    print('Subscribe User Location Error');
                  }
                }),
            ElevatedButton(
                child: Text('Subscribe Events'),
                onPressed: () async {
                  try {
                    setState(() {
                      myUser = "user events subscribed";
                    });
                    await Roam.subscribeEvents();
                  } on PlatformException {
                    print('Subscribe Events Error');
                  }
                }),
          ],
        ),
      ),
    );
  }
}

class MyAccuracyEnginePage extends StatefulWidget {
  MyAccuracyEnginePage({Key key, this.title}) : super(key: key);
  static const String routeName = "/MyAccuracyEnginePage";
  final String title;
  @override
  _MyAccuracyEnginePageState createState() => new _MyAccuracyEnginePageState();
}

class _MyAccuracyEnginePageState extends State<MyAccuracyEnginePage> {
  bool isAccuracyEngineEnabled;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            SelectableText(
                '\nAccuracy Engine status: $isAccuracyEngineEnabled\n'),
            ElevatedButton(
                child: Text('Enable Accuracy Engine'),
                onPressed: () async {
                  setState(() {
                    isAccuracyEngineEnabled = true;
                  });
                  try {
                    await Roam.enableAccuracyEngine();
                  } on PlatformException {
                    print('Enable Accuracy Engine Error');
                  }
                }),
            ElevatedButton(
                child: Text('Disable Accuracy Engine'),
                onPressed: () async {
                  setState(() {
                    isAccuracyEngineEnabled = false;
                  });
                  try {
                    await Roam.disableAccuracyEngine();
                  } on PlatformException {
                    print('Disable Accuracy Engine Error');
                  }
                }),
          ],
        ),
      ),
    );
  }
}

class MyLocationTrackingPage extends StatefulWidget {
  MyLocationTrackingPage({Key key, this.title}) : super(key: key);
  static const String routeName = "/MyLocationTrackingPage";
  final String title;
  @override
  _MyLocationTrackingPageState createState() =>
      new _MyLocationTrackingPageState();
}

class _MyLocationTrackingPageState extends State<MyLocationTrackingPage> {
  bool isTracking;
  String valueText;
  TextEditingController _textFieldController = TextEditingController();
  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Enter Tracking Type'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              controller: _textFieldController,
              decoration: InputDecoration(
                  hintText: "active/passsive/balanced/custom/time/distance"),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.red,
                textColor: Colors.white,
                child: Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              FlatButton(
                color: Colors.green,
                textColor: Colors.white,
                child: Text('OK'),
                onPressed: () async {
                  try {
                    switch (valueText) {
                      case "active":
                        Roam.startTracking(trackingMode: "active");
                        //Navigator.pop(context);
                        break;
                      case "balanced":
                        Roam.startTracking(trackingMode: "balanced");
                        //Navigator.pop(context);
                        break;
                      case "passive":
                        Roam.startTracking(trackingMode: "passive");
                        //Navigator.pop(context);
                        break;
                      case "custom":
                        Map<String, dynamic> fitnessTracking = {
                          "activityType": "fitness",
                          "showsBackgroundLocationIndicator": true,
                          "allowBackgroundLocationUpdates": true,
                          "distanceFilter": 10,
                          "desiredAccuracy": "nearestTenMeters",
                          "distanceInterval": 15
                        };
                        Roam.startTracking(
                            trackingMode: "custom",
                            customMethods: fitnessTracking);
                        //Navigator.pop(context);
                        break;
                      case "time":
                        Map<String, dynamic> fitnessTracking = {
                          "showsBackgroundLocationIndicator": true,
                          "allowBackgroundLocationUpdates": true,
                          "desiredAccuracy": "kCLLocationAccuracyBest",
                          "timeInterval": 1
                        };
                        Roam.startTracking(
                            trackingMode: "custom",
                            customMethods: fitnessTracking);
                        //Navigator.pop(context);
                        break;
                      case "distance":
                        Map<String, dynamic> fitnessTracking = {
                          "activityType": "fitness",
                          "showsBackgroundLocationIndicator": true,
                          "allowBackgroundLocationUpdates": true,
                          "distanceFilter": 5,
                          "desiredAccuracy": "nearestTenMeters",
                          "distanceInterval": 5
                        };
                        Roam.startTracking(
                            trackingMode: "custom",
                            customMethods: fitnessTracking);
                        //Navigator.pop(context);
                        break;
                      default:
                        Navigator.pop(context);
                        break;
                    }
                  } on PlatformException {
                    print('Trip Error');
                  }
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            SelectableText('\nTracking status: $isTracking\n'),
            ElevatedButton(
                child: Text('Update Current Location'),
                onPressed: () async {
                  try {
                    Map<String, dynamic> testMetaData = Map();
                    testMetaData['param1'] = "value";
                    testMetaData['param2'] = 123;
                    await Roam.updateCurrentLocation(accuracy: 100, jsonObject: testMetaData);
                  } on PlatformException {
                    print('Update Current Location Error');
                  }
                }),
            ElevatedButton(
                child: Text('Start Tracking'),
                onPressed: () async {
                  _displayTextInputDialog(context);
                }),
            ElevatedButton(
                child: Text('Stop Tracking'),
                onPressed: () async {
                  try {
                    await Roam.stopTracking();
                  } on PlatformException {
                    print('Stop Tracking Error');
                  }
                }),
          ],
        ),
      ),
    );
  }
}
