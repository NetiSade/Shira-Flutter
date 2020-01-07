import 'package:flutter/material.dart';
import '../pages/artists_page.dart';
import '../pages/home_page/home_page.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
      color: Theme.of(context).primaryColor,
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(),
            child: Column(
              children: <Widget>[
                Text(
                  'השיר היומי',
                  style: TextStyle(color: Colors.white),
                ),
                Text('כותרת'),
                Text('משורר')
              ],
            ),
          ),
          buildListTile(context, 'שירים', () {
            Navigator.of(context).pushReplacementNamed(HomePage.routeName);
          }),
          buildListTile(context, 'שירים מאויירים', () {}),
          buildListTile(context, 'משוררים', () {
            Navigator.of(context).pushReplacementNamed(ArtistsPage.routeName);
          }),
          buildListTile(context, 'האזור האישי', () {}),
          buildListTile(context, 'הפיצו שירה', () {}),
          buildListTile(context, 'אודות', () {}),
          buildListTile(context, 'הגדרות', () {}),
        ],
      ),
    ));
  }

  Widget buildListTile(BuildContext context, String txt, Function onTap) {
    return Container(
        decoration: BoxDecoration(
            border: Border(
          top: BorderSide(width: 1, color: Colors.white),
        )),
        child: ListTile(title: Text(txt), onTap: onTap));
  }
}
