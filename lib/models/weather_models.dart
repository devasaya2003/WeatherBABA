class WeatherModel {
  final String cityName;
  final double temp;
  final String weatherCondition;

  WeatherModel(
      {required this.cityName,
      required this.temp,
      required this.weatherCondition});

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'],
      temp: json['main']['temp'].toDouble(),
      weatherCondition: json['weather'][0]['main'],
    );
  }
}
