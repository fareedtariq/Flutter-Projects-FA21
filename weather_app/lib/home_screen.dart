import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'weather_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100, // Increased height to accommodate search bar
        flexibleSpace: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Search Bar
              SizedBox(
                height: 45,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search City...",
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      weatherProvider.setCity(value);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.blue,
        elevation: 4,
      ),
      body: weatherProvider.weatherData == null
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // City Name
              Text(
                weatherProvider.selectedCity,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              // Weather Icon
              Image.network(
                'https://openweathermap.org/img/wn/${weatherProvider.weatherData!['weather'][0]['icon']}@2x.png',
                height: 100,
              ),
              const SizedBox(height: 16),
              // Temperature
              Text(
                "${weatherProvider.weatherData!['main']['temp']}°C",
                style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              // Weather Description
              Text(
                weatherProvider.weatherData!['weather'][0]['description']
                    .toString()
                    .toUpperCase(),
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 16),
              // Additional Details
              WeatherDetails(weatherProvider.weatherData!),
            ],
          ),
        ),
      ),
    );
  }
}

class WeatherDetails extends StatelessWidget {
  final Map<String, dynamic> weatherData;

  const WeatherDetails(this.weatherData, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            WeatherDetailRow(
              icon: Icons.water_drop,
              label: "Humidity",
              value: "${weatherData['main']['humidity']}%",
            ),
            const Divider(),
            WeatherDetailRow(
              icon: Icons.air,
              label: "Wind Speed",
              value: "${weatherData['wind']['speed']} m/s",
            ),
            const Divider(),
            WeatherDetailRow(
              icon: Icons.thermostat,
              label: "Feels Like",
              value: "${weatherData['main']['feels_like']}°C",
            ),
          ],
        ),
      ),
    );
  }
}

class WeatherDetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const WeatherDetailRow({
    required this.icon,
    required this.label,
    required this.value,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.blue),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
