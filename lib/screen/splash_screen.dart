import 'dart:async';
import 'package:flutter/material.dart';
import 'package:uthmsync5/background/custom_background.dart';
import 'package:uthmsync5/screen/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _progressValue = 0.0;

  @override
  void initState() {
    super.initState();

    // Simulate loading by incrementing progress over time
    const duration = Duration(seconds: 1);
    Timer.periodic(duration, (Timer timer) {
      if (_progressValue < 1.0) {
        setState(() {
          _progressValue += 0.75; // Increase progress by 75%
          _progressValue = _progressValue.clamp(0.0, 1.0); // Clamp the value to a maximum of 1.0
        });
      } else {
        // When loading is complete, navigate to the login page
        timer.cancel();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Login()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomBackground(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/UTHMSynclogo.png'),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0), // Add padding here
              child: SizedBox(
                height: 16, // Set the desired height of the progress bar
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8), // Set the border radius
                  child: LinearProgressIndicator(
                    value: _progressValue,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.green), // Set the color to green
                    backgroundColor: Colors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '${(_progressValue * 100).toInt()}%', // Display percentage
              style: const TextStyle(color: Colors.green, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}