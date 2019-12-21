import 'package:flutter/widgets.dart';

import '../locator.dart';
import '../models/artwork.dart';
import '../services/db_service.dart';

class ArtworksProvider with ChangeNotifier {
  List<Artwork> _artworks = List<Artwork>();
  DbService _dbService;

  ArtworksProvider() {
    _dbService = serviceLocator.get<DbService>();
    startListening();
  }

  List<Artwork> get artworks {
    return [..._artworks];
  }

  List<Artwork> getArtistArtworks(String artistName) {
    return _artworks.where((a) => a.artistName == artistName).toList();
  }

  void startListening() {
    _dbService.streamArtworks().listen((artworks) {
      _artworks = artworks;
      notifyListeners();
    });
  }
}
