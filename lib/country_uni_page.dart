import 'dart:convert';
import 'package:crystal_tarea_seis/navbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class University {
  final String nombre;
  final String pais;
  final List<String> paginasWeb;
  final List<String> dominios;

  University({required this.nombre, required this.pais, required this.paginasWeb,
  required this.dominios});

  factory University.fromJson(Map<String, dynamic> json) {
    return University(
      nombre: json["name"],
      pais: json["country"],
      paginasWeb: json["web_pages"] != null ? List<String>.from(json["web_pages"]) : [],
      dominios: json["domains"] != null ? List<String>.from(json["domains"]) : [],
    );
  }
}

class UniversityListPage extends StatefulWidget {
  const UniversityListPage({Key? key}) : super(key: key);

  @override
  State<UniversityListPage> createState() => _UniversityListPageState();
}

class _UniversityListPageState extends State<UniversityListPage> {
  final TextEditingController _countryController = TextEditingController();
  Future<List<University>>? _universities;

  void _searchUniversities(String country) async {
    final formattedCountry = country.replaceAll(' ', '%20');
    final response = await http.get(Uri.parse(
        "http://universities.hipolabs.com/search?country=$formattedCountry"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      setState(() {
        _universities = Future.value(data.map((json) => University.fromJson(json)).toList());
      });
    } else {
      setState(() {
        _universities = Future.error('No se pudo cargar universidades');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        title: Text(
          'Búsqueda de Universidades',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.pink,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _countryController,
              decoration: InputDecoration(
                labelText: 'Escriba el nombre de un país (en inglés)',
                hintText: 'e.g., Dominican Republic',
              ),
              onSubmitted: (country) => _searchUniversities(country),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _searchUniversities(_countryController.text),
              child: Text('Buscar Universidades'),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: _universities != null
                  ? FutureBuilder<List<University>>(
                future: _universities,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final universities = snapshot.data!;
                    return ListView.builder(
                      itemCount: universities.length,
                      itemBuilder: (context, index) {
                        final university = universities[index];
                        return Card(
                          child: ListTile(
                            title: Text(university.nombre),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('País: ${university.pais}'),
                                SizedBox(height: 4),
                                Text('Página Web: ${university.paginasWeb.isNotEmpty ? university.paginasWeb[0] : ''}'),
                                SizedBox(height: 4),
                                Text('Dominio: ${university.dominios.isNotEmpty ? university.dominios[0] : ''}'),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('${snapshot.error}'),
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                },
              )
                  : SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
