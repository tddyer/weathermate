import 'package:flutter/material.dart';
import 'package:weathermate/services/location.dart';
import 'package:weathermate/services/networking.dart';

const apiKey = 'apiKey';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {

  double latitude;
  double longitude;

  @override
  void initState() {
    super.initState();
    getLocationData();
  }

  // accesses device location
  void getLocationData() async {
    Location location = Location();

    await location.getCurrentLocation();

    latitude = location.latitude;
    longitude = location.longitude;

    Networking weatherNetwork = Networking(url: 'https://api.openweathermap.org/data/2.5/weather?'
      'lat=$latitude&lon=$longitude&appid=$apiKey');

    var weatherData = await weatherNetwork.getData();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    );
  }
}
