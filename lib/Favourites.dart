import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

import 'package:ice_and_fire/character.dart';
import 'package:ice_and_fire/CharacterList.dart';
import 'package:ice_and_fire/main.dart';

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
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            const Text(
              "\nNoted character:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Container(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
