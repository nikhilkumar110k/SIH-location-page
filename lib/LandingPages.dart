import 'package:flutter/material.dart';
import 'dart:async';

import 'package:sih_spot_sync/Login.dart';
import 'package:sih_spot_sync/loginandsigninredirector.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller!, curve: Curves.easeOut),
    );

    _controller!.forward();

    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => LoginandSignPage()),
      );
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ScaleTransition(
          scale: _scaleAnimation!,
          child: Image.asset(
            'images/spot_1.png',
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ),
    );
  }
}
