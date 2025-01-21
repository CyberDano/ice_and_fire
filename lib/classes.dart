/// Clase para los personajes
class Character {
  final String url;
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
  final bool fav;

  const Character({
    required this.url,
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
    required this.fav
  });

// Método para crear una instancia de Character a partir de JSON
  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
        url: json['url'],
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
        playedBy: List<String>.from(json['playedBy']),
        fav: false);
  }
}

/// Clase para las casas
class House {
  final String url;
  final String name;
  final String region;
  final String coatOfArms;
  final String words;
  final List<String> titles;
  final List<String> seats;
  final String currentLord;
  final String heir;
  final String overlord;
  final String founded;
  final String founder;
  final String diedOut;
  final List<String> ancestralWeapons;
  final List<String> cadetBranches;
  final List<String> swornMembers;

  const House(
      {required this.url,
      required this.name,
      required this.region,
      required this.coatOfArms,
      required this.words,
      required this.titles,
      required this.seats,
      required this.currentLord,
      required this.heir,
      required this.overlord,
      required this.founded,
      required this.founder,
      required this.diedOut,
      required this.ancestralWeapons,
      required this.cadetBranches,
      required this.swornMembers});

// Método para crear una instancia de House a partir de JSON
  factory House.fromJson(Map<String, dynamic> json) {
    return House(
        url: json['url'],
        name: json['name'],
        region: json['region'],
        coatOfArms: json['coatOfArms'],
        words: json['words'],
        titles: List<String>.from(json['titles']),
        seats: List<String>.from(json['seats']),
        currentLord: json['currentLord'],
        heir: json['heir'],
        overlord: json['overlord'],
        founded: json['founded'],
        founder: json['founder'],
        diedOut: json['diedOut'],
        ancestralWeapons: List<String>.from(json['ancestralWeapons']),
        cadetBranches: List<String>.from(json['cadetBranches']),
        swornMembers: List<String>.from(json['swornMembers']));
  }
}

/// Clase para los libros
class Book {
  final String url;
  final String name;
  final String isbn;
  final List<String> authors;
  final int pages;
  final String publisher;
  final String country;
  final String mediaType;
  final String released;
  final List<String> characters;
  final List<String> povCharacters;

  const Book(
      {required this.url,
      required this.name,
      required this.isbn,
      required this.authors,
      required this.pages,
      required this.publisher,
      required this.country,
      required this.mediaType,
      required this.released,
      required this.characters,
      required this.povCharacters});

// Método para crear una instancia de House a partir de JSON
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
        url: json['url'],
        name: json['name'],
        isbn: json['isbn'],
        authors: List<String>.from(json['authors']),
        pages: json['numberOfPages'],
        publisher: json['publisher'],
        country: json['country'],
        mediaType: json['mediaType'],
        released: json['released'],
        characters: List<String>.from(json['characters']),
        povCharacters: List<String>.from(json['povCharacters']));
  }
}
