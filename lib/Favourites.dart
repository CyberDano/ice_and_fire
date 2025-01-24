import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ice_and_fire/characterpage.dart';
import 'package:ice_and_fire/classes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class FavouriteCharacters with ChangeNotifier {
  List<Character> favList = [];

  FavouriteCharacters() {
    _loadFavList();
  }

  /// Adds character to list
  void addFav(Character c) {
    if (!favList.contains(c)) {
      favList.add(c);
      _saveFavList();
      notifyListeners();
    }
  }

  /// Removes character from list
  void removeFav(Character c) {
    favList.remove(c);
    _saveFavList();
    notifyListeners();
  }

  /// Checks if the character is in list
  bool isFavourite(Character c) {
    for (int i = 0; i < favList.length; i++) {
      if (favList[i].url == c.url) {
        return true;
      }
    }
    return false;
  }

  /// Guarda la lista de personajes favoritos en SharedPreferences
  void _saveFavList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> jsonList =
        favList.map((c) => json.encode(c.toJson())).toList();
    prefs.setStringList('favouriteCharacters', jsonList);
  }

  /// Carga la lista de personajes favoritos desde SharedPreferences
  void _loadFavList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? jsonList = prefs.getStringList('favouriteCharacters');
    if (jsonList != null) {
      favList = jsonList
          .map((item) => Character.fromJson(json.decode(item)))
          .toList();
      notifyListeners();
    }
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
  void initState() {
    super.initState();
    final favCharacters =
        Provider.of<FavouriteCharacters>(context, listen: false);
    favCharacters._loadFavList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Your favourites"),
      ),
      body: Center(
        child: Column(
          children: [
            const Text(
              "\nFavourite characters:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Container(
              color: const Color.fromARGB(100, 255, 214, 100),
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: 400,
                height: 700,
                child: _myListView(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _myListView(BuildContext context) {
    return Consumer<FavouriteCharacters>(
      builder: (context, favCharacters, child) {
        return ListView.builder(
          itemCount: favCharacters.favList.length,
          itemBuilder: (context, index) {
            final character = favCharacters.favList[index];
            return ListTile(
              title: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CharacterPage(
                          title: "Character ${character.url.substring(45)}",
                          web: character.url,
                        ),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Character -> ${character.name}"),
                      IconButton(
                          onPressed: () => favCharacters.removeFav(character),
                          icon: const Icon(Icons.close))
                    ],
                  )),
            );
          },
        );
      },
    );
  }
}
