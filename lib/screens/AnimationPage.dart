import 'package:flutter/material.dart';
import 'package:lit_starfield/lit_starfield.dart';

class AnimationPage extends StatefulWidget {
  @override
  _AnimationPageState createState() => _AnimationPageState();
}

class _AnimationPageState extends State<AnimationPage>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          LitStarfieldContainer(
            animated: true,
            number: 500,
            velocity: 0.85,
            depth: 0.9,
            scale: 4,
            starColor: Colors.amber,
            backgroundDecoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF031936),
                  Color(0xFF141334),
                  Color(0xFF284059),
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
          ),
          SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 100.0),
                  child: Center(
                    child: Image(
                      image: AssetImage('assets/logo1.png'),
                    ),
                  ),
                ),
                SizedBox(
                  height: 0.1,
                ),

                Padding(
                  padding: const EdgeInsets.all(24.0), // Adjust the padding as needed
                  child: Text(
                    "All of your data is secure and is in safe hands. Rest assured",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 390,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/detection');
                  },
                  child: Container(
                    height: 50,
                    width: 330,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey[600],
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.blueGrey),
                    ),
                    child: Center(
                      child: Text(
                        "Open Camera",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
