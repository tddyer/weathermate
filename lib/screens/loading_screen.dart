import 'package:flutter/material.dart';
import 'weather_summary_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:weathermate/services/weather.dart';


class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {

  @override
  void initState() {
    super.initState();
    getLocationData();
  }

  // accesses device location + get weather data from OpenWeatherMap (OWM) api
  void getLocationData() async {

    // get weather data for current location
    var weatherData = await WeatherModel().getLocationWeather();    

    // transfer weather data to location screen
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return LocationScreen(locationWeather: weatherData);
    }));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitRipple(
          color: Colors.white,
          size: 100.0,
        ),
      ),
    );
  }
}
