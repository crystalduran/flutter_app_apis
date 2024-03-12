import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:crystal_tarea_seis/navbar.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:html_unescape/html_unescape.dart';

class Noticia {
  final String titulo;
  final String resumen;
  final String contenido;
  final String enlace;

  Noticia({required this.titulo, required this.resumen, required this.contenido, required this.enlace});

  factory Noticia.fromJson(Map<String, dynamic> json) {
    final htmlUnescape = HtmlUnescape();
    return Noticia(
      titulo: htmlUnescape.convert(json["title"]["rendered"]),
      resumen: htmlUnescape.convert(json["excerpt"]["rendered"].replaceAll("<p>", "").replaceAll("</p>", "")),
      contenido: htmlUnescape.convert(json["content"]["rendered"]),
      enlace: json["link"],
    );
  }
}

Future<List<Noticia>> obtenerNoticias() async {
  final response = await http.get(Uri.parse(
      "https://crackmagazine.net/wp-json/wp/v2/posts?order=desc&orderby=date&per_page=3"));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body) as List;
    return data.map((json) => Noticia.fromJson(json)).toList();
  } else {
    throw Exception("Error al obtener las noticias");
  }
}

class NoticiaPage extends StatelessWidget {
  const NoticiaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/Home-Page-Thumbnail-V1-.jpg',
              height: 40,
            ),
            SizedBox(width: 10),
            Text(
              "- Noticias",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<Noticia>>(
        future: obtenerNoticias(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final noticias = snapshot.data!;
            return ListView.builder(
              itemCount: noticias.length,
              itemBuilder: (context, index) {
                final noticia = noticias[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          noticia.titulo,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          noticia.resumen,
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 2),
                        TextButton(
                          child: Text(
                            "Leer más",
                            style: TextStyle(
                              color: Colors.pink,
                            ),
                          ),
                          onPressed: () => _abrirEnlace(noticia.enlace),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error al obtener las noticias"),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  void _abrirEnlace(String enlace) async {
    if (await url_launcher.canLaunch(enlace)) {
      await url_launcher.launch(enlace);
    } else {
      throw 'No se pudo abrir el enlace $enlace';
    }
  }
}
