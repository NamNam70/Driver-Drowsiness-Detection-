import 'package:flutter/material.dart';
import 'package:untitled/screens/landingPage.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation; // Define _fadeAnimation as an instance variable

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    );

    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);

    // Start the animation when the page is built
    _animationController.forward();

    // Use Future.delayed to simulate a splash duration
    Future.delayed(Duration(seconds: 3), () {
      // Navigate to the desired page after the splash duration
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LandingPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF141436),
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // You can add an image or any other splash content here
              Image.asset("assets/logo1.png"),
              SizedBox(height: 16),
              SizedBox(
                width: 190, // Adjust the width as per your preference
                child: LinearProgressIndicator(
                  minHeight: 4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
