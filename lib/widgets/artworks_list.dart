import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../pages/artwork_page/artwork_page.dart';
import '../models/artwork.dart';
import '../models/artworks_group.dart';
import '../models/enums.dart';

class ArtworksList extends StatelessWidget {
  const ArtworksList(
      {Key key,
      @required SortType sortType,
      @required List<ArtworkGroup> artworkGroups,
      @required List<Artwork> allArtworks})
      : _sortType = sortType,
        _artworkGroups = artworkGroups,
        _allArtworks = allArtworks,
        super(key: key);

  final SortType _sortType;
  final List<ArtworkGroup> _artworkGroups;
  final List<Artwork> _allArtworks;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(246, 246, 246, 0),
      child: _sortType != SortType.None
          ? _artworkGroups == null
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

  Widget _buildListItem(Artwork artwork, bool isLast, BuildContext context) {
    return InkWell(
      onTap: () => _navToArtworkPage(artwork, context),
      child: Container(
        height: 73,
        child: Center(
          child: !isLast
              ? Container(
                  decoration: BoxDecoration(
                      border: Border(
                    bottom: BorderSide(
                        width: 1, color: Theme.of(context).accentColor),
                  )),
                  child: Card(
                      margin: EdgeInsets.all(0),
                      child: Column(
                        children: <Widget>[
                          Container(
                              child: _buildArtworkListTile(artwork, context)),
                        ],
                      )))
              : Card(
                  margin: EdgeInsets.all(0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(40),
                          bottomLeft: Radius.circular(40))),
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: _buildArtworkListTile(artwork, context),
                      ),
                    ],
                  )),
        ),
      ),
    );
  }

  Widget _buildPreviewListItem(
      Artwork artwork, bool isLast, BuildContext context) {
    return InkWell(
      onTap: () => _navToArtworkPage(artwork, context),
      child: Container(
        height: 324,
        child: Center(
          child: !isLast
              ? Container(
                  decoration: BoxDecoration(
                      border: Border(
                    bottom: BorderSide(
                        width: 1, color: Theme.of(context).accentColor),
                  )),
                  child: Card(
                      margin: EdgeInsets.all(0),
                      child: Column(
                        children: <Widget>[
                          Container(
                              child: _buildArtworkPreviewListTile(
                                  artwork, context)),
                        ],
                      )))
              : Card(
                  margin: EdgeInsets.all(0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(40),
                          bottomLeft: Radius.circular(40))),
                  child: Container(
                    child: _buildArtworkListTile(artwork, context),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildArtworkListTile(Artwork artwork, BuildContext context) {
    return ListTile(
      leading: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(3),
            child: Text(
              DateFormat('E').format(artwork.publisheDate),
              style: TextStyle(fontSize: 20),
            ),
          ),
          Container(
            padding: EdgeInsets.all(3),
            child: Text(artwork.publisheDate.day.toString(),
                style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
      title: Text(
        artwork.title,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        artwork.artistName,
        style: TextStyle(fontSize: 12),
      ),
      trailing: IconButton(
        icon: Icon(Icons.favorite_border, color: Theme.of(context).accentColor),
        onPressed: () => {},
      ),
    );
  }

  Widget _buildArtworkPreviewListTile(Artwork artwork, BuildContext context) {
    return ListTile(
      leading: IconButton(
        icon: Icon(Icons.favorite_border, color: Theme.of(context).accentColor),
        onPressed: () => {},
      ),
      title: Text(
        artwork.title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        textAlign: TextAlign.end,
      ),
      subtitle: Column(
        children: <Widget>[
          Text(
            artwork.artistName,
            style: TextStyle(fontSize: 12),
            textAlign: TextAlign.end,
          ),
          Text(
            artwork.bodyText,
            style: TextStyle(fontSize: 20),
            maxLines: 6,
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }

  Widget _buildSortedGroups(BuildContext context) {
    return ListView.builder(
        itemCount: _artworkGroups.length,
        itemBuilder: (BuildContext context, int index) =>
            _buildArtworkGroup(_artworkGroups[index]));
  }

  Widget _buildArtworkPreviewList(BuildContext buildContext) {
    return ListView.builder(
        itemCount: _allArtworks.length,
        itemBuilder: (BuildContext context, int index) => _buildPreviewListItem(
            _allArtworks[index],
            _allArtworks.last == _allArtworks[index],
            context));
  }

  Widget _buildArtworkGroup(ArtworkGroup artworkGroup) {
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
                      _buildListItem(artworkGroup.artworks[index],
                          index == artworkGroup.artworks.length - 1, context)),
            ),
          ],
        ));
  }

  _navToArtworkPage(Artwork artwork, BuildContext context) {
    Navigator.of(context).pushNamed(ArtworkPage.routeName, arguments: artwork);
  }
}
