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
      platformVersion = await RoamFlutter.platformVersion;
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
            RaisedButton(
                child: Text('Request Location Permissions'),
                onPressed: () async {
                  try {
                    await Permission.locationAlways.request();
                  } on PlatformException {
                    print('Error getting location permissions');
                  }
                }),
            RaisedButton(
                child: Text('Get Current Location'),
                onPressed: () async {
                  setState(() {
                    myLocation = "fetching location..";
                  });
                  try {
                    await RoamFlutter.getCurrentLocation(
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
            RaisedButton(
                child: Text('Initialize SDK'),
                onPressed: () async {
                  try {
                    await RoamFlutter.initialize(
                        publishKey:
                            'fd7bd6d1b1ecbfbd456bf9ccd3f4157323eb184d919e5cd341ad0fad216d0b06');
                  } on PlatformException {
                    print('Initialization Error');
                  }
                }),
            RaisedButton(
                child: Text('Users'), onPressed: _onUsersButtonPressed),
            RaisedButton(
                child: Text('Subcribe Location/Events'),
                onPressed: _onSubscriptionButtonPressed),
            RaisedButton(
                child: Text('Accuracy Engine'),
                onPressed: _onAccuracyEngineButtonPressed),
            RaisedButton(
                child: Text('Location Tracking'),
                onPressed: _onLocationTrackingButtonPressed),
            RaisedButton(child: Text('Trips'), onPressed: _onButtonPressed),
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
            RaisedButton(
                child: Text('Create Trip'),
                onPressed: () async {
                  setState(() {
                    myTrip = "creating trip..";
                  });
                  try {
                    await RoamFlutter.createTrip(
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
            RaisedButton(
                child: Text('Get Trip Details'),
                onPressed: () async {
                  setState(() {
                    myTrip = "fetching trip details..";
                  });
                  try {
                    await RoamFlutter.getTripDetails(
                        tripId: '601e45cb623bd22e82f419d0',
                        callBack: ({trip}) {
                          setState(() {
                            myTrip = trip;
                          });
                          print(trip);
                        });
                  } on PlatformException {
                    print('Get Trip Details Error');
                  }
                }),
            RaisedButton(
                child: Text('Get Trip Status'),
                onPressed: () async {
                  setState(() {
                    myTrip = "fetching trip details..";
                  });
                  try {
                    await RoamFlutter.getTripStatus(
                        tripId: '601e45cb623bd22e82f419d0',
                        callBack: ({trip}) {
                          setState(() {
                            myTrip = trip;
                          });
                          print(trip);
                        });
                  } on PlatformException {
                    print('Get Trip Details Error');
                  }
                }),
            RaisedButton(
                child: Text('Subscribe Trip Status'),
                onPressed: () async {
                  setState(() {
                    myTrip = 'trip subscribed';
                  });
                  try {
                    await RoamFlutter.subscribeTripStatus(
                        tripId: '601e45cb623bd22e82f419d0');
                  } on PlatformException {
                    print('Subscribe Trip Status Error');
                  }
                }),
            RaisedButton(
                child: Text('Unsubscribe Trip Status'),
                onPressed: () async {
                  setState(() {
                    myTrip = 'trip unsubscribed';
                  });
                  try {
                    await RoamFlutter.ubSubscribeTripStatus(
                        tripId: '601e45cb623bd22e82f419d0');
                  } on PlatformException {
                    print('Unsubscribe Trip Status Error');
                  }
                }),
            RaisedButton(
                child: Text('Start Trip'),
                onPressed: () async {
                  try {
                    await RoamFlutter.startTrip(
                        tripId: '601e45cb623bd22e82f419d0');
                  } on PlatformException {
                    print('Start Trip Error');
                  }
                }),
            RaisedButton(
                child: Text('Pause Trip'),
                onPressed: () async {
                  try {
                    await RoamFlutter.pauseTrip(
                        tripId: '601e45cb623bd22e82f419d0');
                  } on PlatformException {
                    print('Pause Trip Error');
                  }
                }),
            RaisedButton(
                child: Text('Resume Trip'),
                onPressed: () async {
                  try {
                    await RoamFlutter.resumeTrip(
                        tripId: '601e45cb623bd22e82f419d0');
                  } on PlatformException {
                    print('Resume Trip Error');
                  }
                }),
            RaisedButton(
                child: Text('End Trip'),
                onPressed: () async {
                  try {
                    await RoamFlutter.endTrip(
                        tripId: '601e45cb623bd22e82f419d0');
                  } on PlatformException {
                    print('End Trip Error');
                  }
                }),
            RaisedButton(
                child: Text('Get Trip Summary'),
                onPressed: () async {
                  setState(() {
                    myTrip = "fetching trip summary..";
                  });
                  try {
                    await RoamFlutter.getTripSummary(
                        tripId: '601e45cb623bd22e82f419d0',
                        callBack: ({trip}) {
                          setState(() {
                            myTrip = trip;
                          });
                          print(trip);
                        });
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
                    codeDialog = valueText;
                    print(codeDialog);
                    try {
                      RoamFlutter.getUser(
                          userId: codeDialog,
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
            RaisedButton(
                child: Text('Create User'),
                onPressed: () async {
                  setState(() {
                    myUser = "creating user..";
                  });
                  try {
                    await RoamFlutter.createUser(
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
            RaisedButton(
                child: Text('Get User'),
                onPressed: () async {
                  setState(() {
                    myUser = "getting user..";
                  });
                  try {
                    await RoamFlutter.getUser(
                        userId: '601e459e623bd22e59f419cf',
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
            RaisedButton(
                child: Text('Get User'),
                onPressed: () async {
                  _displayTextInputDialog(context);
                }),
            RaisedButton(
                child: Text('Toogle Listener'),
                onPressed: () async {
                  setState(() {
                    myUser = "updating user listener status..";
                  });
                  try {
                    await RoamFlutter.toggleListener(
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
            RaisedButton(
                child: Text('Toogle Events'),
                onPressed: () async {
                  setState(() {
                    myUser = "updating user events status..";
                  });
                  try {
                    await RoamFlutter.toggleEvents(
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
            RaisedButton(
                child: Text('Get Listener Status'),
                onPressed: () async {
                  setState(() {
                    myUser = "fetching user listener status..";
                  });
                  try {
                    await RoamFlutter.getListenerStatus(callBack: ({user}) {
                      setState(() {
                        myUser = user;
                      });
                      print(user);
                    });
                  } on PlatformException {
                    print('Get Listener Status Error');
                  }
                }),
            RaisedButton(
                child: Text('Logout User'),
                onPressed: () async {
                  try {
                    await RoamFlutter.logoutUser();
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
            RaisedButton(
                child: Text('Subscribe Location'),
                onPressed: () async {
                  setState(() {
                    myUser = "user location subscribed";
                  });
                  try {
                    await RoamFlutter.subscribeLocation();
                  } on PlatformException {
                    print('Subscribe Location Error');
                  }
                }),
            RaisedButton(
                child: Text('Subscribe User Location'),
                onPressed: () async {
                  try {
                    setState(() {
                      myUser = "user location subscribed";
                    });
                    await RoamFlutter.subscribeUserLocation(
                        userId: '60181b1f521e0249023652bc');
                  } on PlatformException {
                    print('Subscribe User Location Error');
                  }
                }),
            RaisedButton(
                child: Text('Subscribe Events'),
                onPressed: () async {
                  try {
                    setState(() {
                      myUser = "user events subscribed";
                    });
                    await RoamFlutter.subscribeEvents();
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
            RaisedButton(
                child: Text('Enable Accuracy Engine'),
                onPressed: () async {
                  setState(() {
                    isAccuracyEngineEnabled = true;
                  });
                  try {
                    await RoamFlutter.enableAccuracyEngine();
                  } on PlatformException {
                    print('Enable Accuracy Engine Error');
                  }
                }),
            RaisedButton(
                child: Text('Disable Accuracy Engine'),
                onPressed: () async {
                  setState(() {
                    isAccuracyEngineEnabled = false;
                  });
                  try {
                    await RoamFlutter.disableAccuracyEngine();
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
            RaisedButton(
                child: Text('Update Current Location'),
                onPressed: () async {
                  try {
                    await RoamFlutter.updateCurrentLocation(accuracy: 100);
                  } on PlatformException {
                    print('Update Current Location Error');
                  }
                }),
            RaisedButton(
                child: Text('Start Tracking'),
                onPressed: () async {
                  try {
                    // Map<String, dynamic> trackingOptions = {
                    //   "activityType": "fitness",
                    //   "pausesLocationUpdatesAutomatically": true,
                    //   "showsBackgroundLocationIndicator": true,
                    //   "distanceFilter": 10,
                    //   "useSignificantLocationChanges": false,
                    //   "useRegionMonitoring": false,
                    //   "useVisits": false,
                    //   "desiredAccuracy": "nearestTenMeters"
                    // };
                    await RoamFlutter.startTracking(trackingMode: 'active');
                  } on PlatformException {
                    print('Start Tracking Error');
                  }
                }),
            RaisedButton(
                child: Text('Stop Tracking'),
                onPressed: () async {
                  try {
                    await RoamFlutter.stopTracking();
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
