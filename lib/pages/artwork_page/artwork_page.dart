import 'package:flutter/material.dart';
import '../../models/artwork.dart';

class ArtworkPage extends StatelessWidget {
  static const routeName = '/artwork-page';
  @override
  Widget build(BuildContext context) {
    final artwork = ModalRoute.of(context).settings.arguments as Artwork;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(50),
          child: Column(
            children: <Widget>[
              Text(
                artwork.title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                artwork.artistName,
                style: TextStyle(
                    fontSize: 18,
                    color: Color.fromRGBO(248, 122, 100, 1),
                    fontWeight: FontWeight.bold),
              ),
              Text(
                artwork.bodyText,
                style: TextStyle(fontSize: 24),
              )
            ],
          ),
        ),
      ),
    );
  }
}
