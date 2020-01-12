import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/enums.dart';
import '../pages/artist_detail_page.dart';
import '../widgets/artists_group_widget.dart';
import '../widgets/main_bottom_nav_bar.dart';
import '../providers/artists_provider.dart';
import '../widgets/main_drawer.dart';

class ArtistsPage extends StatefulWidget {
  static const routeName = '/artists-page';

  @override
  _ArtistsPageState createState() => _ArtistsPageState();
}

class _ArtistsPageState extends State<ArtistsPage> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  int _bottomNavselectedIndex = 0;
  final TextEditingController _searchQueryController = TextEditingController();
  ArtistsProvider _artistsProvider;

  @override
  Widget build(BuildContext context) {
    _artistsProvider = Provider.of<ArtistsProvider>(context);
    var _artistsGroups = _artistsProvider.artistGroups;

    return Scaffold(
      key: _drawerKey,
      drawer: MainDrawer(),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            if (_artistsProvider.displayModel.searchQuery != '')
              ListTile(
                title: Text(
                  _artistsProvider.displayModel.searchQuery == ''
                      ? ''
                      : 'תוצאות חיפוש: \"${_artistsProvider.displayModel.searchQuery}\"',
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
              height: _artistsProvider.displayModel.searchQuery == ''
                  ? MediaQuery.of(context).size.height - 84
                  : MediaQuery.of(context).size.height - 84 - 56,
              child: Container(
                child: ListView.builder(
                  itemCount: _artistsGroups.length,
                  itemBuilder: (BuildContext context, int index) =>
                      ArtistsGroupWidget(
                    artistsGroup: _artistsGroups[index],
                    onItemTapped: (BuildContext context, String artistId) {
                      _navToArtistDetailPage(context, artistId);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 60,
        child: MainBottomNavBar(
          selectedIndex: _bottomNavselectedIndex,
          onBottomNavTapped: _onBottomNavTapped,
          showDisplayOption: false,
        ),
      ),
    );
  }

  _navToArtistDetailPage(BuildContext context, String artistId) {
    Navigator.of(context)
        .pushNamed(ArtistDetailPage.routeName, arguments: artistId);
  }

  _onBottomNavTapped(int index, BuildContext ctx) {
    setState(() {
      _bottomNavselectedIndex = index;

      switch (index) {
        case 0:
          break;
        case 1:
          showSearchBottomSheet(ctx: ctx);
          break;
        case 2:
          _drawerKey.currentState.openDrawer();
          break;

        default:
      }
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

  void onSearchQueryChnaged(String query) {
    setState(() {
      var displayModel = _artistsProvider.displayModel;
      displayModel.searchQuery = query;
      displayModel.sortType = SortType.ArtistName;
      _artistsProvider.setDisplayModel(displayModel);
    });
  }
}
