import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testapp/bluetooth/bluetooth.dart';
import 'package:testapp/home.dart';

import 'settings.dart';
// import 'bluetooth.dart';

List<CameraDescription> cameras;

Future<Null> main() async {
  // set defaults in shared preferences on app start
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('resolution', 0);
  await prefs.setBool('connected', false);

  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error: $e.code\nError Message: $e.message');
  }
  runApp(App(cameras: cameras));
}

class App extends StatelessWidget {
  final List<CameraDescription> cameras;

  const App({Key key, @required this.cameras}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Home(cameras: cameras),
      routes: <String, WidgetBuilder>{
        '/settings': (BuildContext context) => Settings(),
        // '/bluetooth': (BuildContext context) => Bluetooth(),
      },
    );
  }
}