import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {

  GradientBackground({this.primaryColor, this.secondaryColor});

  final Color primaryColor;
  final Color secondaryColor;
  
  // creating MultiTween object that describes animations
  @override
  Widget build(BuildContext context) {     
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [primaryColor, secondaryColor]
        ),
      ),
    );
  }
}