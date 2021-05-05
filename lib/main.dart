import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:soul/screens/home_screen.dart';
import 'package:soul/screens/upload_screen.dart';
import 'screens/meditation_screen.dart';
import 'screens/player_screen.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MainScreen());
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentindex = 0;
  // bool isDarkMode = false;

  List tabs = [
    HomeScreen(),
    MeditationScreen(),
    UploadScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Color(0xFF0A305D),
          child: Icon(Icons.nightlight_round),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: tabs[currentindex],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF536976),
                Color(0xFF292E49),
              ],
              begin: Alignment.topLeft,
              end: Alignment.topRight,
              stops: [0.0, 0.8],
              tileMode: TileMode.clamp,
            ),
          ),
          child: AnimatedBottomNavigationBar(
            activeIndex: currentindex,
            icons: [
              Icons.home,
              Icons.mood_rounded,
              Icons.settings,
              Icons.low_priority,
            ],
            backgroundColor: Colors.transparent,
            activeColor: Colors.white,
            inactiveColor: Colors.white54,
            gapWidth: 77.0,
            iconSize: 30.0,
            gapLocation: GapLocation.center,
            notchSmoothness: NotchSmoothness.softEdge,
            notchMargin: 0.70,
            leftCornerRadius: 10,
            rightCornerRadius: 10,
            elevation: 25,
            height: 68.0,
            onTap: (index) {
              setState(() {
                currentindex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
