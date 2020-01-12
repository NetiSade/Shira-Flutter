import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainBottomNavBar extends StatelessWidget {
  const MainBottomNavBar(
      {@required this.selectedIndex,
      @required this.onBottomNavTapped,
      this.showDisplayOption = true});

  final int selectedIndex;
  final Function onBottomNavTapped;
  final bool showDisplayOption;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Theme.of(context).primaryColor,
      currentIndex: selectedIndex,
      selectedItemColor: Color.fromRGBO(47, 83, 68, 1),
      onTap: (index) => onBottomNavTapped(index, context),
      items: <BottomNavigationBarItem>[
        if (showDisplayOption)
          BottomNavigationBarItem(
              backgroundColor: Theme.of(context).primaryColor,
              icon: SvgPicture.asset('assets/images/view-list.svg'),
              title: Text('תצוגה',
                  style: TextStyle(
                      fontSize: 12, color: Color.fromRGBO(47, 83, 68, 1)))),
        BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: SvgPicture.asset('assets/images/sort.svg'),
            title: Text('מיון לפי',
                style: TextStyle(
                    fontSize: 12, color: Color.fromRGBO(47, 83, 68, 1)))),
        BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: SvgPicture.asset(
              'assets/images/search.svg',
            ),
            title: Text('חיפוש',
                style: TextStyle(
                    fontSize: 12, color: Color.fromRGBO(47, 83, 68, 1)))),
        BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: SvgPicture.asset(
              'assets/images/shira-logo.svg',
              width: 50,
            ),
            title: Container()),
      ],
    );
  }
}
