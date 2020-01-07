import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../widgets/main_drawer.dart';
import '../widgets/artworks_list.dart';
import '../providers/artworks_provider.dart';
import '../providers/artists_provider.dart';

//TODO: Get artworks by artist id and not artist name!

class ArtistDetailPage extends StatefulWidget {
  static const routeName = '/artist-detail-page';

  @override
  _ArtistDetailPageState createState() => _ArtistDetailPageState();
}

class _ArtistDetailPageState extends State<ArtistDetailPage> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final String artistId = ModalRoute.of(context).settings.arguments as String;
    var artist = Provider.of<ArtistsProvider>(context).getArtist(artistId);

    var _bottomNavselectedIndex = 0;

    return SafeArea(
      child: Scaffold(
        key: _drawerKey,
        drawer: MainDrawer(),
        bottomNavigationBar: SizedBox(
            height: 60,
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Theme.of(context).primaryColor,
              currentIndex: _bottomNavselectedIndex,
              selectedItemColor: Color.fromRGBO(47, 83, 68, 1),
              onTap: (index) => {
                setState(() {
                  index == 0
                      ? Navigator.pop(context)
                      : _drawerKey.currentState.openDrawer();
                })
              },
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  backgroundColor: Theme.of(context).primaryColor,
                  icon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Align(
                        alignment: Alignment.centerRight,
                        child:
                            SvgPicture.asset('assets/images/arrow-back.svg')),
                  ),
                  title: Container(),
                ),
                BottomNavigationBarItem(
                    backgroundColor: Theme.of(context).primaryColor,
                    icon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: SvgPicture.asset(
                          'assets/images/shira-logo.svg',
                          width: 50,
                        ),
                      ),
                    ),
                    title: Container()),
              ],
            )),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                    width: double.infinity,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(40),
                              bottomLeft: Radius.circular(40))),
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: <Widget>[
                            Text(artist.name),
                            Text(artist.biography),
                          ],
                        ),
                      ),
                    )),
                Container(
                  height: 500,
                  child: ArtworksList(
                    showArtistName: false,
                    showDate: false,
                    artistName: artist.name,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
