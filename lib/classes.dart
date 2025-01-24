import 'package:flutter/material.dart';
import 'package:ice_and_fire/bookpage.dart';
import 'package:ice_and_fire/characterpage.dart';
import 'package:ice_and_fire/housepage.dart';

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

  const Character(
      {required this.url,
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
      required this.playedBy});

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
    );
  }

  // Método para convertir una instancia de Character a JSON
  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'name': name,
      'gender': gender,
      'culture': culture,
      'born': born,
      'died': died,
      'titles': titles,
      'aliases': aliases,
      'father': father,
      'mother': mother,
      'spouse': spouse,
      'allegiances': allegiances,
      'books': books,
      'povBooks': povBooks,
      'tvSeries': tvSeries,
      'playedBy': playedBy,
    };
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

class Methods {
  static int itemCountToShow(List<String> param, int itemsToShow) {
    if (param.length < itemsToShow) {
      return param.length;
    }
    return itemsToShow;
  }

  /// Devuelve los datos correspondientes si están rellenos
  // ignore: non_constant_identifier_names
  static Widget answer(BuildContext context, String param) {
    if (param.isNotEmpty) {
      if (param.startsWith("http")) {
        // Si es un enlace
        return TextButton(
            onPressed: () {
              if (param.contains("/characters/")) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CharacterPage(
                      title: "Character ${param.substring(45)}",
                      web: param,
                    ),
                  ),
                );
              }
              if (param.contains("/houses/")) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HousePage(
                              title: "House ${param.substring(40)}",
                              web: param,
                            )));
              }
              if (param.contains("/books/")) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BookPage(
                              title: "Book ${param.substring(41)}",
                              web: param,
                            )));
              }
            },
            child: Text("See -> ${param.substring(34)}"));
      } else {
        return Text(param);
      }
    }
    return const Text(
      "Not specified.",
      style: TextStyle(color: Color.fromARGB(255, 255, 0, 0)),
    );
  }

  /// Devuelve los datos correspondientes si están rellenos
  // ignore: non_constant_identifier_names
  static Widget listAnswer(
      BuildContext context, List<String> param, int length) {
    if (param.isNotEmpty) {
      if (!param[0].startsWith("http")) {
        // Si es un enlace
        return SizedBox(
          width: 300,
          height: 50,
          child: ListView.builder(
              itemCount: length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    (param[index]),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14),
                  ),
                );
              }),
        );
      }
      return DropdownButton<String>(
        hint: Text('See ${param.length}'),
        items: param.take(length).map((String param) {
          return DropdownMenuItem<String>(
              value: param,
              child: TextButton(
                  onPressed: () {
                    if (param.contains("/characters/")) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CharacterPage(
                            title: "Character ${param.substring(45)}",
                            web: param,
                          ),
                        ),
                      );
                    }
                    if (param.contains("/houses/")) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HousePage(
                                    title: "House ${param.substring(41)}",
                                    web: param,
                                  )));
                    }
                    if (param.contains("/books/")) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BookPage(
                                    title: "Book ${param.substring(40)}",
                                    web: param,
                                  )));
                    }
                  },
                  child: Text("See -> ${param.substring(34)}")));
        }).toList(),
        onChanged: (String? newValue) {
          // Actualiza la Interfaz de Usuario si es necesario
        },
      );
    }
    return const Text(
      "No data known.",
      style: TextStyle(color: Color.fromARGB(255, 255, 0, 0)),
    );
  }
}
