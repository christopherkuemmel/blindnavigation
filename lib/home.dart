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
  bool _screenOn = false;

  double _appBarHeight = AppBar().preferredSize.height;

  setRecognitions(recognitions, imageHeight, imageWidth) {
    setState(() {
      _recognitions = recognitions;
      // _imageHeight = imageHeight;
      // _imageWidth = imageWidth;
    });
    if (_device != null) RecognitionHeuristic().sendRequestBasedOnRecognitions(_recognitions, _device, _recognitionThreshold, _landscapeCutOff);
  }

  // Bluetooth State
  bool _bluetoothConnected = false;
  FlutterBluetoothSerial _device;
  double _recognitionThreshold;
  double _landscapeCutOff;

  // Settings
  int _resolution = 0;
  double _framerate = 1.0;

  setBluetooth(bluetoothConnected, device, recognitionThreshold, landscapeCutOff){
    setState(() {
      _bluetoothConnected = bluetoothConnected;
      _device = device;
      _recognitionThreshold = recognitionThreshold;
      _landscapeCutOff = landscapeCutOff;
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
          inactiveThumbColor: Colors.red,
          activeColor: Colors.red,
          value: _detectModeOn,
          onChanged: (value) => setState(() => _detectModeOn = value)
        ),
        Switch(
          value: _screenOn,
          onChanged: (value) => setState(() => _screenOn = value)
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
      body: CameraStream(widget.cameras, _resolution, _framerate, setRecognitions, _detectModeOn, _screenOn, _appBarHeight),
    );
  }
}
