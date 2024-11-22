import 'package:flutter/material.dart';
import 'weather_service.dart';

class WeatherProvider with ChangeNotifier {
  final WeatherService _weatherService = WeatherService();
  Map<String, dynamic>? _weatherData;
  String _selectedCity = "London";

  Map<String, dynamic>? get weatherData => _weatherData;
  String get selectedCity => _selectedCity;

  void setCity(String city) {
    _selectedCity = city;
    fetchWeather();
    notifyListeners();
  }

  Future<void> fetchWeather() async {
    try {
      _weatherData = await _weatherService.fetchWeather(_selectedCity);
      notifyListeners();
    } catch (e) {
      print("Error: $e");
    }
  }
}
