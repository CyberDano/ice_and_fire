import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

import 'package:ice_and_fire/character.dart';
import 'package:ice_and_fire/CharacterList.dart';
import 'package:ice_and_fire/Favourites.dart';

void main() {
  runApp(const MyApp());
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

  @override
  void initState() {
    RandomCharacter();
    super.initState();
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
        notedText = noted.name;
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
        if (noted.playedBy.isNotEmpty)
          DropdownButton<String>(
            hint: const Text('PlayedBy'),
            items: noted.playedBy.map((String param) {
              return DropdownMenuItem<String>(
                value: param,
                child: Text(param),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {});
            },
          ),
        Container(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            child: Table(
              children: [
                TableRow(children: [
                  Text('Culture:\n ${Answer(noted.culture)}',
                      textAlign: TextAlign.center), // Columna izquierda
                  Text('Spouse:\n ${Answer(noted.spouse)}',
                      textAlign: TextAlign.center),
                ]),
                TableRow(children: [
                  Text('Born:\n ${Answer(noted.born)}',
                      textAlign: TextAlign.center), // Columna izquierda
                  Text('Died:\n ${Answer(noted.died)}',
                      textAlign: TextAlign.center), // Columna derecha
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
                  Text('Father:\n ${Answer(noted.father)}',
                      textAlign: TextAlign.center), // Columna izquierda
                  Text('Mother:\n ${Answer(noted.mother)}',
                      textAlign: TextAlign.center), // Columna derecha
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
  String Answer(String param) {
    if (param.isNotEmpty) {
      if (param.startsWith("http")) {
        // Si es un enlace
        return "Link";
      } else {
        return param;
      }
    }
    return "Not specified.";
  }

  /// Devuelve los datos correspondientes si están rellenos
  // ignore: non_constant_identifier_names
  Widget ListAnswer(List<String> param) {
    if (param.isNotEmpty) {
      return DropdownButton<String>(
        hint: const Text('See'),
        items: param.map((String param) {
          return DropdownMenuItem<String>(
            value: param,
            child: SelectableText(param),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {});
        },
      );
    }
    return const Text("No data known.");
  }
}
