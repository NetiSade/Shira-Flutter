class Artist {
  final String id;
  final String name;
  final String firstLetter;
  final String biography;

  const Artist({this.id, this.name, this.firstLetter, this.biography});

  Artist.fromMap(Map<String, dynamic> data, String id)
      : id = id ?? '',
        name = data['name'] ?? '',
        firstLetter = data['firstLetter'] ?? '',
        biography = data['biography'] ?? '';
}
