import 'dart:convert';
import 'dart:ffi';
import 'package:crystal_tarea_seis/navbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Persona {
  final String nombre;
  final int edad;

  Persona({required this.nombre, required this.edad});

  factory Persona.fromJson(Map<String, dynamic> json) {
    return Persona(
      nombre: json["name"],
      edad: json["age"],
    );
  }
}

class EdadPage extends StatefulWidget {
  const EdadPage({Key? key}) : super(key: key);

  @override
  State<EdadPage> createState() => _EdadPageState();

}

class _EdadPageState extends State<EdadPage> {
  String nombre = "";
  int edad = 0;
  String mensaje = "";
  Image imagenEdad = Image.asset('assets/images/teenager_girl.jpg');


  final TextEditingController _nombreController = TextEditingController();

  Future<Persona> _getPersona(String nombre) async {
    final response = await http.get(Uri.parse("http://api.agify.io/?name=$nombre"));

    if(response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Persona.fromJson(data);
    } else {
      throw Exception ("Error al obtener datos");
    }
  }

  void _predictAge(String nombre) async {
    setState(() {
      edad = 0;
      mensaje = "";
      imagenEdad = Image.asset('assets/images/teenager_girl.jpg');
    });

    try {
      final persona = await _getPersona(nombre);

      setState(() {
        edad = persona.edad;
        if(edad < 18) {
          mensaje = "Esta persona es joven";
          imagenEdad = Image.asset('assets/images/teenager_girl.jpg');
        } else if (edad < 60) {
          mensaje = "Esta persona es adulta";
          imagenEdad = Image.asset('assets/images/adult_woman.jpg');
        } else {
          mensaje = "Esta persona es anciana";
          imagenEdad = Image.asset('assets/images/elderly_woman.jpg');
        }
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
          "Predicción de edad",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.pink,
      ),
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 5,
            left: 10,
            right: 10,
            child: TextField(
              controller: _nombreController,
              decoration: InputDecoration(labelText: "Nombre"),
              onSubmitted: (texto) => _predictAge(texto),
            ),
          ),
          Positioned(
            top: 75,
            left: 10,
            right: 10,
            child: ElevatedButton(
              onPressed: () => _predictAge(_nombreController.text),
              child: Text("Predecir Edad"),
            ),
          ),
          if(edad > 0) ... [
            Positioned(
              top: 130,
              left: 10,
              right: 10,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.pink,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Edad: $edad\n$mensaje",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Positioned(
              top: 195,
              left: 10,
              right: 10,
              child: imagenEdad,
            )
          ],
        ],
      )
    );
  }
}