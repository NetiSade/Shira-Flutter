import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/artwork.dart';

class ArtworkPreviewListItem extends StatelessWidget {
  final Artwork artwork;
  final Function onTap;

  const ArtworkPreviewListItem({this.artwork, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(artwork, context),
      child: Container(
        height: 324,
        child: Container(
            child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(40),
            bottomLeft: Radius.circular(40),
          )),
          margin: EdgeInsets.all(0),
          child: Column(
            children: <Widget>[
              Container(height: 274, child: _buildListTile(context)),
              Container(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 15),
                  child: Row(
                    children: <Widget>[
                      Text(DateFormat('E').format(artwork.publisheDate)),
                      SizedBox(
                        width: 180,
                      ),
                      Text(
                        artwork.publisheDate.toString(),
                      ),
                    ],
                  ),
                ),
                decoration: ShapeDecoration(
                    color: Colors.grey[400],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(40),
                            bottomLeft: Radius.circular(40)))),
                height: 50,
              )
            ],
          ),
        )),
      ),
    );
  }

  Widget _buildListTile(BuildContext context) {
    return ListTile(
      trailing: IconButton(
        icon:
            Icon(Icons.favorite_border, color: Theme.of(context).primaryColor),
        onPressed: () => {},
      ),
      title: Text(
        artwork.title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
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
      contentPadding: EdgeInsets.all(12),
    );
  }
}
