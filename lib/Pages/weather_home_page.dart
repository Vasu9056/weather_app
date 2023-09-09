import 'dart:async';

import 'package:flutter/material.dart';
import 'package:weather_app/Icons/icons.dart';
import 'package:weather_app/Model/weather_api.dart';
import 'package:weather_app/Services/weather_service.dart';
import 'package:weather_app/Widgets/forecast_card.dart';
import 'package:weather_app/Widgets/header.dart';
import 'package:weather_app/Widgets/info_card.dart';
import 'package:weather_app/colors/color.dart';
import 'package:weather_app/loading/loading_page.dart';

class WeatherHomePage extends StatefulWidget {
  WeatherHomePage({super.key});
  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  bool isLoading = true;
  WeatherService weatherService = WeatherService();
  Weather weather = Weather();

  String image = '';
  Color defaultColor = Colors.black;
  int hour = 0;
  bool isday = false;
  bool isNight = false;
  String icon = '';
  // bool _isLoadinf = true;

  Future getWeather() async {
    weather = await weatherService.getWeatherData();
    setState(() {
      getWeather();
      isLoading = false;
    });
  }

  void setday() async {
    List datetime = weather.date.split(' ');
    var hours = datetime[1].split(':');
    var turnInt = int.parse(hours[0]);
    if (turnInt >= 19 || turnInt <= 5) {
      print(turnInt);
      setState(() {
        isday = false;
        isNight = true;
        defaultColor = nightappbarcolor;
      });
    }
    if (turnInt > 5 && turnInt < 19) {
      setState(() {
        isNight = false;
        isday = true;
        defaultColor = dayappbarcolor;
      });
    }
  }

  void day() async {
    setState(() {
      defaultColor = dayappbarcolor;
    });
    if (weather.text == 'Sunny') {
      setState(() {
        loadingIcon = sunnyIcon;
      });
    }

    if (weather.text == 'Clear') {
      setState(() {
        loadingIcon = clearNightIcon;
      });
    }
  }

  void night() async {
    setState(() {
      defaultColor = nightappbarcolor;
    });

    if (weather.text == 'Partly Cloud') {
      setState(() {
        loadingIcon = partlyCloudyIconNight;
      });
    }
    if (weather.text == 'Clear') {
      setState(() {
        loadingIcon = clearNightIcon;
      });
    }
  }

  void gethour() {
    List datetime = weather.date.split(' ');
    var hours = datetime[1].split(':');
    var turnInt = int.parse(hours[0]);
    setState(() {
      hour = turnInt;
    });
  }

  @override
  void initState() {
    getWeather();
    Timer.periodic(Duration(seconds: 2), (timer) {
      setday();
    });
    Timer.periodic(Duration(seconds: 3), (timer) {
      isday ? day() : night();
    });
    Timer.periodic(Duration(seconds: 3), (timer) {
      gethour();
    });
    Future.delayed(Duration(seconds: 2), () async {
      await weatherService.getWeatherData;
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  Widget build(BuildContext context) => isLoading
      ? LoadingPage()
      : Scaffold(
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(300),
              child: Header(
                  backgroundColor: defaultColor,
                  city_name: weather.city,
                  description: weather.text,
                  descriptionIMG: loadingIcon,
                  state_name: weather.state,
                  temp: weather.temp)),
          body: Container(
            decoration: BoxDecoration(
                gradient: isday
                    ? LinearGradient(
                        begin: const Alignment(-1.5, 8),
                        end: const Alignment(-1.5, -0.5),
                        colors: [Colors.white, defaultColor])
                    : LinearGradient(
                        begin: const Alignment(-1.5, 8),
                        end: const Alignment(-1.5, -0.5),
                        colors: [Colors.white, defaultColor])),
            child: CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    color: Color.fromARGB(0, 255, 255, 255),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      itemCount: weather.forecast.length - hour - 1,
                      itemBuilder: (context, index) => SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 5),
                        child: Center(
                            child: ForecastCard(
                                hour: weather.forecast[hour + index]['time']
                                    .toString()
                                    .split(' ')[1],
                                averageTemp: weather.forecast[hour + index]
                                    ['temp_c'],
                                description: weather.forecast[hour + index]
                                    ['condition']['text'],
                                descriptionIMG: weather.forecast[hour + index]
                                        ['condition']['icon']
                                    .toString()
                                    .replaceAll('//', 'http://'))),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: InformartionsCard(
                      humidity: weather.humidity,
                      uvIndex: weather.uvIndex,
                      wind: weather.wind),
                )
              ],
            ),
          ),
        );
}
