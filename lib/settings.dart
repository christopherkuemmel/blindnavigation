import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => new _SettingsState();
}

class _SettingsState extends State {
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Settings"),
      ),
      body: new Container(
          child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                'Resolution',
                style: TextStyle(
                  fontSize: 20,
                ),
              )
            ],
          ),
          Row(
            children: <Widget>[
              new FlatButton(
                onPressed: _setResolution(0),
                child: Text('Low'),
              ),
              new FlatButton(
                onPressed: _setResolution(1),
                child: Text('Medium'),
              ),
              new FlatButton(
                onPressed: _setResolution(2),
                child: Text('High'),
              ),
            ],
          ),
        ],
      )),
    );
  }
}

_setResolution(int x) {}
