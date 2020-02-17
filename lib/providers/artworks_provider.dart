import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../services/user_data_service.dart';
import '../models/enums.dart';
import '../models/artworks_display_model.dart';
import '../models/artworks_group.dart';
import '../locator.dart';
import '../models/artwork.dart';
import '../services/db_service.dart';

class ArtworksProvider with ChangeNotifier {
  List<Artwork> _artworks = List<Artwork>();
  ArtworksDisplayModel _displayModel = ArtworksDisplayModel();
  List<ArtworksGroup> _artworkGroups = List<ArtworksGroup>();
  Artwork _todayArtwork;
  DbService _dbService;
  UserDataService _userDataService;

  ArtworksProvider() {
    _dbService = serviceLocator.get<DbService>();
    _userDataService = serviceLocator.get<UserDataService>();
    startListening();
  }

  List<Artwork> get artworks {
    return [..._artworks];
  }

  List<Artwork> get favoriteArtworks {
    return [..._artworks.where((a) => a.isFavorite).toList()];
  }

  List<ArtworksGroup> get artworkGroups {
    return [..._artworkGroups];
  }

  Artwork get todayArtwork {
    return _todayArtwork;
  }

  getTheArtworkOfToday(Function onData) {
    _dbService.streamArtworkOfToday().listen((artworks) {
      artworks != null || artworks.length == 0
          ? onData(null)
          : onData(artworks[0]);
    }).onError((err) => print(err));
  }

  ArtworksGroup getArtistArtworks(String artistName) {
    var artworks = _artworks.where((a) => a.artistName == artistName).toList();
    return ArtworksGroup(
        artworks: artworks,
        title: artworks.length > 1 ? '${artworks.length} שירים' : '');
  }

  ArtworksDisplayModel get displayModel {
    return _displayModel;
  }

  void startListening() {
    _dbService.streamArtworks().listen((artworks) {
      _artworks = artworks;
      sortArtworks();
      notifyListeners();
    }).onError((err) => print(err));

    _dbService.streamArtworkOfToday().listen((artworks) {
      _todayArtwork =
          artworks != null && artworks.length > 0 ? artworks[0] : null;
      notifyListeners();
    }).onError((err) => print(err));
  }

  void setDisplayModel(ArtworksDisplayModel displayModel) {
    _displayModel = displayModel;
    sortArtworks();
  }

  void sortArtworks() async {
    if (_artworks == null || _artworks.length == 0) {
      return;
    }

    var groups = List<ArtworksGroup>();
    if (_displayModel.searchQuery != '') {
      groups =
          await Future(() => _sortBySearchQuery(_displayModel.searchQuery));
    } else {
      switch (_displayModel.sortType) {
        case SortType.Date:
          groups = await Future(() => _sortByDate());
          break;
        case SortType.None:
          break;
        case SortType.ArtistName:
          groups = await Future(() => _sortByArtistName());
          break;
        case SortType.ArtworkName:
          groups = await Future(() => _sortByArtworkName());
          break;
        default:
          groups = await Future(() => _sortByDate());
      }
    }

    _artworkGroups = groups;
    notifyListeners();
  }

  List<ArtworksGroup> _sortBySearchQuery(String searchQuery) {
    var groups = List<ArtworksGroup>();

    var artworkBodyList =
        _artworks.where((a) => a.bodyText.contains(searchQuery)).toList();
    var artworkNameList =
        _artworks.where((a) => a.title.contains(searchQuery)).toList();
    var artistNameList =
        _artworks.where((a) => a.artistName.contains(searchQuery)).toList();

    groups.add(ArtworksGroup(
        artworks: artworkNameList,
        title: 'שירים',
        searchQuery: searchQuery,
        searchQueryArea: ArtworkSearchQueryArea.Title));
    groups.add(ArtworksGroup(
        artworks: artworkBodyList,
        title: 'מילים מתוך שיר',
        searchQuery: searchQuery,
        searchQueryArea: ArtworkSearchQueryArea.Body));
    groups.add(ArtworksGroup(
        artworks: artistNameList,
        title: 'משוררים',
        searchQuery: searchQuery,
        searchQueryArea: ArtworkSearchQueryArea.ArtistName));

    return groups;
  }

