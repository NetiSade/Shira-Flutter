import 'package:flutter/widgets.dart';

import '../models/ArtistsGroup.dart';
import '../locator.dart';
import '../models/artist.dart';
import '../services/db_service.dart';

class ArtistsProvider with ChangeNotifier {
  List<Artist> _artists = List<Artist>();
  List<ArtistsGroup> _artistsGroups = List<ArtistsGroup>();
  DbService _dbService;

  ArtistsProvider() {
    _dbService = serviceLocator.get<DbService>();
    startListening();
  }

  List<Artist> get artists {
    return [..._artists];
  }

  List<ArtistsGroup> get artistGroups {
    return [..._artistsGroups];
  }

  Artist getArtist(artistId) {
    return _artists.firstWhere((a) => a.id == artistId);
  }

  void startListening() {
    _dbService.streamArtists().listen((artists) {
      _artists = artists;
      _buildArtistsGroups();
      notifyListeners();
    });
  }

  void _buildArtistsGroups() {
    if (_artists.length <= 0) return;

    var all = [..._artists];
    var groupsList = List<ArtistsGroup>();

    var groupLetter = all[0].firstLetter;
    var group = List<Artist>();

    for (var i = 0; i < all.length; i++) {
      var artist = all[i];

      if (groupLetter == artist.firstLetter) {
        group.add(artist);
      } else {
        var ag = ArtistsGroup(artists: group, title: groupLetter);
        groupsList.add(ag);

        group = List<Artist>();
        group.add(artist);
        groupLetter = artist.firstLetter;
      }
    }

    var artist = group[0];
    var ag = ArtistsGroup(artists: group, title: artist.firstLetter);
    groupsList.add(ag);

    _artistsGroups = groupsList;
  }
}
