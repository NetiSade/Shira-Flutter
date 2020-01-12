import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/sort_modal.dart';
import '../providers/artworks_provider.dart';
import '../models/enums.dart';
import '../widgets/artworks_list.dart';
import '../widgets/main_drawer.dart';
import '../widgets/main_bottom_nav_bar.dart';

class ArtworksPage extends StatefulWidget {
  static const routeName = '/home-page';
  @override
  _ArtworksPageState createState() => _ArtworksPageState();
}

class _ArtworksPageState extends State<ArtworksPage> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  int _bottomNavselectedIndex = 0;
  final TextEditingController _searchQueryController = TextEditingController();
  ArtworksProvider _artworksProvider;
  ArtworksList _artworksList = ArtworksList();

  @override
  Widget build(BuildContext context) {
    _artworksProvider = Provider.of<ArtworksProvider>(context);

    return SafeArea(
      child: Scaffold(
        key: _drawerKey,
        body: Container(
            child: Column(
          children: <Widget>[
            if (_artworksProvider.displayModel.searchQuery != '')
              ListTile(
                title: Text(
                  _artworksProvider.displayModel.searchQuery == ''
                      ? ''
                      : 'תוצאות חיפוש: \"${_artworksProvider.displayModel.searchQuery}\"',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: () {
                    _searchQueryController.clear();
                    onSearchQueryChnaged('');
                  },
                ),
                onTap: () {
                  showSearchBottomSheet(ctx: context);
                },
              ),
            SizedBox(
              width: double.infinity,
              height: _artworksProvider.displayModel.searchQuery == ''
                  ? MediaQuery.of(context).size.height - 84
                  : MediaQuery.of(context).size.height - 84 - 56,
              child: _artworksList,
            ),
          ],
        )),
        drawer: MainDrawer(),
        bottomNavigationBar: SizedBox(
          height: 60,
          child: MainBottomNavBar(
            selectedIndex: _bottomNavselectedIndex,
            onBottomNavTapped: _onBottomNavTapped,
          ),
        ),
      ),
    );
  }

  _onBottomNavTapped(int index, BuildContext ctx) {
    setState(() {
      _bottomNavselectedIndex = index;

      switch (index) {
        case 3:
          _drawerKey.currentState.openDrawer();
          break;
        case 1:
          showSortBottomSheet(ctx);
          break;
        case 2:
          showSearchBottomSheet(ctx: ctx);
          break;
        case 0:
          var dm = _artworksProvider.displayModel;
          dm.sortType =
              dm.sortType == SortType.None ? SortType.Date : SortType.None;
          _artworksProvider.setDisplayModel(dm);
          break;
        default:
      }
    });
  }

  showSortBottomSheet(BuildContext ctx) {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40), topRight: Radius.circular(40))),
        elevation: 5,
        context: ctx,
        builder: (ctx) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return FractionallySizedBox(
                heightFactor: 0.7,
                child: SortModal(
                    setModalState: setModalState,
                    onDismiss: () {
                      setState(() {
                        Navigator.of(context).pop();
                      });
                    }),
              );
            },
          );
        });
  }

  void onSearchQueryChnaged(String query) {
    setState(() {
      var displayModel = _artworksProvider.displayModel;
      displayModel.searchQuery = query;
      displayModel.sortType = SortType.Date;
      _artworksProvider.setDisplayModel(displayModel);
    });
  }

  void showSearchBottomSheet({BuildContext ctx, bool autofocus = true}) {
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
                    child: TextField(
                      onSubmitted: (_) {
                        Navigator.of(context).pop();
                      },
                      controller: _searchQueryController,
                      onChanged: (query) {
                        onSearchQueryChnaged(query);
                      },
                      autofocus: autofocus,
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
}
