import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/artwork.dart';

//TODO: dependency injection
//TODO: DbService interface

class DbService {
  bool isLoggedIn() {
    return FirebaseAuth.instance.currentUser() != null;
  }

  Future<List<Artwork>> get getArtworks async {
    List<Artwork> list = List<Artwork>();
    await Firestore.instance
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

  // override fun listenToArtworks(handler: (ArrayList<Artwork>) -> Unit) {
  //       FirebaseFirestore.getInstance().collection(artworksCollectionRef).orderBy("publisheDate", Query.Direction.DESCENDING)
  //           .addSnapshotListener(EventListener<QuerySnapshot> { querySnapshot, e ->
  //               if (e != null)
  //               {
  //                   Log.w(ContentValues.TAG, "Listen error", e)
  //                   return@EventListener
  //               }

  //               if (querySnapshot != null) {
  //                   for (document in querySnapshot.documents) {
  //                       val source = if (querySnapshot.metadata.isFromCache)
  //                           "local cache"
  //                       else
  //                           "server"
  //                       Log.d(ContentValues.TAG, "Data fetched from $source")
  //                       try {
  //                           val artwork = document.toObject(Artwork::class.java)
  //                           if (artwork != null) {
  //                               val fixedArtwork = fixArtwork(artwork,document)
  //                               artworksArray.add(fixedArtwork)
  //                           }
  //                       } catch (e: Exception) {
  //                           Log.d(ContentValues.TAG, "Cannot create Artwork obj document: " + document.toString())
  //                           Log.d(ContentValues.TAG, e.toString())
  //                       }
  //                   }
  //               }
  //               handler(artworksArray)
  //           })
}
