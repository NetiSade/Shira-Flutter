import 'enums.dart';

class ArtworksDisplayModel {
  SortType sortType;
  bool showViewed;
  bool descendingOrder;
  String searchQuery;

  ArtworksDisplayModel(
      {this.sortType = SortType.Date,
      this.showViewed = true,
      this.descendingOrder = true,
      this.searchQuery = ''});
}
