import 'dart:typed_data';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:testapp/bluetooth/vibrotac/utils/cobs.dart';
import 'package:testapp/bluetooth/vibrotac/utils/lrc.dart';
import 'package:testapp/bluetooth/vibrotac/utils/utils.dart';

class Vibrotac {
  void sendRequest(List modules, FlutterBluetoothSerial device) {
    device.isConnected.then((isConnected) {
      if (isConnected) {
        var bytes = List<int>();
        bytes.add(0x42); // start byte for multiple modules
        bytes.add(modules.length);

        for (var module in modules) {
          bytes.add(module['moduleId']);
          bytes.add((module['intensity'] * 100).floor());
          bytes.addAll(Utils().largeIntToUint8List(module['duration'], 2));
        }

        bytes = LRC().calculateAndAddLRC(bytes);
        bytes = COBS().encode(bytes);
        bytes = Utils().xOrBytes(bytes);

        device.writeBytes(Uint8List.fromList(bytes));
      } else {
        throw Error();
      }
    });
  }

  void sendLeftRequest(double intensity, int duration, FlutterBluetoothSerial device) {
    var modules = [
      {'moduleId': 2, 'duration': duration, 'intensity': intensity},
      {'moduleId': 3, 'duration': duration, 'intensity': intensity}
    ];
    sendRequest(modules, device);
  }
  void sendRightRequest(double intensity, int duration, FlutterBluetoothSerial device) {
    var modules = [
      {'moduleId': 5, 'duration': duration, 'intensity': intensity},
      {'moduleId': 6, 'duration': duration, 'intensity': intensity}
    ];
    sendRequest(modules, device);
  }
}
