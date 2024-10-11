import 'package:flutter/material.dart';

class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Layer 1 - Background Curve
    Paint paintFill = Paint()
      ..color = const Color.fromARGB(255, 16, 104, 187) // Blue color
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(size.width * 0.75, 0, size.width, 0); // Top horizontal line
    path.lineTo(size.width, size.height); // Right side down
    path.lineTo(0, size.height); // Bottom side left
    path.lineTo(0, size.height * 0.75); // Left side up
    path.quadraticBezierTo(
        size.width * 0.3, size.height * 0.6, 0, size.height * 0.5); // Curve

    path.close();

    canvas.drawPath(path, paintFill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
