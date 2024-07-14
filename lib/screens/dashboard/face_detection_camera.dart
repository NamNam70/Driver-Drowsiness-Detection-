import 'dart:async';
import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:tflite/tflite.dart';

import './boundary_box.dart';

class FaceDetectionFromLiveCamera extends StatefulWidget {
  @override
  _FaceDetectionFromLiveCameraState createState() =>
      _FaceDetectionFromLiveCameraState();
}

class _FaceDetectionFromLiveCameraState
    extends State<FaceDetectionFromLiveCamera> {
  bool _loading = false;

  List<CameraDescription> _availableCameras = [];
  late CameraController cameraController;
  bool isDetecting = false;
  List<dynamic> _recognitions = [];
  int closedEyesCount = 0;
  int openEyesCount = 0;

  bool alarmPlaying = false;

  int _imageHeight = 0;
  int _imageWidth = 0;
  bool front = true;

  static const TextStyle goldCoinWhiteStyle = TextStyle(
      color: Colors.white,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      fontFamily: "LexendDeca");

  @override
  void initState() {
    super.initState();
    _loading = true;
    alarmPlaying = false;

    loadModel();
    _getAvailableCameras();
    setState(() {
      _loading = false;
    });
  }

  @override
  void dispose() {
    FlutterRingtonePlayer.stop();
    cameraController?.dispose();
    super.dispose();
  }

  Future<void> _getAvailableCameras() async {
    WidgetsFlutterBinding.ensureInitialized();
    _availableCameras = await availableCameras();
    _initializeCamera(_availableCameras[1]);
  }

  void loadModel() async {
    await Tflite.loadModel(
      model: "assets/model_unquant_drow.tflite",
      labels: "assets/label.txt",
    );
  }

  Future<void> _initializeCamera(CameraDescription description) async {
    cameraController = CameraController(description, ResolutionPreset.high);
    try {
      await cameraController.initialize().then(
            (_) {
          if (!mounted) {
            return;
          }
          cameraController.startImageStream(
                (CameraImage img) {
              if (!isDetecting) {
                isDetecting = true;
                Tflite.runModelOnFrame(
                  bytesList: img.planes.map(
                        (plane) {
                      return plane.bytes;
                    },
                  ).toList(),
                  threshold: 0.5,
                  rotation: 0,
                  imageHeight: img.height,
                  imageWidth: img.width,
                  numResults: 1,
                ).then(
                      (recognitions) {
                    setRecognitions(recognitions, img.height, img.width);
                    isDetecting = false;
                  },
                );
              }
            },
          );
        },
      );
      setState(() {});
    } catch (e) {
      print(e);
    }
  }
/*
  void _toggleCameraLens() {
    // get current lens direction (front / rear)
    final lensDirection = cameraController.description.lensDirection;
    CameraDescription newDescription;
    if (lensDirection == CameraLensDirection.front) {
      newDescription = _availableCameras.firstWhere((description) =>
          description.lensDirection == CameraLensDirection.back);
    } else {
      newDescription = _availableCameras.firstWhere((description) =>
          description.lensDirection == CameraLensDirection.front);
    }

    if (newDescription != null) {
      _initializeCamera(newDescription);
    } else {
      print('Asked camera not available');
    }
  }*/

  void setRecognitions(recognitions, imageHeight, imageWidth) {
    setState(() {
      _recognitions = recognitions;
      if (_recognitions != null && _recognitions.isNotEmpty) {
        String label = _recognitions[0]['label'];

        if (label == '0 Closed') {
          openEyesCount = 0;
          closedEyesCount++;
        } else if (label == '1 Open') {
          FlutterRingtonePlayer.stop();
          openEyesCount++;
          closedEyesCount = 0;
        }

        if (closedEyesCount >= 3 && !alarmPlaying) {
          playAlarm();
        } else if (openEyesCount >= 3 && alarmPlaying) {
          stopAlarm();
        }
      }
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });
  }

  void stopAlarm() {
    FlutterRingtonePlayer.stop();
    setState(() {
      closedEyesCount = 0;
      openEyesCount = 0;
      alarmPlaying = false;
    });
  }

  void playAlarm() {
    setState(() {
      closedEyesCount = 0;
      openEyesCount = 0;
      alarmPlaying = true;
    });

    FlutterRingtonePlayer.play(
      android: AndroidSounds.alarm,
      ios: IosSounds.glass,
      looping: true,
    );
    // Add a 12-second delay before stopping the alarm
    Future.delayed(Duration(seconds: 12), () {
      stopAlarm();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return _loading
        ? Container(
      color: Color(0xFF141436),
      alignment: Alignment.center,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      ),
    )
        : Container(
      constraints: const BoxConstraints.expand(),
      child: cameraController == null
          ? Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      )
          : Scaffold(
        /*floatingActionButton: FloatingActionButton(
                backgroundColor: Color(0xFF141436),
                onPressed: () {
                  front == true ? front = false : front = true;
                  _toggleCameraLens();
                },
                child: Icon(
                    front == true ? Icons.camera_rear : Icons.camera_front),
              ),*/
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text("Tracker", style: goldCoinWhiteStyle),
          centerTitle: true,
          backgroundColor: Color(0xFF141436),
          leading: InkWell(
            child: Icon(Icons.arrow_back),
            onTap: () {
              Navigator.pop(
                  context); // Navigate back to the previous page
            },
          ),
        ),
        body: Stack(
          children: [
            Center(
              child: AspectRatio(
                aspectRatio: 1 / cameraController.value.aspectRatio,
                child: CameraPreview(cameraController),
              ),
            ),
            BoundaryBox(
                _recognitions == null ? [] : _recognitions,
                math.max(_imageHeight, _imageWidth),
                math.min(_imageHeight, _imageWidth),
                screen.height,
                screen.width),
          ],
        ),
      ),
    );
  }
}
