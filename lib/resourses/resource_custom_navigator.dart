import 'package:flutter/material.dart';
import 'custom_transition_animations.dart';
class CustomNavigator{

  static push(BuildContext context, newRoute, Function selectedAnimation) {
    final pageRoute = PageRouteBuilder(
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
        return newRoute;
      },
      transitionDuration: Duration(milliseconds: 400),
      transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
        return selectedAnimation(animation, secondaryAnimation, child);
      },
    );

    Navigator.of(context, rootNavigator: true).push(pageRoute);
  }

  static showPlayer(BuildContext context, newRoute) {
    final pageRoute = PageRouteBuilder(
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
        return newRoute;
      },
      transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
        return child;
      },
    );

    //Navigator.of(context).pushAndRemoveUntil(pageRoute, ModalRoute.withName('/HomePage'));
    Navigator.of(context, rootNavigator: true).push(pageRoute);
  }

  static pushAndRemoveUntil(BuildContext context, newRoute) {
    final pageRoute = PageRouteBuilder(
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
        return newRoute;
      },
      transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
        return CustomTransitionAnimations.slideTransitionLeft(animation, secondaryAnimation, child);
      },
    );

    Navigator.of(context).pushAndRemoveUntil(pageRoute, ModalRoute.withName('/'));
  }
}