import 'dart:convert';
import 'package:crystal_tarea_seis/navbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Persona {
  final String nombre;
  final String genero;

  Persona({required this.nombre, required this.genero});

  factory Persona.fromJson(Map<String, dynamic> json) {
    return Persona(
      nombre: json["name"],
      genero: json["gender"],
    );
  }
}

class GeneroPage extends StatefulWidget {
  const GeneroPage({Key? key}) : super(key: key);

  @override
  State<GeneroPage> createState() => _GeneroPageState();

}

class _GeneroPageState extends State<GeneroPage> {
  String nombre = "";
  String genero = "";
  Color color = Colors.white;


  final TextEditingController _nombreController = TextEditingController();

  Future<Persona> _getPersona(String nombre) async {
    final response = await http.get(Uri.parse("http://api.genderize.io/?name=$nombre"));

    if(response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Persona.fromJson(data);
    } else {
      throw Exception ("Error al obtener datos");
    }
  }

  void _predictGender(String nombre) async {
    setState(() {
      genero = "";
      color = Colors.white;
    });

    try {
      final persona = await _getPersona(nombre);

      setState(() {
        genero = persona.genero;
        color = genero == "female" ? Colors.pink : Colors.blue;
      });
    } catch (e) {
      print("Error al obtener datos por la siguiente razón: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        title: Text(
          "Predicción de género",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.pink,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _nombreController,
              decoration: InputDecoration(labelText: "Nombre"),
              onSubmitted: (texto) => _predictGender(texto),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: 500.0, // Set a desired width in pixels
              child: ElevatedButton(
                onPressed: () => _predictGender(_nombreController.text),
                child: Text("Predecir Género"),
              ),
            ),
            SizedBox(height: 16),
            if(genero.isNotEmpty) ... [
              Container(
                height: 50.0,
                width: 500.0,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    "Género: $genero",
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}