import 'package:flutter/material.dart';
import 'package:shira/models/artworks_group.dart';

import 'artwork_list_item.dart';

class ArtworksGroupWidget extends StatelessWidget {
  final ArtworksGroup artworkGroup;
  final Function onItemTapped;
  final bool showDate;
  final bool showArtistName;

  const ArtworksGroupWidget(
      {this.artworkGroup,
      this.onItemTapped,
      this.showArtistName = true,
      this.showDate = true});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color.fromARGB(0, 248, 248, 248),
        height: (artworkGroup.artworks.length * 73.0) + 36,
        child: Column(
          children: <Widget>[
            Container(
              child: Center(
                child: Text(
                  artworkGroup.title,
                  style: TextStyle(
                    color: Color.fromRGBO(100, 100, 100, 1),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              height: 36,
            ),
            Container(
              height: artworkGroup.artworks.length * 73.0,
              child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(0),
                  itemCount: artworkGroup.artworks.length,
                  itemBuilder: (BuildContext context, int index) =>
                      ArtworkListItem(
                          artwork: artworkGroup.artworks[index],
                          isLast: index == artworkGroup.artworks.length - 1,
                          onTap: onItemTapped,
                          showDate: showDate,
                          showArtistName: showArtistName)),
            ),
          ],
        ));
  }
}
