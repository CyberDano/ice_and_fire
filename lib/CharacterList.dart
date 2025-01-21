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

/// Modifica el listado disminuyendo los índices
  // ignore: non_constant_identifier_names
  void PrevPage(bool fast) {
    if (!fast) {
      if ((initialIndex - 10) > 0) {
        initialIndex -= 10;
        finalIndex -= 10;
        loadCharacters();
      }
    }
    if (fast) {
      if ((initialIndex - 20) > 0) {
        initialIndex -= 20;
        finalIndex -= 20;
        loadCharacters();
      }
    }
  }

  /// Modifica el listado aumentando los índices
  // ignore: non_constant_identifier_names
  void NextPage(bool fast) {
    if (!fast) {
      if (finalIndex + 10 < 2135) {
        initialIndex += 10;
        finalIndex += 10;
        loadCharacters();
      }
    }
    if (fast) {
      if (finalIndex + 20 < 2135) {
        initialIndex += 20;
        finalIndex += 20;
        loadCharacters();
      }
    }
  }

  void loadCharacters() async {
    if (littleList.isNotEmpty) littleList.removeRange(0, littleList.length);
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
                  onPressed: () => PrevPage(true),
                  child: const Text("<< Previous page"),
                ),
                TextButton(
                  onPressed: () => PrevPage(false),
                  child: const Text("< Previous page"),
                ),
                const Text("|"),
                TextButton(
                  onPressed: () => NextPage(false),
                  child: const Text("Next page >"),
                ),
                TextButton(
                  onPressed: () => NextPage(true),
                  child: const Text("Next page >>"),
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
}
