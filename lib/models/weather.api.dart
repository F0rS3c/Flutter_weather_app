import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weath/models/weather.dart';

class WeatherApi {
  static Future<List<Weather>> getWeather(String city) async {
    var uri = Uri.https(
      'weatherapi-com.p.rapidapi.com',
      'forecast.json',
      {"q": city, "days": "7"},
    );
    final response = await http.get(uri, headers: {
      'x-rapidapi-host': 'weatherapi-com.p.rapidapi.com',
      'x-rapidapi-key':
          '99703dc039mshc55251176509c32p132f82jsnff4969b8f5b6'
    });
    Map data = jsonDecode(response.body);
    List _temp = [];
    for (var i in data['forecast']['forecastday']) {
      _temp.add(i);
    }
    return Weather.weatherFromSnapshot(_temp);
  }
}
