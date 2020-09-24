import 'package:flutter/material.dart';

const accentColor =  Colors.blueGrey;

const daysOfWeek = {
  1: 'Monday',
  2: 'Tuesday',
  3: 'Wednesday',
  4: 'Thursday',
  5: 'Friday',
  6: 'Saturday',
  7: 'Sunday',
};

const months = {
  1: 'January',
  2: 'February',
  3: 'March',
  4: 'April',
  5: 'May',
  6: 'June',
  7: 'July',
  8: 'August',
  9: 'September',
  10: 'October',
  11: 'November',
  12: 'December',
};

const kTempTextStyle = TextStyle(
  fontFamily: 'Montserrat',
  fontSize: 100.0,
);

const kCityTitleTextStyle = TextStyle(
  fontSize: 30,
  fontFamily: 'Montserrat',
);

const kDateTextStyle = TextStyle(
  fontSize: 16,
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
