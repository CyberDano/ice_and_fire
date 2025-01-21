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
    RandomCharacter();
    super.initState();
  }

  // ignore: non_constant_identifier_names
  void RandomCharacter() async {
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
            Answer(noted.isbn),
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
                      ListAnswer(noted.authors),
                    ],
                  ),
                  Column(
                    children: [
                      const Text("Number of pages:"),
                      Answer("${noted.pages} pages"),
                    ],
                  ),
                ]),
                TableRow(children: [
                  Column(
                    children: [
                      const Text("Publisher:"),
                      Answer(noted.publisher),
                    ],
                  ),
                  Column(
                    children: [
                      const Text("Country:"),
                      Answer(noted.country),
                    ],
                  ),
                ]),
                TableRow(children: [
                  Column(
                    children: [
                      const Text("Media type:"),
                      Answer(noted.mediaType),
                    ],
                  ),
                  Column(
                    children: [
                      const Text("Released:"),
                      Answer(noted.released),
                    ],
                  ),
                ]),
                TableRow(children: [
                  Column(
                    children: [
                      const Text("Characters:"),
                      ListAnswer(noted.characters),
                    ],
                  ),
                  Column(
                    children: [
                      const Text("POV characters:"),
                      ListAnswer(noted.povCharacters),
                    ],
                  ),
                ]),
              ],
            ),
          ),
        ),
      ])),
    );
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
            child: Text(param));
      } else {
        return Text(param);
      }
    }
    return const Text("Not specified.");
  }

  /// Devuelve los datos correspondientes si están rellenos
  // ignore: non_constant_identifier_names
  Widget ListAnswer(List<String> param) {
    if (param.isNotEmpty) {
      if (!param[0].startsWith("http")) {
        return SizedBox(
          width: 300,
          height: 50,
          child: ListView.builder(
              itemCount: param.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    (param[index]),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14),
                  ),
                );
              }),
        );
      }
      return DropdownButton<String>(
        hint: Text('See ${param.length}'),
        items: param.take(itemsToShow).map((String param) {
          return DropdownMenuItem<String>(
              value: param,
              child: TextButton(
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
                  child: Text(param)));
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {});
        },
      );
    }
    return const Text("No data known.");
  }
}
