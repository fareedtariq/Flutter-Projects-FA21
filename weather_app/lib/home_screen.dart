import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'weather_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120, // Increased height for better design
        flexibleSpace: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Weather App Name with Animation
              FadeInDown(
                child: Text(
                  "Weather App",
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Animated Search Bar
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 50,
                width: _isSearching ? 300 : 250,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.blue, Colors.lightBlueAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextField(
                  controller: _searchController,
                  onTap: () {
                    setState(() {
                      _isSearching = true;
                    });
                  },
                  onSubmitted: (value) {
                    setState(() {
                      _isSearching = false;
                    });
                    if (value.isNotEmpty) {
                      weatherProvider.setCity(value);
                    }
                  },
                  decoration: InputDecoration(
                    hintText: "Search City...",
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    prefixIcon: const Icon(Icons.search, color: Colors.white),
                    suffixIcon: _isSearching
                        ? IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          _isSearching = false;
                          _searchController.clear();
                        });
                      },
                    )
                        : null,
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.blueAccent,
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
              // City Name with Fade-In Animation
              FadeInDown(
                child: Text(
                  weatherProvider.selectedCity,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Weather Icon with Slide-In Animation
              SlideInUp(
                child: Image.network(
                  'https://openweathermap.org/img/wn/${weatherProvider.weatherData!['weather'][0]['icon']}@2x.png',
                  height: 100,
                ),
              ),
              const SizedBox(height: 16),
              // Temperature with Bounce-In Animation
              FadeIn(
                child: Text(
                  "${weatherProvider.weatherData!['main']['temp']}°C",
                  style: const TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Weather Description
              FadeInUp(
                child: Text(
                  weatherProvider.weatherData!['weather'][0]['description']
                      .toString()
                      .toUpperCase(),
                  style: const TextStyle(fontSize: 24),
                ),
              ),
              const SizedBox(height: 16),
              // Additional Details Section with Slide Animation
              SlideInLeft(child: WeatherDetails(weatherProvider.weatherData!)),
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
