import 'package:flutter/material.dart';

class MainBottomNavBar extends StatelessWidget {
  const MainBottomNavBar({
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
            icon: Icon(Icons.sort),
            title: Text('תצוגה',
                style: TextStyle(
                    fontSize: 12, color: Color.fromRGBO(47, 83, 68, 1)))),
        BottomNavigationBarItem(
            backgroundColor: Theme.of(context).accentColor,
            icon: Icon(Icons.filter),
            title: Text('מיון',
                style: TextStyle(
                    fontSize: 12, color: Color.fromRGBO(47, 83, 68, 1)))),
        BottomNavigationBarItem(
            backgroundColor: Theme.of(context).accentColor,
            icon: Icon(Icons.search),
            title: Text('חיפוש',
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
