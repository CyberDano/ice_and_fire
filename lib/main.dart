import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

import 'package:ice_and_fire/classes.dart';
import 'package:ice_and_fire/CharacterList.dart';
import 'package:ice_and_fire/Favourites.dart';
import 'package:ice_and_fire/housepage.dart';
import 'package:ice_and_fire/bookpage.dart';
import 'package:ice_and_fire/characterpage.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => FavouriteCharacters(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ice and Fire app',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 100, 167, 255)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Ice and Fire'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String web = "https://anapioficeandfire.com/api/characters/";
  int radInt = (Random().nextInt(2135) + 1);
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
    super.initState();
    RandomCharacter();
  }

  // ignore: non_constant_identifier_names
  void RandomCharacter() async {
    try {
      final url = Uri.parse("$web" "$radInt");
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
      notedText = "Error loading $radInt.\n Request: $request";
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
          "\nNoted character:",
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
                      Methods.listAnswer(context, noted.titles,
                          Methods.itemCountToShow(noted.titles, itemsToShow)),
                    ],
                  ),
                  Column(
                    children: [
                      const Text("Aliases:"),
                      Methods.listAnswer(context, noted.aliases,
                          Methods.itemCountToShow(noted.aliases, itemsToShow)),
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
                      Methods.listAnswer(context, noted.povBooks,
                          Methods.itemCountToShow(noted.povBooks, itemsToShow)),
                    ],
                  ),
                  Column(
                    children: [
                      const Text("tvSeries:"),
                      Methods.listAnswer(context, noted.tvSeries,
                          Methods.itemCountToShow(noted.tvSeries, itemsToShow)),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: SeeCharactersScreen,
              child: const Text("See all characters"),
            ),
            TextButton(
              onPressed: FavouritesScreen,
              child: const Text("My favourites"),
            ),
          ],
        ),
      ])),
    );
  }

  void _setFavourite() {
    setState(() {
      final favCharacters =
          Provider.of<FavouriteCharacters>(context, listen: false);
      favCharacters.addFav(noted);
    });
  }

  /// All characters list
  // ignore: non_constant_identifier_names
  void SeeCharactersScreen() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const CharactersList(title: "All characters list")));
  }

  /// Favourite characters list
  // ignore: non_constant_identifier_names
  void FavouritesScreen() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const Favourites(title: "My favourites")));
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
            child: const Text("See ->"));
      } else {
        return Text(param);
      }
    }
    return const Text(
      "Not specified.",
      style: TextStyle(color: Color.fromARGB(255, 255, 0, 0)),
    );
  }
}
