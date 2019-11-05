import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/artwork.dart';
import '../../models/artworks_group.dart';
import '../../models/enums.dart';
import '../../services/db_service.dart';
import '../../widgets/artworks_list.dart';
import 'main_bottom_nav_bar.dart';
import 'main_drawer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ArtworkGroup> _artworkGroups = List<ArtworkGroup>();
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  SortType _sortType = SortType.Date;
  List<Artwork> _allArtworks = List<Artwork>();
  int _bottomNavselectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      body: Container(
          color: Color.fromRGBO(246, 246, 246, 0),
          child: ArtworksList(
            sortType: _sortType,
            artworkGroups: _artworkGroups,
            allArtworks: _allArtworks,
          )),
      drawer: MainDrawer(),
      bottomNavigationBar: SizedBox(
        height: 60,
        child: MainBottomNavBar(
            bottomNavselectedIndex: _bottomNavselectedIndex,
            onBottomNavTapped: _onBottomNavTapped),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    DbService().getArtworks.then((artworks) {
      setState(() {
        _allArtworks = artworks;
        initArtworks();
      });
    });
  }

  Future<void> initArtworks() async {
    this._artworkGroups = List<ArtworkGroup>();

    if (_allArtworks.length == 0) {
      return;
    }

    _sortArtworks();
  }

  void _onBottomNavTapped(int index, BuildContext ctx) {
    setState(() {
      _bottomNavselectedIndex = index;

      switch (index) {
        case 3:
          _drawerKey.currentState.openDrawer();
          break;
        case 1:
          showSortBottomSheet(ctx, index);
          break;
        case 0:
          _sortType =
              _sortType == SortType.None ? SortType.Date : SortType.None;
          break;
        default:
      }
    });
  }

  showSortBottomSheet(BuildContext ctx, int index) {
    showModalBottomSheet(
        elevation: 5,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        context: ctx,
        builder: (_) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text('הצג לפי'),
                    Switch(
                      onChanged: (bool value) {},
                      value: true,
                    ),
                    Row(
                      children: <Widget>[
                        Checkbox(
                          onChanged: (bool value) {},
                          value: true,
                        ),
                        Text('הצג שירים שנקראו')
                      ],
                    ),
                    Row(
                      children: <Widget>[Radio(), Text('שם המחבר')],
                    ),
                    Row(
                      children: <Widget>[Radio(), Text('שם השיר')],
                    ),
                    Row(
                      children: <Widget>[Radio(), Text('תאריך פרסום')],
                    ),
                    Row(
                      children: <Widget>[
                        RaisedButton(
                          child: Text('ביטול'),
                          onPressed: () {},
                        ),
                        SizedBox(
                          width: 50,
                        ),
                        RaisedButton(
                          child: Text('אישור'),
                          onPressed: () {},
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            onTap: () {},
          );
        });
  }

  Future<void> _sortArtworks() async {
    switch (_sortType) {
      case SortType.Date:
        _sortByDate();
        break;
      case SortType.None:
        break;
      case SortType.ArtistName:
        break;
      case SortType.ArtworkName:
        break;

      default:
    }
  }

  Future<void> _sortByDate() async {
    var groupDate = _allArtworks[0].publisheDate;

    var list = List<Artwork>();

    for (var i = 0; i < _allArtworks.length; i++) {
      var artwork = _allArtworks[i];
      var artworkDate = artwork.publisheDate;

      if (artworkDate.year == groupDate.year &&
          artworkDate.month == groupDate.month) {
        list.add(_allArtworks[i]);
      } else {
        var ag = ArtworkGroup(
            artworks: list,
            title:
                "${DateFormat('MMMM').format(artwork.publisheDate)} ${artwork.publisheDate.year}");
        this._artworkGroups.add(ag);
        list = List<Artwork>();
        list.add(artwork);
        groupDate = artworkDate;
      }
    }

    var artwork = list[0];
    var ag = ArtworkGroup(
        artworks: list,
        title:
            "${DateFormat('MMMM').format(artwork.publisheDate)} ${artwork.publisheDate.year}");
    this._artworkGroups.add(ag);
  }
}
