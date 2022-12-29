class Weather {
  late final String icon;
  late final String text;
  late final String day;
  late final int maxTemp;
  late final int minTemp;
  late final int daily_chance_of_rain;
  late final String sunrise;
  late final String sunset;
  late final int maxwind_kph;
  late final int uv;
  late final int avghumidity;
  late final int daily_chance_of_snow;
  late final List hour;

  Weather({
    required this.icon,
    required this.text,
    required this.day,
    required this.maxTemp,
    required this.minTemp,
    required this.daily_chance_of_rain,
    required this.sunrise,
    required this.sunset,
    required this.maxwind_kph,
    required this.uv,
    required this.avghumidity,
    required this.daily_chance_of_snow,
    required this.hour,
  });

  factory Weather.fromJson(dynamic json) {
    return Weather(
      icon: (json['day']['condition']['icon'] as String),
      text: json['day']['condition']['text'] as String,
      day: json['date'] as String,
      maxTemp: json['day']['maxtemp_c'].round(),
      minTemp: json['day']['mintemp_c'].round(),
      daily_chance_of_rain: json['day']['daily_chance_of_rain'].round(),
      sunrise: json['astro']['sunrise'] as String,
      sunset: json['astro']['sunset'] as String,
      maxwind_kph: json['day']['maxwind_kph'].round(),
      uv: json['day']['uv'].round(),
      avghumidity: json['day']['avghumidity'].round(),
      daily_chance_of_snow: json['day']['daily_chance_of_snow'].round(),
      hour: json['hour'] as List,
    );
  }
  static List<Weather> weatherFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return Weather.fromJson(data);
    }).toList();
  }

  @override
  String toString() {
    return '{"icon": "$icon", "text": $text, "day": $day,  "maxTemp": $maxTemp, "minTemp": $minTemp, "daily_chance_of_rain": $daily_chance_of_rain, "sunrise": $sunrise, "sunset": $sunset, "maxwind_kph": $maxwind_kph, "uv": $uv, "avghumidity": $avghumidity, "daily_chance_of_snow": $daily_chance_of_snow "hour": $hour}';
  }
}
