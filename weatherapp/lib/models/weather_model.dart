class Weather {
  final String cityName;
  final double temprature;
  final String maincond;

  Weather({
    required this.cityName,
    required this.temprature,
    required this.maincond,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      temprature: json['main']['temp'].toDouble(),
      maincond: json['weather'][0]['main'],
    );
  }
}
