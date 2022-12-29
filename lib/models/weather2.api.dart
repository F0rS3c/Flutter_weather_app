import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherApi2 {
  static Future<String> getWeather(String city) async {
    var uri = Uri.https(
      'weatherapi-com.p.rapidapi.com',
      'forecast.json',
      {"q": city},
    );
    final response = await http.get(uri, headers: {
      'x-rapidapi-host': 'weatherapi-com.p.rapidapi.com',
      'x-rapidapi-key':
          '99703dc039mshc55251176509c32p132f82jsnff4969b8f5b6' //TODO: add api key from https://rapidapi.com/weatherapi/api/weatherapi-com/
    });
    Map data = jsonDecode(response.body);

    return data['location']['name'];
  }

}
