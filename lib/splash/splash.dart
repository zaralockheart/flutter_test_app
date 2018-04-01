import 'dart:async';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/common/utils.dart';
import 'package:untitled/main/main.dart';


class Splash extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MySplash(),
    );
  }
}

class MySplash extends StatefulWidget {

  @override
  _MySplash createState() => new _MySplash();
}

class _MySplash extends State<MySplash> with SingleTickerProviderStateMixin {

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  static final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();

  Future<Null> initPlatformState() async {
    Map<String, dynamic> deviceData;

    final SharedPreferences prefs = await _prefs;

    try {
      if (Platform.isAndroid) {
        deviceData = readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceData = readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    setState(() {
      prefs.setString('device', deviceData['identifierForVendor']);
    });
  }

  void handleTimeout() {
    Navigator.of(context).pushReplacement(
        new MaterialPageRoute(
        builder: (BuildContext context) => new MyHomePage()));
  }

  startTimeout() async {
    var duration = const Duration(seconds: 3);
    return new Timer(duration, handleTimeout);
  }


  @override
  void initState() {
    super.initState();
    startTimeout();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
    );
  }

}