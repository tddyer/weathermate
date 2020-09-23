import 'package:flutter/material.dart';

const kTempTextStyle = TextStyle(
  fontFamily: 'Montserrat',
  fontSize: 100.0,
);

const kCityTitleTextStyle = TextStyle(
  fontSize: 30,
  fontFamily: 'Montserrat',
);

const kWeatherCharacteristicsTextStyle = TextStyle(
  fontFamily: 'Montserrat',
  fontSize: 18.0,
);

const kButtonTextStyle = TextStyle(
  fontSize: 30.0,
  fontFamily: 'Montserrat',
);

const kConditionTextStyle = TextStyle(
  fontSize: 100.0,
);

const kForecastTextStyle = TextStyle(
  // fontFamily: 'Spartan MB',
  fontSize: 20.0,
);

const kForecastTimeTextStyle = TextStyle(
  fontFamily: 'Montserrat',
  fontSize: 20.0,
);

const kForecastConditionTextStyle = TextStyle(
  fontSize: 50.0,
);

const kTextFieldInputDecoration =  InputDecoration(
  filled: true,
  fillColor: Colors.white,
  icon: Icon(
    Icons.location_city,
    color: Colors.white,
  ),
  hintText: 'Enter city name',
  hintStyle: TextStyle(
    color: Colors.grey,
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(10)
    ),
    borderSide: BorderSide.none,
  ),
);
