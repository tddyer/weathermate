import 'package:flutter/material.dart';
import 'package:weathermate/widgets/animated_background.dart';

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