import 'dart:ui';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter/material.dart';
import 'package:weatherapp/screens/forecast_screen.dart';
import 'package:weatherapp/services/weather_service.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherService _weatherService = WeatherService();
  String _city = "London";
  Map<String, dynamic>? _currentWeather;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    try {
      final weatherData = await _weatherService.fetchCurrentWeather(_city);
      setState(() {
        _currentWeather = weatherData;
      });
    } catch (e) {
      print(e);
    }
  }

  void _showCitySelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Enter City Name"),
          content: TypeAheadField(
            suggestionsCallback: (pattern) async {
              return await _weatherService.fetchCitySuggestionst(pattern);
            },
            builder: (context, controller, focusNode) {
              return TextField(
                controller: controller,
                focusNode: focusNode,
                autofocus: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                //labelText:"City",
              );
            },
            itemBuilder: (context, suggestion) {
              return ListTile(title: Text(suggestion['name']));
            },
            onSelected: (city) {
              setState(() {
                _city = city['name'];
              });
            },
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel")),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _fetchWeather();
                },
                child: const Text("Submit")),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentWeather == null
          ? Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF1A2344),
                  Color.fromARGB(255, 125, 32, 142),
                  Colors.purple,
                  Color.fromARGB(255, 151, 44, 170),
                ],
              )),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            )
          : Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF1A2344),
                  Color.fromARGB(255, 125, 32, 142),
                  Colors.purple,
                  Color.fromARGB(255, 151, 44, 170),
                ],
              )),
              child: ListView(
                children: [
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: _showCitySelectionDialog,
                    child: Text(
                      _city,
                      style: GoogleFonts.lato(
                        fontSize: 36,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Column(
                      children: [
                        Image.network(
                          'http:${_currentWeather!['current']['condition']['icon']}',
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                        Text(
                          '${_currentWeather!['current']['temp_c'].round()}°C',
                          style: GoogleFonts.lato(
                            fontSize: 40,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${_currentWeather!['current']['condition']['text']}',
                          style: GoogleFonts.lato(
                            fontSize: 40,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        /*Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'Max: ${_currentWeather!['forecast']
                              ['forecastday'][0]['day']['maxtemp_c'].round()}°C',
                              style: GoogleFonts.lato(
                                fontSize: 22,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Min: ${_currentWeather!['forecast']['forecastday'][0]['day']['mintemp_c'].round()}°C',
                              style: GoogleFonts.lato(
                                fontSize: 22,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),*/
                      ],
                    ),
                  ),
                  const SizedBox(height: 45),
                  /*Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildWeatherDetail(
                          'Sunrise',
                          Icons.wb_sunny,
                          _currentWeather!['forecast']['forecasrday'][0]
                              ['astro']['sunrise']),
                      _buildWeatherDetail(
                          'Sunset',
                          Icons.brightness_3,
                          _currentWeather!['forecast']['forecasrday'][0]
                              ['astro']['sunset']),
                    ],
                  ),*/
                  const SizedBox(height: 40),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ForecastScreen(city: _city),
                            ));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A2344),
                      ),
                      child: const Text("Next 7 Days Forecast",
                          style: TextStyle(
                            color: Colors.white,
                          )),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  /* Widget _buildWeatherDetail(String label, IconData icon, dynamic value) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                begin: AlignmentDirectional.topStart,
                end: AlignmentDirectional.bottomEnd,
                colors: [
                  const Color(0xFF1A2344).withOpacity(0.5),
                  const Color(0xFF1A2344).withOpacity(0.2),
                ],
              )),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.white,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: GoogleFonts.lato(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                value is String ? value : value.toString(),
                style: GoogleFonts.lato(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }*/
}
