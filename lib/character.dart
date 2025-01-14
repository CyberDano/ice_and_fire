class Character {
  final String name;
  final String gender;
  final String culture;
  final String born;
  final String died;
  //final List<String> titles;
  //final List<String> aliases;
  final String father;
  final String mother;
  final String spouse;
  //final List<String> allegiances;
  //final List<String> books;
  //final List<String> povBooks;
  //final List<String> tvSeries;
  //final List<String> playedBy;

  const Character({
    required this.name,
    required this.gender,
    required this.culture,
    required this.born,
    required this.died,
    //required this.titles,
    //required this.aliases,
    required this.father,
    required this.mother,
    required this.spouse,
    //required this.allegiances,
    //required this.books,
    //required this.povBooks,
    //required this.tvSeries,
    //required this.playedBy*/
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      name: json['name'] as String,
      gender: json['gender'] as String,
      culture: json['culture'] as String,
      born: json['born'] as String,
      died: json['died'] as String,
      //titles: json['titles'] as List<String>,
      //aliases: json['aliases'] as List<String>,
      father: json['father'] as String,
      mother: json['mother'] as String,
      spouse: json['spouse'] as String,
      //allegiances: json['allegiances'] as List<String>,
      //books: json['books'] as List<String>,
      //povBooks: json['povBooks'] as List<String>,
      //tvSeries: json['tvSeries'] as List<String>,
      //playedBy: json['playedBy'] as List<String>*/
    );
  }
}
