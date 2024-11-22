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
        title: const Text("Weather App"),
        actions: [
          IconButton(
            icon: const Icon(Icons.location_city),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => CitySelectionDialog(),
              );
            },
          ),
        ],
      ),
      body: weatherProvider.weatherData == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              weatherProvider.selectedCity,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              "${weatherProvider.weatherData!['main']['temp']}°C",
              style: const TextStyle(fontSize: 64),
            ),
            const SizedBox(height: 16),
            Text(
              weatherProvider.weatherData!['weather'][0]['description'],
              style: const TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}

class CitySelectionDialog extends StatelessWidget {
  CitySelectionDialog({Key? key}) : super(key: key);

  final TextEditingController _cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context, listen: false);

    return AlertDialog(
      title: const Text("Select City"),
      content: TextField(
        controller: _cityController,
        decoration: const InputDecoration(labelText: "City Name"),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            weatherProvider.setCity(_cityController.text);
            Navigator.of(context).pop();
          },
          child: const Text("OK"),
        ),
      ],
    );
  }
}
