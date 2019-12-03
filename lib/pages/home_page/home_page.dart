import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shira/models/artworks_display_model.dart';
import 'package:shira/providers/artworks_provider.dart';

import '../../models/artwork.dart';
import '../../models/artworks_group.dart';
import '../../models/enums.dart';
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
  var _displayModel = ArtworksDisplayModel();
  var _selectedDisplayModel = ArtworksDisplayModel();
  List<Artwork> _allArtworks = List<Artwork>();
  int _bottomNavselectedIndex = 0;
  final TextEditingController _searchQueryController =
      new TextEditingController();

  @override
  Widget build(BuildContext context) {
    _allArtworks = Provider.of<ArtworksProvider>(context).artworks;
    _sortArtworks();

    return Scaffold(
      key: _drawerKey,
      body: Container(
          color: Color.fromRGBO(246, 246, 246, 0),
          child: ArtworksList(
            sortType: _displayModel.sortType,
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

  _sortArtworks() {
    this._artworkGroups = List<ArtworkGroup>();

    if (_allArtworks == null || _allArtworks.length == 0) {
      return;
    }

    if (_displayModel.searchQuery != '') {
      _sortBySearchQuery(_displayModel.searchQuery);
      return;
    }

    switch (_displayModel.sortType) {
      case SortType.Date:
        _sortByDate();
        break;
      case SortType.None:
        break;
      case SortType.ArtistName:
        _sortByArtistName();
        break;
      case SortType.ArtworkName:
        _sortByArtworkName();
        break;
      default:
        _sortByDate();
    }
  }

  _onSortChanged(ArtworksDisplayModel adm) {
    setState(() {
      _selectedDisplayModel = adm;
    });
  }

  _onBottomNavTapped(int index, BuildContext ctx) {
    setState(() {
      _bottomNavselectedIndex = index;

      switch (index) {
        case 3:
          _drawerKey.currentState.openDrawer();
          break;
        case 1:
          _selectedDisplayModel = _displayModel;
          showSortBottomSheet(ctx);
          break;
        case 2:
          showSearchBottomSheet(ctx);
          break;
        case 0:
          _displayModel.sortType = _displayModel.sortType == SortType.None
              ? SortType.Date
              : SortType.None;
          break;
        default:
      }
    });
  }

  showSortBottomSheet(BuildContext ctx) {
    showModalBottomSheet(
        elevation: 5,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        context: ctx,
        builder: (ctx) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return _buildBottomSheet(setModalState);
            },
          );
        });
  }

  void onSearchQueryChnaged(String query) {
    setState(() {
      _displayModel.searchQuery = query;
      _sortArtworks();
    });
  }

  void showSearchBottomSheet(BuildContext ctx) {
    showModalBottomSheet(
        elevation: 5,
        context: ctx,
        builder: (ctx) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                    padding: EdgeInsets.all(10),
                    height: 80,
                    color: Theme.of(context).accentColor,
                    child: TextField(
                      controller: _searchQueryController,
                      onChanged: (query) {
                        onSearchQueryChnaged(query);
                      },
                      autofocus: true,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'חפש',
                          suffixIcon: IconButton(
                            icon: Icon(Icons.cancel),
                            onPressed: () {
                              _searchQueryController.clear();
                              onSearchQueryChnaged('');
                            },
                          )),
                    )));
          });
        });
  }

  _sortByDate() {
    _displayModel.descendingOrder
        ? _allArtworks.sort((b, a) => a.publisheDate.compareTo(b.publisheDate))
        : _allArtworks.sort((a, b) => a.publisheDate.compareTo(b.publisheDate));

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

  _sortByArtistName() {
    _displayModel.descendingOrder
        ? _allArtworks.sort((b, a) => a.artistName.compareTo(b.artistName))
        : _allArtworks.sort((a, b) => a.artistName.compareTo(b.artistName));

    var groupChar = _allArtworks[0].artistName[0];

    var list = List<Artwork>();

    for (var i = 0; i < _allArtworks.length; i++) {
      var artwork = _allArtworks[i];
      var artworkChar = artwork.artistName[0];

      if (groupChar == artworkChar) {
        list.add(_allArtworks[i]);
      } else {
        var ag = ArtworkGroup(artworks: list, title: groupChar);
        this._artworkGroups.add(ag);
        list = List<Artwork>();
        list.add(artwork);
        groupChar = artworkChar;
      }
    }

    var artwork = list[0];
    var ag = ArtworkGroup(artworks: list, title: artwork.artistName[0]);
    this._artworkGroups.add(ag);
  }

  _sortByArtworkName() {
    _displayModel.descendingOrder
        ? _allArtworks.sort((b, a) => a.title.compareTo(b.title))
        : _allArtworks.sort((a, b) => a.title.compareTo(b.title));

    var groupChar = _allArtworks[0].title[0];

    var list = List<Artwork>();

    for (var i = 0; i < _allArtworks.length; i++) {
      var artwork = _allArtworks[i];
      var artworkChar = artwork.title[0];

      if (groupChar == artworkChar) {
        list.add(_allArtworks[i]);
      } else {
        var ag = ArtworkGroup(artworks: list, title: groupChar);
        this._artworkGroups.add(ag);
        list = List<Artwork>();
        list.add(artwork);
        groupChar = artworkChar;
      }
    }

    var artwork = list[0];
    var ag = ArtworkGroup(artworks: list, title: artwork.title[0]);
    this._artworkGroups.add(ag);
  }

  _sortBySearchQuery(String searchQuery) {
    var artworkBodyList = List<Artwork>();
    var artworkNameList = List<Artwork>();
    var artistNameList = List<Artwork>();

    for (var artwork in _allArtworks) {
      if (artwork.bodyText.contains(searchQuery)) {
        artworkBodyList.add(artwork);
      }
      if (artwork.title.contains(searchQuery)) {
        artworkNameList.add(artwork);
      }
      if (artwork.artistName.contains(searchQuery)) {
        artistNameList.add(artwork);
      }
    }

    _artworkGroups.add(ArtworkGroup(artworks: artworkNameList, title: 'שירים'));
    _artworkGroups
        .add(ArtworkGroup(artworks: artworkBodyList, title: 'מילים מתוך שיר'));
    _artworkGroups
        .add(ArtworkGroup(artworks: artistNameList, title: 'משוררים'));
  }

  _buildBottomSheet(Function setModalState) {
    var adm = ArtworksDisplayModel();
    adm.sortType = _selectedDisplayModel.sortType;
    adm.descendingOrder = _selectedDisplayModel.descendingOrder;
    adm.showViewed = _selectedDisplayModel.showViewed;

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            ListTile(
              title: Text(
                '- הצג לפי -',
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
            SwitchListTile(
              onChanged: (val) {
                setModalState(() {
                  adm.descendingOrder = val;
                  _onSortChanged(adm);
                });
              },
              value: adm.descendingOrder,
              title: const Text('סדר יורד'),
            ),
            CheckboxListTile(
              onChanged: (val) {
                setModalState(() {
                  adm.showViewed = val;
                  _onSortChanged(adm);
                });
              },
              value: adm.showViewed,
              title: const Text('הצג שירים שנקראו'),
            ),
            RadioListTile(
              groupValue: _selectedDisplayModel.sortType,
              value: SortType.ArtistName,
              title: const Text('שם המחבר'),
              onChanged: (val) {
                setModalState(() {
                  adm.sortType = val;
                  _onSortChanged(adm);
                });
              },
            ),
            RadioListTile(
              groupValue: _selectedDisplayModel.sortType,
              title: Text('שם השיר'),
              value: SortType.ArtworkName,
              onChanged: (val) {
                setModalState(() {
                  adm.sortType = val;
                  _onSortChanged(adm);
                });
              },
            ),
            RadioListTile(
              groupValue: _selectedDisplayModel.sortType,
              value: SortType.Date,
              title: Text('תאריך פרסום'),
              onChanged: (val) {
                setModalState(() {
                  adm.sortType = val;
                  _onSortChanged(adm);
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  child: Text('ביטול'),
                  onPressed: () {
                    setState(() {
                      Navigator.of(context).pop();
                    });
                  },
                ),
                SizedBox(
                  width: 50,
                ),
                RaisedButton(
                  child: Text('אישור'),
                  onPressed: () {
                    setState(() {
                      if (_selectedDisplayModel != _displayModel) {
                        _displayModel = _selectedDisplayModel;
                        _sortArtworks();
                      }
                      Navigator.of(context).pop();
                    });
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
