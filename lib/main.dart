import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'package:ice_and_fire/character.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ice and Fire app',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Ice and Fire'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String web = "https://anapioficeandfire.com/api/characters/";
  int radInt = (Random().nextInt(2135) + 1);
  String notedText = "";
  String request = "";

  @override
  void initState() {
    RandomCharacter();
    super.initState();
  }

  // ignore: non_constant_identifier_names
  void RandomCharacter() async {
    try {
      final url = Uri.parse("$web" "$radInt");
      request = url.toString();
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final json = response.body;
        print(json);
        Character noted = Character.fromJson(jsonDecode(json));
        notedText = noted.name;
        notedText += ", who is a ${noted.gender.toLowerCase()} character.";
        if (noted.born.isNotEmpty) notedText += "\nBorn ${noted.born}.";
        request = json;
      }
    } catch (e) {
      notedText = "Error al buscar el personaje $radInt.\n Consulta: $request";
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
          "Noted character:",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SelectableText(notedText),
        Text(request)
      ])),
    );
  }
}
