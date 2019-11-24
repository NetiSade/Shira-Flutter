import 'package:flutter/material.dart';

class ArtworkPageBottomNavBar extends StatelessWidget {
  const ArtworkPageBottomNavBar({
    Key key,
    @required int bottomNavselectedIndex,
    @required Function onBottomNavTapped,
  })  : _bottomNavselectedIndex = bottomNavselectedIndex,
        _onBottomNavTapped = onBottomNavTapped,
        super(key: key);

  final int _bottomNavselectedIndex;
  final Function _onBottomNavTapped;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Theme.of(context).accentColor,
      currentIndex: _bottomNavselectedIndex,
      selectedItemColor: Color.fromRGBO(47, 83, 68, 1),
      onTap: (index) => _onBottomNavTapped(index, context),
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            backgroundColor: Theme.of(context).accentColor,
            icon: Icon(Icons.arrow_back),
            title: Text('חזרה',
                style: TextStyle(
                    fontSize: 12, color: Color.fromRGBO(47, 83, 68, 1)))),
        BottomNavigationBarItem(
            backgroundColor: Theme.of(context).accentColor,
            icon: Icon(Icons.language),
            title: Text('שפת מקור',
                style: TextStyle(
                    fontSize: 12, color: Color.fromRGBO(47, 83, 68, 1)))),
        BottomNavigationBarItem(
            backgroundColor: Theme.of(context).accentColor,
            icon: Icon(Icons.share),
            title: Text('שיתוף',
                style: TextStyle(
                    fontSize: 12, color: Color.fromRGBO(47, 83, 68, 1)))),
        BottomNavigationBarItem(
            backgroundColor: Theme.of(context).accentColor,
            icon: Icon(Icons.forum),
            title: Text(
              'שירה',
              style:
                  TextStyle(fontSize: 12, color: Color.fromRGBO(47, 83, 68, 1)),
            )),
      ],
    );
  }
}
