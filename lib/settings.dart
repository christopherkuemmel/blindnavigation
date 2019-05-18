import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const RES_LOW = 0;
const RES_MED = 1;
const RES_HIGH = 2;

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State {
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
                    onPressed: () => _setResolution(RES_LOW),
                    child: const Text('Low'),
                  ),
                  RaisedButton(
                    padding: const EdgeInsets.all(8.0),
                    onPressed: () => _setResolution(RES_MED),
                    child: const Text('Medium'),
                  ),
                  RaisedButton(
                    padding: const EdgeInsets.all(8.0),
                    onPressed: () => _setResolution(RES_HIGH),
                    child: const Text('High'),
                  ),
                ],
              ),
            ],
          )),
    );
  }

  Future<void> _setResolution(int res) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('resolution', res);
  }
}
