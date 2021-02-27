import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location/location.dart';

import 'package:trackme/util.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme:
          ThemeData(accentColor: Colors.green, disabledColor: Colors.grey[400]),
      home: MyHomePage(title: 'Track Me!'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState();

  var _urlController;
  var _txtController;
  var _srcController = TextEditingController();
  var _destController = TextEditingController();
  var _truckController = TextEditingController();

  @override
  void initState() {
    _urlController =
        TextEditingController(text: 'http://192.168.43.180:3000/feast/a');
    _txtController =
        TextEditingController(text: 'Logs will be displayed here....');
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  bool shouldTrack = false;
  bool enableFields = true;

  Future<LocationData> _getCoordinates(Location _location) {
    return _location.getLocation();
  }

  Map<String, dynamic> getMyDetails(LocationData _locationData) {
    print(
      "Longitude: ${_locationData.longitude}; Latitude: ${_locationData.latitude}; Time: ${_locationData.time}",
    );

    Map<String, dynamic> details = {
      "source": _srcController.text,
      "dest": _destController.text,
      "truckNum": _truckController.text,
      "longitude": _locationData.longitude,
      "latitude": _locationData.latitude,
      "time": _locationData.time
    };
    return details;
  }

  appendLog(String log) {
    setState(() {
      _txtController.text = log;
    });
  }

  @override
  Widget build(BuildContext context) {
    Location location = Location();
    Util.askAccess(context, location);

    Timer.periodic(Duration(seconds: 10), (timer) {
      if (shouldTrack) {
        bool hasAccess = true;
        // checkAccess(location).then((bool value) => hasAccess = value);
        if (hasAccess) {
          print('Tracking the device. \n${DateTime.now().toString()}');
          appendLog('Tracking the device. \n${DateTime.now().toString()}');
          _getCoordinates(location).then((_locationData) {
            var details = getMyDetails(_locationData);
            Util.exportData(_urlController.text, details);
          });
        }
      } else {
        var msg = 'Not tracking the device!';
        print(msg);
        appendLog(msg);
      }
    });

    var appBar = AppBar(
      backgroundColor: Colors.white,
      title: Text(
        widget.title,
        style: TextStyle(color: Colors.green),
      ),
    );

    var safeHeight =
        MediaQuery.of(context).size.height - appBar.preferredSize.height - 10;

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Container(
          height: safeHeight,
          color: Colors.grey[200],
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Text(
                          'Enter Details',
                          style: TextStyle(fontSize: 17),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: MediaQuery.of(context).size.width - 35,
                    child: Card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.all(15.0),
                            child: Image.asset(
                              'assets/images/chain.png',
                              height: 25,
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 110,
                            child: TextFormField(
                              enabled: enableFields,
                              controller: _urlController,
                              decoration: InputDecoration(
                                labelText: 'URL',
                                border: InputBorder.none,
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                return (value.isEmpty)
                                    ? "Please enter the API URL!"
                                    : null;
                              },
                              style: TextStyle(
                                  color: (enableFields)
                                      ? Colors.black
                                      : Theme.of(context).disabledColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    width: MediaQuery.of(context).size.width - 35,
                    child: Card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.all(15.0),
                            child: Image.asset(
                              'assets/images/depot.png',
                              height: 25,
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 110,
                            child: TextFormField(
                              enabled: enableFields,
                              controller: _srcController,
                              decoration: InputDecoration(
                                labelText: 'Source Depot Name',
                                border: InputBorder.none,
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                return (value.isEmpty)
                                    ? "Please enter the Source Depot name!"
                                    : null;
                              },
                              style: TextStyle(
                                  color: (enableFields)
                                      ? Colors.black
                                      : Theme.of(context).disabledColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    width: MediaQuery.of(context).size.width - 35,
                    child: Card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.all(15.0),
                            child: Image.asset(
                              'assets/images/truck.png',
                              height: 25,
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 110,
                            child: TextFormField(
                              enabled: enableFields,
                              controller: _truckController,
                              decoration: InputDecoration(
                                labelText: 'Truck Number',
                                border: InputBorder.none,
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                return (value.isEmpty)
                                    ? "Please enter the Truck Number!"
                                    : null;
                              },
                              style: TextStyle(
                                  color: (enableFields)
                                      ? Colors.black
                                      : Theme.of(context).disabledColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    width: MediaQuery.of(context).size.width - 35,
                    child: Card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.all(15.0),
                            child: Image.asset(
                              'assets/images/depot.png',
                              height: 25,
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 110,
                            child: TextFormField(
                              enabled: enableFields,
                              controller: _destController,
                              decoration: InputDecoration(
                                labelText: 'Destination Depot Name',
                                border: InputBorder.none,
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                return (value.isEmpty)
                                    ? "Please enter the Destination Depot name!"
                                    : null;
                              },
                              style: TextStyle(
                                  color: (enableFields)
                                      ? Colors.black
                                      : Theme.of(context).disabledColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width - 35,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                              fixedSize: MaterialStateProperty.all<Size>(
                                  Size(150, 45)),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.green)),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                enableFields = false;
                                shouldTrack = true;
                              });
                            }
                          },
                          child: Text(
                            'Track',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                              fixedSize: MaterialStateProperty.all<Size>(
                                  Size(150, 45)),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.grey)),
                          onPressed: () {
                            setState(() {
                              enableFields = true;
                              shouldTrack = false;
                            });
                          },
                          child: Text(
                            'Stop',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(5),
                    width: MediaQuery.of(context).size.width - 35,
                    child: TextField(
                      controller: _txtController,
                      enabled: false,
                      maxLines: null,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
