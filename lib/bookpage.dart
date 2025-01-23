import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ice_and_fire/characterpage.dart';

import 'package:ice_and_fire/classes.dart';
import 'package:ice_and_fire/housepage.dart';

class BookPage extends StatefulWidget {
  const BookPage({super.key, required this.title, required this.web});
  final String title;
  final String web;

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  Book noted = const Book(
      url: "",
      name: "",
      isbn: "",
      authors: ["Loading..."],
      pages: 0,
      publisher: "Loading...",
      country: "Loading...",
      mediaType: "Loading...",
      released: "Loading...",
      characters: ["Loading..."],
      povCharacters: ["Loading..."]);
  String notedText = "";
  String request = "";
  int itemsToShow = 10;

  @override
  void initState() {
    LoadBook();
    super.initState();
  }

  // ignore: non_constant_identifier_names
  void LoadBook() async {
    try {
      final url = Uri.parse(widget.web);
      request = widget.web;
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final json = response.body;
        noted = Book.fromJson(jsonDecode(json));
        notedText = noted.name;
        request = json;
      }
    } catch (e) {
      notedText = "Error loading book.\n Request: $request";
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
            "\nBook:",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SelectableText(notedText),
          Column(
            children: [
              const Text("ISBN:"),
              Methods.answer(context, noted.isbn),
              Text("\nNow loading $itemsToShow parameters."),
              TextButton(
                onPressed: () {
                  setState(() {
                    itemsToShow += 10;
                  });
                },
                child: const Text('Load 10 more'),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              child: Table(
                children: [
                  TableRow(children: [
                    Column(
                      children: [
                        const Text("Authors:"),
                        Methods.listAnswer(
                            context,
                            noted.authors,
                            Methods.itemCountToShow(
                                noted.authors, itemsToShow)),
                      ],
                    ),
                    Column(
                      children: [
                        const Text("Number of pages:"),
                        Methods.answer(context, "${noted.pages} pages"),
                      ],
                    ),
                  ]),
                  TableRow(children: [
                    Column(
                      children: [
                        const Text("Publisher:"),
                        Methods.answer(context, noted.publisher),
                      ],
                    ),
                    Column(
                      children: [
                        const Text("Country:"),
                        Methods.answer(context, noted.country),
                      ],
                    ),
                  ]),
                  TableRow(children: [
                    Column(
                      children: [
                        const Text("Media type:"),
                        Methods.answer(context, noted.mediaType),
                      ],
                    ),
                    Column(
                      children: [
                        const Text("Released:"),
                        Methods.answer(context, noted.released),
                      ],
                    ),
                  ]),
                  TableRow(children: [
                    Column(
                      children: [
                        const Text("Characters:"),
                        Methods.listAnswer(
                            context,
                            noted.characters,
                            Methods.itemCountToShow(
                                noted.characters, itemsToShow)),
                      ],
                    ),
                    Column(
                      children: [
                        const Text("POV characters:"),
                        Methods.listAnswer(
                            context,
                            noted.povCharacters,
                            Methods.itemCountToShow(
                                noted.povCharacters, itemsToShow)),
                      ],
                    ),
                  ]),
                ],
              ),
            ),
          ),
        ])),
        floatingActionButton: IconButton(
          icon: const Icon(Icons.home),
          onPressed: GoHome,
        ));
  }

  // ignore: non_constant_identifier_names
  void GoHome() {
    Navigator.popUntil(context, (route) => route.isFirst);
  }
}
