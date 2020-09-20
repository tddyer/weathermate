import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

// features you want to animate
enum AniProps {opacity, translateX}

class FadeIn extends StatelessWidget {
  
  FadeIn({@required this.child, @required this.delay});

  final double delay;
  final Widget child;
  
  // creating MultiTween object that describes animations
  @override
  Widget build(BuildContext context) {
    final tween = MultiTween<AniProps>()
    ..add(AniProps.opacity, 0.0.tweenTo(1.0), 500.milliseconds)
    ..add(AniProps.translateX, 130.0.tweenTo(0.0), 500.milliseconds, Curves.easeOut);

    // using CustomAnimation to performs animations
    return CustomAnimation(
      delay:  ((300 * delay).round()).milliseconds,
      duration: tween.duration,
      tween: tween,
      child: child,
      builder: (context, child, animation) => Opacity(
            opacity: animation.get(AniProps.opacity),
            child: Transform.translate(
                offset: Offset(animation.get(AniProps.translateX), 0), child: child),
          ),
    );
  }
}