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
  int radInt = (Random().nextInt(2135) + 1);
  String notedText = "";

  @override
  void initState() {
    RandomCharacter();
    super.initState();
  }

  // ignore: non_constant_identifier_names
  void RandomCharacter() async {
    int random = new Random().nextInt(2135) + 1;
    final url =
        Uri.parse("https://anapioficeandfire.com/api/characters/$random");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final json = response.body;
      Character noted = Character.fromJson(jsonDecode(json));
      notedText = noted.name;
      if (noted.aliases.isNotEmpty) notedText += noted.aliases[0];
      notedText += ", who is a ${noted.gender},\n from ${noted.born}";
    } else {
      notedText = "Error al cargar.";
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
      body: const Center(
          child: Column(children: [
        Text("Noted character:"),
      ])),
    );
  }
}
