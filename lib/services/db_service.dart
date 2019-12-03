import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/artwork.dart';

class DbService {
  final _db = Firestore.instance;
  final _auth = FirebaseAuth.instance;

  bool isLoggedIn() {
    return _auth.currentUser() != null;
  }

  Future<List<Artwork>> get getArtworks async {
    List<Artwork> list = List<Artwork>();
    await _db
        .collection('artworks')
        .orderBy('publisheDate', descending: true)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        try {
          list.add(Artwork.fromMap(f.data, f.documentID));
        } catch (e) {}
      });
    });

    return list;
  }

  Future<Artwork> getArtwork(String id) async {
    var snap = await _db.collection('artworks').document(id).get();

    return Artwork.fromMap(snap.data, id);
  }

  Stream<List<Artwork>> streamArtworks() {
    return _db.collection('artworks').snapshots().map((list) => list.documents
        .map((doc) => Artwork.fromMap(doc.data, doc.documentID))
        .toList());
  }

  void startListening(Function onSnapshots) {
    _db.collection('artworks').snapshots().listen((snap) {
      onSnapshots(
          snap.documents.map((d) => Artwork.fromMap(d.data, d.documentID)));
    });
  }
}
