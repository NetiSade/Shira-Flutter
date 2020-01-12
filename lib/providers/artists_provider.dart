import 'package:flutter/widgets.dart';

import '../models/enums.dart';
import '../models/artists_disply_model.dart';
import '../models/artists_group.dart';
import '../locator.dart';
import '../models/artist.dart';
import '../services/db_service.dart';

class ArtistsProvider with ChangeNotifier {
  List<Artist> _artists = List<Artist>();
  ArtistsDisplayModel _displayModel = ArtistsDisplayModel();
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

  ArtistsDisplayModel get displayModel {
    return _displayModel;
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

  void setDisplayModel(ArtistsDisplayModel displayModel) {
    _displayModel = displayModel;
    sortArtists();
  }

  void sortArtists() async {
    if (_artists == null || _artists.length == 0) {
      return;
    }

    if (_displayModel.searchQuery != '') {
      await Future(() => _sortBySearchQuery(_displayModel.searchQuery));
    } else {
      _buildArtistsGroups();
      // switch (_displayModel.sortType) {
      //   case SortType.Date:
      //     await Future(() => _sortByDate());
      //     break;
      //   case SortType.None:
      //     break;
      //   case SortType.ArtistName:
      //     await Future(() => _sortByArtistName());
      //     break;
      // case SortType.ArtworkName:
      //   await Future(() => _sortByArtworkName());
      //   break;
      // default:
      //   await Future(() => _sortByDate());
    }

    notifyListeners();
  }

  void _sortBySearchQuery(String searchQuery) {
    var res =
        _artists.where((artist) => artist.name.contains(searchQuery)).toList();

    var group = ArtistsGroup(artists: res, title: '');

    _artistsGroups = [group];
  }
}
