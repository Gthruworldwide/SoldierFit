import 'package:flutter/material.dart';

class MotionSystem {
  // Durations
  static const fast = Duration(milliseconds: 180);
  static const medium = Duration(milliseconds: 350);
  static const slow = Duration(milliseconds: 700);
  static const extraSlow = Duration(milliseconds: 1200);
  
  // Curves
  static const curve = Curves.easeOutCubic;
  static const curveIn = Curves.easeInCubic;
  static const curveElastic = Curves.elasticOut;
  static const curveBounce = Curves.bounceOut;
  
  // Animation Values
  static const double scaleSmall = 0.95;
  static const double scaleLarge = 1.05;
  static const double scaleExplosion = 1.6;
  
  static const double opacityHidden = 0.0;
  static const double opacityVisible = 1.0;
  static const double opacityFaded = 0.6;
}

class PageTransitions {
  static Widget slideTransition(Widget child, Animation<double> animation) {
    const begin = Offset(1.0, 0.0);
    const end = Offset.zero;
    const curve = MotionSystem.curve;
    
    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
    var offsetAnimation = animation.drive(tween);
    
    return SlideTransition(
      position: offsetAnimation,
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }
  
  static Widget fadeTransition(Widget child, Animation<double> animation) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
  
  static Widget scaleTransition(Widget child, Animation<double> animation) {
    return ScaleTransition(
      scale: animation,
      child: child,
    );
  }
}
