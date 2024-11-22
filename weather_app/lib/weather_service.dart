import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = "ce028fe5d3b83f6bd9fc1500b571abb2";
  final String baseUrl = "https://api.openweathermap.org/data/2.5/weather";

  Future<Map<String, dynamic>> fetchWeather(String city) async {
    try {
      final url = Uri.parse('$baseUrl?q=$city&appid=$apiKey&units=metric');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      print("Error in API request: $e");
      rethrow;
    }
  }
}
