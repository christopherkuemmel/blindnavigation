import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const RES_LOW = 0;
const RES_MED = 1;
const RES_HIGH = 2;

typedef void Callback(int resolution);

class Settings extends StatefulWidget {

  final Callback setSettings;

  Settings(this.setSettings);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  Widget build(BuildContext context) {
    return Scaffold(
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
                  RaisedButton(
                    padding: const EdgeInsets.all(8.0),
                    onPressed: () => widget.setSettings(RES_LOW),
                    child: const Text('Low'),
                  ),
                  RaisedButton(
                    padding: const EdgeInsets.all(8.0),
                    onPressed: () => widget.setSettings(RES_MED),
                    child: const Text('Medium'),
                  ),
                  RaisedButton(
                    padding: const EdgeInsets.all(8.0),
                    onPressed: () => widget.setSettings(RES_HIGH),
                    child: const Text('High'),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
