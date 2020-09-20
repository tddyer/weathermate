import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

// to be used with certain weather conditions (rain, snow, etc)

enum _BgColors { color1, color2 }

class AnimatedBackground extends StatelessWidget {

  AnimatedBackground({this.primaryColor, this.primaryShade, this.secondaryColor, this.secondaryShade});

  final Color primaryColor;
  final Color primaryShade;
  final Color secondaryColor;
  final Color secondaryShade;

  @override
  Widget build(BuildContext context) {
    final tween = MultiTween<_BgColors>()
      ..add(
          _BgColors.color1, primaryColor.tweenTo(primaryShade))
      ..add(_BgColors.color2, primaryColor.tweenTo(secondaryShade));

    return MirrorAnimation<MultiTweenValues<_BgColors>>(
      tween: tween,
      duration: 5.seconds,
      builder: (context, child, value) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [value.get(_BgColors.color1), value.get(_BgColors.color2)]
            )
          ),
        );
      },
    );
  }
}