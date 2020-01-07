import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

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
  DbService _dbService;

  ArtworksProvider() {
    _dbService = serviceLocator.get<DbService>();
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
    });
  }

  void setDisplayModel(ArtworksDisplayModel displayModel) {
    _displayModel = displayModel;
    sortArtworks();
  }

//TODO: Make it async!!!
  void sortArtworks() {
    this._artworkGroups = List<ArtworksGroup>();

    if (_artworks == null || _artworks.length == 0) {
      return;
    }

    if (_displayModel.searchQuery != '') {
      _sortBySearchQuery(_displayModel.searchQuery);
      return;
    }

    switch (_displayModel.sortType) {
      case SortType.Date:
        _sortByDate();
        break;
      case SortType.None:
        break;
      case SortType.ArtistName:
        _sortByArtistName();
        break;
      case SortType.ArtworkName:
        _sortByArtworkName();
        break;
      default:
        _sortByDate();
    }

    notifyListeners();
  }

  _sortBySearchQuery(String searchQuery) {
    var artworkBodyList = List<Artwork>();
    var artworkNameList = List<Artwork>();
    var artistNameList = List<Artwork>();

    for (var artwork in _artworks) {
      if (artwork.bodyText.contains(searchQuery)) {
        artworkBodyList.add(artwork);
      }
      if (artwork.title.contains(searchQuery)) {
        artworkNameList.add(artwork);
      }
      if (artwork.artistName.contains(searchQuery)) {
        artistNameList.add(artwork);
      }
    }

    _artworkGroups
        .add(ArtworksGroup(artworks: artworkNameList, title: 'שירים'));
    _artworkGroups
        .add(ArtworksGroup(artworks: artworkBodyList, title: 'מילים מתוך שיר'));
    _artworkGroups
        .add(ArtworksGroup(artworks: artistNameList, title: 'משוררים'));
  }

  _sortByDate() {
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
        this._artworkGroups.add(ag);
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
    this._artworkGroups.add(ag);
  }

  _sortByArtistName() {
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
        this._artworkGroups.add(ag);
        list = List<Artwork>();
        list.add(artwork);
        groupChar = artworkChar;
      }
    }

    var artwork = list[0];
    var ag = ArtworksGroup(artworks: list, title: artwork.artistName[0]);
    this._artworkGroups.add(ag);
  }

  _sortByArtworkName() {
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
        this._artworkGroups.add(ag);
        list = List<Artwork>();
        list.add(artwork);
        groupChar = artworkChar;
      }
    }

    var artwork = list[0];
    var ag = ArtworksGroup(artworks: list, title: artwork.title[0]);
    this._artworkGroups.add(ag);
  }

  void toggleFavorite(String artworkId) {
    var artwork = _artworks.firstWhere((a) => a.id == artworkId);
    artwork.isFavorite = !artwork.isFavorite;
    notifyListeners();
  }
}
