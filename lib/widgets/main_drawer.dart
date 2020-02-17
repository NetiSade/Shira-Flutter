import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../pages/artists_page.dart';
import '../pages/artworks_page.dart';
import '../providers/artworks_provider.dart';
import '../pages/setting_page.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var todayArtwork = Provider.of<ArtworksProvider>(context).todayArtwork;

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
                if (todayArtwork != null) Text(todayArtwork.title),
                if (todayArtwork != null) Text(todayArtwork.artistName)
              ],
            ),
          ),
          buildListTile(context, 'שירים', () {
            Navigator.of(context).pushReplacementNamed(ArtworksPage.routeName);
          }),
          buildListTile(context, 'שירים מאויירים', () {}),
          buildListTile(context, 'משוררים', () {
            Navigator.of(context).pushReplacementNamed(ArtistsPage.routeName);
          }),
          buildListTile(context, 'האזור האישי', () {}),
          buildListTile(context, 'הפיצו שירה', () {}),
          buildListTile(context, 'אודות', () {}),
          buildListTile(context, 'הגדרות', () {
            Navigator.of(context).pushNamed(SettingPage.routeName);
          }),
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
