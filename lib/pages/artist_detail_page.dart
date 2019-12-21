import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/artworks_group.dart';
import '../widgets/main_drawer.dart';
import '../models/enums.dart';
import '../widgets/artworks_list.dart';
import '../providers/artworks_provider.dart';
import '../providers/artists_provider.dart';

//TODO: Get artworks by artist id and not artist name!

class ArtistDetailPage extends StatelessWidget {
  static const routeName = '/artist-detail-page';

  @override
  Widget build(BuildContext context) {
    final String artistId = ModalRoute.of(context).settings.arguments as String;
    var artist = Provider.of<ArtistsProvider>(context).getArtist(artistId);
    var artistArtworks =
        Provider.of<ArtworksProvider>(context).getArtistArtworks(artist.name);

    return Scaffold(
      drawer: MainDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                  width: double.infinity,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(40),
                            bottomLeft: Radius.circular(40))),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: <Widget>[
                          Text(artist.name),
                          Text(artist.biography),
                        ],
                      ),
                    ),
                  )),
              Container(
                height: 500,
                child: ArtworksList(
                  allArtworks: artistArtworks,
                  artworkGroups: [
                    (ArtworksGroup(
                        artworks: artistArtworks,
                        title: artistArtworks.length > 1
                            ? '${artistArtworks.length} שירים'
                            : ''))
                  ],
                  sortType: SortType.Date,
                  showArtistName: false,
                  showDate: false,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
