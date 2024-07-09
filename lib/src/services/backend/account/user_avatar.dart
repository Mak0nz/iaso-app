import 'package:flutter/material.dart';
import 'dart:math' as math;

class InitialAvatar extends StatelessWidget {
  final String username;
  final double radius;

  // ignore: use_super_parameters
  const InitialAvatar({
    Key? key,
    required this.username,
    this.radius = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final backgroundColor = _getRandomColor();
    final textColor = _getContrastingTextColor(backgroundColor);

    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor,
      child: Text(
        _getInitial(),
        style: TextStyle(
          color:  textColor,
          fontWeight: FontWeight.bold,
          fontSize: radius * 1.25,
        ),
      ),
    );
  }

  String _getInitial() {
    return username.isNotEmpty ? username[0].toUpperCase() : '?';
  }

  Color _getRandomColor() {
    return Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
  }

  Color _getContrastingTextColor(Color backgroundColor) {
    // Calculate the perceived brightness of the background color
    double brightness = (backgroundColor.red * 299 +
                         backgroundColor.green * 587 +
                         backgroundColor.blue * 114) / 1000;

    // Use black text on light backgrounds and white text on dark backgrounds
    return brightness > 128 ? Colors.black : Colors.white;
  }

}