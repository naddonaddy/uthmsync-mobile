import 'package:flutter/material.dart';
import 'package:uthmsync5/screen/splash_screen.dart';
import 'package:uthmsync5/utils/responsive%20layout/responsive_layout.dart'; // Import your SplashScreen file

class TabletScaffold extends StatelessWidget {
  const TabletScaffold({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobileScaffold: SizedBox(), // Empty for mobile
      tabletScaffold: SplashScreen(), // Display SplashScreen for tablets
      desktopScaffold: SizedBox(), // Empty for desktops
    );
  }
}
