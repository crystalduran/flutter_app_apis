import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:crystal_tarea_seis/navbar.dart';
import 'package:http/http.dart' as http;

class Weather {
  final String nombreLocation;
  final double temperatureC;
  final double temperatureF;
  final String condition;
  final String iconUrl;

  Weather({
    this.nombreLocation = 'Santo Domingo',
    this.temperatureC = 0,
    this.temperatureF = 0,
    this.condition = 'Soleado',
    this.iconUrl = '',
  });

  factory Weather.fromJson(Map<String, dynamic> json){
    return Weather(
      nombreLocation: json['location']['name'],
      temperatureC: json['current']['temp_c'],
      temperatureF: json['current']['temp_f'],
      condition: json['current']['condition']['text'],
      iconUrl: 'https:' + json['current']['condition']['icon'],
    );
  }
}

class WeatherService {
  Future<Weather> getWeatherData(String place) async {
    try {
      final queryParameters = {
        'key': '5a258130744f42ed9e9212707241203',
        'q': place,
        'lang': 'es'
      };
      final uri = Uri.http('api.weatherapi.com', '/v1/current.json', queryParameters);
      final response = await http.get(uri);
      if(response.statusCode == 200){
        return Weather.fromJson(jsonDecode(response.body));
      } else {
        throw Exception("No se pudo obtener el clima");
      }
    } catch (e) {
      rethrow;
    }
  }
}

class ClimatePage extends StatefulWidget {
  const ClimatePage({Key? key}) : super(key: key);

  @override
  State<ClimatePage> createState() => _ClimatePageState();
}

class _ClimatePageState extends State<ClimatePage> {
  Weather weather = Weather();
  WeatherService weatherService = WeatherService();

  @override
  void initState() {
    super.initState();
    getWeatherForSantoDomingo();
  }

  void getWeatherForSantoDomingo() async {
    // Consultar el clima para RD
    final String place = 'Dominican Republic';
    weather = await weatherService.getWeatherData(place.replaceAll(' ', '+'));

    // Actualizar el estado para reflejar los cambios en la UI
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        title: Text(
          'Clima',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.pink,
      ),
      body: Center(
        child: Card(
          elevation: 4,
          margin: EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Santo Domingo',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Temperatura: ${weather.temperatureC}°C',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  'Condición: ${weather.condition}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Image.network(
                  weather.iconUrl,
                  width: 100,
                  height: 100,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
