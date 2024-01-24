import 'package:flutter/material.dart';

class DiagonalLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white // Color of the lines
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0; // Width of the lines

    final path = Path()
      ..moveTo(0, 0) // Start from the top-left corner
      ..lineTo(size.width, size.height); // Draw a diagonal line to the bottom-right corner

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}