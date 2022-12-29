
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weath/models/weather3.dart';


class WeatherApi3 {
  static Future<List<News>> getNews(String source) async {
    var uri = Uri.https(
      'tellus-climate-feed.p.rapidapi.com',
      '/',
      {'source': source},
    );
    final response = await http.get(uri, headers: {
      'x-rapidapi-host': 'tellus-climate-feed.p.rapidapi.com',
      'x-rapidapi-key': '99703dc039mshc55251176509c32p132f82jsnff4969b8f5b6'
    });
    Map data = jsonDecode(response.body);

    List _temp = [];
    for (var i in data['articles']) {
      _temp.add(i);
    }


    return News.newsFromSnapshot(_temp);  }
}

