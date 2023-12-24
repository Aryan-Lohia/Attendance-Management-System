import 'dart:async';

import 'package:attendance_management/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 3),(){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home()));
    });
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 245, 224, 1),
      body: Center(child: Padding(
        padding: const EdgeInsets.all(100.0),
        child: Image.asset("assets/logo.png"),
      ),).animate().scale(
        duration: Duration(milliseconds: 600),
        curve: Curves.fastEaseInToSlowEaseOut,
        begin: Offset(5, 5),
        end: Offset(1, 1)
      ).then().shimmer(
        duration: Duration(seconds: 3,),
        colors: [Color.fromRGBO(20, 30, 70, 1),Colors.white,Color.fromRGBO(20, 30, 70, 1),Color.fromRGBO(20, 30, 70, 1)]
      ),
    );
  }
}
