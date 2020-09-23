import 'package:weathermate/widgets/update_location_popup.dart';
import 'package:weathermate/utilities/backgrounds.dart';
import 'package:weathermate/widgets/animated_wave.dart';
import 'package:weathermate/utilities/constants.dart';
import 'package:weathermate/widgets/side_drawer.dart';
import 'package:weathermate/services/weather.dart';
import 'package:weathermate/widgets/fade_in.dart';
import 'package:flutter/material.dart';
import 'dart:math';


class LocationScreen extends StatefulWidget {

  LocationScreen({this.locationWeather});

  final locationWeather;

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {

  WeatherModel weather = WeatherModel();

  List<Map> upcomingHours = []; // contains hourly forecast data for next 24 hours
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
            style: kForecastTimeTextStyle,
          ),
          SizedBox(height: 10.0),
          Text(
            "${upcomingHours[i]['icon']}",
            style: kForecastConditionTextStyle,
          ),
          SizedBox(height: 10.0),
          Text(
            "${upcomingHours[i]['temp']}°",
            textAlign: TextAlign.left,
            style: kForecastTextStyle,
          ),
        ],
      ));
      forecastCards.add(SizedBox(width: 15.0));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: forecastCards,
        mainAxisAlignment: MainAxisAlignment.center,
      ),
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

      // TODO: Check if there's an easier way to convert timestamps
      for (int i = 0; i < 24; i++) {
        Map hourly = {};
        hourly['time'] = weatherData['hourly'][i]['dt'];
        hourly['time'] = DateTime.fromMillisecondsSinceEpoch(1000 * hourly['time']); // converting timestamp -> DateTime
        hourly['time'] = '${hourly['time'].hour}';
        if (int.parse(hourly['time']) > 12) {
          hourly['time'] = (int.parse(hourly['time']) % 12).toString() + " PM";
        } else if (int.parse(hourly['time']) == 12) {
          hourly['time'] = "${hourly['time']} PM";
        } else if (int.parse(hourly['time']) == 0) {
          hourly['time'] = "12 AM";
        } else {
          hourly['time'] = "${hourly['time']} AM";
        }
        
        hourly['temp'] = weatherData['hourly'][i]['temp'].toInt();
        hourly['condition'] = weatherData['hourly'][i]['weather'][0]['id'];
        hourly['icon'] = weather.getWeatherIcon(hourly['condition']);
        upcomingHours.add(hourly);
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          FlatButton( // Update location button
            onPressed: () async {
              var inputCity = await updateLocationPopup(context);
              if (inputCity != null) {
                print(inputCity);
                var weatherData = await weather.getCityWeather(inputCity);
                updateUI(weatherData);
              }
            },
            child: Icon(
              Icons.location_on,
              size: 30.0,
            ),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      drawer: SideDrawer(),
      body: Container(
        //constraints: BoxConstraints.expand(),
        //child: SafeArea(
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
                  // TODO: implement pull down for refresh location
                  // Padding( // top navigation buttons
                  //   padding: const EdgeInsets.only(top: 20.0),
                    
                  //   // child: Row(
                  //   //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   //   children: <Widget>[
                  //       // FlatButton(
                  //       //   onPressed: () async {
                  //       //     var weatherData = await weather.getLocationWeather();
                  //       //     updateUI(weatherData);
                  //       //   },
                  //       //   child: Icon(
                  //       //     Icons.near_me,
                  //       //     size: 50.0,
                  //       //   ),
                  //       // ),
                      // ],
                    // ),
                  // ),
                  Padding(
                    padding: EdgeInsets.only(top: 100.0),
                    child: FadeIn(
                      delay: 1.0, 
                      child: Text(
                        '$city',
                        style: kCityTitleTextStyle,
                      ),
                    ),
                  ),
                  // TODO: add date here
                  Padding(
                    padding: const EdgeInsets.only(top: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                  Padding( // TODO: Consider adding precipitatin amounts, chances, etc (+ in forecast)
                    padding: EdgeInsets.only(top: 50.0, bottom: 10.0),
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
                    padding: const EdgeInsets.only(top: 50.0, left: 35.0, right: 35.0),
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
      // ),
    );
  }

  Widget onBottom(Widget child) => Positioned.fill(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: child,
        ),
      );
}
