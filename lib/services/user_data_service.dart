import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDataService {
  final _db = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  FirebaseUser _currentUser;

  UserDataService() {
    initCurrentUser();
    checkUser();
  }

  void initCurrentUser() async {
    _currentUser = await _auth.currentUser();
  }

  void checkUser() async {
    if (_currentUser == null) {
      await _auth.signInAnonymously();
    }
  }

  Future<bool> isLoggedIn() async {
    return _currentUser != null;
  }

  updateArtworkViewed(String artworkId) {
    var data = {'viewed': DateTime.now()};
    var uid = _currentUser.uid;

    _db
        .collection('users')
        .document(uid)
        .collection('viewed_artworks')
        .document(artworkId)
        .setData(data, merge: true);
  }

  updateFavoriteArtwork(String artworkId, bool isFavorite) {
    updateArtworkViewed(artworkId);

    var uid = _currentUser.uid;
    var docRef = _db
        .collection('users')
        .document(uid)
        .collection('viewed_artworks')
        .document(artworkId);

    if (isFavorite) {
      var data = {'favorite': DateTime.now()};
      docRef.setData(data, merge: true);
    } else {
      var data = {'favorite': FieldValue.delete()};
      docRef.setData(data, merge: true);
    }
  }
}
