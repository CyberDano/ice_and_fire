import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:ice_and_fire/characterpage.dart';
import 'package:ice_and_fire/classes.dart';

class FavouriteCharacters with ChangeNotifier {
  List<Character> favList = [];

  void addFav(Character c) {
    if (!favList.contains(c)) {
      favList.add(c);
      notifyListeners();
    }
  }

  void removeFav(Character c) {
    favList.remove(c);
    notifyListeners();
  }

  bool isFavourite(Character c) {
    return favList.contains(c);
  }
}

class Favourites extends StatefulWidget {
  const Favourites({super.key, required this.title});
  final String title;

  @override
  State<Favourites> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<Favourites> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title:
            const Text("Lista de personajes favoritos"), // Actualiza el título
      ),
      body: Center(
        child: Column(
          children: [
            const Text(
              "\nPersonajes favoritos:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Container(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: 650,
                height: 500,
                child: _myListView(context),
              ),
            ),
            // ... (pagination buttons, puedes eliminarlos si no son necesarios)
          ],
        ),
      ),
    );
  }

  Widget _myListView(BuildContext context) {
    return ListView.builder(
      itemCount: FavouriteCharacters()
          .favList
          .length, // Usa el tamaño de la lista de favoritos
      itemBuilder: (context, index) {
        final character = FavouriteCharacters().favList[index];
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
