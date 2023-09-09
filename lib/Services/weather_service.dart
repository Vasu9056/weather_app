import 'dart:convert';
import 'package:weather_app/Model/weather_api.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  Future<Weather> getWeatherData() async {
    final uri =
        Uri.parse('https://www.weatherapi.com/api-explorer.aspx#forecast');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed');
    }
  }
}

String city = 'Gujrat';
