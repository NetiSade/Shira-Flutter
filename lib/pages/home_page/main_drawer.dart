import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      children: <Widget>[
        ListTile(
            title: Text('item1'),
            onTap: () {
              // Update the state of the app.
              // ...
              // Then close the drawer.
              Navigator.pop(context);
            }),
        ListTile(
          title: Text('item2'),
        ),
        ListTile(
          title: Text('item3'),
        )
      ],
    ));
  }
}
