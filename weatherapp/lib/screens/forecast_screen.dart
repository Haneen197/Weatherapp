import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weatherapp/services/weather_service.dart';

class ForecastScreen extends StatefulWidget {
  final String city;
  const ForecastScreen({required this.city});

  @override
  State<ForecastScreen> createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen> {
  final WeatherService _weatherService = WeatherService();

  List<dynamic>? _forecast;

  @override
  void initState() {
    super.initState();
    _fetchForecast();
  }

  Future<void> _fetchForecast() async {
    try {
      final forecastData = await _weatherService.fetch7dayWeather(widget.city);
      setState(() {
        _forecast = forecastData['forecast']['forecastday'];
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: _forecast == null
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
              height: MediaQuery.of(context).size.height,
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
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(Icons.arrow_back,
                                color: Colors.white, size: 30),
                          ),
                          const SizedBox(width: 15),
                          Text(
                            "7 day Forecast",
                            style: GoogleFonts.lato(
                              fontSize: 36,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _forecast!.length,
                      itemBuilder: (context, index) {
                        final day = _forecast![index];
                        String iconURL =
                            'http:${day['day']['condition']['icon']}';
                        return Padding(
                          padding: EdgeInsets.all(10),
                          child: ClipRRect(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                              child: Container(
                                  height: 110,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: LinearGradient(
                                        begin: AlignmentDirectional.topStart,
                                        end: AlignmentDirectional.bottomEnd,
                                        colors: [
                                          const Color(0xFF1A2344)
                                              .withOpacity(0.5),
                                          const Color(0xFF1A2344)
                                              .withOpacity(0.2),
                                        ],
                                      )),
                                  child: ListTile(
                                    leading: Image.network(iconURL),
                                    title: Text(
                                      '${day['date']} - ${day['day']['avgtemp_c'].round()}°C',
                                      style: GoogleFonts.lato(
                                        fontSize: 22,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    subtitle: Text(
                                      'Max: ${day['day']['maxtemp_c'].round()}°C\nMin: ${day['day']['mintemp_c'].round()}°C',
                                      style: GoogleFonts.lato(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  )),
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
              )),
    ));
  }
}
