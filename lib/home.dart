import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:testapp/bluetooth/bluetooth.dart';
import 'package:testapp/camera_stream.dart';
import 'package:testapp/placeholder.dart';

class Home extends StatefulWidget {
  final List<CameraDescription> cameras;

  const Home({Key key, this.cameras}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomeState(cameras);
  }
}

class _HomeState extends State<Home> {
  final List<CameraDescription> cameras;

  int _currentIndex = 0;
  final List<Widget> _children;

  _HomeState(this.cameras)
      : _children = [
          CameraStream(cameras),
          // TODO: add video imports
          PlaceholderWidget(Colors.green),
        ];

  // Bluetooth State
  bool _bluetoothConnected = false;
  FlutterBluetoothSerial _device;

  setBluetooth(bluetoothConnected, device){
    setState(() {
      _bluetoothConnected = bluetoothConnected;
      _device = device;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Object Detection'), actions: <Widget>[
        // action button
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            Navigator.of(context).pushNamed('/settings');
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
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            title: Text('Camera'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.videocam),
            title: Text('Video'),
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
