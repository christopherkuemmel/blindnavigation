import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'placeholder.dart';
import 'camera_stream.dart';



class Home extends StatefulWidget {

  final List<CameraDescription> cameras;
  Home(this.cameras);

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    CameraStream(widget.cameras),
    PlaceholderWidget(Colors.green),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Object Detection'),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.camera_alt),
            title: new Text('Camera'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.videocam),
            title: new Text('Video'),
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
