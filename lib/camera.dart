import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;
import 'package:native_device_orientation/native_device_orientation.dart';

const RES_LOW = 0;
const RES_MED = 1;
const RES_HIGH = 2;

typedef void Callback(List<dynamic> list, int h, int w);

class Camera extends StatefulWidget {
  final List<CameraDescription> cameras;
  final Callback setRecognitions;
  final bool detectModeOn;
  final int resolution;

  Camera(this.cameras, this.setRecognitions, this.detectModeOn, this.resolution);

  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  CameraController controller;
  bool isDetecting = false;
  bool _detectModeOn = true;
  int lastTime = new DateTime.now().millisecondsSinceEpoch;
  ResolutionPreset _resolutionPreset = ResolutionPreset.low;

  @override
  void initState() {
    super.initState();
    if (widget.cameras == null || widget.cameras.length < 1) {
      print('No camera is found');
    } else {
      controller = CameraController(
        widget.cameras[0],
        _resolutionPreset,
      );
      controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});

        controller.startImageStream((CameraImage img) {
          int currentTime = new DateTime.now().millisecondsSinceEpoch;
          // set detection rate
          if (currentTime - lastTime > 1000 && !isDetecting) {
            // if detection is on
            if (_detectModeOn) {
              // just detect if no other process is running
              if (!isDetecting) {
                isDetecting = true;

                int startTime = new DateTime.now().millisecondsSinceEpoch;

                Tflite.detectObjectOnFrame(
                  bytesList: img.planes.map((plane) {
                    return plane.bytes;
                  }).toList(),
                  model: "SSDMobileNet",
                  imageHeight: img.height,
                  imageWidth: img.width,
                  imageMean: 127.5,
                  imageStd: 127.5,
                  numResultsPerClass: 1,
                  threshold: 0.4,
                ).then((recognitions) {
                  print(recognitions);

                  int endTime = new DateTime.now().millisecondsSinceEpoch;
                  print("Detection took ${endTime - startTime}");

                  widget.setRecognitions(recognitions, img.height, img.width);

                  isDetecting = false;
                });
                lastTime = currentTime;
              }
            }
          }
        });
      });
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller.value.isInitialized) {
      return Container();
    }

    var contextSize = MediaQuery.of(context).size;
    var screenH = math.max(contextSize.height, contextSize.width);
    var screenW = math.min(contextSize.height, contextSize.width);
    var previewSize = controller.value.previewSize;
    var previewH = math.max(previewSize.height, previewSize.width);
    var previewW = math.min(previewSize.height, previewSize.width);
    var screenRatio = screenH / screenW;
    var previewRatio = previewH / previewW;

    return NativeDeviceOrientationReader(builder: (context) {
      NativeDeviceOrientation orientation =
          NativeDeviceOrientationReader.orientation(context);

      int turns;
      switch (orientation) {
        case NativeDeviceOrientation.landscapeLeft:
          turns = -1;
          break;
        case NativeDeviceOrientation.landscapeRight:
          turns = 1;
          break;
        case NativeDeviceOrientation.portraitDown:
          turns = 2;
          break;
        default:
          turns = 0;
          break;
      }

      return RotatedBox(
          quarterTurns: turns,
          child: OverflowBox(
            maxHeight: screenRatio > previewRatio
                ? screenH
                : screenW / previewW * previewH,
            maxWidth: screenRatio > previewRatio
                ? screenH / previewH * previewW
                : screenW,
            child: CameraPreview(controller),
          ));
    });
  }

  @override
  void didUpdateWidget(Camera oldWidget) {
    _detectModeOn = widget.detectModeOn;
    _resolutionPreset = _getResolution(widget.resolution);
    super.didUpdateWidget(oldWidget);
  }

  ResolutionPreset _getResolution(res) {
    print('GET RESOLUTION: $res');
    switch (res) {
      case RES_LOW:
        return ResolutionPreset.low;
      case RES_MED:
        return ResolutionPreset.medium;
      default:
        return ResolutionPreset.high;
    }
  }
}
