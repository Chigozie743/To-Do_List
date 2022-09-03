// ignore_for_file: prefer_const_constructo
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import "package:todo/View/Screens/home_screen.dart";

import 'View/Screens/welcome_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter ToDo List',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        // scaffoldBackgroundColor: Colors.white,
      ),
      home: WelcomeScreen(),
    );
  }
}
