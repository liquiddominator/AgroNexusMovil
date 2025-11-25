import '../models/weather.dart';
import '../services/weather_service.dart';

class WeatherController {
  final WeatherService _service = WeatherService();

  bool loading = false;
  String? errorMessage;
  Weather? weather;

  Future<bool> loadWeather(double lat, double lon) async {
    loading = true;
    errorMessage = null;

    try {
      final data = await _service.getWeather(lat, lon);
      weather = Weather.fromJson(data);
      loading = false;
      return true;
    } catch (e) {
      errorMessage = e.toString();
      loading = false;
      return false;
    }
  }
}