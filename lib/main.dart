import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'models/artwork.dart';
import 'services/db_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shira',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          accentColor: Color.fromRGBO(154, 226, 197, 1)),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<List<Artwork>> artworks;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: artworks == null
          ? Container(
              color: Theme.of(context).accentColor,
              child: Center(
                  child: Text(
                'Loading',
              )),
            )
          : ListView(
              children: artworks
                  .map((monthGroup) => _buildMonthGroup(monthGroup))
                  .toList(),
            ),
    );
  }

  @override
  void initState() {
    super.initState();
    DbService().getArtworks.then((artworks) {
      setState(() {
        initArtworks(artworks);
      });
    });
  }

  void initArtworks(List<Artwork> artworks) {
    this.artworks = List<List<Artwork>>();

    if (artworks == null || artworks.length == 0) {
      return;
    }

    var artworkDate = artworks[0].publisheDate;
    var dateStr = artworkDate.year.toString() + artworkDate.month.toString();

    var list = List<Artwork>();

    for (var i = 0; i < artworks.length; i++) {
      var artwork = artworks[i];
      var date = artwork.publisheDate;
      var dId = date.year.toString() + date.month.toString();
      if (dId == dateStr) {
        list.add(artworks[i]);
      } else {
        this.artworks.add(list);
        list = List<Artwork>();
        list.add(artwork);
        dateStr = dId;
      }
    }

    this.artworks.add(list);
  }

  Widget _buildMonthGroup(List<Artwork> artworkGroup) {
    return Container(
        height: (artworkGroup.length * 73.0) + 60,
        margin: EdgeInsets.fromLTRB(0, 0, 0, 50),
        child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(0),
            itemCount: artworkGroup.length,
            itemBuilder: (BuildContext context, int index) => _buildListItem(
                artworkGroup[index], index == artworkGroup.length - 1))
        // child: ListView(
        //   physics: ScrollPhysics(),
        //   children: artworkGroup
        //       .map((artwork) =>
        //           _buildListItem(artwork, artwork == artworkGroup.last))
        //       .toList(),
        // ),
        );
  }

  Widget _buildListItem(Artwork artwork, bool isLast) {
    return Container(
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
                          child: ListTile(
                            leading: IconButton(
                              icon: Icon(Icons.favorite_border,
                                  color: Theme.of(context).accentColor),
                              onPressed: () => {},
                            ),
                            title: Text(
                              artwork.title,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.end,
                            ),
                            subtitle: Text(
                              artwork.artistName,
                              style: TextStyle(fontSize: 12),
                              textAlign: TextAlign.end,
                            ),
                            trailing: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(3),
                                  child: Text(
                                    DateFormat('E')
                                        .format(artwork.publisheDate),
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(3),
                                  child: Text(
                                      artwork.publisheDate.day.toString(),
                                      style: TextStyle(fontSize: 12)),
                                ),
                              ],
                            ),
                          ),
                        ),
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
                      child: ListTile(
                        leading: IconButton(
                          icon: Icon(Icons.favorite_border,
                              color: Theme.of(context).accentColor),
                          onPressed: () => {},
                        ),
                        title: Text(
                          artwork.title,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.end,
                        ),
                        subtitle: Text(
                          artwork.artistName,
                          style: TextStyle(fontSize: 12),
                          textAlign: TextAlign.end,
                        ),
                        trailing: Column(
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
                      ),
                    ),
                  ],
                )),
      ),
    );
  }
}
