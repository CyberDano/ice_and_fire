import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ice_and_fire/Favourites.dart';
import 'package:ice_and_fire/bookpage.dart';

import 'package:ice_and_fire/classes.dart';
import 'package:ice_and_fire/housepage.dart';

class CharacterPage extends StatefulWidget {
  const CharacterPage({super.key, required this.title, required this.web});
  final String title;
  final String web;

  @override
  State<CharacterPage> createState() => _CharacterPageState();
}

class _CharacterPageState extends State<CharacterPage> {
  Character noted = const Character(
      url: "",
      name: "",
      gender: "",
      culture: "",
      born: "Loading...",
      died: "Loading...",
      titles: ["Loading..."],
      aliases: ["Loading..."],
      father: "Loading...",
      mother: "Loading...",
      spouse: "Loading...",
      allegiances: ["Loading..."],
      books: ["Loading..."],
      povBooks: ["Loading..."],
      tvSeries: ["Loading..."],
      playedBy: ["Loading..."],
      fav: false);
  String notedText = "";
  String request = "";
  bool isFavourite = false;

  @override
  void initState() {
    RandomCharacter();
    super.initState();
  }

  // ignore: non_constant_identifier_names
  void RandomCharacter() async {
    try {
      final url = Uri.parse(widget.web);
      request = url.toString();
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final json = response.body;
        noted = Character.fromJson(jsonDecode(json));
        if (noted.name.isNotEmpty) {
          notedText = noted.name;
        } else {
          notedText = "[···]";
        }
        notedText += ", who is a ${noted.gender.toLowerCase()} character.";
        request = json;
      }
    } catch (e) {
      notedText = "Error loading character.\n Request: $request";
    }
    setState(() {}); // Actualiza la Interfaz de Usuario
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
            child: Column(children: [
          const Text(
            "\nCharacter:",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(notedText),
          if (noted.playedBy.isNotEmpty) const Text("Played by:"),
          if (noted.playedBy.isNotEmpty) ListAnswer(noted.playedBy),
          Container(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              child: Table(
                children: [
                  TableRow(children: [
                    Column(children: [
                      const Text("Culture:"),
                      Answer(noted.culture),
                    ]),
                    Column(children: [
                      const Text("Spouse:"),
                      Answer(noted.spouse),
                    ]),
                  ]),
                  TableRow(children: [
                    Column(
                      children: [
                        const Text("Born:"),
                        Answer(noted.born),
                      ],
                    ),
                    Column(
                      children: [
                        const Text("Died:"),
                        Answer(noted.died),
                      ],
                    ),
                  ]),
                  TableRow(children: [
                    Column(
                      children: [
                        const Text("Titles:"),
                        ListAnswer(noted.titles),
                      ],
                    ),
                    Column(
                      children: [
                        const Text("Aliases:"),
                        ListAnswer(noted.aliases),
                      ],
                    ),
                  ]),
                  TableRow(children: [
                    Column(
                      children: [
                        const Text("Father:"),
                        Answer(noted.father),
                      ],
                    ),
                    Column(
                      children: [
                        const Text("Mother:"),
                        Answer(noted.mother),
                      ],
                    ),
                  ]),
                  TableRow(children: [
                    Column(
                      children: [
                        const Text("Allegiances:"),
                        ListAnswer(noted.allegiances),
                      ],
                    ),
                    Column(
                      children: [
                        const Text("Books:"),
                        ListAnswer(noted.books),
                      ],
                    ),
                  ]),
                  TableRow(children: [
                    Column(
                      children: [
                        const Text("povBooks:"),
                        ListAnswer(noted.povBooks),
                      ],
                    ),
                    Column(
                      children: [
                        const Text("tvSeries:"),
                        ListAnswer(noted.tvSeries),
                      ],
                    ),
                  ]),
                ],
              ),
            ),
          ),
          Switch(
            value: isFavourite,
            onChanged: (value) => _toggleFavourite(),
          ),
        ])),
        floatingActionButton: IconButton(
          icon: const Icon(Icons.home),
          onPressed: GoHome,
        ));
  }

  void _toggleFavourite() {
    setState(() {
      isFavourite = !isFavourite;
      if (isFavourite) {
        FavouriteCharacters().addFav(noted);
      } else {
        FavouriteCharacters().removeFav(noted);
      }
    });
  }

// ignore: non_constant_identifier_names
  void GoHome() {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  /// Devuelve los datos correspondientes si están rellenos
  // ignore: non_constant_identifier_names
  Widget Answer(String param) {
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
                      title: "Character $param",
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
                              title: "House $param",
                              web: param,
                            )));
              }
              if (param.contains("/books/")) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BookPage(
                              title: "Book $param",
                              web: param,
                            )));
              }
            },
            child: Text(param));
      } else {
        return Text(param);
      }
    }
    return const Text("Not specified.");
  }

  /// Devuelve los datos correspondientes si están rellenos
  // ignore: non_constant_identifier_names
  Widget ListAnswer(List<String> param) {
    if (param.isNotEmpty) {
      if (!param[0].startsWith("http")) {
        return SizedBox(
          width: 300,
          height: 50,
          child: ListView.builder(
              itemCount: param.length,
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
        items: param.map((String param) {
          return DropdownMenuItem<String>(
              value: param,
              child: TextButton(
                  onPressed: () {
                    if (param.contains("/characters/")) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CharacterPage(
                            title: "Character $param",
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
                                    title: "House $param",
                                    web: param,
                                  )));
                    }
                    if (param.contains("/books/")) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BookPage(
                                    title: "Book $param",
                                    web: param,
                                  )));
                    }
                  },
                  child: Text(param)));
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {});
        },
      );
    }
    return const Text("No data known.");
  }
}
