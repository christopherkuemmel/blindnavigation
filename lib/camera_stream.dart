import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;

import 'camera.dart';
import 'bounding_box.dart';

typedef void Callback(List<dynamic> list, int h, int w);

class CameraStream extends StatefulWidget {
  final List<CameraDescription> cameras;
  final int resolution;
  final Callback setRecognitions;

  CameraStream(this.cameras,this.resolution, this.setRecognitions);

  @override
  _CameraStreamState createState() => _CameraStreamState();
}

class _CameraStreamState extends State<CameraStream> {
  List<dynamic> _recognitions;
  int _imageHeight = 0;
  int _imageWidth = 0;
  bool _detectModeOn = false;
  int _resolution = 0;

  @override
  void initState() {
    super.initState();
  }

  loadModel() async {
    String res = await Tflite.loadModel(
        model: "assets/ssd_mobilenet.tflite",
        labels: "assets/ssd_mobilenet.txt");
    print(res);
  }

  setRecognitions(recognitions, imageHeight, imageWidth) {
    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });
    // pass recognitions to parent widget
    widget.setRecognitions(_recognitions, _imageHeight, _imageWidth);
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    loadModel();
    return Scaffold(
      body: Stack(
        children: [
          Camera(widget.cameras, setRecognitions, _detectModeOn, _resolution),
          BoundingBox(
            getRecognitions(),
            math.max(_imageHeight, _imageWidth),
            math.min(_imageHeight, _imageWidth),
            screen.height,
            screen.width,
          ),
          // TODO: move switch button to appbar
          Switch(
              value: _detectModeOn,
              onChanged: (value) => setState(() => _detectModeOn = value)
          ),
        ],
      ),
    );
  }

  List<dynamic> getRecognitions() {
    return _recognitions == null ? [] :
      _detectModeOn ? _recognitions : [];
  }

  @override
  void didUpdateWidget(CameraStream oldWidget) {
    _resolution = widget.resolution;
    super.didUpdateWidget(oldWidget);
  }
}
