import 'package:flutter/material.dart';
import 'dart:math';

class ShortElectricityMeterBusBarWidget extends StatelessWidget {
  final bool sensorStatus;
  final double value;
  final String nodeName;
  final String? color;
  final String? borderColor;
  final String? textColor;
  final double textSize;
  final double loadBoxHeight;
  final double loadBoxWidth;
  final VoidCallback onTap;
  final String unit;
  final String orientation;

  const ShortElectricityMeterBusBarWidget({
    super.key,
    required this.sensorStatus,
    required this.value,
    required this.nodeName,
    this.color,
    this.borderColor,
    this.textColor,
    required this.textSize,
    required this.loadBoxHeight,
    required this.loadBoxWidth,
    required this.onTap,
    required this.unit,
    required this.orientation,
  });

  Color hexToColor(String? hex, {bool isBorderOrText = false}) {
    if (hex == null || hex.isEmpty) {
      debugPrint('hexToColor: Input is null or empty, returning ${isBorderOrText ? "Colors.black" : "Colors.transparent"}');
      return isBorderOrText ? Colors.black : Colors.transparent;
    }
    hex = hex.replaceAll('#', '');
    try {
      return Color(int.parse('0xFF$hex'));
    } catch (e) {
      debugPrint('Invalid hex color: $hex, returning ${isBorderOrText ? "Colors.black" : "Colors.transparent"}');
      return isBorderOrText ? Colors.black : Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('MeterBusBarWidget: nodeName=$nodeName, orientation=$orientation, '
        'width=$loadBoxWidth, height=$loadBoxHeight, '
        'color=$color, borderColor=$borderColor, textColor=$textColor, textSize=$textSize');

    final isVertical = orientation.toLowerCase().trim() == 'vertical';
    final baseFontSize = textSize;
    final valueText = '${value.toStringAsFixed(2)} $unit';

    final adjustedFontSize = valueText.length > 15
        ? baseFontSize * 0.85
        : baseFontSize;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: loadBoxWidth,
        height: loadBoxHeight,
        decoration: BoxDecoration(
          color: hexToColor(color),
          border: Border.all(color: hexToColor(borderColor, isBorderOrText: true), width: 3),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: isVertical
                ? Transform.rotate(
              angle: -pi / 2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    nodeName,
                    style: TextStyle(
                      color: hexToColor(textColor, isBorderOrText: true),
                      fontSize: baseFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    valueText,
                    style: TextStyle(
                      color: hexToColor(textColor, isBorderOrText: true),
                      fontSize: adjustedFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
                : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  nodeName,
                  style: TextStyle(
                    color: hexToColor(textColor, isBorderOrText: true),
                    fontSize: baseFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  valueText,
                  style: TextStyle(
                    color: hexToColor(textColor, isBorderOrText: true),
                    fontSize: adjustedFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}