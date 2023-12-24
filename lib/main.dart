import 'package:attendance_management/home.dart';
import 'package:attendance_management/splash.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp( const MaterialApp(
    color: Colors.black,
    debugShowCheckedModeBanner: false,
    title: "Attendance Management",
    home: SplashPage(),
  ));
}