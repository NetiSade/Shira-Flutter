import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/artworks_provider.dart';
import 'artwork_preview_list_item.dart';
import 'artworks_group_widget.dart';
import '../pages/artwork_page/artwork_page.dart';
import '../models/artwork.dart';
import '../models/artworks_group.dart';
import '../models/enums.dart';

class ArtworksList extends StatelessWidget {
  final bool showDate;
  final bool showArtistName;
  final String artistName;

  const ArtworksList({
    this.showArtistName = true,
    this.showDate = true,
    this.artistName = '',
  });

  @override
  Widget build(BuildContext context) {
    var artworksProvider = Provider.of<ArtworksProvider>(context);
    var allArtworks = artworksProvider.artworks;
    var groups = artworksProvider.artworkGroups;
    var sortType = artworksProvider.displayModel.sortType;

    return artistName == ''
        ? Container(
            color: Color.fromRGBO(246, 246, 246, 0),
            child: sortType != SortType.None
                ? _buildSortedGroups(context, groups)
                : _buildArtworkPreviewList(context, allArtworks),
          )
        : Container(
            color: Color.fromRGBO(246, 246, 246, 0),
            child: _buildSortedGroups(
                context, [artworksProvider.getArtistArtworks(artistName)]));
  }

  Widget _buildSortedGroups(
      BuildContext context, List<ArtworksGroup> artworkGroups) {
    return ListView.builder(
        itemCount: artworkGroups.length,
        itemBuilder: (BuildContext context, int index) => ArtworksGroupWidget(
            artworkGroup: artworkGroups[index],
            onItemTapped: _navToArtworkPage,
            showDate: showDate,
            showArtistName: showArtistName));
  }

  Widget _buildArtworkPreviewList(
      BuildContext buildContext, List<Artwork> artworks) {
    return ListView.builder(
        itemCount: artworks.length,
        itemBuilder: (BuildContext context, int index) =>
            ArtworkPreviewListItem(
              artwork: artworks[index],
              onTap: _navToArtworkPage,
            ));
  }

  _navToArtworkPage(Artwork artwork, BuildContext context) {
    Navigator.of(context).pushNamed(ArtworkPage.routeName, arguments: artwork);
  }
}
