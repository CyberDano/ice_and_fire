import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:ice_and_fire/classes.dart';
import 'package:ice_and_fire/Favourites.dart';

class CharactersList extends StatefulWidget {
  const CharactersList({super.key, required this.title});
  final String title;

  @override
  State<CharactersList> createState() => _CharactersListScreenState();
}

/* Screen build */
class _CharactersListScreenState extends State<CharactersList> {
  late List<Character> characterList = <Character>[];
  String web = "https://anapioficeandfire.com/api/characters/";
  Character novel = const Character(
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
  @override
  void initState() {
    LoadCharacter();
    super.initState();
  }

  // ignore: non_constant_identifier_names
  void LoadCharacter() async {
    for (int i = 1; i < 2135; i++) {
      try {
        final url = Uri.parse("$web" "$i");
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final json = response.body;
          // ignore: non_constant_identifier_names
          novel = Character.fromJson(jsonDecode(json));
          characterList.add(novel);
        }
      } catch (e) {
        print("Error loading $e");
      }
      setState(() {}); // Actualiza la Interfaz de Usuario
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            const Text(
              "\nLisf of characters:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Container(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: 300,
                height: 50,
                child: _myListView(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _myListView(BuildContext context) {
    print("Pasan cosas");
    return ListView.builder(
      itemCount: characterList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(characterList[index].name),
        );
      },
    );
  }
}
