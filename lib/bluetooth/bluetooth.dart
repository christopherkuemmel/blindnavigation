import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:testapp/bluetooth/vibrotac/vibrotac.dart';

typedef void Callback(bool bluetoothConnected, FlutterBluetoothSerial device);

class Bluetooth extends StatefulWidget {
  final Callback setBluetooth;

  Bluetooth(this.setBluetooth);

  @override
  _BluetoothState createState() => _BluetoothState();
}

class _BluetoothState extends State<Bluetooth> {
  // Initializing a global key, as it would help us in showing a SnackBar later
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  // Get the instance of the bluetooth
  FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;

  // Define some variables, which will be required later
  List<BluetoothDevice> _devicesList = [];
  BluetoothDevice _device;
  bool _connected = false;
  bool _pressed = false;

  double _intensitySliderValue = 1.0;
  double _durationSliderValue = 0.1;

  @override
  void initState() {
    super.initState();
    bluetoothConnectionState();
  }

  // We are using async callback for using await
  Future<void> bluetoothConnectionState() async {
    List<BluetoothDevice> devices = [];

    // To get the list of paired devices
    try {
      devices = await bluetooth.getBondedDevices();
    } catch (e) {
      print("Error");
      print(e);
    }

    bluetooth.isConnected.then((isConnected) {
      if (isConnected) {
        setState(() {
          _connected = true;
          _pressed = false;
        });
      }
    });

    // For knowing when bluetooth is connected and when disconnected
    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case FlutterBluetoothSerial.CONNECTED:
          setState(() {
            _connected = true;
            _pressed = false;
          });
          break;

        case FlutterBluetoothSerial.DISCONNECTED:
          setState(() {
            _connected = false;
            _pressed = false;
          });
          widget.setBluetooth(false, null);
          break;

        default:
          print(state);
          break;
      }
    });

    // It is an error to call [setState] unless [mounted] is true.
    if (!mounted) {
      return;
    }

    // Store the [devices] list in the [_devicesList] for accessing
    // the list outside this class
    setState(() {
      _devicesList = devices;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Bluetooth"),
      ),
      body: Container(
        padding: new EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      "Paired Devices",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                )),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Device:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  DropdownButton(
                    items: _getDeviceItems(),
                    // TODO: show already selected/connected device when reloading bluetooth widget
                    onChanged: (value) => setState(() => _device = value),
                    value: _device,
                  ),
                  RaisedButton(
                    onPressed:
                        _pressed ? null : _connected ? _disconnect : _connect,
                    child: Text(_connected ? 'Disconnect' : 'Connect'),
                  ),
                ],
              ),
            ),

            // TODO: single Modules
            // Padding(
            //   padding: const EdgeInsets.only(bottom: 8.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: <Widget>[
            //       Text("Duration"),
            //       Flexible(
            //         flex: 1,
            //         child: Slider(
            //           activeColor: Colors.white,
            //           min: 0.0,
            //           max: 1.0,
            //           onChanged: (newRating) {
            //             setState(() => _durationSliderValue = newRating);
            //           },
            //           value: _durationSliderValue,
            //         ),
            //       ),
            //       Container(
            //         width: 80.0,
            //         alignment: Alignment.center,
            //         child: Text((_durationSliderValue*10000.floor()).toStringAsFixed(0) + " ms")
            //       )
            //     ],
            //   ),
            // ),

            // Left & Right
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Duration"),
                  Flexible(
                    flex: 1,
                    child: Slider(
                      activeColor: Colors.white,
                      min: 0.0,
                      max: 1.0,
                      onChanged: (newRating) {
                        setState(() => _durationSliderValue = newRating);
                      },
                      value: _durationSliderValue,
                    ),
                  ),
                  Container(
                      width: 80.0,
                      alignment: Alignment.center,
                      child: Text((_durationSliderValue * 10000.floor())
                              .toStringAsFixed(0) +
                          " ms"))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Intensity"),
                  Flexible(
                    flex: 1,
                    child: Slider(
                      activeColor: Colors.white,
                      min: 0.0,
                      max: 1.0,
                      onChanged: (newRating) {
                        setState(() => _intensitySliderValue = newRating);
                      },
                      value: _intensitySliderValue,
                    ),
                  ),
                  Container(
                      width: 80.0,
                      alignment: Alignment.center,
                      child: Text(_intensitySliderValue.toStringAsFixed(2)))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    child: Text("LEFT"),
                    onPressed: _sendLeftRequest,
                  ),
                  RaisedButton(
                    child: Text("RIGHT"),
                    onPressed: _sendRightRequest,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Create the List of devices to be shown in Dropdown Menu
  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devicesList.isEmpty) {
      items.add(DropdownMenuItem(
        child: Text('NONE'),
      ));
    } else {
      _devicesList.forEach((device) {
        items.add(DropdownMenuItem(
          child: Text(device.name),
          value: device,
        ));
      });
    }
    return items;
  }

  // Method to connect to bluetooth
  void _connect() {
    if (_device == null) {
      show('No device selected');
    } else {
      bluetooth.isConnected.then((isConnected) {
        if (!isConnected) {
          bluetooth
              .connect(_device)
              .timeout(Duration(seconds: 10))
              .catchError((error) {
            setState(() => _pressed = false);
          });
          setState(() => _pressed = true);
          widget.setBluetooth(true, bluetooth);
        }
      });
    }
  }

  // Method to disconnect bluetooth
  void _disconnect() {
    bluetooth.disconnect();
    setState(() => _pressed = true);
    widget.setBluetooth(false, null);
  }

  void _sendLeftRequest() {
    Vibrotac().sendLeftRequest(_intensitySliderValue,
        (_durationSliderValue * 10000).floor(), bluetooth);
  }

  void _sendRightRequest() {
    Vibrotac().sendRightRequest(_intensitySliderValue,
        (_durationSliderValue * 10000).floor(), bluetooth);
  }

  // Method to show a Snackbar,
  // taking message as the text
  Future show(
    String message, {
    Duration duration: const Duration(seconds: 3),
  }) async {
    await new Future.delayed(new Duration(milliseconds: 100));
    _scaffoldKey.currentState.showSnackBar(
      new SnackBar(
        content: new Text(
          message,
        ),
        duration: duration,
      ),
    );
  }
}
