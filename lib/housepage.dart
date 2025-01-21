import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ice_and_fire/bookpage.dart';

import 'package:ice_and_fire/classes.dart';
import 'package:ice_and_fire/CharacterPage.dart';

class HousePage extends StatefulWidget {
  const HousePage({super.key, required this.title, required this.web});
  final String title;
  final String web;

  @override
  State<HousePage> createState() => _HousePageState();
}

class _HousePageState extends State<HousePage> {
  House noted = const House(
      url: "",
      name: "",
      region: "",
      coatOfArms: "",
      words: "Loading...",
      titles: ["Loading..."],
      seats: ["Loading..."],
      currentLord: "Loading...",
      heir: "Loading...",
      overlord: "Loading...",
      founded: "Loading...",
      founder: "Loading...",
      diedOut: "Loading...",
      ancestralWeapons: ["Loading..."],
      cadetBranches: ["Loading..."],
      swornMembers: ["Loading..."]);
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
      request = url.toString();
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final json = response.body;
        noted = House.fromJson(jsonDecode(json));
        notedText = noted.name;
        request = json;
      }
    } catch (e) {
      notedText = "Error loading house.\n Request: $request";
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
          "\nHouse:",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(notedText),
        Text("\nNow loading $itemsToShow parameters."),
        TextButton(
          onPressed: () {
            setState(() {
              itemsToShow += 10;
            });
          },
          child: const Text('Load 10 more'),
        ),
        Container(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            child: Table(
              children: [
                TableRow(children: [
                  Column(children: [
                    const Text("Region:"),
                    Answer(noted.region),
                  ]),
                  Column(children: [
                    const Text("Coat of arms:"),
                    Answer(noted.coatOfArms),
                  ]),
                ]),
                TableRow(children: [
                  Column(
                    children: [
                      const Text("Words:"),
                      Answer(noted.words),
                    ],
                  ),
                  Column(
                    children: [
                      const Text("Titles:"),
                      ListAnswer(noted.titles),
                    ],
                  ),
                ]),
                TableRow(children: [
                  Column(
                    children: [
                      const Text("Seats:"),
                      ListAnswer(noted.seats),
                    ],
                  ),
                  Column(
                    children: [
                      const Text("Current lord:"),
                      Answer(noted.currentLord),
                    ],
                  ),
                ]),
                TableRow(children: [
                  Column(
                    children: [
                      const Text("Heir:"),
                      Answer(noted.heir),
                    ],
                  ),
                  Column(
                    children: [
                      const Text("Overlord:"),
                      Answer(noted.overlord),
                    ],
                  ),
                ]),
                TableRow(children: [
                  Column(
                    children: [
                      const Text("Founded:"),
                      Answer(noted.founded),
                    ],
                  ),
                  Column(
                    children: [
                      const Text("Founder:"),
                      Answer(noted.founder),
                    ],
                  ),
                ]),
                TableRow(children: [
                  Column(
                    children: [
                      const Text("Died out:"),
                      Answer(noted.diedOut),
                    ],
                  ),
                  Column(
                    children: [
                      const Text("Ancestral weapons:"),
                      ListAnswer(noted.ancestralWeapons),
                    ],
                  ),
                ]),
                TableRow(children: [
                  Column(
                    children: [
                      const Text("Cadet branches:"),
                      ListAnswer(noted.cadetBranches),
                    ],
                  ),
                  Column(
                    children: [
                      const Text("Sworn members:"),
                      ListAnswer(noted.swornMembers),
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
