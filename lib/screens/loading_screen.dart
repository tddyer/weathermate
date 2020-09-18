import 'package:flutter/material.dart';
import 'package:weathermate/services/location.dart';
import 'package:weathermate/services/networking.dart';
import 'location_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

const apiKey = 'apiKey';

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
    // get device location
    Location location = Location();
    await location.getCurrentLocation();

    // tap into OWM api + retrieve weather data
    Networking weatherNetwork = Networking(url: 'https://api.openweathermap.org/data/2.5/weather?'
      'lat=${location.latitude}&lon=${location.longitude}&appid=$apiKey&units=imperial');

    var weatherData = await weatherNetwork.getData();

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
