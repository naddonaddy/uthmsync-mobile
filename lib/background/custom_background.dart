import 'package:flutter/material.dart';

class CustomBackground extends StatelessWidget {
  final Widget
      child; // This will be the content placed on top of the background.

  const CustomBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF246ee9), // Use the desired color value
      ),
      child: SafeArea(
        top: false, // Disable top padding
        child: child,
      ),
    );
  }
}