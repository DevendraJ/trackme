import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class Util {
  static void askAccess(BuildContext ctx, Location _location) async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  static Future<bool> checkAccess(Location _location) async {
    bool _serviceEnabled = await _location.serviceEnabled();
    PermissionStatus _permissionGranted = await _location.hasPermission();
    bool hasAccess =
        (_serviceEnabled) && (_permissionGranted != PermissionStatus.granted);
    return hasAccess;
  }

  static void exportData(String url, Map<String, dynamic> details) async {
    print('Sending data');
    var reqBody = jsonEncode(details);
    var headers = {"content-type": "application/json"};
    http.post(url, body: reqBody, headers: headers).then((response) {
      print('Response Status: ${response.statusCode}');
    }).catchError((e) {
      print(e.toString());
    });
  }
}
