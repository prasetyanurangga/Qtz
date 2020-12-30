import 'package:flutter/material.dart';
import 'package:Qtz/constant.dart';
import 'package:Qtz/screens/home_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  AnimationController fadeController;
  Animation<double> animation;

  final Shader linearGradient = LinearGradient(
    colors: <Color>[Color(0xffDA44bb), Color(0xff8921aa)],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  @override
  void initState() {
    super.initState();
    fadeController = AnimationController(duration: const Duration(seconds: 1), vsync: this);
    animation = CurvedAnimation(parent: fadeController, curve: Curves.easeIn);animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setPermission();
      }
    });
    fadeController.forward();
  }

  Future<void> setPermission() async {
    if (!await Permission.storage.isGranted) {
      print("belum di acc");
      if (await Permission.storage.request().isGranted) {
        goToNextPage();
      }
      else{
        exit(0);
      }
    }
    else{
      goToNextPage();
    }
    
  }

  void goToNextPage(){
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => HomePage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      )
    );
  }

  @override
  void dispose() {
    super.dispose();
    fadeController.dispose();
  }

  Future<bool> _willPopCallback() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        backgroundColor: colorBackground,
        body: FadeTransition(
          opacity: animation,
          child: Center(
            child: Column(
              children:[
                Spacer(),
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: colorGradientSecondary,
                  ).createShader(
                    Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                  ),
                  child: Text(
                    "QtZ", 
                    style: Theme.of(context).textTheme.headline2.copyWith(
                      color: Colors.white, 
                      fontWeight: FontWeight.w300,
                    )
                  ),
                ),
                Spacer(),
              ]
            ),
          ),
        ),
      ), 
      onWillPop: _willPopCallback
    );
  }
}


