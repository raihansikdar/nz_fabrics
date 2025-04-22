import 'package:flutter/material.dart';

class MeterBusBarWidget extends StatelessWidget {
  final bool sensorStatus;
  final double value;
  final String nodeName;
  final String borderColor;
  final Color textColor;
  final double loadBoxHeight;
  final double loadBoxWidth;
  final VoidCallback onTap;
  final String unit;

  const MeterBusBarWidget({
    super.key,
    required this.sensorStatus,
    required this.value,
    required this.nodeName,
    required this.borderColor,
    required this.textColor,
    required this.loadBoxHeight,
    required this.loadBoxWidth,
    required this.onTap,
    required this.unit,
  });


  Color hexToColor(String hex) {
    return Color(int.parse('0xFF${hex.replaceAll('#', '')}'));
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: loadBoxWidth,
        height: loadBoxHeight,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: hexToColor(borderColor), width: 3),
        ),
        child: Center(
          child: Text(
            '$nodeName\n${value.toStringAsFixed(2)} $unit',
            style: TextStyle(color: textColor, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}