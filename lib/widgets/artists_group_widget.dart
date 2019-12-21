import 'package:flutter/material.dart';

import '../models/ArtistsGroup.dart';
import 'artist_list_item.dart';

class ArtistsGroupWidget extends StatelessWidget {
  final ArtistsGroup artistsGroup;
  final Function onItemTapped;

  const ArtistsGroupWidget({this.artistsGroup, this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: (artistsGroup.artists.length * 73.0) + 36,
        child: Column(
          children: <Widget>[
            Container(
              child: Center(
                child: Container(
                  child: Text(
                    artistsGroup.title,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              height: 36,
            ),
            Container(
              height: artistsGroup.artists.length * 73.0,
              child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(0),
                  itemCount: artistsGroup.artists.length,
                  itemBuilder: (BuildContext context, int index) =>
                      ArtistListItem(
                        artist: artistsGroup.artists[index],
                        isLast: index == artistsGroup.artists.length - 1,
                        onTap: onItemTapped,
                      )),
            ),
          ],
        ));
  }
}
