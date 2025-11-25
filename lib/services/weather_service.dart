import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class WeatherService {
  Future<Map<String, dynamic>> getWeather(double lat, double lon) async {
    final url =
        '${ApiConstants.externalWeatherBase}?lat=$lat&lon=$lon&appid=${ApiConstants.weatherApiKey}&units=metric&lang=es';

    final response = await http.get(Uri.parse(url));

    return jsonDecode(response.body);
  }
}