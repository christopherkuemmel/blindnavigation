import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:testapp/bluetooth/bluetooth.dart';
import 'package:testapp/camera_stream.dart';
import 'package:testapp/lndw/recognition_heuristic.dart';
import 'package:testapp/settings.dart';

class Home extends StatefulWidget {
  final List<CameraDescription> cameras;

  const Home({Key key, this.cameras}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<dynamic> _recognitions;
  bool _detectModeOn = false;

  double _appBarHeight = AppBar().preferredSize.height;

  setRecognitions(recognitions, imageHeight, imageWidth) {
    setState(() {
      _recognitions = recognitions;
      // _imageHeight = imageHeight;
      // _imageWidth = imageWidth;
    });
    if (_device != null) RecognitionHeuristic().sendRequestBasedOnRecognitions(_recognitions, _device);
  }

  // Bluetooth State
  bool _bluetoothConnected = false;
  FlutterBluetoothSerial _device;

  // Settings
  int _resolution = 2;
  double _framerate = 1.0;

  setBluetooth(bluetoothConnected, device){
    setState(() {
      _bluetoothConnected = bluetoothConnected;
      _device = device;
    });
  }

  setSettings(resolution, framerate){
    setState(() {
      _resolution = resolution;
      _framerate = framerate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Object Detection'), actions: <Widget>[
        Switch(
          value: _detectModeOn,
          onChanged: (value) => setState(() => _detectModeOn = value)
        ),
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Settings(setSettings, _resolution, _framerate)));
          },
        ),
        IconButton(
          icon: Icon(Icons.bluetooth),
          color: _bluetoothConnected ? Colors.blue : Colors.white,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Bluetooth(setBluetooth)));
          },
        ),
      ]),
      body: CameraStream(widget.cameras, _resolution, _framerate, setRecognitions, _detectModeOn, _appBarHeight),
    );
  }
}
