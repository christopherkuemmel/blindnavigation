import 'dart:math';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:testapp/bluetooth/vibrotac/vibrotac.dart';

class RecognitionHeuristic {

  // TODO: make use of ClassificationClasses + add more classes
  final List<String> classes = [
    "chair",
    "cup"
    ];
  final double detectionProb = 0.4;

  void sendRequestBasedOnRecognitions(List recognitions, FlutterBluetoothSerial device) {
    double intensity = 0.4;
    int duration = 1000;

    // TODO: filter/calculate size w.r.t. last request

    // filter chairs with prob over 0.6
    var filteredPredictions = recognitions.where((recognition) => classes.contains(recognition["detectedClass"]) && recognition["confidenceInClass"] > detectionProb);

    filteredPredictions.forEach((prediction) => {
      intensity = max(prediction["rect"]["w"], prediction["rect"]["h"]),

      if (prediction["rect"]["x"] + (prediction["rect"]["w"] / 2) > 0.5) {
        Vibrotac().sendRightRequest(intensity, duration, device),
        print("Right with center x=${prediction["rect"]["x"] + (prediction["rect"]["w"] / 2)}")
      }
      else {
        Vibrotac().sendLeftRequest(intensity, duration, device),
        print("Left with center x=${prediction["rect"]["x"] + (prediction["rect"]["w"] / 2)}")
      }
    });
  }
}
