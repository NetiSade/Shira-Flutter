import 'enums.dart';

class ArtistsDisplayModel {
  SortType sortType;
  bool descendingOrder;
  String searchQuery;

  ArtistsDisplayModel(
      {this.sortType = SortType.ArtistName,
      this.descendingOrder = true,
      this.searchQuery = ''});
}
