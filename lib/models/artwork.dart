import 'dart:convert';

class Artwork {
  final String id;
  final String title;
  final String artistName;
  final String bodyText;
  final DateTime publisheDate;
  final String copyright;
  final String note;
  final String source;
  final String sourceLang;
  final String strippedBodyText;
  final String strippedTitle;
  bool isFavorite = false;

  Artwork.fromMap(Map<String, dynamic> data, String id)
      : id = id ?? '',
        title = data['title'] ?? '',
        artistName = data['artistName'] ?? '',
        bodyText = data['bodyText'] ?? '',
        copyright = data['copyright'] ?? '',
        note = data['note'] ?? '',
        source = data['source'] ?? '',
        sourceLang = data['sourceLang'] ?? '',
        strippedBodyText = data['strippedBodyText'] ?? '',
        strippedTitle = data['strippedTitle'] ?? '',
        publisheDate = data['publisheDate'].toDate();

  String getFirstBodyLines() {
    List<String> lines = new LineSplitter().convert(bodyText);
    return lines.length >= 3
        ? lines[0] + '\n' + lines[1] + '\n' + lines[2] + '\n' + '...'
        : lines[0] + '\n' + '...';
  }
}
