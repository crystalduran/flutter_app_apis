import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crystal_tarea_seis/model/weather.dart';

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