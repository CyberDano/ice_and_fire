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
    LoadHouse();
    super.initState();
  }

  // ignore: non_constant_identifier_names
  void LoadHouse() async {
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
                      Methods.answer(context, noted.region),
                    ]),
                    Column(children: [
                      const Text("Coat of arms:"),
                      Methods.answer(context, noted.coatOfArms),
                    ]),
                  ]),
                  TableRow(children: [
                    Column(
                      children: [
                        const Text("Words:"),
                        Methods.answer(context, noted.words),
                      ],
                    ),
                    Column(
                      children: [
                        const Text("Titles:"),
                        Methods.listAnswer(context, noted.titles,
                            Methods.itemCountToShow(noted.titles, itemsToShow)),
                      ],
                    ),
                  ]),
                  TableRow(children: [
                    Column(
                      children: [
                        const Text("Seats:"),
                        Methods.listAnswer(context, noted.seats,
                            Methods.itemCountToShow(noted.seats, itemsToShow)),
                      ],
                    ),
                    Column(
                      children: [
                        const Text("Current lord:"),
                        Methods.answer(context, noted.currentLord),
                      ],
                    ),
                  ]),
                  TableRow(children: [
                    Column(
                      children: [
                        const Text("Heir:"),
                        Methods.answer(context, noted.heir),
                      ],
                    ),
                    Column(
                      children: [
                        const Text("Overlord:"),
                        Methods.answer(context, noted.overlord),
                      ],
                    ),
                  ]),
                  TableRow(children: [
                    Column(
                      children: [
                        const Text("Founded:"),
                        Methods.answer(context, noted.founded),
                      ],
                    ),
                    Column(
                      children: [
                        const Text("Founder:"),
                        Methods.answer(context, noted.founder),
                      ],
                    ),
                  ]),
                  TableRow(children: [
                    Column(
                      children: [
                        const Text("Died out:"),
                        Methods.answer(context, noted.diedOut),
                      ],
                    ),
                    Column(
                      children: [
                        const Text("Ancestral weapons:"),
                        Methods.listAnswer(
                            context,
                            noted.ancestralWeapons,
                            Methods.itemCountToShow(
                                noted.ancestralWeapons, itemsToShow)),
                      ],
                    ),
                  ]),
                  TableRow(children: [
                    Column(
                      children: [
                        const Text("Cadet branches:"),
                        Methods.listAnswer(
                            context,
                            noted.cadetBranches,
                            Methods.itemCountToShow(
                                noted.cadetBranches, itemsToShow)),
                      ],
                    ),
                    Column(
                      children: [
                        const Text("Sworn members:"),
                        Methods.listAnswer(
                            context,
                            noted.swornMembers,
                            Methods.itemCountToShow(
                                noted.swornMembers, itemsToShow)),
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
