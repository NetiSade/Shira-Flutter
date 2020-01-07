import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shira/providers/artworks_provider.dart';
import '../models/artwork.dart';

class ArtworkListItem extends StatelessWidget {
  final Artwork artwork;
  final bool isLast;
  final Function onTap;
  final bool showDate;
  final bool showArtistName;

  const ArtworkListItem(
      {this.artwork,
      this.isLast,
      this.onTap,
      this.showArtistName = true,
      this.showDate = true});

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
      return Container(
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
      );
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
}
