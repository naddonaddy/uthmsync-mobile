import 'package:flutter/material.dart';
import 'package:uthmsync5/screen/splash_screen.dart';
import 'package:uthmsync5/utils/responsive%20layout/responsive_layout.dart'; // Import your SplashScreen file

class MobileScaffold extends StatelessWidget {
  const MobileScaffold({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobileScaffold: SplashScreen(), // Display SplashScreen for mobile
      tabletScaffold: SizedBox(), // Empty for tablets
      desktopScaffold: SizedBox(), // Empty for desktops
    );
  }
}
