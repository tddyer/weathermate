import 'package:flutter/material.dart';
import 'package:weathermate/widgets/animated_background.dart';

const kTempTextStyle = TextStyle(
  fontFamily: 'Spartan MB',
  fontSize: 100.0,
);

const kMessageTextStyle = TextStyle(
  fontFamily: 'Spartan MB',
  fontSize: 60.0,
);

const kWeatherCharacteristicsTextStyle = TextStyle(
  fontFamily: 'Spartan MB',
  fontSize: 20.0,
);

const kButtonTextStyle = TextStyle(
  fontSize: 30.0,
  fontFamily: 'Spartan MB',
);

const kConditionTextStyle = TextStyle(
  fontSize: 100.0,
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


AnimatedBackground rainBackground = AnimatedBackground(
  primaryColor: Colors.grey[600],
  primaryShade: Colors.grey[700], 
  secondaryColor: Colors.blueGrey[600], 
  secondaryShade: Colors.blueGrey[700],
);

// TODO: checkout particle background for snow
AnimatedBackground snowBackground = AnimatedBackground(
  primaryColor: Colors.white60,
  primaryShade: Colors.white54, 
  secondaryColor: Colors.lightBlue[50], 
  secondaryShade: Colors.lightBlue[100],
);