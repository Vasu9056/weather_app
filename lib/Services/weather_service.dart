import 'dart:convert';
import 'package:weather_app/Model/weather_api.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  Future<Weather> getWeatherData() async {
    final uri = Uri.parse(
        'http://api.weatherapi.com/v1/forecast.json?key=6b952b3ec3354faa98485352230809&q=Gujrat&days=1&aqi=no&alerts=no');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed');
    }
  }
}

String city = 'Gujrat';
