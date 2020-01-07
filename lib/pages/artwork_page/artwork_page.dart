import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../providers/artworks_provider.dart';
import '../../widgets/main_drawer.dart';
import '../../models/artwork.dart';
import 'artwork_page_bottom_navBar.dart';

class ArtworkPage extends StatefulWidget {
  static const routeName = '/artwork-page';

  @override
  _ArtworkPageState createState() => _ArtworkPageState();
}

class _ArtworkPageState extends State<ArtworkPage> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  var _bottomNavselectedIndex = 0;
  var showBottomNavBar = false;

  _onBottomNavTapped(index, context) {
    switch (index) {
      case 0:
        setState(() {
          Navigator.pop(context);
        });
        break;
      case 3:
        setState(() {
          _drawerKey.currentState.openDrawer();
        });
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    final artwork = ModalRoute.of(context).settings.arguments as Artwork;
    return Scaffold(
      drawer: MainDrawer(),
      key: _drawerKey,
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
                  ListTile(
                    contentPadding: EdgeInsets.all(0),
                    title: Text(
                      artwork.title,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      artwork.artistName,
                      style: TextStyle(
                          fontSize: 18,
                          color: Color.fromRGBO(248, 122, 100, 1)),
                    ),
                    trailing: GestureDetector(
                      onTap: () {
                        Provider.of<ArtworksProvider>(context, listen: false)
                            .toggleFavorite(artwork.id);
                      },
                      child: SvgPicture.asset(
                        artwork.isFavorite
                            ? 'assets/images/fav-on.svg'
                            : 'assets/images/fav-off.svg',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    artwork.bodyText,
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      artwork.note,
                      style: TextStyle(
                          fontSize: 16,
                          color: Color.fromRGBO(248, 122, 100, 1)),
                    ),
                  ),
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
