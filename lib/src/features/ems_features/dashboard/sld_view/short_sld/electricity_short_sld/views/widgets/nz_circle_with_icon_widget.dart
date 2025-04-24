import 'dart:developer';
import 'package:flutter/material.dart';

class CircleWithIcon extends StatelessWidget {
  final double value;
  final IconData icon;
  final String text;
  final double width;
  final double height;
  final VoidCallback onTap;
  final String unit;
  final bool sensorStatus;
  final String borderColor;

  const CircleWithIcon({
    required this.value,
    required this.icon,
    required this.text,
    required this.width,
    required this.height,
    required this.onTap,
    required this.unit,
    required this.sensorStatus,
    required this.borderColor,
    super.key,
  });


  Color hexToColor(String hex) {
    return Color(int.parse('0xFF${hex.replaceAll('#', '')}'));
  }




  @override
  Widget build(BuildContext context) {
    double diameter = width < height ? width : height;
    double iconSize = 0.2 * diameter;
    double fontSize = 0.135 * diameter;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: hexToColor(borderColor), width: 2.5),
          // Explicitly remove any shadow
          boxShadow: [],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // FaIcon(
              //   icon,
              //   size: iconSize,
              //   color: hexToColor(borderColor),
              // ),
              // const SizedBox(height: 4),
              Text(
                '${value.toStringAsFixed(2)} $unit',
                style: TextStyle(
                  fontSize: fontSize,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                text,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color:Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
