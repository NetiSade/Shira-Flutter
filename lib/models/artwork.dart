class Artwork {
  final String id;
  final String title;
  final String artistName;
  final String bodyText;
  final DateTime publisheDate;

  const Artwork(
      {this.id, this.title, this.artistName, this.bodyText, this.publisheDate});

  Artwork.fromMap(Map<String, dynamic> data, String id)
      : this(
            id: id,
            title: data['title'],
            artistName: data['artistName'],
            bodyText: data['bodyText'],
            publisheDate: data['publisheDate'].toDate());
}
