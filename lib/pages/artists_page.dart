import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shira/pages/artist_detail_page.dart';
import 'package:shira/widgets/artists_group_widget.dart';

import '../providers/artists_provider.dart';
import '../widgets/main_drawer.dart';

class ArtistsPage extends StatelessWidget {
  static const routeName = '/artists-page';

  @override
  Widget build(BuildContext context) {
    var _artistsGroups = Provider.of<ArtistsProvider>(context).artistGroups;

    return Scaffold(
        drawer: MainDrawer(),
        body: SafeArea(
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
        ));
  }

  _navToArtistDetailPage(BuildContext context, String artistId) {
    Navigator.of(context)
        .pushNamed(ArtistDetailPage.routeName, arguments: artistId);
  }
}
