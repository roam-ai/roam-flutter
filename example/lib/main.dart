import 'dart:convert';

import 'package:example/logger.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:roam_flutter/RoamTrackingMode.dart';
import 'package:roam_flutter/roam_flutter.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:roam_flutter/trips_v2/RoamTrip.dart';
import 'package:roam_flutter/trips_v2/models/Geometry.dart';
import 'package:roam_flutter/trips_v2/request/RoamTripStops.dart';

Future<void> main() async {
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
            "bbbf78b0184d74b026437d4bb51df89798ba4c015b3d39dae8c6d3a8fcc0222d");
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
                    await Permission.locationWhenInUse.request();
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
                            'bbbf78b0184d74b026437d4bb51df89798ba4c015b3d39dae8c6d3a8fcc0222d');
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
  String response;

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
                      // case "getTripStatus":
                      //   Roam.getTripStatus(
                      //       tripId: tripId,
                      //       callBack: ({trip}) {
                      //         setState(() {
                      //           myTrip = trip;
                      //         });
                      //         print(trip);
                      //       });
                      //   break;
                      //
                      case "getTrip":
                        // Roam.getTrip(tripId, ({roamTripResponse}) {
                        //   String responseString =
                        //       jsonEncode(roamTripResponse?.toJson());
                        //   print('Get trip response: $responseString');
                        //   CustomLogger.writeLog(responseString);
                        //   setState(() {
                        //     tripId = roamTripResponse?.tripDetails?.id;
                        //   });
                        // }, ({error}) {
                        //   String errorString = jsonEncode(error?.toJson());
                        //   print('Error: $errorString');
                        //   CustomLogger.writeLog(errorString);
                        // });
                        break;

                      case "subscribeTrip":
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
                        // Roam.startTrip(({roamTripResponse}) {
                        //   String responseString =
                        //       jsonEncode(roamTripResponse?.toJson());
                        //   print('Start trip response: $responseString');
                        //   CustomLogger.writeLog(responseString);
                        //   setState(() {
                        //     tripId = roamTripResponse?.tripDetails?.id;
                        //   });
                        // }, ({error}) {
                        //   String errorString = jsonEncode(error?.toJson());
                        //   print('Error: $errorString');
                        //   CustomLogger.writeLog(errorString);
                        // }, tripId: tripId);
                        break;

                      case "quickTrip":
                        // RoamTrip quickTrip = RoamTrip(false);
                        // Roam.startTrip(({roamTripResponse}) {
                        //   String responseString =
                        //       jsonEncode(roamTripResponse?.toJson());
                        //   print('Start quick trip response: $responseString');
                        //   CustomLogger.writeLog(
                        //       'Start quick trip response: $responseString');
                        //   setState(() {
                        //     tripId = roamTripResponse?.tripDetails?.id;
                        //   });
                        // }, ({error}) {
                        //   String errorString = jsonEncode(error?.toJson());
                        //   print('Error: $errorString');
                        //   CustomLogger.writeLog(errorString);
                        // },
                        //     roamTrip: quickTrip,
                        //     roamTrackingMode: RoamTrackingMode.time(5,
                        //         desiredAccuracy: DesiredAccuracy.HIGH));
                        break;

                      case "updateTrip":
                        // RoamTrip updateTrip = RoamTrip(false);
                        // updateTrip.description = "test description";
                        // Roam.updateTrip(updateTrip, ({roamTripResponse}) {
                        //   String responseString =
                        //       jsonEncode(roamTripResponse?.toJson());
                        //   print('Update trip response: $responseString');
                        //   CustomLogger.writeLog('Update trip response: $responseString');
                        //   setState(() {
                        //     tripId = roamTripResponse?.tripDetails?.id;
                        //   });
                        // }, ({error}) {
                        //   String errorString = jsonEncode(error?.toJson());
                        //   print('Error: $errorString');
                        //   CustomLogger.writeLog(errorString);
                        // });
                        break;

                      case "pauseTrip":
                        // Roam.pauseTrip(tripId, ({roamTripResponse}) {
                        //   String responseString =
                        //       jsonEncode(roamTripResponse?.toJson());
                        //   print('Pause trip response: $responseString');
                        //   CustomLogger.writeLog(responseString);
                        //   setState(() {
                        //     tripId = roamTripResponse?.tripDetails?.id;
                        //   });
                        // }, ({error}) {
                        //   String errorString = jsonEncode(error?.toJson());
                        //   print('Error: $errorString');
                        //   CustomLogger.writeLog(errorString);
                        // });
                        break;

                      case "resumeTrip":
                        // Roam.resumeTrip(tripId, ({roamTripResponse}) {
                        //   String responseString =
                        //       jsonEncode(roamTripResponse?.toJson());
                        //   print('Resume trip response: $responseString');
                        //   CustomLogger.writeLog(responseString);
                        //   setState(() {
                        //     tripId = roamTripResponse?.tripDetails?.id;
                        //   });
                        // }, ({error}) {
                        //   String errorString = jsonEncode(error?.toJson());
                        //   print('Error: $errorString');
                        //   CustomLogger.writeLog(errorString);
                        // });
                        break;

                      case "endTrip":
                        // Roam.endTrip(tripId, false, ({roamTripResponse}) {
                        //   String responseString =
                        //       jsonEncode(roamTripResponse?.toJson());
                        //   print('End trip response: $responseString');
                        //   CustomLogger.writeLog(responseString);
                        //   setState(() {
                        //     tripId = roamTripResponse?.tripDetails?.id;
                        //   });
                        // }, ({error}) {
                        //   String errorString = jsonEncode(error?.toJson());
                        //   print('Error: $errorString');
                        //   CustomLogger.writeLog(errorString);
                        // });
                        break;

                      case "syncTrip":
                        // Roam.syncTrip(tripId, ({roamSyncTripResponse}) {
                        //   String responseString =
                        //       jsonEncode(roamSyncTripResponse?.toJson());
                        //   print('End trip response: $responseString');
                        //   CustomLogger.writeLog(responseString);
                        // }, ({error}) {
                        //   String errorString = jsonEncode(error?.toJson());
                        //   print('Error: $errorString');
                        //   CustomLogger.writeLog(errorString);
                        // });
                        break;

                      case "deleteTrip":
                        // Roam.deleteTrip(tripId, ({roamDeleteTripResponse}) {
                        //   String responseString =
                        //       jsonEncode(roamDeleteTripResponse?.toJson());
                        //   print('Delete trip response: $responseString}');
                        //   CustomLogger.writeLog(responseString);
                        //   setState(() {
                        //     tripId = roamDeleteTripResponse?.trip?.id;
                        //   });
                        // }, ({error}) {
                        //   String errorString = jsonEncode(error?.toJson());
                        //   print('Error: $errorString');
                        //   CustomLogger.writeLog(errorString);
                        // });
                        break;

                      case "getTripSummary":
                        // Roam.getTripSummary(tripId, ({roamTripResponse}) {
                        //   String responseString =
                        //       jsonEncode(roamTripResponse?.toJson());
                        //   print('End trip response: $responseString');
                        //   CustomLogger.writeLog(responseString);
                        //   setState(() {
                        //     tripId = roamTripResponse?.tripDetails?.id;
                        //   });
                        // }, ({error}) {
                        //   String errorString = jsonEncode(error?.toJson());
                        //   print('Error: $errorString');
                        //   CustomLogger.writeLog(errorString);
                        // });
                        break;

                      case "getActiveTrips":
                        // Roam.getActiveTrips(false, ({roamActiveTripResponse}) {
                        //   String responseString =
                        //       jsonEncode(roamActiveTripResponse?.toJson());
                        //   print('Get active trips response: $responseString}');
                        //   CustomLogger.writeLog(responseString);
                        // }, ({error}) {
                        //   String errorString = jsonEncode(error?.toJson());
                        //   print('Error: $errorString');
                        //   CustomLogger.writeLog(errorString);
                        // });
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
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SelectableText(
                  '\nTrip Details:\n $tripId\n\n$response',
                  textAlign: TextAlign.center,
                ),
                ElevatedButton(
                    child: Text('Create Online Trip'),
                    onPressed: () async {
                      setState(() {
                        response = "creating trip..";
                      });
                      try {


                        RoamTripStops stop =
                            RoamTripStops(600, [77.63414185889549,12.915192126794398]);
                        RoamTrip roamTrip = RoamTrip(isLocal: false);
                        roamTrip.stop.add(stop);
                        Roam.createTrip(roamTrip, ({roamTripResponse}) {
                          String responseString =
                              jsonEncode(roamTripResponse?.toJson());
                          print('Create online trip response: $responseString');
                          CustomLogger.writeLog(
                              'Create online trip response: $responseString');
                          setState(() {
                            tripId = roamTripResponse.tripDetails.id;
                            response = 'Create online trip response: $responseString';
                            print(jsonEncode(roamTripResponse?.toJson()));
                          });
                        }, ({error}) {
                          String errorString = jsonEncode(error?.toJson());
                          print(errorString);
                          setState(() {
                            response = errorString;
                          });
                          CustomLogger.writeLog(errorString);
                        });
                      } on PlatformException {
                        print('Create Trip Error');
                      }
                    }),
                ElevatedButton(
                    child: Text('Create Offline Trip'),
                    onPressed: () async {
                      setState(() {
                        response = "creating trip..";
                      });
                      try {


                        RoamTripStops stop =
                        RoamTripStops(600, [77.63414185889549,12.915192126794398]);
                        RoamTrip roamTrip = RoamTrip(isLocal: true);
                        roamTrip.stop.add(stop);
                        Roam.createTrip(roamTrip, ({roamTripResponse}) {
                          String responseString =
                          jsonEncode(roamTripResponse?.toJson());
                          print('Create offline trip response: $responseString');
                          CustomLogger.writeLog(
                              'Create offline trip response: $responseString');
                          setState(() {
                            tripId = roamTripResponse.tripDetails.id;
                            response = 'Create offline trip response: $responseString';
                            print(jsonEncode(roamTripResponse?.toJson()));
                          });
                        }, ({error}) {
                          String errorString = jsonEncode(error?.toJson());
                          print(errorString);
                          setState(() {
                            response = errorString;
                          });
                          CustomLogger.writeLog(errorString);
                        });
                      } on PlatformException {
                        print('Create Trip Error');
                      }
                    }),
                ElevatedButton(
                    child: Text('Get Trip'),
                    onPressed: () async {
                      try {
                        Roam.getTrip(tripId, ({roamTripResponse}) {
                          String responseString =
                              jsonEncode(roamTripResponse?.toJson());
                          print('Get trip response: $responseString');
                          CustomLogger.writeLog(
                              'Get trip response: $responseString');
                          setState(() {
                            //tripId = roamTripResponse?.tripDetails?.id;
                            response = 'Get trip response: $responseString';
                          });
                        }, ({error}) {
                          String errorString = jsonEncode(error?.toJson());
                          print('Error: $errorString');
                          CustomLogger.writeLog(errorString);
                          setState(() {
                            response = errorString;
                          });
                        });
                      } catch (error) {
                        print(error);
                      }
                      //_displayTripsInputDialog(context, "getTrip");
                    }),
                // ElevatedButton(
                //     child: Text('Subscribe Trip Status'),
                //     onPressed: () async {
                //       setState(() {
                //         myTrip = 'trip subscribed';
                //       });
                //       try {
                //         _displayTripsInputDialog(context, "subscribeTrip");
                //       } on PlatformException {
                //         print('Subscribe Trip Status Error');
                //       }
                //     }),
                // ElevatedButton(
                //     child: Text('Unsubscribe Trip Status'),
                //     onPressed: () async {
                //       setState(() {
                //         myTrip = 'trip unsubscribed';
                //       });
                //       try {
                //         _displayTripsInputDialog(context, "unSubscribeTripStatus");
                //       } on PlatformException {
                //         print('Unsubscribe Trip Status Error');
                //       }
                //     }),
                ElevatedButton(
                    child: Text('Start Trip'),
                    onPressed: () async {
                      try {
                        // _displayTripsInputDialog(context, "startTrip");
                        Roam.startTrip(({roamTripResponse}) {
                          String responseString =
                              jsonEncode(roamTripResponse?.toJson());
                          print('Start trip response: $responseString');
                          CustomLogger.writeLog(
                              'Start trip response: $responseString');
                          setState(() {
                            //tripId = roamTripResponse?.tripDetails?.id;
                            response = 'Start trip response: $responseString';
                          });
                        }, ({error}) {
                          String errorString = jsonEncode(error?.toJson());
                          print('Error: $errorString');
                          CustomLogger.writeLog(errorString);
                          setState(() {
                            response = errorString;
                          });
                        }, tripId: tripId);
                      } on PlatformException {
                        print('Start Trip Error');
                      }
                    }),
                ElevatedButton(
                    child: Text('Start Online Quick Trip'),
                    onPressed: () async {
                      try {

                        // _displayTripsInputDialog(context, "quickTrip");
                        RoamTrip quickTrip = RoamTrip(isLocal: false);
                        RoamTripStops stop =
                        RoamTripStops(600, [77.63414185889549,12.915192126794398]);
                        quickTrip.stop.add(stop);
                        Roam.startTrip(({roamTripResponse}) {
                          String responseString =
                              jsonEncode(roamTripResponse?.toJson());
                          print('Online Quick trip response: $responseString');
                          CustomLogger.writeLog(
                              'Online Quick trip response: $responseString');
                          setState(() {
                            tripId = roamTripResponse?.tripDetails?.id;
                            response = 'Online Quick trip response: $responseString';
                          });
                        }, ({error}) {
                          String errorString = jsonEncode(error?.toJson());
                          print('Error: $errorString');
                          CustomLogger.writeLog(errorString);
                          setState(() {
                            response = errorString;
                          });
                        },
                            roamTrip: quickTrip,
                            roamTrackingMode: RoamTrackingMode.time(5,
                                desiredAccuracy: DesiredAccuracy.HIGH));
                      } on PlatformException {
                        print('Quick Trip Error');
                      }
                    }),
                ElevatedButton(
                    child: Text('Start Offline Quick Trip'),
                    onPressed: () async {
                      try {

                        // _displayTripsInputDialog(context, "quickTrip");
                        RoamTrip quickTrip = RoamTrip(isLocal: true);
                        RoamTripStops stop =
                        RoamTripStops(600, [77.63414185889549,12.915192126794398]);
                        quickTrip.stop.add(stop);
                        Roam.startTrip(({roamTripResponse}) {
                          String responseString =
                          jsonEncode(roamTripResponse?.toJson());
                          print('Offline Quick trip response: $responseString');
                          CustomLogger.writeLog(
                              'Offline Quick trip response: $responseString');
                          setState(() {
                            tripId = roamTripResponse?.tripDetails?.id;
                            response = 'Offline Quick trip response: $responseString';
                          });
                        }, ({error}) {
                          String errorString = jsonEncode(error?.toJson());
                          print('Error: $errorString');
                          CustomLogger.writeLog(errorString);
                          setState(() {
                            response = errorString;
                          });
                        },
                            roamTrip: quickTrip,
                            roamTrackingMode: RoamTrackingMode.time(5,
                                desiredAccuracy: DesiredAccuracy.HIGH));
                      } on PlatformException {
                        print('Quick Trip Error');
                      } catch (error){
                        print(error);
                      }
                    }),
                ElevatedButton(
                    child: Text('Update Online Trip'),
                    onPressed: () async {
                      try {
                        print('update trip id: ' + tripId);
                        RoamTrip updateTrip = RoamTrip(tripId: tripId);
                        updateTrip.isLocal = false;
                        updateTrip.description = "test description";
                        Roam.updateTrip(updateTrip, ({roamTripResponse}) {
                          String responseString =
                              jsonEncode(roamTripResponse?.toJson());
                          print('Update trip response: $responseString');
                          CustomLogger.writeLog(
                              'Update trip response: $responseString');
                          setState(() {
                            tripId = roamTripResponse?.tripDetails?.id;
                            response = 'Update trip response: $responseString';
                          });
                        }, ({error}) {
                          String errorString = jsonEncode(error?.toJson());
                          print('Error: $errorString');
                          CustomLogger.writeLog(errorString);
                          response = errorString;
                        });
                        //_displayTripsInputDialog(context, "updateTrip");
                      } on PlatformException {
                        print('Update Trip Error');
                      }
                    }),
                ElevatedButton(
                    child: Text('Update Offline Trip'),
                    onPressed: () async {
                      try {
                        print('update trip id: ' + tripId);
                        RoamTrip updateTrip = RoamTrip(tripId: tripId);
                        updateTrip.isLocal = true;
                        updateTrip.description = "test description";
                        Roam.updateTrip(updateTrip, ({roamTripResponse}) {
                          String responseString =
                          jsonEncode(roamTripResponse?.toJson());
                          print('Update trip response: $responseString');
                          CustomLogger.writeLog(
                              'Update trip response: $responseString');
                          setState(() {
                            tripId = roamTripResponse?.tripDetails?.id;
                            response = 'Update trip response: $responseString';
                          });
                        }, ({error}) {
                          String errorString = jsonEncode(error?.toJson());
                          print('Error: $errorString');
                          CustomLogger.writeLog(errorString);
                          response = errorString;
                        });
                        //_displayTripsInputDialog(context, "updateTrip");
                      } on PlatformException {
                        print('Update Trip Error');
                      }
                    }),
                ElevatedButton(
                    child: Text('Pause Trip'),
                    onPressed: () async {
                      try {
                        Roam.pauseTrip(tripId, ({roamTripResponse}) {
                          String responseString =
                              jsonEncode(roamTripResponse?.toJson());
                          print('Pause trip response: $responseString');
                          CustomLogger.writeLog(
                              'Pause trip response: $responseString');
                          setState(() {
                            //tripId = roamTripResponse?.tripDetails?.id;
                            response = 'Pause trip response: $responseString';
                          });
                        }, ({error}) {
                          String errorString = jsonEncode(error?.toJson());
                          print('Error: $errorString');
                          setState(() {
                            response = errorString;
                          });
                          CustomLogger.writeLog(errorString);
                        });
                        //_displayTripsInputDialog(context, "pauseTrip");
                      } on PlatformException {
                        print('Pause Trip Error');
                      }
                    }),
                ElevatedButton(
                    child: Text('Resume Trip'),
                    onPressed: () async {
                      try {
                        Roam.resumeTrip(tripId, ({roamTripResponse}) {
                          String responseString =
                              jsonEncode(roamTripResponse?.toJson());
                          print('Resume trip response: $responseString');
                          CustomLogger.writeLog(
                              'Resume trip response: $responseString');
                          setState(() {
                            response = 'Resume trip response: $responseString';
                            //tripId = roamTripResponse?.tripDetails?.id;
                          });
                        }, ({error}) {
                          String errorString = jsonEncode(error?.toJson());
                          print('Error: $errorString');
                          setState(() {
                            response = errorString;
                          });
                          CustomLogger.writeLog(errorString);
                        });
                        //_displayTripsInputDialog(context, "resumeTrip");
                      } on PlatformException {
                        print('Resume Trip Error');
                      }
                    }),
                ElevatedButton(
                    child: Text('End Trip'),
                    onPressed: () async {
                      try {
                        Roam.endTrip(tripId, false, ({roamTripResponse}) {
                          String responseString =
                              jsonEncode(roamTripResponse?.toJson());
                          print('End trip response: $responseString');
                          CustomLogger.writeLog(
                              'End trip response: $responseString');
                          setState(() {
                            //tripId = roamTripResponse?.tripDetails?.id;
                            response = 'End trip response: $responseString';
                          });
                        }, ({error}) {
                          String errorString = jsonEncode(error?.toJson());
                          print('Error: $errorString');
                          CustomLogger.writeLog(errorString);
                          setState(() {
                            response = errorString;
                          });
                        });
                        //_displayTripsInputDialog(context, "endTrip");
                      } on PlatformException {
                        print('End Trip Error');
                      }
                    }),
                ElevatedButton(
                    child: Text('Sync Trip'),
                    onPressed: () async {
                      try {
                        Roam.syncTrip(tripId, ({roamSyncTripResponse}) {
                          String responseString =
                              jsonEncode(roamSyncTripResponse?.toJson());
                          print('Sync trip response: $responseString');
                          CustomLogger.writeLog(
                              'Sync trip response: $responseString');
                          setState(() {
                            response = 'Sync trip response: $responseString';
                          });
                        }, ({error}) {
                          String errorString = jsonEncode(error?.toJson());
                          print('Error: $errorString');
                          CustomLogger.writeLog(errorString);
                          setState(() {
                            response = errorString;
                          });
                        });
                        //_displayTripsInputDialog(context, "syncTrip");
                      } on PlatformException {
                        print('Sync Trip Error');
                      }
                    }),
                ElevatedButton(
                    child: Text('Delete Trip'),
                    onPressed: () async {
                      try {
                        Roam.deleteTrip(tripId, ({roamDeleteTripResponse}) {
                          String responseString =
                              jsonEncode(roamDeleteTripResponse?.toJson());
                          print('Delete trip response: $responseString}');
                          CustomLogger.writeLog(responseString);
                          setState(() {
                            //tripId = roamDeleteTripResponse?.trip?.id;
                            response = 'Delete trip response: $responseString}';
                          });
                        }, ({error}) {
                          String errorString = jsonEncode(error?.toJson());
                          print('Error: $errorString');
                          CustomLogger.writeLog(errorString);
                          setState(() {
                            response = errorString;
                          });
                        });
                        //_displayTripsInputDialog(context, "deleteTrip");
                      } on PlatformException {
                        print('Delete Trip Error');
                      }
                    }),
                ElevatedButton(
                    child: Text('Get Active Trips'),
                    onPressed: () async {
                      try {
                        Roam.getActiveTrips(false, ({roamActiveTripResponse}) {
                          String responseString =
                              jsonEncode(roamActiveTripResponse?.toJson());
                          print('Get active trips response: $responseString}');
                          CustomLogger.writeLog(responseString);
                          setState(() {
                            response = 'Get active trips response: $responseString}';
                          });
                        }, ({error}) {
                          String errorString = jsonEncode(error?.toJson());
                          print('Error: $errorString');
                          CustomLogger.writeLog(errorString);
                          setState(() {
                            response = errorString;
                          });
                        });
                        //_displayTripsInputDialog(context, "getActiveTrips");
                      } on PlatformException {
                        print('Get Active Trips Error');
                      }
                    }),
                ElevatedButton(
                    child: Text('Get Trip Summary'),
                    onPressed: () async {
                      setState(() {
                        response = "fetching trip summary..";
                      });
                      try {
                        Roam.getTripSummary(tripId, ({roamTripResponse}) {
                          String responseString =
                              jsonEncode(roamTripResponse?.toJson());
                          print('trip summary response: $responseString');
                          CustomLogger.writeLog(
                              'trip summary response: $responseString');
                          setState(() {
                            //tripId = roamTripResponse?.tripDetails?.id;
                            response = 'Trip summary response: $responseString';
                          });
                        }, ({error}) {
                          String errorString = jsonEncode(error?.toJson());
                          print('Error: $errorString');
                          CustomLogger.writeLog(errorString);
                          setState(() {
                            response = errorString;
                          });
                        });
                        //_displayTripsInputDialog(context, "getTripSummary");
                      } on PlatformException {
                        print('Get Trip Summary Error');
                      }
                    }),
              ],
            ),
          ),
        ));
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
                          Roam.offlineTracking(true);
                          Roam.allowMockLocation(allow: true);
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
                    await Roam.updateCurrentLocation(
                        accuracy: 100, jsonObject: testMetaData);
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
