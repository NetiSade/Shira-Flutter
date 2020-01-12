import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shira/providers/artworks_provider.dart';
import '../models/artwork.dart';
import '../models/enums.dart';

class ArtworkListItem extends StatelessWidget {
  final Artwork artwork;
  final bool isLast;
  final Function onTap;
  final bool showDate;
  final bool showArtistName;
  final String searchQuery;
  final ArtworkSearchQueryArea searchRQueryArea;

  const ArtworkListItem(
      {this.artwork,
      this.isLast,
      this.onTap,
      this.showArtistName = true,
      this.showDate = true,
      this.searchQuery = '',
      this.searchRQueryArea});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(artwork, context),
      child: Container(
        height: 73,
        child: Center(
          child: !isLast
              ? Container(
                  decoration: BoxDecoration(
                      border: Border(
                    bottom: BorderSide(
                        width: 1, color: Theme.of(context).primaryColor),
                  )),
                  child: Card(
                      margin: EdgeInsets.all(0),
                      child: _buildListTile(context)))
              : Card(
                  margin: EdgeInsets.all(0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(40),
                          bottomLeft: Radius.circular(40))),
                  child: _buildListTile(context)),
        ),
      ),
    );
  }

  Widget _buildListTile(BuildContext context) {
    if (showDate && showArtistName)
      return searchQuery == ''
          ? Container(
              height: 73,
              child: ListTile(
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
                trailing: GestureDetector(
                  onTap: () {
                    Provider.of<ArtworksProvider>(context, listen: false)
                        .toggleFavorite(artwork.id);
                  },
                  child: SvgPicture.asset(artwork.isFavorite
                      ? 'assets/images/fav-on.svg'
                      : 'assets/images/fav-off.svg'),
                ),
              ),
            )
          : _buildSearchResultListTile(context);
    else
      return Container(
        height: 73,
        child: ListTile(
          title: Text(
            artwork.title,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          trailing: GestureDetector(
            onTap: () {},
            child: SvgPicture.asset(
              'assets/images/fav-off.svg',
            ),
          ),
        ),
      );
  }

  Widget _buildSearchResultListTile(BuildContext context) {
    return Container(
      height: 73,
      child: searchRQueryArea == ArtworkSearchQueryArea.Body
          ? _buildSearchResultBody(context)
          : _buildSearchResultTitle(context),
    );
  }

  Widget _buildSearchResultBody(BuildContext context) {
    return ListTile(
        title: Text(
          '${artwork.title} / ${artwork.artistName}',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: _getBodyRichText(artwork.bodyText, context));
  }

  Widget _buildSearchResultTitle(BuildContext context) {
    return ListTile(title: _getTitleRichText(context));
  }

  Text _getTitleRichText(BuildContext context) {
    var title = artwork.title;
    var artistName = artwork.artistName;

    if (searchRQueryArea == ArtworkSearchQueryArea.Title) {
      var queryIndex = title.indexOf(searchQuery);
      var before = title.substring(0, queryIndex);
      var after = title.substring(queryIndex + searchQuery.length);

      return Text.rich(
        TextSpan(
          text: before,
          style: TextStyle(
            fontSize: 20,
          ), // default text style
          children: <TextSpan>[
            TextSpan(
              text: searchQuery,
              style: TextStyle(
                backgroundColor: Theme.of(context).primaryColor,
                fontSize: 20,
              ),
            ),
            TextSpan(
              text: after,
            ),
            TextSpan(
              text: " / $artistName",
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    } else {
      var queryIndex = artistName.indexOf(searchQuery);
      var before = artistName.substring(0, queryIndex);
      var after = artistName.substring(queryIndex + searchQuery.length);

      return Text.rich(
        TextSpan(
          style: TextStyle(
            fontSize: 20,
          ), // default text style
          children: <TextSpan>[
            TextSpan(text: before),
            TextSpan(
              text: searchQuery,
              style: TextStyle(backgroundColor: Theme.of(context).primaryColor),
            ),
            TextSpan(
              text: '$after / ',
            ),
            TextSpan(
              text: title,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }
  }

  Text _getBodyRichText(String text, BuildContext context) {
    var lines = LineSplitter().convert(text);
    var line = lines.firstWhere((l) => l.contains(searchQuery));

    var queryIndex = line.indexOf(searchQuery);
    var before = line.substring(0, queryIndex);
    var after = line.substring(queryIndex + searchQuery.length);

    return Text.rich(
      TextSpan(
        text: before,
        style: TextStyle(
          fontSize: 20,
        ), // default text style
        children: <TextSpan>[
          TextSpan(
            text: searchQuery,
            style: TextStyle(backgroundColor: Theme.of(context).primaryColor),
          ),
          TextSpan(
            text: after,
          ),
        ],
      ),
      overflow: TextOverflow.ellipsis,
    );
  }
}
