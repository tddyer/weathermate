import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:weathermate/services/location.dart';
import 'package:http/http.dart' as http;

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
    getLocation();
  }

  // accesses device location
  void getLocation() async {
    Location location = Location();

    await location.getCurrentLocation();

    latitude = location.latitude;
    longitude = location.longitude;

    getData();
  }

  // uses openweathermap api to get weather data
  void getData() async {
    http.Response response = await http.get(
      'https://api.openweathermap.org/data/2.5/weather?'
      'lat=$latitude&lon=$longitude&appid=$apiKey');
    
    if (response.statusCode == 200) {
      String data = response.body;
      var decoded = jsonDecode(data);
      
      double temp = decoded['main']['temp'];
      int condition = decoded['weather'][0]['id'];
      String city = decoded['name'];
      String weatherDesc = decoded['weather'][0]['description'];

      print('$temp, $condition, $city, $weatherDesc');
    } else {
      print(response.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    );
  }
}
