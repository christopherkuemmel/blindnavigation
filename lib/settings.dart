import 'package:flutter/material.dart';

const RES_LOW = 0;
const RES_MED = 1;
const RES_HIGH = 2;

typedef void Callback(int resolution, double framerate);

class Settings extends StatefulWidget {
  final Callback setSettings;
  final int resolution;
  final double framerate;

  Settings(this.setSettings, this.resolution, this.framerate);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  int _resolution;
  double _framerate;

  @override
  initState(){
    super.initState();
    _resolution = widget.resolution;
    _framerate = widget.framerate;
  }

  Future<bool> _setSettings() {
    widget.setSettings(_resolution, _framerate);
    return Future.value(true);
  }

  void handleResolutionChange(res) {
    setState(() => _resolution = res);
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _setSettings(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
        ),
        body: Container(
            padding: EdgeInsets.all(32.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Resolution'),
                      Radio(
                        onChanged: (res) => handleResolutionChange(res),
                        groupValue: _resolution,
                        value: RES_LOW,
                      ),
                      Text('Low'),
                      Radio(
                        onChanged: (res) => handleResolutionChange(res),
                        groupValue: _resolution,
                        value: RES_MED,
                      ),
                      Text('Medium'),
                      Radio(
                        onChanged: (res) => handleResolutionChange(res),
                        groupValue: _resolution,
                        value: RES_HIGH,
                      ),
                      Text('High'),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Framerate"),
                      Flexible(
                        flex: 1,
                        child: Slider(
                          activeColor: Colors.white,
                          min: 1,
                          max: 25,
                          onChanged: (newRating) => setState(() => _framerate = newRating),
                          value: _framerate,
                        ),
                      ),
                      Container(
                          width: 80.0,
                          alignment: Alignment.center,
                          child: Text((_framerate.floor()).toStringAsFixed(0) + " fps"))
                    ],
                  ),
                ),
              ],
            ),
        ),
      ),
    );
  }
}

