import 'package:weathermate/widgets/animated_background.dart';
import 'package:weathermate/widgets/update_location_popup.dart';
import 'package:weathermate/utilities/backgrounds.dart';
import 'package:weathermate/widgets/animated_wave.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:weathermate/utilities/constants.dart';
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

  ListView forecastListView;
  AnimatedBackground background;
  List<Map> hourlyForecastData;
  int temp, humidity, feelsLike, windSpeed, uvi;
  String weatherIcon;
  String city;
  String formattedDate;

  @override
  void initState() {
    super.initState();

    // populate weather data upon creation of screen
    updateUI(widget.locationWeather);
  }

  void updateForecastData(dynamic weatherData) {
      for (int i = 0; i < 24; i++) {
        Map hourly = {};
        DateTime rawDt = DateTime.fromMillisecondsSinceEpoch(1000 * weatherData['hourly'][i]['dt']);

        if (i == 0)
          formattedDate = DateTimeFormat.format(rawDt, format: AmericanDateFormats.dayOfWeekShortWithComma).toString();
        
        hourly['time'] = DateTimeFormat.format(rawDt, format: 'g A').toString();
        hourly['temp'] = weatherData['hourly'][i]['temp'].toInt();
        hourly['humidity'] = weatherData['hourly'][i]['humidity'];
        hourly['pop'] = (weatherData['hourly'][i]['pop'] * 100).round();
        hourly['feels_like'] = weatherData['hourly'][i]['feels_like'].round();
        hourly['wind_speed'] = weatherData['hourly'][i]['wind_speed'].round();
        hourly['cloud_coverage'] = weatherData['hourly'][i]['clouds'];
        hourly['condition'] = weatherData['hourly'][i]['weather'][0]['id'];
        hourly['icon'] = weather.getWeatherIcon(hourly['condition']);
        hourlyForecastData.add(hourly);
      }
  }

  // clears out old forecast data and creates new forecast cards
  Widget generateForecastListView() {
    List<Widget> forecastCards = [];
    for (int i = 0; i < hourlyForecastData.length; i++) {
      forecastCards.add(Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Text(
                      "${hourlyForecastData[i]['time']}",
                      style: kForecastTimeTextStyle,
                    ),
                    // Text(
                    //   "${hourlyForecastData[i]['icon']}",
                    //   style: kForecastConditionTextStyle,
                    // ),
                    Text(
                      "${hourlyForecastData[i]['temp']}°",
                      textAlign: TextAlign.left,
                      style: kForecastTextStyle,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Feels like: ${hourlyForecastData[i]['feels_like']}°",
                      style: kWeatherCharacteristicsTextStyle,
                    ),
                    Text(
                      "Humidity: ${hourlyForecastData[i]['humidity']}%",
                      style: kWeatherCharacteristicsTextStyle,
                    ),
                    Text(
                      "Wind speed: ${hourlyForecastData[i]['wind_speed']} mph",
                      style: kWeatherCharacteristicsTextStyle,
                    ),
                    Text(
                      "Cloud coverage: ${hourlyForecastData[i]['cloud_coverage']}%",
                      textAlign: TextAlign.left,
                      style: kWeatherCharacteristicsTextStyle,
                    ),
                    Text(
                      "Precipitation chance: ${hourlyForecastData[i]['pop']}%",
                      style: kWeatherCharacteristicsTextStyle,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: Divider(
              color: Colors.grey[500],
              height: 5,
              thickness: 1,
            ),
          )
        ],
      ));
      // forecastCards.add(SizedBox(width: 15.0));
    }

    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: forecastCards.length,
      itemBuilder: (context, ind) {
        return forecastCards[ind];
      },
    );
  }

  // taps into the retrieved weather data to access desired weather characteristics
  void updateUI(dynamic weatherData) {
    setState(() {
      if (weatherData == null) { // TODO: make this better by adding popup error message instead
        temp = 0;
        weatherIcon = 'Error';
        city = '';
        return;
      }
         
      // refreshing weather local variabless
      city = weatherData['cityName'];
      temp = weatherData['current']['temp'].toInt();
      humidity = weatherData['current']['humidity'].toInt();
      feelsLike = weatherData['current']['feels_like'].toInt();
      windSpeed = weatherData['current']['wind_speed'].toInt();
      uvi = weatherData['current']['uvi'].toInt();
      weatherIcon = weather.getWeatherIcon(weatherData['current']['weather'][0]['id']);

      // updating background based on temp
      if (temp < 32) {
        background = snowBackground;
      } else {
        background = rainBackground;
      }

      // emptying any old forecast data before repopulating to avoid newly fetched
      // forecast data getting appended to the old forecast data
      hourlyForecastData = [];
      updateForecastData(weatherData);   
      forecastListView = generateForecastListView();
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
                    Expanded( // section 1: city + date
                      flex: 1,
                      child: Container(
                        // color: Colors.red,
                        height: MediaQuery.of(context).size.height,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              FadeIn(
                                delay: 1.0, 
                                child: Text(
                                  '$city',
                                  style: kCityTitleTextStyle,
                                ),
                              ),
                              FadeIn(
                                delay: 1.0, 
                                child: Text(
                                  '$formattedDate',
                                  style: kDateTextStyle,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded( // section 2: temperature + weather characterstics
                      flex: 3,
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        // color: Colors.blue,
                        child: Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
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
                              FadeIn(
                                delay: 3.0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
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
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded( // section 3: forecast
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: forecastListView,
                      )
                    ),
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
