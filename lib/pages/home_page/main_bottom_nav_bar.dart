import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainBottomNavBar extends StatelessWidget {
  const MainBottomNavBar({
    Key key,
    @required int bottomNavSelectedIndex,
    @required Function onBottomNavTapped,
  })  : _bottomNavselectedIndex = bottomNavSelectedIndex,
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
            icon: SvgPicture.asset('assets/images/view-list.svg'),
            title: Text('תצוגה',
                style: TextStyle(
                    fontSize: 12, color: Color.fromRGBO(47, 83, 68, 1)))),
        BottomNavigationBarItem(
            backgroundColor: Theme.of(context).accentColor,
            icon: SvgPicture.asset('assets/images/sort.svg'),
            title: Text('מיון לפי',
                style: TextStyle(
                    fontSize: 12, color: Color.fromRGBO(47, 83, 68, 1)))),
        BottomNavigationBarItem(
            backgroundColor: Theme.of(context).accentColor,
            icon: SvgPicture.asset(
              'assets/images/search.svg',
            ),
            title: Text('חיפוש',
                style: TextStyle(
                    fontSize: 12, color: Color.fromRGBO(47, 83, 68, 1)))),
        BottomNavigationBarItem(
            backgroundColor: Theme.of(context).accentColor,
            icon: SvgPicture.asset(
              'assets/images/shira-logo.svg',
              width: 50,
            ),
            title: Container()),
      ],
    );
  }
}
