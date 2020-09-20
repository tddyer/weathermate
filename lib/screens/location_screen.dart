import 'package:flutter/material.dart';
import 'package:weathermate/services/weather.dart';
import 'package:weathermate/utilities/constants.dart';
import 'package:weathermate/widgets/fade_in.dart';
import 'city_screen.dart';
import 'package:weathermate/widgets/gradient_background.dart';
import 'package:weathermate/widgets/animated_background.dart';
import 'package:weathermate/widgets/animated_wave.dart';
import 'dart:math';
import 'package:weathermate/utilities/constants.dart';


// TODO: add forecast data

class LocationScreen extends StatefulWidget {

  LocationScreen({this.locationWeather});

  final locationWeather;

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {

  WeatherModel weather = WeatherModel();

  int temp;
  String weatherMessage;
  String weatherIcon;
  String city;

  @override
  void initState() {
    super.initState();
    
    // retrieve weather data upon creation of screen
    updateUI(widget.locationWeather);
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
      city = weatherData['name'];

      temp = weatherData['main']['temp'].toInt();
      weatherMessage = weather.getMessage(temp);

      var condition = weatherData['weather'][0]['id'];
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
                child: rainBackground,
              ),
              onBottom(
                AnimatedWave(
                  height: 180,
                  speed: 1.0,
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
                    padding: const EdgeInsets.only(top: 10.0),
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
                  FadeIn(
                    delay: 3.0,
                    child: Padding(
                      padding: EdgeInsets.only(right: 15.0, bottom: 15.0),
                      child: Text(
                        '$weatherMessage in $city',
                        textAlign: TextAlign.right,
                        style: kMessageTextStyle,
                      ),
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


