import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/artist.dart';
import '../models/artwork.dart';

class DbService {
  final _db = Firestore.instance;

  Stream<List<Artwork>> streamArtworks() {
    return _db
        .collection('artworks')
        //.where('isPublic', isEqualTo: true)
        //.where('type', isEqualTo: 'poem')
        //.where('verifiedByEditor', isEqualTo: true)
        .orderBy('publisheDate')
        .snapshots()
        .map((list) => list.documents
            .map((doc) => Artwork.fromMap(
                  doc.data,
                  doc.documentID,
                ))
            .toList());
  }

  Stream<List<Artist>> streamArtists() {
    return _db
        .collection('artists')
        //.where('type', isEqualTo: 'poet')
        .orderBy('firstLetter')
        .snapshots()
        .map((list) => list.documents
            .map((doc) => Artist.fromMap(doc.data, doc.documentID))
            .toList());
  }

  Stream<List<Artwork>> streamArtworkOfToday() {
    final now = DateTime.now();
    final lastMidnight = new DateTime(now.year, now.month, now.day);
    final nextMidnight = new DateTime(now.year, now.month, now.day + 1);

    return _db
        .collection('artworks')
        //.where('isPublic', isEqualTo: true)
        //.where('type', isEqualTo: 'poem')
        //.where('verifiedByEditor', isEqualTo: true)
        .orderBy('publisheDate')
        .where('publisheDate', isGreaterThan: lastMidnight)
        .where('publisheDate', isLessThan: nextMidnight)
        .snapshots()
        .map((list) => list.documents
            .map((doc) => Artwork.fromMap(
                  doc.data,
                  doc.documentID,
                ))
            .toList());
  }

  static Future<Artwork> getArtworkOfTheToday() async {
    final now = DateTime.now();
    final lastMidnight = new DateTime(now.year, now.month, now.day);
    final nextMidnight = new DateTime(now.year, now.month, now.day + 1);

    return Firestore.instance
        .collection('artworks')
        .where('publisheDate', isGreaterThan: lastMidnight)
        .where('publisheDate', isLessThan: nextMidnight)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      if (snapshot.documents.length == 0) {
        return null;
      } else {
        return Artwork.fromMap(
          snapshot.documents[0].data,
          snapshot.documents[0].documentID,
        );
      }
    });
    //.catchError();
  }
}
