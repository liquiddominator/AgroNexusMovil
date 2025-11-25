class Weather {
  final String description;
  final double temperature;
  final double feelsLike;
  final double humidity;
  final String icon;

  final String city;
  final String country;

  Weather({
    required this.description,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.icon,
    required this.city,
    required this.country,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      description: json['weather'][0]['description'],
      temperature: (json['main']['temp'] as num).toDouble(),
      feelsLike: (json['main']['feels_like'] as num).toDouble(),
      humidity: (json['main']['humidity'] as num).toDouble(),
      icon: json['weather'][0]['icon'],
      city: json['name'] ?? '',
      country: (json['sys'] != null ? json['sys']['country'] : '') ?? '',
    );
  }
}