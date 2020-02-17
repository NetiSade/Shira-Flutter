import 'package:flutter/material.dart';

class SettingPage extends StatelessWidget {
  static const routeName = '/setting-page';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('שם ושם משפחה'),
          ),
          ListTile(
            title: Text('עדכונים והתראות'),
          ),
        ],
      ),
    );
  }
}
