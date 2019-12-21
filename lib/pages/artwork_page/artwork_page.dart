import 'package:flutter/material.dart';

import '../../models/artwork.dart';
import 'artwork_page_bottom_navBar.dart';

class ArtworkPage extends StatefulWidget {
  static const routeName = '/artwork-page';

  @override
  _ArtworkPageState createState() => _ArtworkPageState();
}

class _ArtworkPageState extends State<ArtworkPage> {
  var _bottomNavselectedIndex = 0;
  var showBottomNavBar = false;

  _onBottomNavTapped(index, context) {
    switch (index) {
      case 0:
        setState(() {
          Navigator.pop(context);
        });
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    final artwork = ModalRoute.of(context).settings.arguments as Artwork;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: GestureDetector(
            onTap: () {
              setState(() {
                showBottomNavBar = !showBottomNavBar;
              });
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(50),
              child: Column(
                children: <Widget>[
                  Text(
                    artwork.title,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    artwork.artistName,
                    style: TextStyle(
                        fontSize: 18,
                        color: Color.fromRGBO(248, 122, 100, 1),
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    artwork.bodyText,
                    style: TextStyle(fontSize: 24),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: showBottomNavBar
          ? SizedBox(
              height: 60,
              child: ArtworkPageBottomNavBar(
                  bottomNavselectedIndex: _bottomNavselectedIndex,
                  onBottomNavTapped: _onBottomNavTapped),
            )
          : SizedBox(),
    );
  }
}
