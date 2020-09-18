import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:weathermate/services/location.dart';
import 'package:http/http.dart' as http;

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  // accesses device location
  void getLocation() async {
    Location location = Location();

    await location.getCurrentLocation();

    print(location.latitude);
    print(location.longitude);
  }

  // uses openweathermap api to get weather data
  void getData() async {
    http.Response response = await http.get(
      'https://samples.openweathermap.org/data/2.5/weather?'
      'lat=35&lon=139&appid=439d4b804bc8187953eb36d2a8c26a02');
    
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
    getData();
    return Scaffold(
    );
  }
}
