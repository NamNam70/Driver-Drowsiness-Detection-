import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LandingPage extends StatelessWidget {
  static const TextStyle goldCoinWhiteStyle = TextStyle(
    color: Colors.white,
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    fontFamily: "LexendDeca",
  );

  static const TextStyle greyStyle = TextStyle(
    fontSize: 40.0,
    color: Colors.grey,
    fontFamily: "LexendDeca",
  );

  static const TextStyle descriptionGreyStyle = TextStyle(
    color: Colors.grey,
    fontSize: 20.0,
    fontFamily: "LexendDeca",
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          color: Color(0xFF141436),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: [
                        /*CircleAvatar(
                          backgroundImage: AssetImage("assets/logo1.png"),
                        ),*/
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Image.asset(
                            "assets/logo1.png", // Replace with your image asset
                            width: 85,
                            height: 90,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 50.0,
                      height: 50.0,
                      child: FloatingActionButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Confirmation"),
                                content: Text(
                                    "Make sure you have a good light source to get the best results."),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text("Cancel"),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                    },
                                  ),
                                  TextButton(
                                    child: Text("OK"),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                      Navigator.pushNamed(context,
                                          '/detection'); // Navigate to detection page
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        backgroundColor: Colors.transparent,
                        child: Icon(
                          Icons.arrow_right_alt,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Lottie.asset(
                  "assets/lottie/face-scan.json",
                  width: 300,
                  fit: BoxFit.fill,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Driver \nDetection",
                      style: greyStyle,
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      'A step towards safe driving',
                      style: descriptionGreyStyle,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
