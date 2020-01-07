import 'package:flutter/material.dart';

import '../models/artist.dart';

class ArtistListItem extends StatelessWidget {
  final Artist artist;
  final bool isLast;
  final Function onTap;

  const ArtistListItem({this.artist, this.isLast, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(context, artist.id),
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
                      child: Container(
                        height: 73,
                        child: _buildListTile(),
                      )))
              : Card(
                  margin: EdgeInsets.all(0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(40),
                          bottomLeft: Radius.circular(40))),
                  child: Container(
                    height: 73,
                    child: _buildListTile(),
                  )),
        ),
      ),
    );
  }

  Widget _buildListTile() {
    return ListTile(
      title: Text(
        artist.name,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
      // trailing: GestureDetector(
      //   onTap: () {},
      //   child: SvgPicture.asset(
      //     'assets/images/fav-on.svg',
      //   ),
      // ),
    );
  }
}
