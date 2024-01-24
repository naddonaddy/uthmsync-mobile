import 'package:flutter/material.dart';
import 'package:uthmsync5/screen/splash_screen.dart';
import 'package:uthmsync5/utils/responsive%20layout/responsive_layout.dart'; // Import your SplashScreen file

class DesktopScaffold extends StatelessWidget {
  const DesktopScaffold({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobileScaffold: SizedBox(), // Empty for mobile
      tabletScaffold: SizedBox(), // Empty for tablets
      desktopScaffold: SplashScreen(), // Display SplashScreen for desktops
    );
  }
}
