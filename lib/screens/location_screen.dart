import 'package:weathermate/utilities/backgrounds.dart';
import 'package:weathermate/widgets/animated_wave.dart';
import 'package:weathermate/utilities/constants.dart';
import 'package:weathermate/services/weather.dart';
import 'package:weathermate/widgets/fade_in.dart';
import 'package:flutter/material.dart';
import 'city_screen.dart';
import 'dart:math';


// TODO: add forecast data

class LocationScreen extends StatefulWidget {

  LocationScreen({this.locationWeather});

  final locationWeather;

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {

  WeatherModel weather = WeatherModel();

  List<Map> upcomingHours = [{}, {}, {}, {}]; // contains 4 entries for hourly forecast data (3, 6, 9, 12 hours in future)
  int temp, humidity, feelsLike, windSpeed, uvi;
  String weatherMessage;
  String weatherIcon;
  String city;

  @override
  void initState() {
    super.initState();
    
    // retrieve weather data upon creation of screen
    updateUI(widget.locationWeather);
  }

  Widget generateForecastWidget() {
    List<Widget> forecastCards = [];
    for (int i = 0; i < upcomingHours.length; i++) {
      forecastCards.add(Column(
        children: [
          Text(
            "${upcomingHours[i]['time']}",
            style: kForecastTextStyle,
          ),
          Text(
            "${upcomingHours[i]['icon']}",
            style: kForecastConditionTextStyle,
          ),
          Text(
            "${upcomingHours[i]['temp']}°",
            textAlign: TextAlign.left,
            style: kForecastTextStyle,
          ),
        ],
      ));
      forecastCards.add(SizedBox(width: 15.0));
    }

    return Row(
      children: forecastCards,
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }

  // taps into the retrieved weather data to access desired weather characteristics
  void updateUI(dynamic weatherData) {
    setState(() {
      if (weatherData == null) { // TODO: make this better by adding popup error message instead
        temp = 0;
        weatherIcon = 'Error';
        weatherMessage = 'Unable to retrieve weather data';
        city = '';
        return;
      }
      city = weatherData['cityName'];

      for (int i = 0; i < 4; i++) {
        upcomingHours[i]['time'] = weatherData['hourly'][i * 3]['dt'];
        upcomingHours[i]['time'] = DateTime.fromMillisecondsSinceEpoch(1000 * upcomingHours[i]['time']); // converting timestamp -> DateTime
        upcomingHours[i]['time'] = '${upcomingHours[i]['time'].hour}';
        if (int.parse(upcomingHours[i]['time']) > 12) {
          upcomingHours[i]['time'] = (int.parse(upcomingHours[i]['time']) % 12).toString() + " PM";
        } else if (int.parse(upcomingHours[i]['time']) == 12) {
          upcomingHours[i]['time'] = "${upcomingHours[i]['time']} PM";
        } else {
          upcomingHours[i]['time'] = "${upcomingHours[i]['time']} AM";
        }
        
        upcomingHours[i]['temp'] = weatherData['hourly'][i * 3]['temp'].toInt();
        upcomingHours[i]['condition'] = weatherData['hourly'][i * 3]['weather'][0]['id'];
        upcomingHours[i]['icon'] = weather.getWeatherIcon(upcomingHours[i]['condition']);
      }

      temp = weatherData['current']['temp'].toInt();
      humidity = weatherData['current']['humidity'].toInt();
      feelsLike = weatherData['current']['feels_like'].toInt();
      windSpeed = weatherData['current']['wind_speed'].toInt();
      uvi = weatherData['current']['uvi'].toInt();

      weatherMessage = weather.getMessage(temp);

      var condition = weatherData['current']['weather'][0]['id'];
      weatherIcon = weather.getWeatherIcon(condition);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Stack(
            children: <Widget>[ 
              // START ANIMATED BACKGROUND
              // TODO: sync up background with weather conditions
              Positioned.fill(
                child: snowBackground,
              ),
              onBottom(
                AnimatedWave(
                  height: 180,
                  speed: 1.0, // TODO: sync up wave speed with current wind speed
                )
              ),
              onBottom(
                AnimatedWave(
                  height: 120,
                  speed: 0.9,
                  offset: pi,
                )
              ),
              onBottom(
                AnimatedWave(
                  height: 220,
                  speed: 1.2,
                  offset: pi / 2,
                )
              ),
              // END ANIMATED BACKGROUND
              Column( // main weather content section
                children: [
                  Padding( // top navigation buttons
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        // TODO: move these buttons to a side menu that includes settings
                        FlatButton(
                          onPressed: () async {
                            var weatherData = await weather.getLocationWeather();
                            updateUI(weatherData);
                          },
                          child: Icon(
                            Icons.near_me,
                            size: 50.0,
                          ),
                        ),
                        FlatButton(
                          onPressed: () async {
                            var inputCity = await Navigator.push( // returns Future output from CityScreen (when Navigator.pop is called)
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return CityScreen();
                                },
                              ),
                            );
                            if (inputCity != null) {
                              var weatherData = await weather.getCityWeather(inputCity);
                              updateUI(weatherData);
                            }
                          },
                          child: Icon(
                            Icons.location_city,
                            size: 50.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Row(
                      children: <Widget>[
                        FadeIn(
                          delay: 1.0, 
                          child: Text(
                            '$temp°',
                            style: kTempTextStyle,
                          ),
                        ),
                        FadeIn(
                          delay: 2.0,
                          child: Text(
                            weatherIcon,
                            style: kConditionTextStyle,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // FORECASE DATA HERE
                  // Padding(
                  //   padding: EdgeInsets.only(left: 50.0),
                  //   child: FadeIn(
                  //     delay: 3.0,
                  //     child: Column(
                  //       // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //       crossAxisAlignment: CrossAxisAlignment.stretch,
                  //       children: [
                  //         Text(
                  //           'Feels like: $feelsLike°',
                  //           textAlign: TextAlign.left,
                  //           style: kWeatherCharacteristicsTextStyle,
                  //         ),
                  //         Text(
                  //           'Humidity: $humidity%',
                  //           textAlign: TextAlign.left,
                  //           style: kWeatherCharacteristicsTextStyle,
                  //         ),
                  //         Text(
                  //           'Wind: $windSpeed mph',
                  //           textAlign: TextAlign.left,
                  //           style: kWeatherCharacteristicsTextStyle,
                  //         ),
                  //         Text(
                  //           'UV Index: $uvi',
                  //           textAlign: TextAlign.left,
                  //           style: kWeatherCharacteristicsTextStyle,
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: FadeIn(
                      delay: 3.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Feels like: $feelsLike°',
                                textAlign: TextAlign.left,
                                style: kWeatherCharacteristicsTextStyle,
                              ),
                              Text(
                                'Humidity: $humidity%',
                                textAlign: TextAlign.left,
                                style: kWeatherCharacteristicsTextStyle,
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 25.0,
                          ),
                          Column(
                            // mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Wind: $windSpeed mph',
                                textAlign: TextAlign.left,
                                style: kWeatherCharacteristicsTextStyle,
                              ),
                              Text(
                                'UV Index: $uvi',
                                textAlign: TextAlign.left,
                                style: kWeatherCharacteristicsTextStyle,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: FadeIn(
                      delay: 3.5,
                      child: generateForecastWidget(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget onBottom(Widget child) => Positioned.fill(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: child,
        ),
      );
}
