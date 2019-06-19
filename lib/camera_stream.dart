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
  final double framerate;
  final Callback setRecognitions;
  final bool detectModeOn;
  final bool screenOn;
  final double appBarHeight;

  CameraStream(this.cameras, this.resolution, this.framerate, this.setRecognitions, this.detectModeOn, this.screenOn, this.appBarHeight);

  @override
  _CameraStreamState createState() => _CameraStreamState();
}

class _CameraStreamState extends State<CameraStream> {
  List<dynamic> _recognitions;
  int _imageHeight = 0;
  int _imageWidth = 0;
  bool _detectModeOn = false;
  bool _screenOn = false;
  int _resolution;
  int _framerate;

  @override
  void initState() {
    _resolution = widget.resolution;
    _framerate = widget.framerate.floor();
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
          Camera(widget.cameras, setRecognitions, _detectModeOn, _screenOn, _resolution, _framerate),
          _screenOn ? BoundingBox(
              getRecognitions(),
              math.max(_imageHeight, _imageWidth),
              math.min(_imageHeight, _imageWidth),
              screen.height,
              screen.width,
              widget.appBarHeight
            ) : Container(),
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
    setState(() {
      _resolution = widget.resolution;
      _framerate = widget.framerate.floor();
      _detectModeOn = widget.detectModeOn;
      _screenOn = widget.screenOn;
    });
    super.didUpdateWidget(oldWidget);
  }
}
