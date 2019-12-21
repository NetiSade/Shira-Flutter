import 'package:flutter/material.dart';

import 'artwork_preview_list_item.dart';
import 'artworks_group_widget.dart';
import '../pages/artwork_page/artwork_page.dart';
import '../models/artwork.dart';
import '../models/artworks_group.dart';
import '../models/enums.dart';

class ArtworksList extends StatelessWidget {
  final SortType sortType;
  final List<ArtworksGroup> artworkGroups;
  final List<Artwork> allArtworks;
  final bool showDate;
  final bool showArtistName;

  const ArtworksList(
      {this.sortType,
      this.artworkGroups,
      this.allArtworks,
      this.showArtistName = true,
      this.showDate = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(246, 246, 246, 0),
      child: sortType != SortType.None
          ? artworkGroups == null
              ? Container(
                  color: Theme.of(context).accentColor,
                  child: Center(
                      child: Text(
                    'Loading',
                  )),
                )
              : _buildSortedGroups(context)
          : _buildArtworkPreviewList(context),
    );
  }

  Widget _buildSortedGroups(BuildContext context) {
    return ListView.builder(
        itemCount: artworkGroups.length,
        itemBuilder: (BuildContext context, int index) => ArtworksGroupWidget(
            artworkGroup: artworkGroups[index],
            onItemTapped: _navToArtworkPage,
            showDate: showDate,
            showArtistName: showArtistName));
  }

  Widget _buildArtworkPreviewList(BuildContext buildContext) {
    return ListView.builder(
        itemCount: allArtworks.length,
        itemBuilder: (BuildContext context, int index) =>
            ArtworkPreviewListItem(
              artwork: allArtworks[index],
              onTap: _navToArtworkPage,
            ));
  }

  _navToArtworkPage(Artwork artwork, BuildContext context) {
    Navigator.of(context).pushNamed(ArtworkPage.routeName, arguments: artwork);
  }
}
