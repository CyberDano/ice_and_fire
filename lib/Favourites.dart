import 'package:flutter/material.dart';
import 'package:ice_and_fire/characterpage.dart';
import 'package:ice_and_fire/classes.dart';
import 'package:provider/provider.dart';

class FavouriteCharacters with ChangeNotifier {
  List<Character> favList = [];

  /// Adds character to list
  void addFav(Character c) {
    if (!favList.contains(c)) {
      favList.add(c);
      notifyListeners();
    }
  }

  /// ERemoves character from list
  void removeFav(Character c) {
    favList.remove(c);
    notifyListeners();
  }

  /// Checks if the character is in list
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
        title: const Text("Lista de personajes favoritos"),
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
      },
    );
  }
}
