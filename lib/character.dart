class Character {
  final String name;
  final String gender;
  final String culture;
  final String born;
  final String died;
  final List<String> titles;
  final List<String> aliases;
  final String father;
  final String mother;
  final String spouse;
  final List<String> allegiances;
  final List<String> books;
  final List<String> povBooks;
  final List<String> tvSeries;
  final List<String> playedBy;

  const Character({
    required this.name,
    required this.gender,
    required this.culture,
    required this.born,
    required this.died,
    required this.titles,
    required this.aliases,
    required this.father,
    required this.mother,
    required this.spouse,
    required this.allegiances,
    required this.books,
    required this.povBooks,
    required this.tvSeries,
    required this.playedBy,
  });

// Método para crear una instancia de Character a partir de JSON
  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
        name: json['name'],
        gender: json['gender'],
        culture: json['culture'],
        born: json['born'],
        died: json['died'],
        titles: List<String>.from(json['titles']),
        aliases: List<String>.from(json['aliases']),
        father: json['father'],
        mother: json['mother'],
        spouse: json['spouse'],
        allegiances: List<String>.from(json['allegiances']),
        books: List<String>.from(json['books']),
        povBooks: List<String>.from(json['povBooks']),
        tvSeries: List<String>.from(json['tvSeries']),
        playedBy: List<String>.from(json['playedBy']));
  }
}
