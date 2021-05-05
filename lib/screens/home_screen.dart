import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:soul/screens/meditation_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentindex = 0;

  List tabs = [
    HomeScreen(),
    MeditationScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Hello Peta Dada')),
      backgroundColor: Colors.white,
    );
  }
}
