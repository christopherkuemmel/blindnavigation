import 'package:flutter/material.dart';
import 'object_detection_widget.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: ObjectDetection(),
    );
  }
}
