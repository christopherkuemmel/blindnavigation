import 'dart:math';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:testapp/bluetooth/vibrotac/vibrotac.dart';

class RecognitionHeuristic {
  // TODO: make use of ClassificationClasses + add more classes
  final List<String> classes = ["chair", "cup"];
  final double detectionProb = 0.4;

  void sendRequestBasedOnRecognitions(List recognitions, FlutterBluetoothSerial device) {
    int duration = 1000;
    double recognitionThreshold = 0.5;

    double intensity = 0.0;
    double highestIntensity = 0.0;
    var largestPrediction;

    // filter chairs with prob
    var filteredPredictions = recognitions.where((recognition) =>
        classes.contains(recognition["detectedClass"]) &&
        recognition["confidenceInClass"] > detectionProb);


    // double _valueIntensity = 0.4;
    // double _elementIntesity = 0.4;
    // if (filteredPredictions.length > 1) {
    //   largestPrediction = filteredPredictions.reduce((value, element) => {
    //         _valueIntensity = max(value["rect"]["w"], value["rect"]["h"]),
    //         _elementIntesity = max(element["rect"]["w"], element["rect"]["h"]),
    //         value = max(_valueIntensity, _elementIntesity),
    //       });
    // }
    // print(largestPrediction);

    filteredPredictions.forEach((prediction) => {
          intensity = max(prediction["rect"]["w"], prediction["rect"]["h"]),
          intensity = intensity / 2,
          if (intensity > highestIntensity)
            {
              highestIntensity = intensity,
              largestPrediction = prediction,
            }
        });

    if (largestPrediction != null && largestPrediction["rect"]["h"] >= recognitionThreshold) {
      if (largestPrediction["rect"]["x"] + (largestPrediction["rect"]["w"] / 2) > 0.5) {
        Vibrotac().sendRightRequest(highestIntensity, duration, device);
        print("Right with center x=${largestPrediction["rect"]["x"] + (largestPrediction["rect"]["w"] / 2)}");
      } else {
        Vibrotac().sendLeftRequest(highestIntensity, duration, device);
        print("Left with center x=${largestPrediction["rect"]["x"] + (largestPrediction["rect"]["w"] / 2)}");
      }
    }

    // filteredPredictions.forEach((prediction) => {
    //       intensity = max(prediction["rect"]["w"], prediction["rect"]["h"]),
    //       intensity = intensity / 2,
    //       if (prediction["rect"]["x"] + (prediction["rect"]["w"] / 2) > 0.5)
    //         {
    //           Vibrotac().sendRightRequest(intensity, duration, device),
    //           print(
    //               "Right with center x=${prediction["rect"]["x"] + (prediction["rect"]["w"] / 2)}")
    //         }
    //       else
    //         {
    //           Vibrotac().sendLeftRequest(intensity, duration, device),
    //           print(
    //               "Left with center x=${prediction["rect"]["x"] + (prediction["rect"]["w"] / 2)}")
    //         }
    //     });
  }
}
