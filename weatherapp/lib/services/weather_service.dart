import 'dart:convert';

import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = "746459cf876c42e0a14192758240811";
  final String forecastBaseURL = 'http://api.weatherapi.com/v1/forecast.json';
  final String searchBaseURL = 'http://api.weatherapi.com/v1/search.json';

  Future<Map<String, dynamic>> fetchCurrentWeather(String city) async {
    final url = '$forecastBaseURL?key=$apiKey&q=$city&days=1&api=no&alert=no';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<Map<String, dynamic>> fetch7dayWeather(String city) async {
    final url = '$forecastBaseURL?key=$apiKey&q=$city&days=7&api=no&alert=no';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load forecast data');
    }
  }

  Future<List<dynamic>?> fetchCitySuggestionst(String query) async {
    final url = '$searchBaseURL?key=$apiKey&q=$query';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return null;
    }
  }
}
