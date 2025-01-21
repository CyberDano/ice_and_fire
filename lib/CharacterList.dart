import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:ice_and_fire/classes.dart';
import 'package:ice_and_fire/characterpage.dart';

class CharactersList extends StatefulWidget {
  const CharactersList({super.key, required this.title});
  final String title;

  @override
  State<CharactersList> createState() => _CharactersListScreenState();
}

/* Screen build */
class _CharactersListScreenState extends State<CharactersList> {
  List<Character> littleList = [];
  String web = "https://anapioficeandfire.com/api/characters/";
  int initialIndex = 1;
  int finalIndex = 11;

  @override
  void initState() {
    super.initState();
    loadCharacters();
  }

  void loadCharacters() async {
    try {
      for (int i = initialIndex; i < finalIndex; i++) {
        final url = Uri.parse("$web$i");
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final json = response.body;
          final Character novel = Character.fromJson(jsonDecode(json));
          setState(() {
            littleList.add(novel);
          });
        }
      }
    } catch (e) {
      print("Error loading characters from $web");
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
              "\nList of characters:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text("(from $initialIndex to ${finalIndex - 1}):"),
            Container(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: 650,
                height: 500,
                child: _myListView(context),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: prevPage,
                  child: const Text("< Previous page"),
                ),
                const Text("|"),
                TextButton(
                  onPressed: nextPage,
                  child: const Text("Next page >"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _myListView(BuildContext context) {
    return ListView.builder(
      itemCount: littleList.length,
      itemBuilder: (context, index) {
        final character = littleList[index];
        return ListTile(
          title: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CharacterPage(
                    title: "Character ${character.url}",
                    web: character.url,
                  ),
                ),
              );
            },
            child: Text("Character -> ${character.name}"),
          ),
        );
      },
    );
  }

  /// Modifica el listado disminuyendo los índices
  void prevPage() {
    if ((initialIndex - 10) > 0) {
      initialIndex -= 10;
      finalIndex -= 10;
      loadCharacters();
    }
  }

  /// Modifica el listado aumentando los índices
  void nextPage() {
    if (finalIndex + 10 < 2135) {
      initialIndex += 10;
      finalIndex += 10;
      loadCharacters();
    }
  }
}
