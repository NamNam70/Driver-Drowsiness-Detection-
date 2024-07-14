import 'package:flutter/material.dart';
import 'package:untitled/screens/SplashScreenPage.dart';
import 'package:untitled/screens/dashboard/face_detection_camera.dart';
import 'package:untitled/screens/landingPage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: "LexendDeca",
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreenPage(),
        '/LandingPage': (context) => LandingPage(),
        '/detection': (context) => FaceDetectionFromLiveCamera(),
      },
    );
  }
}