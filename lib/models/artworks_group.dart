import 'artwork.dart';
import 'enums.dart';

class ArtworksGroup {
  final List<Artwork> artworks;
  final String title;
  final String searchQuery;
  final ArtworkSearchQueryArea searchQueryArea;

  ArtworksGroup({
    this.artworks,
    this.title,
    this.searchQueryArea = ArtworkSearchQueryArea.None,
    this.searchQuery = '',
  });
}
