import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
      playedBy: ["Loading..."]);
  String notedText = "";
  String request = "";
  int itemsToShow = 10;
  bool isFavourite = false;
  @override
  void initState() {
    LoadCharacter();
    super.initState();
  }

  // ignore: non_constant_identifier_names
  void LoadCharacter() async {
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
        final favCharacters =
            Provider.of<FavouriteCharacters>(context, listen: false);
        isFavourite = favCharacters.isFavourite(noted);
        notedText += ", who is a ${noted.gender.toLowerCase()} character.";
        request = json;
      }
    } catch (e) {
      notedText = "Error loading character.\n Request: $request";
    }
    setState(() {});
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
          if (noted.playedBy.isNotEmpty)
            Methods.listAnswer(context, noted.playedBy,
                Methods.itemCountToShow(noted.playedBy, itemsToShow)),
          Container(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              child: Table(
                children: [
                  TableRow(children: [
                    Column(children: [
                      const Text("Culture:"),
                      Methods.answer(context, noted.culture),
                    ]),
                    Column(children: [
                      const Text("Spouse:"),
                      Methods.answer(context, noted.spouse),
                    ]),
                  ]),
                  TableRow(children: [
                    Column(
                      children: [
                        const Text("Born:"),
                        Methods.answer(context, noted.born),
                      ],
                    ),
                    Column(
                      children: [
                        const Text("Died:"),
                        Methods.answer(context, noted.died),
                      ],
                    ),
                  ]),
                  TableRow(children: [
                    Column(
                      children: [
                        const Text("Titles:"),
                        Methods.listAnswer(context, noted.titles,
                            Methods.itemCountToShow(noted.titles, itemsToShow)),
                      ],
                    ),
                    Column(
                      children: [
                        const Text("Aliases:"),
                        Methods.listAnswer(
                            context,
                            noted.aliases,
                            Methods.itemCountToShow(
                                noted.aliases, itemsToShow)),
                      ],
                    ),
                  ]),
                  TableRow(children: [
                    Column(
                      children: [
                        const Text("Father:"),
                        Methods.answer(context, noted.father),
                      ],
                    ),
                    Column(
                      children: [
                        const Text("Mother:"),
                        Methods.answer(context, noted.mother),
                      ],
                    ),
                  ]),
                  TableRow(children: [
                    Column(
                      children: [
                        const Text("Allegiances:"),
                        Methods.listAnswer(
                            context,
                            noted.allegiances,
                            Methods.itemCountToShow(
                                noted.allegiances, itemsToShow)),
                      ],
                    ),
                    Column(
                      children: [
                        const Text("Books:"),
                        Methods.listAnswer(context, noted.books,
                            Methods.itemCountToShow(noted.books, itemsToShow)),
                      ],
                    ),
                  ]),
                  TableRow(children: [
                    Column(
                      children: [
                        const Text("povBooks:"),
                        Methods.listAnswer(
                            context,
                            noted.povBooks,
                            Methods.itemCountToShow(
                                noted.povBooks, itemsToShow)),
                      ],
                    ),
                    Column(
                      children: [
                        const Text("tvSeries:"),
                        Methods.listAnswer(
                            context,
                            noted.tvSeries,
                            Methods.itemCountToShow(
                                noted.tvSeries, itemsToShow)),
                      ],
                    ),
                  ]),
                ],
              ),
            ),
          ),
          if (!isFavourite)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: _setFavourite,
                  child: const Text("Add to favourites"),
                )
              ],
            ),
        ])),
        floatingActionButton: IconButton(
          icon: const Icon(Icons.home),
          onPressed: GoHome,
        ));
  }

  void _setFavourite() {
    setState(() {
      final favCharacters =
          Provider.of<FavouriteCharacters>(context, listen: false);
      favCharacters.addFav(noted);
    });
  }

// ignore: non_constant_identifier_names
  void GoHome() {
    Navigator.popUntil(context, (route) => route.isFirst);
  }
}
