import 'package:weathermate/widgets/update_location_popup.dart';
import 'package:weathermate/utilities/backgrounds.dart';
import 'package:weathermate/widgets/animated_wave.dart';
import 'package:weathermate/utilities/constants.dart';
import 'package:weathermate/widgets/side_drawer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:weathermate/widgets/on_bottom.dart';
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

  final RefreshController _refreshController = RefreshController();

  WeatherModel weather = WeatherModel();

  Widget forecast;

  List<Map> upcomingHours; // contains hourly forecast data for next 24 hours
  int temp, humidity, feelsLike, windSpeed, uvi;
  String weatherMessage;
  String weatherIcon;
  String city;
  String date;

  @override
  void initState() {
    super.initState();
    // retrieve weather data upon creation of screen
    updateUI(widget.locationWeather);
  }

  void updateForecastData(dynamic weatherData) {
    // TODO: Check if there's an easier way to convert timestamps
      for (int i = 0; i < 24; i++) {
        Map hourly = {};
        hourly['time'] = weatherData['hourly'][i]['dt'];
        hourly['time'] = DateTime.fromMillisecondsSinceEpoch(1000 * hourly['time']); // converting timestamp -> DateTime

        if (i == 0) 
          date = "${daysOfWeek[hourly['time'].weekday]}, ${months[hourly['time'].month]} ${hourly['time'].day.toString()}";


        if (hourly['time'].hour > 12) {
          hourly['time'] = (hourly['time'].hour % 12).toString() + " PM";
        } else if (hourly['time'].hour == 12) {
          hourly['time'] = "${hourly['time'].hour} PM";
        } else if (hourly['time'].hour == 0) {
          hourly['time'] = "12 AM";
        } else {
          hourly['time'] = "${hourly['time'].hour} AM";
        }
        
        hourly['temp'] = weatherData['hourly'][i]['temp'].toInt();
        hourly['condition'] = weatherData['hourly'][i]['weather'][0]['id'];
        hourly['icon'] = weather.getWeatherIcon(hourly['condition']);
        upcomingHours.add(hourly);
      }
  }

  // clears out old forecast data and creates new forecast cards, returning them in a Scroll View
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

    return Expanded(
      child: Container(
        padding: const EdgeInsets.only(top: 40.0, left: 25.0, right: 25.0),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: forecastCards.length,
          itemBuilder: (context, ind) {
            return forecastCards[ind];
          },
        ),
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

      // emptying any old forecast data before repopulating
      upcomingHours = [];

      updateForecastData(weatherData);

      temp = weatherData['current']['temp'].toInt();
      humidity = weatherData['current']['humidity'].toInt();
      feelsLike = weatherData['current']['feels_like'].toInt();
      windSpeed = weatherData['current']['wind_speed'].toInt();
      uvi = weatherData['current']['uvi'].toInt();

      weatherMessage = weather.getMessage(temp);

      var condition = weatherData['current']['weather'][0]['id'];
      weatherIcon = weather.getWeatherIcon(condition);
      forecast = generateForecastWidget();
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
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      drawer: SideDrawer(),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: () async {
          var weatherData = await weather.getLocationWeather();
          updateUI(weatherData);
          _refreshController.refreshCompleted();
        },
        child: Container(
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
              SafeArea (
                child: Column( // main weather content section
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 40.0),
                      child: FadeIn(
                        delay: 1.0, 
                        child: Text(
                          '$city',
                          style: kCityTitleTextStyle,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5.0),
                      child: FadeIn(
                        delay: 1.0, 
                        child: Text(
                          '$date',
                          style: kDateTextStyle,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
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
                    forecast,
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 50.0, left: 35.0, right: 35.0, bottom: 20.0),
                    //   child: FadeIn(
                    //     delay: 3.5,
                    //     child: forecast,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
