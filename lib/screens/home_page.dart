import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:dart_ipify/dart_ipify.dart';
import 'package:weath/models/weather.api.dart';
import 'package:weath/models/weather.dart';
import 'package:intl/intl.dart';
import 'package:weath/models/weather2.api.dart';
import 'package:weath/models/weather3.dart';
import 'package:weath/models/weather3.api.dart';
import 'package:animations/animations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';




class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();

}


class _HomePageState extends State<HomePage> {
  String currentTime = "";
  List<Weather> _weather = [];
  List<News> _news = [];
  String cityName = "";
  int nextDayHour = 0;
  int forecastResultsCount = 24;
  int newsCount = 3;
  int hoursNextDay = 0;
  Random random = new Random();
  int randomNumber = 0;
  List hoursList = [];
  List newsList = [];
    String selectedItem = "";
  int currTime = DateTime.now().hour;
  int i=0 ;// current hour
  List<String> _capitalCities = ['Abu Dhabi', 'Abuja', 'Accra', 'Adamstown', 'Addis Ababa', 'Algiers', 'Alofi', 'Amman', 'Amsterdam', 'Andorra la Vella', 'Ankara', 'Antananarivo', 'Apia', 'Ashgabat', 'Asmara', 'Astana', 'Asuncion', 'Atafu', 'Athens', 'Avarua', 'Baghdad', 'Baku', 'Bamako', 'Bandar Seri Begawan', 'Bangkok', 'Bangui', 'Banjul', 'Basseterre', 'Beijing', 'Beirut', 'Belgrade', 'Belmopan', 'Berlin', 'Bern', 'Bishkek', 'Bissau', 'Bogota', 'Brasilia', 'Bratislava', 'Brazzaville', 'Bridgetown', 'Brussels', 'Bucharest', 'Budapest', 'Buenos Aires', 'Bujumbura', 'Cairo', 'Canberra', 'Caracas', 'Castries', 'Charlotte Amalie', 'Chisinau', 'Colombo', 'Conakry', 'Copenhagen', 'Dakar', 'Damascus', 'Dar es Salaam', 'Dhaka', 'Diego Garcia', 'Dili', 'Djibouti', 'Doha', 'Douglas', 'Dublin', 'Dushanbe', 'El-AaiÃºn', 'Freetown', 'Funafuti', 'Gaborone', 'George Town', 'Georgetown', 'Gibraltar', 'Grand Turk', 'Guatemala City', 'Gustavia', 'Hagatna', 'Hamilton', 'Hanoi', 'Harare', 'Hargeisa', 'Havana', 'Helsinki', 'Honiara', 'Islamabad', 'Jakarta', 'Jamestown', 'Jerusalem', 'Jerusalem', 'Juba', 'Kabul', 'Kampala', 'Kathmandu', 'Khartoum', 'Kigali', 'King Edward Point', 'Kingston', 'Kingston', 'Kingstown', 'Kinshasa', 'Kuala Lumpur', 'Kuwait City', 'Kyiv', 'La Paz', 'Libreville', 'Lilongwe', 'Lima', 'Lisbon', 'Ljubljana', 'Lome', 'London', 'Longyearbyen', 'Luanda', 'Lusaka', 'Luxembourg', 'Madrid', 'Majuro', 'Malabo', 'Male', 'Managua', 'Manama', 'Manila', 'Maputo', 'Mariehamn', 'Marigot', 'Maseru', 'Mata-Utu', 'Mbabane', 'Melekeok', 'Mexico City', 'Minsk', 'Mogadishu', 'Monaco', 'Monrovia', 'Montevideo', 'Moroni', 'Moscow', 'Muscat', "N'Djamena", 'N/A', 'N/A', 'N/A', 'N/A', 'Nairobi', 'Nassau', 'New Delhi', 'Niamey', 'Nicosia', 'North Nicosia', 'Nouakchott', 'Noumea', "Nuku'alofa", 'Nuuk', 'Oranjestad', 'Oslo', 'Ottawa', 'Ouagadougou', 'Pago Pago', 'Palikir', 'Panama City', 'Papeete', 'Paramaribo', 'Paris', 'Philipsburg', 'Phnom Penh', 'Plymouth', 'Podgorica', 'Port Louis', 'Port Moresby', 'Port of Spain', 'Port-Vila', 'Port-au-Prince', 'Port-aux-FranÃ§ais', 'Porto-Novo', 'Prague', 'Praia', 'Pretoria', 'Pristina', 'Pyongyang', 'Quito', 'Rabat', 'Rangoon', 'Reykjavik', 'Riga', 'Riyadh', 'Road Town', 'Rome', 'Roseau', "Saint George's", 'Saint Helier', "Saint John's", 'Saint Peter Port', 'Saint-Pierre', 'Saipan', 'San Jose', 'San Juan', 'San Marino', 'San Salvador', 'Sanaa', 'Santiago', 'Santo Domingo', 'Sao Tome', 'Sarajevo', 'Seoul', 'Singapore', 'Skopje', 'Sofia', 'Stanley', 'Stockholm', 'Suva', 'Taipei', 'Tallinn', 'Tarawa', 'Tashkent', 'Tbilisi', 'Tegucigalpa', 'Tehran', 'The Settlement', 'The Valley', 'Thimphu', 'Tirana', 'Tokyo', 'Torshavn', 'Tripoli', 'Tunis', 'Ulaanbaatar', 'Vaduz', 'Valletta', 'Vatican City', 'Victoria', 'Vienna', 'Vientiane', 'Vilnius', 'Warsaw', 'Washington', 'Washington', 'Wellington', 'West Island', 'Willemstad', 'Windhoek', 'Yamoussoukro', 'Yaounde', 'Yaren', 'Yerevan', 'Zagreb'];
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  String? _currentAddress;
  Position? _currentPosition;
  FaIcon customIcon = const FaIcon(FontAwesomeIcons.searchLocation);
  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()

