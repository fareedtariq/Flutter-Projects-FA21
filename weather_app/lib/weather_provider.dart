import 'package:flutter/material.dart';
import 'weather_service.dart';

class WeatherProvider with ChangeNotifier {
  final WeatherService _weatherService = WeatherService();
  Map<String, dynamic>? _weatherData;
  String _selectedCity = "London";
  bool _isLoading = false;
  String? _errorMessage;

  Map<String, dynamic>? get weatherData => _weatherData;
  String get selectedCity => _selectedCity;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Method to set the city and fetch weather data
  void setCity(String city) {
    _selectedCity = city;
    fetchWeather();
    notifyListeners();
  }

  // Method to fetch weather data
  Future<void> fetchWeather() async {
    try {
      _weatherData = await _weatherService.fetchWeather(_selectedCity);
      print(_weatherData); // This will print the fetched weather data to the console
      notifyListeners();
    } catch (e) {
      print("Error fetching weather data: $e");
    }
  }

  // Refresh method to re-fetch the data
  Future<void> refreshWeather() async {
    fetchWeather(); // Just reuse the fetchWeather method to refresh data
  }
}
