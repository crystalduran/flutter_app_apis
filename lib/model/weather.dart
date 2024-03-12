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