import 'package:flutter/material.dart';

class CustomTransitionAnimations {
  static Widget slideTransitionLeft(Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return SlideTransition(
      position: new Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(animation),
      child: new SlideTransition(
        position: new Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(0.0, 0.0),
        ).animate(secondaryAnimation),
        child: child,
      ),
    );
  }

  static Widget slideTransitionRight(Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return SlideTransition(
      position: new Tween<Offset>(
        begin: const Offset(-1.0, 0.0),
        end: Offset.zero,
      ).animate(animation),
      child: new SlideTransition(
        position: new Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(0.0, 0.0),
        ).animate(secondaryAnimation),
        child: child,
      ),
    );
  }

  static Widget slideTransitionUp(Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return SlideTransition(
      position: new Tween<Offset>(
        begin: const Offset(0.0, 1.0),
        end: Offset.zero,
      ).animate(animation),
      child: new SlideTransition(
        position: new Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(0.0, 0.0),
        ).animate(secondaryAnimation),
        child: child,
      ),
    );
  }

  static Widget slideTransitionDown(Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return SlideTransition(
      position: new Tween<Offset>(
        begin: const Offset(0.0, -1.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut)),
      child: new SlideTransition(
        position: new Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(0.0, 0.0),
        ).animate(secondaryAnimation),
        child: child,
      ),
    );
  }

  static Widget scaleTransition(Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return ScaleTransition(
      scale: Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.fastOutSlowIn,
        ),
      ),
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }

  static Widget rotationTransition(Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return RotationTransition(
      turns: Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.linear,
        ),
      ),
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );

  }

}