    if(mounted)
      setState(() {

      });
    _refreshController.loadComplete();
  }



  @override
  void initState() {
    super.initState();
    getIP();
    updateTime();
  }


void getIP() async {
    await Ipify.ipv4().then((value) {
      getWeather('khouribga');
      getWeather2('khouribga');
      getNews('Nasa Climate');
      _getCurrentPosition();



    });
  }
  void updateTime() {
    setState(() {
      currentTime = DateFormat.yMMMMEEEEd().add_jm().format(DateTime.now());
    });
    Timer(Duration(minutes: 1), updateTime);
  }


  Future<void> getWeather2(String city) async {
    String _cityName = await WeatherApi2.getWeather(city);

    setState(() {
      cityName = _cityName;
    });
  }
    String getDayOfWeek(String dateString) {
    DateTime date = DateTime.parse(dateString);
    return DateFormat.EEEE().format(date);
  }
  Future<void> getWeather(String city) async {
    int j = 0;
    List<Weather> _weatherTemp = await WeatherApi.getWeather(city);
    for (var i = currTime; i < 24; i++) {
      hoursList.add(i);

    }

    while (j < forecastResultsCount) {
      if (currTime >= 23) {
        hoursList.add(hoursNextDay);
        hoursNextDay++;
        currTime++;
      }
      currTime++;
      j++;
    }

    setState(() {
      _weather = _weatherTemp;
    });
  }


  Future<void> getNews(String source) async {
    List<News> _newsTemp = await WeatherApi3.getNews(source);
    setState(() {
      _news = _newsTemp;
    });
  }








  @override
  Widget build(BuildContext context) {
     //city name


    Size size = MediaQuery.of(context).size;
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return Scaffold(

      body:

      Center(
        child: Container(
          height: size.height,
          width: size.height,
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.black : Colors.white,
          ),
          child: SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: size.height * 0.01,


                        ),
                        child: Container(
                          width: 600,
                          height: 140,


                          decoration: BoxDecoration(
                            image: DecorationImage(

                              image: AssetImage("image/we.jpeg"),
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(Colors.white30.withOpacity(.2), BlendMode.modulate)

                            )
                          ),

                          child : Padding (
                            padding: EdgeInsets.only(bottom: 100 , left: 15 , right: 15),

                            child: Row(

                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // InkWell(
                                //   onTap: () {
                                //
                                //       TextField(
                                //         decoration: InputDecoration(
                                //           hintText: 'type in journal name...',
                                //           hintStyle: TextStyle(
                                //             color: Colors.white,
                                //             fontSize: 18,
                                //             fontStyle: FontStyle.italic,
                                //           ),
                                //           border: InputBorder.none,
                                //         ),
                                //         style: TextStyle(
                                //           color: Colors.white,
                                //         ),
                                //       );
                                //
                                //
                                //
                                //
                                //
                                //   },
                                //   child:    FaIcon(
                                //
                                //
                                //     FontAwesomeIcons.searchLocation,
                                //     color: isDarkMode ? Colors.white : Colors.black,
                                //
                                //   ),
                                // ),




                                InkWell(
                                  onTap: () {
                                    showMenu(
                                      context: context,

                                      position: RelativeRect.fromLTRB(100, 100, 0, 0),
                                      items: _capitalCities.map((String city) {
                                        return PopupMenuItem(
                                          value: city,

                                          // child: Text(city),
                                          child: TextButton(
                                            onPressed: () {
                                              setState(() {
                                                selectedItem = city;

                                              });
                                              getWeather(selectedItem);
                                              getWeather2(selectedItem);

                                            },
                                            child: Text(city),
                                          ),
                                        );
                                      }).toList(),

                                    );

                                  },
                                  child:   FaIcon(
                                    FontAwesomeIcons.plusCircle,
                                    color: isDarkMode ? Colors.white : Colors.black,
                                  ),
                                )
                              ],
                            ),

                          )


                      ),
                      ),



                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.05,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            color: isDarkMode
                                ? Colors.white.withOpacity(0.05)
                                : Colors.black.withOpacity(0.05),
                          ),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top: size.height * 0.01,
                                    left: size.width * 0.03,
                                  ),

                                  child: Row(

                                    children: [

                                      City(
                                        FontAwesomeIcons.mapMarkerAlt,
                                        cityName,
                                        currentTime,
                                        isDarkMode,
                                      )
                                    ],
                                  ),
                                ),


                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top: size.height * 0.01,
                                    left: size.width * 0.03,
                                  ),

                                  child: Row(
                                    children: [
                                      _weather.isNotEmpty ?
                                      Currentt(

                                        hoursList[0] < 18 && hoursList[0] > 6
                                            ? _weather[0].hour[hoursList[0]]['chance_of_rain'].round() > 30 ?  FontAwesomeIcons.cloudRain : _weather[0].hour[hoursList[0]]['chance_of_rain'].round() > 10 ? FontAwesomeIcons.cloudSun :_weather[0].hour[hoursList[0]]['chance_of_snow'].round() >= 1 ? WeatherIcons.day_snow :_weather[0].hour[hoursList[0]]['chance_of_snow'].round() >30 ? FontAwesomeIcons.snowflake  : FontAwesomeIcons.sun
                                            : _weather[0].hour[hoursList[0]]['chance_of_rain'].round() > 30 ? FontAwesomeIcons.cloudMoonRain : _weather[0].hour[hoursList[0]]['chance_of_rain'].round() > 10 ? FontAwesomeIcons.cloudMoon :_weather[0].hour[hoursList[0]]['chance_of_snow'].round() >= 1 ? WeatherIcons.night_alt_snow :_weather[0].hour[hoursList[0]]['chance_of_snow'].round() >30 ? FontAwesomeIcons.snowflake  : FontAwesomeIcons.moon,

                                        '${_weather.first.hour[hoursList[0]]['temp_c'].round()}',
                                        isDarkMode,

                                      )
                                          : SizedBox(
                                        height: size.width * 0.265,
                                        width: size.width * 0.265,
                                        child: Transform.scale(
                                          scale: 1,
                                          child: const CircularProgressIndicator(
                                            strokeWidth: 2.0,
                                            valueColor:
                                            AlwaysStoppedAnimation(Colors.indigo),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),


                              ),

                              Padding(
                                padding: EdgeInsets.all(size.width * 0.005),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [

                                         for(int i = 0; i < forecastResultsCount; i++)
                                           _weather.isNotEmpty ?
                                        buildForecastToday(
                                          i == 0
                                              ? 'Now'
                                              : '${hoursList[i]}:00',
                                          i > hoursList.length - hoursNextDay - 1
                                              ? _weather[1].hour[hoursList[i]]['temp_c'].round()
                                              : _weather.first.hour[hoursList[i]]['temp_c'].round(),
                                          hoursList[i] < 18 && hoursList[i] > 6
                                              ? _weather.first.hour[hoursList[i]]['chance_of_rain'].round() > 30 ? FontAwesomeIcons.cloudRain : _weather.first.hour[hoursList[i]]['chance_of_rain'].round() > 10 ? FontAwesomeIcons.cloudSun :_weather[0].hour[hoursList[0]]['chance_of_snow'].round() >= 1 ? WeatherIcons.day_snow :_weather[0].hour[hoursList[0]]['chance_of_snow'].round() >30 ? FontAwesomeIcons.snowflake : FontAwesomeIcons.sun
                                              : _weather.first.hour[hoursList[i]]['chance_of_rain'].round() > 30 ? FontAwesomeIcons.cloudMoonRain : _weather.first.hour[hoursList[i]]['chance_of_rain'].round() > 10 ? FontAwesomeIcons.cloudMoon :_weather[0].hour[hoursList[0]]['chance_of_snow'].round() >=1 ? WeatherIcons.night_alt_snow :_weather[0].hour[hoursList[0]]['chance_of_snow'].round() >30 ? FontAwesomeIcons.snowflake : FontAwesomeIcons.moon,
                                          _weather.first.hour[hoursList[i]]['chance_of_rain'].round(),
                                          size,
                                          isDarkMode,
                                        )
                                      : SizedBox(
                                        height: size.width * 0.265,
                                        width: size.width * 0.265,
                                        child: Transform.scale(
                                          scale: 1,
                                          child: const CircularProgressIndicator(
                                            strokeWidth: 2.0,
                                            valueColor:
                                            AlwaysStoppedAnimation(Colors.indigo),
                                          ),
                                        ),
                                      ),




                                    ],
                                  ),




                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: EdgeInsets.only(top: 10 , bottom: 10),

                                  child:  TextButton(
                                      style: ButtonStyle(
                                        minimumSize:
                                          MaterialStateProperty.all(Size(110, 10)),


                                        backgroundColor: MaterialStateProperty.all<Color>( isDarkMode ? Colors.white10 : Colors.black),
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(20.0),
                                                  side: BorderSide(color: isDarkMode ? Colors.white10 : Colors.black),
                                              )
                                          )
                                      ),

                                    onPressed: _launchURL,
                                    child: Container(


                                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),

                                      child: const Text(
                                        'More',
                                        style: TextStyle(color: Colors.white54, fontSize: 15

                                        ),
                                      ),
                                    ),
                                  ),
                                ),


                              ),

                            ],
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.05,
                          vertical: size.height * 0.02,
                        ),
                        child: Container(
                          decoration: BoxDecoration(

                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            color: isDarkMode
                                ? Colors.white.withOpacity(0.05)
                                : Colors.black.withOpacity(0.05),
                          ),
                          child: Column(
                            children: [

                              Padding(
                                padding: EdgeInsets.all(size.width * 0.005),
                                child: Column(
                                  children: [
                                    for(int i = 0; i < 3; i++)
                                      _weather.isNotEmpty ?
                                    buildSevenDayForecast(
                                    i == 0 ? 'Today' : getDayOfWeek("${_weather[i].day}"),
                                      _weather[i].daily_chance_of_rain,
                                      _weather[i].minTemp,
                                      _weather[i].maxTemp,
                                      _weather[i].daily_chance_of_rain > 30
                                          ? FontAwesomeIcons.cloudRain
                                          : _weather[i].daily_chance_of_rain > 10
                                          ? FontAwesomeIcons.cloudSun
                                          : _weather[i].daily_chance_of_snow >= 1 ? WeatherIcons.day_snow : _weather[i].daily_chance_of_snow > 30 ? FontAwesomeIcons.snowflake : FontAwesomeIcons.sun,


                                      _weather[i].daily_chance_of_rain > 30
                                          ? FontAwesomeIcons.cloudMoonRain
                                          : _weather[i].daily_chance_of_rain > 10
                                          ? FontAwesomeIcons.cloudMoon
                                          : _weather[i].daily_chance_of_snow >= 1 ? WeatherIcons.night_alt_snow : _weather[i].daily_chance_of_snow > 30 ? FontAwesomeIcons.snowflake : FontAwesomeIcons.moon,

                                      size,
                                      isDarkMode,
                                    )
                                    : SizedBox(
                                      height: size.width * 0.265,
                                      width: size.width * 0.265,
                                      child: Transform.scale(
                                        scale: 1,
                                        child: const CircularProgressIndicator(
                                          strokeWidth: 2.0,
                                          valueColor:
                                          AlwaysStoppedAnimation(Colors.indigo),
                                        ),
                                      ),
                                    ),


                                  ],
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: EdgeInsets.only(top: 10 , bottom: 10),

                                  child:  TextButton(
                                    style: ButtonStyle(
                                        minimumSize:
                                        MaterialStateProperty.all(Size(110, 10)),


                                        backgroundColor: MaterialStateProperty.all<Color>(isDarkMode ? Colors.white10 : Colors.black),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20.0),
                                              side: BorderSide(color: isDarkMode ? Colors.white10 : Colors.black),
                                            )
                                        )
                                    ),

                                    onPressed: _getWeather,
                                    child: Container(


                                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),

                                      child: const Text(
                                        'More',
                                        style: TextStyle(color: Colors.white54, fontSize: 15 ),
                                      ),
                                    ),
                                  ),
                                ),


                              ),


                            ],


                          ),


                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.05,
                          vertical: size.height * 0.02,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            color: isDarkMode
                                ? Colors.white.withOpacity(0.05)
                                : Colors.black.withOpacity(0.05),
                          ),
                          child:_news.isNotEmpty ?
                          Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top: size.height * 0.01,
                                    left: size.width * 0.03,
                                  ),

                                  child: Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(20.0),
                                       child : Image.network(

                                          '${_news[16].thumbnail}',
                                          width: 350,
                                          height: 170,
                                          fit: BoxFit.fill,

                                        ),

                                      ),
                                       Padding(
                                         padding: EdgeInsets.only(
                                           left:
                                            size.width * 0.04,
                                         ),
                                         child:
                                         Text(
                                           '${_news[16].title}',
                                           style: TextStyle(color:isDarkMode ? Colors.white54 : Colors.black),
                                         ),
                                       )




                                    ],

                                  ),


                                ),


                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top: size.height * 0.01,
                                    left: size.width * 0.03,
                                  ),

                                  child: Row(
                                    children: [

                                      Padding(
                                        padding: EdgeInsets.only(


                                        ),
                                        child :
                                        Padding (
                                          padding : EdgeInsets.only() ,
                                        child : Flexible(child:   ClipRRect(
                                          borderRadius: BorderRadius.circular(20.0),
                                          child :
                                          GestureDetector(
                                            onTap: () {
                                              launch('${_news[10].url}');
                                            },
                                            child : Image.network(

                                              '${_news[10].thumbnail}',
                                              width: 160,
                                              height: 85,
                                              fit: BoxFit.fill,

                                            ),
                                          ),
                                        ) , flex: 1, ),

                                        ),

                                      ),

                                      Padding(
                                        padding: EdgeInsets.only(left: 30,),
                                      child : Flexible(child:ClipRRect(borderRadius: BorderRadius.circular(20.0),
                                        child :

                                        GestureDetector(
                                          onTap: () {
                                            launch('${_news[18].url}');
                                          },
                                          child : Image.network(

                                          '${_news[18].thumbnail}',
                                          width: 160,
                                          height: 85,
                                          fit: BoxFit.fill,

                                        ),
                                        ),
                                      ) , flex: 1, ),
                                      )




                                    ],

                                  ),


                                ),


                              ),

                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top: size.height * 0.01,
                                    left: size.width * 0.03,
                                  ),


                                ),


                              ),


                              Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: EdgeInsets.only(top: 10 , bottom: 10),


                                  child:  TextButton(
                                    style: ButtonStyle(
                                        minimumSize:
                                        MaterialStateProperty.all(Size(110, 10)),


                                        backgroundColor: MaterialStateProperty.all<Color>(isDarkMode ? Colors.white10 : Colors.black),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20.0),
                                              side: BorderSide(color: isDarkMode ? Colors.white10 : Colors.black),
                                            )
                                        )
                                    ),

                                    onPressed: () async {
                                      final url = 'https://climate.nasa.gov/news/';
                                      if (await canLaunch(url)) {
                                        await launch(url);
                                      } else {
                                        throw 'Could not launch $url';
                                      }
                                    },
                                    child: Container(




                                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),

                                      child: const Text(
                                        'More',
                                        style: TextStyle(color: Colors.white54, fontSize: 15 ),
                                      ),
                                    ),
                                  ),
                                ),


                              ),

                            ],
                          )
                                       : SizedBox(
                          height: size.width * 0.265,
                          width: size.width * 0.265,
                          child: Transform.scale(
                            scale: 1,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2.0,
                              valueColor:
                              AlwaysStoppedAnimation(Colors.indigo),
                            ),
                          ),
                        ),
                        ),
                      ),

                      //details
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.05,
                          vertical: size.height * 0.02,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            color: isDarkMode
                                ? Colors.white.withOpacity(0.05)
                                : Colors.black.withOpacity(0.05),
                          ),
                          child: _weather.isNotEmpty ?

                          Column(
                            children: [

                              weatherDetails(
                                WeatherIcons.earthquake,
                                Colors.yellowAccent,
                                'UV index  ',
                                _weather[0].uv <= 2
                                    ? 'Low'
                                    : _weather[0].uv <= 5
                                    ? 'Moderate'
                                    : _weather[0].uv <= 7
                                    ? 'High'
                                    : _weather[0].uv <= 10
                                    ? 'Very High'
                                    : 'Extreme',
                                size,
                                isDarkMode,
                              ),

                              weatherDetails(
                                WeatherIcons.sunrise,
                                Colors.orange,
                                'Sunrise    ',
                                '${_weather[0].sunrise}',
                                size,
                                isDarkMode,
                              ),
                              weatherDetails(
                                WeatherIcons.sunset,
                                Colors.deepOrange,
                                'Sunset     ',
                                '${_weather[0].sunset}',
                                size,
                                isDarkMode,
                              ),
                              weatherDetails(
                                FontAwesomeIcons.wind,
                                Colors.white54,
                                'Wind           ',
                                '${_weather[0].maxwind_kph} km/h',
                                size,
                                isDarkMode,
                              ),
                              // weatherDetails(
                              //   WeatherIcons.dust,
                              //   Colors.white54,
                              //   'AQI     ',
                              //   'Low (2)',
                              //   size,
                              //   isDarkMode,
                              // ),
                              weatherDetails(
                                WeatherIcons.humidity,
                                Colors.cyanAccent,
                                'Humidity          ',
                                '${_weather[0].avghumidity} %',
                                size,
                                isDarkMode,
                              ),

                              Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: EdgeInsets.only(top: 10 , bottom: 10),


                                  child:  TextButton(
                                    style: ButtonStyle(
                                        minimumSize:
                                        MaterialStateProperty.all(Size(110, 10)),


                                        backgroundColor: MaterialStateProperty.all<Color>(isDarkMode ? Colors.white10 : Colors.black),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20.0),
                                              side: BorderSide(color: isDarkMode ? Colors.white10 : Colors.black),
                                            )
                                        )
                                    ),

                                    onPressed: _launchURL,
                                    child: Container(




                                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),

                                      child: const Text(
                                        'More',
                                        style: TextStyle(color: Colors.white54, fontSize: 15 ),
                                      ),
                                    ),
                                  ),
                                ),


                              ),

                            ],
                          ): SizedBox(
                            height: size.width * 0.265,
                            width: size.width * 0.265,
                            child: Transform.scale(
                              scale: 1,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2.0,
                                valueColor:
                                AlwaysStoppedAnimation(Colors.indigo),
                              ),
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }



  Widget buildForecastToday(String time, int temp, IconData weatherIcon,int rainChance, size, bool isDarkMode) {
    return Padding(
      padding: EdgeInsets.all(size.width * 0.025),
      child: Column(
        children: [
          Text(
            time,
            style: GoogleFonts.questrial(
              color: isDarkMode ? Colors.white : Colors.black,
              fontSize: size.height * 0.02,
            ),
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: size.height * 0.005,
                ),
                child: FaIcon(
                  weatherIcon,
                  color: isDarkMode ? Colors.white : Colors.black,
                  size: size.height * 0.03,
                ),
              ),
            ],
          ),
          Text(
            '$temp˚',
            style: GoogleFonts.questrial(
              color: isDarkMode ? Colors.white : Colors.black,
              fontSize: 20,
            ),
          ),

          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Icon(
                  WeatherIcons.raindrop,
                  color: Colors.lightBlueAccent,
                  size: 10,
                ),
              ),
              Text(
                '$rainChance %',
                style: GoogleFonts.questrial(

                  color: isDarkMode ? Colors.white54 : Colors.black,
                  fontSize: 15,

              ),
              )


            ],

          ),



        ],
      ),
    );
  }
  Widget weatherDetails(IconData det , Color dec , String deta, String detai ,size, bool isDarkMode) {
    return Padding(
      padding: EdgeInsets.all(size.width * 0.025),
      child: Column(
        children: [

          Row(
            children: [

              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: size.height * 0.01,
                    left: size.width * 0.03,
                  ),

                  child: Row(
                    children: [

                      Padding(
                        padding: EdgeInsets.only(
                            right:5,
                            left: 0
                        ),
                        child :
                        Padding (
                          padding : EdgeInsets.only() ,
                          child: Icon(
                            det,
                            color: dec,
                            size: 30,
                          ),
                        ),
                      ),

                      Align (
                        alignment: Alignment.center,
                        child : Padding (
                          padding : EdgeInsets.only(

                              top :10,
                              right: 120,
                              left: 5

                          ) ,
                          child : Text (
                            deta ,
                            style: TextStyle(color:isDarkMode ? Colors.white54 : Colors.black , fontSize:20

                                ),


                          ),
                        ),

                      ),

                      Align (
                        alignment: Alignment.topRight,

                          child : Padding (
                            padding : EdgeInsets.only(
                                top :10,

                            ) ,
                            child : Text (
                              detai ,
                              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontSize:20 ),

                            ),
                          ),



                        ),

                    ],


                  ),


                ),


              ),




              ]

    )]));


  }

  Widget City(IconData weatherIcon, String city , String dd , bool isDarkMode) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20 ),
      child: Column(
        children: [


          Padding(padding: EdgeInsets.only(right: 70),
            child:  Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Icon(
                    weatherIcon,
                    color: isDarkMode ? Colors.white : Colors.black,

                  ),
                ),
                Text(
                  '$city',
                  style: GoogleFonts.questrial(
                    color: isDarkMode
                        ? Colors.white
                        : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),

                ),


              ],
            ),

          ),


          Row(
            children: [
              Text(
                '$dd',
                style: GoogleFonts.questrial(
                  color: isDarkMode
                      ? Colors.white54
                      : Colors.black,

                  fontSize: 15,
                ),

              ),


            ],
          ),





        ],
      ),
    );
  }

  Widget Currentt(IconData weatherIcon, String temp , bool isDarkMode) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: Column(
        children: [

          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Icon(
                  weatherIcon,
                  color: isDarkMode ? Colors.white : Colors.black,
                  size: 50,

                ),
              ),
              Text(
                '$temp°',
                style: GoogleFonts.questrial(
                  color: isDarkMode
                      ? Colors.white
                      : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 60,
                ),

              ),



            ],
          ),






        ],
      ),
    );
  }
  _launchURL() async {
    const url = 'https://openweathermap.org/city/2544246';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  _getWeather() async {
    String url ="https://api.openweathermap.org/data/2.5/forecast?q=rabat&appid=a488d0e105cae3c43e7655449b27b1c3";
    print(url);
    http.get(Uri.parse(url))
        .then((response){
      var result = jsonDecode(response.body);
      String cityy = result['city']['name'];
      print(cityy);

    }).catchError((err){
      print(err);
    });

  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
    print('${_currentAddress} , ddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd');

  }

    Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
        _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
        '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });

  }


  Widget buildSevenDayForecast(String time,int raina , int minTemp, int maxTemp,
      IconData weatherIcon, IconData nightIcon, size, bool isDarkMode) {
    return Padding(
      padding: EdgeInsets.all(
        size.height * 0.005,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.02,
                ),
                child: Text(
                  time,
                  style: GoogleFonts.questrial(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: size.height * 0.025,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                      left: 200
                ),
                child: FaIcon(
                  weatherIcon,

                  color: isDarkMode ? Colors.white : Colors.black,
                  size: size.height * 0.03,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left:240
                ),
                child: FaIcon(
                  nightIcon,

                  color: isDarkMode ? Colors.white : Colors.black,
                  size: size.height * 0.03,
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 5,

                    left: 140,
                  ),
                  child:           Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Icon(
                          WeatherIcons.raindrop,
                          color: Colors.lightBlueAccent,
                          size: size.height * 0.02,
                        ),
                      ),
                      Text(
                        '$raina %',
                        style: GoogleFonts.questrial(

                          color: isDarkMode ? Colors.white54 : Colors.black,
                          fontSize: 13,

                        ),
                      )


                    ],

                  ),
                ),
              ),

              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 7,
                    left: 10,
                  ),
                  child: Text(
                    '$maxTemp˚/$minTemp˚',
                    style: GoogleFonts.questrial(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),


            ],

          ),


        ],
      ),

    );

  }
}