  List<ArtworksGroup> _sortByDate() {
    var groups = List<ArtworksGroup>();
    _displayModel.descendingOrder
        ? _artworks.sort((b, a) => a.publisheDate.compareTo(b.publisheDate))
        : _artworks.sort((a, b) => a.publisheDate.compareTo(b.publisheDate));

    var groupDate = _artworks[0].publisheDate;

    var list = List<Artwork>();

    for (var i = 0; i < _artworks.length; i++) {
      var artwork = _artworks[i];
      var artworkDate = artwork.publisheDate;

      if (artworkDate.year == groupDate.year &&
          artworkDate.month == groupDate.month) {
        list.add(_artworks[i]);
      } else {
        var ag = ArtworksGroup(
            artworks: list,
            title:
                "${DateFormat('MMMM').format(artwork.publisheDate)} ${artwork.publisheDate.year}");
        groups.add(ag);
        list = List<Artwork>();
        list.add(artwork);
        groupDate = artworkDate;
      }
    }
    var artwork = list[0];
    var ag = ArtworksGroup(
        artworks: list,
        title:
            "${DateFormat('MMMM').format(artwork.publisheDate)} ${artwork.publisheDate.year}");
    groups.add(ag);
    return groups;
  }

  List<ArtworksGroup> _sortByArtistName() {
    var groups = List<ArtworksGroup>();
    _displayModel.descendingOrder
        ? _artworks.sort((b, a) => a.artistName.compareTo(b.artistName))
        : _artworks.sort((a, b) => a.artistName.compareTo(b.artistName));

    var groupChar = _artworks[0].artistName[0];

    var list = List<Artwork>();

    for (var i = 0; i < _artworks.length; i++) {
      var artwork = _artworks[i];
      var artworkChar = artwork.artistName[0];

      if (groupChar == artworkChar) {
        list.add(_artworks[i]);
      } else {
        var ag = ArtworksGroup(artworks: list, title: groupChar);
        groups.add(ag);
        list = List<Artwork>();
        list.add(artwork);
        groupChar = artworkChar;
      }
    }

    var artwork = list[0];
    var ag = ArtworksGroup(artworks: list, title: artwork.artistName[0]);
    groups.add(ag);
    return groups;
  }

  List<ArtworksGroup> _sortByArtworkName() {
    var groups = List<ArtworksGroup>();
    _displayModel.descendingOrder
        ? _artworks.sort((b, a) => a.title.compareTo(b.title))
        : _artworks.sort((a, b) => a.title.compareTo(b.title));

    var groupChar = _artworks[0].title[0];

    var list = List<Artwork>();

    for (var i = 0; i < _artworks.length; i++) {
      var artwork = _artworks[i];
      var artworkChar = artwork.title[0];

      if (groupChar == artworkChar) {
        list.add(_artworks[i]);
      } else {
        var ag = ArtworksGroup(artworks: list, title: groupChar);
        groups.add(ag);
        list = List<Artwork>();
        list.add(artwork);
        groupChar = artworkChar;
      }
    }

    var artwork = list[0];
    var ag = ArtworksGroup(artworks: list, title: artwork.title[0]);
    groups.add(ag);
    return groups;
  }

  void toggleFavorite(String artworkId) {
    var artwork = _artworks.firstWhere((a) => a.id == artworkId);
    artwork.isFavorite = !artwork.isFavorite;
    _userDataService.updateFavoriteArtwork(artworkId, artwork.isFavorite);
    notifyListeners();
  }

  getArtwork(String artworkId) {
    return artworks.firstWhere((a) => a.id == artworkId);
  }
}
