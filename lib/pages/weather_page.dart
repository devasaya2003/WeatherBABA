import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:wheather_baba/models/weather_models.dart';
import 'package:wheather_baba/services/weather_service.dart';
import 'package:wheather_baba/themes/theme_provider.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  int value = 0;
  int? nullableValue;
  bool positive = false;
  bool loading = false;
  final wetherService =
      WeatherService(API_KEY: 'YOUR API KEY');
  WeatherModel? weatherModel;

  fetchWeather() async {
    String cityName = await wetherService.getCurrentCity();
    try {
      final weather = await wetherService.getWeather(cityName);
      setState(() {
        weatherModel = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  String getAnimation(String? weatherCondition) {
    if (weatherCondition == null) return 'assets/sunny.json';
    switch (weatherCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/clouds.json';

      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rainy.json';

      case 'thunderstorm':
        return 'assets/thunder.json';

      case 'clear':
        return 'assets/sunny.json';

      default:
        return 'assets/sunny.json';
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AnimatedToggleSwitch<bool>.dual(
        current: positive,
        first: false,
        second: true,
        spacing: 50.0,
        style: const ToggleStyle(
          borderColor: Colors.transparent,
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 1.5),
            ),
          ],
        ),
        borderWidth: 5.0,
        height: 55,
        onChanged: (b) => setState(() {
          positive = b;
          Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
        }),
        styleBuilder: (b) => ToggleStyle(
            backgroundColor: b ? Colors.grey.shade300 : Colors.grey.shade800,
            indicatorColor: b ? Colors.grey.shade800 : Colors.grey.shade300),
        iconBuilder: (value) => value
            ? Icon(
                Icons.dark_mode,
                color: Colors.white,
              )
            : Icon(
                Icons.light_mode,
                color: Colors.black,
              ),
        textBuilder: (value) => value
            ? Center(
                child: Text(
                'Light...',
                style: TextStyle(color: Colors.grey.shade900),
              ))
            : Center(
                child: Text(
                'Dark...',
                style: TextStyle(color: Colors.white),
              )),
      ),
      body: Center(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.light_mode_outlined,
                  // color: Colors.orange.shade300,
                ),
                Text(
                  ' WeatherBABA',
                  style: TextStyle(fontSize: 20),
                )
              ],
            ),
          ),
          Text(weatherModel?.cityName ??
              'WetherBABA is getting your weather data...'),
          Text(
              '${weatherModel?.temp.round() ?? 'Temperature will be shown in '}°C'),
          SizedBox(height: 5),
          Lottie.asset(getAnimation(weatherModel?.weatherCondition)),
          SizedBox(height: 5),
          Text(weatherModel?.weatherCondition ?? ''),
        ]),
      ),
    );
  }
}
