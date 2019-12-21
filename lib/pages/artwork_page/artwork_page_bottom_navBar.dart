import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
            icon: SvgPicture.asset('assets/images/arrow-back.svg'),
            title: Text('חזרה',
                style: TextStyle(
                    fontSize: 12, color: Color.fromRGBO(47, 83, 68, 1)))),
        BottomNavigationBarItem(
            backgroundColor: Theme.of(context).accentColor,
            icon: SvgPicture.asset('assets/images/lang.svg'),
            title: Text('שפת מקור',
                style: TextStyle(
                    fontSize: 12, color: Color.fromRGBO(47, 83, 68, 1)))),
        BottomNavigationBarItem(
            backgroundColor: Theme.of(context).accentColor,
            icon: SvgPicture.asset(
              'assets/images/share.svg',
            ),
            title: Text('שיתוף',
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
