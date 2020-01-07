import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/artist.dart';
import '../models/artwork.dart';

class DbService {
  final _db = Firestore.instance;
  final _auth = FirebaseAuth.instance;

  bool isLoggedIn() {
    return _auth.currentUser() != null;
  }

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
}
