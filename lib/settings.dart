import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => new _SettingsState();
}

class _SettingsState extends State {
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text ('Settings'),
      ),
      body: new Container(
          padding: new EdgeInsets.all(32.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Resolution:',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new RaisedButton(
                    padding: const EdgeInsets.all(8.0),
                    onPressed: _setResolution(0),
                    child: new Text('Low'),
                  ),
                  new RaisedButton(
                    padding: const EdgeInsets.all(8.0),
                    onPressed: _setResolution(1),
                    child: Text('Medium'),
                  ),
                  new RaisedButton(
                    padding: const EdgeInsets.all(8.0),
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
